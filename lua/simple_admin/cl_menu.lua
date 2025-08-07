function sadmin:CallMenu( noframe )
    local sel_player
    local sel_command
    local s_args = {}
    local frame

    if not noframe then
        frame = vgui.Create("DFrame")
        frame:SetTitle("Simple Admin")
        frame:SetSize(600,500)
        frame:Center()
        frame:MakePopup()
        frame:SetSizable( true )
    else
        frame = vgui.Create("DPanel")
    end

    local players = vgui.Create("DScrollPanel", frame)
    players:Dock(LEFT)
    players:DockPadding(5,5,5,5)
    players:SetWide(150)

    local plr_char = vgui.Create("DPanel", frame)
    plr_char:Dock(LEFT)
    plr_char:DockPadding(5,5,5,5)
    plr_char:DockMargin(5,0,0,0)
    plr_char:SetWide(200)

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
            if v and v.type == "text" then
                local entry = args:Add("DTextEntry")
                entry:SetPlaceholderText(v.placeholder)
                entry:Dock(TOP)
                entry.key = k
            elseif v and v.type == "select" then
                local entry = args:Add("DComboBox")
                entry:SetValue(v.placeholder)
                entry:Dock(TOP)
                for _, arg_val in pairs(v.select) do
                    entry:AddChoice(arg_val)
                end
                entry.key = k
            end
        end

        local execute = vgui.Create("DButton", args)
        execute:Dock(TOP)
        execute:SetText("Execute")
        function execute:DoClick()
            for i, v in ipairs(args:GetCanvas():GetChildren()) do
                if not v.key then continue end 
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

    local function populate_commands()
        commands:GetCanvas():Clear()

        if not sel_player then
            return
        end

        local view_commands = {}
        if sadmin.ranks[sel_player:GetUserGroup()] and sadmin.ranks[LocalPlayer():GetUserGroup()] and sadmin.ranks[sel_player:GetUserGroup()].priority <= sadmin.ranks[LocalPlayer():GetUserGroup()].priority then
            sadmin:print(sadmin.ranks[LocalPlayer():GetUserGroup()].access)
            for k, v in pairs(sadmin.ranks[LocalPlayer():GetUserGroup()].access or {}) do
                view_commands[k] = v
            end
        end

        for k, v in pairs(sadmin.commands) do
            if not v.priority and view_commands[k] then
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

    local function populate_character()
        plr_char:Clear()

        local modelBox = vgui.Create("DModelPanel", plr_char)
        modelBox:Dock(FILL)
        modelBox:SetCamPos(Vector(70,0,45))
        modelBox:SetFOV(40)
        modelBox:SetLookAt(Vector(0,0,35))
        modelBox.LayoutEntity = function() end
        modelBox:SetModel(sel_player:GetModel())

        function modelBox:PostDrawModel( ply )
            if not IsValid(ply) then return end

            rp:EqPostPlayerDraw(ply, sel_player:GetEquipment())
        end

        local jobOnModel = vgui.Create("DLabel", modelBox)
        jobOnModel:SetTextColor(color_black)
        jobOnModel:SetText(rp.jobs[tonumber(sel_player:GetCharacter():GetJob())].name)
        jobOnModel:Dock(TOP)

        local moneyOnModel = vgui.Create("DLabel", modelBox)
        moneyOnModel:SetTextColor(color_black)
        moneyOnModel:SetText(sel_player:GetCharacter():GetMoney() .. " $")
        moneyOnModel:Dock(TOP)
    
        populate_commands()
    end

    for i, v in player.Iterator() do
        if v:GetCharacter() then
            local ply = players:Add("DButton")
            ply:Dock(TOP)
            ply:SetText(v:Name() .. " [" .. (v:GetCharacter().id or -1) .. "]")
            ply:SetMaterial(sadmin.ranks[v:GetUserGroup()].icon or sadmin.noicon)

            function ply:DoClick()
                sel_player = v
                populate_character()
            end
        end
    end

    if noframe then
        return frame
    end
end

concommand.Add("sadmin", function()
    sadmin:CallMenu()
end)