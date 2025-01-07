FSMBehavior9000020102 = BaseClass("FSMBehavior9000020102",FSMBehaviorBase)
--和平巡逻状态


function FSMBehavior9000020102.GetGenerates()
	local generates = {}
	return generates
end

function FSMBehavior9000020102:Init()
	self.patrolNum = 1
	self.inReturen = false
	self.patrolPositionList= {}
end

function FSMBehavior9000020102:LateInit()
	--巡逻列表
	if self.ParentBehavior.list["logicName"]~=nil then
		for i=1,#self.ParentBehavior.list["patrolList"] do
			local a =BehaviorFunctions.GetTerrainPositionP(self.ParentBehavior.list["patrolList"][i],10020004,self.ParentBehavior.list["logicName"][1])
			table.insert(self.patrolPositionList,i,BehaviorFunctions.GetTerrainPositionP(self.ParentBehavior.list["patrolList"][i],10020004,self.ParentBehavior.list["logicName"][1]))
		end
		--往返巡逻
		if self.ParentBehavior.list["canReturn"]~=nil then
			if self.ParentBehavior.list["canReturn"][1]=="true" then
				self.canReturn=true
			elseif self.ParentBehavior.list["canReturn"][1]=="false" then
				self.canReturn=false
			end
		end
	end
end

function FSMBehavior9000020102:Update()
	--副本召唤怪物
	--巡逻列表
	if not next(self.patrolPositionList)  then
		local list = BehaviorFunctions.GetEntityValue(self.MainBehavior.me,"patrolPositionList")
		if list and next(list) then
			self.patrolPositionList = BehaviorFunctions.GetEntityValue(self.MainBehavior.me,"patrolPositionList")
		end
	end
	--往返巡逻
	if self.canReturn == nil then
		self.canReturn = BehaviorFunctions.GetEntityValue(self.MainBehavior.me,"canReturn")
	end
	
	--peace状态，需要告诉中继器，自己处于该状态。
	if self.MainBehavior.ecoMe
		and BehaviorFunctions.CheckEcoEntityGroup(self.MainBehavior.ecoMe)== true then
		BehaviorFunctions.SetEntityValue(self.MainBehavior.me,"warnState",false)
	end
	
	--巡逻状态，遍历地点组列表巡逻
	if self.patrolPositionList then
		self:Patrol(self.patrolPositionList,self.canReturn)
	end
	
end

--巡逻逻辑
function FSMBehavior9000020102:Patrol(positionList,canReturn)
	--目标点
	local nextPosition = positionList[self.patrolNum]
	--目标点和当前点的距离
	local distance = BehaviorFunctions.GetDistanceFromPos(self.MainBehavior.myPos,nextPosition)
	BehaviorFunctions.CancelLookAt(self.MainBehavior.me)
	BehaviorFunctions.DoLookAtPositionImmediately(self.MainBehavior.me,nextPosition.x,nil,nextPosition.z)
	--判断距离,切换移动状态
	if BehaviorFunctions.CanCtrl(self.MainBehavior.me) == true then
		--没到目标点，朝着目标点走
		if distance >= 0.1  and BehaviorFunctions.GetEntityState(self.MainBehavior.me) ~= FightEnum.EntityState.Move then
			BehaviorFunctions.DoSetEntityState(self.MainBehavior.me,FightEnum.EntityState.Move)
			BehaviorFunctions.DoSetMoveType(self.MainBehavior.me,FightEnum.EntityMoveSubState.Walk)
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



function FSMBehavior9000020102:SplitParam(string,sep)
	local list={}
	if string == nil then
		return nil
	end
	string.gsub(string,'[^'..sep..']+',function (w)
			table.insert(list,w)
		end)
	return list
end