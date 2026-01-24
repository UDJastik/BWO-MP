require "BWOUtils"
require "BWOGMD"
require "BWOServerEvents"
require "Scenarios/SDayOne"
require "Scenarios/SWeek"
require "BWODebug"

-- central event manager (replaces legacy BWOScheduler)
BWOEventManager = BWOEventManager or BWOEventGenerator or {}
BWOEventGenerator = BWOEventManager
BWOScheduler = BWOScheduler or BWOEventManager -- compatibility bridge

-- scheduler-style shared state
BWOEventManager.Events = BWOEventManager.Events or {}
BWOEventManager.SymptomLevel = BWOEventManager.SymptomLevel or 0
BWOEventManager.WorldAge = BWOEventManager.WorldAge or 0
BWOEventManager.World = BWOEventManager.World or {}
BWOEventManager.NPC = BWOEventManager.NPC or {}
BWOEventManager.Anarchy = BWOEventManager.Anarchy or {}

local waShiftMap = BWOEventManager.waShiftMap or {}
if #waShiftMap == 0 then
    table.insert(waShiftMap, 0) -- week before
    table.insert(waShiftMap, 168) -- 2 weeks before
    table.insert(waShiftMap, 504) -- 4 weeks before
    table.insert(waShiftMap, 1848) -- 12 weeks before
    table.insert(waShiftMap, 8760) -- year before
    table.insert(waShiftMap, 87432) -- 10 years before
end
BWOEventManager.waShiftMap = waShiftMap

-- the main architecture of week one multiplayer events

-- список доступных сценариев
local availableScenarios = {"DayOne", "Week"}

-- сценарий будет инициализирован после выбора
local scenario = nil
local scenarioName = nil

-- a queue of single events to be fired (shared across scheduler + scenario flows)

-- adds a set of individual events to the queue from the sequence
local function addSequence(sequence)
    dprint("[EVENT_MANAGER][INFO] ADDING SEQUENCE, EVENT NUMBER: " .. #sequence, 3)
    for _, eventConf in ipairs(sequence) do
        local event = eventConf[1]
        local eventDelay = eventConf[2]

        local eventTimed = {
            event,
            BWOUtils.GetTime() + eventDelay
        }
        dprint("[EVENT_MANAGER][INFO] ADDING EVENT: " .. event[1], 3)
        table.insert(BWOEventManager.Events, eventTimed)
    end
end

-- reads the schedule to see if it's the right moment to manage a sequence
local function sequenceProcessor()
    if not scenario then return end
    
    local gametime = getGameTime()
    local minute = gametime:getMinutes()
    local worldAge = BWOUtils.GetWorldAge()
    local schedule = scenario:getSchedule()
    dprint("[EVENT_MANAGER][INFO] SCHEDULE LOOKUP FOR: [" .. worldAge .. "][" .. minute .. "]", 3)

    if schedule[worldAge] and schedule[worldAge][minute] then
        local sequence = schedule[worldAge][minute]
        addSequence(sequence)
    end
end

-- server-side executor for all queued timed events (sequences + ad-hoc adds)
local function eventProcessor(ticks)
    if not isServer() then return end

    -- light throttling to avoid spikes
    if ticks and ticks % 5 ~= 0 then return end

    if not BWOEventManager.Events or #BWOEventManager.Events == 0 then return end

    for i, eventTimed in ipairs(BWOEventManager.Events) do
        local currentTime = BWOUtils.GetTime()
        local event = eventTimed[1]
        local eventTime = eventTimed[2]

        if eventTime < currentTime then
            local eventFunction = event[1]
            local eventParams = event[2] or {}
            if eventFunction then
                dprint("[EVENT_MANAGER][INFO] EVENT FUNCTION: " .. eventFunction, 3)
                if BWOServerEvents[eventFunction] then
                    dprint("[EVENT_MANAGER][INFO] EXECUTING EVENT", 3)
                    BWOServerEvents[eventFunction](eventParams)
                else
                    dprint("[EVENT_MANAGER][ERR] NO SUCH EVENT!", 1)
                end
            end
            table.remove(BWOEventManager.Events, i)
            break -- deliberately consuming only one event at a time to avoid spikes
        end
    end

end

-- legacy scheduler logic moved into EventManager
local function generateSchedule()
    local gmd = BWOGMD.Get()
    local variant = gmd.Variant

    return BWOVariants[variant].schedule
end

function BWOEventManager.StoreSandboxVars()
    local gmd = BWOGMD.Get()
    local orig = gmd.Sandbox

    local storeVars = {
        "KeyLootNew", "MaximumLooted", "FoodLootNew", "CannedFoodLootNew", "LiteratureLootNew", "SurvivalGearsLootNew",
        "MedicalLootNew", "WeaponLootNew", "RangedWeaponLootNew", "AmmoLootNew", "MechanicsLootNew",
        "OtherLootNew", "ClothingLootNew", "ContainerLootNew", "MementoLootNew", "MediaLootNew",
        "CookwareLootNew", "MaterialLootNew", "FarmingLootNew", "ToolLootNew", "MaximumRatIndex",
        "SurvivorHouseChance", "VehicleStoryChance", "MetaEvent", "LockedHouses", "ZoneStoryChance", "AnnotatedMapChance",
        "MaxFogIntensity", "TrafficJam", "CarSpawnRate", "Helicopter", "FireSpread", "ZombieConfig.PopulationMultiplier"
    }

    for _, k in pairs(storeVars) do
        gmd.Sandbox[k] = gmd.Sandbox[k] or SandboxVars[k]
    end
end

function BWOEventManager.RestoreRepeatingPlaceEvents()

    local addPlaceEvent = function(args)
        BWOServer.Commands.PlaceEventAdd(args)
    end

    -- building emitters
    addPlaceEvent({phase="Emitter", x=13458, y=3043, z=0, len=110000, sound="ZSBuildingGigamart"}) -- gigamart lousville 
    addPlaceEvent({phase="Emitter", x=6505, y=5345, z=0, len=110000, sound="ZSBuildingGigamart"}) -- gigamart riverside
    addPlaceEvent({phase="Emitter", x=12024, y=6856, z=0, len=110000, sound="ZSBuildingGigamart"}) -- gigamart westpoint

    addPlaceEvent({phase="Emitter", x=6472, y=5266, z=0, len=42000, sound="ZSBuildingPharmabug"}) -- pharmabug riverside
    addPlaceEvent({phase="Emitter", x=13235, y=1284, z=0, len=42000, sound="ZSBuildingPharmabug"}) -- pharmabug lv
    addPlaceEvent({phase="Emitter", x=13120, y=2126, z=0, len=42000, sound="ZSBuildingPharmabug"}) -- pharmabug lv
    addPlaceEvent({phase="Emitter", x=11932, y=6804, z=0, len=42000, sound="ZSBuildingPharmabug"}) -- pharmabug westpoint

    addPlaceEvent({phase="Emitter", x=12228, y=3029, z=0, len=62000, sound="ZSBuildingZippee"}) -- zippee market lv
    addPlaceEvent({phase="Emitter", x=12998, y=3115, z=0, len=62000, sound="ZSBuildingZippee"}) -- zippee market lv
    addPlaceEvent({phase="Emitter", x=13065, y=1923, z=0, len=62000, sound="ZSBuildingZippee"}) -- zippee market lv
    addPlaceEvent({phase="Emitter", x=12660, y=1366, z=0, len=62000, sound="ZSBuildingZippee"}) -- zippee market lv
    addPlaceEvent({phase="Emitter", x=13523, y=1670, z=0, len=62000, sound="ZSBuildingZippee"}) -- zippee market lv
    addPlaceEvent({phase="Emitter", x=12520, y=1482, z=0, len=62000, sound="ZSBuildingZippee"}) -- zippee market lv
    addPlaceEvent({phase="Emitter", x=12646, y=2290, z=0, len=62000, sound="ZSBuildingZippee"}) -- zippee market lv
    addPlaceEvent({phase="Emitter", x=10604, y=9612, z=0, len=62000, sound="ZSBuildingZippee"}) -- zippee market muldraugh
    addPlaceEvent({phase="Emitter", x=8088, y=11560, z=0, len=62000, sound="ZSBuildingZippee"}) -- zippee market rosewood
    addPlaceEvent({phase="Emitter", x=13656, y=5764, z=0, len=62000, sound="ZSBuildingZippee"}) -- zippee market valley station
    addPlaceEvent({phase="Emitter", x=11660, y=7067, z=0, len=62000, sound="ZSBuildingZippee"}) -- zippee market west point

    addPlaceEvent({phase="Emitter", x=10619, y=10527, z=0, len=73700, sound="ZSBuildingRestaurant"}) -- restaurant muldraugh
    addPlaceEvent({phase="Emitter", x=10605, y=10112, z=0, len=73700, sound="ZSBuildingRestaurant"}) -- pizza whirled muldraugh
    addPlaceEvent({phase="Emitter", x=10647, y=9927, z=0, len=73700, sound="ZSBuildingRestaurant"}) -- cafeteria muldraugh
    addPlaceEvent({phase="Emitter", x=10615, y=9646, z=0, len=73700, sound="ZSBuildingRestaurant"}) -- spiffos muldraugh
    addPlaceEvent({phase="Emitter", x=10616, y=9565, z=0, len=73700, sound="ZSBuildingRestaurant"}) -- jays muldraugh
    addPlaceEvent({phase="Emitter", x=10620, y=9513, z=0, len=73700, sound="ZSBuildingRestaurant"}) -- pileocrepe muldraugh
    addPlaceEvent({phase="Emitter", x=12078, y=7076, z=0, len=73700, sound="ZSBuildingRestaurant"}) -- burgers westpoint
    addPlaceEvent({phase="Emitter", x=11976, y=6812, z=0, len=73700, sound="ZSBuildingRestaurant"}) -- spiffos westpoint
    addPlaceEvent({phase="Emitter", x=11930, y=6917, z=0, len=73700, sound="ZSBuildingRestaurant"}) -- restaurant westpoint
    addPlaceEvent({phase="Emitter", x=11663, y=7085, z=0, len=73700, sound="ZSBuildingRestaurant"}) -- pizza whirled westpoint
    addPlaceEvent({phase="Emitter", x=6395, y=5303, z=0, len=73700, sound="ZSBuildingRestaurant"}) -- restaurant riverside
    addPlaceEvent({phase="Emitter", x=6189, y=5338, z=0, len=73700, sound="ZSBuildingRestaurant"}) -- fancy restaurant riverside
    addPlaceEvent({phase="Emitter", x=6121, y=5303, z=0, len=73700, sound="ZSBuildingRestaurant"}) -- spiffos riverside
    addPlaceEvent({phase="Emitter", x=5422, y=5914, z=0, len=73700, sound="ZSBuildingRestaurant"}) -- diner riverside
    addPlaceEvent({phase="Emitter", x=7232, y=8202, z=0, len=73700, sound="ZSBuildingRestaurant"}) -- burger joint doe valley
    addPlaceEvent({phase="Emitter", x=10103, y=12749, z=0, len=73700, sound="ZSBuildingRestaurant"}) -- restaurant march ridge 
    addPlaceEvent({phase="Emitter", x=8076, y=11455, z=0, len=73700, sound="ZSBuildingRestaurant"}) -- restaurant rosewood
    addPlaceEvent({phase="Emitter", x=8072, y=11344, z=0, len=73700, sound="ZSBuildingRestaurant"}) -- spiffos rosewood

    -- LV strip club
    addPlaceEvent({phase="BuildingParty", x=12320, y=1279, z=0, intensity=10, roomName="stripclub"})

    -- alarm emitters (only if nukes are active)
    local gmd = BWOGMD.Get()
    local ncnt = 0
    for _, nuke in pairs(gmd.Nukes) do
        ncnt = ncnt + 1
    end

    if ncnt > 0 then
        addPlaceEvent({phase="Emitter", x=5572, y=12489, z=0, len=2460, sound="ZSBuildingBaseAlert", light={r=1, g=0, b=0, t=10}}) -- fake control room
        addPlaceEvent({phase="Emitter", x=5575, y=12473, z=0, len=2460, sound="ZSBuildingBaseAlert", light={r=1, g=0, b=0, t=10}}) -- entrance
        addPlaceEvent({phase="Emitter", x=5562, y=12464, z=0, len=2460, sound="ZSBuildingBaseAlert", light={r=1, g=0, b=0, t=10}}) -- back

        if BanditCompatibility.GetGameVersion() >= 42 then
            addPlaceEvent({phase="Emitter", x=5556, y=12446, z=-16, len=2460, sound="ZSBuildingBaseAlert", light={r=1, g=0, b=0, t=10}}) -- real control room
        end
    end
end

function BWOEventManager.MasterControl()

    local function daysInMonth(month)
        local daysPerMonth = {31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31}
        return daysPerMonth[month]
    end
    
    local function calculateHourDifference(startHour, startDay, startMonth, startYear, hour, day, month, year)
        local startTotalHours = startHour + (startDay - 1) * 24
        for m = 1, startMonth - 1 do
            startTotalHours = startTotalHours + daysInMonth(m) * 24
        end
        startTotalHours = startTotalHours + (startYear * 365 * 24) 
    
        local totalHours = hour + (day - 1) * 24
        for m = 1, month - 1 do
            totalHours = totalHours + daysInMonth(m) * 24
        end
        totalHours = totalHours + (year * 365 * 24) 
    
        return totalHours - startTotalHours
    end

    local function adjustSandboxVar(k, v)
        getSandboxOptions():set(k, v)
        SandboxVars[k] = v
    end

    getSandboxOptions():applySettings()
    ItemPickerJava.InitSandboxLootSettings()

    local gametime = getGameTime()

    local startHour = gametime:getStartTimeOfDay()
    local startDay = gametime:getStartDay()
    local startMonth = gametime:getStartMonth()
    local startYear = gametime:getStartYear()

    local hour = gametime:getHour()
    local day = gametime:getDay()
    local minute = gametime:getMinutes()
    local month = gametime:getMonth()
    local year = gametime:getYear()

    -- worldAge is counter in hours
    local worldAge = calculateHourDifference(startHour, startDay, startMonth, startYear, hour, day, month, year)

    BWOEventManager.WorldAge = worldAge
    
    -- set flags based on world age that control various aspects of the game

    -- world flags
    BWOEventManager.World = {}

    -- removes objects that conflict stylistically with prepandemic world
    BWOEventManager.World.ObjectRemover = false
    if BWOEventManager.WorldAge <= 64 then 
        BWOEventManager.World.ObjectRemover = true
    end

    -- removed initial deadbodies
    BWOEventManager.World.DeadBodyRemover = false
    if BWOEventManager.WorldAge < 48 then BWOEventManager.World.DeadBodyRemover = true end

    -- registers certain exterior objects positions that npcs can interacts with
    BWOEventManager.World.GlobalObjectAdder = false
    if BWOEventManager.WorldAge < 90 then BWOEventManager.World.GlobalObjectAdder = true end

    -- adds human corpses to simulate struggles outside of player cell
    BWOEventManager.World.DeadBodyAdderDensity = 0
    if BWOEventManager.WorldAge > 2330 then
        BWOEventManager.World.DeadBodyAdderDensity = 0
    elseif BWOEventManager.WorldAge >= 1200 then
        BWOEventManager.World.DeadBodyAdderDensity = 0.01
    elseif BWOEventManager.WorldAge >= 170 then
        BWOEventManager.World.DeadBodyAdderDensity = 0.019
    elseif BWOEventManager.WorldAge >= 150 then
        BWOEventManager.World.DeadBodyAdderDensity = 0.016
    elseif BWOEventManager.WorldAge >= 130 then
        BWOEventManager.World.DeadBodyAdderDensity = 0.012
    elseif BWOEventManager.WorldAge >= 110 then
        BWOEventManager.World.DeadBodyAdderDensity = 0.004
    end

    -- meta gunfight
    if (BWOEventManager.WorldAge >= 135 and BWOEventManager.WorldAge < 138) or (BWOEventManager.WorldAge >= 146 and BWOEventManager.WorldAge < 169) then
        for i=1, ZombRand(4) do
            BWOEventManager.Add("MetaSound", {}, i * 100)
        end
    end

    BWOEventManager.World.Bombing = 0

    -- either fixes the car or removes burned or smashed cars for prepademic world
    BWOEventManager.World.VehicleFixer = false
    if BWOEventManager.WorldAge < 90 then BWOEventManager.World.VehicleFixer = true end

    -- npc logic flags
    BWOEventManager.NPC = {}

    -- controls if npcs will react to protests events
    BWOEventManager.NPC.ReactProtests = false
    if BWOEventManager.WorldAge < 129 then BWOEventManager.NPC.ReactProtests = true end

    -- controls if npcs will react to protests events
    BWOEventManager.NPC.ReactDeadBody = false
    if BWOEventManager.WorldAge < 78 then BWOEventManager.NPC.ReactDeadBody = true end

    -- controls if npcs will react to street preachers
    BWOEventManager.NPC.ReactPreacher = false
    if BWOEventManager.WorldAge < 71 then BWOEventManager.NPC.ReactPreacher = true end

    -- controls if npcs will react to street entertainers
    BWOEventManager.NPC.ReactEntertainers = false
    if BWOEventManager.WorldAge < 65 then BWOEventManager.NPC.ReactEntertainers = true end

    -- controls if npcs will sit on exterior benches
    BWOEventManager.NPC.SitBench = false
    if BWOEventManager.WorldAge < 65 then BWOEventManager.NPC.SitBench = true end

    -- controls the period in which npc will run the atms
    BWOEventManager.NPC.BankRun = false
    if BWOEventManager.WorldAge > 67 and BWOEventManager.WorldAge < 87 then BWOEventManager.NPC.BankRun = true end

    -- controls if npcs will sit on exterior benches
    BWOEventManager.NPC.Talk = false
    if BWOEventManager.WorldAge < 58 then BWOEventManager.NPC.Talk = true end

    -- controls when npc start running instead of walking by default, also cars not stopping
    BWOEventManager.NPC.Run = false
    if BWOEventManager.WorldAge > 90 then BWOEventManager.NPC.Run = true end

    -- controls when npcbarricade their homes
    BWOEventManager.NPC.Barricade = false
    if BWOEventManager.WorldAge > 72 then BWOEventManager.NPC.Barricade = true end

    -- controls functionalities that diminish during the anarchy
    BWOEventManager.Anarchy = {}

    -- if buildings emit sounds like if they are operational (church / school)
    BWOEventManager.Anarchy.BuildingOperational = true
    if BWOEventManager.WorldAge > 72 then BWOEventManager.Anarchy.BuildingOperational = false end

    -- controls if buying and earning is still possible
    BWOEventManager.Anarchy.Transactions = true
    if BWOEventManager.WorldAge > 80 then BWOEventManager.Anarchy.Transactions = false end
    
    -- controls minor crime has consequences (breaking windows)
    BWOEventManager.Anarchy.IllegalMinorCrime = true
    if BWOEventManager.WorldAge > 110 then BWOEventManager.Anarchy.IllegalMinorCrime = false end

    -- building emmiters
    if BWOEventManager.Anarchy.BuildingOperational then

        -- church
        if hour >=6 and hour < 19 then
            if minute == 0 then
                local church = BWOBuildings.FindBuildingWithRoom("church")
                if church then
                    local def = church:getDef()
                    local x = (def:getX() + def:getX2()) / 2
                    local y = (def:getY() + def:getY2()) / 2
                    local emitter = getWorld():getFreeEmitter(x, y, 0)
                    emitter:setVolumeAll(0.5)
                    emitter:tick()
                    emitter:playSound("ZSBuildingChurch")
                end
            end
        end

        -- school
        if hour >=8 and hour < 17 then
            if minute == 10 or minute == 45 then
                local school = BWOBuildings.FindBuildingWithRoom("education")
                if school then
                    local def = school:getDef()
                    local emitter = getWorld():getFreeEmitter((def:getX() + def:getX2()) / 2, (def:getY() + def:getY2()) / 2, 0)
                    emitter:setVolumeAll(0.8)
                    emitter:tick()
                    emitter:playSound("ZSBuildingSchool")
                end
            end
        end
    end

    -- general sickness control
    if worldAge < 34 then 
        BWOEventManager.SymptomLevel = 0
    elseif worldAge < 60 then
        BWOEventManager.SymptomLevel = 1
    elseif worldAge < 100 then
        BWOEventManager.SymptomLevel = 2
    elseif worldAge < 132 then
        BWOEventManager.SymptomLevel = 3
    elseif worldAge == 132 then
        BWOEventManager.SymptomLevel = 4
    else    
        BWOEventManager.SymptomLevel = 5
    end

    -- general services control
    BWOPopControl.Police.On = false
    BWOPopControl.SWAT.On = false
    BWOPopControl.Security.On = false
    BWOPopControl.Medics.On = false
    BWOPopControl.Hazmats.On = false
    BWOPopControl.Fireman.On = false

    if worldAge < 90 then
        BWOPopControl.Medics.On = true
    end

    if worldAge < 120 then
        BWOPopControl.Hazmats.On = true
    end

    if worldAge < 110 then
        BWOPopControl.Police.On = true
        BWOPopControl.SWAT.On = true
        BWOPopControl.Security.On = true
        BWOPopControl.Fireman.On = true
    end

    -- cooldown timers (minutes)
    local function dec(service)
        if not service then return end
        local cd = tonumber(service.Cooldown or 0) or 0
        if cd > 0 then
            cd = cd - 1
            if cd < 0 then cd = 0 end
            service.Cooldown = cd
        end
    end
    dec(BWOPopControl and BWOPopControl.Police)
    dec(BWOPopControl and BWOPopControl.SWAT)
    dec(BWOPopControl and BWOPopControl.Security)
    dec(BWOPopControl and BWOPopControl.Medics)
    dec(BWOPopControl and BWOPopControl.Hazmats)
    dec(BWOPopControl and BWOPopControl.Fireman)
end

function BWOEventManager.Add(eventName, params, delay)
    if not eventName then return end

    -- Defensive: ensure we always have a queue and a time source.
    BWOEventManager.Events = BWOEventManager.Events or {}

    local now = 0
    if BanditUtils and BanditUtils.GetTime then
        now = BanditUtils.GetTime()
    elseif BWOUtils and BWOUtils.GetTime then
        now = BWOUtils.GetTime()
    elseif getTimestampMs then
        now = getTimestampMs()
    end

    local d = tonumber(delay) or 0

    local event = {
        start = now + d,
        phase = eventName,
        params = params,
    }
    -- scheduler queue is unified with EventManager queue
    table.insert(BWOEventManager.Events, {{event.phase, event.params}, event.start})
end

-- compatibility alias for legacy scheduler callback
BWOEventManager.ProcessQueue = function(ticks)
    eventProcessor(ticks)
end

-- extra spawn for specific room types
local function roomSpawner()
    if not scenario then return end
    -- Only DayOne uses room-based spawns; Week should not.
    if scenarioName ~= "DayOne" then return end
    
    local roomSpawns = scenario:getRoomSpawns()

    local worldAge = BWOUtils.GetWorldAge()

    local cache = BWORooms.cache
    if #cache == 0 then
        dprint("[EVENT_MANAGER][INFO] REBUILDING ROOM CACHE", 3)
        BWORooms.UpdateCache()
    end

    dprint("[EVENT_MANAGER][INFO] ROOM CACHE IS: " .. #cache, 3)

    local players = BWOUtils.GetAllPlayers()

    for _, rdata in ipairs(cache) do
        if roomSpawns[rdata.name] then
            for i = 1, #players do
                local player = players[i]
                local px, py = player:getX(), player:getY()
                local distSq = ((px - rdata.x) * (px - rdata.x)) + ((py - rdata.y) * (py - rdata.y))
                if distSq > 900 and distSq < 3600 then -- > 30 and < 60
                    for _, sdata in ipairs(roomSpawns[rdata.name]) do
                        if not rdata.spawned and worldAge >= sdata.waMin and worldAge < sdata.waMax then
                            dprint("[EVENT_MANAGER][INFO] ROOM SPAWN: " .. rdata.name, 3)
                            local args = {
                                cid = sdata.cid,
                                program = "Bandit",
                                hostile = sdata.hostile,
                                size = sdata.size,
                                x = rdata.x,
                                y = rdata.y,
                                z = rdata.z,
                            }
                            BanditServer.Spawner.Clan(player, args)

                            rdata.spawned = true
                        end
                    end
                end
            end
        end
    end
end

local function waitingRoomManager()
    local gmd = BWOGMD.Get()

    if gmd.general.gameStarted then
        if not scenario then
            scenarioName = gmd.general.selectedScenario or "Week" -- fallback just in case
            if BWOScenarios[scenarioName] then
                scenario = BWOScenarios[scenarioName]:new()
                dprint("[EVENT_MANAGER][INFO] RESTORED SCENARIO AFTER RESTART: " .. tostring(scenarioName), 3)
            else
                dprint("[EVENT_MANAGER][ERR] CANNOT RESTORE SCENARIO: " .. tostring(scenarioName), 1)
            end
        end
        return
    end
    local gt = getGameTime()
    local startHour = gt:getStartTimeOfDay()
    gt:setTimeOfDay(startHour)

    -- update player status
    for id, player in pairs(gmd.players) do
        player.online = false
    end

    local players = BWOUtils.GetAllPlayers()
    for i = 1, #players do
        local player = players[i]
        local id = player:getUsername()

        if not gmd.players[id] then
            dprint("[EVENT_MANAGER][INFO] REGISTERING PLAYER " .. id, 3)
            local pdata = {
                sx = player:getX(),
                sy = player:getY(),
                sz = player:getZ(),
                id = id,
                status = false,
                online = true,
            }
            gmd.players[id] = pdata
        else
            gmd.players[id].online = true
        end
    end
    BWOGMD.Transmit()

    -- teleport to waiting room
    for i = 1, #players do
        local player = players[i]
        if player:getY() > 970 then
            local teleportCoords = {
                x1 = 11788,
                y1 = 955,
                x2 = 11795,
                y2 = 958,
                z = 0
            }

            local x = teleportCoords.x1 + ZombRand(teleportCoords.x2 - teleportCoords.x1)
            local y = teleportCoords.y1 + ZombRand(teleportCoords.y2 - teleportCoords.y1)
            local z = 0
            dprint("[EVENT_MANAGER][INFO] TELEPORTING TO X: " .. x .. " Y: " .. y, 3)

            local paramsClient = {
                pid = player:getOnlineID(),
                x = x,
                y = y,
                z = z,
            }
            sendServerCommand("Events", "Teleport", paramsClient)

        end
    end

    if not gmd.general.waitingRoomBuilt then
        local testCoords = {
            x = 11782,
            y = 947,
            z = 0
        }

        local square = getCell():getGridSquare(testCoords.x, testCoords.y, testCoords.z)
        if square then
            dprint("[EVENT_MANAGER][INFO] BUILDING THE WAITING ROOM NOW", 3)
            -- используем первый доступный сценарий для построения комнаты ожидания
            local tempScenario = BWOScenarios[availableScenarios[1]]:new()
            tempScenario:waitingRoom()
            gmd.general.waitingRoomBuilt = true
            BWOGMD.Transmit()
        else
            dprint("[EVENT_MANAGER][WARN] CANNOT REACH SQUARE TO BUILD WAITING ROOM", 2)
        end
    end

    -- подсчет голосов и выбор сценария
    if not gmd.general.selectedScenario then
        local voteCounts = {}
        for _, scenName in ipairs(availableScenarios) do
            voteCounts[scenName] = 0
        end
        
        for playerId, votedScenario in pairs(gmd.scenarioVotes) do
            if gmd.players[playerId] and gmd.players[playerId].online then
                if voteCounts[votedScenario] then
                    voteCounts[votedScenario] = voteCounts[votedScenario] + 1
                end
            end
        end
        
        -- находим сценарий с максимальным количеством голосов
        local maxVotes = 0
        local selectedScen = availableScenarios[1]  -- по умолчанию первый
        for scenName, votes in pairs(voteCounts) do
            if votes > maxVotes then
                maxVotes = votes
                selectedScen = scenName
            end
        end
        
        -- если есть голоса, выбираем сценарий
        if maxVotes > 0 then
            gmd.general.selectedScenario = selectedScen
            scenarioName = selectedScen
            scenario = BWOScenarios[scenarioName]:new()
            dprint("[EVENT_MANAGER][INFO] SELECTED SCENARIO: " .. selectedScen .. " WITH " .. maxVotes .. " VOTES", 3)
            BWOGMD.Transmit()
        end
    else
        -- если сценарий уже выбран, инициализируем его
        if not scenario then
            scenarioName = gmd.general.selectedScenario
            scenario = BWOScenarios[scenarioName]:new()
            dprint("[EVENT_MANAGER][INFO] INITIALIZING SELECTED SCENARIO: " .. scenarioName, 3)
        end
    end


    -- check if everyone is ready
    local allReady = true
    local playerCnt = 0
    for id, player in pairs(gmd.players) do
        if player.online then
            playerCnt = playerCnt + 1
            if not player.status then
                allReady = false
            end
        end
    end

    if allReady and playerCnt > 0 then
        -- проверяем, что сценарий выбран
        if not gmd.general.selectedScenario then
            -- если сценарий не выбран, выбираем по умолчанию первый
            gmd.general.selectedScenario = availableScenarios[1]
            scenarioName = gmd.general.selectedScenario
            scenario = BWOScenarios[scenarioName]:new()
            BWOGMD.Transmit()
        elseif not scenario then
            scenarioName = gmd.general.selectedScenario
            scenario = BWOScenarios[scenarioName]:new()
        end
        
        dprint("[EVENT_MANAGER][INFO] ALL PLAYERS READY! STARTING SCENARIO: " .. scenarioName, 3)
        local spawn = scenario:getRandomPlayerSpawn()
        for i = 1, #players do
            local player = players[i]
            local id = player:getUsername()
            dprint("[EVENT_MANAGER][INFO] TELEPORTING " .. id .. " TO X: " .. spawn.x .. " Y: " .. spawn.y .. " Z: " .. spawn.z, 3)


            local paramsClient = {
                pid = player:getOnlineID(),
                x = spawn.x,
                y = spawn.y,
                z = spawn.z,
            }
            sendServerCommand("Events", "Teleport", paramsClient)
        end

        gmd.general.gameStarted = true
        BWOGMD.Transmit()
    end
end

local function scenarioController()
    if scenario then
        scenario:controller()
    end
end

-- sets player ready/not ready status for the waiting room
local function setPlayerStatus(args)
    local gmd = BWOGMD.Get()
    local id = args.id
    local status = args.status

    if gmd.players[id] then
        gmd.players[id].status = status
        BWOGMD.Transmit()
        if status then
            dprint("[EVENT_MANAGER][INFO] PLAYER " .. id .. " IS NOW READY", 3)
        else
            dprint("[EVENT_MANAGER][INFO] PLAYER " .. id .. " IS NOW NOT READY", 3)
        end
    end
end

-- sets player vote for scenario
local function setScenarioVote(args)
    local gmd = BWOGMD.Get()
    local id = args.id
    local scenarioName = args.scenarioName
    
    if gmd.general.gameStarted then
        dprint("[EVENT_MANAGER][WARN] CANNOT VOTE AFTER GAME STARTED", 2)
        return
    end
    
    if not gmd.players[id] then
        dprint("[EVENT_MANAGER][WARN] PLAYER " .. id .. " NOT FOUND", 2)
        return
    end
    
    -- проверяем, что сценарий доступен
    local isValid = false
    for _, scenName in ipairs(availableScenarios) do
        if scenName == scenarioName then
            isValid = true
            break
        end
    end
    
    if not isValid then
        dprint("[EVENT_MANAGER][WARN] INVALID SCENARIO: " .. tostring(scenarioName), 2)
        return
    end
    
    gmd.scenarioVotes[id] = scenarioName
    BWOGMD.Transmit()
    dprint("[EVENT_MANAGER][INFO] PLAYER " .. id .. " VOTED FOR SCENARIO: " .. scenarioName, 3)
end

-- main processor
local function mainProcessor()
    if not isServer() then return end

    waitingRoomManager()

    scenarioController()

    sequenceProcessor()

    roomSpawner()

    -- BWOServerEvents.MetaSound()
end

-- direct API to allow chaining events from other events
BWOEventGenerator.AddSequence = function(sequence)
    addSequence(sequence)
end

local onClientCommand = function(module, command, player, args)
    if module == "EventManager" then
        if command == "AddSequence" then
            addSequence(args)
        elseif command == "AddEvent" then
            addSequence({{args, 1}})
        elseif command == "SetPlayerStatus" then
            setPlayerStatus(args)
        elseif command == "SetScenarioVote" then
            setScenarioVote(args)
        end
    end
end

-- this works only when a new character is created for a joing player
-- while it seems redundant it allows server-side teleport which works better

local function newPlayerManager(playerNum, player)
    dprint("[EVENT_MANAGER][INFO] NEW PLAYER JOINED IN", 3)

    local gmd = BWOGMD.Get()
    -- Always ensure starting cash (once per character), even if game already started.
    if BWOServer and BWOServer.Commands and BWOServer.Commands.EnsureStartingCash then
        BWOServer.Commands.EnsureStartingCash(player, {})
    end

    if gmd.general.gameStarted then return end

    local teleportCoords = {
        x1 = 11788,
        y1 = 955,
        x2 = 11795,
        y2 = 958,
        z = 0
    }
    
    local x = teleportCoords.x1 + ZombRand(teleportCoords.x2 - teleportCoords.x1)
    local y = teleportCoords.y1 + ZombRand(teleportCoords.y2 - teleportCoords.y1)
    local z = 0
    dprint("[EVENT_MANAGER][INFO] SERVER TELEPORTING TO X: " .. x .. " Y: " .. y, 3)

    player:setX(x)
    player:setY(y)
    player:setZ(z)
    -- player:setLastX(x)
    -- player:setLastY(y)
    -- player:setLastZ(z)

end

Events.OnCreatePlayer.Remove(newPlayerManager)
Events.OnCreatePlayer.Add(newPlayerManager)

Events.OnGameStart.Remove(BWOEventManager.StoreSandboxVars)
Events.OnGameStart.Add(BWOEventManager.StoreSandboxVars)

Events.OnGameStart.Remove(BWOEventManager.RestoreRepeatingPlaceEvents)
Events.OnGameStart.Add(BWOEventManager.RestoreRepeatingPlaceEvents)

Events.EveryOneMinute.Remove(BWOEventManager.MasterControl)
Events.EveryOneMinute.Add(BWOEventManager.MasterControl)

Events.EveryOneMinute.Remove(mainProcessor)
Events.EveryOneMinute.Add(mainProcessor)

Events.OnTick.Remove(eventProcessor)
Events.OnTick.Add(eventProcessor)

Events.OnClientCommand.Remove(onClientCommand)
Events.OnClientCommand.Add(onClientCommand)
