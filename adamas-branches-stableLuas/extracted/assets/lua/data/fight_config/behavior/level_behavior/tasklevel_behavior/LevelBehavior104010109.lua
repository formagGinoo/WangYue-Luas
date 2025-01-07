
LevelBehavior104010109 = BaseClass("104010109",LevelBehaviorBase)
--第四章巡卫恶来争吵

function LevelBehavior104010109:__init(fight)
	self.fight = fight
end

function LevelBehavior104010109.GetGenerates()
	local generates =
	{
		790009001,   --巡卫
		790014000,  --恶来卒
	}
	return generates
end

function LevelBehavior104010109:Init()

	self.missionState = 0

	self.role = nil

	--怪物状态
	self.monsterStateEnum =
	{
		Default = 0,
		Live = 1,
		Dead = 2,
	}

	--怪物列表
	self.monsterList =
	{
		[1] = {state = self.monsterStateEnum.Default, bornPos = "xunwei01", entityId = 790009001, id = nil, lev = 0},
		[2] = {state = self.monsterStateEnum.Default, bornPos = "elai01", entityId = 790014000, id = nil, lev = 0},
	}
	
	--怪物世界等级偏移
	self.monsterLevelBias = {
		[FightEnum.EntityNpcTag.Monster] = 0,
		[FightEnum.EntityNpcTag.Elite] = 0,
		[FightEnum.EntityNpcTag.Boss] = 0,
	}

	self.GuideTypeEnum =
	{
		Task = FightEnum.GuideType.Task,
		Challenge = FightEnum.GuideType.Rogue_Challenge,
		Riddle = FightEnum.GuideType.Rogue_Riddle,
	}
	
	--怪物死亡数量
	self.dieCount = 0
	
	--设置玩家位置
	self.transPos = "rolePos"
	
end

function LevelBehavior104010109:Update()
	--角色为当前玩家操作角色
	self.role = BehaviorFunctions.GetCtrlEntity()
	
	--创怪
	if self.missionState == 0 then
		
		--设置玩家位置
		if self.transPos then
			local rolePos = nil
			if self.logicName then
				rolePos = BehaviorFunctions.GetTerrainPositionP(self.transPos, self.mapId, self.logicName)
			else
				rolePos = BehaviorFunctions.GetTerrainPositionP(self.transPos, self.levelId)
			end
			BehaviorFunctions.InMapTransport(rolePos.x,rolePos.y,rolePos.z)
		end
		
		BehaviorFunctions.StartStoryDialog(104020401)
		BehaviorFunctions.ShowTip(100000001,"让他们冷静下来")
		--获取玩家与战场距离
		--local pos1 = BehaviorFunctions.GetTerrainPositionP("LookAt01", self.levelId)
		--self.empty1 = BehaviorFunctions.CreateEntity(2001, nil, pos1.x, pos1.y, pos1.z, nil, nil, nil, self.levelId, nil)
		self:CreateMonster(self.monsterList)
		self:SetLevelCamera()
		self:SetCombatTarget(self.monsterList)
		self.missionState = 1
	end

	----根据距离显示图标
	--if BehaviorFunctions.GetDistanceFromTarget(self.role, self.empty1, false) < 10 then --小于10米时，隐藏指引图标

		--BehaviorFunctions.SetGuideShowState(FightEnum.GuideType.Task, false)
	--else
		--BehaviorFunctions.SetGuideShowState(FightEnum.GuideType.Task, true)
	--end
	
	--关卡成功入口
	if self.missionState == 10 then
		--调用关卡完成函数
		BehaviorFunctions.FinishLevel(self.levelId)
		BehaviorFunctions.HideTip()
		self.missionState = 11
	end

	----角色死亡入口
	--if self.missionState == 11 then
		----调用关卡完成函数
		--BehaviorFunctions.RemoveLevel(self.levelId)
		--self.missionState = 12
	--end
	
end

--创怪
function LevelBehavior104010109:CreateMonster(monsterList)
	for k,v in ipairs(monsterList) do 
		--世界等级偏移计算
		local npcTag = BehaviorFunctions.GetTagByEntityId(v.entityId)
		local worldMonsterLevel = BehaviorFunctions.GetEcoEntityLevel(npcTag)
		local monsterLevel = worldMonsterLevel + self.monsterLevelBias[npcTag]
		if v.lev == 0 and monsterLevel > 0 then
			v.lev = monsterLevel
		end
		local pos = BehaviorFunctions.GetTerrainPositionP(monsterList[k].bornPos, self.levelId)
		monsterList[k].id = BehaviorFunctions.CreateEntity(monsterList[k].entityId,nil,pos.x,pos.y,pos.z,nil,nil,nil,self.levelId,monsterLevel)
		--创建时看向玩家
		BehaviorFunctions.DoLookAtTargetImmediately(monsterList[k].id,self.role)
		--创建后修改状态
		v.state = self.monsterStateEnum.Live
	end
end

--修改怪物攻击目标以及怪物战斗状态
function LevelBehavior104010109:SetCombatTarget(monsterList)
	for i,v in ipairs(monsterList) do
		if v.state == self.monsterStateEnum.Live then
			BehaviorFunctions.SetEntityValue(v.id, "haveWarn", false)
			BehaviorFunctions.SetEntityValue(v.id, "battleTarget", self.role)
			BehaviorFunctions.SetEntityValue(v.id, "targetMaxRange", 50)
		end
	end
end

--设置关卡相机函数
function LevelBehavior104010109:SetLevelCamera()
	local pos = BehaviorFunctions.GetTerrainPositionP("xunwei01",self.levelId)
	self.empty = BehaviorFunctions.CreateEntity(2001, nil, pos.x, pos.y + 1, pos.z)
	self.levelCam = BehaviorFunctions.CreateEntity(22001)
	BehaviorFunctions.CameraEntityFollowTarget(self.levelCam,self.role,"CameraTarget")
	--看向目标
	BehaviorFunctions.CameraEntityLockTarget(self.levelCam,self.empty)
	BehaviorFunctions.DoLookAtTargetImmediately(self.role,self.empty)
	--延时移除目标和镜头
	BehaviorFunctions.AddDelayCallByFrame(45,BehaviorFunctions,BehaviorFunctions.RemoveEntity,self.levelCam)
	BehaviorFunctions.AddDelayCallByFrame(45,BehaviorFunctions,BehaviorFunctions.RemoveEntity,self.empty)
end

--死亡事件
function LevelBehavior104010109:Death(instanceId,isFormationRevive)

	for k,v in ipairs(self.monsterList) do
		if instanceId == v.id then
			v.state = self.monsterStateEnum.Dead
		end
	end
	
	--战斗快结束时播放旁白
	for k,v in ipairs(self.monsterList) do
		if instanceId == v.id then
			self.dieCount = self.dieCount + 1
		end
		if self.dieCount == 1 then
			BehaviorFunctions.StartStoryDialog(104020301)
			self.dieCount = 99
		end
	end

	--怪物死亡状态判断
	local monsterList = self.monsterList
	local listLenth = #monsterList
	for i,j in ipairs (monsterList) do
		if j.state ~= self.monsterStateEnum.Dead then
			return
		else
			if i == listLenth then
				self.missionState = 10
			end
		end
	end
end