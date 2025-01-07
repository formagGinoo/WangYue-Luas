LevelBehavior303070104 = BaseClass("LevelBehavior303070104",LevelBehaviorBase)
--普通任务刷怪关
 
function LevelBehavior303070104:__init(fight)
    self.fight = fight
end
 
function LevelBehavior303070104.GetGenerates()
    local generates = {790009001}
    return generates
end
 
function LevelBehavior303070104:Init()
	self.monsterID = 790009001

    self.missionState = 0
    self.role = nil
    self.currentWave = 1          --当前波次
    self.currentWaveNum = 0       --当前波次怪物总数
    self.deathCount = 0           --死亡计数
    self.currentWaveLookAtPos = nil       --当前波次关卡相机朝向
    self.levelShouldFinish = false
    self.palyerCombatArea = false           --玩家是否在战斗区域
    self.combatWall = false                 --空气墙
 
    --开放参数
    -- self.logicName = nil          --如果用的worldLogic就填，不填默认是LevelLogic
    -- self.mapId = 10020005         --如果是用的worldLogic才有用
    self.wave = 1                 --总波次
    self.transPos = nil           --设置玩家位置
    self.monsterLevelBias = {     --怪物世界等级偏移
        [FightEnum.EntityNpcTag.Monster] = 0,
        [FightEnum.EntityNpcTag.Elite] = 0,
        [FightEnum.EntityNpcTag.Boss] = 0,
    }
 
    --怪物列表
    --lev表示固定等级，填0时候才会用偏移等级
    self.monsterList = {
        {entityId = self.monsterID, posName = "monster1", instanceId = nil, lev = 0, wave = 1, isDead = false},
        {entityId = self.monsterID, posName = "monster2", instanceId = nil, lev = 0, wave = 1, isDead = false},
    }
end

function LevelBehavior303070104:Update()
    self.role = BehaviorFunctions.GetCtrlEntity()

    --检测玩家位置创建空气墙
    self.palyerCombatArea = BehaviorFunctions.CheckEntityInArea(self.role,"CombatArea","Logic_Level303070104")
    -- print("检测玩家所在区域")
    if self.palyerCombatArea == true and self.combatWall == false then
        -- print("玩家在区域内")
        BehaviorFunctions.ActiveSceneObj("wall",true,self.levelId)
        -- print("创建空气墙")
        self.combatWall = true
        end
    if self.palyerCombatArea == false then
        -- print("玩家不在区域内")
        BehaviorFunctions.ActiveSceneObj("wall",false,self.levelId)
        -- print("随时移除空气墙")
    end
 
    if self.missionState == 0 then
        --开场自定义功能
        self:CustomLevelFunctions()
        self.missionState = 1
        --第一波刷怪
    elseif self.missionState == 1 then
        self:CreateMonster(self.currentWave)
        self.missionState = 2
        --判断是否还有波次
    elseif self.missionState == self.currentWave + 1 then
        --当前波怪物全死时
        if self.currentWaveAllDie == true then
            --如果仍有后续波次
            if self.wave > self.currentWave then
                self.currentWave = self.currentWave + 1
                self.currentWaveAllDie = false
                --成功击杀所有怪
            elseif self.wave == self.currentWave then
                self.levelShouldFinish = true
                self:LevelFinish()
            end
        end
        --后续波次刷怪
    elseif self.missionState == self.currentWave and self.missionState ~= 1 then
        self:CreateMonster(self.currentWave)
    end
end

function LevelBehavior303070104:__delete()
end

-------------------------函数--------------------------------
--开场自定义功能函数
function LevelBehavior303070104:CustomLevelFunctions()
    --如果需要开场图文教学
    if self.imageTipId then
        BehaviorFunctions.ShowGuideImageTips(self.imageTipId)
    end
    --如果需要同步玩家位置
    if self.transPos then
        local rolePos = BehaviorFunctions.GetTerrainPositionP(self.posName.rolePos, 10020005, "Prologue02")
        BehaviorFunctions.InMapTransport(rolePos.x,rolePos.y,rolePos.z)
    end
end
 
--创怪函数
function LevelBehavior303070104:CreateMonster(wave)
    for i, v in pairs(self.monsterList) do
        --创该波的怪
        local pos = nil
        local rot = nil
        --世界等级偏移计算
        local npcTag = BehaviorFunctions.GetTagByEntityId(v.entityId)
        local worldMonsterLevel = BehaviorFunctions.GetEcoEntityLevel(npcTag)
        local monsterLevel = worldMonsterLevel + self.monsterLevelBias[npcTag]
        if v.lev == 0 and monsterLevel >0 then
            v.lev = monsterLevel
        end
        if v.wave == wave then
            if self.logicName then
                pos = BehaviorFunctions.GetTerrainPositionP(v.posName, self.mapId, self.logicName)
                rot = BehaviorFunctions.GetTerrainRotationP(v.posName, self.mapId, self.logicName)
            else
                pos = BehaviorFunctions.GetTerrainPositionP(v.posName, self.levelId)
                rot = BehaviorFunctions.GetTerrainRotationP(v.posName, self.levelId)
            end
            v.instanceId = BehaviorFunctions.CreateEntity(v.entityId, nil, pos.x, pos.y, pos.z, nil, nil, nil, self.levelId)
            BehaviorFunctions.SetEntityEuler(v.instanceId,rot.x,rot.y,rot.z)
            self.currentWaveNum = self.currentWaveNum + 1
            --看向玩家
            BehaviorFunctions.DoLookAtTargetImmediately(v.instanceId, self.role)
        end
        --设置该波的看向点
        if not self.currentWaveLookAtPos then
            self.currentWaveLookAtPos = pos
        end
    end
    self.missionState = self.missionState + 1
    self:SetLevelCamera()
end
 
--设置关卡相机函数
function LevelBehavior303070104:SetLevelCamera()
    self.empty = BehaviorFunctions.CreateEntity(2001, nil, self.currentWaveLookAtPos.x, self.currentWaveLookAtPos.y + 1, self.currentWaveLookAtPos.z, nil,nil,nil,self.levelId)
    self.levelCam = BehaviorFunctions.CreateEntity(22001)
    BehaviorFunctions.CameraEntityFollowTarget(self.levelCam,self.role,"CameraTarget")
    --看向目标
    BehaviorFunctions.CameraEntityLockTarget(self.levelCam,self.empty)
    BehaviorFunctions.DoLookAtTargetImmediately(self.role,self.empty)
    --延时移除目标和镜头
    BehaviorFunctions.AddDelayCallByFrame(45,BehaviorFunctions,BehaviorFunctions.RemoveEntity,self.levelCam)
    BehaviorFunctions.AddDelayCallByFrame(45,BehaviorFunctions,BehaviorFunctions.RemoveEntity,self.empty)
end
 
--关卡结束函数
function LevelBehavior303070104:LevelFinish()
    BehaviorFunctions.FinishLevel(self.levelId)
end
 
---------------------回调----------------------------------
 
--死亡回调
function LevelBehavior303070104:Death(instanceId,isFormationRevive)
    for i, v in pairs(self.monsterList) do
        if instanceId == v.instanceId and v.isDead == false then
            self.deathCount = self.deathCount + 1
            v.isDead = true
            if self.deathCount == self.currentWaveNum then
                --该波怪物全死
                self.currentWaveAllDie = true
                --参数复原
                self.currentWaveNum = 0
                self.currentWaveLookAtPos = nil
                self.deathCount = 0
            end
        end
    end
end