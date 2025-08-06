sadmin.framework:CreateCommand(
    "bring",
    {
        desc = "Brings player",
        priority = true,
        args = {
        }
    },
    function( sender, target, args )
        target:SetPos(sender:GetPos())
        return "Вы телепортировали к себе " .. target:GetName()
    end
)