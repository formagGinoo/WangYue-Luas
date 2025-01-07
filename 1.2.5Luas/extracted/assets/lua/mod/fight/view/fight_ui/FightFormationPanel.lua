FightFormationPanel = BaseClass("FightFormationPanel", BasePanel)

local HeroData =  Config.DataHeroMain.Find
local AttrType = EntityAttrsConfig.AttrType

-- TODO 临时处理
local KeyEvent2FormationIndex = {
	[FightEnum.KeyEvent.Change1] = 1,
	[FightEnum.KeyEvent.Change2] = 2,
	[FightEnum.KeyEvent.Change3] = 3,
}

local Id2SkillEffect = {
	[1001] = "21014",
	[1002] = "22001",
	[1003] = "21014",
}

local ItemNum = 3

function FightFormationPanel:__init(mainView)
	self:SetAsset("Prefabs/UI/Fight/FightFormationPanel.prefab")
	self.mainView = mainView
	self.buffInfoMap = {}

	self.changeIconIndex = nil
	self.changeIconSequence = nil
	
	self.indexMap = {1, 2, 3}
end

function FightFormationPanel:__BindListener()
end

function FightFormationPanel:__Create()
	for i = 1, ItemNum do
		local infoMap = {}
		for j = 1, 4 do
			local buffNode = {}
			buffNode.object = self["Role"..i].transform:Find("BuffBoard_/BuffNode"..j)
			buffNode.iconObject = buffNode.object:Find("Icon").gameObject
			buffNode.fillIcon = buffNode.object:Find("Fill"):GetComponent(Image)
			buffNode.levelCount = UtilsUI.GetText(buffNode.object:Find("Level").gameObject)
			buffNode.buffId = 0
			buffNode.duration = 0
			table.insert(infoMap, buffNode)
		end
		table.insert(self.buffInfoMap, infoMap)
	end
end
function FightFormationPanel:__BaseShow()
	self:SetParent(self.mainView.PanelParent.transform)
end

function FightFormationPanel:__Show()
	self:InitFormations()
end

function FightFormationPanel:__ShowComplete()
	self.mainView:AddLoadDoneCount()
end

function FightFormationPanel:__delete()
	if self.changeIconSequence then
		self.changeIconSequence:Kill()
		self.changeIconSequence = nil
		UnityUtils.SetLocalScale(self.nodes["Role"..self.changeIconIndex].Icon.transform, 1, 1, 1)
		self.changeIconIndex = nil
	end
end

function FightFormationPanel:__Hide()
	if self.changeIconSequence then
		self.changeIconSequence:Kill()
		self.changeIconSequence = nil
		UnityUtils.SetLocalScale(self.nodes["Role"..self.changeIconIndex].Icon.transform, 1, 1, 1)
		self.changeIconIndex = nil
	end
end

function FightFormationPanel:Update()
	local formationInfos = mod.FormationCtrl:GetCurFormationInfo()
	for i = 1, #self.formationList do
		local haveRole = formationInfos.roleList[i] and formationInfos.roleList[i] ~= 0
		if haveRole then
			local entity = self.player:GetQTEEntityObject(i)
			if entity and next(entity) then
				self:UpdateFormationSkill(i, entity)
				self:UpdateIconAndHp(i, entity)
				self:UpdateBuffState(i, entity)
				--self:UpdateFormationState(i, entity)
			end
		end
	end

	-- 给快捷键用的 后面更改成映射到按键上
	local opera = 0
	if Fight.Instance.operationManager:CheckKeyDown(FightEnum.KeyEvent.Change1) then
		opera = FightEnum.KeyEvent.Change1
	elseif Fight.Instance.operationManager:CheckKeyDown(FightEnum.KeyEvent.Change2) then
		opera = FightEnum.KeyEvent.Change2
	elseif Fight.Instance.operationManager:CheckKeyDown(FightEnum.KeyEvent.Change3) then
		opera = FightEnum.KeyEvent.Change3
	end
	local index = self.indexMap[KeyEvent2FormationIndex[opera]]
	if index and formationInfos.roleList[index] then
		local entity = self.player:GetQTEEntityObject(index)
		local curEntity = self.player:GetCtrlEntityObject()
		if not curEntity.attrComponent.deadTransport and self:ChangeRoleStateCheck(curEntity) and not entity.stateComponent:IsState(FightEnum.EntityState.Death) then
			self:OnClick_FormationClick(index, entity.instanceId)
		end
	end
end

function FightFormationPanel:UpdatePlayer(ignoreFormation)
	if not ignoreFormation then
		self:SetFormationInfo()
	end
end

function FightFormationPanel:InitFormations()
	self.player = Fight.Instance.playerManager:GetPlayer()
	self.formationList = {}
	self.nodes = {}
	self.curIndex = nil

	for i = 1, ItemNum do
		local prefabInfo = {}
		prefabInfo.transform = self["Role"..i].transform
		UtilsUI.GetContainerObject(prefabInfo.transform, prefabInfo)
		table.insert(self.formationList, prefabInfo)
		self.nodes["Role"..i] = prefabInfo
	end

	self:SetFormationInfo()
end

function FightFormationPanel:UpdateIndexMap(index, roleNum)
	if index > ItemNum then
		return 
	end
	
	local move = false
	for i = 1, roleNum do
		local idx = self.indexMap[i]
		if idx == index then
			move = true
		end
		
		if move and self.indexMap[i + 1] then
			self.indexMap[i] = self.indexMap[i + 1]
		end
	end
	self.indexMap[roleNum] = index
end

function FightFormationPanel:SetFormationInfo()
	if not self.formationList or not next(self.formationList) or not self.mainView.playerObject then
		return
	end

	local curRole = self.mainView.playerObject.entityId
	local formationInfos = mod.FormationCtrl:GetCurFormationInfo()
	local roleNum = #formationInfos.roleList
	for i = 1, #self.formationList do
		local haveRole = formationInfos.roleList[i] and formationInfos.roleList[i] ~= 0
		self.formationList[i].transform:SetActive(haveRole)
		if haveRole then
			local entity = self.player:GetQTEEntityObject(i)
			if not entity then
				return
			end
			
			if curRole == entity.entityId then
				self.formationList[i].transform:SetActive(false)
				self.formationList[i].transform:SetSiblingIndex(roleNum - 1)
				--if not self.curIndex then
					--self.changeIconIndex = i
					--UnityUtils.SetLocalScale(self.nodes["Role"..i].Icon.transform, 0.9, 0.9, 0.9)
				--end
				self.curIndex = i
			end
			local path = HeroData[entity.masterId].head_icon
			SingleIconLoader.Load(self.formationList[i]["HeadIcon"], path)

			local hp, maxHp = entity.attrComponent.attrs[AttrType.Life], entity.attrComponent.attrs[AttrType.MaxLife]
			self.formationList[i]["HpFill_img"].fillAmount = self:GetPercent(hp, maxHp)
			
			self.formationList[i].entityElement = entity.elementStateComponent.config.ElementType or FightEnum.ElementType.Phy
			for j = 2, 6 do
				self.formationList[i]["CoreProgress"..j.."_canvas"].alpha = j == self.formationList[i].entityElement and 1 or 0
			end

			--local dragBehaviour = self.formationList[i].Button:GetComponent(UIDragBehaviour)
			--if not dragBehaviour then
				--dragBehaviour = self.formationList[i].Button:AddComponent(UIDragBehaviour)
				--dragBehaviour.IngorePass = true
			--end

			local onClick = function (castSkill)
				local curEntity = self.player:GetCtrlEntityObject()
				local cb = function ()
					self:OnClick_FormationClick(i, entity.instanceId, castSkill)
				end
				if not curEntity.attrComponent.deadTransport and self:ChangeRoleStateCheck(curEntity) and not entity.stateComponent:IsState(FightEnum.EntityState.Death) then
					cb()
				elseif entity.stateComponent:IsState(FightEnum.EntityState.Death) then
					local itemIds = ItemConfig.GetItemIds_ItemType(1034)
					local args = { item_ids = itemIds, callBack = cb, selectedIndex = i }
					if not self.useMultiItemPanel then
						self.useMultiItemPanel = PanelManager.Instance:OpenPanel(UseMultiItemPanel, args)
					else
						self.useMultiItemPanel:Show(args)
					end
				end
			end
			
			self.formationList[i].Button_btn.onClick:RemoveAllListeners()
			self.formationList[i].Button_btn.onClick:AddListener(function() onClick(false) end)
			--dragBehaviour.onPointerClick = function () onClick(false) end

			--local onPointerUp = function()
				--if i == self.curIndex then
					--return
				--end
				--self.nodes["Role"..i].PressBg:SetActive(false)
			--end
			--dragBehaviour.onPointerUp = onPointerUp

			--local onPointerDown = function()
				--if i == self.curIndex then
					--return
				--end
				--self.nodes["Role"..i].PressBg:SetActive(true)
			--end
			--dragBehaviour.onPointerDown = onPointerDown

			-- TODO 测试逻辑 之后改成根据角色属性来加载 单独分一个方法
			--if entity.entityId == 1001 then
				--SingleIconLoader.Load(self.formationList[i].UltimateSkillIconBg, "Textures/Icon/Single/ElementIcon/image_mask_red.png")
			--elseif entity.entityId == 1002 then
				--SingleIconLoader.Load(self.formationList[i].UltimateSkillIconBg, "Textures/Icon/Single/ElementIcon/image_mask_purple.png")
			--end

			--self.formationList[i].UltimateSkillIconBg_btn.onClick:RemoveAllListeners()
			--self.formationList[i].UltimateSkillIconBg_btn.onClick:AddListener(function() onClick(true) end)
		--else
			--self.formationList[i].UltimateSkillIconBg_btn.onClick:RemoveAllListeners()
		end

		--for i = 1, #self.formationList do
			--local anim = "Role1_2"
			--if i == self.curIndex then
				--anim = "Role1_1"
			--end
			--self["Role"..i.."_anim"]:Play(anim, -1, 1)
		--end
	end
	
	self:UpdateIndexMap(self.curIndex, roleNum)
end

function FightFormationPanel:OnClick_FormationClick(index, instanceId, castSkill)
	local curUseInstance = self.player.ctrlId
	if curUseInstance == instanceId then
		return
	end

	local entityInfo = self.player:GetQTEEntityInfo(index)
	local frame = entityInfo.SwitchTime - Fight.Instance.fightFrame
	if frame > 0 then
		local cdTime = frame * FightUtil.deltaTimeSecond
		if cdTime < entityInfo.SwitchCDTime then
			return
		end
	end

	EventMgr.Instance:Fire(EventName.CurRoleChange, curUseInstance, instanceId)
	Fight.Instance.entityManager:CallBehaviorFun("ChangeRole", index, curUseInstance, instanceId)
	if castSkill then
		Fight.Instance.clientFight.inputManager:KeyDown(FightEnum.KeyEvent.UltimateSkill)
	end

	--self["Role"..index.."_anim"]:Play("Role1_1")
	--self["Role"..self.curIndex.."_anim"]:Play("Role1_2")
	--self:ChangeIconAnim(self.curIndex)
	--self.mainView:StopEffect("21011", "Role"..index)
	--self.mainView:PlayEffect("21011", "Role"..index, {-90, 0, 0}) --动效制作后，锚点改了，偏一下
end

function FightFormationPanel:ChangeRoleStateCheck(entity)
	local stateComponent = entity.stateComponent
	return stateComponent:CanChangeRole()
end

function FightFormationPanel:ChangeIconAnim(curIndex)
	if self.changeIconSequence then
		self.changeIconSequence:Kill()
		self.changeIconSequence = nil
	end

	self.changeIconSequence = DOTween.Sequence()
	local tween1 = self.nodes["Role"..self.changeIconIndex].Icon.transform:DOScale(1, 0.2)
	local tween2 = self.nodes["Role"..curIndex].Icon.transform:DOScale(0.9, 0.2)
	self.changeIconSequence:Append(tween1)
	self.changeIconSequence:Join(tween2)
	self.changeIconIndex = curIndex
end

function FightFormationPanel:GetPercent(v, mv)
	return 0.33 * (v / mv)
end

function FightFormationPanel:UpdateFormationSkill(index, entity)
	local curRole = Fight.Instance.playerManager:GetPlayer():GetCtrlEntityObject().entityId
	local config = entity.skillSetComponent:GetConfig(FightEnum.KeyEvent.UltimateSkill)
	local curValue, useValue = 0, 0
	if config then
		curValue, useValue = entity.skillSetComponent:GetSetButton(FightEnum.KeyEvent.UltimateSkill):GetCostValue()
	end

	useValue = curValue and useValue or 1
	useValue = math.max(useValue, 1)
	curValue = curValue or 0
	local hasUltimateSkill = useValue > 0 and curValue >= useValue
	local element = self.formationList[index].entityElement
	if element ~= FightEnum.ElementType.Phy then
		--TODO：策划说，现在先把进度条拉满
		self.formationList[index]["CoreFill"..element.."_img"].fillAmount = self:GetPercent(1, 1) --self:GetPercent(curValue, maxValue)
	end

	--self.formationList[index].SkillIcon:SetActive(hasUltimateSkill and curRole ~= entity.entityId)
	--self.formationList[index].UltimateSkillIcon:SetActive(hasUltimateSkill)
	--self.formationList[index].UltimateSkillIconBg:SetActive(hasUltimateSkill)
	
	--if hasUltimateSkill and curRole ~= entity.entityId then
		--self.mainView:PlayEffect(Id2SkillEffect[entity.entityId], "SkillIcon", nil, nil, nil, "Role"..index, 0.56)
	--else
		--self.mainView:StopEffect(Id2SkillEffect[entity.entityId], "SkillIcon", "Role"..index)
	--end
end

local LowHpInterval = 0.4
local LowHpColor = Color(246/255, 170/255, 165/255)
local NormalHpColor = Color(1, 1, 1)
local GreyColor = 161 / 255
function FightFormationPanel:UpdateIconAndHp(index, entity)
	if not self.mainView.playerObject then
		return
	end

	local isCurUse = self.mainView.playerObject.entityId == entity.entityId
	local hp, maxHp = entity.attrComponent.attrs[AttrType.Life], entity.attrComponent.attrs[AttrType.MaxLife]
	self.formationList[index]["HpFill_img"].fillAmount = self:GetPercent(hp, maxHp)

	--local color = hp / maxHp < LowHpInterval and LowHpColor or NormalHpColor
	--self.formationList[index]["HpFill_img"].color = color

	local entityInfo = self.player:GetQTEEntityInfo(index)
	local showCDImg = false
	local frame = entityInfo.SwitchTime - Fight.Instance.fightFrame
	local iconColor = hp <= 0 and GreyColor or 1
	if frame > 0 then
		local cdTime = frame * FightUtil.deltaTimeSecond
		if cdTime < entityInfo.SwitchCDTime then
			showCDImg = not isCurUse
			--alpha = isCurUse and 1 or 0.5
			--self.formationList[index]["ChangeCD_txt"].text = string.format("%.1f", cdTime)
			self.formationList[index]["ChangeCDMask_img"].fillAmount = (cdTime / entityInfo.SwitchCDTime)
		end
	--elseif not entity.stateComponent:IsState(FightEnum.EntityState.Death) and not isCurUse then
		--alpha = self:ChangeRoleStateCheck(self.mainView.playerObject) and 1 or 0.5
	end

	--self.formationList[index]["ChangeCD"]:SetActive(showCDImg)
	self.formationList[index]["ChangeCDMask"]:SetActive(showCDImg)
	CustomUnityUtils.SetImageColor(self.formationList[index]["HeadIcon_img"],iconColor,iconColor,iconColor,1)
	--CustomUnityUtils.SetImageColor(self.formationList[index]["HpFill_img"],1,1,1,alpha)
	--CustomUnityUtils.SetImageColor(self.formationList[index]["CoreFill_img"],1,1,1,alpha)
	--if hp <= 0 or isCurUse then
		--self.formationList[index].UltimateSkillIcon:SetActive(false)
		--self.formationList[index].UltimateSkillIconBg:SetActive(false)
		--self.mainView:StopEffect(Id2SkillEffect[entity.entityId], "SkillIcon", "Role"..index)
	--end
end

function FightFormationPanel:UpdateFormationState(index, entity)
	if not self.mainView.playerObject then
		return
	end

	local curRole = self.mainView.playerObject.entityId
	self.formationList[index].SelectedArrow:SetActive(curRole == entity.entityId)
	self.formationList[index].SelectedBg:SetActive(curRole == entity.entityId)
	self.formationList[index].FrontName:SetActive(curRole == entity.entityId)
	self.formationList[index].BackName:SetActive(curRole ~= entity.entityId)
	self.formationList[index].HpProgress:SetActive(curRole ~= entity.entityId)

end
function FightFormationPanel:UpdateBuffState(index, entity)
	-- todo buffItem
	do return end
	local buffMap, maxPriority, count = entity.buffComponent:GetVisibleBuff()
	local showCount = 0
	for i = maxPriority, 0, -1 do
		if showCount >= 4 then break end
		if buffMap[i] then
			for j = 1, 	#buffMap[i] do
				if showCount >= 4 then break end
				showCount = showCount + 1
				self:UpdateBuffIcon(buffMap[i][j], showCount, index)
			end
		end
	end
	showCount = showCount + 1
	if showCount <= 4 then
		for i = showCount, 4 do
			self:UpdateBuffIcon(nil, i, index)
		end
	end
end

function FightFormationPanel:UpdateBuffIcon(buff, buffIndex, roleIndex)
	local buffObjectInfo = self.buffInfoMap[roleIndex][buffIndex]
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