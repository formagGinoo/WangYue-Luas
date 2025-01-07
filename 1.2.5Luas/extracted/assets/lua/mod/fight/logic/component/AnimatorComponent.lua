---@class AnimatorComponent
AnimatorComponent = BaseClass("AnimatorComponent",PoolBaseClass)


local AnimEventType = FightEnum.AnimEventType
local FrameEventFuns =
{
	[AnimEventType.PlaySound] = "DoPlaySound",
	[AnimEventType.PlayTerrainSound] = "DoPlayTerrainSound",	
	[AnimEventType.JumpDodge] = "DoJumpDodge",	
	[AnimEventType.EnableIkShake] = "DoEnableIkShake",
	[AnimEventType.IKAnimateDirection] = "DOIkAnimateDirection",
	[AnimEventType.EnableIkLook] = "DoEnableEnableIkLook",
}

-- 帧事件是否在刚播放时进行前向查询并调用
local ForwardSearch = 
{
	[AnimEventType.LeftWeaponVisible] = true,
	[AnimEventType.RightWeaponVisible] = true,
	[AnimEventType.JumpDodge] = true,
	[AnimEventType.EnableIkShake] = true,
	[AnimEventType.IKAnimateDirection] = true,
}

function AnimatorComponent:__init()
	self.layerPlayAnim = {}
	self.Anim2StateMap = {}
end

function AnimatorComponent:Init(fight,entity)
	self.fight = fight
	self.entity = entity
	self.moveComponent = self.entity.moveComponent
	self.combinationComponent = self.entity.combinationComponent
	self.frame = 0
	self.animFrame = 1
	self.fusionFrame = 0
	self.animationTranslate = nil
	self.layer = 0

	self:ResetAnimData()
end

function AnimatorComponent:ResetAnimData(id)
	if not id then
		id = self.entity:GetComponentConfig(FightEnum.ComponentType.Animator).AnimationConfigID
		if not id or id == "" then
			id = self.entity.entityId
		end
	end
	
	self.animDatas = AnimEventConfig.GetAnimData(id)
	
	if self.animDatas and self.animDatas.State2AnimMap then
		for k, v in pairs(self.animDatas.State2AnimMap) do
			self.Anim2StateMap[v] = k
		end
	end
end

function AnimatorComponent:UpdateLayerPlayAnim(layer)
	--默认0层级是单层播放，如果后续0层也是混合，则需要根据层级权重【animator:GetLayerWeight(layer)】来判断数据是否记录
	if layer == 0 then
		TableUtils.ClearTable(self.layerPlayAnim)
	else
		if self.layerPlayAnim[layer] then
			self.layerPlayAnim[layer] = nil
		end
		if self.animatorLayer ~= 0 and layer ~= self.animatorLayer then
			self.layerPlayAnim[self.animatorLayer] = {
				name = self.animationName,
				frame = self.frame,
				animFrame = self.animFrame,
				isLooping = self.isLooping
			}
		end
	end
end

function AnimatorComponent:PlayAnimation(name,startFrame,layer)
	layer = layer or self.layer
	self:ClearLifeBindEvent()
	self:UpdateLayerPlayAnim(layer)
	if self.animationTranslate then
		local translateInfo = self.animationTranslate[name]
		if translateInfo then
			if not translateInfo.animNameTo then
				return
			end

			name = translateInfo.animNameTo
			layer = translateInfo.layer
			self.entity.logicMove = false
		end
	end

	local nName, data = self:GetAnimFusionData(name)
	local offsetFrame = 0
	self.fusionFrame = 0
	if data then
		self.fusionFrame = data.fusionFrame
		offsetFrame = data.toStartFrame
	end

	if self.combinationComponent then
		self.combinationComponent:PlayAnimation(name)
	end
	
	self.frame = offsetFrame
	self.lastAnimationName = self.animationName
	self.animationName = nName
	self.startFrame = startFrame and startFrame or 0
	self.frame = self.startFrame == 0 and self.frame or self.startFrame
	self.animFrame = self.animDatas and self.animDatas.AnimFrames[nName] or -1
	self.animatorLayer = layer
	self.isLooping = false
	if self.animDatas and self.animDatas.LoopingAnim and self.animDatas.LoopingAnim[nName] then
		self.isLooping = true
	end
	self.play = true
	if ctx then--即时播放动画
		local fusionTime = self.fusionFrame * FightUtil.deltaTimeSecond
		local startTime = self.frame * FightUtil.deltaTimeSecond
		self.entity.clientEntity.clientAnimatorComponent:PlayAnimation(self.animationName, fusionTime, startTime, self.animatorLayer)
		self:UpdateAnimEvent(self.animationName, self.animatorLayer, self.frame, self.animFrame, true)
		EventMgr.Instance:Fire(EventName.OnPlayAnimation, self.entity.instanceId, self.animationName, self:GetAnimName())
	end
	if self.moveComponent then
		self.moveComponent:ApplyAnimation()
	end
	return (self.animFrame - self.frame) * FightUtil.deltaTimeSecond
end

function AnimatorComponent:ClearAnimation()
	if self.moveComponent then
		self.moveComponent:ClearAnimation()
	end
end

function AnimatorComponent:Update()
	if self.play then
		if ctx then
			--会延迟，改成立即调用
  			--self.entity.clientEntity.clientAnimatorComponent:PlayAnimation(self.animationName, self.fusionFrame * FightUtil.deltaTimeSecond, self.frame * FightUtil.deltaTimeSecond, self.animatorLayer)
		end
	end
	
	if not self.isLooping and self.frame == self.animFrame then
		return 
	end
	
	self.frame = self.frame + 1
	self:UpdateAnimEvent(self.animationName, self.animatorLayer, self.frame, self.animFrame)
	for k, v in pairs(self.layerPlayAnim) do
		if not v.isLooping and v.frame == v.animFrame then
			self.layerPlayAnim[k] = nil
		else
			v.frame = v.frame + 1
			self:UpdateAnimEvent(v.name, k, v.frame, v.animFrame)
		end
	end
	
	if self.play then
		self.play = false
	end
end

function AnimatorComponent:SetAnimationTranslate(animNameFrom, animNameTo, layer)
	self.animationTranslate = self.animationTranslate or {}
	self.animationTranslate[animNameFrom] = {animNameTo = animNameTo, layer = layer}
end


function AnimatorComponent:GetAnimationName()
	return self.animationName
end

function AnimatorComponent:GetFrame()
	return self.frame 
end

function AnimatorComponent:GetAnimationFrame(animationName)
	if not animationName then
		return self.animFrame
	end
	
	if not self.animDatas then
		return -1
	end
	
	return self.animDatas.AnimFrames[animationName] or -1
end

function AnimatorComponent:GetPlayingAnimationName(layer)
	if layer == self.animatorLayer then
		return self.animationName, self:GetAnimName(self.animationName)
	elseif self.layerPlayAnim[layer] then
		return self.layerPlayAnim[layer].name, self:GetAnimName(self.layerPlayAnim[layer].name)
	end
end

function AnimatorComponent:GetAnimName(name)
	name = name or self.animationName
	if self.animDatas and self.animDatas.State2AnimMap then
		name = self.animDatas.State2AnimMap[name] or name
	end
	
	return name
end

function AnimatorComponent:GetAnimFusionData(toAnim)
	local subAnim = Config.EntityCommonConfig.Anim2SubAnim[toAnim]
	
	local animList = subAnim or {toAnim}
	local rAnim, rData = animList[1], nil
	if not self.animDatas then
		return rAnim, rData
	end
	
	local animationName = self:GetAnimName(self.animationName)
	local animFusions = self.animDatas.AnimFusions[self.animatorLayer]
	local curFrame = self.frame % self.animFrame
	
	if animFusions and animFusions[animationName] then
		local animFusion = animFusions[animationName]
		for _, v in pairs(animList) do
			v = self:GetAnimName(v)
			if animFusion[v] then
				for _, vv in pairs(animFusion[v]) do
					if curFrame >= vv.fromStartFrame then
						if not rData or (rData and rData.fromStartFrame < vv.fromStartFrame) then
							rAnim, rData = v, vv
						end
					end
				end
			end
		end
	end
	
	if self.Anim2StateMap then
		rAnim = self.Anim2StateMap[rAnim] or rAnim
	end
	
	return rAnim, rData
end

local frameEventData = {}
local recentFrameRecord = {}
function AnimatorComponent:UpdateAnimEvent(name, layer, curFrame, totalFrame, getRecent)
	if not self.animDatas or not self.animDatas.AnimEvents[layer] then
		return 
	end
	
	TableUtils.ClearTable(frameEventData)
	TableUtils.ClearTable(recentFrameRecord)
	local animationName = self:GetAnimName(name)
	local frame = curFrame % totalFrame
	local animEvents = self.animDatas.AnimEvents[layer]

	
	if animEvents[animationName] then
		if getRecent then
			for k, v in pairs(animEvents[animationName]) do
				for _, vv in pairs(v) do
					local recentFrame = recentFrameRecord[vv.eventType] or 0
					if ForwardSearch[vv.eventType] and recentFrame <= k and k <= frame then
						recentFrameRecord[vv.eventType] = k
					end
				end

			end
			
			for k, v in pairs(recentFrameRecord) do
				local data = animEvents[animationName][v]
				for _, vv in pairs(data) do
					if vv.eventType == k then
						table.insert(frameEventData, vv)
					end
				end
			end
		else
			if animEvents[animationName][frame] then
				local data = animEvents[animationName][frame]
				for i = 1, #data do
					table.insert(frameEventData, data[i])
				end
			end
		end
	
		if frameEventData then
			for i = 1, #frameEventData do
				local eventInfo = frameEventData[i]
				local func = FrameEventFuns[eventInfo.eventType]
				if self[func] then
	    			self[func](self, eventInfo)
	    		else
					self.fight.entityManager:CallBehaviorFun("OnAnimEvent", self.entity.instanceId, eventInfo.eventType, eventInfo, animationName)
				end
			end
		end
	end
end

function AnimatorComponent:DoPlaySound(eventInfo)
	self.entity.clientEntity.clientSoundComponent:PlaySound(eventInfo.soundEvent, eventInfo.lifeBindAnimClip)
end

function AnimatorComponent:DoPlayTerrainSound(eventInfo)
	self.entity.clientEntity.clientSoundComponent:PlayTerrainSound(eventInfo.soundEvent, eventInfo.lifeBindAnimClip)
end

function AnimatorComponent:DoJumpDodge(eventInfo)
	if self.entity.dodgeComponent then
		self.entity.dodgeComponent:ActiveDodge(eventInfo.durationFrame,eventInfo.ringCount,true)
		self.hasJumpDodgeEvent = true
	end
end

function AnimatorComponent:DoEnableIkShake(eventInfo)
	if self.entity.hitComponent then
		self.entity.hitComponent:SetAnimForbiddenBoneShake(not eventInfo.Enable)
	end
end

function AnimatorComponent:DoEnableEnableIkLook(eventInfo)
	if self.entity.clientEntity.clientIkComponent then
		self.entity.clientEntity.clientIkComponent:SetLookEnable(eventInfo.Enable)
	end
end

function AnimatorComponent:DOIkAnimateDirection(eventInfo)
	local transform = self.entity.clientEntity.clientTransformComponent:GetTransform()
	local dir = eventInfo.AnimateDirection
	CustomUnityUtils.DoTweenAnimateDirection(transform, dir[1], dir[2], dir[3], eventInfo.time)  
end

function AnimatorComponent:ClearLifeBindEvent()
	if self.hasJumpDodgeEvent then
		self.entity.dodgeComponent:ActiveDodge(0, 0)
		self.hasJumpDodgeEvent = false
	end
end

function AnimatorComponent:SetAnimatorLayer(layer)
	self.layer = self.entity.clientEntity.clientAnimatorComponent:GetLayerIndex(layer)
end

function AnimatorComponent:OnCache()
	self.fight.objectPool:Cache(AnimatorComponent,self)
end

function AnimatorComponent:__cache()
	TableUtils.ClearTable(self.layerPlayAnim)
	TableUtils.ClearTable(self.Anim2StateMap)
end

function AnimatorComponent:__delete()
	self.fight = nil
	self.entity = nil
end