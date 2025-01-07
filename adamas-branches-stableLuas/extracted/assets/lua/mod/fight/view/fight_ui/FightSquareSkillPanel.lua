FightSquareSkillPanel = BaseClass("FightSquareSkillPanel", BasePanel)

local _sin = math.sin
local _cos = math.cos
local _deg2Rad = math.rad(1)
local AttrType = EntityAttrsConfig.AttrType

local SkillBtn2Event = FightEnum.SkillBtn2Event
local BehaviorBtn2Events = FightEnum.BehaviorBtn2Events
local KeyEvent2Btn = FightEnum.KeyEvent2Btn
local HeroData =  Config.DataHeroMain.Find

local UltimateSkillBtnName = "L"

local Id2SkillOpenEffect = {
	[1001] = "21014",	
	[1002] = "22001",	
	[1003] = "21014",	
}

local Id2SkillCloseEffect = {
	[1001] = "21015",
	[1002] = "22002",
	[1003] = "21015",
}

local SkillButtonType = {
	Normal = 1,
	Climb = 2,
	Swim = 3,
}

function FightSquareSkillPanel:__init(mainView)
	self:SetAsset("Prefabs/UI/Fight/FightSquareSkillPanel.prefab")
	self.mainView = mainView

	self.playerEntityCount = 0
	self.SkillBtn2CostMap = {}
	self.SkillBtnOldRecord = {}
	self.QTEForegroundState = {}
	self.BehaviorInputRecode = {}
end

function FightSquareSkillPanel:__BindEvent() end

function FightSquareSkillPanel:__BindListener() end

function FightSquareSkillPanel:__BaseShow()
	self:SetParent(self.mainView.PanelParent.transform)
end

function FightSquareSkillPanel:__Show()
	self.gameObject:SetActive(false)
	self.tempEffectList = {}
	self.coreState = false
	self.btns = {}
	self.btnAlpha = self.btnAlpha or {}
	local btnParent = {"NormalButton", "ClimbButton", "SwimButton"}
	for j = 1, #btnParent do
		for i = 0, self[btnParent[j]].transform.childCount - 1 do
			local trans = self[btnParent[j]].transform:GetChild(i)
			local btn = {}
			btn.gameObject = trans.gameObject
			btn.transform = trans
			btn.type = j
			UtilsUI.GetContainerObject(btn.transform, btn)
			local name = string.gsub(trans.name, "_", "")
			self.btns[name] = btn
			if self.btnAlpha and not self.btnAlpha[name] then
				self.btnAlpha[name] = self.btns[name].Icon_img.color.a
			end
		end
	end

	for k, v in pairs(SkillBtn2Event) do
		if self.btns[k] and self.btns[k].Button then
			self:RegisterSkillBtnEvent(self.btns[k].Button, k, {v})
		end
	end
	
	for k, v in pairs(BehaviorBtn2Events) do
		if self.btns[k] and self.btns[k].Button then
			self:RegisterSkillBtnEvent(self.btns[k].Button, k, v)
		end
	end
end

function FightSquareSkillPanel:__ShowComplete()
	self.mainView:AddLoadDoneCount()
end

function FightSquareSkillPanel:__delete()
	TableUtils.ClearTable(self.tempEffectList)
end

function FightSquareSkillPanel:__Hide()
	self:RemoveTimer()
	self.SkillBtnOldRecord = {}
	TableUtils.ClearTable(self.tempEffectList)
end

function FightSquareSkillPanel:RemoveTimer()
	if self.timer then
		LuaTimerManager.Instance:RemoveTimer(self.timer)
		self.timer = nil
	end
end

function FightSquareSkillPanel:Update()
	local stateComponent = self.mainView.playerObject.stateComponent
	local isClimbState = stateComponent:IsState(FightEnum.EntityState.Climb)
	local isSwimState = stateComponent:IsState(FightEnum.EntityState.Swim)
	local isNormal = not isClimbState and not isSwimState
	
	--这个表一般是个空表，记录切换时没有释放的按钮
	for k, v in pairs(self.BehaviorInputRecode) do
		if (not isNormal and self.btns[k].type == SkillButtonType.Normal) or 
			(not isSwimState and self.btns[k].type == SkillButtonType.Swim) or
			(not isClimbState and self.btns[k].type == SkillButtonType.Climb) then

			self.mainView:StopEffect("21052", k)
			for _, vv in pairs(v) do
				self.mainView:KeyUp(vv)
			end
			self.BehaviorInputRecode[k] = nil
		end
	end

	self.NormalButton:SetActive(isNormal)
	self.ClimbButton:SetActive(isClimbState)
	self.SwimButton:SetActive(isSwimState)
	-- 临时逻辑 记录按键的特效 不需要重播的特效在关闭父节点的时候要一并删除
	if not isNormal then
		for btnName, v in pairs(self.tempEffectList) do
			for effectId, _ in pairs(v) do
				if effectId == "20034" and TableUtils.GetParam(self.tempEffectList, nil, btnName, "20034") ~= nil then
					self.mainView:StopEffect("20034", btnName)
					self.tempEffectList[btnName]["20034"] = false
				end
			end
		end
	end
end

function FightSquareSkillPanel:OnChangeRole()
	local playerEntityId = self.mainView.playerObject.entityId
	self.mainView:StopEffect(Id2SkillOpenEffect[playerEntityId], UltimateSkillBtnName)
end

function FightSquareSkillPanel:RegisterSkillBtnEvent(gameObject, btnName, keys)
	local pointer = gameObject:AddComponent(UIDragBehaviour)
	local down = function(data)
		self.mainView:PlayEffect("21052", btnName)
			
		self.BehaviorInputRecode[btnName] = keys
		for _, v in pairs(keys) do
			self.mainView:KeyDown(v)
		end
	end
	local up = function(data)
		self.mainView:StopEffect("21052", btnName)
			
		self.BehaviorInputRecode[btnName] = nil
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

function FightSquareSkillPanel:UpdatePlayer()
	self.player = self.mainView.player
	self.playerEntityCount = self.player:GetEntityCount()
	self.playerSkillSetComp = self.mainView.playerObject.skillSetComponent

	if self.btnActiveAttr4 then
		for k, v in pairs(self.btnActiveAttr4) do
			if v.sequence then
				v.sequence:Kill(false)
			end
		end
		self.btnActiveAttr4 = {}
	end

	self:UpdatePlayerSkillList()
end

function FightSquareSkillPanel:UpdatePlayerAttr(attrType)
	local btnMap = self.SkillBtn2CostMap[attrType]
	if btnMap then
		for btnName, _ in pairs(btnMap) do
			self:UpdateSkillBtnAttr(btnName)
		end
	end
end

local SkillAttrShowType =
{
	1,2,3,4,1,5
}

function FightSquareSkillPanel:UpdatePlayerSkillList()
	self.SkillBtn2SkillMap = {}
	self.SkillBtn2CostMap = {}

	for btnName, v in pairs(SkillBtn2Event) do
		local skillInfo = self.playerSkillSetComp:GetSkillSetByBtnName(btnName)
		if skillInfo and self.btns[btnName] then
			self.btns[btnName].gameObject:SetActive(skillInfo.Active)
			if skillInfo.Active then
				self:SetSkillBtnId(btnName)
				self:SetSkillBtnIcon(btnName, skillInfo.SkillIcon, nil, SkillAttrShowType[skillInfo.skill.attrType] == 3)
			end
		end
	end
end

function FightSquareSkillPanel:SetSkillBtnId(btnName, instanceId)
	if instanceId and self.mainView.playerObject.instanceId ~= instanceId then
		return
	end

	local oldSkill = self.SkillBtn2SkillMap[btnName]
	if oldSkill then
		if not self.SkillBtnOldRecord[btnName] then
			self.SkillBtnOldRecord[btnName] = {}
		end

		self.SkillBtnOldRecord[btnName].skill = oldSkill
		if self.SkillBtn2CostMap[oldSkill.useCostType] then
			self.SkillBtnOldRecord[btnName].useCostType = oldSkill.useCostType
			self.SkillBtnOldRecord[btnName].useValue = self.mainView.playerObject.attrComponent:GetValueAndMaxValue(oldSkill.useCostType)
			self.SkillBtn2CostMap[oldSkill.useCostType][btnName] = nil
		else
			self.SkillBtnOldRecord[btnName].useCostType = nil
			self.SkillBtnOldRecord[btnName].useValue = nil
		end
	end

	local skill = self.playerSkillSetComp:GetSkill(FightEnum.SkillBtn2Event[btnName])
	self.SkillBtn2SkillMap[btnName] = skill

	local starPanel = self.btns[btnName.."Star"]

	if skill then
		local useCostType = skill.useCostType
		self.SkillBtn2CostMap[useCostType] = self.SkillBtn2CostMap[useCostType] or {}
		self.SkillBtn2CostMap[useCostType][btnName] = true

		local btnShowType = SkillAttrShowType[skill.attrType]
		for i = 1, FightEnum.SkillAttrType.CDTime do
			local showType = SkillAttrShowType[i]
			local showTypePanel = self.btns[btnName]["ShowType"..showType]
			if showTypePanel then
				showTypePanel:SetActive(btnShowType == showType)
			end
		end

		if starPanel then
			starPanel:SetActive(skill.useCostType == AttrType.SkillPoint)
		end

		local func = self["InitSkillBtnAttr"..skill.attrType]
		if func then
			func(self, btnName, skill)
		end

		self:UpdateSkillBtnAttr(btnName)
	else
		local showType = SkillAttrShowType[i]
		local showTypePanel = self.btns[btnName]["ShowType"..showType]
		if showTypePanel then
			showTypePanel:SetActive(false)
		end

		if starPanel then
			starPanel:SetActive(false)
		end
	end
end

function FightSquareSkillPanel:SetSkillBtnIcon(btnName, skillIcon, instanceId, isFillType)
	if instanceId and self.mainView.playerObject.instanceId ~= instanceId then
		return
	end
	local path = AssetConfig.GetSkillIcon(skillIcon)
	SingleIconLoader.Load(self.btns[btnName].Icon, path)

	-- if isFillType then
	-- 	SingleIconLoader.Load(self.mainView[btnName.."ShowType3"], path)
	-- end
end

function FightSquareSkillPanel:UpdateSkillBtnById(skillId)
	if not self.SkillBtn2SkillMap then
		return
	end

	for btnName, v in pairs(self.SkillBtn2SkillMap) do
		if v.skillId == skillId then
			self:UpdateSkillBtnAttr(btnName)
		end
	end
end

function FightSquareSkillPanel:UpdateSkillCD(keyEvent)
	local btnName = KeyEvent2Btn[keyEvent]
	self:UpdateSkillBtnAttr(btnName)
end

function FightSquareSkillPanel:UpdateSkillBtnAttr(btnName)
	if not self.SkillBtn2SkillMap then
		return
	end

	local skill = self.SkillBtn2SkillMap[btnName]
	if not skill then
		return
	end

	local useCostType = skill.useCostType
	local useCostValue = skill.useCostValue
	local skillAttrType = skill.attrType
	self["UpdateSkillBtnAttr"..skillAttrType](self, btnName, useCostType, useCostValue, skill)

	-- 技能点要单独显示
	if useCostType == AttrType.SkillPoint then
		self.btns[btnName.."starNum_txt"].text = useCostValue
	end
end

local BtnRauis = 61
function FightSquareSkillPanel:InitSkillBtnAttr1(btnName, skill)
	-- 初始化充能布局
	local maxChargeTimes = skill.maxChargeTimes
	if maxChargeTimes == 1 then
		maxChargeTimes = 0
	end
	self.attr1LastChargeTime = skill.curChargeTimes
	local startRZ = -10 -- maxChargeTimes * 5
	for i = 1, 5 do
		local chargeImg = self.btns[btnName]["Charge"..i]
		chargeImg:SetActive(maxChargeTimes >= i or maxChargeTimes == 1)

		-- 切换角色所有充能点特效都要消失
		self.mainView:StopEffect("20011", "Charge"..i, btnName)
		self.mainView:StopEffect("20012", "Charge"..i, btnName)
	end
end

function FightSquareSkillPanel:InitSkillBtnAttr5(btnName, skill)
	-- 初始化充能布局
	local attrComponent = self.mainView.playerObject.attrComponent
	local curValue, maxValue = attrComponent:GetValueAndMaxValue(skill.useCostType)
	local startRZ = -10 -- maxValue * 5
	for i = 1, 5 do
		local chargeImg = self.btns[btnName]["Charge"..i]
		chargeImg:SetActive(maxValue >= i)
		
		-- 切换角色所有充能点特效都要消失
		self.mainView:StopEffect("20011", "Charge"..i, btnName)
		self.mainView:StopEffect("20012", "Charge"..i, btnName)
	end
end

function FightSquareSkillPanel:InitSkillBtnAttr6(btnName, skill)
	-- 初始化充能布局
	if not self.coreState and btnName == "R" then
		self:SetSkillIconDisable(btnName, true, 0.2)
	end
end

function FightSquareSkillPanel:SetSkillIconDisable(btnName, disable, forceAlpha)
	local alpha = self.btnAlpha[btnName]
	if disable then
		alpha = forceAlpha and forceAlpha or 0.5
	end
	CustomUnityUtils.SetImageColor(self.btns[btnName].Icon_img,1,1,1,alpha)
end

function FightSquareSkillPanel:UpdateSkillBtnAttr1(btnName, useCostType, useCostValue, skill)
	local chargeTimes = skill.curChargeTimes
	local chargeMaxTimes = skill.maxChargeTimes
	local attrComponent = self.mainView.playerObject.attrComponent
	local curValue = attrComponent:GetValue(useCostType)
	self:SetSkillIconDisable(btnName, useCostValue > curValue, 0.6)
	self.btns[btnName].ChargeCD:SetActive(chargeTimes >= 0 and chargeTimes < chargeMaxTimes or skill.SkillType == FightEnum.SkillSpecialType.Dodge)
	self.btns[btnName].CDTime:SetActive(chargeTimes >= 0 and chargeTimes < chargeMaxTimes and skill.SkillType ~= FightEnum.SkillSpecialType.Dodge)
	self.btns[btnName].CDMask:SetActive(chargeTimes == 0 and skill.SkillType ~= FightEnum.SkillSpecialType.Dodge)
	self.btns[btnName].CDMask_Reserver:SetActive((chargeTimes > 0 and chargeTimes < chargeMaxTimes) or skill.SkillType == FightEnum.SkillSpecialType.Dodge)
	if chargeTimes < chargeMaxTimes then
		local time = math.ceil(skill.curCDtime * 0.001) / 10
		self.btns[btnName].CDTime_txt.text = time

		self.mainView:StopEffect("20034", btnName)
		if TableUtils.GetParam(self.tempEffectList, nil, btnName, "20034") ~= nil then
			self.tempEffectList[btnName]["20034"] = false
		end

	 	local percent = skill.curCDtime / skill.maxCDtime
	 	local imgFill = chargeTimes == 0 and self.btns[btnName].CDMask_img or self.btns[btnName].CDMask_Reserver_img
	 	imgFill.fillAmount = percent
	else
	 	self.btns[btnName].CDTime_txt.text = ""
		if chargeTimes == chargeMaxTimes and skill.SkillType ~= FightEnum.SkillSpecialType.Dodge then
			self.mainView:PlayEffect("20034", btnName)
			if not self.tempEffectList[btnName] then
				self.tempEffectList[btnName] = {}
			end
			self.tempEffectList[btnName]["20034"] = true
		end
	end

	if skill.SkillType == FightEnum.SkillSpecialType.Dodge then
		local imgFill = self.btns[btnName].CDMask_Reserver_img
		local dodgeState = self.mainView.playerObject.dodgeComponent:GetLimitState()
		if dodgeState == DodgeComponent.LimitState.Enable then
			imgFill.fillAmount = 0

			self.mainView:PlayEffect("20034", btnName)
			if not self.tempEffectList[btnName] then
				self.tempEffectList[btnName] = {}
			end

			self.tempEffectList[btnName]["20034"] = true
		elseif dodgeState == DodgeComponent.LimitState.Disable then
			imgFill.fillAmount = 1
		elseif dodgeState == DodgeComponent.LimitState.Cooling then
			imgFill.fillAmount = self.mainView.playerObject.dodgeComponent:GetCoolingPercent()
		end
	end

	-- 播放充能点获得动效
	if self.attr1LastChargeTime < chargeTimes then
		self.mainView:StopEffect("20012", "Charge"..chargeTimes, btnName)
		self.mainView:PlayEffect("20011", "Charge"..chargeTimes, nil, nil, nil, btnName)
	elseif self.attr1LastChargeTime > chargeTimes then
		-- 播放充能点消失动效
		self.mainView:StopEffect("20011", "Charge"..(chargeTimes + 1), btnName)
		self.mainView:PlayEffect("20012", "Charge"..(chargeTimes + 1), nil, nil, nil, btnName)
	end
	
	for i = 1, chargeMaxTimes do
		local chargeShowImg = self.btns[btnName]["ChargeS"..i]
		if chargeShowImg then
			chargeShowImg:SetActive(i <= chargeTimes)
		end
	end
	
	self.attr1LastChargeTime = chargeTimes
end

-- 恢复类型
function FightSquareSkillPanel:UpdateSkillBtnAttr2(btnName, useCostType, useCostValue, skill)

	local attrComponent = self.mainView.playerObject.attrComponent
	local curValue, maxValue = attrComponent:GetValueAndMaxValue(useCostType)
	local percent = curValue / maxValue

	local imgFill = self.btns[btnName].ImgRoundFill_img
	imgFill.fillAmount = percent
	local disable = curValue < useCostValue
	self:SetSkillIconDisable(btnName, disable)

	--self.btns[btnName].RoundDisable:SetActive(disable)
	-- 闪避按钮的特效(暂时停用)
	--local dodgeComponent = self.mainView.playerObject.dodgeComponent
	--if skill.config.SkillType == FightEnum.SkillSpecialType.Dodge then
		--local dodgeDisable = dodgeComponent:IsLimitState(DodgeComponent.LimitState.Enable)
		--if dodgeDisable then
			----self.mainView:PlayEffect("20018", btnName)
		--else
			----self.mainView:StopEffect("20018", btnName)
		--end
	--end
end

-- 累积类型
function FightSquareSkillPanel:UpdateSkillBtnAttr3(btnName, useCostType, useCostValue)
	local attrComponent = self.mainView.playerObject.attrComponent
	local curValue = attrComponent:GetValueAndMaxValue(useCostType)
	local percent = curValue / useCostValue

	-- local imgFill = self.mainView[btnName.."ImgMask_img"]
	-- imgFill.fillAmount = percent
	if not self.curUseRole then
		local curUseRole = self.mainView.playerObject.entityId
		self.curUseRole = curUseRole
		if curUseRole == 1001 then
			SingleIconLoader.Load(self.btns["L"].ImgMask, "Textures/Icon/Single/ElementIcon/image_mask_red.png")
		elseif curUseRole == 1002 then
			SingleIconLoader.Load(self.btns["L"].ImgMask, "Textures/Icon/Single/ElementIcon/image_mask_purple.png")
		end
	end

	local imgFill = self.btns[btnName].ImgMask_img
	local disable = percent < 1
	imgFill.gameObject:SetActive(disable)
	imgFill.fillAmount = percent
	self:SetSkillIconDisable(btnName, disable)

	if disable then
		self[btnName.."_canvas"].alpha = math.min(0.7, math.max(percent, 0.3))
	else
		self[btnName.."_canvas"].alpha = 1
	end


	if btnName == UltimateSkillBtnName then
		local curPress = FightEnum.SkillBtn2Event[btnName]
		local isDown = self.mainView.operationManager:CheckKeyDown(curPress)
		local playerEntityId = self.mainView.playerObject.entityId
		if percent == 1 then
			self.mainView:PlayEffect(Id2SkillOpenEffect[playerEntityId], btnName)
			self.mainView:StopEffect(Id2SkillCloseEffect[playerEntityId], btnName)
		elseif percent == 0 and isDown then
			self.mainView:PlayEffect(Id2SkillCloseEffect[playerEntityId], btnName)
			self.mainView:StopEffect(Id2SkillOpenEffect[playerEntityId], btnName)
		elseif percent ~= 1 then
			self.mainView:StopEffect(Id2SkillOpenEffect[playerEntityId], btnName)
		end
	end
end

-- 显隐类型
function FightSquareSkillPanel:UpdateSkillBtnAttr4(btnName, useCostType, useCostValue)
	local attrComponent = self.mainView.playerObject.attrComponent
	local canUse = attrComponent:CheckCost(useCostType, useCostValue)

	local keyEvent = SkillBtn2Event[btnName]
	if not canUse then
		self.mainView:KeyUp(keyEvent)
	end

	self.btns[btnName]:SetActive(canUse)
end

function FightSquareSkillPanel:UpdateSkillBtnAttr5(btnName, useCostType, useCostValue, skill)
	local attrComponent = self.mainView.playerObject.attrComponent
	local curValue, maxValue = attrComponent:GetValueAndMaxValue(useCostType)
	curValue = curValue or 0
	maxValue = maxValue or 0
	local imgFill = self.btns[btnName].CDMask_img
	local canUse = curValue >= useCostValue and skill.curCDtime <= 0
	if not self.SkillBtnOldRecord[btnName] then
		self.SkillBtnOldRecord[btnName] = {}
	end

	local hideEffect = self.SkillBtnOldRecord[btnName].useCostType == useCostType and self.SkillBtnOldRecord[btnName].useValue == curValue
	if not hideEffect then
		self.SkillBtnOldRecord[btnName].skill = skill
		self.SkillBtnOldRecord[btnName].useCostType = useCostType
		self.SkillBtnOldRecord[btnName].useValue = curValue
	end

	self:SetSkillIconDisable(btnName, not canUse)
	self.btns[btnName].ChargeCD:SetActive(not canUse)
	self.btns[btnName].CDMask:SetActive(curValue > 0 and skill.curCDtime > 0)
	if curValue == 0 then
		imgFill.fillAmount = 1
	end

	if skill.curCDtime >= 0 then
		local time = math.ceil(skill.curCDtime * 0.001) / 10
		self.btns[btnName].CDTime_txt.text = time.."S"

		local percent = skill.curCDtime / skill.maxCDtime
		imgFill.fillAmount = percent

		self.mainView:StopEffect("20034", btnName)
		if TableUtils.GetParam(self.tempEffectList, nil, btnName, "20034") ~= nil then
			self.tempEffectList[btnName]["20034"] = false
		end

		if not hideEffect then
			self.mainView:StopEffect("20011", "Charge"..(curValue + 1), btnName)
			self.mainView:PlayEffect("20012", "Charge"..(curValue + 1), nil, nil, nil, btnName)
		end
	else
		self.btns[btnName].CDTime_txt.text = ""

		-- 播放充能点获得动效
		if curValue ~= 0 then
			self.mainView:PlayEffect("20034", btnName)
			if not self.tempEffectList[btnName] then
				self.tempEffectList[btnName] = {}
			end
			self.tempEffectList[btnName]["20034"] = true
		end
	end

	for i = 1, maxValue do
		local chargeShowImg = self.btns[btnName.."ChargeS"..i]
		if chargeShowImg then
			chargeShowImg:SetActive(i <= curValue)

			if i == curValue and not hideEffect then
				self.mainView:StopEffect("20012", "Charge"..curValue, btnName)
				self.mainView:PlayEffect("20011", "Charge"..curValue, nil, nil, nil, btnName)
			end
		end
	end
end

function FightSquareSkillPanel:UpdateSkillBtnAttr6(btnName, useCostType, useCostValue, skill)
	local percent = skill.curCDtime / skill.maxCDtime
	local imgFill = self.btns[btnName].SkillCDMask_img
	imgFill.fillAmount = percent

	if skill.curCDtime > 0 then
		local time = math.ceil(skill.curCDtime * 0.001) / 10
		self.btns[btnName].SkillCDTime_txt.text = time.."S"
		self:SetSkillIconDisable(btnName, true)
	else
		self.btns[btnName].SkillCDTime_txt.text = ""
		self:SetSkillIconDisable(btnName, false)
	end

	self.btns[btnName].DisableMask:SetActive(not self.coreState and btnName == "R")
	if not self.coreState and btnName == "R" then
		self:SetSkillIconDisable(btnName, true, 0.2)
	end
end

function FightSquareSkillPanel:SetCoreState(visible, entityId)
	if self.curUseRole ~= entityId then
		return
	end

	self.coreState = visible
	self:UpdateSkillBtnAttr("R")
end

--TODO 测试逻辑 目前没有属性之分 先按角色写死
function FightSquareSkillPanel:ChangeCurUseRole(curUseRole)
	self.curUseRole = curUseRole
	if curUseRole == 1001 then
		SingleIconLoader.Load(self.btns["L"].ImgMask, "Textures/Icon/Single/ElementIcon/image_mask_red.png")
	elseif curUseRole == 1002 then
		SingleIconLoader.Load(self.btns["L"].ImgMask, "Textures/Icon/Single/ElementIcon/image_mask_purple.png")
	end
end

function FightSquareSkillPanel:ChangeDodgeValue()
	self.tempDodge = {
		skillId = 0,
		attrType = FightEnum.SkillAttrType.CDTime,
		SkillType = FightEnum.SkillSpecialType.Dodge,
		useCostType = 1,
		useCostValue = -1,
		curCDtime = 0,
		maxCDtime = 0,
		curChargeTimes = 0,
		maxChargeTimes = 0,
	}

	self:UpdateSkillBtnAttr1("K", 1, -1, self.tempDodge)
end