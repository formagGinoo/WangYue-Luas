
FightResuorcesLoadHelp = BaseClass("FightResuorcesLoadHelp")

local _insert = table.insert
local sceneABs = {}
local ComponentType = FightEnum.ComponentType  
local ComponentConfigName = FightEnum.ComponentConfigName
local DataDuplicateLevel = Config.DataDuplicate.data_duplicate_level
local SkillEventType = FightEnum.SkillEventType

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


function FightResuorcesLoadHelp:PreloadEntity(entityId, fileLoad)
	if self.entites[entityId] then
		return
	end

	local entityConfig = EntityConfig.GetEntity(entityId)
	if not entityConfig then
		LogError("找不到配置！"..entityId)
		return
	end

	local entityConfigId = EntityConfig.GetEntityConfigId(entityId)
	if not entityConfigId then
		LogError("找不到配置！"..entityId)
		return
	end


	if not fileLoad then
		local fileName = Config.EntityIdConfig[entityId]
		if not fileName then
			LogError("entityId fileName null "..entityId)
		end

		if not self.entiteFileLoad[fileName] then
			self.entiteFileLoad[fileName] = true
			local config = Config["Entity"..fileName]
			for k, v in pairs(config) do
				self:PreloadEntity(k, true)
			end

			self.magicFileLoad[fileName] = true
			local magicConfig = Config["Magic"..fileName]
			if magicConfig then
				for magicId, v in pairs(magicConfig.Magics) do
					self:PreloadMagicAndBuffs(magicId, entityConfigId)
				end

				for magicId, v in pairs(magicConfig.Buffs) do
					self:PreloadMagicAndBuffs(magicId, entityConfigId)
				end
			end
		end
	end

	self.entites[entityId] = entityId

	local components = entityConfig.Components
	local transformConfig = components[ComponentConfigName[ComponentType.Transform]]
	if transformConfig then
		self:AddRes({path = transformConfig.Prefab, type = AssetType.Prefab})
	end

	local animatorConfig = components[ComponentConfigName[ComponentType.Animator]]
	if animatorConfig then
		self:AddRes({path = animatorConfig.Animator, type = AssetType.Object})
	end

	local combinationConfig = components[ComponentConfigName[ComponentType.Combination]]
	if combinationConfig and combinationConfig.Animator then
		self:AddRes({path = combinationConfig.Animator,type = AssetType.Object})
	end
	
	local attributesConfig = components[ComponentConfigName[ComponentType.Attributes]]
	if attributesConfig and attributesConfig.AttributeEventList then
		for k, v in pairs(attributesConfig.AttributeEventList) do
			if v.EmptyEvent then
				-- if v.EmptyEvent.SelfMagicList then
				-- 	for k, magicId in pairs(v.EmptyEvent.SelfMagicList) do
				-- 		self:PreloadMagicAndBuffs(magicId, entityConfigId)
				-- 	end
				-- end

				-- if v.EmptyEvent.PlayerMagicList then
				-- 	for k, magicId in pairs(v.EmptyEvent.PlayerMagicList) do
				-- 		self:PreloadMagicAndBuffs(magicId, entityConfigId)
				-- 	end
				-- end

				-- if v.EmptyEvent.EndMagicList then
				-- 	for k, magicId in pairs(v.EmptyEvent.EndMagicList) do
				-- 		self:PreloadMagicAndBuffs(magicId, entityConfigId)
				-- 	end
				-- end
			end
		end
	end

	if Config.FollowHaloConfig[entityId] then
		self:AddRes({path = Config.FollowHaloConfig[entityId].Prefab, type = AssetType.Prefab})
	end

	local skillConfig = components[ComponentConfigName[ComponentType.Skill]]
	if skillConfig and skillConfig.Skills then
		for skillId, skill in pairs(skillConfig.Skills) do
			if not skill.FrameEvent then
				Log("没有技能帧事件,entityId = "..entityId.." skillId = "..skillId)
			else			
				for _, frameEventList in pairs(skill.FrameEvent) do
					for __, v in pairs(frameEventList) do
						if v.EventType == SkillEventType.CreateEntity then
							self:PreloadEntity(v.EntityId)
						elseif v.EventType == SkillEventType.PostProcess and
							v.PostProcessType == FightEnum.PostProcessType.SceneColorChange then
							self:AddRes({path = v.PostProcessParams.EnvProfilePath, type = AssetType.Object})
							self:AddRes({path = v.PostProcessParams.SkyProfilePath, type = AssetType.Object})
						-- elseif v.EventType == SkillEventType.DoMagic or v.EventType == SkillEventType.AddBuff then
						-- 	local magicId = v.EventType == SkillEventType.DoMagic and v.MagicId or v.BuffId
						-- 	self:PreloadMagicAndBuffs(magicId, entityConfigId)
						end
					end
				end
			end
			if skill.SetButtonInfos then
				local buttonInfos = skill.SetButtonInfos --预加载加载按钮特效
				for index, config in ipairs(buttonInfos) do
					if config then
						if config.ReadyEffectPath and #config.ReadyEffectPath > 8 then
							self:AddRes({path = config.ReadyEffectPath, type = AssetType.Prefab})
						end
						if config.CastEffectPath and #config.CastEffectPath > 8 then
							self:AddRes({path = config.CastEffectPath, type = AssetType.Prefab})
						end
						if config.DodgeEffectPath and #config.DodgeEffectPath > 8 then
							self:AddRes({path = config.DodgeEffectPath, type = AssetType.Prefab})
						end
					end
				end
			end
		end
	end

	local skillSetConfig = components[ComponentConfigName[ComponentType.SkillSet]]
	if skillSetConfig and skillSetConfig.UISets[1].BindResPath then
		local UISetsConfig = skillSetConfig.UISets[1]
		self:AddRes({path = UISetsConfig.BindResPath, type = AssetType.Prefab})
		local coreInfos = UISetsConfig.CoreInfos or {} --预加载加载按钮特效
		for index, config in ipairs(coreInfos) do
			if config then
				if config.ReadyEffectPath and #config.ReadyEffectPath > 8 then
					self:AddRes({path = config.ReadyEffectPath, type = AssetType.Prefab})
				end
				if config.CastEffectPath and #config.CastEffectPath > 8 then
					self:AddRes({path = config.CastEffectPath, type = AssetType.Prefab})
				end
				if config.DodgeEffectPath and #config.DodgeEffectPath > 8 then
					self:AddRes({path = config.DodgeEffectPath, type = AssetType.Prefab})
				end
			end
		end
	end
	
	if skillSetConfig and skillSetConfig.UISets[1] then
		local UISetsConfig = skillSetConfig.UISets[1]
		if UISetsConfig.CoreUIConfig and UISetsConfig.CoreUIConfig.UIPath then
			self:AddRes({path = UISetsConfig.CoreUIConfig.UIPath, type = AssetType.Prefab})
		end
	end

	local pasvConfig = components[ComponentConfigName[ComponentType.Pasv]]
	if pasvConfig then
		for skillId, skill in pairs(pasvConfig.Skills) do
			for _, frameEventList in pairs(skill.FrameEvent) do
				for __, v in pairs(frameEventList) do
					if v.EventType == SkillEventType.CreateEntity then
						self:PreloadEntity(v.EntityId)
					elseif v.EventType == SkillEventType.DoMagic or v.EventType == SkillEventType.AddBuff then
						local magicId = v.EventType == SkillEventType.DoMagic and v.MagicId or v.BuffId
						self:PreloadMagicAndBuffs(magicId, entityConfigId)
					end
				end
			end
		end
	end

	local behaviorConfig = components[ComponentConfigName[ComponentType.Behavior]]
	if behaviorConfig then
		for i = 1, #behaviorConfig.Behaviors do
			self:PreloadBehavior(behaviorConfig.Behaviors[i], entityConfigId)
		end
	end

	-- local attackConfig = components[ComponentConfigName[ComponentType.Attack]]
	-- if attackConfig then
	-- 	if attackConfig.MagicsBySelf then
	-- 		for k, magicId in pairs(attackConfig.MagicsBySelf) do
	-- 			self:PreloadMagicAndBuffs(magicId, entityConfigId)
	-- 		end
	-- 	end

	-- 	if attackConfig.MagicsByTarget then
	-- 		for k, magicId in pairs(attackConfig.MagicsByTarget) do
	-- 			self:PreloadMagicAndBuffs(magicId, entityConfigId)
	-- 		end
	-- 	end
	-- 	if attackConfig.MagicsByTargetSingle then
	-- 		for k, magicId in pairs(attackConfig.MagicsByTargetSingle) do
	-- 			self:PreloadMagicAndBuffs(magicId, entityConfigId)
	-- 		end
	-- 	end
	-- 	if attackConfig.TargetCreateEntities then
	-- 		for k, entityId in pairs(attackConfig.TargetCreateEntities) do
	-- 			self:PreloadEntity(entityId)
	-- 		end
	-- 	end

	-- 	if attackConfig.HitGroundCreateEntity then
	-- 		for k, entityId in pairs(attackConfig.HitGroundCreateEntity) do
	-- 			self:PreloadEntity(entityId)
	-- 		end
	-- 	end
	-- end
	
	local createEntityConfig = components[ComponentConfigName[ComponentType.CreateEntity]]
	if createEntityConfig then
		for i, v in ipairs(createEntityConfig.CreateEntityInfos) do
			self:PreloadEntity(v.EntityId)
		end
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
	local DialogConfig =  StoryConfig.DialogConfig
	if next(DialogConfig[dialogId].relevance_id) then
		for k, v in pairs(DialogConfig[dialogId].relevance_id) do
			storyPath = "Prefabs/StoryTimeline/Prefabs/"..v..".prefab"
			self:AddRes({path = storyPath, type = AssetType.Prefab})
		end
	else
		storyPath = "Prefabs/StoryTimeline/Prefabs/"..dialogId..".prefab"
		self:AddRes({path = storyPath, type = AssetType.Prefab})
	end

end

function FightResuorcesLoadHelp:PreloadWeapon(weaponId, refine)
	refine = refine or 1
	local modelConfig = RoleConfig.GetWeaponAsset(weaponId)
	if modelConfig and next(modelConfig) then
		for i = 1, #modelConfig, 1 do
			self:AddRes({path = modelConfig[i][2], type = AssetType.Prefab})
		end
	end
	local magicConfig = {}
	if RoleConfig.GetWeaponRefineConfig(weaponId, refine) then
		magicConfig = RoleConfig.GetWeaponRefineConfig(weaponId, refine).magic_type
	end
	if magicConfig and next(magicConfig) then
		for i = 1, #magicConfig, 1 do
			self:PreloadMagicAndBuffs(magicConfig[i], nil, FightEnum.MagicConfigFormType.Equip)
		end
	end
end

function FightResuorcesLoadHelp:PreloadPartnerSkill(skillId, skillLev)
	local levelConfig = RoleConfig.GetPartnerSkillLevelConfig(skillId, skillLev)
	if levelConfig and levelConfig.fight_magic then
		for key, value in pairs(levelConfig.fight_magic) do
			self:PreloadMagicAndBuffs(value, nil, FightEnum.MagicConfigFormType.Equip)
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