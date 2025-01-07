Behavior2030101 = BaseClass("Behavior2030101",EntityBehaviorBase)
--射击解谜机关
function Behavior2030101.GetGenerates()

end

function Behavior2030101:Init()
	self.me = self.instanceId
	self.magicState = 0
	self.rotateState = 0
	self.RotateStateEnum ={
		Default = 0,
		ClockWise = 1,
		Hold = 2,
		AntiClockRevert = 3,
		AntiClockWise = 4,
	}
	self.rotateStartTime = 0
	self.ClockWiseTime = 4
	self.AntiClockRevertTime = 1.33
	self.AntiClockWiseTime = 2.5
	self.HoldTime = 15
	self.startWise = false
	self.puzzleDone = false
	--管理员id
	self.controllerEcoId = 1507
	self.deathState = 0 
	self.deathTime = 0
	--欧拉草你吗
	self.oState = 0
end


function Behavior2030101:Update()
	self.EcoId = BehaviorFunctions.GetEntityEcoId(self.me)
	self.time = BehaviorFunctions.GetFightFrame()/30
	self.role = BehaviorFunctions.GetCtrlEntity()
	local controllerInstanceId = BehaviorFunctions.GetEcoEntityByEcoId(self.controllerEcoId)
	BehaviorFunctions.SetEntityValue(self.me,"PuzzleState",{instanceId = self.me,state = self.rotateState})
	if self.magicState == 0 then
		BehaviorFunctions.DoMagic(1,self.me,900000020)
		BehaviorFunctions.DoMagic(1,self.me,900000001)
		BehaviorFunctions.DoMagic(1,self.me,900000022)
		--BehaviorFunctions.DoMagic(1,self.me,900000023)
		self.magicState = 1
	end
	if self.EcoId and self.EcoId == 1503 and self.oState == 0 then
		BehaviorFunctions.SetEntityEuler(self.me,0,30,90)
	end
	
	if controllerInstanceId and BehaviorFunctions.CheckEntity(controllerInstanceId) then
		if BehaviorFunctions.GetEntityValue(controllerInstanceId,"PuzzleDone") and self.deathState == 0 then
			self.puzzleDone = true
			self.deathState = 1
			self.deathTime = self.time
		end
	end
	if self.deathState == 1 and self.time - self.deathTime > 1 then
		BehaviorFunctions.CreateEntity(200000105,self.me) --溶解
		self.deathTime = self.time
		self.deathState =2 
	elseif self.deathState == 2 and self.time - self.deathTime > 2 then
		BehaviorFunctions.InteractEntityHit(self.me,FightEnum.SysEntityOpType.Death)--后端交互
		BehaviorFunctions.RemoveEntity(self.me)
		self.deathState = 999
	end

	if self.puzzleDone == false then
		--顺时针转
		if self.rotateState == self.RotateStateEnum.ClockWise and self.startWise == true then
			self.rotateStartTime = self.time
			BehaviorFunctions.PlayAnimation(self.me,"ClockWise")
			self.startWise = false
		--停留
		elseif self.rotateState == self.RotateStateEnum.ClockWise and self.time - self.rotateStartTime >= self.ClockWiseTime then
			self.rotateState = self.RotateStateEnum.Hold
		--逆时针恢复
		elseif self.rotateState == self.RotateStateEnum.Hold and self.time - self.rotateStartTime >= self.HoldTime + self.ClockWiseTime then
			self.rotateState = self.RotateStateEnum.AntiClockRevert
			BehaviorFunctions.PlayAnimation(self.me,"AntiClockRevert")
		--逆时针转
		elseif self.rotateState == self.RotateStateEnum.AntiClockWise and self.startWise == true then
			self.rotateStartTime = self.time
			BehaviorFunctions.PlayAnimation(self.me,"AntiClockWise")
			self.startWise = false
		end
		--状态归零
		if self.rotateState == self.RotateStateEnum.AntiClockRevert
			and self.time - self.rotateStartTime >= self.ClockWiseTime + self.HoldTime + self.AntiClockRevertTime then
			self.rotateState = self.RotateStateEnum.Default
		elseif self.rotateState == self.RotateStateEnum.AntiClockWise
			and self.time - self.rotateStartTime >= self.AntiClockWiseTime then
			self.rotateState = self.RotateStateEnum.Default
		end
	end
end

function Behavior2030101:PartHit(instanceId,partName,life,damage)
	if instanceId == self.me then
		--if self.rotateState == self.RotateStateEnum.Default then
			--if partName == "ClockWise1" or partName == "ClockWise2" or partName == "ClockWise3" then
				--self.rotateState = self.RotateStateEnum.ClockWise
				--self.startWise = true		
			--elseif partName == "AntiClockWise1" or partName == "AntiClockWise2" or partName == "AntiClockWise3" then
				--self.rotateState = self.RotateStateEnum.AntiClockWise
				--self.startWise = true
			--end
		--end
		if self.rotateState == self.RotateStateEnum.Default then
				self.rotateState = self.RotateStateEnum.ClockWise
				self.startWise = true
		end
	end
end