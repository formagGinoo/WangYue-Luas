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

local LevelColor = {
	Low = "#FFFFFF",
	Normal = "#7AF18B",
	High = "#FBE297",
	Highest = "#F86447"
}

local ElementType = {
	[2] = "jin",
	[3] = "mu",
	[4] = "shui",
	[5] = "huo",
	[6] = "tu",
}

local DefaultScale = 0.003 --默认缩放
local DefaultHeadRadius = 0.5 -- 默认头部范围

local ColorChangePercent = 0.2 --衰减颜色改变进度
local ColorStayPercent = 0.1 --衰减颜色保持进度

local NormalColor = Color(161/255, 57/255, 57/255)
local LowPercentColor = Color(255/255, 0/255, 0/255)
local StateEffectLength = 126

function LifeBarObjBase:SetObjActive(obj, active)
	if not obj then return end

	if obj.activeSelf ~= active then
		UtilsUI.SetActive(obj, active)
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
	self.lifeBarWidth = nil
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
	if ctx and ctx.Editor then
		self.gameObject.name = self.instanceId
	end
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

	--local width = self:GetBarWidth()
	--self.Life_rect:SetSizeDeltaWidth(width)
	--self.LifeBarAssassin_rect:SetSizeDeltaWidth(width)
	--self.LifeBarPerfectAssassin_rect:SetSizeDeltaWidth(width)
	self.ElementStateBar_rect:SetSizeDeltaWidth(0)
	self.LifeBar_img.fillAmount = 1
	
	self:SetObjActive(self.LifeBarAssassin, false)
	self:SetObjActive(self.LifeBarPerfectAssassin, false)
	self:SetObjActive(self["UI_cishaxeutiao_putong"], false)

	self:InitElementUI()
	--self:UpdatePlayer()
end

function LifeBarObjBase:InitElementUI()
	if not self.entity.elementStateComponent then
		self:SetObjActive(self.ElementState, false)
		self:SetObjActive(self.ElementIcon, false)
		return
	end
	self.ElementStateCoolingCD_img.fillAmount = 0
	
	--元素图标、克制关系
	self.selfElement = self.entity.elementStateComponent.elementType or FightEnum.ElementType.Phy
	self:SetObjActive(self.ElementIcon, self.selfElement ~= FightEnum.ElementType.Phy)
	if self.selfElement ~= FightEnum.ElementType.Phy then
		AtlasIconLoader.Load(self.ElementIcon, string.format("Textures/Icon/Atlas/ElementIcon/%d.png",self.selfElement))
	end

	--元素克制条
	local elementState = self.entity.elementStateComponent:GetElementState()
	if elementState then
		self.restrainElement = elementState.element
		self:UpdateElementState(self.entity.instanceId, elementState.element, elementState.state, elementState.count, elementState.maxCount)
	end
	self:SetObjActive(self.ElementState, self.restrainElement ~= nil)
	self:SetObjActive(self.ElementStateBar, self.restrainElement ~= nil)
	-- self.transform_22077 = self["UI_kezhitiaodaojishi"].transform

	UnityUtils.SetLocalScale(self["UI_kezhitiaodaojishi_rect"], 0, 1, 1)
end


function LifeBarObjBase:InitListener()
	EventMgr.Instance:AddListener(EventName.UpdateElementState, self:ToFunc("UpdateElementState"))
	EventMgr.Instance:AddListener(EventName.PlayerUpdate, self:ToFunc("UpdatePlayer"))
	EventMgr.Instance:AddListener(EventName.OnEntityBuffChange, self:ToFunc("EntityBuffChange"))
	EventMgr.Instance:AddListener(EventName.EntityAttrChange, self:ToFunc("EntityAttrChange"))
	EventMgr.Instance:AddListener(EventName.RoleMaxLevChange, self:ToFunc("UpdateMaxLevel"))
end

function LifeBarObjBase:RemoveListener()
	EventMgr.Instance:RemoveListener(EventName.UpdateElementState, self:ToFunc("UpdateElementState"))
	EventMgr.Instance:RemoveListener(EventName.PlayerUpdate, self:ToFunc("UpdatePlayer"))
	EventMgr.Instance:RemoveListener(EventName.OnEntityBuffChange, self:ToFunc("EntityBuffChange"))
	EventMgr.Instance:RemoveListener(EventName.EntityAttrChange, self:ToFunc("EntityAttrChange"))
	EventMgr.Instance:RemoveListener(EventName.RoleMaxLevChange, self:ToFunc("UpdateMaxLevel"))
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

function LifeBarObjBase:GetStateEffectScale(baseScale)
	return self.widthScale * baseScale * self.lifeBarLength / StateEffectLength
end

function LifeBarObjBase:UpdateElementState(instanceId, element, state, value, maxValue)
	if not self.ElementState then return end
	
	if not BehaviorFunctions.CheckEntity(self.instanceId) then return end
	
	if instanceId ~= self.instanceId then return end
	
	if self.restrainElement ~= element then return end
	UnityUtils.BeginSample("LifeBarObjBase:UpdateElementState")

	self:SetObjActive(self.ElementStateReadyCD, state == FightEnum.ElementState.Ready)
	--self:SetObjActive(self.ElementStateCoolingCD, state == FightEnum.ElementState.Cooling)
	self:SetObjActive(self.ElementStateBar, state == FightEnum.ElementState.Accumulation)
	-- self:SetObjActive(self["UI_kezhitiaodaojishi"], state == FightEnum.ElementState.Ready)

	local percent = value / maxValue
	if state == FightEnum.ElementState.Accumulation then
		self.restrainElementPercent = percent
		local width = self.restrainElementPercent * self:GetBarWidth()
		self.ElementStateBar_rect:SetSizeDeltaWidth(width)
		if self.restrainElementPercent == 1 then
			--播放克制条满特效
			UtilsUI.SetActive(self["UI_kezhitiaochongman"], true)
		else
			if self["UI_kezhitiaojianshao"].activeInHierarchy then
				UtilsUI.SetActive(self["UI_kezhitiaojianshao"], false)
			end
			UtilsUI.SetActive(self["UI_kezhitiaojianshao"], true)
			UnityUtils.SetAnchoredPosition(self["UI_kezhitiaojianshao_rect"], self:GetBarWidth() * percent, 0)
		end
		--1 * self.widthScale * percent
	elseif state == FightEnum.ElementState.Ready then
		local width = percent * self:GetBarWidth()
		self.TargetElementStateReadyCD1_rect:SetSizeDeltaWidth(width / 2)
		self.TargetElementStateReadyCD2_rect:SetSizeDeltaWidth(width / 2)
	elseif state == FightEnum.ElementState.Cooling then
		self.ElementStateCoolingCD_img.fillAmount = percent
		
		UnityUtils.SetLocalScale(self["UI_kezhitiaodaojishi_rect"], self:GetStateEffectScale(percent), 1, 1)
	end
	UnityUtils.EndSample()
end

function LifeBarObjBase:UpdatePlayer()
	self:UpdateRestraintEffect()
end

function LifeBarObjBase:UpdateMaxLevel()
	if not self.entity or not self.entity.attrComponent then
		return
	end

	local lev = mod.RoleCtrl:GetMaxRoleLev()
	local lvOffset = self.entity.attrComponent.level - lev

	local colorIdx = LevelColor.Normal
	if lvOffset <= -5 then
		colorIdx = LevelColor.Low
	elseif lvOffset > -5 and lvOffset < 5 then
		colorIdx = LevelColor.Normal
	elseif  lvOffset >= 5 and lvOffset < 10 then
		colorIdx = LevelColor.High
	elseif lvOffset >= 10 then
		colorIdx = LevelColor.Highest
	end

	UtilsUI.SetTextColor(self.DetailLevel_txt, colorIdx)
	UtilsUI.SetTextColor(self.SimpleLevel_txt, colorIdx)
	UtilsUI.SetTextColor(self.SimpleLev_txt, colorIdx)
	UtilsUI.SetTextColor(self.lev_txt, colorIdx)
end

function LifeBarObjBase:UpdateRestraintEffect()
	-- 克制动效
	local player = Fight.Instance.playerManager:GetPlayer():GetCtrlEntityObject()
	local playerElement = player.elementStateComponent.config.ElementType
	local restraint = FightEnum.ElementRelationDmgType[playerElement] == self.selfElement or playerElement == self.selfElement
	local beRestrainted = FightEnum.ElementRelationDmgType[self.selfElement] == playerElement
	local normal = not restraint and not beRestrainted

	UtilsUI.SetActive(self.ELArrow, true)
	if restraint == true then
		AtlasIconLoader.Load(self.ELArrow1, string.format("Textures/Icon/Atlas/ElementArrow/unique_guaiwukezhi_%s%d_%d.png", ElementType[playerElement], 1, 1))
		AtlasIconLoader.Load(self.ELArrow2, string.format("Textures/Icon/Atlas/ElementArrow/unique_guaiwukezhi_%s%d_%d.png", ElementType[playerElement], 1, 2))
		self.ELArrow_anim:Play("UI_MonsterLifeBarObj_kezhiloop")
	elseif beRestrainted == true then
		AtlasIconLoader.Load(self.ELArrow1, string.format("Textures/Icon/Atlas/ElementArrow/unique_guaiwukezhi_%s%d_%d.png", ElementType[playerElement], 2, 1))
		AtlasIconLoader.Load(self.ELArrow2, string.format("Textures/Icon/Atlas/ElementArrow/unique_guaiwukezhi_%s%d_%d.png", ElementType[playerElement], 2, 2))
		self.ELArrow_anim:Play("UI_MonsterLifeBarObj_beikezhiloop")
	else
		UtilsUI.SetActive(self.ELArrow, false)
	end
end

function LifeBarObjBase:Update()
	UnityUtils.SetAnchoredPosition(self.Simple_rect, self.config.OffsetX / DefaultScale, 50)
	if not self.isSetLevel and self.DetailLevel then
		local lv = self.entity.attrComponent.level
		self.DetailLevel_txt.text = lv
		self.SimpleLevel_txt.text = lv
		self.isSetLevel = true
		self:UpdatePlayer()
		self:UpdateMaxLevel()
	end
	local forceShow = self.forceVisibleType == VisibleType.ForceShow
	local forceHide = self.forceVisibleType == VisibleType.ForceHide
	
	if forceHide or (not self.delayDeathHide and self.entity.stateComponent and self.entity.stateComponent:IsState(FightEnum.EntityState.Death)) then
		self:SetObjActive(self.gameObject, false)
		return
	end
	self:LogicUpdate()

	local Visibility = false
	if forceShow or self:CheckShowDetail() then
		self:SetObjActive(self.Detail, true)
		self:SetObjActive(self.LevelBg, self:CheckShowLevel())
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
		return
	end
	
	self:UpdateBuffIcon()

	self:UpdateDecLifeAnim()

	self:UpdateScale()
end

function LifeBarObjBase:EntityAttrChange(attrType, entity, oldValue, newValue)
	if not entity then return end
	if entity.instanceId ~= self.instanceId or attrType ~= AttrType.Life then
		return
	end
	local value, maxValue = entity.attrComponent:GetValueAndMaxValue(attrType)
	self:UpdateLifeBar(value, maxValue)
	self:UpdateShow()
end

function LifeBarObjBase:UpdateLifeBar(curLife, maxLife)
	if not self.Life then
		return
	end
	
	local rColorPercent = math.min((self.logic.rLife - curLife) / maxLife, ColorChangePercent)
	rColorPercent = (rColorPercent - ColorStayPercent) / (ColorChangePercent - ColorStayPercent)
	-- 扣血动效
	if self["UI_xuetiaojianshao"].activeInHierarchy then
		UtilsUI.SetActive(self["UI_xuetiaojianshao"], false)
	end
	if curLife < maxLife then
		UtilsUI.SetActive(self["UI_xuetiaojianshao"], true)
	end
	UnityUtils.SetAnchoredPosition(self["UI_xuetiaojianshao_rect"], self:GetBarWidth() * curLife / maxLife - self:GetBarWidth(), 0)

	local percent = curLife / maxLife
	self.LifeBar_img.fillAmount = percent
	
	self.logic:UpdateLifeBar(curLife, maxLife)
	
	local posX = (percent - 1) * self:GetBarWidth()
end


function LifeBarObjBase:UpdateDecLifeAnim()
	local percent = self.logic:DoDecLifeAnim()
	self.LifeRBar_img.fillAmount = percent
end

--涉及修改width的需要一直更新，性能都不会好
function LifeBarObjBase:UpdateScale()
	self.widthScale = self.detailScaler:GetWidthScale()
	--血条
	local width = self:GetBarWidth()
	if self.LifeBarAssassin.activeInHierarchy then 
		self:UpdateAssassinBar(self.logic.recordLife, self.logic.recordMaxLife)
	end
	if width == self.lifeBarWidth then
		return
	end
	self.lifeBarWidth = width
	
	-- 血条
	--if self.Life.activeInHierarchy and self.Life_rect.sizeDelta.x ~= width then end
	self.Life_rect:SetSizeDeltaWidth(width)
	--刺杀条


	--元素克制条
	--if self.ElementState.activeInHierarchy and self.ElementState_rect.sizeDelta.x ~= width then end
	self.ElementState_rect:SetSizeDeltaWidth(width)
	--local elementWidth = self.restrainElementPercent * width
	-- self.ElementStateBar_rect:SetSizeDeltaWidth(elementWidth)
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
		-- 暂时屏蔽buff
		-- self:AddBuff(self.entity, visibleBuff)
		-- self:AddBuff(self.entity, visibleDebuff)
	else
		-- self:RemoveBuff(self.entity, buffInstanceId, buffId)
	end
end

function LifeBarObjBase:AddBuff(targetEntity, buffList)
	if not buffList or not next(buffList) then
		return
	end

	local removeList = {}
	for k, v in pairs(self.buffOnShow) do
		local vIsDebuff = BehaviorFunctions.CheckIsDebuff(targetEntity.instanceId, k)
		for i = 1, #buffList do
			local isDebuff = BehaviorFunctions.CheckIsDebuff(targetEntity.instanceId, buffList[i].instanceId)
			if buffList[i].instanceId == k or isDebuff ~= vIsDebuff then
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
		buffItem.object.object:GetComponent(Animator):Play("UI_CommonBuff_out")
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
	---获取月灵技能等级
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
	local hitAttr = hit.attrComponent
	local entityDefLevel = hit.attrComponent.level
	local entityAtkLevel = attack.attrComponent.level
	local levelDiff = entityDefLevel - entityAtkLevel > EntityCommonConfig.AssassinateMinLvDiff and entityDefLevel - entityAtkLevel - EntityCommonConfig.AssassinateMinLvDiff or 0
	self.assassinPercent = ((SkillParam or 10000) / 10000) - (hitAttr:GetValue(AttrType.AssassinateDef)) - (levelDiff * EntityCommonConfig.AssassinateLvParam)

	magic = MagicConfig.GetMagic(perfectMagicId, 1000)
	magicConfigKey = UtilsBase.GetDoubleKeys(perfectMagicId, skillLevel, 16)
	SkillParam = DataMagic[magicConfigKey] and DataMagic[magicConfigKey].param1 or magic.Param.SkillParam
	self.perfectAssassinPercent = ((SkillParam or 10000) / 10000) - (hitAttr:GetValue(AttrType.AssassinateDef)) - (levelDiff * EntityCommonConfig.AssassinateLvParam)

	local curLife, maxLife = self.entity.attrComponent:GetValueAndMaxValue(AttrType.Life)
	self:UpdateAssassinBar(curLife, maxLife, true)
end

function LifeBarObjBase:UpdateAssassinBar(curLife, maxLife, force)
	if not self.LifeBarAssassin.activeInHierarchy and not force then
		return
	end
	local lifePercent = curLife / maxLife
	local width = self:GetBarWidth()  -- 4是距离边框的偏移量
	local percent = math.min(lifePercent, self.assassinPercent or 0)
	self.LifeBarAssassin_rect:SetSizeDeltaWidth(width * percent)

	local baseScale = 1.564 * self.widthScale * 1.3
	UnityUtils.SetLocalScale(self["UI_cishaxeutiao_putong_rect"], 
		baseScale * math.max(0, percent) * (self.lifeBarLength / 250), baseScale, baseScale)
	
	self:SetObjActive(self["UI_cishaxeutiao_putong"], true)	

	percent = math.min(lifePercent, self.perfectAssassinPercent or 0)
	self.LifeBarPerfectAssassin_rect:SetSizeDeltaWidth(width * percent)

	local offsetX = -width * (1 - lifePercent)
	UnityUtils.SetAnchoredPosition(self.LifeBarAssassin_rect, offsetX, 0)
	UnityUtils.SetAnchoredPosition(self.LifeBarPerfectAssassin_rect, offsetX, 0)

	local baseScale = 1.564 * self.widthScale * 1.3
	UnityUtils.SetLocalScale(self["UI_cishaxeutiao_wanmei_rect"], 
	baseScale * math.max(0, percent) * (self.lifeBarLength / 250), baseScale, baseScale)
	self:SetObjActive(self["UI_cishaxeutiao_wanmei"], true)	

	self:SetObjActive(self.LifeBarAssassin, true)
	self:SetObjActive(self.LifeBarPerfectAssassin, true)
end

function LifeBarObjBase:HideAssassinTip(attackId, hitId)
	self:SetObjActive(self.LifeBarAssassin, false)
	self:SetObjActive(self.LifeBarPerfectAssassin, false)
	self:SetObjActive(self["UI_cishaxeutiao_putong"], false)
	self:SetObjActive(self["UI_cishaxeutiao_wanmei"], false)
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

function LifeBarObjBase:UpdateLifebarConcludePrecent()
	local concludeData = self.entity:GetConcludeBuffState()
	self.ConcludePrecent:SetActive(false)
	if not concludeData then return end
	-- 这里是万分比，只是展示百分比
	local precent = concludeData.precent / 100
	precent = math.min(precent, 100)
	self.ConcludePrecent:SetActive(true)
	self.PrecentVal_txt.text = precent .. "%"
end
