local INTERNAL_MAP_PREFIXES = {
	"test",
}

SRMS_MapPool = {}

local POOL = nil

local function getGamemodePrefixes()
	return SRMS_Configuration.getValue("map_prefixes")
end

local function hasPrefix(map, prefixes)
	for _, prefix in pairs(prefixes) do
		if not string.StartsWith(map, prefix) then
			continue
		end

		return true
	end

	return false
end

-- Modified from: https://github.com/ksprugevics/rafs-mapvote/blob/main/lua/server/config/rmv_map_info.lua#L1
local function cleanMapList(mapList)
	local temp = {}
	for i, map in pairs(mapList) do
		if hasPrefix(map, INTERNAL_MAP_PREFIXES) then
			continue
		end

		temp[i] = map:sub(1, -5)
	end
	return temp
end

function SRMS_MapPool.GetMaps()
	if POOL ~= nil then
		return POOL
	end

	local prefixes = getGamemodePrefixes()

	SRMS_Logger.log("Loading maps...", SRMS_Logger.SEVERITY.INFO)

	local maps = file.Find("maps/*.bsp", "GAME")
	maps = cleanMapList(maps)

	if prefixes == false then
		print("WARNING: The game '" .. engine.ActiveGamemode() .. "' does not have map prefixes set - Using all maps")
		POOL = maps
		return POOL
	end

	SRMS_Logger.log("using prefixes: " .. table.ToString(prefixes), SRMS_Logger.SEVERITY.DEBUG)
	local filteredMaps = {}
	for i, map in pairs(maps) do
		if not hasPrefix(map, prefixes) then
			continue
		end

		filteredMaps[i] = map
	end

	POOL = filteredMaps

	SRMS_Logger.logTable("Found Maps:", POOL, SRMS_Logger.SEVERITY.DEBUG)

	return POOL
end

function SRMS_MapPool.IsCurrentMapInPool()
	local currentMap = game.GetMap()

	if currentMap == "menu" then
		return true
	end

	local maps = SRMS_MapPool.GetMaps()
	return table.HasValue(maps, currentMap)
end
