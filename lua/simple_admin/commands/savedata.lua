sadmin.framework:CreateCommand(
    "savedata",
    {
        desc = "savedata",
        priority = true,
        args = {
        }
    },
    function( sender, target, args )
        sadmin.framework:SaveDatabase(target)
        return "savedata " .. target:GetName()
    end
)