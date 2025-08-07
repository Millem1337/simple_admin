sadmin.framework:CreateCommand(
    "spawn",
    {
        desc = "tp to spawn character",
        priority = true,
        args = {
        }
    },
    function( sender, target, args )
        target:Spawn()
        return "Вы телепортировали " .. target:GetName() .. " на спавн"
    end
)