require "BWOVehicles"
require "BWORoutes"
require "BWODebug"

-- Server-side "road traffic" implementation for MP.
-- Spawns real BaseVehicles and moves them along BWORoutes on the server (authoritative -> synced to all clients).

BWOTraffic = BWOTraffic or {}
BWOTraffic.Enabled = BWOTraffic.Enabled or false
BWOTraffic.Tab = BWOTraffic.Tab or {} -- key: vehicleId -> state

-- Tuning knobs (debug-friendly / safe defaults)
BWOTraffic.Config = BWOTraffic.Config or {
    -- speed scale: route point speed `s` (from BWORoutes) is mapped to "tiles/sec" by (s / SpeedDivisor)
    SpeedDivisor = 55,
    -- acceleration/deceleration in tiles/sec^2
    Accel = 0.90,
    Decel = 1.40,
    -- when close to point (tiles), advance to next route point
    PointRadius = 1.75,
    -- cap dt to avoid jumps after server lag spikes
    -- NOTE: when server time source is coarse (os.time), dt may be ~1s; don't clamp too hard or vehicles won't move.
    MaxDt = 1.0,
    -- server debug spam throttle
    Debug = false,
}

local floor, min, max, sqrt, atan2, deg = math.floor, math.min, math.max, math.sqrt, math.atan2, math.deg

local function nowMs()
    if getTimestampMs then
        return getTimestampMs()
    end
    return os.time() * 1000
end

local function normalizeYaw(yaw)
    -- normalize to (-180..180]
    yaw = yaw % 360
    if yaw > 180 then yaw = yaw - 360 end
    return yaw
end

local function dirFromRot(rotDeg)
    rotDeg = (tonumber(rotDeg) or 0) % 360
    if rotDeg >= 315 or rotDeg < 45 then
        return IsoDirections.S
    elseif rotDeg >= 45 and rotDeg < 135 then
        return IsoDirections.E
    elseif rotDeg >= 135 and rotDeg < 225 then
        return IsoDirections.N
    else
        return IsoDirections.W
    end
end

local function getVehicleById(id)
    if id == nil then return nil end
    local cell = getCell()
    if not cell then return nil end
    local list = cell:getVehicles()
    if not list then return nil end
    for i = 0, list:size() - 1 do
        local v = list:get(i)
        if v and v:getId() == id then
            return v
        end
    end
    return nil
end

local function ensureState(vehicleId, routeId)
    local s = BWOTraffic.Tab[vehicleId]
    if not s then
        s = {
            id = vehicleId,
            routeId = routeId,
            routeIndex = 1,
            speed = 0,
        }
        BWOTraffic.Tab[vehicleId] = s
    end
    if routeId ~= nil then
        s.routeId = routeId
    end
    if not s.routeIndex then s.routeIndex = 1 end
    if not s.speed then s.speed = 0 end
    return s
end

function BWOTraffic.Count()
    local c = 0
    for _, _ in pairs(BWOTraffic.Tab) do c = c + 1 end
    return c
end

function BWOTraffic.Clear()
    if not isServer() then return end
    for vid, _ in pairs(BWOTraffic.Tab) do
        local v = getVehicleById(vid)
        if v and v.permanentlyRemove then
            v:permanentlyRemove()
        end
    end
    BWOTraffic.Tab = {}
    dprint(string.format("[BWOTraffic] cleared"), 2)
end

function BWOTraffic.Stop()
    if not isServer() then return end
    BWOTraffic.Enabled = false
    dprint(string.format("[BWOTraffic] stop (freeze)"), 2)
end

function BWOTraffic.Start()
    if not isServer() then return end
    BWOTraffic.Enabled = true
    dprint(string.format("[BWOTraffic] start"), 2)
end

function BWOTraffic.SetDebug(on)
    if not isServer() then return end
    BWOTraffic.Config = BWOTraffic.Config or {}
    BWOTraffic.Config.Debug = on and true or false
    dprint(string.format("[BWOTraffic] debug=%s", tostring(BWOTraffic.Config.Debug)), 2)
end

function BWOTraffic.Dump(maxItems)
    maxItems = tonumber(maxItems) or 12
    if maxItems < 1 then maxItems = 1 end
    if maxItems > 50 then maxItems = 50 end

    local lines = {}
    table.insert(lines, string.format("BWOTraffic: enabled=%s count=%d", tostring(BWOTraffic.Enabled), BWOTraffic.Count()))

    local i = 0
    for vid, st in pairs(BWOTraffic.Tab) do
        i = i + 1
        local v = getVehicleById(vid)
        if v then
            table.insert(lines, string.format(
                "#%d id=%d route=%s idx=%s speed=%.2f pos=(%.1f,%.1f,%d)",
                i, vid, tostring(st.routeId), tostring(st.routeIndex), tonumber(st.speed) or 0,
                v:getX(), v:getY(), v:getZ() or 0
            ))
        else
            table.insert(lines, string.format(
                "#%d id=%d route=%s idx=%s speed=%.2f pos=(missing)",
                i, vid, tostring(st.routeId), tostring(st.routeIndex), tonumber(st.speed) or 0
            ))
        end

        if i >= maxItems then
            break
        end
    end

    if BWOTraffic.Count() > maxItems then
        table.insert(lines, string.format("(truncated, showing %d of %d)", maxItems, BWOTraffic.Count()))
    end

    return lines
end

function BWOTraffic.Spawn(routeId, vtype)
    if not isServer() then return nil end

    routeId = tonumber(routeId)
    local routes = BWORoutes and BWORoutes.routes or nil
    local route = routes and routeId and routes[routeId] or nil
    if not (route and route.start and route.points) then
        dprint(string.format("[BWOTraffic][ERR] Spawn: bad routeId=%s", tostring(routeId)), 1)
        return nil
    end

    local start = route.start
    local x = tonumber(start.x)
    local y = tonumber(start.y)
    if not x or not y then
        dprint(string.format("[BWOTraffic][ERR] Spawn: bad start coords routeId=%s", tostring(routeId)), 1)
        return nil
    end

    local dir = dirFromRot(start.rot)
    local btype = vtype
    if not btype then
        btype = BWOVehicles and BWOVehicles.carChoices and BWOVehicles.carChoices[1 + ZombRand(#BWOVehicles.carChoices)] or "Base.CarNormal"
        btype = (BWOCompatibility and BWOCompatibility.GetCarType and BWOCompatibility.GetCarType(btype)) or btype
    end

    local vehicle = BWOVehicles and BWOVehicles.VehicleSpawn and BWOVehicles.VehicleSpawn(x, y, dir, btype) or nil
    if not vehicle then
        print(string.format("[BWOTraffic][ERR] Spawn failed (maybe square not loaded) routeId=%s type=%s @(%s,%s)", tostring(routeId), tostring(btype), tostring(x), tostring(y)))
        return nil
    end

    -- We are going to move this vehicle manually (teleport-style). Keep physics disabled so the physics engine
    -- doesn't "snap" it back or fight our setX/setY updates.
    if vehicle.setPhysicsActive then
        pcall(function() vehicle:setPhysicsActive(false) end)
    end

    -- Tag for debugging/cleanup
    local md = vehicle:getModData()
    md.BWO = md.BWO or {}
    md.BWO.traffic = { routeId = routeId, created = nowMs() }

    ensureState(vehicle:getId(), routeId)

    print(string.format("[BWOTraffic] spawned id=%d routeId=%d type=%s @(%d,%d)", vehicle:getId(), routeId, tostring(btype), floor(x), floor(y)))
    return vehicle
end

local function bestPointIndex(route, px, py)
    if not (route and route.points and px and py) then return 1 end
    local bestI = 1
    local bestD2 = nil
    for i, p in ipairs(route.points) do
        local dx = (tonumber(p.x) or 0) - px
        local dy = (tonumber(p.y) or 0) - py
        local d2 = dx * dx + dy * dy
        if (bestD2 == nil) or (d2 < bestD2) then
            bestD2 = d2
            bestI = i
        end
    end
    return bestI
end

function BWOTraffic.SpawnNearPlayer(player, routeId, vtype)
    if not isServer() then return nil end
    if not player then return nil end

    routeId = tonumber(routeId)
    local routes = BWORoutes and BWORoutes.routes or nil
    local route = routes and routeId and routes[routeId] or nil
    if not (route and route.points and #route.points > 0) then
        print(string.format("[BWOTraffic][ERR] SpawnNearPlayer: bad routeId=%s", tostring(routeId)))
        return nil
    end

    local px = tonumber(player:getX() or 0)
    local py = tonumber(player:getY() or 0)
    local idx = bestPointIndex(route, px, py)

    local p = route.points[idx]
    local pNext = route.points[idx + 1] or route.points[1]
    local ang = 0
    if pNext then
        ang = atan2((tonumber(pNext.y) or py) - (tonumber(p.y) or py), (tonumber(pNext.x) or px) - (tonumber(p.x) or px))
    end
    local yaw = normalizeYaw(90 + deg(ang))
    local dir = dirFromRot(yaw)

    local btype = vtype
    if not btype then
        btype = BWOVehicles and BWOVehicles.carChoices and BWOVehicles.carChoices[1 + ZombRand(#BWOVehicles.carChoices)] or "Base.CarNormal"
        btype = (BWOCompatibility and BWOCompatibility.GetCarType and BWOCompatibility.GetCarType(btype)) or btype
    end

    local vehicle = BWOVehicles and BWOVehicles.VehicleSpawn and BWOVehicles.VehicleSpawn(p.x, p.y, dir, btype) or nil
    if not vehicle then
        print(string.format("[BWOTraffic][ERR] SpawnNearPlayer failed routeId=%s idx=%s type=%s", tostring(routeId), tostring(idx), tostring(btype)))
        return nil
    end

    if vehicle.setPhysicsActive then
        pcall(function() vehicle:setPhysicsActive(false) end)
    end

    local st = ensureState(vehicle:getId(), routeId)
    st.routeIndex = idx
    st.speed = 0

    -- Align exactly to direction of route
    vehicle:setAngles(0, yaw, 0)

    local md = vehicle:getModData()
    md.BWO = md.BWO or {}
    md.BWO.traffic = { routeId = routeId, created = nowMs(), nearPlayer = true }

    print(string.format("[BWOTraffic] spawned near player id=%d routeId=%d idx=%d type=%s @(%d,%d)",
        vehicle:getId(), routeId, idx, tostring(btype), floor(vehicle:getX()), floor(vehicle:getY())))

    return vehicle
end

function BWOTraffic.SpawnN(count, routeId, player)
    if not isServer() then return end
    count = tonumber(count) or 1
    if count < 1 then count = 1 end
    if count > 40 then count = 40 end

    local routes = BWORoutes and BWORoutes.routes or {}
    local routeIds = {}
    for rid, _ in pairs(routes) do
        table.insert(routeIds, rid)
    end
    table.sort(routeIds)
    if #routeIds == 0 then
        dprint("[BWOTraffic][ERR] SpawnN: no routes", 1)
        return
    end

    for i = 1, count do
        local rid = routeId and tonumber(routeId) or routeIds[1 + ZombRand(#routeIds)]
        if player and BWOTraffic.SpawnNearPlayer then
            BWOTraffic.SpawnNearPlayer(player, rid, nil)
        else
            BWOTraffic.Spawn(rid, nil)
        end
    end
end

local function tickOne(state, dt)
    local v = getVehicleById(state.id)
    if not v then
        BWOTraffic.Tab[state.id] = nil
        return
    end

    local routes = BWORoutes and BWORoutes.routes or nil
    local route = routes and state.routeId and routes[state.routeId] or nil
    if not (route and route.points) then
        BWOTraffic.Tab[state.id] = nil
        return
    end

    local idx = tonumber(state.routeIndex) or 1
    local point = route.points[idx]
    if not point then
        idx = 1
        point = route.points[idx]
        if not point then
            BWOTraffic.Tab[state.id] = nil
            return
        end
    end

    local x = v:getX()
    local y = v:getY()
    local tx = (tonumber(point.x) or x) + 0.5
    local ty = (tonumber(point.y) or y) + 0.5

    local dx = tx - x
    local dy = ty - y
    local dist = sqrt(dx * dx + dy * dy)

    -- Advance route point when close enough.
    if dist <= BWOTraffic.Config.PointRadius then
        idx = idx + 1
        if idx > #route.points then idx = 1 end
        state.routeIndex = idx
        point = route.points[idx]
        tx = (tonumber(point.x) or x) + 0.5
        ty = (tonumber(point.y) or y) + 0.5
        dx = tx - x
        dy = ty - y
        dist = sqrt(dx * dx + dy * dy)
    end

    if dist < 0.001 then
        return
    end

    local ang = atan2(dy, dx) -- 0 rad = east, +pi/2 = north
    local yaw = normalizeYaw(90 + deg(ang))

    -- Speed target (tiles/sec) from route point.
    local spdKmh = tonumber(point.s) or 30
    local target = max(0.10, spdKmh / (BWOTraffic.Config.SpeedDivisor or 55))

    -- Simple accel/decel towards target.
    local speed = tonumber(state.speed) or 0
    if speed < target then
        speed = min(target, speed + (BWOTraffic.Config.Accel or 0.9) * dt)
    elseif speed > target then
        speed = max(target, speed - (BWOTraffic.Config.Decel or 1.4) * dt)
    end
    state.speed = speed

    local step = min(dist, speed * dt)
    local nx = x + (dx / dist) * step
    local ny = y + (dy / dist) * step

    -- Skip updates into completely unloaded squares (avoid nil squares & weird teleports).
    local cell = getCell()
    local sq = cell and cell:getGridSquare(floor(nx), floor(ny), 0) or nil
    if not sq then
        -- keep it, but don't move when not loaded; will resume later.
        return
    end

    -- Ensure we're in manual move mode.
    if v.setPhysicsActive then
        pcall(function() v:setPhysicsActive(false) end)
    end

    local bx, by = x, y

    v:setX(nx)
    v:setY(ny)
    v:setZ(0)
    v:setAngles(0, yaw, 0)

    -- Verify that the engine accepted the move (some builds ignore vehicle:setX/Y during MP).
    local ax = v:getX()
    local ay = v:getY()
    if (math.abs(ax - bx) < 0.0001) and (math.abs(ay - by) < 0.0001) then
        state._dbgNoMove = (state._dbgNoMove or 0) + 1
        if state._dbgNoMove <= 5 then
            print(string.format("[BWOTraffic][WARN] setX/setY had no effect id=%d before=(%.3f,%.3f) target=(%.3f,%.3f) after=(%.3f,%.3f)",
                state.id, bx, by, nx, ny, ax, ay))
        end
        return
    end

    -- One-time proof that the server tick is actually moving vehicles.
    if not state._dbgMoved then
        state._dbgMoved = true
        print(string.format("[BWOTraffic][MOVE] id=%d route=%s idx=%s speed=%.2f -> (%.2f,%.2f)",
            state.id, tostring(state.routeId), tostring(state.routeIndex), tonumber(state.speed) or 0, nx, ny))
    end

    -- Best effort network sync (depends on build).
    if v.transmitPosition then
        pcall(function() v:transmitPosition() end)
    end
    if v.transmit then
        pcall(function() v:transmit() end)
    end
end

local function onTick(ticks)
    if not isServer() then return end
    if not BWOTraffic.Enabled then return end
    if BWOTraffic.Count() == 0 then return end

    -- Prefer in-game time delta: stable across different server tick rates and doesn't depend on real timers.
    -- getWorldAgeHours() exists on PZ builds where Mods/Events exist; fall back to ms clock if needed.
    local dt = 0.05
    local gt = getGameTime and getGameTime() or nil
    local ageH = gt and gt.getWorldAgeHours and gt:getWorldAgeHours() or nil
    if ageH then
        BWOTraffic._lastAgeH = BWOTraffic._lastAgeH or ageH
        local dH = ageH - BWOTraffic._lastAgeH
        if dH < 0 then dH = 0 end
        BWOTraffic._lastAgeH = ageH
        dt = dH * 3600.0 -- convert hours -> seconds
        if dt <= 0 then dt = 0.05 end
    else
        BWOTraffic._lastMs = BWOTraffic._lastMs or nowMs()
        local now = nowMs()
        dt = (now - BWOTraffic._lastMs) / 1000.0
        if dt <= 0 then
            dt = 0.05
        else
            BWOTraffic._lastMs = now
        end
    end

    -- Clamp dt to keep movement stable and visible.
    dt = max(dt, 0.05)
    dt = min(dt, BWOTraffic.Config.MaxDt or 1.0)

    for _, state in pairs(BWOTraffic.Tab) do
        tickOne(state, dt)
    end

    -- Optional debug heartbeat
    if BWOTraffic.Config.Debug then
        BWOTraffic._dbgLast = BWOTraffic._dbgLast or 0
        if (now - BWOTraffic._dbgLast) > 2000 then
            BWOTraffic._dbgLast = now
            dprint(string.format("[BWOTraffic][DBG] tick dt=%.3f count=%d", dt, BWOTraffic.Count()), 3)
        end
    end
end

Events.OnTick.Remove(onTick)
Events.OnTick.Add(onTick)

dprint("[BWOTraffic] OnTick hook installed", 3)

-- Optional: only hook EveryOneSecond if the event exists in this game build.
-- Some builds don't expose it; OnTick + game-time-delta above is enough.
if Events and Events.EveryOneSecond then
    local function onEveryOneSecond()
        if not isServer() then return end
        if not BWOTraffic.Enabled then return end
        if BWOTraffic.Count() == 0 then return end

        for _, state in pairs(BWOTraffic.Tab) do
            tickOne(state, 1.0)
        end

        BWOTraffic._hb = (BWOTraffic._hb or 0) + 1
        if BWOTraffic._hb % 5 == 0 then
            print(string.format("[BWOTraffic][HB] enabled=%s count=%d", tostring(BWOTraffic.Enabled), BWOTraffic.Count()))
        end
    end

    Events.EveryOneSecond.Remove(onEveryOneSecond)
    Events.EveryOneSecond.Add(onEveryOneSecond)
else
    -- Heartbeat via tick counter (approx; keeps logs readable).
    local function hbOnTick()
        if not isServer() then return end
        if not BWOTraffic.Enabled then return end
        BWOTraffic._hbTick = (BWOTraffic._hbTick or 0) + 1
        if BWOTraffic._hbTick % 300 == 0 then
            print(string.format("[BWOTraffic][HB] enabled=%s count=%d", tostring(BWOTraffic.Enabled), BWOTraffic.Count()))
        end
    end
    Events.OnTick.Remove(hbOnTick)
    Events.OnTick.Add(hbOnTick)
end

dprint("[BWOTraffic] loaded (server)", 3)


