LevelBehavior102030110 = BaseClass("LevelBehavior102030110",LevelBehaviorBase)
--创怪打怪恶来三只

function LevelBehavior102030110:__init(fight)
	self.fight = fight
end

function LevelBehavior102030110.GetGenerates()
	local generates = {790014000}
	return generates
end

function LevelBehavior102030110:Init()
	self.TaskFightLevel = BehaviorFunctions.CreateBehavior("TaskFightLevel",self)
	self.TaskFightLevel.levelId = self.levelId
	--开放参数
	self.TaskFightLevel.logicName = "Main02_1"          --如果用的worldLogic就填，不填默认是LevelLogic
	self.TaskFightLevel.mapId = 10020005         --如果是用的worldLogic才有用
	self.TaskFightLevel.wave = 2                 --总波次
	self.TaskFightLevel.isWarn = true            --是否开启警戒
	self.TaskFightLevel.transPos = nil           --设置玩家位置
	self.TaskFightLevel.imageTipId = nil         --图文教学
	self.TaskFightLevel.monsterLevelBias = {     --怪物世界等级偏移
		[FightEnum.EntityNpcTag.Monster] = -2,
		[FightEnum.EntityNpcTag.Elite] = -2,
		[FightEnum.EntityNpcTag.Boss] = 0,
	}

	--怪物列表
	self.TaskFightLevel.monsterList = {
		--第一波
		{entityId = 790014000, posName = "HunhunJudian", instanceId = nil, lev = 0, wave = 1, isDead = false},
		{entityId = 790014000, posName = "HunhunJudian01", instanceId = nil, lev = 0, wave = 1, isDead = false},
		--第二波
		{entityId = 790014000, posName = "HunhunJudian", instanceId = nil, lev = 0, wave = 2, isDead = false},
		{entityId = 790014000, posName = "HunhunJudian01", instanceId = nil, lev = 0, wave = 2, isDead = false},
		{entityId = 790014000, posName = "HunhunJudian02", instanceId = nil, lev = 0, wave = 2, isDead = false},
	}

	--插入旁白
	self.TaskFightLevel.attackDialogId = nil             --开打旁白，不配默认没有
	self.TaskFightLevel.isWaveDialog = false             --是否有波次旁白，即刷该波怪的时候播旁白
	self.TaskFightLevel.waveDialogList = {
		--{wave = 2, dialogId = nil},
	}
end

function LevelBehavior102030110:Update()
	self.TaskFightLevel:Update()
end

function LevelBehavior102030110:__delete()

end
