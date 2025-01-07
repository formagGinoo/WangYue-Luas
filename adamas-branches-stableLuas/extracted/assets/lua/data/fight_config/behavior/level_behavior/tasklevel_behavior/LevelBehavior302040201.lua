LevelBehavior302040201 = BaseClass("LevelBehavior302040201")
--支线任务组：寻找脉灵
--子任务1：进行脉灵追逐游戏
--完成条件：完成交互

--初始化
function LevelBehavior302040201.GetGenerates()
	local generates = {50002, 801200102, 801200104, 801200106, 801200107}
	return generates
end

function LevelBehavior302040201:__init(fight)
	self.fight = fight
end

function LevelBehavior302040201:Init()
	self.me = self.instanceId
    self.role = nil
    -- 距离范围设置为1米，过远距离为50米
    self.distanceLimit = 1
    self.distanceToofar = 50
	self.missionState = 0
    -- 移除实体状态的标志
    self.removedState = 0
    self.removedStatEnum = {
        Panda01 = 0,
		Panda02 = 1,
		Panda03 = 2,
        Panda04 = 3,
        Panda05 = 4,
    }
    -- npc实体是否显示
    self.isShow = false
    self.npcState = 0
    -- 是否重置关卡的标志
    self.shouldReset = false
    -- npc实体是否存在
    self.isNpc = nil

    self.dialogState = 0
	self.dialogStateEnum = {
		Default = 0,
		NotPlaying = 1,
		Play01 = 2,
		Play02 = 3,
	}
	self.dialogList =
	{
		[1] = {Id = 202050401},
		[2] = {Id = 202050501},
        [3] = {Id = 202050601},
        [4] = {Id = 202050701},
        [5] = {Id = 202050801},
	}
end


function LevelBehavior302040201:Update()
	self.role = BehaviorFunctions.GetCtrlEntity()

    local Pos1 = BehaviorFunctions.GetTerrainPositionP("MailingRunPos01", 10020001, "LogicMailing")
    local Pos2 = BehaviorFunctions.GetTerrainPositionP("MailingRunPos02", 10020001, "LogicMailing")
    local Pos3 = BehaviorFunctions.GetTerrainPositionP("MailingRunPos03", 10020001, "LogicMailing")
    local Pos4 = BehaviorFunctions.GetTerrainPositionP("MailingRunPos04", 10020001, "LogicMailing")


    if self.missionState == 0 then
        -- 创建熊猫实体1 
        self.pandaEntity01 = BehaviorFunctions.CreateEntity(50002, self.me, Pos1.x, Pos1.y, Pos1.z)
        self.fxEntity00 = BehaviorFunctions.CreateEntity(801200104, self.pandaEntity01, Pos1.x, Pos1.y, Pos1.z) --爱心特效pos1
        BehaviorFunctions.DoLookAtTargetImmediately(self.pandaEntity01, self.role)
        BehaviorFunctions.PlayAnimation(self.pandaEntity01, "Stand2") --播放动画
        self.missionState = 1

        -- 播放对话1
        BehaviorFunctions.StartStoryDialog(self.dialogList[1].Id)
    end

    local playerPos = BehaviorFunctions.GetPositionP(self.role)
    local distance1 = BehaviorFunctions.GetDistanceFromPos(playerPos, Pos1)
    local distance2 = BehaviorFunctions.GetDistanceFromPos(playerPos, Pos2)
    local distance3 = BehaviorFunctions.GetDistanceFromPos(playerPos, Pos3)
    local distance4 = BehaviorFunctions.GetDistanceFromPos(playerPos, Pos4)

    if self.removedState == self.removedStatEnum.Panda01 and distance1 <= self.distanceLimit then
        --移除熊猫实体1
        BehaviorFunctions.CreateEntity(801200102, self.me, Pos1.x, Pos1.y, Pos1.z) --消失特效
        BehaviorFunctions.RemoveEntity(self.pandaEntity01) 
        
        --创建熊猫实体2
        self.pandaEntity02 = BehaviorFunctions.CreateEntity(50002, self.me, Pos2.x, Pos2.y, Pos2.z)
        self.fxEntity02 = BehaviorFunctions.CreateEntity(801200104, self.pandaEntity02, Pos2.x, Pos2.y, Pos2.z) --爱心特效pos2
        BehaviorFunctions.DoLookAtTargetImmediately(self.pandaEntity02, self.role)
        BehaviorFunctions.PlayAnimation(self.pandaEntity02, "ExceptionLoop") --播放动画
        self.AniDelay01 = BehaviorFunctions.AddDelayCallByTime(5, BehaviorFunctions, BehaviorFunctions.PlayAnimation, self.pandaEntity02, "Stand2")  --兴奋跳动作

        -- 播放对话2
        BehaviorFunctions.StartStoryDialog(self.dialogList[2].Id)
        self.removedState = 1

    elseif self.removedState == self.removedStatEnum.Panda02 and distance2 <= self.distanceLimit then 
        --移除熊猫实体2
        BehaviorFunctions.CreateEntity(801200107, self.me, Pos2.x, Pos2.y, Pos2.z) --消失特效
        BehaviorFunctions.RemoveEntity(self.pandaEntity02) 
        BehaviorFunctions.RemoveDelayCall(self.AniDelay01)

        --在pos3创建新熊猫实体3
        self.pandaEntity03 = BehaviorFunctions.CreateEntity(50002, self.me, Pos3.x, Pos3.y, Pos3.z)
        self.fxEntity04 = BehaviorFunctions.CreateEntity(801200104, self.pandaEntity03, Pos3.x, Pos3.y, Pos3.z) --爱心特效pos3
        BehaviorFunctions.DoLookAtTargetImmediately(self.pandaEntity03, self.role)
        BehaviorFunctions.PlayAnimation(self.pandaEntity03, "HappyEat") --播放动画
        self.AniDelay02 = BehaviorFunctions.AddDelayCallByTime(3, BehaviorFunctions, BehaviorFunctions.PlayAnimation, self.pandaEntity03, "Stand2")  --兴奋跳动作

        -- 播放对话3
        BehaviorFunctions.StartStoryDialog(self.dialogList[3].Id)
        self.removedState = 2

    elseif self.removedState == self.removedStatEnum.Panda03 and distance3 <= self.distanceLimit then
        --移除熊猫实体3
        BehaviorFunctions.CreateEntity(801200102, self.me, Pos3.x, Pos3.y, Pos3.z) --消失特效
        BehaviorFunctions.RemoveEntity(self.pandaEntity03)
        BehaviorFunctions.RemoveDelayCall(self.AniDelay02)

        --在pos4创建新熊猫实体4
        BehaviorFunctions.CreateEntity(801200106, self.me, Pos4.x, Pos4.y, Pos4.z) --烟花特效
        self.pandaEntity04 = BehaviorFunctions.CreateEntity(50002, self.me, Pos4.x, Pos4.y, Pos4.z)
        self.fxEntity07 = BehaviorFunctions.CreateEntity(801200104, self.pandaEntity04, Pos4.x, Pos4.y, Pos4.z) --爱心特效pos4
        BehaviorFunctions.DoLookAtTargetImmediately(self.pandaEntity04, self.role)
        BehaviorFunctions.PlayAnimation(self.pandaEntity04, "Born") --播放动画
        self.AniDelay03 = BehaviorFunctions.AddDelayCallByTime(2, BehaviorFunctions, BehaviorFunctions.PlayAnimation, self.pandaEntity04, "DisapointLoop")  --沮丧动作

        -- 播放对话4
        BehaviorFunctions.StartStoryDialog(self.dialogList[4].Id)

        self.removedState = 3
       
    elseif self.removedState == 3 and distance4 <= self.distanceLimit then
        -- 移除熊猫实体4
        BehaviorFunctions.RemoveEntity(self.pandaEntity04)
        BehaviorFunctions.RemoveDelayCall(self.AniDelay03)

        -- 播放对话5
        BehaviorFunctions.StartStoryDialog(self.dialogList[5].Id)
        self.removedState = 4
    end

    if not self.removedState == 0 then
        local distance = BehaviorFunctions.GetDistanceFromPos(playerPos, Pos1)
        if distance > self.distanceToofar then
            self.shouldReset = true
        end
    end

    -- 如果需要重置关卡，则将所有设置和状态复原
    if self.shouldReset then
        Behavior20009.MailingReset()
    end
end

--对话5播完卸载关卡
function LevelBehavior302040201:StoryEndEvent(dialogId)
    if dialogId == self.dialogList[5].Id then
        BehaviorFunctions.RemoveLevel(302040201)
    end
end

--重置
function Behavior20009:MailingReset()
    if self.shouldReset then
        if self.removedState == 0 then
            BehaviorFunctions.RemoveEntity(self.pandaEntity01)
        elseif self.removedState == 1 then
            BehaviorFunctions.RemoveEntity(self.pandaEntity02)
            
        elseif self.removedState == 2 then
            BehaviorFunctions.RemoveEntity(self.pandaEntity03)
        elseif self.removedState == 3 then
            BehaviorFunctions.RemoveEntity(self.pandaEntity04)
            self.isShow = false
        BehaviorFunctions.SetEntityShowState(self.npcInstanceId, self.isShow)
        end

        -- 重置标志位
        self.removedState = 0
        self.shouldReset = false
        self.missionState = 0
    end
end

function Behavior20009:Death(instanceId,isFormationRevive)
    --角色死亡重置
    if isFormationRevive then
        self.shouldReset = true
    end
end
