sadmin.framework:CreateCommand(
    "ban",
    {
        desc = "Blocks the player from entering the server for a time.",
        args = {
            player = "Player",
            time = "Time",
        }
    },
    function( executor, args )
        if #args < 2 then
            return
        end
    end
)