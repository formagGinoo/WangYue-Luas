LevelBehavior1003 = BaseClass("LevelBehavior1003",LevelBehaviorBase)
--贝露贝特测试关1
function LevelBehavior1003:__init(fight)
	self.fight = fight
end


function LevelBehavior1003.GetGenerates()
	local generates = {92002}
	return generates
end


function LevelBehavior1003:Init()
	--self.timeStart = 0
	self.missionState = 0
end

--local bcomb = false
function LevelBehavior1003:Update()
	self.time = BehaviorFunctions.GetFightFrame()/30
	self.role = BehaviorFunctions.GetCtrlEntity()
	
	-- if self.missionState == 5 and self.time - self.timeStart >= 5 then
	-- 	-- BehaviorFunctions.CastSkillByTarget(self.Monster,92002041,self.role)	
	-- 	-- if bcomb then
	-- 	-- 	BehaviorFunctions.ClearEntityCombination(self.Monster, self.MonsterBlbt)
	-- 	-- else
	-- 	-- 	BehaviorFunctions.EntityCombination(self.Monster, self.MonsterBlbt, true)
	-- 	-- end
	-- 	-- bcomb = not bcomb

	-- 	self.timeStart = BehaviorFunctions.GetFightFrame()/30
	-- end	
	
	if not BehaviorFunctions.HasEntitySign(self.role,10000007) then
		BehaviorFunctions.AddEntitySign(self.role,10000007,-1)
	end
	if  self.missionState == 0 and BehaviorFunctions.CanCtrl(self.role) then
		local role = BehaviorFunctions.GetTerrainPositionP("born1")
		local blbt = BehaviorFunctions.GetTerrainPositionP("blbt")
		BehaviorFunctions.ActiveSceneObj("blbtbgm",true)
		--BehaviorFunctions.DoSetPosition(self.role,role.x,role.y,role.z)
		BehaviorFunctions.SetPlayerBorn(role.x,role.y,role.z)	--设置角色出生点
		self.Monster = BehaviorFunctions.CreateEntity(92002,nil,blbt.x,blbt.y,blbt.z,role.x,nil,role.z)
		--self.MonsterBlbt = BehaviorFunctions.CreateEntity(92001,nil,blbt.x + 10,blbt.y,blbt.z,role.x,role.z)

		BehaviorFunctions.DoLookAtTargetImmediately(self.role,self.Monster)
		BehaviorFunctions.InitCameraAngle(0)
		self.missionState = 5
	end
	if self.missionState == 30 and self.time - self.timeStart >=1 then
		local canshu = 3
		BehaviorFunctions.ShowTip(1106,canshu)
		self.timeStart =self.time
		self.missionState = 31
	end
	if self.missionState == 31 and self.time - self.timeStart >=1 then
		local canshu = 2
		BehaviorFunctions.ShowTip(1106,canshu)
		self.timeStart =self.time
		self.missionState = 32
	end
	if self.missionState == 32 and self.time - self.timeStart >=1 then
		local canshu = 1
		BehaviorFunctions.ShowTip(1106,canshu)
		self.timeStart =self.time
		self.missionState = 33
	end
	if self.missionState == 33 and self.time - self.timeStart >=1 then
		BehaviorFunctions.SetFightResult(true)
		self.missionState = 999
	end
end

function LevelBehavior1003:Death(instanceId)
	if instanceId == self.role then
		BehaviorFunctions.SetFightResult(false)
	end
	if instanceId == self.Monster then
		self.missionState = 30
		self.timeStart = self.time
	end
end

function LevelBehavior1003:__delete()

end