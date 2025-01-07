---@class DisplayComponent
DisplayComponent = BaseClass("DisplayComponent",PoolBaseClass)
local Vec3 = Vec3
local UpDir = Vec3.New(0, 1, 0)
local _abs = math.abs
local _random = math.random
local _sqrt = math.sqrt
local _max = math.max

local EntityLayer = FightEnum.Layer.Entity

function DisplayComponent:__init()
end

DisplayComponent.Const_StandardMass = 10
DisplayComponent.Const_DefaultSpeed = 10
DisplayComponent.Const_DefaultBreakSpeed = 1
DisplayComponent.Const_ParentName = "DisplayParent"

function DisplayComponent:Init(fight,entity)
	self.fight = fight
	self.entity = entity
	self.config = entity:GetComponentConfig(FightEnum.ComponentType.Display)
	self.displayEvent = nil
	self.stateEvent = nil
	self.currentDisplayName = nil
	self.displayEffectList = {}
	self.stateEffectList = {}
	self.frame = 0
	self.bodyily = self.config.Bodyily
	self.playAnims = {}
	
    self.curDisplaySpeed = 1
end

function DisplayComponent:LateInit()
end

function DisplayComponent:GetBodyily()
	return self.bodyily
end

function DisplayComponent:SetSpeed(speed)
	self.curDisplaySpeed = speed
	self.entity.clientEntity.clientAnimatorComponent:SetTimeScale(speed)
end


function DisplayComponent:ChangeState(stateType)
	if not self.stateEvent or self.stateEvent.StateType ~= stateType then
		self:ClearStateEffect()
		self.stateEvent =  self:GetStateEvent(stateType)
		if self.stateEvent then
			if self.stateEvent.StateAnim then
				local layer = self.stateEvent.LayerIndex
				if layer > 0 then
					layer = self.entity.clientAnimatorComponent:GetLayerIndex(FightEnum.AnimationLayerIndexToName[self.stateEvent.LayerIndex + 1])
				end
				self.entity.animatorComponent:PlayAnimation( self.stateEvent.StateAnim, 0, layer)
			end
	
			self:CreatStateEffect(self.stateEvent.CreateEntitys)
			
		end
	end
end

function DisplayComponent:GetDisplayAnimsConfig(displayEvent,animType)
	if displayEvent and displayEvent.AnimConfigs then
		for i, v in ipairs(displayEvent.AnimConfigs) do
			if v.animType == animType then
				return v
			end
		end
	end
end

function DisplayComponent:Display(displayType,skipFadeOut,callback)
	
	if self.displayEvent and self.displayEvent.DisplayType == displayType then
		return
	end


	TableUtils.ClearTable(self.playAnims)
	local fadeOutFinish = function()
		if callback then
			callback(FightEnum.DisplayFinishType.FadeOut)
		end
	end
	if self.displayEvent and not skipFadeOut then
		local fadeOutCfg = self:GetDisplayAnimsConfig(self.displayEvent,FightEnum.DisplayAnimType.FadeOut)
		if fadeOutCfg then
			local aniFrame = BehaviorFunctions.GetEntityAnimationFrame(self.entity.instanceId,fadeOutCfg.animName)
			if aniFrame == -1 then
				aniFrame = 30
			end
			self:AddAnimationPlay(fadeOutCfg.animName,self.displayEvent.LayerIndex,aniFrame,fadeOutCfg.CreateEntitys,fadeOutFinish,self.displayEvent.DisplayType)
		else
			fadeOutFinish()
		end
		self.displayEvent = nil
	else
		fadeOutFinish()
	end
	
	local fadeInFinish = function()
		if callback then
			callback(FightEnum.DisplayFinishType.FadeIn)
		end
	end
	if displayType then
		self.displayEvent = self:GetDisplayEvent(displayType)
		if self.displayEvent then
			
			local fadeInCfg = self:GetDisplayAnimsConfig(self.displayEvent,FightEnum.DisplayAnimType.FadeIn)
			if fadeInCfg then
				local aniFrame = BehaviorFunctions.GetEntityAnimationFrame(self.entity.instanceId,fadeInCfg.animName)
				if aniFrame == -1 then
					aniFrame = 30
				end
				self:AddAnimationPlay(fadeInCfg.animName,self.displayEvent.LayerIndex,aniFrame,fadeInCfg.CreateEntitys,fadeInFinish,self.displayEvent.DisplayType)
			else
				fadeInFinish()
			end

			local loopCfg = self:GetDisplayAnimsConfig(self.displayEvent,FightEnum.DisplayAnimType.Loop)
			if loopCfg then
				self:AddAnimationPlay(loopCfg.animName,self.displayEvent.LayerIndex,nil,loopCfg.CreateEntitys,nil,self.displayEvent.DisplayType)
			end
		end
		
	else
		fadeInFinish()
	end

end

function DisplayComponent:AddAnimationPlay(name,layer,duration,createEntitys,callback,displayType)

	local lastAnims =  self.playAnims[#self.playAnims]
	local EndFrame
	if duration then
		if lastAnims and lastAnims.EndFrame then
			EndFrame = lastAnims.EndFrame + duration
		else
			EndFrame = self.frame + duration
		end
	end
	
	
	table.insert(self.playAnims,{Name = name,Layer = layer, EndFrame = EndFrame,CreateEntitys = createEntitys,CallBack = callback,DisplayType = displayType})
end


function DisplayComponent:PlayPerformAnimation(name,layer)
	self.entity.clientEntity.clientAnimatorComponent:SetTimeScale(self.curDisplaySpeed)

	if name then
		if layer > 0 then
			layer = self.entity.clientAnimatorComponent:GetLayerIndex(FightEnum.AnimationLayerIndexToName[params.LayerIndex + 1])
		end
		self.entity.animatorComponent:PlayAnimation( name, 0, layer)
	end
end


function DisplayComponent:GetDisplayEvent(displayType)
	if not self.config.DisplayEvents then
		return
	end
	local displayEvent
	for i, v in ipairs(self.config.DisplayEvents) do
		if v.DisplayType == displayType then
			displayEvent = v
		end
	end
	return displayEvent
end

function DisplayComponent:GetStateEvent(stateType)
	if not self.config.StateEvents then
		return
	end
	local displayEvent
	for i, v in ipairs(self.config.StateEvents) do
		if v.StateType == stateType then
			displayEvent = v
		end
	end
	return displayEvent
end


function DisplayComponent:Update()
	self.frame = self.frame + 1

	if next(self.playAnims) then
		if self.playAnims[1].EndFrame and self.frame >= self.playAnims[1].EndFrame then
			if self.playAnims[1].CallBack then
				self.playAnims[1].CallBack()
			end
			table.remove(self.playAnims,1)
		end
	end
	
	if self.playAnims[1] then
		if self.currentDisplayName ~= self.playAnims[1].Name then
			self.currentDisplayName = self.playAnims[1].Name
			self:PlayPerformAnimation(self.playAnims[1].Name,self.playAnims[1].Layer)
			self:CreatDisplayEffect(self.playAnims[1].CreateEntitys)
		end
	else
		self.currentDisplayName = nil
		if self.config.isDecoration and self.entity.clientEntity.clientAnimatorComponent then
			self.entity.clientEntity.clientAnimatorComponent:SetTimeScale(0)
		end

		self:ClearDisplayEffect()
	end

end

function DisplayComponent:GetDisplayType()

	if self.displayEvent then
		return self.displayEvent.DisplayType
	end
end


function DisplayComponent:ClearDisplayEffect()
	for i, v in ipairs(self.displayEffectList) do
		BehaviorFunctions.RemoveEntity(v)
	end
	TableUtils.ClearTable(self.displayEffectList)
end

function DisplayComponent:ClearStateEffect()
	for i, v in ipairs(self.stateEffectList) do
		BehaviorFunctions.RemoveEntity(v.instanceId)
	end
	TableUtils.ClearTable(self.stateEffectList)
end

-- 创建演出特效
function DisplayComponent:CreatDisplayEffect(creatList)
	self:ClearDisplayEffect()
	if creatList then
		local creatEffectList = self.displayEffectList
		for k, v in ipairs(creatList) do
			
			local pos = self.entity.transformComponent.position
			local effectEntityId = BehaviorFunctions.CreateEntity(v.EntityId, self.entity.instanceId, pos.x, pos.y, pos.z)

			local effectEntity =self.fight.entityManager:GetEntity(effectEntityId)

			effectEntity.clientTransformComponent:SetTransformScale(v.Scale[1], v.Scale[2], v.Scale[3])

			table.insert(creatEffectList,effectEntityId)
		end
	end
end

-- 创建状态特效
function DisplayComponent:CreatStateEffect(creatList)
	self:ClearStateEffect()
	if creatList then
		local creatEffectList = self.stateEffectList
		for k, v in ipairs(creatList) do
			
			local pos = self.entity.transformComponent.position
			local effectEntityId = BehaviorFunctions.CreateEntity(v.EntityId, self.entity.instanceId, pos.x, pos.y, pos.z)
			local effectEntity =self.fight.entityManager:GetEntity(effectEntityId)
			effectEntity.clientTransformComponent:SetTransformScale(v.Scale[1], v.Scale[2], v.Scale[3])
			table.insert(creatEffectList,effectEntity)
		end
	end
end

function DisplayComponent:OnCache()
	self:ClearDisplayEffect()
	self.fight.objectPool:Cache(DisplayComponent,self)
end

function DisplayComponent:__cache()
end

function DisplayComponent:__delete()
end