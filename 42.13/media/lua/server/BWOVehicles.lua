BWOVehicles = BWOVehicles or {}

BWOVehicles.tab = {}

BWOVehicles.carChoices = {"Base.CarLights", "Base.CarLuxury", "Base.CarNormal", "Base.CarStationWagon", 
                          "Base.CarTaxi", "Base.ModernCar", "Base.PickUpTruck", "Base.PickUpTruckLights", 
                          "Base.PickUpVan", "Base.PickUpVanLights", "Base.SUV", "Base.SmallCar", 
                          "Base.SportsCar", "Base.StepVan", "Base.Van"}

BWOVehicles.policeCarChoices = {"Base.PickUpVanLightsPolice"}

BWOVehicles.firemanCarChoices = {"Base.PickUpTruckLightsFire"}

BWOVehicles.SWATCarChoices = {"Base.StepVan_LouisvilleSWAT"}

BWOVehicles.medicalCarChoices = {"Base.VanAmbulance"}

BWOVehicles.hazmatsCarChoices = {"Base.VanAmbulance"}

BWOVehicles.playerCarChoicesDefault = {"Base.SmallCar"}

BWOVehicles.playerCarChoicesOccupation = {}
BWOVehicles.playerCarChoicesOccupation["fireofficer"] = {"Base.PickUpTruckLightsFire"}
BWOVehicles.playerCarChoicesOccupation["policeofficer"] = {"Base.PickUpVanLightsPolice"}
BWOVehicles.playerCarChoicesOccupation["mechanics"] = {"Base.SportsCar", "Base.StepVan_Mechanic"}
BWOVehicles.playerCarChoicesOccupation["lumberjack"] = {"Base.PickUpVanLightsCarpenter", "Base.VanMichaels"}
BWOVehicles.playerCarChoicesOccupation["carpenter"] = {"Base.PickUpVanLightsCarpenter", "Base.VanMichaels"}
BWOVehicles.playerCarChoicesOccupation["constructionworker"] = {"Base.PickUpVanKimbleKonstruction", "Base.StepVan_Masonry", "Base.VanBeckmans", "Base.VanPennSHam"}
BWOVehicles.playerCarChoicesOccupation["metalworker"] = {"Base.PickUpVanHeltonMetalWorking", "Base.PickUpVanMetalworker", "Base.PickUpVanWeldingbyCamille"}
BWOVehicles.playerCarChoicesOccupation["farmer"] = {"Base.VanOvoFarm"}
BWOVehicles.playerCarChoicesOccupation["lumberjack"] = {"Base.PickUpVanYingsWood"}
BWOVehicles.playerCarChoicesOccupation["repairman"] = {"Base.StepVan_CompleteRepairShop", "Base.VanBrewsterHarbin"}
BWOVehicles.playerCarChoicesOccupation["engineer"] = {"Base.StepVan_CompleteRepairShop", "Base.VanBrewsterHarbin"}
BWOVehicles.playerCarChoicesOccupation["electrician"] = {"Base.VanKnoxCom", "Base.VanPluggedInElectrics"}
BWOVehicles.playerCarChoicesOccupation["chef"] = {"Base.VanSpiffo"}
BWOVehicles.playerCarChoicesOccupation["doctor"] = {"Base.CarLuxury"}

-- order is important
BWOVehicles.burnMap = {}

BWOVehicles.burnMap["Base.CarLights"] = "Base.CarNormalBurnt"
BWOVehicles.burnMap["Base.CarLuxury"] = "Base.LuxuryCarBurnt"
BWOVehicles.burnMap["Base.NormalCarPolice"] = "Base.NormalCarBurntPolice"
BWOVehicles.burnMap["Base.CarNormal"] = "Base.CarNormalBurnt"
BWOVehicles.burnMap["Base.CarStationWagon"] = "Base.CarNormalBurnt"
BWOVehicles.burnMap["Base.ModernCar"] = "Base.ModernCar02Burnt"
BWOVehicles.burnMap["Base.ModernCar02"] = "Base.SmallCar02Burnt"
BWOVehicles.burnMap["Base.SmallCar02"] = "Base.SmallCar02Burnt"
BWOVehicles.burnMap["Base.CarSmall02"] = "Base.SmallCar02Burnt"
BWOVehicles.burnMap["Base.SmallCar"] = "Base.SmallCarBurnt"
BWOVehicles.burnMap["Base.CarSmall"] = "Base.SmallCarBurnt"
BWOVehicles.burnMap["Base.SportsCar"] = "Base.SportsCarBurnt"
BWOVehicles.burnMap["Base.OffRoad"] = "Base.OffRoadBurnt"
BWOVehicles.burnMap["Base.LuxuryCar"] = "Base.LuxuryCarBurnt"
BWOVehicles.burnMap["Base.SUV"] = "Base.SUVBurnt"
BWOVehicles.burnMap["Base.Taxi"] = "Base.TaxiBurnt"
BWOVehicles.burnMap["Base.CarTaxi"] = "Base.TaxiBurnt"
BWOVehicles.burnMap["Base.CarTaxi2"] = "Base.TaxiBurnt"
BWOVehicles.burnMap["Base.PickUpVanLights"] = "Base.PickUpVanLightsBurnt"
BWOVehicles.burnMap["Base.PickUpVan"] = "Base.PickUpVanBurnt"
BWOVehicles.burnMap["Base.VanAmbulance"] = "Base.AmbulanceBurnt"
BWOVehicles.burnMap["Base.VanRadio"] = "Base.VanRadioBurnt"
BWOVehicles.burnMap["Base.VanSeats"] = "Base.VanSeatsBurnt"
BWOVehicles.burnMap["Base.Van"] = "Base.VanBurnt"
BWOVehicles.burnMap["Base.StepVan"] = "Base.VanBurnt" -- has no better alternative
BWOVehicles.burnMap["Base.PickupSpecial"] = "Base.PickupSpecialBurnt"
BWOVehicles.burnMap["Base.PickUpTruck"] = "Base.PickupBurnt"
BWOVehicles.burnMap["Base.Pickup"] = "Base.PickupBurnt"

BWOVehicles.parts = {}
BWOVehicles.parts[1] = "HeadlightLeft"
BWOVehicles.parts[2] = "HeadlightRight"
BWOVehicles.parts[3] = "HeadlightRearLeft"
BWOVehicles.parts[4] = "HeadlightRearRight"
BWOVehicles.parts[5] = "Windshield"
BWOVehicles.parts[6] = "WindshieldRear"
BWOVehicles.parts[7] = "WindowFrontRight"
BWOVehicles.parts[8] = "WindowFrontLeft"
BWOVehicles.parts[9] = "WindowRearRight"
BWOVehicles.parts[10] = "WindowRearLeft"
BWOVehicles.parts[11] = "WindowMiddleLeft"
BWOVehicles.parts[12] = "WindowMiddleRight"
BWOVehicles.parts[13] = "DoorFrontRight"
BWOVehicles.parts[14] = "DoorFrontLeft"
BWOVehicles.parts[15] = "DoorRearRight"
BWOVehicles.parts[16] = "DoorRearLeft"
BWOVehicles.parts[17] = "EngineDoor"
BWOVehicles.parts[18] = "TireFrontRight"
BWOVehicles.parts[19] = "TireFrontLeft"
BWOVehicles.parts[20] = "TireRearLeft"
BWOVehicles.parts[21] = "TireRearRight"

BWOVehicles.Register = function(vehicle)
    local id = vehicle:getId()
    BWOVehicles.tab[id] = vehicle
end

BWOVehicles.VehicleSpawn = function(x, y, dir, btype)
    local square = getCell():getGridSquare(x, y, 0)
    if square then

        if not square:isFree(false) then return end

        if square:isVehicleIntersecting() then return end

        local vehicle = BWOCompatibility.AddVehicle(btype, dir, square)
        if vehicle then
            for i = 0, vehicle:getPartCount() - 1 do
                local container = vehicle:getPartByIndex(i):getItemContainer()
                if container then
                    container:removeAllItems()
                end
            end
            vehicle:getModData().BWO = {}
            vehicle:getModData().BWO.wasRepaired = true
            BWOVehicles.Repair(vehicle)
            vehicle:setColor(ZombRandFloat(0, 1), ZombRandFloat(0, 1), ZombRandFloat(0, 1))
            vehicle:setAlarmed(false)
            vehicle:setGeneralPartCondition(100, 80)
            vehicle:setHeadlightsOn(true)
            vehicle:setPhysicsActive(true)

            -- NORTH x: -180 y: 0 z: 180
            -- SOUTH x: 0 y: 0 z: 0
            -- EAST x: -125 y: 90 z: 125
            -- WEST x: -125, y: -90, z: -125

            local md = vehicle:getModData()
            if not md.BWO then md.BWO = {} end

            if dir == IsoDirections.N then
                vehicle:setAngles(0, 180, 0)
                md.BWO.dir = "N"
            elseif dir == IsoDirections.S then
                vehicle:setAngles(0, 0, 0)
                md.BWO.dir = "S"
            elseif dir == IsoDirections.E then
                vehicle:setAngles(0, 90, 0)
                md.BWO.dir = "E"
            elseif dir == IsoDirections.W then
                -- vehicle:setAngles(-125, -90, -125)
                vehicle:setAngles(0, -90, 0)
                md.BWO.dir = "W"
            end

            local id = vehicle:getId()
            BWOVehicles.tab[id] = vehicle

            --[[
            if args.lightbar or args.siren or args.alarm then
                local newargs = {id=vehicle:getId(), lightbar=args.lightbar, siren=args.siren, alarm=args.alarm}
                sendServerCommand('Commands', 'UpdateVehicle', newargs)
            end
            ]]
        end
    end
end

BWOVehicles.Repair = function(vehicle)
    -- we cant use vehicle:replair() because it will add armor to ki5 vehicles

    for i = 0, vehicle:getPartCount() - 1 do
        local part = vehicle:getPartByIndex(i)
        local area = part:getArea()

        if area and not area:embodies("Armor") then
            local cond = 70 + ZombRand(40)
            if cond > 100 then cond = 100 end
            part:setCondition(cond)
        end
    end

    local gasTank = vehicle:getPartById("GasTank")
    if gasTank then
        local max = gasTank:getContainerCapacity() * 0.7
        gasTank:setContainerContentAmount(ZombRandFloat(0, max))
    end
end

BWOVehicles.Burn = function(vehicle)
    local burnMap = BWOVehicles.burnMap
    local scriptName = vehicle:getScriptName()
    if scriptName:embodies("Burnt") then return end

    for k, v in pairs(burnMap) do
        if scriptName:embodies(k) then
            local ax = vehicle:getAngleX()
            local ay = vehicle:getAngleY()
            local az = vehicle:getAngleZ()
            vehicle:permanentlyRemove()

            local vehicleBurnt = BWOCompatibility.AddVehicle(v, IsoDirections.S, vehicle:getSquare())
            if vehicleBurnt then
                for i = 0, vehicleBurnt:getPartCount() - 1 do
                    local container = vehicleBurnt:getPartByIndex(i):getItemContainer()
                    if container then
                        container:removeAllItems()
                    end
                end
                vehicleBurnt:getModData().BWO = {}
                vehicleBurnt:getModData().BWO.wasRepaired = true
                vehicleBurnt:setAngles(ax, ay, az)
            end
            break
        end
    end
end

BWOVehicles.FindSpawnPoint = function(player)
    
    -- detects orientation and width of the road
    local getInfo = function(x, y)
        local res = {}
        res.valid = false
  
        -- check in x
        local xlen = 0
        local xmin = math.huge
        local xmax = 0
        for i = -14, 14 do
            local dx = x + i
            if BWOUtils.HasZoneType(dx, y, 0, "Nav") then 
                xlen = xlen + 1 
                if dx < xmin then
                    xmin = dx
                end
                if dx > xmax then
                    xmax = dx
                end
            end
        end

        --check in y
        local ylen = 0
        local ymin = math.huge
        local ymax = 0
        for i = -14, 14 do
            local dy = y + i
            if BWOUtils.HasZoneType(x, dy, 0, "Nav") then 
                ylen = ylen + 1
                if dy < ymin then
                    ymin = dy
                end
                if dy > ymax then
                    ymax = dy
                end
            end
        end

        -- width: 14 - intercity roads
        -- width: 8 - city main roads

        if xlen > 20 and ylen >= 8 then
            res.valid = true
            res.orientation = "X" -- EW
            res.min = ymin
            res.max = ymax
            res.width = ylen
        elseif ylen > 20 and xlen >= 8 then
            res.valid = true
            res.orientation = "Y" -- EW
            res.min = xmin
            res.max = xmax
            res.width = xlen
        end

        return res
    end

    -- validates if the point is good for vehicle spawn
    local checkPoint = function(x, y)
        local res = {}
        res.valid = false

        if BWOUtils.HasZoneType(x, y, 0, "Nav") then
            local roadInfo = getInfo(x, y)
            if roadInfo.valid then
                res.valid = true
                if roadInfo.orientation == "X" then
                    res.toEast = {}
                    res.toEast.x = x - 50
                    res.toEast.y = roadInfo.max - 1
                    res.toEast.dir = IsoDirections.E
                    
                    res.toWest = {}
                    res.toWest.x = x + 50
                    res.toWest.y = roadInfo.min + 2
                    res.toWest.dir = IsoDirections.W

                    for dx=x-50, x+50, 5 do
                        local roadInfo = getInfo(dx, y)
                        if not roadInfo.valid then
                            res.valid = false
                            break
                        end
                    end
                else
                    res.toNorth = {}
                    res.toNorth.x = roadInfo.max - 1
                    res.toNorth.y = y + 50
                    res.toNorth.dir = IsoDirections.N
                    
                    res.toSouth = {}
                    res.toSouth.x = roadInfo.min + 2
                    res.toSouth.y = y - 50
                    res.toSouth.dir = IsoDirections.S

                    for dy=y-50, y+50, 5 do
                        local roadInfo = getInfo(x, dy)
                        if not roadInfo.valid then
                            res.valid = false
                            break
                        end
                    end
                end
            end
        end
        return res
    end

    local px = math.floor(player:getX()+0.5)
    local py = math.floor(player:getY()+0.5)

    -- find all possible spawn points
    local list = {}
    for x=px-25, px+25, 5 do
        local res = checkPoint (x, py)
        if res.valid then 
            table.insert(list, res)
        end
    end

    for y=py-25, py+25, 5 do
        local res = checkPoint (px, y)
        if res.valid then 
            table.insert(list, res)
        end
    end

    if #list == 0 then return end

    for i = #list, 2, -1 do
        local j = ZombRand(i) + 1
        list[i], list[j] = list[j], list[i]
    end

    local res = list[1]
    if res.valid then
        local x, y, dir
        local btype = BWOCompatibility.GetCarType(BanditUtils.Choice(BWOVehicles.carChoices))
        if res.toNorth and res.toSouth then
            if ZombRand(2) == 0 then
                x = res.toNorth.x
                y = res.toNorth.y
                dir = res.toNorth.dir
            else
                x = res.toSouth.x
                y = res.toSouth.y
                dir = res.toSouth.dir
            end
        elseif res.toEast and res.toWest then
            if ZombRand(2) == 0 then
                x = res.toEast.x
                y = res.toEast.y
                dir = res.toEast.dir
            else
                x = res.toWest.x
                y = res.toWest.y
                dir = res.toWest.dir
            end
        end
        BWOVehicles.VehicleSpawn(x, y, dir, btype)
    end
end

local dirMap = {}
dirMap.N = {}
for y=-12, -4 do
    for x=-1, 1 do
        table.insert(dirMap.N, {x=x, y=y})
    end
end

dirMap.S = {}
for y=4, 12 do
    for x=-1, 1 do
        table.insert(dirMap.S, {x=x, y=y})
    end
end

dirMap.W = {}
for x=-20, -4 do
    for y=-1, -1 do
        table.insert(dirMap.W, {x=x, y=y})
    end
end

dirMap.E = {}
for x=4, 12 do
    for y=-1, 1 do
        table.insert(dirMap.E, {x=x, y=y})
    end
end

BWOVehicles.dirMap = dirMap

local AddVehicles = function()

    if BWOScheduler.WorldAge > 168 then return end
    
    local players = (BWOUtils and BWOUtils.GetAllPlayers) and BWOUtils.GetAllPlayers() or nil
    if type(players) ~= "table" or #players == 0 then return end
    local player = BanditUtils.Choice(players)

    local gametime = getGameTime()
    local hour = gametime:getHour()
    local minute = gametime:getMinutes()

    if minute % 2 == 1 then return end

    local cnt = 0
    for _, _ in pairs(BWOVehicles.tab) do
        cnt = cnt + 1
    end
    
    local max = 0
    if hour == 5 then
        max = math.floor(SandboxVars.BanditsWeekOne.VehiclesMax / 3)
    elseif hour >= 6 and hour < 19 then
        max = SandboxVars.BanditsWeekOne.VehiclesMax
    elseif hour >= 20 and hour < 23 then
        max = math.floor(SandboxVars.BanditsWeekOne.VehiclesMax / 3)
    end
    
    if cnt < max then
        BWOVehicles.FindSpawnPoint(player)
    end
end

-- Disabled: this periodic spawner caused "uncontrolled" vehicle spawns near players
-- (it picks a random player and spawns a vehicle on nearby roads every 2 minutes).
-- If you ever want to re-enable it, restore the event hook below.
-- Events.EveryOneMinute.Add(AddVehicles)
