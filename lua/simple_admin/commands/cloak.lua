local v = Color(255,255,255,255)
local iv = Color(255,255,255,0)

sadmin.framework:CreateCommand(
    "cloak",
    {
        desc = "Cloaks player",
        priority = true,
        args = {
        }
    },
    function( sender, target, args )
        local colora = target:GetColor().a
        if colora == 0 then
            target:SetColor(v)
            return "Вы сделали видимым игрока " .. target:GetName()
        else
            target:SetColor(iv)
            return "Вы сделали невидимым игрока " .. target:GetName()
        end
    end
)