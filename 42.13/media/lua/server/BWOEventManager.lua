require "BWOUtils"
require "BWOGMD"
require "BWOServerEvents"
require "Scenarios/SDayOne"
require "Scenarios/SWeek"

BWOEventGenerator = BWOEventGenerator or {}

-- the main architecture of week one multiplayer events

-- список доступных сценариев
local availableScenarios = {"DayOne", "Week"}

-- сценарий будет инициализирован после выбора
local scenario = nil
local scenarioName = nil

-- a queue of single events to be fired
local events = {}

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
        table.insert(events, eventTimed)
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

-- fires single event server-side
-- server-side event will call client logic shortafter
local function eventProcessor()
    if not isServer() then return end

    for i, eventTimed in ipairs(events) do
        local currentTime = BWOUtils.GetTime()
        local event = eventTimed[1]
        local eventTime = eventTimed[2]

        if eventTime < currentTime then
            local eventFunction = event[1]
            local eventParams = event[2]
            if eventFunction and eventParams then
                dprint("[EVENT_MANAGER][INFO] EVENT FUNCTION: " .. eventFunction, 3)
                if BWOServerEvents[eventFunction] then
                    dprint("[EVENT_MANAGER][INFO] EXECUTING EVENT", 3)
                    BWOServerEvents[eventFunction](eventParams)
                else
                    dprint("[EVENT_MANAGER][ERR] NO SUCH EVENT!", 1)
                end
            end
            table.remove(events, i)
            break -- deliberately consuming only one event at a time to avoid spikes
        end
    end

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

Events.EveryOneMinute.Remove(mainProcessor)
Events.EveryOneMinute.Add(mainProcessor)

Events.OnTick.Remove(eventProcessor)
Events.OnTick.Add(eventProcessor)

Events.OnClientCommand.Remove(onClientCommand)
Events.OnClientCommand.Add(onClientCommand)