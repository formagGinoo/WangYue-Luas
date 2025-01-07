Print = Print or {}

local color = "<color=#FF2F00FF>"
local UnityLog = Debug.Log
local UnityLogError = Debug.LogError
function Log(...)
   -- if not IS_DEBUG then return end
    --UnityLog(table.concat({...}, ",").."\r\n"..debug.traceback())
    UnityLog(table.concat({...}, ","))
end

function Logf(log,...)
  --  if not IS_DEBUG then return end
    log = string.format(log,...)
	--UnityLog(log.."\r\n"..debug.traceback())
	UnityLog(log)
end

function LogColor(...)
    --if not IS_DEBUG then return end
	UnityLog(color..table.concat({...}, ",").."</color>\r\n"..debug.traceback())
end

function LogColorf(log,...)
    --if not IS_DEBUG then return end
    --log = string.format(log,...)
	UnityLog(color..log.."</color>\r\n"..debug.traceback())
end

function LogError(...)
	UnityLogError(table.concat({...}, ",").."\r\n"..debug.traceback())
end

function LogErrorf(log,...)
    log = string.format(log,...)
	UnityLogError(log.."\r\n"..debug.traceback())
end

function LogTable(tableName,tableData)
   -- if not IS_DEBUG then return end
    Print.PrintTable(tableName,tableData)
end

function LogInfo(...)
	UnityLog(table.concat({...}, ",").."\r\n"..debug.traceback())
end


function LogInfof(log,...)
    log = string.format(log,...)
	UnityLog(log.."\r\n"..debug.traceback())
end


function Print.PrintTable(tableName,...)
    local args = {...}
    for k,arg in ipairs(args) do
        if type(arg) == 'table'
            or type(arg) == 'boolean'
            or type(arg) == 'function'
            or type(arg) == 'userdata' then
            args[k] = Print.ToString(arg)
        end
    end

    args[#args+1] = "nil"
    args[#args+1] = "nil"
    args[#args+1] = "nil"
    Log(tableName..":"..table.unpack(args))
end

function Print.ToString(value, indent, vmap)
    local str = ''
    indent = indent or ''
    vmap = vmap or {}

    --µÝ¹é½áÊøÌõ¼þ
    if (type(value) ~= 'table') then
        if (type(value) == 'string') then
            --×Ö·û´®
            str = string.format('"%s"', value)
        else
            --ÕûÊý
            str = tostring(value)
        end
    else
        if type(vmap) == 'table' then
            if vmap[value] then return '('..tostring(value)..')' end
            vmap[value] = true
        end

        local auxTable = {}     --±£´æÔª±íKEY(·ÇÕûÊý)
        local iauxTable = {}    --±£´æÔª±ívalue
        local iiauxTable = {}   --±£´æÊý×é(keyÎª0)
		for k, v in pairs(value) do
			if type(k) == 'number' then
				if k == 0 then
					table.insert(iiauxTable, k)
				else
					table.insert(iauxTable, k)
				end
			elseif type(k) ~= 'table' then
				table.insert(auxTable, k)
			end
		end
        --table.sort(iauxTable)

        str = str..'{\n'
        local separator = ""
        local entry = "\n"
        local barray = true
        local kk,vv
		for k, v in pairs(iauxTable) do
			if k == v and barray then
				entry = Print.ToString(value[v], indent..'  \t', vmap)
				str = str..separator..indent..'  \t'..entry
				separator = ", \n"
			else
				barray = false
				table.insert(iiauxTable, v)
			end
		end
        table.sort(iiauxTable)
		
		for i, fieldName in pairs(iiauxTable) do
			kk = tostring(fieldName)
			if type(fieldName) == "number" then
				kk = '['..kk.."]"
			end
			entry = kk .. " = " .. Print.ToString(value[fieldName],indent..'  \t',vmap)

			str = str..separator..indent..'  \t'..entry
			separator = ", \n"
		end

        table.sort(auxTable)
		for i, fieldName in pairs(auxTable) do
			kk = tostring(fieldName)
			if type(fieldName) == "number" then
				kk = '['..kk.."]"
			end
			vv = value[fieldName]
			entry = kk .. " = " .. Print.ToString(value[fieldName],indent..'  \t',vmap)

			str = str..separator..indent..'  \t'..entry
			separator = ", \n"
		end


        str = str..'\n'..indent..'}'
    end

    return str
end
