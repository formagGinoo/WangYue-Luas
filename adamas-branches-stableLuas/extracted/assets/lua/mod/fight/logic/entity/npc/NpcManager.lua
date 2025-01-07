NpcManager = BaseClass("NpcManager")

local DataNpcBubbleCfg = Config.DataNpcBubble.Find
local _eventMgr = EventMgr.Instance

function NpcManager:__init(fight, entityManager)
    self.fight = fight
    self.entityManager = entityManager

    -- 记录可以生成的NPC
    self.npcRecord = {}

    self.npcEntity = {}
    self.npcBindTaskList = {}
    self.npcBindDialogList = {}
    self.npcHeadIcon = {}

    self.npcBubbleRecord = {}
    self.npcTaskReset = {}

    --self.waitInitNpcBindTask = false

    self.npcInMail = {}     -- 在发短信的NPC列表
    self.npcInCall = {}     -- 在打电话的NPC列表

    self.npcViewBindMap = {} --表现层被占用的npc

    EventMgr.Instance:AddListener(EventName.TaskFinish, self:ToFunc("OnTaskFinish"))
end

function NpcManager:StartFight()
    self.npcRecord = {}
    self:InitTaskBind()
    self:InitNpcBorn()
end

function NpcManager:Update()

end

function NpcManager:InitTaskBind()
    -- local taskMainType = TaskConfig.GetAllTaskMainType()
    local allTask = mod.TaskCtrl:GetAllTask()
    for _, task in pairs(allTask) do
        if not task.inProgress then
            goto continue
        end

        self:BindTask(task.taskId, task.stepId)

        ::continue::
    end
end

function NpcManager:CheckCreateNpc(config)
    local curMapId = self.fight:GetFightMap()
	if config.map_id ~= curMapId then
		return false
	end
	
	local mailingId = StoryConfig.GetMailingId(config.id)
	if mailingId and mod.MailingCtrl:CheckMailingState(mailingId, FightEnum.MailingState.Finished) then
		return false
	end

	return true
end

function NpcManager:InitNpcBorn()
    EventMgr.Instance:Fire(EventName.EcosystemInitDone, FightEnum.CreateEntityType.Npc)
end

function NpcManager:CreateNpc(config)
    if not self:CheckCreateNpc(config) then
        return
    end
    local entity = self.entityManager:CreateEntity(config.entity_id, nil, nil, config.id)
    local levelId
    local positionParam = config.position
    if self.npcBindTaskList[config.id] then
        local task = mod.TaskCtrl:GetTask(self.npcBindTaskList[config.id].taskId)
        if task then
            local occupyCfg = mod.TaskCtrl:GetTaskOccupyConfig(task.taskId, task.stepId)
            if not occupyCfg then
                goto continue
            end

            for k, v in pairs(occupyCfg.occupy_list) do
                if k == config.id then
                    if v[3] ~= 0 then
                        levelId = v[3]
                    end
        
                    if v[5] ~= "" and v[6] ~= "" then
                        positionParam = { v[5], v[6] }
                    end
                end
            end
            ::continue::
        end
    end

    local position = BehaviorFunctions.GetTerrainPositionP(positionParam[2], levelId, positionParam[1])
    if not position then
        return
    end

    entity.transformComponent:SetPosition(position.x, position.y, position.z)
    entity.rotateComponent:SetRotation(Quat.New(position.rotX, position.rotY, position.rotZ, position.rotW))

    self.npcEntity[config.id] = entity

    self.fight.clientFight.headInfoManager:ShowCharacterHeadTips(entity.instanceId)

    return entity
end

function NpcManager:RemoveNpc(npcId)
    self.npcEntity[npcId] = nil
end

function NpcManager:EntityHit()

end

function NpcManager:EntityHitEnd()

end

function NpcManager:BindTask(taskId, stepId)
    local taskOccupyCfg = mod.TaskCtrl:GetTaskOccupyConfig(taskId, stepId)
    if not taskOccupyCfg or not next(taskOccupyCfg) then
        return
    end

    local npcCfg = {}
    for k, v in pairs(taskOccupyCfg.occupy_list) do
        npcCfg = self:GetNpcConfig(k)
        if not npcCfg or not next(npcCfg) then
            goto continue
        end

        self.npcBindTaskList[k] = { taskId = taskId, stepId = stepId }
        local position
        if v[6] ~= "" and v[5] ~= "" then
            position = BehaviorFunctions.GetTerrainPositionP(v[6], v[4], v[5])
        end
        self.entityManager.ecosystemCtrlManager:UpdateNpcTaskBind(k, v[2], position)

        if v[7] ~= 0 then
            mod.WorldMapCtrl:ChangeEcosystemMark(npcCfg.map_id, k, v[7])
        end

        -- 除了修改ctrl的位置 还要修改实体的位置
        local entity = self:GetNpcEntity(k)
        if entity and position then
            entity.transformComponent:SetPosition(position.x, position.y, position.z)
        end
        self.npcViewBindMap[k] = taskId
        self.fight.entityManager:CallBehaviorFun("NpcBindTask", true, k)

        ::continue::
    end
end

-- 表现上解除任务的绑定
function NpcManager:UnBindTaskOnShow(taskId, stepId)
    local occupyCfg
    for k, v in pairs(self.npcBindTaskList) do
        if v.taskId ~= taskId or v.stepId ~= stepId then
            goto continue
        end

        occupyCfg = mod.TaskCtrl:GetTaskOccupyConfig(taskId, stepId)
        self:UnBindTaskSingle(k, occupyCfg)

        ::continue::
    end
end

function NpcManager:UnBindTaskSingle(npcId, occupyCfg)
    local npcCfg = self:GetNpcConfig(npcId)
    if not npcCfg or not next(npcCfg) then
        return
    end

    -- TODO 做一下优化 看看能不能后处理了
    local npcOccupy
    if occupyCfg then
        for k, v in pairs(occupyCfg) do
            if k == npcId then
                npcOccupy = k
                break
            end
        end
    end

    -- 位置修正
    if npcOccupy and npcOccupy[5] ~= "" and npcOccupy[6] ~= "" then
        local npcEntity = self:GetNpcEntity(npcId)
        local position = BehaviorFunctions.GetTerrainPositionP(npcCfg.position[2], nil, npcCfg.position[1])
        if npcEntity then
            npcEntity.transformComponent:SetPosition(position.x, position.y, position.z)
            npcEntity.rotateComponent:SetRotation(Quat.New(position.rotX, position.rotY, position.rotZ, position.rotW))
        else
            self.entityManager.ecosystemCtrlManager:ChangeCtrlPosition(npcId, position)
        end
    end

    self.entityManager.ecosystemCtrlManager:CancelNpcTaskBind(npcId)
    self.entityManager.ecosystemCtrlManager:ChangeEntityCreateState(npcId, npcCfg.default_create)
    self.npcViewBindMap[npcId] = nil

    if not next(npcCfg.jump_system_id) then
        self:SetNpcHeadIcon(npcId)
        local mark = mod.WorldMapCtrl:GetEcosystemMark(npcId)
        if mark then
            mod.WorldMapCtrl:RemoveMapMark(mark.instanceId)
        end
        self.fight.entityManager:CallBehaviorFun("NpcBindTask", false, npcId)
        return
    end

    for i = 1, #npcCfg.jump_system_id do
        local tempJumpCfg = Config.DataNpcSystemJump.Find[npcCfg.jump_system_id[i]]
        if self.fight.conditionManager:CheckConditionByConfig(tempJumpCfg.condition) then
            self:SetNpcHeadIcon(npcId, tempJumpCfg.icon)
            mod.WorldMapCtrl:ChangeEcosystemMark(npcCfg.map_id, npcId, npcCfg.jump_system_id[i])
            break
        end
    end

    self.fight.entityManager:CallBehaviorFun("NpcBindTask", false, npcId)
end

function NpcManager:BindDialog(npcList, dialogId)
    -- NPC被对话绑定 还没想好应用场景
end

function NpcManager:GetNpcConfig(npcId)
    local cfg, type = EcoSystemConfig.GetEcoConfig(npcId)
    return cfg, type
end

function NpcManager:GetNpc()
    
end

function NpcManager:GetNpcDialogId(npcId)
    local npcCfg = self:GetNpcConfig(npcId)
    if not npcCfg or not next(npcCfg) then
        return
    end

    if self.npcBindTaskList[npcId] then
        local taskId = self.npcBindTaskList[npcId].taskId
        local stepId = self.npcBindTaskList[npcId].stepId
        local occupyCfg = mod.TaskCtrl:GetTaskOccupyConfig(taskId, stepId)
        if occupyCfg then
            for k, v in pairs(occupyCfg.occupy_list) do
                if v[1] ~= 0 and k == npcId then
                    return v[1]
                end
            end
        end
    end

    -- local acceptDialogId = mod.TaskCtrl:GetNpcAcceptDialog(npcId)
    -- if acceptDialogId then
    --     return acceptDialogId
    -- end

    local dialogId = npcCfg.story_dialog_id
    local priority = 0
    for k, v in ipairs(npcCfg.task_extra_dialog) do
        if v[1] <= priority then
            goto continue
        end

        if self.fight.conditionManager:CheckConditionByConfig(v[2]) then
            dialogId = v[3]
            priority = v[1]
        end

        ::continue::
    end

    return dialogId
end

-- 获取当前NPC配置应该播放的气泡对话ID
function NpcManager:GetNpcBubbleId(npcId)
    if not DataNpcBubbleCfg[npcId] then
        return
    end

    --TODO 找到正确的地方重置
    --if self.npcBubbleRecord[npcId] and not self.npcTaskReset[npcId] then
    --    return self.npcBubbleRecord[npcId]
    --end

    local bubbleId
    local priority = 0
    for k, v in pairs(DataNpcBubbleCfg[npcId].bubble_list) do
        if (v[1] == 0 or mod.TaskCtrl:CheckTaskIsFinish(v[1])) and v[2] > priority then
            bubbleId = k
            priority = v[2]
        end
    end

    self.npcBubbleRecord[npcId] = bubbleId
    self.npcTaskReset[npcId] = false

    return bubbleId
end

-- 获取当前NPC播放的气泡对话ID
function NpcManager:GetNpcPlayingBubbleId(npcId)
    if not self.npcEntity[npcId] then
        return
    end

    local instanceId = self.npcEntity[npcId].instanceId
    return self.fight.clientFight.headInfoManager:GetHeadInfoBubbleId(instanceId)
end

function NpcManager:GetNpcBubbleCfg(npcId, bubbleId)
    if not DataNpcBubbleCfg[npcId] then
        return
    end

    return DataNpcBubbleCfg[npcId].bubble_list[bubbleId]
end

function NpcManager:GetNpcBindTask(npcId)
    return self.npcBindTaskList[npcId]
end

function NpcManager:GetNpcEntity(npcId)
    return self.npcEntity[npcId]
end

function NpcManager:GetNpcRecordList()
    return self.npcRecord
end

function NpcManager:SetNpcHeadIcon(npcId, icon)
    self.npcHeadIcon[npcId] = icon
    if not self.npcEntity[npcId] then
        return
    end

    self.fight.clientFight.headInfoManager:SetHeadIcon(self.npcEntity[npcId].instanceId, icon)
end

function NpcManager:GetNpcHeadIcon(npcId)
    if self.npcHeadIcon and self.npcHeadIcon[npcId] then
        return self.npcHeadIcon[npcId]
    end

    -- local jumpId, showIcon = self:GetNpcJumpId(npcId)
    -- local npcCfg = self:GetNpcConfig(npcId)
    local jumpCfg, showIcon = self:GetNpcJumpCfg(npcId)
    if jumpCfg and showIcon then
        -- local jumpCfg = Config.DataNpcSystemJump.Find[jumpId]
        return jumpCfg.icon
    else
        return ""
    end
end

function NpcManager:GetNpcJumpCfg(npcId)
    local npcCfg = self:GetNpcConfig(npcId)
    if not npcCfg then
        return
    end

    local jumpCfg
    if self.npcBindTaskList[npcId] then
        local taskId = self.npcBindTaskList[npcId].taskId
        local stepId = self.npcBindTaskList[npcId].stepId
        local occupyCfg = mod.TaskCtrl:GetTaskOccupyConfig(taskId, stepId)
        if not occupyCfg then
            goto continue
        end

        for k, v in pairs(occupyCfg.occupy_list) do
            if v[7] ~= 0 and k == npcId then
                jumpCfg = Config.DataNpcSystemJump.Find[v[7]]
                return jumpCfg, true
            end
        end
    end

    ::continue::

    if not next(npcCfg.jump_system_id) then
        return
    end

    for i = 1, #npcCfg.jump_system_id do
        local tempJumpCfg = Config.DataNpcSystemJump.Find[npcCfg.jump_system_id[i]]
        if tempJumpCfg and tempJumpCfg.icon ~= "" and self.fight.conditionManager:CheckConditionByConfig(tempJumpCfg.condition) then
            jumpCfg = tempJumpCfg
            break
        end
    end

    return jumpCfg, npcCfg.show_head_icon
    -- return npcCfg.jump_system_id[1], npcCfg.show_head_icon
end

function NpcManager:SetNpcBubbleId(npcId, bubbleId)
    if not self.npcEntity[npcId] or not DataNpcBubbleCfg[npcId] then
        return
    end

    local bubbleCfg = DataNpcBubbleCfg[npcId].bubble_list[bubbleId]
    if not bubbleCfg then
        return
    end

    local instanceId = self.npcEntity[npcId].instanceId
    self.fight.clientFight.headInfoManager:SetHeadInfoBubbleId(instanceId, bubbleId, bubbleCfg)
end

function NpcManager:SetNpcBubbleContent(npcId, content, duration)
    if not self.npcEntity[npcId] or not content or not duration then
        return
    end

    local instanceId = self.npcEntity[npcId].instanceId
    self.fight.clientFight.headInfoManager:SetBubbleContent(instanceId, content, duration)
end

function NpcManager:SetNpcBubbleVisible(npcId, visible)
    if not self.npcEntity[npcId] then
        return
    end

    local instanceId = self.npcEntity[npcId].instanceId
    self.fight.clientFight.headInfoManager:SetBubbleVisible(instanceId, visible)
end

function NpcManager:SetNpcHeadInfoVisible(npcId, visible)
    if not self.npcEntity[npcId] then
        return
    end

    local instanceId = self.npcEntity[npcId].instanceId
    self.fight.clientFight.headInfoManager:SetHeadInfoVisible(instanceId, visible)
end

function NpcManager:CheckEntityIsNpc(instanceId)
    local entity = self.entityManager:GetEntity(instanceId)
    if not entity then
        return false
    end

    local npcCfg, type = self:GetNpcConfig(entity.sInstanceId)
    if not npcCfg or not next(npcCfg) or type ~= FightEnum.EcoEntityType.Npc then
        return false
    end

    return true
end

function NpcManager:CheckEcoIdIsNpc(ecoId)
    local cfg, type = EcoSystemConfig.GetEcoConfig(ecoId)
	return type == FightEnum.EcoEntityType.Npc
end

function NpcManager:CheckNpcIsInTask(npcId)
    return self.npcBindTaskList[npcId] ~= nil
end

--表现层是否被占用
function NpcManager:CheckNpcIsBind(npcId)
    return self.npcViewBindMap[npcId] ~= nil
end

function NpcManager:CheckNpcIsInDialog()

end

function NpcManager:OnTaskFinish(taskId, stepId)
    -- 解除任务的绑定
    for k, v in pairs(self.npcBindTaskList) do
        if v.taskId ~= taskId or v.stepId ~= stepId then
            goto continue
        end

        -- 看看下个任务会不会连续占用 是不是没有必要恢复
        local stepCount = mod.TaskCtrl:GetTaskStepCount(taskId)
        if stepCount > stepId and mod.TaskCtrl:CheckIsTaskOccupyNpc(taskId, stepId + 1, k) then
             goto continue
        end

        self.npcBindTaskList[k] = nil
        self:UnBindTaskSingle(k)

        ::continue::
    end
end

function NpcManager:SetNpcMailState(npcId, state)
    if not self.npcInMail[npcId] and not state then
        return
    end

    self.npcInMail[npcId] = state

    EventMgr.Instance:Fire(EventName.NpcMailStateChange, npcId, state)
end

function NpcManager:SetNpcCallState(npcId, state)
    if not self.npcInCall[npcId] and not state then
        return
    end

    self.npcInCall[npcId] = state

    EventMgr.Instance:Fire(EventName.NpcCallStateChange, npcId, state)
end

function NpcManager:CheckNpcMailState(npcId)
    return self.npcInMail[npcId] == true
end

function NpcManager:CheckNpcCallState(npcId)
    return self.npcInCall[npcId] == true
end

function NpcManager:GetNpcMailId(npcId)
    local npcConfig = self:GetNpcConfig(npcId)
    if not next(npcConfig.mail_list) then
        return
    end

    math.randomseed()
    local id = math.random(#npcConfig.mail_list)
    return npcConfig.mail_list[id]
end

function NpcManager:GetNpcCallId(npcId)
    local npcConfig = self:GetNpcConfig(npcId)
    if not next(npcConfig.phone_call_list) then
        return
    end

    math.randomseed()
    local id = math.random(#npcConfig.phone_call_list)
    return npcConfig.phone_call_list[id]
end

function NpcManager:CheckNpcCanMail(npcId)
    local npcConfig = self:GetNpcConfig(npcId)
    if not next(npcConfig.mail_list) then
        return false
    end

    return true
end

function NpcManager:CheckNpcCanCall(npcId)
    local npcConfig = self:GetNpcConfig(npcId)
    if not next(npcConfig.phone_call_list) then
        return false
    end

    return true
end

function NpcManager:__delete()
    EventMgr.Instance:RemoveListener(EventName.TaskFinish, self:ToFunc("OnTaskFinish"))
end