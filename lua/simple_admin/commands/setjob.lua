sadmin.framework:CreateCommand(
    "setjob",
    {
        desc = "Set job to character",
        priority = true,
        args = {
            job = "job",
        }
    },
    function( sender, target, args )
        target:GetCharacter():ChangeJob(tonumber(args["job"]), true)
        return true
    end
)