
FightResuorcesLoadHelp = BaseClass("FightResuorcesLoadHelp")

local _insert = table.insert
local sceneABs = {}
local ComponentType = FightEnum.ComponentType  
local ComponentConfigName = FightEnum.ComponentConfigName
local DataDuplicateLevel = Config.DataDuplicate.data_duplicate_level
local SkillEventType = FightEnum.SkillEventType

FightResuorcesLoadHelp.EntityCache = {}

function FightResuorcesLoadHelp:__init(addResCB)
	self.entites = {}
	self.magics = {}
	self.buffs = {}
	self.entiteFileLoad = {}
	self.magicFileLoad = {}
	self.resList = {}
	self.resMap = {}
	self.addResCB = addResCB
end

function FightResuorcesLoadHelp:AddCellCallback(cellCallback)
	for k, v in pairs(self.resList) do
		v.callback = cellCallback
	end
end

function FightResuorcesLoadHelp:AddRes(resInfo)
	if not resInfo.path or resInfo.path == "" or self.resMap[resInfo.path] then
		return
	end

	resInfo.callback = self.addResCB
	_insert(self.resList, resInfo)
	self.resMap[resInfo.path] = true
end

FightResuorcesLoadHelp.CommonEntityFiles =
{
	["1000"] = {},
	["2000"] = {},
	["2002"] = {},
	["6000"] = {},
	["9000"] = {},
	["4000"] = {},
	["60000"] = {}
}

function FightResuorcesLoadHelp:PreloadEntity(entityId, fileLoad, root)
	local monsterCfg = Config.DataMonster.Find[entityId]
	if monsterCfg then
		entityId = monsterCfg.entity_id
	end
	local fileName = Config.EntityIdConfig[entityId]
	if not fileName then
		LogError("找不到实体:"..entityId .. "，请更新EntityIdConfig文件")
	end
	local fileResConfig = Config["EntityRes"..fileName]
	if not fileResConfig then
		LogError("EntityRes fileName Missing "..fileName)
		return
	end
	local entityResInfo
	local commonFileInfo = FightResuorcesLoadHelp.CommonEntityFiles[fileName]
	if commonFileInfo then
		entityResInfo = fileResConfig[tonumber(fileName)]
	else
		entityResInfo = fileResConfig[entityId]
	end

	if not entityResInfo then
		LogError("PreloadEntity fileResNil "..entityId)
	end

	for k, resInfo in pairs(entityResInfo) do
		self:AddRes(resInfo)
	end
end

function FightResuorcesLoadHelp:PreloadBehavior(behaviorName, entityConfigId, kind)
	local class = "Behavior" .. behaviorName
	local behavior = _G[class]
	if behavior then
		if  behavior.GetGenerates then
			local generates = behavior.GetGenerates()
			if generates then
				for i = 1, #generates do
					self:PreloadEntity(generates[i])
				end
			end
		end

		if behavior.GetMagics then
			local magics = behavior.GetMagics()
			if magics then
				for i = 1, #magics do
					self:PreloadMagicAndBuffs(magics[i], entityConfigId, kind)
				end
			end
		end

		if behavior.GetStorys then
			local storys = behavior.GetStorys()
			if storys then
				for i = 1, #storys do
					self:PreloadStorys(storys[i])
				end
			end
		end

		if behavior.GetOtherAsset then
			local otherAsset = behavior.GetOtherAsset()
			for i = 1, #otherAsset, 1 do
				self:AddRes({path = otherAsset[i], type = AssetType.Prefab})
			end
		end

	end
end

function FightResuorcesLoadHelp:PreloadMagicAndBuffs(id, entityConfigId, kind)
	local magicConfig = MagicConfig.GetMagic(id, entityConfigId, kind)
	if magicConfig and not self.magics[id] then
		self.magics[id] = id
		if FightEnum.MagicFuncName[magicConfig.Type] == "CreateEntity" then
			local EntityId = magicConfig.Param.EntityId
			if not EntityId then
				LogError("magicConfig.Param.EntityId id null "..magicConfig.Param.EntityId)
			else
				self:PreloadEntity(EntityId)
			end
		elseif FightEnum.MagicFuncName[magicConfig.Type] == "AddBuff" then
			self:PreloadMagicAndBuffs(magicConfig.Param.BuffId, entityConfigId, kind)
		elseif FightEnum.MagicFuncName[magicConfig.Type] == "ScreenEffect" then
			self:AddRes({path = magicConfig.Param.Effect, type = AssetType.Prefab})
		elseif FightEnum.MagicFuncName[magicConfig.Type] == "AddBehavior" then
			self:PreloadBehavior(magicConfig.Param.behaviorName, entityConfigId, kind)
		elseif FightEnum.MagicFuncName[magicConfig.Type] == "Preform" then
			self:AddRes({path = magicConfig.Param.TimelinePath, type = AssetType.Prefab})
		elseif FightEnum.MagicFuncName[magicConfig.Type] == "CameraTrack" then
			self:AddRes({path = magicConfig.Param.CameraTrackPath, type = AssetType.Prefab})
		elseif FightEnum.MagicFuncName[magicConfig.Type] == "WeaponEffect" then
			self:AddRes({path = magicConfig.Param.effectPath, type = AssetType.Prefab})
		end
	elseif self.magics[id] then
		return
	end

	local buffConfig = MagicConfig.GetBuff(id, entityConfigId, kind)
	if buffConfig and not self.buffs[id] then
		self.buffs[id] = id
		if buffConfig.MagicIds then
			for i = 1, #buffConfig.MagicIds do
				self:PreloadMagicAndBuffs(buffConfig.MagicIds[i], entityConfigId, kind)
			end
		end

		if buffConfig.EffectInfos then
			for i = 1, #buffConfig.EffectInfos do
				self:AddRes({path = buffConfig.EffectInfos[i].EffectPath, type = AssetType.Prefab})
			end
		end
	elseif self.buffs[id] then
		return
	end
end

function FightResuorcesLoadHelp:PreloadStorys(dialogId)
	local storyPath
	for k, v in pairs(StoryConfig.GetRelevanceId(dialogId)) do
		storyPath = StoryConfig.GetStoryFilePath(v)
		self:AddRes({path = storyPath, type = AssetType.Prefab})
	end
end

function FightResuorcesLoadHelp:PreloadWeapon(weaponId, refine)
	refine = refine or 1
	local modelConfig = RoleConfig.GetWeaponAsset(weaponId)
	if modelConfig and next(modelConfig) then
		for i = 1, #modelConfig, 1 do
			self:AddRes({path = modelConfig[i][1], type = AssetType.Prefab})
		end
	end
	local magicConfig = {}
	if RoleConfig.GetWeaponRefineConfig(weaponId, refine) then
		magicConfig = RoleConfig.GetWeaponRefineConfig(weaponId, refine).magic_type
	end
	if magicConfig and next(magicConfig) then
		for i = 1, #magicConfig, 1 do
			local magicId, lev = RoleConfig.GetMagicData(magicConfig[i])
			self:PreloadMagicAndBuffs(magicId, nil, FightEnum.MagicConfigFormType.Equip)
		end
	end
end

function FightResuorcesLoadHelp:PreloadPartnerSkill(skillId)
	local levelConfig = RoleConfig.GetPartnerSkillConfig(skillId)
	if levelConfig and levelConfig.fight_magic then
		for key, value in pairs(levelConfig.fight_magic) do
			local magicId, lev = RoleConfig.GetMagicData(value)
			self:PreloadMagicAndBuffs(magicId, nil, FightEnum.MagicConfigFormType.Equip)
		end
	end
end

function FightResuorcesLoadHelp:PreloadGlider(gliderId)
	-- local modelConfig = RoleConfig.GetWeaponAsset(gliderId)
	-- if modelConfig and next(modelConfig) then
	-- 	for i = 1, #modelConfig, 1 do
	-- 		self:AddRes({path = modelConfig[i][2], type = AssetType.Prefab})
	-- 	end
	-- end
	self:AddRes({path = "Character/Animal/Glider/Zhiyao/Zhiyao.prefab", type = AssetType.Prefab})
end