sadmin.framework:CreateCommand(
    "goto",
    {
        desc = "Teleport to player",
        priority = true,
        args = {
        }
    },
    function( sender, target, args )
        sender:SetPos(target:GetPos())
        return "Вы телепортировались " .. target:GetName()
    end
)