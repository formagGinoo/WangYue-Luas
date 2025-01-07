Behavior2030518 = BaseClass("Behavior2030518",EntityBehaviorBase)
--序章用门终端
function Behavior2030518.GetGenerates()
	-- local generates = {}
	-- return generates
end

function Behavior2030518:Init()
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
	self.groupMember = nil	
	self.gateEcoId = nil
	
	self.buttonState = false
	
	self.warning = false
end

function Behavior2030518:LateInit()
	
end


function Behavior2030518:Update()
	if BehaviorFunctions.GetEntityEcoId(self.me) then
		self.ecoId = BehaviorFunctions.GetEntityEcoId(self.me)
		self.ecoState = BehaviorFunctions.GetEcoEntityState(self.ecoId)
		--获得该生态的状态
		if self.ecoState == 0 then
			self.myState = self.myStateEnum.inactive
			if self.buttonState == true then
				BehaviorFunctions.SetEntityHackActiveState(self.me,false)
				self.buttonState = false
			end
		elseif self.ecoState == 1 then
			self.myState = self.myStateEnum.activated
			if self.buttonState == false then
				BehaviorFunctions.SetEntityHackActiveState(self.me,true)
				self.buttonState = true
			end
		end
		if not self.groupMember and not self.warning then
			if BehaviorFunctions.GetEcoEntityGroup(nil,nil,self.me) then
				self.groupMember = BehaviorFunctions.GetEcoEntityGroupMember(nil,nil,self.ecoId)
				if self.groupMember then
					for i,v in pairs(self.groupMember) do
						if self.ecoId ~= v  then
							self.gateEcoId = v
						end
					end
					if not self.gateEcoId then
						LogError("生态ID："..self.ecoId..",未能找到该终端同组下的其他装置，请检查生态表中的生态组配置")
					end
				else
					LogError("生态ID："..self.ecoId..",未能找到该终端同组下的其他装置，请检查生态表中的生态组配置")
					self.warning = true
				end
			end
		end
	end		
	
	--在未激活状态下
	if self.myState == self.myStateEnum.inactive then
		--BehaviorFunctions.SetEntityHackEnable(self.me,true)
		if self.gateEcoId then
			if BehaviorFunctions.CheckEntityEcoState(nil,self.gateEcoId) ~= false then
				if BehaviorFunctions.GetEcoEntityState(self.gateEcoId) == 1 then
					BehaviorFunctions.SetEcoEntityState(self.gateEcoId,0)
				end
			end
		end
	--在激活状态下
	elseif self.myState == self.myStateEnum.activated then
		--BehaviorFunctions.SetEntityHackEnable(self.me,false)
		if self.gateEcoId then
			if BehaviorFunctions.CheckEntityEcoState(nil,self.gateEcoId) ~= false then
				if BehaviorFunctions.GetEcoEntityState(self.gateEcoId) == 0 then
					BehaviorFunctions.SetEcoEntityState(self.gateEcoId,1)
				end
			end
		end
	end
end

--function Behavior2030518:HackingClickUp(instanceId)
	--if instanceId == self.me then
		--if self.myState == self.myStateEnum.inactive then
			--if self.ecoId then
				--BehaviorFunctions.SetEcoEntityState(self.ecoId,1)
			--end
			--self.myState = self.myStateEnum.activated
		--end	
	--end
--end

function Behavior2030518:CallHackUp(instanceId)
	if instanceId == self.me then
		if self.myState == self.myStateEnum.inactive then
			if self.ecoId then
				BehaviorFunctions.SetEcoEntityState(self.ecoId,1)
			end
			self.myState = self.myStateEnum.activated
			
		elseif self.myState == self.myStateEnum.activated then
			if self.ecoId then
				BehaviorFunctions.SetEcoEntityState(self.ecoId,0)
			end
		end
	end
end







