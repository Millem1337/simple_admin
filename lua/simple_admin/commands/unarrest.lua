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
        return "Вы сняли арест игроку " .. target:GetName()
    end
)