BWOServerCommands = BWOServerCommands or {}
BWOServerCommands.Commands = BWOServerCommands.Commands or {}
BWOServerCommands.Events = BWOServerCommands.Events or {}

BWOServerCommands.Events.Ping = function(args)
    print ("PING received from server for player " .. tostring(args.pid))
end

BWOServerCommands.ZombieRemove = function(args)
    local zombie = BanditZombie.GetInstanceById(args.zid)
    if zombie then
        zombie:removeFromWorld()
        zombie:removeFromSquare()
    end
end


