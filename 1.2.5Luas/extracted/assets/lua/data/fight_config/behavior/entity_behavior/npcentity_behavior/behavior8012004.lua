Behavior8012004 = BaseClass("Behavior8012004",EntityBehaviorBase)

--初始化
function Behavior8012004:Init() 
	self.me = self.instanceId
	self.myFrame = 0
	self.battleTargetDistance = 0
	self.myHeight = 2.0
	self.myLenth = 2.5
	
	--出生参数
	self.bornPos = nil
	self.isFriendly = nil
	self.isBornLie = nil
	
	--状态切换
	self.myState = 0
	self.myStateEnum = 
	{
		Default = 0, --默认
		Initial = 1, --初始化性格
		Leisure = 2, --休闲状态
		Escape = 3, --逃跑状态
		Fight = 4, --战斗状态
		makeFriend = 5, --示好状态
		Removing = 6 --消失中
	}
	self.leisureState = 0
	self.leisureStateEnum = 
	{
		LeisureWalk = 0,
		LeisureIdle = 1,
	}
	
	--休闲状态
	self.leisureCD = 5        --休闲状态下多久做一次行动变化
	self.leisureFrame = 0     --记录休闲状态的帧数
	self.wandMinRange = 4     --游荡的最短距离
	self.wandMaxRange = 8     --游荡的最远距离

	--示好状态
	self.isMakingFriend = false
	self.friendlyMaxRange = 4
	self.friendlyMinRange = 0

	--默认动作
	self.actList = 
	{
		[1] = {aniName = "Eat", lastFrame = 120},           --休闲动作列表
		[2] = {aniName = "Stand1", lastFrame = 80},
		[3] = {aniName = "Comb", lastFrame = 90},
		[4] = {aniName = "Walk", lastFrame = 20}
	}
	self.defaultActing = nil
	self.defaultActNum = 1
	self.defaultActState = 0
	self.defaultActStateEnum =
	{
		Default = 0, --默认
		In = 1, --进入
		End = 2, --结束
	}
	self.walkLoopCount = nil

	--躺倒动作
	self.lieActEnum =
	{
		[1] = {aniName = "LieIn", lastFrame = 60},          --躺倒动作列表
		[2] = {aniName = "LieLoop", lastFrame = 120},
		[3] = {aniName = "LieOut", lastFrame = 60}
	}
	self.lying = nil
	self.lieNum = 1
	self.lieState = 0
	self.lieStateEnum =
	{
		Default = 0, --默认
		In = 1, --进入
		Loop = 2, --持续
		Out = 3, --退出
		End = 4, --结束
	}
	self.lieLoopCount = nil

	--寻路参数
	self.findingPath = false
	self.targetPos = nil
	
	--攻击参数
	self.battleTarget = 0								                    --战斗目标
	self.canAttack = false	   --是否会主动攻击
	self.skillList = {                  --技能列表
		{id = 801200401,
		minDistance = 0,                      --技能释放最小距离（有等号）
		maxDistance = 2,                    --技能释放最大距离（无等号）
		angle = 120,                          --技能释放角度
		cd = 3,                               --技能cd，单位：秒
		durationFrame = 65,                   --技能持续帧数
		cdFrame = 90}	                            
	}
	self.initialSkillCd = 0				--技能初始cd
	self.inSkillAngle = 0                                                   --是否符合技能释放角度
	self.skillCastingFrame = 0
	self.skillBeginFrame = 0
	self.skillBeginState = 0
	self.FightTargetArrowEffect = false
	self.warnSign = 0

	self.skillState = 0	                                                    --技能状态
	self.SkillStateEnum = {                                                 --技能状态枚举
		Default = 0,
		--Initial = 1,
		PrepareSkill = 2,
		HaveSkill = 3,
		Ready = 4,
		CastingSkill = 5,
		InCommonCd = 6
	}
	self.currentSkillId = 0				                                    --记录当前释放中技能，否则为0
	
	--逃跑参数
	self.escapeCheckTime = 0.5
	self.escapeFrame = 0
	self.vanishTime = 2.8
	self.vanishRemoveDelay = nil
end

--初始化结束
function Behavior8012004:LateInit()	
	if self.sInstanceId then
	end	
end

--帧事件
function Behavior8012004:Update()
	self.myFrame = BehaviorFunctions.GetEntityFrame(self.me)
	self.role = BehaviorFunctions.GetCtrlEntity()
	self.entityState = BehaviorFunctions.GetEntityState(self.me)
	
	if not BehaviorFunctions.CanCtrl(self.me) then
		return
	end
	
	if not self.bornPos then
		self.bornPos = BehaviorFunctions.GetPositionP(self.me)
	end
	
	--默认状态进入出生性格生成
	if self.myState == self.myStateEnum.Default then
		self:BornRollPersonality()
		self.myState = self.myStateEnum.Initial
	end

	--初始化进入休闲状态
	if self.myState == self.myStateEnum.Initial then
		if self.isBornLie == true then
			self:LieAct()
		end
		self.myState = self.myStateEnum.Leisure
	end
	
	--如果处于休闲状态下
	if self.myState == self.myStateEnum.Leisure then
		self:DefaultAct()
		self:ShouldEnterFight()

	--如果处于战斗状态下	
	elseif self.myState == self.myStateEnum.Fight then
        self:InFight(self.role)
	
	--如果处于示好状态下
	elseif self.myState == self.myStateEnum.makeFriend then
		self:makeFriend(self.role)
		
	--如果处于逃跑状态下
	elseif self.myState == self.myStateEnum.Escape then
		local result = self:ReturnObstractDis(1,0)
		if result then
			self:Vanish()
		else
			if self.escapeFrame < self.myFrame then
				self.escapeFrame = self.myFrame + self.escapeCheckTime *30
				self:Escape(self.role)
			end
		end
		
	--如果处于消失状态下
	elseif self.myState == self.myStateEnum.Removing then
		--进入无敌不被杀死状态
		if not BehaviorFunctions.HasBuffKind(self.me,900000007) then
			BehaviorFunctions.AddBuff(1, self.me,900000007)
		end
	end		
end

--战斗逻辑
function Behavior8012004:InFight(battleTarget)
	if self.myState == self.myStateEnum.Fight then
		local angle = BehaviorFunctions.GetEntityAngle(self.me, self.role)
		self.battleTargetDistance = BehaviorFunctions.GetDistanceFromTarget(self.me, battleTarget)
		--距离判断
		if self.skillState == self.SkillStateEnum.Default then
			if self.battleTargetDistance > self.skillList[1].maxDistance then
				local battleTargetPos = BehaviorFunctions.GetPositionP(battleTarget)
				BehaviorFunctions.DoLookAtPositionByLerp(self.me, battleTargetPos.x, battleTargetPos.y, battleTargetPos.z, false, 180, 460, true)
				if BehaviorFunctions.GetSubMoveState(self.me) ~= FightEnum.EntityMoveSubState.Walk then
					BehaviorFunctions.DoSetMoveType(self.me,FightEnum.EntityMoveSubState.Walk)
				end
			elseif self.battleTargetDistance >= self.skillList[1].minDistance and
				self.battleTargetDistance < self.skillList[1].maxDistance then
					self.skillState = self.SkillStateEnum.CastingSkill
			end
		end
		if self.skillState == self.SkillStateEnum.CastingSkill then
			BehaviorFunctions.DoLookAtTargetImmediately(self.me, self.role)
			BehaviorFunctions.CastSkillByTarget(self.me, self.skillList[1].id, battleTarget)
			self.skillState = self.SkillStateEnum.Default
			self.myState = self.myStateEnum.Escape
		end
	end
end

--出生性格逻辑
function Behavior8012004:BornRollPersonality()
    -- 随机决定性格
    self.isFriendly = (math.random(1, 2) == 1)

    -- 设置是否可攻击
    if not self.isFriendly then
        self.canAttack = true
    end

    -- 添加友善/敌意特效
    if self.isFriendly then
		local fxEntityPeace = BehaviorFunctions.CreateEntity(80120040104, self.me)
    else
        local fxEntityDanger = BehaviorFunctions.CreateEntity(80120040103, self.me)
    end

	--出生是否躺倒
	self.isBornLie = (math.random(1, 2) == 1)
end

--死亡逻辑
function Behavior8012004:Die(attackInstanceId,instanceId)
	if instanceId == self.me then
		if self.myState == self.myStateEnum.Removing then
			BehaviorFunctions.RemoveDelayCall(self.vanishRemoveDelay)
		end
	end
end

--躺倒动作逻辑
function Behavior8012004:LieAct()
	if self.myState == self.myStateEnum.Leisure and self.isBornLie == true then
		if self.lieState == self.lieStateEnum.Default then
			self.lieState = self.lieStateEnum.In
		end
		--躺下
		if self.lieState == self.lieStateEnum.In and not self.lying then
			BehaviorFunctions.PlayAnimation(self.me, self.lieActEnum[1].aniName)   --可以把1、2、3改成用defaultLieNum控制
			self.lying = true
			BehaviorFunctions.AddDelayCallByFrame(self.lieActEnum[1].lastFrame,self,self.Assignment,"lieState",self.lieStateEnum.Loop)
			BehaviorFunctions.AddDelayCallByFrame(self.lieActEnum[1].lastFrame,self,self.Assignment,"lying",nil)
		end
		--循环
		if self.lieState == self.lieStateEnum.Loop and not self.lying then
			BehaviorFunctions.PlayAnimation(self.me, self.lieActEnum[2].aniName)
			self.lieLoopCount = math.random(2, 10)
			self.lying = true
			BehaviorFunctions.AddDelayCallByFrame(self.lieActEnum[2].lastFrame*self.lieLoopCount,self,self.Assignment,"lieState",self.lieStateEnum.Out)
			BehaviorFunctions.AddDelayCallByFrame(self.lieActEnum[2].lastFrame*self.lieLoopCount,self,self.Assignment,"lying",nil)
		end
		--起身
		if self.lieState == self.lieStateEnum.Out and not self.lying then
			BehaviorFunctions.PlayAnimation(self.me,self.lieActEnum[3].aniName)
			self.lying = true
			BehaviorFunctions.AddDelayCallByFrame(self.lieActEnum[3].lastFrame,self,self.Assignment,"lieState",self.lieStateEnum.End)
			BehaviorFunctions.AddDelayCallByFrame(self.lieActEnum[3].lastFrame,self,self.Assignment,"lying",nil)
		end
		--结束
		if self.lieState == self.lieStateEnum.End and not self.lying then
			self.lying = true
			self.isBornLie = false
		end
	end
end

--默认动作轮播（包括游荡）
function Behavior8012004:DefaultAct()
	if self.myState == self.myStateEnum.Leisure then
		--播放
		if self.defaultActState == self.defaultActStateEnum.Default and not self.defaultActing then
			self.defaultActNum = math.random(1, #self.actList)
			local aniName = self.actList[self.defaultActNum].aniName
			--如果是行走，转向跳一定次数
			if aniName == "Walk" then
				local randomAngle = math.random(0,360)
				local lookAtPos = BehaviorFunctions.GetPositionOffsetBySelf(self.me, 100, randomAngle)
				BehaviorFunctions.DoLookAtPositionByLerp(self.me,lookAtPos.x,lookAtPos.y,lookAtPos.z,false,180,460,true)
				self.walkLoopCount = math.random(4, 8)
				BehaviorFunctions.DoSetMoveType(self.me,FightEnum.EntityMoveSubState.Walk)
				self.defaultActing = true
				BehaviorFunctions.AddDelayCallByFrame(self.actList[self.defaultActNum].lastFrame*self.walkLoopCount,self,self.Assignment,"defaultActState",self.defaultActStateEnum.Default)
				BehaviorFunctions.AddDelayCallByFrame(self.actList[self.defaultActNum].lastFrame*self.walkLoopCount,self,self.Assignment,"defaultActing",nil)
			--如果不是行走，直接播放
			else
				if BehaviorFunctions.GetSubMoveState(self.me) == FightEnum.EntityMoveSubState.Walk then
					BehaviorFunctions.DoSetMoveType(self.me,FightEnum.EntityMoveSubState.None)
				end
				BehaviorFunctions.PlayAnimation(self.me,aniName)
				self.defaultActing = true
				BehaviorFunctions.AddDelayCallByFrame(self.actList[self.defaultActNum].lastFrame,self,self.Assignment,"defaultActState",self.defaultActStateEnum.Default)
				BehaviorFunctions.AddDelayCallByFrame(self.actList[self.defaultActNum].lastFrame,self,self.Assignment,"defaultActing",nil)
			end
		end
	end
end

--进战或示好逻辑
function Behavior8012004:ShouldEnterFight()
	if self.myState == self.myStateEnum.Leisure then
		local distance = BehaviorFunctions.GetDistanceFromTarget(self.me, self.role)
		-- 如果实体和玩家距离小于20米且敌视人，则将状态切换到战斗状态
		if distance < 20 and self.canAttack == true then
			self.myState = self.myStateEnum.Fight
		end
		
		-- 如果距离小于10米且canAttack是false，则将状态切换到示好状态
		if distance  < 15 and self.canAttack == false and self.isMakingFriend == false then
			self.myState = self.myStateEnum.makeFriend
		end
	end
end


--示好状态
function Behavior8012004:makeFriend(target)
	if self.myState == self.myStateEnum.makeFriend then
		local targetDistance = BehaviorFunctions.GetDistanceFromTarget(self.me, target)
		--距离判断
		if targetDistance > self.friendlyMaxRange then
			local targetPos = BehaviorFunctions.GetPositionP(target)
			BehaviorFunctions.DoLookAtPositionByLerp(self.me, targetPos.x, targetPos.y, targetPos.z, false, 180, 460, true)
			if BehaviorFunctions.GetSubMoveState(self.me) ~= FightEnum.EntityMoveSubState.Walk then
				BehaviorFunctions.DoSetMoveType(self.me,FightEnum.EntityMoveSubState.Walk)
			end
		elseif targetDistance >= self.friendlyMinRange and targetDistance < self.friendlyMaxRange and self.isMakingFriend == false then
			BehaviorFunctions.DoSetMoveType(self.me,FightEnum.EntityMoveSubState.None)
			local aniName = self.actList[3].aniName
			BehaviorFunctions.PlayAnimation(self.me,aniName)
			self.isMakingFriend = true
			--BehaviorFunctions.AddDelayCallByFrame(self.actList[3].lastFrame,self,self.Assignment,"isMakingFriend", false)
			BehaviorFunctions.AddDelayCallByFrame(self.actList[3].lastFrame,self,self.Assignment,"myState", self.myStateEnum.Leisure)
		end
	end
end


--朝目标的反方向逃跑
function Behavior8012004:Escape(target)
	local EnemyAngle = BehaviorFunctions.GetEntityAngle(self.me,target)
	local escapeDir = 0
	if EnemyAngle <= 180 then
		escapeDir = 180 + EnemyAngle
	else
		escapeDir = EnemyAngle - 180
	end
	local myPos = BehaviorFunctions.GetPositionP(self.me)
	local directionPos = BehaviorFunctions.GetPositionOffsetBySelf(self.me,100,escapeDir)
	BehaviorFunctions.DoLookAtPositionByLerp(self.me,directionPos.x,directionPos.y,directionPos.z,false,180,460,true)
	if BehaviorFunctions.GetSubMoveState(self.me) ~= FightEnum.EntityMoveSubState.Walk then
		BehaviorFunctions.DoSetMoveType(self.me,FightEnum.EntityMoveSubState.Walk)
	end
end

--开始消失隐藏模型
function Behavior8012004:Vanish()
	self.myState = self.myStateEnum.Removing
	BehaviorFunctions.DoSetEntityState(self.me,FightEnum.EntityState.Idle)
	self.vanishRemoveDelay = BehaviorFunctions.AddDelayCallByFrame(self.vanishTime * 30,BehaviorFunctions,BehaviorFunctions.RemoveEntity,self.me)
	BehaviorFunctions.CreateEntity(900000109,self.me)
	BehaviorFunctions.PlayAnimation(self.me,"Run")
end

--赋值
function Behavior8012004:Assignment(variable,value)
	self[variable] = value
	if variable == "myState" then
	end
end

--回调受击状态
function Behavior8012004:Hit(attackInstanceId,hitInstanceId,hitType)
	if hitInstanceId == self.me and attackInstanceId == self.role then
		self.myState = self.myStateEnum.Fight
		local fxEntityDanger = BehaviorFunctions.CreateEntity(80120040103, self.me)
	end
end

--返回对应方向角度距离是否有障碍
function Behavior8012004:ReturnObstractDis(distance,angle)
	--检查方式：取怪物身体长度和高度来计算其最前端是否能够跨过前方障碍
	local myPos = BehaviorFunctions.GetPositionP(self.me)
	local detectPos = Vec3.New(myPos.x,myPos.y + (self.myHeight/2),myPos.z)
	local targetPos = BehaviorFunctions.GetPositionOffsetBySelf(self.me,self.myLenth + distance,angle)
	targetPos.y = targetPos.y + (self.myHeight/2)
	local result = BehaviorFunctions.CheckObstaclesBetweenPos(detectPos,targetPos,true)
	if result then
		local obstarctDis = BehaviorFunctions.GetDistanceBetweenObstaclesAndPos(detectPos,targetPos,true)
		targetPos = BehaviorFunctions.GetPositionOffsetBySelf(self.me,obstarctDis,angle)
	end
	return result,targetPos
end


function Behavior8012004:RemoveEntity(instanceId)
	if self.fxEntityPeace and BehaviorFunctions.CheckEntity(self.fxEntityPeace) then
		BehaviorFunctions.RemoveEntity(self.fxEntityPeace)
	end
	if self.fxEntityDanger and BehaviorFunctions.CheckEntity(self.fxEntityDanger) then
		BehaviorFunctions.RemoveEntity(self.fxEntityDanger)
	end
end