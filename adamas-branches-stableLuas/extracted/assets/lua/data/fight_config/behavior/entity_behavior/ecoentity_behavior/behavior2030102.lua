Behavior2030102 = BaseClass("Behavior2030102",EntityBehaviorBase)
--射击解谜台阶
function Behavior2030102.GetGenerates()
	
end

function Behavior2030102:Init()
	self.me = self.instanceId
	self.upState = 0
	self.UpStateEnum ={
		Default = 0,
		Up = 1,
		Hold = 2,
		Down = 3,
	}
	self.upStartTime = 0
	self.UpTime = 4
	self.DownTime = 1.33
	self.HoldTime = 15
	self.canUp = true
	self.puzzleDone = false
	self.myState = 0 
	self.controllerEcoId = 1507
	self.standSign = false
end


function Behavior2030102:Update()
	self.myframe = BehaviorFunctions.GetEntityFrame(self.me)
	self.time = BehaviorFunctions.GetFightFrame()/30
	self.role = BehaviorFunctions.GetCtrlEntity()
	local controllerInstanceId = BehaviorFunctions.GetEcoEntityByEcoId(self.controllerEcoId)
	if self.myState == 0 and self.myframe >1 then
		if controllerInstanceId and  BehaviorFunctions.CheckEntity(controllerInstanceId)then
			BehaviorFunctions.PlayAnimation(self.me,"Ground")
			self.standSign = false
			self.myState = 1
		elseif not controllerInstanceId or (controllerInstanceId and not BehaviorFunctions.CheckEntity()) then
			if self.standSign == false then
				BehaviorFunctions.PlayAnimation(self.me,"Stand1")
				self.standSign = true
				self.puzzleDone = true
			end
			
		end
	end
	if self.puzzleDone == false then
		--升降控制
		if self.upState == self.UpStateEnum.Up and self.canUp == true then
			self.upStartTime = self.time
			BehaviorFunctions.PlayAnimation(self.me,"Up")
			self.canUp = false
			--停留
		elseif self.upState == self.UpStateEnum.Up and self.time - self.upStartTime >= self.UpTime then
			self.upState = self.UpStateEnum.Hold
			--逆时针恢复
		elseif self.upState == self.UpStateEnum.Hold and self.time - self.upStartTime >= self.HoldTime + self.UpTime then
			self.upState = self.UpStateEnum.Down
			BehaviorFunctions.PlayAnimation(self.me,"Down")
		end
		--状态归零
		if self.upState == self.UpStateEnum.Down
			and self.time - self.upStartTime >= self.UpTime + self.HoldTime + self.DownTime then
			self.upState = self.UpStateEnum.Default
			self.canUp = true
		end
		if BehaviorFunctions.GetEntityValue(self.me,"PuzzleState") then
			self.upState = BehaviorFunctions.GetEntityValue(self.me,"PuzzleState")
		end
	end

end

