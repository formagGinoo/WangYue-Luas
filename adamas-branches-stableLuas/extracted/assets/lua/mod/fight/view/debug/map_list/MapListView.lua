---@class MapListView
MapListView = BaseClass("MapListView",BaseView)
MapListView.NotClear = true
local DataHero = Config.DataHeroMain.Find

function MapListView:__init(model)
	self.model = model
	self:SetAsset(AssetConfig.debug_map_list)
end

function MapListView:__delete()
	if self.VLayout then
		self.VLayout:DeleteMe()
		self.VLayout = nil
	end
end

function MapListView:__CacheObject()
	self.cloneV = self.transform:Find("cloneV").gameObject
	self.VListCon = self.transform:Find("MaskScrollV/List")
	self.VScrollRect = self:Find("MaskScrollV")
	self.textmapInput = self:Find("FightData/InputMapId", TMP_InputField)
	self.textmapInput.text = PlayerPrefs.GetString("MapId")
	self.roleDataUI = {}
	for i = 1, 3 do
		self.roleDataUI[i] = {}
		self.roleDataUI[i].tog = self:Find(string.format("FightData/Entity%d/Toggle", i),Toggle)
		self.roleDataUI[i].tog.isOn = PlayerPrefs.GetInt("SelectEntityId"..tostring(i)) == 1
		self.roleDataUI[i].input = self:Find(string.format("FightData/Entity%d/InputField", i), TMP_InputField)
		self.roleDataUI[i].input.text = PlayerPrefs.GetString("EntityId"..tostring(i))

		self.roleDataUI[i].input2 = self:Find(string.format("FightData/Entity%d/InputField2", i), TMP_InputField)
		self.roleDataUI[i].input2.text = PlayerPrefs.GetString("PartnerId"..tostring(i))

		self.roleDataUI[i].input3 = self:Find(string.format("FightData/Entity%d/InputField3", i), TMP_InputField)
		self.roleDataUI[i].input3.text = PlayerPrefs.GetString("RoleStar"..tostring(i))
	end

	self.abilityInputField = self:Find("FightData/AbilityInputField", TMP_InputField)
	self.abilityInputField.text = PlayerPrefs.GetString("DebugAbilityId")
end

function MapListView:__BindListener()
	local enterFight = self:Find("FightData/EnterFight",Button)
	enterFight.onClick:AddListener(function() self:EnterFight() end)
end

function MapListView:__Create()
	self.VLayout = LuaBoxLayout.New(self.VListCon, {axis = BoxLayoutAxis.Y, cspacing = 0, scrollRect = self.VScrollRect, Left = 8, border = 5})

	local canvas = self:Find(nil,Canvas)
    if canvas ~= nil then
        canvas.pixelPerfect = false
        canvas.overrideSorting = true
    end
end

function MapListView:__Show()
	UnityUtils.SetLocalScale(self.gameObject.transform, 1.5, 1.5, 1.5)
	UnityUtils.SetLocalPosition(self.gameObject.transform, 0, 150.060059, 0)

	self:OpenMapList()
end

function MapListView:OpenMapList()
	for k,v in pairs(Config.DataDuplicate.data_duplicate) do
		local item = GameObject.Instantiate(self.cloneV)
		local trans = item.transform
		local mapConfig = Config.DataMap.data_scene[v.map_id]
		if not mapConfig then
			goto continue
		end
		local prefab = string.gsub(mapConfig.scene_prefab, ".*/", "")
		prefab = string.gsub(prefab, ".prefab", "")
		UtilsUI.GetText(trans:Find("Text")).text = prefab.."("..tostring(k)..")"
		local btn = trans:GetComponent(Button)
		btn.onClick:AddListener(function() self:MapClick(k) end)
		self.VLayout:AddCell(item)
		::continue::
	end
end

function MapListView:MapClick(id)
	self.textmapInput.text = tostring(id)
end

function MapListView:EnterFight()
	local duplicateId = tonumber(self.textmapInput.text)
	if not duplicateId then
		LogError("错误的地图ID:"..self.textmapInput.text)
		return
	end
	
	local hasData = false
	local fightEntites = {}
	local t = {}
	local partners = {}
	local roleList = {}
	for i = 1, 3 do
		if self.roleDataUI[i].tog.isOn then
			local id = tonumber(self.roleDataUI[i].input.text)
			local partnerId = tonumber(self.roleDataUI[i].input2.text)
			local star = tonumber(self.roleDataUI[i].input3.text)
			if star then
				star = MathX.Clamp(star, 0, 6)
			else
				star = 6
			end
			local roleId = id
			if id then
				hasData = true
				for k, v in pairs(DataHero) do
					if v.entity_id == id then
						id = v.id
					end

					if v.id == roleId then
						table.insert(t, v.entity_id)
					end
				end
				table.insert(fightEntites, id)
				table.insert(partners, {id,{partner_id = partnerId, star = star}})
				mod.RoleCtrl:SetDebugData(id,{partner_id = partnerId, star = star})

				PlayerPrefs.SetString("EntityId"..tostring(i), id)
				PlayerPrefs.SetString("PartnerId"..tostring(i), partnerId)
				PlayerPrefs.SetString("RoleStar"..tostring(i), star)
				table.insert(roleList, roleId)
			else
				table.insert(roleList, 0)
			end
		else
			table.insert(roleList, 0)
		end
		PlayerPrefs.SetInt("SelectEntityId"..tostring(i), self.roleDataUI[i].tog.isOn and 1 or 0)
	end
	local debugAbilityIdStr = self.abilityInputField.text
	PlayerPrefs.SetString("DebugAbilityId", debugAbilityIdStr)
	local abilityIdStrList = StringHelper.Split(debugAbilityIdStr, ',')
	local abilityidList = {}
	for i, v in ipairs(abilityIdStrList) do
		local abilityId = tonumber(v)
		if abilityId then
			abilityidList[abilityId] = true
		end
	end
	mod.AbilityWheelCtrl:SetDebug(abilityidList)
	mod.FormationCtrl:SetDebugFormation(roleList)

	local fightData = nil
	local heroList = {}
	local enterPos = nil
	if Fight.Instance then
		local curEntity = Fight.Instance.playerManager:GetPlayer():GetCtrlEntityObject()
		enterPos = curEntity.transformComponent.position
		Fight.Instance.levelManager:RemoveAllLevel()
		local duplicateConfig = Config.DataDuplicate.data_duplicate[duplicateId]
		local fd = FightData.New()
		fightData = fd:BuildFightData(fightEntites, duplicateConfig.map_id)

		Fight.Instance:Clear()
		--Facade.ClearModuleData()
		
		for _, v in pairs(partners) do
			mod.RoleCtrl:SetDebugData(v[1], v[2])
		end
		
		if not GmHotUpdateManager.Instance then
			GmHotUpdateManager.New()
		end
		local cache = DebugClientInvoke.Cache
		
		GmHotUpdateManager.Instance:HotUpdate()

		DebugClientInvoke.SetCache(cache)
		DebugPlanInvoke.SetCache(cache)
		DebugTestInvoke.SetCache(cache)
	else
		WindowManager.Instance:CloseAllWindow(true)
		PanelManager.Instance:CloseAllPanel(true)
		WindowManager.Instance:OpenWindow(LoginWindow)
	end

	-- Facade.ClearModuleData()
	
	if not hasData then
		Log("角色信息为空")
		MsgBoxManager.Instance:ShowTips(TI18N("角色信息为空"))
		return
	end
	
	PlayerPrefs.SetString("MapId",self.textmapInput.text)

	local dataTb = {}
	for i = 1, 3 do
		if self.roleDataUI[i].tog.isOn then
			local entityId = tonumber(self.roleDataUI[i].input.text)
			local star = tonumber(self.roleDataUI[i].input3.text)
			if star then
				star = MathX.Clamp(star, 0, 6)
			end
			local roleId = entityId
			if roleId then
				hasData = true
				for k, v in pairs(DataHero) do
					if v.entity_id == roleId then
						roleId = v.id
					end
				end

				table.insert(dataTb, {roleId = roleId, star = star})
			end
		end
	end

	self.model:CloseMainUI()

	if fightData then
		local duplicateConfig = Config.DataDuplicate.data_duplicate[duplicateId]
		local duplicateLevelId = duplicateConfig.level_id
		mod.WorldMapCtrl:SetDuplicateInfo(duplicateId, duplicateLevelId)
		
		Fight.New()
		Fight.Instance:SetDebugFormation(fightEntites)
		Fight.Instance:EnterFight(fightData, enterPos)

		--Fight.Instance.levelManager:CreateLevel(duplicateLevelId)
	else
		mod.WorldMapCtrl:EnterDebugDuplicate(duplicateId, fightEntites)
	end
end