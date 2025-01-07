Behavior600140 = BaseClass("Behavior600140",EntityBehaviorBase)
--资源预加载
function Behavior600140.GetGenerates()
	local generates = {}
	return generates
end

function Behavior600140.GetMagics()
	local generates = {}
	return generates
end

function Behavior600140:Init()
	self.me = self.instanceId	--记录自身
	self.PartnerAllParm = BehaviorFunctions.CreateBehavior("PartnerAllParm",self)
	self.PartnerCastSkill = BehaviorFunctions.CreateBehavior("PartnerCastSkill",self)
	self.PartnerAllParm.diyuePart = "Bip001 L Hand"
	self.PartnerAllParm.hasFightSkill = false	--是否会因为战斗影响技能切换
	self.PartnerAllParm.cameraWeight = 1	--相机权重重写
	self.PartnerAllParm.skillList = {
		--主动技能列表
		{
			id = 600140006,
			showType = 2,	--1变身型，2召唤型
			frame = 50,	--技能持续时间，时间结束自动进入退场流程
			skillType = 3, --1战前释放，2战中释放，3不需要战前战中切换
			distance =	4,	--召唤技能释放距离
			angle = 60,  --召唤技能释放角度
			targetType = 2,	--目标点：1以角色为中心，2以敌人为中心
			createPos = 2, --创建点：1以角色为中心，2以敌人为中心
			stableShow = 0,	--是否需要在指定位置稳定创建
			Camera = 1,		--是否使用3D动态镜头，0为不需要，1为使用水平投影，2为3D动态，一般使用水平投影
			rolePerform = 4,	--0不使用角色出场动作,1使用前召唤，2使用后召唤
			isTimeScale = 2,
		}
	}
	
	self.PartnerAllParm.createDistance = 2
	self.PartnerAllParm.createAngle = 270
end

function Behavior600140:Update()
	self.PartnerAllParm:Update()
	self.PartnerCastSkill:Update()
	
	if BehaviorFunctions.HasEntitySign(self.me,60014001) then
		if not self.initBuff then
			BehaviorFunctions.DoMagic(self.me,self.PartnerAllParm.role,600140001)
			self.initBuff = true
		end
	end
end	



--function Behavior600060:CastSkill(instanceId,skillId,skillType)
	--if instanceId == self.PartnerAllParm.role then
		--if skillType == 601 or skillType == 602 then
			--if not BehaviorFunctions.HasEntitySign(self.PartnerAllParm.role,100000007) then
				----BehaviorFunctions.AddEntitySign(self.PartnerAllParm.role,600000011,-1,false)	--标记为不使用动态相机权重
				--if self.PartnerAllParm.HasTarget then
					--local distance = BehaviorFunctions.GetDistanceFromTarget(self.PartnerAllParm.role,self.PartnerAllParm.battleTarget,false)
					--local height = BehaviorFunctions.CheckEntityHeight(self.PartnerAllParm.battleTarget)
					--if distance > 2 and height < 1 then
						--BehaviorFunctions.SetVCCameraBlend("ForceLockingCamera","FightingCamera",0.2)
						--BehaviorFunctions.SetVCCameraBlend("ForceLockingCamera","WeakLockingCamera",0.2)
						--BehaviorFunctions.SetCameraStateForce(FightEnum.CameraState.ForceLocking,true)
						--BehaviorFunctions.SetCameraParams(FightEnum.CameraState.ForceLocking,600060006,false)
						----BehaviorFunctions.SetCameraStateForce(FightEnum.CameraState.Operating,true)
						----BehaviorFunctions.SetVCCameraBlend("FightingCamera","OperatingCamera",0.2)
						----BehaviorFunctions.RemoveAllLookAtTarget()
						----BehaviorFunctions.RemoveAllFollowTarget()
						----BehaviorFunctions.AddFollowTarget(self.PartnerAllParm.role,"CameraTarget")
						----BehaviorFunctions.AddLookAtTarget(self.PartnerAllParm.role,"CameraTarget")
					----	BehaviorFunctions.CameraPosReduction(0.2,false,0.5)
						
						----BehaviorFunctions.DoMagic(self.me,self.PartnerAllParm.role,600060006)	--相机偏移
						--BehaviorFunctions.RemoveAllLookAtTarget()
						--BehaviorFunctions.RemoveAllFollowTarget()
						----BehaviorFunctions.AddFollowTarget(self.me,"CameraTarget")
						--BehaviorFunctions.AddFollowTarget(self.PartnerAllParm.role,"CameraTarget")
						--BehaviorFunctions.AddLookAtTarget(self.battleTarget,"HitCase")
						--self.curTarget = self.battleTarget
					--end
				--else
					--BehaviorFunctions.CameraPosReduction(0.2,false,0.5)	--重置相机位置
					----BehaviorFunctions.SetCameraStateForce(FightEnum.CameraState.Operating,false)
					----BehaviorFunctions.AddLookAtTarget(self.PartnerAllParm.CtrlRole,"CameraTarget")
				--end
			--end
			----
		--end
	--end
--end



--function Behavior600060:AddSkillSign(instanceId,sign)
	--if instanceId == self.me then
		--if sign == 600060006 then
			--if not BehaviorFunctions.HasEntitySign(self.PartnerAllParm.role,100000007) then
				--BehaviorFunctions.SetVCCameraBlend("ForceLockingCamera","OperatingCamera",1)
				--BehaviorFunctions.SetVCCameraBlend("ForceLockingCamera","FightCamera",1)
				--BehaviorFunctions.RemoveAllFollowTarget()
				--BehaviorFunctions.AddFollowTarget(self.PartnerAllParm.CtrlRole,"CameraTarget")
				--BehaviorFunctions.RemoveAllLookAtTarget()
				--if self.PartnerAllParm.HasTarget then
					--BehaviorFunctions.SetCameraStateForce(FightEnum.CameraState.Fight,false)
					--BehaviorFunctions.AddLookAtTarget(self.PartnerAllParm.battleTarget,"HitCase")
				--else
					--BehaviorFunctions.SetCameraStateForce(FightEnum.CameraState.Operating,false)
					--BehaviorFunctions.AddLookAtTarget(self.PartnerAllParm.CtrlRole,"CameraTarget")
				--end
				--BehaviorFunctions.SetCameraStateForce(FightEnum.CameraState.Operating,false)
			--end
		--end
		
		--if sign == 600000020 then
			--if not BehaviorFunctions.HasEntitySign(1,10000007) and self.PartnerAllParm.role == self.PartnerAllParm.CtrlRole then
				--BehaviorFunctions.SetCameraStateForce(FightEnum.CameraState.Operating,false)	--接触强制相机设置
				--self:ReturnCamera(0.2,0.5)
			--end
		--end
	--end
--end

--function Behavior600060:KeyFrameAddEntity(instanceId,entityId)
	----if instanceId == self.me then
		--if entityId == 600060005001 then
			--BehaviorFunctions.ChangeToTrackMoveComponent(instanceId,100000031,100000032,true,0.5,0)
		--end
	----end
--end




