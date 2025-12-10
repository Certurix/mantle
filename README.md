# Mantle

🎈 Universal GLua library for Garry's Mod: interface creation and convenient utilities.

All code is documented with comments — explore and find examples directly in the source code.

## Features

- Custom VGUI elements
- Fast rendering via RNDX
- Load materials from URL
- Flexible color theme system
- Server player notifications
- Modular architecture
- Cyrillic and UTF-8 support
- Unified menu with documentation and settings

## Library Menu

There is a menu with documentation and settings. To open it, use the console command: `mantle_menu`.

## Component Examples

### Documentation and VGUI Elements

<img width="983" height="720" alt="image" src="https://github.com/user-attachments/assets/892290e4-eb7f-4f65-b306-4ed5cc0c0e5b" />

### Light Window Mode

<img width="406" height="314" alt="image" src="https://github.com/user-attachments/assets/31669a2a-f2d3-4e2d-9e82-63a2188fe96e" />

### ComboBox

<img width="1002" height="728" alt="image" src="https://github.com/user-attachments/assets/8abb781b-b055-4178-9ee1-20046fbcc409" />

### SlideBox

<img width="1021" height="750" alt="image" src="https://github.com/user-attachments/assets/1afae892-4d6c-492b-8ded-38915282c8ee" />

### Tables

<img width="994" height="729" alt="image" src="https://github.com/user-attachments/assets/bd87ca15-5c25-41a4-9786-034faf71adc9" />

### Input Field

<img width="994" height="722" alt="image" src="https://github.com/user-attachments/assets/864f6206-f5b8-4072-bd8f-808d4f6f69df" />

### Popup Elements

<img width="989" height="720" alt="image" src="https://github.com/user-attachments/assets/a050be2a-727d-450c-84f3-2a04b15a0ceb" />

### Radial Menu

<img width="1920" height="1080" alt="image" src="https://github.com/user-attachments/assets/268fee97-d54a-4143-8c43-3b9a4e8e272f" />

### Optional Menu

<img width="352" height="323" alt="image" src="https://github.com/user-attachments/assets/2bd0f764-8fcd-4f9e-ba7e-1165c6afb10e" />

### Color Themes

<img width="996" height="775" alt="image" src="https://github.com/user-attachments/assets/a0b7c168-b773-48f1-b516-f070b76d34f6" />
<img width="1920" height="1080" alt="image" src="https://github.com/user-attachments/assets/14eaa457-7475-4fe3-9d4e-177035a75fcc" />
<img width="1920" height="1080" alt="image" src="https://github.com/user-attachments/assets/b0049430-1c08-4534-8075-3bf03201fd85" />
<img width="1920" height="1080" alt="image" src="https://github.com/user-attachments/assets/5c1ff333-ea6c-408c-aec6-f5f75921cb5d" />
<img width="1920" height="1080" alt="image" src="https://github.com/user-attachments/assets/e464c564-b7d1-42f6-bdde-6d5130a31acf" />
<img width="1920" height="1080" alt="image" src="https://github.com/user-attachments/assets/658fb731-aebc-4ce9-8d4d-2e9575961030" />

### And most importantly - smooth and magical animations

https://github.com/user-attachments/assets/6a813fd1-6da2-4c59-a84b-f78abfc20900

## External Examples

### Sending Server Notifications

```lua
hook.Add('PlayerSpawn', 'Test', function(pl)
    Mantle.notify(pl, Color(75, 0, 0), 'Title', 'Hello, ' .. pl:Name() .. '!')
    -- first argument true, in case of sending to all players
end)
```

### Image from URL

```lua
http.DownloadMaterial('https://i.imgur.com/eEnGbcp.jpeg', 'dog.png', function(your_mat)
    hook.Add('HUDPaint', 'Test', function()
        surface.SetDrawColor(255, 255, 255)
        surface.SetMaterial(your_mat)
        surface.DrawTexturedRect(5, 5, 250, 330)
    end)
end)
```

### Cyrillic Character Conversion

```lua
hook.Add('HUDPaint', 'test', function()
    local txt = 'ПриВЕТ МИР Hello World'
    -- default
    draw.SimpleText(string.lower(txt), 'Fated.20', 15, 15, color_black)
    -- mantle
    draw.SimpleText(utf8.lower(txt), 'Fated.20', 15, 35, color_black)
end)
```

<img width="247" height="75" alt="Comparison of default and mantle function" src="https://github.com/user-attachments/assets/77e0b791-e970-45da-90b3-1b4960b945fd" />

## Steam Workshop

For auto-updates – [subscribe and add the addon to your server collection](https://steamcommunity.com/sharedfiles/filedetails/?id=3126986993). This way you can always get the latest version of the library ✅
