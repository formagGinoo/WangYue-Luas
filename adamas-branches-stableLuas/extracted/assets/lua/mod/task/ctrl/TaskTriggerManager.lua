TaskTriggerManager = BaseClass("TaskTriggerManager")

TaskTriggerEnum = {
    PlayStoryDialog = 1,
    CreateLevel = 2,
    Transport = 3,
    Message = 4,
    Duplicate = 5,
    Teach = 6,
    PlayerLookAtPos = 7,
    PLayerLookAtEco = 8
}

TaskTriggerTrans = {
    ["play_storydialog"] = TaskTriggerEnum.PlayStoryDialog,
    ["create_level"] = TaskTriggerEnum.CreateLevel,
    ["transport"] = TaskTriggerEnum.Transport,
    ["start_message"] = TaskTriggerEnum.Message,
    ["create_duplicate"] = TaskTriggerEnum.Duplicate,
    ["start_teach"] = TaskTriggerEnum.Teach,
    ["player_lookatpos"] = TaskTriggerEnum.PlayerLookAtPos,
    ["player_lookateco"] = TaskTriggerEnum.PLayerLookAtEco
}

function TaskTriggerManager:__init(fight, taskManager)
    self:BindTriggerFuncs()
    self:BindListener()
    self.teachId = nil
    self.curTaskId = nil
    self.curTaskStep = nil
    self.curParams = {}
    self.role = nil
    self.curEcoEntity = nil
    self.startPlayerLookAtPos = false
    self.startPlayerLookAtEco = false
    self.removeEntity = false
    self.fight = fight
    self.taskManager = taskManager
end

function TaskTriggerManager:BindTriggerFuncs()
    self.triggerFuncs = {}
    self.triggerFuncs[TaskTriggerEnum.PlayStoryDialog] = self.OnPlayStoryDialog
    self.triggerFuncs[TaskTriggerEnum.CreateLevel] = self.OnCreateLevel
    self.triggerFuncs[TaskTriggerEnum.Transport] = self.OnTransport
    self.triggerFuncs[TaskTriggerEnum.Message] = self.OnMessage
    self.triggerFuncs[TaskTriggerEnum.Duplicate] = self.OnCretaeDupLicate
    self.triggerFuncs[TaskTriggerEnum.Teach] = self.OnTeach
    self.triggerFuncs[TaskTriggerEnum.PlayerLookAtPos] = self.OnPlayerLookAtPos
    self.triggerFuncs[TaskTriggerEnum.PLayerLookAtEco] = self.OnPlayerLookAtEco

end
function TaskTriggerManager:BindListener()
    EventMgr.Instance:AddListener(EventName.AddTask, self:ToFunc("DoTrigger"))
end

function TaskTriggerManager:RemoveListener()
    EventMgr.Instance:RemoveListener(EventName.AddTask, self:ToFunc("DoTrigger"))
end

function TaskTriggerManager:DoTrigger(taskId, isTrigger)
    if not isTrigger then return end

    local taskInfo = mod.TaskCtrl:GetTask(taskId)
    if not taskInfo then
        return
    end
    if not taskInfo.inProgress then
        return
    end

    local taskCfg = mod.TaskCtrl:GetTaskConfig(taskInfo.taskId, taskInfo.stepId)
    if not taskCfg then
        return
    end
    if not taskCfg.trigger or not next(taskCfg.trigger) then
        return
    end

    local condition = TaskTriggerTrans[taskCfg.trigger[1]]
    if not condition then
        return
    end

    if self.triggerFuncs[condition] then
        self.triggerFuncs[condition](self, taskInfo.taskId, taskInfo.stepId, taskCfg.trigger[2])
    end
end

function TaskTriggerManager:Update()
end

function TaskTriggerManager:LowUpdate()
    if self.startPlayerLookAtPos then
        self:CheckPosDistance()
    end
    if self.startPlayerLookAtEco then
        self:CheckEcoDistance()
    end
    if self.removeEntity then
        self:RemoveCamera()
    end
end

function TaskTriggerManager:OnPlayStoryDialog(taskId, stepId, params)
    local dialogId = params[1]
    if not dialogId then
        Log.Error("对话播放失败,缺少对应的配置信息,dialogId = %s",dialogId)
        return
    end

    if self.taskManager.taskInCurtain then
        LuaTimerManager.Instance:AddTimer(1, 0.5, function() CurtainManager.Instance:FadeOut(1) end)
        self.taskManager:SetTaskInCurtain(false)
    end
    self.taskManager:PalyStory(tonumber(dialogId))
end

function TaskTriggerManager:OnCreateLevel(taskId, stepId, params)
    
    --现在关卡会被取消重新创建，所以要判断下任务是否是退出指引的任务，不是的话就不进行创建
    if mod.TaskCtrl:GetExitTask(taskId) then
        return
    end
    local levelId = params[1]
    --需要判断是否提前创建了关卡
    if self.taskManager:CheckIsPreLoadLevel(levelId) then
        return
    end
    if not levelId then
        Log.Error("关卡创建失败,缺少对应的配置信息,levelId = %s",levelId)
        return
    end

    BehaviorFunctions.AddLevel(tonumber(levelId), taskId)
end

-- TODO 这里的transport和BehaviorFunctions里面的transport是一个方法 后面改一下
function TaskTriggerManager:OnTransport(taskId, stepId, params)
    local mapId = params[1]
    local positionId = params[2]
    local logicName = params[3]
    local positionName = params[4]

    if not mapId or not positionId or not logicName or not positionName then
        Log.Error("传送失败,缺少对应的配置信息,mapId = %s,positionId = %s,logicName = %s,positionName = %s",mapId,positionId,logicName,positionName)
        return
    end

    local posCfg = mod.WorldMapCtrl:GetMapPositionConfigByPositionId(positionId,positionName,logicName)

    if not mapId or not positionName then
        return
    end

    if posCfg then
        local  nowMapId = self.fight:GetFightMap()
        if not posCfg or not nowMapId then
           return
        end

        local ctrlEntity = self.fight.playerManager:GetPlayer():GetCtrlEntityObject()
        local curPos = ctrlEntity.transformComponent:GetPosition()
        local inMapTrans = ((posCfg.x - curPos.x) ^ 2 + (posCfg.y - curPos.y) ^ 2 + (posCfg.z - curPos.z) ^ 2 <= 10000) and nowMapId == tonumber(mapId)
        if inMapTrans then
            mod.WorldCtrl:InMapTransport(nil, posCfg.x,posCfg.y,posCfg.z)
        else
            BehaviorFunctions.Transport(tonumber(mapId), posCfg.x, posCfg.y, posCfg.z)
        end
    end
end

function TaskTriggerManager:OnMessage(taskId, stepId, params)
    local messageId = params[1]
    if not messageId then
        Log.Error("触发短信失败,缺少对应的配置信息messageId = %s",messageId)
        return
    end
    BehaviorFunctions.StartMessage(tonumber(messageId))
end

function TaskTriggerManager:OnCretaeDupLicate(taskId,stepId,params)
    local duplicateId = params[1]
    if not duplicateId then
        Log.Error("副本关卡创建失败,缺少对应的配置信息duplicateId= %s",duplicateId)
        return
    end
    BehaviorFunctions.CreateDuplicate(tonumber(duplicateId))
end

function TaskTriggerManager:OnTeach(taskId,stepId,params)
    if self.teachId == params[1] then --避免多次触发教学
        return
    end
    self.teachId = params[1]
    if not self.teachId then
        Log.Error("教学创建失败,缺少对应的配置信息teachId= %s",self.teachId)
        return
    end
    BehaviorFunctions.ShowGuideImageTips(tonumber(self.teachId))
end

function TaskTriggerManager:OnPlayerLookAtPos(taskId,stepId,params)
    self.curTaskId = taskId
    self.curTaskStep = stepId
    self.startPlayerLookAtPos = true
    self.curParams = params
    self.role = BehaviorFunctions.GetCtrlEntity()
end

function TaskTriggerManager:CheckPosDistance()
    local camEntityId = tonumber(self.curParams[1])
    local positionId = tonumber(self.curParams[2])
    local logicName = self.curParams[3]
    local positionName = self.curParams[4]
    local time = tonumber(self.curParams[5])
    local distance = tonumber(self.curParams[6])
    local pos1 = BehaviorFunctions.GetTerrainPositionP(positionName,positionId,logicName)
	local pos2 = BehaviorFunctions.GetPositionP(self.role)
    local dis =  BehaviorFunctions.GetDistanceFromPos(pos1,pos2)
    if dis<distance or distance<0 then
        local fp1 = BehaviorFunctions.GetTerrainPositionP(positionName,nil,logicName)
	    self.empty = BehaviorFunctions.CreateEntity(2001,nil,fp1.x,fp1.y,fp1.z)
        self:SetCamOrientation(self.role,self.empty,camEntityId,time)
        if time>0 then
            BehaviorFunctions.AddDelayCallByTime(time,BehaviorFunctions,BehaviorFunctions.RemoveEntity,self.empty)
            self.empty = nil
        end
        self.startPlayerLookAtPos = false
    end
end

function TaskTriggerManager:OnPlayerLookAtEco( taskId,stepId,params)
    local ecoEntityId = tonumber(params[2])
    self.curTaskId = taskId
    self.curTaskStep = stepId
    self.startPlayerLookAtEco = true
    self.curParams = params
    self.role = BehaviorFunctions.GetCtrlEntity()
    self.curEcoEntity =  BehaviorFunctions.GetEcoEntityByEcoId(ecoEntityId)
end

function TaskTriggerManager:CheckEcoDistance()
    local camEntityId = tonumber(self.curParams[1])
    local time = tonumber(self.curParams[3])
    local distance = tonumber(self.curParams[4])
    
    local pos1 = BehaviorFunctions.GetPositionP(self.curEcoEntity)
	local pos2 = BehaviorFunctions.GetPositionP(self.role)
    local dis =  BehaviorFunctions.GetDistanceFromPos(pos1,pos2)
    if dis<distance or distance<0 then
        self:SetCamOrientation(self.role,self.curEcoEntity,camEntityId,time)
        self.startPlayerLookAtEco = false
    end
end

function TaskTriggerManager:SetCamOrientation(roel,entity,camEntityId,time)
    self.levelCam = BehaviorFunctions.CreateEntity(camEntityId)
    self.camentity = BehaviorFunctions.GetEntity(self.levelCam)
    local OperatingCamera = CameraManager.Instance:GetCamera(FightEnum.CameraState.Operating)
    local targetGroup = OperatingCamera.targetGroup
    BehaviorFunctions.DoLookAtTargetImmediately(roel,entity)
    if targetGroup then
        self.camentity.clientEntity.clientCameraComponent.cinemachineCamera.m_Follow = targetGroup.Transform
    end
    BehaviorFunctions.CameraEntityLockTarget(self.levelCam,entity)
    if time>0 then
        BehaviorFunctions.AddDelayCallByTime(time,BehaviorFunctions,BehaviorFunctions.RemoveEntity,self.levelCam)
        self.levelCam = nil
    else
        self.removeEntity = true
    end
end

function TaskTriggerManager:RemoveCamera()
    if mod.TaskCtrl:CheckTaskStepIsFinish(self.curTaskId,self.curTaskStep) 
    or UtilsBase.IsNull(self.camentity.clientEntity.clientCameraComponent.cinemachineCamera.m_LookAt) then
        if self.levelCam then
            BehaviorFunctions.RemoveEntity(self.levelCam)
        end
        if self.empty then
            BehaviorFunctions.RemoveEntity(self.empty)
        end
       self.levelCam = nil
       self.empty = nil
       self.removeEntity = false
    end
end