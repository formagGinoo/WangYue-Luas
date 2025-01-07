MailingCtrl = BaseClass("MailingCtrl", Controller)

local DataMailing = Config.DataMailing.Find

function MailingCtrl:__init()
	self.activeState = {}
	self.id2NpcId = {}
	
	self.isInit = false
end

function MailingCtrl:OnRecvMailingInfo(data)
	if not self.isInit then
		for _, v in pairs(data) do
			self.activeState[v.key] = v.value
		end
		self.isInit = true
	else
		self.activeState[data[1].key] = data[1].value
		if data[1].value == FightEnum.MailingState.Active then
			self:OnActiveMailing(self.id2NpcId[data[1].key], data[1].key)
		end
	end
end

function MailingCtrl:CheckMailingState(id, state)
	if state == FightEnum.MailingState.NotActive then
		return self.activeState[id] == nil
	end
	
	return self.activeState[id] == state
end

function MailingCtrl:ActiveMailing(npcId)
	if not self.isInit then
		LogError("脉灵功能未初始化")
		return
	end
	
	local id = StoryConfig.GetMailingId(npcId)
	if self.activeState[id] then
		LogError("脉灵重复激活:"..id)
		return
	end
	
	self.id2NpcId[id] = npcId
	mod.MailingFacade:SendMsg("mailing_active", id)
	--self:OnRecvMailingInfo({{key = 70001, value = 1}})
end

function MailingCtrl:CommitExchangeItem(id, itemId, itemCount)
	if self.activeState[id] ~= FightEnum.MailingState.Active or not itemId or not itemCount or itemCount == 0 then
		LogError("脉灵道具交付失败:"..id)
		return
	end
	mod.MailingFacade:SendMsg("mailing_exchange", id, itemId, itemCount)
end

function MailingCtrl:OnGetCommitResult(data)
	if data.result == 1 then
		self.activeState[data.mailing_id] = FightEnum.MailingState.Finished
	end
	
	EventMgr.Instance:Fire(EventName.MailingExchangeResult, data.mailing_id, data.result)
end

function MailingCtrl:GetExchangeItem(id)
	if not id then
		return
	end
	
	local data = DataMailing[id]
	if not data then
		LogError("错误的脉灵道具交付数据获取："..id)
	end
	return data
end

function MailingCtrl:OpenExchangeWindow(id, npcId)
	if not self.isInit then
		LogError("脉灵功能未初始化")
		return
	end
	
	if not self.activeState[id] then
		LogError("脉灵未激活:"..id)
		return
	end
	
	if self.activeState[id] == FightEnum.MailingState.Finished then
		LogError("脉灵已完成交易:"..id)
		return
	end
	
	self.id2NpcId[id] = npcId
	local npcEntity = BehaviorFunctions.GetNpcEntity(npcId)
	
	local delayFunc = function()
		self:SetCamera(npcEntity, 167, 0.71, 0.52, 1.63)
	end
	LuaTimerManager.Instance:AddTimer(1, 0.01, delayFunc)
	
	local data = self:GetExchangeItem(id)
	WindowManager.Instance:OpenWindow(MailingExchangeWindow, {id = id, config = data, instanceId = npcEntity.instanceId}, nil, true)
	self:SetPlayerVisible(false)
end

function MailingCtrl:SetCamera(npcEntity, rotY, screenX, screenY, distance)
	local CameraTarget = npcEntity.clientEntity.clientTransformComponent:GetTransform("CameraTarget")
	if not CameraTarget then
		CameraTarget = GameObject("CameraTarget")
		npcEntity.clientEntity.clientTransformComponent:SetTransformChild(CameraTarget.transform)
		CameraTarget.transform:ResetAttr()
		CameraTarget.transform.localPosition = Vector3(0, 0.25, 0)
	end
	
	CameraTarget.transform.localRotation = Quaternion.Euler(Vector3(0, rotY, 0))
	BehaviorFunctions.SetCameraState(FightEnum.CameraState.Mailing)
	BehaviorFunctions.fight.clientFight.cameraManager.states[FightEnum.CameraState.Mailing]:SetCameraParam(screenX, screenY, distance)
	BehaviorFunctions.fight.clientFight.cameraManager.states[FightEnum.CameraState.Mailing]:SetMainTarget(CameraTarget.transform)
end

function MailingCtrl:CloseExchangeWindow(window, id, finish)
	WindowManager.Instance:CloseWindow(window)
	
	if finish then
		local delayFunc = function()
			Fight.Instance.entityManager:CallBehaviorFun("MailingExchangeFinish", self.id2NpcId[id], id)
			BehaviorFunctions.SetCameraState(FightEnum.CameraState.Operating)
			BehaviorFunctions.SetFightPanelVisible("-1")
			self:SetPlayerVisible(true)
		end
		
		BehaviorFunctions.SetFightPanelVisible("0")
		Fight.Instance.entityManager:CallBehaviorFun("MailingExchangeBeforeFinish", self.id2NpcId[id], id)
		LuaTimerManager.Instance:AddTimer(1, 3, delayFunc)
	else
		BehaviorFunctions.SetCameraState(FightEnum.CameraState.Operating)
		self:SetPlayerVisible(true)
	end
end

function MailingCtrl:HangingFood(foodId, instanceId)
	if foodId and foodId ~= 0 then
		local effectEntity = BehaviorFunctions.GetEntity(self.effect)
		local effectClientTransformComponent = effectEntity.clientEntity.clientTransformComponent
		
		local effectFood = BehaviorFunctions.CreateEntity(foodId, instanceId)
		local foodEntity = BehaviorFunctions.GetEntity(effectFood)
		if foodEntity.triggerComponent then
			foodEntity.triggerComponent.enabled = false
		end
		local transform = foodEntity.clientEntity.clientTransformComponent:GetTransform()
		effectEntity.clientEntity.clientTransformComponent:SetTransformChild(transform, "Food")
		transform:ResetAttr()
		UnityUtils.SetLocalScale(transform, 0.15, 0.15, 0.15)
		effectEntity:LifeBindEntity(foodEntity.instanceId)
	end
end

function MailingCtrl:PlayMailingAnim(instanceId, animName, effectId, foodId, isLoadFood)
	if self.effect then
		BehaviorFunctions.RemoveEntity(self.effect)
		self.effect = nil
	end
	
	if foodId and foodId ~= 0 and not isLoadFood then
		local callback = function()
			self:PlayMailingAnim(instanceId, animName, effectId, foodId, true)
		end
		
		Fight.Instance.clientFight.assetsNodeManager:LoadEntity(foodId, callback)
		return
	end
	
	if effectId then
		self.effect = BehaviorFunctions.CreateEntity(effectId, instanceId)
		self:HangingFood(foodId, instanceId)
	end
	
	if BehaviorFunctions.CheckEntity(instanceId) then
		BehaviorFunctions.PlayAnimation(instanceId, animName)
	end
end

--改为timeline为宜
function MailingCtrl:OnActiveMailing(npcId, id)
	Fight.Instance.entityManager:CallBehaviorFun("MailingActive", npcId, id)
end

function MailingCtrl:SetPlayerVisible(visible)
	local role = Fight.Instance.playerManager:GetPlayer():GetCtrlEntityObject()
	--role.clientEntity.clientTransformComponent:SetActive(visible)
	role.clientEntity.clientTransformComponent:SetBineVisible("Role",visible)
end