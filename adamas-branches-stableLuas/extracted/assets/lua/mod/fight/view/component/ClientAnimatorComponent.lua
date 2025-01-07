---@class ClientAnimatorComponent
ClientAnimatorComponent = BaseClass("ClientAnimatorComponent",PoolBaseClass)

local LayerCrossTime = 0.2
local BaseSpeedHash = -2024739398

function ClientAnimatorComponent:__init()
	self.lastName = ""
	self.AdditiveAnim = {}
	self.waitPlayParam = {}
	self.forcePause = false
	self.isStopAnimator = false
end

function ClientAnimatorComponent:Update()
	local time = Global.deltaTime * 10000
	for layer, addAnim in pairs(self.AdditiveAnim) do
		addAnim.lastTime = addAnim.lastTime - time
		local percent = 1 - addAnim.lastTime / addAnim.duration
		if percent > 1 then
			if addAnim.isLoop then
				self.animator:SetLayerWeight(layer, addAnim.curve[addAnim.curveLength] * addAnim.weight)
				addAnim.lastTime = addAnim.duration
			else
				percent = 1
				self.AdditiveAnim[layer] = nil
				self.animator:SetLayerWeight(layer, 0)
			end
		else
			local curveIndex = math.ceil(percent * addAnim.curveLength)
			curveIndex = curveIndex == 0 and 1 or curveIndex
			self.animator:SetLayerWeight(layer, addAnim.curve[curveIndex] * addAnim.weight)
		end
	end
end

function ClientAnimatorComponent:Init(clientFight,clientEntity,info)
	self.clientFight = clientFight
	self.clientEntity = clientEntity
	self.path = info.Animator
	local entity = self.clientEntity.entity
	self.transformComponent = entity.transformComponent
	self.animatorComponent = entity.animatorComponent
	self.animatorController = self.clientFight.assetsPool:Get(self.path)
	self.hitComponent = entity.hitComponent
	if not self.animatorController then
		LogError("have not AnimatorComponent")
	end
	local clientTransformComponent = self.clientEntity.clientTransformComponent
	self.transform = clientTransformComponent.model and clientTransformComponent.model or clientTransformComponent.transform
	self.animator = self.transform.gameObject:GetComponentInChildren(Animator, true)
	if not self.animator then
		self.animator = self.transform.gameObject:AddComponent(Animator)
	end
	self.animator.enabled = true
	self.animator.runtimeAnimatorController = self.animatorController
	self.transitionConfig = entity:GetComponentConfig(FightEnum.ComponentType.Animator).TransitionDic

	self.layerLastName = {
		[0] = ""
	}
	self.layerWeightTween = {}
	self.animatorBaseSpeed = 1

	if AssetBatchLoader.UseLocalRes then
		if self.animatorController.layers then
			self.checkAnimStateMap = {}
			local layerCount = self.animatorController.layers.Length
			for i = 0, layerCount - 1 do
				self.checkAnimStateMap[i] = {}
				local states = CustomUnityUtils.GetAnimatorAllStates(self.animatorController, i)
				for j = 0, states.Count - 1 do
					self.checkAnimStateMap[i][states[j]] = true
				end
			end
		end
	end
end

function ClientAnimatorComponent:GetLayerIndex(layerName)
	local layer = self.animator:GetLayerIndex(layerName)
	return layer
end

function ClientAnimatorComponent:SetAnimationSync(entity)
	--获取当前动画状态
	local currentState = self.animator:GetCurrentAnimatorStateInfo(0)
	if currentState == nil then
        return
    end
	local animName = self.animatorComponent.animationName
	local startTime = currentState.normalizedTime
	
	local pos =  self.transform.position
	entity.transformComponent:SetPosition(pos.x, pos.y, pos.z)
	entity.clientEntity.clientTransformComponent:Async()
	BehaviorFunctions.CopyEntityRotate(self.clientEntity.entity.instanceId,entity.instanceId)
	entity.clientEntity.clientAnimatorComponent:PlayAnimation(animName,0,startTime,0,true,true)
	entity.clientEntity.clientAnimatorComponent:SetForcePauseState(true)
end

function ClientAnimatorComponent:PlayAnimation(name, time, offset, layer, isNormalized, isImmediately)
	layer = layer or 0
	if layer ~= 0 then
		if not self.layerLastName[layer] then
			self:SetLayerWeight(layer, 0, 1, LayerCrossTime)
		end
	else
		for k, v in pairs(self.layerLastName) do
			if k > 0 then
				self.layerLastName[k] = nil
				self:SetLayerWeight(k, 1, 0, LayerCrossTime)
			end
		end
	end

	if time == 0 and (self.lastLayer ~= layer or self.layerLastName[layer] ~= name) then
		time = self:GetTransition(layer, self.lastName, name, isNormalized)
	end

	self.lastLayer = layer
	self.layerLastName[layer] = name

	if self.hitComponent then
		self.hitComponent:SetAnimForbiddenBoneShake(false)
	end

	if not isImmediately then
		if self.animator:GetFloat(BaseSpeedHash) ~= self.animatorBaseSpeed then
			self:SetTimeScale(self.animatorBaseSpeed)
		end

		self.waitPlayParam[layer] = { name = name , time = time, layer = layer, fixedTimeOffset = offset, isNormalized = isNormalized }
	else
		if isNormalized then
			self:CrossFade(name, time, layer, offset)
		else
			local speed = self.animator:GetFloat("BaseSpeed")
			local fixedTimeOffset = speed == 0 and 0 or offset / speed
			time = speed == 0 and 0 or time / speed
			self:CrossFadeInFixedTime(name, time, layer, fixedTimeOffset)
		end
	end
end

function ClientAnimatorComponent:AfterUpdate()
	if not self.waitPlayParam or not next(self.waitPlayParam) then
		return
	end

	for k, v in pairs(self.waitPlayParam) do
		if v.isNormalized then
			self:CrossFade(v.name, v.time, v.layer, v.fixedTimeOffset)
		else
			local speed = self.animatorBaseSpeed
			local fixedTimeOffset = speed == 0 and 0 or v.fixedTimeOffset / speed
			local time = speed == 0 and 0 or v.time / speed
			self:CrossFadeInFixedTime(v.name, time, v.layer, fixedTimeOffset)
		end
	end
	TableUtils.ClearTable(self.waitPlayParam)
end

function ClientAnimatorComponent:CrossFade(name, fusionTime, layer, startTime)
	if self.checkAnimStateMap then
		if not self.checkAnimStateMap[layer] or not self.checkAnimStateMap[layer][name] then
			return
		end
	end

	self.animator:CrossFade(name, fusionTime, layer, startTime)
end

function ClientAnimatorComponent:CrossFadeInFixedTime(name,time,layer,fixedTimeOffset)--固定时间内动画过渡
	if self.checkAnimStateMap then
		if not self.checkAnimStateMap[layer] or not self.checkAnimStateMap[layer][name] then
			--LogError("Play Missing State:"..name, " obj:"..self.clientEntity.clientTransformComponent.gameObject.name)
			return
		end
	end

	self.animator:CrossFadeInFixedTime(name,time,layer,fixedTimeOffset)
end


function ClientAnimatorComponent:SetLayerWeight(layer, from, to, time, callback)
	if self.layerWeightTween[layer] then	
		self.layerWeightTween[layer]:Kill()	
	end

	if not from then
		from = self.animator:GetLayerWeight(layer)
	end

	self.layerWeightTween[layer] = CustomUnityUtils.TweenerTo(from, to, time, function(v) 
	    self.animator:SetLayerWeight(layer, v)
	    if v == to then
	    	self.layerWeightTween[layer]:Kill()	
	    	if callback then
	    		callback()
	    	end
	    end
	end)
end

function ClientAnimatorComponent:PlayAdditiveAnimation(name, layerName, weight, CurveId, isLoop)--播放叠加动画
	local animName = self.animatorComponent:GetAnimName(name)
	local animFrame = self.animatorComponent:GetAnimationFrame(animName)
	local layer = self.animator:GetLayerIndex(layerName)
	local curve = CurveConfig.GetCurve(1000, CurveId)

	self.animator:SetLayerWeight(layer, curve[1] * weight)

	local addAnim = {
		layer = layer,
		curve = curve,
		isLoop = isLoop,
		weight = weight,
		duration = animFrame * FightUtil.deltaTime,
		lastTime = animFrame * FightUtil.deltaTime,
		curveLength = #curve,
	}
	self.AdditiveAnim[layer] = addAnim

	self:CrossFadeInFixedTime(name, 0, layer, 0)
end

function ClientAnimatorComponent:SetForcePauseState(state)--更新为强制暂停状态
	self.forcePause = state
	if self.animator then
		self.animator:SetFloat(BaseSpeedHash, state and 0 or 1)
		self.animatorBaseSpeed = state and 0 or 1
	end
end

function ClientAnimatorComponent:SetTimeScale(timeScale)
	if self.forcePause then
		return
	end

    if self.animator then
		local isCanUpdate = self.animatorComponent:IsCurrentAnimationNeedUpdate()
		-- 顿帧的动作对齐
		-- 只发生在从1到小于1的那一次
		-- 如果不对齐，会导致动作表现和逻辑动作帧数不一致，表现会慢一些
		if self.animatorBaseSpeed >= 1 and timeScale < 1 and self.animatorBaseSpeed ~= timeScale and isCanUpdate then
			local animationName = self.animatorComponent.animationName
			local animatorLayer = self.animatorComponent.animatorLayer
			if not animationName then
				return
			end

			local frame = self.animatorComponent.frame + self.animatorComponent.intervalFrame
			local animName = self.animatorComponent:GetAnimName()
			local lengthData = self.animatorComponent.animLengthData
			local startTime = 0
			if lengthData and lengthData[animatorLayer] and lengthData[animatorLayer][animName] then
				startTime = frame / lengthData[animatorLayer][animName]
				self.waitPlayParam[animatorLayer] = { name = animationName, time = 0, layer = animatorLayer, fixedTimeOffset = startTime, isNormalized = true }
			else
				-- 如果不是按进度算的动画 改不了 等死吧
			end
		end

		self.animator:SetFloat(BaseSpeedHash, timeScale)
		self.animatorBaseSpeed = timeScale
	end
end

function ClientAnimatorComponent:SetTimeScaleMultiplier(name, timeScale)
	self.animator:SetFloat(name, timeScale)
	if name == "BaseSpeed" then
		self.animatorBaseSpeed = timeScale
	end
end

function ClientAnimatorComponent:SaveTimeScale(timeScale)
	if timeScale then
		self.animatorBaseSpeedCache = timeScale
	else
		self.animatorBaseSpeedCache = self.animatorBaseSpeed
	end
end

function ClientAnimatorComponent:ResetTimeScale()
	if self.animatorBaseSpeedCache then
		self.animator:SetFloat(BaseSpeedHash, self.animatorBaseSpeedCache)
		self.animatorBaseSpeed = self.animatorBaseSpeedCache
		self.animatorBaseSpeedCache = nil
	end
end

function ClientAnimatorComponent:SetBackSpeed(speed)
	self:SetTimeScale(speed)
	self.animBackResetSpeed = speed
end

function ClientAnimatorComponent:IsCurrentAnimationLooping(layer)
	if UtilsBase.IsNull(self.animator) then
		return true
	end
	layer = layer or 0
	local stateInfo = self.animator:GetCurrentAnimatorStateInfo(layer)
	if stateInfo:IsName(self.layerLastName[layer]) then
		return stateInfo.loop
	end
	return true
end

function ClientAnimatorComponent:GetAnimTime(stateName,layer)
	if UtilsBase.IsNull(self.animator) then
		return 
	end
	layer = layer or 0

	local clips = self.animatorController.animationClips

	for i = 0, clips.Length - 1, 1 do
		if clips[i].name == stateName then 
			return clips[i].length
		end
	end
end

function ClientAnimatorComponent:GetTransition(layer,formName,toName, isNormalized)
	local transition = 0.1
	if self.transitionConfig and self.transitionConfig[layer] then
		local config = self.transitionConfig[layer][formName]
		if not config then
			config = self.transitionConfig[layer].AnyState
		end

		if config then
			if config[toName] then
				transition = config[toName]
			elseif config.AnyState then
				transition = config.AnyState
			end
		end
	end

	if isNormalized then
		-- 百分比过度是用的上一个动画的百分比
		local lengthData = self.animatorComponent.animLengthData
		local animName = self.animatorComponent:GetAnimName(formName)
		if lengthData and lengthData[layer] and lengthData[layer][animName] then
			local fusionFrame = math.floor(transition / 0.03)
			transition = fusionFrame / lengthData[layer][animName]
		end
	end

	return transition
end

function ClientAnimatorComponent:SetController(controller)
	self.animator.runtimeAnimatorController = controller
end

function ClientAnimatorComponent:ResetController()
	self.animator.runtimeAnimatorController = self.animatorController
end

function ClientAnimatorComponent:IsLayerHasState(name, layer)
	return self.animator:HasState(layer, Animator.StringToHash(name))
end

function ClientAnimatorComponent:OnCache()
	self.clientFight.fight.objectPool:Cache(ClientAnimatorComponent,self)
end

function ClientAnimatorComponent:__cache()
	self.animator.enabled = true
	self.animator = nil
	self.animatorBaseSpeed = nil
	self.animatorBaseSpeedCache = nil
	self.isStopAnimator = false
	TableUtils.ClearTable(self.AdditiveAnim)
	TableUtils.ClearTable(self.waitPlayParam)
	--self.clientFight.assetsPool:Cache(self.path,self.animatorController)
end

function ClientAnimatorComponent:__delete()
	self.clientFight = nil
	self.clientEntity = nil
end