FSMBehavior90000301 = BaseClass("FSMBehavior90000301",FSMBehaviorBase)
--战斗游荡总状态


function FSMBehavior90000301.GetGenerates()
	local generates = {}
	return generates
end

function FSMBehavior90000301:Init()
	self.inSkillAngle = 0                                                   --是否符合技能释放角度
	self.skillCastingFrame = 0
	self.prepareSkillList = {}                                              --准备中技能列表(能立刻放的技能)
	self.skillBeginFrame = 0
	self.FightTargetArrowEffect=false
	self.warnSign = 0

end

function FSMBehavior90000301:Update()
	--测试用判断是否能进CastSkill
	self.MainBehavior.CanCastSkill = true
	
	if  not BehaviorFunctions.HasBuffKind(self.MainBehavior.me,5003)
		and self.MainBehavior.roleState ~= FightEnum.EntityState.Die and self.MainBehavior.roleState ~= FightEnum.EntityState.Death then
		--技能列表初始化
		if 	self.MainBehavior.skillBeginState == 0 and self.ParentBehavior.skillState == self.ParentBehavior.skillStateEnum.Default then
			if self.MainBehavior.initialSkillList and next(self.MainBehavior.initialSkillList) then
				self.MainBehavior.currentSkillList = self:InitSkillList(self.MainBehavior.initialSkillList)
				self.skillBeginFrame = self.MainBehavior.myFrame
				self.ParentBehavior.skillState = self.ParentBehavior.skillStateEnum.Initial
				self.MainBehavior.skillBeginState = 1
			end
		end
		--等初始CD
		if self.ParentBehavior.skillState == self.ParentBehavior.skillStateEnum.Initial
			and self.MainBehavior.myFrame - self.skillBeginFrame > self.MainBehavior.initialSkillCd * 30 then
			self.ParentBehavior.skillState = self.ParentBehavior.skillStateEnum.Default
		end

		--技能释放逻辑
		if  BehaviorFunctions.CanCtrl(self.MainBehavior.me) then
			--技能选择:把符合条件的技能都放入currentSkillList中
			if self.ParentBehavior.skillState == self.ParentBehavior.skillStateEnum.Default
				and self.MainBehavior.currentSkillList and next(self.MainBehavior.currentSkillList)
				--群组ai规定，怪物必须有攻击性才能进后续流程
				and self.MainBehavior.isAggressive == 1
				--群组ai规定，根据远近程判断现在是否处于群组公共cd
				and ((self.MainBehavior.attackRange == 1 and not BehaviorFunctions.HasEntitySign(1,10000036))
					or (self.MainBehavior.attackRange == 2 and not BehaviorFunctions.HasEntitySign(1,10000037))) then
				for num = 1,#self.MainBehavior.currentSkillList,1 do
					local judgeState = 0
					--条件1：是否自动释放
					if judgeState == 0 then
						if self.MainBehavior.currentSkillList[num].isAuto == true then
							judgeState = 1
						end
					end
					--条件2：CD判断
					if judgeState == 1 then
						if self.MainBehavior.currentSkillList[num].frame < self.MainBehavior.myFrame then
							judgeState = 2
						end
					end
					--条件3：距离判断
					if judgeState == 2 then
						if self.MainBehavior.battleTargetDistance >= self.MainBehavior.currentSkillList[num].minDistance and
							self.MainBehavior.battleTargetDistance < self.MainBehavior.currentSkillList[num].maxDistance then
							judgeState = 3
						end
					end
					--条件4：血量判断
					if judgeState == 3 then
						if self.MainBehavior.haveSkillLifeRatio then
							if self.MainBehavior.LifeRatio > self.MainBehavior.currentSkillList[num].minLifeRatio and
								self.MainBehavior.LifeRatio <= self.MainBehavior.currentSkillList[num].maxLifeRatio then
								judgeState = 4
							end
						else
							judgeState = 4
						end
					end
					--条件5：目标受击判断
					if judgeState == 4  then
						if self.MainBehavior.currentSkillList[num].canCastSkillWhenTargetInHit == true then
							judgeState = 5
						else
							if self.MainBehavior.targetInHit == false then
								judgeState = 5
							end
						end
					end
					--条件6：特殊条件判断
					if judgeState == 5  then
						if not self.MainBehavior.mySpecialState
							or (self.MainBehavior.mySpecialState
								and self.MainBehavior.currentSkillList[num].specialState==self.MainBehavior.mySpecialState) then
							judgeState = 6
						end
					end
					--条件7：分级技能判断，属于群组ai
					if judgeState == 6 then
						--处理配置为空的保底
						if not self.MainBehavior.currentSkillList[num].grade then
							self.MainBehavior.currentSkillList[num].grade = 1
						end
						--为低等级技能，或者高等级技能但是不在公共冷却，可以释放
						if self.MainBehavior.currentSkillList[num].grade <= self.ParentBehavior.grade
							or (self.MainBehavior.currentSkillList[num].grade > self.ParentBehavior.grade and not BehaviorFunctions.HasEntitySign(1,10000034)) then
							judgeState = 7
						end
					end
					--选好技能，插入prepareSkillList
					if judgeState == 7 then
						table.insert(self.prepareSkillList,self.MainBehavior.currentSkillList[num])
					end
					if num == #self.MainBehavior.currentSkillList then
						self.ParentBehavior.skillState = self.ParentBehavior.skillStateEnum.PrepareSkill
					end
				end
			end

			--prepareSkillList中选择技能释放
			if self.ParentBehavior.skillState == self.ParentBehavior.skillStateEnum.PrepareSkill then
				if #self.prepareSkillList > 0 then
					self.prepareSkillList = self:InitSkillList(self.prepareSkillList,true)
					local priority = self.prepareSkillList[1].priority
					local weightSum = 0
					local currentWeight = 1
					local randomSum = 0
					--仅保留最高优先级技能
					self.prepareSkillList = self:RemoveListByPriority(self.prepareSkillList,priority)
					--计算权重总和
					for num = 1, #self.prepareSkillList do
						if not self.prepareSkillList[num].weight or self.prepareSkillList[num].weight == 0 then
							self.prepareSkillList[num].weight = 1
						end
						weightSum = weightSum + self.prepareSkillList[num].weight
					end
					--权重随机
					if weightSum > 1 then
						currentWeight = BehaviorFunctions.Random(0,weightSum)
					else
						currentWeight = 1
					end
					--按随机结果选择技能
					for num = 1, #self.prepareSkillList do
						if self.prepareSkillList[num].weight then
							randomSum = randomSum + self.prepareSkillList[num].weight
							if randomSum >=  currentWeight then
								self.MainBehavior.currentSkillListNum = self:SerchSkillList(self.prepareSkillList[num].id,self.MainBehavior.currentSkillList)
								self.MainBehavior.currentSkillId = self.prepareSkillList[num].id
								break
							end
						end
					end
					if self.MainBehavior.currentSkillId~= 0 then
						self.ParentBehavior.skillState = self.ParentBehavior.skillStateEnum.HaveSkill
						BehaviorFunctions.CustomFSMTryChangeState(self.MainBehavior.me)
					end
				else
					self.ParentBehavior.skillState = self.ParentBehavior.skillStateEnum.Default
				end
			end
			
		end
	end
end

--技能列表初始化
function FSMBehavior90000301:InitSkillList(skillList,iscast)
	local list = {}
	for k = 1, #skillList do
		list[k] = skillList[k]
		if iscast then
			list[k].frame = skillList[k].frame
		else
			list[k].frame = skillList[k].frame + self.MainBehavior.myFrame
		end

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
		if list[i].difficultyDegree > self.MainBehavior.difficultyDegree then
			table.remove(list,i)
		end
	end
	return list
end


function FSMBehavior90000301:RemoveListByPriority(skillList,priority)
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
function FSMBehavior90000301:SerchSkillList(skillid,table)
	for i = 1,#table do
		if skillid == table[i].id then
			return i
		end
	end
end

--修改初始技能列表
function FSMBehavior90000301:initialSkillListAlter(table)
	for i = #self.MainBehavior.initialSkillList,1,-1 do
		for j = #table,1,-1 do
			if self.MainBehavior.initialSkillList[i].id == table[j].id then
				self.MainBehavior.initialSkillList[i] = table[j]
			end
		end
	end
end

--修改当前技能列表单个参数
function FSMBehavior90000301:AlterCurrentSkillList(id,ParamName,Param)
	for i = #self.MainBehavior.currentSkillList,1,-1 do
		if self.MainBehavior.currentSkillList[i].id == id then
			self.MainBehavior.currentSkillList[i][ParamName] = Param
		end
	end
end