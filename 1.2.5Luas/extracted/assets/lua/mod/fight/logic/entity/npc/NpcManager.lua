NpcManager = BaseClass("NpcManager")

local DataNpcConfig = Config.DataNpc.Find
local DataNpcBubbleCfg = Config.DataNpcBubble.Find

function NpcManager:__init(fight, entityManager)
    self.fight = fight
    self.entityManager = entityManager

    -- 记录可以生成的NPC
    self.npcRecord = {}

    self.npcEntity = {}
    self.npcBindTaskList = {}
    self.npcBindDialogList = {}
    self.npcCreateStateRecord = {}
    self.npcHeadIcon = {}

    self.npcBubbleRecord = {}
    self.npcTaskReset = {}

    self.waitInitNpcBindTask = false

    EventMgr.Instance:AddListener(EventName.AddTask, self:ToFunc("OnTaskAdded"))
    EventMgr.Instance:AddListener(EventName.TaskFinish, self:ToFunc("OnTaskFinish"))
end

function NpcManager:StartFight()
    self.npcRecord = {}
    self:InitTaskBind()
    self:InitNpcBorn()
end

function NpcManager:Update()
    if self.waitInitNpcBindTask then
        self.waitInitNpcBindTask = false
        if self.npcBindTaskList and next(self.npcBindTaskList) then
            for k, v in pairs(self.npcBindTaskList) do
                self.entityManager.ecosystemCtrlManager:ChangeEntityCreateState(k, v.cfg[2])

                if v.cfg[6] ~= "" and v.cfg[5] ~= "" then
                    local position = BehaviorFunctions.GetTerrainPositionP(v.cfg[6], v.cfg[4], v.cfg[5])
                    self.entityManager.ecosystemCtrlManager:ChangeCtrlPosition(k, position)
                end
            end
        end
    end
end

function NpcManager:InitTaskBind()
    local taskMainType = TaskConfig.GetAllTaskMainType()
    for taskType, _ in pairs(taskMainType) do
        local taskList = mod.TaskCtrl:GetTaskList(taskType)
        for k, v in ipairs(taskList) do
            if not v.inProgress then
                goto continue
            end

            self:BindTask(v.taskId)

            ::continue::
        end
    end
end

function NpcManager:CheckCreateNpc(config, curMapId)
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
	local curMapId = self.fight:GetFightMap()
    for k, v in pairs(DataNpcConfig) do
		if self:CheckCreateNpc(v, curMapId) then
        	self.entityManager:CreateSysEntityCtrl(v, FightEnum.CreateEntityType.Npc)
            table.insert(self.npcRecord, k)
		end
    end

    self.waitInitNpcBindTask = true
    EventMgr.Instance:Fire(EventName.EcosystemInitDone, FightEnum.CreateEntityType.Npc)
end

function NpcManager:CreateNpc(config)
    local entity = self.entityManager:CreateEntity(config.entity_id, nil, nil, config.id)
    local levelId
    local positionParam = config.position
    if self.npcBindTaskList[config.id] then
        local occupyCfg = self.npcBindTaskList[config.id]
        if occupyCfg.cfg[3] ~= 0 then
            levelId = occupyCfg.cfg[3]
        end

        if occupyCfg.cfg[5] ~= "" and occupyCfg.cfg[6] ~= "" then
            positionParam = { occupyCfg.cfg[5], occupyCfg.cfg[6] }
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

function NpcManager:BindTask(taskId)
    local taskOccupyCfg = mod.TaskCtrl:GetTaskOccupyConfig(taskId)
    if not taskOccupyCfg or not next(taskOccupyCfg) then
        return
    end

    for k, v in pairs(taskOccupyCfg.occupy_list) do
        self.npcBindTaskList[k] = { taskId = taskId, cfg = v }
        self.npcCreateStateRecord[k] = true
        self.entityManager.ecosystemCtrlManager:ChangeEntityCreateState(k, v[2])

        if v[6] ~= "" and v[5] ~= "" then
            local position = BehaviorFunctions.GetTerrainPositionP(v[6], v[4], v[5])
            self.entityManager.ecosystemCtrlManager:ChangeCtrlPosition(k, position)
        end
    end
end

function NpcManager:BindDialog(npcList, dialogId)
    -- NPC被对话绑定 还没想好应用场景
end

function NpcManager:GetNpcConfig(npcId)
    return DataNpcConfig[npcId]
end

function NpcManager:GetNpcDialogId(npcId)
    local npcCfg = self:GetNpcConfig(npcId)
    if not npcCfg or not next(npcCfg) then
        return
    end

    if self.npcBindTaskList[npcId] then
        local occupyCfg = self.npcBindTaskList[npcId].cfg
        return occupyCfg[1]
    end

    local acceptDialogId = mod.TaskCtrl:GetNpcAcceptDialog(npcId)
    if acceptDialogId then
        return acceptDialogId
    end

    local dialogId = npcCfg.story_dialog_id
    local priority = 0
    for k, v in ipairs(npcCfg.task_extra_dialog) do
        if v[1] <= priority then
            goto continue
        end

        if self.fight.conditionManager:CheckConditionByConfig(v[2][1]) then
            dialogId = v[2][2]
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

    if self.npcBubbleRecord[npcId] and not self.npcTaskReset[npcId] then
        return self.npcBubbleRecord[npcId]
    end

    local bubbleId
    local priority = 0
    for k, v in pairs(DataNpcBubbleCfg[npcId].bubble_list) do
        if mod.TaskCtrl:CheckTaskIsFinish(v[1]) and v[2] > priority then
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

    local npcCfg = self:GetNpcConfig(npcId)
    local jumpId = npcCfg.jump_system_id[1]
    if jumpId and npcCfg.show_head_icon then
        local jumpCfg = Config.DataNpcSystemJump.Find[npcCfg.jump_system_id[1]]
        return jumpCfg.icon
    else
        return ""
    end
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

    local npcCfg = self:GetNpcConfig(entity.sInstanceId)
    if not npcCfg or not next(npcCfg) then
        return false
    end

    return true
end

function NpcManager:CheckEcoIdIsNpc(ecoId)
	local npcCfg = self:GetNpcConfig(ecoId)
	if not npcCfg or not next(npcCfg) then
		return false
	end

	return true
end

function NpcManager:CheckNpcIsInTask(npcId)
    return self.npcBindTaskList[npcId] ~= nil, self.npcBindTaskList[npcId]
end

function NpcManager:CheckNpcCreateState(npcId)
    return self.npcCreateStateRecord[npcId]
end

function NpcManager:CheckNpcIsInDialog()

end

function NpcManager:OnTaskAdded(taskId)
    if not mod.TaskCtrl:CheckTaskIsInProgress(taskId) then
        return
    end

    self:BindTask(taskId)
end

function NpcManager:OnTaskFinish(taskId)
    -- 解除任务的绑定
    for k, v in pairs(self.npcBindTaskList) do
        if v.taskId == taskId then
            local npcCfg = self:GetNpcConfig(k)

            -- 位置修正
            local npcEntity = self:GetNpcEntity(k)
            local position = BehaviorFunctions.GetTerrainPositionP(npcCfg.position[2], nil, npcCfg.position[1])
            if npcEntity then
                npcEntity.transformComponent:SetPosition(position.x, position.y, position.z)
                npcEntity.rotateComponent:SetRotation(Quat.New(position.rotX, position.rotY, position.rotZ, position.rotW))
            else
                self.entityManager.ecosystemCtrlManager:ChangeCtrlPosition(k, position)
            end

            self.npcCreateStateRecord[k] = false
            self.entityManager.ecosystemCtrlManager:ChangeEntityCreateState(k, npcCfg.default_create)

            self.npcBindTaskList[k] = nil
        end
    end
end

function NpcManager:__delete()
    EventMgr.Instance:RemoveListener(EventName.AddTask, self:ToFunc("OnTaskAdded"))
    EventMgr.Instance:RemoveListener(EventName.TaskFinish, self:ToFunc("OnTaskFinish"))
end