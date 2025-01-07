LevelBehavior104480101 = BaseClass("LevelBehavior104480101",LevelBehaviorBase)


function LevelBehavior104480101:__init(fight)
	self.fight = fight
end


--预加载
function LevelBehavior104480101.GetGenerates()
	local generates = {900040,900041,910040,900030}
	return generates
end

--初始化
function LevelBehavior104480101:Init()

	self.bornPos = 0 --定义重生位置在这个脚本中的名称
	self.enemy1 = nil
	self.enemy2 = nil
	self.enemy3 = nil
	self.enemy4 = nil
	self.enemy5 = nil
	self.enemy6 = nil
	self.enemy7 = nil

	self.enemyPos = 0
	self.enemyID = 900040 --定义生成什么敌人
	self.npc = nil
	self.missionState = 0
	self.count = 0 --定义玩家击败敌人数量
	


end


function LevelBehavior104480101:Update()

	self.time = BehaviorFunctions.GetFightFrame() --获取帧数


	if self.missionState == 0 then --阶段1

		--Monster Born

		local eBornPos1 = BehaviorFunctions.GetTerrainPositionP("Pos1",self.levelId)
		local eBornPos2 = BehaviorFunctions.GetTerrainPositionP("Pos2",self.levelId)
		local eBornPos3 = BehaviorFunctions.GetTerrainPositionP("Pos3",self.levelId)
		--local eBornRot1 = BehaviorFunctions.GetTerrainRotationP("Pos1",self.levelId)
		--local eBornRot2 = BehaviorFunctions.GetTerrainRotationP("Pos2",self.levelId)
		--local eBornRot3 = BehaviorFunctions.GetTerrainRotationP("Pos3",self.levelId)				
		self.enemy1 = BehaviorFunctions.CreateEntity(900040,nil,eBornPos1.x,eBornPos1.y,eBornPos1.z)
		--BehaviorFunctions.SetEntityEuler(self.enemy1,eBornRot1.x,eBornRot1.y,eBornRot1.z)
		self.enemy2 = BehaviorFunctions.CreateEntity(900040,nil,eBornPos2.x,eBornPos2.y,eBornPos2.z)
		--BehaviorFunctions.SetEntityEuler(self.enemy2,eBornRot2.x,eBornRot2.y,eBornRot2.z)
		self.enemy3 = BehaviorFunctions.CreateEntity(900040,nil,eBornPos3.x,eBornPos3.y,eBornPos3.z)
		--BehaviorFunctions.SetEntityEuler(self.enemy3,eBornRot3.x,eBornRot3.y,eBornRot3.z)
				

		
		self.missionState = 1

	end



	if self.missionState == 1 and self.count > 2 then --阶段3

		----Wave 2 Monster Born
		BehaviorFunctions.FinishLevel(104480101)

		self.missionState = 2
	end
	

end


--死亡敌人计数
function LevelBehavior104480101:Die(attackInstanceId,dieInstanceId)
	if dieInstanceId == self.enemy1 or dieInstanceId == self.enemy2 or dieInstanceId == self.enemy3 or dieInstanceId == self.enemy4
		or dieInstanceId == self.enemy5 or dieInstanceId == self.enemy6 or dieInstanceId == self.enemy7
		then
		self.count = self.count + 1

		BehaviorFunctions.ChangeTitleTipsDesc(self.tipId,self.count)--更新Tip信息
	end
end


function LevelBehavior104480101:__delete()
	
end


