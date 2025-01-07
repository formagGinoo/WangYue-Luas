SwitchQTE = BaseClass("SwitchQTE", QTEBase)
---@class SwitchQTEParams
---@field instanceId
---@field duration
local DataHero = Config.DataHeroMain.Find
local SwitchType = {
    Single = 1,
    Double = 2,
    Three = 3,
}

function SwitchQTE:__init()
    self:SetAsset("Prefabs/UI/QTE/NewSwitchQTE.prefab")
    self.firstInit = true
    self.type = FightEnum.NewQTEType.Switch
    self.switchRoleInfo = self.switchRoleInfo or {}
end

function SwitchQTE:__onCache()
    LuaTimerManager.Instance:RemoveTimer(self.QTEEndTimer)
    self.QTEEndTimer = nil
    if self.setting.duration == 0 then
        LogError("SwitchQTE 持续时间不能为0 ")
    end
    self.onHide = true
    TableUtils.ClearTable(self.switchRoleInfo)
end

function SwitchQTE:__Reset()
    self.onHide = true
end

function SwitchQTE:__BindListener()
    self.kaiqi_hcb.HideAction:AddListener(self:ToFunc("OpenCallBack"))
    self.guanbi_hcb.HideAction:AddListener(self:ToFunc("CloseCallBack"))
    self.SingleHeadButton_btn.onClick:AddListener(self:ToFunc("OnClick_SingleHead"))
    self.RightHeadButton_btn.onClick:AddListener(self:ToFunc("OnClick_RightHead"))
    self.LeftHeadButton_btn.onClick:AddListener(self:ToFunc("OnClick_LeftHead"))
    self.ThreeLeftHeadButton_btn.onClick:AddListener(self:ToFunc("OnClick_ThreeLeft"))
    self.ThreeCenterHeadButton_btn.onClick:AddListener(self:ToFunc("OnClick_ThreeCenter"))
    self.ThreeRightHeadButton_btn.onClick:AddListener(self:ToFunc("OnClick_ThreeRight"))
    EventMgr.Instance:AddListener(EventName.ActionInput, self:ToFunc("OnActionInput"))
end

function SwitchQTE:__Hide()

end

function SwitchQTE:__Show()
    if self.firstInit then
        self:SetParent(UIDefine.canvasRoot.transform)
        self.canvas = self:Find(nil, Canvas)
        self.canvas.overrideSorting = true
        self.firstInit = false
    end
    self:SetTopLayer(self.canvas)

    self.formationInfo = mod.FormationCtrl:GetCurFormationInfo()
    local entity = Fight.Instance.entityManager:GetEntity(self.setting.instanceId)
    self.curRoleId = entity.masterId
    self.foreInstanceId = self.setting.instanceId
    self.curDurationTime = 0

    for index, roleId in pairs(self.formationInfo.roleList) do
        local instanceId = Fight.Instance.playerManager:GetPlayer():GetInstanceIdByHeroId(roleId)
        if BehaviorFunctions.CheckEntity(instanceId) then
            local data = { roleId = roleId, index = index, instanceId = instanceId }
            if roleId ~= self.curRoleId then
                table.insert(self.switchRoleInfo, data)
            else
                table.insert(self.switchRoleInfo, 1, data)
            end
        end
    end

    local formationRoleCount = #self.switchRoleInfo
    if formationRoleCount == 0 then
        Fight.Instance.clientFight.qteManager:StopQTE(self.qteId)
        return
    end

    if formationRoleCount == 1 then
        self.switchType = SwitchType.Single
    elseif formationRoleCount == 2 then
        self.switchType = SwitchType.Double
    elseif formationRoleCount == 3 then
        self.switchType = SwitchType.Three
    end
    self:SetObjActive(self.Single, formationRoleCount == 1)
    self:SetObjActive(self.Double, formationRoleCount == 2)
    self:SetObjActive(self.DoubleLeft, formationRoleCount == 2)
    self:SetObjActive(self.Three, formationRoleCount == 3)

    local timeText = string.format("%02d:%02d:%02d", math.floor(self.setting.duration / 60), math.floor(self.setting.duration % 60), math.floor(self.setting.duration % 1 * 60))
    --TODO 增加奥义名
    if self.switchType == SwitchType.Single then
        SingleIconLoader.Load(self.SingleHeadIcon, DataHero[self.switchRoleInfo[1].roleId].head_icon)
        self.SingleProgress_img.fillAmount = 1
        self.SingleCountDown_txt.text = timeText
        self:SetObjActive(self.SingleProgressBg, true)
    elseif self.switchType == SwitchType.Double then
        SingleIconLoader.Load(self.RightHeadIcon, DataHero[self.switchRoleInfo[1].roleId].head_icon)
        SingleIconLoader.Load(self.LeftHeadIcon, DataHero[self.switchRoleInfo[2].roleId].head_icon)
        --UnityUtils.SetSizeDelata(self.DoubleProgressMask.transform, 474, 40)
        self.DoubleCountDown_txt.text = timeText
        self:SetObjActive(self.DoubleProgressBg, true)
    elseif self.switchType == SwitchType.Three then
        SingleIconLoader.Load(self.ThreeCenterHeadIcon, DataHero[self.switchRoleInfo[1].roleId].head_icon)
        SingleIconLoader.Load(self.ThreeLeftHeadIcon, DataHero[self.switchRoleInfo[2].roleId].head_icon)
        SingleIconLoader.Load(self.ThreeRightHeadIcon, DataHero[self.switchRoleInfo[3].roleId].head_icon)
        --UnityUtils.SetSizeDelata(self.ThreeProgressMask.transform, 580 + 130, 97)
        self.ThreeCountDown_txt.text = timeText
        self:SetObjActive(self.ThreeProgressBg, true)
    end

    self:CallEntityBehavior("EnterQTE", FightEnum.NewQTEType.Switch, self.qteId)
end

function SwitchQTE:__ShowComplete()

end

function SwitchQTE:OpenCallBack()
    if self.switchType == SwitchType.Single then
        self:SetObjActive(self.SingleCountDown, true)
    elseif self.switchType == SwitchType.Double then
        self:SetObjActive(self.DoubleCountDown, true)
    elseif self.switchType == SwitchType.Three then
        self:SetObjActive(self.ThreeCountDown, true)
    end
    self.onHide = false
end

function SwitchQTE:CloseCallBack()
    self:StopAllEffect()
    Fight.Instance.clientFight.qteManager:StopQTE(self.qteId)
end

function SwitchQTE:OnClick_SingleHead()
    if self.onHide then return end
    self:CallEntityBehavior("ClickQTE", self.qteId)
    self:OnExitQTE(true, self.switchRoleInfo[1].instanceId, self.switchRoleInfo[1].index)
    self.Timeline_Single_Click:SetActive(true)
    self.SingleCountDown:SetActive(false)
end

function SwitchQTE:OnClick_LeftHead()
    if self.onHide then return end
    self:CallEntityBehavior("ClickQTE", self.qteId)
    self:OnExitQTE(true, self.switchRoleInfo[2].instanceId, self.switchRoleInfo[2].index)
    self.Timeline_DoubleLeft_Click:SetActive(true)
    self.Timeline_DoubleRight_off:SetActive(true)
    self.DoubleCountDown:SetActive(false)
end

function SwitchQTE:OnClick_RightHead()
    if self.onHide then return end
    self:CallEntityBehavior("ClickQTE", self.qteId)
    self:OnExitQTE(true, self.switchRoleInfo[1].instanceId, self.switchRoleInfo[1].index)
    self.Timeline_DoubleRight_Click:SetActive(true)
    self.Timeline_DoubleLeft_off:SetActive(true)
    self.DoubleCountDown:SetActive(false)
end

function SwitchQTE:OnClick_ThreeCenter()
    if self.onHide then return end
    self:CallEntityBehavior("ClickQTE", self.qteId)
    self:OnExitQTE(true, self.switchRoleInfo[1].instanceId, self.switchRoleInfo[1].index)
    self.Timeline_ThreeCenter_Click:SetActive(true)
    self.Timeline_ThreeLeft_off:SetActive(true)
    self.Timeline_ThreeRight_off:SetActive(true)
    self.ThreeCountDown:SetActive(false)
end

function SwitchQTE:OnClick_ThreeLeft()
    if self.onHide then return end
    self:CallEntityBehavior("ClickQTE", self.qteId)
    self:OnExitQTE(true, self.switchRoleInfo[2].instanceId, self.switchRoleInfo[2].index)
    self.Timeline_ThreeLeft_Click:SetActive(true)
    self.Timeline_ThreeCenter_off:SetActive(true)
    self.Timeline_ThreeRight_off:SetActive(true)
    self.ThreeCountDown:SetActive(false)
end

function SwitchQTE:OnClick_ThreeRight()
    if self.onHide then return end
    self:CallEntityBehavior("ClickQTE", self.qteId)
    self:OnExitQTE(true, self.switchRoleInfo[3].instanceId, self.switchRoleInfo[3].index)
    self.Timeline_ThreeRight_Click:SetActive(true)
    self.Timeline_ThreeLeft_off:SetActive(true)
    self.Timeline_ThreeCenter_off:SetActive(true)
    self.ThreeCountDown:SetActive(false)
end

function SwitchQTE:OnActionInput(key, value)
    if self.switchType == SwitchType.Single then
        if key == FightEnum.ActionToKeyEvent.Change1 then
            self:OnClick_SingleHead()
        end
    elseif self.switchType == SwitchType.Double then
        if key == FightEnum.ActionToKeyEvent.Change1 then
            self:OnClick_LeftHead()
        elseif key == FightEnum.ActionToKeyEvent.Change2 then
            self:OnClick_RightHead()
        end
    elseif self.switchType == SwitchType.Three then
        if key == FightEnum.ActionToKeyEvent.Change1 then
            self:OnClick_ThreeLeft()
        elseif key == FightEnum.ActionToKeyEvent.Change2 then
            self:OnClick_ThreeCenter()
        elseif key == FightEnum.ActionToKeyEvent.Chang3 then
            self:OnClick_RightHead()
        end
    end
end

function SwitchQTE:_BeforeUpdate(deltaTime)
    if not self.active then
        return
    end
    self.curDurationTime = self.curDurationTime + deltaTime
    local fill = 1 - self.curDurationTime / self.setting.duration
    fill = fill < 0 and 0 or fill
    local lastTime = self.setting.duration * fill
    local timeText = string.format("%02d:%02d:%02d", math.floor(lastTime / 60), math.floor(lastTime % 60), math.floor(lastTime % 1 * 60))

    if self.switchType == SwitchType.Single then
        self.SingleProgress_img.fillAmount = fill
        self.SingleCountDown_txt.text = timeText
    elseif self.switchType == SwitchType.Double then
        UnityUtils.SetSizeDelata(self.DoubleProgressMask.transform, 474 * fill, 40)
        self.DoubleCountDown_txt.text = timeText
    elseif self.switchType == SwitchType.Three then
        UnityUtils.SetSizeDelata(self.ThreeProgressMask.transform, 580 * fill + 130, 97)
        self.ThreeCountDown_txt.text = timeText
    end
end

function SwitchQTE:CallEntityBehavior(name, ...)
    Fight.Instance.entityManager:CallBehaviorFun(name, ...)
end

function SwitchQTE:OnExitQTE(isClick, BackInstanceId, index)
    self.onHide = true
    if not isClick then
        if self.switchType == SwitchType.Single then
            self.Timeline_Single_off:SetActive(true)
        elseif self.switchType == SwitchType.Double then
            self.Timeline_DoubleRight_off:SetActive(true)
            self.Timeline_DoubleLeft_off:SetActive(true)
        elseif self.switchType == SwitchType.Three then
            self.Timeline_ThreeCenter_off:SetActive(true)
            self.Timeline_ThreeLeft_off:SetActive(true)
            self.Timeline_ThreeRight_off:SetActive(true)
        end
        self.QTEEndTimer = LuaTimerManager.Instance:AddTimer(1, 0.5, function()
            self:CloseCallBack()
        end)
    end

    self:CallEntityBehavior("ExitQTE", FightEnum.NewQTEType.Switch, BackInstanceId ~= nil, self.qteId)
    self:CallEntityBehavior("SwitchQTE", self.foreInstanceId, BackInstanceId, index, isClick)
    self.SingleProgressBg:SetActive(false)
    self.DoubleProgressBg:SetActive(false)
    self.ThreeProgressBg:SetActive(false)
end