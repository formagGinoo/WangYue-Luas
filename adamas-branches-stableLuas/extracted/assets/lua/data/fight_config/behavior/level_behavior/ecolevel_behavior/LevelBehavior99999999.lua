LevelBehavior99999999 = BaseClass("LevelBehavior99999999",LevelBehaviorBase)
--大悬钟，搬运电梯玩法
function LevelBehavior99999999.GetGenerates()
	local generates = {2080101,2080102,2080103,2990101}
	return generates
end


function LevelBehavior99999999:Init()
	self.missionState = 0
	self.time = nil
	self.frame = nil
	self.role = nil
	self.empty = 0
	self.feiji = nil
	
	self.actorList =
	{
		{id = 2080101 ,posName = "Fan1" ,pos = nil ,instanceId = nil},
		{id = 2080101 ,posName = "Fan2" ,pos = nil ,instanceId = nil},
		{id = 2080101 ,posName = "Fan3" ,pos = nil ,instanceId = nil},
		{id = 2080101 ,posName = "Fan4" ,pos = nil ,instanceId = nil},
		{id = 2080102 ,posName = "Banzi1" ,pos = nil ,instanceId = nil},
		{id = 2080103 ,posName = "Console1" ,pos = nil ,instanceId = nil},
		}
end

function LevelBehavior99999999:Update()
	self.time = BehaviorFunctions.GetFightFrame()/30
	self.frame = BehaviorFunctions.GetFightFrame()
	self.role = BehaviorFunctions.GetCtrlEntity()

	if self.missionState == 0 then
		self.empty = BehaviorFunctions.CreateEntityByPosition(2001,nil,"MiddlePos",nil,99999999,self.levelId)
		
		self.missionState = 1
	
	elseif self.missionState == 1 then
		self.blueprintIndex = Fight.Instance.clientFight.buildManager.buildController:TempCreateBlueprint(nil,{x = 2206,y = 153,z = 1054}, {x =0,y = 70,z = 0})
		self.missionState = 2
		
	elseif self.missionState == 2 then
		self:CreateActor(self.actorList)
		self:PosCheck(self.actorList)
	end
end

function LevelBehavior99999999:RemoveLevel(levelId)

end

--赋值
function LevelBehavior99999999:Assignment(variable,value)
	self[variable] = value
end


function LevelBehavior99999999:CreateActor(List)
	for i,v in ipairs(List) do
		if v.id then
			if not BehaviorFunctions.CheckEntity(v.instanceId) then
				if v.posName then
					local pos = BehaviorFunctions.GetTerrainPositionP(v.posName,self.levelId)
					local rot = BehaviorFunctions.GetTerrainRotationP(v.posName,self.levelId)
					if pos then
						v.instanceId = BehaviorFunctions.CreateEntity(v.id,nil,pos.x,pos.y,pos.z,nil,nil,nil,self.levelId,v.lev)
						BehaviorFunctions.SetEntityEuler(v.instanceId,rot.x,rot.y,rot.z)
					end
				end
			end
		end
	end
end

function LevelBehavior99999999:PosCheck(List)
	for i,v in ipairs(List) do
		if v.instanceId then
			local pos = BehaviorFunctions.GetPositionP(v.instanceId)
			local rootPos = BehaviorFunctions.GetTerrainPositionP(v.posName,self.levelId)
			if rootPos.y - pos.y > 40 then
				BehaviorFunctions.RemoveEntity(v.instanceId)
			end
		end
	end
	
	if self.feiji then
		local pos = BehaviorFunctions.GetPositionP(self.feiji)
		local rootPos = BehaviorFunctions.GetTerrainPositionP("MiddlePos",self.levelId)
		if rootPos.y - pos.y > 40 then
			self.blueprintIndex = Fight.Instance.clientFight.buildManager.buildController:TempCreateBlueprint(nil,{x = 2206,y = 153,z = 1054}, {x =0,y = 70,z = 0})
			self.feiji = nil
		end
	end
end

function LevelBehavior99999999:TempCreateBluePrint(index, instanceId)
	if self.blueprintIndex == index then
		self.feiji = instanceId
	end
end