MonsterCastSkill = BaseClass("MonsterCastSkill",EntityBehaviorBase)

function MonsterCastSkill:Init()
	self.MonsterCommonBehavior = self.ParentBehavior
	self.MonsterCommonParam = self.MainBehavior.MonsterCommonParam
	
	self.inSkillAngle = 0                                                   --是否符合技能释放角度
	self.skillCastingFrame = 0
	self.prepareSkillList = {}                                              --准备中技能列表(能立刻放的技能)
	self.skillBeginFrame = 0
	self.skillBeginState = 0
	self.FightTargetArrowEffect=false
	self.warnSign = 0
end

function MonsterCastSkill:Update()
	if  self.MonsterCommonParam.inFight == true then
		--技能列表初始化
		if 	self.skillBeginState == 0 and self.MonsterCommonParam.skillState == self.MonsterCommonParam.SkillStateEnum.Default then
			if self.MonsterCommonParam.initialSkillList and next(self.MonsterCommonParam.initialSkillList) then
				self.MonsterCommonParam.currentSkillList = self:InitSkillList(self.MonsterCommonParam.initialSkillList)
				self.skillBeginFrame = self.MonsterCommonParam.myFrame
				self.MonsterCommonParam.skillState = self.MonsterCommonParam.SkillStateEnum.Initial
				self.skillBeginState = 1
			end
		end	
		--等初始CD
		if self.MonsterCommonParam.skillState == self.MonsterCommonParam.SkillStateEnum.Initial
			and self.MonsterCommonParam.myFrame - self.skillBeginFrame > self.MonsterCommonParam.initialSkillCd*30 then
			self.MonsterCommonParam.skillState = self.MonsterCommonParam.SkillStateEnum.Default
		end
		--技能释放逻辑
		if  BehaviorFunctions.CanCtrl(self.MonsterCommonParam.me) then
			--技能选择:把符合条件的技能都放入currentSkillList中
			if self.MonsterCommonParam.skillState == self.MonsterCommonParam.SkillStateEnum.Default 
				and self.MonsterCommonParam.currentSkillList and next(self.MonsterCommonParam.currentSkillList) then
				for num = 1,#self.MonsterCommonParam.currentSkillList,1 do
					local judgeState = 0
					--条件1：是否自动释放
					if judgeState == 0 then
						if self.MonsterCommonParam.currentSkillList[num].isAuto == true then
							judgeState = 1
						end
					end
					--条件2：CD判断
					if judgeState == 1 then
						if self.MonsterCommonParam.currentSkillList[num].frame < self.MonsterCommonParam.myFrame then
							judgeState = 2
						end
					end
					--条件3：距离判断
					if judgeState == 2 then
						if self.MonsterCommonParam.battleTargetDistance >= self.MonsterCommonParam.currentSkillList[num].minDistance and
							self.MonsterCommonParam.battleTargetDistance < self.MonsterCommonParam.currentSkillList[num].maxDistance then
							judgeState = 3
						end
					end
					--条件4：血量判断
					if judgeState == 3 then
						if self.MonsterCommonParam.haveSkillLifeRatio then
							if self.MonsterCommonParam.LifeRatio > self.MonsterCommonParam.currentSkillList[num].minLifeRatio and
								self.MonsterCommonParam.LifeRatio <= self.MonsterCommonParam.currentSkillList[num].maxLifeRatio then
								judgeState = 4
							end
						else
							judgeState = 4
						end
					end
					--条件5：目标受击判断
					if judgeState == 4  then
						if self.MonsterCommonParam.currentSkillList[num].canCastSkillWhenTargetInHit == true then
							judgeState = 5
						else
							if self.MonsterCommonParam.targetInHit == false then
								judgeState = 5
							end
						end
					end
					--条件6：特殊条件判断
					if judgeState == 5  then
						if not self.MonsterCommonParam.mySpecialState
							or (self.MonsterCommonParam.mySpecialState
							and self.MonsterCommonParam.currentSkillList[num].specialState==self.MonsterCommonParam.mySpecialState) then
							judgeState = 6
						end
					end
					--选好技能，插入prepareSkillList
					if judgeState == 6 then
						table.insert(self.prepareSkillList,self.MonsterCommonParam.currentSkillList[num])
					end
					if num == #self.MonsterCommonParam.currentSkillList then
						self.MonsterCommonParam.skillState = self.MonsterCommonParam.SkillStateEnum.PrepareSkill
					end
				end
			end

			--prepareSkillList中选择技能释放
			if self.MonsterCommonParam.skillState == self.MonsterCommonParam.SkillStateEnum.PrepareSkill then
				if #self.prepareSkillList > 0 then
					self.prepareSkillList = self:InitSkillList(self.prepareSkillList)
					local priority = self.prepareSkillList[1].priority
					local weightSum = 0
					local currentWeight = 1
					local randomSum = 0
					--仅保留最高优先级技能
					self.prepareSkillList = self:RemoveListByPriority(self.prepareSkillList,priority)
					--计算权重总和
					for num = 1, #self.prepareSkillList do
						if self.prepareSkillList[num].weight then
							if self.prepareSkillList[num].weight == 0  then
								self.prepareSkillList[num].weight = 1
							end
							weightSum = weightSum + self.prepareSkillList[num].weight
						else
							self.prepareSkillList[num].weight = 1
						end
					end
					--权重随机
					if weightSum > 1 then
						currentWeight = BehaviorFunctions.Random(1,weightSum)
					else
						currentWeight = 1
					end	
					--按随机结果选择技能	
					for num = 1, #self.prepareSkillList do
						if self.prepareSkillList[num].weight then
							randomSum = randomSum + self.prepareSkillList[num].weight
							if randomSum >=  currentWeight then
								self.MonsterCommonParam.currentSkillListNum = self:SerchSkillList(self.prepareSkillList[num].id,self.MonsterCommonParam.currentSkillList)
								self.MonsterCommonParam.currentSkillId = self.prepareSkillList[num].id
								break
							end
						end
					end
					if self.MonsterCommonParam.currentSkillId~= 0 then
						self.MonsterCommonParam.skillState = self.MonsterCommonParam.SkillStateEnum.HaveSkill
					end	
				else
					self.MonsterCommonParam.skillState = self.MonsterCommonParam.SkillStateEnum.Default
				end
			end
			--释放选好的技能
			if self.MonsterCommonParam.skillState == self.MonsterCommonParam.SkillStateEnum.HaveSkill then
				--取消移动
				if self.MonsterCommonParam.myState == FightEnum.EntityState.Move then
					BehaviorFunctions.StopMove(self.MonsterCommonParam.me)
					self.MonsterCommonParam.moveState = self.MonsterCommonParam.MoveStateEnum.Default
				end
				--角度判断
				if BehaviorFunctions.CompEntityLessAngle(self.MonsterCommonParam.me,self.MonsterCommonParam.battleTarget,self.MonsterCommonParam.currentSkillList[self.MonsterCommonParam.currentSkillListNum].angle) then
					self.inSkillAngle = true
					self.MonsterCommonParam.skillState = self.MonsterCommonParam.SkillStateEnum.Ready
				else
					self.inSkillAngle = false
					--BehaviorFunctions.DoLookAtTargetImmediately(self.MonsterCommonParam.me,self.MonsterCommonParam.battleTarget)
					BehaviorFunctions.DoLookAtTargetByLerp(self.MonsterCommonParam.me,self.MonsterCommonParam.battleTarget,true,0,240,-2)
				end
			end
			--角度合适则放技能
			if self.MonsterCommonParam.skillState == self.MonsterCommonParam.SkillStateEnum.Ready then
				BehaviorFunctions.CancelLookAt(self.MonsterCommonParam.me)
				BehaviorFunctions.CastSkillByTarget(self.MonsterCommonParam.me,self.MonsterCommonParam.currentSkillId,self.MonsterCommonParam.battleTarget)
				self.FightTargetArrowEffect=true
				--技能cd
				self.MonsterCommonParam.currentSkillList[self.MonsterCommonParam.currentSkillListNum].frame = self.MonsterCommonParam.myFrame + self.MonsterCommonParam.currentSkillList[self.MonsterCommonParam.currentSkillListNum].cd * 30
				--公共cd帧数=当前帧数+公共cd*30+持续帧数
				self.skillCastingFrame = self.MonsterCommonParam.myFrame + self.MonsterCommonParam.currentSkillList[self.MonsterCommonParam.currentSkillListNum].durationFrame
				if self.MonsterCommonParam.currentSkillList[self.MonsterCommonParam.currentSkillListNum].ignoreCommonSkillCd == true then
					self.MonsterCommonParam.commonSkillCdFrame = self.MonsterCommonParam.myFrame + self.MonsterCommonParam.currentSkillList[self.MonsterCommonParam.currentSkillListNum].durationFrame
				else
					self.MonsterCommonParam.commonSkillCdFrame = self.MonsterCommonParam.myFrame + self.MonsterCommonParam.commonSkillCd * 30 + self.MonsterCommonParam.currentSkillList[self.MonsterCommonParam.currentSkillListNum].durationFrame
				end
				self.MonsterCommonParam.skillState = self.MonsterCommonParam.SkillStateEnum.CastingSkill
				self.MonsterCommonParam.moveState = self.MonsterCommonParam.MoveStateEnum.Default
			end
			--技能释放计时
			if self.MonsterCommonParam.skillState == self.MonsterCommonParam.SkillStateEnum.CastingSkill and self.MonsterCommonParam.myFrame >= self.skillCastingFrame then
				self.MonsterCommonParam.skillState = self.MonsterCommonParam.SkillStateEnum.InCommonCd
			elseif self.MonsterCommonParam.skillState == self.MonsterCommonParam.SkillStateEnum.CastingSkill and BehaviorFunctions.GetSkill(self.MonsterCommonParam.me) == 0 then
				self.MonsterCommonParam.skillState = self.MonsterCommonParam.SkillStateEnum.InCommonCd
			end
			--公共CD计时
			if self.MonsterCommonParam.skillState == self.MonsterCommonParam.SkillStateEnum.InCommonCd and self.MonsterCommonParam.myFrame >=self.MonsterCommonParam.commonSkillCdFrame then
				self.MonsterCommonParam.skillState = self.MonsterCommonParam.SkillStateEnum.Default
				self.MonsterCommonParam.currentSkillId = 0
				self.prepareSkillList = {}
				--分组处理
				if self.MonsterCommonParam.groupSkillSign == 1 then
					BehaviorFunctions.SetEntityValue(self.MonsterCommonParam.me,"GroupSkill",0)
					self.MonsterCommonParam.groupSkillFrame = self.MonsterCommonParam.myFrame
					self.MonsterCommonParam.groupSkillNum = self.MonsterCommonParam.currentSkillListNum
				end
			end
		end
	end
	
	--检查是否有标记。如果有标记，且暂无攻击特效，则显示。否则不显示。
	if BehaviorFunctions.GetSkillSign(self.MonsterCommonParam.me,9999) 
		and self.FightTargetArrowEffect==true and self.warnSign ~= 1 and BehaviorFunctions.GetDistanceFromTarget(self.MonsterCommonParam.me,self.MonsterCommonParam.battleTarget,false) < 8 then
		if not BehaviorFunctions.CheckFightTargetArrowEffect(self.MonsterCommonParam.me) then
			BehaviorFunctions.PlayFightTargetArrowEffect(self.MonsterCommonParam.me,true)
		end
	elseif not BehaviorFunctions.GetSkillSign(self.MonsterCommonParam.me,9999) and self.warnSign ~= 1 then
		if BehaviorFunctions.CheckFightTargetArrowEffect(self.MonsterCommonParam.me) then
			BehaviorFunctions.PlayFightTargetArrowEffect(self.MonsterCommonParam.me,false)
		end
	end
	
end


--技能列表初始化
function MonsterCastSkill:InitSkillList(skillList)
	local list = {}
	for k = 1, #skillList do
		list[k] = skillList[k]
		list[k].frame = list[k].frame
	end
	--技能列表排序，优先级：优先priority降序，priority相同则id升序
	table.sort(list,function(a,b)
			if a.priority > b.priority then
				return true
			elseif a.priority == b.priority then
				if a.id < b.id then
					return true
				end
			end
		end)
	--剔除难度系数大于预设难度的技能
	for i = #list,1,-1 do
		if list[i].difficultyDegree > self.MonsterCommonParam.difficultyDegree then
			table.remove(list,i)
		end
	end
	return list
end


function MonsterCastSkill:RemoveListByPriority(skillList,priority)
	local list = {}
	for k = 1, #skillList do
		list[k] = skillList[k]
	end
	for num = #list,1,-1 do
		if list[num].priority < priority then
			table.remove(list,num)
		end
	end
	return list
end

--根据id查找列表中对应id的技能的列表下标
function MonsterCastSkill:SerchSkillList(skillid,table)
	for i = 1,#table do
		if skillid == table[i].id then
			return i
		end
	end
end

--修改初始技能列表
function MonsterCastSkill:initialSkillListAlter(table)
	for i = #self.MonsterCommonParam.initialSkillList,1,-1 do
		for j = #table,1,-1 do
			if self.MonsterCommonParam.initialSkillList[i].id == table[j].id then
				self.MonsterCommonParam.initialSkillList[i] = table[j]
			end
		end
	end
end

--修改当前技能列表单个参数
function MonsterCastSkill:AlterCurrentSkillList(id,ParamName,Param)
	for i = #self.MonsterCommonParam.currentSkillList,1,-1 do
		if self.MonsterCommonParam.currentSkillList[i].id == id then
			self.MonsterCommonParam.currentSkillList[i][ParamName] = Param
		end
	end
end

function MonsterCastSkill:Collide(attackInstanceId,hitInstanceId)
	--受击后提前驱除闪烁标记
	if attackInstanceId==self.MonsterCommonParam.me
		and hitInstanceId==self.MonsterCommonParam.battleTarget then
		--检查是否有标记。如果有标记，且暂无攻击特效，则显示。否则不显示。
		self.FightTargetArrowEffect=false
	end

	--播放霸体特效
	if hitInstanceId == self.MonsterCommonParam.me then
		--播放霸体受击特效
		if BehaviorFunctions.HasBuffKind(hitInstanceId,900000040) and self.MonsterCommonParam.hitEffectFrame < self.MonsterCommonParam.myFrame then
			BehaviorFunctions.DoMagic(self.MonsterCommonParam.me,self.MonsterCommonParam.me,900000052)
			self.MonsterCommonParam.hitEffectFrame = self.MonsterCommonParam.myFrame + 8
		end
	end
end

function MonsterCastSkill:FinishSkill(instanceId,skillId,skillType)
	if instanceId==self.MonsterCommonParam.me
		and BehaviorFunctions.CheckFightTargetArrowEffect(self.MonsterCommonParam.me) then
		self.FightTargetArrowEffect=false
	end
end

function MonsterCastSkill:BreakSkill(instanceId,skillId,skillType)
	if instanceId==self.MonsterCommonParam.me
		and BehaviorFunctions.CheckFightTargetArrowEffect(self.MonsterCommonParam.me) then
		self.FightTargetArrowEffect=false
	end
end

function MonsterCastSkill:Warning(instance, targetInstance, sign ,isEnd)
	if instance == self.MonsterCommonParam.me and sign == 900050 and BehaviorFunctions.GetDistanceFromTarget(instance,targetInstance,false) >= 8 and isEnd == nil then
		self.warnSign = 1
		if not BehaviorFunctions.CheckFightTargetArrowEffect(self.MonsterCommonParam.me) then
			BehaviorFunctions.PlayFightTargetArrowEffect(self.MonsterCommonParam.me,true)
		end
	end
	if instance == self.MonsterCommonParam.me and sign == 900050 and isEnd == true then
		if BehaviorFunctions.CheckFightTargetArrowEffect(self.MonsterCommonParam.me) then
			BehaviorFunctions.PlayFightTargetArrowEffect(self.MonsterCommonParam.me,false)
			self.warnSign = 0
		end
	end
end

