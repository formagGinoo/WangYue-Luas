AssassinQTE = BaseClass("AssassinQTE", QTEBase)
---@class AssassinQTEParams
---@field instanceId
---@field duration
---@field minTime
---@field maxTime

function AssassinQTE:__init()
    self:SetAsset("Prefabs/UI/QTE/AssassinQTE.prefab")
    self.firstInit = true
    self.type = FightEnum.NewQTEType.Assassin
end

function AssassinQTE:__onCache()
    LuaTimerManager.Instance:RemoveTimer(self.QTEEndTimer)
    LuaTimerManager.Instance:RemoveTimer(self.hideTimer)
    self.QTEEndTimer = nil
    self.hideTimer = nil

    self.Perfect_Kill_Section:SetActive(false)

    self["22095"]:SetActive(false)
    self["22083"]:SetActive(false)
end

function AssassinQTE:__BindListener()
    self.Button_btn.onClick:AddListener(self:ToFunc("OnClick_QTE"))
end

function AssassinQTE:__Show()
    if self.firstInit then
        self.firstInit = false
        self:SetParent(UIDefine.canvasRoot.transform)
        self.canvas = self:Find(nil, Canvas)
        self.canvas.overrideSorting = true
    end

    self:SetTopLayer(self.canvas)
    self.QTE_canvas.alpha = 1
    self.TimeScale_canvas.alpha = 1

    self.curProgress = 0
    self.time = 0
    self.active = false
    self.minPercent = self.setting.minTime / self.setting.duration
    self.maxPercent = self.setting.maxTime / self.setting.duration

    --self:SetAnchorType(self.setting.anchorType)
    --UnityUtils.SetAnchoredPosition(self.QTE.transform, self.setting.posX, self.setting.posY)
    --根据点击范围设置图片大小
    --设置白圈->100%
    UnityUtils.SetLocalScale(self.TimeScale.transform, 1, 1, 1)
    --设置红色外圈
    UnityUtils.SetLocalScale(self.StartTime.transform, (1 - self.minPercent) / 0.623, (1 - self.minPercent) / 0.623, 1)
    --设置红色镂空
    local time = (1 - self.maxPercent) / 0.1154
    UnityUtils.SetSizeDelata(self.Mask.transform, 164 * time, 128 * time)
    --设置红色内圈
    UnityUtils.SetLocalScale(self.EndTime.transform, 0.26 * time, 0.26 * time, 1)

    self.LoseTip:SetActive(false)
    self.SuccessTip:SetActive(false)
    self.PerfectTip:SetActive(false)
    self.AssassinQTE_Click:SetActive(false)


    self:CallEntityBehavior("EnterQTE", FightEnum.NewQTEType.Assassin, self.qteId)
    self.active = true
end

function AssassinQTE:__ShowComplete()

end

function AssassinQTE:OnClick_QTE()
    if self.onHide then
        return
    end
    self:CallEntityBehavior("ClickQTE", self.qteId)
    self.AssassinQTE_Click:SetActive(true)
    self["22095"]:SetActive(false)
    self.onHide = true
    self:OnExitQTE(true)
end

function AssassinQTE:_BeforeUpdate(deltaTime)
    if not self.active or self.onHide then
        return
    end
    self.time = self.time + deltaTime

    self.curProgress = self.time / self.setting.duration
    local scale = 1 - self.curProgress

    if self.curProgress > self.maxPercent + 0.05 then
        self.TimeScale_canvas.alpha = 0.5
    end
    local isInPerfect = self.curProgress < self.maxPercent and self.curProgress > self.minPercent
    self["22095"]:SetActive(isInPerfect)
    self["22083"]:SetActive(isInPerfect)
    if scale < 0 then
        scale = 0
    end
    UnityUtils.SetLocalScale(self.TimeScale.transform, scale, scale, scale)
end

function AssassinQTE:CallEntityBehavior(name, ...)
    Fight.Instance.entityManager:CallBehaviorFun(name, ...)
end

function AssassinQTE:OnExitQTE(isSuccess)
    self.onHide = true
    local result = 0
    if isSuccess then
        result = 1
        if self.curProgress < self.maxPercent and self.curProgress > self.minPercent then
            result = 2
            mod.SystemTaskCtrl:RecordClinetEvent(SystemTaskConfig.EventType.PerfectAssassinate)
        end
    end
    self["22083"]:SetActive(false)
    ---显示暗杀结果
    if result == 0 then
        self.LoseTip:SetActive(true)
    elseif result == 1 then
        self.SuccessTip:SetActive(true)
        self["22084"]:SetActive(true)
    elseif result == 2 then
        self.PerfectTip:SetActive(true)
        self.Perfect_Kill_Section:SetActive(true)
        self["22085"]:SetActive(true)
    end

    self:CallEntityBehavior("EndAssassinQTE", self.qteId, result)
    self:CallEntityBehavior("ExitQTE", FightEnum.NewQTEType.Assassin, isSuccess, self.qteId)
    --self.Button_btn.onClick:RemoveListener(self:ToFunc("OnClick_QTE"))
    self:StopAllEffect()
    local exitFunc = function()
        BehaviorFunctions.fight.clientFight.qteManager:StopQTE(self.qteId)
    end
    LuaTimerManager.Instance:RemoveTimer(self.QTEEndTimer)
    LuaTimerManager.Instance:RemoveTimer(self.hideTimer)

    LuaTimerManager.Instance:AddTimer(1, 1, function()
        self.QTE_canvas:DOFade(0, 1)
    end)
    if not self.hideTimer then
        self.hideTimer = LuaTimerManager.Instance:AddTimer(1, 2, exitFunc)
    end
end