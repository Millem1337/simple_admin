local select_jobs = {}
hook.Add("InitPostEntity", "sadmin.selectojobs", function()
    for k, v in pairs(jobs) do
        select_jobs[k] = v.name
    end
end)

sadmin.framework:CreateCommand(
    "setjob",
    {
        desc = "Set job to character",
        priority = true,
        args = {
            job = {
                placeholder = "Job",
                type = "select",
                select = select_jobs
            },
        }
    },
    function( sender, target, args )
        local job = FindJob(args["job"])
        if job then
            target:GetCharacter():ChangeJob(tonumber(job), true)
        end
        return true
    end
)