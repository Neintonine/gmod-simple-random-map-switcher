SRMS_RandomMethod = {}

local BAG_PATH = "srms/bag.json"
local BAG_NAMESPACE = "DATA"

local function getActiveBag()
	if not file.IsDir("srms", BAG_NAMESPACE) then
		file.CreateDir("srms")
	end

	if not file.Exists(BAG_PATH, BAG_NAMESPACE) then
		return {}
	end

	local playedMapsData = file.Read(BAG_PATH, BAG_NAMESPACE)
	bag = util.JSONToTable(playedMapsData)
	return bag
end

local function createBag()
	local maps = SRMS_MapPool.GetMaps()
	local currentMap = game.GetMap()

	local bag = {}
	local mapsCopy = table.Copy(maps)
	local firstMap = true
	SRMS_Logger.log("Found " .. #mapsCopy .. " maps", 4)
	repeat
		local map = nil
		if firstMap then
			local index = nil
			repeat
				index = math.random(1, #mapsCopy)
				map = mapsCopy[index]
			until map ~= currentMap
			table.remove(mapsCopy, index)
			firstMap = false
		else
			map = table.remove(mapsCopy, math.random(1, #mapsCopy))
		end

		mapsCopy = table.ClearKeys(mapsCopy)

		table.insert(bag, map)
	until table.IsEmpty(mapsCopy)

	SRMS_Logger.logTable("Created bag", bag, 4)

	local bagObj = {}
	bagObj["maps"] = bag
	bagObj["pointer"] = 1

	return bagObj
end

local function updateBag(bag)
	local maps = SRMS_MapPool.GetMaps()
	local bagMaps = bag["maps"]

	local unusedMaps = {}
	for i, map in pairs(maps) do
		if table.HasValue(bagMaps, map) then
			continue
		end

		table.insert(unusedMaps, map)
	end

	if table.IsEmpty(unusedMaps) then
		return bag
	end

	local pointer = bag["pointer"]

	for i, map in pairs(unusedMaps) do
		local amountOfMissingMaps = #bagMaps - pointer
		local weightedAmount = math.ceil(amountOfMissingMaps / 1.5) -- the dividant is for some weighting so the new maps are more likely to show up earlier
		local index = math.random(pointer, weightedAmount + pointer)

		table.insert(bagMaps, index, map)
	end

	local newBag = {}
	newBag["maps"] = bagMaps
	newBag["pointer"] = pointer
	return newBag
end

local function saveBag(bag)
	file.Write(BAG_PATH, util.TableToJSON(bag))
end

function SRMS_RandomMethod.getRandomMap()
	local currentBag = getActiveBag()
	if table.IsEmpty(currentBag) or #currentBag["maps"] < currentBag["pointer"] then
		currentBag = createBag()
	else
		currentBag = updateBag(currentBag)
	end
	SRMS_Logger.logTable("Uses Bag", currentBag, 4)

	local nextMap = currentBag["maps"][currentBag["pointer"]]

	currentBag["pointer"] = currentBag["pointer"] + 1
	saveBag(currentBag)
	return nextMap
end
