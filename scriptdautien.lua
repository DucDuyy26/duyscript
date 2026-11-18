local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/jensonhirst/Orion/main/source')))()

local Window = OrionLib:MakeWindow({
    Name = "DucDuyy Mobile Hub",
    HidePremium = false,
    SaveConfig = false,
    ConfigFolder = "DucDuyyConfig"
})

local MainTab = Window:MakeTab({
    Name = "Chức năng",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

MainTab:AddSlider({
    Name = "Tốc độ chạy",
    Min = 16,
    Max = 200,
    Default = 16,
    Color = Color3.fromRGB(255, 255, 255),
    Increment = 1,
    ValueName = "Tốc độ",
    Callback = function(Value)
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
    end    
})

OrionLib:Init()
