-- DÒNG 1 NÀY LÀ DÒNG ĐÃ ĐƯỢC THAY MỚI ĐỂ CHẠY TRONG STUDIO:
local OrionLib = require(game.ReplicatedStorage:WaitForChild("OrionLib"))

-- CÁC DÒNG DƯỚI GIỮ NGUYÊN:
local Window = OrionLib:MakeWindow({
	Name = "Dizzi Hub",
	HidePremium = false,
	SaveConfig = false,
	ConfigFolder = "MyScriptConfig",
	-- Thêm 2 dòng này để biến thành nút tròn có ảnh:
	IntroIcon = "rbxassetid://84764915900713", -- Thay số ID decal ảnh của bạn vào đây
	IntroText = "Dizzi Hub"
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
		local char = game.Players.LocalPlayer.Character
		if char and char:FindFirstChild("Humanoid") then
			char.Humanoid.WalkSpeed = Value
		end
	end    
})
local FarmTab = Window:MakeTab({
	Name = "Farm",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})

FarmTab:AddToggle({
	Name = "Auto Farm Level",
	Default = false,
	Callback = function(Value)
		print("Auto Farm Level:", Value)
	end
})

OrionLib:Init()
