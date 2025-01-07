LevelBehavior1008 = BaseClass("LevelBehavior1008",LevelBehaviorBase)


--fight初始化
function LevelBehavior1008:__init(fight)
	self.fight = fight	
end

--预加载
function LevelBehavior1008.GetGenerates()
	local generates = {9001}
	return generates
end

--初始化
function LevelBehavior1008:Init()
	self.role = 1
	self.Missionstate = 0
	self.AreaTest1 = true
	self.AreaTest2 = true
end

function LevelBehavior1008:Update()
	if not self.entites and self.Missionstate == 0 then 
		self.entites = {}   --初始化self.entites表
		self.Monster = BehaviorFunctions.CreateEntity(9001)                 --召怪,返回怪物id
		BehaviorFunctions.DoSetPosition(self.Monster,10,0,12.5) --怪物位置
		BehaviorFunctions.DoSetPosition(self.role,3,0,12.5)         --角色位置
		self.Missionstate = 1
	end
	
	if self.Missionstate == 1 then
		BehaviorFunctions.SetWallEnable("AW5",false)
		self.AreaTest1 = BehaviorFunctions.GetInAreaById("Area0",self.role)
		self.AreaTest2 = BehaviorFunctions.GetInAreaByPos("Area0",{x = 1,y = 0,z = 12.5})	
		self.Missionstate = 2
	end
	if self.Missionstate == 2 and BehaviorFunctions.GetInAreaById("Area0",self.role) then
		self.Missionstate = 3
	end
end

function LevelBehavior1008:__delete()

end

