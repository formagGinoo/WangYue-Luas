RoleSelectTarget = BaseClass("RoleSelectTarget",EntityBehaviorBase)

local BF = BehaviorFunctions
local FE = FightEnum
local FK = FightEnum.KeyEvent

--角色目标选择判断
function RoleSelectTarget:Init()

	self.Me = self.instanceId	--记录自己
	--通用参数组合初始化
	self.RoleAllBehavior = self.ParentBehavior
	self.RoleAllParm = self.MainBehavior.RoleAllParm
	self.RAB = self.RoleAllBehavior
	self.RAP = self.RoleAllParm
	self.ScreenDownFrame = 0 	--本组合-屏幕点击判定帧数
	self.LastChangeTarget = 999	--本组合-上次切换角度
	self.AllTarget = {}
	self.AllTargetLockPart = 0
end


function RoleSelectTarget:Update(LockDistance,CancelLockDistance)
	
	--组合缩写
	self.RAP = self.RoleAllParm
	if BF.CheckEntityForeground(self.Me) then
		--锁定、备用目标相同，清除备用目标
		if self.RAP.LockTarget ~= 0 and self.RAP.LockTarget == self.RAP.LockAltnTarget then
			self:CleanTarget("LockAltnTarget")
		end
		--攻击、备用目标相同，清除备用目标
		if self.RAP.AttackTarget ~= 0 and self.RAP.AttackTarget == self.RAP.AttackAltnTarget then
			self:CleanTarget("AttackAltnTarget")
		end
		--常规搜索逻辑
		self:NormalSearch(LockDistance,CancelLockDistance)
		--Log("备用锁定点"..self.RAP.LockAltnTargetPoint.."    备用锁点目标"..self.RAP.LockAltnTarget
			--.."    锁定目标"..self.RAP.LockTarget.."    锁定点"..self.RAP.LockTargetPoint)
	end
	
	--当自身为当前操控角色时
	if self.RAP.CtrlRole == self.Me then
		--锁定时间结束，清除目标信息
		if self.RAP.CancelLockFrame < self.RAP.RealFrame and not BF.HasEntitySign(1,10000007) then
			self.RAP.CancelLockFrame = self.RAP.RealFrame - 1
			self:CleanTarget("LockTarget")
			self:CleanTarget("AttackTarget")
		end
		
		--滑动屏幕镜头移除锁定状态，清除目标信息
		if BF.CheckKeyPress(FK.ScreenPress) and BF.CheckKeyPress(FK.ScreenMove) 
			and (not BF.HasEntitySign(1,10000007) or BF.HasEntitySign(1,10000027)) then
			self.RAP.CancelLockFrame = self.RAP.RealFrame - 1
			self:CleanTarget("LockTarget")
			self:CleanTarget("AttackTarget")
		end
	end
end


--通用清除目标
function RoleSelectTarget:CleanTarget(Target)
	if Target == "AttackTarget" then
		self.RAP.AttackTarget = 0
		self.RAP.AttackTargetPoint = 0
		self.RAP.AttackTargetPart = 0
		self.RAP.AttackTargetState = 0
		self.RAP.AttackTargetDistance = 0
	end
	if Target == "AttackAltnTarget" then
		self.RAP.AttackAltnTarget = 0
		self.RAP.AttackAltnTargetPoint = 0
		self.RAP.AttackAltnTargetPart = 0
		self.RAP.AttackAltnTargetState = 0
		self.RAP.AttackAltnTargetDistance = 0
	end
	if Target == "LockTarget" then
		self.RAP.LockTarget = 0
		self.RAP.LockTargetPoint = 0
		self.RAP.LockTargetPart = 0
		self.RAP.LockTargetState = 0
		self.RAP.LockTargetDistance = 0
	end
	if Target == "LockAltnTarget" then
		self.RAP.LockAltnTarget = 0
		self.RAP.LockAltnTargetPoint = 0
		self.RAP.LockAltnTargetPart = 0
		self.RAP.LockAltnTargetDistance = 0
		self.RAP.LockAltnTargetState = 0
	end
end

--常规搜索目标逻辑
function RoleSelectTarget:NormalSearch(LockDistance,CancelLockDistance)
	--指定锁定目标获取标记判断
	if not BF.HasEntitySign(1,10000001) then
		--搜索实体、部位
		if BF.HasEntitySign(1,10000007) then --存在持续锁定按钮标记
			--搜索合集：半径999，角度0-360，阵营2，实体标签1(Npc)，存在buff无(0)，不存在buff1004(隐身类)，
			--距离权重1，角度权重1，Npc标签，检查锁定开启，头部射线开启，高度权重1，画面内权重1，部位锁定权重关闭，部位锁定权重开启
			self.AllTarget = BF.SearchEntities(self.Me,999,0,360,2,1,nil,1004,
				1,0.3,4,false,true,1,0.2,false,true)
		else
			--搜索合集：半径15，角度0-360，阵营2，实体标签1(Npc)，存在buff无(0)，不存在buff1004(隐身类)，
			--距离权重1，角度权重1，Npc标签，检查锁定开启，头部射线开启，高度权重1，画面内权重1，部位锁定权重关闭，部位锁定权重开启
			self.AllTarget = BF.SearchEntities(self.Me,LockDistance,0,360,2,1,nil,1004,
				1,0.3,nil,false,true,1,0.2,false,true)
		end
		--如果搜索合集不为空
		if next(self.AllTarget) then
			--存在搜索实体
			if BF.CheckEntity(self.AllTarget[1][1]) then
				if BF.HasEntitySign(self.AllTarget[1][1],10000024) then --强锁定怪物多部位切换判断标记
					local lock,attack,part = BF.SearchEntityPart(self.Me,self.AllTarget[1][1],999,0,360,1,0.3,false,1,0.2,false,true)
					--更新攻击备用目标、点、部位
					self.RAP.AttackAltnTarget = self.AllTarget[1][1]
					self.RAP.AttackAltnTargetPoint = attack
					self.RAP.AttackAltnTargetPart = part
				else
					--更新攻击备用目标、点、部位
					self.RAP.AttackAltnTarget = self.AllTarget[1][1]
					self.RAP.AttackAltnTargetPoint = self.AllTarget[1][3]
					self.RAP.AttackAltnTargetPart = self.AllTarget[1][4]
				end
				--如果当前部位能被锁定，更新锁定备用目标、点、部位
				if BF.CheckEntityPartLock(self.Me,self.AllTarget[1][4]) == true then
					self.RAP.LockAltnTarget = self.AllTarget[1][1]
					self.RAP.LockAltnTargetPoint = self.AllTarget[1][2]
					self.RAP.LockAltnTargetPart = self.AllTarget[1][4]
				else
					--否则搜索目标身上符合条件的锁定点、部位
					local lock,attack,part = BF.SearchEntityPart(self.Me,self.AllTarget[1][1],999,0,360,1,0.3,true,1,1,true,false)
					if lock then
						self.RAP.LockAltnTarget = self.AllTarget[1][1]
						self.RAP.LockAltnTargetPoint = lock
						self.RAP.LockAltnTargetPart = part
						--保底记录锁定目标、点、部位
					else
						self.RAP.LockAltnTarget = self.AllTarget[1][1]
						self.RAP.LockAltnTargetPoint = self.AllTarget[1][3]
						self.RAP.LockAltnTargetPart = self.AllTarget[1][4]
					end
				end
			end
		elseif self.AllTarget == {} then
			self:CleanTarget("AttackAltnTarget")
			self:CleanTarget("LockAltnTarget")
		end
	elseif BF.HasEntitySign(1,10000001) then
		self:CleanTarget("AttackTarget")
		self:CleanTarget("LockTarget")
		self:CleanTarget("AttackAltnTarget")
		self:CleanTarget("LockAltnTarget")
		self.RAP.AttackTarget = BF.GetEntityValue(self.Me,"AttackTarget")
		self.RAP.AttackTargetPoint = BF.GetEntityValue(self.Me,"AttackTargetPoint")
		self.RAP.AttackTargetPart = BF.GetEntityValue(self.Me,"AttackTargetPart")
		self.RAP.LockTarget = BF.GetEntityValue(self.Me,"LockTarget")
		self.RAP.LockTargetPoint = BF.GetEntityValue(self.Me,"LockTargetPoint")
		self.RAP.LockTargetPart = BF.GetEntityValue(self.Me,"LockTargetPart")
		self.RAP.AttackAltnTarget = BF.GetEntityValue(self.Me,"AttackAltnTarget")
		self.RAP.AttackAltnTargetPoint = BF.GetEntityValue(self.Me,"AttackAltnTargetPoint")
		self.RAP.AttackAltnTargetPart = BF.GetEntityValue(self.Me,"AttackAltnTargetPart")
		self.RAP.LockAltnTarget = BF.GetEntityValue(self.Me,"LockAltnTarget")
		self.RAP.LockAltnTargetPoint = BF.GetEntityValue(self.Me,"LockAltnTargetPoint")
		self.RAP.LockAltnTargetPart = BF.GetEntityValue(self.Me,"LockAltnTargetPart")
	end
	
	--锁定目标条件判断
	self.RAB.RoleLockTarget:LockTargetPart(CancelLockDistance)
	
	--锁定目标信息判断
	if self.RAP.LockTarget ~= 0 and BF.CheckEntity(self.RAP.LockTarget) and not BF.HasBuffKind(self.RAP.LockTarget,1004)
		then
		self.RAP.LockTargetState = BF.GetEntityState(self.RAP.LockTarget)
		self.RAP.LockTargetDistance = BF.GetDistanceFromTarget(self.Me,self.RAP.LockTarget)
		--检查距离因素
		if not BF.HeadRaySearch(self.Me,self.RAP.LockTarget) and not BF.HasEntitySign(1,10000007) then
			self:CleanTarget("LockTarget")
		end
	end
	
	--攻击目标信息判断
	if self.RAP.AttackTarget ~= 0 and BF.CheckEntity(self.RAP.AttackTarget) and not BF.HasBuffKind(self.RAP.AttackTarget,1004)
		 then
		self.RAP.AttackTargetState = BF.GetEntityState(self.RAP.AttackTarget)
		self.RAP.AttackTargetDistance = BF.GetDistanceFromTarget(self.Me,self.RAP.AttackTarget)
		--检查距离因素
		if (self.RAP.AttackTargetDistance > CancelLockDistance or not BF.HeadRaySearch(self.Me,self.RAP.AttackTarget))
			and not BF.HasEntitySign(1,10000007) then
			self:CleanTarget("AttackTarget")
		end
	else
		self:CleanTarget("AttackTarget")
	end
	--攻击备用目标信息判断
	if self.RAP.AttackAltnTarget ~= 0 and BF.CheckEntity(self.RAP.AttackAltnTarget) and not BF.HasBuffKind(self.RAP.AttackAltnTarget,1004)then
		self.RAP.AttackAltnTargetState = BF.GetEntityState(self.RAP.AttackAltnTarget)
		self.RAP.AttackAltnTargetDistance = BF.GetDistanceFromTarget(self.Me,self.RAP.AttackAltnTarget)
		--检查距离因素
		if (self.RAP.AttackAltnTargetDistance > LockDistance or not BF.HeadRaySearch(self.Me,self.RAP.AttackAltnTarget))
			and not BF.HasEntitySign(1,10000007) then
			self:CleanTarget("AttackAltnTarget")
		end
	else
		self:CleanTarget("AttackAltnTarget")
	end
	--锁定备用目标信息判断
	if self.RAP.LockAltnTarget ~= 0 and BF.CheckEntity(self.RAP.LockAltnTarget) and not BF.HasBuffKind(self.RAP.LockAltnTarget,1004)then
		self.RAP.LockAltnTargetState = BF.GetEntityState(self.RAP.LockAltnTarget)
		self.RAP.LockAltnTargetDistance = BF.GetDistanceFromTarget(self.Me,self.RAP.LockAltnTarget)
		--检查距离因素
		if (self.RAP.LockAltnTargetDistance > LockDistance or not BF.HeadRaySearch(self.Me,self.RAP.LockAltnTarget))
			and not BF.HasEntitySign(1,10000007) then
			self:CleanTarget("LockAltnTarget")
		end
	else
		self:CleanTarget("LockAltnTarget")
	end
end

function RoleSelectTarget:JoystickSearch(LockDistance,isLook)
	--锁定状态下有按键输入,则尝试向摇杆方向锁定目标，默认搜索距离5
	if self.RAP.LockTarget ~= 0 and self.RAP.LockTarget ~= nil and BF.CheckMove() and not BF.HasEntitySign(1,10000007) then
		local r = BF.GetMoveSignedAngle()
		--角度值需随摇杆操作逐步增加，距离判断增加
		local r1 = r - 30 	--搜索角度开始
		local r2 = r + 30 	--搜索角度结束
		if r2 > 360 then
			r2 = r2 - 360
		end
		if r1 < 0 then
			r1 = r1 + 360
		end
		local r3 = 0		--上一次角度与本次角度差值
		if self.LastChangeTarget ~= 999 and self.RAP.ChangeLockTargetFrame < self.RAP.RealFrame then
			r3 = self.LastChangeTarget - r
		else
			r3 = 0
		end

		local d = 0
		local T1 = {}
		if (r >= 30 and r < 90) or (r <= 330 and r > 270) then
			--搜索合集：半径LockDistance/2，角度，阵营2，实体标签1(Npc)，存在buff无(0)，不存在buff1004(隐身类)，
			--距离权重1，角度权重3，标签无，检查锁定关闭，头部射线开启，高度权重2，画面内权重1，部位锁定权重关闭，部位锁定权重开启
			T1 = BF.SearchEntities(self.Me,LockDistance/2,r1,r2,2,1,nil,1004,
				1,3,nil,false,true,2,0.5,false,true)
			d = 1		
		elseif (r >= 90 and r < 135) or (r <= 270 and r > 225) then
			T1 = BF.SearchEntities(self.Me,LockDistance/2,r1,r2,2,1,nil,1004,
				1,3,nil,false,true,2,0.5,false,true)
			d = 2
		elseif (r >= 135 and r <= 180) or (r <= 225 and r >= 180) then
			T1 = BF.SearchEntities(self.Me,LockDistance/2,r1,r2,2,1,nil,1004,
				1,3,nil,false,true,2,0.5,false,true)
			d = 3
		else
			T1 = BF.SearchEntities(self.Me,LockDistance/2,r1,r2,2,1,nil,1004,
				1,3,nil,false,true,2,0.5,false,true)
			d = 4
		end
		if next(T1) then
			if self.RAP.LockTarget ~= 0 and self.RAP.LockTarget ~= T1[1][1] and
				(self.RAP.ChangeLockTargetFrame < self.RAP.RealFrame or d == 3) then
				if isLook then
					--如果当前部位能被锁定，更新锁定备用目标、点、部位
					if BF.CheckEntityPartLock(self.Me,T1[1][4]) == true then
						self.RAP.LockTarget = T1[1][1]
						self.RAP.LockTargetPoint = T1[1][2]
						self.RAP.LockTargetPart = T1[1][4]
					else
						--否则搜索目标身上符合条件的锁定点、部位
						local lock,attack,part = BF.SearchEntityPart(self.Me,T1[1][1],15,0,360,1,1,true,1,1,true,false)
						if lock then
							self.RAP.LockTarget = T1[1][1]
							self.RAP.LockTargetPoint = lock
							self.RAP.LockTargetPart = part
							--保底记录锁定目标、点、部位
						else
							self.RAP.LockTarget = T1[1][1]
							self.RAP.LockTargetPoint = T1[1][3]
							self.RAP.LockTargetPart = T1[1][4]
						end
					end
				end
				self.RAP.AttackTarget = T1[1][1]
				self.RAP.AttackTargetPoint = T1[1][3]
				self.RAP.AttackTargetPart = T1[1][4]
				self.RAP.ChangeLockTargetFrame = self.RAP.RealFrame + 30
				self.LastChangeTarget = r
				if #T1 >= 2 then
					self.RAP.AttackAltnTarget = T1[1][1]
					self.RAP.AttackAltnTargetPoint = T1[1][3]
					self.RAP.AttackAltnTargetPart = T1[1][4]
				end
				return true
			end
		else
			return false
		end
	else
		return false
	end
end