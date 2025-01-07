TableUtils = BaseClass("TableUtils")

function TableUtils.ReadOnly (t,name)
    local proxy = {}
    local mt = {
     __index = t,
     __newindex = function (t,k,v)
        error(string.format("无法(修改、新增)%s字段[%s]",name or "Table",k) ,2)
     end
    }
    setmetatable(proxy,mt)
    return proxy
end

function TableUtils.ReadUpdateOnly (t,name)
    local proxy = t or {}
    local mt = {
     __newindex = function (t,k,v)
        error(string.format("无法(新增)%s字段[%s]",name or "Table",k),2)
     end
    }
    setmetatable(proxy,mt)
    return proxy
end

function TableUtils.CopyTable(st)
    if st == nil then return nil end
    if type(st) ~= "table" then
        return st
    end
    local tab = {}
    for k, v in pairs(st or {}) do
        if type(v) ~= "table" then
            tab[k] = v
        else
            tab[k] = UtilsBase.copytab(v)
        end
    end
    return tab
end

function TableUtils.NewTable()
    return {}
end

function TableUtils.ClearTable(table)
    if not table or not next(table) then
        return
    end

    for key, _ in pairs(table) do
        table[key] = nil
    end
end

function TableUtils.GetParam(table, default, ...)
    if not table then
        return default
    end

    local args = {...}
    local result = table
    for k, v in pairs(args) do
        if result[v] then
            result = result[v]
        else
            return default
        end
    end

    return result
end

function TableUtils.GetTabelLen(table)
    local num = 0
    for _, _ in pairs(table) do
        num = num + 1
    end
    return num
end

function TableUtils.ContainValue(table, value)
	for _ ,v in pairs(table) do
		if v == value then
			return true
		end
	end
	
	return false
end