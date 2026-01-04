require "BanditGMD"
require "BWODebug"
require "BWOUtils"
require "BWOGMD"
require "BWOZombie"
BWOPopControl = BWOPopControl or {}

local function normalizeScenario(selected)
    if selected == "Week" then return "Week" end
    if selected == "DayOne" or selected == "DOne" then return "DOne" end
    return nil
end

-- первичная инициализация (может быть до загрузки мод-даты)
do
    local selected = BWOGMD
        and BWOGMD.data
        and BWOGMD.data.general
        and BWOGMD.data.general.selectedScenario
    local scen = normalizeScenario(selected) or "DOne"

    BWOPopControl.Scenario = scen
    if scen == "Week" then
        BWOPopControl.zombiePercent = 0
    else
        BWOPopControl.zombiePercent = 66
    end
end

-- мод-дата подтягивается позже стартового require, поэтому уточняем сценарий динамически
local function refreshScenarioFromGMD()
    local selected = BWOGMD
        and BWOGMD.data
        and BWOGMD.data.general
        and BWOGMD.data.general.selectedScenario
    local scen = normalizeScenario(selected)
    if not scen or scen == BWOPopControl.Scenario then return end

    BWOPopControl.Scenario = scen
    if scen == "Week" then
        BWOPopControl.zombiePercent = 0
    else
        BWOPopControl.zombiePercent = 66
    end

    dprint("[POP CONTROL][INFO] SCENARIO SWITCHED TO: " .. tostring(scen), 2)
end

-- population defaults (server-side mirror of client values)
BWOPopControl.ZombieMax = BWOPopControl.ZombieMax or 0
BWOPopControl.StreetsNominal = BWOPopControl.StreetsNominal or 0
BWOPopControl.InhabitantsNominal = BWOPopControl.InhabitantsNominal or 0
BWOPopControl.SurvivorsNominal = BWOPopControl.SurvivorsNominal or 0

BWOPopControl.Police = {} 
BWOPopControl.Police.Cooldown = 0
BWOPopControl.Police.On = true

BWOPopControl.SWAT = {} 
BWOPopControl.SWAT.Cooldown = 0
BWOPopControl.SWAT.On = true

BWOPopControl.Security = {}
BWOPopControl.Security.Cooldown = 0
BWOPopControl.Security.On = true

BWOPopControl.Medics = {}
BWOPopControl.Medics.Cooldown = 0
BWOPopControl.Medics.On = true

BWOPopControl.Hazmats = {}
BWOPopControl.Hazmats.Cooldown = 0
BWOPopControl.Hazmats.On = true

BWOPopControl.Fireman = {} 
BWOPopControl.Fireman.Cooldown = 0
BWOPopControl.Fireman.On = true

-- =========================================================
-- Spawn/despawn stats + periodic logging (server-side)
-- =========================================================
BWOPopControl.Stats = BWOPopControl.Stats or {
    street = { spawnedTotal = 0, despawnedTotal = 0, spawnedInterval = 0, despawnedInterval = 0, last = {} },
    inhabitant = { spawnedTotal = 0, despawnedTotal = 0, spawnedInterval = 0, despawnedInterval = 0, last = {} },
    survivor = { spawnedTotal = 0, despawnedTotal = 0, spawnedInterval = 0, despawnedInterval = 0, last = {} },
}

local function fmtNum(n, digits)
    if n == nil then return "nil" end
    digits = digits or 0
    local num = tonumber(n)
    if not num then return tostring(n) end
    if digits <= 0 then return tostring(math.floor(num + 0.5)) end
    return string.format("%." .. tostring(digits) .. "f", num)
end

local function statsRemember(group, fields)
    local s = BWOPopControl.Stats and BWOPopControl.Stats[group]
    if not s then return end
    s.last = s.last or {}
    for k, v in pairs(fields or {}) do
        s.last[k] = v
    end
    s.last.worldAge = BWOUtils and BWOUtils.GetWorldAge and BWOUtils.GetWorldAge() or s.last.worldAge
    local gt = getGameTime()
    s.last.hour = gt and gt.getHour and gt:getHour() or (s.last.hour or nil)
end

local function statsInc(group, field, delta)
    local s = BWOPopControl.Stats and BWOPopControl.Stats[group]
    if not s then return end
    delta = delta or 0
    s[field] = (s[field] or 0) + delta
end

local function logStatsEvery10Ticks(numTicks)
    if not isServer() then return end
    if (numTicks or 0) % 10 ~= 0 then return end
    refreshScenarioFromGMD()

    local gt = getGameTime()
    local hour = gt and gt.getHour and gt:getHour() or -1
    local worldAge = BWOUtils and BWOUtils.GetWorldAge and BWOUtils.GetWorldAge() or -1
    local players = BWOUtils and BWOUtils.GetAllPlayers and BWOUtils.GetAllPlayers() or {}
    local pcount = players and #players or 0

    local function line(groupName, key)
        local s = BWOPopControl.Stats[key]
        if not s then return end
        local last = s.last or {}
        dprint(string.format(
            "[POP CONTROL][STATS][%s] tick=%s worldAge=%sh hour=%s players=%s scenario=%s | target=%s current=%s missing=%s | spawned(+10t)=%s total=%s | despawned(+10t)=%s total=%s",
            groupName,
            tostring(numTicks or "?"),
            fmtNum(worldAge, 0),
            tostring(hour),
            tostring(pcount),
            tostring(BWOPopControl.Scenario),
            fmtNum(last.target, 2),
            fmtNum(last.current, 0),
            fmtNum(last.missing, 2),
            tostring(s.spawnedInterval or 0),
            tostring(s.spawnedTotal or 0),
            tostring(s.despawnedInterval or 0),
            tostring(s.despawnedTotal or 0)
        ), 2)

        -- reset interval counters
        s.spawnedInterval = 0
        s.despawnedInterval = 0
    end

    line("STREETS", "street")
    line("INHABITANTS", "inhabitant")
    line("SURVIVORS", "survivor")
end

local function zombieController(targetCnt)
    if targetCnt > 400 then return end
    -- IMPORTANT:
    -- We must not delete bandits while trimming zombies.
    -- BWOMP.Queue is reserved for "KEEP" semantics (zombies that should persist).
    local queue = ModData.getOrCreate("BWOMP").Queue
    if not queue then
        queue = {}
        ModData.getOrCreate("BWOMP").Queue = queue
    end
    local players = BWOUtils.GetAllPlayers()
    if not players or #players == 0 then return end

    local banditMemo = {}
    local function isBandit(zombie, id)
        if not zombie or not id then return false end
        if zombie:getVariableBoolean("Bandit") then return true end
        if banditMemo[id] ~= nil then return banditMemo[id] end
        if GetBanditClusterData then
            local gmd = GetBanditClusterData(id)
            if gmd and gmd[id] then
                banditMemo[id] = true
                return true
            end
        end
        banditMemo[id] = false
        return false
    end

    -- пройти по каждому игроку и удалить у него не более targetCnt зомби
    for pIdx = 1, #players do
        local player = players[pIdx]
        local cell = player and player:getCell()
        if cell then
            local pid = player.getOnlineID and player:getOnlineID() or pIdx
            local zombieList = cell:getZombieList()
            local zombieListSize = zombieList:size()
            local zombies = {}
            for i = 0, zombieListSize - 1 do
                local z = zombieList:get(i)
                if z then table.insert(zombies, z) end
            end
            if VERBOSE_LVL and VERBOSE_LVL >= 4 then
                dprint("[ZOMBIEDEL] Zombielist size: " .. zombieListSize, 4)
            end
            local desired = targetCnt or 0
            if desired < 0 then desired = 0 end

            -- Build candidates: real zombies only (exclude bandits), with stable ids.
            local candidates = {}
            for _, zombie in ipairs(zombies) do
                if zombie and zombie:isAlive() and not zombie:isReanimatedPlayer() then
                    local id = BanditUtils.GetZombieID(zombie)
                    if not id and BanditUtils.GetCharacterID then
                        id = BanditUtils.GetCharacterID(zombie)
                    end
                    if id and (not isBandit(zombie, id)) then
                        local dx = zombie:getX() - player:getX()
                        local dy = zombie:getY() - player:getY()
                        table.insert(candidates, { id = id, zombie = zombie, d2 = (dx * dx + dy * dy) })
                    end
                end
            end

            -- Sort by distance (nearest first). Tie-breaker: id string.
            table.sort(candidates, function(a, b)
                if a.d2 ~= b.d2 then return a.d2 < b.d2 end
                return tostring(a.id) < tostring(b.id)
            end)

            -- Determine keep-set for this player.
            local keep = {}
            for i = 1, math.min(desired, #candidates) do
                keep[candidates[i].id] = true
            end

            -- Update BWOMP.Queue for this player: queue[id] = pid
            -- Remove old keeps owned by this pid that are no longer in keep-set.
            for id, owner in pairs(queue) do
                if owner == pid and (not keep[id]) then
                    queue[id] = nil
                end
            end
            -- Add keeps
            for id, _ in pairs(keep) do
                queue[id] = pid
            end

            local removed = 0
            local toDelete = {}
            local current = #candidates
            local toRemove = current - desired
            if toRemove <= 0 then
                if VERBOSE_LVL and VERBOSE_LVL >= 4 then
                    dprint(string.format("[ZOMBIEDEL] current %s <= target %s, nothing to delete for player %s", current, desired, player.getUsername and player:getUsername() or tostring(pIdx)), 4)
                end
            else
                -- safety cap to avoid deleting too many per tick
                if toRemove > 400 then toRemove = 400 end
                if VERBOSE_LVL and VERBOSE_LVL >= 4 then
                    dprint(string.format("[ZOMBIEDEL] need to delete %s (target %s, current %s)", toRemove, desired, current), 4)
                end

                -- Delete farthest first, keep nearest (stable).
                for i = #candidates, 1, -1 do
                    if removed >= toRemove then break end

                    local entry = candidates[i]
                    local id = entry and entry.id or nil
                    local zombie = entry and entry.zombie or nil

                    if id and zombie and (not keep[id]) then
                        -- If some other player owns this zombie in queue, don't delete it here.
                        local owner = queue[id]
                        if owner ~= nil and owner ~= pid then
                            -- skip
                        else
                            zombie:removeFromWorld()
                            zombie:removeFromSquare()
                            if VERBOSE_LVL and VERBOSE_LVL >= 4 then
                                dprint("[ZOMBIDEL] Zombie removed on server - " .. tostring(id), 4)
                            end
                        -- Notify ALL clients to remove by coordinates (robust in MP; id mapping can differ).
                        local playersAll = BWOUtils.GetAllPlayers()
                        local payload = { zid = id, x = zombie:getX(), y = zombie:getY(), z = zombie:getZ() }
                        for _, pl in pairs(playersAll or {}) do
                            sendServerCommand(pl, "Commands", "ZombieRemoveAt", payload)
                        end
                            table.insert(toDelete, id)
                            removed = removed + 1
                        end
                    end
                end
            end

            if VERBOSE_LVL and VERBOSE_LVL >= 4 then
                dprint("[POP CONTROL] Zombie Controller: Target Count: " .. targetCnt .. " Removed count: " .. removed .. " player: " .. (player.getUsername and player:getUsername() or tostring(pIdx)), 4)
            end
        end
    end
end

local function countTable(tbl)
    local c = 0
    if not tbl then return c end
    for _ in pairs(tbl) do c = c + 1 end
    return c
end

-- ---------------------------------------------------------------------------
-- Cluster cleanup helpers
-- ---------------------------------------------------------------------------
-- Population controllers may count NPCs via Bandits' global clusters (ModData),
-- while despawners only see currently-loaded IsoZombies. When players travel far,
-- unloaded NPC objects can disappear but their cluster entries remain, bloating
-- counts ("current") and leaking memory. This helper prunes stale cluster entries
-- for specific programs if the corresponding IsoZombie is not currently loaded.
local function trimClustersByProgram(programs, cnt, opts)
    if not isServer() then return 0 end
    if not programs or #programs == 0 then return 0 end
    cnt = tonumber(cnt) or 0
    if cnt <= 0 then return 0 end

    opts = opts or {}
    local skipPermanent = (opts.skipPermanent ~= false) -- default true

    if not BanditClusters or not BanditClusterCount then return 0 end

    local progSet = {}
    for _, p in ipairs(programs) do
        progSet[p] = true
    end

    local candidates = {}
    for c = 0, BanditClusterCount - 1 do
        local cluster = BanditClusters[c]
        if cluster then
            for id, brain in pairs(cluster) do
                local prog = brain and brain.program and brain.program.name
                if prog and progSet[prog] then
                    if (not skipPermanent) or (not (brain and brain.permanent)) then
                        -- Only remove if the actual IsoZombie is NOT loaded right now.
                        local loaded = (BWOZombie and BWOZombie.GetInstanceById and BWOZombie.GetInstanceById(id)) ~= nil
                        if not loaded then
                            candidates[#candidates + 1] = { c = c, id = id, born = (brain and brain.born) or 0 }
                        end
                    end
                end
            end
        end
    end

    if #candidates == 0 then return 0 end

    -- Prefer removing oldest entries first (more likely stale).
    table.sort(candidates, function(a, b)
        return (a.born or 0) < (b.born or 0)
    end)

    local removed = 0
    local touched = {}
    for _, v in ipairs(candidates) do
        if removed >= cnt then break end
        local cluster = BanditClusters[v.c]
        if cluster and cluster[v.id] then
            cluster[v.id] = nil
            touched[v.c] = true
            removed = removed + 1

            -- best-effort: keep WeekOneMP caches in sync (should usually be nil already)
            if BWOZombie then
                if BWOZombie.Cache then BWOZombie.Cache[v.id] = nil end
                if BWOZombie.CacheLight then BWOZombie.CacheLight[v.id] = nil end
                if BWOZombie.CacheLightB then BWOZombie.CacheLightB[v.id] = nil end
                if BWOZombie.CacheLightZ then BWOZombie.CacheLightZ[v.id] = nil end
            end
        end
    end

    -- MP sync: transmit only the clusters we touched.
    if removed > 0 and TransmitBanditClusterExpicit then
        for c, _ in pairs(touched) do
            TransmitBanditClusterExpicit(c)
        end
    end

    return removed
end

local function pickDensityPlayer()
    local players = BWOUtils.GetAllPlayers()
    if not players or #players == 0 then return nil end
    return BanditUtils.Choice(players)
end

local function getDensityForPlayer(player)
    local density = 1
    if BWOBuildings and BWOBuildings.GetDensityScore and player then
        density = BWOBuildings.GetDensityScore(player, 120) / 8000
    end
    if density > 2.2 then density = 2.2 end
    return density
end

local function streetsController(targetCnt)
    if not isServer() then return end
    local player = pickDensityPlayer()
    if not player then return end

    local density = getDensityForPlayer(player)
    local hourmod = getHourScore and getHourScore() or 1
    local target = targetCnt * density * hourmod

    local programs = {"Walker", "Runner", "Patrol", "Postal", "Gardener", "Janitor", "Entertainer", "Vandal"}
    local current = (BWOUtils.CountBanditByProgram and BWOUtils.CountBanditByProgram(programs)) or countTable(BWOUtils.GetAllBanditByProgram(programs))

    local missing = target - current
    if missing > 20 then missing = 20 end

    statsRemember("street", { target = target, current = current, missing = missing })

    if missing >= 1 then
        BWOPopControl.StreetsSpawn(missing)
    elseif missing < 0 then
        BWOPopControl.StreetsDespawn(-missing)
    end
end

local function inhabitantsController(targetCnt)
    if not isServer() then return end
    local player = pickDensityPlayer()
    if not player then return end

    local density = getDensityForPlayer(player)

    local target = targetCnt * density

    local current = (BWOUtils.CountBanditByProgram and BWOUtils.CountBanditByProgram({"Inhabitant"})) or countTable(BWOUtils.GetAllBanditByProgram({"Inhabitant"}))

    local missing = target - current
    if missing > 20 then missing = 20 end

    statsRemember("inhabitant", { target = target, current = current, missing = missing })

    if missing >= 1 then
        BWOPopControl.InhabitantsSpawn(missing)
    elseif missing < 0 then
        BWOPopControl.InhabitantsDespawn(-missing)
    end
end

local function survivorsController(targetCnt)
    if not isServer() then return end

    local target = targetCnt
    local current = (BWOUtils.CountBanditByProgram and BWOUtils.CountBanditByProgram({"Survivor"})) or countTable(BWOUtils.GetAllBanditByProgram({"Survivor"}))

    local missing = target - current
    if missing > 4 then missing = 4 end

    statsRemember("survivor", { target = target, current = current, missing = missing })

    if missing >= 1 then
        BWOPopControl.SurvivorsSpawn(missing)
    elseif missing < 0 then
        BWOPopControl.SurvivorsDespawn(-missing)
    end
end

BWOPopControl.population = {
    zombie = {
        periods = {
            [1] = {start=0, endt=24, cnt=0}, -- 110
            [2] = {start=24, endt=48, cnt=1}, -- 8
            [3] = {start=48, endt=72, cnt=2}, -- 3
            [4] = {start=72, endt=96, cnt=3}, -- 2
            [5] = {start=96, endt=110, cnt=5}, -- 1
            [6] = {start=110, endt=134, cnt=8},
            [7] = {start=134, endt=182, cnt=13},
            [8] = {start=182, endt=100000, cnt=1000},
        },
        control = zombieController
    },
    inhabitant = {
        periods = {
            [1] = {start=0, endt=24, cnt=75},
            [2] = {start=24, endt=48, cnt=50},
            [3] = {start=48, endt=72, cnt=40},
            [4] = {start=72, endt=96, cnt=30},
            [5] = {start=96, endt=110, cnt=15},
            [6] = {start=110, endt=134, cnt=15},
            [7] = {start=134, endt=182, cnt=4},
            [8] = {start=182, endt=100000, cnt=0},
        },
        control = inhabitantsController
    },
    street = {
        periods = {
            [1] = {start=0, endt=24, cnt=46},
            [2] = {start=24, endt=48, cnt=53},
            [3] = {start=48, endt=72, cnt=56},
            [4] = {start=72, endt=96, cnt=59},
            [5] = {start=96, endt=110, cnt=62},
            [6] = {start=110, endt=134, cnt=55},
            [7] = {start=134, endt=182, cnt=1},
            [8] = {start=182, endt=100000, cnt=0},
        },
        control = streetsController
    },
    survivor = {
        periods = {
            [1] = {start=0, endt=24, cnt=0},
            [2] = {start=24, endt=48, cnt=2},
            [3] = {start=48, endt=72, cnt=3},
            [4] = {start=72, endt=96, cnt=5},
            [5] = {start=96, endt=110, cnt=8},
            [6] = {start=110, endt=134, cnt=6},
            [7] = {start=134, endt=100000, cnt=0},
        },
        control = survivorsController
    }
}

local function getGroupCount(group, worldAge)
    local periods = BWOPopControl.population[group].periods
    for i = 1, #periods do
        local period = periods[i]
        if worldAge >= period.start and worldAge < period.endt then
            return period.cnt
        end
    end
    return nil
end


-- server-only wrapper that picks a server-side player and spawns nearby
BWOPopControl.StreetsSpawn = function(cnt)
    if not isServer() then return end
    local players = BWOUtils.GetAllPlayers()
    if #players == 0 then return end
    cnt = cnt or 1

    local player = BanditUtils.Choice(players)
    if not player then return end

    local cell = player:getCell()
    if not cell then return end

    local cm = getWorld():getClimateManager()
    local rainIntensity = cm and cm:getRainIntensity() or 0
    local px, py = player:getX(), player:getY()

    local args = { size = 1 }
    local spawned = 0

    for i = 1, cnt do
        local x = 35 + ZombRand(25)
        local y = 35 + ZombRand(25)

        if ZombRand(2) == 1 then x = -x end
        if ZombRand(2) == 1 then y = -y end

        local square = cell:getGridSquare(px + x, py + y, 0)
        if square and square:isOutside() and not BWOSquareLoader.IsInExclusion(square:getX(), square:getY()) then
            args.x = square:getX()
            args.y = square:getY()
            args.z = square:getZ()

            local zombieType = ItemPickerJava.getSquareZombiesType(square)
            if zombieType and zombieType == "Army" then
                args.cid = Bandit.clanMap.ArmyGreen
                args.program = "Patrol"
            else
                local rnd = ZombRand(100)
                if rnd < 4 then
                    args.cid = Bandit.clanMap.Runner
                    args.program = "Runner"
                elseif rnd < 8 then
                    args.cid = Bandit.clanMap.Postal
                    args.program = "Postal"
                elseif rnd < 13 then
                    args.cid = Bandit.clanMap.Gardener
                    args.program = "Gardener"
                elseif rnd < 16 then
                    args.cid = Bandit.clanMap.Janitor
                    args.program = "Janitor"
                elseif rnd < 17 then
                    args.cid = Bandit.clanMap.Vandal
                    args.program = "Vandal"
                else
                    if rainIntensity > 0.02 then
                        args.cid = Bandit.clanMap.Walker
                    else
                        args.cid = Bandit.clanMap.WalkerRain
                    end
                    args.program = "Walker"
                end
            end

            BanditServer.Spawner.Clan(player, args)
            spawned = spawned + 1
        end
    end

    if spawned > 0 then
        statsInc("street", "spawnedTotal", spawned)
        statsInc("street", "spawnedInterval", spawned)
    end
end


BWOPopControl.StreetsDespawn = function(cnt)
    if not isServer() then return end
    local players = BWOUtils.GetAllPlayers()
    if #players == 0 then return end
    cnt = cnt or 1

    local removePrg = {"Walker", "Runner", "Postal", "Entertainer", "Janitor", "Medic", "Gardener", "Vandal"}
    local zombieList = BWOUtils.GetAllBanditByProgram(removePrg)
    local removed = 0
    for _, zombie in pairs(zombieList) do
        if removed >= cnt then break end

        local zx = zombie.x
        local zy = zombie.y

        if type(zx) == "number" and type(zy) == "number" then
            -- despawn only if bandit is further than 50 from ALL players
            local nearAnyPlayer = false
            for _, player in pairs(players) do
                local px, py = player:getX(), player:getY()
                local dist = BanditUtils.DistTo(px, py, zx, zy)
                if dist <= 50 then
                    nearAnyPlayer = true
                    break
                end
            end

            if not nearAnyPlayer then
                local zid = zombie.id
                local zombieObj = BWOZombie.GetInstanceById(zid)
                if zombieObj then
                    zombieObj:removeFromSquare()
                    zombieObj:removeFromWorld()
                    -- notify all clients (need a player connection for sendServerCommand)
                    for _, player in pairs(players) do
                        sendServerCommand(player, 'Commands', 'BanditRemove', { id = zid, x = zx, y = zy, z = zombieObj:getZ() })
                    end
                end

                -- cleanup caches/mod data
                BWOZombie.CacheLightZ[zid] = nil
                local gmd = GetBanditClusterData(zid)
                if gmd and gmd[zid] then gmd[zid] = nil end

                removed = removed + 1
            end
        end
    end

    -- If we still need to despawn but none are loaded (or not enough),
    -- prune stale BanditClusters entries for these programs.
    if removed < cnt then
        local extra = trimClustersByProgram(removePrg, (cnt - removed))
        removed = removed + extra
    end

    if removed > 0 then
        statsInc("street", "despawnedTotal", removed)
        statsInc("street", "despawnedInterval", removed)
    end
end

-- server-side inhabitants spawner (ported from client, no client commands)
BWOPopControl.InhabitantsSpawn = function(max)
    if not isServer() then return end
    local players = BWOUtils.GetAllPlayers()
    if #players == 0 then return end

    max = max or 0
    local player = BanditUtils.Choice(players)
    if not player then return end

    local cell = player:getCell()
    if not cell then return end

    local px, py = player:getX(), player:getY()
    local rooms = cell:getRoomList()
    local banditList = BWOZombie.CacheLightB or {}

    local cursor = 0
    local roomPool = {}

    for i = 0, rooms:size() - 1 do
        local room = rooms:get(i)
        local def = room:getRoomDef()

        if def then
            local building = room:getBuilding()
            local buildingDef = building and building:getDef()
            if buildingDef then buildingDef:setAlarmed(false) end

            if building and not BWOBuildings.IsEventBuilding(building, "home") then
                local bx1, bx2 = def:getX(), def:getX2()
                local by1, by2 = def:getY(), def:getY2()
                local bz = def:getZ()
                local sd = 15
                local md = 90

                if (px < bx1 - sd or px > bx2 + sd) and (py < by1 - sd or py > by2 + sd)
                    and (px > bx1 - md or px < bx2 + md) and (py > by1 - md or py < by2 + md) then

                    local roomData = BWORooms.Get(room)
                    if roomData then
                        local spawnSquare = def:getFreeSquare()
                        if spawnSquare and not spawnSquare:getZombie() and not spawnSquare:isOutside() then

                            local rid = def:getIDString()
                            local sx, sy, sz = spawnSquare:getX(), spawnSquare:getY(), spawnSquare:getZ()

                            local occupantsRequiredGeneric = 0
                            local occupantsRequiredSpecial = 0
                            local occupantsRequiredBandit = 0

                            if roomData.cids and bz >= 0 then
                                local occupantsRequiredTotal = BWORooms.GetRoomMaxPop(room)

                                if roomData.cidSpecial then
                                    for _ in pairs(roomData.cidSpecial) do
                                        occupantsRequiredSpecial = occupantsRequiredSpecial + 1
                                    end
                                end

                                occupantsRequiredGeneric = occupantsRequiredTotal - occupantsRequiredSpecial
                            end

                            if roomData.cidBandit and bz < 0 and BWOScheduler.NPC.Run then
                                occupantsRequiredBandit = BWORooms.GetRoomMaxPop(room)
                            end

                            local occupantsPresentGeneric = 0
                            local occupantsPresentSpecial = 0
                            local occupantsPresentBandit = 0

                            if occupantsRequiredGeneric > 0 or occupantsRequiredSpecial > 0 or occupantsRequiredBandit > 0 then
                                for _, otherBandit in pairs(banditList) do
                                    if rid == otherBandit.rid then
                                        if occupantsRequiredGeneric > 0 then
                                            for _, cid in pairs(roomData.cids) do
                                                if cid == otherBandit.brain.cid then
                                                    occupantsPresentGeneric = occupantsPresentGeneric + 1
                                                    break
                                                end
                                            end
                                        end

                                        if occupantsRequiredSpecial > 0 then
                                            for _, cid in pairs(roomData.cidSpecial) do
                                                if cid == otherBandit.brain.cid then
                                                    occupantsPresentSpecial = occupantsPresentSpecial + 1
                                                    break
                                                end
                                            end
                                        end

                                        if occupantsRequiredBandit > 0 then
                                            for _, cid in pairs(roomData.cidBandit) do
                                                if cid == otherBandit.brain.cid then
                                                    occupantsPresentBandit = occupantsPresentBandit + 1
                                                    break
                                                end
                                            end
                                        end
                                    end
                                end
                            end

                            local occupantsSpawnSpecial = occupantsRequiredSpecial - occupantsPresentSpecial
                            if occupantsSpawnSpecial > 0 then
                                local cid = BanditUtils.Choice(roomData.cidSpecial)
                                local roomSize = BWORooms.GetRoomSize(room)
                                local cursorStart = cursor
                                cursor = cursor + math.floor(roomSize ^ 1.2)
                                table.insert(roomPool, {room=room, x=sx, y=sy, z=sz, cid = cid, cursorStart=cursorStart, cursorEnd=cursor})
                            end

                            local occupantsSpawnGeneric = occupantsRequiredGeneric - occupantsPresentGeneric
                            if occupantsSpawnGeneric > 0 then
                                local cid = BanditUtils.Choice(roomData.cids)
                                local roomSize = BWORooms.GetRoomSize(room)
                                local cursorStart = cursor
                                cursor = cursor + math.floor(roomSize ^ 1.2)
                                table.insert(roomPool, {room=room, x=sx, y=sy, z=sz, cid = cid, cursorStart=cursorStart, cursorEnd=cursor})
                            end

                            local occupantsSpawnBandit = occupantsRequiredBandit - occupantsPresentBandit
                            if occupantsSpawnBandit > 0 then
                                local cid = BanditUtils.Choice(roomData.cidBandit)
                                local roomSize = BWORooms.GetRoomSize(room)
                                local cursorStart = cursor
                                cursor = cursor + math.floor(roomSize ^ 1.2)
                                table.insert(roomPool, {room=room, x=sx, y=sy, z=sz, cid = cid, cursorStart=cursorStart, cursorEnd=cursor})
                            end
                        end
                    end
                end
            end
        end
    end

    -- Fisher-Yates shuffle
    for i = #roomPool, 2, -1 do
        local j = ZombRand(i) + 1
        roomPool[i], roomPool[j] = roomPool[j], roomPool[i]
    end

    local i = 0
    for _, rp in pairs(roomPool) do
        local args = {
            size = 1,
            program = "Inhabitant",
            x = rp.x,
            y = rp.y,
            z = rp.z,
            cid = rp.cid
        }
        BanditServer.Spawner.Clan(player, args)

        i = i + 1
        if i > max then break end
    end

    if i > 0 then
        statsInc("inhabitant", "spawnedTotal", i)
        statsInc("inhabitant", "spawnedInterval", i)
    end
end

-- server-side inhabitants despawner
BWOPopControl.InhabitantsDespawn = function(cnt)
    if not isServer() then return end
    local players = BWOUtils.GetAllPlayers()
    if #players == 0 then return end
    cnt = cnt or 1
    local removePrg = {"Inhabitant"}
    local zombieList = BWOUtils.GetAllBanditByProgram(removePrg)

    local i = 0
    for _, zombie in pairs(zombieList) do
        if i >= cnt then break end

        local zx = zombie.x
        local zy = zombie.y

        if type(zx) == "number" and type(zy) == "number" then
            -- despawn only if bandit is further than 50 from ALL players
            local nearAnyPlayer = false
            for _, player in pairs(players) do
                local px, py = player:getX(), player:getY()
                local dist = BanditUtils.DistTo(px, py, zx, zy)
                if dist <= 50 then
                    nearAnyPlayer = true
                    break
                end
            end

            if not nearAnyPlayer then
                local zid = zombie.id
                local zombieObj = BWOZombie.GetInstanceById(zid)
                if zombieObj then
                    zombieObj:removeFromSquare()
                    zombieObj:removeFromWorld()
                end

                -- keep server state in sync
                for _, player in pairs(players) do
                    sendServerCommand(player, 'Commands', 'BanditRemove', { id = zid, x = zx, y = zy, z = zombieObj and zombieObj:getZ() or 0 })
                end
                -- cleanup caches/mod data
                BWOZombie.CacheLightZ[zid] = nil
                local gmd = GetBanditClusterData(zid)
                if gmd and gmd[zid] then gmd[zid] = nil end

                i = i + 1
            end
        end
    end

    -- If we still need to despawn but none are loaded (or not enough),
    -- prune stale BanditClusters entries for this program.
    if i < cnt then
        local extra = trimClustersByProgram(removePrg, (cnt - i))
        i = i + extra
    end

    if i > 0 then
        statsInc("inhabitant", "despawnedTotal", i)
        statsInc("inhabitant", "despawnedInterval", i)
    end
end

-- server-side survivors spawner
BWOPopControl.SurvivorsSpawn = function(cnt)
    if not isServer() then return end
    local players = BWOUtils.GetAllPlayers()
    if #players == 0 then return end
    cnt = cnt or 1

    local player = BanditUtils.Choice(players)
    if not player then return end

    local cell = player:getCell()
    if not cell then return end

    local px, py = player:getX(), player:getY()

    local args = {
        cid = Bandit.clanMap.Survivor,
        size = 1,
        program = "Survivor"
    }

    local gmd = BWOGMD.Get()
    
    local spawned = 0

    for i = 1, cnt do
        local x = 35 + ZombRand(25)
        local y = 35 + ZombRand(25)
        
        if ZombRand(2) == 1 then x = -x end
        if ZombRand(2) == 1 then y = -y end

        local square = cell:getGridSquare(px + x, py + y, 0)
        if square and square:isOutside() and not BWOSquareLoader.IsInExclusion(square:getX(), square:getY()) then
            args.x = square:getX()
            args.y = square:getY()
            args.z = square:getZ()

            BanditServer.Spawner.Clan(player, args)
            spawned = spawned + 1
        end
    end

    if spawned > 0 then
        statsInc("survivor", "spawnedTotal", spawned)
        statsInc("survivor", "spawnedInterval", spawned)
    end
end

-- server-side survivors despawner
BWOPopControl.SurvivorsDespawn = function(cnt)
    if not isServer() then return end
    local players = BWOUtils.GetAllPlayers()
    if #players == 0 then return end
    cnt = cnt or 1

    local removePrg = {"Survivor"}
    local zombieList = BWOUtils.GetAllBanditByProgram(removePrg)

    local i = 0
    for _, zombie in pairs(zombieList) do
        if i >= cnt then break end

        local zx = zombie.x
        local zy = zombie.y

        if type(zx) == "number" and type(zy) == "number" then
            -- despawn only if bandit is further than 50 from ALL players
            local nearAnyPlayer = false
            for _, player in pairs(players) do
                local px, py = player:getX(), player:getY()
                local dist = BanditUtils.DistTo(px, py, zx, zy)
                if dist <= 50 then
                    nearAnyPlayer = true
                    break
                end
            end

            if not nearAnyPlayer then
                local zid = zombie.id
                local zombieObj = BWOZombie.GetInstanceById(zid)
                if zombieObj then
                    zombieObj:removeFromSquare()
                    zombieObj:removeFromWorld()
                end

                -- keep server state in sync
                for _, player in pairs(players) do
                    sendServerCommand(player, 'Commands', 'BanditRemove', { id = zid, x = zx, y = zy, z = zombieObj and zombieObj:getZ() or 0 })
                end
                -- cleanup caches/mod data
                BWOZombie.CacheLightZ[zid] = nil
                local gmd = GetBanditClusterData(zid)
                if gmd and gmd[zid] then gmd[zid] = nil end

                i = i + 1
            end
        end
    end

    -- If we still need to despawn but none are loaded (or not enough),
    -- prune stale BanditClusters entries for this program.
    if i < cnt then
        local extra = trimClustersByProgram(removePrg, (cnt - i))
        i = i + extra
    end

    if i > 0 then
        statsInc("survivor", "despawnedTotal", i)
        statsInc("survivor", "despawnedInterval", i)
    end
end

local onTick = function(numTicks)
    if numTicks % 4 > 0 then return end
    if not isServer() then return end

    local worldAge = BWOUtils.GetWorldAge() 
    local population = BWOPopControl.population
    for group, data in pairs(population) do
        if data.periods and data.control then
            local targetCnt = getGroupCount(group, worldAge)
            if targetCnt then
                data.control(targetCnt)
            end
        end
    end
end

local function loadBanditOptions(cid)
    local bandits = {}
    local options = BanditCustom.GetFromClan(cid)
    for bid, option in pairs(options) do
        -- enrich
        option.bid = bid
        table.insert(bandits, option)
    end

    return bandits
end

-- server-side population adjuster (Week scenario only, MP safe)
local function getHourScore()
    local hmap = {
        [0] = 0.20, [1] = 0.15, [2] = 0.10, [3] = 0.05, [4] = 0.05,
        [5] = 0.35, [6] = 0.85, [7] = 1.20, [8] = 1.20, [9] = 1.00,
        [10] = 1.00, [11] = 0.80, [12] = 0.80, [13] = 0.80, [14] = 0.80,
        [15] = 1.00, [16] = 1.20, [17] = 1.20, [18] = 1.00, [19] = 1.00,
        [20] = 1.00, [21] = 0.90, [22] = 0.70, [23] = 0.40,
    }
    local gameTime = getGameTime()
    local hour = gameTime and gameTime:getHour() or 12
    return hmap[hour] or 1
end

local function pickServerPlayer()
    local players = BWOUtils.GetAllPlayers()
    if not players or #players == 0 then return nil end
    return BanditUtils.Choice(players)
end


-- converts zeds into npcs
local function everyOneMinute()
    
    if not isServer() then return end
    refreshScenarioFromGMD()
    -- print ("[POP CONTROL][INFO] INIT ")

    if BWOPopControl.Scenario ~= "DOne" then return end
    local worldAge = BWOUtils.GetWorldAge() 
    local cell = getCell()
    local zombieList = cell:getZombieList()
    local zombieListSize = zombieList:size()

    local clusters = {}
    for i=0, BanditClusterCount-1 do
        clusters[i] = false
    end

    dprint ("[POP CONTROL][INFO] ZOMBIES: " .. zombieListSize, 3)
    for i = 0, zombieListSize - 1 do
        local zombie = zombieList:get(i)
        
        local rnd = ZombRand(100)
        if rnd > BWOPopControl.zombiePercent and not zombie:getModData().skip then

            local id = BanditUtils.GetCharacterID(zombie)
            local gmd = GetBanditClusterData(id)
            local c = GetBanditCluster(id)
            if not gmd[id] then
                
                -- this forces the reclothing so that server knows the outfit
                zombie:dressInPersistentOutfitID(id)

                zombie:getModData().brainId = id

                local outfitName = zombie:getOutfitName()
                if not outfitName then
                    dprint ("[POPCONTROL][ERR] MISSING OUTFIT!", 1)
                    outfitName = "Generic01"
                end
                
                local outfitData = Bandit.outfit2clan[outfitName]
                if not outfitData then
                    dprint ("[POPCONTROL][WARN] MISSING OUTFIT MAPPING: " .. tostring(outfitName), 2)
                    outfitData = {cid = Bandit.clanMap.Walker}
                end

                if outfitData.cid then

                    local bandit = BanditUtils.Choice(loadBanditOptions(outfitData.cid))
                    local brain = {}

                    dprint ("[POPCONTROL][INFO] CONVERTING, OUTFIT: " .. tostring(outfitName) .. ", CID: " .. outfitData.cid, 3)

                    -- auto-generated properties 
                    brain.id = id
                    brain.inVehicle = false
                    brain.fullname = BanditNames.GenerateName(zombie:isFemale())

                    brain.born = getGameTime():getWorldAgeHours()
                    brain.bornCoords = {}
                    brain.bornCoords.x = zombie:getX()
                    brain.bornCoords.y = zombie:getY()
                    brain.bornCoords.z = zombie:getZ()

                    brain.stationary = false
                    brain.sleeping = false
                    brain.aiming = false
                    brain.moving = false
                    brain.endurance = 1.00
                    brain.speech = 0.00
                    brain.sound = 0.00
                    brain.infection = 0

                    -- properties taken from bandit custom profile
                    local general = bandit.general
                    brain.clan = general.cid
                    brain.cid = general.cid
                    brain.bid = general.bid
                    brain.female = general.female or false
                    zombie:setFemaleEtc(general.female)
                    brain.skin = general.skin or 1
                    brain.hairType = general.hairType or 1
                    brain.hairColor = general.hairColor or 1
                    brain.beardType = general.beardType or 1
                    brain.eatBody = false

                    local health = general.health or 5
                    brain.health = BanditUtils.Lerp(health, 1, 9, 1, 2.6)

                    local accuracyBoost = general.sight or 5
                    brain.accuracyBoost = BanditUtils.Lerp(accuracyBoost, 1, 9, -8, 8)

                    local enduranceBoost = general.endurance or 5
                    brain.enduranceBoost = BanditUtils.Lerp(enduranceBoost, 1, 9, 0.25, 1.75)

                    local strengthBoost = general.strength or 5
                    brain.strengthBoost = BanditUtils.Lerp(strengthBoost, 1, 9, 0.25, 1.75)

                    brain.exp = {0, 0, 0}
                    if general.exp1 and general.exp2 and general.exp3 then
                        brain.exp = {general.exp1, general.exp2, general.exp3}
                    end

                    brain.weapons = {}
                    brain.weapons.melee = "Base.BareHands"
                    brain.weapons.primary = {["bulletsLeft"] = 0, ["magCount"] = 0}
                    brain.weapons.secondary = {["bulletsLeft"] = 0, ["magCount"] = 0}

                    if bandit.weapons then
                        if bandit.weapons.melee then
                            brain.weapons.melee = BanditCompatibility.GetLegacyItem(bandit.weapons.melee)
                        end
                        for _, slot in pairs({"primary", "secondary"}) do
                            brain.weapons[slot].bulletsLeft = 0
                            brain.weapons[slot].magCount = 0
                            if bandit.weapons[slot] and bandit.ammo[slot] then
                                brain.weapons[slot] = BanditWeapons.Make(bandit.weapons[slot], bandit.ammo[slot])
                            end
                        end
                    end

                    brain.clothing = bandit.clothing or {}
                    brain.tint = bandit.tint or {}
                    brain.bag = bandit.bag

                    brain.loot = {}
                    brain.inventory = {}
                    brain.tasks = {}

                    -- bandit differentiators
                    -- 1 - symptoms [0 - no, 1 - yes]
                    -- 2 - character [0,1 - panic, 2 - cry, 3,4 - hide, 5,6 - courage]
                    brain.rnd = {ZombRand(2), ZombRand(10), ZombRand(100), ZombRand(1000), ZombRand(10000)}

                    brain.personality = {}

                    -- addiction and sickness
                    brain.personality.alcoholic = (ZombRand(50) == 0)
                    brain.personality.smoker = (ZombRand(4) == 0)
                    brain.personality.compulsiveCleaner = (ZombRand(90) == 0)

                    -- collectors
                    brain.personality.comicsCollector = (ZombRand(80) == 0)
                    brain.personality.gameCollector = (ZombRand(220) == 0)
                    brain.personality.hottieCollector = (ZombRand(100) == 0)
                    brain.personality.toyCollector = (ZombRand(220) == 0)
                    brain.personality.videoCollector = (ZombRand(220) == 0)
                    brain.personality.underwearCollector = (ZombRand(150) == 0)

                    -- heritage
                    brain.personality.fromPoland = (ZombRand(120) == 0) -- ku chwale ojczyzny!

                    brain.hostile = false
                    brain.hostileP = false

                    brain.program = {}
                    brain.program.name = "Civilian"
                    brain.program.stage = "Prepare"
                    brain.programFallback = brain.program

                    -- bwo uses it
                    brain.occupation = ""
                    brain.loyal = false

                    brain.master = 0
                    brain.permanent = false
                    brain.key = nil

                    brain.voice = Bandit.PickVoice(zombie)

                    Bandit.ApplyVisuals(zombie, brain)

                    -- ready!
                    gmd[id] = brain
                    clusters[c] = true
                    
                    dprint ("[POP CONTROL][INFO] ZOMBIE " .. id .. " BANDITIZED.", 3)
                else
                    dprint ("[POP CONTROL][ERR] WRONG CID MAPPING FOR OUTFIT " .. outfitName, 1)
                end
            else
                -- dprint ("[POP CONTROL][INFO] ZOMBIE" .. id .. " IS ALREADY A BANDIT.", 3)
            end
        else
            zombie:getModData().skip = true
        end
    end

    for i=0, BanditClusterCount-1 do
        if clusters[i] then
            dprint ("[POP CONTROL][INFO] TRANSMIT CLUSTER" .. i, 3)
            TransmitBanditClusterExpicit(i)
        end
    end
end

Events.OnTick.Remove(onTick)
Events.OnTick.Add(onTick)

Events.EveryOneMinute.Remove(everyOneMinute)
Events.EveryOneMinute.Add(everyOneMinute)

-- periodic summary log for spawn/despawn counters (every 10 ticks)
Events.OnTick.Remove(logStatsEvery10Ticks)
Events.OnTick.Add(logStatsEvery10Ticks)