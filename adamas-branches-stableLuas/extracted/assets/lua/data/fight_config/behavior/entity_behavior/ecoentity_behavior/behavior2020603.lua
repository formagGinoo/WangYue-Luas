Behavior2020603 = BaseClass("Behavior2020603",EntityBehaviorBase)
--大悬钟电梯
function Behavior2020603.GetGenerates()

end

function Behavior2020603:Init()
	self.me = self.instanceId
	self.ecoMe = self.sInstanceId
	self.stateEnum = {
		Up = 0,  --听上方   
		Down = 1,    --停下方  
		Uping = 2,		  --上升     
		Downing = 3,	  --下降     
		Special = 4   --特殊状态逻辑
		}
	self.entityValue = 0  --大悬钟关卡特殊逻辑用
	
	--电梯开关
	self.canButton = false
	
	self.state = self.stateEnum.Up
	self.onele = false  --是否在电梯上
	self.active = false  --满足启动条件（在电梯上2s）
	self.totalFrame = 0
	self.ontime = 0  --站在电梯上的时间
	self.onfloor = false  --是否在楼上
	self.moveY = false
	self.activeTiime = 2   --站2s激活电梯
	self.flag = 0
	self.localEco = 0
	self.eleEffect = nil
	self.fxSign = 0
	self.firstActived = false
	
	
	self.flagKey = 0
	self.airWallFlag = 0
	
	self.playerAtBottom = false --临时
end

function Behavior2020603:LateInit()
	--获取电梯状态
	self.ecoState = BehaviorFunctions.GetEcoEntityState(self.ecoMe)
	--获取电梯初始坐标（Up）
	--local pos = BehaviorFunctions.GetPositionP(self.me)
	--self.rootPos = pos
end

function Behavior2020603:Update()
	self.role = BehaviorFunctions.GetCtrlEntity()
	self.pos = BehaviorFunctions.GetPositionP(self.me)
	self:OnElevator()
	
	--临时大悬钟关联逻辑
	self.bigBellTower = BehaviorFunctions.GetEcoEntityByEcoId(1003001020001)
	self.towerState = BehaviorFunctions.CheckEntityEcoState(self.bigBellTower)
	--临时大悬钟关联逻辑
	
	--电梯在上面（Default，0）
	if self.state == self.stateEnum.Up then
		if BehaviorFunctions.GetDistanceFromTargetWithY(self.role, self.me) < 10 then
			if self.flagKey == 1 then
				BehaviorFunctions.SetFightPanelVisible("-1")
				self.flagKey = 0
			end
		end
		--记录目标点位参数
		if self.flag == 0 then
			local x,y,z = BehaviorFunctions.GetPosition(self.me)
			self.rootPos = Vec3.New(x,y,z)
			self.downPos = self.rootPos.y - 48
			self.upPos = self.rootPos.y
			
			self.flag = 1
		end
		
	
		if self.localEco == 1 then  --在下面
			BehaviorFunctions.DoSetPositionOffset(self.me,0,-48,0)
			self.state = self.stateEnum.Down
			
		elseif self.localEco == 0 then --在上面
			
			
			--电梯激活后，进入下降状态
			if self.active == true then
				self.state = self.stateEnum.Downing
				self.active = false
				--self.fxSign = 0
			end
			
			--保底：如果玩家在下层，电梯也进入下降状态
			if self.pos then
				
				local rolepos = BehaviorFunctions.GetPositionP(self.role)
				local num1 = rolepos.y
				local num2 = self.downPos
				local num3 = self.rootPos.y

				local dis1 = BehaviorFunctions.GetDistanceFromPos(rolepos,self.pos)
				local dis2 =  math.abs(num1-num2)
				local dis3 = math.abs(num1-num3)
				if dis1 < 30 and dis2 < 3 then
					self.state = self.stateEnum.Downing
					--self.playerAtBottom = true  --临时
				end
				
				--if dis1 < 30 and dis3 <3 then
					--self.playerAtBottom = false  --临时
				--end
			end
		end
		
	end
	
	--电梯在下面
	if self.state == self.stateEnum.Down then
		if BehaviorFunctions.GetDistanceFromTargetWithY(self.role, self.me) < 10 then
			if self.flagKey == 1 then
				BehaviorFunctions.SetFightPanelVisible("-1")
				self.flagKey = 0
			end
		end
		--电梯激活后，进入上升状态
		if self.active == true then
			self.state = self.stateEnum.Uping
			self.active = false
			--self.fxSign = 0
		end
		
	end

	
	--电梯在上升
	if self.state == self.stateEnum.Uping then
		if BehaviorFunctions.GetDistanceFromTargetWithY(self.role, self.me) < 5 then
			BehaviorFunctions.CancelJoystick()
			if self.flagKey == 0 then
				BehaviorFunctions.SetFightPanelVisible("0")--临时
				self.flagKey = 1
			end
		end
		BehaviorFunctions.DoMoveY(self.me,0.3)
		if self.airWallFlag == 0 then
			BehaviorFunctions.SetEntityBineVisible(self.bigBellTower,"TowerElevatorAirWall1",true)
			BehaviorFunctions.SetEntityBineVisible(self.bigBellTower,"TowerElevatorAirWall2",true)
			self.airWallFlag = 1
		end
		
		--播特效(跑1次)
		if self.pos and self.fxSign == 1 then
			BehaviorFunctions.PlayAnimation(self.eleEffect,"FxElevatorLoopAni")
			BehaviorFunctions.DoEntityAudioPlay(self.role,"Elevator_loop",false)
			self.fxSign = 2
		end
		
		--到达位置
		if self.pos.y >= self.upPos then
			--播结束特效，移除特效
			if self.fxSign == 2 then
				BehaviorFunctions.PlayAnimation(self.eleEffect,"FxElevatorEndAni")
				BehaviorFunctions.AddDelayCallByFrame(25,BehaviorFunctions,BehaviorFunctions.RemoveEntity,self.eleEffect)
				self.fxSign = 0
			end
			
			--设置生态状态
			self.localEco = 0
			BehaviorFunctions.SetEcoEntityState(self.ecoMe, 0)
			
			--取消移动
			BehaviorFunctions.StopMove(self.me)
			BehaviorFunctions.DoSetPositionP(self.me,self.rootPos)
			BehaviorFunctions.DoEntityAudioStop(self.role,"Elevator_loop",0,0)
			BehaviorFunctions.DoEntityAudioPlay(self.role,"Elevator_end",false)
			BehaviorFunctions.SetEntityBineVisible(self.bigBellTower,"TowerElevatorAirWall1",false)
			BehaviorFunctions.SetEntityBineVisible(self.bigBellTower,"TowerElevatorAirWall2",false)
			self.airWallFlag = 0
			--BehaviorFunctions.DoMoveY(self.me,0)
			self.totalFrame = 0
			
			self.state = self.stateEnum.Up
			
		end
	
	end
	
	--临时
	if self.pos then
		local rolepos = BehaviorFunctions.GetPositionP(self.role)
		local num1 = rolepos.y
		local num2 = self.downPos
		local num3 = self.rootPos.y

		local dis1 = BehaviorFunctions.GetDistanceFromPos(rolepos,self.pos)
		local dis2 =  math.abs(num1-num2)
		local dis3 = math.abs(num1-num3)
		if dis1 < 30 and dis2 < 3 then
			self.playerAtBottom = true
		end

		if dis1 < 30 and dis3 < 3 then
			self.playerAtBottom = false
		end
	end
	--临时
	
	--在上面未交互 可下
	--在上面已交互 不可下
	--在下面未交互 可下
	--在下面已交互 可下
	--电梯在下降
	if self.state == self.stateEnum.Downing then        --and self.playerAtBottom == true or (self.playerAtBottom == false and self.towerState == false))  临时大悬钟关联逻辑
		if BehaviorFunctions.GetDistanceFromTargetWithY(self.role, self.me) < 5 then
			BehaviorFunctions.CancelJoystick()
			if self.flagKey == 0 then
				BehaviorFunctions.SetFightPanelVisible("0")--临时
				self.flagKey = 1
			end
		end
		
		BehaviorFunctions.DoMoveY(self.me,-0.3)
		if self.airWallFlag == 0 then
			BehaviorFunctions.SetEntityBineVisible(self.bigBellTower,"TowerElevatorAirWall1",true)
			BehaviorFunctions.SetEntityBineVisible(self.bigBellTower,"TowerElevatorAirWall2",true)
			self.airWallFlag = 1
		end
		
		--播特效(跑1次)
		if self.pos and self.fxSign == 1 then
			BehaviorFunctions.PlayAnimation(self.eleEffect,"FxElevatorLoopAni")
			BehaviorFunctions.DoEntityAudioPlay(self.role,"Elevator_loop",false)
			self.fxSign = 2
		end
		
		--到达位置
		if self.pos.y <= self.downPos then
			--播结束特效，移除特效
			if self.fxSign == 2 then
				BehaviorFunctions.PlayAnimation(self.eleEffect,"FxElevatorEndAni")
				BehaviorFunctions.AddDelayCallByFrame(25,BehaviorFunctions,BehaviorFunctions.RemoveEntity,self.eleEffect)
				self.fxSign = 0
			end
			--设置生态状态
			self.localEco = 1
			BehaviorFunctions.SetEcoEntityState(self.ecoMe, 1)
			--取消移动
			BehaviorFunctions.StopMove(self.me)
			BehaviorFunctions.DoEntityAudioStop(self.role,"Elevator_loop",0,0)
			BehaviorFunctions.DoEntityAudioPlay(self.role,"Elevator_end",false)
			BehaviorFunctions.SetEntityBineVisible(self.bigBellTower,"TowerElevatorAirWall1",false)
			BehaviorFunctions.SetEntityBineVisible(self.bigBellTower,"TowerElevatorAirWall2",false)
			self.totalFrame = 0
			self.airWallFlag = 0
			
			self.state = self.stateEnum.Down
			
		end
	end
	
	
	--大悬钟关卡特殊逻辑
	self.entityValue = BehaviorFunctions.GetEntityValue(self.me,"specialState")
	if self.entityValue == 1 then
		self.state = self.stateEnum.Down
		self.localEco = 1
		BehaviorFunctions.SetEntityValue(self.me,"specialState",0)
	end
	--
	
	----特殊关卡改状态
	--if self.state == self.stateEnum.Special then
		--BehaviorFunctions.DoMoveY(self.me,-24)
		--if self.pos.y <= self.downPos then
			--BehaviorFunctions.StopMove(self.me)
			--self.state = self.stateEnum.Down
			--BehaviorFunctions.SetEntityValue(self.me,"specialState",0)
		--end
	--end
end

--function Behavior2020603:MoveY()
	----移动开关：开
	--if self.moveY == true then
		----执行上升
		--if self.state == self.stateEnum.Uping then
			
		----执行下降
		--elseif self.state == self.stateEnum.Downing then
			
		--end
		
		----self.totalFrame = self.totalFrame + 1
		----if self.totalFrame >= 120 then	
			------取消移动
			----BehaviorFunctions.StopMove(self.me)
			----self.totalFrame = 0
			----self.moveY == false
		----end
	--end
	
--end

function Behavior2020603:OnElevator()
	--local elePos = {x=0,y=0,z=0}
	--elePos.x,elePos.y,elePos.z = BehaviorFunctions.GetEntityTransformPos(self.me,"elePos")
	--local rolepos = BehaviorFunctions.GetPositionP(self.role)
	
	--local distance = BehaviorFunctions.GetDistanceFromTargetWithY(self.role,self.me)
	
	--if distance < 2 then
		----计算站在电梯上满足激活时间
		--self.onele = true
		--self.ontime =self.ontime + 1
		----播特效(跑1次)
		--if (self.state ==self.stateEnum.Up or self.state ==self.stateEnum.Down) and self.pos and self.fxSign == 0 then
			--self.eleEffect = BehaviorFunctions.CreateEntity(202060301,self.me,self.pos.x,self.pos.y,self.pos.z)
			--BehaviorFunctions.PlayAnimation(self.eleEffect,"FxElevatorStartAni")
			--BehaviorFunctions.DoEntityAudioPlay(self.role,"Elevator_start",false)
			--self.fxSign = 1
		--end
		
		----按下电梯2s 激活电梯
		--if self.canButton == true then
			--if self.ontime > self.activeTiime*30 then
				--if BehaviorFunctions.GetEntityState(self.role) == FightEnum.EntityState.Idle or BehaviorFunctions.GetEntityState(self.role) == FightEnum.EntityState.Move then
					--self.active = true
					--self.canButton = false
				--end
			--end
		--end
		
		
	--elseif distance >= 2 then
		--self.onele = false
		--self.ontime = 0
		--self.canButton = true
		
		
		----2S未满时离开范围就移除特效
		--if( self.state == self.stateEnum.Up or self.state == self.stateEnum.Down ) and self.fxSign == 1 then
			----BehaviorFunctions.RemoveEntity(self.eleEffect)
			----倒放特效
			----BehaviorFunctions.SetAnimatorTimeScale(self.eleEdffect,-2)
			----BehaviorFunctions.DoEntityAudioStop(self.role,"Elevator_start",0,1)
			----self.fxSign = 999
			------移除特效
			----BehaviorFunctions.AddDelayCallByFrame(100,BehaviorFunctions,BehaviorFunctions.RemoveEntity,self.eleEffect)
			----BehaviorFunctions.AddDelayCallByFrame(101,self,self.Assignment,"fxSign",0)
			------self.fxSign = 0		
			--BehaviorFunctions.RemoveEntity(self.eleEffect)
			--BehaviorFunctions.DoEntityAudioStop(self.role,"Elevator_start",0,1)
			--self.fxSign = 0
		--end
	--end
end

function Behavior2020603:Assignment(variable,value)
	self[variable] = value
end

function Behavior2020603:WorldInteractClick(uniqueId,instanceId)
	if instanceId == self.me then
		self.eleEffect = BehaviorFunctions.CreateEntity(202060301,self.me,self.pos.x,self.pos.y,self.pos.z)
		BehaviorFunctions.PlayAnimation(self.eleEffect,"FxElevatorStartAni")
		BehaviorFunctions.DoEntityAudioPlay(self.role,"Elevator_start",false)
		self.fxSign = 1
		self.active = true
		BehaviorFunctions.WorldInteractRemove(instanceId,uniqueId)
	end
end

