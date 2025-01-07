RoleLockTarget = BaseClass("RoleLockTarget",EntityBehaviorBase)

local BF = BehaviorFunctions
local FE = FightEnum
local FES = FightEnum.EntityState

--角色目标选择判断
function RoleLockTarget:Init()

	self.Me = self.instanceId	--记录自己
	--通用参数组合初始化
	self.RoleAllBehavior = self.ParentBehavior
	self.RoleAllParm = self.MainBehavior.RoleAllParm
	self.RAB = self.RoleAllBehavior
	self.RAP = self.RoleAllParm
	self.LevelUiTarget = 0
end

function RoleLockTarget:Update(LockDistance,CancelLockDistance)
	
	--组合缩写
	self.RAP = self.RoleAllParm
	if self.RAP.CtrlRole == self.Me and BF.CheckEntityForeground(self.Me) then
		--锁定目标判断
		self:LockTargetPart(CancelLockDistance)
		
		--存在目标帧事件标记
		if (BF.CheckEntity(self.RAP.LockTarget) or BF.CheckEntity(self.RAP.AttackTarget) 
			or BF.CheckEntity(self.RAP.AttackAltnTarget) or BF.CheckEntity(self.RAP.LockAltnTarget)) and not BF.CheckSkillEventActiveSign(self.Me,10000001) then
			BF.AddSkillEventActiveSign(self.Me,10000001) --存在目标技能帧事件标记
		elseif not BF.CheckEntity(self.RAP.LockTarget) and not BF.CheckEntity(self.RAP.AttackTarget) and not BF.CheckEntity(self.RAP.AttackAltnTarget) 
			and not BF.CheckEntity(self.RAP.LockAltnTarget) and BF.CheckSkillEventActiveSign(self.Me,10000001) then
			BF.RemoveSkillEventActiveSign(self.Me,10000001)
		end
		
		local CameraType = BF.GetCameraState()
		
		--弱锁定情况下锁定时间结束，战斗镜头切换为操作镜头的统一出口
		if (CameraType == 2 or CameraType == 99 ) and self.RAP.CancelLockFrame < self.RAP.RealFrame and not BF.HasEntitySign(1,600000010) then
			BF.SetLockTarget()
			BF.RemoveAllLookAtTarget()
			BF.AddLookAtTarget(self.Me,"CameraTarget")
			BF.SetCameraState(FightEnum.CameraState.Operating)
			self.RAP.CameraType = 1 --操作镜头类型
			self.RAB.RoleSelectTarget:CleanTarget("LockTarget")
		end
		
		--无锁定目标时
		if self.RAP.LockTarget == 0 then
			--清除锁定目标
			if self.RAP.CameraType == 3 then
				BF.SetLockTarget()
				BF.RemoveAllLookAtTarget()
				BF.AddLookAtTarget(self.Me,"CameraTarget")
			end
			
			
			--操作时间未结束，切换到操作镜头
			if self.RAP.CameraType ~= 1 and self.RAP.CameraType ~= 4 and not BF.HasEntitySign(1,600000010) and BF.GetCameraState() ~= FightEnum.CameraState.ForceLocking then
				--佩从临时相机逻辑
				BF.RemoveAllLookAtTarget()
				BF.AddLookAtTarget(self.Me,"CameraTarget")
				--佩从临时相机逻辑
				BF.SetCameraState(FightEnum.CameraState.Operating)
				BF.SetLockTarget()
				self.RAP.CameraType = 1 --操作镜头类型
			----操作时间结束，切换到聚焦镜头
			--elseif self.RAP.FocusCameraChangeFrame < self.RAP.RealFrame and self.RAP.CameraType ~= 2 then
				--BF.SetCameraState(FightEnum.CameraState.Focus)
				--self.RAP.CameraType = 2 --聚焦镜头类型
			end
		end
		
		--关卡清除UI目标判断
		if BF.HasEntitySign(1,10000021) then
			if BF.HasEntitySign(1,10000020) then
				BF.RemoveEntitySign(1,10000020)
			end
			self.RAP.UITargetCancelFrame = self.RAP.RealFrame - 1
			BF.RemoveEntitySign(1,10000021)
		end
		
		--关卡UI目标判断
		if BF.HasEntitySign(1,10000020) then --存在关卡设置目标标记
			self.LevelUiTarget = BF.GetEntityValue(1,"LevelUiTarget")
			if BF.CheckEntity(self.LevelUiTarget) then
				self.RAP.UiTarget = self.LevelUiTarget
				--Log(self.UiTarget)
				self.RAP.UITargetCancelFrame = self.RAP.RealFrame + 90
				BF.SetFightUITarget(self.RAP.UiTarget)
			end
		else
			if self.RAP.UiTarget == self.LevelUiTarget then
				self.LevelUiTarget = 0
			end
			self.RAP.UiTarget = 0
		end
		
		--敌人UI显隐判断	
		if self.RAP.UiTarget ~= 0 and self.RAP.UITargetCancelFrame > self.RAP.RealFrame then
			if BF.CheckEntity(self.RAP.UiTarget) and BF.HasEntitySign(1,10000007) then --存在持续锁定标记
				BF.SetFightUITarget(self.RAP.UiTarget)
			end
		elseif self.RAP.UITargetCancelFrame < self.RAP.RealFrame then
			self.RAP.UiTarget = 0
			self.RAP.UITargetCancelFrame = 0
			BF.SetFightUITarget()
		end
	end
	
	--切换战斗待机判断，休闲待机切换帧数 > 世界帧数
	if BF.CheckEntityForeground(self.Me) then
		if self.RAP.LeisurelyIdleChangeFrame > self.RAP.RealFrame and not BF.CheckIdleState(self.Me,FightEnum.EntityIdleType.FightIdle) 
			and BF.CanCtrl(self.Me) then
			BF.SetIdleType(self.Me,FightEnum.EntityIdleType.FightIdle) --战斗待机
		elseif self.RAP.LeisurelyIdleChangeFrame <= self.RAP.RealFrame and BF.CheckIdleState(self.Me,FightEnum.EntityIdleType.FightIdle) 
			and BF.CanCtrl(self.Me) then
			BF.SetIdleType(self.Me,FightEnum.EntityIdleType.FightToLeisurely) --战斗切休闲（待机状态）
		end
	end
end

--UI目标死亡判断 / 自身死亡判断
function RoleLockTarget:Die(attackInstanceId,dieInstanceId)

	if BF.CheckEntityForeground(self.Me) then
		if dieInstanceId == self.RAP.UiTarget then
			self.RAP.UITargetCancelFrame = self.RAP.RealFrame + 30 --延迟取消敌方UI显示
		end
		--if dieInstanceId == self.Me then
			--self.RAP.UITargetCancelFrame = self.RAP.RealFrame -1
			--self.RAP.UiTarget
		--end
		if dieInstanceId == self.Me and BF.CheckLockTarget(self.Me) then
			self.Role2 = BF.GetQTEEntity(2)
			self.Role3 = BF.GetQTEEntity(3)
			if not BF.CheckEntity(self.Role2) and not BF.CheckEntity(self.Role3) then
				BF.RemoveAllLookAtTarget()
				BF.AddLookAtTarget(self.Me,"CameraTarget")
				BF.SetCameraState(FightEnum.CameraState.Operating)
				BF.SetLockTarget()
				self.RAP.CameraType = 1 --操作镜头类型
			end
		end
	end
end

--受击时锁定不移除
function RoleLockTarget:Hit(attackInstanceId,hitInstanceId,hitType)
	if hitInstanceId == self.Me and self.Me == self.RAP.CtrlRole then
		if BF.HasEntitySign(1,10000007) and BF.CheckEntity(self.RAP.UiTarget) then
			self:UiTargetPart(attackInstanceId)
		else
			self:UiTargetPart(0)
		end
	end
end

--锁定目标判断
function RoleLockTarget:LockTargetPart(CancelLockDistance)
	--有锁定目标
	if BF.CheckEntity(self.RAP.LockTarget) then
		self.RAP.LockTargetState = BF.GetEntityState(self.RAP.LockTarget)
		self.RAP.LockTargetDistance = BF.GetDistanceFromTarget(self.Me,self.RAP.LockTarget)
		--如果锁定目标没有隐身，且在移除范围之内，或者处于强锁定状态，每帧设置其为镜头的锁定目标
		if not BF.HasBuffKind(self.RAP.LockTarget,1004) and (self.RAP.LockTargetDistance < CancelLockDistance or BF.HasEntitySign(1,10000007)) then
			if not BF.HasEntitySign(1,10000002) then
				BF.SetLockTarget(self.RAP.LockTarget,"CameraTarget",self.RAP.LockTargetPoint)
			end
			if BF.HasEntitySign(1,10000007) then
				BF.SetLockTarget(self.RAP.LockTarget,self.RAP.LockTargetPoint,self.RAP.LockTargetPoint)
				if not BF.CheckLockTarget() or self.RAP.CameraType ~= 3 then
					BF.SetLockTarget(self.RAP.LockTarget,self.RAP.LockTargetPoint,self.RAP.LockTargetPoint)
					if self.RAP.MyState ~= FES.Aim then
						BF.SetCameraState(FE.CameraState.ForceLocking)
						self.RAP.CameraType = 3 --锁定镜头类型
						self.RAP.CancelLockFrame = self.RAP.RealFrame + 99999
					end
				end
			end
		--有锁定目标但超出锁定距离且没有强锁实体标记，或存在免疫锁定BUFF类型1004，清除锁定目标
		elseif (self.RAP.LockTargetDistance > CancelLockDistance and not BF.HasEntitySign(1,10000007)) or BF.HasBuffKind(self.RAP.LockTarget,1004) then
			if self.RAP.CameraType == 2 or self.RAP.CameraType == 3 then
				BF.SetLockTarget()
				BF.SetCameraState(FE.CameraState.Operating)
				self.RAP.CameraType = 1 --操作镜头类型
			end
			self.RAB.RoleSelectTarget:CleanTarget("LockTarget")
		end
	--没有锁定目标
	elseif self.RAP.LockTarget == 0 or not BF.CheckEntity(self.RAP.LockTarget) then
		self.RAB.RoleSelectTarget:CleanTarget("LockTarget")
	end
end

--UI目标设置部分
function RoleLockTarget:UiTargetPart(InstanceId)
	if BF.CheckEntity(self.RAP.LockTarget) and InstanceId == self.RAP.LockTarget and not BF.HasEntitySign(InstanceId,10000031)then
		if BF.CheckEntity(InstanceId) and BF.HasEntitySign(1,10000007) then
			self.RAP.UITargetCancelFrame = self.RAP.RealFrame + 99999 --延迟取消敌方UI显示
			self.RAP.CancelLockFrame = self.RAP.RealFrame + 90 --设置移除锁定镜头延迟时间
		else
			self.RAP.UITargetCancelFrame = self.RAP.RealFrame + 30
			self.RAP.CancelLockFrame = self.RAP.RealFrame
		end
		self.RAP.LeisurelyIdleChangeFrame = self.RAP.RealFrame + 150 --休闲待机切换倒计时
	elseif InstanceId ~= self.RAP.LockTarget and BF.CheckEntity(InstanceId) and BF.HasEntitySign(1,10000007) 
		and not BF.HasEntitySign(InstanceId,10000031) then
		self.RAP.UiTarget = InstanceId
		self.RAP.UITargetCancelFrame = self.RAP.RealFrame + 99999
		BF.SetFightUITarget(InstanceId)
	end
end