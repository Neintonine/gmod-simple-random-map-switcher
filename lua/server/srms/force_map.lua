if SRMS_MapPool.IsCurrentMapInPool() then
	return
end

timer.Simple(0, SRMS_MapLoader.LoadNextMap)
