sadmin.framework:CreateCommand(
    "setmoney",
    {
        desc = "Set money to character",
        priority = true,
        args = {
            money = "$ Money",
        }
    },
    function( sender, target, args )
        local money = args["money"]

        target:GetCharacter():SetMoney(money)
        return true
    end
)