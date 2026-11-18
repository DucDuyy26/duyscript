-- KIỂM TRA VÀ CHỜ GAME TẢI XONG
if not game:IsLoaded() then
    game.Loaded:Wait()
end

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")
local VirtualUser = game:GetService("VirtualUser")
local Camera = Workspace.CurrentCamera

-- TẢI THƯ VIỆN ORIONLIB TRỰC TIẾP TỪ INTERNET
local success, OrionLib = pcall(function()
    return loadstring(game:HttpGet('https://raw.githubusercontent.com/jensonhirst/Orion/main/source'))()
end)

if not success or not OrionLib then
    warn("Không thể tải được OrionLib!")
    return
end

-- ==========================================
-- CÀI ĐẶT MẶC ĐỊNH
-- ==========================================
getgenv().AutoFarm = false
getgenv().TargetMobNames = {"Reborn Skeleton", "Living Zombie", "Demonic Soul", "Possessed Mummy"} 
getgenv().SelectedWeapon = "Melee"

-- HÀM TỰ ĐỘNG TRANG BỊ VŨ KHÍ
local function EquipWeapon(toolType)
    local character = LocalPlayer.Character
    if not character then return end
    
    local currentTool = character:FindFirstChildOfClass("Tool")
    if currentTool then
        if toolType == "Sword" and currentTool.ToolTip == "Sword" then return end
        if toolType == "Melee" and (currentTool.ToolTip == "Melee" or currentTool.Name:match("Combat")) then return end
    end
    
    local backpack = LocalPlayer:FindFirstChildOfClass("Backpack")
    if backpack then
        for _, item in pairs(backpack:GetChildren()) do
            if item:IsA("Tool") then
                if toolType == "Sword" and item.ToolTip == "Sword" then
                    character.Humanoid:EquipTool(item)
                    break
                elseif toolType == "Melee" and (item.Name:match("Combat") or item.ToolTip == "Melee" or item.Name:match("Step") or item.Name:match("Claw")) then
                    character.Humanoid:EquipTool(item)
                    break
                end
            end
        end
    end
end

-- HÀM TÌM QUÁI KHỚP TÊN (ƯU TIÊN CON GẦN NHẤT)
local function GetMobFromList(nameList)
    local target = nil
    local shortestDistance = math.huge
    
    local enemies = Workspace:FindFirstChild("Enemies")
    if enemies then
        for _, mob in pairs(enemies:GetChildren()) do
            local hum = mob:FindFirstChildOfClass("Humanoid")
            local rootPart = mob:FindFirstChild("HumanoidRootPart")
            if hum and rootPart and hum.Health > 0 and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                for _, targetName in ipairs(nameList) do
                    local cleanTarget = targetName:match("^%s*(.-)%s*$")
                    if mob.Name:lower():find(cleanTarget:lower()) then
                        local distance = (LocalPlayer.Character.HumanoidRootPart.Position - rootPart.Position).Magnitude
                        if distance < shortestDistance then
                            shortestDistance = distance
                            target = mob
                        end
                        break
                    end
                end
            end
        end
    end
    return target
end

-- TẠO GIAO DIỆN MENU
local Window = OrionLib:MakeWindow({
	Name = "Dizzi Hub | Click Auto Farm",
	HidePremium = false,
	SaveConfig = false,
	ConfigFolder = "DizziConfig_Click",
	IntroIcon = "rbxassetid://84764915900713",
	IntroText = "Dizzi Hub Loading..."
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
		local char = LocalPlayer.Character
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

FarmTab:AddTextbox({
	Name = "Danh sách tên quái (Cách nhau dấu phẩy)",
	Default = "Reborn Skeleton, Living Zombie, Demonic Soul, Possessed Mummy",
	TextDisappear = false,
	Callback = function(Value)
		local list = {}
		for mobName in Value:gmatch("[^,]+") do
			local cleanName = mobName:match("^%s*(.-)%s*$")
			if cleanName ~= "" then
				table.insert(list, cleanName)
			end
		end
		if #list > 0 then
			getgenv().TargetMobNames = list
		end
	end
})

FarmTab:AddDropdown({
	Name = "Chọn Vũ Khí Farm",
	Default = "Melee",
	Options = {"Melee", "Sword"},
	Callback = function(Value)
		getgenv().SelectedWeapon = Value
	end
})

FarmTab:AddToggle({
	Name = "Auto Farm Click Màn Hình",
	Default = false,
	Callback = function(Value)
		getgenv().AutoFarm = Value
		
		task.spawn(function()
			while getgenv().AutoFarm do
				task.wait(0.1)
				pcall(function()
					local char = LocalPlayer.Character
					if char and char:FindFirstChild("HumanoidRootPart") then
						-- 1. Tự động cầm vũ khí
						EquipWeapon(getgenv().SelectedWeapon)
						
						-- 2. Tìm quái
						local mob = GetMobFromList(getgenv().TargetMobNames)
						if mob and mob:FindFirstChild("HumanoidRootPart") then
							local mobRoot = mob.HumanoidRootPart
							
							-- Bay lơ lửng cách phía trên quái 18 studs
							char.HumanoidRootPart.CFrame = mobRoot.CFrame * CFrame.new(0, 18, 0)
							char.HumanoidRootPart.Velocity = Vector3.new(0, 0, 0)
							
							-- Hướng camera nhìn thẳng xuống con quái để cú click màn hình trúng đích
							Camera.CFrame = CFrame.new(Camera.CFrame.Position, mobRoot.Position)
							
							-- 3. Giả lập bấm click màn hình điện thoại để đánh
							VirtualUser:CaptureController()
							VirtualUser:Button1Down(Vector2.new(100, 100), Camera.CFrame)
							task.wait(0.05)
							VirtualUser:Button1Up(Vector2.new(100, 100), Camera.CFrame)
						end
					end
				end)
			end
		end)
	end
})

OrionLib:Init()
