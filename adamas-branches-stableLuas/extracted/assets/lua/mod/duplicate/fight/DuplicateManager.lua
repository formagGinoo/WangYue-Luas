DuplicateManager = BaseClass("DuplicateManager")

local _tInsert = table.insert
local _tRemove = table.remove
local _tSort = table.sort

function DuplicateManager:__init(fight)
    self.fight = fight
    self.duplicateCtrl = mod.DuplicateCtrl
    self.worldMapCtrl = mod.WorldMapCtrl

    self.duplicateList = {} --副本列表 保存副本systemId

    -- self.dupTimerOpen = false --副本耗时开关
    -- self.duplicateUseTime = 0 --副本耗时

    self.timerId = 0
    self.timers = {}
    self.systemDTimerId = 0
    self.dupUseTimerId = 0
end

function DuplicateManager:StartFight()
    self:AddDupUseTimer()
    EventMgr.Instance:AddListener(EventName.OnEntityBuffChange, self:ToFunc("EntityBuffChange"))
end

function DuplicateManager:Update()
    -- if self.dupTimerOpen then
    --     self.duplicateUseTime = self.duplicateUseTime + FightUtil.deltaTimeSecond
    -- end

    if not self.timers or not next(self.timers) or self.pauseAllTimer then
        return
    end

    for timerId, timer in pairs(self.timers) do
        if timer.isFinish or timer.isPause then
            goto continue
        end

        local isAcc = timer.timerType == FightEnum.DuplicateTimerType.Acc or timer.timerType == FightEnum.DuplicateTimerType.FightTargetUIAcc
        local tChange = isAcc and FightUtil.deltaTimeSecond or -FightUtil.deltaTimeSecond
        timer.time = timer.time + tChange

        local isFinish = isAcc and (timer.oTime and timer.time >= timer.oTime)
        if not isFinish then
            isFinish = not isAcc and timer.time <= 0
        end

        if isFinish then
            Fight.Instance.entityManager:CallBehaviorFun("TimerCountFinish", timerId)
            timer.isFinish = true
            self:RemoveTimer(timerId)
            goto continue
        end

        if timer.timerType ~= FightEnum.DuplicateTimerType.Acc and timer.timerType ~= FightEnum.DuplicateTimerType.CountDown then
            EventMgr.Instance:Fire(EventName.SyncDuplicateCountDown, timerId)
        end

        ::continue::
    end
end

-- 添加副本累计计时
function DuplicateManager:AddDupUseTimer(duplicateId)
    if not duplicateId then
        duplicateId = mod.DuplicateCtrl:GetSystemDuplicateId()
    end

    if not duplicateId then
        return --说明不在副本，不需要计时
    end

    local dupCfg = DuplicateConfig.GetSystemDuplicateConfigById(duplicateId)
    if not dupCfg then
        LogError("系统副本找不到 id = "..duplicateId)
        return
    end

    self.dupUseTimerId = self:AddTimer(nil, FightEnum.DuplicateTimerType.Acc)
    return self.dupUseTimerId
end

-- 好像只有系统副本才有倒计时
function DuplicateManager:AddTimerByDuplicateID(duplicateId)
    if not duplicateId then
        duplicateId = mod.DuplicateCtrl:GetSystemDuplicateId()
    end

    local dupCfg = DuplicateConfig.GetSystemDuplicateConfigById(duplicateId)
    if not dupCfg then
        LogError("系统副本找不到 id = "..duplicateId)
        return
    end

    self.systemDTimerId = self:AddTimer(dupCfg.time, FightEnum.DuplicateTimerType.FightTargetUI)
    return self.systemDTimerId
end

-- 加倒计时
function DuplicateManager:AddTimer(time, timerType)
    local isAcc = timerType == FightEnum.DuplicateTimerType.Acc or timerType == FightEnum.DuplicateTimerType.FightTargetUIAcc
    if not time and not isAcc then
        return
    end

    self.timerId = self.timerId + 1
    self.timers[self.timerId] = { time = not isAcc and time or 0, oTime = time, timerType = timerType }
    if self:CheckTimerHaveUI(self.timerId) then
        EventMgr.Instance:Fire(EventName.OpenDuplicateCountDown, self.timerId)
    end

    return self.timerId
end

-- 重置倒计时
function DuplicateManager:ResetTimer(timerId)
    if not self.timers or not self.timers[timerId] then
        return
    end

    local timerType = self.timers[timerId].timerType
    local isAcc = timerType == FightEnum.DuplicateTimerType.Acc or timerType == FightEnum.DuplicateTimerType.FightTargetUIAcc
    self.timers[timerId].time = not isAcc and self.timers[timerId].oTime or 0

    if self:CheckTimerHaveUI(timerId) then
        EventMgr.Instance:Fire(EventName.SyncDuplicateCountDown, timerId)
    end
end

-- 移除倒计时
function DuplicateManager:RemoveTimer(timerId)
    if not self.timers or not self.timers[timerId] then
        return
    end

    if self:CheckTimerHaveUI(timerId) then
        EventMgr.Instance:Fire(EventName.StopDuplicateCountDown, timerId)
    end

    if self.systemDTimerId == timerId then
        self.systemDTimerId = 0
    end

    self.timers[timerId] = nil
end

-- 设置倒计时是否暂停
function DuplicateManager:SetTimerPauseState(timerId, state)
    if not self.timers or not self.timers[timerId] then
        return
    end

    self.timers[timerId].isPause = state
end

-- 计时添加时间
function DuplicateManager:AddTimerTime(timerId, time)
    if not self.timers or not self.timers[timerId] or self.timers[timerId].timerType == FightEnum.DuplicateTimerType.Acc then
        return
    end

    self.timers[timerId].time = self.timers[timerId].time + time
end

-- 返回计时
function DuplicateManager:ReturnTimerTime(timerId)
    if not self.timers or not self.timers[timerId] then
        return
    end

    return self.timers[timerId].time
end

function DuplicateManager:ResetDupTimer()
    self:ResetTimer(self.systemDTimerId)
    self:ResetTimer(self.dupUseTimerId)
end

function DuplicateManager:RemoveDupTimer()
    self:RemoveTimer(self.systemDTimerId)
    self:RemoveTimer(self.dupUseTimerId)
end

function DuplicateManager:EntityBuffChange(instanceId, buffInstanceId, buffId, isAdd)
    local entity = Fight.Instance.entityManager:GetEntity(instanceId)
    if not entity then
        return
    end

	local _, isPlayer = Fight.Instance.playerManager:GetPlayer():GetEntityQTEIndex(instanceId)
	if not isPlayer then
		return
	end

	local isPause = entity.buffComponent:CheckState(FightEnum.EntityBuffState.BigSkillPause)
	self.pauseAllTimer = isPause
end

function DuplicateManager:GetSystemDuplicateTimerId()
    return self.systemDTimerId
end

function DuplicateManager:GetDuplicateUseTimerId()
    return self.dupUseTimerId
end

function DuplicateManager:CheckTimerHaveUI(timerId)
    if not self.timers or not self.timers[timerId] then
        return
    end

    local timer = self.timers[timerId]
    return timer.timerType ~= FightEnum.DuplicateTimerType.Acc and timer.timerType ~= FightEnum.DuplicateTimerType.CountDown
end

-- function DuplicateManager:StartDuplicateUseTime()
--     self:ClearDuplicateUseTime()
--     self.dupTimerOpen = true
-- end

-- function DuplicateManager:EndDuplicateUseTime()
--     self.dupTimerOpen = false
-- end

--获取当前entity的点位
function DuplicateManager:GetCtrlEntityPos()
    local entity = self.fight.playerManager:GetPlayer():GetCtrlEntityObject()
    local transportPoint = entity.transformComponent.position
    local transportRot = entity.transformComponent.rotation
    local pos = {
        rotX = transportRot.rotX,
        rotY = transportRot.rotY,
        rotZ = transportRot.rotZ,
        rotW = transportRot.rotW,
        x = transportPoint.x,
        y = transportPoint.y,
        z = transportPoint.z
    }
    
    return pos 
end

--副本内复活编队成员
function DuplicateManager:ReviveEntity()
    local transportPoint = self.duplicateCtrl:GetDuplicatePos()
    local entity = self.fight.playerManager:GetPlayer():GetCtrlEntityObject()
    local transportRot

    if transportPoint.x == 0 and transportPoint.y == 0 and transportPoint.z == 0 then
        --读取duplicateConfig
        local duplicateId, levelId = self.worldMapCtrl:GetDuplicateInfo()
        local duplicateConfig = DuplicateConfig.GetDuplicateConfigById(duplicateId)
        if next(duplicateConfig.revive_pos) then
            --默认复活点
            transportPoint = self.worldMapCtrl:GetMapPositionConfig(levelId, duplicateConfig.revive_pos[2], duplicateConfig.revive_pos[1])
        else
            --原地复活
            transportPoint = entity.transformComponent.position
            transportRot = entity.transformComponent.rotation:ToEulerAngles()
        end
    end
    --补满血--改成正常状态
    self:SetPlayersMaxHp()
    BehaviorFunctions.InMapTransport(transportPoint.x, transportPoint.y, transportPoint.z)

    if transportRot then
        BehaviorFunctions.SetEntityEuler(entity.instanceId, transportRot.x, transportRot.y, transportRot.z)
    else
        local rot = Quat.New(transportPoint.rotX, transportPoint.rotY, transportPoint.rotZ, transportPoint.rotW):ToEulerAngles()
        BehaviorFunctions.SetEntityEuler(entity.instanceId, rot.x, rot.y, rot.z)
    end
    CameraManager.Instance:SetCameraRotation(entity.transformComponent.rotation)
end

--补满血
function DuplicateManager:SetPlayersMaxHp()
    local player = self.fight.playerManager:GetPlayer()
    --获取整个编队
    local entityList = player:GetEntityMap()
    for _, v in pairs(entityList) do
        local entity = BehaviorFunctions.GetEntity(v.InstanceId)
        entity:Revive()
    end
end

--@BeforeEnter 
--进入副本前的判断
function DuplicateManager:BeforeCreateDuplicate(systemDuplicateId, params)
    local systemDuplicateCfg = DuplicateConfig.GetSystemDuplicateConfigById(systemDuplicateId)
    if not systemDuplicateCfg then return end

    if systemDuplicateCfg.team_type == DuplicateConfig.formationType.robotType then
        --直接进入副本，不打开编队界面，直接带入限制角色进副本
        params.useHeroIdList = systemDuplicateCfg.team_request_id
        self.duplicateCtrl:EnterDuplicateMessage(systemDuplicateId, params)
        return
    elseif systemDuplicateCfg.team_type == DuplicateConfig.formationType.freeType then
        self.duplicateCtrl:EnterDuplicateMessage(systemDuplicateId, params)
        return 
    end
    

    params.fightData = {
        systemDuplicateId = systemDuplicateId,
        shopID = params.shopID,
        currSelectEntrustmentId = params.currSelectEntrustmentId,
        team_type = systemDuplicateCfg.team_type,--编队类型
        team_request_id = systemDuplicateCfg.team_request_id, --机器人
    }
    --打开大世界编队界面
    --打开编队
    FormationWindowV2.OpenWindow(params)
end

---@Enter Duplicate
--入口
function DuplicateManager:CreateDuplicate(systemDuplicateId, params)
    params = params or {}
    self:BeforeCreateDuplicate(systemDuplicateId, params)
end

function DuplicateManager:EnterFightFunc(systemDuplicateId, params)
    local curInfo = mod.FormationCtrl:GetOriginalFormation(mod.FormationCtrl.curFormationId)
	params.useHeroIdList = params.useHeroIdList or {}
	for i = 1, 3 do
		if curInfo.roleList[i] then 
			params.useHeroIdList[i] = curInfo.roleList[i]
		else
			params.useHeroIdList[i] = 0 
		end
	end
    self.duplicateCtrl:EnterDuplicateMessage(systemDuplicateId, params)
end

---@Finish Duplicate
--完成
function DuplicateManager:FinishedDuplicate(result, isQuit)
    --这里加个保底措施，防止出现在同一个副本中set为false 又set为true的情况
    local lastResult = self.duplicateCtrl:GetDupResult()
    if lastResult ~= FightEnum.FightResult.None then
        return
    end
    
    self.isQuit = isQuit--是否直接退出
    --设置副本结果
    self.duplicateCtrl:SetDupResult(result)
    --停止副本计时
    self:RemoveTimer(self.systemDTimerId)
    --发送结算协议
    self.duplicateCtrl:SendDuplicateFinishedMessage(result)
end

---@ResFinish Duplicate
--副本完成回包处理
function DuplicateManager:RecvFinishedDuplicate(data)
    --如果填了直接退出，直接发退出副本协议
    if self.isQuit then
        self.isQuit = nil
        self:ExitDuplicate()
        return
    end
   
    local result = self.duplicateCtrl:GetDupResult()
    if result == FightEnum.FightResult.Win then
        --挑战成功后会根据是否有掉落弹不同的界面
        local rewardList = data.reward_list or {}
        if next(rewardList) then
            --WindowManager.Instance:OpenWindow(DuplicateSuccessWindow, {reward_list = rewardList, cost = data.cost_energy})
            --添加到弹窗列表显示
            local setting = {
                args = {reward_list = rewardList, cost = data.cost_energy},
                isWindow = true,
            }
            EventMgr.Instance:Fire(EventName.AddSystemContent, DuplicateSuccessWindow, setting)
        else
            WindowManager.Instance:OpenWindow(DuplicateSuccessNoItemWindow, {cost = data.cost_energy})
        end
    else
        WindowManager.Instance:OpenWindow(DuplicateFailWindow, {cost = data.cost_energy})
    end
end

---@Exit Duplicate
--出口
function DuplicateManager:ExitDuplicate()
    self.duplicateCtrl:QuitDuplicate()
    self:RemoveDupTimer()
end

---@Again Duplicate
---再次挑战
function DuplicateManager:AgainDuplicateLevel()
    self.duplicateCtrl:AgainDuplicate()
end

---@ResAgain Duplicate
--再次挑战回包处理
function DuplicateManager:RecvAgainDuplicateLevel(data)
    self:ResetLevel()
    self:ResetDupTimer()
end

---@Reset Duplicate
--重新挑战
function DuplicateManager:ResetDuplicateLevel()
    local orderId, protoId = mod.DuplicateFacade:SendMsg("duplicate_reset_base")
    SystemConfig.WaitProcessing(orderId, protoId, function(ERRORCODE)
        if ERRORCODE == 0 then
            --清空数据
            self.duplicateCtrl:ClearProgressList()
            self.duplicateCtrl:ClearDuplicatePos()
            self.duplicateCtrl.fightResult = FightEnum.FightResult.None

            self:ResetLevel()
            self:ResetDupTimer()

            EventMgr.Instance:Fire(EventName.ResetDuplicate)
        end
    end)
end

function DuplicateManager:ResetLevel()
    --重载副本逻辑
    local duplicateId, dupLevelId = self.worldMapCtrl:GetDuplicateInfo()
    self.fight.levelManager:ResetLevel(dupLevelId)
    --判断小队是否都死亡了
    if self.fight.playerManager:GetPlayer():CheckIsAllDead() then
        self:ReviveEntity()
    else
        local dupCfg = DuplicateConfig.GetDuplicateConfigById(duplicateId)
        local bornPos = BehaviorFunctions.GetTerrainPositionP(dupCfg.position, dupCfg.level_id)
        --设置角色位置、朝向
        if bornPos then
            local player = self.fight.playerManager:GetPlayer():GetCtrlEntityObject()
            local rot = Quat.New(bornPos.rotX, bornPos.rotY, bornPos.rotZ, bornPos.rotW):ToEulerAngles()
            BehaviorFunctions.SetEntityEuler(player.instanceId, rot.x, rot.y, rot.z)
            BehaviorFunctions.InMapTransport(bornPos.x, bornPos.y, bornPos.z)
            CameraManager.Instance:SetCameraRotation(player.transformComponent.rotation)
        end
    end
end


function DuplicateManager:__delete()
    self.isQuit = nil
    EventMgr.Instance:RemoveListener(EventName.OnEntityBuffChange, self:ToFunc("EntityBuffChange"))
end


