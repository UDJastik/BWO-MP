-- BanditsWeekOneMP - optional hooks for the standalone Bandits mod.
-- Goal: react to NPC gunshots (Bandits' ZAShoot action) by notifying the MP server.

BWOBanditsHooks = BWOBanditsHooks or {}

local patched = false
local lastShotById = {}

local function tryPatchZAShoot()
    if patched then return true end

    -- Try to load Bandits' shoot action (safe if mod not installed).
    pcall(require, "ZombieActions/ZAShoot")

    if not ZombieActions or not ZombieActions.Shoot or type(ZombieActions.Shoot.onComplete) ~= "function" then
        return false
    end

    local original = ZombieActions.Shoot.onComplete
    ZombieActions.Shoot.onComplete = function(bandit, task)
        local ok = original(bandit, task)

        -- Only the local client should report; server will fan-out behavior.
        local player = getPlayer()
        if player and bandit and task then
            -- Throttle per-shooter to avoid spamming (full-auto can call onComplete frequently).
            local zid = (BanditUtils and BanditUtils.GetZombieID and BanditUtils.GetZombieID(bandit)) or tostring(bandit)
            local now = getTimestampMs and getTimestampMs() or (getGameTime() and getGameTime():getWorldAgeHours() * 3600000) or 0
            local last = lastShotById[zid] or 0
            if (now - last) > 250 then
                lastShotById[zid] = now
                sendClientCommand(player, "Commands", "NPCGunshot", {
                    x = bandit:getX(),
                    y = bandit:getY(),
                    z = bandit:getZ(),
                    radius = 40,
                })
            end
        end

        return ok
    end

    patched = true
    return true
end

-- Patch as soon as possible, but also retry shortly after game start for load-order safety.
Events.OnGameStart.Add(function()
    if tryPatchZAShoot() then return end
    local retryFn
    retryFn = function()
        if tryPatchZAShoot() then
            Events.EveryOneMinute.Remove(retryFn)
        end
    end
    Events.EveryOneMinute.Add(retryFn)
end)


