-- BWODebugOverhead.lua
-- Simple overhead debug text for zombies/bandits: shows Bandit flag, clan, program, and a few brain states.
-- Toggle with F9 by default.

if isServer() then return end

BWODebugOverhead = BWODebugOverhead or {}
BWODebugOverhead.enabled = BWODebugOverhead.enabled or false
-- Show both zombies and bandits by default (user request). Set to true to display only bandits.
BWODebugOverhead.onlyBandits = BWODebugOverhead.onlyBandits ~= nil and BWODebugOverhead.onlyBandits or false
BWODebugOverhead.maxDist = BWODebugOverhead.maxDist or 25
BWODebugOverhead.keyToggle = BWODebugOverhead.keyToggle or (Keyboard and Keyboard.KEY_F9 or 67) -- fallback
BWODebugOverhead.keyForceRemove = BWODebugOverhead.keyForceRemove or (Keyboard and Keyboard.KEY_F10 or 68) -- fallback
BWODebugOverhead._lastNearest = BWODebugOverhead._lastNearest or nil

local function boolStr(v)
    return v and "true" or "false"
end

local function safeToString(v)
    if v == nil then return "nil" end
    return tostring(v)
end

local function shortenCid(cid)
    cid = tostring(cid or "")
    if #cid <= 8 then return cid end
    return cid:sub(1, 8) .. "…"
end

local function getClanName(cid)
    if not cid then return nil end
    if BanditCustom and BanditCustom.ClanGet then
        local c = BanditCustom.ClanGet(cid)
        if c and c.general and c.general.name and c.general.name ~= "" then
            return c.general.name
        end
    end
    return "CID:" .. shortenCid(cid)
end

local function getProgramText(brain)
    if not brain or not brain.program then return nil end
    local p = brain.program
    local name = p.name or p.program or nil
    if not name then return nil end
    local stage = p.stage and tostring(p.stage) or nil
    if stage then
        return tostring(name) .. ":" .. stage
    end
    return tostring(name)
end

local function getTaskText(brain)
    if not brain or not brain.tasks or (type(brain.tasks) ~= "table") then return nil end
    local t1 = brain.tasks[1]
    if not t1 then return nil end
    local a = t1.action or t1.type or nil
    if not a then return nil end
    return tostring(a)
end

local function resolveInstance(light)
    if not light then return nil end
    if light._instance then return light._instance end
    if light.id and BanditZombie and BanditZombie.GetInstanceById then
        return BanditZombie.GetInstanceById(light.id)
    end
    return nil
end

local function worldToScreen(playerNum, x, y, z)
    if not IsoUtils then return nil, nil end

    local sx = IsoUtils.XToScreen(x, y, z, 0)
    local sy = IsoUtils.YToScreen(x, y, z, 0)

    if IsoCamera and IsoCamera.getOffX then sx = sx - IsoCamera.getOffX() end
    if IsoCamera and IsoCamera.getOffY then sy = sy - IsoCamera.getOffY() end

    if getPlayerScreenLeft then sx = sx - getPlayerScreenLeft(playerNum) end
    if getPlayerScreenTop then sy = sy - getPlayerScreenTop(playerNum) end

    return sx, sy
end

local function drawLinesAtWorld(playerNum, x, y, z, lines, color)
    if not lines or #lines == 0 then return end

    local sx, sy = worldToScreen(playerNum, x, y, z)
    if not sx or not sy then return end

    local w, h = getCore():getScreenWidth(), getCore():getScreenHeight()
    if sx < -200 or sy < -200 or sx > w + 200 or sy > h + 200 then return end

    local tm = getTextManager()
    if not tm then return end

    local font = UIFont.Small
    local r = (color and color.r) or 1
    local g = (color and color.g) or 1
    local b = (color and color.b) or 1
    local a = (color and color.a) or 1

    -- Move text above head.
    local y0 = sy - 70
    for i = 1, #lines do
        local line = lines[i]
        if line and line ~= "" then
            local tw = tm:MeasureStringX(font, line)
            tm:DrawString(font, sx - (tw / 2), y0 - ((i - 1) * 12), line, r, g, b, a)
        end
    end
end

local function buildLines(isBandit, brain, light)
    local lines = {}

    if light and light.id ~= nil then
        table.insert(lines, "id: " .. safeToString(light.id))
    end

    if isBandit then
        table.insert(lines, "BANDIT")
    else
        table.insert(lines, "ZOMBIE")
    end

    -- Entity flags from instance (helps debug "unremovable" entities)
    local inst = resolveInstance(light)
    if inst then
        -- Basic lifecycle flags
        if inst.isAlive then table.insert(lines, "alive: " .. boolStr(inst:isAlive())) end
        if inst.isFakeDead then table.insert(lines, "fakeDead: " .. boolStr(inst:isFakeDead())) end
        if inst.isReanimatedPlayer then table.insert(lines, "reanimPlayer: " .. boolStr(inst:isReanimatedPlayer())) end
        if inst.isRagdoll then table.insert(lines, "ragdoll: " .. boolStr(inst:isRagdoll())) end

        -- Bandit classification hints
        table.insert(lines, "varBandit: " .. boolStr(inst:getVariableBoolean("Bandit")))

        local md = inst.getModData and inst:getModData() or nil
        if md and md.brainId ~= nil then
            table.insert(lines, "mod.brainId: " .. safeToString(md.brainId))
        end

        if inst.getOutfitName then
            local o = inst:getOutfitName()
            if o then table.insert(lines, "outfit: " .. safeToString(o)) end
        end
        if inst.getPersistentOutfitID then
            local poid = inst:getPersistentOutfitID()
            if poid then table.insert(lines, "poid: " .. safeToString(poid)) end
        end
    end

    if brain then
        local clanName = getClanName(brain.cid or brain.clan)
        if clanName then
            table.insert(lines, "clan: " .. clanName)
        end

        local prog = getProgramText(brain)
        if prog then
            table.insert(lines, "prog: " .. prog)
        end

        local task = getTaskText(brain)
        if task then
            table.insert(lines, "task: " .. task .. " (" .. safeToString(#(brain.tasks or {})) .. ")")
        end

        -- a few boolean-ish state flags used by Bandits AI
        local hostile = brain.hostile ~= nil and ("hostile: " .. boolStr(brain.hostile)) or nil
        local hostileP = brain.hostileP ~= nil and ("hostileP: " .. boolStr(brain.hostileP)) or nil
        if hostile then table.insert(lines, hostile) end
        if hostileP then table.insert(lines, hostileP) end

        if brain.sleeping ~= nil then table.insert(lines, "sleeping: " .. boolStr(brain.sleeping)) end
        if brain.stationary ~= nil then table.insert(lines, "stationary: " .. boolStr(brain.stationary)) end
        if brain.moving ~= nil then table.insert(lines, "moving: " .. boolStr(brain.moving)) end
        if brain.aim ~= nil then table.insert(lines, "aim: " .. boolStr(brain.aim)) end
        if brain.aiming ~= nil then table.insert(lines, "aiming: " .. boolStr(brain.aiming)) end

        if brain.infection ~= nil then table.insert(lines, "infection: " .. safeToString(brain.infection)) end
        if brain.endurance ~= nil then table.insert(lines, "endurance: " .. safeToString(brain.endurance)) end

        if brain.master ~= nil then table.insert(lines, "master: " .. safeToString(brain.master)) end
        if brain.permanent ~= nil then table.insert(lines, "permanent: " .. boolStr(brain.permanent)) end
        if brain.key ~= nil then table.insert(lines, "key: " .. safeToString(brain.key)) end
    end

    if light and light.rid then
        table.insert(lines, "room: " .. safeToString(light.rid))
    end

    -- BWOMP.Queue is used by WeekOneMP as a "keep list" for zombies (and should NOT mean 'bandit').
    local q = (BWOGMD and BWOGMD.data and BWOGMD.data.Queue) or nil
    if q and light and light.id and q[light.id] ~= nil then
        table.insert(lines, "keep(queue): " .. safeToString(q[light.id]))
    end

    return lines
end

local function iterZombiesNearPlayer(player, maxDist)
    -- Prefer Bandits client cache if present (fast). Fallback to scanning cell zombies (works even without Bandits cache).
    local px, py = player:getX(), player:getY()
    local maxDist2 = maxDist * maxDist

    local yielded = false

    if BanditZombie and BanditZombie.GetAll then
        local all = BanditZombie.GetAll()
        if all then
            for _, light in pairs(all) do
                if light and light.x and light.y then
                    local dx = light.x - px
                    local dy = light.y - py
                    if (dx * dx + dy * dy) <= maxDist2 then
                        yielded = true
                        coroutine.yield(light)
                    end
                end
            end
        end
    end

    if yielded then return end

    local cell = getCell()
    if not cell then return end
    local list = cell:getZombieList()
    if not list then return end

    for i = 0, list:size() - 1 do
        local z = list:get(i)
        if z and (not z:isRagdoll()) and z:isAlive() then
            local zx, zy = z:getX(), z:getY()
            local dx = zx - px
            local dy = zy - py
            if (dx * dx + dy * dy) <= maxDist2 then
                coroutine.yield({
                    id = (BanditUtils and BanditUtils.GetZombieID and BanditUtils.GetZombieID(z)) or nil,
                    x = zx, y = zy, z = z:getZ(), d = z:getDirectionAngle(),
                    isBandit = z:getVariableBoolean("Bandit"),
                    brain = (BanditBrain and BanditBrain.Get and BanditBrain.Get(z)) or nil,
                    _instance = z,
                })
            end
        end
    end
end

local function eachZombieLight(player, maxDist)
    return coroutine.wrap(function()
        iterZombiesNearPlayer(player, maxDist)
    end)
end

local function render()
    if not isIngameState() then return end
    if not BWODebugOverhead.enabled then return end

    local playerNum = 0
    local player = getSpecificPlayer(playerNum)
    if not player then return end

    -- Track nearest entity (for ForceRemove hotkey)
    BWODebugOverhead._lastNearest = nil
    local bestD2 = nil

    for light in eachZombieLight(player, BWODebugOverhead.maxDist) do
        if light then
            local isBandit = light.isBandit == true
            if (not BWODebugOverhead.onlyBandits) or isBandit then
                local brain = light.brain

                -- In cache path we might only have id/x/y/z; resolve instance if needed for brain.
                if (not brain) and isBandit and light.id and BanditZombie and BanditZombie.GetInstanceById then
                    local inst = BanditZombie.GetInstanceById(light.id)
                    if inst and BanditBrain and BanditBrain.Get then
                        brain = BanditBrain.Get(inst)
                    end
                end

                local lines = buildLines(isBandit, brain, light)
                local color = isBandit and {r = 1, g = 0.35, b = 0.35, a = 1} or {r = 0.8, g = 0.8, b = 0.8, a = 1}
                drawLinesAtWorld(playerNum, light.x, light.y, light.z or 0, lines, color)
            end

            -- nearest tracking (always, even if onlyBandits filtering hides it)
            if light.x and light.y and light.id ~= nil then
                local dx = light.x - player:getX()
                local dy = light.y - player:getY()
                local d2 = dx * dx + dy * dy
                if (bestD2 == nil) or (d2 < bestD2) then
                    bestD2 = d2
                    BWODebugOverhead._lastNearest = { id = light.id, x = light.x, y = light.y, z = light.z or 0 }
                end
            end
        end
    end
end

local function onKeyPressed(key)
    if key ~= BWODebugOverhead.keyToggle then return end
    if key == BWODebugOverhead.keyToggle then
        BWODebugOverhead.enabled = not BWODebugOverhead.enabled
        local p = getPlayer()
        if p and p.addLineChatElement then
            local msg = BWODebugOverhead.enabled and "BWO Overhead Debug: ON" or "BWO Overhead Debug: OFF"
            p:addLineChatElement(msg, 0.2, 0.9, 1.0)
        end
        return
    end
end

local function onKeyPressedForceRemove(key)
    if key ~= BWODebugOverhead.keyForceRemove then return end
    if not BWODebugOverhead.enabled then return end
    local p = getPlayer()
    if not p then return end
    local near = BWODebugOverhead._lastNearest
    if not near or near.id == nil then
        if p.addLineChatElement then
            p:addLineChatElement("ForceRemove: no target", 1.0, 0.4, 0.4)
        end
        return
    end
    -- Include coords to help server find entity even if id mapping differs.
    sendClientCommand(p, "Commands", "ForceRemove", { zid = near.id, x = near.x, y = near.y, z = near.z })
    if p.addLineChatElement then
        p:addLineChatElement("ForceRemove sent: " .. safeToString(near.id), 1.0, 0.7, 0.2)
    end
end

Events.OnPreUIDraw.Remove(render)
Events.OnPreUIDraw.Add(render)

Events.OnKeyPressed.Remove(onKeyPressed)
Events.OnKeyPressed.Add(onKeyPressed)

Events.OnKeyPressed.Remove(onKeyPressedForceRemove)
Events.OnKeyPressed.Add(onKeyPressedForceRemove)


