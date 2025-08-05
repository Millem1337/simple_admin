sadmin.framework:CreateCommand(
    "ban",
    {
        desc = "Blocks the player from entering the server for a time.",
        priority = true,
        args = {
            time = "Time in seconds",
        }
    },
    function( sender, target, args )
        local time = args["time"]

        target:Ban(time/60, true)
        return true
    end
)