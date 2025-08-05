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
					target:RemoveFlags(64)
					target:RemoveFlags(32768)
				else target:Lock()
				end
        return true
    end
)