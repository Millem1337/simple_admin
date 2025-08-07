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
        local ug = args["group"]
        if not sadmin.ranks[ug] then
            return "group doesn't exist"
        end

        if sadmin.ranks[ug].priority > sadmin.ranks[sender:GetUserGroup()].priority then
            return "group priority is higher then yours"
        end

        target:SetUserGroup(ug)
        return true
    end
)