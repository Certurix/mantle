local function CreateMenu()
    if IsValid(menuMantle) then
        menuMantle:Remove()
    end

    menuMantle = vgui.Create('MantleFrame')
    menuMantle:SetSize(920, 640)
    menuMantle:Center()
    menuMantle:MakePopup()
    menuMantle:SetTitle('Mantle')
    menuMantle:SetCenterTitle('Library Main Menu')
    menuMantle:ShowAnimation()

    local tabs = vgui.Create('MantleTabs', menuMantle)
    tabs:Dock(FILL)

    local function CreateTabHeader(title, subtitle, icon, pan)
        local header = vgui.Create('Panel', pan)
        header:Dock(TOP)
        header:DockMargin(0, 0, 0, 8)
        header:SetTall(56)

        header.Paint = function(_, w, h)
            RNDX().Rect(0, 0, w, h)
                :Rad(8)
                :Color(Mantle.color.panel_alpha[2])
            :Draw()

            RNDX().Rect(12, h * 0.5 - 12, 24, 24)
                :Color(255, 255, 255)
                :Material(icon)
            :Draw()

            draw.SimpleText(title, 'Fated.20', 48, 10, Mantle.color.text)
            draw.SimpleText(subtitle, 'Fated.16', 48, h - 10, Mantle.color.gray, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM)
        end

        return header
    end

    local function CreateCopyButton(parent, snippet)
        local b = vgui.Create('DButton', parent)
        b:SetText('')
        b:SetWide(110)
        b.Paint = function(me, w, h)
            RNDX().Rect(0, 0, w, h)
                :Rad(6)
                :Color(Mantle.color.panel_alpha[1])
            :Draw()

            draw.SimpleText('Copy', 'Fated.16', w / 2, h / 2, Mantle.color.text, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end
        b.DoClick = function()
            SetClipboardText(snippet)
            menuMantle:Notify(snippet)
            Mantle.func.sound()
        end
        return b
    end

    local function CreateInfo(info, pan)
        local panelInfo = vgui.Create('Panel')
        panelInfo:Dock(TOP)
        panelInfo:DockMargin(0, 0, 0, 6)
        panelInfo:SetTall(50)

        panelInfo.Paint = function(_, w, h)
            RNDX().Rect(0, 0, w, h)
                :Rad(6)
                :Color(Mantle.color.panel_alpha[2])
            :Draw()

            Mantle.func.gradient(0, 0, 6, h, 3, Mantle.color.theme, 6)

            draw.SimpleText(info[1], 'Fated.20', 16, 7, Mantle.color.text)
            draw.SimpleText(info[2], 'Fated.16', 16, h - 7, Mantle.color.gray, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM)
        end

        local copyBtn = CreateCopyButton(panelInfo, info[1])
        copyBtn:Dock(RIGHT)
        copyBtn:DockMargin(0, 10, 10, 10)

        pan:AddItem(panelInfo)
    end

    local function CreateCategory(name, info_table, pan, ui_element, is_active)
        local panel = vgui.Create('MantleCategory', pan)
        panel:Dock(TOP)
        panel:DockMargin(0, 0, 0, 6)
        panel:SetText(name)

        if is_active then
            panel:SetActive(true)
        end

        for _, info in ipairs(info_table) do
            CreateInfo(info, panel)
        end

        if ui_element then
            panel:AddItem(ui_element)
        end
    end

    local function CreateTabElements()
        local panel = vgui.Create('MantleScrollPanel')
        CreateTabHeader('UI Elements', 'Demonstration of all Mantle components. Click on an element to open an example.', Material('icon16/chart_pie.png'), panel)

        local menuWide = menuMantle:GetWide()

        -- Button
        local panelBtns = vgui.Create('Panel')
        panelBtns:Dock(TOP)
        panelBtns:DockMargin(menuWide * 0.3, 6, menuWide * 0.3, 0)
        panelBtns:SetTall(132)

        local btn1 = vgui.Create('MantleBtn', panelBtns)
        btn1:Dock(TOP)
        btn1:SetTall(40)
        btn1:SetTxt('Standard button')

        local btn2 = vgui.Create('MantleBtn', panelBtns)
        btn2:Dock(TOP)
        btn2:DockMargin(0, 6, 0, 0)
        btn2:SetTall(40)
        btn2:SetTxt('Ripple effect')
        btn2:SetRipple(true)

        local btn3 = vgui.Create('MantleBtn', panelBtns)
        btn3:Dock(TOP)
        btn3:DockMargin(0, 6, 0, 0)
        btn3:SetTall(40)
        btn3:SetTxt('Custom color')
        btn3:SetColor(Color(182, 65, 65))
        btn3:SetColorHover(Color(143, 57, 57))
        btn3:SetIcon(Material('icon16/delete.png'), 16)

        CreateCategory('Button (MantleBtn)', {
            {':SetHover(bool is_hover)', 'Enable/disable hover color (default - true)'},
            {':SetFont(string font)', 'Set font'},
            {':SetRadius(int rad)', 'Set corner radius'},
            {':SetIcon(string icon, int icon_size)', 'Set icon'},
            {':SetTxt(string text)', 'Set text'},
            {':SetColor(color col)', 'Set button color'},
            {':SetColorHover(color col)', 'Set hover color'},
            {':SetGradient(bool is_grad)', 'Enable/disable gradient (default - true)'},
            {':SetRipple(bool is_ripple)', 'Enable/disable ripple effect (default - false)'}
        }, panel, panelBtns)

        -- Checkbox
        local checkbox = vgui.Create('MantleCheckBox')
        checkbox:DockMargin(menuWide * 0.3, 6, menuWide * 0.3, 0)
        checkbox:Dock(TOP)
        checkbox:SetTxt('HUD Display')
        checkbox:SetConvar('cl_drawhud')
        CreateCategory('Toggle (MantleCheckBox)', {
            {':SetTxt(string text)', 'Set text'},
            {':SetValue(bool value)', 'Set bool-value of toggle'},
            {':GetBool()', 'Get bool-value of toggle'},
            {':SetConvar(string convar)', 'Set ConVar'},
            {':SetDescription(string desc)', 'Set description for toggle'},
            {':OnChange(bool new_value)', 'Called when toggle value changes'}
        }, panel, checkbox)

        -- Text input
        local entry = vgui.Create('MantleEntry')
        entry:Dock(TOP)
        entry:DockMargin(menuWide * 0.35, 6, menuWide * 0.35, 0)
        entry:SetTitle('Nickname')
        entry:SetPlaceholder('darkf')
        CreateCategory('Text Input (MantleEntry)', {
            {':SetTitle(string text)', 'Set title'},
            {':SetPlaceholder(string text)', 'Set placeholder text (appears when field is empty)'},
            {':GetValue()', 'Get string-value of field'},
            {':SetValue(string value)', 'Set field value'}
        }, panel, entry)

        -- Window
        local panelFrames = vgui.Create('Panel')
        panelFrames:Dock(TOP)
        panelFrames:SetTall(92)

        local btnFrame1 = vgui.Create('MantleBtn', panelFrames)
        btnFrame1:Dock(TOP)
        btnFrame1:DockMargin(menuWide * 0.3, 6, menuWide * 0.3, 0)
        btnFrame1:SetTxt('Regular window')
        btnFrame1:SetTall(40)
        btnFrame1.DoClick = function()
            local frame = vgui.Create('MantleFrame')
            frame:SetSize(400, 300)
            frame:Center()
            frame:MakePopup()
            frame:SetCenterTitle('Center')
        end

        local btnFrame2 = vgui.Create('MantleBtn', panelFrames)
        btnFrame2:Dock(TOP)
        btnFrame2:DockMargin(menuWide * 0.3, 6, menuWide * 0.3, 0)
        btnFrame2:SetTxt('Lite mode')
        btnFrame2:SetTall(40)
        btnFrame2.DoClick = function()
            local frame = vgui.Create('MantleFrame')
            frame:SetSize(400, 300)
            frame:Center()
            frame:MakePopup()
            frame:LiteMode()
        end

        CreateCategory('Window (MantleFrame)', {
            {':SetAlphaBackground(bool is_alpha)', 'Enable/disable window transparency (default - false)'},
            {':SetTitle(string title)', 'Set title'},
            {':SetCenterTitle(string title)', 'Set center title'},
            {':ShowAnimation()', 'Activate animation when menu appears'},
            {':DisableCloseBtn()', 'Hide close button'},
            {':SetDraggable(bool is_draggable)', 'Enable/disable window dragging'},
            {':LiteMode()', 'Activate Lite mode (without top panel)'},
            {':Notify(string text, number duration, color col)', 'Show notification at bottom of window (default duration - 2 sec., color - Mantle.color.theme)'}
        }, panel, panelFrames)

        -- ScrollPanel
        local sp = vgui.Create('MantleScrollPanel')
        sp:Dock(TOP)
        sp:DockMargin(menuWide * 0.3, 6, menuWide * 0.3, 0)
        sp:SetTall(150)
        for spK = 1, 10 do
            local spPanel = vgui.Create('DPanel', sp)
            spPanel:Dock(TOP)
            spPanel:DockMargin(0, 0, 0, 6)
            spPanel:SetTall(24)
            spPanel.Paint = function(_, w, h)
                RNDX().Rect(0, 0, w, h)
                    :Rad(16)
                    :Color(Mantle.color.panel_alpha[1])
                    :Shape(RNDX.SHAPE_IOS)
                :Draw()
            end
        end
        CreateCategory('Scroll Panel (MantleScrollPanel)', {
            {':SetScroll(number offset)', 'Set scroll offset'},
            {':GetScroll()', 'Get current scroll offset'},
            {':AddItem(object panel)', 'Add element to panel'},
            {':Clear()', 'Clear all elements from panel'},
            {':DisableVBarPadding()', 'Disable right padding for scrollbar (enabled by default)'}
        }, panel, sp)

        -- Tabs
        local panelTabs = vgui.Create('Panel')
        panelTabs:Dock(TOP)
        panelTabs:SetTall(280)

        local testTabs = vgui.Create('MantleTabs', panelTabs) -- modern style
        testTabs:Dock(TOP)
        testTabs:DockMargin(menuWide * 0.3, 6, menuWide * 0.3, 0)
        testTabs:SetTall(150)
        local testTab1 = vgui.Create('DPanel')
        testTab1.Paint = function(_, w, h)
            RNDX().Rect(0, 0, w - 12, h)
                :Rad(16)
                :Color(53, 98, 40)
                :Shape(RNDX.SHAPE_IOS)
            :Draw()
        end
        testTabs:AddTab('Test1', testTab1)
        local testTab2 = vgui.Create('DPanel')
        testTab2.Paint = function(_, w, h)
            RNDX().Rect(0, 0, w - 12, h)
                :Rad(16)
                :Color(108, 41, 45)
                :Shape(RNDX.SHAPE_IOS)
            :Draw()
        end
        testTabs:AddTab('Test2', testTab2)

        local testTabs2 = vgui.Create('MantleTabs', panelTabs) -- classic style
        testTabs2:Dock(FILL)
        testTabs2:DockMargin(menuWide * 0.3, 10, menuWide * 0.3, 0)
        testTabs2:SetTabStyle('classic')
        local testTab3 = vgui.Create('DPanel')
        testTab3.Paint = function(_, w, h)
            RNDX().Rect(0, 0, w - 12, h)
                :Rad(16)
                :Color(51, 61, 116)
                :Shape(RNDX.SHAPE_IOS)
            :Draw()
        end
        testTabs2:AddTab('Test3', testTab3)
        local testTab4 = vgui.Create('DPanel')
        testTab4.Paint = function(_, w, h)
            RNDX().Rect(0, 0, w - 12, h)
                :Rad(16)
                :Color(138, 89, 43)
                :Shape(RNDX.SHAPE_IOS)
            :Draw()
        end
        testTabs2:AddTab('Test4', testTab4)
        local testTab5 = vgui.Create('DPanel')
        testTab5.Paint = function(_, w, h)
            RNDX().Rect(0, 0, w - 12, h)
                :Rad(16)
                :Color(43, 138, 133)
                :Shape(RNDX.SHAPE_IOS)
            :Draw()
        end
        testTabs2:AddTab('With icon', testTab5, Material('icon16/folder.png'))

        CreateCategory('Tabs (MantleTabs)', {
            {':SetTabStyle(string style)', 'Set tab style (modern or classic)'},
            {':SetTabHeight(int height)', 'Set tab height'},
            {':SetIndicatorHeight(int height)', 'Set tab indicator height'},
            {':AddTab(string name, object panel, string icon)', 'Add tab'}
        }, panel, panelTabs)


        -- Horizontal scroll
        local hscroll = vgui.Create('MantleHScroll')
        hscroll:Dock(TOP)
        hscroll:DockMargin(menuWide * 0.3, 6, menuWide * 0.3, 0)
        hscroll:SetTall(80)

        for i = 1, 8 do
            local btn = vgui.Create('MantleBtn')
            btn:SetSize(120, 60)
            btn:SetTxt('Element ' .. i)
            btn:Dock(LEFT)
            btn:DockMargin(0, 0, 5, 0)
            hscroll:AddItem(btn)
        end

        CreateCategory('Horizontal Scroll (MantleHScroll)', {
            {':AddItem(pnl) / :Add(pnl)', 'Add element to scroll container'},
            {':Clear()', 'Clear all elements from container'},
            {':SetScroll(x)', 'Set current scroll offset'},
            {':GetScroll()', 'Get current scroll offset'}
        }, panel, hscroll)

        -- Choice selection
        local combo = vgui.Create('MantleComboBox')
        combo:SetPlaceholder('Select option')
        combo:AddChoice('Option 1', 'value1')
        combo:AddChoice('Option 2', 'value2')
        combo:AddChoice('Option 3', 'value3')
        combo:AddChoice('Option 4', 'value4')
        combo:AddChoice('Option 5', 'value5')
        combo:AddChoice('Option 6', 'value6')
        combo:AddChoice('Option 7', 'value7')
        combo:AddChoice('Option 8', 'value8')
        combo.OnSelect = function(idx, text, data)
            chat.AddText(color_white, 'You selected: ', Mantle.color.theme, text, color_white, ' (', tostring(data), ')')
        end
        combo:DockMargin(menuWide * 0.3, 6, menuWide * 0.3, 0)
        combo:Dock(TOP)
        CreateCategory('Dropdown List (MantleComboBox)', {
            {':AddChoice(string text, any data)', 'Add option to list (data — any value associated with item)'},
            {':SetValue(string text)', 'Set selected value by text'},
            {':GetValue()', 'Get selected value (text)'},
            {':SetPlaceholder(string text)', 'Set placeholder text'},
            {':OnSelect(idx, text, data)', 'Called when option is selected: idx — index, text — text, data — value'}
        }, panel, combo)

        -- Table
        local tableExample = vgui.Create('MantleTable')
        tableExample:Dock(TOP)
        tableExample:DockMargin(menuWide * 0.2, 6, menuWide * 0.2, 0)
        tableExample:SetTall(250)

        tableExample:AddColumn('Name', 200, TEXT_ALIGN_LEFT, true)
        tableExample:AddColumn('Type', 120, TEXT_ALIGN_CENTER, true)
        tableExample:AddColumn('Quality', 100, TEXT_ALIGN_CENTER, true)
        tableExample:AddColumn('Price', 110, TEXT_ALIGN_RIGHT, true)

        local products = {
            {'Milk "Farm House"', 'Dairy', 'Premium', 89},
            {'Bread "Borodinsky"', 'Bakery', 'Standard', 45},
            {'Juice "Kind"', 'Beverages', 'Premium', 120},
            {'Chocolate "Alenka"', 'Candy', 'Premium', 95},
            {'Yogurt "Activia"', 'Dairy', 'Premium', 65},
            {'Dumplings "Siberian"', 'Frozen', 'Standard', 350},
            {'Sausage "Doctorskaya"', 'Meat', 'Premium', 450},
            {'Cheese "Russian"', 'Dairy', 'Standard', 380},
            {'Pizza "Pepperoni"', 'Frozen', 'Premium', 450},
            {'Tea "Lipton"', 'Beverages', 'Standard', 180},
            {'Cookies "Jubilee"', 'Bakery', 'Standard', 85},
            {'Butter "Farm"', 'Dairy', 'Premium', 120},
            {'Sour Cream "Prostokvashino"', 'Dairy', 'Standard', 65},
            {'Chicken "Broiler"', 'Meat', 'Standard', 280},
            {'Fish "Pollock"', 'Seafood', 'Standard', 320},
            {'Apples "Golden"', 'Fruits', 'Premium', 180},
            {'Potatoes', 'Vegetables', 'Standard', 45},
            {'Carrots', 'Vegetables', 'Standard', 35},
            {'Bananas', 'Fruits', 'Standard', 120},
            {'Oranges', 'Fruits', 'Premium', 180}
        }

        for _, product in ipairs(products) do
            tableExample:AddItem(unpack(product))
        end

        tableExample:SetAction(function(row_data)
            chat.AddText(color_white, 'Selected product: ', Mantle.color.theme, row_data[1], color_white, ' (', row_data[2], ')')
        end)

        CreateCategory('Table (MantleTable)', {
            {':AddColumn(string name, number width, number align, bool sortable)', 'Add column'},
            {':AddItem(...)', 'Add row. Number of arguments must match number of columns'},
            {':SetAction(function(table row_data))', 'Set function called when row is clicked. row_data — array of row values'},
            {':SetRightClickAction(function(table row_data))', 'Set function called when row is right-clicked'},
            {':Clear()', 'Clear table of all rows'},
            {':GetSelectedRow()', 'Get selected row data (array of values)'},
            {':GetRowCount()', 'Get number of rows in table'},
            {':RemoveRow(number index)', 'Remove row by index (starting from 1)'}
        }, panel, tableExample)

        -- Category
        local panelCat = vgui.Create('Panel')
        panelCat:Dock(TOP)
        panelCat:DockMargin(0, 6, 0, 0)
        panelCat:SetTall(142)
        panelCat.Paint = nil

        local cat = vgui.Create('MantleCategory', panelCat)
        cat:Dock(TOP)
        cat:SetCenterText(true)
        cat:SetActive(true)
        local panGreen = vgui.Create('DPanel')
        panGreen:Dock(TOP)
        panGreen:SetTall(50)
        panGreen.Paint = function(_, w, h)
            RNDX().Rect(0, 0, w - 12, h)
                :Rad(16)
                :Color(93, 179, 101)
                :Shape(RNDX.SHAPE_IOS)
            :Draw()
        end
        cat:AddItem(panGreen)
        local panRed = vgui.Create('DPanel')
        panRed:Dock(TOP)
        panRed:DockMargin(0, 6, 0, 0)
        panRed:SetTall(50)
        panRed.Paint = function(_, w, h)
            RNDX().Rect(0, 0, w - 12, h)
                :Rad(16)
                :Color(179, 110, 93)
                :Shape(RNDX.SHAPE_IOS)
            :Draw()
        end
        cat:AddItem(panRed)
        CreateCategory('Category (MantleCategory)', {
            {':SetText(string name)', 'Set name'},
            {':AddItem(object panel)', 'Add element to category'},
            {':SetColor(color col)', 'Set custom category color'},
            {':SetCenterText(bool is_centered)', 'Set name centering'},
            {':SetActive(bool is_active)', 'Set category active state (default - false)'}
        }, panel, panelCat)

        -- Slider
        local slider = vgui.Create('MantleSlideBox')
        slider:Dock(TOP)
        slider:DockMargin(menuWide * 0.3, 6, menuWide * 0.3, 0)
        slider:SetRange(0, 4)
        slider:SetConvar('net_graph')
        slider:SetText('Graph')
        CreateCategory('Slider (MantleSlideBox)', {
            {':SetRange(int min_value, int max_value, int decimals)', 'Set slider range with precision (default precision - 0)'},
            {':SetConvar(string convar)', 'Set ConVar'},
            {':SetText(string text)', 'Set text label'},
            {':SetValue(string val)', 'Set value'},
            {':GetValue()', 'Get selected value (number)'},
            {':OnValueChanged(string new_value)', 'Called when slider value changes'}
        }, panel, slider)

        local panelTexts = vgui.Create('Panel')
        panelTexts:Dock(TOP)
        panelTexts:DockMargin(menuWide * 0.3, 6, menuWide * 0.3, 0)
        panelTexts:DockPadding(8, 8, 8, 8)
        panelTexts:SetTall(344)
        panelTexts.Paint = function(_, w, h)
            RNDX().Rect(0, 0, w, h)
                :Rad(32)
                :Color(Mantle.color.panel_alpha[2])
                :Shape(RNDX.SHAPE_IOS)
            :Draw()
        end

        local panelText1 = vgui.Create('DPanel', panelTexts)
        panelText1:Dock(TOP)
        panelText1:DockMargin(0, 0, 0, 6)
        panelText1:SetTall(74)
        panelText1.Paint = function(_, w, h)
            RNDX().Rect(0, 0, w, h)
                :Rad(32)
                :Color(Mantle.color.panel_alpha[1])
                :Shape(RNDX.SHAPE_IOS)
            :Draw()
        end

        local text1 = vgui.Create('MantleText', panelText1)
        text1:Dock(FILL)
        text1:SetPadding(10)
        text1:SetText('MantleText — component for neat multiline text output. Text automatically wraps by width and is truncated with ellipsis')

        local panelText2 = vgui.Create('DPanel', panelTexts)
        panelText2:Dock(TOP)
        panelText2:DockMargin(0, 0, 0, 6)
        panelText2:SetTall(100)
        panelText2.Paint = function(_, w, h)
            RNDX().Rect(0, 0, w, h)
                :Rad(32)
                :Color(Mantle.color.panel_alpha[1])
                :Shape(RNDX.SHAPE_IOS)
            :Draw()
        end

        local text2 = vgui.Create('MantleText', panelText2)
        text2:Dock(FILL)
        text2:SetPadding(12)
        text2:SetFont('Fated.20')
        text2:SetText('Centering: horizontal + vertical. Text is centered in the block.')
        text2:SetAlign(TEXT_ALIGN_CENTER)
        text2:SetVAlign('center')

        local panelText3 = vgui.Create('DPanel', panelTexts)
        panelText3:Dock(TOP)
        panelText3:DockMargin(0, 0, 0, 6)
        panelText3:SetTall(54)
        panelText3.Paint = function(_, w, h)
            RNDX().Rect(0, 0, w, h)
                :Rad(32)
                :Color(Mantle.color.panel_alpha[1])
                :Shape(RNDX.SHAPE_IOS)
            :Draw()
        end

        local text3 = vgui.Create('MantleText', panelText3)
        text3:Dock(FILL)
        text3:SetPadding(8)
        text3:SetText('VeryLongWordWithoutSpacesThatNeedsToBeSeperatedSoItDoesNotBreakTheLayout')

        local panelText4 = vgui.Create('DPanel', panelTexts)
        panelText4:Dock(TOP)
        panelText4:SetTall(82)
        panelText4.Paint = function(_, w, h)
            RNDX().Rect(0, 0, w, h)
                :Rad(32)
                :Color(Mantle.color.panel_alpha[1])
                :Shape(RNDX.SHAPE_IOS)
            :Draw()
        end

        local longText = [[
        This is a long example text that spans multiple lines. If the block is small in height — the last visible line will be truncated with ellipsis to not break the layout and not exceed the boundaries of our menu panel.
        ]]

        local text4 = vgui.Create('MantleText', panelText4)
        text4:Dock(FILL)
        text4:SetPadding(8)
        text4:SetFont('Fated.16')
        text4:SetText(longText)

        CreateCategory('Text (MantleText)', {
            {':SetText(string text)', 'Set text to display'},
            {':SetFont(string font)', 'Set font'},
            {':SetColor(color col)', 'Set text color'},
            {':SetAlign(number align)', 'Horizontal alignment (TEXT_ALIGN_*)'},
            {':SetVAlign(string valign)', 'Vertical alignment: top, center, bottom'},
            {':SetPadding(number px)', 'Internal padding from edges'}
        }, panel, panelTexts)

        return panel
    end

    tabs:AddTab('UI Elements', CreateTabElements(), Material('icon16/chart_pie.png'))

    local function CreateShowMenus()
        local panel = vgui.Create('MantleScrollPanel')
        CreateTabHeader('Popups', 'Color picker, derma-menu, radial and other utilities.', Material('icon16/application_double.png'), panel)

        local listMenus = {
            {'Color selection via picker', function()
                Mantle.ui.color_picker(function(col)
                    chat.AddText('You selected color: ', col, tostring(col))
                end, Color(25, 59, 102))
            end},
            {'Optional menu (Derma Menu)', function()
                local DM = Mantle.ui.derma_menu()
                for i = 1, 5 do
                    DM:AddOption('Option ' .. i, function()
                        chat.AddText('Hello everyone! ' .. i)
                    end)
                end
                DM:AddSpacer()
                DM:AddOption('Check your privilege', function()
                    chat.AddText(LocalPlayer():GetUserGroup())
                end, 'icon16/status_online.png')
            end},
            {'Optional with submenu (Derma Menu)', function()
                local DM = Mantle.ui.derma_menu()

                local clothes = DM:AddOption('Clothing')
                local subClothes = clothes:AddSubMenu()
                subClothes:AddOption('Hat', function()
                    chat.AddText('You selected: Hat')
                end)
                subClothes:AddOption('Sweater', function()
                    chat.AddText('You selected: Sweater')
                end)

                local food = DM:AddOption('Food')
                local subFood = food:AddSubMenu()
                subFood:AddOption('Carrot', function()
                    chat.AddText('You selected: Carrot')
                end)
                subFood:AddOption('Apple', function()
                    chat.AddText('You selected: Apple')
                end)
            end},
            {'Player selection', function()
                Mantle.ui.player_selector(function(pl)
                    chat.AddText('You selected player: ', color_white, pl:Name())
                end)
            end},
            {'Radial menu', function()
                --[[
                The radial menu can be configured

                local configRadial = {
                    disable_background = true, -- disables background
                    hover_sound = 'buttons/button14.wav', -- hover sound
                    scale_animation = false, -- disables scale animation
                    radius = 300, -- menu radius
                    inner_radius = 100 -- inner circle radius
                }

                local rm = Mantle.ui.radial_menu(configRadial)
                --]]

                local rm = Mantle.ui.radial_menu()
                rm:SetCenterText('Actions', 'Select action')

                local weaponsMenu = rm:CreateSubMenu('Weapons', 'Select weapon')
                weaponsMenu:AddOption('Pistol', function()
                    chat.AddText(Mantle.color.theme, 'Selected pistol')
                end, 'icon16/gun.png', 'Regular pistol')
                weaponsMenu:AddOption('Rifle', function()
                    chat.AddText(Mantle.color.theme, 'Selected rifle')
                end, 'icon16/gun.png', 'Powerful rifle')
                rm:AddSubMenuOption('Weapons', weaponsMenu, 'icon16/gun.png', 'Select weapon')

                -- Regular options
                rm:AddOption('Drop', function()
                    chat.AddText('Drop weapon')
                end, 'icon16/gun.png', 'Drop weapon')
                rm:AddOption('Roll dice', function()
                    chat.AddText('Action completed')
                end, 'icon16/controller.png', 'Random dice')
                rm:AddOption('Die', function()
                    chat.AddText('Action completed')
                end, 'icon16/world.png', 'Say goodbye to the world')
                rm:AddOption('Hack', function()
                    chat.AddText('Action completed')
                end, 'icon16/server.png', 'Hack the server')
                rm:AddOption('Check balance', function()
                    chat.AddText('Action completed')
                end, 'icon16/money.png', 'How much money you have')
                rm:AddOption('No icon', function()
                    chat.AddText('Action completed')
                end, nil, 'Where is the icon?')
            end},
            {'Text writing', function()
                Mantle.ui.text_box('Title', 'Description of what to enter', function(s)
                    chat.AddText('You entered: ', color_white, s)
                end)
            end},
            {'Call message in Window', function()
                menuMantle:Notify('Test message!')
            end}
        }

        for _, elem in ipairs(listMenus) do
            local btn = vgui.Create('MantleBtn', panel)
            btn:Dock(TOP)
            btn:DockMargin(0, 0, 0, 6)
            btn:SetTall(30)
            btn:SetTxt(elem[1])
            btn.DoClick = function()
                elem[2]()
                Mantle.func.sound()
            end
        end

        return panel
    end

    tabs:AddTab('Popups', CreateShowMenus(), Material('icon16/application_double.png'))

    local function CreateTabFunctions()
        local panel = vgui.Create('MantleScrollPanel')
        CreateTabHeader('Functions', 'Complete list of utility functions Mantle.func and other helper functions', Material('icon16/cog.png'), panel)

        local menuWide = menuMantle:GetWide()

        CreateCategory('Panel blur', {
            {'Mantle.func.blur(object panel)', 'Render panel blur in Paint'}
        }, panel)

        CreateCategory('Gradient', {
            {'Mantle.func.gradient(int x, int y, int w, int h, int dir, color color_shadow, int radius, flags)', 'Render gradient (dir: 1 - up, 2 - down, 3 - left, 4 - right)'}
        }, panel)

        CreateCategory('Sound creation', {
            {'Mantle.func.sound(string path)', 'Plays sound (default - mantle/btn_click.ogg)'}
        }, panel)

        CreateCategory('Relative units for adaptive interface', {
            {'Mantle.func.w(int px)', 'Relative width (from 1920)'},
            {'Mantle.func.h(int px)', 'Relative height (from 1080)'}
        }, panel)

        CreateCategory('Draw text above entity', {
            {'Mantle.func.draw_ent_text(object ent, string text, int posY)', 'Draws text above entity with smooth appearance (3D2D)'}
        }, panel)

        CreateCategory('Panel size animation', {
            {'Mantle.func.animate_appearance(object panel, int w, int h, int duration, int alpha_dur, func callback, int scale_factor)', 'Smooth panel resize to desired size'}
        }, panel)

        CreateCategory('Smooth color change', {
            {'Mantle.func.LerpColor(int frac, color col1, color col2)', 'Smooth color transition from col1 → col2'}
        }, panel)

        CreateCategory('Image loading', {
            {'http.DownloadMaterial(string url, string path, func callback, int retry_count)', 'Downloads material from URL and caches it. Retries on error, returns material via callback'}
        }, panel)

        CreateCategory('Server notification', {
            {'Mantle.notify(object pl, color header_color, string header, string text)', 'Send messages to player chat or everyone (specify true instead of pl - then to everyone)'}
        }, panel)

        CreateCategory('Case change', {
            {'utf8.lower(string text)', 'Converts string to lowercase with Russian letter support'},
            {'utf8.upper(string text)', 'Converts string to uppercase with Russian letter support'}
        }, panel)

        return panel
    end

    tabs:AddTab('Functions', CreateTabFunctions(), Material('icon16/error.png'))

    local function CreateLegacyTest()
        local panel = vgui.Create('MantleScrollPanel')
        CreateTabHeader('Legacy UI', 'Set of legacy utilities (Mantle.ui.*). For compatibility and examples.', Material('icon16/exclamation.png'), panel)

        local menuWide = menuMantle:GetWide()

        local btnFrame = vgui.Create('MantleBtn')
        btnFrame:SetTxt('Open Legacy Frame')
        btnFrame:SetTall(40)
        btnFrame:DockMargin(menuWide * 0.3, 6, menuWide * 0.3, 0)
        btnFrame:Dock(TOP)
        btnFrame.DoClick = function()
            local frame = vgui.Create('DFrame')
            frame:SetSize(400, 300)
            frame:Center()
            frame:MakePopup()
            Mantle.ui.frame(frame, 'Legacy Frame', 400, 300, true, true)

            local scroll = vgui.Create('DScrollPanel', frame)
            scroll:Dock(FILL)
            Mantle.ui.sp(scroll)

            -- Test buttons with different parameters
            local btn1 = vgui.Create('DButton', scroll)
            btn1:Dock(TOP)
            btn1:DockMargin(10, 10, 10, 0)
            btn1:SetText('Regular button')
            Mantle.ui.btn(btn1)

            local btn2 = vgui.Create('DButton', scroll)
            btn2:Dock(TOP)
            btn2:DockMargin(10, 10, 10, 0)
            btn2:SetText('Button with icon')
            Mantle.ui.btn(btn2, Material('icon16/accept.png'), 16)

            local btn3 = vgui.Create('DButton', scroll)
            btn3:Dock(TOP)
            btn3:DockMargin(10, 10, 10, 0)
            btn3:SetText('Button without gradient')
            Mantle.ui.btn(btn3, nil, nil, nil, nil, true)

            local btn4 = vgui.Create('DButton', scroll)
            btn4:Dock(TOP)
            btn4:DockMargin(10, 10, 10, 0)
            btn4:SetText('Button without hover')
            Mantle.ui.btn(btn4, nil, nil, nil, nil, nil, nil, true)

            -- Test sliders
            local slider1 = Mantle.ui.slidebox(scroll, 'Slider (0-100)', 0, 100, 'net_graph', 0)
            slider1:DockMargin(10, 20, 10, 0)

            local slider2 = Mantle.ui.slidebox(scroll, 'Slider (0-1)', 0, 1, 'cl_drawhud', 2)
            slider2:DockMargin(10, 20, 10, 0)

            -- Test input fields
            local entry1, entry_bg1 = Mantle.ui.desc_entry(scroll, 'Field with title', 'Enter text...')
            entry_bg1:DockMargin(10, 20, 10, 0)

            local entry2, entry_bg2 = Mantle.ui.desc_entry(scroll, nil, 'Field without title')
            entry_bg2:DockMargin(10, 20, 10, 0)

            -- Test checkboxes
            local checkbox1, checkbox_btn1 = Mantle.ui.checkbox(scroll, 'Checkbox with ConVar', 'cl_drawhud')
            checkbox1:DockMargin(10, 20, 10, 0)

            local checkbox2, checkbox_btn2 = Mantle.ui.checkbox(scroll, 'Checkbox without ConVar')
            checkbox2:DockMargin(10, 20, 10, 0)

            -- Test tabs
            local panelTabs = vgui.Create('DPanel', scroll)
            panelTabs:Dock(TOP)
            panelTabs:SetTall(250)
            panelTabs.Paint = nil

            local tabs = Mantle.ui.panel_tabs(panelTabs)
            tabs:DockMargin(10, 20, 10, 0)

            -- Add tabs with different styles
            local tab1 = vgui.Create('DPanel')
            tab1.Paint = function(_, w, h)
                draw.SimpleText('Tab 1', 'Fated.20', w/2, h/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            end
            tabs:AddTab('Tab 1', tab1, 'icon16/page_white.png')

            local tab2 = vgui.Create('DPanel')
            tab2.Paint = function(_, w, h)
                draw.SimpleText('Tab 2', 'Fated.20', w/2, h/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            end
            tabs:AddTab('Tab 2', tab2, 'icon16/page_white_edit.png', Color(100, 200, 100))

            local tab3 = vgui.Create('DPanel')
            tab3.Paint = function(_, w, h)
                draw.SimpleText('Tab 3', 'Fated.20', w/2, h/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            end
            tabs:AddTab('Tab 3', tab3, 'icon16/page_white_gear.png', nil, Color(200, 100, 100))

            tabs:ActiveTab('Tab 1')
        end
        CreateCategory('Legacy Frame (not recommended to use)', {
            {'Mantle.ui.frame(object frame, string title, int w, int h, bool cls_btn, bool open_anim)', 'Style standard window with Mantle style'},
            {'Mantle.ui.sp(object scroll)', 'Style scroll panel for elements'},
            {'Mantle.ui.btn(object btn, mat icon, int icon_size, color col, int rad, bool off_grad, color hov, bool off_hov)', 'Style button'},
            {'Mantle.ui.slidebox(object parent, string label, int min_value, int max_value, string convar, int decimals)', 'Create slider on parent element'},
            {'Mantle.ui.desc_entry(object parent, string title, string placeholder, bool off_title)', 'Create input field'},
            {'Mantle.ui.checkbox(object parent, string text, string convar)', 'Create checkbox'},
            {'Mantle.ui.panel_tabs(object parent)', 'Create panel with tabs. Later use :AddTab() and :ActiveTab() for configuration'}
        }, panel, btnFrame, true)

        return panel
    end

    tabs:AddTab('Legacy UI', CreateLegacyTest(), Material('icon16/exclamation.png'))

    local function CreateSettings()
        local panel = vgui.Create('MantleScrollPanel')
        CreateTabHeader('Settings', 'Global Mantle settings: themes, effects and element depths.', Material('icon16/cog.png'), panel)

        local menuWide = menuMantle:GetWide()

        local checkboxDepth = vgui.Create('MantleCheckBox', panel)
        checkboxDepth:Dock(TOP)
        checkboxDepth:SetTxt('Element depths')
        checkboxDepth:SetConvar('mantle_depth_ui')

        local checkboxBlur = vgui.Create('MantleCheckBox', panel)
        checkboxBlur:Dock(TOP)
        checkboxBlur:DockMargin(0, 6, 0, 0)
        checkboxBlur:SetTxt('Background blur')
        checkboxBlur:SetConvar('mantle_blur')

        local categoryTheme = vgui.Create('MantleCategory', panel)
        categoryTheme:Dock(TOP)
        categoryTheme:DockMargin(0, 6, 0, 0)
        categoryTheme:SetText('Change color theme')
        categoryTheme:SetActive(true)

        local comboboxTheme = vgui.Create('MantleComboBox')
        comboboxTheme:Dock(TOP)
        comboboxTheme:SetPlaceholder('Select interface theme')
        comboboxTheme:AddChoice('Dark (dark)', 'dark')
        comboboxTheme:AddChoice('Dark monotone (dark_mono)', 'dark_mono')
        comboboxTheme:AddChoice('Light (light)', 'light')
        comboboxTheme:AddChoice('Blue (blue)', 'blue')
        comboboxTheme:AddChoice('Red (red)', 'red')
        comboboxTheme:AddChoice('Green (green)', 'green')
        comboboxTheme:AddChoice('Orange (orange)', 'orange')
        comboboxTheme:AddChoice('Purple (purple)', 'purple')
        comboboxTheme:AddChoice('Coffee (coffee)', 'coffee')
        comboboxTheme:AddChoice('Ice (ice)', 'ice')
        comboboxTheme:AddChoice('Wine (wine)', 'wine')
        comboboxTheme:AddChoice('Violet (violet)', 'violet')
        comboboxTheme:AddChoice('Moss (moss)', 'moss')
        comboboxTheme:AddChoice('Coral (coral)', 'coral')
        comboboxTheme.OnSelect = function(_, _, data)
            RunConsoleCommand('mantle_theme', data)
        end
        categoryTheme:AddItem(comboboxTheme)

        local listThemeColors = vgui.Create('DIconLayout')
        listThemeColors:Dock(TOP)
        listThemeColors:DockMargin(6, 8, 6, 0)
        listThemeColors:SetTall(164)
        listThemeColors:SetSpaceX(8)
        listThemeColors:SetSpaceY(8)
        categoryTheme:AddItem(listThemeColors)

        for colId, _ in pairs(Mantle.color) do
            local panCol = vgui.Create('DPanel', listThemeColors)
            panCol:SetSize(80, 80)
            panCol.Paint = function(_, w, h)
                RNDX().Rect(0, 0, w, h)
                    :Rad(16)
                    :Color(Mantle.color[colId])
                    :Shape(RNDX.SHAPE_IOS)
                :Draw()
                draw.SimpleText(colId, 'Fated.12', w * 0.5, h * 0.5, color_black, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            end
        end

        return panel
    end

    tabs:AddTab('Settings', CreateSettings(), Material('icon16/cog.png'))
end

concommand.Add('mantle_menu', CreateMenu)
