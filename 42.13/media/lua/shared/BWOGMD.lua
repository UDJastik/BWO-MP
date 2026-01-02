BWOGMD = {}
BWOGMD.data = {}

local function initModData(isNewGame)

    -- BANDIT GLOBAL MODDATA
    local globalData = ModData.getOrCreate("BWOMP")
    if isClient() then
        ModData.request("BWOMP")
    end
    
    if not globalData.general then 
        globalData.general = {
            gameStarted = false,
            waitingRoomBuilt = false,
            selectedScenario = nil,  -- выбранный сценарий после голосования
        }
    end
    if not globalData.Queue then globalData.Queue = {} end
    if not globalData.Variant then globalData.Variant = {} end
    if not globalData.Objects then globalData.Objects = {} end
    if not globalData.Sandbox then globalData.Sandbox = {} end
    if not globalData.QueryCache then globalData.QueryCache = {} end
    if not globalData.DeadBodies then globalData.DeadBodies = {} end
    if not globalData.EventBuildings then globalData.EventBuildings = {} end
    if not globalData.Nukes then globalData.Nukes = {} end
    if not globalData.PlaceEvents then globalData.PlaceEvents = {} end
    if not globalData.players then 
        globalData.players = {}
    end

    if not globalData.scenarioVotes then
        globalData.scenarioVotes = {}  -- голоса игроков: {playerId = scenarioName}
    end

    BWOGMD.data = globalData

end

local function loadModData(key, globalData)
    if isClient() then
        if key and globalData then
            if key == "BWOMP" then
                BWOGMD.data = globalData
            end
        end
    end
end

BWOGMD.Get = function()
    return BWOGMD.data
end

BWOGMD.Transmit = function()
    if isServer() then
        ModData.transmit("BWOMP")
    end
end

Events.OnInitGlobalModData.Add(initModData)
Events.OnReceiveGlobalModData.Add(loadModData)
