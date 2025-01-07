SectionQTE = BaseClass("SectionQTE", QTEBase)
---@class SectionQTEParams
---@field instanceId
---@field prefab
---@field icon
---@field anchorType
---@field posX
---@field posY
---@field section
---@field duration
---@field addSpeed
---@field targetProgress

function SectionQTE:__init()
    self:SetAsset("Prefabs/UI/QTE/SectionQTE.prefab")
    self.firstInit = true
    self.type = FightEnum.NewQTEType.Section
end

function SectionQTE:__onCache()
    LuaTimerManager.Instance:RemoveTimer(self.QTEEndTimer)
    LuaTimerManager.Instance:RemoveTimer(self.hideTimer)
    self.QTEEndTimer = nil
    self.hideTimer = nil
end

function SectionQTE:__BindListener()
    self.Button_btn.onClick:AddListener(self:ToFunc("OnClick_QTE"))
end

function SectionQTE:__Hide()

end

function SectionQTE:__Show()
    if self.firstInit then
        self:SetParent(UIDefine.canvasRoot.transform)
        self.canvas = self:Find(nil, Canvas)
        self.canvas.overrideSorting = true
        self.firstInit = false
    end
    self.QTE_canvas.alpha = 1
    UnityUtils.SetLocalScale(self.SectionBg.transform, 1, 1, 1)
    self.curProgress = 0
    if #self.setting.icon > 4 then
        SingleIconLoader.Load(self.Icon, self.setting.icon)
    end

    self:SetAnchorType(self.setting.anchorType)
    UnityUtils.SetAnchoredPosition(self.QTE.transform, self.setting.posX, self.setting.posY)

    self:CallEntityBehavior("EnterQTE", FightEnum.NewQTEType.Click, self.qteId)
end

function SectionQTE:__ShowComplete()

end

function SectionQTE:OnClick_QTE()
    if self.onHide then
        return
    end
    self:CallEntityBehavior("ClickQTE", self.qteId)
    self.stop = true
    self:OnExitQTE()
end

function SectionQTE:_BeforeUpdate(deltaTime)
    if not self.active or self.stop then
        return
    end
    self.curProgress = self.curProgress + deltaTime * self.setting.addSpeed

    local scale = 1 - 0.3 * self.curProgress / self.setting.targetProgress
    if scale < 0.7 then
        scale = 0.7
        self.stop = true
        self:OnExitQTE()
    end
    UnityUtils.SetLocalScale(self.SectionBg.transform, scale, scale, scale)
end

function SectionQTE:CallEntityBehavior(name, ...)
    Fight.Instance.entityManager:CallBehaviorFun(name, ...)
end

function SectionQTE:OnExitQTE()
    self.onHide = true
    local sectionId = 0
    for id, section in pairs(self.setting.section) do
        if self.curProgress >= section[1] and self.curProgress <= section[2] then
            sectionId = id
            break
        end
    end
    self:CallEntityBehavior("ExitQTE", FightEnum.NewQTEType.Section, sectionId, self.qteId)
    --self.Button_btn.onClick:RemoveListener(self:ToFunc("OnClick_QTE"))
    self:StopAllEffect()
    self.QTE_canvas:DOFade(0, 0.3)
    local exitFunc = function()
        BehaviorFunctions.fight.clientFight.qteManager:StopQTE(self.qteId)
    end
    LuaTimerManager.Instance:RemoveTimer(self.QTEEndTimer)
    LuaTimerManager.Instance:RemoveTimer(self.hideTimer)
    if not self.hideTimer then
        self.hideTimer = LuaTimerManager.Instance:AddTimer(1, 0.3, exitFunc, 1)
    end
end

function SectionQTE:SetAnchorType(anchorType)
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
