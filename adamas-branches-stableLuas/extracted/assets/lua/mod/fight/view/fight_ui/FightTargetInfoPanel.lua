FightTargetInfoPanel = BaseClass("FightTargetInfoPanel", BasePanel)

local AttrType = EntityAttrsConfig.AttrType

local ElementType = {
	[2] = "jin",
	[3] = "mu",
	[4] = "shui",
	[5] = "huo",
	[6] = "tu",
}

function FightTargetInfoPanel:__init(mainView)
	self:SetAsset("Prefabs/UI/Fight/FightTargetInfoPanel.prefab")
	self.mainView = mainView

	self.hpBarWidth = nil
	self.loadDone = false

	self.buffOnShow = {}
	self.buffItemPool = {}

	self.timerId = 0
end

function FightTargetInfoPanel:__BindEvent()
end

function FightTargetInfoPanel:__Create()
    self.canvas = self.transform:GetComponent(Canvas)
	-- self.UI_xuetiaojianshao_BOSS_canvas = self.UI_xuetiaojianshao_BOSS.transform:GetComponent(Canvas)
end

function FightTargetInfoPanel:__BindListener()
	EventMgr.Instance:AddListener(EventName.UpdateElementState, self:ToFunc("UpdateElementState"))
	EventMgr.Instance:AddListener(EventName.OnEntityBuffChange, self:ToFunc("EntityBuffChange"))
	EventMgr.Instance:AddListener(EventName.UpdateAssassinTip, self:ToFunc("UpdateAssassinTip"))
	EventMgr.Instance:AddListener(EventName.HideAssassinTip, self:ToFunc("HideAssassinTip"))
	EventMgr.Instance:AddListener(EventName.OpenDuplicateCountDown, self:ToFunc("OpenDuplicateCountDown"))
	EventMgr.Instance:AddListener(EventName.StopDuplicateCountDown, self:ToFunc("StopDuplicateCountDown"))
	EventMgr.Instance:AddListener(EventName.SyncDuplicateCountDown, self:ToFunc("RefreshCount"))
	EventMgr.Instance:AddListener(EventName.LeaveDuplicate, self:ToFunc("HideTargetInfo"))

	UtilsUI.SetHideCallBack(self.kezhitiaojianshao_BOSS_EndAnimNode, self:ToFunc("StateBarAddCallBack"))
	-- UtilsUI.SetHideCallBack(self.xuetiaojianshao_BOSS_EndAnimNode, self:ToFunc("TargetLifeBarAddCallBack"))
end

function FightTargetInfoPanel:__BaseShow()
	self:SetParent(self.mainView.PanelParent.transform)
end

function FightTargetInfoPanel:__Show()
	--记录初始的血条长度
	self.hpBarWidth = self.hpBarWidth or self.TargetLife.transform.rect.width
	self.elementBarWidth = self.elementBarWidth or self.TargetElementState.transform.rect.width
	self.stateBarAnimator = self.UI_kezhitiaojianshao_BOSS:GetComponentInChildren(Animator)
	-- self.targetLifeBarAnimator = self.UI_xuetiaojianshao_BOSS.transform:Find("fx"):GetComponent(Animator)
	self.stateBarAddBaseScale = 5.3
	-- self.targetLifeBarBaseScale = 5.15
	-- self.UI_xuetiaojianshao_BOSS_canvas.sortingOrder = WindowManager.Instance:GetCurOrderLayer() + 1
	if not self.logic then
		self.logic = LifeBarLogic.New()
	end

	self.targetId = nil
	self.TargetInfo:SetActive(false)
end

function FightTargetInfoPanel:__ShowComplete()
	self.mainView:AddLoadDoneCount()
	UtilsUI.SetEffectMask(self.LifeHud_rect, self.xuetiaochixu_BOSS_rect)
end

function FightTargetInfoPanel:__delete()
	EventMgr.Instance:RemoveListener(EventName.UpdateElementState, self:ToFunc("UpdateElementState"))
	EventMgr.Instance:RemoveListener(EventName.OnEntityBuffChange, self:ToFunc("EntityBuffChange"))
	EventMgr.Instance:RemoveListener(EventName.UpdateAssassinTip, self:ToFunc("UpdateAssassinTip"))
	EventMgr.Instance:RemoveListener(EventName.HideAssassinTip, self:ToFunc("HideAssassinTip"))
	EventMgr.Instance:RemoveListener(EventName.OpenDuplicateCountDown, self:ToFunc("OpenDuplicateCountDown"))
	EventMgr.Instance:RemoveListener(EventName.StopDuplicateCountDown, self:ToFunc("StopDuplicateCountDown"))
	EventMgr.Instance:RemoveListener(EventName.SyncDuplicateCountDown, self:ToFunc("RefreshCount"))
	EventMgr.Instance:RemoveListener(EventName.LeaveDuplicate, self:ToFunc("HideTargetInfo"))

end

function FightTargetInfoPanel:__Hide()
	self:StopDuplicateCountDown(nil, true)
end


function FightTargetInfoPanel:Update()
	if not self.targetId then
		return
	end

	self:_UpdateBarDecLifeAnim()
	self:UpdateBuffIcon()
end

function FightTargetInfoPanel:LogicUpdate()

end

function FightTargetInfoPanel:OpenDuplicateCountDown(timerId)
	self.CoutDownInfo:SetActive(true)
	self.timerId = timerId
	self:RefreshCount()
end

function FightTargetInfoPanel:StopDuplicateCountDown(timerId, forceClose)
	if (timerId and timerId == self.timerId) or forceClose then
		self.CoutDownInfo:SetActive(false)
	end
end

function FightTargetInfoPanel:RefreshCount(timerId)
	if timerId and timerId ~= self.timerId then
		return
	end

	local time = Fight.Instance.duplicateManager:ReturnTimerTime(self.timerId)
	local min = math.floor(time / 60)
	local second = math.floor(time % 60)
	self.CoutDown_txt.text = min..':'..second
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
		-- 这个在实体编辑器里面去掉了
		-- targetName = targetAttrComp.config.DefaultName
	end

	self.TargetInfo:SetActive(true)
	self.BaseInfo:SetActive(true)
	self.RestrainInfo:SetActive(true)

	self.TargetLevelText_txt.text = targetEntity.attrComponent.level
	self.TargetName_txt.text = targetName
	LayoutRebuilder.ForceRebuildLayoutImmediate(self.TargetNameRoot.transform)

	self:UpdateTargetElementRelation(targetEntity)

	self.recordLifeSection = nil
	self.targetLifeSection = targetAttrComp.maxLifeSection

	for i = 1, 3 do
		self["TargetP"..i]:SetActive(i <= self.targetLifeSection)
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
	AtlasIconLoader.Load(self.EleIcon, "Textures/Icon/Atlas/ElementIcon/".. targetElement .. ".png")


	local restraint = FightEnum.ElementRelationDmgType[playerElement] == targetElement
	local beRestrainted = FightEnum.ElementRelationDmgType[targetElement] == playerElement
	local normal = not restraint and not beRestrainted

	UtilsUI.SetActive(self.EleArrow, true)
	if restraint == true then
		AtlasIconLoader.Load(self.EleArrow1, string.format("Textures/Icon/Atlas/ElementArrow/unique_guaiwukezhi_%s%d_%d.png", ElementType[playerElement], 1, 1))
		AtlasIconLoader.Load(self.EleArrow2, string.format("Textures/Icon/Atlas/ElementArrow/unique_guaiwukezhi_%s%d_%d.png", ElementType[playerElement], 1, 2))
		self.EleArrow_anim:Play("UI_FightTargetInfoPanel_EleArrow_kezhiloop")
	elseif beRestrainted == true then
		AtlasIconLoader.Load(self.EleArrow1, string.format("Textures/Icon/Atlas/ElementArrow/unique_guaiwukezhi_%s%d_%d.png", ElementType[playerElement], 2, 1))
		AtlasIconLoader.Load(self.EleArrow2, string.format("Textures/Icon/Atlas/ElementArrow/unique_guaiwukezhi_%s%d_%d.png", ElementType[playerElement], 2, 2))
		self.EleArrow_anim:Play("UI_FightTargetInfoPanel_EleArrow_beikezhiloop")

	else
		UtilsUI.SetActive(self.EleArrow, false)
	end
end

function FightTargetInfoPanel:_InitTargetLife()
	local entity = Fight.Instance.entityManager:GetEntity(self.targetId)
	local curLife = entity.attrComponent:GetValue(AttrType.Life)
	local maxLife = entity.attrComponent:GetValue(AttrType.MaxLife)
	local maxlifeBar = 1 --entity.attrComponent.attrs[AttrType.LifeBar]
	self.targetBarMaxLife = maxLife / maxlifeBar
	local barCurLife = curLife % self.targetBarMaxLife
	if curLife ~= 0 and barCurLife >= 0 and barCurLife < 1 then
		barCurLife = self.targetBarMaxLife
	end

	self.TargetBgLife:SetActive(true)
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
	if self.TargetLifeWFill_img.fillAmount > percent then
		self.TargetInfo_anim:Play("UI_FightTargetInfoPanel_TargetInfo_yao", 1, 0)
	end

	if self.UI_xuetiaojianshao_BOSS.activeInHierarchy then
		UtilsUI.SetActive(self.UI_xuetiaojianshao_BOSS, false)
	end
	UnityUtils.SetAnchoredPosition(self.UI_xuetiaojianshao_BOSS_rect, self.hpBarWidth * percent, 0)
	UtilsUI.SetActive(self.UI_xuetiaojianshao_BOSS, true)
	if self.UI_xuetiaoglowchixu_BOSS.activeInHierarchy == false then
		LuaTimerManager.Instance:AddTimer(1,1, function()
			UtilsUI.SetActive(self.UI_xuetiaoglowchixu_BOSS, true)
		end)
	end
	-- self:PlayTargetLifeBarAnim(self.TargetLifeWFill_img.fillAmount, percent)
	self.TargetLifeWFill_img.fillAmount = percent
	
	-- UnityUtils.SetSizeDelata(self.LifeHud_rect, self.hpBarWidth - (self.hpBarWidth * (1 - percent)), 18)
	UnityUtils.SetLocalScale(self.LifeHud_rect, percent, 1, 1)
	self.logic:UpdateLifeBar(curLife, maxLife)

	local posX = ((percent / 0.5) - 1) * 250

	if percent <= 0 then
		self.mingshu_BOSS_rect.anchoredPosition = self["TargetP" .. self.recordLifeSection].transform.anchoredPosition
		UtilsUI.SetActive(self["TargetP" .. self.recordLifeSection], false)
		UtilsUI.SetActive(self.mingshu_BOSS, true)
		self.recordLifeSection = self.recordLifeSection - 1
	end
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
	-- UnityUtils.SetActive(self["22076"], state == FightEnum.ElementState.Ready)
	
	local percent = value / maxValue
	if state == FightEnum.ElementState.Accumulation then
		self.restrainElement = element
		if self.restrainElement then
			self:PlayStateAddAnim(self.TargetElementStateFill_img.fillAmount, percent)

			self.TargetElementStateFill_img.fillAmount = percent

			if not self["UI_kezhitiaochixuglow"].activeInHierarchy then
				LuaTimerManager.Instance:AddTimer(1,1, function()
					UtilsUI.SetActive(self["UI_kezhitiaochixuglow"], true)
				end)
			end
			UnityUtils.SetAnchoredPosition(self["UI_kezhitiaochixuglow_rect"], self.elementBarWidth * percent, 0)


			if percent == 1 then
				UnityUtils.SetActive(self["UI_kezhitiaochongman_BOSS"], true)
				UtilsUI.SetActive(self["UI_kezhitiaochixuglow"], false)
			end
		end
	elseif state == FightEnum.ElementState.Ready then
		self.TargetElementStateReadyCD1_img.fillAmount = percent
		self.TargetElementStateReadyCD2_img.fillAmount = percent
		UtilsUI.SetActive(self.UI_kezhitiaojianshao_BOSS, false)
	elseif state == FightEnum.ElementState.Cooling then
		self.TargetElementStateCoolingCD_img.fillAmount = percent
		UnityUtils.SetLocalScale(self["UI_kezhitiaodaojishi_rect"], 4 * percent, 1, 1)
	end
	UnityUtils.EndSample()
end

function FightTargetInfoPanel:PlayTargetLifeBarAnim(lastPercent, toPercent)
	if lastPercent < toPercent then
		return
	end
	local scale = -(toPercent - lastPercent) * self.targetLifeBarBaseScale
	local pos = -(self.hpBarWidth - self.hpBarWidth * lastPercent)

	UnityUtils.SetLocalScale(self.UI_xuetiaojianshao_BOSS_rect, scale, 1, 1)
	UnityUtils.SetAnchoredPosition(self.UI_xuetiaojianshao_BOSS_rect, pos, 0)

	-- scale = 1 / scale
	-- if scale > 1 then
	-- 	self.stateBarAnimator.speed = 1
	-- else
	-- 	self.stateBarAnimator.speed = scale
	-- end
	
	UtilsUI.SetActive(self.UI_xuetiaojianshao_BOSS, true)
end

function FightTargetInfoPanel:PlayStateAddAnim(lastPercent, toPercent)
	--self.stateBarAnimator
	if lastPercent > toPercent then
		return
	end
	local scale = (toPercent - lastPercent) * self.stateBarAddBaseScale
	local pos = self.elementBarWidth * lastPercent

	UnityUtils.SetLocalScale(self.UI_kezhitiaojianshao_BOSS_rect, scale, 1, 1)
	UnityUtils.SetAnchoredPosition(self.UI_kezhitiaojianshao_BOSS_rect, pos, 0)

	scale = 1 / scale
	if scale > 1 then
		self.stateBarAnimator.speed = 1
	else
		self.stateBarAnimator.speed = scale
	end
	
	UtilsUI.SetActive(self.UI_kezhitiaojianshao_BOSS, true)
end

function FightTargetInfoPanel:StateBarAddCallBack()
	UtilsUI.SetActive(self.UI_kezhitiaojianshao_BOSS, false)
end
function FightTargetInfoPanel:TargetLifeBarAddCallBack()
	UtilsUI.SetActive(self.UI_xuetiaojianshao_BOSS, false)
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
	-- buffer列表为空返回
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
			UnityUtils.SetLocalScale(buffItem.object.objectTransform, 0.87, 0.87, 0.87)
			UnityUtils.SetActive(buffItem.object.object, true)
			buffItem.object.objectTransform:SetAsLastSibling()

			self.buffOnShow[buffList[i].instanceId] = buffItem
		end
	end

	LayoutRebuilder.ForceRebuildLayoutImmediate(self.DebuffArea.transform)
	LayoutRebuilder.ForceRebuildLayoutImmediate(self.BuffArea.transform)
	LayoutRebuilder.ForceRebuildLayoutImmediate(self.BuffIconList.transform)
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
    --LayoutRebuilder.ForceRebuildLayoutImmediate(self.MatchCurScore.transform)
	if buffCount == 0 or not buffItem.buffConfig.isShowNum then
		-- UnityUtils.SetActive(buffItem.object.object, false)
		buffItem.object.object:GetComponent(Animator):Play("UI_CommonBuff_out")
		buffItem:Reset()
		table.insert(self.buffItemPool, buffItem)
		self.buffOnShow[buffItemIndex] = nil

		LayoutRebuilder.ForceRebuildLayoutImmediate(self.DebuffArea.transform)
		LayoutRebuilder.ForceRebuildLayoutImmediate(self.BuffArea.transform)
		LayoutRebuilder.ForceRebuildLayoutImmediate(self.BuffIconList.transform)
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

local DataMagic = Config.DataMagic.data_magic
local EntityCommonConfig = Config.EntityCommonConfig

function FightTargetInfoPanel:UpdateAssassinTip(instanceId, hitId, skillId, magicId, perfectMagicId)
	if self.targetId ~= hitId then
		return
	end
	if self["UI_cishaxeutiao_putong"].activeInHierarchy then
		return
	end
	
	local attack = BehaviorFunctions.GetEntity(instanceId)
	local hit = BehaviorFunctions.GetEntity(hitId)
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

	UtilsUI.SetActive(self["UI_cishaxeutiao_putong"], true)
	UnityUtils.SetLocalScale(self["22075_rect"], 4 * self.assassinPercent, 1.3, 1)
	UtilsUI.SetEffectSortingOrder(self["UI_cishaxeutiao_putong"], self.canvas.sortingOrder + 1)
end

function FightTargetInfoPanel:HideAssassinTip(instanceId, hitId)
	if self.targetId ~= hitId then
		return
	end
	UtilsUI.SetActive(self["UI_cishaxeutiao_putong"], false)
end

function FightTargetInfoPanel:HideTargetInfo()
	if self.TargetInfo then
		self.TargetInfo:SetActive(false)
	end
end