---@class ClientAnimatorComponent
ClientAnimatorComponent = BaseClass("ClientAnimatorComponent",PoolBaseClass)

local LayerCrossTime = 0.2

function ClientAnimatorComponent:__init()
	self.lastName = ""
	self.AdditiveAnim = {}
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
	self.animator = self.transform.gameObject:GetComponentInChildren(Animator)
	if not self.animator then
		self.animator = self.transform.gameObject:AddComponent(Animator)
	end
	self.animator.runtimeAnimatorController = self.animatorController
	self.animationEventTrigger = self.transform.gameObject:GetComponent(AnimationEventTrigger)
	if not self.animationEventTrigger then
		self.animationEventTrigger = self.transform.gameObject:AddComponent(AnimationEventTrigger)
	end
	self.transitionConfig = entity:GetComponentConfig(FightEnum.ComponentType.Animator).TransitionDic

	self.layerLastName = {
		[0] = ""
	}
	self.layerWeightTween = {}
end

function ClientAnimatorComponent:GetLayerIndex(layerName)
	local layer = self.animator:GetLayerIndex(layerName)
	return layer
end

function ClientAnimatorComponent:PlayAnimation(name, time, offset, layer)
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

	if time == 0 then
		time = self:GetTransition(layer,self.lastName,name)
	end

	self.lastLayer = layer
	self.layerLastName[layer] = name

	if self.hitComponent then
		self.hitComponent:SetAnimForbiddenBoneShake(false)
	end

	local speed = self.animator:GetFloat("BaseSpeed")
	local fixedTimeOffset = speed == 0 and 0 or offset / speed
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


function ClientAnimatorComponent:PlayAdditiveAnimation(name, layerName, weight, CurveId, isLoop)
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

	self.animator:CrossFadeInFixedTime(name, 0, layer, 0)
end

function ClientAnimatorComponent:SetTimeScale(timeScale)
	if self.animator then
		self.animator:SetFloat("BaseSpeed", timeScale)
	end
end

function ClientAnimatorComponent:SetTimeScaleMultiplier(name, timeScale)
	self.animator:SetFloat(name, timeScale)
end

function ClientAnimatorComponent:SaveTimeScale(timeScale)
	if timeScale then
		self.animatorSpeed = timeScale
	elseif not self.animatorSpeed then
		self.animatorSpeed = self.animator:GetFloat("BaseSpeed")
	end
end

function ClientAnimatorComponent:ResetTimeScale()
	if self.animatorSpeed then
		self.animator:SetFloat("BaseSpeed", self.animatorSpeed)
		self.animatorSpeed = nil
	end
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

function ClientAnimatorComponent:GetTransition(layer,formName,toName)
	local transition = 0.1
	if not self.transitionConfig then
		return transition
	end
	if not self.transitionConfig[layer] then
		return 0.1
	end
	local config = self.transitionConfig[layer][formName]
	if not config then
		config = self.transitionConfig[layer].AnyState
	end
	if config then
		if config[toName] then
			return config[toName]
		elseif config.AnyState then
			return config.AnyState
		else
			return transition
		end
	else
		return transition
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
	self.animator = nil
	self.animatorSpeed = nil
	self.AdditiveAnim = {}
	--self.clientFight.assetsPool:Cache(self.path,self.animatorController)
end

function ClientAnimatorComponent:__delete()
	self.clientFight = nil
	self.clientEntity = nil
end