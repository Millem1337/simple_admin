sadmin.framework:CreateCommand(
    "setmoney",
    {
        desc = "Set money to character",
        priority = true,
        args = {
            money = {
                placeholder = "$",
                type = "text"
            },
        }
    },
    function( sender, target, args )
        local money = args["money"]

        target:GetCharacter():SetMoney(money)
        return true
    end
)