-- keep your globals exactly as before
BWOZombie = BWOZombie or {}

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

local function getRoomId(zombie)
    local room = zombie:getSquare():getRoom()
    if room then
        local roomDef = room:getRoomDef()
        if roomDef then
            return roomDef:getIDString()
        end
    end
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

    local isBandit = zombie:getVariableBoolean("Bandit")
    light.isBandit = isBandit
    if isBandit then
        -- if GetBrain is expensive, consider caching it on enter-bandit only
        light.brain = GetBrain(zombie)
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
    local queue = (BWOGMD and BWOGMD.data and BWOGMD.data.Queue) or ModData.getOrCreate("BWOMP").Queue
    if isBandit and zombie:isAlive() then
        queue[id] = true
    else
        queue[id] = nil
    end
end

local function onZombieDead(zombie)
    if not isServer() then return end
    local id = GetZombieID(zombie)
    if not id then return end
    local queue = (BWOGMD and BWOGMD.data and BWOGMD.data.Queue) or ModData.getOrCreate("BWOMP").Queue
    queue[id] = nil
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
            light.isBandit = isBandit
            if isBandit  then
                light.brain = BanditBrain.Get(zombie)
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
