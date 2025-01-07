FightFormationPanel = BaseClass("FightFormationPanel", BasePanel)

local ItemNum = 3

local HeroData = Config.DataHeroMain.Find
local AttrType = EntityAttrsConfig.AttrType

local KeyEvent2FormationIndex = {
	[FightEnum.KeyEvent.Change1] = 1,
	[FightEnum.KeyEvent.Change2] = 2,
	[FightEnum.KeyEvent.Change3] = 3,
}

local ElementType = {
	[1] = "jin",
	[2] = "mu",
	[3] = "shui",
	[4] = "huo",
	[5] = "tu",
	[6] = "null",

}

function FightFormationPanel:__init(mainView)
    self:SetAsset("Prefabs/UI/Fight/FightFormationPanelV2.prefab")
    self.mainView = mainView

	self.entityList = {}
	self.formationList = {}
	self.squad = {}
	self.nodes = {}
end

function FightFormationPanel:__delete()
    EventMgr.Instance:RemoveListener(EventName.ActionInput, self:ToFunc("OnActionInput"))
	EventMgr.Instance:RemoveListener(EventName.PlayerAttrChange, self:ToFunc("UpdateEleIconActive"))
end

function FightFormationPanel:__BindEvent()
	EventMgr.Instance:AddListener(EventName.PlayerAttrChange, self:ToFunc("UpdateEleIconActive"))
	EventMgr.Instance:AddListener(EventName.ActionInput, self:ToFunc("OnActionInput"))
end

function FightFormationPanel:__BindListener()
	self:SetInputImagerChanger()

    
end

function FightFormationPanel:__Create()

end

function FightFormationPanel:__CacheObject()
    self:SetCacheMode(UIDefine.CacheMode.destroy)
end

function FightFormationPanel:__BaseShow()
	self:SetParent(self.mainView.PanelParent.transform)
end

function FightFormationPanel:__Show()
	self:UpdatePlayerInfo()
end

function FightFormationPanel:__ShowComplete()
	self.mainView:AddLoadDoneCount()
end

function FightFormationPanel:__Hide()

end

function FightFormationPanel:UpdatePlayerInfo()
	self.player = Fight.Instance.playerManager:GetPlayer()

	for i = 1, ItemNum do
		local entity = self.player:GetQTEEntityObject(i)
		self.entityList[i] = entity
		local roleItem = self.formationList[i]
		if not roleItem then
			roleItem = {}
			roleItem.gameObject = self["Role" .. i]
			UtilsUI.GetContainerObject(roleItem.gameObject, roleItem)
			self.formationList[i] = roleItem
			self.nodes["Role" .. i] = roleItem
		end
		if entity then
			local master_Id = mod.RoleCtrl:GetRealRoleId(entity.masterId)
			local roleInfo = HeroData[master_Id]
			if roleItem.curShowElem then
				UtilsUI.SetActive(roleItem[roleItem.curShowElem], false)
			end
			if roleItem.skillEffectObj then
				self:PushUITmpObject(roleItem.element, roleItem.skillEffectObj)
				roleItem.element = nil
				roleItem.skillEffectObj = nil
			end
			--加载元素
			roleItem.curShowElem = "IconArea" .. ElementType[roleInfo.element]
			roleItem.element = string.format("UI_fight_R_%s_1", ElementType[roleInfo.element])
			UtilsUI.SetActive(roleItem[roleItem.curShowElem], true)
			--加载头像
			SingleIconLoader.Load(roleItem.HeadIcon, HeroData[master_Id].rhead_icon)
			UtilsUI.SetHideCallBack(roleItem["FightFormationPanel_qiehuan_fan"], function()
				roleItem["FightFormationPanel_qiehuan_zhuan"]:SetActive(true)
				local entity = self.player:GetQTEEntityObject(i)
				SingleIconLoader.Load(roleItem.HeadIcon, HeroData[master_Id].rhead_icon)
			end)

			--加载技能图标
			local skillConfig = entity.skillSetComponent:GetConfig(FightEnum.KeyEvent.UltimateSkill)
			if skillConfig and skillConfig.ElementIconType and skillConfig.ElementIconType ~= ElementType[6] then
				SingleIconLoader.Load(roleItem.EleSkillIcon, AssetConfig.GetSkillIcon(skillConfig.SkillIcon))
				roleItem.skillEffectObj = self:PopUITmpObject(roleItem.element, roleItem.EleEffectNode.transform)
				UnityUtils.SetAnchoredPosition(roleItem.skillEffectObj.objectTransform, 0, 0)
				if roleItem.curShouSkillElem then
					UtilsUI.SetActive(roleItem[roleItem.curShouSkillElem], false)
				end
				roleItem.curShouSkillElem = "EleIconBg" .. skillConfig.ElementIconType
				UtilsUI.SetActive(roleItem[roleItem.curShouSkillElem], true)
	
				roleItem.EleSkillIcon_btn.onClick:RemoveAllListeners()
				roleItem.EleSkillIcon_btn.onClick:AddListener(function ()
					Fight.Instance.entityManager:CallBehaviorFun("QTEChangeRole", self.player.ctrlId, entity.instanceId)
				end)
			end

			UtilsUI.SetActive(roleItem.gameObject, true)
		else
			UtilsUI.SetActive(roleItem.gameObject, false)
		end
	end

	self:UpdateFormations()

	self:UpdateEleIconActive()
end

function FightFormationPanel:UpdateFormations()
	if not self.formationList or not next(self.formationList) or not self.mainView.playerObject then
		return
	end

	local formationInfos = mod.FormationCtrl:GetCurFormationInfo()

	local curRole = self.mainView.playerObject.entityId

	for i = 1, #formationInfos.roleList do
		local roleItem = self.formationList[i]
		local entity = self.entityList[i]
		if not entity then
			goto continue
		end
		--站场角色隐藏
		--LogInfo()
		if curRole == entity.entityId then
			UtilsUI.SetActive(roleItem.gameObject, false)

			self.curIndex = i
			self.formationList[self.curIndex]["FightFormationPanel_qiehuan_fan"]:SetActive(true)
		else
			UtilsUI.SetActive(roleItem.gameObject, true)
		end

		roleItem.Button_btn.onClick:RemoveAllListeners()
		roleItem.Button_btn.onClick:AddListener(function() self:OnClickRoleButton(i) end)

		::continue::
	end

	--print(formationInfos)
	self:UpdateFormationIndex()
end

function FightFormationPanel:Update()
	local formationInfos = mod.FormationCtrl:GetCurFormationInfo()
	for i = 1, #self.formationList do
		local haveRole = formationInfos.roleList[i] and formationInfos.roleList[i] ~= 0
		if haveRole then
			local entity = self.player:GetQTEEntityObject(i)
			if entity and next(entity) then
				self:UpdateHp(i, entity)
			end
		end
	end
	self:UpdateEleIconActive(FightEnum.PlayerAttr.Curqteres)
end

function FightFormationPanel:UpdatePlayer()
	--站场编队
	self:UpdatePlayerInfo()
end

local LowHpInterval = 0.4
local LowHpColor = Color(209/255, 79/255, 79/255)
local NormalHpColor = Color(1, 1, 1)
local GreyColor = 161 / 255

function FightFormationPanel:UpdateHp(i, entity)
	local hp, maxHp = entity.attrComponent:GetValue(AttrType.Life), entity.attrComponent:GetValue(AttrType.MaxLife)
	local percent = hp / maxHp
	local roleItem = self.formationList[i]
	roleItem.HpFill_img.fillAmount = 0.25 * percent

	if percent <= LowHpInterval then
		roleItem.HpFill_img.color = LowHpColor
	else
		roleItem.HpFill_img.color = NormalHpColor
	end

	UtilsUI.SetActive(roleItem.DeadIcon, percent <= 0)
end

function FightFormationPanel:OnClickRoleButton(index)
	--LogInfo("点击换人按钮 " .. index)
	--print(self.player:GetQTEEntityObject(index).masterId)
	self:CheckSwapHero(index)
end

function FightFormationPanel:CheckSwapHero(index)
	local formationInfos = mod.FormationCtrl:GetCurFormationInfo()
	if not index or not formationInfos.roleList[index] then
		return
	end

	local entity = self.player:GetQTEEntityObject(index)
	local isDup = mod.DuplicateCtrl:CheckIsDupAndType(FightEnum.SystemDuplicateType.NightMare)--只有梦魇副本内不能复活?
	if entity.stateComponent:IsState(FightEnum.EntityState.Death) and not isDup then
		local itemIds = ItemConfig.GetItemIds_ItemType(1034)
		local cb = function()
			self:SwapHero(index, entity)
		end 
		local args = { item_ids = itemIds, callBack = cb, selectedIndex = index }
		WindowManager.Instance:OpenWindow(UseMultiItemWindow, args)
		return
	end

	self:SwapHero(index, entity)

	-- if index and formationInfos.roleList[index] then
	-- 	local entity = self.player:GetQTEEntityObject(index)
	-- 	local curEntity = self.player:GetCtrlEntityObject()

	-- 	local isDup = mod.DuplicateCtrl:CheckIsDupAndType(FightEnum.SystemDuplicateType.NightMare)--只有梦魇副本内不能复活?
	-- 	-- 检测角色状态
	-- 	if not curEntity.attrComponent.deadTransport and self:ChangeRoleStateCheck(curEntity) and not entity.stateComponent:IsState(FightEnum.EntityState.Death) then
	-- 		self:SwapHero(index, entity)
	-- 	elseif entity.stateComponent:IsState(FightEnum.EntityState.Death) and not isDup then
	-- 		local itemIds = ItemConfig.GetItemIds_ItemType(1034)
	-- 		local cb = function()
	-- 			self:SwapHero(index, entity)
	-- 		end 
	-- 		local args = { item_ids = itemIds, callBack = cb, selectedIndex = index }
	-- 		WindowManager.Instance:OpenWindow(UseMultiItemWindow, args)
	-- 	end
	-- end
end

function FightFormationPanel:ChangeRoleStateCheck(entity)
	local stateComponent = entity.stateComponent
	return stateComponent:CanChangeRole()
end

function FightFormationPanel:SwapHero(index, roleEntity)
	local curUseInstance = self.player.ctrlId
	if curUseInstance == roleEntity.instanceId then
		return
	end

	local curEntity = self.player:GetCtrlEntityObject()
	if curEntity.attrComponent.deadTransport or not self:ChangeRoleStateCheck(curEntity) or roleEntity.stateComponent:IsState(FightEnum.EntityState.Death) then
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

	EventMgr.Instance:Fire(EventName.CurRoleChange, curUseInstance, roleEntity.instanceId)
	Fight.Instance.entityManager:CallBehaviorFun("ChangeRole", index, curUseInstance, roleEntity.instanceId)
end

function FightFormationPanel:UpdateFormationIndex()
	local oldSquad = self.squad
	self:UpdateSquadList()
	
	local isDiff = false;
	for i, v in ipairs(oldSquad) do
		if self.squad[i] and oldSquad[i][1] ~= self.squad[i][1] then
			isDiff = true
		end 
	end
	if isDiff == false then
		return
	end
	for i, v in ipairs(oldSquad) do
		if oldSquad[i][1] == self.squad[1][1] then
			oldSquad[i][1].transform:SetSiblingIndex(oldSquad[i][1].transform:GetSiblingIndex() + 1)
		elseif oldSquad[i][1] == self.squad[#self.squad][1] then
			oldSquad[i][1].transform:SetSiblingIndex(oldSquad[i][1].transform:GetSiblingIndex() - 1)
		end
	end

	self:UpdateSquadList()
end

function FightFormationPanel:UpdateSquadList()
	self.squad = {}
	local count = self.RoleList.transform.childCount - 1
	for i = 0, count do
		local go = self.RoleList.transform:GetChild(i).gameObject
		if go.activeSelf == true then
			table.insert(self.squad, {go, tonumber(string.sub(go.name,5,5))})
		end
	end
	self:UpdateInputImagerChanger()
end

function FightFormationPanel:SetInputImagerChanger()
	local count = self.InputImageGroup.transform.childCount
	for i = 1, count do
		local go = self["RoleTips" .. i]
		UtilsUI.SetInputImageChanger(go, self:ToFunc("UpdateInputImagerChanger"))
	end
end

function FightFormationPanel:UpdateInputImagerChanger()
	local count = self.InputImageGroup.transform.childCount
	if not UtilsUI.CheckPCPlatform() then
		for i = 1, count do
			UtilsUI.SetActive(self["RoleTips" .. i], false)
		end
        return
    end
	local roleCount = #self.squad
	for i = 1, count do
		if roleCount >= i then
			UtilsUI.SetActive(self["RoleTips" .. i], true)
		else
			UtilsUI.SetActive(self["RoleTips" .. i], false)
		end
	end
end

function FightFormationPanel:UpdateEleIconActive(attrType)
	if attrType ~= FightEnum.PlayerAttr.Curqteres then
		return
	end
	for i = 1, ItemNum do
		self:UpdateEleIconActiveByIndex(i)
	end
end

function FightFormationPanel:UpdateEleIconActiveByIndex(index)
	local entity = self.player:GetQTEEntityObject(index)
	if not entity then
		return
	end

	-- 人不能是死的 要不在Cd 且有资源
	if entity.skillSetComponent:CheckUseSkill(FightEnum.KeyEvent.UltimateSkill) == false 
	or entity.stateComponent:IsState(FightEnum.EntityState.Death) 
	or entity.skillSetComponent:CheckSkillResources(FightEnum.KeyEvent.UltimateSkill) == false then
		UtilsUI.SetActive(self.formationList[index].EleIcon, false)
	else
		UtilsUI.SetActive(self.formationList[index].EleIcon, true)
	end
end

function FightFormationPanel:OnActionInput(key, value)
	if key ~= FightEnum.KeyEvent.Change1 and key ~= FightEnum.KeyEvent.Change2 then
		return
	end

	if #self.squad < KeyEvent2FormationIndex[key] then
		return
	end

	local index = self.squad[KeyEvent2FormationIndex[key]][2]
	self:CheckSwapHero(index)
end

function FightFormationPanel:HideSelf()
	UtilsUI.SetActive(self.CloseNode, true)
end