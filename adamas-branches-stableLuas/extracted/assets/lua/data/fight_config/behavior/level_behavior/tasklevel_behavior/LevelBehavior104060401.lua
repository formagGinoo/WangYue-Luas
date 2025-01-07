LevelBehavior104060401 = BaseClass("LevelBehavior104060401",LevelBehaviorBase)


function LevelBehavior104060401:__init(fight)
	self.fight = fight
end


--预加载
function LevelBehavior104060401.GetGenerates()
	local generates = {900040,900041,910040}
	return generates
end

--初始化
function LevelBehavior104060401:Init()



	self.enemyPos = 0
	self.npc = nil
	self.missionState = 0
	self.me = self.levelId
	
	--怪物状态判断
	self.monsterStateEnum =
	{
		Default = 0,
		Live = 1,
		Dead = 2,
	}
	
	self.deathCount = 0

	--怪物list
	self.enemyList = {
		[1] = {state = self.monsterStateEnum.Default, monsterId = 900040, enemyType = "monster", posName = "Pos4631", Id = nil},
		[2] = {state = self.monsterStateEnum.Default, monsterId = 900040, enemyType = "monster", posName = "Pos4632", Id = nil},
		[3] = {state = self.monsterStateEnum.Default, monsterId = 900050, enemyType = "monster", posName = "Pos4633", Id = nil},
		[4] = {state = self.monsterStateEnum.Default, monsterId = 910040, enemyType = "monster", posName = "Pos4634", Id = nil},
		[5] = {state = self.monsterStateEnum.Default, monsterId = 900050, enemyType = "monster", posName = "Pos4633", Id = nil},
		[6] = {state = self.monsterStateEnum.Default, monsterId = 900050, enemyType = "monster", posName = "Pos4632", Id = nil}	
	}



end


function LevelBehavior104060401:Update()

	self.time = BehaviorFunctions.GetFightFrame() --获取帧数
	BehaviorFunctions.ShowCommonTitle(8,"发现城市威胁",true)


	if self.missionState == 0 then --阶段1

		--Monster Born

		self:summonMonster(self.enemyList,1)
		self:summonMonster(self.enemyList,2)
		BehaviorFunctions.AddDelayCallByFrame(20,self,self.summonMonster,self.self.enemyList[3])


		self.missionState = 1

	end


	if self.missionState == 1 and self.deathCount > 2 then --阶段2

		----Wave 2 Monster Born

		self:summonMonster(self.enemyList[4])
		self:summonMonster(self.enemyList[5])
		BehaviorFunctions.AddDelayCallByFrame(20,self,self.summonMonster,self.enemyList[6])

		self.missionState = 2
	end


	if self.missionState == 2 and self.deathCount > 5 then
		BehaviorFunctions.SendTaskProgress(1040603,1,1)
		self.missionState = 4
	end
end





function LevelBehavior104060401:summonMonster(List)
	for i,v in ipairs(List) do
		if v.state ~= self.monsterStateEnum.Live then
			local pos = BehaviorFunctions.GetTerrainPositionP(posName,self.levelId)

			if pos ~= nil then
				v.Id = BehaviorFunctions.CreateEntity(v.monsterId,nil,pos.x,pos.y,pos.z,nil,nil,nil,self.levelId)
				self.enemyList[v].Id = BehaviorFunctions.CreateEntity(self.monsterList[v].entityId,nil,pos.x,pos.y,pos.z,nil,nil,nil,self.levelId,self.monLev)
				BehaviorFunctions.SetEntityEuler(self.monsterList[v].Id,posR.x,posR.y,posR.z)
				self.enemyList[v].state = self.monsterStateEnum.Live
				v.state = self.monsterStateEnum.Live
				BehaviorFunctions.DoLookAtTargetImmediately(v.Id,self.role)

				if v.enemyType == "monster" then
					self.enemyCount = self.enemyCount + 1
				end
			end
		end
	end
end

function LevelBehavior104060401:Die(attackInstanceId,dieInstanceId)

	for i,v in ipairs(self.enemyList) do
		if dieInstanceId == v.Id and v.enemyType == "monster" then
			v.state = self.monsterStateEnum.Dead
			self.deathCount = self.deathCount + 1
			local killVal = self.deathCount
			--BehaviorFunctions.ChangeSubTipsDesc(3,104060103,killVal,self.enemyCount)  --修改tips
		end

		if dieInstanceId == v.Id and v.enemyType == "boss" then
			for i,v in ipairs(self.enemyList) do
				if v.enemyType == "monster" and v.state ~= self.monsterStateEnum.Dead then
					BehaviorFunctions.SetEntityAttr(v.Id,1001,0,1)  --这里修改的什么实体没有弄清楚
				end
			end
			self.missionSuccess = true
			self.missionFinished = true
		end
	end
end

----检查敌人是否死完
--local monsterList = self.waveList[1]
--local listLenth = #monsterList
--for i,v in ipairs (monsterList) do
	--if self.monsterList[i].state ~= self.monsterStateEnum.Dead then
		--return
	--else
		--if i == listLenth then
			--self.missionState = 999
		--end
	--end
--end


function LevelBehavior104060401:__delete()

end


