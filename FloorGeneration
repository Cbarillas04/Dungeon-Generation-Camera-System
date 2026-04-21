-- @author moocow969

local floorGeneration = {}

-- Private Functions

--[[
Sets position of part
@params part to move
@params position to move part to
--]]
function setPosition(part, position, rotation)
	local newCFrame = CFrame.new(position)
	if rotation ~= 0 and rotation ~= 180 then
		newCFrame = newCFrame * CFrame.Angles(0,math.rad(rotation * -1),0)
		part:SetPrimaryPartCFrame(newCFrame)
	elseif rotation == 180 then
		newCFrame = newCFrame * CFrame.Angles(0,0,0)
		part:SetPrimaryPartCFrame(newCFrame)
	else
		newCFrame = newCFrame * CFrame.Angles(0,math.rad(180),0)
		part:SetPrimaryPartCFrame(newCFrame)
	end
end

--[[
Parses through the model and looks for entrance
It then randomly selects one if there are multiple
@params model
@params rotation
@return temp
--]]
function findEntrance(model)
	local temp = {}
	for _,i in pairs(model.Entrances:GetChildren()) do
		if i.Name == "Entree" then
			table.insert(temp, i)
		end
	end

	return temp[math.random(#temp)]
end

--[[
Runs through all the models already placed, and looks for an open entree point
@params list of models
@returns temp of random open entree point
--]]
function selectEntrees(list)
	local temp = {}
	for _,i in pairs(list) do
		for _,j in pairs(i.Entrances:GetChildren()) do
			if j.Name == "Entree" then
				table.insert(temp, j)
			end
		end
	end
	return temp[math.random(#temp)]
end

--[[
Runs through the new placed model and looks in a region if there are parts named entree
If there are, then it renames them to indicate a doorway
@params model to parse through
@params entrance of the region position to check
--]]
local function labelDoorWays(model)
	for _,i in pairs(model.Entrances:GetChildren()) do
		if i.Name == "Entree" then
			local region = Region3.new(i.Position, i.Position)
			local parts = game.Workspace:FindPartsInRegion3(region, nil, math.huge)
			if #parts > 1 then
				for _,j in pairs(parts) do
					if j.Name == "Entree" then
						j.Name = "doorWay"
					end
				end
			end
		end
	end
end


--[[
-- TESTING FUNCTION, HELPS WITH DEBUGGING
local function createVisualBox(region, parent)
	-- Calculate the center and size of the Region3
	local minVector = region.CFrame.Position - region.Size / 2
	local maxVector = region.CFrame.Position + region.Size / 2
	local center = (minVector + maxVector) / 2
	local size = maxVector - minVector

	-- Create a transparent part to represent the region
	local part = Instance.new("Part")
	part.Size = size
	part.Position = center
	part.Anchored = true
	part.Transparency = 0.5
	part.CanCollide = false
	part.Parent = parent

	-- Optionally, set color or other properties
	part.BrickColor = BrickColor.new("Bright red")
	part.Material = Enum.Material.ForceField
	return part
end
--]]

--[[
Helper Function for checkCollision
@params model of current model
@returns region3 point
--]]
local function specialRooms(model)
	if model.Name == "Boss" then
		return Region3.new(model.floor.Position - Vector3.new(225,20.75,225), model.floor.Position + Vector3.new(225,130,225))
	else
		return Region3.new(model.floor.Position - Vector3.new(50,20.75,50), model.floor.Position + Vector3.new(50,20.75,50))
	end
end

--[[
Check if a piece will collide if placed there
@returns true if collision detected
@returns false if no collision detected
--]]
local function checkCollision(model, pos)
	local temp = model:Clone()
	setPosition(temp, pos.Position, pos.Orientation.Y)
	local region = specialRooms(temp)
	local parts = game.Workspace:FindPartsInRegion3(region, nil, math.huge)
	local num = 0

	--local something = createVisualBox(region, workspace)
	temp.Name = "copyTest"
	temp.Parent = workspace

	for _,i in pairs(parts) do
		if i.Name == "floor" then
			num += 1
			--something:Destroy()
		end
	end

	temp:Destroy()
	if num > 0 then
		return true
	end
	return false
end
---------------------------------------------------------------------------------------------

-- Public Functions

--[[
Parses through a list and randomly selects one
@params list of Models
@returns selection
--]]
function floorGeneration.pickrandomTile(list)
	local tiles = list:GetChildren()
	local selection = tiles[math.random(#tiles)]
	while selection.Name == "Start" or selection.Name == "End" or selection.Name == "Boss" or selection.Name == "Item" do
		selection = tiles[math.random(#tiles)]
	end
	return selection
end

--[[
Sets parent of part to workspace
@params part to copy
@return copy
--]]
function floorGeneration.setinWorkspace(part, folder)
	local copy = part:Clone()
	copy.Parent = workspace:WaitForChild(folder.Name)
	return copy
end

--[[
Places the start model of the floor
@params list of models
@return copy
--]]
function floorGeneration.placeStart(list, folder)
	local copy = list:FindFirstChild("Start")
	copy = copy:Clone()
	copy.Parent = workspace:WaitForChild(folder.Name)
	copy:SetPrimaryPartCFrame(CFrame.new(Vector3.new(-68.9, 167.8, -103.2)))
	return copy
end

--[[
Places the tiles to creat the entire floor
@params previousPart the previous model
@params currentPart the current modle
--]]
function floorGeneration.placeTiles(possibleEntrees, currentPart)
	--Find an opening for the current part
	local entrance = findEntrance(currentPart)
	--Find an opening from previously placed parts
	local openEntree = selectEntrees(possibleEntrees)
	currentPart.PrimaryPart = entrance

	local fail = 0
	while checkCollision(currentPart,openEntree) do
		if fail > 10 then
			return true
		end
		openEntree = selectEntrees(possibleEntrees)
		fail += 1
	end

	setPosition(currentPart, openEntree.Position, openEntree.Orientation.Y)
	wait()
	labelDoorWays(currentPart)
end

return floorGeneration
