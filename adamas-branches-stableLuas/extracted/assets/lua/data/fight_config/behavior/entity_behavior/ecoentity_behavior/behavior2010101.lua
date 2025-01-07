Behavior2010101 = BaseClass("Behavior2010101",EntityBehaviorBase)
--宝箱

function Behavior2010101.GetGenerates()
	local generates = {2010101}
	return generates
end

function Behavior2010101:Init()
	self.me = self.instanceId
	self.state = 0
	self.time = 0
	self.timestart = 0
	self.storyState = 0
	self.isHide = false
	self.lockState = 0
	self.LockStateEnum = {
		Default = 1,
		Locked = 2,
		Unlock = 3,
	}
	self.unLockEffectState = 0
	self.removeState = true
	self.brightEffectState = 0
	self.delayTime = 0.25 --延迟时间（爆金币，移除常驻特效）
	self.openTime = 2.5  --交互后开始溶解的时间
	self.dissolveTime = 2 --溶解持续时间
	self.guideDistance = 30 --指引距离
	self.canGuide = nil
	self.guideIcon = nil
end 

function Behavior2010101:Update()
	self.lockState = BehaviorFunctions.GetEntityValue(self.me,"lockState")
	self.isHide = BehaviorFunctions.GetEntityValue(self.me,"isHide")
	self.entityId = BehaviorFunctions.GetEntityTemplateId(self.me)
	self.time = BehaviorFunctions.GetFightFrame()/30
	self.role = BehaviorFunctions.GetCtrlEntity()
	--宝箱标记
	if not BehaviorFunctions.HasEntitySign(self.me,20000000) then
		BehaviorFunctions.AddEntitySign(self.me,20000000,-1)
	end
	
	--隐藏、显示；锁定、解锁切换
	if  self.state == 0 and BehaviorFunctions.CheckEntity(self.me) then
		if self.isHide == true and not BehaviorFunctions.HasBuffKind(self.me,900000010) then
			BehaviorFunctions.DoMagic(1,self.me,900000010)
		elseif 	(not self.isHide or self.isHide==false) and BehaviorFunctions.HasBuffKind(self.me,900000010) then
			if self.canGuide == nil then
				self.canGuide = true
			end
			BehaviorFunctions.RemoveBuff(self.me,900000010)
			BehaviorFunctions.CreateEntity(201010123,self.me) --宝箱出现特效
			--BehaviorFunctions.CreateEntity(20011,self.me)     --宝箱出现音效
		elseif not self.Lockeffect and self.lockState and self.lockState == self.LockStateEnum.Locked then
			self.Lockeffect = BehaviorFunctions.CreateEntity(201010121,self.me)
		elseif self.lockState and self.lockState == self.LockStateEnum.Unlock and self.Lockeffect then
			BehaviorFunctions.RemoveEntity(self.Lockeffect)
			self.Lockeffect = nil
			if self.unLockEffectState == 0 then
				BehaviorFunctions.DoEntityAudioPlay(self.role,"broken2",false)
				self.unLockEffect = BehaviorFunctions.CreateEntity(201010122,self.me)
				--BehaviorFunctions.CreateEntity(20011,self.me)     --宝箱出现音效
				if self.canGuide == nil then
					self.canGuide = true
				end
				self.unLockEffectState = 1
			end
		end
	end	
	--常驻发光特效
	if self.brightEffectState == 0 then
		if self.entityId and self.entityId == 2010101 then
			self.BrightEffect = BehaviorFunctions.CreateEntity(201010111,self.me)
			self.bottomEffect = BehaviorFunctions.CreateEntity(201010131,self.me)
		elseif self.entityId and self.entityId == 2010102 then
			self.BrightEffect = BehaviorFunctions.CreateEntity(201010112,self.me)
			self.bottomEffect = BehaviorFunctions.CreateEntity(201010132,self.me)
		elseif self.entityId and self.entityId == 2010103 then
			self.BrightEffect = BehaviorFunctions.CreateEntity(201010113,self.me)
			self.bottomEffect = BehaviorFunctions.CreateEntity(201010133,self.me)
		elseif self.entityId and self.entityId == 2010104 then
			self.BrightEffect = BehaviorFunctions.CreateEntity(201010114,self.me)
			self.bottomEffect = BehaviorFunctions.CreateEntity(201010134,self.me)
		end
		self.brightEffectState = 1
	end
	
	
	--延迟移除发光特效
	if self.state == 1 and self.time - self.timestart > self.delayTime then
		if self.BrightEffect then
			BehaviorFunctions.RemoveEntity(self.BrightEffect)
			BehaviorFunctions.RemoveEntity(self.bottomEffect)
			BehaviorFunctions.DoMagic(1,self.role,900000011) --震屏magic
			BehaviorFunctions.InteractEntityHit(self.me,FightEnum.SysEntityOpType.Collect,true)--后端交互
			self.bottomEffect = nil
			self.BrightEffect = nil
		end
	end
	
	
	--溶解和移除
	if self.state == 1 and self.time - self.timestart > self.openTime  and BehaviorFunctions.CheckEntity(self.me) then
		--开始溶解
		if self.openEffect  then
			BehaviorFunctions.RemoveEntity(self.openEffect)
			self.openEffect = nil
		end
		BehaviorFunctions.CreateEntity(200000105,self.me) --溶解
		self.timestart = self.time
		self.state = 2
	elseif self.state == 2 and self.time - self.timestart > self.dissolveTime and self.canRemove and BehaviorFunctions.CheckEntity(self.me) then
		BehaviorFunctions.RemoveEntity(self.me)
		self.state = 999
	end
	
	--guideIcon显示
	if self.canGuide and BehaviorFunctions.CheckEntity(self.me) then
		if  BehaviorFunctions.GetDistanceFromTarget(self.me,self.role) <= self.guideDistance and self.guideIcon == nil then
			self.guideIcon = BehaviorFunctions.AddEntityGuidePointer(self.me,FightEnum.GuideType.TreasureBox,1.2)
		elseif BehaviorFunctions.GetDistanceFromTarget(self.me,self.role) > self.guideDistance and self.guideIcon then
			BehaviorFunctions.RemoveEntityGuidePointer(self.guideIcon)
			self.guideIcon = nil
		end
	end
end

function Behavior2010101:WorldInteractClick(uniqueId, instanceId)
	if instanceId ~= self.me then
		return
	end
	if self.interactUniqueId and self.interactUniqueId == uniqueId then
		if self.canGuide and self.guideIcon then
			self.canGuide = nil
			BehaviorFunctions.RemoveEntityGuidePointer(self.guideIcon)
			self.guideIcon = nil
		end
		if self.state == 0 then
			BehaviorFunctions.PlayAnimation(self.me,"Open")
			if self.entityId and self.entityId == 2010101 then
				self.openEffect = BehaviorFunctions.CreateEntity(201010101,self.me)
			elseif self.entityId and self.entityId == 2010102 then
				self.openEffect = BehaviorFunctions.CreateEntity(201010102,self.me)
			elseif self.entityId and self.entityId == 2010103 then
				self.openEffect = BehaviorFunctions.CreateEntity(201010103,self.me)
			elseif self.entityId and self.entityId == 2010104 then
				self.openEffect = BehaviorFunctions.CreateEntity(201010104,self.me)
			end
			BehaviorFunctions.WorldInteractRemove(self.me,self.interactUniqueId)
			--临时用一个音效
			BehaviorFunctions.DoEntityAudioPlay(self.role,"QingmenyinR31M11_Atk013")
			self.removeState = nil
			self.timestart =self.time
			self.state = 1		
		end
		if self.storyState == 0 and (BehaviorFunctions.CheckTaskId(200100102) or BehaviorFunctions.CheckTaskId(200100103))then
			BehaviorFunctions.StartStoryDialog(9001)
			self.storyState = 1
		end
	end
end

function Behavior2010101:EnterTrigger(triggerInstanceId,triggerEntityId,roleInstanceId)
	if self.isTrigger 
		or self.isHide
		or self.lockState ==  self.LockStateEnum.Locked then
		return
	end
	self.isTrigger = triggerInstanceId == self.me
	if not self.isTrigger then
		return
	end	
	if self.entityId and self.entityId == 2010101 then
		self.interactUniqueId = BehaviorFunctions.WorldInteractActive(self.me,WorldEnum.InteractType.Chest,nil,"雀铜宝藏",1)
	elseif self.entityId and self.entityId == 2010102 then
		self.interactUniqueId = BehaviorFunctions.WorldInteractActive(self.me,WorldEnum.InteractType.Chest,nil,"燕铁宝藏",1)
	elseif self.entityId and self.entityId == 2010103 then
		self.interactUniqueId = BehaviorFunctions.WorldInteractActive(self.me,WorldEnum.InteractType.Chest,nil,"鹰银宝藏",1)
	elseif self.entityId and self.entityId == 2010104 then
		self.interactUniqueId = BehaviorFunctions.WorldInteractActive(self.me,WorldEnum.InteractType.Chest,nil,"鹤金宝藏",1)
	end
end

function Behavior2010101:ExitTrigger(triggerInstanceId,triggerEntityId,roleInstanceId)
	if self.isTrigger and triggerInstanceId == self.me and self.removeState then
		self.isTrigger = false
		BehaviorFunctions.WorldInteractRemove(self.me,self.interactUniqueId)
	end
end

function Behavior2010101:EntityHitEnd(instanceId)
	if instanceId == self.me  then
		self.canRemove = true
	end
end


function Behavior2010101:RemoveEntity(instanceId)
	if instanceId == self.me  then
		if BehaviorFunctions.HasBuffKind(self.me,900000010) then
			BehaviorFunctions.RemoveBuff(self.me,900000010)
		end
		--移除常驻特效
		if self.BrightEffect and BehaviorFunctions.CheckEntity(self.BrightEffect) then
			BehaviorFunctions.RemoveEntity(self.BrightEffect)
		end
		--移除底部特效
		if self.bottomEffect and BehaviorFunctions.CheckEntity(self.bottomEffect) then
			BehaviorFunctions.RemoveEntity(self.bottomEffect)
		end
		--移除锁定常驻特效
		if self.Lockeffect and BehaviorFunctions.CheckEntity(self.Lockeffect) then
			BehaviorFunctions.RemoveEntity(self.Lockeffect)
		end

	end
end