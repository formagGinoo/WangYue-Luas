ControlDronePanel = BaseClass("ControlDronePanel", BasePanel)

function ControlDronePanel:__init()
    self:SetAsset("Prefabs/UI/Hacking/ControlDronePanel.prefab")
    self.operateButton = {}
end

function ControlDronePanel:__BindListener()
    --self:SetHideNode("CommonBack2_")
    self:BindCloseBtn(self.CommonBack2_btn, self:ToFunc("Close_HideCallBack"))
    EventMgr.Instance:AddListener(EventName.OnDroneCountDownUpdate, self:ToFunc("UpdateCountDown"))
    EventMgr.Instance:AddListener(EventName.ActionInput, self:ToFunc("OnActionInput"))
    EventMgr.Instance:AddListener(EventName.ActionInputEnd, self:ToFunc("OnActionInputEnd"))
    EventMgr.Instance:AddListener(EventName.CloseAllUI, self:ToFunc("CloseAllUI"))
    EventMgr.Instance:AddListener(EventName.SetDroneAimTarget, self:ToFunc("SetDroneAimTarget"))
end

function ControlDronePanel:__delete()
    EventMgr.Instance:RemoveListener(EventName.ActionInput, self:ToFunc("OnActionInput"))
    EventMgr.Instance:RemoveListener(EventName.ActionInputEnd, self:ToFunc("OnActionInputEnd"))
    EventMgr.Instance:RemoveListener(EventName.OnDroneCountDownUpdate, self:ToFunc("UpdateCountDown"))
    EventMgr.Instance:RemoveListener(EventName.CloseAllUI, self:ToFunc("CloseAllUI"))
    EventMgr.Instance:RemoveListener(EventName.SetDroneAimTarget, self:ToFunc("SetDroneAimTarget"))
end

--缓存对象
function ControlDronePanel:__CacheObject()
    self:SetCacheMode(UIDefine.CacheMode.destroy)
end

function ControlDronePanel:__Create()
    UnityUtils.SetActive(self.CommonBack2, not self.isCar)
    TableUtils.ClearTable(self.operateButton)
    for i = 1, 4 do
        self.operateButton[i] = {}

        local btn = self["HackOperationBtn" .. i]
        self.operateButton[i].gameObject = btn
        self.operateButton[i].transform = btn.transform
        UtilsUI.GetContainerObject(btn.transform, self.operateButton[i])

        UtilsUI.SetInputImageChanger(self.operateButton[i].HackOperateBtnInputImage)

        local btnGb = self.operateButton[i].ActionBtn
        local behavior = btnGb:GetComponent(UIDragBehaviour) or btnGb:AddComponent(UIDragBehaviour)
        local sIconPath, uIconPath, tTextPath, hTextPath = HackingConfig.GetIconAssetsPath(HackingConfig.HackingTypeToIconConfig[FightEnum.HackingType.Drone][i][1])

        self:SetSingleOperateButton(self.operateButton[i], false, sIconPath, uIconPath, tTextPath, hTextPath)

        local onDown = function(data)
            self:OnClickOperateBtn(i, true)
            self:TempSetOperateButton(i, true)
        end
        behavior.onPointerDown = onDown
        local onUp = function(data)
            self:OnClickOperateBtn(i, false)
            self:TempSetOperateButton(i, false)
        end
        behavior.onPointerUp = onUp
    end

    UtilsUI.SetInputImageChanger(self.AddSpeedInputImage)
    UtilsUI.SetInputImageChanger(self.ActiveChildInputImage)
    UtilsUI.SetInputImageChanger(self.CommonBack2InputImage)

    local dragBehaviour = self.AddSpeed.transform:GetComponent(UIDragBehaviour)
    if not dragBehaviour then
        dragBehaviour = self.AddSpeed:AddComponent(UIDragBehaviour)
    end
    dragBehaviour.onPointerDown = function(data)
        self:OnTouchAddSpeed(true)
    end
    dragBehaviour.onPointerUp = function(data)
        self:OnTouchAddSpeed(false)
    end

    dragBehaviour = self.ActiveChild.transform:GetComponent(UIDragBehaviour)
    if not dragBehaviour then
        dragBehaviour = self.ActiveChild:AddComponent(UIDragBehaviour)
    end
    dragBehaviour.onPointerDown = function(data)
        self:OnTouchActiveChild(true)
    end
    dragBehaviour.onPointerUp = function(data)
        self:OnTouchActiveChild(false)
    end
end

function ControlDronePanel:CloseAllUI()
    -- PV专用
    if DebugClientInvoke.Cache.closeUI == true then
        UtilsUI.SetActiveByScale(self.gameObject, false)
        return
    else
        UtilsUI.SetActiveByScale(self.gameObject, true)
    end
end

function ControlDronePanel:OnTouchAddSpeed(isTouch)
    Fight.Instance.entityManager:CallBehaviorFun("OnTouchAddSpeed", isTouch)

    UnityUtils.SetActive(self.AddSpeedSelected, isTouch)
    UnityUtils.SetActive(self.AddSpeedUnselected, not isTouch)
end

function ControlDronePanel:SetDroneId(droneInstanceId)
    self.droneInstanceId = droneInstanceId

    UnityUtils.SetActive(self.Control, true)
end

function ControlDronePanel:SetSingleOperateButton(btnNode, empty, sIconPath, uIconPath, tIconPath, hTextPath)
    UnityUtils.SetActive(btnNode.Selected, false)
    UnityUtils.SetActive(btnNode.Unselected, not empty)
    UnityUtils.SetActive(btnNode.ActionBtn, not empty)
    UnityUtils.SetActive(btnNode.Empty, empty)
    UnityUtils.SetActive(btnNode.SelectedIcon, false)
    UnityUtils.SetActive(btnNode.UnselectedIcon, false)
    UnityUtils.SetActive(btnNode.TipsTextIcon, false)
    UnityUtils.SetActive(btnNode.SelectTipsTextIcon, false)

    if not empty and sIconPath and uIconPath then
        SingleIconLoader.Load(btnNode.SelectedIcon, sIconPath, function()
            UnityUtils.SetActive(btnNode.SelectedIcon, true)
        end)
        SingleIconLoader.Load(btnNode.UnselectedIcon, uIconPath, function()
            UnityUtils.SetActive(btnNode.UnselectedIcon, true)
        end)
    end

    if not empty and tIconPath and hTextPath then
        SingleIconLoader.Load(btnNode.TipsTextIcon, tIconPath, function()
            UnityUtils.SetActive(btnNode.TipsTextIcon, true)
        end)
        SingleIconLoader.Load(btnNode.SelectTipsTextIcon, hTextPath)
    else
        UnityUtils.SetActive(btnNode.TipsTextIcon, false)
        UnityUtils.SetActive(btnNode.SelectTipsTextIcon, false)
    end
end

function ControlDronePanel:__Hide()
    EventMgr.Instance:RemoveListener(EventName.OnDroneCountDownUpdate, self:ToFunc("UpdateCountDown"))
end

function ControlDronePanel:__Show()
    -- PV专用
	if DebugClientInvoke.Cache.closeUI == true then
        UtilsUI.SetActiveByPosition(self.gameObject, false)
	else
        UtilsUI.SetActiveByPosition(self.gameObject, true)
	end
end

function ControlDronePanel:__ShowComplete()
    UnityUtils.SetActive(self.Control, true)
end

function ControlDronePanel:BindDriveCarButtonEvent()

end

local FuncNameList = {
    "ClickControlDroneUp",
    "ClickControlDroneRight",
    "ClickControlDroneDown",
    "ClickControlDroneLeft",
}

function ControlDronePanel:OnClickOperateBtn(idx, down)
    Fight.Instance.entityManager:CallBehaviorFun(FuncNameList[idx], self.droneInstanceId, down)
end

function ControlDronePanel:Close_HideCallBack()
    --BehaviorFunctions.ExitControlDroneMode()
    Fight.Instance.entityManager:CallBehaviorFun("OnStopDrive", self.droneInstanceId)
end

function ControlDronePanel:UpdateCountDown(frame, totalFrame)
    self.CountDownFill_img.fillAmount = frame / totalFrame
    local time = math.ceil(frame / 30)
    if time <= 10 then
        self.CountDownText_txt.text = string.format("<color=%s>%ds</color>", "#FF000A", time)
    else
        self.CountDownText_txt.text = math.ceil(frame / 30) .. "s"
    end
end

function ControlDronePanel:OnActionInput(key, value)
    if key == FightEnum.KeyEvent.QuitFly then
        self:Close_HideCallBack()
    elseif key == FightEnum.KeyEvent.Activation then
        self:OnTouchActiveChild(true)
    elseif key == FightEnum.KeyEvent.Accel then
        self:OnTouchAddSpeed(true)
    elseif key == FightEnum.KeyEvent.Drone_Brake then
        --UtilsUI.SetActive(self.BrakeEffect, true)
    elseif key == FightEnum.KeyEvent.Drone_Boost then
        --UtilsUI.SetActive(self.AccelerateEffect, true)
    end
end

function ControlDronePanel:OnActionInputEnd(key, value)
    if key == FightEnum.KeyEvent.Drone_Brake then
        --UtilsUI.SetActive(self.BrakeEffect, false)
    elseif key == FightEnum.KeyEvent.Drone_Boost then
        --UtilsUI.SetActive(self.AccelerateEffect, false)
    elseif key == FightEnum.KeyEvent.Activation then
        self:OnTouchActiveChild(false)
    elseif key == FightEnum.KeyEvent.Accel then
        self:OnTouchAddSpeed(false)
    end
end

function ControlDronePanel:OnTouchActiveChild(isTouch)
    UnityUtils.SetActive(self.ActiveChildSelected, isTouch)
    UnityUtils.SetActive(self.ActiveChildUnselected, not isTouch)
end

----------------------------------------------------
local zeroInput = { x = 0, y = 0 }
local lockDistance = 165 * 165
local AimState = {
    None = 1,
    Aiming = 2,
    Locked = 3
}
local tempVec3 = Vec3.New(0,0,0)

--设置瞄准
function ControlDronePanel:SetDroneAimTarget(targetId)
    if self.AimTargetId ~= targetId then
        self.AimTargetId = targetId
        self.AimPercent = 0
        self.lockState = AimState.None
    end
    if targetId == nil then
        UnityUtils.SetAnchoredPosition(self.Aim.transform, 0, 0)
        self.lockState = AimState.None
    end
end

function ControlDronePanel:Update()
    if self.AimTargetId then
        local target = BehaviorFunctions.GetEntity(self.AimTargetId)
        if target and target.clientTransformComponent then
            local transform = target.clientTransformComponent:GetTransform("HitCase")
            local uiPos = UtilsBase.WorldToUIPointBase(transform.position.x, transform.position.y, transform.position.z)
            local distance = uiPos.x * uiPos.x +  uiPos.y * uiPos.y
            if uiPos.z > 0 and distance <= lockDistance then
                if self.lockState == AimState.Aiming or self.lockState == AimState.None then
                    self.lockState = AimState.Aiming
                    self.AimPercent = self.AimPercent + 0.2
                    tempVec3:Set(self.Aim.transform.position.x, self.Aim.transform.position.y, self.Aim.transform.position.z)
                    local newPos = Vec3.Lerp(tempVec3, uiPos, self.AimPercent)
                    UnityUtils.SetAnchoredPosition(self.Aim.transform, newPos.x, newPos.y)
                    if self.AimPercent == 1 then
                        self.lockState = AimState.Locked
                        Fight.Instance.entityManager:CallBehaviorFun("PVSetAttackTarget", self.AimTargetId)
                    end
                elseif self.lockState == AimState.Locked then
                    UnityUtils.SetAnchoredPosition(self.Aim.transform, uiPos.x, uiPos.y)
                end
            end
        end
    end

    if self.AimTargetId and self.lockState == AimState.Locked then
        UnityUtils.SetActive(self.AimWhite, false)
        UnityUtils.SetActive(self.AimRed, true)
    else
        UnityUtils.SetActive(self.AimWhite, true)
        UnityUtils.SetActive(self.AimRed, false)
    end

    -----按键映射
    local flyInput = Fight.Instance.operationManager:GetKeyInput(FightEnum.KeyEvent.Drone_Fly) or zeroInput
    if flyInput.x == 1 then
        self:TempSetOperateButton(2, true)
        self:TempSetOperateButton(4, false)
    elseif flyInput.x == -1 then
        self:TempSetOperateButton(2, false)
        self:TempSetOperateButton(4, true)
    elseif flyInput.x == 0 then
        self:TempSetOperateButton(2, false)
        self:TempSetOperateButton(4, false)
    end

    if flyInput.y == 0 then
        self:TempSetOperateButton(1, false)
        self:TempSetOperateButton(3, false)
    elseif flyInput.y == -1 then
        self:TempSetOperateButton(1, false)
        self:TempSetOperateButton(3, true)
    elseif flyInput.y == 1 then
        self:TempSetOperateButton(1, true)
        self:TempSetOperateButton(3, false)
    end
end

function ControlDronePanel:TempSetOperateButton(index, isSelect)
    UnityUtils.SetActive(self.operateButton[index].Selected, isSelect)
    UnityUtils.SetActive(self.operateButton[index].Unselected, not isSelect)
    UnityUtils.SetActive(self.operateButton[index].TipsTextIcon, not isSelect)
    UnityUtils.SetActive(self.operateButton[index].SelectTipsTextIcon, isSelect)
end

--#endregion