Behavior2030105 = BaseClass("Behavior2030105",EntityBehaviorBase)
--射击解谜管理器
function Behavior2030105.GetGenerates()

end

function Behavior2030105:Init()
	self.me = self.instanceId
	self.puzzleEntityList = {
		{name = "puzzleGear1",ecoId = 1501,info = {instanceId = 0,state = 0}},
		{name = "puzzleGear2",ecoId = 1502,info = {instanceId = 0,state = 0}},
		{name = "puzzleGear3",ecoId = 1503,info = {instanceId = 0,state = 0}},
		{name = "puzzleStage1",ecoId = 1504,info = {instanceId = 0,state = 0}},
		{name = "puzzleStage2",ecoId = 1505,info = {instanceId = 0,state = 0}},
		{name = "puzzleStage3",ecoId = 1506,info = {instanceId = 0,state = 0}},
	}
	self.UpStateEnum ={
		Default = 0,
		Up = 1,
		Hold = 2,
		Down = 3,
	}
	self.RotateStateEnum ={
		Default = 0,
		ClockWise = 1,
		Hold = 2,
		AntiClockRevert = 3,
		AntiClockWise = 4,
	}
	self.finish = false
	self.treasureBoxEcoId = 1508
	self.treasureBoxHide = true	
	self.removeTime = 0
	self.removeState = 0
end

function Behavior2030105:Update()
	self.time = BehaviorFunctions.GetEntityFrame(self.me)/30
	self:GetPuzzleState()
	--完成puzzle显示宝箱
	if BehaviorFunctions.GetEcoEntityByEcoId(self.treasureBoxEcoId) then
		local instanceId = BehaviorFunctions.GetEcoEntityByEcoId(self.treasureBoxEcoId)
		if BehaviorFunctions.CheckEntity(instanceId) and self.treasureBoxHide == true then
			BehaviorFunctions.SetEntityValue(instanceId,"isHide",true)
		elseif BehaviorFunctions.CheckEntity(instanceId) and self.treasureBoxHide == false then
			BehaviorFunctions.SetEntityValue(instanceId,"isHide",false)
			BehaviorFunctions.SetEntityValue(self.me,"PuzzleDone",true)
			if self.removeState == 0 then
				self.removeTime = self.time
				self.removeState = 1
			end
		end
	end
	--延迟移除
	if self.removeState == 1 and self.time -self.removeTime > 3 then
		BehaviorFunctions.InteractEntityHit(self.me,FightEnum.SysEntityOpType.Death)--后端交互
		BehaviorFunctions.RemoveEntity(self.me)
		self.removeState = 999
	end
	--台阶匹配装置状态
	if self.finish == false then
		for i = 1,#self.puzzleEntityList do
			if self.puzzleEntityList[i].info.instanceId then
				if self.puzzleEntityList[i].info.instanceId > 0 and string.match(self.puzzleEntityList[i].name,"puzzleGear") then
					local j = i + 3
					if self.puzzleEntityList[i].info.state ==  self.RotateStateEnum.ClockWise then
						self.puzzleEntityList[j].info.state = self.UpStateEnum.Up
					elseif self.puzzleEntityList[i].info.state ==  self.RotateStateEnum.Hold then
						self.puzzleEntityList[j].info.state = self.UpStateEnum.Hold
					elseif self.puzzleEntityList[i].info.state ==  self.RotateStateEnum.AntiClockRevert then
						self.puzzleEntityList[j].info.state = self.UpStateEnum.Down
					elseif self.puzzleEntityList[i].info.state ==  self.RotateStateEnum.Default then
						self.puzzleEntityList[j].info.state = self.UpStateEnum.Default
					end
				elseif self.puzzleEntityList[i].info.instanceId > 0 and BehaviorFunctions.CheckEntity(self.puzzleEntityList[i].info.instanceId)
					and string.match(self.puzzleEntityList[i].name,"puzzleStage") then
					BehaviorFunctions.SetEntityValue(self.puzzleEntityList[i].info.instanceId,"PuzzleState",self.puzzleEntityList[i].info.state)
				end
			end
		end
	end	
	--完成判定
	if self.finish == false 
		and (self.puzzleEntityList[4].info.state == self.UpStateEnum.Up or self.puzzleEntityList[4].info.state == self.UpStateEnum.Hold)
		and (self.puzzleEntityList[5].info.state == self.UpStateEnum.Up or self.puzzleEntityList[5].info.state == self.UpStateEnum.Hold)
		and (self.puzzleEntityList[6].info.state == self.UpStateEnum.Up or self.puzzleEntityList[6].info.state == self.UpStateEnum.Hold) then
		self.finish = true
	elseif self.finish == true then
		--台阶回归默认，机关回归默认
		self.treasureBoxHide = false			
	end
end

function Behavior2030105:GetPuzzleState()
	for i = 1, #self.puzzleEntityList do
		if BehaviorFunctions.GetEcoEntityByEcoId(self.puzzleEntityList[i].ecoId) then
			--获取生态id对应实例id
			self.puzzleEntityList[i].info.instanceId = BehaviorFunctions.GetEcoEntityByEcoId(self.puzzleEntityList[i].ecoId)
		end
		--装置传值查询
		if string.match(self.puzzleEntityList[i].name,"puzzleGear") ~= nil then
			--是否有传值
			if self.puzzleEntityList[i].info.instanceId and self.puzzleEntityList[i].info.instanceId >0
				and BehaviorFunctions.CheckEntity(self.puzzleEntityList[i].info.instanceId)
				and BehaviorFunctions.GetEntityValue(self.puzzleEntityList[i].info.instanceId,"PuzzleState") then
				local info = BehaviorFunctions.GetEntityValue(self.puzzleEntityList[i].info.instanceId,"PuzzleState")
				
				if type(info) == "table" and info.instanceId and info.instanceId == self.puzzleEntityList[i].info.instanceId then
					self.puzzleEntityList[i].info = info
				end
			end
		end
	end

end