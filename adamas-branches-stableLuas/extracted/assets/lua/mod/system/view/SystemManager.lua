SystemManager = BaseClass("SystemManager")
local DataSystemOpen = Config.DataSystemOpen.data_system_open

local _tInsert = table.insert
local _tRemove = table.remove
local _tSort = table.sort

SystemManager.TeachSystemId = 801

function SystemManager:__init(fight)
	self.fight = fight
	self.systemCtrl = mod.SystemCtrl
	self.conditionToSysytemId = {}
	self.showSystemOpenPnlList = {}
end

function SystemManager:StartFight()
	self:AddConditionListener()
end

function SystemManager:CheckConditionSuc(idMap)
    -- 看看是不是有新加的漏网之鱼
    local conditionMgr = Fight.Instance.conditionManager
    for id, _ in pairs(idMap) do
        local cfg = DataSystemOpen[id]
        local condition = cfg.condition
        if condition ~= 0 and conditionMgr:CheckConditionByConfig(condition) then
			idMap[id] = nil
            mod.SystemFacade:SendMsg("sys_open_add", id)
        end
    end
end

-- 添加条件监听
function SystemManager:AddConditionListener()
	local idMap = mod.SystemCtrl:GetNoSucSystemIdMap()
	self:CheckConditionSuc(idMap)
	for id, _ in pairs(idMap) do
		local data = DataSystemOpen[id]
		local conditionId = data.condition
		if conditionId ~= 0 then
			self.conditionToSysytemId[conditionId] = self.conditionToSysytemId[conditionId] or {}
			self.conditionToSysytemId[conditionId][id] = true
			self.fight.conditionManager:AddListener(conditionId, self:ToFunc("OnConditionSuc"))
		end
	end
end

function SystemManager:OnConditionSuc(conditionId)
	local idMap = self.conditionToSysytemId[conditionId]
	if not idMap or not next(idMap) then return end
	for id, _ in pairs(idMap) do
		local data = DataSystemOpen[id]
		_tInsert(self.showSystemOpenPnlList, {id = id, sortVal = data.notice_priority})
	end
	self.conditionToSysytemId[conditionId] = nil

	_tSort(self.showSystemOpenPnlList, function (a, b)
		if a.sortVal == b.sortVal then
			return a.id < b.id
		end
		return a.sortVal > b.sortVal
	end)
	EventMgr.Instance:Fire(EventName.SystemOpen)
end

function SystemManager:CheckShowSystemOpenPnl()
	local id = self:GetShowPnlSystemId()
	if not id then return end
	-- 展示界面
	local setting = {
		args = {systemId = id},
		isWindow = true,
		delayTime = 0.5
	}

	EventMgr.Instance:Fire(EventName.AddFightContent, SystemOpenWindow, setting)
	return true
end

function SystemManager:GMSetData(data)
	self.showSystemOpenPnlList = data
	self:CheckShowSystemOpenPnl()
end

function SystemManager:GetShowPnlSystemId()
	if #self.showSystemOpenPnlList <= 0 then return end
	local removeKey = {}
	local selectId
	for i = 1, #self.showSystemOpenPnlList do
		local id = self.showSystemOpenPnlList[i].id
		mod.SystemFacade:SendMsg("sys_open_add", id)
		local cfg = DataSystemOpen[id]
		removeKey[id] = true
		if cfg.is_notice then
			selectId = id
			break
		end
	end

	for i = #self.showSystemOpenPnlList, 1, -1 do
		local id = self.showSystemOpenPnlList[i].id
		if removeKey[id] then
			_tRemove(self.showSystemOpenPnlList, i)
		end
	end

	return selectId
end

function SystemManager:CheckShowSystemPnlLen()
	return #self.showSystemOpenPnlList
end

function SystemManager:CheckSystemOpen(systemId)
	if self.systemCtrl:IsShowSystemOpenPnl(systemId) then
		return true
	end

	local cfg = DataSystemOpen[systemId]
	if cfg.conditionId == 0 then
		return true
	end
	return false
end