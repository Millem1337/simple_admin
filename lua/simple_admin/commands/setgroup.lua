sadmin.framework:CreateCommand(
    "setgroup",
    {
        desc = "Set group to user",
        priority = true,
        args = {
            group = "Group",
        }
    },
    function( sender, target, args )
        target:SetUserGroup(args["group"])
        return true
    end
)