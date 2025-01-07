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
	--检查长按缓存
	local PressButton = 0
	if self.RAP.PressButton[1] ~= 0 and self.RAP.PressButton[1] ~= nil then
		PressButton = 1
	elseif self.RAP.PressButton[2] ~= 0 and self.RAP.PressButton[2] ~= nil then
		PressButton = 2
	elseif self.RAP.PressButton[3] ~= 0 and self.RAP.PressButton[3] ~= nil then
		PressButton = 3
	end

	--按钮存在判断
	if ((ClickButton == 1 or ClickButton == 2 or ClickButton == 3) or (PressButton == 1 or PressButton == 2 or PressButton == 3))
		and BF.CheckEntityForeground(self.Me) then
		--进行跳跃流程
		if self.RAP.ClickButton[ClickButton] == FK.Jump and not BF.HasBuffKind(self.Me,1000033) and not BF.HasBuffKind(self.Me,1000034)
			and (self.RAP.MyState ~= FES.Climb or (self.RAP.MyState == FES.Climb and not BF.CheckKeyPress(FK.Jump))) and (self.RAP.MyState ~= FES.Skill
				or (self.RAP.MyState == FES.Skill and BF.GetSkillConfigSign(self.Me) ~= 50 and BF.GetSkillConfigSign(self.Me) ~= 80 and BF.GetSkillConfigSign(self.Me) ~= 81
					and BF.GetSkillConfigSign(self.Me) ~= 170 and BF.GetSkillConfigSign(self.Me) ~= 171 ))then
			if self.RAP.MyState == FES.Skill then
				BF.BreakSkill(self.Me)
			end
			if BF.DoJump(self.Me) then
				self.RAB.RoleCatchSkill:ClearButtonPart(ClickButton,"ClearClick")
			end
			--大招释放判断
		elseif self.RAP.ClickButton[ClickButton] == FK.UltimateSkill and BF.CheckEntityHeight(self.Me) == 0 then
			if self.RAB.RoleCatchSkill:ActiveSkill(ClickButton,self.MainBehavior.UltimateSkill[1],6,5,0,0,0,{0},"Immediately","ClearClick",true,0,-1) then
				BF.CastSkillCost(self.Me,self.MainBehavior.UltimateSkill[1])
			end
			--闪避释放判断
		elseif self.RAP.ClickButton[ClickButton] == FK.Dodge and BF.CheckEntityHeight(self.Me) == 0 then
			if self.RAB.RoleCatchSkill:MoveSkill(ClickButton,5,5,0,0,0,{21},"ClearClick") then
				BF.CastSkillCost(self.Me,self.MainBehavior.MoveSkill[1],"ClearClick")
			end
			--普通技能释放判断
		elseif self.RAP.ClickButton[ClickButton] == FK.NormalSkill and BF.CheckEntityHeight(self.Me) == 0 then
			if BF.GetSkillCostValue(self.Me,FK.NormalSkill) >= 2 then
				if self.RAB.RoleCatchSkill:ActiveSkill(ClickButton,self.MainBehavior.NormalSkill[1],2,2,0,0,0,{0},"Immediately","ClearClick",true,0,-1) then
					BF.CastSkillCost(self.Me,self.MainBehavior.NormalSkill[1])
				end
			end
			--普攻长按释放判断(空中)
		elseif self.RAP.PressButton[PressButton] == FK.Attack and self.RAP.PressButtonFrame[PressButton] >= 7
			and BF.CheckEntityHeight(self.Me) >= 1 then
			self.RAB.RoleCatchSkill:ActiveSkill(PressButton,self.MainBehavior.FallAttack[1],170,170,0,0,0,{0},"0","ClearPress",true,0,-1)
			--普攻长按释放判断(地面)，核心能量满时，长按普攻释放核心
		elseif self.RAP.PressButton[PressButton] == FK.Attack and self.RAP.PressButtonFrame[PressButton] >= 12
			and BF.CheckEntityHeight(self.Me) == 0 and self.RAP.CoreResRatio >= 10000 then
			if self.RAB.RoleCatchSkill:ActiveSkill(PressButton,self.MainBehavior.CoreSkill[1],2,2,0,0,0,{0},"Immediately","ClearPress",true,0,-1) then
				local coreRes = BF.GetEntityAttrVal(self.Me,1204)
				BF.ChangeEntityAttr(self.Me,1204,-coreRes)
			end
			--普攻点按释放判断(地面)
		elseif self.RAP.ClickButton[ClickButton] == FK.Attack and BF.CheckEntityHeight(self.Me) == 0 then
			self.RAB.RoleCatchSkill:ContSkill(ClickButton,self.MainBehavior.NormalAttack,1,1,10000002,0,0,{0},"Immediately","ClearClick",true,0,-1)
			--点按佩从按钮（地面）
		elseif self.RAP.ClickButton[ClickButton] == FK.Partner and self.RAP.partner then
			self.RAB.RolePartnerBase:PartnerSkill(ClickButton)
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
			and (self.RAP.CurrentSkillPriority < BreakPriority or (self.RAP.CurrentSkillPriority == BreakPriority and BF.CanCastSkill(self.Me))
				 or BF.GetSkillSign(self.Me,SkillSign))
			and ((EntitySign == 0 and BuffKind == 0) or BF.HasEntitySign(self.Me,EntitySign) or BF.HasBuffKind(self.Me,BuffKind))) then

		--打断上一技能判断
		if BF.CheckEntityState(self.Me,FES.Skill) then
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
		self.RAP.CtrlRole = BF.GetCtrlEntity()
		if self.RAP.CtrlRole == self.Me then
			if self.RAP.JoystickPosX ~= 0 and self.RAP.JoystickPosZ ~= 0 then
				BF.DoLookAtPositionImmediately(self.Me,self.RAP.JoystickPosX,self.RAP.MyPos.y,self.RAP.JoystickPosZ)
				BF.CastSkillByPosition(self.Me, self.MainBehavior.MoveSkill[1], self.RAP.JoystickPosX, self.RAP.MyPos.y, self.RAP.JoystickPosZ)
			else
				BF.CastSkillBySelfPosition( self.Me,self.MainBehavior.MoveSkill[2])
				self.RAP.LeisurelyIdleChangeFrame = self.RAP.RealFrame + 150
			end
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
	local skillType = BF.GetSkillSignWithId(self.Me, Skill)
	self:TargetPart(true,isJoystick,skillType)
	
	self.RAP.MyFrontPos = BF.GetPositionOffsetBySelf(self.Me,self.RAP.FrontDistance,0)
	if LookAtType == "inHerit" then
		BF.CastSkillByPosition(self.Me,Skill,self.RAP.MyFrontPos.x,self.RAP.MyFrontPos.y,self.RAP.MyFrontPos.z)
	else
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
			
			BF.CastSkillByTarget(self.Me,Skill,self.RAP.AttackTarget,nil,self.RAP.AttackTargetPoint)
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
			if Yoffset ~= nil then
				BF.CastSkillByPosition(self.Me,Skill,self.RAP.JoystickPosX, self.RAP.MyPos.y+Yoffset, self.RAP.JoystickPosZ)
			else
				BF.CastSkillByPosition(self.Me,Skill,self.RAP.JoystickPosX, self.RAP.MyPos.y, self.RAP.JoystickPosZ)
			end
		--不存在攻击目标，则原地释放技能
		elseif Yoffset ~= nil then
			BF.CastSkillByPosition(self.Me,Skill,self.RAP.MyFrontPos.x,self.RAP.MyFrontPos.y+Yoffset,self.RAP.MyFrontPos.z)
		else
			BF.CastSkillByPosition(self.Me,Skill,self.RAP.MyFrontPos.x,self.RAP.MyFrontPos.y,self.RAP.MyFrontPos.z)
		end
	end
	self.RAP.CurrentSkillPriority = SkillPriority
	self:ClearButtonPart(Button,ClearType)
end



--通用目标部分
function RoleCatchSkill:TargetPart(isLock,isJoystick,skillType)
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
		if not BF.HasEntitySign(1,10000007)
			and not BF.HasEntitySign(self.Me,10000019) and skillType ~= 170 then --and self.RAP.CameraType ~= 2
			--添加镜头目标，设置镜头为战斗镜头
			BF.RemoveAllLookAtTarget()
			BF.AddLookAtTarget(self.RAP.LockTarget,"CameraTarget")
			BF.AddLookAtTarget(self.Me,"CameraTarget")
			BF.SetLookAtTargetWeight(self.Me,"CameraTarget",0.5)
			BF.SetLockTarget(self.RAP.LockTarget,"CameraTarget","HitCase")
			BF.SetCameraState(FE.CameraState.Fight)
			if self.RAP.cameraParams and self.RAP.cameraParams ~= 0 then
				BF.SetCameraParams(FE.CameraState.Fight,self.RAP.cameraParams,true)	--根据特殊环境设置战斗镜头的参数
			end
			self.RAP.CancelLockFrame = self.RAP.RealFrame + 60 --移除锁定镜头延迟时间
			--如果当前的镜头状态不是战斗状态，则在初次进入战斗镜头状态时执行一次默认修正，0.2秒内修正到X轴9度
			--if self.RAP.CameraType ~= 2 then
				----BF.SetCorrectCameraState(FE.CameraState.Fight, true)
				----BF.CorrectCameraParams(FE.CameraState.Fight)
				--BF.SetCorrectEulerData(FE.CameraState.Fight,true,0.2,9)
			--end
			
			--在镜头位置发生严重偏转时，执行修正；该修正如果在高度差超过2时不执行
			local x,y,z = BF.GetCameraRotation()
			local distance = BF.GetDistanceFromTarget(self.Me,self.RAP.LockTarget,false)
			local angle = BF.GetEntityAngle(self.Me,self.RAP.LockTarget)
			local myPos = BF.GetPositionP(self.Me)
			local targetPos = BF.GetPositionP(self.RAP.LockTarget)
			local height = myPos.y - targetPos.y
			if x > 20 and self.RAP.CameraType == 2 and math.abs(height) < 2 then
				BF.SetCorrectEulerData(FE.CameraState.Fight,true,0.1,9)
			elseif 	x < 0 and self.RAP.CameraType == 2 and math.abs(height) < 2 then
				BF.SetCorrectEulerData(FE.CameraState.Fight,true,0.1,8)
			end
			
			self.RAP.CameraType = 2 --将当前状态切换为战斗镜头
			--if BF.CheckPartnerShow(self.Me) then
				--BF.AddLookAtTarget(self.RAP.partner,"HitCase")
			--end

		elseif BF.HasEntitySign(1,10000007) then
			BF.SetLockTarget(self.RAP.LockTarget,self.RAP.LockTargetPoint,self.RAP.LockTargetPoint)
			BF.SetCameraState(FightEnum.CameraState.ForceLocking)
			--BehaviorFunctions.SetFixedCameraVerticalDir(FightEnum.CameraState.ForceLocking,true)
			self.RAP.CameraType = 3 --弱锁定镜头
			self.RAP.CancelLockFrame = self.RAP.RealFrame + 99999 --移除锁定镜头延迟时间
			--BF.SetFixedCameraVerticalDir(FightEnum.CameraState.ForceLocking,false)
			--BF.SetCorrectCameraState(FightEnum.CameraState.ForceLocking, false)
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

--通用释放距离限制集判断，格式{距离限制,是否判断半径} 或 -1
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

--相机过渡通知
--function RoleCatchSkill:InformCameraBlendState(isBlend,formCamera,toCamera)
	--if formCamera == FightEnum.CameraState.Operating and toCamera == FightEnum.CameraState.Fight then
		----完成融合
		--if isBlend == false then
			

		--end

		----进入融合
		--if isBlend  == true then
			--BF.RemoveAllFollowTarget()
			--BF.RemoveAllLookAtTarget()
			--BF.AddFollowTarget(self.Me,"CameraTarget")
			--BF.AddLookAtTarget(self.Me,"CameraTarget")
		--end
	--end
--end