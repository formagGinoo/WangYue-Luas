LevelBehavior103040101 = BaseClass("LevelBehavior103040101",LevelBehaviorBase)
--饭店室内战斗

function LevelBehavior103040101:__init(fight)
    self.fight = fight
end

function LevelBehavior103040101.GetGenerates()
    local generates = {790014000,790010200}
    return generates
end

function LevelBehavior103040101:Init()
	self.TaskFightLevel = BehaviorFunctions.CreateBehavior("TaskFightLevel",self)
	self.TaskFightLevel.levelId = self.levelId
    --开放参数
    self.TaskFightLevel.logicName = nil          --如果用的worldLogic就填，不填默认是LevelLogic
    self.TaskFightLevel.mapId = 10020005         --如果是用的worldLogic才有用
    self.TaskFightLevel.wave = 1                 --总波次
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

 
function LevelBehavior103040101:Update()
	self.TaskFightLevel:Update()
end
--本关特殊逻辑：快结束了说句话
function LevelBehavior103040101:Die(attackInstanceId,dieInstanceId, deathReason)
	--剩一只怪旁白
	if self.TaskFightLevel.deathCount == self.TaskFightLevel.currentWaveNum - 1 then
		BehaviorFunctions.StartStoryDialog(103010801)
	end
end

function LevelBehavior103040101:__delete()

end