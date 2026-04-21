--[[
This script represetnts the main mechanic behind the world generation for all floors

@author moocow969
@version 1.0
--]]
-- Set to Night
game.Lighting.ClockTime = 2.9
game.Lighting.Brightness = 0

-- Intializing Modules
local floorGeneration = require(script.FloorGeneration)
local doorGeneration = require(script.DoorGeneration)
local wallGeneration = require(script.WallGeneration)

-- Intializing
local floorlevel = game.ReplicatedStorage.Limbo.Rooms
local floorFolder

--Creates a folder to hold floor's tiles in workspace
local function createFolder()
	floorFolder = Instance.new("Folder")
	floorFolder.Name = floorlevel.Parent.Name .. "Folder"
	floorFolder.Parent = workspace
end

--[[
Determines when to forcefully input special rooms or a random room
@param floorSize The size of the floor.
@param roomCount The current number of rooms.
@return The tile to be used for the next room.
--]]
local function determineSpecialRooms(floorSize, roomCount)
	if floorSize//2 == roomCount then
		return floorlevel.Item
	elseif floorSize - 1 == roomCount then
		return floorlevel.Boss
	else
		return floorGeneration.pickrandomTile(floorlevel)
	end
end

--[[
Runs the main loop for the generation of the floor.
@param floorSize The size of the floor to be generated.
--]]
local function Main(floorSize)
	createFolder() 
	local roomCount = 0
	local startingBlock = floorGeneration.placeStart(floorlevel, floorFolder)
	local prevention = 0

	while roomCount < floorSize or prevention > 25 do
		local beforeNewPiece = floorFolder:GetChildren()
		
		local currentSelected = determineSpecialRooms(floorSize, roomCount)
		currentSelected = floorGeneration.setinWorkspace(currentSelected, floorFolder)
		
		local fail = floorGeneration.placeTiles(beforeNewPiece,currentSelected)
		if fail == true then
			prevention += 1
			currentSelected:Destroy()
		else
			roomCount += 1
		end
	end
	
	doorGeneration.createDoorWays(floorFolder:GetChildren())
	wallGeneration.createWalls(floorFolder:GetChildren())
end

Main(15)
