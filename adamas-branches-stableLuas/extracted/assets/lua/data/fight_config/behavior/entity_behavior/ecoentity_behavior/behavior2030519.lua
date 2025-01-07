Behavior2030519 = BaseClass("Behavior2030519",EntityBehaviorBase)
--序章用门
function Behavior2030519.GetGenerates()
	-- local generates = {}
	-- return generates
end

function Behavior2030519:Init()
	self.me = self.instanceId	
	self.role = nil
	
	self.ecoId = nil	
	self.ecoState = nil
	
	self.myStateEnum = 
	{
		inactive = 1,--未激活状态
		activated = 2,--已激活状态
	}
	self.myState = self.myStateEnum.inactive
	
	self.canInteract = false
	
	self.extraParam = nil
	
	self.isOpen = false
	
	self.tpPos = nil
end

function Behavior2030519:LateInit()
	if BehaviorFunctions.GetEntityEcoId(self.me) then
		self.ecoId = BehaviorFunctions.GetEntityEcoId(self.me)
		self.ecoState = BehaviorFunctions.GetEcoEntityState(self.ecoId)
		--获得该生态的状态
		if self.ecoState == 0 then
			self.myState = self.myStateEnum.inactive
			BehaviorFunctions.PlayAnimation(self.me,"DoorCloseIdle")
			self.isOpen = false
		elseif self.ecoState == 1 then
			self.myState = self.myStateEnum.activated
			BehaviorFunctions.PlayAnimation(self.me,"DoorOpenIdle")
			self.isOpen = true
		end
	end
end

function Behavior2030519:Update()
	self.role = BehaviorFunctions.GetCtrlEntity()
	if BehaviorFunctions.GetEntityEcoId(self.me) then
		self.ecoId = BehaviorFunctions.GetEntityEcoId(self.me)
		self.ecoState = BehaviorFunctions.GetEcoEntityState(self.ecoId)		
		--获得该生态的状态
		if self.ecoState == 0 then
			self.myState = self.myStateEnum.inactive
		elseif self.ecoState == 1 then
			self.myState = self.myStateEnum.activated
		end
	end
	
	--在未激活状态下
	if self.myState == self.myStateEnum.inactive then
		if self.isOpen == true then
			BehaviorFunctions.PlayAnimation(self.me,"DoorClose")
			self.isOpen = false
		end
		self.canInteract = false
	--在激活状态下
	elseif self.myState == self.myStateEnum.activated then
		if self.isOpen == false then
			BehaviorFunctions.PlayAnimation(self.me,"DoorOpen")
			self.isOpen = true
		end
		self.canInteract = true
	end
end










