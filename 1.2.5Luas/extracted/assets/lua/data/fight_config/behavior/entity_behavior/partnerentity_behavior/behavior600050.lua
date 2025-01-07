Behavior600050 = BaseClass("Behavior600050",EntityBehaviorBase)

local BF = BehaviorFunctions
local FES = FightEnum.EntityState
local FK = FightEnum.KeyEvent
local FE = FightEnum
local FEAS = FightEnum.EntityAimState
local FEET = FightEnum.ElementType
local FEAET = FightEnum.AnimEventType

--资源预加载
function Behavior600050.GetGenerates()
	local generates = {}
	return generates
end

function Behavior600050.GetMagics()
	local generates = {60005006}
	return generates
end



function Behavior600050:Init()
	self.me = self.instanceId	--记录自身
	self.AimTarget = 0
	self.AimTargetPos = {}
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
	self.Aiming = false
	
	self.HasTarget = false
	self.HasAimTarget = false
	self.bulletPower = true
end



function Behavior600050:Update()
	self.role = BF.GetEntityOwner(self.me)
	self.time = BF.GetFightFrame()

	self.myPos = BehaviorFunctions.GetPositionP(self.me)
	self.rolePos = BehaviorFunctions.GetPositionP(self.role)
	self.showPos = BehaviorFunctions.GetPositionOffsetBySelf(self.role,2,270)
	self.skillPos = BehaviorFunctions.GetPositionOffsetBySelf(self.role,2,270)
	--self.AimTargetPos = BehaviorFunctions.GetAimTargetPositionP()
	
	self.roleFrontPos = BehaviorFunctions.GetPositionOffsetBySelf(self.role,5,0)
	--仲魔连携技能

	if BehaviorFunctions.CheckKeyDown(FightEnum.KeyEvent.Partner) and BehaviorFunctions.GetCtrlEntity() == self.role then
		if BehaviorFunctions.CheckBtnUseSkill(self.me,FightEnum.KeyEvent.Partner) then
			BehaviorFunctions.AddEntitySign(self.role,600050,-1,false)	--标记仲魔在场
			self:CallSoul()
			BehaviorFunctions.CastSkillByPosition(self.me,60005003)
		end
	end
	
end	

function Behavior600050:CallSoul()
	BehaviorFunctions.CallCommonBehaviorFunc(self.me, "StopPartnerLeave")	--终止正在进行的离场流程
	--BehaviorFunctions.BindEntityToTargetEntityBone(self.me,self.role)
	BehaviorFunctions.DoLookAtPositionImmediately(self.me,self.roleFrontPos.x,self.roleFrontPos.y,self.roleFrontPos.z)
	BehaviorFunctions.BindTransform(self.me,"",{x = -0.3, y = 0, z = -0.3},self.role)
	--BehaviorFunctions.DoSetPosition(self.me,self.showPos.x,self.showPos.y,self.showPos.z)
	
	BehaviorFunctions.DoMagic(self.me,self.me,600000014,1)	--允许穿墙buff
	BehaviorFunctions.DoMagic(self.me,self.me,1000055,1)
	BehaviorFunctions.ShowPartner(self.role,true)
	BehaviorFunctions.DoMagic(self.role,self.role,600000021,1)	--给角色添加瞄准buff
	--BehaviorFunctions.DoMagic(self.me,self.me,600000005,1)	--播放仲魔出场特效
	BehaviorFunctions.DoMagic(self.me,self.me,60005002,1)	--给佩从添加灵体特效
	
end


--瞄准状态判断
function Behavior600050:AimSwitchState(instanceId,Type)
	if instanceId == self.role then
		if BehaviorFunctions.GetBuffCount(self.role,600000021) > 0 then
			if Type == FightEnum.EntityAimState.AimStart then
				self:CallSoul()
				BehaviorFunctions.BreakSkill(self.me)
				BehaviorFunctions.CastSkillBySelfPosition(self.me,60005011)
				BehaviorFunctions.DoMagic(self.me,self.role,600000022,1)
			end
			
			if Type == FightEnum.EntityAimState.Aiming then
				if self.Aiming == false then
					BehaviorFunctions.BreakSkill(self.me)
					BehaviorFunctions.CastSkillBySelfPosition(self.me,60005012)
					BehaviorFunctions.SetAimTarget(self.me, true)
					self.Aiming = true
				end
			else
				self.Aiming = false
			end
			
			if Type == FightEnum.EntityAimState.AimShoot then
				BehaviorFunctions.BreakSkill(self.me)
				self.AimTargetPos = BehaviorFunctions.GetAimTargetPositionP()
				BehaviorFunctions.CastSkillByPosition(self.me,60005013,self.AimTargetPos.x,self.AimTargetPos.y,self.AimTargetPos.z)
				
				--获取瞄准目标存在状态
				if BehaviorFunctions.CheckAimTarget(self.role) then
					self.HasAimTarget = true
					self.AimTarget = BehaviorFunctions.GetAimTargetInstanceId(self.role)
				else	
					self.HasAimTarget = false
					self.AimTargetPos = BehaviorFunctions.GetAimTargetPositionP()
				end
			end
			
			if Type == FightEnum.EntityAimState.AimEnd then
				BehaviorFunctions.BreakSkill(self.me)
				BehaviorFunctions.CastSkillBySelfPosition(self.me,60005014)
				BehaviorFunctions.SetAimTarget(self.me, false)
				BehaviorFunctions.RemoveBuff(self.role,600000022)
			end
		else
			BehaviorFunctions.BreakSkill(self.me)
			BehaviorFunctions.CastSkillBySelfPosition(self.me,60005014)
			BehaviorFunctions.RemoveBuff(self.role,600000022)
		end
	end	
end






--获取战斗技能目标
function Behavior600050:GetTarget()

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


--技能窗口检测
function Behavior600050:AddSkillSign(instanceId,sign)
	if instanceId == self.me or instanceId == self.role then
		if sign == 600050001 then
			BehaviorFunctions.CastSkillByPosition(self.me,self.role,600050002,self.roleFrontPos)
			--BehaviorFunctions.BindEntityToTargetEntityBone(self.me,"Role",true)
		end
		
		if sign == 600050003 then
			self:PartnerFinish()
		end
		
		if sign == 600050000 then
			BehaviorFunctions.DoLookAtPositionByLerp(instanceId,self.roleFrontPos.x,self.roleFrontPos.y,self.roleFrontPos.z,false,180,180,true)
		end
		
		if sign == 600000006 then
			--BehaviorFunctions.DoMagic(self.me,self.me,600000006,1)
			BehaviorFunctions.CallCommonBehaviorFunc(self.me, "DoPartnerLeave")		--进入仲魔退场流程
		end
		
		--判定是否蓄力结束
		if sign == 60005012 then
			self.bulletPower = true
		end
		
		--子弹发射
		if sign == 60005013 then
			if self.bulletPower == true then
				--self.bullet1 = BehaviorFunctions.CreateAimEntity(60005002002,self.me,"AimShootPointL")
				--self.bullet2 = BehaviorFunctions.CreateAimEntity(60005002003,self.me,"AimShootPointL")
				--self.bullet3 = BehaviorFunctions.CreateAimEntity(60005002004,self.me,"AimShootPointL")
				--self.bullet4 = BehaviorFunctions.CreateAimEntity(60005002005,self.me,"AimShootPointL")
				self.shootX,self.shootY,self.shootZ = BehaviorFunctions.GetEntityTransformPos(self.me,"AimShootPointL")
				self.bullet1 = BehaviorFunctions.CreateEntity(60005002002,self.me,self.shootX,self.shootY,self.shootZ)
				self.bullet2 = BehaviorFunctions.CreateEntity(60005002003,self.me,self.shootX,self.shootY,self.shootZ)
				self.bullet3 = BehaviorFunctions.CreateEntity(60005002004,self.me,self.shootX,self.shootY,self.shootZ)
				self.bullet4 = BehaviorFunctions.CreateEntity(60005002005,self.me,self.shootX,self.shootY,self.shootZ)
				--检查是否有瞄准目标
				if self.HasAimTarget == true then
					BehaviorFunctions.SetEntityTrackTarget(self.bullet1,self.AimTarget)
					BehaviorFunctions.SetEntityTrackTarget(self.bullet2,self.AimTarget)
					BehaviorFunctions.SetEntityTrackTarget(self.bullet3,self.AimTarget)
					BehaviorFunctions.SetEntityTrackTarget(self.bullet4,self.AimTarget)
				else
					BehaviorFunctions.SetEntityTrackPosition(self.bullet1,self.AimTargetPos.x,self.AimTargetPos.y,self.AimTargetPos.z)
					BehaviorFunctions.SetEntityTrackPosition(self.bullet2,self.AimTargetPos.x,self.AimTargetPos.y,self.AimTargetPos.z)
					BehaviorFunctions.SetEntityTrackPosition(self.bullet3,self.AimTargetPos.x,self.AimTargetPos.y,self.AimTargetPos.z)
					BehaviorFunctions.SetEntityTrackPosition(self.bullet4,self.AimTargetPos.x,self.AimTargetPos.y,self.AimTargetPos.z)
				end		
				self.bulletPower = false
			else
				self.shootX,self.shootY,self.shootZ = BehaviorFunctions.GetEntityTransformPos(self.me,"AimShootPointL")
				self.bullet = BehaviorFunctions.CreateEntity(60005002001,self.me,self.shootX,self.shootY,self.shootZ,self.AimTargetPos.x,self.AimTargetPos.y,self.AimTargetPos.z)
			end
		end
	end
end

--召唤技能退场
function Behavior600050:PartnerFinish()
	--BehaviorFunctions.DoMagic(self.me,self.me,600000006,1)		--播放退场特效
	--BehaviorFunctions.DoMagic(self.me,self.me,600000004,1)		--播放退场氛围特效
	BehaviorFunctions.CallCommonBehaviorFunc(self.me, "DoPartnerLeave")		--进入仲魔退场流程
end

--仲魔离场回调
function Behavior600050:PartnerHide(instanceId)
	if instanceId == self.me then
		BehaviorFunctions.RemoveEntitySign(self.me,600002)
		BehaviorFunctions.RemoveEntitySign(self.role,600000)	--结束仲魔在场状态
		BehaviorFunctions.RemoveBuff(self.me,1000055)	--移除无敌buff
	end
end

