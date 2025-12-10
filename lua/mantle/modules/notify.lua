if SERVER then
    util.AddNetworkString('Mantle-Notify')

    --[[
        Function for outputting text to chat.
        Can output to specific target or everyone by specifying true instead of pl
    ]]--
    function Mantle.notify(pl, header_color, header, text)
        net.Start('Mantle-Notify')
            net.WriteString(header)
            net.WriteColor(header_color)
            net.WriteString(text)
        if pl == true then net.Broadcast() else net.Send(pl) end
    end
else
    net.Receive('Mantle-Notify', function()
        local headerText = net.ReadString()
        local headerColor = net.ReadColor()
        local headerColorDop = Color(headerColor.r + 10, headerColor.g + 10, headerColor.b + 10)
        local text = net.ReadString()

        chat.AddText(headerColorDop, '[', headerColor, headerText, headerColorDop, '] ', color_white, text)
        chat.PlaySound()
    end)
end
