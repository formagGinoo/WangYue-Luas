LevelBehavior4001 = BaseClass("LevelBehavior4001",LevelBehaviorBase)
--关卡测试关
function LevelBehavior4001:__init(fight)
	self.fight = fight
end


function LevelBehavior4001.GetGenerates()
	local generates = {2040802,2040803,2040811}
	return generates
end


function LevelBehavior4001:Init()
	self.role = 0
	self.initState = 0
	self.missionState = 0
	self.car = 0
	self.pos = 0
end

function LevelBehavior4001:Update()
	self.time = BehaviorFunctions.GetFightFrame()
	self.role = BehaviorFunctions.GetCtrlEntity()
	if self.initState == 0 then
		--self.pos = BehaviorFunctions.GetTerrainPositionP("PlayerBorn",self.levelId)
		--BehaviorFunctions.DoSetPosition(self.role,self.pos.x,self.pos.y,self.pos.z)
		LogError("关卡已创建")
		self.initState = 1
	end
	
	--if self.missionState == 0 then
		--local pos = BehaviorFunctions.GetTerrainPositionP("Car",4001)
		--self.car = BehaviorFunctions.CreateEntity(2040811,nil,pos.x,pos.y,pos.z,nil,nil,nil,nil,nil)
		--self.missionState = 1
	--end
end

function LevelBehavior4001:KeyInput(key,status)
	if key == FightEnum.KeyEvent.NormalSkill and status == FightEnum.KeyInputStatus.Down then
		LogError("关卡已完成")
		BehaviorFunctions.FinishLevel(self.levelId)
	end
end

