-- KIỂM TRA VÀ CHỜ GAME TẢI XONG
if not game:IsLoaded() then
    game.Loaded:Wait()
end

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")

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
getgenv().CurrentTween = nil

-- HÀM DỪNG TWEEN ĐANG CHẠY KHI TẮT AUTO FARM
local function StopTween()
    if getgenv().CurrentTween then
        getgenv().CurrentTween:Cancel()
        getgenv().CurrentTween = nil
    end
end

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
	Name = "Dizzi Hub | Smooth Tween Farm",
	HidePremium = false,
	SaveConfig = false,
	ConfigFolder = "DizziConfig_Tween",
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
	Name = "Auto Farm Bay Mượt (Tween)",
	Default = false,
	Callback = function(Value)
		getgenv().AutoFarm = Value
		
		if not Value then
			StopTween()
		end
		
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
							local targetCFrame = mobRoot.CFrame * CFrame.new(0, 15, 0)
							
							-- Tính toán thời gian bay dựa trên khoảng cách (khoảng cách / tốc độ bay)
							local distance = (char.HumanoidRootPart.Position - mobRoot.Position).Magnitude
							local flySpeed = 250 -- Tốc độ bay (studs/s)
							local timeVal = distance / flySpeed
							if timeVal < 0.1 then timeVal = 0.1 end
							
							-- 3. Bay từ từ đến vị trí phía trên quái bằng TweenService
							StopTween()
							local tweenInfo = TweenInfo.new(timeVal, Enum.EasingStyle.Linear)
							getgenv().CurrentTween = TweenService:Create(char.HumanoidRootPart, tweenInfo, {CFrame = targetCFrame})
							getgenv().CurrentTween:Play()
							
							-- Đợi bay đến nơi hoặc quái chết
							local startTime = tick()
							while getgenv().AutoFarm and mob and mob:FindFirstChild("Humanoid") and mob.Humanoid.Health > 0 do
								if (tick() - startTime) > timeVal then
									-- Đã đến nơi, tiến hành tấn công bằng cách kích hoạt Tool đang cầm
									local tool = char:FindFirstChildOfClass("Tool")
									if tool then
										tool:Activate()
									end
								end
								task.wait(0.05)
							end
							StopTween()
						else
							StopTween()
						end
					end
				end)
			end
			StopTween()
		end)
	end
})

OrionLib:Init()
