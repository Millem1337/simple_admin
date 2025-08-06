sadmin.framework:CreateCommand(
    "ban",
    {
        desc = "Blocks the player from entering the server for a time.",
        priority = true,
        args = {
            time = {
                placeholder = "Time in seconds",
                type = "text"
            },
        }
    },
    function( sender, target, args )
        local time = args["time"]

        target:Ban(time/60, true)
        return "Вы забанили игрока " .. target:GetName() .. " на " .. args["time"] .. "сек."
    end
)