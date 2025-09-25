sadmin.framework:CreateCommand(
    "additem",
    {
        desc = "Add item to inventory",
        priority = true,
        args = {
            item_class = {
                placeholder = "Item Class",
                type = "select",
                select = table.GetKeys(rp.inventory.items)
            },
            inventory_index = {
                placeholder = "Inventory index",
                type = "text",
                placeholder = "inventory index"
            }
        }
    },
    function( sender, target, args )
        local item_class = args["item_class"]
        local inventory_index = tonumber(args["inventory_index"]) or 1

        target:GetInventories()[inventory_index]:AddItem( ItemStack(item_class) )
        return true
    end
)