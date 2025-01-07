MonsterPeace = BaseClass("MonsterPeace",EntityBehaviorBase)
--非战斗状态

function MonsterPeace:Init()
	self.MonsterCommonBehavior = self.ParentBehavior
	self.MonsterCommonParam = self.MainBehavior.MonsterCommonParam
	--逻辑变量
	self.patrolNum = 1
	self.inReturen = false
	self.param = nil
	self.information = {"peaceState","logicName","patrolList","canReturn","actPerformance"}
	self.list = {}
	--self.patrolList={}
	self.patrolPositionList= {}
end

function MonsterPeace:LateInit()
	if self.sInstanceId then
		self.param = BehaviorFunctions.GetEcoEntityExtraParam(self.MonsterCommonParam.ecoMe)
		if  self.param and next(self.param) then
			for k,v in pairs(self.param) do
				for n,m in ipairs(self.information) do
					if v[m]~=nil then
						self.list[m]=self:SplitParam(v[m],"|")
					end
				end
			end
		end


		--非战斗方式
		if self.list["logicName"] then
			self.peaceState=self.MonsterCommonParam.PeaceStateEnum.Patrol
		elseif self.list["actPerformance"] then
			self.peaceState=self.MonsterCommonParam.PeaceStateEnum.Act
		end

		--巡逻列表
		if self.list["logicName"]~=nil then
			for i=1,#self.list["patrolList"] do
				local a =BehaviorFunctions.GetTerrainPositionP(self.list["patrolList"][i],10020004,self.list["logicName"][1])
				table.insert(self.patrolPositionList,i,BehaviorFunctions.GetTerrainPositionP(self.list["patrolList"][i],10020004,self.list["logicName"][1]))
			end
		end
		--往返巡逻
		if self.list["canReturn"]~=nil then
			if self.list["canReturn"][1]=="true" then
				self.canReturn=true
			elseif self.list["canReturn"][1]=="false" then
				self.canReturn=false
			end
		end
		--表演参数
		if self.list["actPerformance"]~=nil then
			self.actPerformance=self.list["actPerformance"][1]
		end
	end
end



function MonsterPeace:Update()
	--副本召唤怪物
	--非战斗方式
	if self.peaceState == nil then
		self.peaceState = BehaviorFunctions.GetEntityValue(self.MonsterCommonParam.me,"peaceState")
	end
	--巡逻列表
	if not next(self.patrolPositionList)  then
		local list = BehaviorFunctions.GetEntityValue(self.MonsterCommonParam.me,"patrolPositionList")
		if list and next(list) then
			self.patrolPositionList = BehaviorFunctions.GetEntityValue(self.MonsterCommonParam.me,"patrolPositionList")
		end

	end
	--往返巡逻
	if self.canReturn == nil then
		self.canReturn = BehaviorFunctions.GetEntityValue(self.MonsterCommonParam.me,"canReturn")
	end
	--表演获取
	if  self.actPerformance==nil then
		self.actPerformance=BehaviorFunctions.GetEntityValue(self.MonsterCommonParam.me,"actPerformance")
	end
	--end


	--非战斗行为
	if self.MonsterCommonParam.inInitial == false
		and self.MonsterCommonParam.inPeace == true
		and BehaviorFunctions.CanCtrl(self.MonsterCommonParam.me)
		and self.MonsterCommonParam.exitFightState ~= self.MonsterCommonParam.ExitFightStateEnum.Exiting then
		self.MonsterCommonParam.inFight = false

		--peace状态，需要告诉中继器，自己处于该状态。
		if self.MonsterCommonParam.ecoMe
			and BehaviorFunctions.CheckEcoEntityGroup(self.MonsterCommonParam.ecoMe)== true then
			--and BehaviorFunctions.GetEntityValue(self.MonsterCommonParam.me,"warnState") ==nil then --初始化身上带一个warnState
			BehaviorFunctions.SetEntityValue(self.MonsterCommonParam.me,"warnState",false)
		end

		if self.MonsterCommonParam.initialState == self.MonsterCommonParam.InitialStateEnum.Done or self.MonsterCommonParam.initialState == self.MonsterCommonParam.InitialStateEnum.Default then
			--默认状态，非战斗待机
			--if (not self.peaceState or self.peaceState == self.MonsterCommonParam.PeaceStateEnum.Default) and self.MonsterCommonParam.myState ~= FightEnum.EntityState.Idle then
			--	BehaviorFunctions.DoSetEntityState(self.MonsterCommonParam.me,FightEnum.EntityState.Idle)
				--演出状态，播演出技能
			if self.peaceState == self.MonsterCommonParam.PeaceStateEnum.Act and self.actPerformance and self.MonsterCommonParam.actKey==true then
				BehaviorFunctions.PlayAnimation(self.MonsterCommonParam.me,self.actPerformance)
				self.MonsterCommonParam.actKey = false
				--巡逻状态，遍历地点组列表巡逻
			elseif self.peaceState == self.MonsterCommonParam.PeaceStateEnum.Patrol then
				if self.patrolPositionList then
					self:Patrol(self.patrolPositionList,self.canReturn)
				end

			end
		end
	end

end



--巡逻逻辑
function MonsterPeace:Patrol(positionList,canReturn)
	--目标点
	local nextPosition = positionList[self.patrolNum]
	--目标点和当前点的距离
	local distance = BehaviorFunctions.GetDistanceFromPos(self.MonsterCommonParam.myPos,nextPosition)
	BehaviorFunctions.CancelLookAt(self.MonsterCommonParam.me)
	BehaviorFunctions.DoLookAtPositionImmediately(self.MonsterCommonParam.me,nextPosition.x,nil,nextPosition.z)
	--BehaviorFunctions.DoLookAtPositionByLerp(self.MonsterCommonParam.me,nextPosition.x,nil,nextPosition.z,false,0,180,-2)
	--判断距离,切换移动状态
	if BehaviorFunctions.CanCtrl(self.MonsterCommonParam.me) == true then
		--没到目标点，朝着目标点走
		if distance >= 0.1  and BehaviorFunctions.GetEntityState(self.MonsterCommonParam.me) ~= FightEnum.EntityState.Move then
			BehaviorFunctions.DoSetEntityState(self.MonsterCommonParam.me,FightEnum.EntityState.Move)
			BehaviorFunctions.DoSetMoveType(self.MonsterCommonParam.me,FightEnum.EntityMoveSubState.Walk)
		--到达目标点，按规则切换下个目标点
		elseif distance < 0.1 then
			--不会折返
			if canReturn == false then
				if self.patrolNum < #positionList  then
					self.patrolNum = self.patrolNum + 1
				elseif self.patrolNum == #positionList  then
					self.patrolNum = 1
				end
			--会折返
			elseif canReturn == true then
				--没开始折返，正常巡逻
				if self.inReturen == false then
					if self.patrolNum < #positionList  then
						self.patrolNum = self.patrolNum + 1
					elseif self.patrolNum == #positionList  then
						self.inReturen = true
					end
				--开始折返，反向巡逻
				elseif self.inReturen == true then
					if self.patrolNum > 1  then
						self.patrolNum = self.patrolNum - 1
					elseif self.patrolNum == 1 then
						self.inReturen = false
					end
				end		
			end
		end
	end
end



function MonsterPeace:SplitParam(string,sep)
	local list={}
	if string == nil then
		return nil
	end
	string.gsub(string,'[^'..sep..']+',function (w)
			table.insert(list,w)
		end)
	return list
end