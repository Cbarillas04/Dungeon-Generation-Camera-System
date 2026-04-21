-- @author moocow969

local wallGeneration = {}

local doorFolder = game.ReplicatedStorage.Limbo.WallTypes

-- Private Functions

--[[
Run through the folder of models in workspace and find all the parts marked doorWay
@params list of models
@returns list of doorways
--]]
function findOpenEntrees(list)
	local temp = {}
	for _,i in pairs(list) do
		for _,j in pairs(i.Entrances:GetChildren()) do
			if j.Name == "Entree" then
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
function createWallCopy(folder, selected, model)
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
Gives specfic wall design
@params part the current part to get parented to
@params folder of wall types
@returns wall
--]]
function wallDesign(part, folder)
	local name = part.Parent.Parent.Name
	
	if name == "Start" then
		return createWallCopy(folder, "startWall", part)
	elseif name == "Skinny" then
		return createWallCopy(folder, "skinnyWall", part)
	else
		return createWallCopy(folder, "wall1", part)
	end
end

--[[
Places the Walls
@params list of models
@params folder of wall types
--]]
function placeWall(list, folder)
	local position
	local orientation
	local wall
	for _,i in pairs(list) do
		wall = wallDesign(i, folder)
		orientation = i.Orientation + Vector3.new(0,90,0)
		position = i.Position + setpush(i.Orientation.Y)
		if orientation.Y == 0 then
			wall:SetPrimaryPartCFrame(CFrame.new(position))
		else
			wall:SetPrimaryPartCFrame(CFrame.new(position) * CFrame.Angles(0,math.rad(orientation.Y),0))
		end
	end
end

--------------------------------------------------

-- Public Functions

--[[
Creates doorways
@params list of models
--]]
function wallGeneration.createWalls(list)
	local allDoorWays = findOpenEntrees(list)
	placeWall(allDoorWays, doorFolder)
end

return wallGeneration
