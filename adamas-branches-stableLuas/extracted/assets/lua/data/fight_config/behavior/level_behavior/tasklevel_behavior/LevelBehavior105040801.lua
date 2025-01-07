LevelBehavior105040801 = BaseClass("LevelBehavior105040801",LevelBehaviorBase)
--版署主线第三章通用关卡逻辑

function LevelBehavior105040801:__init(fight)
	self.fight = fight
end

function LevelBehavior105040801.GetGenerates()
	local generates = {900070}
	return generates
end

function LevelBehavior105040801:Init()
	self.missionState = 0
    self.role = nil
    self.posName = "Squar01"
	self.deathCount = 0
	self.monsterList = {
        900070
    }
    self.dialogId = 102322401
end

function LevelBehavior105040801:Update()
    self.role = BehaviorFunctions.GetCtrlEntity()
    if self.missionState == 0 then
        local pos = BehaviorFunctions.GetTerrainPositionP("Businessman", 10020004, "MainTask04")
        self.Yigaidui = BehaviorFunctions.CreateEntity(900070, nil, pos.x, pos.y, pos.z, nil, self.levelId)
        BehaviorFunctions.DoLookAtTargetImmediately(self.Yigaidui, self.role)
        self.missionState = 1
    end
end

function LevelBehavior105040801:__delete()

end

--死亡事件
function LevelBehavior105040801:Death(instanceId,isFormationRevive)
    if instanceId == self.Yigaidui then
        self.deathCount = self.deathCount + 1
		if self.deathCount == 1 then
            BehaviorFunctions.StartStoryDialog(self.dialogId)
		end
    end
end

function LevelBehavior105040801:LevelFinish()
	BehaviorFunctions.SendTaskProgress(self.levelId, 1, 1)
	BehaviorFunctions.RemoveLevel(self.levelId)
end

function LevelBehavior105040801:StoryEndEvent(dialogId)
    if dialogId == self.dialogId then
        self:LevelFinish()
    end
end