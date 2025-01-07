LevelBehavior101120801 = BaseClass("LevelBehavior101120801",LevelBehaviorBase)
--击败巡卫（101111301打怪旁白）

function LevelBehavior101120801:__init(fight)
	self.fight = fight
end

function LevelBehavior101120801.GetGenerates()
	local generates = {790009001}
	return generates
end

function LevelBehavior101120801:Init()
	self.TaskFightLevel = BehaviorFunctions.CreateBehavior("TaskFightLevel",self)
	self.TaskFightLevel.levelId = self.levelId
	--开放参数
	self.TaskFightLevel.logicName = "Prologue02"          --如果用的worldLogic就填，不填默认是LevelLogic
	self.TaskFightLevel.mapId = 10020005         --如果是用的worldLogic才有用
	self.TaskFightLevel.wave = 1                 --总波次
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
		{entityId = 790009001, posName = "Xunwei", instanceId = nil, lev = 0, wave = 1, isDead = false},
		--第二波
		--{entityId = 900070, posName = "XuantianPos2", instanceId = nil, lev = 1, wave = 2, isDead = false},
		--{entityId = 900071, posName = "XuantianPos021", instanceId = nil, lev = 2, wave = 2, isDead = false},
	}

	--插入旁白
	self.TaskFightLevel.attackDialogId = 101111301             --开打旁白，不配默认没有
	self.TaskFightLevel.isWaveDialog = false             --是否有波次旁白，即刷该波怪的时候播旁白
	self.TaskFightLevel.waveDialogList = {
		--{wave = 2, dialogId = nil},
	}
end

function LevelBehavior101120801:Update()
	self.TaskFightLevel:Update()
end

function LevelBehavior101120801:__delete()

end
