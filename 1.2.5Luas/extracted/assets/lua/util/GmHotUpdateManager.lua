-- 热更
GmHotUpdateManager = BaseClass("GmHotUpdateManager")

function GmHotUpdateManager:__init()
    if GmHotUpdateManager.Instance then
        LogError("拒绝重复实例化单例" .. debug.force_traceback())
        return
    end
    GmHotUpdateManager.Instance = self

    self.excludeFiles = 
    {
        "base/common"
    }
end

function GmHotUpdateManager:__delete()
end

function GmHotUpdateManager:GetModelTree()
    self.modelTree = {}
    self.textCnt = 0
    self.localLuaFileList = {}
    local temp = {}
    local luaFile = {}
    local otherFile = {}
    local index = 0
    for path, v in pairs(package.loaded) do
        table.insert(temp, path)
        if self:CheckPath(path) == true then
            table.insert(luaFile,path)
        else
            table.insert(otherFile,path)
        end
    end
    table.sort(luaFile)
    for i,v in ipairs(luaFile) do
        if string.find(v, "/data_") ~= nil then
            self.localLuaFileList[v] = "data/lua/"..string.sub(v, 6)..".lua"
        elseif string.find(v, "fight_config") ~= nil then
            self.localLuaFileList[v] = "data/lua/"..string.sub(v, 6)..".lua"
        else
            -- if not self:IsExcludeFile(v) then
            --     self.localLuaFileList[v] = "lua/"..v..".lua"
            -- end
        end
    end

    for i,path in ipairs(temp) do
        self:InsertModel(self.modelTree, path)
    end
end

function GmHotUpdateManager:IsExcludeFile(file)
    for _,with in ipairs(self.excludeFiles) do
        local index = string.find(file,with)
        if index and index == 1 then
            return true
        end
    end
    return false
end

function GmHotUpdateManager:HotUpdate()
	Time.timeScale = 1
    print("-------热更开始------")
    IS_HOT_UPDATING = true
    if self.modelTree == nil then
        self:GetModelTree()
    end

    self:DoHotUpdate()

    self.modelTree = nil

	--HotUpdate.GetInstance():CheckFilesWitchNeedUpdate(self.localLuaFileList)
    --TimerManager.Add(200, function()
        --HotUpdate.GetInstance():CheckFilesWitchNeedUpdate(self.localLuaFileList)
    --end)
    print("-------热更结束------")
    -- TODO 临时代码
    mod.WorldMapCtrl:ClearPlayer()
    mod.HackingCtrl:OnEnterMap()
    MsgBoxManager.New()
end
local blckList = {
	"CurtainManager",
	"LuaTimerManager",
	"LoadPanelManager",
}
function GmHotUpdateManager:BlackListCheck(name)
	for k, v in pairs(blckList) do
		if string.find(name,v) then
			return true
		end
	end
	return false
end

function GmHotUpdateManager:DoHotUpdate()
	--for k,v in pairs(self.localLuaFileList) do
		--local oldModule = package.loaded[k]
		--package.loaded[k] = nil

		--xpcall(function() require(k) end, function(err)
				--LogError(string.format("热更文件%s失败[%s]", v,err))
			--end, k)
		--local newModule = package.ldwoaded[k]
	--end
	local path = ClzMapping["BehaviorFunctions"]
    if path then
	   package.loaded[path] = nil
	   require(path)
    end
  
	_G["BehaviorFunctions"] = nil
	local reloadList = {}
    local reloadDataList = {}
	for k, v in pairs(ClzMapping) do
		--local oldModule = _G[k]
		if (not self:BlackListCheck(v)) and (string.find(v,"mod/") or string.find(v,"data/"))  then
			if package.loaded[v] then
				package.loaded[v] = nil
				_G[k] = nil
                if string.find(v, "mod/") then
				    table.insert(reloadList, v)
                elseif string.find(v, "data/") then
                    table.insert(reloadDataList, v)
                end
				--require(v)
			end
		end
		
		--local newModule = _G[k]
	end
	clear_loaded_files()
	for k, v in pairs(reloadList) do
		require(v)
	end

    for k, v in pairs(reloadDataList) do
		require(v)
	end
	
	do return end
	--for k, v in pairs(ClzMapping) do
		--if k == "Behavior9001" then
			--local oldModule = _G[k]
			--package.loaded[v] = nil
			--require(v)
			--local newModule = _G[k]
			----self:UpdateTable(newModule, oldModule)
		--end
	--end
	--do return end
    local waiting = WaitForSeconds(0)
    if self.c1 ~= nil and coroutine.status(self.c1) ~= "dead" then
        LogError("上次热更还没结束稍等")
        return
    end
	Log("正在热更文件。。。")
    self.c1 = coroutine.create(function()
        local errnum = 0
        local index = 0
        for k,v in pairs(self.localLuaFileList) do
            index = index + 1
            package.loaded[k] = nil

            xpcall(function() require(k) end, function(err)
                errnum = errnum + 1
						LogError(string.format("热更文件%s失败[%s]", v,err))
            end, k)
            if index % 10 == 0 then
                Yield(waiting)
            end
        end

        -- for i,v in ipairs(list) do
        --     package.loaded[v] = nil
        --     xpcall(function() require(v) end, function(err)
        --         errnum = errnum + 1
		-- 				LogError(string.format("热更文件%s失败[%s]", v,err))
        --     end, v)
        --     if i%10 == 0 then
        --         Yield(waiting)
        --     end
        --     -- if i > 10 then
        --     --     LogError(string.format("快捷热更文件有%s个可能会卡死，自动中断操作， 请再次修改文件再次操作", #list))
        --     --     return
        --     -- end
        -- end
        IS_HOT_UPDATING = false
		Log(string.format("快捷热更文件有%s个，%s个失败", #list, errnum))
        self.c1 = nil
    end)
    coroutine.resume(self.c1)
end

function GmHotUpdateManager:CheckPath(path)
    if
        string.find(path,"mod/") ~= nil or
        string.find(path,"base/") ~= nil or
        string.find(path,"config/") ~= nil or
        string.find(path,"data/") ~= nil or
        string.find(path,"util/") ~= nil or
        string.find(path,"game_lua_start") ~= nil or
        string.find(path,"gm_cmd") ~= nil or
        string.find(path,"zlsx_debug") ~= nil
        then
        return true
    else
        return false
    end
end

function GmHotUpdateManager:InsertModel(thetable, path)
    local subname = string.match(path, "(.-)/")
    if subname then
        local subpath = string.gsub(path, subname.."/", "")
        if thetable[subname] == nil then
            thetable[subname] = {}
        end
        return self:InsertModel(thetable[subname], subpath)
    else
        table.insert(thetable, path)
    end
end

function GmHotUpdateManager:UpdateTable(new_table, old_table)
	assert("table" == type(new_table))
	assert("table" == type(old_table))

	-- Compare 2 tables, and update old table.
	for key, value in pairs(new_table) do
		local old_value = old_table[key]
		local type_value = type(value)
		if type_value == "function" then
			self:UpdateTable(value, old_value)
			old_table[key] = value
		elseif type_value == "table" then
			self:UpdateTable(value, old_value)
		end
	end

	-- Update metatable.
	local old_meta = debug.getmetatable(old_table)
	local new_meta = debug.getmetatable(new_table)
	if type(old_meta) == "table" and type(new_meta) == "table" then
		self:UpdateTable(new_meta, old_meta)
	end
end