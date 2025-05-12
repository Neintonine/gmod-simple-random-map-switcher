SRMS_PlayedMaps = {}

local PLAYED_MAPS_PATH = "srms/played_maps.json"
local PLAYED_MAPS_NAMESPACE = "DATA"

local maps = {}

function SRMS_PlayedMaps.save()
	file.Write(PLAYED_MAPS_PATH, util.TableToJSON(maps))
end

function SRMS_PlayedMaps.load()
	if not SRMS_PlayedMaps.isActive() then
		SRMS_Logger.log("Won't load played games... due to not configured to do so.", 2)
	end

	if not file.IsDir("srms", PLAYED_MAPS_NAMESPACE) then
		file.CreateDir("srms")
	end

	if not file.Exists(PLAYED_MAPS_PATH, PLAYED_MAPS_NAMESPACE) then
		SRMS_Logger.log("Missing played maps file...", 4)
		return
	end

	local playedMapsData = file.Read(PLAYED_MAPS_PATH, PLAYED_MAPS_NAMESPACE)
	maps = util.JSONToTable(playedMapsData)

	SRMS_Logger.logTable("Maps loaded", maps, 4)
end

function SRMS_PlayedMaps.isActive()
	return SRMS_Configuration.getValue("track_played_maps")
end

function SRMS_PlayedMaps.increment(map)
	if maps[map] == nil then
		maps[map] = 0
	end

	SRMS_Logger.log("Incrementing map " .. map .. " by one", 4)

	maps[map] = maps[map] + 1

	SRMS_PlayedMaps.save()
end

function SRMS_PlayedMaps.getMapCount(map)
	if maps[map] == nil then
		return 0
	end

	return maps[map]
end

function SRMS_PlayedMaps.getMinValue()
	if table.IsEmpty(maps) then
		return 0
	end

	local min = math.huge

	for map, value in pairs(maps) do
		min = min < value and min or value
	end

	return min
end

function SRMS_PlayedMaps.getMaxValue()
	if table.IsEmpty(maps) then
		return 0
	end

	local max = 0

	for map, value in pairs(maps) do
		max = max > value and max or value
	end

	return max
end
