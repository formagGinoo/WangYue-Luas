LevelBehavior104540201 = BaseClass("LevelBehavior104540201",LevelBehaviorBase)

function LevelBehavior104540201:__init(fight)
	self.fight = fight
end

function LevelBehavior104540201.GetGenerates()
	local generates = {910040,2030202}
	return generates
end

function LevelBehavior104540201.GetStorys()
	local storys = {}
	return storys
end

function LevelBehavior104540201.NeedBlackCurtain()
	return true, 0
end

function LevelBehavior104540201:Init()
	self.role = BehaviorFunctions.GetCtrlEntity()
	self.missionState = 0

	self.blockInf =
	{
		[1] = {Id = nil ,bp = "Task1010608Wall1",entityId = 2030202},
	}
	self.gate1EcoId = 2001002120001
	self.time = 0
end


	
function LevelBehavior104540201:Update()
		self.time = BehaviorFunctions.GetFightFrame()
		self.role = BehaviorFunctions.GetCtrlEntity()
		if self.missionState == 0 then
		--BehaviorFunctions.ChangeEcoEntityCreateState(self.gate1EcoId, false)
		
		    --打开庭院的门
		    local ins = BehaviorFunctions.GetEcoEntityByEcoId(self.gate1EcoId)
		    if ins ~= nil then
			    local result = BehaviorFunctions.CheckEntity(ins)
			    if result == true then
				--BehaviorFunctions.SetEntityValue(ins,"Remove",true)
				BehaviorFunctions.InteractEntityHit(ins)
		
			    end
				BehaviorFunctions.FinishLevel(104540201)
		    end
			self.missionState = 1
		end
end
