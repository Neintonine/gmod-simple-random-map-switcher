SRMS_MapLoader = {}

local nextMap = nil

function SRMS_MapLoader.GetNextMap()
	if nextMap ~= nil and SRMS_Configuration.getValue("single_random_map") then
		return nextMap
	end
	nextMap = SRMS_RandomMethod.getRandomMap()
	SRMS_Logger.log("Select map: " .. nextMap, 3)
	return nextMap
end

function SRMS_MapLoader.LoadNextMap(played)
	if played == nil then
		played = false
	end

	if nextMap == nil then
		-- Select Random map...
		SRMS_MapLoader.GetNextMap()
	end

	if played and SRMS_PlayedMaps.isActive() then
		SRMS_PlayedMaps.increment(game.GetMap())
	end

	SRMS_Logger.log("Load map: " .. nextMap, 3)
	RunConsoleCommand("changelevel", nextMap)
end

function SRMS_MapLoader.ForgetNextMap()
	nextMap = nil
end
