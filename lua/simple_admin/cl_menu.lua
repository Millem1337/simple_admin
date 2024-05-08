function sadmin:CallMenu()
    local frame = vgui.Create("DFrame")
    frame:SetTitle("Simple Admin")
    frame:SetSize(600,500)
    frame:Center()
    frame:MakePopup()
    frame:SetSizable( true )

    local execute = vgui.Create("DButton", frame)
    execute:Dock(BOTTOM)
    execute:SetText("Execute")
    
    local commands = vgui.Create("DPanel", frame)
    commands:Dock(LEFT)
    commands:DockPadding(5,5,5,5)
    commands:SetWide(100)

    for k, v in pairs(sadmin.commands) do 
        local command = vgui.Create("DButton", commands)
        command:Dock(TOP)
        command:SetText(v.name)
    end

    local players = vgui.Create("DPanel", frame)
    players:Dock(LEFT)
    players:DockPadding(5,5,5,5)
    players:SetWide(250)
end

concommand.Add("sadmin", function()
    sadmin:CallMenu()
end)