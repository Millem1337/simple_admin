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
        return true
    end
)