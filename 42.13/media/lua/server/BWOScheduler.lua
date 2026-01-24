-- Compatibility shim: BWOScheduler now lives inside BWOEventManager.
if not BWOEventManager then
    require "BWOEventManager"
end

BWOScheduler = BWOEventManager

return BWOScheduler
