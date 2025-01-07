Behavior6012003 = BaseClass("Behavior6012003",EntityBehaviorBase)
--资源预加载
function Behavior6012003.GetGenerates()
	local generates = {}
	return generates
end

function Behavior6012003.GetMagics()
	local generates = {}
	return generates
end

function Behavior6012003:Init()
	self.me = self.instanceId	--记录自身
	self.PartnerAllParm = BehaviorFunctions.CreateBehavior("PartnerAllParm",self)
	self.PartnerCastSkill = BehaviorFunctions.CreateBehavior("PartnerCastSkill",self)
	self.PartnerAllParm.diyuePart = "Bip001 R Hand"
	self.PartnerAllParm.hasFightSkill = false	--是否会因为战斗影响技能切换
	self.PartnerAllParm.autoRemove = false
	self.PartnerAllParm.cameraWeight = 1	--相机权重重写
	self.PartnerAllParm.skillList = {
		--主动技能列表
		{
			id = 601200305,
			showType = 1,	--1变身型，2召唤型
			frame = 50,	--技能持续时间，时间结束自动进入退场流程
			skillType = 3, --1战前释放，2战中释放，3不需要战前战中切换
			distance =	4,	--召唤技能释放距离
			angle = 1,  --召唤技能释放角度
			targetType = 2,	--目标点：1以角色为中心，2以敌人为中心
			createPos = 1, --创建点：1以角色为中心，2以敌人为中心
			stableShow = 0,	--是否需要在指定位置稳定创建
			Camera = 1,		--是否使用3D动态镜头，0为不需要，1为使用水平投影，2为3D动态，一般使用水平投影
			rolePerform = 0,	--0不使用角色出场动作,1使用前召唤，2使用后召唤
			isTimeScale = 1,
		}
	}
	
	self.PartnerAllParm.createDistance = 2
	self.PartnerAllParm.createAngle = 270
end

function Behavior6012003:Update()
	self.PartnerAllParm:Update()
	self.PartnerCastSkill:Update()

end	

function Behavior6012003:AddSkillSign(instanceId,sign)
	if instanceId == self.me then
		if sign == 601200301 then
			if self.PartnerAllParm.HasTarget then
				BehaviorFunctions.CastSkillByTarget(self.me,601200302,self.PartnerAllParm.battleTarget)
			else
				BehaviorFunctions.CastSkillBySelfPosition(self.me,601200302)
			end
		end
		
		--循环冲撞
		if sign == 601200302 then
			if self.endSkill then
				BehaviorFunctions.CastSkillBySelfPosition(self.me,601200303)
			else
				BehaviorFunctions.CastSkillBySelfPosition(self.me,601200302)
			end
		end
	end
end

function Behavior6012003:FirstCollide(attackInstanceId,hitInstanceId,instanceId,attackType,skillType, atkElement)
	if attackInstanceId == self.me then
		local bullet = BehaviorFunctions.GetEntityTemplateId(instanceId)
		if bullet == 601200301 then
			self.endSkill = true
		end
	end
end

function Behavior6012003:CastSkill(instanceId,skillId,SkillConfigSign,skillType)
	if instanceId == self.me then
		if skillId == 601200301 then
			self.endSkill = false
		end
		
		if skillId == 601200305 then
			--if self.PartnerAllParm.HasTarget then
				--BehaviorFunctions.DoLookAtPositionImmediately(self.me,self.PartnerCastSkill.targetPos.x,self.PartnerCastSkill.targetPos.y,self.PartnerCastSkill.targetPos.z,true)	--设置朝向
			--end
			if BehaviorFunctions.HasEntitySign(self.PartnerAllParm.role,10000007) then

			else
				BehaviorFunctions.SetCameraStateForce(1,false)	--设置回操作相机
				BehaviorFunctions.RemoveAllLookAtTarget()
				BehaviorFunctions.AddLookAtTarget(self.PartnerAllParm.ctrlRole,"CameraTarget")
				--BehaviorFunctions.DoMagic(self.me,self.me,1000055)	--施加初始buff
				BehaviorFunctions.SetVCCameraBlend("FightingCamera","OperatingCamera",0.1)
				BehaviorFunctions.AddDelayCallByFrame(10,BehaviorFunctions,BehaviorFunctions.CameraPosReduction,0.1,false,1)	--重置相机位置)
			end
		end
	end
end

--停止技能
function Behavior6012003:BreakSkill(instanceId,skillId,SkillConfigSign,skillType)
	if instanceId == self.me then
		if skillId == 601200305 then
			if BehaviorFunctions.HasEntitySign(self.PartnerAllParm.role,10000007) then
				BehaviorFunctions.SetVCCameraBlend("FightingCamera","OperatingCamera",0.5)
			end
		end
	end
end

