FightInfoPanel = BaseClass("FightInfoPanel", BasePanel)

local AttrType = EntityAttrsConfig.AttrType

function FightInfoPanel:__init(mainView)
	self:SetAsset("Prefabs/UI/Fight/FightInfoPanel.prefab")
	self.mainView = mainView

	self.loadDone = false

	self.bindResPrefab = {}
	self.recordPlayerLife = {}

	-- buff
	self.buffItemPool = {}
	self.buffOnShow = {}

	self.buffRemoveList = {}
end

function FightInfoPanel:__BindEvent()
end

function FightInfoPanel:__BindListener()
	EventMgr.Instance:AddListener(EventName.SetCoreVisible, self:ToFunc("SetCoreVisible"))
	EventMgr.Instance:AddListener(EventName.RoleInfoUpdate, self:ToFunc("UpdateRoleInfo")) 
	EventMgr.Instance:AddListener(EventName.SkillPointChangeAfter, self:ToFunc("SkillPointChangeAfter"))
	EventMgr.Instance:AddListener(EventName.OnEntityHit, self:ToFunc("OnEntityHit"))
	EventMgr.Instance:AddListener(EventName.OnEntityBuffChange, self:ToFunc("EntityBuffChange"))
	EventMgr.Instance:AddListener(EventName.UseSkillDecPoint, self:ToFunc("IsUseSkill"))
end

function FightInfoPanel:__BaseShow()
	self:SetParent(self.mainView.PanelParent.transform)
end

function FightInfoPanel:__Create()
	self.animCurve = self.PowerGroup:GetComponent(DistanceCurveScaler).curve
	self.hpBarWidth = self.LifeProgress.transform.rect.width
end

function FightInfoPanel:__Show()
	self.loadDone = true
	self.Hp2DMask = self.HpMask:GetComponent(RectMask2D)
	if self.updateInfo then
		self:UpdatePlayer()
		self:UpdatePlayerHp()
		self.updateInfo = nil
	end
end

function FightInfoPanel:__ShowComplete()
	self.mainView:AddLoadDoneCount()
end

function FightInfoPanel:__delete()
	EventMgr.Instance:RemoveListener(EventName.SetCoreVisible, self:ToFunc("SetCoreVisible"))
	EventMgr.Instance:RemoveListener(EventName.RoleInfoUpdate, self:ToFunc("UpdateRoleInfo"))
	EventMgr.Instance:RemoveListener(EventName.SkillPointChangeAfter, self:ToFunc("SkillPointChangeAfter"))
	EventMgr.Instance:RemoveListener(EventName.OnEntityHit, self:ToFunc("OnEntityHit"))
	EventMgr.Instance:RemoveListener(EventName.OnEntityBuffChange, self:ToFunc("EntityBuffChange"))
end

function FightInfoPanel:__Hide()
	self.playerLifeDecSpeed = 0
end

function FightInfoPanel:Update()
	if self.playerLifeDec and self.playerLifeDec > 1 then
		local progress = (self.playerObjAttr:GetValue(AttrType.MaxLife) - self.playerObjAttr:GetValue(AttrType.Life)) / self.playerObjAttr:GetValue(AttrType.MaxLife)
		local time = 0.2 * (1 + 0.3 * progress * (1 - progress))
		self.playerLifeDecSpeed = self.playerLifeDec / time
		self.playerLifeDec = math.max(0, self.playerLifeDec - self.playerLifeDecSpeed * Time.unscaledDeltaTime)
		self:_UpdatePlayerDecLifeAnim()
	end
	if self.playerMainLifeDec and self.playerMainLifeDec > 1 then
		local progress = (self.playerObjAttr:GetValue(AttrType.MaxLife) - self.playerObjAttr:GetValue(AttrType.Life)) / self.playerObjAttr:GetValue(AttrType.MaxLife)
		local time = 0.1 * (1 + 0.3 * progress * (1 - progress))
		self.playerMainLifeDecSpeed = self.playerMainLifeDec / time
		self.playerMainLifeDec = math.max(0, self.playerMainLifeDec - self.playerMainLifeDecSpeed * Time.unscaledDeltaTime)
		self:_UpdatePlayerMainDecLifeAnim()
	end
	self:UpdataBuffStates()
	self:UpdateBlueBarAnim()
	self:UpdateYellowBarAnim()
end

function FightInfoPanel:UpdatePlayer()
	self.playerObject = Fight.Instance.playerManager:GetPlayer():GetCtrlEntityObject()
	self.playerObjAttr = self.playerObject.attrComponent
	
	if not self.loadDone then
		self.updateInfo = true
		return
	end
	self:UpdatePlayerLevel()
	self:ResetPowerBar()

	for key, value in pairs(FightEnum.RoleSkillPoint) do
		self:UpdataCommonCost(value)
	end
	self:AnalyseCoreShowConfig()
end

function FightInfoPanel:UpdatePlayerLevel()
	if not self.loadDone then
		self.updateInfo = true
		return
	end

	local curRole = BehaviorFunctions.fight.playerManager:GetPlayer():GetCtrlEntity()
	curRole = BehaviorFunctions.fight.playerManager:GetPlayer():GetHeroIdByInstanceId(curRole)
	curRole = curRole or mod.RoleCtrl:GetCurUseRole()
	if curRole then
		local roleData = mod.RoleCtrl:GetRoleData(curRole)
		if roleData and roleData.lev then
			self.LvNumText_txt.text = roleData.lev
		else
			self.LvNumText_txt.text = " "
		end
	end
end

function FightInfoPanel:UpdateRoleInfo()
	self:UpdatePlayer()
end

local LowHpInterval = 0.4
local LowHpColor = Color(209/255, 59/255, 51/255)
local NormalHpColor = Color(1, 1, 1)
function FightInfoPanel:UpdatePlayerHp()
	if not self.loadDone then
		self.updateInfo = true
		return
	end
	
	local curLife = self.playerObjAttr:GetValue(AttrType.Life, true)
	local maxLife = self.playerObjAttr:GetValue(AttrType.MaxLife, true)
	-- self.LifeFill_rect:SetSizeDeltaWidth((curLife / maxLife) * self.hpBarWidth)
	self.HeroHpText_txt.text = math.floor(curLife).." / "..maxLife
	self.HeroHpTextBg_txt.text = math.floor(curLife).." / "..maxLife
	self.Hp2DMask.padding = Vector4(0, 0, (self.hpBarWidth - (curLife / maxLife) * self.hpBarWidth) * self.HP_rect.localScale.x, 0)

	local color = NormalHpColor
	if curLife / maxLife < LowHpInterval then
		color = LowHpColor
		BehaviorFunctions.PlayFightUIEffect("22053_canxue_Loop", "BgFill")
	else
		BehaviorFunctions.StopFightUIEffect("22053_canxue_Loop", "BgFill")
		
	end
	
	self.LifeFill_img.color = color
	if not self.recordPlayerLife[self.playerObject.entityId] then
		self.recordPlayerLife[self.playerObject.entityId] = maxLife
		self.firstDone = false
	end

	local isDecIng = false
	if self.playerLifeDec and self.playerMainLifeDec 
	and (self.playerLifeDec > 5 or self.playerMainLifeDec > 5) then
		isDecIng = true
	end
	if not self.playerLifeDec then
		self.playerLifeDec = 0
		self.playerLifeDecSpeed = 0
		self.playerMainLifeDec = 0
		self.playerMainLifeDecSpeed = 0
	end

	local decHp = self.recordPlayerLife[self.playerObject.entityId] - curLife

	if decHp > 0 and self.firstDone == true then
		if curLife / maxLife < LowHpInterval then
			UtilsUI.SetActive(self.LifeRFill, false)
			UtilsUI.SetActive(self.BgLowHFill, true)
			self.BgLowHFill_img.fillAmount = (curLife + decHp) / maxLife
		else
			UtilsUI.SetActive(self.LifeRFill, true)
			UtilsUI.SetActive(self.BgLowHFill, false)
			self.LifeRFill_img.fillAmount = (curLife + decHp) / maxLife
		end
		if self.decTimer then
			LuaTimerManager.Instance:RemoveTimer(self.decTimer)
		end
		
		self.decTimer = LuaTimerManager.Instance:AddTimer(1, 0.3, function()
			if self.playerLifeDec then
				self.playerLifeDec = self.playerLifeDec + decHp
				self:_UpdatePlayerDecLifeAnim()
			end
		end)

		-- 多个怪物同时打主角的时候
		if isDecIng == true and self.decTimer then
			LuaTimerManager.Instance:RemoveTimer(self.decTimer)
			self.playerLifeDec = self.playerLifeDec + decHp
			self:_UpdatePlayerDecLifeAnim()
		end

		self.playerMainLifeDec = self.playerMainLifeDec + decHp
		self:_UpdatePlayerMainDecLifeAnim()
	else
		self.LifeFill_img.fillAmount = curLife / maxLife
		UtilsUI.SetActive(self.LifeRFill, false)
		UtilsUI.SetActive(self.BgLowHFill, false)
		self.firstDone = true
	end
	
	self.recordPlayerLife[self.playerObject.entityId] = curLife
end

function FightInfoPanel:_UpdatePlayerDecLifeAnim()
	local curLife = self.playerObjAttr:GetValue(AttrType.Life, true)
	local maxLife = self.playerObjAttr:GetValue(AttrType.MaxLife, true)
	local animCurLife = curLife + self.playerLifeDec
	if curLife / maxLife < LowHpInterval then
		UtilsUI.SetActive(self.LifeRFill, false)
		UtilsUI.SetActive(self.BgLowHFill, true)
		self.BgLowHFill_img.fillAmount = animCurLife / maxLife
	else
		UtilsUI.SetActive(self.LifeRFill, true)
		UtilsUI.SetActive(self.BgLowHFill, false)
		self.LifeRFill_img.fillAmount = animCurLife / maxLife
	end
	

	if self.playerLifeDec <= 1 then
		self.LifeRFill:SetActive(false)
	end
end

function FightInfoPanel:_UpdatePlayerMainDecLifeAnim()
	local curLife = self.playerObjAttr:GetValue(AttrType.Life, true)
	local maxLife = self.playerObjAttr:GetValue(AttrType.MaxLife, true)
	local animCurLife = curLife + self.playerMainLifeDec
	self.LifeFill_img.fillAmount = animCurLife / maxLife
end

local position20003 = {-167,0,0}
function FightInfoPanel:UpdatePlayerEnergy()
	local curEnergy = self.playerObjAttr:GetValue(AttrType.Energy)
	local maxEnergy = self.playerObjAttr:GetValue(AttrType.MaxEnergy)
	self.EnergyFill_img.fillAmount = curEnergy / maxEnergy

	if curEnergy == maxEnergy then
		self:PlayEffect("20003", "EnergyProgress", position20003)
	else
		self:StopEffect("20003", "EnergyProgress")
	end
end

function FightInfoPanel:UpdatePlayerBindNode(forceClose)
	local curPlayer = self.playerObject.entityId
	if self.nodeCacheByPlayer[curPlayer] then
		for k, v in pairs(self.nodeCacheByPlayer[curPlayer]) do
			if forceClose then
				self[k]:SetActive(false)
			else
				self[k]:SetActive(v)
			end
		end
	end
end

function FightInfoPanel:UpdatePlayerAttr(attrType)
	self:UpdataCommonCost(attrType)
end

function FightInfoPanel:SetCoreVisible(entityId, visible)
	if not self.mainView.loadDone or not self.active then
		return
	end
	
	if self.bindResPrefab[entityId] then
		self.bindResPrefab[entityId].transform.gameObject:SetActive(visible)
	end
end

function FightInfoPanel:SetCoreEffectVisible(name, visible)
	if not self.mainView.loadDone then
		return
	end
	
	if self.bindResPrefab[self.playerObject.entityId] and self.bindResPrefab[self.playerObject.entityId][name] then
		self.bindResPrefab[self.playerObject.entityId][name]:SetActive(visible)
	end
end

function FightInfoPanel:BindResPrefabs()
	if self.bindResPrefab and next(self.bindResPrefab) then
		for k, v in pairs(self.bindResPrefab) do
			self:SetCoreVisible(k, k == self.playerObject.entityId)
		end
	end

	if self.bindResPrefab[self.playerObject.entityId] and next(self.bindResPrefab[self.playerObject.entityId]) then
		return
	end

end

function FightInfoPanel:AnalyseCoreShowConfig()
	local prefabInfo = self.bindResPrefab[self.playerObject.entityId]
	if not prefabInfo then
		return
	end
	local attrMap = self.coreSkillList[self.playerObject.entityId]
	for attrType, index in pairs(attrMap) do
		local config = self.playerObject.skillSetComponent:GetConfig(attrType)
		if prefabInfo["CoreRes"..index] then
			prefabInfo["CoreRes"..index]:SetActive(config and config.PowerMask)
		end
		if prefabInfo["TimerFill"..index] then
			prefabInfo["TimerFill"..index]:SetActive(config and config.SkillCDMask)
		end
		if prefabInfo["Timer"..index] then	
			prefabInfo["Timer"..index]:SetActive(config and config.ShowCD)
		end
	end
end

function FightInfoPanel:EntityBuffChange(entityInstanceId, buffInstanceId, buffId, isAdd)
	local entity = self.mainView.playerObject
	if entity.instanceId ~= entityInstanceId then
		return
	end

	local visibleBuff, visibleDebuff = entity.buffComponent:GetVisibleBuff(5)
	if isAdd then
		self:AddBuff(entity, visibleBuff)
		self:AddBuff(entity, visibleDebuff)
	else
		self:RemoveBuff(entity, buffInstanceId, buffId)
	end
end

function FightInfoPanel:AddBuff(targetEntity, buffList)
	if not buffList or not next(buffList) then
		return
	end

	TableUtils.ClearTable(self.buffRemoveList)

	local entity = self.mainView.playerObject
	for k, v in pairs(self.buffOnShow) do
		local vIsDebuff = BehaviorFunctions.CheckIsDebuff(entity.instanceId, k)
		for i = 1, #buffList do
			local isDebuff = BehaviorFunctions.CheckIsDebuff(entity.instanceId, buffList[i].instanceId)
			if buffList[i].instanceId == k or isDebuff ~= vIsDebuff then
				break
			end

			if i == #buffList then
				table.insert(self.buffRemoveList, k)
			end
		end
	end

	for i = 1, #self.buffRemoveList do
		local buffItem = self.buffOnShow[self.buffRemoveList[i]]
		UnityUtils.SetActive(buffItem.object.object, false)
		buffItem:Reset()
		table.insert(self.buffItemPool, buffItem)
		self.buffOnShow[self.buffRemoveList[i]] = nil
	end

	for i = 1, #buffList do
		if not self.buffOnShow[buffList[i].instanceId] then
			local isDebuff = BehaviorFunctions.CheckIsDebuff(entity.instanceId, buffList[i].instanceId)
			local buffCount = targetEntity.buffComponent:GetBuffCount(buffList[i].buffId)
			local buffItem = self:GetBuffItem(targetEntity, buffList[i], buffCount)
			local parent = isDebuff and self.DebuffBoard.transform or self.BuffBoard.transform

			buffItem.object.objectTransform:SetParent(parent)
			UnityUtils.SetLocalScale(buffItem.object.objectTransform, 1, 1, 1)
			UnityUtils.SetActive(buffItem.object.object, true)
			LayoutRebuilder.ForceRebuildLayoutImmediate(self.Board.transform)
			self.buffOnShow[buffList[i].instanceId] = buffItem
		end
	end
end

function FightInfoPanel:RemoveBuff(targetEntity, buffInstanceId, buffId)
	local buffCount = targetEntity.buffComponent:GetBuffCount(buffId) - 1
	local buffItem = self.buffOnShow[buffInstanceId]
	local buffItemIndex = buffInstanceId
	if not buffItem or not next(buffItem) then
		for k, v in pairs(self.buffOnShow) do
			if v.buff.buffId == buffId then
				buffItem = v
				buffItemIndex = k
				break
			end
		end

		if not buffItem or not next(buffItem) then
			return
		end
	end

	if buffCount == 0 or not buffItem.buffConfig.isShowNum then
		buffItem.object.object:GetComponent(Animator):Play("UI_CommonBuff_out")
		buffItem:Reset()
		if self.resetTimmer then
			LuaTimerManager.Instance:RemoveTimer(self.resetTimmer)
		end
		self.resetTimmer = LuaTimerManager.Instance:AddTimer(1,1.2,function()
			LayoutRebuilder.ForceRebuildLayoutImmediate(self.Board.transform)
		end)
		table.insert(self.buffItemPool, buffItem)
		self.buffOnShow[buffItemIndex] = nil
		return
	end

	buffItem:SetBuffNum(buffCount)
end

function FightInfoPanel:CheckBuffItem(buff)
	if self.buffOnShow[buff.instanceId] and not buff.config.isShowNum then
		return false, 0
	end

	for k, v in pairs(self.buffOnShow) do
		if v.buff.buffId == buff.buffId and buff.config.isShowNum then
			return false, k
		end
	end

	return true, 0
end

function FightInfoPanel:UpdataBuffStates()
	for k, v in pairs(self.buffOnShow) do
		v:Update()
	end
end

function FightInfoPanel:GetBuffItem(entity, buff, count)
	if self.buffItemPool and next(self.buffItemPool) then
		local buffItem = table.remove(self.buffItemPool)
		buffItem:Reset()
		buffItem:InitBuff(buffItem.object, entity, buff, count)
		return buffItem
	end

	local object = self:PopUITmpObject("CommonBuff")
	UtilsUI.GetContainerObject(object.objectTransform, object)

	local buffItem = CommonBuff.New()
	buffItem:InitBuff(object, self.mainView.playerObject, buff, count)

	return buffItem
end

function FightInfoPanel:UpdateBuffIcon(buff, index)
	local buffObjectInfo = self.buffInfoMap[index]
	if not buff then
		if buffObjectInfo.object.gameObject.activeSelf then
			buffObjectInfo.object:SetActive(false)
		end
		return
	end
	if not buffObjectInfo.object.gameObject.activeSelf then
		buffObjectInfo.object:SetActive(true)
	end
	if buffObjectInfo.buffId ~= buff.buffId then
		buffObjectInfo.buffId = buff.buffId
		buffObjectInfo.duration = buff.config.Duration * 10000
		SingleIconLoader.Load(buffObjectInfo.iconObject, buff.config.buffIconPath)
	end
	if buff.level and buff.level > 1 then
		buffObjectInfo.levelCount.text = buff.level
	else
		buffObjectInfo.levelCount.text = ""
	end

	buffObjectInfo.fillIcon.fillAmount = 1 - buff.duration / buffObjectInfo.duration
end

function FightInfoPanel:UpdataCommonCost(attrType)
	if attrType == FightEnum.RoleSkillPoint.Ex then
		self:ShowBulePower()
	elseif attrType == FightEnum.RoleSkillPoint.Normal then
		self:ShowYellowPower()
	end
end

function FightInfoPanel:ShowBulePower()
	if not self.playerObject.attrComponent then
		return
	end
	local curValue, maxValue = self.playerObject.attrComponent:GetValueAndMaxValue(FightEnum.RoleSkillPoint.Ex)
	local pointValue = maxValue / 3
	local pointCount, overflow = math.modf(curValue / pointValue)
	local curCount = 1
	for i = curCount, pointCount, 1 do
		self["Blue"..i.."_img"].fillAmount = 1
		self["Blue"..i.."MaskBg_img"].fillAmount = 1
		curCount = curCount + 1
	end

	if self.oldBlue and self.isUseBlue == true then
		local oldPointCount, oldOverflow = math.modf(self.oldBlue / pointValue)
		if oldPointCount > pointCount then
			for i = oldPointCount, pointCount + 1, -1 do
				if i > 0 then
					self["Blue"..i .. "Anim_anim"]:Play("UI_Blue_xiaohao", 0, 0)
				end
			end
		end
		self.isUseBlue = false
	end
	
	if self["Blue"..curCount.."_img"] then
		local wight = self["Blue"..curCount.."_rect"].sizeDelta.x
		wight = wight * overflow
		self["Blue"..curCount.."_img"].fillAmount = 0.19 + overflow * 0.61
		self["Blue"..curCount.."MaskBg_img"].fillAmount = 0.12 + overflow * 0.76
	end

	for i = curCount + 1, 3, 1 do
		self["Blue"..i.."_img"].fillAmount = 0
		self["Blue"..i.."MaskBg_img"].fillAmount = 0
	end

	UtilsUI.SetActive(self.BlueHigh, pointCount == 3)
	self:UpdateBlueBarAnim(self.oldBlue, curValue, pointValue)
	self.oldBlue = curValue
end
function FightInfoPanel:IsUseSkill(exValue, needNormalValue)
	self.isUseBlue = exValue > 0
	self.isUseYellow = needNormalValue > 0
end

function FightInfoPanel:ShowYellowPower()
	local curValue, maxValue = self.playerObject.attrComponent:GetValueAndMaxValue(FightEnum.RoleSkillPoint.Normal)
	local pointValue = maxValue / 3
	local pointCount, overflow = math.modf(curValue / pointValue)
	if curValue == maxValue then
		pointCount = 3
	end

	if self.oldYellow and self.isUseYellow == true then
		local oldPointCount, oldOverflow = math.modf(self.oldYellow / pointValue)
		if oldPointCount > pointCount then
			for i = oldPointCount, pointCount + 1, -1 do
				if i > 0 then
					self["Yellow"..i .. "Anim_anim"]:Play("UI_Yellow_xiaohao", 0, 0)
				end
			end

		end
		self.isUseYellow = false
	end

	local curCount = 1
	for i = curCount, pointCount, 1 do
		self["Yellow"..i.."_img"].fillAmount = 1
		self["Yellow"..i.."MaskBg_img"].fillAmount = 1
		curCount = curCount + 1
	end

	if self["Yellow"..curCount.."_img"] then
		local wight = self["Yellow"..curCount.."_rect"].sizeDelta.x
		wight = wight * overflow
		self["Yellow"..curCount.."_img"].fillAmount = (overflow + 0.2) * 0.6
		self["Yellow"..curCount.."MaskBg_img"].fillAmount = overflow * 0.73
	end

	for i = curCount + 1, 3, 1 do
		self["Yellow"..i.."_img"].fillAmount = 0
		self["Yellow"..i.."MaskBg_img"].fillAmount = 0
	end

	UtilsUI.SetActive(self.YellowHigh, pointCount == 3)
	self:UpdateYellowBarAnim(self.oldYellow, curValue, pointValue)
	self.oldYellow = curValue
end

function FightInfoPanel:UpdateBlueBarAnim(curValue, tagetValue, pointValue)
	self.refer2Blue = self.refer2Blue or 0 
	if curValue and self.blueValue then
		if curValue >= self.blueValue then
			self.blueValue = curValue or self.blueValue
			self.refer2Blue = 0
		end
	else
		self.blueValue = curValue or self.blueValue
	end

	self.blueTarget = tagetValue or self.blueTarget
	self.bluePointValue = pointValue or self.bluePointValue

	if curValue or tagetValue then
		return
	end

	if self.blueValue and self.blueTarget then
		if self.blueValue == self.blueTarget then
			return
		end

		self.refer2Blue = self.refer2Blue + Time.deltaTime
		local refer = self.animCurve:Evaluate(self.refer2Blue)

		local changeValue = self.bluePointValue / 12
		changeValue = changeValue * refer
		self.blueValue = self.blueValue - changeValue
		if self.blueValue < self.blueTarget then
			self.blueValue = self.blueTarget
		end

		local pointCount, overflow = math.modf(self.blueValue / self.bluePointValue)
		local curCount = 1
		for i = 1, pointCount, 1 do
			self["Blue"..i.."_img"].fillAmount = 1
			curCount = curCount + 1
		end
		if curCount <= 3 then
			self["Blue"..curCount.."_img"].fillAmount = 0.2 + overflow * 0.6
		end
		for i = curCount + 1, 3, 1 do
			self["Blue"..i.."_img"].fillAmount = 0
		end
	end
end

function FightInfoPanel:UpdateYellowBarAnim(curValue, tagetValue, pointValue)
	self.refer2Yellow = self.refer2Yellow or 0
	if curValue and self.yellowValue then
		if curValue >= self.yellowValue then
			self.yellowValue = curValue or self.yellowValue
			self.refer2Yellow = 0
		end
	else
		self.yellowValue = curValue or self.yellowValue
	end
	self.yellowTarget = tagetValue or self.yellowTarget
	self.yellowPointValue = pointValue or self.yellowPointValue

	if curValue or tagetValue then
		return
	end

	if self.yellowValue and self.yellowTarget then
		if self.yellowValue == self.yellowTarget then
			return
		end
		self.refer2Yellow = self.refer2Yellow + Time.deltaTime
		local refer = self.animCurve:Evaluate(self.refer2Yellow)
		local changeValue = self.yellowPointValue / 12
		changeValue = changeValue * refer
		self.yellowValue = self.yellowValue - changeValue
		if self.yellowValue < self.yellowTarget then
			self.yellowValue = self.yellowTarget
		end
	end
	if self.yellowValue and self.yellowPointValue then
		local pointCount, overflow = math.modf(self.yellowValue / self.yellowPointValue)
		local curCount = 1
		for i = 1, pointCount, 1 do
			self["Yellow"..i.."_img"].fillAmount = 1
			curCount = curCount + 1
		end
		if curCount <= 3 then
			self["Yellow"..curCount.."_img"].fillAmount = (overflow + 0.2) * 0.6
		end
		for i = curCount + 1, 3, 1 do
			self["Yellow"..i.."_img"].fillAmount = 0
		end
	end
end

function FightInfoPanel:ResetPowerBar()
	self.blueValue = nil
	self.yellowValue = nil
	self.blueTarget = nil
	self.yellowTarget = nil
	self.oldBlue = nil
	self.oldYellow = nil
	for i = 1, 3, 1 do
		self["Blue"..i .. "Anim_anim"]:Play("UI_Blue_kong", 0, 0)
		self["Yellow"..i .. "Anim_anim"]:Play("UI_Yellow_kong", 0, 0)
	end
end

function FightInfoPanel:SkillPointChangeAfter(instanceId, type, oldValue, newValue)
	if instanceId ~= self.playerObject.instanceId then
		return
	end
	newValue = math.min(newValue, 3)
	if oldValue >= newValue then
		return
	end
	if type == FightEnum.RoleSkillPoint.Ex then -- blue
		for i = oldValue + 1, newValue, 1 do
			self["Blue"..i .. "Anim_anim"]:Play("UI_Blue_chuxian", 0, 0)
		end
	elseif type == FightEnum.RoleSkillPoint.Normal then --yellow
		for i = oldValue + 1, newValue, 1 do
			self["Yellow"..i .. "Anim_anim"]:Play("UI_Yellow_chuxian", 0, 0)
		end
	end
end

function FightInfoPanel:OnEntityHit(attackId, hitId)
end

function FightInfoPanel:HideSelf()
    UtilsUI.SetActive(self.FightInfoPanel_Exit, true)
end