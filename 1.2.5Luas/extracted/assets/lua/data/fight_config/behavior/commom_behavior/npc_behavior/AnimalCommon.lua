AnimalCommon = BaseClass("AnimalCommon",EntityBehaviorBase)

--初始化
function AnimalCommon:Init()
	--逻辑参数
	self.me = self.instanceId
	self.myFrame = 0
	
	--怪物参数
	self.myHeight = 0.8
	self.myLenth = 1.6
	
	--状态切换
	self.myState = 0
	self.myStateEnum = 
	{
		Default = 0, --默认
		Leisure = 1, --休闲状态
		Alert = 2, --警戒状态
		Escape = 3, --逃跑状态
		Fight = 4, --战斗状态
		Turn = 5, --转身
		Removing = 6 --消失中
	}
	
	self.leisureState = 0
	
	self.leisureStateEnum = 
	{
		LeisureWalk = 0,
		LeisureIdle = 1,
	}
	
	--出生点
	self.bornPos = nil
	
	--目标
	self.mainEnemy = nil	   --当前最主要的敌人
	self.enemyList = {}
	
	--休闲状态
	self.leisureCD = 5        --休闲状态下多久做一次行动变化
	self.leisureFrame = 0     --记录休闲状态的帧数
	self.wandMinRange = 4     --游荡的最短距离
	self.wandMaxRange = 8     --游荡的最远距离

	--默认动作
	self.actList= {[1] = {aniName = "Eat" , lastTime = 4}}	 --休闲动作列表
	self.defaultActing = nil
	self.defaultActNum = 1
	self.defaultActState = 0
	self.defaultActStateEnum = 
	{
		Default = 0, --默认
		In = 1, --进入
		Loop = 2, --持续
		Out = 3, --退出
		End = 4, --结束
	}
	
	--寻路参数
	self.findingPath = false
	self.targetPos = nil
	
	--警戒参数
	self.alertTime = 5          --代表如果敌人处于警戒的最边界需要多久才能发现，如果靠的越近则越容易被发现
	self.alertClearTime = 3     --多长时间解除警戒
	self.alertClearFrame = nil	--开始降低警戒的帧数
	self.alertMaxValue = 100	   --警戒值上限
	self.alertCurrentValue = 0  --当前警戒值
	self.alertFrame = 0		   --警戒动作循环帧数参数
	
	--警戒视觉参数
	self.visionAlert = true     --开启视觉警戒
	self.visionAngle = 45
	self.visionMaxDistance = 10--进入这个距离才会增长警戒值
	self.visionMinDistance = 3 --处于这个距离一定会暴露
	
	--警戒听觉参数				
	self.auditoryAlert = true     --开启听觉警戒
	self.auditoryMaxDistance = 10--进入这个距离才会增长警戒值
	
	--攻击参数
	self.canAttack = false	   --是否会主动攻击
	self.skillList = {}		   --技能列表
	self.skillCDFrame = 5	   --技能间隔时间
	self.skillFrame = 0		   --技能帧数
	
	--逃跑参数
	self.escapeCheckTime = 0.5
	self.escapeFrame = 0
	self.vanishTime = 2.8
	self.vanishRemoveDelay = nil
end


--初始化结束
function AnimalCommon:LateInit()	
	if self.sInstanceId then

	end	
end

--帧事件
function AnimalCommon:Update()
	self.myFrame = BehaviorFunctions.GetEntityFrame(self.me)
	self.role = BehaviorFunctions.GetCtrlEntity()
	self.entityState = BehaviorFunctions.GetEntityState(self.me)
	
	if not BehaviorFunctions.CanCtrl(self.me) then
		return
	end
	
	if not self.bornPos then
		self.bornPos = BehaviorFunctions.GetPositionP(self.me)
	end
	
	--初始化进入休闲状态
	if self.myState == self.myStateEnum.Default then
		self.myState = self.myStateEnum.Leisure
	end
	
	--如果处于休闲状态下
	if self.myState == self.myStateEnum.Leisure then
		self.alertCurrentValue = self:ReturnCurrentAlertValue(self.role)
		if self.alertCurrentValue > 0 then
			self.myState = self.myStateEnum.Alert
		else
			self:WandAround(self.bornPos,self.wandMinRange,self.wandMaxRange)
		end
	--如果进入警戒状态
	elseif self.myState == self.myStateEnum.Alert then
		--待机状态原地静止
		if BehaviorFunctions.GetEntityState(self.me) ~= FightEnum.EntityState.Idle then
			BehaviorFunctions.DoSetEntityState(self.me,FightEnum.EntityState.Idle)
			self.leisureState = self.leisureStateEnum.LeisureIdle
		end
		if self.myFrame > self.alertFrame then
			--播放警戒动作
			local aniName = "Alert"
			local aniFrame = BehaviorFunctions.GetEntityAnimationFrame(self.me,aniName)
			BehaviorFunctions.PlayAnimation(self.me,aniName)
			self.alertFrame = self.myFrame + aniFrame
		end		
		--头部疑问标识
		if not BehaviorFunctions.HasBuffKind(self.me,900000024) then
			BehaviorFunctions.AddBuff(self.me,self.me,900000024)
		end
		self.alertCurrentValue = self:ReturnCurrentAlertValue(self.role)
		--累积满警戒值的情况下
		if self.alertCurrentValue == self.alertMaxValue then
			if BehaviorFunctions.HasBuffKind(self.me,900000024) then
				BehaviorFunctions.RemoveBuff(self.me,900000024)
			end
			--头部警戒标识
			if not BehaviorFunctions.HasBuffKind(self.me,900000025) then
				BehaviorFunctions.AddBuff(self.me,self.me,900000025)
			end
			if self.canAttack == true then
				self.myState = self.myStateEnum.Fight
			else
				self.myState = self.myStateEnum.Escape
			end
		--若警戒值清零则返回休闲状态
		elseif self.alertCurrentValue == 0 then
			if BehaviorFunctions.HasBuffKind(self.me,900000024) then
				BehaviorFunctions.RemoveBuff(self.me,900000024)
			end
			self.myState = self.myStateEnum.Leisure
		end
	--如果处于战斗状态下	
	elseif self.myState == self.myStateEnum.Fight then
		
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
			BehaviorFunctions.AddBuff(self.me,self.me,900000007)
		end
	end		
end

function AnimalCommon:Die(attackInstanceId,instanceId)
	if instanceId == self.me then
		if self.myState == self.myStateEnum.Removing then
			BehaviorFunctions.RemoveDelayCall(self.vanishRemoveDelay)
		end
	end
end

--休闲待机巡逻逻辑
function AnimalCommon:WandAround(pos,minRange,maxRange)
	--待机状态根据CD切换
	if self.myFrame >= self.leisureFrame then
		if self.leisureState ~= self.leisureStateEnum.LeisureWalk then
			self.leisureState = self.leisureStateEnum.LeisureWalk
		end
	else
		if self.leisureState ~= self.leisureStateEnum.LeisureIdle then
			self.leisureState = self.leisureStateEnum.LeisureIdle
		end
	end

	if self.leisureState == self.leisureStateEnum.LeisureWalk then
		if BehaviorFunctions.GetSubMoveState(self.me) ~= FightEnum.EntityMoveSubState.Walk then
			if self.targetPos == nil then
				local worldPos = Vec3.New(0,0,0)
				local randomAngle = math.random(0,360)
				local randomRange = math.random(minRange,maxRange)
				self.targetPos = self:MoveDirectly(randomRange,randomAngle)
			else
				BehaviorFunctions.DoLookAtPositionByLerp(self.me,self.targetPos.x,self.targetPos.y,self.targetPos.z,false,180,460,true)
				if BehaviorFunctions.GetSubMoveState(self.me) ~= FightEnum.EntityMoveSubState.Walk then
					BehaviorFunctions.DoSetMoveType(self.me,FightEnum.EntityMoveSubState.Walk)
				end
			end		
		end
		local myPos = BehaviorFunctions.GetPositionP(self.me)
		if BehaviorFunctions.GetDistanceFromPos(myPos,self.targetPos) <= 2 then
			self.leisureState = self.leisureStateEnum.LeisureIdle
			self.leisureFrame = self.myFrame + self.leisureCD * 30
			self.targetPos = nil			
		end
	elseif self.leisureState == self.leisureStateEnum.LeisureIdle then
		BehaviorFunctions.DoSetEntityState(self.me,FightEnum.EntityState.Idle)
		self:DefaultAct()
	end
end

----位移转身
--function AnimalCommon:Turn(pos,lookPos)
	--if self.myState ~= self.myStateEnum.Turn then
		--local myPos = BehaviorFunctions.GetPositionP(self.me)
		--BehaviorFunctions.DoLookAtPositionByLerp(self.me,lookPos.x,myPos.y,lookPos.z,false,180,460)
		--BehaviorFunctions.PlayAnimation(self.me,"Standback")
		--local animationFrame = BehaviorFunctions.GetEntityAnimationFrame(self.me,"Standback")
		----默认情况
		--if self.myState ~= self.myStateEnum.Talk then
			--self.AssignmentDelay = BehaviorFunctions.AddDelayCallByFrame(animationFrame,self,self.Assignment,"myState",self.myStateEnum.Default)
		--elseif self.talkTurn and self.talkState == self.talkStateEnum.Ending then
			----对话结束的talkturn
			--BehaviorFunctions.AddDelayCallByFrame(animationFrame,self,self.Assignment,"talkTurn",nil)
			--BehaviorFunctions.AddDelayCallByFrame(animationFrame,self,self.Assignment,"talkState",self.talkStateEnum.Default)
			--self.AssignmentDelay = BehaviorFunctions.AddDelayCallByFrame(animationFrame,self,self.Assignment,"myState",self.myStateEnum.Default)
		--end
	--end
--end

--返回对应方向角度距离是否有障碍
function AnimalCommon:ReturnObstractDis(distance,angle)
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

--直线移动至地点
function AnimalCommon:MoveDirectly(distance,angle)
	--检查方式：取怪物身体长度和高度来计算其最前端是否能够跨过前方障碍
	local myPos = BehaviorFunctions.GetPositionP(self.me)
	local detectPos = Vec3.New(myPos.x,myPos.y + (self.myHeight/2),myPos.z)
	local targetPos = BehaviorFunctions.GetPositionOffsetBySelf(self.me,self.myLenth + distance,angle)
	targetPos.y = targetPos.y + (self.myHeight/2)
	local result = BehaviorFunctions.CheckObstaclesBetweenPos(detectPos,targetPos,true)
	if not result then
		BehaviorFunctions.DoLookAtPositionByLerp(self.me,targetPos.x,targetPos.y,targetPos.z,false,180,460,true)
		if BehaviorFunctions.GetSubMoveState(self.me) ~= FightEnum.EntityMoveSubState.Walk then
			BehaviorFunctions.DoSetMoveType(self.me,FightEnum.EntityMoveSubState.Walk)
		end
	else
		local obstarctDis = BehaviorFunctions.GetDistanceBetweenObstaclesAndPos(detectPos,targetPos,true)
		targetPos = BehaviorFunctions.GetPositionOffsetBySelf(self.me,obstarctDis,angle)
		BehaviorFunctions.DoLookAtPositionByLerp(self.me,targetPos.x,targetPos.y,targetPos.z,false,180,460,true)
		if BehaviorFunctions.GetSubMoveState(self.me) ~= FightEnum.EntityMoveSubState.Walk then
			BehaviorFunctions.DoSetMoveType(self.me,FightEnum.EntityMoveSubState.Walk)
		end
	end	
	return targetPos
end

--寻路至坐标
function AnimalCommon:MoveToPos(pos,moveType)
	local result = BehaviorFunctions.SetPathFollowPos(self.me,pos)
	if result == true then
		if BehaviorFunctions.GetSubMoveState(self.me) ~= moveType then
			BehaviorFunctions.DoSetMoveType(self.me,moveType)
			self.findingPath = true
			return true
		end
	else
		return false
	end
end

--停止寻路
function AnimalCommon:StopMoveToPos()
	BehaviorFunctions.DoSetEntityState(self.me,FightEnum.EntityState.Idle)
	BehaviorFunctions.ClearPathFinding(self.me)
	self.findingPath = false
end

--朝目标的反方向跑
function AnimalCommon:Escape(target)
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
	if BehaviorFunctions.GetSubMoveState(self.me) ~= FightEnum.EntityMoveSubState.Run then
		BehaviorFunctions.DoSetMoveType(self.me,FightEnum.EntityMoveSubState.Run)
	end
end

--寻路返回结果
function AnimalCommon:PathFindingEnd(instanceId,result)
	if instanceId == self.me then
		self:StopMoveToPos()
	end
end

--返回对目标的当前警戒值
function AnimalCommon:ReturnCurrentAlertValue(target)
	local targetAngle = BehaviorFunctions.GetEntityAngle(self.me,target)
	local targetDis = BehaviorFunctions.GetDistanceFromTarget(self.me,target)
	local angle = self.visionAngle
	local useVisition = false
	local useauditory = false
	local currentValue = 0
	
	--根据视觉是否开启视觉判断
	if self.visionAlert then
		--如果和目标之间没有障碍物不开启判断
		if not BehaviorFunctions.CheckObstaclesBetweenEntity(self.me,target,false) then
			if BehaviorFunctions.CompEntityLessAngle(self.me,target,self.visionAngle) then
				--处于范围区间时
				if self.visionMaxDistance >= targetDis then
					useVisition = true
				end
			end
		end
	end
	
	--如果启用视觉
	if useVisition then
		--处于范围区间时
		if self.visionMaxDistance >= targetDis and targetDis > self.visionMinDistance then
			--每帧平均增长速度
			local alertIncreaseValue = self.alertMaxValue / (self.alertTime *30)
			currentValue = self.alertCurrentValue + alertIncreaseValue
			if currentValue > self.alertMaxValue then
				currentValue = self.alertMaxValue
			end
			self.alertClearFrame = nil
			return currentValue
		elseif targetDis <= self.visionMinDistance then
			currentValue = self.alertMaxValue
			self.alertClearFrame = nil
			return currentValue
		end
	end
		
	--如果启用听觉
	if self.auditoryAlert then
		if self.auditoryMaxDistance >= targetDis then
			local targetState = BehaviorFunctions.GetEntityState(target)
			--如果对象不是待机状态
			if targetState ~= FightEnum.EntityState.Idle then
			--每帧平均增长速度
				local alertIncreaseValue = self.alertMaxValue / (self.alertTime *30)
				currentValue = self.alertCurrentValue + alertIncreaseValue
				if currentValue > self.alertMaxValue then
					currentValue = self.alertMaxValue
				end
				self.alertClearFrame = nil
				return currentValue
			end
		end
	end
	
	--return self.alertCurrentValue
	
	--如果看不到目标、也听不到目标，则开始降低警戒
	if self.alertCurrentValue > 0 then
		if not self.alertClearFrame then
			self.alertClearFrame = self.myFrame + self.alertClearTime * 30
		end
		if self.alertClearFrame <= self.myFrame then
			currentValue = 0
		else
			currentValue = self.alertCurrentValue + 0	
		end
		return currentValue
	else
		currentValue = 0
	end	
	return currentValue
end

function AnimalCommon:Collide(attackInstanceId,hitInstanceId,instanceId)
	if hitInstanceId == self.me then
		self.alertCurrentValue = self.alertMaxValue
	end
end

--默认动作轮播
function AnimalCommon:DefaultAct()
	if self.myState == self.myStateEnum.Leisure then
		if self.defaultActState == self.defaultActStateEnum.Default then
			self.defaultActState = self.defaultActStateEnum.In
		end
		--开始
		if self.defaultActState == self.defaultActStateEnum.In and not self.defaultActing then
			local aniName = self.actList[self.defaultActNum].aniName.."_in"
			local aniFrame = BehaviorFunctions.GetEntityAnimationFrame(self.me,aniName)
			--判断动作是performLayer还是defaultLayer
			if aniFrame ~= -1 then
				--是performLayer，直接播
				BehaviorFunctions.PlayAnimation(self.me,aniName,FightEnum.AnimationLayer.PerformLayer)
				BehaviorFunctions.AddDelayCallByFrame(aniFrame,self,self.Assignment,"defaultActState",self.defaultActStateEnum.Loop)
				BehaviorFunctions.AddDelayCallByFrame(aniFrame,self,self.Assignment,"defaultActing",nil)
			else
				--是defaultLayer，改名再播，直接跳到完成
				aniName = self.actList[self.defaultActNum].aniName
				BehaviorFunctions.PlayAnimation(self.me,aniName)
				BehaviorFunctions.AddDelayCallByFrame(self.actList[self.defaultActNum].lastTime*30,self,self.Assignment,"defaultActState",self.defaultActStateEnum.End)
				BehaviorFunctions.AddDelayCallByFrame(self.actList[self.defaultActNum].lastTime*30,self,self.Assignment,"defaultActing",nil)
			end
			self.defaultActing = true
		end
		--持续
		if self.defaultActState == self.defaultActStateEnum.Loop and not self.defaultActing then
			local aniName = self.actList[self.defaultActNum].aniName.."_loop"
			BehaviorFunctions.PlayAnimation(self.me,aniName,FightEnum.AnimationLayer.PerformLayer)
			local aniFrame = BehaviorFunctions.GetEntityAnimationFrame(self.me,aniName)
			if self.actList[self.defaultActNum].lastTime and self.actList[self.defaultActNum].lastTime*30 >= aniFrame then
				aniFrame = self.actList[self.defaultActNum].lastTime*30
			end
			self.defaultActing = true
			BehaviorFunctions.AddDelayCallByFrame(aniFrame,self,self.Assignment,"defaultActState",self.defaultActStateEnum.Out)
			BehaviorFunctions.AddDelayCallByFrame(aniFrame,self,self.Assignment,"defaultActing",nil)
		end
		--退出
		if self.defaultActState == self.defaultActStateEnum.Out and not self.defaultActing then
			local aniName = self.actList[self.defaultActNum].aniName.."_end"
			BehaviorFunctions.PlayAnimation(self.me,aniName,FightEnum.AnimationLayer.PerformLayer)
			local aniFrame = BehaviorFunctions.GetEntityAnimationFrame(self.me,aniName)
			self.defaultActing = true
			BehaviorFunctions.AddDelayCallByFrame(aniFrame,self,self.Assignment,"defaultActState",self.defaultActStateEnum.End)
			BehaviorFunctions.AddDelayCallByFrame(aniFrame,self,self.Assignment,"defaultActing",nil)
		end
		--结束
		if self.defaultActState == self.defaultActStateEnum.End then
			--获取下一个对话动作
			if self.defaultActNum < #self.actList  then
				self.defaultActNum = self.defaultActNum + 1
			elseif self.defaultActNum == #self.actList  then
				self.defaultActNum = 1
			end
			self.defaultActState = self.defaultActStateEnum.Default
		end
	end
end

--开始消失隐藏模型
function AnimalCommon:Vanish()
	self.myState = self.myStateEnum.Removing
	BehaviorFunctions.DoSetEntityState(self.me,FightEnum.EntityState.Idle)
	self.vanishRemoveDelay = BehaviorFunctions.AddDelayCallByFrame(self.vanishTime * 30,BehaviorFunctions,BehaviorFunctions.RemoveEntity,self.me)
	BehaviorFunctions.CreateEntity(900000109,self.me)
	BehaviorFunctions.PlayAnimation(self.me,"Run")
end

--赋值
function AnimalCommon:Assignment(variable,value)
	self[variable] = value
	if variable == "myState" then
	end
end



