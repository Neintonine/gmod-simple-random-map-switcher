include("server/srms/map_pool.lua")
include("server/srms/map_loader.lua")
include("server/srms/commands.lua")

SRMS_Logger.log("Load random method: " .. SRMS_Configuration.getValue("random_method"), SRMS_Logger.SEVERITY.DEBUG)
include("server/srms/random_methods/" .. SRMS_Configuration.getValue("random_method") .. ".lua")

if SRMS_Configuration.getValue("override_next_map") then
	include("server/srms/next_map_override.lua")
end

if SRMS_Configuration.getValue("force_map") then
	include("server/srms/force_map.lua")
end

SRMS_Logger.logTable("Found Maps:", SRMS_MapPool.GetMaps(), SRMS_Logger.SEVERITY.DEBUG)
SRMS_Logger.logTable("Configuration after loading gamemode:", SRMS_Configuration.get(), 4)
