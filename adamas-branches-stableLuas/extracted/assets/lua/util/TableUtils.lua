TableUtils = BaseClass("TableUtils")

local _insert = table.insert

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

--这个检查很耗时，只能在editor中使用
function TableUtils.ValueRepeatError(t,name)
	if ctx.Editor then
		local proxy = t or {}
		local mt = {
			__newindex = function (t,k,v)
				for k1, v1 in pairs(t) do
					if v == v1 then
						error(string.format("value[%s]重复key[%s]",v,k),2)
						return
					end
				end
				rawset(t,k,v)
			end
		}
		setmetatable(proxy,mt)
		return proxy
	else
		return t
	end
end

--模拟C#枚举自增
function TableUtils.Enum(t,name)
	local proxy = t or {}
	proxy.count = 0
	local mt = {
		__newindex = function (t,k,v)
			t.count = t.count + 1
			local value = t.count
			rawset(t,k,value)
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

function TableUtils.InsertTable(table, table2)
    for k, v in ipairs(table2) do
        _insert(table, v)
    end
end