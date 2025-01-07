Behavior1000001 = BaseClass("Behavior1000001",EntityBehaviorBase)

local BF = BehaviorFunctions
local FE = FightEnum
local FQT = FightEnum.QTEType
local FQS = FightEnum.QTEState
local FES = FightEnum.EntityState
local FEMSS = FightEnum.EntityMoveSubState
local FCS = FightEnum.CameraState
local FK = FightEnum.KeyEvent

function Behavior1000001.GetGenerates()
	local generates = {1000000000,1000000001,1000000002}
	return generates
end
function Behavior1000001.GetMagics()
	local generates = {}
	return generates
end

--通用角色需要场景怪判断逻辑
function Behavior1000001:Init()
	--变量声明
	self.RealFrame = 0				--记录世界帧数
	self.Me = self.instanceId		--记录自己
	self.CtrlRole = 0				--玩家当前角色
	self.Role1 = 0					--序号1角色
	self.Role2 = 0					--序号2角色
	self.Role3 = 0					--序号3角色
	self.RoleDiyueResRadio = 0		--缔约值记录
	self.CreateDiyueLineBool = 0	--缔约线创建开关
	self.DiyueLine = 0				--缔约线实体记录
	self.DiyueStepNum = 0			--缔约流程步骤序号
	
	self.QTELeaveFrame = 0	--QTE退场延迟帧数
	self.QTELeaveRole = 0	--QTE退场角色
	self.QTETarget = 0
	
	self.RFillEndEffectCloseFrame = 0	--缔约状态结束动效移除时间
end

function Behavior1000001:Update()
	
	BF.GetEntityValue(self.Me,"LevelUiTarget")
	
	--记录世界时间
	self.RealFrame = BF.GetFightFrame()
	
	--记录全队角色
	self.CtrlRole = BF.GetCtrlEntity()
	self.Role1 = BF.GetQTEEntity(1)
	self.Role2 = BF.GetQTEEntity(2)
	self.Role3 = BF.GetQTEEntity(3)

	--技能帧事件当前角色标记--施加和移除判断
	if BF.CheckEntity(self.CtrlRole) and not BF.CheckSkillEventActiveSign(self.CtrlRole,10000000) then
		BF.AddSkillEventActiveSign(self.CtrlRole,10000000)
	end
	if BF.CheckEntity(self.Role1) and self.Role1 ~= self.CtrlRole and BF.CheckSkillEventActiveSign(self.Role1,10000000) then
		BF.RemoveSkillEventActiveSign(self.Role1,10000000)
	end
	if BF.CheckEntity(self.Role2) and self.Role2 ~= self.CtrlRole and BF.CheckSkillEventActiveSign(self.Role2,10000000) then
		BF.RemoveSkillEventActiveSign(self.Role2,10000000)
	end
	if BF.CheckEntity(self.Role3) and self.Role3 ~= self.CtrlRole and BF.CheckSkillEventActiveSign(self.Role3,10000000) then
		BF.RemoveSkillEventActiveSign(self.Role3,10000000)
	end
	
	--当前角色低血量动效判断
	if BF.CheckEntity(self.CtrlRole) and BF.GetEntityAttrValueRatio(self.CtrlRole,1001) <= 3500 then
		BF.SetFightMainNodeVisible(2,"21005",true,1)
	else
		BF.SetFightMainNodeVisible(2,"21005",false,1)
	end
	
	--大招QTE出场衔接释放大招判断
	if BF.GetSkillSign(self.CtrlRole,10000009) then
		BF.BreakSkill(self.CtrlRole)
		local RABC1 = BF.GetEntityValue(self.CtrlRole,"RAB").RoleCatchSkill
		local UltimateSkill1 = BF.GetEntityValue(self.CtrlRole,"UltimateSkill1")
		BF.CallBehaviorFuncByEntityEx(RABC1,"ActiveSkill",0,UltimateSkill1,5,3,0,0,0,{0},"Immediately","",true,0,-1)
		--移除场景怪的QTE激活标记
		if BF.HasEntitySign(self.Me,10000002) then
			BF.RemoveEntitySign(self.Me,10000002)
		end
		BF.RemoveBuff(self.CtrlRole,1000031,5) 	--移除QTE大招选择期间-免伤害+受击+强制位移+死亡+子弹受击+受击朝向
		if BF.HasEntitySign(1,10000020) then
			BF.SetFightPanelVisible("-1")
			BF.SetJoyStickVisibleByAlpha(2, true, true)
		else
			BF.SetFightPanelVisible("-1")
			BF.SetJoyStickVisibleByAlpha(2, true, true)
			--BF.SetFightMainNodeVisible(2,"PanelParent",true) --显示主UI
		end
		BF.ForbidKey(FK.ScreenPress,false)		--取消屏蔽镜头点按输入
		BF.ForbidKey(FK.ScreenMove,false)		--取消屏蔽镜头移动输入
		BF.SetDamageFontVisible(true)			--显示伤害数字
		BF.SetLockPointVisible(true)			--显示锁定点UI
		BF.SetAllEntityLifeBarVisibleType(1) 	--显示血条
		BF.EnableShake(true)					--取消屏蔽震屏
		BF.SetCameraRotatePause(false)			--取消屏蔽镜头旋转
		BF.SetSoftZone(false)					--取消镜头全屏缓动区域
		BF.SetBodyDamping() 					--恢复镜头跟随过渡时间
		BF.SetCameraLookAt(self.CtrlRole)		--设置镜头看向点
		BF.SetCameraFollow(self.CtrlRole)		--设置镜头跟随点
		if BF.CheckEntity(self.QTELeaveRole) then
			BF.RemoveBuff(self.QTELeaveRole,1000030,5) --QTE大招镜头偏移
		end
		BF.AddSkillPoint(self.CtrlRole,1202,3)	--增加3格蓝色资源
		BF.AllEntityEnterElementCoolingState(self.Me,nil,8,-1) --全局怪物设置元素冷却状态
		if BF.CheckEntity(self.QTETarget) then
			BF.AddEntityElementReadyTime(self.QTETarget,-9999,-1)
			if BF.HasBuffKind(self.QTETarget,1000032) then
				BF.RemoveBuff(self.QTETarget,1000032)
			end
			if BF.HasBuffKind(self.QTETarget,1000041) then
				BF.SetBuffEffectIgnoreTimeScale(self.QTETarget,1000041,false) --设置克制条满怪物晕眩特效不受顿帧
			end
			BF.SetEntityElementStateIgnoreTimeScale(nil,false) --取消元素状态缩放
			BF.CancelEffectKeyWordControl() --取消特效透明度调整
		end
	end
	
	--大招QTE退场流程判断
	if BF.CheckEntity(self.QTELeaveRole) and BF.HasEntitySign(self.QTELeaveRole,10000026) then
		if self.QTELeaveFrame < self.RealFrame and self.QTELeaveFrame ~= 0 then
			--尝试打断在场角色技能状态
			--if CtrlState == FES.Skill and (BF.GetSkillType(ForeInstanceId) ~= 50 or (BF.GetSkillType(ForeInstanceId) == 50 and BF.CanCastSkill(ForeInstanceId))) then
				--BF.BreakSkill(ForeInstanceId)
			--end
			BF.BreakSkill(self.QTELeaveRole)
			local Role1Pos = BF.GetPositionP(self.QTELeaveRole)
			if BF.CheckEntityHeight(self.QTELeaveRole) > 0.2 then
				Role1Pos.y = Role1Pos.y - BF.CheckEntityHeight(self.QTELeaveRole)
			end
			local RABC1 = BF.GetEntityValue(self.QTELeaveRole,"RAB").RoleCatchSkill
			BF.CallBehaviorFuncByEntityEx(RABC1,"MoveSkill",0,3,3,0,0,0,{21},"")
			BF.SetEntityTranslucent(self.QTELeaveRole,2,0.4333) --模型透明度渐出效果
			self.QTELeaveFrame = 0
		end
		--大招QTE退场判断
		if BF.GetSkillSign(self.QTELeaveRole,10000010) then
			BF.BreakSkill(self.QTELeaveRole)
			BF.RemoveBuff(self.QTELeaveRole,1000030,5) 	--移除QTE大招选择期间-镜头偏移
			BF.RemoveBuff(self.QTELeaveRole,1000031,5)	--移除QTE大招选择期间-免伤害+受击+强制位移+死亡+子弹受击+受击朝向
			--BF.RemoveBuff(self.QTELeaveRole,1000032,5) 	--移除QTE大招选择期间-暂停实体半透明
			BF.RemoveEntitySign(self.QTELeaveRole,10000026)	--移除QTE大招延迟退场标记
			BF.SetEntityBackState(self.QTELeaveRole,FE.Backstage.Background)
		end
	end
	
	--大招QTE状态判断
	if BF.HasEntitySign(self.Me,10000002) then
		--如果怪物血条显示
		if BF.HasEntitySign(1,10000020) then
			BF.SetFightPanelVisible("00010001")	--显示怪物信息&摇杆
			BF.SetJoyStickVisibleByAlpha(2, false, false)
		else
			--BF.SetFightMainNodeVisible(2,"PanelParent",false)	--隐藏主UI
			BF.SetFightPanelVisible("00010001")	--显示怪物信息&摇杆
			BF.SetJoyStickVisibleByAlpha(2, false, false)
		end
		BF.ForbidKey(FK.ScreenPress,true)		--屏蔽镜头点按输入
		BF.ForbidKey(FK.ScreenMove,true)		--屏蔽镜头滑动输入
		BF.SetDamageFontVisible(false)			--隐藏伤害数字
		BF.SetLockPointVisible(false)			--隐藏锁定点UI
		
		if BF.HasBuffKind(self.CtrlRole,1000029) then
			self.QTETarget = BF.GetEntityValue(self.CtrlRole,"QTETarget")
		end
		if BF.CheckEntity(self.QTETarget) then
			BF.SetEntityLifeBarVisibleType(self.QTETarget,2)
			if not BF.HasBuffKind(self.QTETarget,1000032) then
				BF.AddBuff(self.QTETarget,self.QTETarget,1000032,1)
			end
			BF.SetEntityElementStateIgnoreTimeScale(nil,true)
		end
		BF.EnableShake(false)					--屏蔽震屏
		BF.SetCameraRotatePause(true)			--屏蔽镜头旋转
	end
	
	----极限闪避就绪判断
	--if BF.CheckEntity(self.CtrlRole) and BF.GetDodgeLimitState(self.CtrlRole) == DodgeComponent.LimitState.Enable then
		--BF.PlayFightUIEffect("22003","K")
	--else
		--BF.StopFightUIEffect("22003","K")
	--end
	
	--极限闪避状态判断
	if BF.HasBuffKind(self.Me,1000006) then
		--BF.AddEntitySign(self.Me,10000015,0.1) --增加极限闪避标记
		--if BF.CheckEntity(self.Role1) and not BF.HasBuffKind(self.Role1,1000004) then
			--BF.DoMagic(self.Me,self.Role1,1000004,1) --对角色施加3秒内免疫子弹受击效果
		--end
		--if BF.CheckEntity(self.Role2) and not BF.HasBuffKind(self.Role2,1000004) then
			--BF.DoMagic(self.Me,self.Role2,1000004,1)
		--end
		--if BF.CheckEntity(self.Role3) and not BF.HasBuffKind(self.Role3,1000004) then
			--BF.DoMagic(self.Me,self.Role3,1000004,1)
		--end
	--非极限闪避判断
	elseif not BF.HasBuffKind(self.Me,1000006) then
		--BF.RemoveEntitySign(self.Me,10000015) --移除极限闪避标记
		--if BF.CheckEntity(self.Role1) and BF.HasBuffKind(self.Role1,1000004) then
			--BF.RemoveBuff(self.Role1,1000004,5) --尝试移除3秒内免疫子弹受击效果
		--end
		--if BF.CheckEntity(self.Role2) and BF.HasBuffKind(self.Role2,1000004) then
			--BF.RemoveBuff(self.Role2,1000004,5)
		--end
		--if BF.CheckEntity(self.Role3) and BF.HasBuffKind(self.Role3,1000004) then
			--BF.RemoveBuff(self.Role3,1000004,5)
		--end
	end
	
	--战斗状态判断
	if not BF.CheckPlayerInFight() then
		BF.SetCameraParams(FightEnum.CameraState.Operating,1000)
		BF.SetCameraParams(FightEnum.CameraState.WeakLocking,1100)
	elseif BF.CheckPlayerInFight() and not BF.HasEntitySign(self.Me,10000007) then
		BF.SetCameraParams(FightEnum.CameraState.Operating,1001)
		--BF.SetCameraParams(FightEnum.CameraState.ForceLocking,1101)
	end

end

--实体标记移除
function Behavior1000001:RemoveEntitySign(instanceId,sign)
	--if sign == 10000002 then
		--Log("1111111111111111111")
	--end
	if instanceId == self.Me and sign == 10000002 then
		
		BF.RemoveBuff(self.CtrlRole,1000029,5) --移除QTE大招选择期间-顿帧
		BF.RemoveBuff(self.CtrlRole,1000030,5) --移除QTE大招选择期间-镜头偏移
		BF.RemoveBuff(self.CtrlRole,1000031,5) --移除QTE大招选择期间-免伤害+受击+强制位移+死亡+子弹受击+受击朝向
		--BF.RemoveBuff(self.CtrlRole,1000032,5) --移除QTE大招选择期间-暂停实体半透明
		BF.AllEntityEnterElementCoolingState(self.Me,nil,8,-1) --全局怪物设置元素冷却状态
		self.QTETarget = BF.GetEntityValue(self.CtrlRole,"QTETarget")
		if BF.CheckEntity(self.QTETarget) then
			BF.AddEntityElementReadyTime(self.QTETarget,-9999,-1)
			if BF.HasBuffKind(self.QTETarget,1000032) then
				BF.RemoveBuff(self.QTETarget,1000032)
			end
			BF.SetEntityElementStateIgnoreTimeScale(nil,false) --取消元素状态缩放
			BF.CancelEffectKeyWordControl() --取消特效透明度缩放
		end
		if BF.CheckEntity(self.QTETarget) and BF.HasBuffKind(self.QTETarget,1000041) then
			BF.SetBuffEffectIgnoreTimeScale(self.QTETarget,1000041,false) --设置克制条满怪物晕眩特效不受顿帧
		end
		if BF.HasEntitySign(1,10000020) then
			BF.SetFightPanelVisible("-1")
			BF.SetJoyStickVisibleByAlpha(2, true, true)
		else
			BF.SetFightPanelVisible("-1")
			BF.SetJoyStickVisibleByAlpha(2, true, true)
			--BF.SetFightMainNodeVisible(2,"PanelParent",true)	--显示主UI
		end
		BF.EndPosVague(self.CtrlRole,0) 		--关闭QTE大招选择期间-径向模糊
		BF.ForbidKey(FK.ScreenPress,false)		--取消屏蔽镜头点按输入
		BF.ForbidKey(FK.ScreenMove,false)		--取消屏蔽镜头移动输入
		BF.SetDamageFontVisible(true)			--显示伤害数字
		BF.SetLockPointVisible(true)			--显示锁定点UI
		BF.SetAllEntityLifeBarVisibleType(1)	--显示血条
		self.CtrlRole = BF.GetCtrlEntity()
		BF.EnableShake(true)					--取消屏蔽震屏
		BF.SetCameraRotatePause(false)			--取消屏蔽镜头旋转
		BF.SetBodyDamping() 					--设置镜头跟随过渡时间
		BF.SetCameraLookAt(self.CtrlRole)		--设置镜头看向点
		BF.SetCameraFollow(self.CtrlRole)		--设置镜头跟随点
		--BF.AddSkillPoint(self.CtrlRole,1202,3)	--增加3格蓝色资源

	end
end

--通用换人逻辑，QTEIndex为点击头像，Role1指代在场角色，Role2指代点击头像的后台角色
function Behavior1000001:ChangeRole(QTEIndex,Role1,Role2)

	local ChangePos = BF.GetPositionP(Role1)
	local CtrlState = BF.GetEntityState(Role1)
	local CrtlQTEIndex = BF.GetEntityState(Role1)
	if Role1 == Role2 or BehaviorFunctions.HasBuffKind(Role1,5002) or BehaviorFunctions.HasBuffKind(Role1,1000008) or BehaviorFunctions.HasEntitySign(Role1,600000) then
		return
	end
	--存在QTE激活标记，则进行QTE判断
	if BF.CheckQTEState(QTEIndex,FQT.QTE,FQS.Ready) and BF.CheckEntity(Role2) and BF.CheckEntity(Role1)then
		--Role1目标传递给Role2
		if BF.CheckEntity(BF.GetEntityValue(Role1,"AttackTarget")) then
			BF.SetEntityValue(Role2,"AttackTarget",BF.GetEntityValue(Role1,"AttackTarget"))
			BF.SetEntityValue(Role2,"AttackTargetPoint",BF.GetEntityValue(Role1,"AttackTargetPoint"))
			BF.SetEntityValue(Role2,"AttackTargetPart",BF.GetEntityValue(Role1,"AttackTargetPart"))
		elseif BF.CheckEntity(BF.GetEntityValue(Role1,"AttackAltnTarget")) then
			BF.SetEntityValue(Role2,"AttackTarget",BF.GetEntityValue(Role1,"AttackAltnTarget"))
			BF.SetEntityValue(Role2,"AttackTargetPoint",BF.GetEntityValue(Role1,"AttackAltnTargetPoint"))
			BF.SetEntityValue(Role2,"AttackTargetPart",BF.GetEntityValue(Role1,"AttackAltnTargetPart"))
		end
		
		if BF.CheckEntity(BF.GetEntityValue(Role1,"LockTarget")) then
			BF.SetEntityValue(Role2,"LockTarget",BF.GetEntityValue(Role1,"LockTarget"))
			BF.SetEntityValue(Role2,"LockTargetPoint",BF.GetEntityValue(Role1,"LockTargetPoint"))
			BF.SetEntityValue(Role2,"LockTargetPart",BF.GetEntityValue(Role1,"LockTargetPart"))
		elseif BF.CheckEntity(BF.GetEntityValue(Role1,"LockAltnTarget")) then
			BF.SetEntityValue(Role2,"LockTarget",BF.GetEntityValue(Role1,"LockAltnTarget"))
			BF.SetEntityValue(Role2,"LockTargetPoint",BF.GetEntityValue(Role1,"LockAltnTargetPoint"))
			BF.SetEntityValue(Role2,"LockTargetPart",BF.GetEntityValue(Role1,"LockAltnTargetPart"))
		elseif BF.CheckEntity(BF.GetEntityValue(Role1,"AttackTarget")) then
			BF.SetEntityValue(Role2,"LockTarget",BF.GetEntityValue(Role1,"AttackTarget"))
			BF.SetEntityValue(Role2,"LockTargetPoint",BF.GetEntityValue(Role1,"AttackTargetPoint"))
			BF.SetEntityValue(Role2,"LockTargetPart",BF.GetEntityValue(Role1,"AttackTargetPart"))
		else
			BF.SetEntityValue(Role2,"LockTarget",BF.GetEntityValue(Role1,"AttackAltnTarget"))
			BF.SetEntityValue(Role2,"LockTargetPoint",BF.GetEntityValue(Role1,"AttackAltnTargetPoint"))
			BF.SetEntityValue(Role2,"LockTargetPart",BF.GetEntityValue(Role1,"AttackAltnTargetPart"))
		end
		
		--QTE类型为：1切换角色释放技能 / 2不切换角色释放技能 / 3角色在场助战
		if BF.GetEntityValue(Role2,"QTEtype") == 1 or BF.GetEntityValue(Role2,"QTEtype") == 2 or BF.GetEntityValue(Role2,"QTEtype") == 3 then
			local m1 = BF.Random(45,135)
			local m2 = BF.Random(225,315)
			--如果出场坐标参考等于在场角色，则以在场角色坐标为中心点
			if BF.GetEntityValue(Role2,"QTEPosRef") == 1 then
				if BF.GetEntityValue(Role2,"QTEtype") == 1 then
					ChangePos = BF.GetPositionP(Role1)
				elseif BF.GetEntityValue(Role2,"QTEtype") ~= 1 then
					--以在场角色为中心左右随机出角度及坐标
					if BF.Probability(5000) then
						ChangePos = BF.GetPositionOffsetBySelf(Role1,2,m1)
					else
						ChangePos = BF.GetPositionOffsetBySelf(Role1,2,m2)
					end
				end
				--设置朝向坐标为QTE目标 / 在场角色前方位置
				local LookPos = {}
				if BF.CheckEntity(BF.GetEntityValue(Role2,"LockTarget")) then
					LookPos = BF.GetPositionP(BF.GetEntityValue(Role2,"LockTarget"))
				else
					LookPos = BF.GetPositionOffsetBySelf(Role1,10,0)
				end
				--自身设置至前台、设置坐标、设置朝向
				BF.SetEntityBackState(Role2,FE.Backstage.Foreground)
				BF.DoSetPositionP(Role2,ChangePos)
				local Role2Pos = BF.GetPositionP(Role2)
				BF.DoLookAtPositionImmediately(Role2,LookPos.x,Role2Pos.y,LookPos.z)
				BF.CreateEntity(1000000001,Role2,Role2Pos.x,Role2Pos.y,Role2Pos.z)
			end
			----如果出场坐标参考不等于在场角色
			--else
				----如果有目标，则以目标为中心点筛选坐标，朝向目标坐标
				--if BF.CheckEntity(BF.GetEntityValue(Role2,"LockTarget")) then
					--local p1 = BF.GetPositionP(Role1)
					--local p2 = BF.GetPositionP(BF.GetEntityValue(Role2,"LockTarget"))
					----以坐标参考实体为中心左右随机出角度及坐标
					--if BF.Probability(5000) then
						--ChangePos = BF.GetPositionOffsetP(p2,p1,2,m1)
					--else
						--ChangePos = BF.GetPositionOffsetP(p2,p1,2,m2)
					--end
					----设置朝向坐标为QTE攻击目标的方向
					--local LookPos = BF.GetPositionP(BF.GetEntityValue(Role2,"LockTarget"))
					----自身设置至前台、设置坐标、设置朝向
					--BF.SetEntityBackState(Role2,FE.Backstage.Foreground)
					--BF.DoSetPositionP(Role2,ChangePos)
					--BF.DoLookAtPositionImmediately(Role2,LookPos.x,LookPos.y,LookPos.z)
					--local Role2Pos = BF.GetPositionP(Role2)
					--BF.CreateEntity(1000000001,Role2,Role2Pos.x,Role2Pos.y,Role2Pos.z)
					----如果没有任何目标，则取在场角色前方偏移的坐标为中心点筛选坐标，朝向偏移点
				--else
					--local p1 = BF.GetPositionP(Role1)
					--local p2 = BF.GetPositionOffsetBySelf(Role1,5,0)
					--m1 = BF.Random(30,150)
					--m2 = BF.Random(210,330)
					--local LookPos = p2
					--if BF.Probability(5000) then
						--ChangePos = BF.GetPositionOffsetP(p2,p1,2,m1)
					--else
						--ChangePos = BF.GetPositionOffsetP(p2,p1,2,m2)
					--end
					----自身设置至前台、设置坐标、设置朝向
					--BF.SetEntityBackState(Role2,FE.Backstage.Foreground)
					--BF.DoSetPositionP(Role2,ChangePos)
					--BF.DoLookAtPositionImmediately(Role2,LookPos.x,LookPos.y,LookPos.z)
					--local Role2Pos = BF.GetPositionP(Role2)
					--BF.CreateEntity(1000000001,Role2,Role2Pos.x,Role2Pos.y,Role2Pos.z)
				--end
			--end
			--QTE类型为1时，设置自身切到前台为操控角色，尝试打断在场角色技能状态并切到后台，施加正式冷却时间
			if BF.GetEntityValue(Role2,"QTEtype") == 1 then
				if CtrlState == FES.Skill and (BF.GetSkillType(Role1) ~= 50 or (BF.GetSkillType(Role1) == 50 and BF.CanCastSkill(Role1))) then
					BF.BreakSkill(Role1)
				end
				BF.SetEntityBackState(Role1,FE.Backstage.Background)
				BF.SetCtrlEntity(Role2)
				local Role2Pos = BF.GetPositionP(Role2)
				BF.CreateEntity(1000000001,Role2,Role2Pos.x,Role2Pos.y,Role2Pos.z)
				if BF.CheckEntity(self.Role1) then
					BF.SetQTETime(1,FE.QTEType.QTE,BF.GetEntityValue(self.Role1,"QTEChangeCD"))
					BF.SetQTETime(1,FE.QTEType.Change,BF.GetEntityValue(self.Role1,"QTEChangeCD"))
				end
				if BF.CheckEntity(self.Role2) then
					BF.SetQTETime(2,FE.QTEType.QTE,BF.GetEntityValue(self.Role2,"QTEChangeCD"))
					BF.SetQTETime(2,FE.QTEType.Change,BF.GetEntityValue(self.Role2,"QTEChangeCD"))
				end
				if BF.CheckEntity(self.Role3) then
					BF.SetQTETime(3,FE.QTEType.QTE,BF.GetEntityValue(self.Role3,"QTEChangeCD"))
					BF.SetQTETime(3,FE.QTEType.Change,BF.GetEntityValue(self.Role3,"QTEChangeCD"))
				end
			end
			----QTE类型为2时，添加QTE释放后回到后台标记，施加临时冷却时间
			--elseif BF.GetEntityValue(Role2,"QTEtype") == 2 then
				--BF.AddEntitySign(Role2,10000003,-1) --QTE后回到后台标记
				--BF.SetQTETime(2,FE.QTEType.QTE,9999)
				--BF.SetQTETime(2,FE.QTEType.Change,9999)
			--end
			----向目标释放技能判定、锁定目标
			--if BF.CheckEntity(BF.GetEntityValue(Role2,"LockTarget")) then
				local RAB = BF.GetEntityValue(Role2,"RAB")
				local RABC = RAB.RoleCatchSkill
				local qteskill = BF.GetEntityValue(Role2,"QTESkill")
				BF.CallBehaviorFuncByEntityEx(RABC,"ActiveSkill",0,qteskill,2,2,0,0,0,{0},"Immediately","",true,0,-1)
				--self.RAB.RoleCatchSkill:ActiveSkill(ClickButton,self.UltimateSkill[1],5,3,0,0,0,{0},"Immediately","ClearClick",true)
				--BF.DoLookAtTargetImmediately(Role2,BF.GetEntityValue(Role2,"LockTarget"),BF.GetEntityValue(Role2,"LockTargetPart"))
				--BF.CastSkillByTarget(Role2,BF.GetEntityValue(Role2,"QTESkill"),BF.GetEntityValue(Role2,"LockTarget"))
			--end
			----移除场景怪的QTE激活标记
			--if BF.HasEntitySign(self.Me,10000002) then
				--BF.RemoveEntitySign(self.Me,10000002)
			--end
		end
	--存在当前角色切换其他角色标记，则进行换人判断
	elseif BF.CheckQTEState(QTEIndex,FQT.Change,FQS.Enable) and BF.CheckEntity(Role2)
		and BF.GetEntityState(Role1) ~= FES.PathFinding
		and BF.GetEntityState(Role1) ~= FES.Immobilize and BF.GetEntityState(Role1) ~= FES.Preform and BF.GetEntityState(Role1) ~= FES.Stun
		and BF.GetEntityState(Role1) ~= FES.Slide
		and BF.GetEntityState(Role1) ~= FES.StrideOver and BF.GetEntityState(Role1) ~= FES.Aim then
		
		--Role1目标传递给Role2
		if BF.CheckEntity(BF.GetEntityValue(Role1,"AttackTarget")) then
			BF.SetEntityValue(Role2,"AttackTarget",BF.GetEntityValue(Role1,"AttackTarget"))
			BF.SetEntityValue(Role2,"AttackTargetPoint",BF.GetEntityValue(Role1,"AttackTargetPoint"))
			BF.SetEntityValue(Role2,"AttackTargetPart",BF.GetEntityValue(Role1,"AttackTargetPart"))
		elseif BF.CheckEntity(BF.GetEntityValue(Role1,"AttackAltnTarget")) then
			BF.SetEntityValue(Role2,"AttackTarget",BF.GetEntityValue(Role1,"AttackAltnTarget"))
			BF.SetEntityValue(Role2,"AttackTargetPoint",BF.GetEntityValue(Role1,"AttackAltnTargetPoint"))
			BF.SetEntityValue(Role2,"AttackTargetPart",BF.GetEntityValue(Role1,"AttackAltnTargetPart"))
		end

		if BF.CheckEntity(BF.GetEntityValue(Role1,"LockTarget")) then
			BF.SetEntityValue(Role2,"LockTarget",BF.GetEntityValue(Role1,"LockTarget"))
			BF.SetEntityValue(Role2,"LockTargetPoint",BF.GetEntityValue(Role1,"LockTargetPoint"))
			BF.SetEntityValue(Role2,"LockTargetPart",BF.GetEntityValue(Role1,"LockTargetPart"))
		elseif BF.CheckEntity(BF.GetEntityValue(Role1,"LockAltnTarget")) then
			BF.SetEntityValue(Role2,"LockTarget",BF.GetEntityValue(Role1,"LockAltnTarget"))
			BF.SetEntityValue(Role2,"LockTargetPoint",BF.GetEntityValue(Role1,"LockAltnTargetPoint"))
			BF.SetEntityValue(Role2,"LockTargetPart",BF.GetEntityValue(Role1,"LockAltnTargetPart"))
		elseif BF.CheckEntity(BF.GetEntityValue(Role1,"AttackTarget")) then
			BF.SetEntityValue(Role2,"LockTarget",BF.GetEntityValue(Role1,"AttackTarget"))
			BF.SetEntityValue(Role2,"LockTargetPoint",BF.GetEntityValue(Role1,"AttackTargetPoint"))
			BF.SetEntityValue(Role2,"LockTargetPart",BF.GetEntityValue(Role1,"AttackTargetPart"))
		else
			BF.SetEntityValue(Role2,"LockTarget",BF.GetEntityValue(Role1,"AttackAltnTarget"))
			BF.SetEntityValue(Role2,"LockTargetPoint",BF.GetEntityValue(Role1,"AttackAltnTargetPoint"))
			BF.SetEntityValue(Role2,"LockTargetPart",BF.GetEntityValue(Role1,"AttackAltnTargetPart"))
		end
		
		--后台角色设置自身出场坐标、朝向、操控
		local ps1 = BF.GetPositionOffsetBySelf(Role1,10,0)
		BF.DoSetPositionP(Role2,ChangePos)
		BF.SetEntityBackState(Role2,FE.Backstage.Foreground)
		BF.DoLookAtPositionImmediately(Role2,ps1.x,ps1.y,ps1.z)
		--尝试打断在场角色技能
		if CtrlState == FES.Skill then
			BF.BreakSkill(Role1)
		end
		--设置在场角色至后台、按钮位置、换人冷却时间
		BF.SetEntityBackState(Role1,FE.Backstage.Background)
		BF.ClearAllInput() --清除所有按钮状态
		--BF.CancelJoystick() --取消摇杆输入
		BF.CreateEntity(1000000001,Role2,ChangePos.x,ChangePos.y,ChangePos.z)
		BF.DoSetEntityState(Role2,FES.FightIdle)
		BF.SetCtrlEntity(Role2)
		--尝试继承移动状态
		-- local M = BF.GetSubMoveState(Role1)
		-- if M == FEMSS.Run and BF.CheckMove() then
		-- 	BF.DoSetMoveType(Role2,FEMSS.Run)
		-- elseif M == FEMSS.Run and not BF.CheckMove() then
		-- 	BF.DoSetMoveType(Role2,FEMSS.RunEnd)
		-- elseif M == FEMSS.RunStart and BF.CheckMove() then
		-- 	BF.DoSetMoveType(Role2,FEMSS.Run)
		-- elseif M == FEMSS.RunStart and not BF.CheckMove() then
		-- 	BF.DoSetMoveType(Role2,FEMSS.RunStartEnd)
		-- elseif M == FEMSS.Sprint and BF.CheckMove() then
		-- 	BF.SetEntitySprintState(Role2,true)
		-- 	BF.DoSetMoveType(Role2,FEMSS.Sprint)
		-- elseif M == FEMSS.Sprint and not BF.CheckMove() then
		-- 	BF.SetEntitySprintState(Role2,false)
		-- 	BF.DoSetMoveType(Role2,FEMSS.SprintEnd)
		-- else
		-- 	BF.DoSetMoveType(Role2,FEMSS.RunStartEnd)
		-- end
		BF.ChangeRoleInheritState(Role1, Role2)
		local I1 = BF.GetEntityQTEIndex(Role1)
		local I2 = BF.GetEntityQTEIndex(Role2)
		if BF.CheckEntity(Role1) and BF.CheckEntity(Role2) then
			BF.SetQTETime(I1,FE.QTEType.Change,1)
			BF.SetQTETime(I1,FE.QTEType.QTE,1)
			BF.SetQTETime(I2,FE.QTEType.Change,1)
			BF.SetQTETime(I2,FE.QTEType.QTE,1)
		elseif not BF.CheckEntity(Role1) then
			BF.SetQTETime(I2,FE.QTEType.Change,0.5)
			BF.SetQTETime(I2,FE.QTEType.QTE,0.5)
		end
		--Role1目标传递给Role2
		if BF.CheckEntity(BF.GetEntityValue(Role1,"LockTarget")) then
			local RAB = BF.GetEntityValue(Role2,"RAB")
			local RABC = RAB.RoleCatchSkill
			local NormalAttack = BF.GetEntityValue(Role2,"NormalAttack")
			BF.CallBehaviorFuncByEntityEx(RABC,"ContSkill",0,NormalAttack,1,1,10000002,0,0,{0},"Immediately","")
			--BF.DoLookAtTargetImmediately(Role2,BF.GetEntityValue(Role2,"LockTarget"),BF.GetEntityValue(Role2,"LockTargetPart"))
			--BF.CastSkillByTarget(Role2,BF.GetEntityValue(Role2,"NormalAttack[1]"),BF.GetEntityValue(Role2,"LockTarget"))	
		end
	end
end

--通用QTE大招逻辑，index为点击头像对应的角色头像序号，ForeInstanceId指代在场角色，BackInstanceId指代点击头像的后台角色
function Behavior1000001:SwitchQTE(ForeInstanceId,BackInstanceId,index,isClick)

	--if index == nil then
		--if BF.HasEntitySign(1,10000020) then
			--BF.SetFightPanelVisible("00010000")
		--else
			--BF.SetFightMainNodeVisible(2,"PanelParent",true)	--显示主UI
		--end
		--BF.RemoveBuff(ForeInstanceId,1000029,5) --移除QTE大招选择期间-顿帧
		--BF.RemoveBuff(ForeInstanceId,1000030,5) --移除QTE大招选择期间-镜头偏移
		--BF.RemoveBuff(ForeInstanceId,1000031,5) --移除QTE大招选择期间-免伤害+受击+强制位移+死亡+子弹受击+受击朝向
		----BF.RemoveBuff(ForeInstanceId,1000032,5) --移除QTE大招选择期间-暂停实体半透明
		--BF.EndPosVague(ForeInstanceId,0) 		--关闭QTE大招选择期间-径向模糊
		--BF.RemoveEntitySign(self.Me,10000002)	--移除给场景怪大招QTE激活标记
		--BF.ForbidKey(FK.ScreenPress,false)		--取消屏蔽镜头点按输入
		--BF.ForbidKey(FK.ScreenMove,false)		--取消屏蔽镜头移动输入
		--BF.SetDamageFontVisible(true)			--显示伤害数字
		--BF.SetLockPointVisible(true)			--显示锁定点UI
		--BF.SetAllEntityLifeBarVisibleType(1)	--显示血条
		--self.CtrlRole = BF.GetCtrlEntity()		
		--BF.EnableShake(true)					--取消屏蔽震屏
		--BF.SetCameraRotatePause(false)			--取消屏蔽镜头旋转
		--BF.SetBodyDamping() 					--设置镜头跟随过渡时间
		--BF.SetCameraLookAt(self.CtrlRole)		--设置镜头看向点
		--BF.SetCameraFollow(self.CtrlRole)		--设置镜头跟随点
		--return
	--end
	BF.ClearAllInput()	--清除所有按键状态
	--BF.CancelJoystick()	--取消摇杆输入

	local ChangePos = BF.GetPositionP(ForeInstanceId)
	local CtrlState = BF.GetEntityState(ForeInstanceId)
	if (BF.CheckEntity(BackInstanceId) and BF.CheckEntity(ForeInstanceId) and BackInstanceId == ForeInstanceId)
		or index == nil then

		BF.RemoveBuff(ForeInstanceId,1000029,5) --移除QTE大招选择期间-顿帧
		BF.RemoveBuff(ForeInstanceId,1000030,5) --移除QTE大招选择期间-镜头偏移
		BF.RemoveBuff(ForeInstanceId,1000031,5) --移除QTE大招选择期间-免伤害+受击+强制位移+死亡+子弹受击+受击朝向
		--BF.RemoveBuff(ForeInstanceId,1000032,5) --移除QTE大招选择期间-暂停实体半透明
		BF.AllEntityEnterElementCoolingState(self.Me,nil,8,-1) --全局怪物设置元素冷却状态
		self.QTETarget = BF.GetEntityValue(self.CtrlRole,"QTETarget")
		if BF.CheckEntity(self.QTETarget) then
			BF.AddEntityElementReadyTime(self.QTETarget,-9999,-1)
			if BF.HasBuffKind(self.QTETarget,1000032) then
				BF.RemoveBuff(self.QTETarget,1000032)
			end
			BF.SetEntityElementStateIgnoreTimeScale(nil,false) --取消元素状态缩放
			BF.CancelEffectKeyWordControl() --取消特效透明度缩放
		end

		--尝试打断在场角色技能状态
		if CtrlState == FES.Skill then
			BF.BreakSkill(ForeInstanceId)
		end
		--检测角色在空中，设置到地上
		if BF.CheckEntityHeight(ForeInstanceId) > 0.2 then
			local rp1 = BF.GetPositionP(ForeInstanceId)
			rp1.y = rp1.y - BF.CheckEntityHeight(ForeInstanceId)
			BF.DoSetPositionP(ForeInstanceId,rp1)
		end

		--朝向目标或前方
		local LookPos = {}
		if BF.CheckEntity(BF.GetEntityValue(ForeInstanceId,"LockTarget")) then
			LookPos = BF.GetPositionP(BF.GetEntityValue(ForeInstanceId,"LockTarget"))
		else
			LookPos = BF.GetPositionOffsetBySelf(ForeInstanceId,10,0)
		end
		BF.DoLookAtPositionImmediately(ForeInstanceId,LookPos.x,ChangePos.y,LookPos.z)
		
		--执行角色释放技能逻辑
		local RAB = BF.GetEntityValue(ForeInstanceId,"RAB")
		local RABC = RAB.RoleCatchSkill
		local UltimateSkill1 = BF.GetEntityValue(ForeInstanceId,"UltimateSkill1")
		BF.CallBehaviorFuncByEntityEx(RABC,"ActiveSkill",0,UltimateSkill1,5,3,0,0,0,{0},"Immediately","",true,0,-1)
		--移除场景怪的QTE激活标记
		if BF.HasEntitySign(self.Me,10000002) then
			BF.RemoveEntitySign(self.Me,10000002)
			if BF.CheckEntity(self.QTETarget) and BF.HasBuffKind(self.QTETarget,1000041) then
				BF.SetBuffEffectIgnoreTimeScale(self.QTETarget,1000041,false) --设置克制条满怪物晕眩特效不受顿帧
			end
		end
		if BF.HasEntitySign(1,10000020) then
			BF.SetFightPanelVisible("-1")
			BF.SetJoyStickVisibleByAlpha(2, true, true)
		else
			BF.SetFightPanelVisible("-1")
			BF.SetJoyStickVisibleByAlpha(2, true, true)
			--BF.SetFightMainNodeVisible(2,"PanelParent",true)	--显示主UI
		end
		BF.EndPosVague(ForeInstanceId,0) 		--关闭QTE大招选择期间-径向模糊
		BF.ForbidKey(FK.ScreenPress,false)		--取消屏蔽镜头点按输入
		BF.ForbidKey(FK.ScreenMove,false)		--取消屏蔽镜头移动输入
		BF.SetDamageFontVisible(true)			--显示伤害数字
		BF.SetLockPointVisible(true)			--显示锁定点UI
		BF.SetAllEntityLifeBarVisibleType(1)	--显示血条
		self.CtrlRole = BF.GetCtrlEntity()
		BF.EnableShake(true)					--取消屏蔽震屏
		BF.SetCameraRotatePause(false)			--取消屏蔽镜头旋转
		BF.SetBodyDamping() 					--设置镜头跟随过渡时间
		BF.SetCameraLookAt(self.CtrlRole)		--设置镜头看向点
		BF.SetCameraFollow(self.CtrlRole)		--设置镜头跟随点
		BF.AddSkillPoint(self.CtrlRole,1202,3)	--增加3格蓝色资源
		
		--存在QTE激活标记，则进行QTE判断
	elseif BF.CheckEntity(BackInstanceId) and BF.CheckEntity(ForeInstanceId) then
		
		if BF.CheckEntity(BF.GetEntityValue(ForeInstanceId,"AttackTarget")) then
			BF.SetEntityValue(BackInstanceId,"AttackTarget",BF.GetEntityValue(ForeInstanceId,"AttackTarget"))
			BF.SetEntityValue(BackInstanceId,"AttackTargetPoint",BF.GetEntityValue(ForeInstanceId,"AttackTargetPoint"))
			BF.SetEntityValue(BackInstanceId,"AttackTargetPart",BF.GetEntityValue(ForeInstanceId,"AttackTargetPart"))
		elseif BF.CheckEntity(BF.GetEntityValue(ForeInstanceId,"AttackAltnTarget")) then
			BF.SetEntityValue(BackInstanceId,"AttackTarget",BF.GetEntityValue(ForeInstanceId,"AttackAltnTarget"))
			BF.SetEntityValue(BackInstanceId,"AttackTargetPoint",BF.GetEntityValue(ForeInstanceId,"AttackAltnTargetPoint"))
			BF.SetEntityValue(BackInstanceId,"AttackTargetPart",BF.GetEntityValue(ForeInstanceId,"AttackAltnTargetPart"))
		end

		if BF.CheckEntity(BF.GetEntityValue(ForeInstanceId,"LockTarget")) then
			BF.SetEntityValue(BackInstanceId,"LockTarget",BF.GetEntityValue(ForeInstanceId,"LockTarget"))
			BF.SetEntityValue(BackInstanceId,"LockTargetPoint",BF.GetEntityValue(ForeInstanceId,"LockTargetPoint"))
			BF.SetEntityValue(BackInstanceId,"LockTargetPart",BF.GetEntityValue(ForeInstanceId,"LockTargetPart"))
		elseif BF.CheckEntity(BF.GetEntityValue(ForeInstanceId,"LockAltnTarget")) then
			BF.SetEntityValue(BackInstanceId,"LockTarget",BF.GetEntityValue(ForeInstanceId,"LockAltnTarget"))
			BF.SetEntityValue(BackInstanceId,"LockTargetPoint",BF.GetEntityValue(ForeInstanceId,"LockAltnTargetPoint"))
			BF.SetEntityValue(BackInstanceId,"LockTargetPart",BF.GetEntityValue(ForeInstanceId,"LockAltnTargetPart"))
		elseif BF.CheckEntity(BF.GetEntityValue(ForeInstanceId,"AttackTarget")) then
			BF.SetEntityValue(BackInstanceId,"LockTarget",BF.GetEntityValue(ForeInstanceId,"AttackTarget"))
			BF.SetEntityValue(BackInstanceId,"LockTargetPoint",BF.GetEntityValue(ForeInstanceId,"AttackTargetPoint"))
			BF.SetEntityValue(BackInstanceId,"LockTargetPart",BF.GetEntityValue(ForeInstanceId,"AttackTargetPart"))
		else
			BF.SetEntityValue(BackInstanceId,"LockTarget",BF.GetEntityValue(ForeInstanceId,"AttackAltnTarget"))
			BF.SetEntityValue(BackInstanceId,"LockTargetPoint",BF.GetEntityValue(ForeInstanceId,"AttackAltnTargetPoint"))
			BF.SetEntityValue(BackInstanceId,"LockTargetPart",BF.GetEntityValue(ForeInstanceId,"AttackAltnTargetPart"))
		end
		
		self.QTETarget = BF.GetEntityValue(self.CtrlRole,"QTETarget")
		
		--随机选取角度和距离得出出生点
		ChangePos = BF.GetPositionOffsetBySelf(ForeInstanceId,BF.Random(2,2),BF.RandomSelect(BF.Random(100,120),BF.Random(240,260)))
		
		--设置目标坐标为朝向 / 在场角色前方位置
		local LookPos = {}
		if BF.CheckEntity(BF.GetEntityValue(BackInstanceId,"LockTarget")) then
			LookPos = BF.GetPositionP(BF.GetEntityValue(BackInstanceId,"LockTarget"))
		else
			LookPos = BF.GetPositionOffsetBySelf(ForeInstanceId,10,0)
		end

		--自身设置至前台、设置坐标、设置朝向
		BF.SetEntityBackState(BackInstanceId,FE.Backstage.Foreground)
		BF.AddBuff(BackInstanceId,BackInstanceId,1000031,1) --大招QTE免疫伤害-受击-强制位移-死亡-子弹受击-受击朝向
		--检测角色在空中，设置到地上
		if BF.CheckEntityHeight(ForeInstanceId) > 0.2 then
			ChangePos.y = ChangePos.y - BF.CheckEntityHeight(ForeInstanceId)
		end
		BF.DoSetPositionP(BackInstanceId,ChangePos)
		BF.SetEntityTranslucent(BackInstanceId,1,0.2) --模型透明度渐入效果
		BF.DoLookAtPositionImmediately(BackInstanceId,LookPos.x,ChangePos.y,LookPos.z)
		
		BF.RemoveBuff(ForeInstanceId,1000029,5)	 	--移除QTE大招选择期间-顿帧
		--BF.RemoveBuff(ForeInstanceId,1000032,5) 	--QTE大招暂停实体半透明
		--BF.SetCameraRotatePause(true)				--取消屏蔽镜头旋转
		BF.EndPosVague(ForeInstanceId,0) 			--关闭径向模糊
		BF.AddEntitySign(ForeInstanceId,10000026,-1)--QTE大招延时退场标记
		BF.SetSoftZone(true)						--设置镜头全屏缓动区域
		BF.SetBodyDamping(0.7,0.7,0.7)				--设置镜头跟随过渡时间
		self.QTELeaveFrame = self.RealFrame + 18	--延时退场帧数
		self.QTELeaveRole = ForeInstanceId
		
		BF.SetCtrlEntity(BackInstanceId)
		local RABC2 = BF.GetEntityValue(BackInstanceId,"RAB").RoleCatchSkill
		local UltimateSkill2 = BF.GetEntityValue(BackInstanceId,"UltimateSkill2")
		BF.CallBehaviorFuncByEntityEx(RABC2,"ActiveSkill",0,UltimateSkill2,5,3,0,0,0,{0},"Immediately","",true,0,-1)

	end
end