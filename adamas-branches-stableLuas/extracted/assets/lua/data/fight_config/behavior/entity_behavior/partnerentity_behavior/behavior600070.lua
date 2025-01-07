Behavior600070 = BaseClass("Behavior600070",EntityBehaviorBase)

local BF = BehaviorFunctions
local FES = FightEnum.EntityState
local FK = FightEnum.KeyEvent
local FE = FightEnum
local FEAS = FightEnum.EntityAimState
local FEET = FightEnum.ElementType
local FEAET = FightEnum.AnimEventType

--资源预加载
function Behavior600070.GetGenerates()
	local generates = {}
	return generates
end

function Behavior600070.GetMagics()
	local generates = {60007006}
	return generates
end



function Behavior600070:Init()
	self.me = self.instanceId	--记录自身
	

	--瞄准相关
	self.AimNum = 0	--瞄准阶段
	self.CameraType = 1			--当前镜头类型，1操作镜头，2弱锁定，3强锁定，4瞄准镜头
	self.AimCurrectChargeEffect = 0
	self.AimShootTime = 20	--射击帧数
	self.AimShootFrame = 0	--射击，当前帧数
	
	self.AimMode = 0
	self.AimCurrectCount = 0	--当前瞄准阶段
	self.AimingFrame = 0		--当前瞄准帧数
	self.AimShootCameraSwitch = 0 --瞄准射击添加震屏开关
	self.AimUpTime = 15		--抬手帧数
	self.AimUpFrame = 0		--抬手-当前帧数
	self.AimCount = 0
	self.AimShootCount = 1	--射击次数
	
	
	self.HasTarget = false
end



function Behavior600070:Update()
	self.role = BF.GetEntityOwner(self.me)
	self.time = BF.GetFightFrame()
	self.roleState = BF.GetEntityState(self.role)
	self:AimStep()
	self.roleFrontPos = BehaviorFunctions.GetPositionOffsetBySelf(self.role,5,0) --角色前方的位置
	self.CameraType = BF.GetEntityValue(self.role,"CameraType")
	self.PressButton1 = BF.GetEntityValue(self.role,"PressButton1")
	self.PressButtonFrame1 = BF.GetEntityValue(self.role,"PressButtonFrame1")
	
	self.rolePos = BF.GetPositionP(self.role)
	--BF.SetEntityValue(self.me,"fightSkillType",self.fightSkillType)
end	



function Behavior600070:FirstCollide(attackInstanceId,hitInstanceId,instanceId,attackType)
	if BehaviorFunctions.GetEntityTemplateId(instanceId) == 600070005001 and attackInstanceId == self.me then
		if BehaviorFunctions.CheckPlayerInFight() then
			BehaviorFunctions.DoMagic(self.me,hitInstanceId,600070002,1)
		else
			BehaviorFunctions.DoMagic(self.me,hitInstanceId,600070001,1)
		end
	end
end


--瞄准
function Behavior600070:AimStep()
	--非瞄准状态判断
	if self.roleState ~= FES.Aim and self.AimNum ~= 0 then
		self:ClearAimInfo()
	end
	
	--瞄准状态判断
	if self.roleState == FES.Aim then
		BF.SetAimLockTargetEnable(self.role,false)
		BF.SetAimPartDecSpeed(self.role, true)

		BF.SetMouseSensitivity(0.25,0.15,true) --设置瞄准滑动灵敏度,true代表移动端,false为PC端

		BF.SwitchCoreUIType(self.role,1)
		BF.SetCoreUIScale(self.role, 0)
	else
		BF.SetMouseSensitivity(0.35,0.25,true) --设置瞄准滑动灵敏度
		BF.SwitchCoreUIType(self.role,1)
		BF.SetFontOffsetPos(2, 0, 0)
		BF.SetFontRangePos(2, -0.9, 0.9, 0.5, 1.2)
		BF.SetCoreUIScale(self.role, 0.7)
	end
		
		
	
	--点击技能进入瞄准状态
	if self.PressButton1 == FK.Partner and self.PressButtonFrame1 >= 10 and BehaviorFunctions.GetCtrlEntity() == self.role then
		if BehaviorFunctions.CheckBtnUseSkill(self.me,600070005) then
			if BF.CheckEntityHeight(self.role) == 0 and self.roleState ~= FES.Aim and self.roleState ~= FES.Jump and self.AimMode == 0
				and not (self.AimNum == 2 or self.AimNum == 3 and self.AimShootFrame >= self.time)
				and (BF.CanCastSkill(self.role) or (BF.CheckEntityState(self.role,FES.Skill) )) then
				self:AimChangePart()

				--尝试打断技能
				if self.roleState == FES.Skill then
					BF.BreakSkill(self.role)
				end
				--判断瞄准模式，设置相关参数
				if self.PressButton1 == FK.Partner then
					self.AimMode = 1
				end

				--BF.SetAnimationTranslate(self.Me,"AimShoot","AimShoot",1) --设置瞄准射击动作
				--BF.SetAnimationTranslate(self.Me,"AimDown","AimDown",1) --设置瞄准放下动作
				BF.DoSetEntityState(self.role,FES.Aim) --设置实体为瞄准状态
				BF.SetAimState(self.role,FEAS.AimStart) --设置瞄准开始
				--仲魔释放技能
				self:PartnerAimStart()

				--判断目前镜头类型，设置瞄准状态、镜头切换时间
				if self.CameraType == 2 or self.CameraType == 3 then
					BF.SetCameraState(FE.CameraState.Aiming)
					if BF.CheckEntity(self.LockTarget) or BF.CheckEntity(self.AttackTarget) then
						BF.SetVCCameraBlend("**ANY CAMERA**","AimingCamera",0.3) --设置镜头过渡时间
						BF.SetVCCameraBlend("AimingCamera","**ANY CAMERA**",0.3)
					else
						BF.SetVCCameraBlend("**ANY CAMERA**","AimingCamera",0.3)
						BF.SetVCCameraBlend("AimingCamera","**ANY CAMERA**",0.3)
					end
					self.CameraType = 4
				elseif self.CameraType == 1 then
					BF.SetCameraState(FE.CameraState.Aiming)
					BF.SetVCCameraBlend("**ANY CAMERA**","AimingCamera",0.3)
					self.CameraType = 4
				end

				--开启瞄准UI总开关
				BF.SetAimUIVisble(true)
				--设置瞄准镜头参数
				--if self.AimMode == 2 then
				--BF.CameraAimStart(self.Me,0.5,1.5,0)
				if self.AimMode == 1 then
					BF.CameraAimStart(self.role,0,0,0)
				--	BF.CameraAimStart(self.role,0.6,1.5,-0.3)
					--BF.CameraAimStart(self.Me,0.5,1.5,0)
				end
				--设置辅助瞄准目标
				if BF.CheckEntity(self.LockTarget) then
					BF.SetAimCameraLockTarget(self.LockTarget)
				elseif BF.CheckEntity(self.AttackTarget) then
					BF.SetAimCameraLockTarget(self.AttackTarget)
				elseif BF.CheckEntity(self.AttackAltnTarget) then
					BF.SetAimCameraLockTarget(self.AttackAltnTarget)
				end
			end
		end
	end
		
		

	
	
	--移动瞄准开关
	if self.AimMode == 1 then
		BF.AimSetCanMove(self.role,true)
	end
			
	--瞄准进入持续判断
	if self.AimMode ~= 0 and self.AimNum == 1 and self.AimUpFrame < self.time and BF.CheckEntityHeight(self.role) == 0 then
		--瞄准切换部分
		self:AimChangePart()
		BF.SetAimState(self.role,FEAS.Aiming)
	end
		
	--瞄准持续过程判断
	if self.AimMode ~= 0 and BF.CheckEntityHeight(self.role) == 0
		--and ((self.AimNum == 2 and self.AimUpFrame < self.time and not BF.HasEntitySign(self.Me,10020000))
		--or (BF.HasEntitySign(self.Me,10020000) and not BF.CheckAimTarget(self.Me) and self.AimUpFrame < self.time))then
		and (self.AimNum == 2 and self.AimUpFrame < self.time) then

		----临时检查持续瞄准
		--if BF.CheckAimTarget(self.Me) then
		--BF.SetAimCameraLockTarget(BF.GetAimTargetInstanceId(self.Me))
		--end

		--瞄准切换部分
		self:AimChangePart()


		--self.AimingFrame = self.AimingFrame + 1
		--if self.AimCurrectCount < self.AimCount then
			--if self.AimCount == 1 and self.AimingFrame == self.AimChargeTime * 30 then
				--self.AimCurrectCount = self.AimCount
				----self.AimCurrectChargeEffect = BF.CreateEntity(self.AimChargeEffect[2],self.Me)
			--elseif self.AimCount > 1 then
				--for i = self.AimCount, 1, -1 do
					--if self.AimingFrame == self.AimChargeTime[i] then
						--self.AimCurrectCount = i
					--end
				--end
			--end
		--end
		BF.SetAimState(self.role,FEAS.Aiming)

	end



	--瞄准射击判断
	if self.AimMode == 1 and BF.CheckEntityHeight(self.role) == 0
		and ((self.AimNum == 2 and (self.PressButton1 ~= FK.Partner or (self.PressButton1 == FK.Partner and self.PressButtonFrame1 < 3)))) then
				--and self.RAP.PressButton[1] == FK.Attack and self.RAP.PressButtonFrame[1] > 3 and BF.CheckAimTarget(self.Me))) then
		----射击、放下动作判断
		--if self.AimMode == 2 and (self.AimCurrectCount == 3 or self.AimCurrectCount == 2 or self.AimCurrectCount == 1) then
		--BF.SetAnimationTranslate(self.Me,"AimShoot","Attack040",0)
		--BF.SetAnimationTranslate(self.Me,"AimDown",nil,0)
		--self.AimShootTime = 72
		--end

		----临时检查持续瞄准
		--if BF.CheckAimTarget(self.Me) then
		--BF.SetAimCameraLockTarget(BF.GetAimTargetInstanceId(self.Me))
		--end

		--瞄准切换部分
		self:AimChangePart()

		--射击流程
		BF.SetAimState(self.role,FEAS.AimShoot) --射击
		BF.CastSkillByPositionP(self.me,600070003,self.roleFrontPos)	--仲魔释放技能
		--BehaviorFunctions.AddDelayCallByFrame(4,BehaviorFunctions,BehaviorFunctions.CreateEntity,self.AimShootEffect[self.AimCurrectCount+1],self.Me)
		--BehaviorFunctions.AddDelayCallByFrame(4,BehaviorFunctions,BehaviorFunctions.CreateAimEntity,self.AimShootMissile[self.AimCurrectCount+1],self.Me)
		--BehaviorFunctions.AddDelayCallByFrame(4,BehaviorFunctions,BehaviorFunctions.DoEntityAudioPlay,self.Me,"kekeA5",true)
		--瞄准射击后衔接判断
	end
	if self.roleState == FES.Aim and self.AimNum == 3 and BF.CheckEntityHeight(self.role) == 0 and BF.HasEntitySign(self.role,600070) then
		self.AimingFrame = 0
		--关闭瞄准UI总开关
		BF.SetAimUIVisble(false)
		--射击震屏判断
		if self.AimMode == 1 and self.AimShootFrame - 12 < self.time then
			if self.AimCurrectCount == 0 and self.AimShootCameraSwitch == 0 then
				BF.AddBuff(self.role,self.role,600000018,1)
				self.AimShootCameraSwitch = 1
			end
			if self.AimCurrectCount == 1 and self.AimShootCameraSwitch == 0 then
				BF.AddBuff(self.role,self.role,600000019,1)
				self.AimShootCameraSwitch = 1
			end
			self.AimCurrectCount = 0
		end
		--瞄准退出判断
		if self.AimMode == 1 and self.AimShootFrame - 5 < self.time then
			BF.SetAnimatorLayerWeight(self.role,1,nil,0,0)
			BF.SetAnimatorLayerWeight(self.role,2,nil,0,0)
			BF.CameraAimEnd(self.role) --退出瞄准镜头
			BF.SetCameraState(FE.CameraState.Operating) --设置操作镜头
			self.CameraType = 1
			BF.SetAimState(self.role,FEAS.AimEnd)
			BF.AimStateEnd(self.role) --退出瞄准模式
			self.AimMode = 0
		end
	end
end


--通用清除瞄准信息
function Behavior600070:ClearAimInfo()
	self.AimMode = 0			--瞄准模式
	self.AimCurrectCount = 0	--当前瞄准阶段
	self.AimingFrame = 0		--当前瞄准帧数
	self.AimShootCameraSwitch = 0 --瞄准射击添加震屏开关
	BF.CameraAimEnd(self.role)	--退出瞄准状态镜头
	BF.SetCameraState(FE.CameraState.Operating)	--设置操作镜头
	self.CameraType = 1		--记录镜头类型
	BF.SetAimState(self.role,FEAS.AimEnd)	--设置瞄准类型
	self.AimNum = 0				--瞄准阶段
	BF.RemoveEntitySign(self.role,600070)
	--移除当前瞄准特效
	--if BF.CheckEntity(self.AimCurrectChargeEffect) then
		--BF.RemoveEntity(self.AimCurrectChargeEffect)
		--self.AimCurrectChargeEffect = 0
	--end
	BF.SetAimUIVisble(false)
	BF.AimStateEnd(self.role)	--退出任意瞄准状态
end


function Behavior600070:AimChangePart(AnimChange)

	if AnimChange == true then
		local n1 = BF.GetPlayingAnimationName(self.role,1)
		local n2 = BF.GetPlayingAnimationName(self.role,2)

		self.AimMode = 0
		self.AimCurrectCount = 0	--当前瞄准阶段
		self.AimingFrame = 0		--当前瞄准帧数
		self.AimShootCameraSwitch = 0 --瞄准射击添加震屏开关
		--if n1 == "Attack042" or n1 == "Attack041" then
		--if n1 == "Attack042" then
		local a = 0
		if BF.CheckAimTarget(self.role) then
			BF.CameraAimEnd(self.role,0.3) --退出瞄准镜头
			a = 1
		else
			BF.CameraAimEnd(self.role) --退出瞄准镜头
		end
		BF.SetCameraState(FE.CameraState.Operating)	--设置操作镜头
		self.CameraType = 1		--记录镜头类型
		BF.SetEntityValue(self.role,"CameraType",self.CameraType)
		BF.SetAimState(self.role,FEAS.AimEnd)	--设置瞄准类型
		self.AimNum = 0				--瞄准阶段
		BF.SetAimUIVisble(false)
		BF.AimStateEnd(self.role)	--退出任意瞄准状态

		if a == 1 then
			BF.SetAnimatorLayerWeight(self.role,1,nil,0,0)
			BF.SetAnimatorLayerWeight(self.role,2,nil,0,0)
			BF.RemoveKeyPress(FK.Attack)
		end
	end
	--瞄准参数、资源设置
	if AnimChange ~= true then
		self.AimUpTime = 15	--抬手帧数
		BF.SetAnimationTranslate(self.role,"AimUp","PartnerAimStart",1)		--设置瞄准抬手动作
		BF.SetAnimationTranslate(self.role,"Aiming","PartnerAiming_body",1)		--设置瞄准持续动作
		BF.SetAnimationTranslate(self.role,"AimShoot","PartnerAimShoot",1)	--设置瞄准射击动作
		BF.SetAnimationTranslate(self.role,"AimDown","PartnerAimEnd",1)		--设置瞄准放下动作
		--BF.SetAnimationTranslate(self.role,"AimUp","AimUp",1)		--设置瞄准抬手动作
		--BF.SetAnimationTranslate(self.role,"Aiming","Aiming",1)		--设置瞄准持续动作
		--BF.SetAnimationTranslate(self.role,"AimShoot","AimShoot",1)	--设置瞄准射击动作
		--BF.SetAnimationTranslate(self.role,"AimDown","AimDown",1)		--设置瞄准放下动作

		BF.SetAnimationTranslate(self.role,"AimIdle","AimIdle",2)		--设置瞄准下身待机动作
		BF.SetAnimationTranslate(self.role,"AimWalk","AimWalk",2)		--设置瞄准下身前走动作
		BF.SetAnimationTranslate(self.role,"AimWalkBack","AaimWalkBack",2)--设置瞄准下身后走动作
		BF.SetAnimationTranslate(self.role,"AimWalkLeft","AimWalkLeft",2)	--设置瞄准下身左走动作
		BF.SetAnimationTranslate(self.role,"AimWalkRight","AimWalkRight",2)--设置瞄准下身右走动作
		--if AnimChange == true then
		--local n1 = BF.GetPlayingAnimationName(self.Me,1)
		--local n2 = BF.GetPlayingAnimationName(self.Me,2)
		--if n1 == "Attack040" then
		--BF.PlayAnimation(self.Me,"AimUp",1)
		--elseif n1 == "Attack041" then
		--BF.PlayAnimation(self.Me,"Aiming",1)
		--elseif n1 == "Attack042" then
		--BF.PlayAnimation(self.Me,"AimShoot",1)
		--elseif n1 == "Attack043" then
		--BF.PlayAnimation(self.Me,"AimDown",1)
		--end

		--if n2 == "Attack044" then
		--BF.PlayAnimation(self.Me,"AimIdle",2)
		--elseif n2 == "Attack045" then
		--BF.PlayAnimation(self.Me,"AimWalk",2)
		--elseif n2 == "Attack046" then
		--BF.PlayAnimation(self.Me,"AimWalkBack",2)
		--elseif n2 == "Attack047" then
		--BF.PlayAnimation(self.Me,"AimWalkLeft",2)
		--elseif n2 == "Attack048" then
		--BF.PlayAnimation(self.Me,"AimWalkRight",2)
		--end
		--end
		--if not BF.HasBuffKind(self.role,1002165) then
			--BF.AddBuff(self.role,self.role,1002165,1) --右手IK隐藏BUFF
		--end
	end
end

--瞄准阶段判断
function Behavior600070:AimSwitchState(instanceId,State)
	if instanceId == self.role then
		if State == FEAS.AimStart then
			self.AimUpFrame = self.time + self.AimUpTime
			self.AimNum = 1
			self.AimShootCameraSwitch = 0
		end
		if State == FEAS.Aiming then
			self.AimNum = 2

		end
		if State == FEAS.AimShoot then
			self.AimNum = 3
			if self.AimShootCount == 1 then
				self.AimShootFrame = self.time + self.AimShootTime
				--self.AimShootDelayFrame = self.AimShootDelayTime[self.AimCurrectCount+1] + self.time
			elseif self.AimShootCount == 2 then
				self.AimShootFrame = self.time + self.AimShootTime[2]
			end
		end
		if State == FEAS.AimDown then
		end
	end
end


--获取战斗技能目标
function Behavior600070:GetTarget()

	self.LockTarget = BehaviorFunctions.GetEntityValue(self.role,"LockTarget")
	self.LockTargetPoint = BehaviorFunctions.GetEntityValue(self.role,"LockTargetPoint")
	self.LockTargetPart = BehaviorFunctions.GetEntityValue(self.role,"LockTargetPart")

	self.AttackTarget = BehaviorFunctions.GetEntityValue(self.role,"AttackTarget")
	self.AttackTargetPoint = BehaviorFunctions.GetEntityValue(self.role,"AttackTargetPoint")
	self.AttackTargetPart = BehaviorFunctions.GetEntityValue(self.role,"AttackTargetPart")

	self.LockAltnTarget = BehaviorFunctions.GetEntityValue(self.role,"LockAltnTarget")
	self.LockAltnTargetPoint = BehaviorFunctions.GetEntityValue(self.role,"LockAltnTargetPoint")
	self.LockAltnTargetPart = BehaviorFunctions.GetEntityValue(self.role,"LockAltnTargetPart")

	self.AttackAltnTarget = BehaviorFunctions.GetEntityValue(self.role,"AttackAltnTarget")
	self.AttackAltnTargetPoint = BehaviorFunctions.GetEntityValue(self.role,"AttackAltnTargetPoint")
	self.AttackAltnTargetPart = BehaviorFunctions.GetEntityValue(self.role,"AttackAltnTargetPart")

	if BehaviorFunctions.CheckEntity(self.LockTarget) then
		self.battleTarget = self.LockTarget
		self.HasTarget = true
		BehaviorFunctions.AddSkillEventActiveSign(self.me,62001008)
	elseif BehaviorFunctions.CheckEntity(self.AttackTarget) then
		self.battleTarget = self.AttackTarget
		self.HasTarget = true
		BehaviorFunctions.AddSkillEventActiveSign(self.me,62001008)
	elseif BehaviorFunctions.CheckEntity(self.AttackAltnTarget) then
		self.battleTarget = self.AttackAltnTarget
		self.HasTarget = true
		BehaviorFunctions.AddSkillEventActiveSign(self.me,62001008)
	else
		self.HasTarget = false
		BehaviorFunctions.AddSkillEventActiveSign(self.me,62001108)
		BehaviorFunctions.RemoveSkillEventActiveSign(self.me,62001008)

	end

end

function Behavior600070:OnAnimEvent(instanceId,eventType,params,animationName)
	if instanceId == self.role and eventType == FEAET.AimShoot and BF.HasEntitySign(self.role,600070) and animationName == "PartnerAimShoot" then
		if params.Hand == 0 then --左手
			--BF.CreateEntity(60007000501,self.role) --喷焰特效
			BF.CreateAimEntity(600070005001,self.role,"AimShootL") --子弹
		else
			--BF.CreateEntity(60007000501,self.role) --喷焰特效
			BF.CreateAimEntity(600070005001,self.role,"AimShootR") --子弹
		end
		--射击震屏判断
		--BF.AddBuff(self.role,self.role,1002045,1)
		--BF.ChangeEntityAttr(self.role,1204,-5,1)
		BF.DoEntityAudioPlay(self.role,"kekeA5",true)
	end
end

--召唤仲魔
function Behavior600070:PartnerAimStart()
	BehaviorFunctions.ResetEntityMoveComponent(self.me)
	BF.AddEntitySign(self.role,600070,-1,false)
	local Pos = BF.GetPositionOffsetBySelf(self.role,0.5,0)
	BehaviorFunctions.CallCommonBehaviorFunc(self.me, "StopPartnerLeave")
	BehaviorFunctions.DoSetPosition(self.me,Pos.x - 0.1,Pos.y,Pos.z + 1)	--设置召唤位置
	BehaviorFunctions.DoLookAtPositionImmediately(self.me,self.roleFrontPos.x,self.roleFrontPos.y,self.roleFrontPos.z,true)	--设置朝向
	BehaviorFunctions.ShowPartner(self.role, true)	--显示仲魔
	BehaviorFunctions.SetUseParentTimeScale(self.me, false)--不使用创建者时间缩放
	BehaviorFunctions.DoMagic(self.me,self.me,1000055,1)	--仲魔召唤技能无敌buff
	BehaviorFunctions.DoMagic(self.me,self.me,600000014,1)	--允许穿墙buff
	BehaviorFunctions.DoMagic(self.me,self.me,600000016,1)	--浮空buff
	BehaviorFunctions.DoMagic(self.me,self.me,600000005,1)	--播放仲魔出场特效
	BehaviorFunctions.CastSkillByTarget(self.me,600070001,self.role)	--释放技能
end

--技能窗口检测
function Behavior600070:AddSkillSign(instanceId,sign)
	if instanceId == self.me then
		if sign == 600070001 then
			BehaviorFunctions.CastSkillByPosition(self.me,600070002,self.roleFrontPos)
			BehaviorFunctions.BindEntityToOwnerBone(self.me,"Role",true)
		end
		
		if sign == 600070003 then
			self:PartnerFinish()
		end
		
		if sign == 600070000 then
			BehaviorFunctions.DoLookAtPositionByLerp(instanceId,self.roleFrontPos.x,self.roleFrontPos.y,self.roleFrontPos.z,false,180,180,true)
		end
	end
end

--召唤技能退场
function Behavior600070:PartnerFinish()
	BehaviorFunctions.DoMagic(self.me,self.me,600000006,1)		--播放退场特效
	BehaviorFunctions.DoMagic(self.me,self.me,600000004,1)		--播放退场氛围特效
	BehaviorFunctions.CallCommonBehaviorFunc(self.me, "DoPartnerLeave")		--进入仲魔退场流程
end

--仲魔离场回调
function Behavior600070:PartnerHide(instanceId)
	if instanceId == self.me then
		BehaviorFunctions.RemoveEntitySign(self.me,600002)
		BehaviorFunctions.RemoveEntitySign(self.role,600000)	--结束仲魔在场状态
		BehaviorFunctions.RemoveBuff(self.me,1000055)	--移除无敌buff
	end
end