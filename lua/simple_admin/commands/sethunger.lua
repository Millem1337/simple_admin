sadmin.framework:CreateCommand(
    "sethunger",
    {
        desc = "Set hunger to character",
        priority = true,
        args = {
            hunger = {
                placeholder = "hunger",
                type = "text"
            },
        }
    },
    function( sender, target, args )
        local hunger = args["hunger"]

        target:GetCharacter():SetHunger(hunger)
        return "Вы поставили " .. target:GetName() .. " " .. args["hunger"] .. " единиц голода"
    end
)