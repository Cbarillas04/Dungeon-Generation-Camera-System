--[[
Local script that locks onto a target

@author Sonic96911, moocow969
@version 1.0
]]

--Intializing variables
local player = game.Players.LocalPlayer
local camera = workspace.CurrentCamera
local Mouse = player:GetMouse()

local character = player.Character or player.CharacterAdded:wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

-- Intializing Services
local UI_SERVICE = game:GetService("UserInputService")
local RUN_SERVICE = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local Tween = nil
local TweenInformation = TweenInfo.new(0.05, Enum.EasingStyle.Cubic, Enum.EasingDirection.InOut, 0, false, 0)

local pin = script:WaitForChild("Pin")
local range = 75
local locked = false
local target = nil


--[[
Find the lowest distance of humanoid npc to player so the lock is on the closest one
@param list of humanoids
@return lowest
--]]
local function getLowest(list)
	local low = math.huge
	local lowest
	for i, v in pairs(list) do
		local distBetween = (character.HumanoidRootPart.Position - v.Position).magnitude
		if distBetween < low then
			low = distBetween
			lowest = i
		end
	end
	return lowest
end

--[[
Iterates through a table to only get the humanoid root parts
@param list of parts in region
@returns templist of humanoid root parts
]]
--]]
local function findRootPart(list)
	local tempList = {}

	for _, part in ipairs(list) do
		if part.Name == "HumanoidRootPart" and game.Players:FindFirstChild(part.Parent.Name) == nil then -- part.Parent:FindFirstChild("Humanoid")
			table.insert(tempList, part)
		end
	end
	return tempList
end

--[[ 
Creates a region that detects a humanoid
@param range for range of detection
@return the Humanoid if found
]]--
local function findHumanoidInRegion(range)
	local region = Region3.new(camera.CFrame.Position - Vector3.new(range, range, range), camera.CFrame.Position + Vector3.new(range, range, range))
	local parts = game.Workspace:FindPartsInRegion3(region, character, 100)
	local onlyHumanoids = findRootPart(parts)
	local closetHumanoid = onlyHumanoids[getLowest(onlyHumanoids)]

	return closetHumanoid
end



--[[
Checks if a given model has primary part
If primary part, sets up pin
@params Model
@returns nothing if no primary part
--]]
local function LockOn(Model)
	if not Model.PrimaryPart then warn("No primary part"); return end
	camera.CameraType = Enum.CameraType.Scriptable
	pin.Parent = character
	target = Model.HumanoidRootPart
	pin.Parent = character
	pin.Adornee = target
	pin.Enabled = true
	locked = true

	character:SetAttribute("TargetLock", locked)
end

--[[
Disables pin, locked, and target
Cancels lockon
--]]
local function LockOff()
	pin.Enabled = false
	locked = false
	target = nil
	if Tween then 
		Tween:Cancel() 
	end

	camera.CameraType = Enum.CameraType.Custom
	character:SetAttribute("TargetLock", locked)
end

--[[
Checks if there is a wall in between the player and the camera
@params range of detection
@returns boolean if in range
--]]
local function wallCollision(range)
	-- Edit newCameraCFrame to the current camera CFrame if changed
	local newCameraCFrame = CFrame.new(character.Head.Position, target.Position)*CFrame.new(5,3,12)
	local ray = Ray.new(character.HumanoidRootPart.Position, (newCameraCFrame.Position - character.HumanoidRootPart.Position).unit * range)
	local hit, position = game.Workspace:FindPartOnRay(ray, character)

	if hit then
		if not(hit.Parent:FindFirstChild("Humanoid")) and hit.Transparency ~= 1 and hit.Name ~= "floor" then
			return true 
		end
	end
	return false
end
--[[
@params input of player
@params gameProcess of boolean if server registered input
--]]
local function OnLockRequested(input, gameProcess)
	if gameProcess or input.UserInputType ~= Enum.UserInputType.Keyboard then return end
	if input.KeyCode ~= Enum.KeyCode.LeftControl then return end

	local target = findHumanoidInRegion(range)
	if locked or not target then LockOff() return end
	if (target.Position -  humanoidRootPart.Position).magnitude > range then warn("Target too far") return end

	if target.Parent:FindFirstChild("Humanoid") and target.Parent:IsA("Model") then
		LockOn(target.Parent)
		return
	end

	while target.Parent ~= workspace do
		wait()
		target = target.Parent

		if target.Parent:FindFirstChild("Humanoid") and target.Parent:IsA("Model") then
			LockOn(target.Parent) 
			return
		end
	end
end

-- Gets player input
UI_SERVICE.InputBegan:connect(OnLockRequested)

--[[
Runs the main function, checks for humanoid that is alive and if so, locks onto it
While locked on, player faces target's humanoid root part
Stays locked on until target is dead or player leaves given range
--]]
RUN_SERVICE.RenderStepped:connect(function()
	if not character:FindFirstChild("Humanoid") then return end
	if character.Humanoid.Health == 0 then LockOff() end

	if not locked then return end
	if target.Parent.Humanoid.Health == 0 then LockOff() return end
	if (humanoidRootPart.Position - target.Position).magnitude > range then LockOff() return end

	local CurrentPos = humanoidRootPart.CFrame.p
	local LookPos = Vector3.new(target.Position.x, humanoidRootPart.Position.y, target.Position.z)
	humanoidRootPart.CFrame = CFrame.lookAt(CurrentPos, LookPos)
	
	-- Change values for different camera positions
	local zVal = 12
	local xVal = 5
	local yVal = 3
	local speed = .1
	character.Head.Transparency = 0
	if wallCollision(20) then
		character.Head.Transparency = .5
		zVal = -.7
		xVal = 0
		yVal = .5
		speed = .3
	end

	local goal = {CoordinateFrame =(CFrame.new((humanoidRootPart.CFrame * CFrame.new(0,0,30)).p, target.Position)*CFrame.new(xVal,yVal,zVal))}
	camera.CFrame = camera.CFrame:lerp(CFrame.new(character.Head.Position, target.Position)*CFrame.new(xVal,yVal,zVal), speed)
	Tween = TweenService:Create(camera, TweenInformation, goal)
end)
