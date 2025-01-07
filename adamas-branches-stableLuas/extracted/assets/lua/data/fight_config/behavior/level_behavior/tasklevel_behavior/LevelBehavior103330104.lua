LevelBehavior103330104 = BaseClass("LevelBehavior103330104",LevelBehaviorBase)
--浮空岛3boss战

function LevelBehavior103330104:__init(fight)
    self.fight = fight
end

function LevelBehavior103330104.GetGenerates()
    local generates = {791004002,2030206}
    return generates
end

function LevelBehavior103330104:Init()
	self.missionState = 0
	self.rongyeList = {}
	self.rongyeCount = 10
	self.rongyeCreate = false
	self.taskProgress = false
end

 
function LevelBehavior103330104:Update()
	if self.missionState == 0  then
		--创建Boss
		self.boss = self:CreateActor(791004002,"monster1")
		--创建溶液
		for i = 1,self.rongyeCount do
			local posName = "rongye"..i
			local instanceId = self:CreateActor(2030206,posName)
			table.insert(self.rongyeList,instanceId)
		end
		self.missionState = 1
	end
end

function LevelBehavior103330104:Death(instanceId, isFormationRevive)
	for i,v in ipairs(self.rongyeList) do
		if instanceId == v then
			self.rongyeCount = self.rongyeCount - 1
		end
	end
	if instanceId == self.boss then
		BehaviorFunctions.FinishLevel(self.levelId)
		if self.taskProgress == false then
			if self.rongyeCount == 0 then
				--溶液只剩一个
				BehaviorFunctions.SendTaskProgress(1033302,1,1)
			elseif self.rongyeCount < 5 then
				--溶液剩的多
				BehaviorFunctions.SendTaskProgress(1033303,1,1)
			end
			self.taskProgress = true
		end
	end
end

function LevelBehavior103330104:CreateActor(entityId,bornPos)
	local instanceId = BehaviorFunctions.CreateEntityByPosition(entityId,nil,bornPos,nil,self.levelId,self.levelId)
	return instanceId
end