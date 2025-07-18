LevelBehavior32000102 = BaseClass("LevelBehavior32000102",LevelBehaviorBase)
--无buff神荼挑战

function LevelBehavior32000102.GetGenerates()
	local generates = {709200300}
	return generates
end


function LevelBehavior32000102:__init(taskInfo)
	self.enemyList = {
		[1] = {bp = "enemy1", enemyId = 709200300, id = nil, lev = 0},
	}

	--怪物世界等级偏移
	self.monsterLevelBias = {
		[FightEnum.EntityNpcTag.Monster] = 0,
		[FightEnum.EntityNpcTag.Elite] = 0,
		[FightEnum.EntityNpcTag.Boss] = 15,
	}
	
	self.deathCount = 0
	self.enemyCount = 0
	self.taskState = 0

	self.role = nil
	self.startRange = 20
end


function LevelBehavior32000102:Update()
	self.role = BehaviorFunctions.GetCtrlEntity()

	if self.taskState == 0 then
		local PlayerTP = BehaviorFunctions.GetTerrainPositionP("Phase2pb",self.levelId)
		BehaviorFunctions.InMapTransport(PlayerTP.x,PlayerTP.y,PlayerTP.z,false)
		self.taskState = 1
	end

	if self.taskState == 1 then
		self:summonMonster()
		BehaviorFunctions.ActiveSceneObj("airWall1",true,self.levelId)
		BehaviorFunctions.ActiveSceneObj("airWall2",true,self.levelId)
		BehaviorFunctions.ActiveSceneObj("airWall3",true,self.levelId)
		BehaviorFunctions.ActiveSceneObj("airWall4",true,self.levelId)
		self.taskState = 2
	end




	if self.taskState == 2 then
		if self.deathCount == self.enemyCount then
			BehaviorFunctions.FinishLevel(self.levelId)
			--BehaviorFunctions.ShowCommonTitle(6,"神荼",true)
			BehaviorFunctions.SetDuplicateResult(true)
			BehaviorFunctions.ActiveSceneObj("airWall1",false,self.levelId)
			BehaviorFunctions.ActiveSceneObj("airWall2",false,self.levelId)
			BehaviorFunctions.ActiveSceneObj("airWall3",false,self.levelId)
			BehaviorFunctions.ActiveSceneObj("airWall4",false,self.levelId)
			self.taskState = 999
		end
	end
end

function LevelBehavior32000102:summonMonster()
	for i,v in ipairs(self.enemyList) do
		local pos = BehaviorFunctions.GetTerrainPositionP(v.bp, self.levelId)
		local rot = BehaviorFunctions.GetTerrainRotationP(v.bp, self.levelId)

		local npcTag = BehaviorFunctions.GetTagByEntityId(v.enemyId)
		local worldMonsterLevel = BehaviorFunctions.GetEcoEntityLevel(npcTag)
		local monsterLevel = worldMonsterLevel + self.monsterLevelBias[npcTag]
		if v.lev == 0 and monsterLevel >0 then
			v.lev = monsterLevel
		end


		if pos and rot then
			v.id = BehaviorFunctions.CreateEntity(v.enemyId, nil, pos.x, pos.y, pos.z, nil, nil, nil, self.levelId,20)
			BehaviorFunctions.SetEntityEuler(v.id, rot.x, rot.y, rot.z)
			BehaviorFunctions.SetVCCameraBlend("OperatingCamera","LevelCamera",0)
			self:LevelLookAtPos("enemy1",22002,45)
			self.enemyCount = self.enemyCount + 1
		end
	end
end

function LevelBehavior32000102:Death(instanceId,isFormationRevive)
	for i,v in ipairs(self.enemyList) do
		if v.id == instanceId then
			self.deathCount = self.deathCount + 1
		end
	end
end


function LevelBehavior32000102:AddEntitySign(instanceId,sign)
	--进入神荼2阶段处理
	if instanceId == self.enemyList[1].id and sign == 92003018 then
		--神荼传送
		local bossTP = BehaviorFunctions.GetTerrainPositionP("Center",self.levelId)
		local bossRot = BehaviorFunctions.GetTerrainRotationP("Center",self.levelId)
		BehaviorFunctions.DoSetPositionP(self.enemyList[1].id,bossTP)
		BehaviorFunctions.SetEntityEuler(self.enemyList[1].id,bossRot.x,bossRot.y,bossRot.z)
		--玩家传送
		local PlayerTP = BehaviorFunctions.GetTerrainPositionP("Phase2pb",self.levelId)
		BehaviorFunctions.InMapTransport(PlayerTP.x,PlayerTP.y,PlayerTP.z,false)
		self:LevelLookAtPos("Center",22002,45)
	end
end


function LevelBehavior32000102:RemoveEntitySign(instanceId,sign)
	if instanceId == self.enemyList[1].id and sign == 92003018 then
		BehaviorFunctions.ShowTip(102660101)
	end
end


function LevelBehavior32000102:LevelLookAtPos(pos,type,frame,bindTransform)
	local fp1 = BehaviorFunctions.GetTerrainPositionP(pos,self.levelId)
	local empty = BehaviorFunctions.CreateEntity(2001,nil,fp1.x,fp1.y,fp1.z,nil,nil,nil,self.levelId)
	local camera = BehaviorFunctions.CreateEntity(type,nil,fp1.x,fp1.y,fp1.z,nil,nil,nil,self.levelId)
	--立刻朝向目标点
	BehaviorFunctions.DoLookAtTargetImmediately(self.role,empty)
	if bindTransform then
		BehaviorFunctions.CameraEntityFollowTarget(camera,self.role,bindTransform)
	else
		BehaviorFunctions.CameraEntityFollowTarget(camera,self.role)
	end
	BehaviorFunctions.CameraEntityLockTarget(camera,empty)
	--延迟移除目标和镜头
	BehaviorFunctions.AddDelayCallByFrame(frame,BehaviorFunctions,BehaviorFunctions.RemoveEntity,empty)
	BehaviorFunctions.AddDelayCallByFrame(frame,BehaviorFunctions,BehaviorFunctions.RemoveEntity,camera)
end