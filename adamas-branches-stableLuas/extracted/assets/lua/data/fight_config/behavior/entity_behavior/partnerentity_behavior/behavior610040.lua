Behavior610040 = BaseClass("Behavior610040",EntityBehaviorBase)
local FK = FightEnum.KeyEvent
--资源预加载
function Behavior610040.GetGenerates()
	local generates = {}
	return generates
end

function Behavior610040.GetMagics()
	local generates = {61004006}
	return generates
end



function Behavior610040:Init()
	self.me = self.instanceId	--记录自身

	self.PartnerAllParm = BehaviorFunctions.CreateBehavior("PartnerAllParm",self)
	self.PartnerCastSkill = BehaviorFunctions.CreateBehavior("PartnerCastSkill",self)
	self.PartnerAllParm.diyuePart = "Bip001 R Hand"
	self.role = BehaviorFunctions.GetEntityOwner(self.me)
	--self.dodgeAtkDistance = 0	--闪避反击释放距离
	self.dodgeFrame = 3
	self.dodgeTime = 0
	self.PartnerAllParm.autoRemove = false

	
	
	self.PartnerAllParm.hasFightSkill = false	--是否会因为战斗影响技能切换
	
	--主动技能列表
	self.PartnerAllParm.skillList = {
		{	--咆哮
			id = 61004006,
			showType = 2,	--1变a身型，2召唤型
			frame = 132,	--技能持续时间，时间结束自动进入退场流程，132
			skillType = 3, --1战前释放，2战中释放，3不需要战前战中切换
			distance =	2.5,	--召唤技能释放距离
			angle = 270,  --召唤技能释放角度
			targetType = 1,	--1以角色为中心，2以敌人为中心
			rushRange = 0,	--召唤冲刺技能极限范围，需要在技能帧事件中位移事件配置技能标记
			rolePerform = 4,	--0不使用角色出场动作，,1使用前召唤，2使用后召唤
			stableShow = 0,	--是否需要在指定位置稳定创建，0不需要，1需要，需要的话要手动上浮空buff和修改下落速度，危险危险
			Camera = 1,		--是否使用3D动态镜头，1为使用水平投影，2为3D动态，一般使用水平投影
		}
	}
	
	--连携技能列表
	self.PartnerAllParm.connectSkillList = {
		
		--{	--上挑
			--id = 61004001,
			--showType = 2,	--1变身型，2召唤型,不填默认为召唤型
			--frame = 62,	--技能持续时间，时间结束自动进入退场流程
			--distance =	2.8,	--召唤技能释放距离
			--angle = 250,  --召唤技能释放角度
			--targetType = 2,	--1以角色为中心，2以敌人为中心
			--createPos = 2, --创建点：1以角色为中心，2以敌人为中心
			--connectType = 1, --连携类型：1普攻，2技能，3核心，4闪避，0默认不释放
			--rushRange = 10,	--召唤冲刺技能极限范围，需要在技能帧事件中位移事件配置技能标记
			--stableShow = 0,	--是否需要在指定位置稳定创建，0不需要，1需要，需要的话要手动上浮空buff和修改下落速度，危险危险
			--Camera = 1,		--是否使用3D动态镜头，1为使用水平投影，2为3D动态，一般使用水平投影
		--},
		
		{	--跳砸
			id = 61004005,
			showType = 2,	--1变身型，2召唤型,不填默认为召唤型
			frame = 90,	--技能持续时间，时间结束自动进入退场流程
			distance =	5,	--召唤技能释放距离
			angle = 250,  --召唤技能释放角度
			targetType = 2,	--1以角色为中心，2以敌人为中心
			createPos = 2, --创建点：1以角色为中心，2以敌人为中心
			connectType = 4, --连携类型：1普攻，2技能，3核心，4闪避，0默认不释放
			rushRange = 0,	--召唤冲刺技能极限范围，需要在技能帧事件中位移事件配置技能标记
			stableShow = 0,	--是否需要在指定位置稳定创建，0不需要，1需要，需要的话要手动上浮空buff和修改下落速度，危险危险
			Camera = 1,		--是否使用3D动态镜头，1为使用水平投影，2为3D动态，一般使用水平投影
			sign = 61004001,
		},
		
		--{	--跳砸
			--id = 61004007,
			--showType = 2,	--1变身型，2召唤型,不填默认为召唤型
			--frame = 90,	--技能持续时间，时间结束自动进入退场流程
			--distance =	5,	--召唤技能释放距离
			--angle = 250,  --召唤技能释放角度
			--targetType = 2,	--1以角色为中心，2以敌人为中心
			--connectType = 4, --连携类型：1普攻，2技能，3核心，4闪避，0默认不释放
			--rushRange = 0,	--召唤冲刺技能极限范围，需要在技能帧事件中位移事件配置技能标记
			--stableShow = 0,	--是否需要在指定位置稳定创建，0不需要，1需要，需要的话要手动上浮空buff和修改下落速度，危险危险
			--Camera = 1,		--是否使用3D动态镜头，1为使用水平投影，2为3D动态，一般使用水平投影
		--}
	}
	
	self.PartnerAllParm.createDistance = 2.5	--在自己旁边放技能的保底距离
	self.PartnerAllParm.createAngle = 270	--在自己旁边放技能的保底位置
end



function Behavior610040:Update()
	
	self.PartnerAllParm:Update()
	self.PartnerCastSkill:Update()
	--获取目标距离
	if self.PartnerAllParm.HasTarget == true then
		self.dodgeAtkDistance = BehaviorFunctions.GetDistanceFromTarget(self.me,self.PartnerAllParm.battleTarget,false)
		--闪避反击技能释放范围，超过距离不释放
		if self.dodgeAtkDistance < 10 then
			BehaviorFunctions.AddSkillEventActiveSign(self.me,610040999)
		else
			BehaviorFunctions.RemoveSkillEventActiveSign(self.me,610040999)
		end
	end
	
	--技能标记
	if self.PartnerAllParm.role == BehaviorFunctions.GetCtrlEntity() then
		BehaviorFunctions.AddSkillEventActiveSign(self.PartnerAllParm.role,610040)
	else
		BehaviorFunctions.RemoveSkillEventActiveSign(self.PartnerAllParm.role,610040)
	end
	
	if self.PartnerAllParm.HasTarget == true then
		BehaviorFunctions.RemoveSkillEventActiveSign(self.me,61004001)
	else
		BehaviorFunctions.AddSkillEventActiveSign(self.me,61004001)
	end
	--闪避时禁用按钮
	--if BehaviorFunctions.HasEntitySign(self.PartnerAllParm.role,self.me) then
		--BehaviorFunctions.DisableSkillButton(self.me,FightEnum.KeyEvent.Partner , true)
	--else	
		--BehaviorFunctions.DisableSkillButton(self.me,FightEnum.KeyEvent.Partner , false)
	--end
end	
	

function Behavior610040:AddSkillSign(instanceId,sign)
	if BehaviorFunctions.GetCtrlEntity() == self.PartnerAllParm.role then
		if instanceId == self.me or instanceId == self.PartnerAllParm.role then
		--闪避反击结束回调
			--if sign == 40610040 then
				----BehaviorFunctions.AddBuff(self.me,self.me,1000067)	--到点退场
				--BehaviorFunctions.RemoveEntitySign(self.PartnerAllParm.role,self.me,-1,false)	--退场时移除在场标记
			--end
			
			--追击仲魔顿帧
			--if sign == 600000008 then
				--BehaviorFunctions.DoMagic(self.PartnerAllParm.role,self.PartnerAllParm.role,600000010)
				--BehaviorFunctions.DoMagic(self.PartnerAllParm.role,self.PartnerAllParm.role,600000009)
			--end
			
			
			--追击仲魔
			--if sign == 600000007 then
				--BehaviorFunctions.CallCommonBehaviorFunc(self.me, "StopPartnerLeave")
				--BehaviorFunctions.RemoveEntitySign(self.me,600002)
				--if self.PartnerAllParm.HasTarget == true then
					--BehaviorFunctions.SetUseParentTimeScale(self.me, false)--不使用创建者时间缩放
					
					--self.PartnerCastSkill:StartCreatePartnerSkill(61004001,self.PartnerAllParm.battleTarget,4,330)--释放召唤技能
					--self.PartnerAllParm.skillFrame = self.PartnerAllParm.time + 62
				--else
					--BehaviorFunctions.SetUseParentTimeScale(self.me, false)--不使用创建者时间缩放
					--self.PartnerCastSkill:StartCreatePartnerSkill(61004001,self.PartnerAllParm.role,2.8,250)
					--self.PartnerAllParm.skillFrame = self.PartnerAllParm.time + 62
				--end
			--end
			
			--主动技能窗口+攻击力buff
			if sign == 10610040 then
				--BehaviorFunctions.DoMagic(self.me,self.PartnerAllParm.role,61004006)
				BehaviorFunctions.AddPlayerBuff(self.me,61004006)	--给全队施加加攻击力buff
			end
		end
	end
end

function Behavior610040:AddBuff(entityInstanceId, buffInstanceId,buffId,ownInstanceId)
	if buffId == 61004006 and ownInstanceId == self.me then
		--被动2
		if BehaviorFunctions.HasEntitySign(self.me,61004002) then
			self.buffId = buffInstanceId
			local buffTime = BehaviorFunctions.GetBuffTime(self.PartnerAllParm.role,buffInstanceId)	--获取当前buff时间
			BehaviorFunctions.SetBuffTime(self.PartnerAllParm.role,buffInstanceId,buffTime + 90)
		end
	end
end

function Behavior610040:PartnerHenshinStart(partnerinsID,roleinsID)
	if partnerinsID == self.me then
	end
	
end


--function Behavior610040:FirstCollide(attackInstanceId,hitInstanceId,instanceId,attackType,camp)
	--if BehaviorFunctions.GetEntityTemplateId(instanceId) == 1001002001 then
		--BehaviorFunctions.SetCameraState(FightEnum.CameraState.ForceLocking)
		--BehaviorFunctions.SetCameraParams(FightEnum.CameraState.ForceLocking,100601202)
		--BehaviorFunctions.RemoveAllFollowTarget()
		--BehaviorFunctions.AddFollowTarget(hitInstanceId,"")
		--BehaviorFunctions.CallBehaviorFuncByEntityEx(self.PartnerCastSkill,"StartCreatePartnerSkill",61004005,hitInstanceId,hitInstanceId,2,280,0)
		--BehaviorFunctions.RemoveAllLookAtTarget()
		--BehaviorFunctions.AddLookAtTarget(self.me,"HitCase")
	--end
--end

--闪避成功
--function Behavior610040:Dodge(attackInstanceId,hitInstanceId,limit)
	--if hitInstanceId == self.PartnerAllParm.role then
		--if attackInstanceId then
			----BehaviorFunctions.DoMagic(self.PartnerAllParm.role,self.PartnerAllParm.role,600000009)
			----BehaviorFunctions.AddDelayCallByFrame(8,self,self.DodgeCounter,attackInstanceId)	--闪避成功后8帧触发闪避反击
			----BehaviorFunctions.DoMagic(attackInstanceId,self.me,6000101)	--连携尝试
			----BehaviorFunctions.SetTimelineTrackCameraLookAtState(true)
		--end
	--end
--end

--function Behavior610040:DodgeCounter(attackInstanceId)
	--if attackInstanceId then
		--BehaviorFunctions.DoMagic(self.PartnerAllParm.role,self.PartnerAllParm.role,600000009)	--聚气
		--BehaviorFunctions.DoMagic(self.PartnerAllParm.role,self.PartnerAllParm.role,600000039)	--聚气后8帧顿帧
		--BehaviorFunctions.AddDelayCallByFrame(12,self,self.DelayCallPartner,attackInstanceId)	--顿帧后4帧召唤佩从
	--end
--end

--function Behavior610040:DelayCallPartner(attackInstanceId)
	--if attackInstanceId then
		--local targetPos = BehaviorFunctions.GetPositionP(attackInstanceId)	--如果坐标存在，获取目标
		--if self.PartnerAllParm.skillFrame > self.PartnerAllParm.time then
			--BehaviorFunctions.RemoveBuff(self.me,self.me,600000006)
		--end
		--BehaviorFunctions.CallCommonBehaviorFunc(self.me, "StopPartnerLeave")
		--BehaviorFunctions.RemoveEntitySign(self.me,600002)
		----如果当前仲魔在场不允许重复创建
		--if self.dodgeTime < self.PartnerAllParm.time  then
			----BehaviorFunctions.AddPostProcessByTemplateId(self.PartnerAllParm.role, 610040, FightEnum.PostProcessType.FullScreen)	--调用场景变色
			--BehaviorFunctions.DoMagic(self.PartnerAllParm.role,self.PartnerAllParm.role,600000008,1)--震屏
			--BehaviorFunctions.SetUseParentTimeScale(self.me, false)--不使用创建者时间缩放
			--self.PartnerCastSkill:StartCreatePartnerSkill(61004005,attackInstanceId,5,250)--释放召唤技能


			--self.dodgeTime = self.PartnerAllParm.time + self.dodgeFrame * 30
			--self.PartnerAllParm.skillFrame = self.PartnerAllParm.time + 100
		--end
	--end
--end