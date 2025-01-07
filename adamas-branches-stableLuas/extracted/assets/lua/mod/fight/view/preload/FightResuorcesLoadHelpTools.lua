
FightResuorcesLoadHelpTools = BaseClass("FightResuorcesLoadHelpTools")

local _insert = table.insert
local ComponentType = FightEnum.ComponentType  
local ComponentConfigName = FightEnum.ComponentConfigName
local SkillEventType = FightEnum.SkillEventType

FightResuorcesLoadHelpTools.EntityCache = {}

function FightResuorcesLoadHelpTools:__init(addResCB)
	self.entityStack = {}
	self.entites = {}
	self.magics = {}
	self.buffs = {}
	self.resList = {}
	self.resMap = {}
	self.stackStringList = {}
	self.addResCB = addResCB
end

function FightResuorcesLoadHelpTools:AddCellCallback(cellCallback)
	for k, v in pairs(self.resList) do
		v.callback = cellCallback
	end
end

function FightResuorcesLoadHelpTools:AddRes(resInfo,stackString)
	if not resInfo.path or resInfo.path == "" then
		return
	end

	DebugResStackDict[resInfo.path] = stackString

	--stackString = stackString or ""
	resInfo.callback = self.addResCB
	
	_insert(self.resList, resInfo)
	self.resMap[resInfo.path] = true
end


function FightResuorcesLoadHelpTools.PreloadEntityFile(fileId, stackString)
	stackString = stackString or ""
	DebugEntityResDict = {}
    local config = Config["Entity" .. fileId]
    if config then
    	local commonFileInfo = FightResuorcesLoadHelp.CommonEntityFiles[tostring(fileId)]
    	if commonFileInfo then
    		FightResuorcesLoadHelpTools.LoadFileResMagic(fileId, stackString .. fileId .. "-->(CommonFile)")
    	else
	        for k, v in pairs(config) do
	        	if k == fileId then
	        		FightResuorcesLoadHelpTools.LoadFileResMagic(fileId, stackString)
	        	else
					local resHelp = FightResuorcesLoadHelpTools.New()
					DebugEntityResDict[k] = {}
					resHelp:PreloadEntity(k, stackString .. fileId .. "-->(Entity)")
					for _, resInfo in pairs(resHelp.resList) do
						DebugEntityResDict[k][resInfo.path] = resInfo.type 
					end
				end
	        end
	    end
    end
end

function FightResuorcesLoadHelpTools.LoadFileResMagic(fileId, stackString)
	if DebugEntityResDict[fileId] then
		return
	end

	DebugEntityResDict[fileId] = {}
	local config = Config["Entity" .. fileId]
    for k, v in pairs(config) do
		local resHelp = FightResuorcesLoadHelpTools.New()
		resHelp:PreloadEntity(k, stackString .. fileId .. "-->(Entity)")
		for _, resInfo in pairs(resHelp.resList) do
			DebugEntityResDict[fileId][resInfo.path] = resInfo.type 
		end
    end

    local resHelp = FightResuorcesLoadHelpTools.New()
    local magicConfig = Config["Magic"..fileId]
	if magicConfig then
		for magicId, v in pairs(magicConfig.Magics) do
			resHelp:PreloadMagicAndBuffs(magicId, fileId,nil,stackString)
		end

		for magicId, v in pairs(magicConfig.Buffs) do
			resHelp:PreloadMagicAndBuffs(magicId, fileId,nil,stackString)
		end
	end
	for _, resInfo in pairs(resHelp.resList) do
		DebugEntityResDict[fileId][resInfo.path] = resInfo.type
	end
end

function FightResuorcesLoadHelpTools:PreloadEntity(entityId, stackString)
	stackString = stackString or ""
	local cache = not next(self.resList)

	if self.entites[entityId] then
		return
	end


	local entityConfigId = EntityConfig.GetEntityConfigId(entityId)
	if not entityConfigId then
		--LogError(" 找不到配置！"..entityId.."堆栈："..stackString)
		return
	end

	local fileName = Config.EntityIdConfig[entityId]

	if not FightResuorcesLoadHelp.CommonEntityFiles[fileName] and DebugEntityFileName ~= fileName and
		Config["EntityRes"..entityId] then
		
		local tempFileName = DebugEntityFileName
		-- 其他root id引用直接加载
		DebugEntityFileName = tostring(fileName)
		FightResuorcesLoadHelpTools.LoadFileResMagic(entityId, stackString .. entityId .. "-->")
		DebugEntityFileName = tempFileName
		local size = TableUtils.GetTabelLen(DebugEntityResDict[entityId])
		--print("entityId "..entityId.." fileId size "..size.."堆栈 "..stackString)
		for k, v in pairs(DebugEntityResDict[entityId]) do
			self:AddRes({path = k, type = v},stackString)
		end
		return
	end

	--DebugEntityFileName = fileName

	self.entites[entityId] = entityId

	local entityConfig = EntityConfig.GetEntity(entityId)
	if not entityConfig then
		--LogError(" 找不到配置！"..entityId.."堆栈："..stackString)
		return
	end

	self.entityStack[entityId] = entityId

	local components = entityConfig.Components
	local transformConfig = components[ComponentConfigName[ComponentType.Transform]]
	if transformConfig then
		if transformConfig.LodRes then
			local path = string.gsub(transformConfig.Prefab, ".prefab", "Unit.prefab")
			self:AddRes({path = path, type = AssetType.Prefab},stackString .. entityId .. "-->(transform)")
		else
			self:AddRes({path = transformConfig.Prefab, type = AssetType.Prefab},stackString..entityId.."-->(transform)")
		end
	end

	local animatorConfig = components[ComponentConfigName[ComponentType.Animator]]
	if animatorConfig then
		self:AddRes({path = animatorConfig.Animator, type = AssetType.Object},stackString .. entityId .. "-->(animator)")
	end

	local combinationConfig = components[ComponentConfigName[ComponentType.Combination]]
	if combinationConfig and combinationConfig.Animator then
		self:AddRes({path = combinationConfig.Animator,type = AssetType.Object},stackString .. entityId .. "-->(combination)")
	end

	if Config.FollowHaloConfig[entityId] then
		self:AddRes({path = Config.FollowHaloConfig[entityId].Prefab, type = AssetType.Prefab},stackString .. entityId .. "-->(FollowHalo)")
	end

	local skillConfig = components[ComponentConfigName[ComponentType.Skill]]
	if skillConfig and skillConfig.Skills then
		for skillId, skill in pairs(skillConfig.Skills) do
			if not skill.FrameEvent then
				--Log("没有技能帧事件,entityId = "..entityId.." skillId = "..skillId)
			else			
				for _, frameEventList in pairs(skill.FrameEvent) do
					for __, v in pairs(frameEventList) do
						if v.EventType == SkillEventType.CreateEntity then
							self:PreloadEntity(v.EntityId,stackString .. entityId.. "-->" .. "(" .. skillId .. "技能帧事件创建)")
						elseif v.EventType == SkillEventType.PostProcess and
							v.PostProcessType == FightEnum.PostProcessType.SceneColorChange then
							self:AddRes({path = v.PostProcessParams.EnvProfilePath, type = AssetType.Object},stackString .. skillId .. "-->(skill)")
							self:AddRes({path = v.PostProcessParams.SkyProfilePath, type = AssetType.Object},stackString .. skillId .. "-->(skill)")
						elseif v.EventType == SkillEventType.DoMagic or v.EventType == SkillEventType.AddBuff then
							local magicId = v.EventType == SkillEventType.DoMagic and v.MagicId or v.BuffId
							self:PreloadMagicAndBuffs(magicId, entityConfigId,nil,stackString .. "(被动技能帧事件)" .. entityId .. "-->")
						end
					end
				end
			end
			if skill.SetButtonInfos then
				local buttonInfos = skill.SetButtonInfos --预加载加载按钮特效
				for index, config in ipairs(buttonInfos) do
					if config then
						if config.ReadyEffectPath and #config.ReadyEffectPath > 8 then
							self:AddRes({path = config.ReadyEffectPath, type = AssetType.Prefab},stackString .. entityId .. "-->(buttonInfo)")
						end
						if config.CastEffectPath and #config.CastEffectPath > 8 then
							self:AddRes({path = config.CastEffectPath, type = AssetType.Prefab},stackString .. entityId .. "-->(buttonInfo)")
						end
						if config.DodgeEffectPath and #config.DodgeEffectPath > 8 then
							self:AddRes({path = config.DodgeEffectPath, type = AssetType.Prefab},stackString .. entityId .. "-->(buttonInfo)")
						end
					end
				end
			end
		end
	end

	local skillSetConfig = components[ComponentConfigName[ComponentType.SkillSet]]
	if skillSetConfig and skillSetConfig.UISets[1] then
		local UISetsConfig = skillSetConfig.UISets[1]
		if UISetsConfig.CoreUIConfig and UISetsConfig.CoreUIConfig.UIPath then
			self:AddRes({path = UISetsConfig.CoreUIConfig.UIPath, type = AssetType.Prefab},stackString .. entityId .. "-->(CoreUI)")
		end
	end

	local pasvConfig = components[ComponentConfigName[ComponentType.Pasv]]
	if pasvConfig then
		for skillId, skill in pairs(pasvConfig.Skills) do
			for _, frameEventList in pairs(skill.FrameEvent) do
				for __, v in pairs(frameEventList) do
					if v.EventType == SkillEventType.CreateEntity then
						self:PreloadEntity(v.EntityId,stackString .. entityId .."-->" .. "(被动技能帧事件创建)")
					elseif v.EventType == SkillEventType.DoMagic or v.EventType == SkillEventType.AddBuff then
						local magicId = v.EventType == SkillEventType.DoMagic and v.MagicId or v.BuffId
						self:PreloadMagicAndBuffs(magicId, entityConfigId,nil,stackString .. "(被动技能帧事件)" .. entityId .. "-->")
					end
				end
			end
		end
	end

	local behaviorConfig = components[ComponentConfigName[ComponentType.Behavior]]
	if behaviorConfig then
		for i = 1, #behaviorConfig.Behaviors do
			self:PreloadBehavior(behaviorConfig.Behaviors[i], entityConfigId,nil,stackString .. entityId .. "-->(Behavior配置)")
		end
	end

	local attackConfig = components[ComponentConfigName[ComponentType.Attack]]
	if attackConfig then
		if attackConfig.MagicsBySelf then
			for k, magicId in pairs(attackConfig.MagicsBySelf) do
				self:PreloadMagicAndBuffs(magicId, entityConfigId,nil,stackString)
			end
		end

		if attackConfig.MagicsByTarget then
			for k, magicId in pairs(attackConfig.MagicsByTarget) do
				self:PreloadMagicAndBuffs(magicId, entityConfigId,nil,stackString)
			end
		end
		if attackConfig.MagicsByTargetSingle then
			for k, magicId in pairs(attackConfig.MagicsByTargetSingle) do
				self:PreloadMagicAndBuffs(magicId, entityConfigId,nil,stackString)
			end
		end
		if attackConfig.TargetCreateEntities then
			for k, entityId in pairs(attackConfig.TargetCreateEntities) do
				self:PreloadEntity(entityId, stackString ..  entityId.. "-->(TargetCreateEntities)")
			end
		end

		if attackConfig.HitGroundCreateEntity then
			for k, entityId in pairs(attackConfig.HitGroundCreateEntity) do
				self:PreloadEntity(entityId, stackString ..  entityId.. "-->(HitGroundCreateEntity)")
			end
		end

		if attackConfig.CreateHitEntities then
			for k, v in pairs(attackConfig.CreateHitEntities) do
				self:PreloadEntity(v.EntityId, stackString ..  v.EntityId .. "-->(CreateHitEntities)")
			end
		end
		
	end

	local blowConfig = components[ComponentConfigName[ComponentType.Blow]]
	if blowConfig then
		if blowConfig.CreateHitEntities and next(blowConfig.CreateHitEntities) then
			for k, v in pairs(blowConfig.CreateHitEntities) do
				self:PreloadEntity(v.EntityId, stackString ..  v.EntityId.. "-->(CreateHitEntities)")
			end
		end

		if blowConfig.CreateBreakEntities and next(blowConfig.CreateBreakEntities)  then
			for k, v in pairs(blowConfig.CreateBreakEntities) do
				self:PreloadEntity(v.EntityId, stackString ..  v.EntityId.. "-->(CreateBreakEntities)")
			end
		end

		if blowConfig.CreateDisappearEntities and next(blowConfig.CreateDisappearEntities) then
			for k, v in pairs(blowConfig.CreateDisappearEntities) do
				self:PreloadEntity(v.EntityId, stackString ..  v.EntityId .. "-->(CreateDisappearEntities)")
			end
		end
		
	end
	
	local displayConfig = components[ComponentConfigName[ComponentType.Display]]
	if displayConfig then
		for i, v in ipairs(displayConfig.DisplayEvents) do
			if v.AnimConfigs and next(v.AnimConfigs) then
				for k, w in pairs(v.AnimConfigs) do
					if w.CreateEntitys and next(w.CreateEntitys) then
						for j, p in pairs(w.CreateEntitys) do
							self:PreloadEntity(p.EntityId, stackString ..  p.EntityId.. "演出创建状态实体")
						end
					end
				end
			end
		end
		for i, v in ipairs(displayConfig.StateEvents) do
			if v.CreateEntitys and next(v.CreateEntitys) then
				for k, w in pairs(v.CreateEntitys) do
					self:PreloadEntity(w.EntityId, stackString ..  w.EntityId.. "演出创建状态实体")
				end
			end
		end
		
	end

	local createEntityConfig = components[ComponentConfigName[ComponentType.CreateEntity]]
	if createEntityConfig then
		for i, v in ipairs(createEntityConfig.CreateEntityInfos) do
			self:PreloadEntity(v.EntityId,stackString ..  entityId .. "-->(CreateEntityInfos)")
		end
	end

	self.entityStack[entityId] = nil
end

function FightResuorcesLoadHelpTools:PreloadBehavior(behaviorName, entityConfigId, kind,stackString)
	stackString = stackString or ""
	local class = "Behavior" .. behaviorName
	local behavior = _G[class]
	if behavior then
		if  behavior.GetGenerates then
			local generates = behavior.GetGenerates()
			if generates then
				for i = 1, #generates do
					self:PreloadEntity(generates[i],stackString.. "(Behavior创建)")
				end
			end
		end

		if behavior.GetMagics then
			local magics = behavior.GetMagics()
			if magics then
				for i = 1, #magics do
					self:PreloadMagicAndBuffs(magics[i], entityConfigId, kind,stackString)
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
				self:AddRes({path = otherAsset[i], type = AssetType.Prefab},stackString)
			end
		end

	end
end

function FightResuorcesLoadHelpTools:PreloadMagicAndBuffs(id, entityConfigId, kind, stackString)
	stackString = stackString or ""
	local magicConfig = MagicConfig.GetMagic(id, entityConfigId, kind)
	if magicConfig and not self.magics[id] then
		self.magics[id] = id
		if FightEnum.MagicFuncName[magicConfig.Type] == "CreateEntity" then
			local EntityId = magicConfig.Param.EntityId
			if not EntityId then
				--LogError("magicConfig.Param.EntityId id null "..magicConfig.Param.EntityId)
			else
				self:PreloadEntity(EntityId,stackString ..id .. "-->" .. "(MagicAndBuffs创建)")
			end
		elseif FightEnum.MagicFuncName[magicConfig.Type] == "AddBuff" then
			self:PreloadMagicAndBuffs(magicConfig.Param.BuffId, entityConfigId, kind,stackString .. "(MagicAndBuffs)" ..id .. "-->")
		elseif FightEnum.MagicFuncName[magicConfig.Type] == "ScreenEffect" then
			self:AddRes({path = magicConfig.Param.Effect, type = AssetType.Prefab},stackString .. "(MagicAndBuffs)" ..id .. "-->(ScreenEffect)")
		elseif FightEnum.MagicFuncName[magicConfig.Type] == "AddBehavior" then
			self:PreloadBehavior(magicConfig.Param.behaviorName, entityConfigId, kind,stackString .. "(MagicAndBuffs)" ..id .. "-->")
		elseif FightEnum.MagicFuncName[magicConfig.Type] == "Preform" then
			self:AddRes({path = magicConfig.Param.TimelinePath, type = AssetType.Prefab},stackString .. "(MagicAndBuffs)" ..id .. "-->(Preform)")
		elseif FightEnum.MagicFuncName[magicConfig.Type] == "CameraTrack" then
			self:AddRes({path = magicConfig.Param.CameraTrackPath, type = AssetType.Prefab},stackString .. "(MagicAndBuffs)" ..id .. "-->(CameraTrack)")
		elseif FightEnum.MagicFuncName[magicConfig.Type] == "WeaponEffect" then
			self:AddRes({path = magicConfig.Param.effectPath, type = AssetType.Prefab},stackString .. "(MagicAndBuffs)" ..id .. "-->(WeaponEffect)")
		end
	elseif self.magics[id] then
		return
	end

	local buffConfig = MagicConfig.GetBuff(id, entityConfigId, kind)
	if buffConfig and not self.buffs[id] then
		self.buffs[id] = id
		if buffConfig.MagicIds then
			for i = 1, #buffConfig.MagicIds do
				self:PreloadMagicAndBuffs(buffConfig.MagicIds[i], entityConfigId, kind,stackString .. "(MagicAndBuffs)" ..id .. "-->")
			end
		end

		if buffConfig.EffectInfos then
			for i = 1, #buffConfig.EffectInfos do
				self:AddRes({path = buffConfig.EffectInfos[i].EffectPath, type = AssetType.Prefab},stackString .. id .. "-->(buff)")
			end
		end
	elseif self.buffs[id] then
		return
	end
end

-- function FightResuorcesLoadHelpTools:PreloadStorys(dialogId)
-- 	local storyPath
-- 	for k, v in pairs(StoryConfig.GetRelevanceId(dialogId)) do
-- 		storyPath = StoryConfig.GetStoryFilePath(v)
-- 		self:AddRes({path = storyPath, type = AssetType.Prefab})
-- 	end
-- end

-- function FightResuorcesLoadHelpTools:PreloadWeapon(weaponId, refine)
-- 	refine = refine or 1
-- 	local modelConfig = RoleConfig.GetWeaponAsset(weaponId)
-- 	if modelConfig and next(modelConfig) then
-- 		for i = 1, #modelConfig, 1 do
-- 			self:AddRes({path = modelConfig[i][2], type = AssetType.Prefab})
-- 		end
-- 	end
-- 	local magicConfig = {}
-- 	if RoleConfig.GetWeaponRefineConfig(weaponId, refine) then
-- 		magicConfig = RoleConfig.GetWeaponRefineConfig(weaponId, refine).magic_type
-- 	end
-- 	if magicConfig and next(magicConfig) then
-- 		for i = 1, #magicConfig, 1 do
-- 			self:PreloadMagicAndBuffs(magicConfig[i], nil, FightEnum.MagicConfigFormType.Equip)
-- 		end
-- 	end
-- end

-- function FightResuorcesLoadHelpTools:PreloadPartnerSkill(skillId, skillLev)
-- 	local levelConfig = RoleConfig.GetPartnerSkillLevelConfig(skillId, skillLev)
-- 	if levelConfig and levelConfig.fight_magic then
-- 		for key, value in pairs(levelConfig.fight_magic) do
-- 			self:PreloadMagicAndBuffs(value, nil, FightEnum.MagicConfigFormType.Equip)
-- 		end
-- 	end
-- end

-- function FightResuorcesLoadHelpTools:PreloadGlider(gliderId)
-- 	-- local modelConfig = RoleConfig.GetWeaponAsset(gliderId)
-- 	-- if modelConfig and next(modelConfig) then
-- 	-- 	for i = 1, #modelConfig, 1 do
-- 	-- 		self:AddRes({path = modelConfig[i][2], type = AssetType.Prefab})
-- 	-- 	end
-- 	-- end
-- 	self:AddRes({path = "Character/Animal/Glider/Zhiyao/Zhiyao.prefab", type = AssetType.Prefab})
-- end