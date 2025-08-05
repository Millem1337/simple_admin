sadmin.framework:CreateCommand(
    "sethunger",
    {
        desc = "Set hunger to character",
        priority = true,
        args = {
            hunger = "Hunger",
        }
    },
    function( sender, target, args )
        local hunger = args["hunger"]

        target:GetCharacter():SetHunger(hunger)
        return true
    end
)