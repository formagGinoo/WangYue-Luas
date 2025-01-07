PhotoMainPanel = BaseClass("PhotoMainPanel", BasePanel, SystemView)

function PhotoMainPanel:__init()
    self:SetAsset("Prefabs/UI/Photo/PhotoMainPanel.prefab")

    self.inputManager = Fight.Instance.clientFight.inputManager
end

function PhotoMainPanel:__CacheObject()
    self:SetCacheMode(UIDefine.CacheMode.destroy)
    self:AddSystemState(SystemStateConfig.StateType.Photo)
end

function PhotoMainPanel:__BindListener()
    self:SetHideNode("TempCameraWindow_out")
    self:BindCloseBtn(self.BackBtn_btn, self:ToFunc("OnBack"), self:ToFunc("OnClick_Close"))
    self.CameraBtn_btn.onClick:AddListener(self:ToFunc("OnClickCamera"))

    self.cameraFovScroller = self.Scroller:GetComponent(Scrollbar)
    self.cameraFovScroller.onValueChanged:AddListener(self:ToFunc("OnCameraFovValueChange"))

    self.touchEvent = self.DragBg:GetComponent("UITouchEvent")
    self.touchEvent:SetTouchAction(self:ToFunc("OnTouchEvent"))

    self.PhotoDeleteButton_btn.onClick:AddListener(self:ToFunc("ClosePhotoBg"))
    self.PhotoBgCloseButton_btn.onClick:AddListener(self:ToFunc("ClosePhotoBg"))
    self.PhotoSaveButton_btn.onClick:AddListener(self:ToFunc("SavePhoto"))

    --拍照回调
    UtilsUI.SetAnimationEventCallBack(self.gameObject, function(param)
        if param == "in" then
            self:OnCameraCallback()
        end
    end)

    --制图回调
    UtilsUI.SetAnimationEventCallBack(self.Reward, function(param)
        --if param == "move" then
        --    local aimEntityInstance, animEntityDis = mod.PhotoCtrl:GetCurUnLoadEntity()
        --    local entity = BehaviorFunctions.GetEntity(aimEntityInstance)
        --    local uiPos = UtilsBase.WorldToUIPointBase(entity.transformComponent.position.x, entity.transformComponent.position.y, entity.transformComponent.position.z)
        --    UnityUtils.SetAnchoredPosition(self.UI_Reward_tuowei_rect, uiPos.x, uiPos.y)
        --    self.sequence = DOTween.Sequence()
        --    local tween1 = self.UI_Reward_tuowei_rect:DOAnchorPos(Vector2(302, 299), 0.5)
        --    self.sequence:Append(tween1)
        --end
    end)

    UtilsUI.SetHideCallBack(self.Reward_out, self:ToFunc("OnRewardAnimEnd"))

    self.PlayerAnimButton_btn.onClick:AddListener(self:ToFunc("OnClickPlayerAnimButton"))
    self.SwitchPhotoButton_btn.onClick:AddListener(self:ToFunc("OnClickSwitchPhotoButton"))

    self.ResetCameraButton_btn.onClick:AddListener(self:ToFunc("OnClickResetCameraButton"))
    self.TriAnimGroupCloseButton_btn.onClick:AddListener(self:ToFunc("OnClickTriAnimGroupCloseButton"))
    self.TriCameraOperateCont = UtilsUI.GetContainerObject(self.Rotation)
    local dragBehaviour = self.TriCameraOperateCont.RotationBg:GetComponent(UIDragBehaviour)
    if not dragBehaviour then
        dragBehaviour = self.TriCameraOperateCont.RotationBg:AddComponent(UIDragBehaviour)
    end
    dragBehaviour.onPointerDown = function(data)
        self:OnClick3rdCameraRotation(data)
    end
    dragBehaviour.onPointerUp = function(data)
        self:OnClick3rdCameraRotationCancel(data)
    end

    self:SetDrag()
end

function PhotoMainPanel:SetDrag()
    local bgdragBehaviour = self.DragBg:GetComponent(UIDragBehaviour) or self.DragBg:AddComponent(UIDragBehaviour)
    local onbgBeginDrag = function(data)
        self:BGBeginDrag(data)
    end
    bgdragBehaviour.onBeginDrag = onbgBeginDrag
    local cbbgOnDrag = function(data)
        self:BGDrag(data)
    end
    bgdragBehaviour.onDrag = cbbgOnDrag

    local cbbgOnEndDrag = function(data)
        self:BGEndDrag(data)
    end
    bgdragBehaviour.onEndDrag = cbbgOnEndDrag

    local onbgDown = function(data)
        self:BGDown(data)
    end
    bgdragBehaviour.onPointerDown = onbgDown
    local onbgUp = function(data)
        self:BGUp(data)
    end
    bgdragBehaviour.onPointerUp = onbgUp
end

function PhotoMainPanel:__BindEvent()
    EventMgr.Instance:AddListener(EventName.ActionInput, self:ToFunc("OnActionInput"))
    EventMgr.Instance:AddListener(EventName.ActionInputEnd, self:ToFunc("OnActionInputEnd"))
end

function PhotoMainPanel:__delete()
    EventMgr.Instance:RemoveListener(EventName.ActionInput, self:ToFunc("OnActionInput"))
    EventMgr.Instance:RemoveListener(EventName.ActionInputEnd, self:ToFunc("OnActionInputEnd"))
end

function PhotoMainPanel:__Create()
    UtilsUI.SetActive(self.MessagePanel, false)
    UtilsUI.SetActive(self.Talk, false)

    self.buildInfoList = mod.PhotoCtrl:GetUnLockPrintList()

    UtilsUI.SetInputImageChanger(self.BackBtnInputImage)
    UtilsUI.SetInputImageChanger(self.PlayerAnimButtonInputImage)
    UtilsUI.SetInputImageChanger(self.SwitchPhotoInputImage)
    UtilsUI.SetInputImageChanger(self.CameraBtnInputImage)
    UtilsUI.SetInputImageChanger(self.ResetCameraButtonInputImage)

    self.onClose = false
end

function PhotoMainPanel:__Show()
    self.animator = self.gameObject:GetComponent(Animator)
    UtilsUI.SetActive(self.Income, false)

    self:InitPlayAnim()

    self.PlayerAnimText_txt.text = TI18N("角色动作")
    self.SwitchPhotoText_txt.text = TI18N("切换镜头")

    Fight.Instance.entityManager:CallBehaviorFun("OnPhotoEnter")

    self.canClose = true
end

function PhotoMainPanel:SetCamera(isTriCamera)
    if self.onClose then
        return
    end
    local ctrl = BehaviorFunctions.GetCtrlEntity()
    local entity = BehaviorFunctions.GetEntity(ctrl)

    --隐藏角色
    if isTriCamera then
        BehaviorFunctions.RemoveBuff(ctrl, 1000048)
    else
        BehaviorFunctions.DoMagic(1, ctrl, 1000048, 1)
    end

    local h, v = 0, 0
    local cameraState = CameraManager.Instance:GetCameraState()
    if cameraState == FightEnum.CameraState.Operating or cameraState == FightEnum.CameraState.Hacking then
        h = CameraManager.Instance.statesMachine.lockingPOV.m_HorizontalAxis.Value
        v = CameraManager.Instance.statesMachine.lockingPOV.m_VerticalAxis.Value
    end
    if self.lastActionMap then
        InputManager.Instance:MinusLayerCount(self.lastActionMap)
        self.lastActionMap = nil
    end

    if isTriCamera then
        InputManager.Instance:AddLayerCount("PhotoTPS")
        self.lastActionMap = "PhotoTPS"
        local camera = CameraManager.Instance.states[FightEnum.CameraState.TriPhoto]
        --BehaviorFunctions.SetCameraState(FightEnum.CameraState.TriPhoto)
        SystemStateMgr.Instance:SetCameraState(SystemStateConfig.StateType.Photo, FightEnum.CameraState.TriPhoto)
        camera:UpdateCameraRotation(h, v)
        camera:SetMainTarget(entity.clientTransformComponent:GetTransform("CameraTarget"))
    else

        InputManager.Instance:AddLayerCount("Photo")
        self.lastActionMap = "Photo"
        local camera = CameraManager.Instance.states[FightEnum.CameraState.Photo]
        -- BehaviorFunctions.SetCameraState(FightEnum.CameraState.Photo)
        SystemStateMgr.Instance:SetCameraState(SystemStateConfig.StateType.Photo, FightEnum.CameraState.Photo)
        camera:UpdateCameraRotation(h, v)
        camera:SetMainTarget(entity.clientTransformComponent:GetTransform("CameraTarget"))
    end


    if isTriCamera then
        self.photoCamera = CameraManager.Instance.states[FightEnum.CameraState.TriPhoto]
        self.photoCamera:SetScreenOffset(0.5, 0.5)
        self.photoCamera:SetDistance(4.5)
        self.curScreenX = 0.5
        self.curScreenY = 0.5
        self.curDistance = 4.5
    else
        self:OnClick3rdCameraRotationCancel()
        self.photoCamera = CameraManager.Instance.states[FightEnum.CameraState.Photo]
    end
    
    self.isTriCamera = isTriCamera

    if isTriCamera then
        self.cameraFovScroller.value = 0.8157894736842105
    else
        self.cameraFovScroller.value = 0
    end

    BehaviorFunctions.PlayAnimation(self.mainInstanceId, "Empty_Perform", FightEnum.AnimationLayer.PerformLayer)
    if self.curAnimTimer then
        LuaTimerManager.Instance:RemoveTimer(self.curAnimTimer)
        self.curAnimTimer = nil
    end
    self.curPlayLoopAnim = nil
end

function PhotoMainPanel:InitPlayAnim()
    local animDataList = PhotoConfig.GetAnimData()
    self.mainInstanceId = BehaviorFunctions.GetCtrlEntity()
    self.mainEntity = BehaviorFunctions.GetEntity(self.mainInstanceId)

    for index, animData in pairs(animDataList) do
        local animDesc = animData.desc
        local animName = animData.ani_name
        local animIcon = animData.icon
        local go = GameObject.Instantiate(self.AnimItem, self.AnimContent_rect)
        local cont = UtilsUI.GetContainerObject(go)
        SingleIconLoader.Load(cont.AnimIcon, animIcon)
        cont.AnimText_txt.text = TI18N(animDesc)
        cont.AnimIcon_btn.onClick:AddListener(function ()
            if self.curPlayLoopAnim then
                self:PlayEndAnim(self.curPlayLoopAnim, animName)
            else
                self:PlayStartAnim(animName)
            end
        end)
        UtilsUI.SetActive(go, true)
    end
end

--起始动画 后必接loop
function PhotoMainPanel:PlayStartAnim(animState)
    if self.curAnimTimer then
        LuaTimerManager.Instance:RemoveTimer(self.curAnimTimer)
        self.curAnimTimer = nil
    end
    local startAnimState = animState .. "_in"
    local loopAnimState = animState .. "_loop"

    local layerIndex = self.mainEntity.clientAnimatorComponent:GetLayerIndex(FightEnum.AnimationLayer.PerformLayer)
    local startTimeLength = BehaviorFunctions.CheckAnimTime(self.mainInstanceId, startAnimState, layerIndex)
    BehaviorFunctions.PlayAnimation(self.mainInstanceId, startAnimState, FightEnum.AnimationLayer.PerformLayer)
    self.curAnimTimer = LuaTimerManager.Instance:AddTimer(1, startTimeLength, function ()
        BehaviorFunctions.PlayAnimation(self.mainInstanceId, loopAnimState, FightEnum.AnimationLayer.PerformLayer)
        self.curPlayLoopAnim = animState
        self.curAnimTimer = nil
    end)
end

--end后看情况接start
function PhotoMainPanel:PlayEndAnim(animState, nextAnimState)
    if self.curAnimTimer then
        LuaTimerManager.Instance:RemoveTimer(self.curAnimTimer)
        self.curAnimTimer = nil
    end

    local endAnimState = animState .. "_end"
    BehaviorFunctions.PlayAnimation(self.mainInstanceId, endAnimState, FightEnum.AnimationLayer.PerformLayer)
    self.curPlayLoopAnim = nil
    if nextAnimState then
        local layerIndex = self.mainEntity.clientAnimatorComponent:GetLayerIndex(FightEnum.AnimationLayer.PerformLayer)
        local endTimeLength = BehaviorFunctions.CheckAnimTime(self.mainInstanceId, endAnimState, layerIndex)
        self.curAnimTimer = LuaTimerManager.Instance:AddTimer(1, endTimeLength, function ()
            self.curAnimTimer = nil
            self:PlayStartAnim(nextAnimState)
        end)
    end
end

function PhotoMainPanel:__ShowComplete()
    self.curState = PhotoEnum.State.Photo
    
    self:SetPhotoMode(self.args.mode or PhotoEnum.PhotoMode.FirstPerson)

    EventMgr.Instance:Fire(EventName.ShowCursor, false)
    self.showCursor = false
end

function PhotoMainPanel:__Hide()
    if self.lastActionMap then
        InputManager.Instance:MinusLayerCount(self.lastActionMap)
        self.lastActionMap = nil
    end

    if self.sequence then
        self.sequence:Kill()
        self.sequence = nil
    end

    local ctrl = BehaviorFunctions.GetCtrlEntity()

    self:OnClick3rdCameraRotationCancel()

    --恢复角色
    BehaviorFunctions.RemoveBuff(ctrl, 1000048)
    --BehaviorFunctions.SetCameraState(FightEnum.CameraState.Operating)

    if self.showCursor then
        EventMgr.Instance:Fire(EventName.ShowCursor, false)
        self.showCursor = false
    end

    Fight.Instance.entityManager:CallBehaviorFun("OnPhotoExit")
end

function PhotoMainPanel:OnBack()
    if self.isOnClickCloseNode then
        mod.PhotoCtrl:ClosePhoto()
    end
end

function PhotoMainPanel:OnClick_Close()
    if not self.canClose then
        return
    end
    if self.onClose then
        return
    end
    self.onClose = true
    UtilsUI.SetActive(self.PhotoBg, false)
    self.animator:Play("UI_TempCameraWindow_out", 0, 0)
    self.isOnClickCloseNode = true
end

function PhotoMainPanel:OnClickCamera()
    if self.onClose then
        return
    end
    if self.curState == PhotoEnum.State.Photo then
        self.curState = PhotoEnum.State.Photoing
        self.canClose = false
        self.animator:Play("UI_TempCameraWindow_paizhao", 0, 0)
        SoundManager.Instance:PlaySound("TakePhoto")
        Fight.Instance.entityManager:CallBehaviorFun("OnPhotoClick")

        if self.isTriCamera then
            self:CloseAnimGroup()
        end

        local isUnlock = false
        if Fight.Instance.conditionManager:CheckConditionByConfig(PhotoConfig.DrawPhotoUnlockCondition) then
            local entityInstanceId, entityDis = mod.PhotoCtrl:GetCurSelectEntity()
            if entityInstanceId then
                local entity = BehaviorFunctions.GetEntity(entityInstanceId)
                --检测是否获得过图纸
                self.designEntity = entity
                mod.PhotoCtrl:UnLockEntity(self.designEntity)
                isUnlock = true

                for index, instanceId in pairs(mod.PhotoCtrl.buildingTargetList) do
                    BehaviorFunctions.RemoveBuff(instanceId, PhotoConfig.CanBuildEffect)
                end
                BehaviorFunctions.RemoveBuff(entityInstanceId, PhotoConfig.SelectEffect)
            end
        end
        self:OnCamera(isUnlock)
    end
end

function PhotoMainPanel:OnCamera(isUnlock)
    if not self.photoImage or not self.photoBlur then
        local setting = { passEvent = UIDefine.BlurBackCaptureType.Scene, blurRadius = 0, bindNode = self.Photo, downSamle = 1 }
        self.photoImage = BlurBack.New(self.PhotoBg, setting)
        if self.PhotoBlur then
            setting = { passEvent = UIDefine.BlurBackCaptureType.Scene, blurRadius = 16, bindNode = self.PhotoBlur, downSamle = 2 }
            self.photoBlurRt = BlurBack.New(self.PhotoBg, setting)
        end
        setting = { passEvent = UIDefine.BlurBackCaptureType.Scene, blurRadius = 0, bindNode = self.RewardPhoto, downSamle = 1 }
        self.photoBlur = BlurBack.New(self.PhotoBg, setting)
    end

    if self.curState == PhotoEnum.State.Photoing then
        if self.PhotoBlur then
            self.photoBlurRt:Show({function ()
                self.photoImage:Show({function ()
                    self.TickPhotoBack_rect:SetAsFirstSibling()
                end})
            end})
        else
            self.photoImage:Show({function ()
                self.TickPhotoBack_rect:SetAsFirstSibling()
            end})
        end
        if isUnlock then
            self.photoBlur:Show()
        end
    end
end

function PhotoMainPanel:OnTouchEvent(isRelease, distance)
    if isRelease then
        self.isTouchEvent = false
        self.initDistance = 0
        return
    end

    local camera = CameraManager.Instance.states[FightEnum.CameraState.Photo]
    self.isTouchEvent = true
    if self.initDistance == 0 then
        self.initDistance = distance
        self.initFovValue = camera.cinemachineCamera.m_Lens.FieldOfView / 45
    end

    local diff = self.initDistance - distance
    if math.abs(diff) <= 5 then
        return
    end

    diff = diff < 0 and diff + 5 or diff - 5
    local value = MathX.Clamp(self.initFovValue + (diff * 0.01), 0.33, 1)
    CinemachineInterface.ChangeFov(camera.camera, value * 45)
end

function PhotoMainPanel:ShowPhotoSaveCallback()
    local rt = self.photoImage:GetRt()
    if rt then
        local nowTimeStamp = TimeUtils.GetCurTimestamp()
        local name = os.date("%Y%m%d%H%M%S.png", nowTimeStamp)
        local savePath = ""
        local result, savePath = CustomUnityUtils.SaveScreenShotToPng(rt, name, savePath)
        if not result then
            MsgBoxManager.Instance:ShowTips(TI18N("保存速度太快"))
            return false
        else
            return true, savePath
        end
    end
end

--事件
function PhotoMainPanel:BGBeginDrag(data)
    FightMainUIView.bgInput.x = 0
    FightMainUIView.bgInput.y = 0
end

function PhotoMainPanel:BGDrag(data)
    FightMainUIView.bgInput.x = data.delta.x
    FightMainUIView.bgInput.y = data.delta.y
    self.inputManager:KeyDown(FightEnum.KeyEvent.ScreenMove)

    self:UpdateTips()
end

function PhotoMainPanel:UpdateTips()
    if self.curSelectIns then
        local entity = BehaviorFunctions.GetEntity(self.curSelectIns)
        if entity then
            local pos = entity.transformComponent.position
            local sp = UtilsBase.WorldToUIPointBase(pos.x, pos.y, pos.z)
            if sp.z > 0 then
                UnityUtils.SetLocalPosition(self.TipsItem.transform, sp.x, sp.y + 45, 0)
            end
        end
    end
end

function PhotoMainPanel:BGEndDrag(data)
    FightMainUIView.bgInput.x = 0
    FightMainUIView.bgInput.y = 0
    self.inputManager:KeyUp(FightEnum.KeyEvent.ScreenMove)
end

function PhotoMainPanel:BGDown()
    self.inputManager:KeyDown(FightEnum.KeyEvent.ScreenPress)
end

function PhotoMainPanel:BGUp()
    self.inputManager:KeyUp(FightEnum.KeyEvent.ScreenPress)
end

function PhotoMainPanel:OnCameraFovValueChange(value)
    if self.isTriCamera then
        self.photoCamera:SetDistance(1 + (20 - 1) * (1 - value))
    else
        local percent = (1 - value) * 1 / 3 + 0.66
        local fov = 45 * percent
    
        if self.PhotoScaleText_txt then
            self.PhotoScaleText_txt.text = string.format("%.1fX", value + 1)
        end
    
        CinemachineInterface.ChangeFov(self.photoCamera.camera, fov)    
    end
end

function PhotoMainPanel:OnCameraCallback()
    if self.curState == PhotoEnum.State.Photoing then
        self.canClose = true
        UtilsUI.SetActive(self.PhotoBg, true)
        EventMgr.Instance:Fire(EventName.ShowCursor, true)
        self.showCursor = true

        self.PhotoBg_anim:Play("UI_PhotoBg_in")

        if self.isTriCamera then
            UtilsUI.SetActive(self.TriCameraOperate, false)
            UtilsUI.SetActive(self.ResetCameraButton, false)
        end

        if self.designEntity then
            --CinemachineInterface.ChangeFov(self.photoCamera.camera, self.recodeFov)
            UtilsUI.SetActive(self.Reward, true)

            local buildInfo = PhotoConfig.GetBuildInfoByEntityId(self.designEntity.entityId)
            self.BuildingName_txt.text = TI18N(buildInfo.name)
            self.Reward_anim:Play("UI_Reward_in")
        end

        Fight.Instance.entityManager:CallBehaviorFun("OnPhotoClickEnd")
    end
end

function PhotoMainPanel:OnRewardAnimEnd()
    UtilsUI.SetActive(self.Reward, false)

    self.designEntity = nil
end

function PhotoMainPanel:OnDesignSelectChange(curSelectInstanceId, curSelectDis)
    --瞄准到可建造物时弹出提示，暂时不使用
    if curSelectInstanceId then
        UtilsUI.SetActive(self.MessagePanel, true)
        UtilsUI.SetActive(self.TipsItem, true)
        if self.curSelectIns ~= curSelectInstanceId then
            local entity = BehaviorFunctions.GetEntity(curSelectInstanceId)
            local buildInfo = PhotoConfig.GetBuildInfoByEntityId(entity.entityId)
            SingleIconLoader.Load(self.MsgHeadIcon, buildInfo.icon)
            self.MsgNameText_txt.text = TI18N(buildInfo.name)
            self.MsgProfessionText_txt.text = TI18N(buildInfo.desc)
            self.TipsText_txt.text = TI18N(buildInfo.name)
        end
        self.curSelectIns = curSelectInstanceId
        self:UpdateTips()
    else
        UtilsUI.SetActive(self.MessagePanel, false)
        UtilsUI.SetActive(self.TipsItem, false)
        self.curSelectIns = curSelectInstanceId
    end
end

function PhotoMainPanel:ClosePhotoBg()
    if self.waitSaveCloseTimer then
        LuaTimerManager.Instance:RemoveTimer(self.waitSaveCloseTimer)
        self.waitSaveCloseTimer = nil
    end
    --self.PhotoBg_anim:Play("UI_PhotoBg_out")
    UtilsUI.SetActive(self.PhotoBg, false)
    EventMgr.Instance:Fire(EventName.ShowCursor, false)
    self.showCursor = false
    self.curState = PhotoEnum.State.Photo

    self.noSave = false

    if self.isTriCamera then
        UtilsUI.SetActive(self.TriCameraOperate, true)
        UtilsUI.SetActive(self.ResetCameraButton, true)
    end

    for index, instanceId in pairs(mod.PhotoCtrl.buildingTargetList) do
        BehaviorFunctions.DoMagic(1, instanceId, PhotoConfig.CanBuildEffect)
    end
end

function PhotoMainPanel:SavePhoto()
    if not self.noSave then
        self.noSave = true
        local result, savePath = self:ShowPhotoSaveCallback()
        if result and UtilsUI.CheckPCPlatform() then
            self.SaveTipsText_txt.text = TI18N("图片已保存至\n") .. savePath
            UtilsUI.SetActive(self.SaveTips, true)
            self.waitSaveCloseTimer = LuaTimerManager.Instance:AddTimer(1, 1.5, function ()
                self.waitSaveCloseTimer = nil
                UtilsUI.SetActive(self.SaveTips, false)
                self:ClosePhotoBg()
            end)
        end
    end
end

function PhotoMainPanel:OnClickSwitchPhotoButton()
    if self.isTriCamera then
        self:SetPhotoMode(PhotoEnum.PhotoMode.FirstPerson)
        self:CloseAnimGroup()
    else
        self:SetPhotoMode(PhotoEnum.PhotoMode.ThirdPerson)
    end
end

function PhotoMainPanel:SetPhotoMode(mode)
    if mode == PhotoEnum.PhotoMode.FirstPerson then
        self:SetCamera(false)
        UtilsUI.SetActive(self.TriCameraOperate, false)
        UtilsUI.SetActive(self.ResetCameraButton, false)
        UtilsUI.SetActive(self.PlayerAnim, false)
        UtilsUI.SetActive(self.TriAnimGroup, false)
    elseif mode == PhotoEnum.PhotoMode.ThirdPerson then
        self:SetCamera(true)
        UtilsUI.SetActive(self.TriCameraOperate, true)
        UtilsUI.SetActive(self.ResetCameraButton, true)
        UtilsUI.SetActive(self.PlayerAnim, true)
    end
end

function PhotoMainPanel:OnClickPlayerAnimButton()
    if self.isOpenAnimGroup then
        self:CloseAnimGroup()
    else
        self:OpenAnimGroup()
    end
end

function PhotoMainPanel:OpenAnimGroup()
    UtilsUI.SetActive(self.PlayerAnimButtonSelectIcon, true)
    self.isOpenAnimGroup = true
    UtilsUI.SetActive(self.TriAnimGroup, true)
end

function PhotoMainPanel:CloseAnimGroup()
    UtilsUI.SetActive(self.PlayerAnimButtonSelectIcon, false)
    self.isOpenAnimGroup = false
    UtilsUI.SetActive(self.TriAnimGroup, false)
end

function PhotoMainPanel:OnClickTriAnimGroupCloseButton()
    self:CloseAnimGroup()
end

function PhotoMainPanel:OnClickResetCameraButton()
    self.photoCamera:SetScreenOffset(0.5, 0.5)
    self.photoCamera:SetDistance(4.5)
    self.curScreenX = 0.5
    self.curScreenY = 0.5
    self.curDistance = 4.5
    self.cameraFovScroller.value = 0.8157894736842105
    self.photoCamera:UpdateCameraHorizontalRotation(-180)
    self.photoCamera:UpdateCameraVerticalRotation(0)
end

local RotationClickType = {
    Up = 1, Down = 2, Left = 3, Right = 4
}

function PhotoMainPanel:OnClick3rdCameraRotation(data)
    local uiCamera = ctx.UICamera
    local spPoint = uiCamera:WorldToScreenPoint(self.TriCameraOperateCont.RotationBg.transform.position)

    local ClickVec = Vec3.New(data.position.x - spPoint.x, data.position.y - spPoint.y, 0)
    local angle = Vec3.Angle(Vec3.up, ClickVec)

    if self.ClickRotationType then
        self:OnClick3rdCameraRotationCancel()
    end

    if angle < 45 then
        self.ClickRotationType = RotationClickType.Up
        self:OnClickRotationUp(true)
    elseif angle >= 45 and angle < 135 then
        if ClickVec.x < 0 then
            self.ClickRotationType = RotationClickType.Left
            self:OnClickRotationLeft(true)
        else
            self.ClickRotationType = RotationClickType.Right
            self:OnClickRotationRight(true)
        end
    else
        self.ClickRotationType = RotationClickType.Down
        self:OnClickRotationDown(true)
    end
end

function PhotoMainPanel:OnClick3rdCameraRotationCancel()
    if self.ClickRotationType == RotationClickType.Up then
        self:OnClickRotationUp(false)
    elseif self.ClickRotationType == RotationClickType.Left then
        self:OnClickRotationLeft(false)
    elseif self.ClickRotationType == RotationClickType.Right then
        self:OnClickRotationRight(false)
    elseif self.ClickRotationType == RotationClickType.Down then
        self:OnClickRotationDown(false)
    end
    self.ClickRotationType = nil
end

local clamp = MathX.Clamp
local updateFix = 0.03
local speed = updateFix

function PhotoMainPanel:OnClickRotationUp(isTouch)
    UtilsUI.SetActive(self.TriCameraOperateCont.Up_UnSelect, not isTouch)
    UtilsUI.SetActive(self.TriCameraOperateCont.Up_Select, isTouch)

    if isTouch then
        self.triCameraSceenMoveTimer = LuaTimerManager.Instance:AddTimer(0, updateFix, function ()
            self.curScreenY = clamp(self.curScreenY + speed, 0.1, 0.9)
            self.photoCamera:SetScreenOffset(self.curScreenX, self.curScreenY)
        end)
    else
        if self.triCameraSceenMoveTimer then
            LuaTimerManager.Instance:RemoveTimer(self.triCameraSceenMoveTimer)
            self.triCameraSceenMoveTimer = nil
        end
    end
end

function PhotoMainPanel:OnClickRotationLeft(isTouch)
    UtilsUI.SetActive(self.TriCameraOperateCont.Left_UnSelect, not isTouch)
    UtilsUI.SetActive(self.TriCameraOperateCont.Left_Select, isTouch)

    if isTouch then
        self.triCameraSceenMoveTimer = LuaTimerManager.Instance:AddTimer(0, updateFix, function ()
            self.curScreenX = clamp(self.curScreenX + speed, 0, 1)
            self.photoCamera:SetScreenOffset(self.curScreenX, self.curScreenY)
        end)
    else
        if self.triCameraSceenMoveTimer then
            LuaTimerManager.Instance:RemoveTimer(self.triCameraSceenMoveTimer)
            self.triCameraSceenMoveTimer = nil
        end
    end
end

function PhotoMainPanel:OnClickRotationRight(isTouch)
    UtilsUI.SetActive(self.TriCameraOperateCont.Right_UnSelect, not isTouch)
    UtilsUI.SetActive(self.TriCameraOperateCont.Right_Select, isTouch)

    if isTouch then
        self.triCameraSceenMoveTimer = LuaTimerManager.Instance:AddTimer(0, updateFix, function ()
            self.curScreenX = clamp(self.curScreenX - speed, 0, 1)
            self.photoCamera:SetScreenOffset(self.curScreenX, self.curScreenY)
        end)
    else
        if self.triCameraSceenMoveTimer then
            LuaTimerManager.Instance:RemoveTimer(self.triCameraSceenMoveTimer)
            self.triCameraSceenMoveTimer = nil
        end
    end
end

function PhotoMainPanel:OnClickRotationDown(isTouch)
    UtilsUI.SetActive(self.TriCameraOperateCont.Down_UnSelect, not isTouch)
    UtilsUI.SetActive(self.TriCameraOperateCont.Down_Select, isTouch)

    if isTouch then
        self.triCameraSceenMoveTimer = LuaTimerManager.Instance:AddTimer(0, updateFix, function ()
            self.curScreenY = clamp(self.curScreenY - speed, 0.1, 0.9)
            self.photoCamera:SetScreenOffset(self.curScreenX, self.curScreenY)
        end)
    else
        if self.triCameraSceenMoveTimer then
            LuaTimerManager.Instance:RemoveTimer(self.triCameraSceenMoveTimer)
            self.triCameraSceenMoveTimer = nil
        end
    end
end

-- 监听InputSystem的事件
function PhotoMainPanel:OnActionInput(key, value)
    if key == FightEnum.KeyEvent.TakePhoto then
        self:OnClickCamera()
    elseif key == FightEnum.KeyEvent.QuitPhoto then
        self:OnClick_Close()
    elseif key == FightEnum.KeyEvent.MovePhotoCamera then
        if self.ClickRotationType then
            self:OnClick3rdCameraRotationCancel()
        end
        if value.x == 0 and value.y == 1 then
            self.ClickRotationType = RotationClickType.Up
            self:OnClickRotationUp(true)
        elseif value.x == -1 and value.y == 0 then
            self.ClickRotationType = RotationClickType.Left
            self:OnClickRotationLeft(true)
        elseif value.x == 1 and value.y == 0 then
            self.ClickRotationType = RotationClickType.Right
            self:OnClickRotationRight(true)
        elseif value.x == 0 and value.y == -1 then
            self.ClickRotationType = RotationClickType.Down
            self:OnClickRotationDown(true)
        end
    elseif key == FightEnum.KeyEvent.SwitchCamera then
        self:OnClickSwitchPhotoButton()
    elseif key == FightEnum.KeyEvent.Zoom then
        local curValue = self.cameraFovScroller.value
        curValue = MathX.Clamp(curValue + (value.y / 1000.0), 0, 1)
        self.cameraFovScroller.value = curValue 
    elseif key == FightEnum.KeyEvent.PlayerAction then
        self:OnClickPlayerAnimButton()
    elseif key == FightEnum.KeyEvent.ResetCamera then
        self:OnClickResetCameraButton()
    end
end
function PhotoMainPanel:OnActionInputEnd(key, value)
    if key == FightEnum.KeyEvent.MovePhotoCamera then
        self:OnClick3rdCameraRotationCancel()
    end
end