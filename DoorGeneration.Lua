-- @author moocow969
-- 111.9, 17.5, -120.9
local doorGeneration = {}

local doorFolder = game.ReplicatedStorage.Limbo.DoorTypes

-- Private Functions

--[[
Run through the folder of models in workspace and find all the parts marked doorWay
@params list of models
@returns list of doorways
--]]
function findDoorWays(list)
	local temp = {}
	for _,i in pairs(list) do
		for _,j in pairs(i.Entrances:GetChildren()) do
			if j.Name == "doorWay" then
				table.insert(temp, j)
			end
		end
	end
	return temp
end

--[[
Gets door
@params folder of door types
@returns door
--]]
function createDoorCopy(folder, selected, model)
	local newDoor = folder:FindFirstChild(selected):Clone()
	newDoor.Parent = model
	return newDoor
end

--[[
Aligns the the door correctly to fit with the floor
@params orientation of the open entree part
@returns a new vector3
--]]
function setpush(orientation)
	if math.abs(orientation) == 180 then
		return Vector3.new(0,17.4,-.5)
	elseif orientation == 0 then
		return Vector3.new(0,17.4,.5)
	elseif orientation == 90 then
		return Vector3.new(.5,17.4,0)
	elseif orientation == -90 then
		return Vector3.new(-.5,17.4,0)
	end
end

--[[
Gives specfici door design
@params part the current part to get parented to
@params folder of door types
@returns door
--]]

function doorDesign(part, folder)
	if part.Parent.Parent.Name == "Start" then
		return createDoorCopy(folder, "startDoor", part)
	elseif part.Parent.Parent.Name == "Item" then
		return createDoorCopy(folder, "itemDoor", part)
	else
		return createDoorCopy(folder, "doorWay1", part)
	end
end

--[[
Places the Doors
@params list of models
@params folder of door types
--]]
function placeDoor(list, folder)
	local position
	local orientation
	local door
	for _,i in pairs(list) do
		door = doorDesign(i, folder)
		orientation = i.Orientation + Vector3.new(0,90,0)
		position = i.Position + setpush(i.Orientation.Y)
		if orientation.Y == 0 then
			door:SetPrimaryPartCFrame(CFrame.new(position))
		else
			door:SetPrimaryPartCFrame(CFrame.new(position) * CFrame.Angles(0,math.rad(orientation.Y),0))
		end
	end
end
--------------------------------------------------

-- Public Functions

--[[
Creates doorways
@params list of models
--]]
function doorGeneration.createDoorWays(list)
	local allDoorWays = findDoorWays(list)
	placeDoor(allDoorWays, doorFolder)
end

return doorGeneration
