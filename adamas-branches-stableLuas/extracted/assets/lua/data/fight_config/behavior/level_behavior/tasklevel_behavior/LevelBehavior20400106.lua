LevelBehavior20400106 = BaseClass("LevelBehavior20400106",LevelBehaviorBase)
--天柜城25分钟流程，通信局关卡
function LevelBehavior20400106:__init(fight)
	self.fight = fight
end


function LevelBehavior20400106.GetGenerates()
	local generates = {900070}
	return generates
end


function LevelBehavior20400106:Init()
	self.role = BehaviorFunctions.GetCtrlEntity()
	self.mapId = 10020004
	self.logicId = "WorldTgc00106"
	self.monsterStateEnum = {
		Default = 0,
		Live = 1,
		Dead = 2,
	}

	self.monsterList =
	{
		[1] = {Id = nil , state = self.monsterStateEnum.Default ,bp = "Enemy1",entityId = 900070,patrolList = nil},
		[2] = {Id = nil , state = self.monsterStateEnum.Default ,bp = "Enemy2",entityId = 900070,patrolList = nil},
		[3] = {Id = nil , state = self.monsterStateEnum.Default ,bp = "Enemy3",entityId = 900070,patrolList = {"Enemy3Patrol1","Enemy3Patrol2"}},
		[4] = {Id = nil , state = self.monsterStateEnum.Default ,bp = "Enemy4",entityId = 900070,patrolList = {"Enemy4Patrol1","Enemy4Patrol2"}},
		[5] = {Id = nil , state = self.monsterStateEnum.Default ,bp = "Enemy5",entityId = 900070,patrolList = nil},
	}
	
	self.dialogStateEnum = {
		Default = 0,
		NotPlaying = 1,
		Playing = 2,
		PlayOver = 3,
	}
	
	self.dialogList =
	{
		[1] = {Id = 202070401,state = self.dialogStateEnum.NotPlaying},--哇！你是什么人……不对，你开的那是什么东西！
		[2] = {Id = 202070601,state = self.dialogStateEnum.NotPlaying},--兄弟们，给我上！
	}
	self.levelInit = false
	self.missionState = 0
end

function LevelBehavior20400106:Update()
	
	--关卡初始化
	if self.levelInit == false then
		self:CreateMonster(self.monsterList)
		self.levelInit = true
	end
	
	if self.dialogList[1].state == self.dialogStateEnum.NotPlaying then
		local result = BehaviorFunctions.CheckPlayerInFight()
		if result then
			BehaviorFunctions.StartStoryDialog(self.dialogList[1].Id)
			self.dialogList[1].state = self.dialogStateEnum.Playing
		end
	end
	
	--检查敌人是否全部死完
	if self.missionState == 0 then
		local listLenth = #self.monsterList
		for i,v in ipairs (self.monsterList) do
			if v.state ~= self.monsterStateEnum.Dead then
				return
			else
				if i == listLenth then
					self.missionState = 1
				end
			end
		end
	
	elseif self.missionState == 1 then
		BehaviorFunctions.SendTaskProgress(302070102,1,1)
		self.missionState = 2
		
	elseif self.missionState == 2 then
		BehaviorFunctions.RemoveLevel(20400106)
	end
end

--召唤列表内怪物
function LevelBehavior20400106:CreateMonster(monsterList)
	for i,v in ipairs (monsterList) do
		local pos = BehaviorFunctions.GetTerrainPositionP(v.bp,self.mapId,self.logicId)
		local rotate = BehaviorFunctions.GetTerrainRotationP(v.bp,self.mapId,self.logicId)
		v.Id = BehaviorFunctions.CreateEntity(v.entityId,nil,pos.x,pos.y,pos.z,nil,nil,nil,self.levelId)
		BehaviorFunctions.SetEntityEuler(v.Id,rotate.x,rotate.y,rotate.z)
		--如果有巡逻列表
		if v.patrolList then
			local patrolPosList = {}
			for index,posName in ipairs(v.patrolList) do
				local pos = BehaviorFunctions.GetTerrainPositionP(posName,self.mapId,self.logicId)
				table.insert(patrolPosList,pos)
			end
			BehaviorFunctions.SetEntityValue(v.Id,"peaceState",1) --设置为巡逻
			BehaviorFunctions.SetEntityValue(v.Id,"patrolPositionList",patrolPosList)--传入巡逻列表
			BehaviorFunctions.SetEntityValue(v.Id,"canReturn",true)--往返设置
		end
		v.state = self.monsterStateEnum.Live
	end
end

function LevelBehavior20400106:Die(attackInstanceId,dieInstanceId)
	for i,v in ipairs(self.monsterList) do
		if dieInstanceId == v.Id then
			v.state = self.monsterStateEnum.Dead
		end
	end
end

function LevelBehavior20400106:Death(instanceId,isFormationRevive)
	
end

function LevelBehavior20400106:AddEntitySign(instanceId,sign)

end

function LevelBehavior20400106:__delete()

end


function LevelBehavior20400106:LevelLookAtPos(pos,type,frame,bindTransform)
	local fp1 = BehaviorFunctions.GetTerrainPositionP(pos,self.levelId)
	local empty = BehaviorFunctions.CreateEntity(2001,nil,fp1.x,fp1.y,fp1.z,nil,nil,nil,self.levelId)
	local camera = BehaviorFunctions.CreateEntity(type,nil,nil,nil,nil,nil,nil,nil,self.levelId)
	--立刻朝向目标点
	BehaviorFunctions.DoLookAtTargetImmediately(self.role,empty)
	if bindTransform then
		BehaviorFunctions.CameraEntityFollowTarget(camera,self.role,bindTransform)
	else
		BehaviorFunctions.CameraEntityFollowTarget(camera,self.role)
	end
	BehaviorFunctions.CameraEntityLockTarget(camera,empty)
	--延迟移除目标和镜头
	BehaviorFunctions.AddDelayCallByFrame(frame,BehaviorFunctions,BehaviorFunctions.SetEntityShowState,camera, false)
	BehaviorFunctions.AddDelayCallByFrame(frame,BehaviorFunctions,BehaviorFunctions.RemoveEntity,empty)
	BehaviorFunctions.AddDelayCallByFrame(frame,BehaviorFunctions,BehaviorFunctions.RemoveEntity,camera)
end

function LevelBehavior20400106:StoryEndEvent(dialogId)
	for i,v in ipairs(self.dialogList) do
		if dialogId == v.Id then
			if dialogId == self.dialogList[1].Id then
				BehaviorFunctions.StartStoryDialog(self.dialogList[2].Id)
			end
			v.state = self.dialogStateEnum.PlayOver
			self.currentDialog = nil
		end
	end
end
