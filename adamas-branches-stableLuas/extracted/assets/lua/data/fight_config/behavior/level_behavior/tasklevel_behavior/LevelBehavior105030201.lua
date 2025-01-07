LevelBehavior105030201 = BaseClass("LevelBehavior105030201",LevelBehaviorBase)
--击败悬天的关卡

function LevelBehavior105030201:__init(fight)
	self.fight = fight
end

function LevelBehavior105030201.GetGenerates()
	local generates = {900070, 900080}
	return generates
end

function LevelBehavior105030201:Init()
	self.missionState = 0
    self.role = nil
    self.posName = "Building"
	self.deathCount = 0
	self.monsterList = {
        900070
    }
    self.dialogId = 102310901
end

function LevelBehavior105030201:Update()
	self.role = BehaviorFunctions.GetCtrlEntity()
    self:CreateMonster()
end

function LevelBehavior105030201:__delete()

end

--在某个点附近创建怪
function LevelBehavior105030201:CreateMonster()
    if self.missionState == 0 then
        local pos = BehaviorFunctions.GetTerrainPositionP(self.posName, 10020004, "MainTask04")
        local posMe = BehaviorFunctions.GetPositionP(self.role)
        local distanceXZ = BehaviorFunctions.GetDistanceFromPos(pos, posMe)
        local distanceY = math.abs(pos.y- posMe.y)
        if distanceXZ < 30 and distanceY < 20 then
            self.monster1 = BehaviorFunctions.CreateEntity(self.monsterList[1], nil, pos.x+1, pos.y, pos.z, nil, nil, nil, self.levelId)
            self.monster2 = BehaviorFunctions.CreateEntity(self.monsterList[1], nil, pos.x-5, pos.y, pos.z, nil, nil, nil, self.levelId)
            BehaviorFunctions.DoLookAtTargetImmediately(self.monster1, self.role)
            BehaviorFunctions.DoLookAtTargetImmediately(self.monster2, self.role)
            self.missionState = 1
        end
    end
end

--死亡事件
function LevelBehavior105030201:Death(instanceId,isFormationRevive)
    if instanceId == self.monster1 or instanceId == self.monster2 or instanceId == self.monster3 or instanceId == self.monster4 then
        self.deathCount = self.deathCount + 1
		if self.deathCount == 2 then
            BehaviorFunctions.StartStoryDialog(self.dialogId)			
		end
    end
end

function LevelBehavior105030201:LevelFinish()
	BehaviorFunctions.SendTaskProgress(self.levelId, 1, 1)
	BehaviorFunctions.RemoveLevel(self.levelId)
end

function LevelBehavior105030201:StoryEndEvent(dialogId)
    if dialogId == self.dialogId then
        self:LevelFinish()
    end
end