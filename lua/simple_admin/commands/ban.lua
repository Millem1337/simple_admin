sadmin.framework:CreateCommand(
    "ban",
    {
        desc = "Blocks the player from entering the server for a time.",
        priority = true,
        args = {
            time = "Time in seconds",
        }
    },
    function( sender, ply, args )
        local time = args["time"]

        ply:Ban(time/60, true)
    end
)