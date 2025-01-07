Behavior8012002 = BaseClass("Behavior8012002",EntityBehaviorBase)
--脉灵
function Behavior8012002.GetGenerates()
	 local generates = {8012001}
	 return generates
end
function Behavior8012002:Init()
	self.me = self.instanceId
	self.myFrame = 0
	self.npcId = nil
	self.isActive = nil
	self.inActive = nil
	self.activeDone = nil
	self.HideEffect = nil
	self.ShowEffect = nil
	self.showFrame  = 3*30 --出现交互延迟
	self.canInteract = nil
	self.specialHide = nil
	self.finishing = nil
	self.activeValue = nil
	self.isModCtrl = false
end

function Behavior8012002:LateInit()	
	if self.sInstanceId then
		self.npcId = self.sInstanceId
		self.isActive = BehaviorFunctions.CheckMailingState(self.npcId, FightEnum.MailingState.Active)
		self.defaultDialogId = BehaviorFunctions.GetNpcDialogId(self.npcId)
	end
end


function Behavior8012002:Update()
	self.role = BehaviorFunctions.GetCtrlEntity()
	self.myFrame = BehaviorFunctions.GetEntityFrame(self.me)
	self.specialHide = BehaviorFunctions.GetEntityValue(self.me,"specialHide")
	self.activeValue = BehaviorFunctions.GetEntityValue(self.me,"activeValue")

	if self.isActive and not self.isModCtrl then
		self:MailingCreateEntity(801200201)
	end
	self.isModCtrl = true
	
	--特殊隐藏
	if self.specialHide == true then
		if not BehaviorFunctions.HasBuffKind(self.me,900000010) then
			BehaviorFunctions.AddBuff(1,self.me,900000010)
		end
		if self.HideEffect then
			BehaviorFunctions.RemoveEntity(self.HideEffect)
			self.HideEffect = nil
		end
		self.canInteract = false
	else
		--未激活，隐藏实体，显示特效
		if not self.canInteract and not BehaviorFunctions.CheckMailingState(self.npcId, FightEnum.MailingState.Finished) then
			self.canInteract = true
		end
		if not self.isActive and not self.HideEffect then
			self.HideEffect = BehaviorFunctions.CreateEntity(801200101,self.me)
			--BehaviorFunctions.SetEntityShowState(self.me,false)
			BehaviorFunctions.AddBuff(1,self.me,900000010)
		end
		if not self.inActive and self.isActive and not self.activeDone then
			self.activeDone = true
		end
	end
	--传值控制激活
	if self.activeValue == true and self.isActive == false then
		self:MailingJihuo()
		self.activeValue = false
	end
end


--点击交互
function Behavior8012002:WorldInteractClick(uniqueId, instanceId)
	if instanceId ~= self.me then
		return
	end
	if self.activeDone and self.defaultDialogId then
		--进入投喂
		if self.interactUniqueId and self.interactUniqueId == uniqueId then
			BehaviorFunctions.WorldInteractRemove(self.me,self.interactUniqueId)
			BehaviorFunctions.StartNPCDialog(self.defaultDialogId, self.me)
			BehaviorFunctions.ShowCharacterHeadTips(self.me, false)
			BehaviorFunctions.DoLookAtTargetImmediately(self.me,self.role)
			self.isTrigger = nil
		end
	elseif not self.isActive then
		--激活脉灵
		if self.interactUniqueId and self.interactUniqueId == uniqueId then
			self:MailingJihuo()
		end
	end
end

--脉灵激活函数
function Behavior8012002:MailingJihuo()
	BehaviorFunctions.ActiveMailing(self.npcId)
	BehaviorFunctions.SetFightPanelVisible("0")
	BehaviorFunctions.ActiveMapIcon(self.npcId)
	BehaviorFunctions.WorldInteractRemove(self.me,self.interactUniqueId)
end

--进入交互范围，添加交互列表
function Behavior8012002:EnterTrigger(triggerInstanceId,triggerEntityId,roleInstanceId)
	if self.canInteract and not self.finishing then
		if self.activeDone then
			if self.isTrigger then
				return
			end
			self.isTrigger = triggerInstanceId == self.me
			if not self.isTrigger then
				return
			end
			self.interactUniqueId = BehaviorFunctions.WorldNPCInteractActive(self.me,"投喂")
		elseif not self.isActive then
			if self.isTrigger then
				return
			end
			self.isTrigger = triggerInstanceId == self.me
			if not self.isTrigger then
				return
			end
			self.interactUniqueId = BehaviorFunctions.WorldNPCInteractActive(self.me,"激活")
			self.inActive = true
		end
	end	
end

--退出交互范围，移除交互列表
function Behavior8012002:ExitTrigger(triggerInstanceId,triggerEntityId,roleInstanceId)
	if self.isTrigger and triggerInstanceId == self.me then
		self.isTrigger = nil
		BehaviorFunctions.WorldInteractRemove(self.me,self.interactUniqueId)
	end
end

--脉灵激活:显示模型，播放动作，添加云特效，开启镜头
function Behavior8012002:MailingActive(npcId, mailingId)
	if npcId == self.npcId then
		BehaviorFunctions.WorldInteractRemove(self.me,self.interactUniqueId)
		self.isTrigger = nil
		self.isActive = true
		if self.HideEffect and not self.ShowEffect then
			BehaviorFunctions.RemoveEntity(self.HideEffect)
			self.HideEffect = nil
			self.ShowEffect = BehaviorFunctions.CreateEntity(801200102,self.me)
			--BehaviorFunctions.SetEntityShowState(self.me,true)
			if BehaviorFunctions.HasBuffKind(self.me,900000010) then
				BehaviorFunctions.RemoveBuff(self.me,900000010)
			end
			BehaviorFunctions.PlayAnimation(self.me,"Born")
			--local pos1 = BehaviorFunctions.GetPositionP(self.me)
            BehaviorFunctions.AddDelayCallByFrame(78, self,self.MailingCreateEntity, 801200201)  --延迟创建云特效
			--关卡相机
			local pos2 = BehaviorFunctions.GetPositionOffsetBySelf(self.me,5,0)
			self.levelCam = BehaviorFunctions.CreateEntity(80120011,nil,pos2.x,pos2.y,pos2.z)
			BehaviorFunctions.CameraEntityFollowTarget(self.levelCam,self.me,"CameraTarget")
			BehaviorFunctions.CameraEntityLockTarget(self.levelCam,self.me,"CameraTarget")
			BehaviorFunctions.SetEntityShowState(self.role,false)
			--延迟关闭相机
			BehaviorFunctions.AddDelayCallByFrame(90,BehaviorFunctions,BehaviorFunctions.RemoveEntity,self.levelCam)
			BehaviorFunctions.AddDelayCallByFrame(90,BehaviorFunctions,BehaviorFunctions.SetEntityShowState,self.role,true)
			--BehaviorFunctions.SetMailingCamera(self.npcId,0,0.5,0.27,0)
			BehaviorFunctions.AddDelayCallByFrame(self.showFrame,self,self.Assignment,"activeDone",true)
			BehaviorFunctions.AddDelayCallByFrame(self.showFrame,BehaviorFunctions,BehaviorFunctions.SetFightPanelVisible,"-1")
			BehaviorFunctions.AddDelayCallByFrame(self.showFrame,self,self.Assignment,"inActive",false)
			BehaviorFunctions.AddDelayCallByFrame(self.showFrame,BehaviorFunctions,BehaviorFunctions.SetCameraState,FightEnum.CameraState.Operating)
		end
	end
end

--脉灵交易完成：关闭界面
function Behavior8012002:MailingExchangeBeforeFinish(npcId,mailingId)
	if npcId == self.npcId then
		if self.isTrigger then
			BehaviorFunctions.WorldInteractRemove(self.me,self.interactUniqueId)
            BehaviorFunctions.AddDelayCallByFrame(40, BehaviorFunctions, BehaviorFunctions.RemoveEntity, self.FxCloud) 
			self.isTrigger = false
			self.canInteract = false
			self.finishing = true
		end
	end
end
--脉灵交易完成：遁地
function Behavior8012002:MailingExchangeFinish(npcId,mailingId)
	if npcId == self.npcId then
		BehaviorFunctions.RemoveEntity(self.me)
	end
end

--创建实体的函数
function Behavior8012002:MailingCreateEntity(entityId)
	mod.MailingCtrl:PlayMailingAnim(self.me, "Stand")  --临时接口，改脉灵的模型偏差
	self.FxCloud = BehaviorFunctions.CreateEntity(entityId, self.me)
end

--赋值
function Behavior8012002:Assignment(variable,value)
	self[variable] = value
	if variable == "myState" then
	end
end

--移除实体
function Behavior8012002:RemoveEntity(instanceId)
	if instanceId == self.me then
		if self.HideEffect  and BehaviorFunctions.CheckEntity(self.HideEffect) then
			BehaviorFunctions.RemoveEntity(self.HideEffect)
		end
	end
end