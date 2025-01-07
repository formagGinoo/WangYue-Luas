TeachCtrl = BaseClass("TeachCtrl",Controller)

local _tinsert = table.insert
local _tsort = table.sort

function TeachCtrl:__init()
    self.windowManager = WindowManager.Instance

    self.teachMap = {}
    self.teachRecordMap = {}

    self.recentlyRecordMap = {}
    self.getRewardMap = {}

	self.addTeachCacheData = {}
end

-- 初始数据
function TeachCtrl:InitTeachData()
    
end

function TeachCtrl:CheckRefreshTeachData(data)
    local id = data.key
    if not self.teachRecordMap[id] then return end
    return true
end

function TeachCtrl:RecvTeachData(data)
    local isAdd = false
	-- 注意在领奖的时候这个value是不会变化的，所以通过RecvTeachReward去设置
    for _, info in ipairs(data) do
        local id = info.key
        if self:CheckRefreshTeachData(info) then
            goto continue
        end

        local cfg = TeachConfig.GetTeachTypeIdCfg(id)
        if cfg then
            local insertData = {
                teachId = id,
                state = info.value,
                sortVal = cfg.protity
            }
            -- 这里记录2个是为了方便索引和使用
            _tinsert(self.teachMap, insertData)
            self.teachRecordMap[id] = insertData
            self.addTeachCacheData[id] = nil
            self:CheckGerRewardMap(id)

            if self.isInitOk then
                self:CheckAddRecentlyTeacher(id)
            end

            isAdd = true
        end

        ::continue::
    end

    self:SortTeachData()
    if isAdd then
	    EventMgr.Instance:Fire(EventName.AddTeach)
	    EventMgr.Instance:Fire(EventName.UpdateSystemMenuRed, SystemConfig.SystemOpenId.Teach)
    end

    self.isInitOk = true
end

function TeachCtrl:AddTeachCacheData(teachId)
    self.addTeachCacheData[teachId] = true
end

function TeachCtrl:SortTeachData()
    _tsort(self.teachMap, function (a, b)
        if a.state == b.state then
            if a.sortVal == b.sortVal then
                return a.teachId < b.teachId
            end
            return a.sortVal > b.sortVal
        end
        return a.state < b.state
    end)
end

function TeachCtrl:RecvTeachReward(id)
    if self.teachRecordMap[id] then
        self.teachRecordMap[id].state = TeachConfig.TeachStateType.receive
    end

    for _, data in pairs(self.teachMap) do
        if data.teachId == id then
            data.state = TeachConfig.TeachStateType.receive
            break
        end
    end

    -- 任务奖励返回 刷新红点
    EventMgr.Instance:Fire(EventName.RetTeachLookReward, id)
    EventMgr.Instance:Fire(EventName.UpdateSystemMenuRed, SystemConfig.SystemOpenId.Teach)
end

function TeachCtrl:GetTeachData(teachId)
    return self.teachRecordMap[teachId]
end

function TeachCtrl:GetAllTeachData()
    return self.teachMap
end

function TeachCtrl:AddTeachRecentlyRecord(list)
    self.recentlyRecordMap = {}
    for _, id in pairs(list) do
        self.recentlyRecordMap[id] = true
    end
end

function TeachCtrl:CheckAddRecentlyTeacher(teachId)
    -- local tabLen = TableUtils.GetTabelLen(self.recentlyRecordMap)
    -- -- 固定4个
    -- if tabLen >= 4 then return end
    -- self.recentlyRecordMap[teachId] = true
end

function TeachCtrl:CheckRecentlyTeach(id)
    return self.recentlyRecordMap[id]
end

function TeachCtrl:CheckAddTeachRecord(teachId)
    local cfg = TeachConfig.GetTeachTypeIdCfg(teachId)
    -- 配置了不收录
    if not cfg.is_svae then return end
    -- 是否已经有了记录
    return not self.teachRecordMap[teachId]
end

function TeachCtrl:checkGetTeachReward(teachId)
    local teachData = self.teachRecordMap[teachId]
    local isAdd = self.addTeachCacheData[teachId]
    -- 正在添加中，加入列表
    if isAdd then
        self.getRewardMap[teachId] = true
        return
    end
    if not teachData then return end
    if teachData.state >= TeachConfig.TeachStateType.receive then return end
    return true
end

function TeachCtrl:CheckGerRewardMap(teachId)
    if not self.getRewardMap[teachId] then return end
    self.getRewardMap[teachId] = nil
    Fight.Instance.teachManager:GetTeachLookReward(teachId)
end

function TeachCtrl:CheckCanGetReward()
	for _, data in pairs(self.teachMap) do
		if data.state <= TeachConfig.TeachStateType.def then
			return true
		end
	end
	return false
end
