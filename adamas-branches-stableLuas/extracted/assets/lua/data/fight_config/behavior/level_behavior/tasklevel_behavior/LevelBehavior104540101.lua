LevelBehavior104540101 = BaseClass("LevelBehavior104540101",LevelBehaviorBase)
--检查周围的草堆寻找钥匙
function LevelBehavior104540101:__init(fight)
	self.fight = fight
end

function LevelBehavior104540101.GetGenerates()
	local generates = {910040,2030202}
	return generates
end

function LevelBehavior104540101.GetStorys()
	local storys = {}
	return storys
end


function LevelBehavior104540101:Init()
	self.role = BehaviorFunctions.GetCtrlEntity()
	self.missionState = 0
    self.inarea = false
	self.button = nil
	self.key = 0
	self.time = 0
	self.role = nil --定义玩家操控角色
	

	self.button1 = nil
end


	
function LevelBehavior104540101:Update()
		self.time = BehaviorFunctions.GetFightFrame()
		self.role = BehaviorFunctions.GetCtrlEntity()
		if self.missionState == 0 and self.key == 1 then
		

			BehaviorFunctions.FinishLevel(104540101)
		    
			self.missionState = 1
		end
end


--点击交互
function LevelBehavior104540101:WorldInteractClick(uniqueId,instanceId)

	if uniqueId == self.button1 then
		BehaviorFunctions.WorldInteractRemove(self.role,self.button1)
		self.key = self.key + 1
	end
end


--进入交互范围，添加搜索按钮
function LevelBehavior104540101:EnterArea(triggerInstanceId, areaName, logicName)

	if triggerInstanceId == self.role and self.inarea == false  and areaName == "Area22" then
		self.button1 = BehaviorFunctions.WorldInteractActive(self.role,4,nil,"搜索",1)
		self.inarea = true
	end	
end

function LevelBehavior104540101:ExitArea(triggerInstanceId, areaName, logicName)

	if self.button1 ~= nil and triggerInstanceId == self.role and areaName == "Area22" then
		BehaviorFunctions.WorldInteractRemove(self.role,self.button1)
		self.inarea = false
	end
	
end

