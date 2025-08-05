sadmin.framework:CreateCommand(
    "addmoney",
    {
        desc = "Add money to character",
        priority = true,
        args = {
            money = "$ Money",
        }
    },
    function( sender, target, args )
        local money = args["money"]

        target:GetCharacter():AddMoney(money)
        return true
    end
)