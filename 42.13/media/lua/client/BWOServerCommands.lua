BWOServerCommands = BWOServerCommands or {}
BWOServerCommands.Commands = BWOServerCommands.Commands or {}
BWOServerCommands.Events = BWOServerCommands.Events or {}

BWOServerCommands.Events.Ping = function(args)
    print ("PING received from server for player " .. tostring(args.pid))
end

BWOServerCommands.ZombieRemove = function(args)
    -- Backwards compatible: old payload only had zid.
    BWOServerCommands.ZombieRemoveAt(args)
end

-- BanditsWeekOneMP: server may broadcast "Commands.BanditRemove" to clients.
-- Treat it as a zombie removal and also clear Bandits client caches if present.
BWOServerCommands.BanditRemove = function(args)
    if type(args) ~= "table" then return end

    local zid = args.zid or args.id
    if zid == nil then return end

    -- Reuse robust removal helper (supports optional x/y/z).
    BWOServerCommands.ZombieRemoveAt({
        zid = zid,
        x = args.x,
        y = args.y,
        z = args.z
    })

    -- Make sure Bandits caches don't keep stale references.
    if BanditZombie then
        if BanditZombie.Cache then BanditZombie.Cache[zid] = nil end
        if BanditZombie.CacheLight then BanditZombie.CacheLight[zid] = nil end
        if BanditZombie.CacheLightB then BanditZombie.CacheLightB[zid] = nil end
        if BanditZombie.CacheLightZ then BanditZombie.CacheLightZ[zid] = nil end
    end
end

-- Robust removal helper: remove nearest zombie to coords (preferred) or by id match (fallback).
BWOServerCommands.ZombieRemoveAt = function(args)
    if type(args) ~= "table" then return end

    local function asNumber(v)
        if v == nil then return nil end
        if type(v) == "number" then return v end
        local n = tonumber(v)
        if n ~= nil then return n end
        return tonumber(tostring(v))
    end

    local zidStr = args.zid ~= nil and tostring(args.zid) or nil
    local tx = asNumber(args.x)
    local ty = asNumber(args.y)
    local tz = asNumber(args.z)

    local cell = getCell()
    local list = cell and cell:getZombieList() or nil
    if not list then return end

    local best = nil
    local bestD2 = nil

    -- Prefer coordinate match when available (works even if id mapping differs across client/server).
    if tx and ty and tz then
        for i = 0, list:size() - 1 do
            local z = list:get(i)
            if z then
                local dx = z:getX() - tx
                local dy = z:getY() - ty
                local dz = (z:getZ() or 0) - tz
                local d2 = (dx * dx + dy * dy) + (dz * dz * 4)
                if (bestD2 == nil) or (d2 < bestD2) then
                    bestD2 = d2
                    best = z
                end
            end
        end

        -- Require reasonably close match to avoid deleting wrong zombie.
        if best and bestD2 and bestD2 <= 9.25 then
            best:removeFromWorld()
            best:removeFromSquare()
            return
        end
    end

    -- Fallback by id via Bandits helpers if present.
    if zidStr then
        -- Try Bandits cache first (banditized entities)
        if BanditZombie and BanditZombie.GetInstanceById then
            local z = BanditZombie.GetInstanceById(args.zid)
            if z then
                z:removeFromWorld()
                z:removeFromSquare()
                return
            end
        end

        for i = 0, list:size() - 1 do
            local z = list:get(i)
            if z then
                local id = nil
                if BanditUtils and BanditUtils.GetZombieID then
                    id = BanditUtils.GetZombieID(z)
                end
                local pid = (z.getPersistentOutfitID and z:getPersistentOutfitID()) or nil
                local cid = (BanditUtils and BanditUtils.GetCharacterID and BanditUtils.GetCharacterID(z)) or nil

                if (id ~= nil and tostring(id) == zidStr) or
                   (pid ~= nil and tostring(pid) == zidStr) or
                   (cid ~= nil and tostring(cid) == zidStr) then
                    z:removeFromWorld()
                    z:removeFromSquare()
                    return
                end
            end
        end
    end
end

BWOServerCommands.ForceRemoveResult = function(args)
    local p = getPlayer()
    if not p or not p.addLineChatElement then return end
    if args.ok then
        p:addLineChatElement("ForceRemove OK: " .. tostring(args.zid) .. " bandit=" .. tostring(args.isBandit), 0.2, 1.0, 0.2)
    else
        local extra = ""
        if args.x ~= nil and args.y ~= nil then
            extra = extra .. " @(" .. tostring(args.x) .. "," .. tostring(args.y) .. "," .. tostring(args.z) .. ")"
        end
        if args.listSize ~= nil then
            extra = extra .. " list=" .. tostring(args.listSize)
        end
        p:addLineChatElement("ForceRemove FAIL: " .. tostring(args.zid) .. " (" .. tostring(args.reason) .. ")" .. extra, 1.0, 0.3, 0.3)
    end
end

-- Server uses this to tweak freshly spawned service vehicles (lightbar/siren/alarm/headlights).
-- Without a client handler, commands are ignored and emergency vehicles appear "silent".
BWOServerCommands.UpdateVehicle = function(args)
    if type(args) ~= "table" then return end

    local id = tonumber(args.id)
    if not id then return end

    local cell = getCell()
    if not cell then return end

    local list = cell:getVehicles()
    if not list then return end

    local veh = nil
    for i = 0, list:size() - 1 do
        local v = list:get(i)
        if v and v:getId() == id then
            veh = v
            break
        end
    end
    if not veh then return end

    if args.headlights ~= nil and veh.hasHeadlights and veh:hasHeadlights() then
        veh:setHeadlightsOn(args.headlights and true or false)
    end

    if args.lightbar ~= nil and veh.hasLightbar and veh:hasLightbar() then
        veh:setLightbarLightsMode(tonumber(args.lightbar) or 0)
    end

    if args.siren ~= nil and veh.hasLightbar and veh:hasLightbar() then
        if veh.setLightbarSirenMode then
            veh:setLightbarSirenMode(tonumber(args.siren) or 0)
        end
    end

    if args.alarm ~= nil and veh.hasAlarm and veh:hasAlarm() then
        if args.alarm then
            veh:setAlarmed(true)
            if veh.triggerAlarm then
                veh:triggerAlarm()
            end
        else
            veh:setAlarmed(false)
        end
    end
end

local onServerCommand = function(module, command, args)
    -- Server sends removal notifications using module "Commands".
    if module == "Commands" and BWOServerCommands[command] then
        if type(args) ~= "table" then args = {} end
        BWOServerCommands[command](args)
    elseif module == "Events" and BWOServerCommands.Events and BWOServerCommands.Events[command] then
        if type(args) ~= "table" then args = {} end
        BWOServerCommands.Events[command](args)
    end
end

Events.OnServerCommand.Remove(onServerCommand)
Events.OnServerCommand.Add(onServerCommand)


