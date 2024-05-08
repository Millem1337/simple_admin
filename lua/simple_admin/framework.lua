sadmin = sadmin or {}
sadmin.debug = true
sadmin.nets = {
    update_commands = "sadmin.nets.update.commands", -- Update all the commands
    update_ranks = "sadmin.nets.update.ranks", -- Update all the ranks
    notify = "sadmin.nets.other.notify", -- Notify player
}

function sadmin:print( s )
    if not sadmin.debug then return false end
    if type(s) ~= "table" then
        print( "SADMIN DEBUG: " .. s )
    else
        print( "SADMIN DEBUG TABLE: " )
        PrintTable( s )
    end
end

if SERVER then
    sadmin.commands = sadmin.commands or {}
    sadmin.framework = sadmin.framework or {}
    sadmin.ranks = sadmin.ranks or {}
    --[[
        CreateCommand( name, data, func ) - Creating command :). Returns false if command already exists!
        name: Name of the command (eg. ban) -- string
        data: Data of the command -- table
        {
            desc: "Description", -- string
            args: { -- All arguments must be checked in function. First is always sender. -- table
                ["player"] = "player", -- First argument in func : placeholder in textentry
                ["time"] = "time",
            }
        }

        func: Function te command. Accepting table of arguments. Return string with error or nil. -- function
    ]]
    function sadmin.framework:CreateCommand( name, data, func )
        if sadmin.commands[name] then
            return false
        end
        local command = { // TODO: Remove name
            name = name,
            data = data,
            func = func,
        }
        sadmin.commands[name] = command
        return true -- Success
    end

    --[[
        Notigy( ply, s ) - Notifies the player
        ply: Player or nil
        s: string to send
    ]]

    function sadmin.framework:Notify( ply, s )
        net.Start(sadmin.nets.notify)
            net.WriteString( s )
        net.Send( ply )
    end

    --[[
        Execute( name, args ) - Execute the command. Returns false if command doesn't exists
        ply: Player or nil
        name: Name of the command (eg. ban) -- string
        args: Table of the command -- table
    ]]
    function sadmin.framework:Execute( ply, name, args )
        if not sadmin.commands[name] then
            return false
        end
        local res = sadmin.commands[name].func( ply, args )
        sadmin:print( res )
        if IsValid(res) and IsValid(ply) then
            sadmin.framework:Notify( ply, res )
        end
    end
    
    --[[
        CreateRank( name, data ) - Creating Rank :). Returns false if rank already exists!
        name: Name of the rank (eg. root) -- string
        data: Data of the rank -- table
        {
            access: { -- All access commands
                ban = true
            }
        }
    ]]
    function sadmin.framework:CreateRank( name, data )
        if sadmin.ranks[name] then
            return false
        end
        local rank = { // TODO: Remove name
            name = name,
            data = data,
        }
        sadmin.ranks[name] = rank
        return true -- Success
    end

    --[[
        CanUse( ply, name ) - Can execute player. Return true if it can or false if not
        ply: Player (eg. root) -- player
        data: Name of the command -- table
        {
            access: { -- All access commands
                ban = true
            }
        }
    ]]
    function sadmin.framework:CanUse( ply, name )
        local rank_data = sadmin.ranks[ply:GetUserGroup()]

        sadmin.print(IsValid(rank_data[name]))
        return IsValid(rank_data[name])
    end

    --[[
        UpdatePlayer( ply ) - Updating all info on clientside.
        ply: Player -- player
    ]]
    function sadmin.framework:UpdatePlayer( ply )
        // TODO: Remove function before sending to the client
        local commands = table.Copy(sadmin.commands)
        for k, v in pairs(commands) do 
            v.func = nil
        end

        net.Start(sadmin.nets.update_commands)
            net.WriteTable(commands)
        net.Send(ply)

        net.Start(sadmin.nets.update_ranks)
            net.WriteTable(sadmin.ranks)
        net.Send(ply)
    end

    function sadmin.framework:LoadCommands()
        local commands = file.Find("simple_admin/commands/*", "LUA")
        for k, v in pairs(commands) do
            sadmin:print("simple_admin/commands/" .. v)
            include("simple_admin/commands/" .. v)
        end
    end

    function sadmin.framework:LoadRanks()
        local commands = file.Find("simple_admin/ranks/*", "LUA")
        for k, v in pairs(commands) do
            sadmin:print("simple_admin/ranks/" .. v)
            include("simple_admin/ranks/" .. v)
        end
    end

    function sadmin.framework:LoadNets()
        for k, v in pairs( sadmin.nets ) do
            sadmin:print(k .. ": " .. v )
            util.AddNetworkString( v )
        end
    end

    function sadmin.framework:LoadDatabase()
        // TODO: Create loading database.
    end

    function sadmin.framework:LoadUp()
        sadmin.framework:LoadRanks()
        sadmin.framework:LoadCommands()
        sadmin.framework:LoadNets()
    end

    function sadmin.framework:LoadPlayer( ply )
        -- Get rank from database
        sadmin.framework:LoadDatabase()
        -- UpdatePlayer
        sadmin.framework:UpdatePlayer( ply )
    end

    -- HOOKS:

    hook.Add("Initialize", "fadmin.hooks.init", function()
        sadmin.framework:LoadUp()
    end)

    hook.Add("PlayerInitialSpawn", "fadmin.hooks.init_spawn", function( ply )
        sadmin.framework:LoadPlayer( ply )
    end)
end
if CLIENT then
    sadmin.commands = sadmin.commands or {}
    sadmin.framework = sadmin.framework or {}
    sadmin.ranks = sadmin.ranks or {}

    net.Receive(sadmin.nets.update_commands, function()
        local commands = net.ReadTable()
        sadmin:print( commands )
        sadmin.commands = commands
    end)

    net.Receive(sadmin.nets.update_ranks, function()
        local commands = net.ReadTable()
        sadmin:print( commands )
        sadmin.ranks = commands
    end)

end