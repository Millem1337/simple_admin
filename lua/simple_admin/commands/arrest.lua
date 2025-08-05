sadmin.framework:CreateCommand(
    "arrest",
    {
        desc = "arrest",
        priority = true,
        args = {
					time = "Time in seconds",
					reason = "Reason"
				}
    },
    function( sender, target, args )
        target:Arrest(NULL, tonumber(args["time"]), args["reason"])
        return true
    end
)