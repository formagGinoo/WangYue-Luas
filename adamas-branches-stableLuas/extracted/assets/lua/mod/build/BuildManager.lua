---@class BuildManager
BuildManager = BaseClass("BuildManager")

local BF = BehaviorFunctions
local BuildData = Config.DataBuild.Find
local BuildDataByEntityId = Config.DataBuild.FindbyInstanceId
local NotAllowBuildEffect = 200001006

function BuildManager:__init()
    self.worldBuildList = {}
    self.recordTemp = {}

    self.buildController = BuildController.New()
    self:AddListener()
end

function BuildManager:StartFight()
    self.buildController:StartFight()
end

function BuildManager:ReqBuildSingle(build_id, func)
    local id, cmd = mod.BuildFacade:SendMsg("hacking_build", build_id)
    mod.LoginCtrl:AddClientCmdEvent(id, cmd, function()
        func()
    end)
end

function BuildManager:ReqBuildBluePrint(blueprint_id, type, func)
    local id, cmd = mod.BuildFacade:SendMsg("blueprint_set", { type = type, blueprint_id = blueprint_id})
    mod.LoginCtrl:AddClientCmdEvent(id, cmd, function()
        func()
    end)
end

function BuildManager:ReqUnlockBluePrint(blueprint_id, func)
    local id, cmd = mod.BuildFacade:SendMsg("blueprint_unlock", blueprint_id)
    mod.LoginCtrl:AddClientCmdEvent(id, cmd, function()
        func()
    end)
end

function BuildManager:AddListener()
    EventMgr.Instance:AddListener(EventName.RemoveEntity, self:ToFunc("OnBuildRemove"))
    EventMgr.Instance:AddListener(EventName.OnEntityTimeoutDeath, self:ToFunc("OnEntityTimeoutDeath"))
    EventMgr.Instance:AddListener(EventName.CreateEntity, self:ToFunc("OnCreateEntity"))
end

--检查新的Entity是否为可建造物
function BuildManager:OnCreateEntity(instanceId)
    local entity = BF.GetEntity(instanceId)
    if entity.jointComponent then
        table.insert(self.worldBuildList, { instanceId = instanceId })
        --if not entity.jointComponent.jointCtrl then
        --    local ctrl = Fight.Instance.objectPool:Get(BaseJointCtrl)
        --    ctrl:Init(Fight.Instance, entity)
        --end
    end
end

--检查新的Entity是否为可建造物
function BuildManager:GetWorldBuildList()
    return self.worldBuildList
end

function BuildManager:OnEntityTimeoutDeath(instanceId)
    local entity = Fight.Instance.entityManager:GetEntity(instanceId)

    for _, data in pairs(BuildData) do
        if entity.entityId == data.instance_id then
            BF.DoMagic(1, entity.instanceId, data.destroy_magic)
            break
        end
    end
end

--建造物被销毁时，从记录中移除
function BuildManager:OnBuildingTimeout(instanceId)
    --激活退场动画
    local entity = Fight.Instance.entityManager:GetEntity(instanceId)
    BF.RemoveBuffByKind(entity.instanceId, 1010)
    BF.DoMagic(1, entity.instanceId, BuildData[BuildDataByEntityId[entity.entityId][1]].destroy_magic)
    EventMgr.Instance:Fire(EventName.RemoveHackingBuild)
    entity.jointComponent:CancelJointToParent()
    entity.jointComponent:DestroyAllChild()
    --销毁实体
    entity.timeoutDeathComponent.removeDelayFrame = 30
    entity.timeoutDeathComponent:SetDeath()
end

function BuildManager:OnBuildRemove(instanceId)
    for k, v in pairs(self.worldBuildList) do
        if v.instanceId == instanceId then
            table.remove(self.worldBuildList, k)
        end
    end
end

function BuildManager:__delete()
    EventMgr.Instance:RemoveListener(EventName.RemoveEntity, self:ToFunc("OnBuildRemove"))
    EventMgr.Instance:RemoveListener(EventName.OnEntityTimeoutDeath, self:ToFunc("OnEntityTimeoutDeath"))
    self.buildController:DeleteMe()
    self.buildController = nil
end

-----------------------------  选择模式----------------------------------
function BuildManager:GetBuildComponent(id)
    id = id
    if not id or not BehaviorFunctions.CheckEntity(id) then
        return
    end

    local entity = BehaviorFunctions.GetEntity(id)
    if not entity then
        return
    end
    if entity.timeoutDeathComponent and entity.timeoutDeathComponent.isDeath then
        return
    end

    return entity.jointComponent
end

function BuildManager:IsBuildEnable(id)
    local component = self:GetBuildComponent(id)
    if not component then
        return false
    end

    return true
end

function BuildManager:GetEntityBuildingTransform(instanceId, boneName)
    local entity = BehaviorFunctions.GetEntity(instanceId)
    if not entity or not entity.clientTransformComponent then
        return
    end

    local transform = entity.clientTransformComponent:GetTransform(boneName)
    if not transform then
        transform = entity.clientTransformComponent:GetTransform()
    end
    return transform
end

function BuildManager:GetBuildingTarget(viewPortRange, worldRange, boneName)
    local cameraState = BehaviorFunctions.fight.clientFight.cameraManager.states[FightEnum.CameraState.Hacking]
    local cameraDistance = cameraState:GetCameraDistance()
    local camera = Fight.Instance.clientFight.cameraManager:GetMainCameraTransform()

    local distance = cameraDistance + worldRange
    local idList, count = CS.CustomUnityUtils.GetRaycastEntity(camera.position, camera.rotation * Vector3.forward,
            distance, FightEnum.LayerBit.AirWall | FightEnum.LayerBit.Entity)

    if count == 0 then
        return
    end

    local minSquareDis = distance^2
    local ctrlId = Fight.Instance.playerManager:GetPlayer():GetCtrlEntity()
    local playerTransform = self:GetEntityBuildingTransform(ctrlId, boneName)

    local checkHaveBuff = function(name)
        if BehaviorFunctions.CheckEntity(name) then
            return BehaviorFunctions.HasBuffKind(name, 200001150)
        end
    end

    local id
    for i = 0, count - 1 do
        local curId = idList[i]
        if curId ~= ctrlId then
            if self:IsBuildEnable(curId) or checkHaveBuff(curId) then
                local targetTransform = self:GetEntityBuildingTransform(curId, boneName)
                local squareDis = Vec3.SquareDistance(targetTransform.position, playerTransform.position)
                if squareDis < minSquareDis then
                    id = curId
                    minSquareDis = squareDis
                end
            end
        end
    end

    return id
end

function BuildManager:OpenBluePrintWindow()
    WindowManager.Instance:OpenWindow(SelectBluePrintWindow)
end

function BuildManager:OpenBuildControlPanel(buildId, type)
    --记录进入前数据
    SystemStateMgr.Instance:AddState(SystemStateConfig.StateType.Build, buildId, type)
end

function BuildManager:TempOpenBuildControlPanel(buildId, type)
    self.oldCameraState = BehaviorFunctions.GetCameraState()
    self.lastInputActionMap = InputManager.Instance:GetNowActionMapName()

    InputManager.Instance:AddLayerCount("Build")
    --切换玩家状态
    local ctrlId = BehaviorFunctions.fight.playerManager:GetPlayer():GetCtrlEntity()

    --切换相机
    -- BehaviorFunctions.SetFightPanelVisible("100010000")
    SystemStateMgr.Instance:SetFightVisible(SystemStateConfig.StateType.Build, "100010000")

    local mainUI = WindowManager.Instance:GetWindow("FightMainUIView")
    self.buildControlPanel = mainUI:OpenPanel(BuildControlPanel, { buildId = buildId, type = type })
end

function BuildManager:CloseBuildControlPanel()
    local ctrlEntity = BehaviorFunctions.fight.playerManager:GetPlayer():GetCtrlEntityObject()
    BehaviorFunctions.SetCameraState(self.oldCameraState)
    -- BehaviorFunctions.SetFightPanelVisible("-1")

    local mainUI = WindowManager.Instance:GetWindow("FightMainUIView")
    mainUI:ClosePanel(BuildControlPanel)
    self.buildControlPanel = nil
    InputManager.Instance:MinusLayerCount("Build")
    Fight.Instance.entityManager:CallBehaviorFun("OnExitBuilding")

    SystemStateMgr.Instance:RemoveState(SystemStateConfig.StateType.Build)
end

function BuildManager:GetBuildController()
    return self.buildController
end


function BuildManager:Update(lerp)
    self.buildController:Update(lerp)
end

function BuildManager:OpenBuildConsolePanel(instanceId)
    BehaviorFunctions.SetFightPanelVisible("100010000")
    local mainUI = WindowManager.Instance:GetWindow("FightMainUIView")
    self.buildConsolePanel = mainUI:OpenPanel(BuildConsolePanel, {ConsoleId = instanceId})
    InputManager.Instance:AddLayerCount("Drone")
end

function BuildManager:CloseBuildConsolePanel(consoleId)
    --local mainUI = WindowManager.Instance:GetWindow("FightMainUIView")
    --mainUI:ClosePanel(self.buildConsolePanel)
    self.buildConsolePanel = nil
    BehaviorFunctions.SetFightPanelVisible("-1")
    InputManager.Instance:MinusLayerCount("Drone")
    local curConsole = BehaviorFunctions.GetEntity(consoleId)
    if curConsole then
        curConsole:CallBehaviorFun("OnQuitBuildConsolePanel", consoleId)
    end
end

function BuildManager:CheckEntityOnBuildControl(instanceId)
    return self.buildController:CheckEntityOnBuildControl(instanceId)
end