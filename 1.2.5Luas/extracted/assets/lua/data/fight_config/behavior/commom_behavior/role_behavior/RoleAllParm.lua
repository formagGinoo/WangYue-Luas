RoleAllParm = BaseClass("RoleAllParm",EntityBehaviorBase)

local BF = BehaviorFunctions
local FE = FightEnum
local FK = FightEnum.KeyEvent
local FEMSS = FightEnum.EntityMoveSubState
local FESS = FightEnum.EntitySwimState
local FES = FightEnum.EntityState
local FECS = FightEnum.EntityClimbState
local FEAET = FightEnum.AnimEventType
local FEET = FightEnum.ElementType
local FEPA = FightEnum.PlayerAttr
local EACAT = EntityAttrsConfig.AttrType

function RoleAllParm.GetMagics()
	local generates = {1000005}
	return generates
end

function getAsset()
	local generates = {"1000005"}
end

--通用参数组合、不区分在场与否参数更新
function RoleAllParm:Init()

	local generates = {1000000000,1000000001} --极限闪避空间特效
	
	self.Me = self.instanceId	--记录自己
	
	self.RealFrame = 0			--世界时间
	self.MyFrame = 0			--自身帧数
	
	self.MyState = 0			--自身状态
	self.MyHitState = 0			--自身受击状态
	self.MyPos = {}				--自身坐标
	self.MyFrontPos = {}		--自身前方坐标
	
	self.JoystickPosX = 0		--摇杆方向坐标X
	self.JoystickPosZ = 0		--摇杆方向坐标Z
	
	self.LevelMovePosition = 0	--关卡路径点
	
	self.CoreRes = 0			--记录当前核心资源量
	self.CoreResRatio = 0		--记录当前核心资源比率
	self.MoveRes = 0			--记录当前闪避值
	self.MoveResRatio = 0		--记录当前闪避值万分比
	self.MoveResFrame = 0		--记录闪避值恢复延迟
	self.MyDiyueResRatio = 0	--记录当前缔约值万分比
	
	self.ClickButton = {0,0,0}		--点击记录的按钮
	self.ClickButtonFrame = {0,0,0}	--点击记录缓存时间
	
	self.PressButton = {0,0,0}		--长按记录的按钮
	self.PressButtonFrame = {0,0,0}	--长按记录缓存时间
	
	self.MyRoleIndex = 0			--自身角色按钮序号
	
	self.CtrlRole = 0	--当前在场角色
	self.Role1 = 0		--序号1角色
	self.Role2 = 0		--序号2角色
	self.Role3 = 0		--序号3角色
	
	self.CurrentSkill = 0			--当前使用中的技能记录当前释放中技能，否则为0
	self.CurrentSkillType = 0		--当前使用中的技能的类型
	self.CurrentSkillPriority = 0	--当前技能优先级
	self.FrontPos = 10
	
	self.UiTarget = 0					--敌方UI目标
	self.UITargetCancelFrame = 0		--敌方UI延迟取消帧数
	
	self.LockTarget = 0					--锁定目标
	self.LockTargetPoint = 0			--锁定点
	self.LockTargetPart = 0				--锁定部位
	self.LockTargetState = 0 			--锁定目标状态
	self.LockTargetDistance = 0			--锁定目标距离
	
	self.LockAltnTarget = 0				--备用锁定目标
	self.LockAltnTargetPoint = 0		--备用锁定点
	self.LockAltnTargetPart = 0			--备用锁定部位
	self.LockAltnTargetState = 0 		--备用锁定目标状态
	self.LockAltnTargetDistance = 0		--备用锁定目标距离
	
	self.AttackTarget = 0				--攻击目标
	self.AttackTargetPoint = 0			--攻击点
	self.AttackTargetPart = 0			--攻击部位
	self.AttackTargetState = 0 			--攻击目标状态
	self.AttackTargetDistance = 0		--攻击目标距离
	
	self.AttackAltnTarget = 0			--备用攻击目标
	self.AttackAltnTargetPoint = 0		--备用攻击点
	self.AttackAltnTargetPart = 0		--备用攻击部位
	self.AttackAltnTargetState = 0 		--备用攻击目标状态
	self.AttackAltnTargetDistance = 0	--备用攻击目标距离

	self.ChangeLockTargetFrame = 0		--切换锁定目标间隔时间
	self.CancelLockFrame = 0			--移除锁定镜头延迟时间
	
	self.LeisurelyIdleChangeFrame = 0	--休闲待机切换倒计时
	
	self.CameraType = 1			--当前镜头类型，1操作镜头，2弱锁定，3强锁定，4瞄准镜头
	
	self.JoystickFrame = 0	--摇杆操作帧数
	
	self.JumpQTE = 0			--空中反击QTE
	self.UltimateQTE = 0 		--大招QTE
	
	self.PlayerInFightFrame = 0	--角色战斗状态缓存帧数
	
	self.RoleAttackFrame = 0 --角色攻击命中记录缓存
	self.RoleReboundFrame = 0 --角色弹刀成功记录缓存
	self.QTETarget = 0 --触发QTE的怪物
	
	self.CoreUiFrame = 0 --核心Ui隐藏延迟时间
	
	--异常状态QTE定义
	self.DebuffIceQTE = 0
	self.DebuffDizzyQTE = 0
	self.DebuffIceTime = 0
	self.DebuffDizzyTime = 0
	self.DebuffIceEffect = 0
	self.DebuffIceId = 0
	self.DebuffDizzyId = 0
	
	--返回角色数量
	self.MemberNum = 0
end

function RoleAllParm:Update()
	
	self.RoleAllBehavior = self.MainBehavior.RoleAllBehavior --获取角色组合合集
	self.RAB = self.RoleAllBehavior
	
	--记录世界帧数、自身帧数、自身状态、自身血量
	self.RealFrame = BF.GetFightFrame()
	self.MyFrame = BF.GetEntityFrame(self.Me)
	self.MyState = BF.GetEntityState(self.Me)
	self.MyHitState = BF.GetHitType(self.Me)
	self.MyHp = BF.GetEntityAttrVal(self.Me,1001)
	
	--返回队伍人数
	self.MemberNum = BF.GetCurAlivePlayerEntityCount()
	
	--记录角色
	self.CtrlRole = BF.GetCtrlEntity()
	self.Role1 = BF.GetQTEEntity(1)
	self.Role2 = BF.GetQTEEntity(2)
	self.Role3 = BF.GetQTEEntity(3)                               
	
	--记录核心资源
	self.CoreRes = BF.GetEntityAttrVal(self.Me,1204)
	self.CoreResRatio = BF.GetEntityAttrValueRatio(self.Me,1204)
	
	--记录缔约值万分比
	self.MyDiyueResRatio = BF.GetEntityAttrValueRatio(self.Me,1301)
	
	--闪避值恢复延迟判断
	if self.MoveRes == 0 and self.MoveResFrame < self.RealFrame then
		self.MoveResFrame = self.RealFrame + 60
	elseif self.MoveRes > 0 and self.MoveResFrame > self.RealFrame then
		self.MoveResFrame = self.RealFrame - 1
	end
	
	--体力恢复判断，每帧恢复4点闪避值，上限1000点
	if not BF.CheckEntitySprint(self.Me) and self.MyState ~= FES.Swim and self.MyState ~= FES.Climb and self.MyState ~= FES.Glide 
		and self.MyState ~= FES.Jump and self.MyState ~= FES.Fall and self.MoveResFrame <= self.RealFrame
		and (BF.CheckEntityForeground(self.Me) and not BF.GetSkillSign(self.Me,10000007)) then
		BF.ChangePlayerAttr(FEPA.CurStaminaValue,BF.GetPlayerAttrVal(FEPA.StaminaRecoveryRate))
	end
	--记录闪避值当前量和比例
	self.MoveRes = BF.GetPlayerAttrVal(FEPA.CurStaminaValue)
	self.MoveResRatio = BF.GetPlayerAttrRatio(FEPA.CurStaminaValue)

	--记录自身的角色按钮序号
	self.MyRoleIndex = BF.GetEntityQTEIndex(self.Me)
	
	--玩家战斗状态帧数缓存
	if BF.CheckPlayerInFight() then
		self.PlayerInFightFrame = self.RealFrame + 90
	end
	
	--存在通用负黄色资源晕眩时恢复资源判断
	if BF.HasBuffKind(self.Me,1000008) then
		BF.ChangeEntityAttr(self.Me,1201,10,1) --3秒
		BF.PlayFightUIEffect("22056", "Yellow")
	else
		BF.StopFightUIEffect("22056","Yellow")
	end
	
	--角色在后台或前台角色不处于战斗状态，缓慢恢复黄色资源
	if not BF.CheckEntityForeground(self.Me) and not BF.HasEntitySign(self.Me,10000030) --角色不自动恢复技能资源标记
		or (not BF.CheckPlayerInFight() and self.PlayerInFightFrame < self.RealFrame) then
		BF.ChangeEntityAttr(self.Me,1201,2,1) --15秒
	end
	
	------------如果在前台-----------------------------
	if BF.CheckEntityForeground(self.Me) then
		
		--记录坐标、前方坐标
		self.MyPos = BF.GetPositionP(self.Me)
		self.MyFrontPos = BF.GetPositionOffsetBySelf(self.Me,self.FrontPos,0)
		
		--通用下落攻击判断
		if self.Me == self.CtrlRole and self.MyState == FES.Skill and self.CurrentSkillType == 170 
			and BF.GetSkillSign(self.Me,10000008) then
			BF.BreakSkill(self.Me)
			BF.CastSkillBySelfPosition(self.Me,self.MainBehavior.FallAttack[2])
			self.CurrentSkillPriority = 171
			--待机切换等待时间、移除锁定镜头延迟时间
			self.LeisurelyIdleChangeFrame = self.RealFrame + 150
			self.CancelLockFrame = self.RealFrame + 5
		end
		
		--存在切换角色暂时无敌标记，则对自身施加无敌BUFF
		if BF.HasEntitySign(self.Me,10000005) then
			BF.AddBuff(self.Me,self.Me,1000002,1)
			BF.RemoveEntitySign(self.Me,10000005)
		end
		
		--记录使用中技能和技能类型，尝试延长锁定相关参数的时间
		if self.MyState == FES.Skill then
			self.CurrentSkill = BF.GetSkill(self.Me)
			self.CurrentSkillType = BF.GetSkillType(self.Me)
			if not BF.CanCastSkill(self.Me) then
				self.CoreUiFrame = self.CoreUiFrame + 1
			end
			if self.CurrentSkillType ~= 30 and self.CurrentSkillType ~= 31 then

				if self.CurrentSkillType == 80 or self.CurrentSkillType == 81 then
					--移除锁定镜头延迟时间
					if self.CancelLockFrame - self.RealFrame < 30 then
						self.CancelLockFrame = self.RealFrame + 30
					end
					--敌方UI延迟取消帧数
					if BF.CheckEntity(self.UiTarget) and (self.UITargetCancelFrame - self.RealFrame < 30) then
						self.UITargetCancelFrame = self.RealFrame + 30
					end
					--休闲待机切换倒计时
					if self.LeisurelyIdleChangeFrame - self.RealFrame < 30 then
						self.LeisurelyIdleChangeFrame = self.RealFrame + 30
					end
				else
					--移除锁定镜头延迟时间
					if self.CancelLockFrame > self.RealFrame then
						self.CancelLockFrame = self.CancelLockFrame + 1
					end
					--敌方UI延迟取消帧数
					if BF.CheckEntity(self.UiTarget) and self.UITargetCancelFrame > self.RealFrame then
						self.UITargetCancelFrame = self.UITargetCancelFrame + 1
					end
					--休闲待机切换倒计时
					if self.LeisurelyIdleChangeFrame > self.RealFrame then
						self.LeisurelyIdleChangeFrame = self.LeisurelyIdleChangeFrame + 1
					end
				end

				--闪避技能释放记录
			elseif (self.CurrentSkillType == 30 or self.CurrentSkillType == 31) and not BF.HasEntitySign(1,10000007) then
				--待机切换等待时间、移除锁定镜头延迟时间
				self.CancelLockFrame = self.RealFrame - 1
			end
		else
			self.CurrentSkill = 0
			self.CurrentSkillType = 0
		end

		--尝试在受击或晕眩状态延长锁定相关参数的时间
		if self.MyState == FES.Hit or self.MyState == FES.Stun then
			--移除锁定镜头延迟时间
			if self.CancelLockFrame > self.RealFrame then
				self.CancelLockFrame = self.CancelLockFrame + 1
			end
			--敌方UI延迟取消帧数
			if BF.CheckEntity(self.UiTarget) and self.UITargetCancelFrame > self.RealFrame then
				self.UITargetCancelFrame = self.UITargetCancelFrame + 1
			end
			--休闲待机切换倒计时
			if self.LeisurelyIdleChangeFrame > self.RealFrame then
				self.LeisurelyIdleChangeFrame = self.LeisurelyIdleChangeFrame + 1
			end
		end
		
		--当前角色死亡过程中移除输入记录
		if self.CtrlRole == self.Me and self.MyState == FES.Die then
			self.ClickButton = {0,0,0}		--点击记录的按钮
			self.ClickButtonFrame = {0,0,0}	--点击记录缓存时间
			self.PressButton = {0,0,0}		--长按记录的按钮
			self.PressButtonFrame = {0,0,0}	--长按记录缓存时间
		end
		
		--当前角色完全死亡后判定
		if self.CtrlRole == self.Me and self.MyState == FES.Death then
			local n1 = BF.GetQTEEntity(1)
			local n2 = BF.GetQTEEntity(2)
			if BF.CheckEntity(n1) and not BF.CheckEntityForeground(n1) then
				BF.AddEntitySign(n1,10000008,-1) --当前角色切换其他角色标记，此为强制施加
				BF.AddEntitySign(n1,10000005,-1) --当前角色死亡后切换角色短暂无敌标记
			elseif BF.CheckEntity(n2) and not BF.CheckEntityForeground(n2) then
				BF.AddEntitySign(n2,10000008,-1)
				BF.AddEntitySign(n2,10000005,-1)
			end
			BF.SetEntityAttr(self.Me,1202,0,1) --死亡移除所有蓝色技能点
		end		
		
		--------判断在前台且为当前操控角色-----------------
		if self.CtrlRole == self.Me then
			
			--强锁定 - 技能帧事件标记判断
			if BF.HasEntitySign(1,10000007) and not BF.CheckSkillEventActiveSign(self.Me,10000002) then
				BF.AddSkillEventActiveSign(self.Me,10000002)
			elseif not BF.HasEntitySign(1,10000007) and BF.CheckSkillEventActiveSign(self.Me,10000002) then
				BF.RemoveSkillEventActiveSign(self.Me,10000002)
			end
			
			--弱锁定 - 技能帧事件标记判断
			if not BF.HasEntitySign(1,10000007) and not BF.CheckSkillEventActiveSign(self.Me,10000003) then
				BF.AddSkillEventActiveSign(self.Me,10000003)
			elseif BF.HasEntitySign(1,10000007) and BF.CheckSkillEventActiveSign(self.Me,10000003) then
				BF.RemoveSkillEventActiveSign(self.Me,10000003)
			end
			
			--跳跃躲避动效提示 / 跳闪提示
			if BF.HasBuffKind(self.Me,1000036) then
				BF.PlayFightUIEffect("20014","O")
			else
				BF.StopFightUIEffect("20014","O")
			end
			
			--记录摇杆方向坐标、记录休闲待机切换倒计时、聚焦镜头切换倒计时
			if BF.CheckMove() then
				self.JoystickPosX,self.JoystickPosZ = BF.GetMoveDistance(self.Me,10)
				if self.MyState == FES.Move then
					BF.SetIdleType(self.Me,FightEnum.EntityIdleType.LeisurelyIdle) --休闲待机
					self.LeisurelyIdleChangeFrame = self.RealFrame - 1
				end
				if BF.CanCtrl(self.Me) then
					self.JoystickFrame = self.JoystickFrame + 1
				else
					self.JoystickFrame = 0
				end
				--移动后移除弱锁定判断
				if not BF.HasEntitySign(1,10000007) and self.JoystickFrame > 9 then
					self.CancelLockFrame = self.RealFrame - 1
				end
			else
				self.JoystickPosX,self.JoystickPosZ = 0,0
				self.JoystickFrame = 0
			end
			
			--进入疾跑判断，闪避按钮长按帧数、体力资源、摇杆操作、前接闪避判断
			if not BF.CheckEntitySprint(self.Me) and BF.GetKeyPressFrame(FK.Dodge) > 7 and BF.CheckMove() and BF.GetSkillSign(self.Me,10000006)
				and self.MoveRes > 10 and self.CurrentSkillType == 30 then
				if self.MyState == FES.Skill then
					BF.SetEntitySprintState(self.Me,true) --设置疾跑状态
					BF.DoSetEntityState(self.Me,FES.Move)
					self.MyState = BF.GetEntityState(self.Me)
				end
			end
			--疾跑状态判断
			if BF.CheckEntitySprint(self.Me) then
				if self.MyState == FES.Move and BF.GetSubMoveState(self.Me) == FEMSS.Sprint then
					BF.ChangePlayerAttr(FEPA.CurStaminaValue, BF.GetEntityAttrVal(self.Me,EACAT.SprintCost)) --减少体力
					self.MoveRes = BF.GetPlayerAttrVal(FEPA.CurStaminaValue)
					if self.MoveRes <= 0 then
						BF.SetEntitySprintState(self.Me,false) --取消疾跑状态
					end
				elseif (self.MyState ~= FES.Move and self.MyState ~= FES.Jump) or self.MoveRes <= 0 or not BF.CheckMove() then
					BF.SetEntitySprintState(self.Me,false)
				end
			end
			
			--游泳判断
			if not BF.CheckEntityFastSwimming(self.Me) and self.MyState == FES.Swim and BF.GetSubSwimState(self.Me) == FESS.Swimming then
				BF.ChangePlayerAttr(FEPA.CurStaminaValue,BF.GetEntityAttrVal(self.Me,EACAT.SwimCost)) --减少体力
				self.MoveRes = BF.GetPlayerAttrVal(FEPA.CurStaminaValue)
			end
			--进入速泳判断，闪避按钮长按帧数、体力资源、摇杆操作、前接闪避判断
			if BF.GetKeyPressFrame(FK.Dodge) >= 2 and BF.CheckMove() and self.MoveRes > 10 and self.MyState == FES.Swim
				and not BF.CheckEntityFastSwimming(self.Me) then
				BF.SetEntityFastSwimming(self.Me,true) --进入速泳状态
			elseif BF.CheckEntityFastSwimming(self.Me) and (BF.GetKeyPressFrame(FK.Dodge) < 2 or not BF.CheckMove() or self.MoveRes == 0
					or self.MyState ~= FES.Swim) then
				BF.SetEntityFastSwimming(self.Me,false)
			end
			--速泳状态判断，闪避按钮长按帧数、摇杆操作、体力资源、人物状态
			if BF.CheckEntityFastSwimming(self.Me) and self.MyState == FES.Swim and BF.GetSubSwimState(self.Me) == FESS.FastSwimming then
				BF.ChangePlayerAttr(FEPA.CurStaminaValue,BF.GetEntityAttrVal(self.Me,EACAT.FastSwimCost)) --减少体力
				self.MoveRes = BF.GetPlayerAttrVal(FEPA.CurStaminaValue)
				if self.MoveRes <= 0 then
					BF.SetEntityFastSwimming(self.Me,false) --取消速泳状态
				end
			end
			
			--攀爬判断
			if not BF.CheckEntityClimbingRun(self.Me) and self.MyState == FES.Climb then
				if BF.GetSubClimbState(self.Me) == FECS.Climbing then
					BF.ChangePlayerAttr(FEPA.CurStaminaValue,BF.GetEntityAttrVal(self.Me,EACAT.ClimbCost)) --减少体力
					self.MoveRes = BF.GetPlayerAttrVal(FEPA.CurStaminaValue)
				end
				if BF.GetSubClimbState(self.Me) == FECS.ClimbingJump then
					BF.ChangePlayerAttr(FEPA.CurStaminaValue,BF.GetEntityAttrVal(self.Me,EACAT.ClimbJumpCost)) --减少体力
					self.MoveRes = BF.GetPlayerAttrVal(FEPA.CurStaminaValue)
				end
				if self.MoveRes <= 0 then
					BF.SetEntityClimbingRun(self.Me,false) --取消攀跑状态
					BF.SetEntityForceLeaveClimb(self.Me) --脱离攀爬
				end
			end
			--进入攀跑判断，闪避按钮长按帧数、体力资源、摇杆操作、前接闪避判断
			if BF.GetKeyPressFrame(FK.Jump) >= 6 and BF.CheckMove() and self.MoveRes > 10 and self.MyState == FES.Climb
				and not BF.CheckEntityClimbingRun(self.Me) then
				BF.SetEntityClimbingRun(self.Me,true) --进入攀跑状态
			elseif BF.CheckEntityClimbingRun(self.Me) and (BF.GetKeyPressFrame(FK.Jump) < 2 or not BF.CheckMove() or self.MoveRes == 0
					or self.MyState ~= FES.Climb ) then
				BF.SetEntityClimbingRun(self.Me,false)
			end
			
			--if BF.GetKeyPressFrame(FK.Jump) >= 6 and BF.CheckMove() and self.MoveRes > 10 and self.MyState == FES.Climb
				--and not BF.CheckEntityClimbingRun(self.Me) then
				--BF.SetEntityClimbingRun(self.Me,true) --进入攀跑状态
			--elseif BF.CheckEntityClimbingRun(self.Me) and (BF.GetKeyPressFrame(FK.Jump) < 2 or not BF.CheckMove() or self.MoveRes == 0
					--or self.MyState ~= FES.Climb ) then
				--BF.SetEntityClimbingRun(self.Me,false)
			--end
			--攀跑判断，闪避按钮长按帧数、摇杆操作、体力资源、人物状态
			if BF.CheckEntityClimbingRun(self.Me) and self.MyState == FES.Climb then
				if BF.GetSubClimbState(self.Me) == FECS.ClimbingRunStart then
					BF.ChangePlayerAttr(FEPA.CurStaminaValue,BF.GetEntityAttrVal(self.Me,EACAT.ClimbRunCost)) --减少体力
				end
				if BF.GetSubClimbState(self.Me) == FECS.ClimbingRun then
					BF.ChangePlayerAttr(FEPA.CurStaminaValue,BF.GetEntityAttrVal(self.Me,EACAT.ClimbRunCost)) --减少体力
				end
				self.MoveRes = BF.GetPlayerAttrVal(FEPA.CurStaminaValue)
				if self.MoveRes <= 0 then
					BF.SetEntityClimbingRun(self.Me,false) --取消攀跑状态
					BF.SetEntityForceLeaveClimb(self.Me) --脱离攀爬
				end
			end
			
			--跳跃反击抬手判断
			if BF.HasEntitySign(self.Me,10000023) then
				BF.RemoveBuff(self.Me,1000033)	--移除跳跃闪避各种免疫
				BF.ForbidKey(FK.ScreenPress,true)
				BF.ForbidKey(FK.ScreenMove,true)
				--BF.DoLookAtTargetImmediately(self.Me,self.LockTarget)
				self.RAB.RoleCatchSkill:ActiveSkill(0,self.MainBehavior.JumpAttack[1],2,2,0,0,0,{0},"Immediately","",false)
				--BF.CastSkillByTarget(self.Me,self.MainBehavior.JumpAttack[1],self.LockTarget)
				self.CurrentSkillPriority = 80
				self.LeisurelyIdleChangeFrame = self.RealFrame + 150
				self.CancelLockFrame = self.RealFrame + 99999
				--BehaviorFunctions.PlayQTEUIEffect(self.JumpQTE, "22044", "QTEEffect")
				BF.RemoveEntitySign(self.Me,10000023)
				--BF.AddBuff(self.Me,self.Me,1000029,1) --大招QTE顿帧
				
				--延时创建QTE，目的：获得QTEId
				BF.AddDelayCallByFrame(24,self,self.JumpQTEPart,self.Me,"","",true,false,5,303,-187,3,1)
			end
			
			--大招QTE触发检测 / QTE绝技开关
			self:UltimateQTEPart()
			
		end
	end
end

--技能释放判断
function RoleAllParm:CastSkill(instanceId,skillId,skillType)
	--放技能取消疾跑状态判断
	if instanceId == self.Me and BF.CheckEntitySprint(self.Me) then
		BF.SetEntitySprintState(self.Me,false) --取消疾跑状态
	end
	--闪避消耗体力值
	if instanceId == self.Me and (skillType == 30 or skillType == 31) then
		BF.ChangePlayerAttr(FEPA.CurStaminaValue,BF.GetEntityAttrVal(self.Me,EACAT.DodgeCost))
		--self.ChangeLockTargetFrame = 0 --闪避重置切换锁定目标间隔时间
	end
end

--通用闪避成功判断：攻击者、受击者、是否触发极限闪避
function RoleAllParm:BeforeDodge(attackInstanceId,hitInstanceId,limit)
	if BF.HasEntitySign(1,10000007) and BF.CheckEntity(self.UiTarget) then
		self.RAB.RoleLockTarget:UiTargetPart(attackInstanceId) --尝试显示目标UI
	end
	if hitInstanceId == self.Me then
		BF.AddSkillPoint(self.Me,1201,1)	--增加1格黄色能量
		
		--BF.AddEntitySign(hitInstanceId,10000000,3) --角色3秒内反击标记
		BF.DoMagic(self.Me,self.Me,1000003,1) --一般闪避角色自身减速Buff
		BF.DoMagic(self.Me,1,1000000,1) --给场景怪加一般闪避怪物场景特效全局减速Buff
		BF.CreateEntity(1000000003,self.Me,self.MyPos.x,self.MyPos.y,self.MyPos.z) --释放一般闪避特效
		--触发极限闪避
		if limit == true then
			BF.SetDodgeLimitTime(1) --设置极限闪避时间
			--极限闪避怪物场景特效减速Buff判断
			if BF.HasBuffKind(1,10000006) then
				BF.ResetBuff(1,10000006) --刷新场景怪身上的极闪怪物场景特效全局减速Buff / 刷新场景怪极限闪避判断
			else
				BF.DoMagic(self.Me,1,1000006,1) --给场景怪加极闪怪物场景特效全局减速Buff / 触发场景怪极限闪避判断
			end
			--BF.AddEntitySign(1,10000002,8) --给场景怪加QTE激活标记
			--BF.AddEntitySign(hitInstanceId,10000000,2) --极闪角色2秒内反击标记
			if BF.CheckEntity(self.CtrlRole) then
				BF.SetDodgeLimitState(self.CtrlRole,DodgeComponent.LimitState.Cooling) --设置角色极限闪避冷却状态
				BF.SetDodgeCoolingTime(self.CtrlRole,13,13) --对角色施加冷却时间
			end
			--if BF.CheckEntity(self.Role1) and self.Role1 ~= self.CtrlRole then
				----BF.AddQTETime(1,FightEnum.QTEType.Change,-99)--重置换人冷却时间
				----BF.AddQTETime(1,FightEnum.QTEType.QTE,-99)	--重置QTE冷却时间
				----BF.SetQTEState(1,FightEnum.QTEType.QTE,FightEnum.QTEState.Ready)--设置QTE状态为就绪
				--BF.SetDodgeLimitState(self.Role1,DodgeComponent.LimitState.Cooling)
				--BF.SetDodgeCoolingTime(self.Role1,13,13)
			--end
			--if BF.CheckEntity(self.Role2) and self.Role2 ~= self.CtrlRole then
				----BF.AddQTETime(1,FightEnum.QTEType.Change,-99)--重置换人冷却时间
				----BF.AddQTETime(1,FightEnum.QTEType.QTE,-99)	--重置QTE冷却时间
				----BF.SetQTEState(1,FightEnum.QTEType.QTE,FightEnum.QTEState.Ready)--设置QTE状态为就绪
				--BF.SetDodgeLimitState(self.Role2,DodgeComponent.LimitState.Cooling)
				--BF.SetDodgeCoolingTime(self.Role2,13,13)
			--end
			--if BF.CheckEntity(self.Role3) and self.Role3 ~= self.CtrlRole then
				----BF.AddQTETime(2,FightEnum.QTEType.Change,-99)--重置换人冷却时间
				----BF.AddQTETime(2,FightEnum.QTEType.QTE,-99)	--重置QTE冷却时间
				----BF.SetQTEState(2,FightEnum.QTEType.QTE,FightEnum.QTEState.Ready)--设置QTE状态为就绪
				--BF.SetDodgeLimitState(self.Role3,DodgeComponent.LimitState.Cooling)
				--BF.SetDodgeCoolingTime(self.Role3,13,13)
			--end
			BF.CreateEntity(1000000000,self.Me,self.MyPos.x,self.MyPos.y,self.MyPos.z) --释放极限闪避特效
			if BF.CheckEntity(self.CtrlRole) then --对当前操作角色施加极限闪避全屏特效
				BF.DoMagic(self.CtrlRole,self.CtrlRole,1000005,1)
				BF.DoEntityAudioPlay(self.CtrlRole,"UltraDodge",true)--音效
			end
			else
			BF.DoEntityAudioPlay(self.CtrlRole,"AirCounter",true)--音效
		end
	end
end

--通用角色上场判断
function RoleAllParm:ChangeForeground(instanceId)
	if instanceId == self.Me then
		self.LockTarget = BF.GetEntityValue(self.Me,"LockTarget")
		self.LockTargetPoint = BF.GetEntityValue(self.Me,"LockTargetPoint")
		self.LockTargetPart = BF.GetEntityValue(self.Me,"LockTargetPart")
		
		self.AttackTarget = BF.GetEntityValue(self.Me,"AttackTarget")
		self.AttackTargetPoint = BF.GetEntityValue(self.Me,"AttackTargetPoint")
		self.AttackTargetPart = BF.GetEntityValue(self.Me,"AttackTargetPart")
		
		self.LockAltnTarget = BF.GetEntityValue(self.Me,"LockAltnTarget")
		self.LockAltnTargetPoint = BF.GetEntityValue(self.Me,"LockAltnTargetPoint")
		self.LockAltnTargetPart = BF.GetEntityValue(self.Me,"LockAltnTargetPart")

		self.AttackAltnTarget = BF.GetEntityValue(self.Me,"AttackAltnTarget")
		self.AttackAltnTargetPoint = BF.GetEntityValue(self.Me,"AttackAltnTargetPoint")
		self.AttackAltnTargetPart = BF.GetEntityValue(self.Me,"AttackAltnTargetPart")
		
	end
end

--通用角色退场判断
function RoleAllParm:ChangeBackground(instanceId)
	if instanceId == self.Me then
		BF.SetEntityAttr(self.Me,1202,0,1)	--退场移除所有蓝色技能点
	end
end

--通用下落攻击着地回调
function RoleAllParm:OnLand(instanceId)
	if instanceId == self.Me and self.MyState == FES.Skill and (self.CurrentSkillType == 171 or self.CurrentSkillType == 170)
		and BF.GetSkillSign(self.Me,10000008) then
		BF.BreakSkill(self.Me)
		BF.CastSkillBySelfPosition(self.Me,self.MainBehavior.FallAttack[3])
		self.CurrentSkillPriority = 2
		--待机切换等待时间、移除锁定镜头延迟时间
		self.LeisurelyIdleChangeFrame = self.RealFrame + 150
		self.CancelLockFrame = self.RealFrame + 5
	end
end

--首次命中判断
function RoleAllParm:FirstCollide(attackInstanceId,hitInstanceId,InstanceIdId,attackType)
	--local I = BF.GetEntityTemplateId(InstanceIdId)
	--角色被常规、特殊攻击子弹攻击后减少资源、气绝判断
	if hitInstanceId == self.Me and (attackType == 1 or attackType == 2) then
		BF.StopFightUIEffect("22057", "Yellow")
		BF.PlayFightUIEffect("22057", "Yellow")
		if not BF.HasBuffKind(self.Me,1000008) then
			BF.AddSkillPoint(self.Me,1201,-0.5)	--减少0.5格黄色资源
		end
		if BF.GetEntityAttrVal(self.Me,1201) <= 0 and not BF.HasBuffKind(self.Me,1000008) then
			BF.BreakSkill(self.Me)
			BF.AddBuff(self.Me,self.Me,1000008,1) --通用角色负黄色技能资源晕眩3秒
			BF.AddBuff(self.Me,self.Me,1000009,1) --气绝屏幕特效
		end
	end
end

--命中判断
function RoleAllParm:Collide(attackInstanceId,hitInstanceId,instanceId,shakeStrenRatio,attackType)
	--角色通用攻击延长判断时间
	if attackInstanceId == self.Me and (attackType == 1 or attackType == 2 or attackType == 5 or attackType == 6) then
		--if BF.GetEntityElementStateAccumulationRatio(hitInstanceId,-1) >= 10000 then
			--BF.EnterEntityElementState(attackInstanceId,hitInstanceId,-1)	--设置元素状态
			--BF.SetEntityElementStateDurationTime(hitInstanceId,-1,20) 		--设置元素状态持续时间
			--BF.AddBuff(attackInstanceId,hitInstanceId,1000024,1)			--临时火属性表现特效
		--end
		--if BF.CheckEntityElementState(hitInstanceId,-1) and self.RoleReboundFrame < self.RealFrame then
	end
end

--伤害计算后
function RoleAllParm:AfterDamage(attackInstanceId,hitInstanceId,damageType,magicId,damageElementType,damageVal,attackType)
	if attackInstanceId == self.Me and (attackType == 1 or attackType == 2 or attackType == 5 or attackType == 6) then
		--if BF.CheckEntityElementState(hitInstanceId,FE.ElementState.Ready,-1) and not BF.HasBuffKind(self.Me,1000023)
		if not BF.CheckEntityElementState(hitInstanceId,FE.ElementState.Cooling,-1) and BF.CheckEntityElementState(hitInstanceId,FE.ElementState.Ready,-1)
			and not BF.HasEntitySign(1,10000099) then
			self.RoleAttackFrame = self.MyFrame + 30
			if BF.CheckEntity(hitInstanceId) then
				self.QTETarget = hitInstanceId
			end
			--BF.SetEntityElementStateCd(hitInstanceId, 1, -1)
			--BF.EnterEntityElementStateCooling(attackInstanceId, hitInstanceId, 20, -1)
			--BehaviorFunctions.AddEntityElementStateAccumulation(hitInstanceId,hitInstanceId,-1,-50)
		end
	end
end

--元素就绪装填 / QTE破防回调
function RoleAllParm:EnterElementStateReady(atkInstanceId, instanceId, element)
	if self.CtrlRole == self.Me and not BF.HasEntitySign(instanceId,92003019) then
		BF.SetEntityElementReadyTime(instanceId, 10, -1)
		BF.AddBuff(self.Me,self.Me,1000010,1)	--克制条满顿帧
		BF.AddBuff(self.Me,instanceId,1000041,1)	--克制条满怪物晕眩
		BF.AddBuff(self.Me,instanceId,1000043,1)	--克制条满破防特效
		BF.DoEntityAudioPlay(self.Me,"broken",true)
	end
end

--大招QTE触发判断
function RoleAllParm:UltimateQTEPart()
	if self.CtrlRole == self.Me and BF.GetSkillSign(self.Me,10000011) --大招QTE触发窗口
		and not BF.HasEntitySign(1,10000099) and self.RoleAttackFrame > self.MyFrame
		and not BF.HasBuffKind(self.Me,1000008) and not BF.HasBuffKind(self.Me,5001)
		and not BF.HasBuffKind(self.Me,5002) then

		self.RoleAttackFrame = 0 --清除记录时间
		self.RAB.RoleCatchSkill:ClearButtonPart(-1,"ClearAll") --清除所有按钮缓存记录
		BF.AddBuff(self.Me,1,1000090,1) --忽略怪物全局顿帧效果
		BF.AddEntitySign(1,10000002,0.8,false) --给场景怪加大招QTE激活标记
		BF.AddEntitySign(1,10000028,0.04,false) --大招QTE触发标记，存在1帧给关卡判断用
		--self.UltimateQTE = BF.DoShowSwitchQTE(self.Me,10) --显示10秒大招QTE界面
		BF.AddBuff(self.Me,self.Me,1000029,1) 	--大招QTE选择期间顿帧
		BF.SetAllEntityLifeBarVisibleType(3)	--隐藏小怪血条
		if BF.CheckEntity(self.QTETarget) then
			BF.SetEntityElementReadyTime(self.QTETarget,999,-1)
			BF.SetBodyDamping(0.5,0.5,0.5) --设置镜头跟随过渡时间
			BF.SetCameraLookAt(self.QTETarget,"HitCase") --设置怪物受击点为镜头看向点
			BF.SetCameraFollow(self.QTETarget,"HitCase") --设置怪物受击点为镜头跟随点
			--BF.AddBuff(self.Me,self.QTETarget,1000032,1)	--大招QTE暂停半透明效果
			BF.SetEntityElementStateIgnoreTimeScale(nil,true)
			if BF.HasBuffKind(self.QTETarget,1000041) then
				BF.SetBuffEffectIgnoreTimeScale(self.QTETarget,1000041,true,1) --设置克制条满怪物晕眩特效不受顿帧
				BF.SetAllEffectKeyWordControl(100000020,{{instanceId = self.QTETarget, buffId = 1000041}},true) --全局特效透明度设置
				--BehaviorFunctions.SetAllEffectKeyWordControl(100000020,{},true) --全局特效透明度设置
				--BF.SetEffectKeyWordControlByIds(100000021,{{instanceId = self.QTETarget, buffId = 1000043}})
				--local p = BF.GetPositionP(self.QTETarget)
				--BF.SetEffectKeyWordControlByRadius(100000020,{{instanceId = self.QTETarget, buffId = 1000041}},p,3) --球型范围特效透明度设置
				--BF.SetEffectKeyWordControlByCylinder(100000020,{{instanceId = self.QTETarget, buffId = 1000041}},p,3,5) --圆柱形特效透明度设置
			else
				BF.SetAllEffectKeyWordControl(100000020,{}) --全局特效透明度设置
			end
		else
			BF.SetBodyDamping(0.6,0.6,0.6) --设置镜头跟随过渡时间
			BF.SetCameraLookAt(self.Me,"HitCase") --设置角色受击点为镜头看向点
			BF.SetCameraFollow(self.Me,"HitCase") --设置角色受击点为镜头跟随点
		end
		BF.ForceFix(100000006,0.6)				--强制执行角色镜头朝向侧面
		--BF.StopBlend()						--停止镜头之间过渡摆动
		BF.AddDelayCallByFrame(18,BehaviorFunctions,BehaviorFunctions.StopBlend) --延时 - 设置镜头停止过度
		BF.RemoveAllShake()						--移除所有镜头震屏效果
		BF.EnableShake(false)					--镜头震屏效果关闭
		BF.StopAllCameraOffset()				--停止镜头偏移效果
		BF.AddDelayCallByFrame(18,BehaviorFunctions,BehaviorFunctions.SetCameraRotatePause,true) --延时 - 设置镜头锁定朝向开关
		BF.AddBuff(self.Me,self.Me,1000030,1)	--大招QTE镜头固定修正Z偏移
		BF.AddBuff(self.Me,self.Me,1000031,1)	--大招QTE免疫伤害-受击-强制位移-死亡-子弹受击-受击朝向
		--BF.AddBuff(self.Me,self.Me,1000032,1)	--大招QTE暂停半透明效果
		--BF.DoShowPosVague(self.Me,0.15, 150, 100000005, 0.85, 1, 40, 0.5,0.35, 0,30) --镜头扭曲效果
		BF.ClearAllInput()
		--BF.CancelJoystick() --取消摇杆输入

		--if self.MemberNum == 2 then
			--BehaviorFunctions.PlayQTEUIEffect(self.UltimateQTE, "LeftEffect", "LeftEffect")
			--BehaviorFunctions.PlayQTEUIEffect(self.UltimateQTE, "RightEffect", "RightEffect")
		--elseif self.MemberNum == 3 then
			--BehaviorFunctions.PlayQTEUIEffect(self.UltimateQTE, "ThreeLeftEffect", "LeftEffect")
			--BehaviorFunctions.PlayQTEUIEffect(self.UltimateQTE, "ThreeRightEffect", "RightEffect")
		--elseif self.MemberNum == 1 then
			--BehaviorFunctions.PlayQTEUIEffect(self.UltimateQTE, "RightEffect", "Single")
		--end
		BF.AddEntitySign(1,10000099,5,true) --临时QTE冷却时间
	end
end

--跳跃闪避判断
function RoleAllParm:JumpDodge(attackInstanceId,hitInstanceId,limit,notJumpBeatBack)
	if hitInstanceId == self.Me and not BF.HasBuffKind(self.Me,1000033) and not BF.HasBuffKind(self.Me,1000034) then
		--BF.CreateEntity(1000000015,self.Me,self.MyPos.x,self.MyPos.y,self.MyPos.z) --释放跳跃闪避特效
		BF.DoEntityAudioPlay(self.Me,"AirCounter",true)
		BF.AddBuff(self.Me,self.Me,1000033,1) --跳跃闪避各种免疫
		BF.AddEntitySign(self.Me,10000023,-1) --当前角色准备释放跳跃反击标记
		BF.SetAllEntityLifeBarVisibleType(3)
		--BF.SetFightMainNodeVisible(2,"PanelParent",false)	--隐藏主UI
		BF.SetFightPanelVisible("00010000")	--显示摇杆
		BF.SetJoyStickVisibleByAlpha(2, false, false)
		BF.ClearAllInput()
		--BF.CancelJoystick()
		if BF.CheckEntity(attackInstanceId) then
			self.LockTarget = attackInstanceId
			self.AttackTarget = attackInstanceId
			local lock,attack,part = BF.SearchEntityPart(self.Me,attackInstanceId,999,0,360,1,0.3,true,1,1,true,false)
			local lock1,attack1,part1 = BF.SearchEntityPart(self.Me,attackInstanceId,999,0,360,1,0.3,false,1,1,false,true)
			self.LockTargetPoint = lock
			self.LockTargetPart = part
			self.AttackTargetPoint = attack1
			self.AttackTargetPart = part1
			if not BF.HasEntitySign(1,10000007) then
				BF.SetLockTarget(self.LockTarget,self.LockTargetPoint)
				BF.SetCameraState(FE.CameraState.WeakLocking)
				self.CameraType = 2 --弱锁定镜头
				self.CancelLockFrame = self.RealFrame + 30 --移除锁定镜头延迟时间
			elseif BF.HasEntitySign(1,10000007) then
				BF.SetLockTarget(self.LockTarget,self.LockTargetPoint)
				BF.SetCameraState(FE.CameraState.ForceLocking)
				self.CameraType = 3 --弱锁定镜头
				self.CancelLockFrame = self.RealFrame + 99999 --移除锁定镜头延迟时间
			end
		end
		--待机切换等待时间
		self.LeisurelyIdleChangeFrame = self.RealFrame + 150
		BF.AddSkillPoint(self.Me,1202,1)	--增加1格蓝色资源
		BF.SetCameraParams(FightEnum.CameraState.ForceLocking,10000001,false)
	end
end

--跳反QTE触发
function RoleAllParm:JumpQTEPart(instanceId, prefab, icon, isShowCountDown, isShowProgress, anchorType,posX, posY, duration, times)
	self.JumpQTE = BehaviorFunctions.DoShowClickQTE(instanceId,prefab,icon,isShowCountDown,isShowProgress,anchorType,posX,posY,duration,times)
end

--QTE退出回调 / 跳跃反击
function RoleAllParm:ExitQTE(qteType, returnValue, qteId)
	if self.JumpQTE == qteId and (returnValue == true or BF.HasEntitySign(self.Me,10000029))then
		--BehaviorFunctions.StopQTEUIEffect(qteId, "22044", "QTEEffect")
		if BF.GetEntityState(self.Me) == FES.Skill then
			BF.BreakSkill(self.Me)
		end
		self.RAB.RoleCatchSkill:ActiveSkill(0,self.MainBehavior.JumpAttack[2],2,2,0,0,0,{0},"Immediately","",false)
		self.CurrentSkillPriority = 81
		self.LeisurelyIdleChangeFrame = self.RealFrame + 150
		self.CancelLockFrame = self.RealFrame + 5
		--BF.RemoveBuff(self.Me,self.Me,1000029,5) --大招QTE顿帧
		--BF.SetFightMainNodeVisible(2,"PanelParent",true)	--显示主UI
		BF.SetFightPanelVisible("-1")	--显示怪物信息&摇杆
		BF.SetJoyStickVisibleByAlpha(2, true, true)
		BF.ForbidKey(FK.ScreenPress,false)
		BF.ForbidKey(FK.ScreenMove,false)
		BF.SetAllEntityLifeBarVisibleType(1)
		BF.ClearAllInput()
		BF.CancelJoystick()
	elseif self.JumpQTE == qteId and returnValue == false then
		--BF.SetFightMainNodeVisible(2,"PanelParent",true)	--显示主UI
		BF.SetFightPanelVisible("-1")	--显示怪物信息&摇杆
		BF.SetJoyStickVisibleByAlpha(2, true, true)
		BF.ForbidKey(FK.ScreenPress,false)
		BF.ForbidKey(FK.ScreenMove,false)
		BF.SetAllEntityLifeBarVisibleType(1)
		BF.SetCameraParams(FightEnum.CameraState.ForceLocking) --重置强锁定镜头参数
	end

	--冰冻
	if self.DebuffIceQTE == qteId then
		BF.RemoveBuffByKind(self.Me,5001)
		BF.RemoveBuffByKind(self.Me,50001)
		BehaviorFunctions.StopQTEUIEffect(qteId, "22046", "QTEEffect")
		BF.AddBuff(self.Me,self.Me,1000039,1)--冰冻抗性
		BehaviorFunctions.SetEntityComponentEnable(self.Me, CS.DynamicBones, true, true)
	end
	--眩晕
	if self.DebuffDizzyQTE == qteId then
		BF.RemoveBuffByKind(self.Me,5002)
		BehaviorFunctions.StopQTEUIEffect(qteId, "22046", "QTEEffect")
		BF.AddBuff(self.Me,self.Me,1000040,1)--眩晕抗性
	end
	--魅惑
	if self.DebuffDizzyQTE == qteId then
		BF.RemoveBuffByKind(self.Me,5003)
		BehaviorFunctions.StopQTEUIEffect(qteId, "22046", "QTEEffect")
		BF.AddBuff(self.Me,self.Me,1000070,1)--魅惑抗性
	end
end

--点击QTE回调
function RoleAllParm:ClickQTE(qteId)
	--冰冻
	if self.DebuffIceQTE == qteId and BehaviorFunctions.CheckBuffKind(self.Me,self.DebuffIceId,5001) then
		BehaviorFunctions.ChangeDebuffQTETime(self.Me, qteId, -self.DebuffIceTime* 0.1)
		BehaviorFunctions.PlayBoneShake(self.Me, 9998, "Root")
	end
	--眩晕
	if self.DebuffDizzyQTE == qteId and BehaviorFunctions.CheckBuffKind(self.Me,self.DebuffDizzyId,5002) then
		BehaviorFunctions.ChangeDebuffQTETime(self.Me, qteId, -self.DebuffDizzyTime* 0.1)
	end
	--魅惑
	if self.DebuffDizzyQTE == qteId and BehaviorFunctions.CheckBuffKind(self.Me,self.DebuffDizzyId,5003) then
		BehaviorFunctions.ChangeDebuffQTETime(self.Me, qteId, -self.DebuffDizzyTime* 0.1)
	end
end
	
--弹刀判断
function RoleAllParm:ReboundAttack(instanceId,instanceId2)
	if instanceId == self.Me then
		--self.RoleReboundFrame = self.RealFrame + 15
		local p = BF.GetPositionP(instanceId)
		if BF.CheckEntity(self.Me,instanceId2) then
			p = BF.GetPositionP(instanceId2)
		end
		BF.CreateEntity(1000000007,self.Me,p.x,self.MyPos.y,p.z) --释放一般弹反特效
		BF.AddBuff(self.Me,self.Me,1000021,1) --弹刀镜头偏移
		BF.AddBuff(self.Me,self.Me,1000022,1) --弹刀震屏
		BF.AddBuff(self.Me,self.Me,1000023,1) --弹刀顿帧
		BF.AddEntityElementStateAccumulation(instanceId2,self.Me,-1,20) --弹刀成功增加目标克制条
		BF.DoEntityAudioPlay(self.Me,"Counter",true) --音效
		BF.AddSkillPoint(self.Me,1201,1)	--增加1格黄色资源
		--BF.AddSkillPoint(self.Me,1201,1)	--增加1格黄色资源
		BF.ChangeEntityAttr(self.Me,1204,75,1)--增加核心资源
	end
end

--添加buff判断
function RoleAllParm:AddBuff(entityInstanceId,buffInstanceId,buffId)
	if entityInstanceId == self.Me and self.CtrlRole == self.Me then
		if BF.GetEntityAttrVal(self.Me,1001) > 0 then
			--冻结
			if BehaviorFunctions.CheckBuffKind(entityInstanceId,buffInstanceId,5001) then
				self.DebuffIceId = buffInstanceId
				self.DebuffIceTime = BehaviorFunctions.GetBuffTime(entityInstanceId,buffInstanceId)
				self.DebuffIceQTE = BehaviorFunctions.DoShowDebuffQTE(self.Me, self.DebuffIceTime, 5001)
				BehaviorFunctions.PlayQTEUIEffect(self.DebuffIceQTE, "22046", "QTEEffect")
				--BF.DoMagic(self.Me,self.Me,1000037,1)
				BehaviorFunctions.AddBuff(entityInstanceId,entityInstanceId,1000038,1)
				BehaviorFunctions.SetEntityComponentEnable(self.Me, CS.DynamicBones, false, true)
			end

			--眩晕
			if BehaviorFunctions.CheckBuffKind(entityInstanceId,buffInstanceId,5002) then
				self.DebuffDizzyTime = BehaviorFunctions.GetBuffTime(entityInstanceId,buffInstanceId)
				self.DebuffDizzyQTE = BehaviorFunctions.DoShowDebuffQTE(self.Me, self.DebuffDizzyTime, 5002)
				BehaviorFunctions.PlayQTEUIEffect(self.DebuffDizzyQTE, "22046", "QTEEffect")
				self.DebuffDizzyId = buffInstanceId
			end
			
			--魅惑
			if BehaviorFunctions.CheckBuffKind(entityInstanceId,buffInstanceId,5003) then
				self.DebuffDizzyTime = BehaviorFunctions.GetBuffTime(entityInstanceId,buffInstanceId)
				self.DebuffDizzyQTE = BehaviorFunctions.DoShowDebuffQTE(self.Me, self.DebuffDizzyTime, 5003)
				BehaviorFunctions.PlayQTEUIEffect(self.DebuffDizzyQTE, "22046", "QTEEffect")
				self.DebuffDizzyId = buffInstanceId
			end
		else
			BF.RemoveBuff(self.Me,buffId)
		end

	end
end

--通用参数开放
function RoleAllParm:SetEntityValuePart()
	--目标参数开放
	if not BF.HasEntitySign(1,10000001) then
		BF.SetEntityValue(self.Me,"LockTarget",self.LockTarget)
		BF.SetEntityValue(self.Me,"LockTargetPoint",self.LockTargetPoint)
		BF.SetEntityValue(self.Me,"LockTargetPart",self.LockTargetPart)

		BF.SetEntityValue(self.Me,"AttackTarget",self.AttackTarget)
		BF.SetEntityValue(self.Me,"AttackTargetPoint",self.AttackTargetPoint)
		BF.SetEntityValue(self.Me,"AttackTargetPart",self.AttackTargetPart)

		BF.SetEntityValue(self.Me,"LockAltnTarget",self.LockAltnTarget)
		BF.SetEntityValue(self.Me,"LockAltnTargetPoint",self.LockAltnTargetPoint)
		BF.SetEntityValue(self.Me,"LockAltnTargetPart",self.LockAltnTargetPart)

		BF.SetEntityValue(self.Me,"AttackAltnTarget",self.AttackAltnTarget)
		BF.SetEntityValue(self.Me,"AttackAltnTargetPoint",self.AttackAltnTargetPoint)
		BF.SetEntityValue(self.Me,"AttackAltnTargetPart",self.AttackAltnTargetPart)
	end
	
	BF.SetEntityValue(self.Me,"partnerAngle",self.MyFrontPos)
	BF.SetEntityValue(self.Me,"CancelLockFrame",self.CancelLockFrame)
	BF.SetEntityValue(self.Me,"QTETarget",self.QTETarget)
	BF.SetEntityValue(self.Me,"RAP",self.RAP)
	BF.SetEntityValue(self.Me,"RAB",self.RAB)
	
	BF.SetEntityValue(self.Me,"QTEPosRef",self.MainBehavior.QTEPosRef)
	BF.SetEntityValue(self.Me,"QTEtype",self.MainBehavior.QTEtype)
	BF.SetEntityValue(self.Me,"QTESkill",self.MainBehavior.QTESkill[1])
	BF.SetEntityValue(self.Me,"QTEChangeCD",self.MainBehavior.QTEChangeCD)
	BF.SetEntityValue(self.Me,"NormalAttack",self.MainBehavior.NormalAttack)
	BF.SetEntityValue(self.Me,"UltimateSkill1",self.MainBehavior.UltimateSkill[1])
	BF.SetEntityValue(self.Me,"UltimateSkill2",self.MainBehavior.UltimateSkill[2])
	BF.SetEntityValue(self.Me,"MoveSkill",self.MainBehavior.MoveSkill[1])
	
	BF.SetEntityValue(self.Me,"CameraType",self.CameraType)
	BF.SetEntityValue(self.Me,"PressButton1",self.PressButton[1])
	BF.SetEntityValue(self.Me,"PressButton2",self.PressButton[2])
	BF.SetEntityValue(self.Me,"PressButton3",self.PressButton[3])
	BF.SetEntityValue(self.Me,"PressButtonFrame1",self.PressButtonFrame[1])
end