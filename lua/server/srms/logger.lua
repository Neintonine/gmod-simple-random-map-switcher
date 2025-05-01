SRMS_Logger = {}
SRMS_Logger.SEVERITY = {
	ERROR = 1,
	WARNING = 2,
	INFO = 3,
	DEBUG = 4,
}

local function ShouldDisplay(severity)
	local verbosity = SRMS_Configuration.getValue("log_verbosity")

	return severity <= verbosity
end

local function SeverityPrefix(severity)
	if severity == SRMS_Logger.SEVERITY.ERROR then
		return "ERROR: "
	end

	if severity == SRMS_Logger.SEVERITY.WARNING then
		return "WARNING: "
	end

	if severity == SRMS_Logger.SEVERITY.INFO then
		return "INFO: "
	end

	if severity == SRMS_Logger.SEVERITY.DEBUG then
		return "DEBUG: "
	end

	return ""
end

function SRMS_Logger.log(message, severity)
	if not ShouldDisplay(severity) then
		return
	end

	message = SeverityPrefix(severity) .. message

	if severity <= SRMS_Logger.SEVERITY.ERROR then
		error(message)
		return
	end

	print(message)
end

function SRMS_Logger.logTable(message, table, severity)
	if not ShouldDisplay(severity) then
		return
	end

	SRMS_Logger.log(message, severity)

	PrintTable(table)
end
