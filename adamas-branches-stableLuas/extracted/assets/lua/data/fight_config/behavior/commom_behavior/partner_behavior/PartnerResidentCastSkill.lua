PartnerResidentCastSkill = BaseClass("PartnerResidentCastSkill",EntityBehaviorBase)

function PartnerResidentCastSkill:Init()
	
	self.PartnerAllBehavior = self.ParentBehavior
	self.PartnerAllParm = self.MainBehavior.PartnerAllParm --获取母树
    self.me = self.instanceId

	--驻场技能列表
	self.ResidentSkillList = {
		{
			id = 0,
			needTarget = 0,	       --开放参数：1需要锁定目标，2不需要锁定目标
			minDistance = 0,       --开放参数：技能释放最小距离（有等号），不需要目标就跳过此判断
			maxDistance = 0,       --开放参数：技能释放最大距离（无等号），不需要目标就跳过此判断
			angle = 0,           --开放参数：释放角度，不需要目标就跳过此判断
			cd = 0,           	   --开放参数：技能cd，单位：秒
			frame = 0              --用来计算cd是否结束，不开放
		}
	}

	--连携技能
	self.ConnectSkill = {
		id = 0,				--技能id
		cd = 0,                      --技能cd，单位：秒
		frame = 0,              --用来计算cd是否结束，不开放
		summonDis = 0,               --以主人面向为正方向，偏移距离
		summonAngle = 0             --以主人面向为正方向，偏移角度
	}

end

function PartnerResidentCastSkill:Update()
	
	self.PartnerAllParm:Update()
	
	--驻场技能逻辑
	if BehaviorFunctions.CanCtrl(self.me) then
		if self.ResidentSkillList then
			for i = 1,#self.ResidentSkillList do    --循环驻场技能列表，依次判断是否要有目标，距离，角度，cd,都满足就放
				if self.ResidentSkillList[i].needTarget == 1 then
					if self.PartnerAllParm.ResidentTarget and self.PartnerAllParm.ResidentTarget ~= 0 and BehaviorFunctions.CheckEntity(self.PartnerAllParm.ResidentTarget) then
						if BehaviorFunctions.GetDistanceFromTarget(self.me,self.PartnerAllParm.ResidentTarget,false) >= self.ResidentSkillList[i].minDistance
							and BehaviorFunctions.GetDistanceFromTarget(self.me,self.PartnerAllParm.ResidentTarget,false) < self.ResidentSkillList[i].maxDistance then
							if BehaviorFunctions.CompEntityLessAngle(self.me,self.PartnerAllParm.ResidentTarget,self.ResidentSkillList[i].angle/2) then
								if self.PartnerAllParm.time >= self.ResidentSkillList[i].frame and not BehaviorFunctions.CheckEntityState(self.me,FightEnum.EntityState.Skill) then
									if BehaviorFunctions.GetEntityState(self.me) == FightEnum.EntityState.Move then
										BehaviorFunctions.StopMove(self.me)
									end
									BehaviorFunctions.CastSkillByTarget(self.me,self.ResidentSkillList[i].id,self.PartnerAllParm.ResidentTarget)
									self.ResidentSkillList[i].frame = self.PartnerAllParm.time + self.ResidentSkillList[i].cd * 30
								end
							end
						end
					end
				else
					if self.PartnerAllParm.time >= self.ResidentSkillList[i].frame and not BehaviorFunctions.CheckEntityState(self.me,FightEnum.EntityState.Skill) then
						if BehaviorFunctions.GetEntityState(self.me) == FightEnum.EntityState.Move then
							BehaviorFunctions.StopMove(self.me)
						end
						BehaviorFunctions.CastSkillBySelfPosition(self.me,self.ResidentSkillList[i].id)
						self.ResidentSkillList[i].frame = self.PartnerAllParm.time + self.ResidentSkillList[i].cd * 30
					end
				end
			end
			--检查是否所有驻场技能都在CD中，若是则把ResidentSkillCDMark改为true
			local CDMark = false
			for i = 1,#self.ResidentSkillList do
				if self.ResidentSkillList[i].frame > self.PartnerAllParm.time then
					CDMark = true
				else
					CDMark = false
					break
				end
			end
			if CDMark == true then
				self.PartnerAllParm.ResidentSkillCDMark = true
			else
				self.PartnerAllParm.ResidentSkillCDMark = false
			end
			--print("是否所有技能都在CD中？ ",self.PartnerAllParm.ResidentSkillCDMark)
		end
	end
end

--连携技能逻辑，判断角色技能窗口id：600000030（连携技能调用入口2）
function PartnerResidentCastSkill:AddSkillSign(instanceId,sign)
	if instanceId == self.PartnerAllParm.role and sign == 600000030 and self.ConnectSkill and self.ConnectSkill.id ~=0 then
		local LockTarget = BehaviorFunctions.GetEntityValue(self.PartnerAllParm.role,"LockTarget")
		if LockTarget and LockTarget ~= 0 
			and BehaviorFunctions.CheckEntity(LockTarget) 
			and BehaviorFunctions.CheckPartnerShow(self.PartnerAllParm.role) then
			if self.PartnerAllParm.time >= self.ConnectSkill.frame then
				if BehaviorFunctions.GetEntityState(self.me) == FightEnum.EntityState.Move then
					BehaviorFunctions.StopMove(self.me)
				end
				local pos = BehaviorFunctions.GetPositionOffsetBySelf(self.PartnerAllParm.role,self.ConnectSkill.summonDis,self.ConnectSkill.summonAngle)
				BehaviorFunctions.DoSetPositionP(self.me,pos)
				BehaviorFunctions.DoLookAtTargetImmediately(self.me,LockTarget,Bip001)
				BehaviorFunctions.DoMagic(self.PartnerAllParm.role,self.PartnerAllParm.role,600000009)
				BehaviorFunctions.DoMagic(self.PartnerAllParm.role,self.PartnerAllParm.role,600000076)
				BehaviorFunctions.AddPostProcessByTemplateId(self.PartnerAllParm.role, 600000010, FightEnum.PostProcessType.FullScreen)
				BehaviorFunctions.CastSkillByTarget(self.me,self.ConnectSkill.id,LockTarget)
				self.ConnectSkill.frame = self.PartnerAllParm.time + self.ConnectSkill.cd * 30
			end
		end
	end
end