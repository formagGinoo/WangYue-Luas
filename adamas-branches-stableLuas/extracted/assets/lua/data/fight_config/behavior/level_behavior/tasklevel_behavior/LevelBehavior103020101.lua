LevelBehavior103020101 = BaseClass("LevelBehavior103020101",LevelBehaviorBase)
--饭店外战斗

function LevelBehavior103020101:__init(fight)
    self.fight = fight
end

function LevelBehavior103020101.GetGenerates()
    local generates = {790007001}
    return generates
end

function LevelBehavior103020101:Init()
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
        {entityId = 790007001, posName = "monster1", instanceId = nil, lev = 0, wave = 1, isDead = false},
        {entityId = 790007001, posName = "monster2", instanceId = nil, lev = 0, wave = 1, isDead = false},
    }
end

 
function LevelBehavior103020101:Update()
	self.TaskFightLevel:Update()
end

function LevelBehavior103020101:__delete()

end