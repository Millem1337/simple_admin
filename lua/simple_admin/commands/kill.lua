sadmin.framework:CreateCommand(
    "kill",
    {
        desc = "Kill character",
        priority = true,
        args = {
        }
    },
    function( sender, target, args )
        target:Kill()
        return "Вы убили " .. target:GetName()
    end
)