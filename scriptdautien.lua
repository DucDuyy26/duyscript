-- Kiểm tra xem game đã load xong chưa
if not game:IsLoaded() then
    game.Loaded:Wait()
end

-- Tải thư viện OrionLib trực tiếp từ nguồn chính hãng
local OrionLib = loadstring(game:HttpGet('https://raw.githubusercontent.com/shlexware/Orion/main/source'))()

-- Tạo cửa sổ Menu "Dizzi Hub" giống như trên Studio của bạn
local Window = OrionLib:MakeWindow({
    Name = "Dizzi Hub", 
    HidePremium = false, 
    SaveConfig = true, 
    ConfigFolder = "DizziConfig"
})

-- Tạo Tab "Chức năng"
local TabChucNang = Window:MakeTab({
    Name = "Chức năng",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

-- Thêm ô chỉnh tốc độ chạy (Tương ứng với mục trong ảnh của bạn)
TabChucNang:AddTextbox({
    Name = "Tốc độ chạy",
    Default = "16",
    TextDisappear = false,
    Callback = function(Value)
        local speed = tonumber(Value)
        if speed then
            local player = game.Players.LocalPlayer
            if player and player.Character and player.Character:FindFirstChild("Humanoid") then
                player.Character.Humanoid.WalkSpeed = speed
            end
        end
    end
})

-- Tạo Tab "Farm"
local TabFarm = Window:MakeTab({
    Name = "Farm",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

TabFarm:AddToggle({
    Name = "Tự động Farm",
    Default = false,
    Callback = function(State)
        print("Trạng thái Auto Farm: ", State)
        -- Viết code farm của bạn ở đây
    end
})

-- Khởi động giao diện Orion
OrionLib:Init()
