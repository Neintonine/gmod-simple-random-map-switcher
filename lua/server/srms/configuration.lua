SRMS_Configuration = {}

local SERVER_DEFAULT_CONFIG = {
	namespace = "GAME",
	path = "data_static/srms/srms-config.default.json",
}

local SERVER_USER_CONFIG = {
	namespace = "GAME",
	path = "cfg/srms-config.json",
}

local GAMEMODE_DEFAULT_CONFIG = {
	namespace = "GAMEMODE_DATA",
	path = "srms-config.default.json",
}

local GAMEMODE_USER_CONFIG = {
	namespace = "GAMEMODE",
	path = "cfg/srms-config.json",
}

local CONFIGURATION = nil

local function loadFile(configFile)
	local namespace = configFile.namespace
	local path = configFile.path

	if namespace == "GAMEMODE" then
		path = "gamemodes/" .. engine.ActiveGamemode() .. "/" .. path
		namespace = "GAME"
	end

	if namespace == "GAMEMODE_DATA" then
		path = "data_static/srms/gamemodes/" .. engine.ActiveGamemode() .. "/" .. path
		namespace = "GAME"
	end

	if not file.Exists(path, namespace) then
		print("Path '" .. path .. "' in namespace '" .. namespace .. "' not found.")
		return nil
	end

	local configData = file.Read(path, namespace)
	local data = util.JSONToTable(configData)
	return data
end

local function getDefaultConfig()
	local defaultConfig = loadFile(SERVER_DEFAULT_CONFIG)
	if defaultConfig == nil then
		print(
			"Could not load default configuration... Either something is wrong, or you have overwritten the default file - Using empty configuration..."
		)
		defaultConfig = {}
	end

	local gamemodeDefault = loadFile(GAMEMODE_DEFAULT_CONFIG)
	if gamemodeDefault ~= nil then
		defaultConfig = table.Merge(defaultConfig, gamemodeDefault)
	end

	return defaultConfig
end

function SRMS_Configuration.loadConfig()
	local config = getDefaultConfig()

	local serverConfig = loadFile(SERVER_USER_CONFIG)
	if serverConfig ~= nil then
		config = table.Merge(config, serverConfig)
	end

	local gamemodeConfig = loadFile(GAMEMODE_USER_CONFIG)
	if gamemodeConfig ~= nil then
		config = table.Merge(config, gamemodeConfig)
	end

	CONFIGURATION = config
end

function SRMS_Configuration.get()
	if CONFIGURATION == nil then
		return nil
	end

	return CONFIGURATION
end

function SRMS_Configuration.getValue(key)
	local config = SRMS_Configuration.get()
	return config[key]
end
