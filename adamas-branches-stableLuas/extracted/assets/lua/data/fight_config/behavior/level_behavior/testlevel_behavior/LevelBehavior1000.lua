LevelBehavior1000 = BaseClass("LevelBehavior1000",LevelBehaviorBase)
--战斗单怪测试关
function LevelBehavior1000:__init(fight)
	self.fight = fight
end


function LevelBehavior1000.GetGenerates()
	local generates = {910024}
	return generates
end


function LevelBehavior1000:Init()
	self.role = 1
	self.Missionstate = 0
end

function LevelBehavior1000:Update()
	self.time = BehaviorFunctions.GetFightFrame()
	if  self.Missionstate == 0 then
		self.entites = {}   --初始化self.entites表
		local pb1 = BehaviorFunctions.GetTerrainPositionP("role")
		local mb101 = BehaviorFunctions.GetTerrainPositionP("mb101")
		BehaviorFunctions.InitCameraAngle(180)
		BehaviorFunctions.DoSetPosition(self.role,pb1.x,pb1.y,pb1.z)
		BehaviorFunctions.SetPlayerBorn(pb1.x,pb1.y,pb1.z)	--设置角色出生点
		self.Monster = BehaviorFunctions.CreateEntity(910024,nil,mb101.x,mb101.y,mb101.z,pb1.x,nil,pb1.z)
		BehaviorFunctions.DoLookAtTargetImmediately(self.role,self.Monster)
		self.startTime = BehaviorFunctions.GetFightFrame()
		self.Missionstate = 5
	end
	
	if self.Missionstate == 5 and self.time - self.startTime == 300 then
		self:StopTime()
		local closeCallback = function()
			self.Missionstate = 7
		end
		BehaviorFunctions.ShowGuideImageTips(1001,closeCallback)
		self.Missionstate = 6
	end
	
	if self.Missionstate == 6 then

	end
	
	if self.Missionstate == 7 then
		local closeCallback = function()
			self.Missionstate = 9
		end
		BehaviorFunctions.ShowGuideImageTips(1002,closeCallback)
		self.Missionstate = 8
	end
	
	if self.Missionstate == 8 then

	end
	
	if self.Missionstate == 9 then
		self:Continue()
		self.Missionstate = 10
		self.startTime = BehaviorFunctions.GetFightFrame()
	end
	if self.Missionstate == 10 and self.time - self.startTime == 300 then
		BehaviorFunctions.DoMagic(self.Monster,self.Monster,200000009)
	end
end

function LevelBehavior1000:Death(instanceId)
	if instanceId == self.Monster then
		local pb1 = BehaviorFunctions.GetTerrainPositionP("role")
		local mb101 = BehaviorFunctions.GetTerrainPositionP("mb101")
		self.Monster = BehaviorFunctions.CreateEntity(9001,nil,mb101.x,mb101.y,mb101.z,pb1.x,nil,pb1.z)
		BehaviorFunctions.DoLookAtTargetImmediately(self.role,self.Monster)
	end
end

function LevelBehavior1000:__delete()

end

--时间暂停
function LevelBehavior1000:StopTime()        --暂停实体时间和行为
	local entity = BehaviorFunctions.GetCtrlEntity()
	if entity then
		BehaviorFunctions.DoMagic(entity,entity,200000008)
	end
end

--解除时间暂停
function LevelBehavior1000:Continue()        --解除暂停
	local entity = BehaviorFunctions.GetCtrlEntity()
	if entity then
		BehaviorFunctions.RemoveBuff(entity,200000008)
	end
end