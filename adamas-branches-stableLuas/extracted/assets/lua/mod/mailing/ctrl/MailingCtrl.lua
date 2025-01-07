MailingCtrl = BaseClass("MailingCtrl", Controller)

local DataMailing = Config.DataMailing.Find

function MailingCtrl:__init()
	self:__Clear()
	self.activeState = {}
	self.feedMailingTime = 0
end

function MailingCtrl:__Clear()
	self.activeState = {}
	self.id2NpcId = {}
	self.isInit = false
end

function MailingCtrl:UpdateFeedMailingTime(_value)
	self.feedMailingTime = _value
end

function MailingCtrl:GetFeedMailingTotalTime()
	return self.feedMailingTime or 0
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
	self.activeState = self.activeState or {}
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
	--self:OnRecvMailingInfo({{key = 10005, value = 1}})
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
		self:SetCamera(npcEntity, "CameraTarget2", 167, 0.71, 0.52, 1.63)
	end
	LuaTimerManager.Instance:AddTimer(1, 0.01, delayFunc)
	
	local data = self:GetExchangeItem(id)
	WindowManager.Instance:OpenWindow(MailingExchangeWindow, {id = id, config = data, instanceId = npcEntity.instanceId}, nil, true)
	--self:PlayMailingAnim(npcEntity.instanceId, "Stand")
	self:SetPlayerVisible(false)
end

function MailingCtrl:SetCamera(npcEntity, targetName, rotY, screenX, screenY, distance, backCamera)
	local CameraTarget = npcEntity.clientTransformComponent:GetTransform(targetName)
	CameraTarget.transform.localRotation = Quaternion.Euler(Vector3(0, rotY, 0))
	
	if not backCamera then
		BehaviorFunctions.SetCameraState(FightEnum.CameraState.Mailing)
	else
		BehaviorFunctions.fight.clientFight.cameraManager.states[FightEnum.CameraState.Mailing]:ChangeToMailingBack()
	end
	
	local mailingCamera = BehaviorFunctions.fight.clientFight.cameraManager.states[FightEnum.CameraState.Mailing]
	mailingCamera:SetCameraParam(screenX, screenY, distance)
	mailingCamera:SetMainTarget(CameraTarget.transform)
end

function MailingCtrl:CloseExchangeWindow(window, id, finish)
	WindowManager.Instance:CloseWindow(window)
	
	if finish then
		local npcEntity = BehaviorFunctions.GetNpcEntity(self.id2NpcId[id])
		self:SetCamera(npcEntity, "CameraTarget", 180, 0.5, 0.5, 5, true)
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

function MailingCtrl:PlayMailingAnim(instanceId, animName, effectId, delay)
	if self.effect then
		BehaviorFunctions.RemoveEntity(self.effect)
		self.effect = nil
	end
	
	local entity = BehaviorFunctions.GetEntity(instanceId)
	if entity and entity.entityId == 8012002 and effectId == 801200107 then
		effectId = 801200203
	end
	
	local delayFunc = function()
		if effectId then
			self.effect = BehaviorFunctions.CreateEntity(effectId, instanceId)
		end
	end
	
	if delay and delay ~= 0 then
		LuaTimerManager.Instance:AddTimer(1, delay, delayFunc)
	else
		delayFunc()
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
	--role.clientTransformComponent:SetActive(visible)
	role.clientTransformComponent:SetBineVisible("Role",visible)
end