RegisterCommand("timecycle", function(source, args)
    if args[1] then
        if args[1] == "reset" then
            ClearTimecycleModifier()
        else
            SetTimecycleModifier(args[1])
        end
    end
end, false) 