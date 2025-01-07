Behavior2030520 = BaseClass("Behavior2030520",EntityBehaviorBase)
--序章用摄像头终端
function Behavior2030520.GetGenerates()
	-- local generates = {}
	-- return generates
end

function Behavior2030520:Init()
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
	self.cameraEcoId = nil
	self.cameraInsId = nil
end

function Behavior2030520:LateInit()
	
end


function Behavior2030520:Update()
	if BehaviorFunctions.GetEntityEcoId(self.me) then
		self.ecoId = BehaviorFunctions.GetEntityEcoId(self.me)
		self.ecoState = BehaviorFunctions.GetEcoEntityState(self.ecoId)
		--获得该生态的状态
		if self.ecoState == 0 then
			self.myState = self.myStateEnum.inactive
		elseif self.ecoState == 1 then
			self.myState = self.myStateEnum.activated
		end
		
		if not self.groupMember then
			if BehaviorFunctions.GetEcoEntityGroup(nil,nil,self.me) then
				self.groupMember = BehaviorFunctions.GetEcoEntityGroupMember(nil,nil,self.ecoId)
				for i,v in pairs(self.groupMember) do
					if self.ecoId ~= v  then
						self.cameraEcoId = v
					end
				end
			else 
				LogError("无配对摄像头")
			end
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

function Behavior2030520:HackingClickUp(instanceId)
	if instanceId == self.me then
		self.cameraInsId = BehaviorFunctions.GetEcoEntityByEcoId(self.cameraEcoId)
		if self.cameraInsId then
			BehaviorFunctions.DoHackInputKey(self.cameraInsId,FightEnum.KeyEvent.HackUpButton,FightEnum.KeyEvent.HackUpButton)
		else
			LogError("找不到对应摄像头的实例ID")
		end
	end
end







