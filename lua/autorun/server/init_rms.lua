include("server/srms/configuration.lua")
SRMS_Configuration.loadConfig()

include("server/srms/logger.lua")
SRMS_Logger.log("Loading random-map-selector on server", SRMS_Logger.SEVERITY.INFO)
SRMS_Logger.logTable("Configuration before loading gamemode:", SRMS_Configuration.get(), 4)

local allowedGamemodes = SRMS_Configuration.getValue("gamemodes")
local allowed = allowedGamemodes == false or table.HasValue(allowedGamemodes, engine.ActiveGamemode())

if allowed then
	include("server/srms/init.lua")
else
	SRMS_Logger.log(
		"Disable random map selector, since the gamemode is not allowed to use it.",
		SRMS_Logger.SEVERITY.WARNING
	)
end
