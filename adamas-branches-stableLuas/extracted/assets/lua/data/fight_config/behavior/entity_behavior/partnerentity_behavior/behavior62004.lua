Behavior62004 = BaseClass("Behavior62004",EntityBehaviorBase)
--资源预加载
function Behavior62004.GetGenerates()
	local generates = {}
	return generates
end

function Behavior62004.GetMagics()
	local generates = {}
	return generates
end



function Behavior62004:Init()
	self.me = self.instanceId	--记录自身
	self.isTrigger = false
	self.PartnerAllParm = BehaviorFunctions.CreateBehavior("PartnerAllParm",self)
	self.PartnerCastSkill = BehaviorFunctions.CreateBehavior("PartnerCastSkill",self)
	
	--self.dodgeAtkDistance = 0	--闪避反击释放距离
	self.mission = 0
	self.dodgeFrame = 3
	self.dodgeTime = 0
	self.PartnerAllParm.diyuePart = "Bip001 R Hand"
	self.PartnerAllParm.autoRemove = false	--自动退场开关,不自动退场
	
	
	self.PartnerAllParm.hasFightSkill = false	--是否会因为战斗影响技能切换
	self.PartnerAllParm.skillList = {
		--主动技能列表
		{
			id = 62004001,
			showType = 2,	--1变身型，2召唤型
			frame = 0,	--技能持续时间，时间结束自动进入退场流程
			skillType = 3, --1战前释放，2战中释放，3不需要战前战中切换
			distance =	-0.8,	--召唤技能释放距离
			angle = 0,  --召唤技能释放角度
			targetType = 1,	--1以角色为中心，2以敌人为中心
			rushRange = 10,	--召唤冲刺技能极限范围，需要在技能帧事件中位移事件配置技能标记
			rolePerform = 0,	--0不使用角色出场动作，,1使用前召唤，2使用后召唤
			stableShow = 0,	--是否需要在指定位置稳定创建，0不需要，1需要，需要的话要手动上浮空buff和修改下落速度，危险危险
			Camera = 1,		--是否使用3D动态镜头，1为使用水平投影，2为3D动态，一般使用水平投影
		}
	}
	
	self.PartnerAllParm.createDistance = 5	--保底，被召唤时和目标的距离
	self.PartnerAllParm.createAngle = 60	--保底，被召唤时和目标的角度
end



function Behavior62004:Update()
	
	self.PartnerAllParm:Update()
	self.PartnerCastSkill:Update()
	self.role = BehaviorFunctions.GetEntityOwner(self.me)
	
	if self.role == BehaviorFunctions.GetCtrlEntity() then
		BehaviorFunctions.AddEntitySign(self.role,62004,-1,false)
	else
		BehaviorFunctions.RemoveEntitySign(self.role,62004)
	end
	
	--if self.mission == 0 then
		--BehaviorFunctions.DoMagic(self.me,self.me,62004603)
		--self.mission = 1
	--end
	

	----获取目标距离
	--if self.PartnerAllParm.HasTarget == true then
		--self.dodgeAtkDistance = BehaviorFunctions.GetDistanceFromTarget(self.me,self.PartnerAllParm.battleTarget,false)
		----闪避反击技能释放范围，超过距离不释放
	--end
	
	--技能标记
	if self.PartnerAllParm.role == BehaviorFunctions.GetCtrlEntity() then
		BehaviorFunctions.AddSkillEventActiveSign(self.PartnerAllParm.role,62004)
	else
		BehaviorFunctions.RemoveSkillEventActiveSign(self.PartnerAllParm.role,62004)
	end
	
	if self.PartnerAllParm.HasTarget == true then
		BehaviorFunctions.RemoveSkillEventActiveSign(self.me,62004601)
	else
		BehaviorFunctions.AddSkillEventActiveSign(self.me,62004601)
	end
	
	--释放反击技能
	if BehaviorFunctions.HasEntitySign(self.me,62004999) and BehaviorFunctions.GetSkillSign(self.me,62004999) then
		--BehaviorFunctions.DoMagic(self.me,self.PartnerAllParm.role,62004001)	--顿帧
		--BehaviorFunctions.DoMagic(self.me,self.PartnerAllParm.role,62004002)	--震屏
		--BehaviorFunctions.DoMagic(self.me,self.PartnerAllParm.role,62004003)	--镜头
		--BehaviorFunctions.DoMagic(self.me,self.me,1001001)	--顿帧
		BehaviorFunctions.RemoveEntitySign(self.me,62004999)	--移除反击标记
		if self.PartnerAllParm.HasTarget == true then
			BehaviorFunctions.CastSkillByTarget(self.me,62004002,self.PartnerAllParm.battleTarget)	--释放反击技能
		else
			BehaviorFunctions.CastSkillBySelfPosition(self.me,62004002)
		end
	end
	--闪避时禁用按钮
	--if BehaviorFunctions.HasEntitySign(self.PartnerAllParm.role,self.me) then
		--BehaviorFunctions.DisableSkillButton(self.me,FightEnum.KeyEvent.Partner , true)
	--else	
		--BehaviorFunctions.DisableSkillButton(self.me,FightEnum.KeyEvent.Partner , false)
	--end
	
	--不处于盾反状态，移除检测盒
	--if not BehaviorFunctions.GetSkillSign(self.me,62004999) then
		--if self.hitedTrigger then
			--BehaviorFunctions.RemoveEntity(self.hitedTrigger)
		--end
	--end
end	

function Behavior62004:AddSkillSign(instanceId,sign)
	if instanceId == self.me or instanceId == self.role then
		if sign == 62004003 then
			if self.PartnerAllParm.HasTarget == true then
				BehaviorFunctions.CastSkillByTarget(self.me,62004004,self.PartnerAllParm.battleTarget)	--结束反击
			else
				BehaviorFunctions.CastSkillBySelfPosition(self.me,62004004)
			end
		end
		
		if sign == 62004001 then
			if self.PartnerAllParm.HasTarget == true then
				BehaviorFunctions.CastSkillByTarget(self.me,62004003,self.PartnerAllParm.battleTarget)	--进入循环
			else
				BehaviorFunctions.CastSkillBySelfPosition(self.me,62004003)
			end
		end
		
		if sign == 600000020 then
			BehaviorFunctions.RemoveEntitySign(self.me,62004999)	--移除反击标记
		end
	end
end
	
function Behavior62004:KeyFrameAddEntity(instanceId,entityId)
	if entityId == 62004999 then
		--获取反击检测盒ID
		self.hitedTrigger = instanceId
	end
end
----移除屏幕特效
--function Behavior62004:DelayEndEffect(instanceId)
	--if instanceId then
		--BehaviorFunctions.RemoveBuff(self.role,600000035)
	--end
--end



--function Behavior62004:BeforeCollide(attackInstanceId,hitInstanceId,instanceId,attackType)
	----触发反击
	----if hitInstanceId == self.hitedTrigger then
	--local i = BehaviorFunctions.GetEntityTemplateId(instanceId)
	--if attackInstanceId == self.me and (i == 62004602001 or i == 62004602002) then
		--BehaviorFunctions.AddBuff(self.me,hitInstanceId,62004008) --破霸体效果
	--end
--end
--判断处决子弹碰撞目标
--function Behavior62004:FirstCollide(attackInstanceId,hitInstanceId,instanceId,attackType)
	----判断反击子弹释放反击技能
	--if BehaviorFunctions.GetEntityTemplateId(instanceId) == 1005012002 then
		--BehaviorFunctions.CallBehaviorFuncByEntityEx(self.PartnerCastSkill,"CastConnectSkill",62004006,hitInstanceId,self.PartnerAllParm.role,2,270,false,0,1)
	--end
--end


function Behavior62004:Collide(attackInstanceId,hitInstanceId,instanceId,shakeStrenRatio,attackType)
	--触发反击
	--if hitInstanceId == self.hitedTrigger then
	if (hitInstanceId == self.me or hitInstanceId == self.PartnerAllParm.role) and not BehaviorFunctions.HasEntitySign(self.me,62004999) 
		and not BehaviorFunctions.CheckCampBetweenTarget(attackInstanceId,hitInstanceId)
		and (attackType == 0 or attackType == FightEnum.EAttackType.General or attackType == FightEnum.EAttackType.Special 
			or attackType == FightEnum.EAttackType.Low or attackType == FightEnum.EAttackType.Grasp or attackType == FightEnum.EAttackType.Aim) then
		BehaviorFunctions.AddEntitySign(self.me,62004999,-1,false)	--添加可以反击标记
	end
	
	
end

--function Behavior62004:Parry(attackInstanceId,hitInstanceId,InstanceIdId,attackType)
	--if hitInstanceId == self.PartnerAllParm.role and not BehaviorFunctions.HasEntitySign(self.me,62004999)
		--and (attackType == FightEnum.EAttackType.General or attackType == FightEnum.EAttackType.Special or attackType == FightEnum.EAttackType.Low
			--or attackType == FightEnum.EAttackType.Grasp or attackType == FightEnum.EAttackType.Aim or attackType == FightEnum.EAttackType.Rebound)then
		--BehaviorFunctions.AddEntitySign(self.me,62004999,-1,false)	--添加可以反击标记
	--end
--end

--仲魔离场回调
function Behavior62004:PartnerHide(instanceId)
	if instanceId == self.me then
		--BehaviorFunctions.RemoveEntitySign(self.me,600002)		--移除离场状态标记
		--BehaviorFunctions.SetBodyDamping()	--恢复相机过渡时间
		--BehaviorFunctions.RemoveEntitySign(self.PartnerAllParm.role,600000)	--结束仲魔在场状态
		--	BehaviorFunctions.RemoveEntitySign(self.me,600003)	--移除在场标记
		--BehaviorFunctions.RemoveEntitySign(self.PartnerAllParm.role,self.me)	--结束自己在场状态
		BehaviorFunctions.RemoveBuff(self.me,62004013)	--移除独属无敌buff
		--BehaviorFunctions.DoMagic(self.me,self.PartnerAllParm.role,600000048,1)	--播放缔约结束特效
		--BehaviorFunctions.RemoveBuff(self.PartnerAllParm.role,600000050)	--移除角色被缔约特效
		--BehaviorFunctions.RemoveBuff(self.me,600000049)	--移除自己被缔约特效
	end
end