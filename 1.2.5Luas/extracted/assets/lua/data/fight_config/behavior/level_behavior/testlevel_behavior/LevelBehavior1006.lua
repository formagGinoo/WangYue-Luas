LevelBehavior1006 = BaseClass("LevelBehavior1006",LevelBehaviorBase)
----战斗群怪测试关
function LevelBehavior1006:__init(fight)
	self.fight = fight
end


function LevelBehavior1006.GetGenerates()
	local generates = {9001}
	return generates
end


function LevelBehavior1006:Init()
	self.role = 1
	self.missionState = 0
	self.monsters = {}
	self:LevelInit()
end

function LevelBehavior1006:Update()
	self.wave1Count = self:WaveCount(1)
	if  self.missionState == 0 then
		self:CreatMonster({
				{id = 9001 ,posName = "mb201",lookatposName = "blbt",wave = 1},
				{id = 9001 ,posName = "mb202",lookatposName = "blbt",wave = 1},
				{id = 9001 ,posName = "mb203",lookatposName = "blbt",wave = 1},
				{id = 9001 ,posName = "mb204",lookatposName = "blbt",wave = 1},
				{id = 9001 ,posName = "mb205",lookatposName = "blbt",wave = 1},
				{id = 9001 ,posName = "mb206",lookatposName = "blbt",wave = 1},
			})
		self.missionState = 5
	end
end

function LevelBehavior1006:Death(instanceId)
	if self.wave1Count == 0 then
		self:CreatMonster({
				{id = 9001 ,posName = "mb201",lookatposName = "blbt",wave = 1},
				{id = 9001 ,posName = "mb202",lookatposName = "blbt",wave = 1},
				{id = 9001 ,posName = "mb203",lookatposName = "blbt",wave = 1},
				{id = 9001 ,posName = "mb204",lookatposName = "blbt",wave = 1},
				{id = 9001 ,posName = "mb205",lookatposName = "blbt",wave = 1},
				{id = 9001 ,posName = "mb206",lookatposName = "blbt",wave = 1},
			})
	end
end

function LevelBehavior1006:__delete()

end

--刷怪
function LevelBehavior1006:CreatMonster(monsterList)
	local MonsterId = 0
	for a = #monsterList,1,-1 do
		if monsterList[a].lookatposName then
			local posP = BehaviorFunctions.GetTerrainPositionP(monsterList[a].posName)
			local lookatposP = BehaviorFunctions.GetTerrainPositionP(monsterList[a].lookatposName)
			MonsterId = BehaviorFunctions.CreateEntity(monsterList[a].id,nil,posP.x,posP.y,posP.z,lookatposP.x,nil,lookatposP.z)
			table.insert(self.monsters,{wave =monsterList[a].wave,instanceId =MonsterId})
		else
			local posP = BehaviorFunctions.GetTerrainPositionP(monsterList[a].posName)
			MonsterId = BehaviorFunctions.CreateEntity(monsterList[a].id,nil,posP.x,posP.y,posP.z)
			BehaviorFunctions.DoLookAtTargetImmediately(MonsterId,self.role)
			table.insert(self.monsters,{wave = monsterList[a].wave,instanceId = MonsterId})
		end
	end
	table.sort(self.monsters,function(a,b)
			if a.wave < b.wave then
				return true
			elseif a.wave == b.wave then
				if a.instanceId < b.instanceId then
					return true
				end
			end
		end)
end

function LevelBehavior1006:WaveCount(waveNum)
	local count	= 0
	for i = #self.monsters,1,-1  do
		if self.monsters[i].wave == waveNum then
			count = count + 1
		end
	end
	return count
end

--关卡初始化
function LevelBehavior1006:LevelInit()
	self.role = BehaviorFunctions.GetCtrlEntity()
	local role = BehaviorFunctions.GetTerrainPositionP("role")
	local s1 = BehaviorFunctions.GetTerrainPositionP("blbt")
	BehaviorFunctions.SetPlayerBorn(role.x,role.y,role.z)	--角色位置
	BehaviorFunctions.DoLookAtPositionImmediately(self.role,s1.x,nil,s1.z)
	BehaviorFunctions.InitCameraAngle(180)
end