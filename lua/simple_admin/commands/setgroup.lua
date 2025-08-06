sadmin.framework:CreateCommand(
    "setgroup",
    {
        desc = "Set group to user",
        priority = true,
        args = {
            group = {
                placeholder = "Group",
                type = "select",
                select = table.GetKeys(sadmin.ranks)
            },
        }
    },
    function( sender, target, args )
        target:SetUserGroup(args["group"])
        return "Вы поставили " .. target:GetName() .. " привилегию " .. args["group"]
    end
)