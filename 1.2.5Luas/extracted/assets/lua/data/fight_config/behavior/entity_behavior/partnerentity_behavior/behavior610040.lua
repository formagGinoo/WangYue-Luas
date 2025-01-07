Behavior610040 = BaseClass("Behavior610040",EntityBehaviorBase)
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
	self.role = BehaviorFunctions.GetEntityOwner(self.me)
	--self.dodgeAtkDistance = 0	--闪避反击释放距离
	self.dodgeFrame = 3
	self.dodgeTime = 0

	
	
	self.PartnerAllParm.hasFightSkill = false	--是否会因为战斗影响技能切换
	self.PartnerAllParm.skillList = {
		--主动技能列表
		{
			id = 61004006,
			showType = 2,	--1变身型，2召唤型
			frame = 132,	--技能持续时间，时间结束自动进入退场流程
			skillType = 3, --1战前释放，2战中释放，3不需要战前战中切换
			distance =	10	--冲刺距离
		}
	}
	
	self.PartnerAllParm.createDistance = 2.5
	self.PartnerAllParm.createAngle = 270
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
			if sign == 40610040 then
				--BehaviorFunctions.AddBuff(self.me,self.me,1000067)	--到点退场
				BehaviorFunctions.RemoveEntitySign(self.PartnerAllParm.role,self.me,-1,false)	--退场时移除在场标记
			end
			
			--追击仲魔顿帧
			if sign == 600000008 then
				BehaviorFunctions.DoMagic(self.PartnerAllParm.role,self.PartnerAllParm.role,600000010)
				BehaviorFunctions.DoMagic(self.PartnerAllParm.role,self.PartnerAllParm.role,600000009)
			end
			--追击仲魔
			if sign == 600000007 then
				BehaviorFunctions.CallCommonBehaviorFunc(self.me, "StopPartnerLeave")
				BehaviorFunctions.RemoveEntitySign(self.me,600002)
				if self.PartnerAllParm.HasTarget == true then
					BehaviorFunctions.SetUseParentTimeScale(self.me, false)--不使用创建者时间缩放
					
					self.PartnerCastSkill:StartCreatePartnerSkill(61004001,self.PartnerAllParm.battleTarget,4,330)--释放召唤技能
					self.PartnerAllParm.skillFrame = self.PartnerAllParm.time + 62
				else
					BehaviorFunctions.SetUseParentTimeScale(self.me, false)--不使用创建者时间缩放
					self.PartnerCastSkill:StartCreatePartnerSkill(61004001,self.PartnerAllParm.role,2.8,250)
					self.PartnerAllParm.skillFrame = self.PartnerAllParm.time + 62
				end
			end
			
			if sign == 10610040 then
				BehaviorFunctions.DoMagic(self.PartnerAllParm.role,self.PartnerAllParm.role,600000015)
			end
		end
	end
end


--闪避成功
function Behavior610040:Dodge(attackInstanceId,hitInstanceId,limit)
	if hitInstanceId == self.PartnerAllParm.role then
		if attackInstanceId then
			local targetPos = BehaviorFunctions.GetPositionP(attackInstanceId)	--如果坐标存在，获取目标
				if self.PartnerAllParm.skillFrame > self.PartnerAllParm.time then
					BehaviorFunctions.RemoveBuff(self.me,self.me,600000006)
				end
				BehaviorFunctions.CallCommonBehaviorFunc(self.me, "StopPartnerLeave")
				BehaviorFunctions.RemoveEntitySign(self.me,600002)
			--如果当前仲魔在场不允许重复创建
			if self.dodgeTime < self.PartnerAllParm.time  then
				BehaviorFunctions.DoMagic(self.PartnerAllParm.role,self.PartnerAllParm.role,600000008,1)--震屏
				BehaviorFunctions.SetUseParentTimeScale(self.me, false)--不使用创建者时间缩放
				self.PartnerCastSkill:StartCreatePartnerSkill(61004005,attackInstanceId,5,250)--释放召唤技能
				BehaviorFunctions.DoMagic(self.PartnerAllParm.role,self.PartnerAllParm.role,600000009)
				--BehaviorFunctions.DoMagic(self.PartnerAllParm.role,self.PartnerAllParm.role,600000012)
				self.dodgeTime = self.PartnerAllParm.time + self.dodgeFrame * 30
				self.PartnerAllParm.skillFrame = self.PartnerAllParm.time + 100
			end
		end
	end
end
