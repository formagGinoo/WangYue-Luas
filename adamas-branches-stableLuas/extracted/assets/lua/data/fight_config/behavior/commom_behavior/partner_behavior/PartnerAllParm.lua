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
	self.partnerType = 0	--初始佩从类型，0连携，1变身，2召唤，3跟随，4附身；默认为连携
	self.role = 0	--记录角色
	self.time = 0	--记录时间
	self.diyuePart = "Bip001 R Hand"
	self.showType = 0
	
	self.HasTarget = false	--目标标记

	self.highSkill = false	--空中是否允许释放技能开关
	self.autoRemove = true	--自动退场开关

	--主动技能列表
	self.skillList = {}
	
	--连携技能列表
	self.connectSkillList = {}
	
	self.createDistance = 0
	self.createAngle = 0
	
	--self.canShowPartner = true	--允许释放佩从召唤技能，false在会在佩从在场时禁用按钮
	
	self.curSkillList = {}	--当前技能列表
	self.curSkillId = 0
	self.curRolePerform = 1  --默认设置佩从出场需要角色表演
	
	self.hasFightSkill = false	--技能按钮是否会被战斗状态影响
	
	self.battleTarget = 0	--战斗目标
	
	self.skillLevel = 0
	
	self.fightState = 0
	
	self.normalAttackCount = 5	--普攻段数默认5段
	
	self.useOwnSkill = false	--默认不使用自己的技能
	self.chainTrans = true
	self.chainSave = true
	self.autoChangeBtn = true	--自动获取技能切换按钮
	
	--=======驻场AI相关==================================
	self.ResidentTarget = 0    --驻场锁定目标
	self.ResidentTargetRange = 20    --佩从默认驻场索敌范围
	self.ResidentSkillCDMark = false   --标记：所有驻场技能都在CD中。默认为false
	
	--技能模板
	--self.PartnerAllParm.skillList = {
		--{
			--id = 600120020,
			--showType = 3,	--1变身技能，2出场技能,3在场攻击技能
			--frame = 98,	--废弃，技能持续时间，时间结束自动进入退场流程
			--skillType = 3, --1战前释放，2战中释放，3不需要战前战中切换
			--distance =	4.5,	--召唤技能释放距离
			--angle = 110,  --召唤技能释放角度
			--targetType = 2,	--释放目标：1角色，2敌人
			--createPos = 2, --创建点：1参考角色，2参考敌人。连线方向作为0度
			--stableShow = 0,	--是否需要在指定位置稳定创建
			--Camera = 0,		--是否使用3D动态镜头，0为不需要，1为使用水平投影，2为3D动态，一般使用水平投影
			--rolePerform = 1,	--0不使用角色出场动作，,1使用前召唤，2使用后召唤
		--},
	--}
end

function PartnerAllParm:LateInit()
	--初始化结束以后缓存一次技能
	self:CurBtnSkill()	--缓存主动技能
end

function PartnerAllParm:Update()
	
	self.time = BehaviorFunctions.GetFightFrame()
	self.role = BehaviorFunctions.GetEntityOwner(self.me)

	if self.role ~= 1 then
		self.rolePos = BehaviorFunctions.GetPositionP(self.role)	--角色位置
		self.roleEntityId = BehaviorFunctions.GetEntityTemplateId(self.role)
	end
	
	self.roleFrontPos = BehaviorFunctions.GetPositionOffsetBySelf(self.role,20,0) --角色前方的位置

	self.myPos = BehaviorFunctions.GetPositionP(self.me)	--佩从位置
	self.myFrontPos = BehaviorFunctions.GetPositionOffsetBySelf(self.me,20,0)	--佩从前方的位置
	
	self.myEntityId = BehaviorFunctions.GetEntityTemplateId(self.me)

	
	self.roleDistance = BehaviorFunctions.GetDistanceFromTarget(self.me,self.role,false)
	
	self.CameraState = BehaviorFunctions.GetCameraState()	--获取相机状态
	self.CtrlRole = BehaviorFunctions.GetCtrlEntity()	--获取当前操纵角色
	--if BehaviorFunctions.GetEntityValue(self.me,"skillList")~=nil then
		----if BehaviorFunctions.GetEntityValue(self.me,"skillList") == "empty" then
		----self.currentSkillList={}
		----else
		--self.curSkillList=BehaviorFunctions.GetEntityValue(self.me,"skillList")
		----end
	--end
	if self.role ~= 1 then
		--如果没有默认的创建位置，则以角色为默认的创建点
		if not self.curSkillList.createPos then
			self.curSkillList.createPos = self.role
		end
	
		--技能是否会因为战斗切换,判断角色状态
		if self.hasFightSkill == true then
			--检查是否处于战斗状态
			if BehaviorFunctions.CheckPlayerInFight() then
				self.fightState = 2
			else
				self.fightState = 1
			end
		else
			self.fightState = 3
		end
			
		--自动切换按钮逻辑，按钮和最符合条件的技能对不上会重新记录一遍
		if self.autoChangeBtn then
			if self.curSkillList.id ~= self.curSkillId then
				self:CurBtnSkill()
			end
		else
			if self.curSkillId ~= 0 then
				self.curSkillId = 0
			end
		end	
		
		--如果是召唤佩从，而且是在出场状态，会更新按钮
		if (self.partnerType == 2 and BehaviorFunctions.CheckPartnerShow(self.role) and self.curSkillList.showType ~= 3)
			or (self.partnerType == 2 and not BehaviorFunctions.CheckPartnerShow(self.role) and self.curSkillList.showType ~= 2) then
			self:CurBtnSkill()
		end
			
		self.skillLevel = self:GetCurSkillLevel(self.curSkillList.id)	--每帧获取佩从技能等级
	--	如果不允许重复召唤佩从，则禁用按钮
		if not BehaviorFunctions.HasEntitySign(self.me,600000001) and self.role == self.CtrlRole then
			if BehaviorFunctions.HasEntitySign(self.role,600000) and self.canShowPartner == false then
				BehaviorFunctions.DisableSkillButton(self.me,FightEnum.KeyEvent.Partner , true)
			else
				BehaviorFunctions.DisableSkillButton(self.me,FightEnum.KeyEvent.Partner , false)
			end
		end
		
		
		--开放缓存技能
		BehaviorFunctions.SetEntityValue(self.me,"curRolePerform",self.curRolePerform)	--开放角色表演参数
		BehaviorFunctions.SetEntityValue(self.me,"showType",self.showType)	--开放技能类型
		BehaviorFunctions.SetEntityValue(self.me,"partnerType",self.partnerType)	--开放佩从类型
	end
end	


--根据战斗状态切换主动技能缓存
function PartnerAllParm:CurBtnSkill()
	--筛选当前的技能缓存，并将当前缓存的按钮插入列表
	--如果角色状态跟技能的要求匹配
	if self.role ~= 1 then
		self.curSkillList = {}
		--如果技能列表里有技能，则筛选最符合条件的放进佩从技能槽
		if next(self.skillList) then
			for index,skill in pairs(self.skillList) do
				--判断技能类型是否匹配战斗状态
				if skill.skillType == self.fightState then
					--判断技能是否匹配在场状态
					if (self.partnerType == 2 and not BehaviorFunctions.CheckPartnerShow(self.role) and skill.showType == 2)
						or (self.partnerType == 2 and BehaviorFunctions.CheckPartnerShow(self.role) and skill.showType == 3)
						or self.partnerType ~= 2 then
						self.curSkillList = TableUtils.CopyTable(self.skillList[index])
						self.curSkillId = skill.id
						self.showType = skill.showType
						BehaviorFunctions.ChangePartnerSkill(self.role, self.curSkillList.id)	--始终让当前按钮为缓存按钮
						BehaviorFunctions.SetFightMainNodeVisible(1,"R",true)	--显示佩从按钮
						--传递角色出场动作设置
						if skill.rolePerform then
							self.curRolePerform = skill.rolePerform
						end
					break
					end
				end
			end
		end
		
		--临时处理，如果没有配出场技能，则召唤技能可以视为出场技能
		--if not self.curSkillList then
			--if next(self.skillList) then
				--for index,skill in pairs(self.skillList) do
					----判断技能类型是否匹配战斗状态
					--if skill.skillType == self.fightState then
						----判断技能是否匹配在场状态
						--if (self.partnerType == 2 and not BehaviorFunctions.CheckPartnerShow(self.role) and skill.showType == 2)
							--or (self.partnerType == 2 and BehaviorFunctions.CheckPartnerShow(self.role) and skill.showType == 3)
							--or self.partnerType ~= 2
							--or self.partnerType == 4 then
							--self.curSkillList = TableUtils.CopyTable(self.skillList[index])
							--self.curSkillId = skill.id
							--BehaviorFunctions.ChangePartnerSkill(self.role, self.curSkillList.id)	--始终让当前按钮为缓存按钮
							--BehaviorFunctions.SetFightMainNodeVisible(1,"R",true)	--显示佩从按钮
							----传递角色出场动作设置
							--if skill.rolePerform then
								--self.curRolePerform = skill.rolePerform
							--end
							--break
						--end
					--end
				--end
			--end
		--end
	end
end

--function PartnerAllParm:curConnectSkill()
	
	----筛选当前的连携技能缓存，并将连携技能插入列表
	--self.curConnectSkillList = {}

	--if next(self.connectskillList) then
		--for index,skill in pairs(self.connectskillList) do
			--if skill.skillType == self.fightState then
				--self.curSkillList = TableUtils.CopyTable(self.skillList[index])
				--self.curSkillId = skill.id
				--break
			--end
		--end
	--end
--end


--获取技能等级
function PartnerAllParm:GetCurSkillLevel(skillId)
	if skillId then
		--检查技能等级
		for i = 1,20 do
			if BehaviorFunctions.HasEntitySign(self.role,skillId * 100 + i) then
				return i
			end
		end
	end
end

--佩从被移除的时候清除状态
function PartnerAllParm:BeforePartnerReplaced(roleInstanceId, partnerInstanceId)
	if partnerInstanceId == self.me then
		BehaviorFunctions.RemoveEntitySign(roleInstanceId,partnerInstanceId)
	end
end
