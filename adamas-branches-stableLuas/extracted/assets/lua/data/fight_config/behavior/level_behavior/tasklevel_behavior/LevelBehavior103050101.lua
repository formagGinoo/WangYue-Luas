LevelBehavior103050101 = BaseClass("LevelBehavior103050101",LevelBehaviorBase)
--创怪打怪恶来三只

function LevelBehavior103050101:__init(fight)
    self.fight = fight
end

function LevelBehavior103050101.GetGenerates()
    local generates = {790014000,790010200}
    return generates
end

function LevelBehavior103050101:Init()
	self.TaskFightLevel = BehaviorFunctions.CreateBehavior("TaskFightLevel",self)
	self.TaskFightLevel.levelId = self.levelId
    --开放参数
    self.TaskFightLevel.logicName = nil          --如果用的worldLogic就填，不填默认是LevelLogic
    self.TaskFightLevel.mapId = 10020005         --如果是用的worldLogic才有用
    self.TaskFightLevel.wave = 1                 --总波次
	self.TaskFightLevel.isWarn = false            --是否开启警戒
    self.TaskFightLevel.transPos = nil           --设置玩家位置
	self.TaskFightLevel.monsterLevelBias = {     --怪物世界等级偏移
		[FightEnum.EntityNpcTag.Monster] = 0,
		[FightEnum.EntityNpcTag.Elite] = 0,
		[FightEnum.EntityNpcTag.Boss] = 0,
		}
    --怪物列表
    self.TaskFightLevel.monsterList = {
        {entityId = 790014000, posName = "monster1", instanceId = nil, lev = 0, wave = 1, isDead = false},
        {entityId = 790014000, posName = "monster2", instanceId = nil, lev = 0, wave = 1, isDead = false},
        {entityId = 790010200, posName = "monster3", instanceId = nil, lev = 0, wave = 1, isDead = false},
    }
	--插入旁白
	self.attackDialogId = nil             --开打旁白，不配默认没有
	self.isWaveDialog = true             --是否有波次旁白，即刷该波怪的时候播旁白
	self.waveDialogList = {
		{wave = 1, dialogId = 103010401},
	}
end

 
function LevelBehavior103050101:Update()
	self.TaskFightLevel:Update()
end

function LevelBehavior103050101:__delete()

end