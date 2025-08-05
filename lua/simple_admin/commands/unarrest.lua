sadmin.framework:CreateCommand(
    "unarrest",
    {
        desc = "unarrest",
        priority = true,
        args = {
        }
    },
    function( sender, target, args )
        target:UnArrest()
        return true
    end
)