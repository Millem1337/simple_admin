sadmin.framework:CreateCommand(
    "warn",
    {
        desc = "Warn admin",
        priority = true,
        args = {
        }
    },
    function( sender, target, args )
        return true
    end
)