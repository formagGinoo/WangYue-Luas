PartnerAllParm = BaseClass("PartnerAllParm",EntityBehaviorBase)
--资源预加载
function PartnerAllParm.GetGenerates()
	local generates = {}
	return generates
end

function PartnerAllParm.GetMagics()
	local generates = {}
	return generates
end



function PartnerAllParm:Init()
	self.PartnerAllBehavior = self.MainBehavior.PartnerAllBehavior --获取角色组合合集
	self.me = self.instanceId	--记录自身
	self.role = 0	--记录角色
	self.mission = 0	--记录阶段
	self.time = 0	--记录时间
	
	
	self.HasTarget = false	--目标标记

	self.highSkill = false	--空中是否允许释放技能开关
	self.autoRemove = true	--自动退场开关
	
	--技能列表
	self.skillList = {}
	
	self.createDistance = 0
	self.createAngle = 0
	
	self.canShowPartner = true	--允许释放仲魔召唤技能，false在会在仲魔在场时禁用按钮
	
	self.curSkillList = {}	--当前技能列表
	self.curSkillId = 0
	
	self.hasFightSkill = false	--技能按钮是否会被战斗状态影响
	
	self.battleTarget = 0	--战斗目标
	
	self.skillFrame = 0	--正在释放技能缓存持续帧数
	self.skillLevel = 0
	
	self.fightState = 0
	
	
end



function PartnerAllParm:Update()
	
	
	self.time = BehaviorFunctions.GetFightFrame()
	self.role = BehaviorFunctions.GetEntityOwner(self.me)

	self.rolePos = BehaviorFunctions.GetPositionP(self.role)	--角色位置
	self.roleFrontPos = BehaviorFunctions.GetPositionOffsetBySelf(self.role,20,0) --角色前方的位置

	self.myPos = BehaviorFunctions.GetPositionP(self.me)	--仲魔位置
	self.myFrontPos = BehaviorFunctions.GetPositionOffsetBySelf(self.me,20,0)	--仲魔前方的位置
	
	self.myEntityId = BehaviorFunctions.GetEntityTemplateId(self.me)
	--if BehaviorFunctions.GetEntityValue(self.me,"skillList")~=nil then
		----if BehaviorFunctions.GetEntityValue(self.me,"skillList") == "empty" then
		----self.currentSkillList={}
		----else
		--self.curSkillList=BehaviorFunctions.GetEntityValue(self.me,"skillList")
		----end
	--end
	if self.mission == 0 then
		self:CurBtnSkill()
		self.mission = 1
	end
	
	if self.curSkillList.id ~= self.curSkillId then
		self:CurBtnSkill()
	end	
		
	self.skillLevel = self:GetCurSkillLevel(self.curSkillList.id)	--每帧获取仲魔技能等级
	--如果不允许重复召唤仲魔，则禁用按钮
	if BehaviorFunctions.HasEntitySign(self.role,600000) and self.canShowPartner == false then
		BehaviorFunctions.DisableSkillButton(self.me,FightEnum.KeyEvent.Partner , true)
	else
		BehaviorFunctions.DisableSkillButton(self.me,FightEnum.KeyEvent.Partner , false)
	end
	
end	


--根据战斗状态切换技能缓存
function PartnerAllParm:CurBtnSkill()

	--技能是否会因为战斗切换
	if self.hasFightSkill == true then
		--检查是否处于战斗状态
		if BehaviorFunctions.CheckPlayerInFight() then
			self.fightState = 1
		else
			self.fightState = 2
		end
	else
		self.fightState = 3
	end

	--筛选当前的技能缓存，并将当前缓存的按钮插入列表
	if self.fightState ~= self.curSkillList.skillType then
		self.curSkillList = {}
		if next(self.skillList) then
			for index,skill in pairs(self.skillList) do
				if skill.skillType == self.fightState then
					self.curSkillList = TableUtils.CopyTable(self.skillList[index])
					self.curSkillId = skill.id
					break
				end
			end
		end
	end

	--当不处于技能释放状态时更新仲魔按钮状态
	if self.curSkillList.id ~= self.curSkillId and self.skillFrame <= self.time then
		self.curSkillList.id = self.curSkillId
		BehaviorFunctions.ChangePartnerSkill(self.role, self.curSkillList.id)	--始终让当前按钮为缓存按钮
		BehaviorFunctions.SetFightMainNodeVisible(1,"R",true)	--显示仲魔按钮
	end

end




--获取技能等级
function PartnerAllParm:GetCurSkillLevel(skillId)

	--检查技能等级
	for i = 1,20 do
		if BehaviorFunctions.HasEntitySign(self.role,skillId * 100 + i) then
			return i
		end
	end

end

--仲魔被移除的时候清除状态
function PartnerAllParm:BeforePartnerReplaced(roleInstanceId, partnerInstanceId)
	if partnerInstanceId == self.me then
		BehaviorFunctions.RemoveEntitySign(self.role,self.me)
	end
end
