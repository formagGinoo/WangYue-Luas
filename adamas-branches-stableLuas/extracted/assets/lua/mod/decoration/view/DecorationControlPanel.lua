DecorationControlPanel = BaseClass("DecorationControlPanel", BasePanel, SystemView)
local DataPartnerMain =  Config.DataPartnerMain.Find
local BF = BehaviorFunctions
local SelectedEffect = 200001004
function DecorationControlPanel:__init(parent)
    self:SetAsset("Prefabs/UI/Decoration/DecorationControlPanel.prefab")
    self.parentUi = parent
    self.selectDecorations = false
    self.curId = 0
    self.curDecoration = nil
    self.selectDecoration = nil
    self.lastDecoration = nil
    self.curCtrlInstanceId = nil
    self.isPC = UtilsUI.CheckPCPlatform()
    self.hackingDistance = BF.GetPlayerAttrVal(FightEnum.PlayerAttr.HackingDistance)
    self.type = nil
    self.lastPos = nil
    self.lastRot = nil
    self.curCastObject = nil
    self.selectCastObject = nil
    self.curPanleType = false
    self.headIcoList = {}
    self.isTake = false
    self.RoelEntity = nil
    self.savePos = {}
end

function DecorationControlPanel:__Show()
   self:Init()
end

function DecorationControlPanel:__BindListener()
    self:AddSystemState(SystemStateConfig.StateType.Decoration)
    EventMgr.Instance:AddListener(EventName.ActionInput, self:ToFunc("OnActionInput"))
    EventMgr.Instance:AddListener(EventName.ActionInputEnd, self:ToFunc("OnActionInputEnd"))
    self.CloseBtn_btn.onClick:AddListener( self:ToFunc("ClosePanel"))
    
end

function DecorationControlPanel:Update()
   if not self.selectDecoration   then
    self:UpdateSelectDecoration()
   end
end

function DecorationControlPanel:Init()
    self.curPanleType = false
    local curInstanceId = BF.GetCtrlEntity()
    self.RoelEntity = BF.GetEntity(curInstanceId)
    --隐藏鼠标
    Fight.Instance.clientFight.decorationManager:HideMouseCursor()
    -- mod.GmCtrl:DisPlayMouse()
    Fight.Instance.entityManager:CheckTriggerComponnet(BehaviorFunctions.GetCtrlEntity())
    
    SystemStateMgr.Instance:SetCameraState(SystemStateConfig.StateType.Decoration, FightEnum.CameraState.Building)
    self.ctrlEntity = Fight.Instance.playerManager:GetPlayer():GetCtrlEntityObject()
    local camera = CameraManager.Instance:GetCamera(FightEnum.CameraState.Building)
    camera:SetMainTarget(self.ctrlEntity.clientTransformComponent:GetTransform("CameraTarget"))
    self.decorationController = Fight.Instance.clientFight.decorationManager:GetDecorationController()
    --初始化根据传入的参数编辑/放置界面
    if self.args.type == DecorationConfig.decorationType.create then
        camera:ChangeToSelect()
        self.ControlPanel:SetActive(true)
        self.EditorPanel:SetActive(false)
        local config = mod.DecorationCtrl:GetDecorationConfig(self.args.decorationId)
        local entityid = config.entity_id
        self.isTake = true
        if entityid and entityid>0 then
            self.decorationController:LoadDecorationEntity(entityid,self.args.type)
            --显示Tips
            self:OnShowTips(config)
        else
            LogError("物件实体id为空,id:"..entityid)
        end
    elseif self.args.type == DecorationConfig.decorationType.editor then
        self.isTake = false
        camera:ChangeToSelect()
        self.ControlPanel:SetActive(false)
        self.EditorPanel:SetActive(true)
    end
    self.type = self.args.type
    BehaviorFunctions.DoSetEntityState(self.ctrlEntity.instanceId, FightEnum.EntityState.Build)
    self.ctrlEntity.stateComponent:SetBuildState(FightEnum.EntityBuildState.BuildStart)
    BehaviorFunctions.SetClimbEnable(false)

    self.curCtrlInstanceId = self.ctrlEntity.instanceId
end

function DecorationControlPanel:UpdateSelectDecoration()
    if self.isTake and self.curDecoration then
        return
    end
    self:ClearSelect()
    --射线检测物件
    local camera = Fight.Instance.clientFight.cameraManager:GetMainCameraTransform()
    local idList, count = CS.CustomUnityUtils.GetRaycastEntity(camera.position, camera.rotation * Vector3.forward,
    self.hackingDistance, FightEnum.LayerBit.EntityCollision)
    if count>0 then
        local newTarget = BF.GetEntity(idList[0])
        if newTarget.entityId ~= self.RoelEntity.entityId  then
            if not self.curDecoration then
                self.curDecoration = newTarget
                local info = mod.DecorationCtrl:GetEntityDecorationInfo(self.curDecoration.instanceId)
                self:UpdateTipInfo(info)
                self.curCastObject = nil
                BehaviorFunctions.DoMagic(1, newTarget.instanceId, SelectedEffect)
                return
            elseif self.curDecoration.instanceId~= newTarget.instanceId and (not self.isTake) then
                if self.curDecoration.instanceId > 0 then
                    BehaviorFunctions.RemoveBuff(self.curDecoration.instanceId, SelectedEffect)
                end
                self.curDecoration = newTarget
                local info = mod.DecorationCtrl:GetEntityDecorationInfo(self.curDecoration.instanceId)
                self:UpdateTipInfo(info)
                self.curCastObject = nil
                BehaviorFunctions.DoMagic(1, newTarget.instanceId, SelectedEffect)
                return
            else
                return
            end
        end
    elseif (count<1 or count==nil) and (not self.isTake) then
        if self.curDecoration and self.curDecoration.instanceId>0 then
            BehaviorFunctions.RemoveBuff(self.curDecoration.instanceId, SelectedEffect)
            self.DecorationEditorInfo:SetActive(false)
        self.curDecoration = nil
        end
    end
end

function DecorationControlPanel:UpdateTipInfo (info)
    if not info then
        return
    end
    for k, v in pairs(self.headIcoList) do
        self:PushUITmpObject("HeadIconItem",v,self.Headicon_rect)
    end
    local config = mod.DecorationCtrl:GetDecorationConfig(info.template_id)
    self.DecorationEditorInfo:SetActive(true)
    local assetId = mod.AssetPurchaseCtrl:GetCurAssetId()
    local newInfo = mod.AssetPurchaseCtrl:GetDevicePartnerList(assetId,info.id)
    if newInfo then
        for key, uniqueId in pairs(newInfo) do
            local partnerData = mod.BagCtrl:GetPartnerData(uniqueId)
            local partnerId = partnerData.template_id
            local obj =  self:PopUITmpObject("HeadIconItem", self.Headicon_rect)
            table.insert(self.headIcoList,obj) 
            obj.object.gameObject:SetActive(true)
            local iconPath = DataPartnerMain[partnerId].chead_icon
            SingleIconLoader.Load(obj.Icon,iconPath)
        end
    end
   
    self.CurWorkText_txt.text ="当前工作:"..config.desc
    self.WorkContentText_txt.text = config.desc
    self.TipTitleText_txt.text = config.name
end

function DecorationControlPanel:OnActionInput(key, value)
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
        if self.type ~= DecorationConfig.decorationType.create then
            self:ReturnMainPanel()
        else
            self:OnCancelBuild()
        end
    elseif key == FightEnum.KeyEvent.SelectModeIn then
        self:OnClickBuild()
    elseif key == FightEnum.KeyEvent.CancelSelect then
        self:OnCancelBuild()
    elseif key == FightEnum.KeyEvent.DisablePlayerMove then
        self:DisablePlayerMove(true)
    elseif key == FightEnum.KeyEvent.TakeIn then
        if self.type ~= DecorationConfig.decorationType.create then
            self:OnClickTakeIn()
        end
    elseif key == FightEnum.KeyEvent.RemoveJoint then
        if self.type ~= DecorationConfig.decorationType.create then
            self:OnClickLayUp()
        end
    end
end

function DecorationControlPanel:OnActionInputEnd(key, value)
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

function DecorationControlPanel:OnClickBuild()
    --放置
    if self.type == DecorationConfig.decorationType.create then
        if not self.decorationController.curControlEntity then
            return
        end
        --local obj = self.decorationController.curControlEntity.clientTransformComponent.gameObject
        local list ={self.decorationController.curControlEntity.instanceId}
        if not self.decorationController:CheckIsCanPut(list) then
            return
        end
        --mod.DecorationCtrl:SetMeshColliders(obj,true)
        local info = mod.DecorationCtrl.curDecorationInfo
        if info and self.decorationController.curEntityTransform  then
            local id = info.id
            local pos = self.decorationController.curEntityTransform.position
            local rot = self.decorationController.curEntityTransform.rotation.eulerAngles
            local posinfo = string.format("pos(%f,%f,%f)_rot(%f,%f,%f)",pos.x,pos.y-0.5,pos.z,rot.x,rot.y,rot.z)
            --先保存起来，统一发送
            info.pos_info = posinfo
            mod.DecorationCtrl:AddSaveData(info)
            self.decorationController:OnBuild(info)
            self.curDecoration = nil
            self.InforBar:SetActive(false)
            self.savePos[info.id] = nil
        else
            LogError("数据丢失")
        end
        if self.curPanleType then
            --切换回
            self.ControlPanel:SetActive(false)
            self.EditorPanel:SetActive(true)
        else
            self:ClosePanel()
            --SystemStateMgr.Instance:RemoveState(SystemStateConfig.StateType.Decoration)
        end
        self.type = nil
        self.isTake = false
        SoundManager.Instance:PlaySound("ChongGou_Quit")
    end
end

local UpQ = Quaternion.Euler(45, 0, 0)
local DownQ = Quaternion.Euler(-45, 0, 0)
local LeftQ = Quaternion.Euler(0, 45, 0)
local RightQ = Quaternion.Euler(0, -45, 0)

--旋转移动操作（目前只需要绕y轴旋转）
function DecorationControlPanel:OnClickRotationUp(isTouch)
    if isTouch then
        --self.decorationController:RotatePreviewPoint(UpQ, 1, 0)
    end
end

function DecorationControlPanel:OnClickRotationDown(isTouch)
    if isTouch then
        --self.decorationController:RotatePreviewPoint(DownQ, -1, 0)
    end
end

function DecorationControlPanel:OnClickRotationLeft(isTouch)
    if isTouch then
        self.decorationController:RotatePreviewPoint(LeftQ, 0, 1)
    end
    self.decorationController:SetRotateOff(isTouch)
end

function DecorationControlPanel:OnClickRotationRight(isTouch)
    if isTouch then
        self.decorationController:RotatePreviewPoint(RightQ, 0, -1)
    end
    self.decorationController:SetRotateOff(isTouch)
end

function DecorationControlPanel:OnTouchPositionValue(value)
    local offset = self.decorationController.previewDistanceOffset * value < 0 and 0 or self.decorationController.previewDistanceOffset
    offset = offset + value / 360 * 1
    self.decorationController:SetPreviewPointDistanceOffset(offset)
end

function DecorationControlPanel:ReturnMainPanel()
    if self.curDecoration and self.curDecoration.instanceId>0  then
        BehaviorFunctions.RemoveBuff(self.curDecoration.instanceId, SelectedEffect)
        self.curDecoration = nil
    end
    if self.active then
        Fight.Instance.clientFight.decorationManager:CloseDecorationControlPanel()
    end
end

function DecorationControlPanel:OnCancelBuild()
    if self.type == DecorationConfig.decorationType.create then
        local count = 0
        for k,v in pairs(self.savePos) do
            count = count + 1
        end
        if count>0 then
            local config = mod.DecorationCtrl:GetEntityDecorationInfo(self.curDecoration.instanceId)
            config.pos_info = self.savePos[config.id].pos_info
            mod.DecorationCtrl:SendChangeDecoration(config.id,self.savePos[config.id].pos_info)
            self.decorationController:OnBuild(config,-1)
            --通知ctrl去掉savePos
            mod.DecorationCtrl:RemovePosInfo(config)
            mod.DecorationCtrl:OnRemoveEntity(config)
            mod.DecorationCtrl:CancleSaveData(config)
            self.savePos[config.id] = nil
            Fight.Instance.clientFight.decorationManager:CloseDecorationControlPanel()
        else
            self:ClosePanel()
        end
    end
end

function DecorationControlPanel:DisablePlayerMove(isDisable)
    BF.SetFightMainNodeVisible(2, "Joystick", not isDisable)
end
--收纳
function DecorationControlPanel:OnClickTakeIn()
    if self.curDecoration then
        local assetId = mod.AssetPurchaseCtrl:GetCurAssetId()
        local cfg = mod.DecorationCtrl:GetEntityDecorationInfo(self.curDecoration.instanceId)
        local newInfo = mod.AssetPurchaseCtrl:GetDeviceWorkInfo(assetId,cfg.id)
        if newInfo then
            if #newInfo.partner_list~=0  then
                MsgBoxManager.Instance:ShowTips(TI18N(" 当前物件已被月灵占用"))
                return
            elseif newInfo.finish_amount~=0 then
                MsgBoxManager.Instance:ShowTips(TI18N("有未获取的道具"))
                return
            elseif  #newInfo.food_list~=0 then
                local count = 0
                for k, v in pairs(newInfo.food_list) do
                    count = count + v.value
                end
                if count > 0 then
                    MsgBoxManager.Instance:ShowTips(TI18N("有未清除的食物"))
                    return
                end
            end
        end
        
        --判断下是否是场景中原有的
        if mod.DecorationCtrl:IsSaveDecoration(cfg.id) then
            mod.DecorationCtrl:SavePosInfo(cfg)
            mod.DecorationCtrl:ReturnDecorationInfo(cfg.id)
        else
            mod.DecorationCtrl:RemoveSaveData(cfg)
        end
        SoundManager.Instance:PlaySound("ChongGou_Quit")
        self.decorationController:OnQuitControl(cfg.id,self.curDecoration,DecorationConfig.QuitPanelType.open)
    end
end

function DecorationControlPanel:OnClickLayUp()
    --抓取
    if not self.curDecoration then
        return
    end
    local config = mod.DecorationCtrl:GetEntityDecorationInfo(self.curDecoration.instanceId)
    if not config then
        return
    end
    self.savePos[config.id] = {}
    self.savePos[config.id].pos_info = config.pos_info
    SoundManager.Instance:PlaySound("ChongGou_Catch")
    local assetId = mod.AssetPurchaseCtrl:GetCurAssetId()    
    local newInfo = mod.AssetPurchaseCtrl:GetDeviceWorkInfo(assetId,config.id)
    if newInfo then
        if #newInfo.partner_list~=0  then
            MsgBoxManager.Instance:ShowTips(TI18N(" 当前物件已被月灵占用"))
            return
        elseif newInfo.finish_amount~=0 then
            MsgBoxManager.Instance:ShowTips(TI18N("有未获取的道具"))
            return
        elseif  #newInfo.food_list~=0 then
            local count = 0
            for k, v in pairs(newInfo.food_list) do
                count = count + v.value
            end
            if count > 0 then
                MsgBoxManager.Instance:ShowTips(TI18N("有未清除的食物"))
                return
            end
        end
    end

    local data = mod.DecorationCtrl:GetDecorationConfig(config.template_id)
    if data then
        self:OnShowTips(data)
    end
    self.ControlPanel:SetActive(true)
    self.EditorPanel:SetActive(false)
    self.type = DecorationConfig.decorationType.create
    if not self.curDecoration then
        return
    end
    if mod.DecorationCtrl:IsSaveDecoration(config.id) then
        mod.DecorationCtrl:SavePosInfo(config)
        mod.DecorationCtrl:ReturnDecorationInfo(config.id)
    end
    mod.AssetPurchaseCtrl:RemoveDecorationEntity(config.id)
    mod.DecorationCtrl:SetCurDecorationInfoByData(config)
    self.decorationController:GetDecoration(self.curDecoration)
    self.curPanleType = true
    self.isTake = true
end

--显示物件Tipd
function DecorationControlPanel:OnShowTips(data)
    self.InforBar:SetActive(true)
    self.InforBarName_txt.text = data.name
    local count = mod.DecorationCtrl:GetrealDecorationCount(data.id)
    self.InfoCount_txt.text = count
end

function DecorationControlPanel:ClosePanel()
    if self.curDecoration then
        self.decorationController:OnCancelControl(self.curDecoration)
    end
    self.type = nil
    Fight.Instance.clientFight.decorationManager:CloseDecorationControlPanel()
end

function DecorationControlPanel:ClearSelect()
   self.selectDecorations = {}
end

function DecorationControlPanel:__Hide()
    --mod.GmCtrl:DisPlayMouse()
    Fight.Instance.clientFight.decorationManager:ShowMouseCursor()
    BehaviorFunctions.DoSetEntityState(self.ctrlEntity.instanceId, FightEnum.EntityState.Idle)
end

function DecorationControlPanel:__delete()
    EventMgr.Instance:RemoveListener(EventName.ActionInput, self:ToFunc("OnActionInput"))
    EventMgr.Instance:RemoveListener(EventName.ActionInputEnd, self:ToFunc("OnActionInputEnd"))
end
