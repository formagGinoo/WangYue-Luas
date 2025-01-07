LevelBehavior103080101 = BaseClass("LevelBehavior103080101",LevelBehaviorBase)
--去柱子上拿东西，东西用logic处理了

function LevelBehavior103080101:__init(fight)
    self.fight = fight
end

function LevelBehavior103080101.GetGenerates()
    local generates = {}
    return generates
end

function LevelBehavior103080101:Init()
    self.missionState = 0
    self.role = nil
    self.currentWave = 1          --当前波次
    self.currentWaveNum = 0       --当前波次怪物总数
    self.deathCount = 0           --死亡计数
    self.currentWaveLookAtPos = nil       --当前波次关卡相机朝向点

    --开放参数
    self.logicName = nil       --如果用的worldLogic就填，不填默认是LevelLogic
    self.mapId = 10020005                  --如果是用的worldLogic才有用
    self.wave = 1                          --总波次
    self.transPos = nil                   --设置玩家位置

    --怪物列表
    self.monsterList = {
        {entityId = 900040, posName = "monster1", instanceId = nil, lev = 2, wave = 1, isDead = false},
        {entityId = 900040, posName = "monster2", instanceId = nil, lev = 2, wave = 1, isDead = false},
        {entityId = 900040, posName = "monster3", instanceId = nil, lev = 2, wave = 1, isDead = false},
    }
end
 
function LevelBehavior103080101:Update()
    self.role = BehaviorFunctions.GetCtrlEntity()

    if self.missionState == 0 then
        --创建指引
        local pos = BehaviorFunctions.GetTerrainPositionP("dongxi",self.levelId)
        self.guide = BehaviorFunctions.CreateEntity(200000108,nil,pos.x,pos.y,pos.z)
        self.missionState = 1
    elseif self.missionState == 1 then
        if self.guide then
            local pos = BehaviorFunctions.GetDistanceFromTarget(self.role,self.guide)
            if pos <= 3 then
                self.enter = true
            else
                self.enter = false
            end
            --交互列表
            if self.enter then
                if self.isTrigger then
                    return
                end
                self.isTrigger = self.guide
                if not self.isTrigger then
                    return
                end
                self.interactUniqueId = BehaviorFunctions.WorldInteractActive(self.guide,WorldEnum.InteractType.Unlock,nil,"捡起",1)
            else
                if self.isTrigger  then
                    self.isTrigger = false
                    BehaviorFunctions.WorldInteractRemove(self.guide,self.interactUniqueId)
                end
            end
        end
    end
end

function LevelBehavior103080101:__delete()

end

function LevelBehavior103080101:WorldInteractClick(uniqueId)
	if self.interactUniqueId and self.interactUniqueId == uniqueId then
		BehaviorFunctions.RemoveEntity(self.guide)
		self.guide = nil
        BehaviorFunctions.FinishLevel(self.levelId)  
	end
end