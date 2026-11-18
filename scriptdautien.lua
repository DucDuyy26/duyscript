-- TỰ ĐỘNG NHẬN DIỆN MÔI TRƯỜNG ĐỂ CHẠY TRÊN CẢ STUDIO VÀ DELTA MOBILE
local success, OrionLib = pcall(function()
    return loadstring(game:HttpGet('https://raw.githubusercontent.com/shlexware/Orion/main/source'))()
end)

if not success or not OrionLib then
    OrionLib = require(game.ReplicatedStorage:WaitForChild("OrionLib"))
end

local Window = OrionLib:MakeWindow({
	Name = "Dizzi Hub",
	HidePremium = false,
	SaveConfig = false,
	ConfigFolder = "MyScriptConfig",
	IntroIcon = "rbxassetid://84764915900713",
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
