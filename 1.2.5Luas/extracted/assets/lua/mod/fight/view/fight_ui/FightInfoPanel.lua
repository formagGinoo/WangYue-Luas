FightInfoPanel = BaseClass("FightInfoPanel", BasePanel)

local AttrType = EntityAttrsConfig.AttrType

function FightInfoPanel:__init(mainView)
	self:SetAsset("Prefabs/UI/Fight/FightInfoPanel.prefab")
	self.mainView = mainView

	self.loadDone = false

	self.bindResPrefab = {}
	self.bindResAttrSetting = {}
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
	EventMgr.Instance:AddListener(EventName.UpdateSkillInfo, self:ToFunc("UpdateCoreCD"))
	EventMgr.Instance:AddListener(EventName.SkillPointChangeAfter, self:ToFunc("SkillPointChangeAfter"))
	EventMgr.Instance:AddListener(EventName.OnEntityHit, self:ToFunc("OnEntityHit"))
	EventMgr.Instance:AddListener(EventName.OnEntityBuffChange, self:ToFunc("EntityBuffChange"))
end

function FightInfoPanel:__BaseShow()
	self:SetParent(self.mainView.PanelParent.transform)
end

function FightInfoPanel:__Create()
	self.animCurve = self.PowerGroup:GetComponent(DistanceCurveScaler).curve
	self.hpBarWidth = self.LifeProgress.transform.rect.width - 5
end

function FightInfoPanel:__Show()
	self.loadDone = true
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
	EventMgr.Instance:RemoveListener(EventName.UpdateSkillInfo, self:ToFunc("UpdateCoreCD"))
	EventMgr.Instance:RemoveListener(EventName.SkillPointChangeAfter, self:ToFunc("SkillPointChangeAfter"))
	EventMgr.Instance:RemoveListener(EventName.OnEntityHit, self:ToFunc("OnEntityHit"))
	EventMgr.Instance:RemoveListener(EventName.OnEntityBuffChange, self:ToFunc("EntityBuffChange"))
end

function FightInfoPanel:__Hide()
	self.playerLifeDecSpeed = 0
end

function FightInfoPanel:Update()
	if self.playerLifeDec and self.playerLifeDec > 0 then
		self.playerLifeDec = math.max(0, self.playerLifeDec - self.playerLifeDecSpeed * Time.unscaledDeltaTime)
		self:_UpdatePlayerDecLifeAnim()
	end
	self:UpdataBuffStates()
	self:UpdateBlueBarAnim()
	self:UpdateYellowBarAnim()
end

function FightInfoPanel:UpdatePlayer()
	self.playerObject = Fight.Instance.playerManager:GetPlayer():GetCtrlEntityObject()
	self.playerObjAttrs = self.playerObject.attrComponent.attrs
	
	if not self.loadDone then
		self.updateInfo = true
		return
	end
	
	local attrTable = self.playerObject.skillSetComponent:GetCoreAttrTable()

	if not self.coreSkillList then
		self.coreSkillList = {}
	end

	if not self.coreSkillList[self.playerObject.entityId] then
		local attrMap = {}
		self.coreSkillList[self.playerObject.entityId] = attrMap
		for i = 1, #attrTable do
			attrMap[attrTable[i]] = i
		end
	end

	self:UpdatePlayerLevel()
	self:BindResPrefabs()
	

	for i = 1, #attrTable do
		self.coreSkillList[self.playerObject.entityId][attrTable[i]] = i
		self:UpdatePlayerBindRes(attrTable[i])
		self:UpdateCoreCD(attrTable[i], self.playerObject.instanceId)
	end

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
	local curRole = mod.RoleCtrl:GetCurUseRole()
	if curRole then
		local roleData = mod.RoleCtrl:GetRoleData(curRole)
		self.LvNumText_txt.text = roleData.lev
	end
	-- for key, value in pairs(self.bindResPrefab) do	
	-- end
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
	
	local curLife = self.playerObjAttrs[AttrType.Life]
	local maxLife = self.playerObjAttrs[AttrType.MaxLife]
	-- self.LifeFill_img.fillAmount = curLife / maxLife
	self.LifeFill_rect:SetSizeDeltaWidth((curLife / maxLife) * self.hpBarWidth)
	self.HeroHpText_txt.text = math.floor(curLife).."/"..maxLife

	local color = NormalHpColor
	if curLife / maxLife < LowHpInterval then
		color = LowHpColor
		self.mainView:PlayEffect("21005", "BgFill")
	else
		self.mainView:StopEffect("21005", "BgFill")
	end
	
	self.LifeFill_img.color = color
	if not self.recordPlayerLife[self.playerObject.entityId] then
		self.recordPlayerLife[self.playerObject.entityId] = maxLife
	end
	self.playerLifeDec = 0
	self.playerLifeDecSpeed = 0

	local decHp = self.recordPlayerLife[self.playerObject.entityId] - curLife
	if decHp > 0 then
		UtilsUI.SetActive(self.LifeRFill, true)
		self.playerLifeDec = self.playerLifeDec + decHp
		local time = 0.4 * (1 + self.playerLifeDec / maxLife  * 0.3)
		self.playerLifeDecSpeed = math.max(self.playerLifeDec / time, self.playerLifeDecSpeed)
		self:_UpdatePlayerDecLifeAnim()
	else
		UtilsUI.SetActive(self.LifeRFill, false)
	end
	self.recordPlayerLife[self.playerObject.entityId] = curLife
end

function FightInfoPanel:_UpdatePlayerDecLifeAnim()
	local curLife = self.playerObjAttrs[AttrType.Life]
	local maxLife = self.playerObjAttrs[AttrType.MaxLife]
	local animCurLife = curLife + self.playerLifeDec
	self.LifeFill_rect:SetSizeDeltaWidth((curLife / maxLife) * self.hpBarWidth)
	self.LifeRFill_rect:SetSizeDeltaWidth((animCurLife / maxLife) * self.hpBarWidth)

	if self.playerLifeDec <= 0 then
		self.LifeRFill:SetActive(false)
	end
end

local position20003 = {-167,0,0}
function FightInfoPanel:UpdatePlayerEnergy()
	local curEnergy = self.playerObjAttrs[AttrType.Energy]
	local maxEnergy = self.playerObjAttrs[AttrType.MaxEnergy]
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

function FightInfoPanel:UpdatePlayerCommonAttr()
	local curValue = self.playerObjAttrs[AttrType.CommonAttr1]
	local maxValue = self.playerObjAttrs[AttrType.MaxCommonAttr1]
	self.CmAttrFill_img.fillAmount = curValue / maxValue
	self.CmAttrText_txt.text = curValue.."/"..maxValue
end

function FightInfoPanel:UpdatePlayerAttr(attrType)
	self:UpdatePlayerBindRes(attrType)
	self:UpdataCommonCost(attrType)
end

function FightInfoPanel:UpdatePlayerBindRes(attrType)
	-- local maxAttrType = EntityAttrsConfig.AttrType2MaxType[attrType]
	-- local curValue = self.playerObjAttrs[attrType]
	-- local maxValue = self.playerObjAttrs[maxAttrType]
	local attrMap = self.coreSkillList[self.playerObject.entityId]
	if not attrMap or not attrMap[attrType] then
		return
	end

	local attrTypeIndex = attrMap[attrType]
	local config = self.playerObject.skillSetComponent:GetConfig(attrType)
	local curValue, maxValue = self.playerObject.skillSetComponent:GetSetButton(attrType):GetCostValue()

	if self.bindResPrefab[self.playerObject.entityId] then
		local prefabInfo = self.bindResPrefab[self.playerObject.entityId]
		
		if config.PowerMask and prefabInfo["CoreRes"..attrTypeIndex.."_img"] then
			prefabInfo["CoreRes"..attrTypeIndex.."_img"].fillAmount = curValue / maxValue
		end

		local usable = self.playerObject.skillSetComponent:CheckUseSkill(attrType) or false
		if prefabInfo["Icon"..attrTypeIndex.."_img"] then
			if usable then
				prefabInfo["Icon"..attrTypeIndex.."_img"].alpha = 1
			else
				prefabInfo["Icon"..attrTypeIndex.."_img"].alpha = 0.6
			end
		end

		if config.ReadyEffect then
			if prefabInfo["Effect"..attrTypeIndex] then
				UtilsUI.SetActive(prefabInfo["Effect"..attrTypeIndex], usable)
			end
		end
		-- if prefabInfo["BindRes"..attrType] and self.bindResAttrSetting[self.playerObject.entityId] then
		-- 	for k, v in pairs(self.bindResAttrSetting[self.playerObject.entityId]) do
		-- 		if v.AttrType == attrType and v.ShowType ~= FightEnum.BindResType.None then
		-- 			local canShow = v.ShowType == FightEnum.BindResType.Always
		-- 			if v.ShowType == FightEnum.BindResType.Empty then
		-- 				canShow = curValue == 0
		-- 			elseif v.ShowType == FightEnum.BindResType.Full then
		-- 				canShow = curValue == maxValue
		-- 			else
		-- 				canShow = canShow or (curValue > 0)
		-- 			end
		-- 			prefabInfo["BindRes"..v.AttrType]:SetActive(canShow)
		-- 			break
		-- 		end
		-- 	end
		-- end
	end
end

function FightInfoPanel:UpdateCoreCD(attrType, instanceId)
	if instanceId == self.playerObject.instanceId then
		local setButton = self.playerObject.skillSetComponent:GetSetButton(attrType)
		if not setButton then
			return
		end
		local curTime, maxTime = setButton:GetShowCD()
		local prefabInfo = self.bindResPrefab[self.playerObject.entityId]
		local attrMap = self.coreSkillList[self.playerObject.entityId]
		if not attrMap or not attrMap[attrType] then
			return
		end
		UnityUtils.BeginSample("UpdateCoreCD")
		local value = curTime / maxTime
		local config = self.playerObject.skillSetComponent:GetConfig(attrType)
		local attrTypeIndex = attrMap[attrType]
		value = math.max(value, 0)
		if config.SkillCDMask and prefabInfo["TimerFill"..attrTypeIndex.."_img"] then
			prefabInfo["TimerFill"..attrTypeIndex.."_img"].fillAmount = value
		end
		if config.ShowCD then
			if value == 0 then
				if prefabInfo["Timer"..attrTypeIndex.."_txt"] then
					prefabInfo["Timer"..attrTypeIndex.."_txt"].text = ""
				end

			else
				if prefabInfo["Timer"..attrTypeIndex.."_txt"] then
					value = math.ceil(curTime * 0.001) / 10
					prefabInfo["Timer"..attrTypeIndex.."_txt"].text = value
				end
			end
		end
		local usable = self.playerObject.skillSetComponent:CheckUseSkill(attrType) or false
		if prefabInfo["Icon"..attrTypeIndex.."_img"] then
			if usable then
				prefabInfo["Icon"..attrTypeIndex.."_img"].alpha = 1
			else
				prefabInfo["Icon"..attrTypeIndex.."_img"].alpha = 0.6
			end
		end

		if config.ReadyEffect then
			if prefabInfo["Effect"..attrTypeIndex] then
				UtilsUI.SetActive(prefabInfo["Effect"..attrTypeIndex], usable)
			end
		end
		UnityUtils.EndSample()
	end
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

	self.bindResAttrSetting[self.playerObject.entityId] = {}
	local corePrefabPaths = self.playerObject.skillSetComponent:GetCorePrefabPath()
	local bindResList = self.playerObject.skillSetComponent:GetUIBindRes()
	if bindResList then
		for k, v in pairs(bindResList) do
			table.insert(self.bindResAttrSetting[self.playerObject.entityId], v)
		end
	end

	if corePrefabPaths then
		local prefabInfo = {}
		local prefab = Fight.Instance.clientFight.assetsPool:Get(corePrefabPaths)
		prefab.gameObject:SetActive(true)
		prefab.gameObject.transform:SetParent(self.Core.transform, false)
		UnityUtils.SetAnchoredPosition(prefab.gameObject.transform, 0, 0)
		-- UnityUtils.SetLocalScale(prefab.gameObject.transform, 0.7, 0.7, 0.7)
		-- prefab.gameObject.transform:ResetAttr()

		prefabInfo.transform = prefab.gameObject.transform
		UtilsUI.GetContainerObject(prefabInfo.transform, prefabInfo)
		self.bindResPrefab[self.playerObject.entityId] = prefabInfo

		local attrTable = self.playerObject.skillSetComponent:GetCoreAttrTable()
		local attrMap  = self.coreSkillList[self.playerObject.entityId]
		for key, attrType in pairs(attrTable) do
			local attrIndex = attrMap[attrType]
			local config = self.playerObject.skillSetComponent:GetConfig(attrType)
			if config.ReadyEffect then
				local effect = BehaviorFunctions.fight.clientFight.assetsPool:Get(config.ReadyEffectPath)
				effect.transform:SetParent(prefabInfo["Effect"..attrIndex].transform)
				UnityUtils.SetLocalPosition(effect.transform, 0,0,0)
				UnityUtils.SetLocalScale(effect.transform, 1,1,1)
			end
		end
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

	for k, v in pairs(self.buffOnShow) do
		for i = 1, #buffList do
			if buffList[i].instanceId == k or buffList[i].config.isDebuff ~= v.buffConfig.isDebuff then
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
			local buffCount = targetEntity.buffComponent:GetBuffCount(buffList[i].buffId)
			local buffItem = self:GetBuffItem(targetEntity, buffList[i], buffCount)
			local parent = buffList[i].config.isDebuff and self.DebuffBoard.transform or self.BuffBoard.transform

			buffItem.object.objectTransform:SetParent(parent)
			UnityUtils.SetLocalScale(buffItem.object.objectTransform, 1, 1, 1)
			UnityUtils.SetActive(buffItem.object.object, true)
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
		UnityUtils.SetActive(buffItem.object.object, false)
		buffItem:Reset()
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
	buffItem:InitBuff(object, targetEntity, buff, count)

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
		UtilsUI.SetActive(self["BlueLine"..i], false)
		curCount = curCount + 1
	end
	if self["Blue"..curCount.."_img"] then
		self["Blue"..curCount.."_img"].fillAmount = overflow
	end
	
	if self["Blue"..curCount.."_img"] then
		local wight = self["Blue"..curCount.."_rect"].sizeDelta.x
		wight = wight * overflow
		UnityUtils.SetAnchoredPosition(self["BlueLine"..curCount.."_rect"], -wight, 0)
		self["Blue"..curCount.."_img"].fillAmount = overflow
		UtilsUI.SetActive(self["BlueLine"..curCount], true)
	end

	for i = curCount + 1, 3, 1 do
		self["Blue"..i.."_img"].fillAmount = 0
		UtilsUI.SetActive(self["BlueLine"..i], false)
	end
	UtilsUI.SetActive(self.BlueHigh, pointCount == 3)
	self:UpdateBlueBarAnim(self.oldBlue, curValue, pointValue)
	self.oldBlue = curValue
end

function FightInfoPanel:ShowYellowPower()
	local curValue, maxValue = self.playerObject.attrComponent:GetValueAndMaxValue(FightEnum.RoleSkillPoint.Normal)
	local pointValue = maxValue / 3
	local pointCount, overflow = math.modf(curValue / pointValue)
	if curValue == maxValue then
		pointCount = 3
	end
	local curCount = 1
	for i = curCount, pointCount, 1 do
		self["Yellow"..i.."_img"].fillAmount = 1
		UtilsUI.SetActive(self["YellowLine"..i], false)
		curCount = curCount + 1
	end

	if self["Yellow"..curCount.."_img"] then
		local wight = self["Yellow"..curCount.."_rect"].sizeDelta.x
		wight = wight * overflow
		UnityUtils.SetAnchoredPosition(self["YellowLine"..curCount.."_rect"], wight, 0)
		self["Yellow"..curCount.."_img"].fillAmount = overflow
		UtilsUI.SetActive(self["YellowLine"..curCount], true)
	end

	for i = curCount + 1, 3, 1 do
		self["Yellow"..i.."_img"].fillAmount = 0
		UtilsUI.SetActive(self["YellowLine"..i], false)
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
			self["BlueBg"..i.."_img"].fillAmount = 1
			curCount = curCount + 1
		end
		if curCount <= 3 then
			self["BlueBg"..curCount.."_img"].fillAmount = overflow
		end
		for i = curCount + 1, 3, 1 do
			self["BlueBg"..i.."_img"].fillAmount = 0
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

		local pointCount, overflow = math.modf(self.yellowValue / self.yellowPointValue)
		local curCount = 1

		for i = 1, pointCount, 1 do
			self["YellowBg"..i.."_img"].fillAmount = 1
			curCount = curCount + 1
		end
		if curCount <= 3 then
			self["YellowBg"..curCount.."_img"].fillAmount = overflow
		end
		for i = curCount + 1, 3, 1 do
			self["YellowBg"..i.."_img"].fillAmount = 0
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
		self["BlueBg"..i.."_img"].fillAmount = 0
		self["YellowBg"..i.."_img"].fillAmount = 0
	end
end

function FightInfoPanel:SkillPointChangeAfter(instanceId, type, oldValue, newValue)
	if instanceId ~= self.playerObject.instanceId then
		return
	end
	newValue = math.min(newValue, 2)
	if oldValue >= newValue then
		return
	end
	if type == FightEnum.RoleSkillPoint.Ex then -- blue
		for i = oldValue + 1, newValue, 1 do
			BehaviorFunctions.StopFightUIEffect("22054", "BlueBg"..i)
			BehaviorFunctions.PlayFightUIEffect("22054", "BlueBg"..i)
		end
	elseif type == FightEnum.RoleSkillPoint.Normal then --yellow
		for i = oldValue + 1, newValue, 1 do
			BehaviorFunctions.StopFightUIEffect("22053", "YellowBg"..i)
			BehaviorFunctions.PlayFightUIEffect("22053", "YellowBg"..i)
		end
	end
end

function FightInfoPanel:OnEntityHit(attackId, hitId)
	-- if self.playerObject.instanceId == hitId then
	-- 	local attrType = FightEnum.RoleSkillPoint.Normal
	-- 	local curValue = self.playerObjAttrs[attrType]
	-- 	if curValue > 0 then
	-- 		BehaviorFunctions.StopFightUIEffect("22057", "Yellow")
	-- 		BehaviorFunctions.PlayFightUIEffect("22057", "Yellow")
	-- 	end
	-- end
end