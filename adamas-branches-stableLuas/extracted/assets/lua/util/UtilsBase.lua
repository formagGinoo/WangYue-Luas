UtilsBase = UtilsBase or {}

UtilsBase.Time = os.time()

-- 复制table
function UtilsBase.copytab(st, tab)
    if st == nil then return nil end
    if type(st) ~= "table" then
        return st
    end
    tab = tab or {}
    for k, v in pairs(st or {}) do
        if type(v) ~= "table" then
            tab[k] = v
        else
            tab[k] = UtilsBase.copytab(v)
        end
    end
    return tab
end

-- 覆盖table属性 把tab2的所有内容赋值给tab1
function UtilsBase.covertab(tab1, tab2)
    for k, v in pairs(tab2) do
        tab1[k] = v
    end
    return tab1
end

-- 检查table内容是否相同(正反调用两次，确保两个table相同)
function UtilsBase.sametab(tab1, tab2)
    if UtilsBase.checktab(tab1, tab2) and UtilsBase.checktab(tab2, tab1) then
        return true
    end
    return false
end

-- 检查table内容是否相同(如果tab2比tab1大则检查不出来)
function UtilsBase.checktab(tab1, tab2)
    if tab1 ~= nil and tab2 == nil then return false end

    for k, v in pairs(tab1 or {}) do
        if type(v) ~= "table" then
            if tab2[k] ~= v then return false end
        elseif tab2[k] ~= nil then
            if not UtilsBase.sametab(v, tab2[k]) then return false end
        else
            return false
        end
    end
    return true
end

-- 代替lua的sort，以避免出现不稳定排序问题
function UtilsBase.BubbleSort(templist, sortFuc)
    local list = {}
    for k, v in pairs(templist) do
        table.insert(list, v)
    end
    local tempVal = true
    for m=#list-1,1,-1 do
        tempVal = true
        for i=#list-1,1,-1 do
            local a = list[i]
            local b = list[i+1]
            local sortBoo = sortFuc(a, b)
            if sortBoo == false then
                list[i], list[i+1] = list[i+1], list[i]
                tempVal = false
            end
        end
        if tempVal then break end
    end
    return list
end

function UtilsBase.Platform()
    return Application.platform
end

function UtilsBase.IsIPhonePlayer()
    return Application.platform == RuntimePlatform.IPhonePlayer
end

-- 序列化
-- 序列化时只需传入obj的值，其它保持nil
function UtilsBase.serialize(obj, name, newline, depth)
    local space = newline and "    " or ""
    newline = newline and true
    depth = depth or 0

    local tmp = string.rep(space, depth)

    if name then
        if type(name) == "number" then
            tmp = tmp .. "[" .. name .. "] = "
        else
            tmp = tmp .. name .. " = "
        end
    end

    if type(obj) == "table" then
        tmp = tmp .. "{" .. (newline and "\n" or "")

        for k, v in pairs(obj) do
            tmp =  tmp .. UtilsBase.serialize(v, k, newline, depth + 1) .. "," .. (newline and "\n" or "")
        end

        tmp = tmp .. string.rep(space, depth) .. "}"
    elseif type(obj) == "number" then
        tmp = tmp .. tostring(obj)
    elseif type(obj) == "string" then
        tmp = tmp .. string.format("%q", obj)
    elseif type(obj) == "boolean" then
        tmp = tmp .. (obj and "true" or "false")
    elseif type(obj) == "function" then
        -- tmp = tmp .. tostring(obj)
        tmp = tmp .. "【function】"
    elseif type(obj) == "userdata" then
        tmp = tmp .. "【userdata】"
    else
        tmp = tmp .. "\"[" .. string.format("%s", tostring(obj)) .. "]\""
    end

    return tmp
end

-- 反序列化
function UtilsBase.unserialize(str)
    return assert(loadstring("local tmp = " .. str .. " return tmp"))()
end

-- 显示指定对象的结构
function UtilsBase.dump(obj, name)
    if IS_DEBUG then
        print(UtilsBase.serialize(obj, name, true, 0))
    end
end

-- 显示指定对象的matetable结构
function UtilsBase.dump_mt(obj, name)
    if IS_DEBUG then
        UtilsBase.dump(getmetatable(obj), name)
    end
end

-- 获取子节点路径
function UtilsBase.GetChildPath(transform, nodeName)
    local tcc = transform.childCount - 1
    local rvl
    for i = 0, tcc do
        local it = transform.transform:GetChild(i)
        if it.childCount > 0 then
            if it.name == nodeName then
                return it.name
            end
            rvl = UtilsBase.GetChildPath(it, nodeName)
            if rvl ~= "" then
                return it.name.."/"..rvl
            end
        elseif it.name == nodeName then
                return it.name
        end
    end
    return ""
end

-- 判断值是否为null、nil
function UtilsBase.IsNull(value)
    return (value == nil or (type(value) == "userdata" and value:Equals(Null)))
end

function UtilsBase.DefaultHoldTime()
    if UtilsBase.platform == nil then
        UtilsBase.platform = Application.platform
    end
    if UtilsBase.platform == RuntimePlatform.IPhonePlayer then
        return 90
    else
        return 180
    end
end

function UtilsBase.LoadAssetBundleFromFile(path)
    local finalPath = AssetMgrProxy.ToAssetPath(path)
    finalPath = AssetMgrProxy.ConvertUrlToPath(finalPath)
    return CustomUnityUtils.LoadAssetBundleFromFile(finalPath)
end

function UtilsBase.WorldToUIPoint(camera,point)
    local worldScreenPos = camera:WorldToScreenPoint(point)
    local _,pos = RectTransformUtility.ScreenPointToLocalPointInRectangle(UIDefine.canvasRoot, Vector2(worldScreenPos.x, worldScreenPos.y), ctx.UICamera)

    return Vector3(pos.x, pos.y, worldScreenPos.z)
end

function UtilsBase.TableList(tableMap)
    local list = {}
    for k, v in pairs(tableMap) do
        table.insert(list, v)
    end

    return list
end

function UtilsBase.WorldToUIPointBase(inX, inY, inZ)
    local vec3 = Vec3.New(0,0,0)
    vec3.x, vec3.y, vec3.z = CustomUnityUtils.WorldToScreenPoint(inX, inY, inZ)
    vec3.x, vec3.y = CustomUnityUtils.DefaultScreenPointToLocalPointInRectangle(vec3.x, vec3.y)
    return vec3
end

function UtilsBase.WorldToViewportPoint(inX, inY, inZ)
    local x, y, z = CustomUnityUtils.WorldToViewportPoint(inX, inY, inZ)
    return Vec3.New(x,y,z)
end

function UtilsBase.ViewportToWorldPoint(inX, inY, inZ)
    local x, y, z = CustomUnityUtils.ViewportToWorldPoint(inX, inY, inZ)
    return Vec3.New(x,y,z)
end

function UtilsBase.GetLuaPosition(transform)
    local x, y, z = CustomUnityUtils.GetPosition(transform)
    local v3 = Vec3.New(x, y, z)
    return v3
end

function UtilsBase.GetLuaRotation(transform)
    local x, y, z, w = CustomUnityUtils.GetRotation(transform)
    local quat = Quat.New(x, y, z, w)
    return quat
end

function UtilsBase.IsPosContain(pos1, pos2, radiusSquare)
	local x,y,z = pos2.x, pos2.y, pos2.z
	local radiusSquare2 = (pos1.x - x) * (pos1.x - x) + 
	(pos1.y - y) * (pos1.y - y) + (pos1.z - z) * (pos1.z - z)
	return radiusSquare2 <= radiusSquare
end

function UtilsBase.GetPosRadius(pos1, pos2)
    local x,y,z = pos2.x, pos2.y, pos2.z
	local radiusSquare2 = (pos1.x - x) * (pos1.x - x) + 
	(pos1.y - y) * (pos1.y - y) + (pos1.z - z) * (pos1.z - z)
    return radiusSquare2
end

---comment 拼接多主键,不建议在update中使用
--- @param ... number 主键1,左移位数, 主键2,左移位数 ...
function UtilsBase.GetPrimaryKeys(...)
    local key, args = 0, {...}
    for i = 1, #args, 2 do
        key = key | args[i] << args[i + 1]
    end
	return key
end


--- @param key1 number 主键1
--- @param key2 number 主键2
--- @param bitOffset any 主键1左移位数
function UtilsBase.GetDoubleKeys(key1, key2, bitOffset)
    if not key1 or not key2 then
        return
    end

    bitOffset = bitOffset or 32
    return key1 << bitOffset | key2
end
---comment 拼接多字符串主键
function UtilsBase.GetStringKeys(...)
    local args = {...}
	local key = args[1]
    for i = 2, #args, 1 do
        key = key .."_".. args[i]
    end
	return key
end

-- 含中文字符串长度
function UtilsBase.utf8len(input)
    local len = 0
    local pos = 1
    local byte = string.byte
    while pos <= #input do
        local c = byte(input, pos)
        len = len + 1
        if c > 0 and c <= 127 then
            pos = pos + 1
        elseif c >= 194 and c <= 223 then
            pos = pos + 2
        elseif c >= 224 and c <= 239 then
            pos = pos + 3
        elseif c >= 240 and c <= 244 then
            pos = pos + 4
        end
    end
    return len
end

-- 找到下一个可以整除的数字
function UtilsBase.ExpandToMultiple(A, B)
    local quotient = A / B -- A 除以 B 的商
    if A % B == 0 then
        return A
    else
        return (math.floor(quotient) + 1) * B
    end
end

function UtilsBase.TryCatch(func, ...)
    local call = function(...) func(...) end
    local status, err = xpcall(call, function(errinfo) 
        LogError("捕获异常:" .. tostring(errinfo)); 
        LogError(debug.traceback())
    end, ...)

    return status
end