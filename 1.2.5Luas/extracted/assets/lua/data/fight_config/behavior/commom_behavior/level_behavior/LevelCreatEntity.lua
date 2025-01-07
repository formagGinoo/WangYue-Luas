LevelCreatEntity = BaseClass("LevelCreatEntity",LevelBehaviorBase)
--fight初始化
function LevelCreatEntity:__init(fight)
	self.fight = fight
end

--预加载
function LevelCreatEntity.GetGenerates()
	local generates = {}
	return generates
end

--参数初始化
function LevelCreatEntity:Init()
	self.time = 0
	self.cameraTime = 0
	self.cameraName = 0
	self.cameraSign = 0
end

--帧事件
function LevelCreatEntity:Update()

end


--刷怪
function LevelCreatEntity:CreatMonster(monsterList)
	local MonsterId = 0
	for a = #monsterList,1,-1 do
		if monsterList[a].lookatposName then
			local posP = BehaviorFunctions.GetTerrainPositionP(monsterList[a].posName)
			local lookatposP = BehaviorFunctions.GetTerrainPositionP(monsterList[a].lookatposName)
			MonsterId = BehaviorFunctions.CreateEntity(monsterList[a].id,nil,posP.x,posP.y,posP.z,lookatposP.x, nil, lookatposP.z)
			table.insert(self.monsters,{wave =monsterList[a].wave,instanceId = MonsterId})
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
