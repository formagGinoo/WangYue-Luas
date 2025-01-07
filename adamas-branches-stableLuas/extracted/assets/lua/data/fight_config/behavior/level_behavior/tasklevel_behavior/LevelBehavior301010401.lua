LevelBehavior301010401 = BaseClass("LevelBehavior301010401",LevelBehaviorBase)

function LevelBehavior301010401.GetGenerates()
	local generates = {808011003}
	return generates
end

function LevelBehavior301010401:__init(fight)
----关卡参数----
	self.fight = fight
	self.role = nil
	self.frame = nil
	
	self.enemyState = 
	{
		Defult = 1,
		Alive = 2,
		Death = 3,
	}
	
	self.enemyList = 
	{
		[1]	= {enemyId = 808011003, state = self.enemyState.Defult, id = nil, posName = "EnemyPos1"},
		[2]	= {enemyId = 808011003, state = self.enemyState.Defult, id = nil, posName = "EnemyPos2"},
		[3]	= {enemyId = 808011003, state = self.enemyState.Defult, id = nil, posName = "EnemyPos3"},
		[4]	= {enemyId = 808011003, state = self.enemyState.Defult, id = nil, posName = "EnemyPos4"},
	}
	
----关卡进度参数----
	self.missionState = 0
	self.deathCount = 0
end


function LevelBehavior301010401:init()
	
end


function LevelBehavior301010401:Update()
	self.frame = BehaviorFunctions.GetFightFrame()
	self.role = BehaviorFunctions.GetCtrlEntity()
	
	if self.missionState == 0 then
		self:SummonMonster(self.enemyList)
		self.missionState = 1
	end
	
	if self.missionState == 2 then
		BehaviorFunctions.SendTaskProgress(301010401,1,1)
		self.missionState = 999
	end
	
end


function LevelBehavior301010401:SummonMonster(List)
	for i,v in ipairs(List) do
		if v.state ~= self.enemyState.Death then
			local pos = BehaviorFunctions.GetTerrainPositionP(v.posName,self.levelId)
			v.id = BehaviorFunctions.CreateEntity(v.enemyId,nil,pos.x,pos.y,pos.z,nil,nil,nil,self.levelId)
		end
	end
end


function LevelBehavior301010401:Death(instanceId,isFormationRevive)
	for i,v in ipairs(self.enemyList) do
		if instanceId == v.id then
			self.deathCount = self.deathCount + 1
			
			if self.deathCount == #self.enemyList then
				self.missionState = 2
			end
		end
	end
end