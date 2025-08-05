sadmin.framework:CreateCommand(
    "wanted",
    {
        desc = "Set wanted to character",
        priority = true,
        args = {
        }
    },
    function( sender, target, args )
        target:GetCharacter():SetWanted(not target:GetCharacter():GetWanted())
        return true
    end
)