Behavior2030516 = BaseClass("Behavior2030516",EntityBehaviorBase)
--电箱
function Behavior2030516.GetGenerates()
	-- local generates = {}
	-- return generates
end

function Behavior2030516:Init()
	self.me = self.instanceId	
	self.battleTarget = nil
	
	self.ecoId = nil	
	self.ecoState = nil
	
	self.myStateEnum = 
	{
		inactive = 1,--未激活状态
		activated = 2,--已激活状态
	}
	self.myState = self.myStateEnum.inactive
end

function Behavior2030516:LateInit()
	
end


function Behavior2030516:Update()
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
		BehaviorFunctions.SetEntityHackEnable(self.me,true)
	--在激活状态下
	elseif self.myState == self.myStateEnum.activated then
		BehaviorFunctions.SetEntityHackEnable(self.me,false)
	end
end

--function Behavior2030516:HackingClickUp(instanceId)
	--if instanceId == self.me then
		--if self.myState == self.myStateEnum.inactive then
			--if self.ecoId then
				--BehaviorFunctions.SetEcoEntityState(self.ecoId,1)
			--end
			--self.myState = self.myStateEnum.activated
		--end	
	--end
--end

--执行函数命令
function Behavior2030516:CallHackUp(instanceId)
	if instanceId == self.me then
		if self.myState == self.myStateEnum.inactive then
			if self.ecoId then
				BehaviorFunctions.SetEcoEntityState(self.ecoId,1)
			end
			self.myState = self.myStateEnum.activated
		end
	end
end








