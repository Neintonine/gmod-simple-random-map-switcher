concommand.Add("srms_getnextmap", function()
	print("Next map: " .. SRMS_MapLoader.GetNextMap())
end)
concommand.Add("srms_loadnextmap", function()
	SRMS_MapLoader.LoadNextMap(true)
end)
concommand.Add("srms_skipnextmap", function()
	SRMS_MapLoader.ForgetNextMap()
	print("Next map: " .. SRMS_MapLoader.GetNextMap())
end)
concommand.Add("srms_resetbag", function()
	if not file.IsDir("srms", "DATA") then
		file.CreateDir("srms")
	end

	file.Write("srms/bag.json", util.TableToJSON({}))
end)
