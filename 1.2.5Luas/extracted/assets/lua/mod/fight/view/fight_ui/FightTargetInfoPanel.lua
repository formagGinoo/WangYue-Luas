FightTargetInfoPanel = BaseClass("FightTargetInfoPanel", BasePanel)

local AttrType = EntityAttrsConfig.AttrType

function FightTargetInfoPanel:__init(mainView)
	self:SetAsset("Prefabs/UI/Fight/FightTargetInfoPanel.prefab")
	self.mainView = mainView
	
	self.hpBarWidth = nil
	self.loadDone = false

	self.buffOnShow = {}
	self.buffItemPool = {}
end

function FightTargetInfoPanel:__BindEvent()
end

function FightTargetInfoPanel:__BindListener()
	EventMgr.Instance:AddListener(EventName.UpdateElementState, self:ToFunc("UpdateElementState"))
	EventMgr.Instance:AddListener(EventName.OnEntityBuffChange, self:ToFunc("EntityBuffChange"))
end

function FightTargetInfoPanel:__BaseShow()
	self:SetParent(self.mainView.PanelParent.transform)
end

function FightTargetInfoPanel:__Show()
	--记录初始的血条长度
	self.hpBarWidth = self.hpBarWidth or self.TargetLifeWFill.transform.rect.width
	self.elementBarWidth = self.elementBarWidth or self.TargetElementStateFill.transform.rect.width
	if not self.logic then
		self.logic = LifeBarLogic.New()
	end

	self.TargetInfo:SetActive(false)
	local effectUtil = self["22076"]:GetComponent(EffectUtil)
	effectUtil:SetSortingOrder(self.canvas.sortingOrder + 1)
end

function FightTargetInfoPanel:__ShowComplete()
	self.mainView:AddLoadDoneCount()
end

function FightTargetInfoPanel:__delete()
	EventMgr.Instance:RemoveListener(EventName.UpdateElementState, self:ToFunc("UpdateElementState"))
	EventMgr.Instance:RemoveListener(EventName.OnEntityBuffChange, self:ToFunc("EntityBuffChange"))
end

function FightTargetInfoPanel:__Hide()

end


function FightTargetInfoPanel:Update()
	if not self.targetId then
		return
	end

	self:_UpdateBarDecLifeAnim()
	self:UpdateBuffIcon()
end

function FightTargetInfoPanel:UpdatePlayer()
	local targetEntity = Fight.Instance.entityManager:GetEntity(self.targetId)
	if not targetEntity then
		return
	end

	self:UpdateTargetElementRelation(targetEntity)
end

function FightTargetInfoPanel:UpdateInfoVisible(showBaseInfo, showRestrainInfo)
	showBaseInfo = showBaseInfo or false
	showRestrainInfo = showRestrainInfo or false
	self.BaseInfo:SetActive(showBaseInfo)
	self.RestrainInfo:SetActive(showRestrainInfo)
end

function FightTargetInfoPanel:UpdateTarget(instanceId)
	if not self.TargetInfo then
		return
	end

	if not instanceId or instanceId == 0 then
		if self.targetId then
			self.targetId = nil
			self.targetLifeDec = 0
			self.restrainElement = nil
			self.TargetInfo:SetActive(false)
		end
		return
	end

	if instanceId == self.targetId then
		return
	end
	
	self.targetId = instanceId
	self:UpdateUI()
	
	local targetEntity = Fight.Instance.entityManager:GetEntity(self.targetId)
	self:UpdateTargetAttr(AttrType.Life, targetEntity)
end

function FightTargetInfoPanel:UpdateUI()
	local targetEntity = Fight.Instance.entityManager:GetEntity(self.targetId)
	if not targetEntity then
		return
	end

	local targetAttrComp = targetEntity.attrComponent
	local targetName = ""
	if targetAttrComp.npcConfig and next(targetAttrComp.npcConfig) then
		targetName = targetAttrComp.npcConfig.name
	else
		targetName = targetAttrComp.config.DefaultName
	end

	self.TargetInfo:SetActive(true)
	self.BaseInfo:SetActive(true)
	self.RestrainInfo:SetActive(true)

	self.TargetLevelText_txt.text = "Lv."..targetEntity.attrComponent.level
	self.TargetName_txt.text = targetName
	LayoutRebuilder.ForceRebuildLayoutImmediate(self.TargetName.transform.parent)

	self:UpdateTargetElementRelation(targetEntity)

	--local maxArmor = targetAttrComp.attrs[AttrType.MaxArmor]
	--self.TargetAmbor1:SetActive(maxArmor > 0)
	--self.TargetAmbor2:SetActive(maxArmor > 0)
	--if maxArmor > 0 then
	--self:_UpdateTargetArmor()
	--end

	self.recordLifeSection = nil
	self.targetLifeSection = targetAttrComp.maxLifeSection

	for i = 1, 3 do
		--self["TargetP"..i]:SetActive(false)
		--self["TargetBgP"..i]:SetActive(false)
	end

	for i = 1, 3 do
		self["TargetP"..i]:SetActive(i <= self.targetLifeSection)
		self["TargetBgP"..i]:SetActive(i <= self.targetLifeSection)
		self["TargetP"..i.."_anim"].speed = 0
		self["TargetP"..i.."_anim"]:Play("ui_point")
	end

	self:_InitTargetLife()
	self:_InitTargetElementState()
end

function FightTargetInfoPanel:UpdateTargetAttr(attrType, target)
	if not self.targetId or target.instanceId ~= self.targetId then
		return
	end
	
	if attrType == AttrType.Life then
		local entity = Fight.Instance.entityManager:GetEntity(self.targetId)
		local value, maxValue = entity.attrComponent:GetValueAndMaxValue(attrType)
		self:UpdateLifeBar(value, maxValue)
	end
end

function FightTargetInfoPanel:UpdateTargetElementRelation(targetEntity)
	local playerEntity = Fight.Instance.playerManager:GetPlayer():GetCtrlEntityObject()
	local playerElement = playerEntity.elementStateComponent.config.ElementType
	local targetElement = targetEntity.elementStateComponent.config.ElementType

	if FightEnum.ElementRelationDmgType[playerElement] == targetElement then
		self.TargetEL:SetActive(true)
		self.TargetELArrow:SetActive(true)
		self.TargetELArrow2:SetActive(false)
		-- self.ArrowWarning:SetActive(true)
	elseif FightEnum.ElementRelationDmgType[targetElement] == playerElement then
		self.TargetEL:SetActive(true)
		self.TargetELArrow:SetActive(false)
		self.TargetELArrow2:SetActive(true)
		-- self.ArrowWarning:SetActive(false)
	else
		self.TargetEL:SetActive(false)
		-- self.ArrowWarning:SetActive(false)
	end
end

--function FightTargetInfoPanel:_UpdateTargetArmor()
	--local entity = Fight.Instance.entityManager:GetEntity(self.targetId)
	--local maxArmor = entity.attrComponent.attrs[AttrType.MaxArmor]
	--local curArmor = entity.attrComponent.attrs[AttrType.Armor]
	--local armorPercent = curArmor / maxArmor
	--self.TargetAmborFill1_img.fillAmount = armorPercent > 0.5 and 1 or armorPercent / 0.5
	--self.TargetAmborFill2_img.fillAmount = armorPercent < 0.5 and 0 or armorPercent / 0.5

	--self["20033"]:SetActive(curArmor == 0)
--end

function FightTargetInfoPanel:_InitTargetLife()
	local entity = Fight.Instance.entityManager:GetEntity(self.targetId)
	local curLife = entity.attrComponent.attrs[AttrType.Life]
	local maxLife = entity.attrComponent.attrs[AttrType.MaxLife]
	local maxlifeBar = 1 --entity.attrComponent.attrs[AttrType.LifeBar]
	self.targetBarMaxLife = maxLife / maxlifeBar
	local barCurLife = curLife % self.targetBarMaxLife
	if curLife ~= 0 and barCurLife >= 0 and barCurLife < 1 then
		barCurLife = self.targetBarMaxLife
	end

	self.TargetBgLife:SetActive(true)
	--self.TargetLifeRFill:SetActive(false)
	self.TargetLifeWFill_rect:SetSizeDeltaWidth((barCurLife / self.targetBarMaxLife) * self.hpBarWidth)

	-- local barCount = math.min(math.ceil(curLife / self.targetBarMaxLife), maxlifeBar)
	-- if barCount > 1 then
	-- 	self.TargetLifeBar_txt.text = "X"..barCount
	-- else
	-- 	self.TargetLifeBar_txt.text = ""
	-- end
	local section = entity.attrComponent.curLifeSection
	self.recordLifeSection = section
	for i = 1, self.targetLifeSection do
		local pointIndex = self.targetLifeSection - i + 1
		local pointObj = self["TargetP"..pointIndex]
		if i >= section then
			pointObj:SetActive(true)
		else
			pointObj:SetActive(false)
		end
	end

	self.targetLifeDec = 0
	self.targetLifeDecSpeed = 0
	self.recordTargetLife = curLife
	self.defaultTargetLifePos = self.TargetLife.transform.localPosition
end

function FightTargetInfoPanel:UpdateLifeBar(curLife, maxLife)
	local percent = curLife / maxLife
	self.TargetLifeWFill_img.fillAmount = percent
	
	self.logic:UpdateLifeBar(curLife, maxLife)

	-- TODO 临时特效手段
	local posX = ((percent / 0.5) - 1) * 318
	UnityUtils.SetLocalPosition(self["22064"].transform, posX + 4, -15, 0)

	UnityUtils.SetActive(self["22064"], false)
	UnityUtils.SetActive(self["22064"], true)
end

function FightTargetInfoPanel:AfterLifeAnim()
	if not self.targetLifeAnim then
		return
	end

	self.targetLifeAnim = false
end

function FightTargetInfoPanel:_UpdateBarDecLifeAnim()
	local entity = Fight.Instance.entityManager:GetEntity(self.targetId)
	if entity then
		local percent = self.logic:DoDecLifeAnim()
		self.TargetLifeRFill_img.fillAmount = percent
	end
end

function FightTargetInfoPanel:_InitTargetElementState()
	if not self.targetId then
		return 
	end
	
	local entity = Fight.Instance.entityManager:GetEntity(self.targetId)
	if not entity.elementStateComponent then
		self.TargetElementState:SetActive(false)
		return 
	end
	
	self.TargetElementState:SetActive(true)
	
	local elementState = entity.elementStateComponent:GetElementState()
	if elementState then
		self.restrainElement = elementState.element
		self:UpdateElementState(entity.instanceId, elementState.element, elementState.state, elementState.count, elementState.maxCount)
	end
end

--local MinERBarWidth = 0 --最小的元素克制条宽度，防止极低血量导致血条完全不见
--local ERBarWidth = 135
function FightTargetInfoPanel:UpdateElementState(instanceId, element, state, value, maxValue)
	if not self.targetId or instanceId ~= self.targetId then
		return
	end

	if self.restrainElement ~= element then return end

	UnityUtils.BeginSample("FightTargetInfoPanel:UpdateElementState")
	UnityUtils.SetActive(self.TargetElementStateFill, state == FightEnum.ElementState.Accumulation)
	UnityUtils.SetActive(self.TargetElementStateCoolingCD, state == FightEnum.ElementState.Cooling)
	UnityUtils.SetActive(self.TargetElementStateReadyCD, state == FightEnum.ElementState.Ready)
	UnityUtils.SetActive(self["22076"], state == FightEnum.ElementState.Ready)
	
	local percent = value / maxValue
	if state == FightEnum.ElementState.Accumulation then
		self.restrainElement = element
		if self.restrainElement then
			self.TargetElementStateFill_img.fillAmount = percent

			if percent == 1 then
				UnityUtils.SetActive(self["22065"], false)
				UnityUtils.SetActive(self["22065"], true)
			end
		end
	elseif state == FightEnum.ElementState.Ready then
		self.TargetElementStateReadyCD1_img.fillAmount = percent
		self.TargetElementStateReadyCD2_img.fillAmount = percent

		UnityUtils.SetLocalScale(self["22076"].transform, percent, 1, 1)
	elseif state == FightEnum.ElementState.Cooling then
		self.TargetElementStateCoolingCD_img.fillAmount = percent
	end
	UnityUtils.EndSample()
end

function FightTargetInfoPanel:EntityBuffChange(entityInstanceId, buffInstanceId, buffId, isAdd)
	if not self.targetId or entityInstanceId ~= self.targetId then
		return
	end

	local targetEntity = Fight.Instance.entityManager:GetEntity(entityInstanceId)
	if not targetEntity or not targetEntity.buffComponent then
		return
	end

	local visibleBuff, visibleDebuff = targetEntity.buffComponent:GetVisibleBuff(10)
	if isAdd then
		self:AddBuff(targetEntity, visibleBuff)
		self:AddBuff(targetEntity, visibleDebuff)
	else
		self:RemoveBuff(targetEntity, buffInstanceId, buffId)
	end
end

function FightTargetInfoPanel:AddBuff(targetEntity, buffList)
	if not buffList or not next(buffList) then
		return
	end

	local removeList = {}
	for k, v in pairs(self.buffOnShow) do
		for i = 1, #buffList do
			if buffList[i].instanceId == k or buffList[i].config.isDebuff ~= v.buffConfig.isDebuff then
				break
			end

			if i == #buffList then
				table.insert(removeList, k)
			end
		end
	end

	for i = 1, #removeList do
		local buffItem = self.buffOnShow[removeList[i]]
		UnityUtils.SetActive(buffItem.object.object, false)
		buffItem:Reset()
		table.insert(self.buffItemPool, buffItem)
		self.buffOnShow[removeList[i]] = nil
	end

	for i = 1, #buffList do
		if not self.buffOnShow[buffList[i].instanceId] then
			local buffCount = targetEntity.buffComponent:GetBuffCount(buffList[i].buffId)
			local buffItem = self:GetBuffItem(targetEntity, buffList[i], buffCount)
			local parent = buffList[i].config.isDebuff and self.DebuffArea.transform or self.BuffArea.transform

			buffItem.object.objectTransform:SetParent(parent)
			UnityUtils.SetLocalScale(buffItem.object.objectTransform, 1, 1, 1)
			UnityUtils.SetActive(buffItem.object.object, true)
			self.buffOnShow[buffList[i].instanceId] = buffItem
		end
	end
end

function FightTargetInfoPanel:RemoveBuff(targetEntity, buffInstanceId, buffId)
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

function FightTargetInfoPanel:GetBuffItem(entity, buff, count)
	if next(self.buffItemPool) then
		local buffItem = table.remove(self.buffItemPool)
		local object = buffItem.object
		buffItem:Reset()
		buffItem:InitBuff(object, entity, buff, count)

		return buffItem
	end

	local buffItem = CommonBuff.New()
	local object = self:PopUITmpObject("CommonBuff")
	UtilsUI.GetContainerObject(object.objectTransform, object)
	buffItem:InitBuff(object, entity, buff, count)

	return buffItem
end

function FightTargetInfoPanel:UpdateBuffIcon()
	for k, v in pairs(self.buffOnShow) do
		v:Update()
	end
end