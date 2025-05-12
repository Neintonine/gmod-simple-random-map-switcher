SRMS_Logger.log("Load override for next map...", 3)
timer.Simple(0, function()
	game.GetMapNext = SRMS_MapLoader.GetNextMap
	game.LoadNextMap = function()
		SRMS_MapLoader.LoadNextMap(true)
	end
end)
