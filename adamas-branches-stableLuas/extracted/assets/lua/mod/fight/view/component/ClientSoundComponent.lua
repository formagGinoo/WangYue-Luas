---@class ClientSoundComponent
ClientSoundComponent = BaseClass("ClientSoundComponent",PoolBaseClass)

function ClientSoundComponent:__init()
	self.bindLifeSoundList = {}
	self.delayEventList = {}
	self.animSoundMap = {}
	self.soundSignMap = {}
	self.playAnimSound = nil
	self.soundEventKeyMap = {}
	self.soundKeyConfigMap = {}
	self.soundKeyPlayRecord = {}
end

function ClientSoundComponent:Init(clientFight,clientEntity)
	self.clientFight = clientFight
	self.fight = clientFight.fight
	self.clientEntity = clientEntity
	self.config = self.clientEntity.entity:GetComponentConfig(FightEnum.ComponentType.Sound)
	self.soundEventList = self.config.SoundEventList
	self.stateComponent = self.clientEntity.entity.stateComponent
	self.skillComponent = self.clientEntity.entity.skillComponent

	--读取技能音效映射表
	if self.config.SkillSoundEventMapList then
		for k, v in pairs(self.config.SkillSoundEventMapList) do
			if v.OldSoundEvent and v.NewSoundEvent and #v.NewSoundEvent > 0 then
				self.soundEventKeyMap[v.OldSoundEvent] = v.NewSoundEvent
				self.soundKeyConfigMap[v.OldSoundEvent] = v
			end 
		end
	end
	--读取状态音效映射表
	if self.config.StateSoundEventMapList then
		for k, v in pairs(self.config.StateSoundEventMapList) do
			if v.StateID and v.NewSoundEvent and #v.NewSoundEvent > 0  then
				self.soundEventKeyMap[BehaviorFunctions.GetStateSoundEventKey(v.StateID,v.SubStateID)] = v.NewSoundEvent
				self.soundKeyConfigMap[BehaviorFunctions.GetStateSoundEventKey(v.StateID,v.SubStateID)] = v
			end 
		end
	end
	self.inStory = false
	
	self.bornSoundPlay = false
	
	EventMgr.Instance:AddListener(EventName.StoryDialogStart, self:ToFunc("OnStoryDialogStart"))
	EventMgr.Instance:AddListener(EventName.StoryDialogEnd, self:ToFunc("OnStoryDialogEnd"))
end

function ClientSoundComponent:LateInit()
	if not self.bornSoundPlay then
		self.gameObject = self.clientEntity.clientTransformComponent:GetGameObject()
		self:OnEvent(FightEnum.SoundEventType.Born)
		self.bornSoundPlay = true
	end
end

function ClientSoundComponent:OnStoryDialogStart()
	self.inStory = true
	if self.gameObject then
		SoundManager.Instance:StopObjectAllSound(self.gameObject)
	else
		LogError("StopObjectAllSound gameobject is null")
	end
end



function ClientSoundComponent:OnStoryDialogEnd()
	self.inStory = false
end


function ClientSoundComponent:OnEvent(eventType, soundSignType)
	if self.soundEventList then
		for k, v in pairs(self.soundEventList) do
			if v.EventType == eventType then
				if v.DelayTime <= 0 then
					self:PlaySound(v.SoundEvent, v.LifeBindEntity,soundSignType)
				else
					local event = TableUtils.CopyTable(v)
					event.soundSignType = soundSignType
					table.insert(self.delayEventList, event)
				end
			end
		end
	end
end


function ClientSoundComponent:Update()
		
	for i = #self.delayEventList, 1, -1 do
		local eventInfo = self.delayEventList[i]
		local delayTime = eventInfo.DelayTime - Global.deltaTime
		if delayTime > 0 then
			eventInfo.DelayTime = delayTime
		else
			if eventInfo.FadeOutTime then
				self:StopSound(eventInfo.SoundEvent, nil, eventInfo.FadeOutTime)		
			else
				self:PlaySound(eventInfo.SoundEvent, eventInfo.LifeBindEntity, eventInfo.soundSignType)
			end
			table.remove(self.delayEventList, i)
		end
	end

	-- 状态音效检查
	if self.stateComponent then
		
		-- todo临时方案，屏蔽timeline过程中实体状态音效
		if self.inStory then
			do
				return
			end
		end

		local mainState,SubState = self.stateComponent:GetState()
		
		local mainStateEventKey = BehaviorFunctions.GetStateSoundEventKey(mainState,0)
		if not self.mainStateEventKey or self.mainStateEventKey ~= mainStateEventKey 
			or (self.soundKeyConfigMap[self.mainStateEventKey] and self.soundKeyConfigMap[self.mainStateEventKey].IsLoop) then
			self.mainStateEventKey = mainStateEventKey
			self:CheckSoundKeyPlay(mainStateEventKey)
		end

		if SubState then
			local subStateEventKey = BehaviorFunctions.GetStateSoundEventKey(mainState,SubState)
			if not self.subStateEventKey or self.subStateEventKey ~= subStateEventKey 
				or (self.soundKeyConfigMap[self.subStateEventKey] and self.soundKeyConfigMap[self.subStateEventKey].IsLoop )then
				self.subStateEventKey = subStateEventKey
				self:CheckSoundKeyPlay(subStateEventKey)
			end
		end
		if self.skillComponent and mainState == FightEnum.EntityState.Skill then
			local skillEventKey = self.skillComponent.skillId
			if not self.skillEventKey or self.skillEventKey ~= skillEventKey 
				or (self.soundKeyConfigMap[self.skillEventKey] and self.soundKeyConfigMap[self.skillEventKey].IsLoop) then
				self.skillEventKey = skillEventKey
				self:CheckSoundKeyPlay(skillEventKey)
			end
		else
			self.skillEventKey = nil
		end
	end
	
end

-- 播放音效key
function ClientSoundComponent:CheckSoundKeyPlay(stateEventKey)
	if stateEventKey then
		local curStateConfig = self.soundKeyConfigMap[stateEventKey]
		if curStateConfig then
			local lastTime = self.soundKeyPlayRecord[stateEventKey]
			if not lastTime or self.fight.time - lastTime > curStateConfig.CD * 10000 then
				self.soundKeyPlayRecord[stateEventKey] = self.fight.time
				
				local isOn = BehaviorFunctions.Probability(curStateConfig.Probability*10000)
				-- 处理与上个stateSound的打断关系
				if self.lastSoundKeyEvent then
					if SoundManager.Instance:CheckGameObjectPlaySound(self.lastSoundKeyEvent, self.gameObject) then
						local lastPriority = self.soundKeyConfigMap[self.lastSoundKeyEvent].Priority
						local curPriority = curStateConfig.Priority
						if curPriority > lastPriority and isOn then
							self:StopSound(self.lastSoundKeyEvent)
						elseif curPriority < lastPriority then
							isOn = false
						end
					end
				end 
				
				if isOn then
					local lifeBindEntity = true
					if curStateConfig.LifeBindEntity ~= nil then
						lifeBindEntity = curStateConfig.LifeBindEntity
					end
					self:TryPlaySoundEventByMap(stateEventKey,lifeBindEntity,FightEnum.SoundSignType.Language) 
					self.lastSoundKeyEvent = stateEventKey
				end 
			end
		end
	end
	
end

-- 播放声音映射
function ClientSoundComponent:TryPlaySoundEventByMap(soundEvent, lifeBindEntity, soundSignType)
	
	local translatedSoundEvent = self.soundEventKeyMap[soundEvent] 
	if translatedSoundEvent then
		for i, v in ipairs(translatedSoundEvent) do
			self:PlaySound(v ,lifeBindEntity, soundSignType)
		end
	end
	
end
function ClientSoundComponent:PlaySound(soundEvent, lifeBindEntity, soundSignType)
	local holdTime = 60
	if not self.gameObject or not soundEvent then
		return
	end
	if lifeBindEntity then
		holdTime = -1
		table.insert(self.bindLifeSoundList, soundEvent)
	end

	if soundSignType and soundSignType ~= FightEnum.SoundSignType.Normal then
		-- 同一类型互斥
		if self.soundSignMap[soundSignType] then
			SoundManager.Instance:StopObjectSound(self.soundSignMap[soundSignType], self.gameObject)		
		end
		self.soundSignMap[soundSignType] = soundEvent
	end

	SoundManager.Instance:PlayObjectSound(soundEvent, self.gameObject, holdTime)
end

function ClientSoundComponent:PlayTerrainSound(soundEvent, lifeBindEntity)
	local terrainMatLayer = self.clientEntity.clientTransformComponent:GetGroundMatLayer()
	if terrainMatLayer == 0 then
		terrainMatLayer = TerrainMatLayerConfig.Layer.Mud
	end
	if self.gameObject then
		GameWwiseContext.SetSwitch("Material", TerrainMatLayerConfig.LayerStr[terrainMatLayer], self.gameObject)
		self:PlaySound(soundEvent, lifeBindEntity)
	end
end

local StopSoundType = SoundManager.ActionEvent.AkActionOnEventType_Stop
local StopSoundFadeCurve = SoundManager.AkCurveInterpolation.AkCurveInterpolation_SineRecip
function ClientSoundComponent:StopSound(soundEvent, delayTime, fadeOutTime)
	if not delayTime then
		if fadeOutTime then
			GameWwiseContext.ExecuteActionOnEvent(soundEvent, StopSoundType, self.gameObject, fadeOutTime, StopSoundFadeCurve)
		else
			SoundManager.Instance:StopObjectSound(soundEvent, self.gameObject)
		end
	else
		local event = 
		{
			SoundEvent = soundEvent,
			DelayTime = delayTime,
			FadeOutTime = fadeOutTime,
		}
		table.insert(self.delayEventList, event)
	end
end

function ClientSoundComponent:SetRTPCValue(name, value, time)
	GameWwiseContext.SetRTPCValue(name, value, self.gameObject, time)
end

function ClientSoundComponent:GetSignSound(signType)
	if self.soundSignMap[signType] then
		if not SoundManager.Instance:CheckGameObjectPlaySound(self.soundSignMap[signType], self.gameObject) then
			self.soundSignMap[signType] = nil
			return
		end
	end

	return self.soundSignMap[signType]
end

function ClientSoundComponent:OnCache()
	self.clientFight.fight.objectPool:Cache(ClientSoundComponent, self)
end

function ClientSoundComponent:__cache()
	self:OnEvent(FightEnum.SoundEventType.Destroy)
	for k, v in pairs(self.bindLifeSoundList) do
		SoundManager.Instance:StopObjectSound(v, self.gameObject)
	end
	TableUtils.ClearTable(self.bindLifeSoundList)
	TableUtils.ClearTable(self.delayEventList)
	TableUtils.ClearTable(self.animSoundMap)
	TableUtils.ClearTable(self.soundSignMap)
	TableUtils.ClearTable(self.soundEventKeyMap)
	TableUtils.ClearTable(self.soundKeyConfigMap)
	TableUtils.ClearTable(self.soundKeyPlayRecord)
	EventMgr.Instance:RemoveListener(EventName.StoryDialogStart, self:ToFunc("OnStoryDialogStart"))
	EventMgr.Instance:RemoveListener(EventName.StoryDialogEnd, self:ToFunc("OnStoryDialogEnd"))
	
end

function ClientSoundComponent:__delete()
	self.clientFight = nil
	self.clientEntity = nil
end