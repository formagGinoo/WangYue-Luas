Behavior62003 = BaseClass("Behavior62003",EntityBehaviorBase)
--资源预加载
function Behavior62003.GetGenerates()
	local generates = {}
	return generates
end

function Behavior62003.GetMagics()
	local generates = {}
	return generates
end



function Behavior62003:Init()
	self.me = self.instanceId	--记录自身
	self.isTrigger = false
	self.PartnerAllParm = BehaviorFunctions.CreateBehavior("PartnerAllParm",self)
	self.PartnerCastSkill = BehaviorFunctions.CreateBehavior("PartnerCastSkill",self)
	self.PartnerAllParm.autoRemove = false	--不自动退场
	--self.dodgeAtkDistance = 0	--闪避反击释放距离
	self.dodgeFrame = 3
	self.dodgeTime = 0
	self.PartnerAllParm.diyuePart = "Bip001 R Hand"
	
	
	self.PartnerAllParm.hasFightSkill = false	--是否会因为战斗影响技能切换
	self.PartnerAllParm.skillList = {
		--主动技能列表
		{
			id = 62003208,
			showType = 2,	--1变身型，2召唤型
			frame = 84,	--技能持续时间，时间结束自动进入退场流程
			skillType = 3, --1战前释放，2战中释放，3不需要战前战中切换
			distance =	3,	--召唤技能释放距离
			angle = 90,  --召唤技能释放角度
			targetType = 2,	--目标点：1以角色为中心，2以敌人为中心
			createPos = 2, --创建点：1以角色为中心，2以敌人为中心
			rushRange = 10,	--召唤冲刺技能极限范围，需要在技能帧事件中位移事件配置技能标记
			rolePerform = 4,	--0不使用角色出场动作，,1使用前召唤，2使用后召唤
			stableShow = 0,	--是否需要在指定位置稳定创建，0不需要，1需要
			Camera = 1,		--是否使用3D动态镜头，1为使用水平投影，2为3D动态，一般使用水平投影
		}
	}
	
	--连携技能列表
	self.PartnerAllParm.connectSkillList = {

		{	--下落攻击连携
			id = 62003621,
			showType = 2,	--1变身型，2召唤型,不填默认为召唤型
			frame = 84,	--技能持续时间，时间结束自动进入退场流程
			distance =	6,	--召唤技能释放距离
			angle = 180,  --召唤技能释放角度
			targetType = 1,	--1以角色为中心，2以敌人为中心
			connectType = 5, --连携类型：1普攻，2技能，3核心，4闪避，5下落攻击，0默认不释放
			rushRange = 0,	--召唤冲刺技能极限范围，需要在技能帧事件中位移事件配置技能标记
			stableShow = 0,	--是否需要在指定位置稳定创建，0不需要，1需要，需要的话要手动上浮空buff和修改下落速度，危险危险
			Camera = 3,		--是否使用3D动态镜头，1为使用水平投影，2为3D动态，一般使用水平投影，3为下砸连携
			sign = 6200301,
		}
	}

	
	self.PartnerAllParm.createDistance = 5	--保底，被召唤时和目标的距离
	self.PartnerAllParm.createAngle = 60	--保底，被召唤时和目标的角度
end



function Behavior62003:Update()
	
	self.PartnerAllParm:Update()
	self.PartnerCastSkill:Update()
	self.role = BehaviorFunctions.GetEntityOwner(self.me)
	
	if self.role == BehaviorFunctions.GetCtrlEntity() then
		if not BehaviorFunctions.HasEntitySign(self.role,62003) then
			BehaviorFunctions.AddEntitySign(self.role,62003,-1,false)
		end
	else
		if BehaviorFunctions.HasEntitySign(self.role,62003) then
			BehaviorFunctions.RemoveEntitySign(self.role,62003)
		end
	end
	
	if not BehaviorFunctions.HasEntitySign(self.role,600000045) then
		BehaviorFunctions.AddEntitySign(self.role,600000045,-1,false)	--添加标记可以QTE连携
	end

	--获取目标距离
	if self.PartnerAllParm.HasTarget == true then
		self.dodgeAtkDistance = BehaviorFunctions.GetDistanceFromTarget(self.me,self.PartnerAllParm.battleTarget,false)
		--闪避反击技能释放范围，超过距离不释放
	end
	
	--技能标记
	if self.PartnerAllParm.role == BehaviorFunctions.GetCtrlEntity() then
		BehaviorFunctions.AddSkillEventActiveSign(self.PartnerAllParm.role,62003)
	else
		BehaviorFunctions.RemoveSkillEventActiveSign(self.PartnerAllParm.role,62003)
	end
	
	if self.PartnerAllParm.HasTarget == true then
		BehaviorFunctions.RemoveSkillEventActiveSign(self.me,62003321)
	else
		BehaviorFunctions.AddSkillEventActiveSign(self.me,62003321)
	end
	
	if BehaviorFunctions.HasEntitySign(self.me,6200302) then
		if not self.initBuff then
			BehaviorFunctions.AddBuff(self.me,self.PartnerAllParm.role,62003001)
			self.initBuff = true
		end
	end
	--闪避时禁用按钮
	--if BehaviorFunctions.HasEntitySign(self.PartnerAllParm.role,self.me) then
		--BehaviorFunctions.DisableSkillButton(self.me,FightEnum.KeyEvent.Partner , true)
	--else	
		--BehaviorFunctions.DisableSkillButton(self.me,FightEnum.KeyEvent.Partner , false)
	--end
end	

function Behavior62003:AddSkillSign(instanceId,sign)
	if instanceId == self.me or instanceId == self.role then
		----播放屏幕特效
		--if sign == 600000002 then
			--BehaviorFunctions.DoMagic(self.me,self.role,600000035,1)
		--end
		
		----隐藏屏幕特效
		--if BehaviorFunctions.CheckPartnerShow(self.role) then
			--if sign == 600000033 then
				--BehaviorFunctions.DoMagic(self.me,self.role,600000036,1)
				--BehaviorFunctions.AddDelayCallByFrame(2,self,self.DelayEndEffect,self.role)
			--end
		--end
		
		--连携后解锁相机
		if sign == 600000033 then
			--BehaviorFunctions.DoMagic(self.me,self.PartnerAllParm.role,600000036,1)
			--BehaviorFunctions.AddDelayCallByFrame(2,self,self.DelayEndEffect,self.PartnerAllParm.role)
			--	BehaviorFunctions.SetForceCameraAmplitudMultiple(1.3)
			--	BehaviorFunctions.SetVCCameraBlend("ForceLockingCamera","OperatingCamera",0.1)	--过渡时间设置
			if not BehaviorFunctions.HasEntitySign(1,10000007) then
				BehaviorFunctions.SetCameraStateForce(1,false)	--设置弱锁
				--BehaviorFunctions.AddLookAtTarget(self.PartnerAllParm.role,"CameraTarget")
				--BehaviorFunctions.RemoveLookAtTarget(self.me,"HitCase")
				BehaviorFunctions.CameraPosReduction(0,true,0)	--重置相机位置
			else
				BehaviorFunctions.SetCameraStateForce(2,false)
			end

			--BehaviorFunctions.CameraPosReduction(0.3,false,1)	--重置相机位置
			if self.PartnerAllParm.HasTarget then
				if self.PartnerCastSkill.curSkillTarget and self.PartnerCastSkill.curSkillTarget ~= 0 and BehaviorFunctions.CheckEntity(self.PartnerCastSkill.curSkillTarget) then
					BehaviorFunctions.RemoveLookAtTarget(self.PartnerCastSkill.curSkillTarget,"HitCase")
					BehaviorFunctions.SetBodyDamping(0.5,0.5,0.5)
				end
			else
				BehaviorFunctions.SetBodyDamping(0.2,0.2,0.2)
			end
		end
		
		--神荼上天移除角色顿帧
		if sign == 600000053 then
			BehaviorFunctions.RemoveBuff(self.PartnerAllParm.role,600000053)	--移除角色顿帧
			--BehaviorFunctions.RemoveLookAtTarget(self.PartnerAllParm.role,"CameraTarget")	--移除看向角色
		end

		--起跳切换目标
		if sign == 62101 then
			BehaviorFunctions.SetVCCameraBlend("WeakLockingCamera","ForceLockingCamera",0.5)	--过渡时间重置
			BehaviorFunctions.SetSoftZone(false)
			BehaviorFunctions.SetBodyDamping(0.2,0.2,0.2)
			if self.PartnerAllParm.HasTarget then
				if self.PartnerCastSkill.curSkillTarget and self.PartnerCastSkill.curSkillTarget ~= 0 and BehaviorFunctions.CheckEntity(self.PartnerCastSkill.curSkillTarget) then
					BehaviorFunctions.AddLookAtTarget(self.PartnerCastSkill.curSkillTarget,"HitCase")	--设置看向怪物
					BehaviorFunctions.SetLookAtTargetWeight(self.PartnerCastSkill.curSkillTarget,"HitCase",2.5)
					BehaviorFunctions.RemoveLookAtTarget(self.PartnerAllParm.role,"CameraTarget")
					--BehaviorFunctions.SetLookAtTargetWeight(self.PartnerAllParm.role,"CameraTarget",0)
					BehaviorFunctions.SetCameraParams(3,62103)
				end
			end
		end

		
		--离场切换相机
		if sign == 600000006 then
			BehaviorFunctions.SetVCCameraBlend("OperatingCamera","ForceLockingCamera",1)	--过渡时间重置
			BehaviorFunctions.SetVCCameraBlend("ForceLockingCamera","OperatingCamera",0)
			--BehaviorFunctions.AddDelayCallByFrame(10,self,self.SetConnectCamera)	--10帧后开始进入切相机流程
			--如果有目标就切换弱锁，没有就切换操作相机
			if not BehaviorFunctions.HasEntitySign(1,10000007) then
				if self.PartnerCastSkill.curSkillTarget and self.PartnerCastSkill.curSkillTarget ~= 0 and BehaviorFunctions.CheckEntity(self.PartnerCastSkill.curSkillTarget) then
					BehaviorFunctions.SetBodyDamping(0.5,0.5,0.5)	--设置相机过渡时间
					BehaviorFunctions.SetCameraStateForce(2,false)	--设置为弱锁定
					BehaviorFunctions.RemoveAllLookAtTarget()	--移除所有看向点
					BehaviorFunctions.RemoveLookAtTarget(self.me,"HitCase")	--移除所有看向点
					BehaviorFunctions.RemoveFollowTarget(self.me,"HitCase")
					--BehaviorFunctions.SetCameraLookAt(self.PartnerCastSkill.curSkillTarget)
					BehaviorFunctions.AddLookAtTarget(self.PartnerCastSkill.curSkillTarget,"HitCase")	--设置看向怪物
				else
					BehaviorFunctions.SetCameraStateForce(1,false)
					BehaviorFunctions.RemoveFollowTarget(self.me,"HitCase")	--移除自己的跟随点
					BehaviorFunctions.RemoveLookAtTarget(self.me,"HitCase")	--移除所有看向点
					BehaviorFunctions.RemoveAllLookAtTarget()	--移除所有看向点
					BehaviorFunctions.AddLookAtTarget(self.PartnerAllParm.CtrlRole,"CameraTarget")	--设置看向角色
					BehaviorFunctions.CameraPosReduction(0.3,false,0.7)	--重置相机位置
				end
			else

			end
			BehaviorFunctions.AddFollowTarget(self.PartnerAllParm.CtrlRole,"CameraTarget")
			--BehaviorFunctions.SetCameraFollow(self.ctrlRole)--设置相机目标为角色
			BehaviorFunctions.SetForceCameraAmplitudMultiple(1)	--重置震屏参数
			BehaviorFunctions.SetSoftZone(false)	--关闭全屏缓出
		end
		
		--离场时，设置回操作相机并且解锁
		if sign == 600000020 then
			if not BehaviorFunctions.HasEntitySign(self.PartnerAllParm.role,10000007) then
				BehaviorFunctions.SetCameraStateForce(FightEnum.CameraState.Operating,false)
			end
		end
	end
end

function Behavior62003:CastSkill(instanceId,skillId,skillType)
	if instanceId == self.me then
		if skillId == 62003621 then
			BehaviorFunctions.SetCameraStateForce(FightEnum.CameraState.Fight,true)
			BehaviorFunctions.AddLookAtTarget(self.me,"HitCase")
			--BehaviorFunctions.SetCameraParams(FightEnum.CameraState.Fight,62003321,false)
		end
	end
	
	--if instanceId == self.PartnerAllParm.role then
		--BehaviorFunctions.CameraPosReduction(0.1,false,0.5)	--重置相机位置
	--end
end

--function Behavior62003:FirstCollide(attackInstanceId,hitInstanceId,instanceId,attackType,skillType, atkElement)
	--if attackInstanceId == self.me and BehaviorFunctions.GetEntityTemplateId(instanceId) == 6200332102 then
		--if BehaviorFunctions.HasEntitySign(self.me,6200303) then
			--BehaviorFunctions.DoMagic(self.me,hitInstanceId,62003002)
		--end
	--end
--end

function Behavior62003:BeforeGetDamageParam(ownerInstanceId,hitInstanceId, attackType, damageType, atkElementType, magicId, attackInstanceId)
	if ownerInstanceId == self.PartnerAllParm.role then
		if attackInstanceId and attackInstanceId ~= 0 then
			if BehaviorFunctions.GetEntityTemplateId(attackInstanceId) == 6200332102 or BehaviorFunctions.GetEntityTemplateId(attackInstanceId) == 6200320801 then
				if BehaviorFunctions.HasEntitySign(self.me,6200303) then
					BehaviorFunctions.DoMagic(self.me,self.me,62003002,1)
					local val = BehaviorFunctions.GetMagicValue(self.me,62003002,1,1)
					BehaviorFunctions.ChangeDamageParam(FightEnum.DamageParam.ElementBreakValue, val)
				end
			end
		end
	end
end