LifeBarObjBase = BaseClass("LifeBarObjBase", PoolBaseClass)

local AttrType = EntityAttrsConfig.AttrType
local DataMagic = Config.DataMagic.data_magic
local EntityCommonConfig = Config.EntityCommonConfig

-- 可视类型
local VisibleType = {
	None = 1,
	ForceShow = 2,
	ForceHide = 3,
}

local LevelColorChangeInterval = 2.5
local LevelColor = {
	[1] = Color(1, 1, 1), --一般威胁
	[2] = Color(172/255, 172/255, 172/255), --更低威胁
	[3]	= Color(125/255, 232/255, 163/255), --低威胁
	[4]	= Color(255/255, 166/255, 94/255), --中等威胁
	[5]	= Color(253/255, 121/255, 99/255), --高威胁
}

local DefaultScale = 0.003 --默认缩放
local DefaultHeadRadius = 0.5 -- 默认头部范围

local ColorChangePercent = 0.2 --衰减颜色改变进度
local ColorStayPercent = 0.1 --衰减颜色保持进度

local NormalColor = Color(161/255, 57/255, 57/255)
local LowPercentColor = Color(255/255, 0/255, 0/255)

function LifeBarObjBase:SetObjActive(obj, active)
	if not obj then return end

	if obj.activeSelf ~= active then
		obj:SetActive(active)
	end
end

function LifeBarObjBase:__init()

end

function LifeBarObjBase:Init(clientEntity, parent, config)
	self.clientFight = Fight.Instance.clientFight
	self.entity = clientEntity.entity
	self.instanceId = self.entity.instanceId
	self.config = config
	self.lifeBarLength = config.LifeBarLength
	
	self.logic = Fight.Instance.objectPool:Get(LifeBarLogic)
	
	self.widthScale = 1
	self.forceVisibleType = VisibleType.None
	self.restrainElement = nil
	self.restrainElementPercent = 0

	self.buffItemPool = {}
	self.buffOnShow = {}

	self:InitUI(parent)
	self:InitData()
	self:InitListener()
end

function LifeBarObjBase:LateInit()
	local func = function() 
		self:EntityAttrChange(AttrType.Life, self.entity)
	end
	
	LuaTimerManager.Instance:AddTimer(1, 0.0333, func)
end

function LifeBarObjBase:InitUI(parent)
	self.isSetLevel = false
	self.gameObject = self.clientFight.assetsPool:Get(self.config.Prefab)
	self.transform = self.gameObject.transform
	self.transform:SetParent(parent)
	UnityUtils.SetLocalScale(self.transform, DefaultScale, DefaultScale, DefaultScale)
	UtilsUI.GetContainerObject(self.transform, self)
	self:SetObjActive(self.gameObject, true)
	
	self.detailScaler = self.Detail.gameObject:GetComponent(DistanceCurveScaler)
	--self.simpleScaler = self.Simple.gameObject:GetComponent(DistanceCurveScaler)
	--self.locationTransform = self.entity.clientEntity.clientTransformComponent:GetTransform(self.config.TransformName)

	self.lifeBarTransformUpdate = self.gameObject:GetComponent(LifeBarTransformUpdate)
	self.lifeBarTransformUpdate:SetParam(self.config.OffsetX, self.config.OffsetY, self.config.OffsetZ,
			self.config.headRadius or DefaultHeadRadius, self.config.OffsetWorldY, self.config.canShowInBody)
	self.lifeBarTransformUpdate:SetEntityTransform(self.entity.clientEntity.clientTransformComponent.transform, self.entity.clientEntity.clientTransformComponent:GetTransform(self.config.TransformName))
	self.lifeBarTransformUpdate.enabled = true

	--self.offset = Vec3.New(self.config.OffsetX, self.config.OffsetY, self.config.OffsetZ)
	--self.headRadius = self.config.headRadius or DefaultHeadRadius

	local width = self:GetBarWidth()
	self.Life_rect:SetSizeDeltaWidth(width)
	self.LifeBarAssassin_rect:SetSizeDeltaWidth(width - 4)
	self.LifeBarPerfectAssassin_rect:SetSizeDeltaWidth(width - 4)
	self.LifeBar_img.fillAmount = 1
	
	self:SetObjActive(self.LifeBarAssassin, false)
	self:SetObjActive(self.LifeBarPerfectAssassin, false)
	self:SetObjActive(self["22075"], false)

	self:InitElementUI()
	--self:UpdatePlayer()
end

function LifeBarObjBase:InitElementUI()
	if not self.entity.elementStateComponent then
		self:SetObjActive(self.ElementState, false)
		self:SetObjActive(self.ElementIcon, false)
		return
	end
	
	--元素图标、克制关系
	self.selfElement = self.entity.elementStateComponent.elementType or FightEnum.ElementType.Phy
	self:SetObjActive(self.ElementIcon, self.selfElement ~= FightEnum.ElementType.Phy)
	--self:SetObjActive(self.ELArrow, self.selfElement ~= FightEnum.ElementType.Phy)
	if self.selfElement ~= FightEnum.ElementType.Phy then
		for i = 0, self.ElementIcon.transform.childCount - 1 do
			local trans = self.ElementIcon.transform:GetChild(i)
			self:SetObjActive(trans.gameObject, false)
		end
		self:SetObjActive(self["Element"..self.selfElement], true)
	end

	--元素克制条
	local elementState = self.entity.elementStateComponent:GetElementState()
	if elementState then
		self.restrainElement = elementState.element
		self:UpdateElementState(self.entity.instanceId, elementState.element, elementState.state, elementState.count, elementState.maxCount)
	end
	self:SetObjActive(self.ElementState, self.restrainElement ~= nil)
	self:SetObjActive(self.ElementStateBar, self.restrainElement ~= nil)
	self.transform_22077 = self["22077"].transform
end


function LifeBarObjBase:InitListener()
	EventMgr.Instance:AddListener(EventName.UpdateElementState, self:ToFunc("UpdateElementState"))
	EventMgr.Instance:AddListener(EventName.PlayerUpdate, self:ToFunc("UpdatePlayer"))
	EventMgr.Instance:AddListener(EventName.OnEntityBuffChange, self:ToFunc("EntityBuffChange"))
	EventMgr.Instance:AddListener(EventName.EntityAttrChange, self:ToFunc("EntityAttrChange"))
end

function LifeBarObjBase:RemoveListener()
	EventMgr.Instance:RemoveListener(EventName.UpdateElementState, self:ToFunc("UpdateElementState"))
	EventMgr.Instance:RemoveListener(EventName.PlayerUpdate, self:ToFunc("UpdatePlayer"))
	EventMgr.Instance:RemoveListener(EventName.OnEntityBuffChange, self:ToFunc("EntityBuffChange"))
	EventMgr.Instance:RemoveListener(EventName.EntityAttrChange, self:ToFunc("EntityAttrChange"))
end

function LifeBarObjBase:__delete()
	if not UtilsBase.IsNull(self.gameObject) then
		GameObject.Destroy(self.gameObject)
	end

	self.entity = nil
	self.gameObject = nil
	self.transform = nil
	self:RemoveListener()
	
	if self.logic and self.logic.DeleteMe then
		self.logic:DeleteMe()
	end
end

function LifeBarObjBase:Cache()
	self.clientFight.assetsPool:Cache(self.config.Prefab, self.gameObject)
	self:OnObjCache()
end

function LifeBarObjBase:__cache()
	self.entity = nil
	self.gameObject = nil
	self.transform = nil
	self:RemoveListener()
	
	if self.logic then
		self.logic:Cache()
	end
end

function LifeBarObjBase:GetBarWidth()
	return self.lifeBarLength * self.widthScale
end

function LifeBarObjBase:UpdateElementState(instanceId, element, state, value, maxValue)
	if not self.ElementState then return end
	
	if not BehaviorFunctions.CheckEntity(self.instanceId) then return end
	
	if instanceId ~= self.instanceId then return end
	
	if self.restrainElement ~= element then return end
	UnityUtils.BeginSample("LifeBarObjBase:UpdateElementState")

	self:SetObjActive(self.ElementStateReadyCD, state == FightEnum.ElementState.Ready)
	self:SetObjActive(self.ElementStateCoolingCD, state == FightEnum.ElementState.Cooling)
	self:SetObjActive(self.ElementStateBar, state == FightEnum.ElementState.Accumulation)
	self:SetObjActive(self["22077"], state == FightEnum.ElementState.Ready)
	
	local percent = value / maxValue
	if state == FightEnum.ElementState.Accumulation then
		self.restrainElementPercent = percent
		local width = self.restrainElementPercent * self:GetBarWidth()
		self.ElementStateBar_rect:SetSizeDeltaWidth(width)
		if self.restrainElementPercent == 1 then
			UnityUtils.SetLocalScale(self.transform_22077,1.5 * self.widthScale, 1, 1)
			self:SetObjActive(self["22078"], false)
			self:SetObjActive(self["22078"], true)
		end
	elseif state == FightEnum.ElementState.Ready then
		local width = percent * self:GetBarWidth()
		self.TargetElementStateReadyCD1_rect:SetSizeDeltaWidth(width / 2)
		self.TargetElementStateReadyCD2_rect:SetSizeDeltaWidth(width / 2)
		UnityUtils.SetLocalScale(self.transform_22077,percent * 1.5 * self.widthScale, 1, 1)
	elseif state == FightEnum.ElementState.Cooling then
		self.ElementStateCoolingCD_img.fillAmount = percent
	end
	UnityUtils.EndSample()
end

function LifeBarObjBase:UpdatePlayer()
	if not self.entity or not self.entity.attrComponent then
		return
	end

	local player = Fight.Instance.playerManager:GetPlayer():GetCtrlEntityObject()

	local lvOffset = self.entity.attrComponent.level - player.attrComponent.level
	local colorIdx = 1
	if lvOffset < -LevelColorChangeInterval * 2 then -- <-5
		colorIdx = 2
	elseif lvOffset < -LevelColorChangeInterval and lvOffset >= -LevelColorChangeInterval * 2 then -- -5~-3
		colorIdx = 3
	elseif lvOffset > LevelColorChangeInterval and lvOffset <= LevelColorChangeInterval * 2 then -- 3~5
		colorIdx = 4
	elseif lvOffset > LevelColorChangeInterval * 2 then -- >5
		colorIdx = 5
	end

	self.DetailLevel_txt.color = LevelColor[colorIdx]
	self.SimpleLevel_txt.color = LevelColor[colorIdx]
	self:UpdateRestraintEffect()
end

function LifeBarObjBase:UpdateRestraintEffect()
	local player = Fight.Instance.playerManager:GetPlayer():GetCtrlEntityObject()
	local playerElement = player.elementStateComponent.config.ElementType
	local restraint = FightEnum.ElementRelationDmgType[playerElement] == self.selfElement or playerElement == self.selfElement
	local beRestrainted = FightEnum.ElementRelationDmgType[self.selfElement] == playerElement
	local normal = not restraint and not beRestrainted
	
	self:SetObjActive(self["22102"], normal)
	self:SetObjActive(self["22103"], restraint)
	self:SetObjActive(self["22104"], beRestrainted)
end

function LifeBarObjBase:Update()
	if not self.isSetLevel and self.DetailLevel then
		local lv = "Lv."..self.entity.attrComponent.level
		self.DetailLevel_txt.text = lv
		self.SimpleLevel_txt.text = lv
		self.isSetLevel = true
		self:UpdatePlayer()
	end
	
	local forceShow = self.forceVisibleType == VisibleType.ForceShow
	local forceHide = self.forceVisibleType == VisibleType.ForceHide

	if forceHide or (not self.delayDeathHide and self.entity.stateComponent and self.entity.stateComponent:IsState(FightEnum.EntityState.Death)) then
		self:SetObjActive(self.gameObject, false)
		return
	end
	UnityUtils.BeginSample("LifeBarObjBase:Update")

	UnityUtils.BeginSample("LifeBarObjBase:LogicUpdate")
	self:LogicUpdate()
	UnityUtils.EndSample()

	local Visibility = false
	if forceShow or self:CheckShowDetail() then
		self:SetObjActive(self.Detail, true)
		self:SetObjActive(self.DetailLevel, self:CheckShowLevel())
		Visibility = true
	else
		self:SetObjActive(self.Detail, false)
	end

	if not forceShow and (self:CheckShowSimple() and self:CheckShowLevel()) then
		self:SetObjActive(self.Simple, true)
		Visibility = true
	else
		self:SetObjActive(self.Simple, false)
	end

	if Visibility == false then
		UnityUtils.EndSample()
		return
	end

	UnityUtils.BeginSample("LifeBarObjBase:UpdateBuffIcon")
	self:UpdateBuffIcon()
	UnityUtils.EndSample()

	UnityUtils.BeginSample("LifeBarObjBase:UpdateDecLifeAnim")
	self:UpdateDecLifeAnim()
	UnityUtils.EndSample()

	self:UpdateTransform()
	UnityUtils.EndSample()
end

function LifeBarObjBase:EntityAttrChange(attrType, entity, oldValue, newValue)
	if not entity then return end
	if entity.instanceId ~= self.instanceId or attrType ~= AttrType.Life then
		return
	end
	UnityUtils.BeginSample("LifeBarObjBase:EntityAttrChange")
	local value, maxValue = entity.attrComponent:GetValueAndMaxValue(attrType)
	self:UpdateLifeBar(value, maxValue)
	self:UpdateShow()
	UnityUtils.EndSample()
	--self:UpdateAssassinBar(value, maxValue)
end

function LifeBarObjBase:UpdateLifeBar(curLife, maxLife)
	if not self.Life then
		return
	end

	local rColorPercent = math.min((self.logic.rLife - curLife) / maxLife, ColorChangePercent)
	rColorPercent = (rColorPercent - ColorStayPercent) / (ColorChangePercent - ColorStayPercent)
	self.LifeRBar_img.color = Color.Lerp(LowPercentColor, NormalColor, rColorPercent)

	local percent = curLife / maxLife
	self.LifeBar_img.fillAmount = percent
	
	self.logic:UpdateLifeBar(curLife, maxLife)
	
	local posX = (percent - 1) * self:GetBarWidth()
	UnityUtils.SetAnchoredPosition(self["22064"].transform, posX + 2, 0, 0)

	UnityUtils.SetActive(self["22064"], false)
	UnityUtils.SetActive(self["22064"], true)
end

function LifeBarObjBase:UpdateDecLifeAnim()
	local percent = self.logic:DoDecLifeAnim()
	self.LifeRBar_img.fillAmount = percent
end

function LifeBarObjBase:UpdateTransform()
	--一般1、6，耗时比较多且稳定。特殊情况3、4耗时会爆
	--local entityPosition = UtilsBase.GetLuaPosition(self.entity.clientEntity.clientTransformComponent.transform)
	--local entityRotation = UtilsBase.GetLuaRotation(self.entity.clientEntity.clientTransformComponent.transform)
	--local camRotation = UtilsBase.GetLuaRotation(self.clientFight.cameraManager.mainCamera.transform)
	--
	--entityPosition = entityPosition + entityRotation * self.offset
	--local barPosition = self:CalcLifeBarPosition(camRotation)
	self:UpdateScale()
	--if self.config.canShowInBody then
	--	local entityViewport = UtilsBase.WorldToViewportPoint(entityPosition.x, entityPosition.y, entityPosition.z)
	--	local barViewport = UtilsBase.WorldToViewportPoint(barPosition.x, barPosition.y, barPosition.z)
	--	if entityViewport.y < 1 and entityViewport.y > 0 and entityViewport.x > 0 and entityViewport.x < 1 then
	--		if barViewport.y > 0.92 then
	--			barViewport.y = 0.92
	--			barPosition = UtilsBase.ViewportToWorldPoint(barViewport.x, barViewport.y + self.offset.y, barViewport.z)
	--		end
	--	end
	--end
	--
	--UnityUtils.SetPosition(self.transform, entityPosition.x, barPosition.y, entityPosition.z)
	--UnityUtils.SetRotation(self.transform, camRotation.x, camRotation.y, camRotation.z, camRotation.w)
end

--Update中使用的变量
--local shiftOffset = Vec3.New(0,0,0)
--local tempBarPos = Vec3.New(0,0,0)
--function LifeBarObjBase:CalcLifeBarPosition(camRotation)
--	 UnityUtils.BeginSample("LifeBarObjBase:CalcLifeBarPosition")
--	local euler = camRotation:ToEulerAngles()--会构建v3
--	if euler.x > 180 then
--		euler.x = 360 - euler.x
--	end
--	shiftOffset:Set(0, euler.x / 90 * self.headRadius, 0)
--	local offset = camRotation * shiftOffset
--
--	tempBarPos:Set()
--	if self.locationTransform then
--		tempBarPos:Add(self.locationTransform.position)
--	end
--	tempBarPos:AddXYZ(0, self.config.OffsetWorldY, 0)
--	if not self.config.lockPosion then
--		tempBarPos:Set(tempBarPos.x + offset.x,tempBarPos.y + offset.y, tempBarPos.z + offset.z)
--	end
--	UnityUtils.EndSample()
--	return tempBarPos
--end

--涉及修改width的需要一直更新，性能都不会好
function LifeBarObjBase:UpdateScale()
	UnityUtils.BeginSample("LifeBarObjBase:UpdateScale")
	--self.detailScaler:UpdateScale(barPosition.x, barPosition.y, barPosition.z)
	--self.simpleScaler:UpdateScale(barPosition.x, barPosition.y, barPosition.z)
	self.widthScale = self.detailScaler:GetWidthScale()

	--血条
	local width = self:GetBarWidth()
	if self.Life.activeInHierarchy then
		self.Life_rect:SetSizeDeltaWidth(width)
	end
	
	--刺杀条
	if self.LifeBarAssassin.activeInHierarchy then
		self:UpdateAssassinBar(self.logic.recordLife, self.logic.recordMaxLife)
	end

	--元素克制条
	if self.ElementState.activeInHierarchy then
		self.ElementState_rect:SetSizeDeltaWidth(width)
		local elementWidth = self.restrainElementPercent * width
		self.ElementStateBar_rect:SetSizeDeltaWidth(elementWidth)
	end

	--元素图标、克制关系
	if self.ElementIcon.activeInHierarchy then
		local x = 0.5 * -width
		UnityUtils.SetAnchoredPosition(self.ElementIcon_rect, x, self.ElementIcon_rect.anchoredPosition.y)
		--self.ELArrow_rect.anchoredPosition = Vector2(x, self.ELArrow_rect.anchoredPosition.y)
	end
	UnityUtils.EndSample()
end

function LifeBarObjBase:EntityBuffChange(entityInstanceId, buffInstanceId, buffId, isAdd)
	if not self.entity or entityInstanceId ~= self.entity.instanceId then
		return
	end

	if not self.entity.buffComponent then
		return
	end

	local visibleBuff, visibleDebuff = self.entity.buffComponent:GetVisibleBuff(3)
	if isAdd then
		self:AddBuff(self.entity, visibleBuff)
	else
		self:RemoveBuff(self.entity, buffInstanceId, buffId)
	end
end

function LifeBarObjBase:AddBuff(targetEntity, buffList)
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
		self:SetObjActive(buffItem.object.object, false)
		buffItem:Reset()
		table.insert(self.buffItemPool, buffItem)
		self.buffOnShow[removeList[i]] = nil
	end

	for i = 1, #buffList do
		if not self.buffOnShow[buffList[i].instanceId] then
			local buffCount = targetEntity.buffComponent:GetBuffCount(buffList[i].buffId)
			local buffItem = self:GetBuffItem(targetEntity, buffList[i], buffCount)
			local parent = self.BuffArea.transform

			buffItem.object.objectTransform:SetParent(parent)
			UnityUtils.SetLocalScale(buffItem.object.objectTransform, 1, 1, 1)
			UnityUtils.SetRotation(buffItem.object.objectTransform, 0, 0, 0, 0)
			UnityUtils.SetLocalPosition(buffItem.object.objectTransform, 0, 0, 0)
			self:SetObjActive(buffItem.object.object, true)
			self.buffOnShow[buffList[i].instanceId] = buffItem
		end
	end
end

function LifeBarObjBase:RemoveBuff(targetEntity, buffInstanceId, buffId)
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
		self:SetObjActive(buffItem.object.object, false)
		buffItem:Reset()
		table.insert(self.buffItemPool, buffItem)
		self.buffOnShow[buffItemIndex] = nil
		return
	end

	buffItem:SetBuffNum(buffCount)
end

function LifeBarObjBase:GetBuffItem(entity, buff, count)
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

function LifeBarObjBase:UpdateBuffIcon()
	for k, v in pairs(self.buffOnShow) do
		v:Update()
	end
end

function LifeBarObjBase:UpdateAssassinTip(attackId, hitId, skillId, magicId, perfectMagicId)
	if not BehaviorFunctions.CheckEntity(self.instanceId) then
		return
	end
	
	if self.LifeBarAssassin.activeInHierarchy then
		return 
	end
	
	local attack = Fight.Instance.entityManager:GetEntity(attackId)
	local hit = Fight.Instance.entityManager:GetEntity(hitId)
	if not attack or not hit then
		return
	end
	local magic = MagicConfig.GetMagic(magicId, 1000)
	if not magic or not magic.Param or not magic.Param.DamageType == FightEnum.DamageType.Assassinate then
		print("magicId ", magicId ," 不是暗杀伤害magic")
		return
	end
	---获取佩从技能等级
	local uniqueId = mod.RoleCtrl:GetRolePartner(attack.masterId)
	local partnerData = mod.BagCtrl:GetPartnerData(uniqueId)
	local skillLevel
	if not partnerData or not partnerData.skill_list or not partnerData.skill_list[skillId] then
		skillLevel = 1
	else
		skillLevel = partnerData.skill_list[skillId]
	end
	local magicConfigKey = UtilsBase.GetDoubleKeys(magicId, skillLevel, 16)
	local SkillParam = DataMagic[magicConfigKey] and DataMagic[magicConfigKey].param1 or magic.Param.SkillParam
	local hitAttrs = hit.attrComponent.attrs
	local entityDefLevel = hit.attrComponent.level
	local entityAtkLevel = attack.attrComponent.level
	local levelDiff = entityDefLevel - entityAtkLevel > EntityCommonConfig.AssassinateMinLvDiff and entityDefLevel - entityAtkLevel - EntityCommonConfig.AssassinateMinLvDiff or 0
	self.assassinPercent = ((SkillParam or 10000) / 10000) - (hitAttrs[AttrType.AssassinateDef]) - (levelDiff * EntityCommonConfig.AssassinateLvParam)

	magic = MagicConfig.GetMagic(perfectMagicId, 1000)
	magicConfigKey = UtilsBase.GetDoubleKeys(perfectMagicId, skillLevel, 16)
	SkillParam = DataMagic[magicConfigKey] and DataMagic[magicConfigKey].param1 or magic.Param.SkillParam
	self.perfectAssassinPercent = ((SkillParam or 10000) / 10000) - (hitAttrs[AttrType.AssassinateDef]) - (levelDiff * EntityCommonConfig.AssassinateLvParam)

	local curLife, maxLife = self.entity.attrComponent:GetValueAndMaxValue(AttrType.Life)
	self:UpdateAssassinBar(curLife, maxLife, true)
end

function LifeBarObjBase:UpdateAssassinBar(curLife, maxLife, force)
	if not self.LifeBarAssassin.activeInHierarchy and not force then
		return
	end
	local lifePercent = curLife / maxLife
	local width = self:GetBarWidth() - 4 -- 4是距离边框的偏移量
	local percent = math.min(lifePercent, self.assassinPercent or 0)
	self.LifeBarAssassin_rect:SetSizeDeltaWidth(width * percent)

	percent = math.min(lifePercent, self.perfectAssassinPercent or 0)
	self.LifeBarPerfectAssassin_rect:SetSizeDeltaWidth(width * percent)

	local offsetX = -width * (1 - lifePercent)
	UnityUtils.SetAnchoredPosition(self.LifeBarAssassin_rect, offsetX, 0)
	UnityUtils.SetAnchoredPosition(self.LifeBarPerfectAssassin_rect, offsetX, 0)

	self:SetObjActive(self.LifeBarAssassin, true)
	self:SetObjActive(self.LifeBarPerfectAssassin, true)
	--1.处理特效位置和偏移问题，该特效暂时不用
	if percent >= lifePercent then
		self:SetObjActive(self["22075"], true)
		UnityUtils.SetLocalScale(self["22075"].transform, 0.0063 * width, 1, 0.0063 * width)
		UnityUtils.SetAnchoredPosition(self["22075"].transform, -90 * (1- lifePercent), 0)
	end
end

function LifeBarObjBase:HideAssassinTip(attackId, hitId)
	self:SetObjActive(self.LifeBarAssassin, false)
	self:SetObjActive(self.LifeBarPerfectAssassin, false)
	self:SetObjActive(self["22075"], false)
end

function LifeBarObjBase:PopUITmpObject(name)
	local objectInfo = {}
	if self.uiTmpObjCache and self.uiTmpObjCache[name] then
		local objectInfo = self.uiTmpObjCache[name][1]
		if objectInfo then
			table.remove(self.uiTmpObjCache[name], 1)
			self:SetObjActive(objectInfo.object, true)

			return objectInfo
		end
	end

	objectInfo.object = GameObject.Instantiate(self[name])
	objectInfo.objectTransform = objectInfo.object.transform
	return objectInfo, true
end

--重载
function LifeBarObjBase:InitData()

end

function LifeBarObjBase:LogicUpdate()

end

function LifeBarObjBase:UpdateShow(showElementBar)
	if showElementBar ~= nil then
		self:SetObjActive(self.ElementState, showElementBar)
	end
end

function LifeBarObjBase:DelayDeathHide(delay)
	self.delayDeathHide = delay
end

function LifeBarObjBase:CheckShowDetail()
	return false
end

function LifeBarObjBase:CheckShowSimple()
	return false
end

function LifeBarObjBase:CheckShowLevel()
	return false
end

function LifeBarObjBase:OnObjCache()
end

function LifeBarObjBase:SetLifeBarForceVisibleType(visibleType)
	self.forceVisibleType = visibleType
	if self.forceVisibleType ~= VisibleType.ForceHide then
		self:SetObjActive(self.gameObject, true)
	else
		self:SetObjActive(self.gameObject, false)
	end
end