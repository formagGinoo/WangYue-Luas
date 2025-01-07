HoldQTE = BaseClass("HoldQTE", QTEBase)
---@class HoldQTEParams
---@field instanceId
---@field prefab
---@field icon
---@field isShowProgress
---@field anchorType
---@field posX
---@field posY
---@field duration
---@field holdTime

function HoldQTE:__init()
    self:SetAsset("Prefabs/UI/QTE/HoldQTE.prefab")
    self.firstInit = true
    self.type = FightEnum.NewQTEType.Hold
end

function HoldQTE:__onCache()
    LuaTimerManager.Instance:RemoveTimer(self.QTEEndTimer)
    LuaTimerManager.Instance:RemoveTimer(self.hideTimer)
    self.QTEEndTimer = nil
    self.hideTimer = nil
end

function HoldQTE:__BindListener()
    local dragBehaviour = self.Button:AddComponent(UIDragBehaviour)
    dragBehaviour.onPointerDown = function(data)
        self:OnHold()
    end
    dragBehaviour.onPointerUp = function(data)
        self:OnStopHold()
    end
end

function HoldQTE:__Hide()

end

function HoldQTE:__Show()
    if self.firstInit then
        self:SetParent(UIDefine.canvasRoot.transform)
        self.canvas = self:Find(nil, Canvas)
        self.canvas.overrideSorting = true
        self.firstInit = false
    end

    self:SetTopLayer(self.canvas)
    self.QTE_canvas.alpha = 1
    UnityUtils.SetLocalScale(self.Hold.transform, 0, 0, 0)

    self.curHoldTime = 0
    if #self.setting.icon > 4 then
        SingleIconLoader.Load(self.Icon, self.setting.icon)
    end

    self.Hold:SetActive(self.setting.isShowProgress)

    self:SetAnchorType(self.setting.anchorType)
    UnityUtils.SetAnchoredPosition(self.QTE.transform, self.setting.posX, self.setting.posY)

    self:CallEntityBehavior("EnterQTE", FightEnum.NewQTEType.Click, self.qteId)
end

function HoldQTE:__ShowComplete()

end

function HoldQTE:OnHold()
    if self.onHold or self.stop then
        return
    end
    self:CallEntityBehavior("EnterHoldQTE", self.qteId)
    self.onHold = true
end

function HoldQTE:OnStopHold()
    self:CallEntityBehavior("ClickQTE", self.qteId)
    self.stop = true
    self.onHold = false
    self:OnExitQTE()
end

function HoldQTE:_BeforeUpdate(deltaTime)
    if not self.active or not self.onHold then
        return
    end
    self.curHoldTime = self.curHoldTime + deltaTime

    local scale = 0.65 + 0.35 * self.curHoldTime / self.setting.holdTime
    if scale > 1 then
        scale = 1
        self.onHold = false
        self:OnExitQTE()
    end
    UnityUtils.SetLocalScale(self.Hold.transform, scale, scale, scale)
end

function HoldQTE:CallEntityBehavior(name, ...)
    Fight.Instance.entityManager:CallBehaviorFun(name, ...)
end

function HoldQTE:OnExitQTE()
    self.onHide = true
    local progress = self.curHoldTime / self.setting.holdTime > 1 and 1 or self.curHoldTime / self.setting.holdTime
    self:CallEntityBehavior("ExitQTE", FightEnum.NewQTEType.Hold, progress, self.qteId)
    self:StopAllEffect()
    self.QTE_canvas:DOFade(0, 0.3)
    local exitFunc = function()
        BehaviorFunctions.fight.clientFight.qteManager:StopQTE(self.qteId)
    end
    LuaTimerManager.Instance:RemoveTimer(self.QTEEndTimer)
    LuaTimerManager.Instance:RemoveTimer(self.hideTimer)
    if not self.hideTimer then
        self.hideTimer = LuaTimerManager.Instance:AddTimer(1, 0.3, exitFunc)
    end
end

function HoldQTE:SetAnchorType(anchorType)
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
