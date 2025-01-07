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

function DebuffQTE:__Reset()

end

function DebuffQTE:__BindListener()
    self.Button_btn.onClick:AddListener(self:ToFunc("OnClick_QTE"))
    EventMgr.Instance:AddListener(EventName.ActionInput, self:ToFunc("OnActionInput"))
end

function DebuffQTE:__Hide()

end

function DebuffQTE:__Show()
    if self.firstInit then
        local mainUI = WindowManager.Instance:GetWindow("FightMainUIView")
        self:SetParent(mainUI.transform)
        self.canvas = self:Find(nil, Canvas)
        self.canvas.overrideSorting = true
        self.firstInit = true
    end

    self:SetTopLayer(self.canvas)
    self.QTE_canvas.alpha = 1
    self.Progress_img.fillAmount = 1
    self.ProgressDelta_img.fillAmount = 1
    self.deltaAdd = 0
    self:SetBuffTypeIcon(self.setting.buffType)
    UtilsUI.SetInputImageChanger(self.InputTips)
    UnityUtils.SetLocalScale(self.QTE.transform, 1, 1, 1)
    self:CallEntityBehavior("EnterQTE", FightEnum.NewQTEType.Click, self.qteId)
end

local ColorByType = 
{
    [FightEnum.DebuffQTEType.Freeze] = "#7cdfe5", 
    [FightEnum.DebuffQTEType.Stun] = "#f6d383", 
    [FightEnum.DebuffQTEType.Charm] = "#ef66a0", 

}

function DebuffQTE:SetBuffTypeIcon(type)
    UtilsUI.SetActive(self.Icon, type ~= FightEnum.DebuffQTEType.Stun)
    SingleIconLoader.Load(self.Icon, "Textures/Icon/Single/BuffQTEIcon/" .. type .. "_Icon.png")
    SingleIconLoader.Load(self.Bg, "Textures/Icon/Single/BuffQTEIcon/" .. type .. "_Bg.png")
    UtilsUI.SetImageColor(self.Progress_img, ColorByType[type])
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
    UnityUtils.SetLocalScale(self.QTE.transform, 0.9, 0.9, 0.9)
    self.scaleTween = self.QTE.transform:DOScale(1, 0.2)
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

