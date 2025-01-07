--逻辑：
--20500本身是一个空实体，放置在pos1；
--在lua逻辑里，在该位置创建一个熊猫实体；
--通过距离判断（进入该初始点位1米范围内），移除该实体，并在pos2创建一个新实体；
--通过距离判定（等到玩家进入pos2的1米范围内），移除该实体，并在pos3创建一个新实体；
--通过距离判定（等到玩家进入pos3的1米范围内），移除该实体，并在pos4创建一个新实体；
--通过距离判定（等到玩家进入pos4的1米范围内），移除该实体，并接触对npc实体的隐藏；
--1.当玩家的距离离实体20500过远（大于50米）或玩家死亡时，重置该关卡，将所有设置和状态复原
--2.当该npc实体被成功解除隐藏时，移除20500这个实体

--追逐脉灵
Behavior20500 = BaseClass("Behavior20500",EntityBehaviorBase)

--初始化
function Behavior20500.GetGenerates()
	local generates = {50002, 801200102, 801200104, 801200106, 801200107}
	return generates
end

function Behavior20500:Init()
	self.me = self.instanceId
	self.role = BehaviorFunctions.GetCtrlEntity()

    -- 距离范围设置为1米，过远距离为50米
    self.distanceLimit = 1
    self.distanceToofar = 50

	self.missionState = 0

    -- 移除实体状态的标志
    self.removedState = 0

    -- npc实体是否显示
    self.isShow = false
    self.npcState = 0

    -- 是否重置关卡的标志
    self.shouldReset = false

    -- npc实体是否存在
    self.isNpc = nil
end


function Behavior20500:Update()
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
    end

    -- 获取NPC实体并隐藏
    if self.npcState == 0 then
        self.npcEntity = BehaviorFunctions.GetNpcEntity(80310)

        if self.npcEntity then
            self.npcInstanceId = self.npcEntity.instanceId
            --传值激发特殊隐藏状态
            if self.npcInstanceId then
                BehaviorFunctions.SetEntityValue(self.npcInstanceId, "specialHide", true)
                BehaviorFunctions.SetEntityShowState(self.npcInstanceId, self.isShow)
                self.npcState = 1
            end
        end
    end

    --[[
    if self.missionState == 1 and self.npcEntity then
        self.npcInstanceId = self.npcEntity.instanceId
        --传值激发特殊隐藏状态
        BehaviorFunctions.SetEntityValue(self.npcInstanceId, "specialHide", true)
        BehaviorFunctions.SetEntityShowState(self.npcInstanceId, self.isShow)
        self.missionState = 2
    end
    --]]

    local playerPos = BehaviorFunctions.GetPositionP(self.role)
    local distance1 = BehaviorFunctions.GetDistanceFromPos(playerPos, Pos1)
    local distance2 = BehaviorFunctions.GetDistanceFromPos(playerPos, Pos2)
    local distance3 = BehaviorFunctions.GetDistanceFromPos(playerPos, Pos3)
    local distance4 = BehaviorFunctions.GetDistanceFromPos(playerPos, Pos4)

    if self.removedState == 0 and distance1 <= self.distanceLimit then
        -- 移除熊猫实体1
        --BehaviorFunctions.RemoveEntity(self.fxEntity00) --移除爱心特效pos1
        BehaviorFunctions.CreateEntity(801200102, self.me, Pos1.x, Pos1.y, Pos1.z) --消失特效
        --BehaviorFunctions.PlayAnimation(self.pandaEntity01, "ByeBye") --播放离开动画

        --BehaviorFunctions.AddDelayCallByTime(3, BehaviorFunctions, BehaviorFunctions.RemoveEntity, self.pandaEntity01) 
        BehaviorFunctions.RemoveEntity(self.pandaEntity01)
        
        --在pos2创建新熊猫实体2
        --self.fxEntity02 = BehaviorFunctions.AddDelayCallByTime(3, BehaviorFunctions, BehaviorFunctions.CreateEntity, 801200104, self.me, Pos2.x, Pos2.y, Pos2.z) 
        --self.pandaEntity02 = BehaviorFunctions.AddDelayCallByTime(3, BehaviorFunctions, BehaviorFunctions.CreateEntity, 50002, self.me, Pos2.x, Pos2.y, Pos2.z) 
        
        self.pandaEntity02 = BehaviorFunctions.CreateEntity(50002, self.me, Pos2.x, Pos2.y, Pos2.z)
        self.fxEntity02 = BehaviorFunctions.CreateEntity(801200104, self.pandaEntity02, Pos2.x, Pos2.y, Pos2.z) --爱心特效pos2
        BehaviorFunctions.DoLookAtTargetImmediately(self.pandaEntity02, self.role)

        --BehaviorFunctions.AddDelayCallByTime(3.1, BehaviorFunctions, BehaviorFunctions.PlayAnimation, self.pandaEntity02, "ExceptionLoop") 
        BehaviorFunctions.PlayAnimation(self.pandaEntity02, "ExceptionLoop") --播放动画
        self.AniDelay01 = BehaviorFunctions.AddDelayCallByTime(5, BehaviorFunctions, BehaviorFunctions.PlayAnimation, self.pandaEntity02, "Stand2")  --兴奋跳动作

        self.removedState = 1

    elseif self.removedState == 1 and distance2 <= self.distanceLimit then 
        -- 移除熊猫实体2
        BehaviorFunctions.CreateEntity(801200107, self.me, Pos2.x, Pos2.y, Pos2.z) --消失特效
        --BehaviorFunctions.RemoveEntity(self.fxEntity02) --移除爱心特效pos2
        --BehaviorFunctions.PlayAnimation(self.pandaEntity02, "ByeBye") --播放离开动画

        --BehaviorFunctions.AddDelayCallByTime(3, BehaviorFunctions, BehaviorFunctions.RemoveEntity, self.pandaEntity02) 
        BehaviorFunctions.RemoveEntity(self.pandaEntity02) 
        BehaviorFunctions.RemoveDelayCall(self.AniDelay01)

        --在pos3创建新熊猫实体3
        self.pandaEntity03 = BehaviorFunctions.CreateEntity(50002, self.me, Pos3.x, Pos3.y, Pos3.z)
        self.fxEntity04 = BehaviorFunctions.CreateEntity(801200104, self.pandaEntity03, Pos3.x, Pos3.y, Pos3.z) --爱心特效pos3
        BehaviorFunctions.DoLookAtTargetImmediately(self.pandaEntity03, self.role)

        BehaviorFunctions.PlayAnimation(self.pandaEntity03, "HappyEat") --播放动画
        self.AniDelay02 = BehaviorFunctions.AddDelayCallByTime(3, BehaviorFunctions, BehaviorFunctions.PlayAnimation, self.pandaEntity03, "Stand2")  --兴奋跳动作
        self.removedState = 2

    elseif self.removedState == 2 and distance3 <= self.distanceLimit then
        -- 移除熊猫实体3
        BehaviorFunctions.CreateEntity(801200102, self.me, Pos3.x, Pos3.y, Pos3.z) --消失特效
        --BehaviorFunctions.RemoveEntity(self.fxEntity04)
        --BehaviorFunctions.PlayAnimation(self.pandaEntity03, "ByeBye") --播放离开动画

        --BehaviorFunctions.AddDelayCallByTime(3, BehaviorFunctions, BehaviorFunctions.RemoveEntity, self.pandaEntity03) 
        BehaviorFunctions.RemoveEntity(self.pandaEntity03)
        BehaviorFunctions.RemoveDelayCall(self.AniDelay02)

        --在pos4创建新熊猫实体4
        BehaviorFunctions.CreateEntity(801200106, self.me, Pos4.x, Pos4.y, Pos4.z) --烟花特效
        self.pandaEntity04 = BehaviorFunctions.CreateEntity(50002, self.me, Pos4.x, Pos4.y, Pos4.z)
        self.fxEntity07 = BehaviorFunctions.CreateEntity(801200104, self.pandaEntity04, Pos4.x, Pos4.y, Pos4.z) --爱心特效pos4
        BehaviorFunctions.DoLookAtTargetImmediately(self.pandaEntity04, self.role)

        BehaviorFunctions.PlayAnimation(self.pandaEntity04, "Born") --播放动画
        self.AniDelay03 = BehaviorFunctions.AddDelayCallByTime(2, BehaviorFunctions, BehaviorFunctions.PlayAnimation, self.pandaEntity04, "Stand2")  --兴奋跳动作
        self.removedState = 3
       
    elseif self.removedState == 3 and distance4 <= self.distanceLimit then
        -- 移除熊猫实体4，并解除对NPC实体的隐藏
        --BehaviorFunctions.RemoveEntity(self.fxEntity07) --移除爱心特效pos4
        BehaviorFunctions.RemoveEntity(self.pandaEntity04)
        BehaviorFunctions.RemoveDelayCall(self.AniDelay03)
        self.isShow = true
        
        if self.isShow and self.npcEntity then
            BehaviorFunctions.SetEntityValue(self.npcInstanceId, "specialHide", false)
            BehaviorFunctions.SetEntityShowState(self.npcInstanceId, self.isShow)
        end
    end

    if not self.removedState == 0 then
        local distance = BehaviorFunctions.GetDistanceFromPos(playerPos, Pos1)
        if distance > self.distanceToofar then
            self.shouldReset = true
        end
    end

    -- 如果需要重置关卡，则将所有设置和状态复原
    if self.shouldReset then
        if self.removedState == 0 then
            BehaviorFunctions.RemoveEntity(self.pandaEntity01)
            --BehaviorFunctions.RemoveEntity(self.fxEntity00) --移除爱心特效pos1
        elseif self.removedState == 1 then
            BehaviorFunctions.RemoveEntity(self.pandaEntity02)
            
        elseif self.removedState == 2 then
            BehaviorFunctions.RemoveEntity(self.pandaEntity03)
        elseif self.removedState == 3 then
            BehaviorFunctions.RemoveEntity(self.pandaEntity04)
            self.isShow = false
        BehaviorFunctions.SetEntityShowState(self.npcInstanceId, self.isShow)
        end
        
        -- 重新创建初始熊猫实体（entityApple01）
        --self.fxEntity00 = BehaviorFunctions.CreateEntity(801200104, self.me, Pos1.x, Pos1.y, Pos1.z) --爱心特效pos1
        --self.pandaEntity01 = BehaviorFunctions.CreateEntity(50002, self.me, Pos1.x, Pos1.y, Pos1.z)
        --BehaviorFunctions.DoLookAtTargetImmediately(self.pandaEntity01, self.role)

        -- 重置标志位
        self.removedState = 0
        self.shouldReset = false
        self.missionState = 0
    end

    -- 当NPC实体被成功解除隐藏时，移除实体20500
    if self.isShow then
        BehaviorFunctions.InteractEntityHit(self.me)
        --BehaviorFunctions.RemoveEntity(self.me)
    end

end

function Behavior20500:Death(instanceId,isFormationRevive)
    --角色死亡重置
    if isFormationRevive then
        self.shouldReset = true
    end
end

function Behavior20500:RemoveEntity(instanceId)
	if instanceId == self.me then
		self:LevelRemoveEntity(self.pandaEntity01)
		self:LevelRemoveEntity(self.pandaEntity02)
		self:LevelRemoveEntity(self.pandaEntity03)
		self:LevelRemoveEntity(self.pandaEntity04)
		self:LevelRemoveEntity(self.fxEntity00)
		self:LevelRemoveEntity(self.fxEntity02)
		self:LevelRemoveEntity(self.fxEntity04)
		self:LevelRemoveEntity(self.fxEntity07)
	end
end

function Behavior20500:LevelRemoveEntity(instanceId)
	if instanceId and BehaviorFunctions.CheckEntity(instanceId) then
		BehaviorFunctions.RemoveEntity(instanceId)
	end
end