PhotoCtrl = BaseClass("PhotoCtrl", Controller)

local BuildData = Config.DataBuild.Find

local _tinsert = table.insert

function PhotoCtrl:__init()
    self.buildingTargetList = {}
    self.isCanRaycast = true

    self.photoEntitysCurFrame = TableUtils.NewTable()
    self.photoEntitysCache = TableUtils.NewTable()
end

function PhotoCtrl:__delete()
end

function PhotoCtrl:OpenPhoto(mode)
    SystemStateMgr.Instance:AddState(SystemStateConfig.StateType.Photo, mode)
end

function PhotoCtrl:TempOpenPhoto(mode)
    local mainUI = WindowManager.Instance:GetWindow("FightMainUIView")
    self.cameraPanel = mainUI:OpenPanel(PhotoMainPanel, {mode = mode})
    --BehaviorFunctions.SetFightPanelVisible("000010000")
    SystemStateMgr.Instance:SetFightVisible(SystemStateConfig.StateType.Photo, "000010000")
    --BehaviorFunctions.StoryPauseDialog()

    self.entityManager = Fight.Instance.entityManager
    InputManager.Instance:AddLayerCount("Photo")
    
    self:EntryPhotoMode()
end

function PhotoCtrl:ClosePhoto()
    if self.cameraPanel then
        local mainUI = WindowManager.Instance:GetWindow("FightMainUIView")
        mainUI:ClosePanel(self.cameraPanel)
        self.cameraPanel = nil
        --BehaviorFunctions.SetFightPanelVisible("-1")
    end
    self:ExitPhotoMode()

    self.entityManager = nil
    InputManager.Instance:MinusLayerCount("Photo")
    --BehaviorFunctions.StoryResumeDialog()
    SystemStateMgr.Instance:RemoveState(SystemStateConfig.StateType.Photo)
end

function PhotoCtrl:EntryPhotoMode()
    self.curMode = PhotoEnum.State.Photo

    self.aimPhotoTargetTimer = LuaTimerManager.Instance:AddTimer(0, 0.1, self:ToFunc("PhotoAimTarget"))

    self:GetBuildingTargetList(self.buildingTargetList)

    for index, instanceId in pairs(self.buildingTargetList) do
        BehaviorFunctions.DoMagic(1, instanceId, PhotoConfig.CanBuildEffect)
    end
end

function PhotoCtrl:ExitPhotoMode()
    if self.curMode ~= PhotoEnum.State.Photo then
        return
    end
    self.curMode = nil

    if self.aimPhotoTargetTimer then
        LuaTimerManager.Instance:RemoveTimer(self.aimPhotoTargetTimer)
        self.aimPhotoTargetTimer = nil 
    end

    for entityInstanceId, entity in pairs(self.photoEntitysCache) do
        --LogInfo(entityInstanceId .. " 实体离开")
        self.entityManager:CallBehaviorFun("ExitPhotoFrame", entityInstanceId)
    end

    for index, instanceId in pairs(self.buildingTargetList) do
        BehaviorFunctions.RemoveBuff(instanceId, PhotoConfig.CanBuildEffect)
    end

    if self.curSelectInstanceId then
        BehaviorFunctions.RemoveBuff(self.curSelectInstanceId, PhotoConfig.SelectEffect)
        self.curSelectInstanceId = nil
    end
    EventMgr.Instance:Fire(EventName.DesignSelectChange, self.curSelectInstanceId, self.curSelectDis)
    TableUtils.ClearTable(self.photoEntitysCurFrame)
    TableUtils.ClearTable(self.photoEntitysCache)
end

function PhotoCtrl:CheckEntityInPhotoFrame(instanceId)
    return self.photoEntitysCache[instanceId] ~= nil
end

function PhotoCtrl:PhotoAimTarget()
    if self.entityManager then
        local entities = self.entityManager:GetEntites()

        TableUtils.ClearTable(self.photoEntitysCurFrame)
        
        for _, entity in pairs(entities) do
            local entityPos = entity.transformComponent.position
            local viewPos = UtilsBase.WorldToViewportPoint(entityPos.x, entityPos.y, entityPos.z)
            if viewPos.z < 0 or viewPos.x < 0 or viewPos.y < 0 or viewPos.x > 1 or viewPos.y > 1 then 
                goto continue
            end
    
            self.photoEntitysCurFrame[entity.instanceId] = entities
    
            ::continue::
        end
        
        for entityInstanceId, entity in pairs(self.photoEntitysCurFrame) do
            if not self.photoEntitysCache[entityInstanceId] then
                --LogInfo(entityInstanceId .. " 实体进入")
                self.entityManager:CallBehaviorFun("EntryPhotoFrame", entityInstanceId)
            end
        end
    
        for entityInstanceId, entity in pairs(self.photoEntitysCache) do
            if not self.photoEntitysCurFrame[entityInstanceId] then
                --LogInfo(entityInstanceId .. " 实体离开")
                self.entityManager:CallBehaviorFun("ExitPhotoFrame", entityInstanceId)
            end
        end
    
        local tmp = self.photoEntitysCache
        self.photoEntitysCache = self.photoEntitysCurFrame
        self.photoEntitysCurFrame = tmp
    
        local selectInstanceId, dis = self:DesignRaycast()
        if selectInstanceId ~= self.curSelectInstanceId then
            if self.curSelectInstanceId then
                BehaviorFunctions.RemoveBuff(self.curSelectInstanceId, PhotoConfig.SelectEffect)
                BehaviorFunctions.DoMagic(1, self.curSelectInstanceId, PhotoConfig.CanBuildEffect)
            end
            self.curSelectInstanceId = selectInstanceId
            self.curSelectDis = dis
            if self.curSelectInstanceId then
                BehaviorFunctions.RemoveBuff(self.curSelectInstanceId, PhotoConfig.CanBuildEffect)
                BehaviorFunctions.DoMagic(1, self.curSelectInstanceId, PhotoConfig.SelectEffect)
            end
    
            EventMgr.Instance:Fire(EventName.DesignSelectChange, self.curSelectInstanceId, self.curSelectDis)
        end
    end
end

function PhotoCtrl:DesignRaycast()
    if self.isCanRaycast then
        self:GetBuildingTargetList(self.buildingTargetList)

        local selectIndex = nil
        local curMinDis = 9999
    
        if self.buildingTargetList then
            for index, instanceId in pairs(self.buildingTargetList) do
                local entity = BehaviorFunctions.GetEntity(instanceId)
                if BehaviorFunctions.CheckEntityIsInCameraView(instanceId) then
                    local viewPos = UtilsBase.WorldToViewportPoint(entity.transformComponent.position.x, entity.transformComponent.position.y, entity.transformComponent.position.z)
                    if viewPos.z < PhotoConfig.CastRayDistance and viewPos.z < curMinDis
                      and viewPos.x > 0.375 and viewPos.x < 0.625 and viewPos.y > 0.335 and viewPos.y < 0.545 then
                        selectIndex = instanceId
                        curMinDis = viewPos.z
                    end
                end
            end
        end
    
        return selectIndex, curMinDis
    else
        return self.curSelectInstanceId, self.curSelectDis
    end
end

function PhotoCtrl:IsCanSaveBluePrint(instanceId)
    if not instanceId or not BehaviorFunctions.CheckEntity(instanceId) then
        return false
    end

    local entity = BehaviorFunctions.GetEntity(instanceId)
    if not entity or not PhotoConfig.CheckEntityIsCanBuild(entity.entityId) then
        return false
    end

    if entity.jointComponent then
        if entity.jointComponent:IsOnJointState() then
            return true
        else
            return not self:BuildIsUnLock(entity.entityId)
        end
    end

    return false
end

function PhotoCtrl:GetBuildingTargetList(tb)
    TableUtils.ClearTable(tb)
    local entities = Fight.Instance.entityManager:GetEntites()
    for _, v in pairs(entities) do
        if self:IsCanSaveBluePrint(v.instanceId) then
            table.insert(tb, v.instanceId)
        end
    end

    return tb
end

function PhotoCtrl:GetCurSelectEntity()
    return self.curSelectInstanceId, self.curSelectDis
end

function PhotoCtrl:GetCurUnLoadEntity()
    return self.curUnLockInstanceId, self.curUnLockDis
end


function PhotoCtrl:BuildIsUnLock(entityId)
    local buildInfo = PhotoConfig.GetBuildInfoByEntityId(entityId)
    
    return mod.BuildCtrl:IsBuildUnLock(buildInfo.build_id)
end

function PhotoCtrl:UnLockEntity(entity)
    if entity.jointComponent then
        if entity.jointComponent:IsOnJointState() then
            local nodes = entity.jointComponent:GetBluePrintNodesData()
            local index = #mod.BuildCtrl.custom_blueprint_list + 1
            local bluePrint = {
                blueprint_id = TimeUtils.GetCurTimestamp(),
                name = "自定义蓝图" .. index,
                image_path = "",
                nodes = nodes,
            }
            LogTable("BluePrint = ", bluePrint)
            mod.BuildCtrl:SaveBluePrint(bluePrint)
        else
            local buildInfo = PhotoConfig.GetBuildInfoByEntityId(entity.entityId)
            mod.BuildFacade:SendMsg("hacking_build_unlock", buildInfo.build_id)
        end
    end
    
    return
end

function PhotoCtrl:GetUnLockPrintList()
    local list = mod.BuildCtrl.unlock_build_list or {}
    local buildList = {}
    --默认解锁的蓝图+已拥有蓝图
    for k, v in pairs(BuildData) do
        if v.condition == 0 then
            table.insert(buildList, v)
        elseif TableUtils.ContainValue(list, v.build_id) then
            table.insert(buildList, v)
        end
    end
    --排序 priority
    table.sort(buildList, function(a, b)
        return a.priority < b.priority
    end)

    return buildList
end