BWOUtils = BWOUtils or {}
-- Ensure shared helpers exist on the client (MP fork relies on BanditUtils helpers for economy logic).
require "shared/BWOUtils"

-- Optional compatibility hooks (only activate when the standalone Bandits mod is present).
require "client/BWOBanditsHooks"

BWOPlayer = BWOPlayer or {}

BWOPlayer.tick = 0

-- time spent on aiming after aim start
BWOPlayer.aimTime = 0

-- a flag that get set when the player is sleeping to be later used as a pseudo trigger
BWOPlayer.wasSleeping = false

-- a list of player timed actions that are recognized by NPCs are crime
BWOPlayer.illegalActions = {
    "ISSmashWindow",
    "ISSmashVehicleWindow",
    "ISHotwireVehicle",
    "ISTakeGasolineFromVehicle",
    "CrowbarActionAnim", -- The Best Lockpicking aka Better Lockpicking [B42]
    "BobbyPinActionAnim", -- The Best Lockpicking aka Better Lockpicking [B42]
    "LockpickTimedAction", -- Simple Lockpicking [B41/B42]
}

-- =========================================================
-- WeekOne crime/threat/exercise hooks (MP wrappers)
-- =========================================================
-- In SP these functions directly change NPC state and/or economy.
-- In MP they must be server-authoritative, so client only forwards intent.

local function isLocalPlayer(p)
    return p and instanceof(p, "IsoPlayer") and (p == getPlayer())
end

-- make npcs react to actual crime
BWOPlayer.ActivateWitness = function(character, min)
    if not isLocalPlayer(character) then return end
    sendClientCommand(character, "Commands", "ActivateWitness", {
        min = min or 18,
    })
end

-- make npcs react to threat possibility (player aiming or swinging weapon)
BWOPlayer.ActivateTargets = function(character, min, severity)
    if not isLocalPlayer(character) then return end
    -- Debug (throttled): confirm client is sending ActivateTargets.
    if (severity or 1) >= 2 then
        BWOPlayer._dbgATLast = BWOPlayer._dbgATLast or 0
        local now = (getTimestampMs and getTimestampMs()) or 0
        if (now - BWOPlayer._dbgATLast) > 750 then
            BWOPlayer._dbgATLast = now
            print(string.format("[BWO] send ActivateTargets min=%s severity=%s", tostring(min or 15), tostring(severity or 1)))
        end
    end
    sendClientCommand(character, "Commands", "ActivateTargets", {
        min = min or 15,
        severity = severity or 1,
    })
end

BWOPlayer.ActivateExcercise = function(character, min)
    if not isLocalPlayer(character) then return end
    sendClientCommand(character, "Commands", "ActivateExcercise", {
        min = min or 5,
    })
end

-- Bandits mod calls `BanditPlayer.CheckFriendlyFire(bandit, attacker)` from client-side `BanditUpdate.lua`.
-- WeekOne SP overrides that function with custom logic. In MP we forward the event to the server, because
-- world/NPC state changes must be server-authoritative.
do
    local function bwoCheckFriendlyFire(bandit, attacker)
        if not bandit or not attacker then return end

        -- Only real player attackers should be processed, and only by the local attacker client.
        if (not instanceof(attacker, "IsoPlayer")) or attacker:isNPC() then return end
        local player = getPlayer()
        if not player or attacker ~= player then return end

        -- Identify victim on the server.
        local zid = nil
        if BanditUtils and BanditUtils.GetZombieID then
            zid = BanditUtils.GetZombieID(bandit)
        end
        if (not zid) and BanditUtils and BanditUtils.GetCharacterID then
            zid = BanditUtils.GetCharacterID(bandit)
        end
        if not zid then return end

        sendClientCommand(player, "Commands", "FriendlyFire", {
            zid = zid,
            x = bandit:getX(),
            y = bandit:getY(),
            z = bandit:getZ(),
        })
    end

    BanditPlayer = BanditPlayer or {}
    BanditPlayer.CheckFriendlyFire = bwoCheckFriendlyFire
end

-- =========================================================
-- SP BWOPlayer.lua hooks ported to MP (client detectors)
-- =========================================================

local function isLocalPlayer(p)
    return p and instanceof(p, "IsoPlayer") and (p == getPlayer())
end

local function cmd(player, command, args)
    if not player then return end
    sendClientCommand(player, "Commands", command, args or {})
end

local function cmdMoneyEarn(player, amount)
    if not player then return end
    amount = tonumber(amount) or 0
    if amount <= 0 then return end
    cmd(player, "MoneyEarn", { amount = amount })
end

local function cmdMoneyPay(player, amount, witnessMin)
    if not player then return end
    amount = tonumber(amount) or 0
    if amount <= 0 then return end
    cmd(player, "MoneyPay", { amount = amount, witnessMin = witnessMin })
end

-- Safe wrapper: prevents nil-call crashes if a dependency mod/script didn't define the function yet.
local function addPriceInflation(price)
    if BanditUtils and BanditUtils.AddPriceInflation then
        return BanditUtils.AddPriceInflation(price)
    end
    return math.floor(tonumber(price) or 0)
end

-- detecting crime based on who got hit by player (Shahid special-case)
local onHitZombie = function(zombie, attacker, bodyPartType, handWeapon)
    if not zombie or not attacker then return end
    if not isLocalPlayer(attacker) then return end

    -- Gunshot reaction (MP): ensure nearby NPCs react when a ranged hit actually occurs.
    if handWeapon and handWeapon.isRanged and handWeapon:isRanged() then
        BWOPlayer.ActivateTargets(attacker, 40, 3)
    end

    local brain = BanditBrain and BanditBrain.Get and BanditBrain.Get(zombie) or nil
    if brain and brain.program and brain.program.name == "Shahid" then
        -- Let server validate and detonate.
        local zid = BanditUtils and BanditUtils.GetZombieID and BanditUtils.GetZombieID(zombie) or nil
        cmd(attacker, "ShahidDetonate", { zid = zid, x = zombie:getX(), y = zombie:getY(), z = zombie:getZ() })
    end
end

-- detecting crime based on who got killed by player
local onZombieDead = function(zombie)
    BWOPlayer.aimTime = -25
    local player = getPlayer()
    if not player then return end

    -- register dead body on server (WeekOne uses this as a world-state registry)
    cmd(player, "DeadBodyAdd", { x = zombie:getX(), y = zombie:getY(), z = zombie:getZ() })
end

-- intercepting player actions
local onTimedActionPerform = function(data)
    local character = data and data.character or nil
    if not isLocalPlayer(character) then return end

    local action = data.action and data.action.getMetaType and data.action:getMetaType() or nil
    if not action then return end

    -- illegal actions intercepted here
    for _, illegalAction in pairs(BWOPlayer.illegalActions) do
        if action == illegalAction then
            BWOPlayer.ActivateWitness(character, 18)
            return
        end
    end

    local profession = character:getDescriptor() and character:getDescriptor():getCharacterProfession() or nil

    -- trash collecting and littering
    if action == "ISMoveablesAction" then
        local mode = data.mode
        local origSpriteName = data.origSpriteName
        if mode and origSpriteName then
            local isTrash = false
            if origSpriteName.embodies then
                isTrash = origSpriteName:embodies("trash")
            else
                isTrash = tostring(origSpriteName):lower():find("trash", 1, true) ~= nil
            end

            if isTrash then
                if mode == "pickup" then
                    cmdMoneyEarn(character, 1)
                elseif mode == "place" then
                    cmdMoneyPay(character, 1, 18)
                    BWOPlayer.ActivateWitness(character, 18)
                end
            end
        end
        return
    end

    -- fuel
    if action == "ISRefuelFromGasPump" then
        if data.tankStart and data.tankTarget then
            local amount = data.tankTarget - data.tankStart
            local price = addPriceInflation(1.11)
            local payment = math.floor(amount * price)
            cmdMoneyPay(character, payment, 18)
        end
        return
    end

    if action == "ISTakeFuel" then
        if data.itemStart and data.itemTarget then
            local amount = data.itemTarget - data.itemStart
            local price = addPriceInflation(1.11)
            local payment = math.floor(amount * price)
            cmdMoneyPay(character, payment, 18)
        end
        return
    end

    -- earning
    if profession == "fireofficer" then
        if action == "ISPutOutFire" then
            cmdMoneyEarn(character, 25)
        end
        return
    end

    if profession == "mechanics" then
        if action == "ISFixVehiclePartAction" then
            local vehiclePart = data.vehiclePart
            if vehiclePart then
                local vehicle = vehiclePart:getVehicle()
                local md = vehicle and vehicle:getModData() or nil
                if md and md.BWO and md.BWO.client then
                    local skill = character:getPerkLevel(Perks.MetalWelding)
                    cmdMoneyEarn(character, skill * 5)
                end
            end
        elseif action == "ISRepairEngine" then
            local vehicle = data.vehicle
            local md = vehicle and vehicle:getModData() or nil
            if md and md.BWO and md.BWO.client then
                local skill = character:getPerkLevel(Perks.Mechanics)
                cmdMoneyEarn(character, skill * 20)
            end
        elseif action == "ISInstallVehiclePart" then
            local vehiclePart = data.part
            if vehiclePart then
                local vehicle = vehiclePart:getVehicle()
                local md = vehicle and vehicle:getModData() or nil
                if md and md.BWO and md.BWO.client and md.BWO.parts then
                    local id = vehiclePart:getScriptPart():getId()
                    local idx
                    for k, v in pairs(BWOVehicles.parts) do
                        if id == v then idx = k end
                    end
                    if idx then
                        local item = data.item
                        local oldCondition = md.BWO.parts[idx]
                        local newCondition = item and item:getCondition() or oldCondition
                        local weight = item and item:getWeight() or 0
                        cmdMoneyEarn(character, math.ceil((newCondition - oldCondition) * weight / 5))
                        md.BWO.parts[idx] = newCondition
                    end
                end
            end
        end
        return
    end

    if profession == "parkranger" then
        if action == "ISForageAction" then
            if not data.discardItems and data.itemDef and data.itemDef.categories then
                local junkCategories = {"Junk", "Trash", "Ammunition", "JunkFood", "JunkWeapons"}
                local categories = data.itemDef.categories
                local junk = false
                for _, c1 in pairs(categories) do
                    for _, c2 in pairs(junkCategories) do
                        if c1 == c2 then
                            junk = true
                            break
                        end
                    end
                    if junk then break end
                end
                if junk then
                    cmdMoneyEarn(character, 25)
                end
            end
        end
        return
    end
end

local onTimedActionStop = function(data)
    local character = data and data.character or nil
    if not isLocalPlayer(character) then return end

    local action = data.action and data.action.getMetaType and data.action:getMetaType() or nil
    if not action then return end

    if action == "ISRefuelFromGasPump" then
        if data.tankStart and data.amountSent then
            local amount = data.amountSent - data.tankStart
            local price = addPriceInflation(1.11)
            local payment = math.floor(amount * price)
            cmdMoneyPay(character, payment, 18)
        end
    end
end

local onFitnessActionExeLooped = function(data)
    local character = data and data.character or nil
    if not isLocalPlayer(character) then return end

    local profession = character:getDescriptor() and character:getDescriptor():getCharacterProfession() or nil
    if profession == "fitnessInstructor" then
        BWOPlayer.ActivateExcercise(character, 5)
    end
end

-- inventory transfer player action needs to intercepted separately to have access the necessary data
local onInventoryTransferAction = function(data)
    local character = data and data.character or nil
    if not isLocalPlayer(character) then return end

    local srcContainer = data.srcContainer
    if not srcContainer then return end

    local destContainer = data.destContainer
    if not destContainer then return end

    local descContainerType = destContainer:getType()

    local item = data.item
    if not item then return end

    local itemType = item:getFullType()
    local md = item:getModData()
    if not md.BWO then
        md.BWO = {}
        md.BWO.stolen = false
        md.BWO.bought = false
    end

    -- item already bought in the past
    if md.BWO.bought then return end

    local profession = character:getDescriptor() and character:getDescriptor():getCharacterProfession() or nil

    local object = srcContainer:getParent()
    local square
    local customName

    if object then
        -- taking from trashcans is not buying
        local sprite = object:getSprite()
        if sprite then
            local props = sprite:getProperties()
            if props and props:has("CustomName") then
                customName = props:get("CustomName")
            end
        end

        -- selling (player-to-player)
        if instanceof(object, "IsoPlayer") then
            if not md.BWO.stolen then
                if profession == "lumberjack" then
                    if itemType == "Base.Log" and descContainerType == "logs" then
                        cmdMoneyEarn(character, 10)
                        md.BWO.stolen = true
                    elseif itemType == "Base.Plank" and descContainerType == "crate" then
                        cmdMoneyEarn(character, 6)
                        md.BWO.stolen = true
                    end
                elseif profession == "fisherman" then
                    local room = destContainer:getSquare() and destContainer:getSquare():getRoom() or nil
                    if room and BWORooms.IsKitchen(room) and (BWORooms.IsRestaurant(room) or BWORooms.IsShop(room)) then
                        if descContainerType == "fridge" or descContainerType == "freezer" then
                            local fishOptions = {"Base.Bass", "Base.SmallmouthBass", "Base.LargemouthBass", "Base.SpottedBass", "Base.StripedBass", "Base.WhiteBass",
                                                 "Base.Catfish", "Base.BlueCatfish", "Base.ChannelCatfish", "Base.FlatheadCatfish",
                                                 "Base.Panfish", "Base.RedearSunfish", "Base.Crayfish",
                                                 "Base.Crappie", "Base.BlackCrappie", "Base.WhiteCrappie",
                                                 "Base.Perch", "Base.Paddlefish", "Base.YellowPerch",
                                                 "Base.Pike", "Base.Trout"}
                            for _, fishOption in pairs(fishOptions) do
                                if itemType == fishOption then
                                    local weight = item:getActualWeight()
                                    local price = math.floor(weight * SandboxVars.BanditsWeekOne.PriceMultiplier * 4)
                                    cmdMoneyEarn(character, price)
                                    md.BWO.stolen = true
                                    break
                                end
                            end
                        end
                    end
                end
            end
            return
        end

        -- looting body
        if instanceof(object, "IsoDeadBody") then
            return
        end

        square = object:getSquare()
    else
        square = character:getSquare()
    end

    -- transfering to non player containers is not buying
    local destCharacter = destContainer:getCharacter()
    if not destCharacter then return end

    -- transfering between player containers is not buying
    local srcCharacter = srcContainer:getCharacter()
    if instanceof(srcCharacter, "IsoPlayer") and instanceof(destCharacter, "IsoPlayer") then return end

    local room = square and square:getRoom() or nil
    -- you can take outside buildings or from vehicles
    if not room then return end

    local canTake, shouldPay = BWORooms.TakeIntention(room, customName)

    -- taking money is not buying
    if item:getType() == "Money" then
        canTake = false
        shouldPay = false
    end

    if canTake then return end

    if shouldPay then
        local weight = item:getActualWeight()
        local pm = (SandboxVars and SandboxVars.BanditsWeekOne and SandboxVars.BanditsWeekOne.PriceMultiplier) or 1
        local price = addPriceInflation(weight * pm * 10)
        if price == 0 then price = 1 end

        md.BWO.bought = true
        cmdMoneyPay(character, price, nil)

    elseif not canTake then
        md.BWO.stolen = true
        BWOPlayer.ActivateWitness(character, 15)
    end
end

local onPlayerUpdate = function(player)
    if not isLocalPlayer(player) then return end

    -- tick update
    if BWOPlayer.tick >= 32 then
        BWOPlayer.tick = 0
    end

    -- intercepting end of sleep
    if not player:isAsleep() and BWOPlayer.wasSleeping then
        BWOPlayer.wasSleeping = false
        cmd(player, "PlayerWokeUp", { night = getGameTime():getNightsSurvived() })
    end

    -- intercepting player aiming (threat detector)
    if (BWOPlayer.tick == 0 or BWOPlayer.tick == 16) then
        if player:isAiming() and (not (BanditPlayer and BanditPlayer.IsGhost and BanditPlayer.IsGhost(player))) then
            local primaryItem = player:getPrimaryHandItem()
            local max
            if primaryItem and primaryItem:IsWeapon() then
                local primaryItemType = WeaponType.getWeaponType(primaryItem)
                if primaryItemType == WeaponType.FIREARM then
                    max = 12
                elseif primaryItemType == WeaponType.HANDGUN then
                    max = 8
                elseif primaryItemType == WeaponType.HEAVY then
                    max = 3
                elseif primaryItemType == WeaponType.ONE_HANDED then
                    max = 3
                elseif primaryItemType == WeaponType.KNIFE then
                    max = 3
                elseif primaryItemType == WeaponType.SPEAR then
                    max = 3
                elseif primaryItemType == WeaponType.TWO_HANDED then
                    max = 3
                elseif primaryItemType == WeaponType.THROWING then
                    max = 12
                elseif primaryItemType == WeaponType.CHAINSAW then
                    max = 4
                end
            end

            if max then
                if BWOPlayer.aimTime > 11 then
                    BWOPlayer.ActivateTargets(player, max, 2)
                elseif BWOPlayer.aimTime > 4 then
                    BWOPlayer.ActivateTargets(player, max, 1)
                end
                BWOPlayer.aimTime = BWOPlayer.aimTime + 1
            end
        else
            BWOPlayer.aimTime = 0
        end
    end

    BWOPlayer.tick = BWOPlayer.tick + 1
end

local onPlayerDeath = function(player)
    if not isLocalPlayer(player) then return end
    cmd(player, "PlayerDeath", {})
end

local onWeaponSwing = function(character, handWeapon)
    if not isLocalPlayer(character) then return end
    if BanditPlayer and BanditPlayer.IsGhost and BanditPlayer.IsGhost(character) then return end

    BWOPlayer.aimTime = 0
    local primaryItemType = WeaponType.getWeaponType(handWeapon)
    if primaryItemType == WeaponType.barehand then return end
    if not character:getPrimaryHandItem() then return end

    local severity = 1
    -- Prefer weapon instance check (works across different WeaponType casing/enum variants).
    local isRanged = handWeapon and handWeapon.isRanged and handWeapon:isRanged()
    if isRanged then
        -- Distinguish actual gunshots from "threat"/aiming. Server treats severity>=3 as gunshot.
        severity = 3
    else
        -- Fallback: some builds expose WeaponType constants in different casing (FIREARM vs firearm).
        local WT = WeaponType
        if WT then
            if (WT.FIREARM and primaryItemType == WT.FIREARM) or
               (WT.HANDGUN and primaryItemType == WT.HANDGUN) or
               (WT.firearm and primaryItemType == WT.firearm) or
               (WT.handgun and primaryItemType == WT.handgun) then
                severity = 3
            end
        end
    end

    local min = 15
    if severity >= 3 then
        -- Gunshots should be heard farther than melee swings.
        min = 40
    end
    BWOPlayer.ActivateTargets(character, min, severity)
end

-- sleep detector to init dreams
local everyHours = function()
    local player = getPlayer()
    if player and player:isAsleep() then
        BWOPlayer.wasSleeping = true
    end
end

-- time based jobs (server authoritative payout)
local function everyOneMinuteIncomeTick()
    local player = getPlayer()
    if not player or player:isAsleep() then return end
    cmd(player, "TimeIncomeTick", {})
end

-- exit vehicle hook (WeekOne SP had complex NPC passenger restore logic; in MP we keep a safe server notification)
local function onExitVehicle(character)
    if not isLocalPlayer(character) then return end
    cmd(character, "PlayerExitVehicle", { x = character:getX(), y = character:getY(), z = character:getZ() })
end
local function everyOneMinute(player)
    local gmd = BWOGMD.Get()

    if gmd.general.gameStarted then
        if BWOPlayer.waitingRoomModal then
            BWOPlayer.waitingRoomModal:removeFromUIManager()
            BWOPlayer.waitingRoomModal:close()
            BWOPlayer.waitingRoomModal = nil
        end
        return
    end

    if not BWOPlayer.waitingRoomModal then
        local screenWidth, screenHeight = getCore():getScreenWidth(), getCore():getScreenHeight()
        local modalWidth, modalHeight = 600, 80
        local modalX = 0
        local modalY = screenHeight - modalHeight
        BWOPlayer.waitingRoomModal = UIWaitingRoom:new(100, 50, 300, screenHeight - 100)
        BWOPlayer.waitingRoomModal:initialise()
        BWOPlayer.waitingRoomModal:addToUIManager()
    end

    -- tick server-side income logic (WeekOne)
    everyOneMinuteIncomeTick()
end

Events.EveryOneMinute.Remove(everyOneMinute)
Events.EveryOneMinute.Add(everyOneMinute)

-- Hook registrations (ported from SP BWOPlayer.lua)
LuaEventManager.AddEvent("OnFitnessActionExeLooped")
LuaEventManager.AddEvent("OnInventoryTransferActionPerform")
LuaEventManager.AddEvent("OnTimedActionStop")
-- Some builds/mod stacks do not predefine this event, but Bandits/BWO may trigger it.
LuaEventManager.AddEvent("OnTimedActionPerform")

Events.OnHitZombie.Add(onHitZombie)
Events.OnZombieDead.Add(onZombieDead)
Events.OnTimedActionPerform.Add(onTimedActionPerform)
Events.OnTimedActionStop.Add(onTimedActionStop)
Events.OnFitnessActionExeLooped.Add(onFitnessActionExeLooped)
Events.OnInventoryTransferActionPerform.Add(onInventoryTransferAction)
Events.OnPlayerUpdate.Add(onPlayerUpdate)
Events.OnPlayerDeath.Add(onPlayerDeath)
Events.OnWeaponSwing.Add(onWeaponSwing)
Events.EveryHours.Add(everyHours)
Events.OnExitVehicle.Add(onExitVehicle)

-- Debug: one-shot client->server connectivity check (confirms server is actually running this mod).
Events.OnGameStart.Add(function()
    if BWOPlayer._pingTestSent then return end
    local p = getPlayer()
    if not p then return end
    BWOPlayer._pingTestSent = true
    sendClientCommand(p, "Commands", "PingTest", { t = (getTimestampMs and getTimestampMs()) or 0 })
end)