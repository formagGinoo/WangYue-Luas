RoleCatchSkill = BaseClass("RoleCatchSkill",EntityBehaviorBase)

local BF = BehaviorFunctions
local FES = FightEnum.EntityState
local FK = FightEnum.KeyEvent
local FE = FightEnum
local FEEBS = FightEnum.EntityBuffState

--角色释放技能组合（重写可复制至最多3个，同时执行3种行为）
function RoleCatchSkill:Init()

	self.Me = self.instanceId	--记录自己
	--通用参数组合初始化

	self.RAB = self.ParentBehavior
	self.RAP = self.MainBehavior.RoleAllParm
end

function RoleCatchSkill:Update()

	self:ClickSkillPart()	--点击按钮释放技能判断部分
end

function RoleCatchSkill:ClickSkillPart()
	--检查按键缓存
	local ClickButton = 0
	if self.RAP.ClickButton[1] ~= 0 and self.RAP.ClickButton[1] ~= nil then
		ClickButton = 1
	elseif self.RAP.ClickButton[2] ~= 0 and self.RAP.ClickButton[1] ~= nil then
		ClickButton = 2
	elseif self.RAP.ClickButton[3] ~= 0 and self.RAP.ClickButton[1] ~= nil then
		ClickButton = 3
	end
	
	if (ClickButton == 1 or ClickButton == 2 or ClickButton == 3) and BF.CheckEntityForeground(self.Me) then
		--进行跳跃流程
		if self.RAP.ClickButton[ClickButton] == FK.Jump then
			if BF.DoJump(self.Me) then
				self:ClearButtonPart(ClickButton,"ClearClick")
			end
		--大招释放判断
		elseif self.RAP.ClickButton[ClickButton] == FK.UltimateSkill then
			--通用主动型技能释放判断
			if self:ActiveSkill(ClickButton,self.MainBehavior.UltimateSkill[1],5,3,0,0,0,{0},"Immediately","ClearClick",true,0,-1) then
				BF.CastSkillCost(self.Me,self.MainBehavior.UltimateSkill[1],0)
			end
		--闪避释放判断
		elseif self.RAP.ClickButton[ClickButton] == FK.Dodge then
			--通用闪避技能释放判断：按钮、技能优先级、(打断优先、技能窗口)、（实体标记条件、Buff类型条件)、打断受击集
			if self:MoveSkill(ClickButton,3,3,0,0,0,{0},"ClearClick") then
				BF.CastSkillCost(self.Me,self.MainBehavior.MoveSkill[1])
			end
		--核心技能释放判断
		elseif self.RAP.ClickButton[ClickButton] == FK.Partner then
			--通用主动型技能释放判断
			if self:ActiveSkill(ClickButton,6,self.MainBehavior.Core[1],5,0,0,0,{-1},"Immediately","ClearClick",true,0,-1) then
				BF.CastSkillCost(self.Me,self.MainBehavior.Core[1])
			end
		--普通技能释放判断
		elseif self.RAP.ClickButton[ClickButton] == FK.NormalSkill then
			if self:ContSkill(ClickButton,self.MainBehavior.NormalSkill,2,2,10000001,0,0,{0},"Immediately","ClearClick",true,0,-1) then
				BF.CastSkillCost(self.Me,self.MainBehavior.NormalSkill[1])
			end
		--普攻释放判断
		elseif self.RAP.ClickButton[ClickButton] == FK.Attack then
			----闪避反击释放判断
			--if BF.HasEntitySign(self.Me,10000000) and BF.GetSkillSign(self.Me,10000000) then
				--if self:ActiveSkill(ClickButton,2,self.DodgeCounter[1],2,0,10000000,0,{0},"Immediately","ClearClick",true,0,-1) then
					--BF.RemoveEntitySign(self.Me,10000000)
				--end
			--通用普攻释放判断
			if self.RAP.ClickButton[ClickButton] == FK.Attack and BF.CheckEntityHeight(self.Me) == 0 and self.RAP.MyState ~= FES.Aim
			and ((not BF.GetSkillSign(self.Me,10000002) and not BF.CheckKeyPress(FK.Attack)) or BF.GetSkillSign(self.Me,10000002)) then
				--self:ContSkill(ClickButton,self.MainBehavior.NormalAttack,1,1,10000002,0,0,{0},"Lerp","ClearClick",true,0,-1)
			end
		end
	end
end


--通用连段技能释放判断：按钮、技能Id集、技能优先级、打断优先、(技能衔接窗口)、(实体标记条件、Buff类型条件)、
	--打断受击集、朝向类型、清理按键缓存类型、检查摇杆、原地释放Y轴偏移,释放距离限制
--示例：RoleCatchSkill:ContSkill(1,self.AttackId,1,1,10000001,0,0,{0},"Lerp"/"Immediately","ClearPress"/"ClearClick/ClearAll",false,0)
function RoleCatchSkill:ContSkill(Button,Skill,SkillPriority,BreakPriority,SkillSign,EntitySign,BuffKind,HitType,LookAtType,ClearType,isJoystick,Yoffset,CastDistance)

	local ContSkill = 0
	--非战斗/受击时/技能且有实体标记、Buff类型时
	if BF.CanCastSkill(self.Me) or (self:HitTypePart(HitType) == true and not BF.CheckBuffState(self.Me,FEEBS.Stun)
			and not BF.CheckBuffState(self.Me,FEEBS.PauseTime))
		or (BF.CheckEntityState(self.Me,FES.Skill) and ((EntitySign == 0 and BuffKind == 0) 
				or BF.HasEntitySign(self.Me,EntitySign) or BF.HasBuffKind(self.Me,BuffKind))) then
		--优先从高往低段数判断普攻Id
		for i = 1, #Skill, 1  do
			--非第1段释放判定，检查当前技能Id、最大连段数、连段技能窗口
			if i >= 2 and self.RAP.CurrentSkill == Skill[i-1] and BF.GetSkillSign(self.Me,SkillSign) then
				if BF.CheckEntityState(self.Me,FES.Skill) then
					BF.BreakSkill(self.Me)
				end
				ContSkill = Skill[i]
				break
			--选择普攻第1段Id
			elseif i == 1 and not BF.GetSkillSign(self.Me,SkillSign) and (BF.CanCastSkill(self.Me) 
					or (BF.CheckEntityState(self.Me,FES.Skill) and self.RAP.CurrentSkillPriority < BreakPriority)) then
				if BF.CheckEntityState(self.Me,FES.Skill) then
					BF.BreakSkill(self.Me)
				end
				ContSkill = Skill[1]
				break
			end
		end
		--筛选普攻Id后
		if ContSkill ~= 0 then
			self:CatchSkillPart(ContSkill,LookAtType,SkillPriority,Button,ClearType,isJoystick,Yoffset,CastDistance)
			return true
		end
	end
end

--通用被动型技能释放判断：按钮、技能Id、清理按键缓存类型
--示例：RoleCatchSkill:PasvSkill(1,BlueSkill[1],"ClearPress"/"ClearClick/ClearAll")
function RoleCatchSkill:PasvSkill(Button,Skill,ClearType,isJoystick)
	--self:TargetPart(true,isJoystick)
	----尝试锁定目标
	--if not BF.CheckLockTarget() and self.RAP.CtrlRole == self.Me and self.RAP.LockTarget ~= 0 
		--and self.RAP.LockTarget ~= nil then
		--BF.SetLockTarget(self.RAP.LockTarget,self.RAP.LockTargetPart)
	--end
	--释放被动型技能
	BF.CastPasv(self.Me,Skill)
	self:ClearButtonPart(Button,ClearType)
	--self.RAP.CancelLockFrame = self.RAP.RealFrame + 5 --移除锁定镜头延迟时间
	return true
end

--通用主动型技能释放判断：按钮、技能Id、技能优先级、(打断优先、技能窗口)、（实体标记条件、Buff类型条件)、
	--打断受击集、朝向类型、清理按键缓存类型、检查摇杆、原地释放Y轴偏移，释放距离限制
--示例：RoleCatchSkill:ActiveSkill(1,self.SkillId,2,2,0,0,0,{0},"Lerp"/"Immediately","ClearPress"/"ClearClick/ClearAll",true,0)
function RoleCatchSkill:ActiveSkill(Button,Skill,SkillPriority,BreakPriority,SkillSign,EntitySign,BuffKind,HitType,LookAtType,ClearType,isJoystick,Yoffset,CastDistance)

	--释放条件判断，可以放技能/当前技能可以打断
	if BF.CanCastSkill(self.Me) or (self:HitTypePart(HitType) == true and not BF.CheckBuffState(self.Me,FEEBS.Stun)
			and not BF.CheckBuffState(self.Me,FEEBS.PauseTime))
		 or (BF.CheckEntityState(self.Me,FES.Skill)
			and (self.RAP.CurrentSkillPriority < BreakPriority or BF.GetSkillSign(self.Me,SkillSign)) 
			and ((EntitySign == 0 and BuffKind == 0) or BF.HasEntitySign(self.Me,EntitySign) or BF.HasBuffKind(self.Me,BuffKind))) then

		--打断上一技能判断
		if BF.CheckEntityState(self.Me,FES.Skill)
			and (self.RAP.CurrentSkillPriority < BreakPriority or BF.GetSkillSign(self.Me,SkillSign)) then
			BF.BreakSkill(self.Me)
		end
		self:CatchSkillPart(Skill,LookAtType,SkillPriority,Button,ClearType,isJoystick,Yoffset,CastDistance)
		return true
	end
end

--通用闪避技能释放判断：按钮、技能优先级、(打断优先、技能窗口)、(实体标记条件、Buff类型条件)、清理按键缓存类型
--示例：RoleCatchSkill:MoveSkill(1,3,3,0,0,0,{0},"Lerp"/"Immediately","ClearPress"/"ClearClick/ClearAll")
function RoleCatchSkill:MoveSkill(Button,SkillPriority,BreakPriority,SkillSign,EntitySign,BuffKind,HitType,ClearType)
	--释放条件判断，可以放技能/当前技能可以打断
	if BF.CanCastSkill(self.Me) or (self:HitTypePart(HitType) == true and not BF.CheckBuffState(self.Me,FEEBS.Stun)
			and not BF.CheckBuffState(self.Me,FEEBS.PauseTime))
		or (BF.CheckEntityState(self.Me,FES.Skill) 
			and (self.RAP.CurrentSkillPriority < BreakPriority or BF.GetSkillSign(self.Me,SkillSign))
			and ((EntitySign == 0 and BuffKind == 0) or BF.HasEntitySign(self.Me,EntitySign) or BF.HasBuffKind(self.Me,BuffKind))) then

		--打断上一技能判断
		if BF.CheckEntityState(self.Me,FES.Skill) 
			and (self.RAP.CurrentSkillPriority < BreakPriority or BF.GetSkillSign(self.Me,SkillSign)) then
			BF.BreakSkill(self.Me)
		end
		--摇杆操作判断、记录摇杆方向
		if self.RAP.JoystickPosX ~= 0 and self.RAP.JoystickPosZ ~= 0 then
			BF.DoLookAtPositionImmediately(self.Me,self.RAP.JoystickPosX,self.RAP.MyPos.y,self.RAP.JoystickPosZ)
			BF.CastSkillByPosition(self.Me, self.MainBehavior.MoveSkill[1], self.RAP.JoystickPosX, self.RAP.MyPos.y, self.RAP.JoystickPosZ)
		else
			BF.CastSkillBySelfPosition( self.Me,self.MainBehavior.MoveSkill[2])
			self.RAP.LeisurelyIdleChangeFrame = self.RAP.RealFrame + 150
		end
		--记录技能优先级
		self.RAP.CurrentSkillPriority = SkillPriority
		self:ClearButtonPart(Button,ClearType)
		return true
	end
end

--通用技能释放部分
	--技能id、朝向类型、技能优先级、按钮、清理按键缓存类型、检查摇杆、原地释放Y轴偏移，释放距离限制
function RoleCatchSkill:CatchSkillPart(Skill,LookAtType,SkillPriority,Button,ClearType,isJoystick,Yoffset,CastDistance)
	self:TargetPart(true,isJoystick)
	--存在攻击目标，则向目标释放技能
	if BF.CheckEntity(self.RAP.AttackTarget) and self:CastDistancePart(CastDistance) == true then
		if LookAtType == "Immediately" then
			--判断怪物存在多部位锁定实体标记
			--BehaviorFunctions.AddEntitySign(4,10000022,-1)
			if BF.HasEntitySign(self.RAP.AttackTarget,10000022) then
				BF.DoLookAtTargetImmediately(self.Me,self.RAP.AttackTarget,self.RAP.AttackTargetPoint)
				--Log(self.RAP.AttackTargetPoint)
			elseif not BF.HasEntitySign(self.RAP.AttackTarget,10000022) then
				BF.DoLookAtTargetImmediately(self.Me,self.RAP.AttackTarget)
			end
		--elseif LookAtType == "Lerp" then
			--BF.DoLookAtTargetByLerp(self.Me,self.RAP.AttackTarget,true,0,0,0.05) --暂时使用-2：朝向成功1次后停止
		end
		BF.CastSkillByTarget(self.Me,Skill,self.RAP.AttackTarget)
		----尝试锁定目标
		--if not BF.CheckLockTarget() and self.RAP.CtrlRole == self.Me and self.RAP.LockTarget ~= 0
			--and self.RAP.LockTarget ~= nil then
			--BF.SetLockTarget(self.RAP.LockTarget,self.RAP.LockTargetPart)
		--end
	--如果有摇杆输出入，则向摇杆方向释放技能
	elseif not BF.CheckEntity(self.RAP.AttackTarget) and self.RAP.JoystickPosX ~= 0 and self.RAP.JoystickPosZ ~= 0 then
		if LookAtType == "Lerp" then
			BF.DoLookAtPositionByLerp(self.Me,self.RAP.JoystickPosX,self.RAP.MyPos.y,self.RAP.JoystickPosZ,true,0,0)
		elseif LookAtType == "Immediately" then
			BF.DoLookAtPositionImmediately(self.Me,self.RAP.JoystickPosX,self.RAP.MyPos.y,self.RAP.JoystickPosZ)
		end
		BF.CastSkillByPosition(self.Me,Skill,self.RAP.JoystickPosX, self.RAP.MyPos.y, self.RAP.JoystickPosZ)
	--不存在攻击目标，则原地释放技能
	elseif Yoffset ~= nil then
		BF.CastSkillByPosition(self.Me,Skill,self.RAP.MyFrontPos.x,self.RAP.MyFrontPos.y+Yoffset,self.RAP.MyFrontPos.z)
	else
		BF.CastSkillByPosition(self.Me,Skill,self.RAP.MyFrontPos.x,self.RAP.MyFrontPos.y,self.RAP.MyFrontPos.z)
	end
	self.RAP.CurrentSkillPriority = SkillPriority
	self:ClearButtonPart(Button,ClearType)
end

--通用目标部分
function RoleCatchSkill:TargetPart(isLock,isJoystick)
	--目标判定
	if isJoystick == true and self.RAB.RoleSelectTarget:JoystickSearch(self.MainBehavior.LockDistance,true) then
		
	--10000024为BOSS强锁定期间可以切换部位标记
	else
		if not BF.CheckEntity(self.RAP.AttackTarget) then
			if BF.CheckEntity(self.RAP.AttackAltnTarget) then
				self.RAP.AttackTarget = self.RAP.AttackAltnTarget
				self.RAP.AttackTargetPoint = self.RAP.AttackAltnTargetPoint
				self.RAP.AttackTargetPart = self.RAP.AttackAltnTargetPart
			end
		elseif BF.CheckEntity(self.RAP.AttackTarget) and BF.HasEntitySign(1,10000007) 
			and BF.HasEntitySign(self.RAP.AttackTarget,10000024) then
			if self.RAP.AttackTarget == self.RAP.AttackAltnTarget then
				self.RAP.AttackTargetPoint = self.RAP.AttackAltnTargetPoint
				self.RAP.AttackTargetPart = self.RAP.AttackAltnTargetPart
			end
		end
		if isLock == true and (not BF.CheckEntity(self.RAP.LockTarget) or self.RAP.LockTarget == 0) then
			if BF.CheckEntity(self.RAP.LockAltnTarget) then
				self.RAP.LockTarget = self.RAP.LockAltnTarget
				self.RAP.LockTargetPoint = self.RAP.LockAltnTargetPoint
				self.RAP.LockTargetPart = self.RAP.LockAltnTargetPart
			elseif BF.CheckEntity(self.RAP.AttackTarget) then
				self.RAP.LockTarget = self.RAP.AttackTarget
				self.RAP.LockTargetPoint = self.RAP.AttackTargetPoint
				self.RAP.LockTargetPart = self.RAP.AttackTargetPart
			elseif BF.CheckEntity(self.RAP.AttackAltnTarget) then
				self.RAP.LockTarget = self.RAP.AttackAltnTarget
				self.RAP.LockTargetPoint = self.RAP.AttackAltnTargetPoint
				self.RAP.LockTargetPart = self.RAP.AttackAltnTargetPart
			end
		end
	end
	--锁定尝试
	if BF.CheckEntity(self.RAP.LockTarget) and self.RAP.LockTarget ~= 0 and isLock == true and not BF.HasEntitySign(self.Me,62001001) then
		if not BF.HasEntitySign(1,10000007) then --and self.RAP.CameraType ~= 2
			BF.SetLockTarget(self.RAP.LockTarget,self.RAP.LockTargetPoint)
			BF.SetCameraState(FightEnum.CameraState.WeakLocking)
			self.RAP.CameraType = 2 --弱锁定镜头
			self.RAP.CancelLockFrame = self.RAP.RealFrame + 30 --移除锁定镜头延迟时间
		elseif BF.HasEntitySign(1,10000007) then
			BF.SetLockTarget(self.RAP.LockTarget,self.RAP.LockTargetPoint)
			BF.SetCameraState(FightEnum.CameraState.ForceLocking)
			self.RAP.CameraType = 3 --弱锁定镜头
			self.RAP.CancelLockFrame = self.RAP.RealFrame + 99999 --移除锁定镜头延迟时间
		end
	end
	--待机切换等待时间
	self.RAP.LeisurelyIdleChangeFrame = self.RAP.RealFrame + 150
end

--通用受击集判断
function RoleCatchSkill:HitTypePart(HitType)
	local N = 0
	for i = 1,#HitType,1 do
		if self.RAP.MyHitState ~= 0 and self.RAP.MyHitState == HitType[i] then
			N = N + 1
		end
	end
	if HitType[1] == -1 then
		return true
	elseif N > 0 then
		return true
	else
		return false
	end
end

--通用释放距离限制集判断
function RoleCatchSkill:CastDistancePart(CastDistance)
	if CastDistance == nil or CastDistance == -1 or (CastDistance ~= nil and ((BF.CheckEntity(self.RAP.AttackTarget) 
			and CastDistance[1] >= BF.GetDistanceFromTarget(self.Me,self.RAP.AttackTarget,CastDistance[2]))
		or CastDistance[1] == -1)) then
		return true
	else
		return false
	end
end

--通用清除按键缓存判断
function RoleCatchSkill:ClearButtonPart(Button,ClearType)
	if (ClearType == "ClearPress" or ClearType == "ClearAll") and self.RAP.PressButton[Button] ~= nil and self.RAP.PressButton[Button] ~= 0 then
		if self.RAP.PressButton[Button] == FK.UltimateSkill then
			BF.RemoveKeyPress(FK.UltimateSkill)
		elseif self.RAP.PressButton[Button] == FK.Jump then
			BF.RemoveKeyPress(FK.Jump)
		elseif self.RAP.PressButton[Button] == FK.Dodge then
			BF.RemoveKeyPress(FK.Dodge)
		elseif self.RAP.PressButton[Button] == FK.Partner then
			BF.RemoveKeyPress(FK.Partner)
		elseif self.RAP.PressButton[Button] == FK.NormalSkill then
			BF.RemoveKeyPress(FK.NormalSkill)
		elseif self.RAP.PressButton[Button] == FK.Attack then
			BF.RemoveKeyPress(FK.Attack)
		end
		self.RAP.PressButton[Button] = nil
		self.RAP.PressButtonFrame[Button] = 0
	end
	
	if (ClearType == "ClearClick" or ClearType == "ClearAll") 
		and ((self.RAP.ClickButton[Button] ~= nil and self.RAP.ClickButton[Button] ~= 0)
			or (self.RAP.PressButton[Button] ~= nil and self.RAP.PressButton[Button] ~= 0))then
		self.RAP.ClickButton[Button] = nil
		self.RAP.ClickButtonFrame[Button] = self.RAP.RealFrame
	end
	
	if ClearType == "ClearAll" and Button == -1 then
		self.RAP.PressButton[1] = nil
		self.RAP.PressButtonFrame[1] = 0
		self.RAP.PressButton[2] = nil
		self.RAP.PressButtonFrame[2] = 0
		self.RAP.PressButton[3] = nil
		self.RAP.PressButtonFrame[3] = 0

		self.RAP.ClickButton[1] = nil
		self.RAP.ClickButtonFrame[1] = self.RAP.RealFrame
		self.RAP.ClickButton[2] = nil
		self.RAP.ClickButtonFrame[2] = self.RAP.RealFrame
		self.RAP.ClickButton[3] = nil
		self.RAP.ClickButtonFrame[3] = self.RAP.RealFrame
	end
end