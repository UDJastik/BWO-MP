ZombiePrograms = ZombiePrograms or {}

ZombiePrograms.Patrol = {}

ZombiePrograms.Patrol.Prepare = function(bandit)
    local tasks = {}

    Bandit.ForceStationary(bandit, false)
  
    return {status=true, next="Main", tasks=tasks}
end

ZombiePrograms.Patrol.Main = function(bandit)
    local tasks = {}
    local walkType = "Walk"
    local endurance = 0

    -- ---------------------------------------------------------------------
    -- Army-specific "awareness" while patrolling
    -- Patrol is otherwise just wandering/following roads and won't react.
    -- ---------------------------------------------------------------------
    local brain = BanditBrain and BanditBrain.Get and BanditBrain.Get(bandit) or nil
    local isArmy = false
    if brain then
        if brain.occupation == "Army" then
            isArmy = true
        elseif brain.cid and Bandit and Bandit.clanMap then
            local cid = brain.cid
            if cid == Bandit.clanMap.ArmyGreen or cid == Bandit.clanMap.ArmyGreenMask or cid == Bandit.clanMap.Officer then
                isArmy = true
            end
        end
    end

    if isArmy then
        -- If the Army NPC is unarmed, it should flee instead of engaging.
        local unarmed = false
        if brain and brain.weapons then
            local w = brain.weapons
            local hasMelee = w.melee and w.melee ~= "Base.BareHands"
            local hasPrimary = type(w.primary) == "table" and w.primary.name ~= nil
            local hasSecondary = type(w.secondary) == "table" and w.secondary.name ~= nil
            unarmed = (not hasMelee) and (not hasPrimary) and (not hasSecondary)
        end

        -- React to nearby zombies (guards should fight).
        if (not unarmed) and BanditUtils and BanditUtils.GetClosestZombieLocation then
            local closestZombie = BanditUtils.GetClosestZombieLocation(bandit)
            if closestZombie and closestZombie.dist and closestZombie.dist < 15 then
                Bandit.Say(bandit, "SPOTTED")
                Bandit.ClearTasks(bandit)
                Bandit.SetProgram(bandit, "Bandit", {})
                Bandit.ForceStationary(bandit, false)
                return {status=true, next="Prepare", tasks=tasks}
            end
        end

        -- React to nearby player only if Army is already hostile OR player is a threat (has weapon).
        if BanditUtils and BanditUtils.GetClosestPlayerLocation then
            local config = { mustSee = false, hearDist = 40 }
            local closestPlayer = BanditUtils.GetClosestPlayerLocation(bandit, config)
            if closestPlayer and closestPlayer.dist then
                -- Check if player is a threat (has weapon visible)
                local playerIsThreat = false
                local player = BanditPlayer and BanditPlayer.GetPlayerById and BanditPlayer.GetPlayerById(closestPlayer.id) or nil
                if player then
                    local primaryItem = player:getPrimaryHandItem()
                    local secondaryItem = player:getSecondaryHandItem()
                    if (primaryItem and primaryItem.IsWeapon and primaryItem:IsWeapon()) or
                       (secondaryItem and secondaryItem.IsWeapon and secondaryItem:IsWeapon()) then
                        playerIsThreat = true
                    end
                end
                
                local isAlreadyHostile = (brain and brain.hostileP) or (Bandit and Bandit.IsHostile and Bandit.IsHostile(bandit))
                
                -- Only react if Army is already hostile OR player is a threat
                if isAlreadyHostile or playerIsThreat then
                    local mindist = 6
                    if isAlreadyHostile then
                        mindist = 50
                    end
                    if closestPlayer.dist < mindist then
                        Bandit.Say(bandit, "SPOTTED")
                        Bandit.ClearTasks(bandit)
                        if unarmed then
                            Bandit.SetProgram(bandit, "Active", {})
                            if Bandit.SetProgramStage then
                                Bandit.SetProgramStage(bandit, "Escape")
                            end
                        else
                            Bandit.SetProgram(bandit, "Bandit", {})
                            Bandit.SetHostileP(bandit, true)
                        end
                        Bandit.ForceStationary(bandit, false)
                        return {status=true, next="Prepare", tasks=tasks}
                    end
                end
            end
        end
    end

    local health = bandit:getHealth()
    if health < 0.8 then
        walkType = "Limp"
        endurance = 0
    end 
    
    local subTasks = BanditPrograms.FollowRoad(bandit, walkType)
    if #subTasks > 0 then
        for _, subTask in pairs(subTasks) do
            table.insert(tasks, subTask)
        end
        return {status=true, next="Main", tasks=tasks}
    end

    local subTasks = BanditPrograms.GoSomewhere(bandit, walkType)
    if #subTasks > 0 then
        for _, subTask in pairs(subTasks) do
            table.insert(tasks, subTask)
        end
        return {status=true, next="Main", tasks=tasks}
    end

    -- fallback
    local subTasks = BanditPrograms.FallbackAction(bandit)
    if #subTasks > 0 then
        for _, subTask in pairs(subTasks) do
            table.insert(tasks, subTask)
        end
    end

    return {status=true, next="Main", tasks=tasks}
end

