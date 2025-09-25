local select_jobs = {}
hook.Add("InitPostEntity", "sadmin.selectojobs", function()
    if rp then
        for k, v in pairs(rp.jobs) do
            select_jobs[k] = v.name
        end
    end
end)

if rp then
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
            return "Вы поставили игроку " .. target:GetName() .. " профессию " .. args["job"]
        end
    )
end