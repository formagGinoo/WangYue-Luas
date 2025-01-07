---@class DebuffQTE : QTEBase
DebuffQTE = BaseClass("DebuffQTE", QTEBase)
---@class DebuffQTEParams
---@field instanceId
---@field duration
---@field buffType

function DebuffQTE:__init()
    self:SetAsset("Prefabs/UI/QTE/DebuffQTE.prefab")
    self.firstInit = true
    self.type = FightEnum.NewQTEType.Debuff
end

function DebuffQTE:__onCache()
    LuaTimerManager.Instance:RemoveTimer(self.hideTimer)
    self.hideTimer = nil
end

function ClickQTE:__Reset()

end

function DebuffQTE:__BindListener()
    self.Button_btn.onClick:AddListener(self:ToFunc("OnClick_QTE"))
    EventMgr.Instance:AddListener(EventName.ActionInput, self:ToFunc("OnActionInput"))
end

function DebuffQTE:__Hide()

end

function DebuffQTE:__Show()
    if self.firstInit then
        self:SetParent(UIDefine.canvasRoot.transform)
        self.canvas = self:Find(nil, Canvas)
        self.canvas.overrideSorting = true
        self.firstInit = true
    end

    self:SetTopLayer(self.canvas)
    self.QTE_canvas.alpha = 1
    self.Progress_img.fillAmount = 1
    self.ProgressDelta_img.fillAmount = 1
    self.deltaAdd = 0

    ---buff图标系统未完善，临时这么用
    SingleIconLoader.Load(self.Icon, "Textures/Icon/Single/BuffIcon/" .. self.setting.buffType .. ".png")

    UnityUtils.SetLocalScale(self.Icon.transform, 1.3, 1.3, 1.3)
    self:CallEntityBehavior("EnterQTE", FightEnum.NewQTEType.Click, self.qteId)
end

function DebuffQTE:__ShowComplete()

end

function DebuffQTE:OnActionInput(key, value)
    if key == FightEnum.ActionToKeyEvent.CommonQTE then
        self:OnClick_QTE()
    end
end

function DebuffQTE:OnClick_QTE()
    if self.onHide then
        return
    end
    if self.scaleTween then
        self.scaleTween:Kill()
    end
    UnityUtils.SetLocalScale(self.Icon.transform, 0.8, 0.8, 0.8)
    self.scaleTween = self.Icon.transform:DOScale(1.3, 0.2)
    self:CallEntityBehavior("ClickQTE", self.qteId)
end

function DebuffQTE:CallEntityBehavior(name, ...)
    Fight.Instance.entityManager:CallBehaviorFun(name, ...)
end

function DebuffQTE:OnExitQTE(isSuccess)
    self.onHide = true
    self:CallEntityBehavior("ExitQTE", FightEnum.NewQTEType.Click, isSuccess, self.qteId)
    self:StopAllEffect()
    self.QTE_canvas:DOFade(0, 0.3)
    local exitFunc = function()
        BehaviorFunctions.fight.clientFight.qteManager:StopQTE(self.qteId)
    end
    LuaTimerManager.Instance:RemoveTimer(self.hideTimer)
    self.hideTimer = LuaTimerManager.Instance:AddTimer(1, 0.3, exitFunc)
end

function DebuffQTE:_BeforeUpdate(deltaTime)
    local curFill = self.remainingTime / self.setting.duration
    self.Progress_img.fillAmount = curFill

    if self.lastClickTime then
        local deltaPercent = math.max(0, 0.5 - (self.lastClickTime - self.remainingTime)) / 0.5
        curFill = curFill + deltaPercent * self.deltaAdd
    end
    self.ProgressDelta_img.fillAmount = curFill
end

function DebuffQTE:ChangeQTETime(deltaTime)
    self.lastRemainingTime = self.remainingTime
    self.remainingTime = self.remainingTime + deltaTime
    if self.remainingTime <= 0 then
        self:OnExitQTE(false)
    end
    self.Progress_img.fillAmount = self.remainingTime / self.setting.duration

    self.lastClickTime = self.remainingTime
    self.deltaAdd = self.lastRemainingTime / self.setting.duration - self.remainingTime / self.setting.duration
end

