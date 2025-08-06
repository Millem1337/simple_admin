sadmin.framework:CreateCommand(
    "arrest",
    {
        desc = "arrest",
        priority = true,
        args = {
            time = {
                placeholder = "Time in seconds",
                type = "text"
            },
            reason = {
                placeholder = "Reason",
                type = "text"
            },
        }
    },
    function( sender, target, args )
        target:Arrest(NULL, tonumber(args["time"]), args["reason"])
        return "Вы выдали арест игроку " .. target:GetName() .. " на " .. args["time"] .. "сек. По причине: " .. args["reason"]
    end
)