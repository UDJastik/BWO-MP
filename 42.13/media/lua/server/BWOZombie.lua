-- keep your globals exactly as before
BWOZombie = BWOZombie or {}

require "BWODebug"
require "BWOGMD"

-- consists of IsoZombie instances
BWOZombie.Cache = BWOZombie.Cache or {}

-- cache light consists of only necessary properties for fast manipulation
-- this cache has all zombies and bandits
BWOZombie.CacheLight = BWOZombie.CacheLight or {}

-- this cache has all zombies without bandits
BWOZombie.CacheLightZ = BWOZombie.CacheLightZ or {}

-- this cache has all bandit without zombies
BWOZombie.CacheLightB = BWOZombie.CacheLightB or {}

-- localize frequently-used globals for speed
local GetZombieID = BanditUtils.GetZombieID
local IsReanimated = BanditCompatibility.IsReanimatedForGrappleOnly
local GetBrain = BanditBrain.Get

-- local references to the cache tables (fast)
local Cache        = BWOZombie.Cache
local CacheLight   = BWOZombie.CacheLight
local CacheLightZ  = BWOZombie.CacheLightZ
local CacheLightB  = BWOZombie.CacheLightB

local sum = 0
local invocations = 0

local function removeZombieFromCaches(id)
    Cache[id] = nil
    CacheLight[id] = nil
    CacheLightB[id] = nil
    CacheLightZ[id] = nil
end

local function countTable(t)
    local c = 0
    if not t then return c end
    for _ in pairs(t) do c = c + 1 end
    return c
end

local function getRoomId(zombie)
    -- `zombie:getSquare()` may be Java-null temporarily (streaming/despawn edge cases),
    -- which would crash when we try to call `:getRoom()` on it.
    if not zombie then return nil end
    local square = zombie:getSquare()
    if not square then return nil end

    local room = square:getRoom()
    if not room then return nil end

    local roomDef = room:getRoomDef()
    if not roomDef then return nil end

    return roomDef:getIDString()
end

local function onZombieUpdate(zombie)
    if not isServer() then return end
    local ts = getTimestampMs()
    -- cheap early-outs first
    if IsReanimated(zombie) or zombie:isRagdoll() or not zombie:isAlive() then
        local id = GetZombieID(zombie)
        if Cache[id] then removeZombieFromCaches(id) end
        return
    end

    local id = GetZombieID(zombie)

    -- always store the raw zombie reference
    Cache[id] = zombie

    -- reuse existing light table to avoid allocating each tick
    local light = CacheLight[id]
    if not light then
        light = {}
        CacheLight[id] = light
    end

    -- update only what changed (optional micro-optimization)
    light.id = id
    light.x = zombie:getX()
    light.y = zombie:getY()
    light.z = zombie:getZ()
    light.d = zombie:getDirectionAngle()

    -- Dedicated servers may not have the "Bandit" variable set (it's commonly set client-side).
    -- Fall back to Bandits GMD cluster state to detect bandits reliably server-side.
    local isBandit = zombie:getVariableBoolean("Bandit")
    local gmd = nil
    if (not isBandit) and GetBanditClusterData and id then
        gmd = GetBanditClusterData(id)
        if gmd and gmd[id] then
            isBandit = true
        end
    end

    -- If cluster says it's a bandit but the variable isn't set, set it serverside to make downstream logic consistent.
    if isBandit and (not zombie:getVariableBoolean("Bandit")) then
        zombie:setVariable("Bandit", true)
    end

    light.isBandit = isBandit
    if isBandit then
        -- Prefer modData brain when present; otherwise pull from cluster data
        local brain = GetBrain(zombie)
        if (not brain) and (not gmd) and GetBanditClusterData and id then
            gmd = GetBanditClusterData(id)
        end
        if (not brain) and gmd and id then
            brain = gmd[id]
        end
        -- Ensure the brain is attached to the zombie modData (Bandits helpers rely on BanditBrain.Get()).
        if brain and BanditBrain and BanditBrain.Update then
            if not GetBrain(zombie) then
                BanditBrain.Update(zombie, brain)
                zombie:getModData().brainId = brain.id
            end
        end

        -- WeekOneMP safety: ensure Army variants actually have weapons.
        -- Some spawn paths / profile variants can end up with BareHands + empty firearm slots, which makes Army flee forever.
        if brain and Bandit and Bandit.clanMap and BanditWeapons and BanditWeapons.Make then
            local cid = brain.cid or brain.clan
            local isArmy =
                (cid == Bandit.clanMap.ArmyGreen) or
                (cid == Bandit.clanMap.ArmyGreenMask) or
                (cid == Bandit.clanMap.ArmyDesert) or
                (cid == Bandit.clanMap.Officer)

            if isArmy then
                brain.weapons = brain.weapons or {}
                brain.weapons.primary = brain.weapons.primary or { bulletsLeft = 0, magCount = 0 }
                brain.weapons.secondary = brain.weapons.secondary or { bulletsLeft = 0, magCount = 0 }
                if not brain.weapons.melee then
                    brain.weapons.melee = "Base.BareHands"
                end

                local hasPrimary = type(brain.weapons.primary) == "table" and brain.weapons.primary.name ~= nil
                local hasSecondary = type(brain.weapons.secondary) == "table" and brain.weapons.secondary.name ~= nil
                local hasMelee = brain.weapons.melee and brain.weapons.melee ~= "Base.BareHands"

                if (not hasPrimary) and (not hasSecondary) and (not hasMelee) and (not brain._bwoWeaponsFixed) then
                    -- Try a few vanilla-safe fallbacks.
                    local primary = BanditWeapons.Make("Base.AssaultRifle", 2) or BanditWeapons.Make("Base.AssaultRifle2", 2)
                    local secondary = BanditWeapons.Make("Base.Pistol2", 2) or BanditWeapons.Make("Base.Pistol", 2)

                    if primary then brain.weapons.primary = primary end
                    if secondary then brain.weapons.secondary = secondary end
                    brain.weapons.melee = "Base.HuntingKnife"
                    brain._bwoWeaponsFixed = true

                    -- If this brain comes from a cluster entry, make sure the cluster is transmitted after mutation.
                    if GetBanditClusterData and TransmitBanditCluster and id then
                        TransmitBanditCluster(id)
                    end
                end
            end
        end

        light.brain = brain
        light.rid = getRoomId(zombie)
        CacheLightB[id] = light
        CacheLightZ[id] = nil
    else
        light.brain = nil
        CacheLightZ[id] = light
        CacheLightB[id] = nil
    end
    sum = sum + (getTimestampMs() - ts)
    invocations = invocations + 1
end

local function onZombieDead(zombie)
    if not isServer() then return end
    local id = GetZombieID(zombie)
    if (not id) and BanditUtils and BanditUtils.GetCharacterID then
        id = BanditUtils.GetCharacterID(zombie)
    end
    if not id then return end

    -- WeekOneMP has an early-world cleanup that removes corpses not present in BWOGMD.DeadBodies.
    -- In MP, a bandit may die without the local client's OnZombieDead registering it, which can
    -- make the corpse (and its loot) disappear. Register bandit deaths server-side so the
    -- cleanup logic doesn't delete them.
    if BWOScheduler and BWOScheduler.World and BWOScheduler.World.DeadBodyRemover then
        -- IMPORTANT:
        -- Some Bandits (notably "civilian"/"army" variants) can die before the server ever sees
        -- their "Bandit" variable set (spawn/streaming/one-shot edge-case). If we rely only on
        -- zombie:getVariableBoolean("Bandit"), BWOSquareLoader's early-world DeadBodyRemover will
        -- delete the corpse (and its loot/clothes) because BWOGMD.DeadBodies isn't populated.
        -- Detect bandits using the same heuristics as server population control: var OR brain OR cluster.
        local isBandit = false
        if zombie.getVariableBoolean and zombie:getVariableBoolean("Bandit") then
            isBandit = true
        end
        if (not isBandit) and BanditBrain and BanditBrain.Get then
            local brain = BanditBrain.Get(zombie)
            if brain then isBandit = true end
        end
        if (not isBandit) and GetBanditClusterData then
            local g = GetBanditClusterData(id)
            if g and g[id] then isBandit = true end
        end

        if isBandit then
            local gmd = BWOGMD.Get()
            if gmd and gmd.DeadBodies then
                local x, y, z = zombie:getX(), zombie:getY(), zombie:getZ()
                local key = math.floor(x) .. "-" .. math.floor(y) .. "-" .. math.floor(z)
                -- keep floats in payload (used by some "react to corpse" behaviors), but key by square coords
                gmd.DeadBodies[key] = { x = x, y = y, z = z }
            end
        end
    end

    -- Always clear BWOMP queue entry so deleter won't keep skipping a dead zombie id.
    local bwomp = ModData.getOrCreate("BWOMP")
    if bwomp and bwomp.Queue then
        bwomp.Queue[id] = nil
    end

    -- Remove from Bandits cluster if it existed (prevents cluster bloat and runaway "current").
    if GetBanditClusterData then
        local gmd = GetBanditClusterData(id)
        if gmd and gmd[id] then
            gmd[id] = nil
            TransmitBanditCluster(id)
        end
    end

    if Cache[id] then removeZombieFromCaches(id) end
end

local function flush()
    if not isServer() then return end

    -- prepare local cache vars
    local cache = {}
    local cacheLight = {}
    local cacheLightB = {}
    local cacheLightZ = {}

    local cell = getCell()
    local zombieList = cell:getZombieList()
    local zombieListSize = zombieList:size()

    for i = 0, zombieListSize - 1 do
        local zombie = zombieList:get(i)

        if not BanditCompatibility.IsReanimatedForGrappleOnly(zombie) and not zombie:isRagdoll() then

            local id = BanditUtils.GetZombieID(zombie)

            cache[id] = zombie

            local zx, zy, zz, zd = zombie:getX(), zombie:getY(), zombie:getZ(), zombie:getDirectionAngle()

            local light = {id = id, x = zx, y = zy, z = zz, d = zd}

            local isBandit = zombie:getVariableBoolean("Bandit")
            local brain = nil
            if not isBandit and GetBanditClusterData and id then
                local gmd = GetBanditClusterData(id)
                if gmd and gmd[id] then
                    isBandit = true
                    brain = gmd[id]
                end
            end

            -- Align variable with cluster-derived truth (important for other systems that only check the variable).
            if isBandit and (not zombie:getVariableBoolean("Bandit")) then
                zombie:setVariable("Bandit", true)
            end

            light.isBandit = isBandit
            if isBandit  then
                if not brain then
                    brain = BanditBrain.Get(zombie)
                end
                light.brain = brain
                light.rid = getRoomId(zombie)
                cacheLightB[id] = light
            else
                cacheLightZ[id] = light
            end
            cacheLight[id] = light
        end

    end

    -- recreate global cache vars with new findings
    BWOZombie.Cache = cache
    BWOZombie.CacheLight = cacheLight
    BWOZombie.CacheLightB = cacheLightB
    BWOZombie.CacheLightZ = cacheLightZ

    -- IMPORTANT: keep the module-local cache references in sync.
    -- This file uses local upvalues (Cache/CacheLight/CacheLightB/CacheLightZ) for speed,
    -- so if we reassign the global tables we must also update these upvalues.
    Cache = cache
    CacheLight = cacheLight
    CacheLightB = cacheLightB
    CacheLightZ = cacheLightZ

    -- Debug summary (enable by setting VERBOSE_LVL to 4+ in `shared/BWODebug.lua`)
    if VERBOSE_LVL and VERBOSE_LVL >= 4 then
        dprint(string.format(
            "[BWOZombie][flush] zombies=%s cache=%s light=%s lightZ=%s lightB=%s queue=%s",
            tostring(zombieListSize),
            tostring(countTable(Cache)),
            tostring(countTable(CacheLight)),
            tostring(countTable(CacheLightZ)),
            tostring(countTable(CacheLightB)),
            tostring(countTable(queue))
        ), 4)

        -- Try to explain low lightB: how many entries exist in clusters right now?
        if BanditClusters and BanditClusterCount then
            local clusterTotal = 0
            for c = 0, BanditClusterCount - 1 do
                local cluster = BanditClusters[c]
                if cluster then
                    for _ in pairs(cluster) do
                        clusterTotal = clusterTotal + 1
                    end
                end
            end
            dprint(string.format("[BWOZombie][flush] clusterEntriesTotal=%s", tostring(clusterTotal)), 4)
        end
    end
end

-- returns IsoZombie by id
BWOZombie.GetInstanceById = function(id)
    if BWOZombie.Cache[id] then
        return BWOZombie.Cache[id]
    end
    return nil
end

-- returns all cache
BWOZombie.GetAll = function()
    return BWOZombie.CacheLight
end

-- returns all cached zombies
BWOZombie.GetAllZ = function()
    return BWOZombie.CacheLightZ
end

-- returns all cached bandits
BWOZombie.GetAllB = function()
    return BWOZombie.CacheLightB
end

-- returns size of zombie cache
BWOZombie.GetAllCnt = function()
    return BWOZombie.LastSize
end

Events.OnZombieUpdate.Remove(onZombieUpdate)
Events.OnZombieUpdate.Add(onZombieUpdate)

Events.OnZombieDead.Remove(onZombieDead)
Events.OnZombieDead.Add(onZombieDead)

Events.EveryOneMinute.Remove(flush)
Events.EveryOneMinute.Add(flush)
