sadmin.framework:CreateCommand(
    "freeze",
    {
        desc = "freeze player",
        priority = true,
        args = {
        }
    },
    function( sender, target, args )
				if (target:IsFlagSet(FL_FROZEN) and target:IsFlagSet(FL_GODMODE)) then
					target:RemoveFlags(FL_FROZEN)
					target:RemoveFlags(FL_GODMODE)
                    return "Вы разморозили игрока " .. target:GetName()
				else
                    target:AddFlags(FL_FROZEN)
                    target:AddFlags(FL_GODMODE)                   
                    return "Вы заморозили игрока " .. target:GetName()
				end
    end
)