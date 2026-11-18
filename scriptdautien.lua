-- Tải thư viện giao diện Orion miễn phí
local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()

-- Tạo cửa sổ menu chính
local Window = OrionLib:MakeWindow({
    Name = "Dizzi Hub",
    HidePremium = false,
    SaveConfig = true,
    ConfigFolder = "MyScriptConfig"
})

-- Tạo một Tab (danh mục) mới
local MainTab = Window:MakeTab({
    Name = "Chức năng chính",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

-- Thêm thanh kéo chỉnh Tốc độ chạy (WalkSpeed)
MainTab:AddSlider({
    Name = "Tốc độ chạy",
    Min = 16,
    Max = 200,
    Default = 16,
    Color = Color3.fromRGB(255, 255, 255),
    Increment = 1,
    ValueName = "Tốc độ",
    Callback = function(Value)
        local player = game.Players.LocalPlayer
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid.WalkSpeed = Value
        end
    end    
})

-- Thêm nút gạt Bật/Tắt vòng lặp tự động (Toggle)
getgenv().AutoAction = false

MainTab:AddToggle({
    Name = "Bật vòng lặp tự động",
    Default = false,
    Callback = function(Value)
        getgenv().AutoAction = Value
        
        task.spawn(function()
            while getgenv().AutoAction do
                task.wait(0.5)
                print("Đang thực hiện tác vụ tự động...")
            end
        end)
    end    
})

-- Khởi chạy giao diện
OrionLib:Init()
