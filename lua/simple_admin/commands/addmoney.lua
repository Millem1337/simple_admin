sadmin.framework:CreateCommand(
    "addmoney",
    {
        desc = "Add money to character",
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

        target:GetCharacter():AddMoney(money)
        return "Вы добавили " .. target:GetName() .. " " .. args["money"] .. "$"
    end
)