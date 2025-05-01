SRMS_RandomMethod = {}

function SRMS_RandomMethod.getRandomMap()
	local currentMap = game.GetMap()

	local maps = SRMS_MapPool.GetMaps()
	local map = nil
	repeat
		map = table.Random(maps)
	until map ~= currentMap

	return map
end
