function sadmin:CallMenu()
    local sel_player
    local sel_command
    local s_args = {}

    local frame = vgui.Create("DFrame")
    frame:SetTitle("Simple Admin")
    frame:SetSize(600,500)
    frame:Center()
    frame:MakePopup()
    frame:SetSizable( true )

    local execute = vgui.Create("DButton", frame)
    execute:Dock(BOTTOM)
    execute:SetText("Execute")

    local players = vgui.Create("DScrollPanel", frame)
    players:Dock(LEFT)
    players:DockPadding(5,5,5,5)
    players:SetWide(150)

    local commands = vgui.Create("DScrollPanel", frame)
    commands:Dock(LEFT)
    commands:DockPadding(5,5,5,5)
    commands:DockMargin(5,0,0,0)
    commands:SetWide(100)

    local args = vgui.Create("DScrollPanel", frame)
    args:Dock(LEFT)
    args:DockPadding(5,5,10,5)
    args:DockMargin(5,0,0,0)
    args:SetWide(100)

    local function populate_args()
        args:GetCanvas():Clear() -- Safe clear.
        
        if not sel_command then
            return
        end

        if not sel_player then
            return
        end
    
        for k, v in pairs(sadmin.commands[sel_command].data.args) do
            sadmin:print(v)
            local entry = args:Add("DTextEntry")
            entry:SetPlaceholderText(v)
            entry:Dock(TOP)
            entry.key = k
        end
    end

    local function populate_commands()
        commands:GetCanvas():Clear()

        if not sel_player then
            return
        end

        local view_commands = {}
        if sadmin.ranks[sel_player:GetUserGroup()].priority <= sadmin.ranks[LocalPlayer():GetUserGroup()].priority then
            for k, v in pairs(sadmin.ranks[LocalPlayer():GetUserGroup()].access or {}) do
                view_commands[k] = v
            end
        end

        for k, v in pairs(sadmin.commands) do
            if not v.priority then
                view_commands[k] = v
            end
        end

        for k, v in pairs(view_commands) do 
            local command_data = sadmin.commands[k]
            sadmin:print(command_data)
    
            local command = commands:Add("DButton")
            command:Dock(TOP)
            command:SetText(command_data.name)
    
            function command:DoClick()
                sel_command = k
                populate_args()
            end
        end
    end

    for i, v in ipairs(player.GetAll()) do
        local ply = players:Add("DButton")
        ply:Dock(TOP)
        ply:SetText(v:Name())

        function ply:DoClick()
            sel_player = v
            populate_commands()
        end
    end

    function execute:DoClick()
        for i, v in ipairs(args:GetCanvas():GetChildren()) do
            sadmin:print(v.key .. " " .. v:GetValue())
            s_args[v.key] = v:GetValue()            
        end


        net.Start(sadmin.nets.execute)
            net.WriteEntity(sel_player)
            net.WriteString(sel_command)
            net.WriteTable(s_args)
        net.SendToServer()
    end
end

concommand.Add("sadmin", function()
    sadmin:CallMenu()
end)