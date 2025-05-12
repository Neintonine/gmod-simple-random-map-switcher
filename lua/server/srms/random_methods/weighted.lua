SRMS_RandomMethod = {}

local function getMapWeight(map)
	return 1 / (SRMS_PlayedMaps.getMapCount(map) + 1)
end

function SRMS_RandomMethod.getRandomMap()
	local currentMap = game.GetMap()
	local maps = SRMS_MapPool.GetMaps()

	local weighted = {}
	local currentWeight = 0
	for i, map in pairs(maps) do
		if map == currentMap then
			continue
		end

		local nextWeight = currentWeight + getMapWeight(map)
		table.insert(weighted, { currentWeight, nextWeight, map })

		currentWeight = nextWeight
	end

	SRMS_Logger.logTable("Weighted Map Pool: (Max weight: " .. currentWeight .. ")", weighted, 4)

	local randValue = math.Rand(0, currentWeight)

	for i, x in pairs(weighted) do
		if x[1] > randValue then
			continue
		end

		if x[2] < randValue then
			continue
		end

		SRMS_Logger.log("Choose '" .. x[3] .. "' for next map.", 3)
		return x[3]
	end
end
