TeachManager = BaseClass("TeachManager")

local _tInsert = table.insert
local _tRemove = table.remove
local _tSort = table.sort

local DataTeachMain = Config.DataTeachMain.Find
function TeachManager:__init(fight)
	self.fight = fight
	self.teachCtrl = mod.TeachCtrl
	self.conditionToTeachId = {}

	self.showTeachTipList = {}
	self.showTeachImgPnlList = {}
	self.showState = {}

	-- 奖励记录
    self.rewardCacheData = {}
	self:AddConditionListener()
end

-- 添加条件监听
function TeachManager:AddConditionListener()
	for id, data in pairs(DataTeachMain) do
		local conditionId = data.condition_id
		if conditionId ~= 0 then
			self.conditionToTeachId[conditionId] = self.conditionToTeachId[conditionId] or {}
			self.conditionToTeachId[conditionId][id] = true
			self.fight.conditionManager:AddListener(conditionId, self:ToFunc("OnConditionSuc"))
		end
	end
end

function TeachManager:OnConditionSuc(conditionId)
	local idMap = self.conditionToTeachId[conditionId]
	if not idMap or not next(idMap) then return end

	for id, _ in pairs(idMap) do
		if self.teachCtrl:CheckAddTeachRecord(id) then
			self:AddTeachShowQueue(id)
			-- 条件触发添加后端记录
			self:AddTeachRecord(id)
		end
	end
	self.conditionToTeachId[conditionId] = nil
	self:CheckShowTeachInfo()
end

function TeachManager:BehaviorTriggerTeach(teachId, callback)
	self:AddTeachRecord(teachId)
	self:AddTeachShowQueue(teachId, callback)
end

function TeachManager:AddTeachShowQueue(teachId, callback)
	-- 这里的队列是弱和强分开
	local cfg = TeachConfig.GetTeachTypeIdCfg(teachId)

	if cfg.show_type == TeachConfig.ShowType.ShowImgPanel then
		_tInsert(self.showTeachImgPnlList, {teachId, callback})
	elseif cfg.show_type == TeachConfig.ShowType.ShowTip then
		_tInsert(self.showTeachTipList, {teachId, callback})
	end

	self:CheckShowTeachInfo()
end

function TeachManager:CheckShowTeachInfo()

	if not self.showState[TeachConfig.ShowType.ShowTip] then
		local showData = self.showTeachTipList[1]
		if showData then
			self.showState[TeachConfig.ShowType.ShowTip] = true
			_tRemove(self.showTeachTipList, 1)
			self:TriggerTeach(showData)
		end
	end

	if not self.showState[TeachConfig.ShowType.ShowImgPanel] then
		local showData = self.showTeachImgPnlList[1]
		if showData then
			self.showState[TeachConfig.ShowType.ShowImgPanel] = true
			_tRemove(self.showTeachImgPnlList, 1)
			self:TriggerTeach(showData)
		end
	end
end

function TeachManager:CloseTeachShowInfo(showType)
	self.showState[showType] = false
	self:CheckShowTeachInfo()
end

function TeachManager:TriggerTeach(showData)
	local teachId = showData[1]
	local callBack = showData[2]

	local teachTypeIdCfg = TeachConfig.GetTeachTypeIdCfg(teachId)
	local showType = teachTypeIdCfg.show_type

	if showType == TeachConfig.ShowType.ShowImgPanel then
		EventMgr.Instance:Fire(EventName.AddSystemContent, GuideImageTipPanel, {args = {teachId, callBack}})
	elseif showType == TeachConfig.ShowType.ShowTip then
		-- PanelManager.Instance:OpenPanel(TeachTipPanel, {teachId, callBack})
		EventMgr.Instance:Fire(EventName.TriggerTeachTip, teachId, callBack)
	end
end

function TeachManager:CheckSaveTeachId(teachId)
	local teachTypeCfg = TeachConfig.GetTeachTypeIdCfg(teachId)
	if not teachTypeCfg then return end
	if not teachTypeCfg.is_svae then return end
	self.teachCtrl:SaveTeachId(teachId)
end

function TeachManager:GetTeachDataByTag(teachTag)
	local teachData = self.teachCtrl:GetAllTeachData()
	if teachTag == TeachConfig.AllTagIdx then
		-- 在全部教学标签中需要额外排序一下，分为最近解锁和普通
		local newData, defData = self:GetAllTagTeachData(teachData)
		return newData, defData
	end
	teachTag = teachTag - 1
	local map = {}
	for _, data in ipairs(teachData) do
		local teachId = data.teachId
		local cfg = TeachConfig.GetTeachTypeIdCfg(teachId)
		if cfg and cfg.teach_tag == teachTag then
			_tInsert(map, data)
		end
	end

	return map
end

function TeachManager:GetAllTagTeachData(AllData)
	local newData = {}
	local defData = {}

	for _, data in pairs(AllData) do
		local teachId = data.teachId
		local state = data.state
		
		local isRecently = self.teachCtrl:CheckRecentlyTeach(teachId)
		if isRecently or state <= TeachConfig.TeachStateType.def then
			_tInsert(newData, data)
		else
			_tInsert(defData, data)
		end
	end

	_tSort(newData, function (a, b)
        if a.state == b.state then
            if a.sortVal == b.sortVal then
                return a.teachId < b.teachId
            end
            return a.sortVal > b.sortVal
        end
        return a.state < b.state
    end)

	return newData, defData
end

-- 检查红点
function TeachManager:CheckShowRedByTeachId(teachId)
	local teachData = self.teachCtrl:GetTeachData(teachId)
	if not teachData then return end
	return teachData.state <= TeachConfig.TeachStateType.def
end

-- 全量检查
function TeachManager:CheckShowTeachRed()
	return self.teachCtrl:CheckCanGetReward()
end

function TeachManager:AddTeachRecord(teachId)
	if not self.teachCtrl:CheckAddTeachRecord(teachId) then
		return
	end
	self.teachCtrl:AddTeachCacheData(teachId)
	mod.TeachFacade:SendMsg("teach_add", teachId)
end

function TeachManager:GetTeachLookReward(teachId)
	if not self.teachCtrl:checkGetTeachReward(teachId) then
		return
	end

    mod.TeachFacade:SendMsg("teach_reward", teachId)
end

function TeachManager:RetTeachLookReward(rewardData)
	local isOpenWin = WindowManager.Instance:IsOpenWindow("TeachWindow")
	if isOpenWin then
		for _, data in pairs(rewardData) do
			local itemId = data.template_id
			local cacheData = self.rewardCacheData[itemId]
			if not cacheData then
				self.rewardCacheData[itemId] = data
			else
				cacheData.count = cacheData.count + data.count
			end
		end
	else
		-- EventMgr.Instance:Fire(EventName.ItemRecv, rewardData)
	end
end

-- 在界面关闭的时候触发
function TeachManager:CheckShowTeachReward()
	if not next(self.rewardCacheData) then return end
	-- EventMgr.Instance:Fire(EventName.ItemRecv, self.rewardCacheData)
	self.rewardCacheData = {}
end

