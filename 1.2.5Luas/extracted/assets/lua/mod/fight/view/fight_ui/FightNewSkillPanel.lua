FightNewSkillPanel = BaseClass("FightNewSkillPanel", BasePanel)

local _sin = math.sin
local _cos = math.cos

local SkillBtn2Event = FightEnum.SkillBtn2Event
local BehaviorBtn2Events = FightEnum.BehaviorBtn2Events
local KeyEvent2Btn = FightEnum.KeyEvent2Btn

local BtnGroup = {
    Normal = {
        ["J"] = SkillBtn2Event.J,
        ["K"] = SkillBtn2Event.K,
        ["L"] = SkillBtn2Event.L,
        ["I"] = SkillBtn2Event.I,
        ["O"] = SkillBtn2Event.O,
        ["R"] = SkillBtn2Event.R,
        ["F"] = SkillBtn2Event.F,
    },
    Climb = {
        ["X"] = BehaviorBtn2Events.X,
        ["JR"] = BehaviorBtn2Events.JR,
    },
    Swim = {
        ["SW"] = BehaviorBtn2Events.SW,
    },
}

local CommonEffect = {
    AddCharge = "20011",
    ReduceCharge = "20012",
    OnClick = "21052",
    DefaultReady = "22058",
    DefaultReadyLoop = "22047",
    DefaultCast = "20034"
}

local NormalClickEffect = "21052"
local SpecialClickEffect = {
	["J"] = "22029",
}

local DisableAlpha = {
	I = 0.2,
    R = 0.2,
    L = 0.2
}

local PowerCircleSetting = {
    MaxFillAmount = 0.325,
    EndPowerAngle = -117,
}

function FightNewSkillPanel:__init(parent)
    self:SetAsset("Prefabs/UI/Fight/FightNewSkillPanel.prefab")
    self.mainView = parent
    self.btns = {}
	self.btnAlpha = {}
    self.effectMap = {}

	self.coreUI = {}
end

function FightNewSkillPanel:__BaseShow()
    self:SetParent(self.mainView.PanelParent.transform)
end

function FightNewSkillPanel:__BindEvent()
    EventMgr.Instance:AddListener(EventName.UpdateSkillInfo, self:ToFunc("UpdateSkillInfo"))
    EventMgr.Instance:AddListener(EventName.PlaySkillUIEffect, self:ToFunc("PlayEffectByBtnName"))
    EventMgr.Instance:AddListener(EventName.StopSkillUIEffect, self:ToFunc("StopEffectByBtnName"))
    EventMgr.Instance:AddListener(EventName.CastSkillUIEffect, self:ToFunc("CastSkillUIEffect"))
    EventMgr.Instance:AddListener(EventName.ChangeButtonConfig, self:ToFunc("ChangeButtonConfig"))
    --EventMgr.Instance:AddListener(EventName.PlayerUpdate, self:ToFunc("UpdatePlayer"))
    EventMgr.Instance:AddListener(EventName.PlayClickEffect, self:ToFunc("PlayClickEffect"))
end

function FightNewSkillPanel:__delete()
    EventMgr.Instance:RemoveListener(EventName.UpdateSkillInfo, self:ToFunc("UpdateSkillInfo"))
    EventMgr.Instance:RemoveListener(EventName.PlaySkillUIEffect, self:ToFunc("PlayEffectByBtnName"))
    EventMgr.Instance:RemoveListener(EventName.StopSkillUIEffect, self:ToFunc("StopEffectByBtnName"))
    EventMgr.Instance:RemoveListener(EventName.CastSkillUIEffect, self:ToFunc("CastSkillUIEffect"))
    EventMgr.Instance:RemoveListener(EventName.ChangeButtonConfig, self:ToFunc("ChangeButtonConfig"))
    --EventMgr.Instance:RemoveListener(EventName.PlayerUpdate, self:ToFunc("UpdatePlayer"))
	EventMgr.Instance:RemoveListener(EventName.PlayClickEffect, self:ToFunc("PlayClickEffect"))
	
	for k, v in pairs(self.coreUI) do
		v:Cache()
	end
	self.coreUI = {}
end

function FightNewSkillPanel:__Show()
    --记录按钮对象
	local btnParent = {"NormalButton", "ClimbButton", "SwimButton"}
    for i = 1, #btnParent do
        for j = 0, self[btnParent[i]].transform.childCount - 1 do
            local trans = self[btnParent[i]].transform:GetChild(j)
            local btn = {}
            btn.gameObject = trans.gameObject
			btn.transform = trans
            UtilsUI.GetContainerObject(btn.transform, btn)
			local name = string.gsub(trans.name, "_", "")
			self.btns[name] = btn
            --默认透明度全部统一成1
			--self.btnAlpha[name] = self.btns[name].Icon_img.color.a
            self.btnAlpha[name] = 1
        end
    end

    --注册按钮事件
	for btnName, keyEvent in pairs(SkillBtn2Event) do
		if self.btns[btnName] and self.btns[btnName].Button then
			self:RegisterSkillBtnEvent(self.btns[btnName].Button, btnName, {keyEvent})
		end
	end

	for btnName, keyEvents in pairs(BehaviorBtn2Events) do
		if self.btns[btnName] and self.btns[btnName].Button then
			self:RegisterSkillBtnEvent(self.btns[btnName].Button, btnName, keyEvents)
		end
	end
    self:SetInputImageChanger()
end

function FightNewSkillPanel:__ShowComplete()
    self.loadDone = true
    self.mainView:AddLoadDoneCount()
	self:UpdatePlayer()
end

--更新技能界面（按组成刷新,拆分每个图层的逻辑）

function FightNewSkillPanel:Update()
    local stateComponent = self.mainView.playerObject.stateComponent
	local isClimbState = stateComponent:IsState(FightEnum.EntityState.Climb)
	local isSwimState = stateComponent:IsState(FightEnum.EntityState.Swim)
	local isNormal = not isClimbState and not isSwimState

    if self.NormalButton_active ~= isNormal then
        self.NormalButton_active = isNormal
        self.NormalButton:SetActive(isNormal)
        if isNormal then
            self:HideAllBaseEffect() --激活界面时关闭掉不必要的特效
        end
        --BehaviorFunctions.ClearAllInput()
    end
    if self.ClimbButton_active ~= isClimbState then
        self.ClimbButton_active = isClimbState
        self.ClimbButton:SetActive(isClimbState)
        --BehaviorFunctions.ClearAllInput()
    end

    if self.SwimButton_active ~= isSwimState then
        self.SwimButton_active = isSwimState
        self.SwimButton:SetActive(isSwimState)
        --BehaviorFunctions.ClearAllInput()
    end
	
	for k, v in pairs(self.coreUI) do
		if v.enable then
			v:Update()
		end
	end
end

--注册按钮事件可能是复合key
function FightNewSkillPanel:RegisterSkillBtnEvent(gameObject, btnName, keys)
    local pointer = gameObject:GetComponent(UIDragBehaviour)
    if pointer then
        pointer.onPointerDown = nil
        pointer.onPointerUp = nil
        pointer.onDrag = nil
    else
        pointer = gameObject:AddComponent(UIDragBehaviour)
    end

    for _, key in pairs(keys) do
        UtilsUI.SetHideCallBack(gameObject, function ()
            if self.mainView then
                self.mainView:KeyUp(key) 
            end
        end)
    end

    local down = function (data)
        for _, v in pairs(keys) do
			self.mainView:KeyDown(v)
		end
    end

    local up = function (data)
        for _, v in pairs(keys) do
			self.mainView:KeyUp(v)
		end
    end

    local drag = function(data)
		FightMainUIView.btnInput.x = data.delta.x
		FightMainUIView.btnInput.y = data.delta.y
	end

	pointer.onPointerDown = down--{"+=", down}
	pointer.onPointerUp = up--{"+=", up}
	pointer.onDrag = drag
end

--更换角色(切换到对应配置，对应技能状态)
function FightNewSkillPanel:UpdatePlayer()
    if not self.loadDone or not self.mainView.player then return end
	local lastRoleId = self.playerObject and self.playerObject.masterId or -1
    self.playerObject = self.mainView.playerObject
    self.skillSetComponent = self.playerObject.skillSetComponent
    self:UpdatePlayerSkillList()
	self:UpdateCoreUI(lastRoleId)
end

function FightNewSkillPanel:UpdateCoreUI(lastRoleId)

	local roleList = mod.FormationCtrl:GetCurFormationInfo().roleList
    for k, v in pairs(self.coreUI) do
        v:SetCoreUIEnable(false)
		
		local contain = false
		for i = 1, #roleList do
			if roleList[i] == k then
				contain = true
			end
		end
		
		if not contain then
			v:Cache()
			self.coreUI[k] = nil
		end
    end

	local curRoleId = self.playerObject and self.playerObject.masterId or -1
	if curRoleId ~= -1 then
		local coreUI = self.coreUI[curRoleId]
		if not coreUI then
			local config = self.playerObject.skillSetComponent.setConfig.CoreUIConfig
			local coreUILogic = _G["CoreUILogic"..self.playerObject.entityId]
			if config and coreUILogic then
				self.coreUI[curRoleId] = Fight.Instance.objectPool:Get(coreUILogic)
				--coreUILogic.New(self.playerObject, config, self.CoreUIParent.transform, self.canvas.sortingOrder)
				coreUI = self.coreUI[curRoleId]
				coreUI:Init(self.playerObject, config, self.CoreUIParent.transform, self.canvas.sortingOrder)
			end
		end

		if coreUI then
			coreUI:SetCoreUIEnable(true)
			coreUI:EntityAttrChange(coreUI.bindRes, self.playerObject)
		end
	end
end

function FightNewSkillPanel:RoleCuting(state)
    if state == nil then
        return self.isCuting or false
    end
    self.isCuting = state
end

--修改技能配置
function FightNewSkillPanel:ChangeButtonConfig(instanceId,keyEvent)
    if instanceId ~= self.playerObject.instanceId then
        return
    end
    local btnName = KeyEvent2Btn[keyEvent]
    local config = self.skillSetComponent:GetConfigByBtnName(btnName)
    if config and self.btns[btnName] then
        self.btns[btnName].BtnBody:SetActive(true)
    elseif self.btns[btnName] then
        self.btns[btnName].BtnBody:SetActive(false)
    else
        return
    end
    self:RemoveAllEffectByBtnName(btnName)
    self:InitButton(btnName)
    self:UpdateSkillBtnCD(btnName)
    self:UpdateSkillCost(btnName)
    self:SkillReadyEffect(btnName)
end

--切换角色更新技能按钮
function FightNewSkillPanel:UpdatePlayerSkillList()
    for btnName, KeyEvent in pairs(SkillBtn2Event) do
        local config = self.skillSetComponent:GetConfigByBtnName(btnName)
        if config and self.btns[btnName] then
            self.btns[btnName].BtnBody:SetActive(true)
            self:InitButton(btnName)
        elseif self.btns[btnName] then
            self.btns[btnName].BtnBody:SetActive(false)
        end
    end
    self:RemoveAllEffect()
    self:RoleCuting(true)
    self:UpdateAllButton()
    self:RoleCuting(false)
end

function FightNewSkillPanel:InitButton(btnName)
    local config = self.skillSetComponent:GetConfigByBtnName(btnName)
    local btn = self.btns[btnName]
    if config and config.SkillIcon then
        local path = AssetConfig.GetSkillIcon(config.SkillIcon)
        SingleIconLoader.Load(self.btns[btnName].Icon, path)
    end

    btn.CDMaskGroup:SetActive(config and config.SkillCDMask)
    btn.ChargeGroup:SetActive(config and config.Charge)
    --btn.DisableMask:SetActive(config and config.DisableMask)
    btn.SkillCDTime:SetActive(config and config.ShowCD)
    btn.PowerMask:SetActive(config and config.PowerMask)
    btn.PowerCircle:SetActive(config and config.PowerCircle)
    btn.PowerPoint:SetActive(config and config.PowerPoint)
    if config and config.PowerPoint then
        btn.CostCount_txt.text = config.UseCostValue or 0
    end

    if config and config.PowerMask and config.MaskColor then
        UtilsUI.SetImageColor(btn.PowerMask_img, config.MaskColor)
    end

    if config and config.Charge then
        local curChargeTimes, maxChargeTimes = self.skillSetComponent:GetSetButtonByBtnName(btnName):GetChargePoint()
        for i = 1, 5 do
            if i <= maxChargeTimes then
                UtilsUI.SetActive(btn["Charge"..i], true)
            else
                UtilsUI.SetActive(btn["Charge"..i], false)
            end
        end
    end
end

function FightNewSkillPanel:CastSkillUIEffect(instanceId, keyEvent)
    if instanceId ~= self.playerObject.instanceId then
        return
    end

    local btnName = KeyEvent2Btn[keyEvent]
    local config = self.skillSetComponent:GetConfigByBtnName(btnName)
    if config and config.CastEffect and config.CastEffectPath ~= "" then
        self:StopEffectByBtnName(config.CastEffectPath, btnName)
        self:PlayEffectByBtnName(config.CastEffectPath, btnName)
    elseif config and config.CastEffect then
        self:StopEffectByBtnName(CommonEffect.DefaultCast, btnName)
        self:PlayEffectByBtnName(CommonEffect.DefaultCast, btnName)
    end
end

--主动更新所有技能
function FightNewSkillPanel:UpdateAllButton()
    for ketEvent, btnName in pairs(KeyEvent2Btn) do
        local skill = self.skillSetComponent:GetSkillByBtnName(btnName)
        if skill then
            self:UpdateSkillBtnCD(btnName)
            self:UpdateSkillCost(btnName)
            self:SkillReadyEffect(btnName)
        end
    end
end

function FightNewSkillPanel:UpdateSkillInfo(keyEvent, instanceId)
    if instanceId == self.playerObject.instanceId then
        local btnName = KeyEvent2Btn[keyEvent]
        self:UpdateSkillBtnCD(btnName)
        self:UpdateSkillCost(btnName)
        self:SkillReadyEffect(btnName)
    end
end

--角色属性资源变更
-- function FightNewSkillPanel:UpdatePlayerAttr(useCostType, entity)
--     if entity.instanceId ~= self.playerObject.instanceId then
--         return
--     end
--     for ketEvent, btnName in pairs(KeyEvent2Btn) do
--         self:UpdateSkillCost(btnName, useCostType)
--     end
-- end

--#更新技能资源显示,如果充能点绑定实体资源，由setbutton通知
function FightNewSkillPanel:UpdateSkillCost(btnName)
    local setComponent = self.skillSetComponent
    local config = setComponent:GetConfigByBtnName(btnName)
    local button = self.btns[btnName]
    if not config or not button then return end
    UnityUtils.BeginSample("UpdateSkillCost")
    local curCostValue, useCostValue, maxUseCostValue, CostType = setComponent:GetSetButtonByBtnName(btnName):GetCostValue()

    --根据配置做显示
    if config.DisableMask then
        self:ChangeDisableMask(button, not self:CheckUseSkill(btnName))
    end

    if config.PowerMask and curCostValue then
        self:ChangePowerValue(button, curCostValue, useCostValue)
    end

    if config.PowerCircle and curCostValue then
        self:ChangePowerCircleValue(button, curCostValue, useCostValue, maxUseCostValue)
    end
    UnityUtils.EndSample()
end

--#更新技能cd显示
function FightNewSkillPanel:UpdateSkillBtnCD(btnName)
    local setComponent = self.skillSetComponent
    local config = setComponent:GetConfigByBtnName(btnName)
    local button = self.btns[btnName]
    if not config or not button then return end
    UnityUtils.BeginSample("UpdateSkillBtnCD")
    if config.DisableMask then
        self:ChangeDisableMask(button, not self:CheckUseSkill(btnName))
    end

    local curCDtime, maxCDtime = setComponent:GetSetButtonByBtnName(btnName):GetShowCD()
    local curChargeTimes, maxChargeTimes = setComponent:GetSetButtonByBtnName(btnName):GetChargePoint()

    if config.SkillCDMask then
        if self:CheckUseSkill(btnName) then
            self:UpdateImgRoundFill(button, curCDtime, maxCDtime)
        else
            self:UpdateSkillCDMask(button, curCDtime, maxCDtime)
        end
    end

    if config.ShowCD then
		self:UpdateCDText(button, curCDtime)
    end

    if config.SkillCdChargePart and config.Charge then
        self:UpdateChargePoint(button, curChargeTimes, maxChargeTimes)
    end
    UnityUtils.EndSample()
end

function FightNewSkillPanel:SkillReadyEffect(btnName)
    local setComponent = self.skillSetComponent
    local config = setComponent:GetConfigByBtnName(btnName)
    local button = self.btns[btnName]
    if not config or not button then return end
    UnityUtils.BeginSample("SkillReadyEffect")
    local curCostValue, useCostValue, maxUseCostValue = setComponent:GetSetButtonByBtnName(btnName):GetCostValue()
    --TODO临时写死的特效
    --if config.SkillCostPart and useCostValue < maxUseCostValue then
        --if curCostValue >= maxUseCostValue then
            --self:PlayEffectByBtnName(CommonEffect.DefaultReadyLoop, btnName, true)
        --else
            --self:StopEffectByBtnName(CommonEffect.DefaultReadyLoop, btnName)
        --end
    --end
    if config.ReadyEffect and self:CheckUseSkill(btnName) then
        if not self:PlayEffectByBtnName(config.ReadyEffectPath, btnName, config.IsLoop) then
            self:PlayEffectByBtnName(CommonEffect.DefaultReady, btnName)
        end
    elseif config.ReadyEffect and not self:CheckUseSkill(btnName) then
        if not self:StopEffectByBtnName(config.ReadyEffectPath, btnName) then
            self:StopEffectByBtnName(CommonEffect.DefaultReady, btnName)
        end
    end

    if config.DodgeEffect and self:CheckUseDodge(btnName) then
        if not self:PlayEffectByBtnName(config.DodgeEffectPath, btnName, true) then
            self:PlayEffectByBtnName(CommonEffect.DefaultReady, btnName, true)
        end
    elseif config.DodgeEffect and not self:CheckUseDodge(btnName) then
        if not self:StopEffectByBtnName(config.DodgeEffectPath, btnName) then
            self:StopEffectByBtnName(CommonEffect.DefaultReady, btnName)
        end
    end

    if self:CheckUseSkill(btnName) then
        self:SetIconAlpha(button,self.btnAlpha[btnName])
    elseif not self:CheckUseSkill(btnName) then
        self:SetIconAlpha(button,0.2)
    end
    UnityUtils.EndSample()
end

function FightNewSkillPanel:UpdateSkillCDMask(button, value, maxValue) --更新cd遮罩(默认)
    UtilsUI.SetActive(button.SkillCDMask, true)
    UtilsUI.SetActive(button.ImgRoundFill, false)
    if value and maxValue then
        if maxValue == 0 or value / maxValue > 1 then
            button.SkillCDMask_img.fillAmount = 0
        else
            button.SkillCDMask_img.fillAmount = value / maxValue
        end
    end
end

function FightNewSkillPanel:UpdateImgRoundFill(button, value, maxValue) --更新cd遮罩(圆框)
    UtilsUI.SetActive(button.SkillCDMask, false)
    UtilsUI.SetActive(button.ImgRoundFill, true)
    if value and maxValue then
        if maxValue == 0 or value / maxValue > 1 then
            button.ImgRoundFill_img.fillAmount = 0
        else
            button.ImgRoundFill_img.fillAmount = value / maxValue
        end
    end
end

function FightNewSkillPanel:UpdateCDText(button, value) --更新cd时间
    if value then
        if value > 0 then
			value = math.ceil(value * 0.001) / 10
            button.SkillCDTime_txt.text = value
        else
            button.SkillCDTime_txt.text = ""
        end
    end
end

function FightNewSkillPanel:UpdateChargePoint(button, value, maxValue)
    if not value or not maxValue then return end
    if value < 0 then
        value = 0
    elseif value > maxValue then
        value = maxValue
    end
    for i = 1, maxValue  do
        if i <= value and not button["ChargeS"..i].activeSelf then
            button["ChargeS"..i]:SetActive(true)
            --播放获得充能点特效
            self:PlayEffect(button.gameObject, button["Charge"..i], CommonEffect.AddCharge)
            self:StopEffect(button.gameObject, button["Charge"..i], CommonEffect.ReduceCharge)
        elseif i > value and button["ChargeS"..i].activeSelf then
            button["ChargeS"..i]:SetActive(false)
            --失去充能点特效
            self:PlayEffect(button.gameObject, button["Charge"..i], CommonEffect.ReduceCharge)
            self:StopEffect(button.gameObject, button["Charge"..i], CommonEffect.AddCharge)
        end
    end
end

function FightNewSkillPanel:ChangePowerValue(button, value, maxValue)
    if value and maxValue then
        if value >= maxValue or value < 0 then
            value = 0
        end
        button.PowerMask_img.fillAmount = value / maxValue
    end
end

function FightNewSkillPanel:ChangePowerCircleValue(button, curValue, useValue, maxValue)
    if curValue > maxValue then
        curValue = maxValue
    end
    --UtilsUI.SetActive(button.PowerState1, not curValue >= maxValue)
    --UtilsUI.SetActive(button.PowerState2, not curValue >= maxValue)
    UtilsUI.SetActive(button.PowerState3, curValue >= maxValue)

    local angleOffset = useValue / maxValue * PowerCircleSetting.EndPowerAngle
    UnityUtils.SetLocalEulerAngles(button.PowerPointer_rect, 0, 0, angleOffset)
    UnityUtils.SetLocalEulerAngles(button.PowerState2_rect, 0, 0, angleOffset)

    if curValue >= maxValue then

    elseif curValue >= useValue then
        UtilsUI.SetImageColor(button.PowerState1_img, "#FFFFFF")
        button.PowerState1_img.fillAmount = useValue / maxValue * PowerCircleSetting.MaxFillAmount
        button.PowerState2_img.fillAmount = (curValue - useValue) / maxValue * PowerCircleSetting.MaxFillAmount
    elseif curValue < useValue then
        UtilsUI.SetImageColor(button.PowerState1_img, "#C0C0C0")
        button.PowerState1_img.fillAmount = curValue / maxValue * PowerCircleSetting.MaxFillAmount
        button.PowerState2_img.fillAmount = 0
    end
end

function FightNewSkillPanel:ChangeDisableMask(button, value) --不可使用遮罩
	UtilsUI.SetActive(button.DisableMask, value or false)
end

function FightNewSkillPanel:SetIconAlpha(button, value)
    UnityUtils.SetImageColor(button.Icon_img, 1, 1, 1, value)
end

--#region 特效相关
function FightNewSkillPanel:PlayClickEffect(btnName, play)
	if not self.btns[btnName] then
		return false
	end

	local effectName = SpecialClickEffect[btnName] or NormalClickEffect
	if play then
		return self:PlayEffectByBtnName(effectName, btnName)
	else
		return self:StopEffectByBtnName(effectName, btnName)
	end
end

function FightNewSkillPanel:PlayEffectByBtnName(effctName, btnName, isLoop)
    if self.btns[btnName] then
        return self:PlayEffect(self.btns[btnName].gameObject, self.btns[btnName].Effect, effctName, isLoop)
    end
    return false
end

function FightNewSkillPanel:StopEffectByBtnName(effctName, btnName)
    if self.btns[btnName] then
        return self:StopEffect(self.btns[btnName].gameObject, self.btns[btnName].Effect, effctName)
    end
    return false
end

function FightNewSkillPanel:RemoveAllEffectByBtnName(btnName)
    if self.btns[btnName] then
        local key = btnName.."_Effect_"
        if self.effectMap[key] then
            for name, value in pairs(self.effectMap[key]) do
                self:CacheEffect(name, value.obj)
            end
        end
        self.effectMap[key] = nil
    end
end

--key = root_parent
--位置优先级parent > root
function FightNewSkillPanel:PlayEffect(root, parent, effect, isLoop)
    if effect == "" then
        return false
    end
    local key = root.name
    if parent then
        key = key..parent.name
    end

    if self:RoleCuting() and not isLoop then
        return true
    end

    if self.effectMap[key] and self.effectMap[key][effect] then
        local info = self.effectMap[key][effect]
        UtilsUI.SetActive(info.obj, true)
        info.state = true
        return true
    end
    local obj = self:GetEffectObj(effect)
    if not obj then
        LogError(string.format("节点[%s]没有加载到特效[%s],请检查路径是否正确", key, effect))
        return false
    end
    local transform = obj.transform
    if parent then
        transform:SetParent(parent.transform)
    else
        transform:SetParent(root.transform)
    end
    transform:ResetAttr()
	transform:SetActive(true)
    if not self.effectMap[key] then
        self.effectMap[key] ={}
    end
    self.effectMap[key][effect] = {obj = obj, loop = isLoop or false, state = true}
    return true
end

function FightNewSkillPanel:StopEffect(root, parent, effect)
    if effect == "" then
        return false
    end
    local key = root.name
    if parent then
        key = key..parent.name
    end
    if self.effectMap[key] and self.effectMap[key][effect] then
        local info = self.effectMap[key][effect]
        UtilsUI.SetActive(info.obj, false)
        info.state = false
        return true
    end
end

function FightNewSkillPanel:GetEffectObj(effect)
    if self.cacaheMap and self.cacaheMap[effect] and next(self.cacaheMap[effect]) then
        local obj = table.remove(self.cacaheMap[effect])
        return obj
    end
    if self[effect] then
		local obj = GameObject.Instantiate(self[effect])
        return obj
    end
    local obj = BehaviorFunctions.fight.clientFight.assetsPool:Get(effect)
    return obj
end

function FightNewSkillPanel:HideAllBaseEffect()
    for index, value in pairs(self.effectMap) do
        for k, v in pairs(value) do
            if not v.loop then
                UtilsUI.SetActive(v.obj, false)
            end
        end
    end
end

function FightNewSkillPanel:RemoveAllEffect()
    for index, value in pairs(self.effectMap) do
        for k, v in pairs(value) do
            self:CacheEffect(k,v.obj)
        end
        self.effectMap[index] = {}
    end
end

function FightNewSkillPanel:CacheEffect(name, obj)
    if not self.cacaheMap then
        self.cacaheMap = {}
    end
    if not self.cacaheMap[name] then
        self.cacaheMap[name] = {}
    end
    table.insert(self.cacaheMap[name], obj)
    obj.transform:SetParent(self.Cache_rect)
end

--#endregion

function FightNewSkillPanel:CheckUseSkill(btnName)
    local setButton = self.skillSetComponent:GetSetButtonByBtnName(btnName)
    return setButton:CheckUseSkill()
end

function FightNewSkillPanel:CheckUseDodge(btnName)
    local setButton = self.skillSetComponent:GetSetButtonByBtnName(btnName)
    return setButton:CheckUseDodge()
end

function FightNewSkillPanel:SetInputImageChanger()
    UtilsUI.SetInputImageChanger(self.btns["K"].InputTips)
    UtilsUI.SetInputImageChanger(self.btns["J"].InputTips)
    UtilsUI.SetInputImageChanger(self.btns["O"].InputTips)
    UtilsUI.SetInputImageChanger(self.btns["I"].InputTips)
    UtilsUI.SetInputImageChanger(self.btns["R"].InputTips)
    UtilsUI.SetInputImageChanger(self.btns["F"].InputTips)
    UtilsUI.SetInputImageChanger(self.btns["SW"].InputTips)
    UtilsUI.SetInputImageChanger(self.btns["X"].InputTips)
    UtilsUI.SetInputImageChanger(self.btns["JR"].InputTips)
end