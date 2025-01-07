ClickQTE = BaseClass("ClickQTE", QTEBase)
---@class ClickQTEParams
---@field instanceId
---@field prefab
---@field icon
---@field isShowCountDown
---@field isShowProgress
---@field anchorType
---@field posX
---@field posY
---@field duration
---@field times

function ClickQTE:__init()
    self:SetAsset("Prefabs/UI/QTE/ClickQTE.prefab")
    self.firstInit = true
    self.type = FightEnum.NewQTEType.Click
    self.progressItems = {}
    self.curClickTimes = 0
end

function ClickQTE:__delete()
    EventMgr.Instance:RemoveListener(EventName.ActionInput, self:ToFunc("OnActionInput"))
end

function ClickQTE:__onCache()
    for _, item in pairs(self.progressItems) do
        UnityUtils.SetLocalScale(item.objectTransform, 0, 0, 0)
        --GameObject.Destroy(item.ProgressItem)
    end
    self.countDownTween:Kill()
    LuaTimerManager.Instance:RemoveTimer(self.hideTimer)
    self.hideTimer = nil
    self.curClickTimes = 0
end

function ClickQTE:__BindListener()
    self.Button_btn.onClick:AddListener(self:ToFunc("OnClick_QTE"))
    EventMgr.Instance:AddListener(EventName.ActionInput, self:ToFunc("OnActionInput"))
    UtilsUI.SetInputImageChanger(self.InputTips)
end

function ClickQTE:CloseAllUI()
    -- PV专用
	if DebugClientInvoke.Cache.closeUI == true then
		UtilsUI.SetActiveByScale(self.gameObject,false)
		return
	else
		UtilsUI.SetActiveByScale(self.gameObject,true)
	end
end

function ClickQTE:__Show()

    if self.firstInit then
        self.firstInit = false
        self:SetParent(UIDefine.canvasRoot.transform)
        self.canvas = self:Find(nil, Canvas)
        self.canvas.overrideSorting = true
    end

    self:SetTopLayer(self.canvas)
    self.QTE_canvas.alpha = 1
    if #self.setting.icon > 4 then
        SingleIconLoader.Load(self.Icon, self.setting.icon)
    end
 
    self.TimeFill:SetActive(self.setting.isShowCountDown)
    if self.setting.isShowCountDown then
        self.TimeFill_img.fillAmount = 1
        self.countDownTween = self.TimeFill_img:DOFillAmount(0, self.setting.duration)
    end

    self.Progress:SetActive(self.setting.isShowProgress)
    if self.setting.isShowProgress then
        local fill = (1 - 0.005 * self.setting.times) / self.setting.times
        for i = 1, self.setting.times do
            local rotationZ = -((i - 1) * (360 / self.setting.times) - 0.9)
            if self.setting.times == 1 then
                rotationZ = 0
                fill = 1
            end
            local item = self.progressItems[i] or self:GetProgressItem()
            UnityUtils.SetLocalScale(item.objectTransform, 1, 1, 1)
            UnityUtils.SetLocalEulerAngles(item.objectTransform, 0, 0, rotationZ)
            item.ProgressItem_img.fillAmount = fill
            item.ProgressFill_img.fillAmount = fill
            item.ProgressFill:SetActive(false)
            item.ProgressItem:SetActive(true)
            self.progressItems[i] = item
        end
    end
    self:SetAnchorType(self.setting.anchorType)
    UnityUtils.SetAnchoredPosition(self.QTE.transform, self.setting.posX, self.setting.posY)
    UtilsUI.SetActive(self.UI_QTE_dianji, true)
    self:CallEntityBehavior("EnterQTE", FightEnum.NewQTEType.Click, self.qteId)
    self:CloseAllUI()
end

function ClickQTE:__ShowComplete()

end

function ClickQTE:OnActionInput(key, value)
    if key == FightEnum.ActionToKeyEvent.CommonQTE then
        self:OnClick_QTE()
    end
end

function ClickQTE:OnClick_QTE()
    if self.onHide then
        return
    end
    self.curClickTimes = self.curClickTimes + 1
    if self.curClickTimes <= self.setting.times then
        if self.setting.isShowProgress then
            self.progressItems[self.curClickTimes].ProgressFill:SetActive(true)
        end
    else
        return
    end

    self:CallEntityBehavior("ClickQTE", self.qteId)
    if self.curClickTimes == self.setting.times then
        self:OnExitQTE(true)
    end
end

function ClickQTE:GetProgressItem()
    local obj = self:PopUITmpObject("ProgressItem")
    obj.objectTransform:SetParent(self.Progress.transform)
    UnityUtils.SetLocalPosition(obj.objectTransform, 0, 0, 0)
    UtilsUI.GetContainerObject(obj.objectTransform, obj)

    return obj
end

function ClickQTE:CallEntityBehavior(name, ...)
    Fight.Instance.entityManager:CallBehaviorFun(name, ...)
end

function ClickQTE:OnExitQTE(isSuccess)
    self.onHide = true
    self:CallEntityBehavior("ExitQTE", FightEnum.NewQTEType.Click, isSuccess, self.qteId)
    self:StopAllEffect()
    self.QTE_canvas:DOFade(0, 0.3)
    local exitFunc = function()
        BehaviorFunctions.fight.clientFight.qteManager:StopQTE(self.qteId)
    end
    UtilsUI.SetActive(self.UI_QTE_dianji, false)
    LuaTimerManager.Instance:RemoveTimer(self.hideTimer)
    if not self.hideTimer then
        self.hideTimer = LuaTimerManager.Instance:AddTimer(1, 0.3, exitFunc)
    end
end

function ClickQTE:SetAnchorType(anchorType)
    if anchorType == FightEnum.QTEAnchorType.LeftTop then
        UnityUtils.SetAnchorMinAndMax(self.QTE.transform, 0, 1, 0, 1)
    elseif anchorType == FightEnum.QTEAnchorType.LeftBottom then
        UnityUtils.SetAnchorMinAndMax(self.QTE.transform, 0, 0, 0, 0)
    elseif anchorType == FightEnum.QTEAnchorType.RightTop then
        UnityUtils.SetAnchorMinAndMax(self.QTE.transform, 1, 1, 1, 1)
    elseif anchorType == FightEnum.QTEAnchorType.RightBottom then
        UnityUtils.SetAnchorMinAndMax(self.QTE.transform, 1, 0, 1, 0)
    else
        UnityUtils.SetAnchorMinAndMax(self.QTE.transform, 0.5, 0.5, 0.5, 0.5)
    end
end