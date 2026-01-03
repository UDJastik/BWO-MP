require "BWOGMD"
require "BWOZombie"
require "BWOCompatibility"
BWOServer = {}
BWOServer.Commands = {}

BWOServer.Commands.ObjectAdd = function(player, args)
    local gmd = BWOGMD.Get()
    if not (args.x and args.y and args.z and args.otype) then return end

    local id = math.floor(args.x) .. "-" .. math.floor(args.y) .. "-" ..args.z

    if not gmd.Objects[args.otype] then gmd.Objects[args.otype] = {} end
    gmd.Objects[args.otype][id] = args
end

BWOServer.Commands.ObjectRemove = function(player, args)
    local gmd = BWOGMD.Get()
    if not (args.x and args.y and args.z and args.otype) then return end

    local id = math.floor(args.x) .. "-" .. math.floor(args.y) .. "-" ..args.z
    if not gmd.Objects[args.otype] then gmd.Objects[args.otype] = {} end

    gmd.Objects[args.otype][id] = nil
end

BWOServer.Commands.NukeAdd = function(player, args)
    local gmd = BWOGMD.Get()
    if not (args.x and args.y and args.r) then return end

    local id = math.floor(args.x) .. "-" .. math.floor(args.y)

    gmd.Nukes[id] = args
end

BWOServer.Commands.NukesDisable = function(player, args)
    local gmd = BWOGMD.Get()
    if args.confirm then
        gmd.Nukes = {}
    end
end

BWOServer.Commands.PlaceEventAdd = function(args)
    local gmd = BWOGMD.Get()
    if not (args.x and args.y and args.z) then return end

    local id = math.floor(args.x) .. "-" .. math.floor(args.y) .. "-" .. math.floor(args.z)

    gmd.PlaceEvents[id] = args
end

BWOServer.Commands.PlaceEventRemove = function(player, args)
    local gmd = BWOGMD.Get()
    if not (args.x and args.y and args.z) then return end

    local id = math.floor(args.x) .. "-" .. math.floor(args.y) .. "-" ..args.z

    gmd.PlaceEvents[id] = nil
end

BWOServer.Commands.EventBuildingAdd = function(player, args)
    local gmd = BWOGMD.Get()
    if not (args.id and args.event) then return end

    gmd.EventBuildings[args.id] = args
end

BWOServer.Commands.DeadBodyAdd = function(player, args)
    local gmd = BWOGMD.Get()
    if not (args.x and args.y and args.z) then return end

    local id = math.floor(args.x) .. "-" .. math.floor(args.y) .. "-" ..args.z
    gmd.DeadBodies[id] = args
end

BWOServer.Commands.DeadBodyRemove = function(player, args)
    local gmd = BWOGMD.Get()
    if not (args.x and args.y and args.z) then return end

    local id = math.floor(args.x) .. "-" .. math.floor(args.y) .. "-" .. args.z
    gmd.DeadBodies[id] = nil
end

BWOServer.Commands.DeadBodyFlush = function(player, args)
    local gmd = BWOGMD.Get()
    gmd.DeadBodies = {}
    print ("[INFO] All deadbodies info removed!!!")
end

local function bwoGiveMoney(player, amount)
    if not player or not amount or amount <= 0 then return end
    local inv = player:getInventory()
    if not inv then return end
    for i = 1, amount do
        local item = BanditCompatibility and BanditCompatibility.InstanceItem and BanditCompatibility.InstanceItem("Base.Money") or nil
        if item then
            inv:AddItem(item)
        end
    end
end

-- =========================================================
-- WeekOne (SP) logic ported to MP server commands
-- =========================================================

-- make npcs react to actual crime
BWOServer.Commands.ActivateWitness = function(player, args)
    if not isServer() then return end
    if not player then return end

    local min = (args and args.min) or 18

    local activatePrograms = {"Patrol", "Inhabitant", "Walker", "Runner", "Postal", "Janitor", "Gardener", "Entertainer", "Vandal", "Medic", "Fireman", "Passenger"}
    local braveList = {
        Bandit.clanMap.PoliceBlue,
        Bandit.clanMap.PoliceGray,
        Bandit.clanMap.PoliceRiot,
        Bandit.clanMap.SWAT,
        Bandit.clanMap.SecretLab,
        Bandit.clanMap.ArmyGreen,
        Bandit.clanMap.ArmyGreenMask,
        Bandit.clanMap.Security
    }

    local witnessList = (BWOZombie and BWOZombie.CacheLightB) or {}
    for _, witness in pairs(witnessList) do
        if witness and witness.brain and witness.x and witness.y then
            local dx = player:getX() - witness.x
            local dy = player:getY() - witness.y
            local dist = math.sqrt(dx * dx + dy * dy)
            if dist < min then
                local actor = BWOZombie.GetInstanceById(witness.id)
                if actor then
                    local canSee = actor:CanSee(player)
                    if canSee or dist < 3 then
                        for _, prg in pairs(activatePrograms) do
                            if witness.brain.program and witness.brain.program.name == prg then
                                Bandit.ClearTasks(actor)

                                local brave = false
                                for _, v in pairs(braveList) do
                                    if v == witness.brain.cid then
                                        brave = true
                                        break
                                    end
                                end

                                if brave then
                                    Bandit.SetProgram(actor, "Police", {})
                                    Bandit.SetHostileP(actor, true)
                                    Bandit.Say(actor, "SPOTTED")
                                else
                                    local r = 4
                                    if actor:isFemale() then r = 10 end

                                    Bandit.SetProgram(actor, "Active", {})
                                    Bandit.SetHostileP(actor, true)
                                    Bandit.Say(actor, "REACTCRIME")
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end

-- make npcs react to threat possibility (player aiming or swinging weapon)
BWOServer.Commands.ActivateTargets = function(player, args)
    if not isServer() then return end
    if not player then return end

    local min = (args and args.min) or 15
    local severity = (args and args.severity) or 1

    local activatePrograms = {"Patrol", "Inhabitant", "Walker", "Runner", "Postal", "Janitor", "Gardener", "Entertainer", "Vandal", "Medic", "Fireman", "Passenger"}
    local braveList = {
        Bandit.clanMap.PoliceBlue,
        Bandit.clanMap.PoliceGray,
        Bandit.clanMap.PoliceRiot,
        Bandit.clanMap.SWAT,
        Bandit.clanMap.SecretLab,
        Bandit.clanMap.ArmyGreen,
        Bandit.clanMap.ArmyGreenMask,
        Bandit.clanMap.Security
    }

    local witnessList = (BWOZombie and BWOZombie.CacheLightB) or {}
    local wasLegal = false
    for _, witness in pairs(witnessList) do
        if witness and witness.brain and witness.x and witness.y then
            local dx = player:getX() - witness.x
            local dy = player:getY() - witness.y
            local dist = math.sqrt(dx * dx + dy * dy)
            if dist < min then
                if witness.brain.hostile or (witness.brain.program and witness.brain.program.name == "Vandal") then
                    wasLegal = true
                else
                    local actor = BWOZombie.GetInstanceById(witness.id)
                    if actor then
                        local canSee1 = actor:CanSee(player)
                        local canSee2 = player:CanSee(actor)
                        if canSee1 and canSee2 then
                            for _, prg in pairs(activatePrograms) do
                                if witness.brain.program and witness.brain.program.name == prg then
                                    Bandit.ClearTasks(actor)

                                    local brave = false
                                    for _, v in pairs(braveList) do
                                        if v == witness.brain.cid then
                                            brave = true
                                            break
                                        end
                                    end

                                    if brave then
                                        Bandit.SetProgram(actor, "Police", {})
                                        if not wasLegal then
                                            if severity == 2 then
                                                Bandit.SetHostileP(actor, true)
                                            end
                                            Bandit.Say(actor, "SPOTTED")
                                        end
                                    else
                                        Bandit.SetProgram(actor, "Active", {})
                                        if not wasLegal then
                                            local r = 4
                                            if actor:isFemale() then r = 9 end
                                            if ZombRand(r) == 0 and severity == 2 then
                                                Bandit.SetHostileP(actor, true)
                                            end
                                            Bandit.Say(actor, "REACTCRIME")
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end

BWOServer.Commands.ActivateExcercise = function(player, args)
    if not isServer() then return end
    if not player then return end
    if not (BWOScheduler and BWOScheduler.Anarchy and BWOScheduler.Anarchy.Transactions) then return end

    local min = (args and args.min) or 5

    local activatePrograms = {"Walker", "Runner", "Inhabitant"}
    local witnessList = (BWOZombie and BWOZombie.CacheLightB) or {}
    local cnt = 0

    for _, witness in pairs(witnessList) do
        if witness and witness.brain and witness.x and witness.y then
            local dx = player:getX() - witness.x
            local dy = player:getY() - witness.y
            local dist = math.sqrt(dx * dx + dy * dy)
            if dist < min then
                local actor = BWOZombie.GetInstanceById(witness.id)
                if actor then
                    local canSee = actor:CanSee(player)
                    if canSee or dist < 3 then
                        for _, prg in pairs(activatePrograms) do
                            if witness.brain.program and witness.brain.program.name == prg then
                                if not Bandit.HasTaskType(actor, "PushUp") then
                                    Bandit.ClearTasks(actor)
                                    Bandit.AddTask(actor, {action = "PushUp", time = 2000})
                                    cnt = cnt + 1
                                end
                            end
                        end
                    end
                end
            end
        end
    end

    if cnt > 0 then
        bwoGiveMoney(player, cnt)
    end
end

-- Economy helpers for MP hooks
BWOServer.Commands.MoneyEarn = function(player, args)
    if not isServer() then return end
    if not player then return end
    if not (BWOScheduler and BWOScheduler.Anarchy and BWOScheduler.Anarchy.Transactions) then return end

    local amount = args and tonumber(args.amount) or 0
    if amount <= 0 then return end
    bwoGiveMoney(player, amount)
end

BWOServer.Commands.MoneyPay = function(player, args)
    if not isServer() then return end
    if not player then return end
    if not (BWOScheduler and BWOScheduler.Anarchy and BWOScheduler.Anarchy.Transactions) then return end

    local amount = args and tonumber(args.amount) or 0
    if amount <= 0 then return end

    local function predicateMoney(item)
        return item and item.getType and item:getType() == "Money"
    end

    local inv = player:getInventory()
    if not inv then return end

    local items = ArrayList.new()
    inv:getAllEvalRecurse(predicateMoney, items)

    if items:size() >= amount then
        for i = 1, amount do
            inv:RemoveOneOf("Money", true)
        end
    else
        -- Not enough money: treat as theft attempt (optional)
        local witnessMin = args and tonumber(args.witnessMin) or nil
        if witnessMin then
            BWOServer.Commands.ActivateWitness(player, { min = witnessMin })
        end
    end
end

-- Sleep end -> schedule server dream event if present
BWOServer.Commands.PlayerWokeUp = function(player, args)
    if not isServer() then return end
    if not player then return end
    if not (BWOScheduler and BWOScheduler.Add) then return end
    local params = { night = args and args.night or nil }
    BWOScheduler.Add("Dream", params, 600)
end

-- Time based income tick (client triggers each minute, server applies every 5 minutes)
BWOServer.Commands.TimeIncomeTick = function(player, args)
    if not isServer() then return end
    if not player then return end
    if not (BWOScheduler and BWOScheduler.Anarchy and BWOScheduler.Anarchy.Transactions) then return end
    if player:isAsleep() then return end

    local gametime = getGameTime()
    local minute = gametime and gametime:getMinutes() or 0
    if minute % 5 > 0 then return end

    local profession = player:getDescriptor() and player:getDescriptor():getCharacterProfession() or nil
    local payment = nil

    if profession == "parkranger" then
        local zone = player:getSquare() and player:getSquare():getZone() or nil
        if zone then
            local zoneType = zone:getType()
            if zoneType == "Forest" then
                payment = 1
            elseif zoneType == "DeepForest" then
                payment = 3
            end
        end
    end

    -- room based time based income
    local square = player:getSquare()
    if square then
        local room = square:getRoom()
        if room then
            local name = BWORooms and BWORooms.GetRealRoomName and BWORooms.GetRealRoomName(room) or nil
            local data = name and BWORooms and BWORooms.tab and BWORooms.tab[name] or nil
            if data and data.income and data.occupations then
                for _, occupation in pairs(data.occupations) do
                    if profession == occupation then
                        payment = data.income
                        break
                    end
                end
            end
        end
    end

    if payment then
        bwoGiveMoney(player, payment)
    end
end

-- De-hostile civs for new player (ported from SP hook)
BWOServer.Commands.PlayerDeath = function(player, args)
    if not isServer() then return end
    local civList = (BWOZombie and BWOZombie.CacheLightB) or {}
    for _, civ in pairs(civList) do
        if civ.brain and civ.brain.hostileP then
            local actor = BWOZombie.GetInstanceById(civ.brain.id)
            if actor then
                Bandit.SetHostileP(actor, false)
            end
        end
    end
end

-- Shahid detonation request from client (server validates)
BWOServer.Commands.ShahidDetonate = function(player, args)
    if not isServer() then return end
    if not args then return end

    local zid = args.zid
    if not zid then return end

    local zombie = BWOZombie and BWOZombie.GetInstanceById and BWOZombie.GetInstanceById(zid) or nil
    if not zombie then return end

    local brain = BanditBrain and BanditBrain.Get and BanditBrain.Get(zombie) or nil
    if not (brain and brain.program and brain.program.name == "Shahid") then return end

    local md = zombie:getModData()
    if md and md.BWOShahidDetonated then return end
    if md then md.BWOShahidDetonated = true end

    -- Kill and explode
    zombie:Kill(nil)
    local params = { x = zombie:getX(), y = zombie:getY() }
    if BWOEvents and BWOEvents.Explode then
        BWOEvents.Explode(params)
    elseif BWOUtils and BWOUtils.Explode then
        BWOUtils.Explode(params.x, params.y, zombie:getZ())
    end
end

-- MP placeholder for SP OnExitVehicle logic (kept for compatibility; no-op by default)
BWOServer.Commands.PlayerExitVehicle = function(player, args)
    -- Intentionally empty for now: SP logic depended on client-side NPC passengers + SpawnRestore.
    -- Hook kept so future vehicle companion logic can be implemented server-side.
end

-- Force-remove an entity by zombie id (debug tool).
-- Useful for "unremovable" entities: attempts to remove regardless of Bandit flag / cluster / reanimated state.
BWOServer.Commands.ForceRemove = function(player, args)
    if not isServer() then return end
    if type(args) ~= "table" then return end

    local function asNumber(v)
        if v == nil then return nil end
        if type(v) == "number" then return v end
        local n = tonumber(v)
        if n ~= nil then return n end
        -- In MP args often arrive as Java boxed numbers/userdata.
        return tonumber(tostring(v))
    end

    local zid = args.zid or args.id
    if zid == nil then return end
    local zidStr = tostring(zid)

    -- Try cached lookup first.
    local zombie = BWOZombie and BWOZombie.GetInstanceById and BWOZombie.GetInstanceById(zid) or nil

    -- Fallback: scan cell zombie list by persistent outfit id / BanditUtils.GetZombieID.
    if not zombie then
        local cell = getCell()
        local list = cell and cell:getZombieList() or nil
        if list then
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
                        zombie = z
                        break
                    end
                end
            end
        end
    end

    if not zombie then
        -- Final fallback: remove nearest zombie to provided coordinates.
        local tx = asNumber(args.x)
        local ty = asNumber(args.y)
        local tz = asNumber(args.z)
        -- If coords are missing/unparsable, fall back to requesting player's current coords.
        if (tx == nil or ty == nil or tz == nil) and player and player.getX then
            tx = tx or player:getX()
            ty = ty or player:getY()
            tz = tz or player:getZ()
        end

        local cell = getCell()
        local list = cell and cell:getZombieList() or nil

        if tx and ty and tz and list then
            local best = nil
            local bestD2 = nil

            for i = 0, list:size() - 1 do
                local z = list:get(i)
                if z and z:isAlive() and (not z:isRagdoll()) then
                    local dx = z:getX() - tx
                    local dy = z:getY() - ty
                    local dz = (z:getZ() or 0) - tz
                    -- prioritize same-Z matches heavily
                    local d2 = (dx * dx + dy * dy) + (dz * dz * 4)
                    if (bestD2 == nil) or (d2 < bestD2) then
                        bestD2 = d2
                        best = z
                    end
                end
            end

            -- Require reasonably close match (within ~3 tiles) to avoid deleting wrong zombie.
            if best and bestD2 ~= nil and bestD2 <= 9.25 then
                zombie = best
                dprint(string.format("[ForceRemove] zid=%s not found by id, using nearest@coords d2=%.3f", zidStr, bestD2), 2)
            end
        end

        if not zombie then
            dprint(string.format("[ForceRemove] zid=%s not found (cache+scan+coords)", zidStr), 2)
            if player then
                local listSize = list and list:size() or -1
                sendServerCommand(player, "Commands", "ForceRemoveResult", {
                    ok = false,
                    zid = zidStr,
                    reason = "not_found",
                    x = tx, y = ty, z = tz,
                    listSize = listSize,
                })
            end
            return
        end
    end

    -- Determine if this is a bandit-like entity (cluster/brain/var).
    local isBandit = false
    if zombie.getVariableBoolean and zombie:getVariableBoolean("Bandit") then
        isBandit = true
    end

    local brain = BanditBrain and BanditBrain.Get and BanditBrain.Get(zombie) or nil
    if brain then
        isBandit = true
    end

    if (not isBandit) and GetBanditClusterData then
        local gmd = GetBanditClusterData(zid)
        if gmd and gmd[zid] then
            isBandit = true
        end
    end

    -- Remove from world/square first (server authoritative).
    local rx = zombie.getX and zombie:getX() or args.x
    local ry = zombie.getY and zombie:getY() or args.y
    local rz = zombie.getZ and zombie:getZ() or args.z
    if zombie.removeFromWorld then zombie:removeFromWorld() end
    if zombie.removeFromSquare then zombie:removeFromSquare() end
    dprint(string.format("[ForceRemove] removed zid=%s isBandit=%s", zidStr, tostring(isBandit)), 2)

    -- Clear BWOMP keep-queue entry if present.
    local bwomp = ModData.getOrCreate("BWOMP")
    if bwomp and bwomp.Queue then
        bwomp.Queue[zid] = nil
    end

    -- Clear Bandits brain + cluster entry if present.
    if BanditBrain and BanditBrain.Remove then
        BanditBrain.Remove(zombie)
    end
    if GetBanditClusterData then
        local gmd = GetBanditClusterData(zid)
        if gmd and gmd[zid] then
            gmd[zid] = nil
            if TransmitBanditCluster then
                TransmitBanditCluster(zid)
            end
        end
    end

    -- Clear WeekOneMP caches
    if BWOZombie and BWOZombie.Cache then BWOZombie.Cache[zid] = nil end
    if BWOZombie and BWOZombie.CacheLight then BWOZombie.CacheLight[zid] = nil end
    if BWOZombie and BWOZombie.CacheLightB then BWOZombie.CacheLightB[zid] = nil end
    if BWOZombie and BWOZombie.CacheLightZ then BWOZombie.CacheLightZ[zid] = nil end

    if player then
        sendServerCommand(player, "Commands", "ForceRemoveResult", {
            ok = true,
            zid = zidStr,
            isBandit = isBandit,
        })
    end

    -- Broadcast removal to all clients by coordinates (fixes client-side "ghost zombies"/bandits turning into zombies).
    local playersAll = BWOUtils and BWOUtils.GetAllPlayers and BWOUtils.GetAllPlayers() or {}
    local payload = { zid = zidStr, x = rx, y = ry, z = rz }
    for _, pl in pairs(playersAll) do
        sendServerCommand(pl, "Commands", "ZombieRemoveAt", payload)
    end
end

-- Server-side port of BanditsWeekOne `BWOPlayer.CheckFriendlyFire` (SP client override).
-- In MP, client forwards a hit event to this command, and server applies the actual logic.
BWOServer.Commands.FriendlyFire = function(player, args)
    if not isServer() then return end
    if not player then return end
    if not args or not args.zid then return end

    -- Identify victim bandit
    local zid = args.zid
    local bandit = BWOZombie and BWOZombie.GetInstanceById and BWOZombie.GetInstanceById(zid) or nil
    if not bandit then return end

    -- attacking zombies is ok!
    local brain = BanditBrain and BanditBrain.Get and BanditBrain.Get(bandit) or nil
    if (not bandit:getVariableBoolean("Bandit")) and (not brain) then
        -- On dedicated servers the "Bandit" variable can be missing; fall back to BWOZombie light cache.
        local light = BWOZombie and BWOZombie.CacheLightB and BWOZombie.CacheLightB[zid] or nil
        if light and light.isBandit then
            brain = light.brain
        else
            return
        end
    end

    if not brain then
        local light = BWOZombie and BWOZombie.CacheLightB and BWOZombie.CacheLightB[zid] or nil
        brain = light and light.brain or nil
    end
    if not brain then return end

    local function giveMoney(p, amount)
        if not p or not amount or amount <= 0 then return end
        local inv = p:getInventory()
        if not inv then return end
        for i = 1, amount do
            local item = BanditCompatibility and BanditCompatibility.InstanceItem and BanditCompatibility.InstanceItem("Base.Money") or nil
            if item then
                inv:AddItem(item)
            end
        end
    end

    -- killing hostile bandits is ok (and can be rewarded)
    if brain.program and brain.program.name == "Vandal" or brain.hostile then
        if BWOScheduler and BWOScheduler.Anarchy and BWOScheduler.Anarchy.Transactions then
            local profession = player:getDescriptor() and player:getDescriptor():getCharacterProfession() or nil
            if profession == "policeofficer" then
                bwoGiveMoney(player, 5)
            end
        end
        return
    end

    -- who saw this changes program
    local witnessList = (BWOZombie and BWOZombie.CacheLightB) or {}
    for id, witness in pairs(witnessList) do
        if witness.brain and not witness.brain.hostileP then
            local dx = bandit:getX() - witness.x
            local dy = bandit:getY() - witness.y
            local dist = math.sqrt(dx * dx + dy * dy)
            if dist < 15 then
                local actor = BWOZombie and BWOZombie.GetInstanceById and BWOZombie.GetInstanceById(witness.id) or nil
                if actor and actor:CanSee(bandit) then

                    local params = {
                        x = bandit:getX(),
                        y = bandit:getY(),
                        z = bandit:getZ(),
                    }

                    -- This command is only sent by the attacking client, so it's always player fault.
                    local wasPlayerFault = true

                    if brain.id ~= id then
                        if brain.occupation == "Police" then
                            if BWOPopControl and BWOPopControl.SWAT and BWOPopControl.SWAT.On then
                                params.hostile = true
                                BWOScheduler.Add("CallSWAT", params, 19500)
                            end
                        else
                            if BWOPopControl and BWOPopControl.Police and BWOPopControl.Police.On then
                                params.hostile = true
                                BWOScheduler.Add("CallCops", params, 12000)
                            end
                        end
                    end

                    -- call medics
                    if BWOPopControl and BWOPopControl.Medics and BWOPopControl.Medics.On then
                        BWOScheduler.Add("CallMedics", params, 15000)
                    elseif BWOPopControl and BWOPopControl.Hazmats and BWOPopControl.Hazmats.On then
                        BWOScheduler.Add("CallHazmats", params, 15500)
                    end

                    -- witnessing civilians need to change peaceful behavior to active
                    local activatePrograms = {"Patrol", "Police", "Inhabitant", "Walker", "Runner", "Postal", "Janitor", "Gardener", "Entertainer", "Vandal", "Passenger"}
                    for _, prg in pairs(activatePrograms) do
                        if witness.brain.program and witness.brain.program.name == prg then
                            if witness.brain.occupation == "Police" or witness.brain.occupation == "Security" or witness.brain.occupation == "Army" then
                                Bandit.ClearTasks(actor)
                                Bandit.SetProgram(actor, "Police", {})
                                if wasPlayerFault then
                                    Bandit.SetHostileP(actor, true)
                                end
                            else
                                if ZombRand(4) > 0 then
                                    Bandit.ClearTasks(actor)
                                    Bandit.SetProgram(actor, "Active", {})
                                    if wasPlayerFault then
                                        Bandit.SetHostileP(actor, true)
                                    end
                                    Bandit.Say(actor, "REACTCRIME")
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end

BWOServer.Commands.AddEffect = function(player, args)
    sendServerCommand('BWOEffects', 'Add', args)
end

BWOServer.Commands.Nuke = function(player, args)
    local player = getSpecificPlayer(0)
    local cell = player:getCell()
    local px = args.x
    local py = args.y
    local r = args.r

    for z=0, 7 do
        for y=-r, r do
            for x=-r, r do
                local bx = px + x
                local by = py + y
                local dist = math.sqrt(math.pow(bx - px, 2) + math.pow(by - py, 2))
                if dist < r then
                    local square = cell:getGridSquare(bx, by, z)
                    if square then
                        BWOSquareLoader.Burn(square)

                        local vehicle = square:getVehicleContainer()
                        if vehicle then
                            BWOVehicles.Burn(vehicle)
                        end
                    end
                end
            end
        end
    end
end

BWOServer.Commands.SetVariant = function(player, args)
    local gmd = BWOGMD.Get()
    gmd.Variant = args.variant

end

-- Ensure scheduler + server events are loaded.
-- Some commands (FriendlyFire/PlayerWokeUp/etc.) enqueue BWOScheduler events (CallCops/CallMedics/...),
-- so BWOScheduler + BWOServerEvents must exist on the server by the time client commands arrive.
if not BWOPopControl then require "BWOPopControl" end
if not BWOServerEvents then require "BWOServerEvents" end
if not BWOScheduler then require "BWOScheduler" end

-- main
local onClientCommand = function(module, command, player, args)
    if BWOServer[module] and BWOServer[module][command] then
        -- Some client commands arrive with `args == nil` (or otherwise non-table) which would crash `pairs(args)`.
        -- Treat missing/malformed args as an empty table so we can safely dispatch.
        if type(args) ~= "table" then
            args = {}
        end
        local argStr = ""
        for k, v in pairs(args) do
            argStr = argStr .. " " .. k .. "=" .. tostring(v)
        end
        -- print ("received " .. module .. "." .. command .. " "  .. argStr)
        BWOServer[module][command](player, args)

        if module == "Commands" then
            BWOGMD.Transmit()
        end
    end
end

-- gc for objects with set ttl
local everyOneMinute = function()
    local toRemove = {}
    local gmd = BWOGMD.Get()
    if not gmd then return end

    -- Defensive: modData can be reset/partial during load; ensure we always iterate a table.
    if type(gmd.Objects) ~= "table" then
        gmd.Objects = {}
    end

    for k, obj in pairs(gmd.Objects) do
        if obj.ttl then
            if BanditUtils.GetTime() > obj.ttl then
                table.insert(toRemove, k)
            end
        end
    end

    for _, k in pairs(toRemove) do
        gmd.Objects[k] = nil
    end
end

Events.OnClientCommand.Add(onClientCommand)
Events.EveryOneMinute.Add(everyOneMinute)
