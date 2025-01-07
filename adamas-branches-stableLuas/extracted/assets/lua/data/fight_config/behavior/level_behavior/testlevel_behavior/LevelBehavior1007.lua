LevelBehavior1007 = BaseClass("LevelBehavior1007",LevelBehaviorBase)


--fight初始化
function LevelBehavior1007:__init(fight)
	self.fight = fight	
end

--预加载
function LevelBehavior1007.GetGenerates()
	local generates = {9001}
	return generates
end

--参数初始化
function LevelBehavior1007:Init()
	self.role = 1
	self.Missionstate = 0
	self.Monsters = {
		Count = 0
	}
	self.wave = 3
end

function LevelBehavior1007:Update()
	--初始化，角色出生点
	if  self.Missionstate == 0 then 
		self.entites = {}   --初始化self.entites表
		BehaviorFunctions.DoSetPosition(self.role,61.06,3.5,57.78)         --角色位置	
		self.Missionstate = 10
	end
	--召怪
	if self.Missionstate == 10 then	
		self.Monsters.count = self:CreatMonster(
			3,
			9001,61.06,3.5,66.25,
			9001,63.06,3.5,66.25,
			9001,65.06,3.5,66.25
			)				
		self.Missionstate = 20
	end
	
--[[	if self.Missionstate == 20 then   --清怪检测
        if self.Monsters.Count == 0 then
	     self.Missionstate = 10
	    end
	end
	]]
end
	

function LevelBehavior1007:Death(instanceId)	
	if self.Monsters[instanceId] then
		self.Monsters[instanceId] = nil
		self.Monsters.Count = self.Monsters.Count - 1
		Log(self.Monsters.Count)
	end
end

function LevelBehavior1007:CreatMonster(...)
--MonsterNum,Monster1Id,Monster1PosX,Monster1PosY,Monster1PosZ,Monster2Id,Monster2PosX,Monster2PosY,Monster2PosZ...
	local i = 0
	local v = 0
	local MonsterIdnPos = {}
	local MId = 2
	local MPosX = 3
	local MPosY = 4
	local MPosZ = 5
	for i,v in ipairs{...} do
		MonsterIdnPos[i] = v
	end
	for a = 1,MonsterIdnPos[1] do
		local MonsterId = BehaviorFunctions.CreateEntity(MonsterIdnPos[MId])      --召怪,返回怪物实体id
		BehaviorFunctions.DoSetPosition(MonsterId,MonsterIdnPos[MPosX],MonsterIdnPos[MPosY],MonsterIdnPos[MPosZ])
		MId = MId + 4
		MPosX = MPosX + 4
		MPosY = MPosY + 4
		MPosZ = MPosZ + 4
		BehaviorFunctions.DoLookAtTargetImmediately(MonsterId,1)
	end
	return MonsterIdnPos[1]
end	
	
function LevelBehavior1007:__delete()

end