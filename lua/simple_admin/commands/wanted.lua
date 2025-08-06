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
        if (target:GetCharacter():GetWanted() == false ) then
            return "Игроку " .. target:GetName() .. " был выдан розыск"
        else 
            return "Игроку " .. target:GetName() .. " был снят розыск"
        end
    end
)