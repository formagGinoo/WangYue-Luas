Behavior2040806 = BaseClass("Behavior2040806",EntityBehaviorBase) 
--红绿灯
function Behavior2040806.GetGenerates()
	local generates = {}
	return generates
end

function Behavior2040806:Init()
	self.me = self.instanceId
	self.myState = 0
	self.MyStateEnum = {
		Red = 1,
		Yellow = 2,
		Green = 3,	
		}
	self.initState = 0
	self.bodyEffectId = 204080601
	self.redEffectId = 204080602
	self.yellowEffectId = 204080603
	self.greenEffectId = 204080604
	self.myLightId = 0
	self.UpDownFrame = 30
	self.moveFrame = 0
	self.moveSpeed = 0.08
	self.isUp = false
	self.isDown = false
	self.hasUp = false
end

function Behavior2040806:LateInit()

	if self.sInstanceId then
		self.myEcoId = self.sInstanceId
		self.extraParam = BehaviorFunctions.GetEcoEntityExtraParam(self.myEcoId)
		if self.extraParam and next(self.extraParam) and 
			self.extraParam[1].TrafficLightId then
			self.myLightId = tonumber(self.extraParam[1].TrafficLightId)
		end
		self.myState = BehaviorFunctions.GetTrafficLightType(self.myLightId)
	else
		Log("这是一个假红绿灯")
	end
end

function Behavior2040806:Update()
	self.myFrame = BehaviorFunctions.GetEntityFrame(self.me)
	--常驻发光特效
	if self.initState == 0 then
		self.BodyEffectEntity = BehaviorFunctions.CreateEntityByEntity(self.me,self.bodyEffectId)
		BehaviorFunctions.ResetBindTransform(self.BodyEffectEntity,self.me,"Root")
		self.initState = 1
	end
	self:LightSwitch()
	self:UpDownSwitch()
end

--红绿灯变化表现
function Behavior2040806:LightSwitch()
	--红灯
	if self.myState == self.MyStateEnum.Red and not self.RedLightEntity then
		if self.GreenLightEntity then
			BehaviorFunctions.RemoveEntity(self.GreenLightEntity)
			self.GreenLightEntity = nil
		end
		self.RedLightEntity = BehaviorFunctions.CreateEntityByEntity(self.me,self.redEffectId)
		BehaviorFunctions.ResetBindTransform(self.RedLightEntity,self.me,"Root")
	--黄灯
	elseif self.myState == self.MyStateEnum.Yellow and not self.YellowLightEntity then
		if self.RedLightEntity then
			BehaviorFunctions.RemoveEntity(self.RedLightEntity)
			self.RedLightEntity = nil
		end
		self.YellowLightEntity = BehaviorFunctions.CreateEntityByEntity(self.me,self.yellowEffectId)
		BehaviorFunctions.ResetBindTransform(self.YellowLightEntity,self.me,"Root")		
	--绿灯
	elseif self.myState == self.MyStateEnum.Green and not self.GreenLightEntity then
		if self.YellowLightEntity then
			BehaviorFunctions.RemoveEntity(self.YellowLightEntity)
			self.YellowLightEntity = nil
		end
		self.GreenLightEntity = BehaviorFunctions.CreateEntityByEntity(self.me,self.greenEffectId)
		BehaviorFunctions.ResetBindTransform(self.GreenLightEntity,self.me,"Root")
	end
end

--红绿灯升降
function Behavior2040806:UpDownSwitch()
	--绿灯上升
	if self.myState == self.MyStateEnum.Green and not self.isUp then
		if self.moveFrame < self.UpDownFrame then
			self.moveFrame = self.moveFrame + 1
			BehaviorFunctions.DoMoveY(self.me,self.moveSpeed)
		else
			self.isUp = true
			self.hasUp = true
			self.moveFrame = 0
		end
	--红灯下降
	elseif self.myState == self.MyStateEnum.Red and not self.isDown and self.hasUp then
		if self.moveFrame < self.UpDownFrame then
			self.moveFrame = self.moveFrame + 1
			BehaviorFunctions.DoMoveY(self.me,-self.moveSpeed)
		else
			self.isDown = true
			self.moveFrame = 0
		end
	end
end


--红绿灯变化回调
function Behavior2040806:TrafficLightChange(id, state)
	if id == self.myLightId  then
		self.myState = state
		if state ~= self.MyStateEnum.Red and self.isDown == true then
			self.isDown = false
		elseif state ~= self.MyStateEnum.Green and self.isUp == true then
			self.isUp = false
		end
	end
end