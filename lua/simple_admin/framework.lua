sadmin = sadmin or {}
sadmin.debug = false
sadmin.nets = {
    update_commands = "sadmin.nets.update.commands", -- Update all the commands
    update_ranks = "sadmin.nets.update.ranks", -- Update all the ranks
    notify = "sadmin.nets.other.notify", -- Notify player
    execute = "sadmin.nets.execute",
}

function sadmin:print( s )
    if not sadmin.debug then return false end
    if type(s) ~= "table" then
        print( "SADMIN DEBUG: " .. tostring(s) )
    else
        print( "SADMIN DEBUG TABLE: " )
        PrintTable( s )
    end
end

sadmin.noicon = Material("icon16/brick.png")

if SERVER then
    sadmin.commands = sadmin.commands or {}
    sadmin.framework = sadmin.framework or {}
    sadmin.ranks = sadmin.ranks or {}

    sql.Query("create table if not exists sadmin_ranks (steamid64 bigint not null, rank varchar(30), primary key (steamid64))")

    --[[
        CreateCommand( name, data, func ) - Creating command :). Returns false if command already exists!
        name: Name of the command (eg. ban) -- string
        data: Data of the command -- table
        {
            desc: "Description", -- string
            priority: true, -- is priority working
            args: { -- All arguments must be checked in function. First is always sender. -- table
                ["time"] = {
                    placeholder = "time",
                    type = "text"
                },
            }
        }

        func: Function command. Accepting player and table of arguments. Return string with error or nil. -- function
    ]]
    function sadmin.framework:CreateCommand( name, data, func )
        if sadmin.commands[name] then
            return false
        end
        local command = {
            name = name,
            data = data,
            func = func,
        }
        sadmin.commands[name] = command
        return true -- Success
    end

    --[[
        Notify( ply, s ) - Notifies the player
        ply: Player or nil
        s: string to send
    ]]

    function sadmin.framework:Notify( ply, s )
        net.Start(sadmin.nets.notify)
            net.WriteString( tostring(s) )
        net.Send( ply )
    end

    --[[
        Execute( name, args ) - Execute the command. Returns false if command doesn't exists
        ply: Player or nil
        name: Name of the command (eg. ban) -- string
        args: Table of the command -- table
    ]]
    function sadmin.framework:Execute( sender, to, name, args )
        sadmin:print( "Executing" )
        if not sadmin.commands[name] then
            sadmin.framework:Notify( sender, "Command not found!" )
            return false
        end
        local res = sadmin.commands[name].func( sender, to, args )
        sadmin:print( res or "" )
        if res and sender then
            sadmin.framework:Notify( sender, res )
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
    function sadmin.framework:CreateRank( name, priority, data, icon )
        icon = icon or sadmin.noicon

        if sadmin.ranks[name] then
            return false
        end
        local rank = { // TODO: Remove name
            name = name,
            priority = priority,
            access = data,
            icon = icon
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
        sadmin:print(ply, name)
        local rank_data = sadmin.ranks[ply:GetUserGroup()] or {}
        sadmin:print(rank_data)
        if rank_data.access then
            sadmin:print(rank_data.access[name])
            return rank_data.access[name]
        end
        return false
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

        /*net.Start(sadmin.nets.update_ranks)
            net.WriteTable(sadmin.ranks)
        net.Send(ply)*/
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
            AddCSLuaFile("simple_admin/ranks/" .. v)
        end
    end

    function sadmin.framework:LoadNets()
        for k, v in pairs( sadmin.nets ) do
            sadmin:print(k .. ": " .. v )
            util.AddNetworkString( v )
        end
    end

    function sadmin.framework:LoadDatabase( ply )
        // TODO: Create loading database.
        local steamid64 = ply:SteamID64()
        local result = sql.QueryRow(string.format("select rank from sadmin_ranks where steamid64=%s", steamid64))
        PrintTable(result or {})
        if result.rank then
            local rank = result.rank
            ply:SetUserGroup(rank)
        end
    end

    function sadmin.framework:SaveDatabase( ply )
        local steamid64 = ply:SteamID64()
        local rank = ply:GetUserGroup()
        local s = string.format("insert into sadmin_ranks (steamid64, rank) values (%s,'%s') ON CONFLICT(steamid64) DO UPDATE SET rank = '%s'", steamid64, rank, rank)
        print(s)
        
        local result = sql.Query(s)

        PrintTable(result or {})
    end

    function sadmin.framework:LoadUp()
        sadmin.framework:LoadRanks()
        sadmin.framework:LoadCommands()
        sadmin.framework:LoadNets()
    end

    function sadmin.framework:LoadPlayer( ply )
        -- Get rank from database
        sadmin.framework:LoadDatabase( ply )
        -- UpdatePlayer
        sadmin.framework:UpdatePlayer( ply )
    end


    -- HOOKS:

    hook.Add("Initialize", "sadmin.hooks.init", sadmin.framework.LoadUp)

    hook.Add("PlayerInitialSpawn", "sadmin.hooks.init_spawn", function( ply )
        sadmin.framework:LoadPlayer( ply )
        if sadmin.debug then
            ply:SetUserGroup("root")
        end
    end)

    hook.Add("PlayerDisconnected", "sadmin.hooks.save_disconnect", function(ply)
        sadmin.framework:SaveDatabase( ply )
    end)

    net.Receive(sadmin.nets.execute, function( _, ply )
        local to = net.ReadEntity()
        local command = net.ReadString()
        local args = net.ReadTable()

        sadmin:print("Executing 1")
        sadmin:print({sadmin.ranks[ply:GetUserGroup()].priority, sadmin.ranks[to:GetUserGroup()].priority, (sadmin.ranks[ply:GetUserGroup()].priority <= sadmin.ranks[to:GetUserGroup()].priority)})
        if sadmin.framework:CanUse(ply, command) and (sadmin.ranks[ply:GetUserGroup()].priority >= sadmin.ranks[to:GetUserGroup()].priority) then
            sadmin:print("Executing 2")
            sadmin:print(ply:GetName() .. " to " .. to:GetName() .. " used command " .. command .. " with arguments: ")
            sadmin:print(args)
            sadmin.framework:Execute(ply, to, command, args)
        end
    end)

    concommand.Add("sadmin_load", sadmin.framework.LoadUp)
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

    /*net.Receive(sadmin.nets.update_ranks, function()
        local ranks = net.ReadTable()
        sadmin:print( ranks )
        sadmin.ranks = ranks
    end)*/

    function sadmin.framework:LoadRanks()
        local commands = file.Find("simple_admin/ranks/*", "LUA")
        for k, v in pairs(commands) do
            sadmin:print("simple_admin/ranks/" .. v)
            include("simple_admin/ranks/" .. v)
        end
    end

    function sadmin.framework:CreateRank( name, priority, data, icon )
        icon = icon or sadmin.noicon
        sadmin:print("creating rank " .. name)

        if sadmin.ranks[name] then
            return false
        end
        local rank = { // TODO: Remove name
            name = name,
            priority = priority,
            access = data,
            icon = icon
        }
        sadmin.ranks[name] = rank
        return true -- Success
    end

    function sadmin.framework:LoadUp()
        sadmin.framework:LoadRanks()
    end

    hook.Add("Initialize", "sadmin.hooks.init", sadmin.framework.LoadUp)
    concommand.Add("sadmin_loadcl", sadmin.framework.LoadUp)

    net.Receive(sadmin.nets.notify,function()
        notification.AddLegacy(net.ReadString(), NOTIFY_GENERIC, 5)
    end)
end

local metaplayer = FindMetaTable("Player")

local oldsuperadmin = metaplayer.IsSuperAdmin

function metaplayer:IsSuperAdmin()
    return oldsuperadmin(self) or self:GetUserGroup() == "root" or self:GetUserGroup() == "sudoroot"
end

function metaplayer:IsAdmin()
    return self:IsSuperAdmin() or self:GetUserGroup() == "admin"
end