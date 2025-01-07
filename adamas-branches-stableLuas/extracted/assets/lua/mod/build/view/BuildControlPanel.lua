BuildControlPanel = BaseClass("BuildControlPanel", BasePanel, SystemView)

local ScreenW = Screen.width * 0.5
local ScreenH = Screen.height * 0.5
local Vector3 = Vector3
local LineCheckLayer = ~(FightEnum.LayerBit.IgnoreRayCastLayer | FightEnum.LayerBit.Area | FightEnum.LayerBit.InRoom | FightEnum.LayerBit.Entity | FightEnum.LayerBit.EntityCollision)
local BuildData = Config.DataBuild.Find
local BuildDataByEntityId = Config.DataBuild.FindbyInstanceId
local BF = BehaviorFunctions

local BuildModel = {
    Single = 1,
    BluePrint = 2,
    OnlyMove = 3,
}
local RotationClickType = {
    Up = 1, Down = 2, Left = 3, Right = 4
}
local BluePrintType = { Prefab = 1, Custom = 2 }

local SelectedEffect = 1000201
local TipEffect = 1000202

local checkIsBuild = function(instanceId)
    local target = Fight.Instance.entityManager:GetEntity(instanceId)
    if not target then
        return false
    end
    for k, v in pairs(BuildData) do
        if v.instance_id == target.entityId then
            return true, v.build_id
        end
    end
    return false
end

--#region UI操作
function BuildControlPanel:__init(mainView)
    self:SetAsset("Prefabs/UI/Build/BuildControlPanel.prefab")
    self.buildPosition = Vec3.New()

    self.onReqBuild = false
    self.previewDistance = 3
    self.previewDistanceOffset = 0
    self.previewHeight = 0
    self.previewHeightOffset = 0

    self.bluePrintPreViewEntity = {}
    self.AddEffectEntitys = {}
    self.buildModel = BuildModel.OnlyMove
    self.mainView = mainView
    self.isPC = UtilsUI.CheckPCPlatform()
    self.isOnLoad = false
    self.hackingDistance = BF.GetPlayerAttrVal(FightEnum.PlayerAttr.HackingDistance)
    self.isQuit = false
end

function BuildControlPanel:__BindListener()
    EventMgr.Instance:AddListener(EventName.ActionInput, self:ToFunc("OnActionInput"))
    EventMgr.Instance:AddListener(EventName.ActionInputEnd, self:ToFunc("OnActionInputEnd"))
    EventMgr.Instance:AddListener(EventName.QuitBuildState, self:ToFunc("OnQuitBuildState"))
    EventMgr.Instance:AddListener(EventName.RemoveEntity, self:ToFunc("OnBuildRemove"))

    self:__AddUIListener()
    if self.isPC then
        self:SetInputImageChanger()
    end

    self:AddSystemState(SystemStateConfig.StateType.Build)
end

function BuildControlPanel:SetInputImageChanger()

end

function BuildControlPanel:__AddUIListener()
    self:BindCloseBtn(self.CommonBack2_btn, self:ToFunc("Close_HideCallBack"))
    if not self.isPC then
        --self.BuildBtn_btn.onClick:AddListener(self:ToFunc("OnClickBuild"))
        --self.RotationBtn_btn.onClick:AddListener(self:ToFunc("OnSelectRotation"))
        --self.PositionBtn_btn.onClick:AddListener(self:ToFunc("OnSelectPosition"))
        --self.TakeBuildBtn_btn.onClick:AddListener(self:ToFunc("OnSelectTakeEntity"))
        --local dragBehaviour = self.RotationBg.transform:GetComponent(UIDragBehaviour)
        --if not dragBehaviour then
        --    dragBehaviour = self.RotationBg:AddComponent(UIDragBehaviour)
        --end
        --dragBehaviour.onPointerDown = function(data)
        --    self:OnClickRotation(data)
        --end
        --dragBehaviour.onPointerUp = function(data)
        --    self:OnClickRotationCancel(data)
        --end
        ----------------------
        --local DragFun = function(instance, obj, funName)
        --    local objDrag = obj:GetComponent(UIDragBehaviour) or obj:AddComponent(UIDragBehaviour)
        --    objDrag.onPointerDown = function(data)
        --        instance[funName](instance, true)
        --    end
        --    objDrag.onPointerUp = function(data)
        --        instance[funName](instance, false)
        --    end
        --end
        --
        --DragFun(self, self.Forward, "OnTouchPositionForward")
        --DragFun(self, self.After, "OnTouchPositionBack")
        --DragFun(self, self.AddHeight, "OnTouchPositionAddHeight")
        --DragFun(self, self.SubHeight, "OnTouchPositionSubHeight")
    end

end

function BuildControlPanel:__delete()
    self.curBuildconfig = nil
    EventMgr.Instance:RemoveListener(EventName.ActionInput, self:ToFunc("OnActionInput"))
    EventMgr.Instance:RemoveListener(EventName.ActionInputEnd, self:ToFunc("OnActionInputEnd"))
    EventMgr.Instance:RemoveListener(EventName.QuitBuildState, self:ToFunc("OnQuitBuildState"))
    EventMgr.Instance:RemoveListener(EventName.RemoveEntity, self:ToFunc("OnBuildRemove"))
end

function BuildControlPanel:OnActionInput(key, value)
    if key == FightEnum.KeyEvent.RollUp then
        self:OnClickRotationUp(true)
    elseif key == FightEnum.KeyEvent.RollDown then
        self:OnClickRotationDown(true)
    elseif key == FightEnum.KeyEvent.RollLeft then
        self:OnClickRotationLeft(true)
    elseif key == FightEnum.KeyEvent.RollRight then
        self:OnClickRotationRight(true)
    elseif key == FightEnum.KeyEvent.TurnForward then
        if self.isPC then
            self:OnTouchPositionValue(value.y)
        end
    elseif key == FightEnum.KeyEvent.Back then
        self:OnCancelBuild()
    elseif key == FightEnum.KeyEvent.SelectModeIn then
        if self.buildModel == BuildModel.OnlyMove then
            self:OnSelectTakeEntity()
        else
            self:OnClickBuild()
        end
    elseif key == FightEnum.KeyEvent.RemoveJoint then
        self:OnCancelJoint()
    elseif key == FightEnum.KeyEvent.CancelSelect then
        self:OnCancelBuild()
    elseif key == FightEnum.KeyEvent.DisablePlayerMove then
        self:DisablePlayerMove(true)
    end
end

function BuildControlPanel:OnActionInputEnd(key, value)
    if key == FightEnum.KeyEvent.RollUp then
        self:OnClickRotationUp(false)
    elseif key == FightEnum.KeyEvent.RollDown then
        self:OnClickRotationDown(false)
    elseif key == FightEnum.KeyEvent.RollLeft then
        self:OnClickRotationLeft(false)
    elseif key == FightEnum.KeyEvent.RollRight then
        self:OnClickRotationRight(false)
    elseif key == FightEnum.KeyEvent.DisablePlayerMove then
        self:DisablePlayerMove(false)
    end
end

function BuildControlPanel:__CacheObject()
    self:SetCacheMode(UIDefine.CacheMode.Destroy)
end

function BuildControlPanel:__Create()

end

function BuildControlPanel:__Hide()
    if self.selectModeTarget then
        local oldTarget = BF.GetEntity(self.selectModeTarget)
        if oldTarget then
            BF.RemoveBuff(oldTarget.instanceId, SelectedEffect)
        end
        self.selectModeTarget = nil
    end
    if self.buildModel == BuildModel.OnlyMove then
        self.buildController:OnCancelTake()
        if BehaviorFunctions.CheckEntityState(self.ctrlEntity.instanceId, FightEnum.EntityState.Build) then
            self.ctrlEntity.stateComponent:SetBuildState(FightEnum.EntityBuildState.BuildEnd)
        end
    else
        self.buildController:OnQuitControl()
    end
    self:RemoveCanControlEffect()
    self.buildController = nil
    self:DisablePlayerMove(false)
    BehaviorFunctions.SetClimbEnable(true)
end

function BuildControlPanel:__Show()
    SystemStateMgr.Instance:SetCameraState(SystemStateConfig.StateType.Build, FightEnum.CameraState.Building)
    self.ctrlEntity = Fight.Instance.playerManager:GetPlayer():GetCtrlEntityObject()
    local camera = CameraManager.Instance:GetCamera(FightEnum.CameraState.Building)
    camera:SetMainTarget(self.ctrlEntity.clientTransformComponent:GetTransform("CameraTarget"))
    BF.DoEntityAudioPlay(self.ctrlEntity.instanceId, "ChongGou_Enter",false)--音效
    --TODO 屏蔽攀爬，临时这么写
    BehaviorFunctions.SetClimbEnable(false)
    self.curCtrlInstanceId = self.ctrlEntity.instanceId
    BehaviorFunctions.DoSetEntityState(self.ctrlEntity.instanceId, FightEnum.EntityState.Build)

    ---@type BuildController
    self.buildController = Fight.Instance.clientFight.buildManager:GetBuildController()
    if self.args.buildId then
        self.ctrlEntity.stateComponent:SetBuildState(FightEnum.EntityBuildState.BuildStart)
        camera:ChangeToBuild()
        self.buildModel = self.args.type == FightEnum.BuildType.Single and BuildModel.Single or BuildModel.BluePrint
        self.buildController:LoadBuildEntity(self.args.buildId, self.buildModel)
        self.SelectedPoint:SetActive(false)
    else
        camera:ChangeToSelect()
        self.buildModel = BuildModel.OnlyMove
        self.SelectedPoint:SetActive(true)
    end
end

function BuildControlPanel:__ShowComplete()
end

--TODO 处理手机端旋转
function BuildControlPanel:OnClickRotation(data)
    --local uiCamera = ctx.UICamera
    --local spPoint = uiCamera:WorldToScreenPoint(self.RotationBg.transform.position)
    --
    --local ClickVec = Vec3.New(data.position.x - spPoint.x, data.position.y - spPoint.y, 0)
    --local angle = Vec3.Angle(Vec3.up, ClickVec)
    --
    --if angle < 45 then
    --    self.ClickRotationType = RotationClickType.Up
    --    self:OnClickRotationUp(true)
    --elseif angle >= 45 and angle < 135 then
    --    if ClickVec.x < 0 then
    --        self.ClickRotationType = RotationClickType.Left
    --        self:OnClickRotationLeft(true)
    --    else
    --        self.ClickRotationType = RotationClickType.Right
    --        self:OnClickRotationRight(true)
    --    end
    --else
    --    self.ClickRotationType = RotationClickType.Down
    --    self:OnClickRotationDown(true)
    --end
end

function BuildControlPanel:OnClickRotationCancel()
    if self.ClickRotationType == RotationClickType.Up then
        --self:OnClickRotationUp(false)
    elseif self.ClickRotationType == RotationClickType.Left then
        --self:OnClickRotationLeft(false)
    elseif self.ClickRotationType == RotationClickType.Right then
        --self:OnClickRotationRight(false)
    elseif self.ClickRotationType == RotationClickType.Down then
        --self:OnClickRotationDown(false)
    end
end
--#endregion

--#region 建造预览
function BuildControlPanel:Update()
    if self.buildModel == BuildModel.OnlyMove and not self.takeEntity then
        --当前未抓取时，寻找瞄准的实体
        --已抓取时，寻找可连接点
        self:UpdateSelectMode()
    end
    self:UpdateCanControlEffect()
    --
    ----更新建造预览挂点的位置和旋转
    --self:UpdateBuildInfo()
end

function BuildControlPanel:UpdateSelectMode()
    --未选中目标时，发射射线进行检测，选中命中的实体
    self.hackingSelectedRange = 0.1 + 0.0001

    local id = Fight.Instance.clientFight.buildManager:GetBuildingTarget(self.hackingSelectedRange, self.hackingDistance, "HackPoint")
    --更新目标的特效表现
    if id ~= self.selectModeTarget then
        if self.selectModeTarget then
            local oldTarget = BF.GetEntity(self.selectModeTarget)
            if oldTarget and oldTarget.jointComponent then
                BF.RemoveBuff(oldTarget.instanceId, SelectedEffect)
                BF.DoMagic(1, oldTarget.instanceId, TipEffect)
                self.AddEffectEntitys[oldTarget.instanceId] = true
            end
        end
        if id then
            local newTarget = BF.GetEntity(id)
            if newTarget and newTarget.jointComponent then
                BF.RemoveBuff(newTarget.instanceId, TipEffect)
                BF.DoMagic(1, newTarget.instanceId, SelectedEffect)
            end
        end
        self.selectModeTarget = id
    end
end

--抓取模式下选中抓取物
function BuildControlPanel:OnSelectTakeEntity()
    if self.selectModeTarget and not self.takeEntity then
        local takeEntity = BF.GetEntity(self.selectModeTarget)
        if takeEntity then
            self.buildController:SetBuild(takeEntity)
            Fight.Instance.entityManager:CallBehaviorFun("OnTakeBuilding", takeEntity.instanceId, true)
            self.takeEntity = takeEntity
            self.SelectedPoint:SetActive(false)
            self.ctrlEntity.stateComponent:SetBuildState(FightEnum.EntityBuildState.BuildStart)
            BF.DoEntityAudioPlay(self.ctrlEntity.instanceId, "ChongGou_Catch",false)--音效
        end
    elseif self.takeEntity then
        self:OnClickBuild()
    end
end

function BuildControlPanel:InitPreviewDistance()
    local hitList = CustomUnityUtils.GetScreenRayWorldHits(CameraManager.Instance.mainCameraComponent, ScreenW, ScreenH, self.previewDistance, LineCheckLayer)
    local minDistance = self.previewDistance
    if hitList and hitList.Length > 0 then
        for i = 0, hitList.Length - 1 do
            if hitList[i].distance < minDistance then
                minDistance = hitList[i].distance
            end
        end
    end
    self.previewDistance = minDistance
end

function BuildControlPanel:OnUnSelectBuilding()
    if self.previewEntity then
        BF.RemoveBuffByKind(self.previewEntity.instanceId, 1010)
        Fight.Instance.entityManager:RemoveEntity(self.previewEntity.instanceId)
        self.previewEntity = nil
    end
end

function BuildControlPanel:UpdateCanControlEffect()
    local entites = BehaviorFunctions.fight.entityManager:GetEntites()
    local centerPos = self.ctrlEntity.transformComponent.position
    for _instanceId, v in pairs(entites) do
        if not self.AddEffectEntitys[_instanceId] and v.jointComponent and _instanceId ~= self.ctrlEntity.instanceId and self.selectModeTarget ~= _instanceId then
            if Vec3.SquareDistance(v.transformComponent.position, centerPos) < 2500 and not v.buffComponent:HasBuffKind(TipEffect) then
                BF.DoMagic(1, _instanceId, TipEffect)
                self.AddEffectEntitys[_instanceId] = true
            end
        end
    end
end

function BuildControlPanel:RemoveCanControlEffect()
    for k, v in pairs(self.AddEffectEntitys) do
        local entity = Fight.Instance.entityManager:GetEntity(k)
        if entity then
            entity.buffComponent:RemoveBuffByBuffId(TipEffect)
        end
    end
    TableUtils.ClearTable(self.AddEffectEntitys)
end
--#endregion

--#region 点击建造按钮
function BuildControlPanel:OnClickBuild()
    if self.onReqBuild then
        return
    end
    local args = self.args
    local buildCallback = function()
        if not self.ctrlEntity then
            self.ctrlEntity = Fight.Instance.playerManager:GetPlayer():GetCtrlEntityObject()
        end
        self.ctrlEntity.stateComponent:SetBuildState(FightEnum.EntityBuildState.BuildEnd)
        mod.BuildCtrl:AddUseTime(args.buildId)
        mod.BuildCtrl:UpdateUseHistory(args.buildId)
        self.onReqBuild = false
        self.buildController:OnBuild()
        Fight.Instance.clientFight.buildManager:CloseBuildControlPanel()
    end

    if self.buildModel == BuildModel.Single then
        self.onReqBuild = true
        Fight.Instance.clientFight.buildManager:ReqBuildSingle(self.args.buildId, buildCallback)
    elseif self.buildModel == BuildModel.BluePrint then
        self.onReqBuild = true
        Fight.Instance.clientFight.buildManager:ReqBuildBluePrint(self.args.buildId, BluePrintType.Custom, buildCallback)
    elseif self.buildModel == BuildModel.OnlyMove then
        self.buildController:OnBuild()
        self:OnStopTake()
    end
end

function BuildControlPanel:OnCancelBuild()
    self.isQuit = true
    if self.buildModel == BuildModel.OnlyMove then
        self:OnStopTake()
    else
        self.buildController:OnQuitControl()
        Fight.Instance.clientFight.buildManager:CloseBuildControlPanel()
        local buildManager = Fight.Instance.clientFight.buildManager
        buildManager:OpenBluePrintWindow()
    end
end

function BuildControlPanel:OnStopTake()
    if self.buildModel == BuildModel.OnlyMove then
        self.buildController:OnCancelTake()
        if self.takeEntity then
            Fight.Instance.entityManager:CallBehaviorFun("OnExitTakeBuilding", self.takeEntity.instanceId, true)
        end
        BF.DoEntityAudioPlay(self.ctrlEntity.instanceId, "ChongGou_Quit",false)--音效
        BehaviorFunctions.DoSetEntityState(self.ctrlEntity.instanceId, FightEnum.EntityState.Idle)
        Fight.Instance.clientFight.buildManager:CloseBuildControlPanel()
        return
    end
end

function BuildControlPanel:OnCancelJoint()
    if self.buildModel == BuildModel.OnlyMove then
        self.buildController:CancelAllJoint()
    end
end

--根据蓝图建造（修改碰撞层级，移除多余特效，播放建造特效）
function BuildControlPanel:OnBuildBluePrint()
    local buildCallback = function()
        TableUtils.ClearTable(self.bluePrintPreViewEntity)
        self.curBluePrintId = nil
    end

    local data = {
        type = self.curBluePrintType,
        blueprint_id = self.curBluePrintId,
    }
    local id, cmd = mod.HackingFacade:SendMsg("blueprint_set", data)
    mod.LoginCtrl:AddClientCmdEvent(id, cmd, function()
        buildCallback()
    end)
    self.curBluePrintId = nil
end
--#endRegion

local UpQ = Quaternion.Euler(45, 0, 0)
local DownQ = Quaternion.Euler(-45, 0, 0)
local LeftQ = Quaternion.Euler(0, 45, 0)
local RightQ = Quaternion.Euler(0, -45, 0)
function BuildControlPanel:OnClickRotationUp(isTouch)
    if isTouch then
        self.buildController:RotatePreviewPoint(UpQ, 1, 0)
    end
end

function BuildControlPanel:OnClickRotationDown(isTouch)
    if isTouch then
        self.buildController:RotatePreviewPoint(DownQ, -1, 0)
    end
end

function BuildControlPanel:OnClickRotationLeft(isTouch)
    if isTouch then
        self.buildController:RotatePreviewPoint(LeftQ, 0, 1)
    end
end

function BuildControlPanel:OnClickRotationRight(isTouch)
    if isTouch then
        self.buildController:RotatePreviewPoint(RightQ, 0, -1)
    end
end

function BuildControlPanel:OnTouchPositionForward(isTouch)
    self.buildController:SetPreviewPointDistanceOffset(isTouch and 0.05 or 0)
end

function BuildControlPanel:OnTouchPositionBack(isTouch)
    self.buildController:SetPreviewPointDistanceOffset(isTouch and -0.05 or 0)
end

function BuildControlPanel:OnTouchPositionValue(value)
    local offset = self.buildController.previewDistanceOffset * value < 0 and 0 or self.buildController.previewDistanceOffset
    offset = offset + value / 360 * 1
    self.buildController:SetPreviewPointDistanceOffset(offset)
end

function BuildControlPanel:OnTouchPositionAddHeight(isTouch)
    self.buildController:SetPreviewPointHeightOffset(isTouch and 0.05 or 0)
end

function BuildControlPanel:OnTouchPositionSubHeight(isTouch)
    self.buildController:SetPreviewPointHeightOffset(isTouch and -0.05 or 0)
end

function BuildControlPanel:OnSelectRotation()
end

function BuildControlPanel:OnSelectPosition()
end

function BuildControlPanel:DisablePlayerMove(isDisable)
    BF.SetFightMainNodeVisible(2, "Joystick", not isDisable)
end

function BuildControlPanel:OnQuitBuildState()
    if not self.isQuit then
        self.isQuit = true
        if self.buildModel == BuildModel.OnlyMove then
            self:OnStopTake()
        else
            self.buildController:OnQuitControl()
            Fight.Instance.clientFight.buildManager:CloseBuildControlPanel()
        end
    end
end

function BuildControlPanel:OnBuildRemove(instanceId)
    if self.takeEntity and self.takeEntity.instanceId == instanceId then
        self:OnCancelBuild()
    end
end

function BuildControlPanel:Close_HideCallBack()
    Fight.Instance.clientFight.buildManager:CloseBuildControlPanel()
end

--打开界面时，判断玩家当前状态，如果不是在建造则进入建造状态
--退出界面时，先做完动作再退出
--取消建造时，不退出建造状态

--移动由fsm哪边管理，这边只是切状态播动作

