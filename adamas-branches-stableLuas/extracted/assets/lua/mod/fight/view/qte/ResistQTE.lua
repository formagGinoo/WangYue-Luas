ResistQTE = BaseClass("ResistQTE", QTEBase)
---@class ResistQTEParams
---@field instanceId
---@field prefab
---@field icon
---@field anchorType
---@field posX
---@field posY
---@field addSpeed
---@field subSpeed
---@field duration
---@field addCurveId
---@field subCurveId

function ResistQTE:__init()
    self:SetAsset("Prefabs/UI/QTE/ResistQTE.prefab")
    self.firstInit = true
    self.type = FightEnum.NewQTEType.Resist
end

function ResistQTE:__BindListener()
    self.Button_btn.onClick:AddListener(self:ToFunc("OnClick_QTE"))
end

function ResistQTE:__Hide()

end

function ResistQTE:__Show()
    if self.firstInit then
        self:SetParent(UIDefine.canvasRoot.transform)
        self.canvas = self:Find(nil, Canvas)
        self.canvas.overrideSorting = true
        self.firstInit = false
    end
    self:SetTopLayer(self.canvas)

    self.curProgress = 50
    self.clickTimes = 0
    self.frame = 0

    self.addCurve = CurveConfig.GetCurve(1000, self.setting.addCurveId)
    self.subCurve = CurveConfig.GetCurve(1000, self.setting.subCurveId)

    self.Slider_sld.value = self.curProgress * 0.01
    self.SliderResist_img.fillAmount = 1 - self.curProgress * 0.01

    if #self.setting.icon > 4 then
        SingleIconLoader.Load(self.Icon, self.setting.icon)
    end

    self:SetAnchorType(self.setting.anchorType)
    UnityUtils.SetAnchoredPosition(self.QTE.transform, self.setting.posX, self.setting.posY)

    self:CallEntityBehavior("EnterQTE", FightEnum.NewQTEType.Resist, self.qteId)
end

function ResistQTE:__ShowComplete()

end

function ResistQTE:__onCache()
end

function ResistQTE:OnClick_QTE()
    if self.onHide then
        return
    end
    self.clickTimes = self.clickTimes + 1 > #self.addCurve and self.clickTimes or self.clickTimes + 1
    self.curProgress = self.curProgress + self.setting.addSpeed * self.addCurve[self.clickTimes]
    self:CallEntityBehavior("ClickQTE", self.qteId)

    self:UpdateProgress()
end

function ResistQTE:Update(lerpTime)
    if not self.active then
        return
    end

    self.frame = self.frame + 1
    local second = math.ceil(FightUtil.deltaTimeSecond * self.frame)
    second = second < #self.subCurve and second or #self.subCurve

    self.curProgress = self.curProgress - self.setting.subSpeed * self.subCurve[second] * FightUtil.deltaTimeSecond

    self:UpdateProgress()
end

function ResistQTE:UpdateProgress()
    self.Slider_sld.value = self.curProgress * 0.01
    self.SliderResist_img.fillAmount = 1 - self.curProgress * 0.01

    if self.curProgress > 52 then
        self.GreaterEffect:SetActive(true)
        self.EqualEffect:SetActive(false)
        self.LessEffect:SetActive(false)
    elseif self.curProgress > 48 then
        self.GreaterEffect:SetActive(false)
        self.EqualEffect:SetActive(true)
        self.LessEffect:SetActive(false)
    else
        self.GreaterEffect:SetActive(false)
        self.EqualEffect:SetActive(false)
        self.LessEffect:SetActive(true)
    end

    if self.curProgress >= 100 then
        self:OnExitQTE(true)
    elseif self.curProgress <= 0 then
        self:OnExitQTE(false)
    end
end

function ResistQTE:CallEntityBehavior(name, ...)
    Fight.Instance.entityManager:CallBehaviorFun(name, ...)
end

function ResistQTE:OnExitQTE(isSuccess)
    self.onHide = true
    --self.Button_btn.onClick:RemoveListener(self:ToFunc("OnClick_QTE"))
    self:StopAllEffect()
    self:CallEntityBehavior("ExitQTE", FightEnum.NewQTEType.Resist, isSuccess, self.qteId)
    BehaviorFunctions.fight.clientFight.qteManager:StopQTE(self.qteId)
end

function ResistQTE:SetAnchorType(anchorType)
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
