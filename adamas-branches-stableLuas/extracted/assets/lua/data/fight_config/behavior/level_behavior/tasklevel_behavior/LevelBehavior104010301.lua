LevelBehavior104010301 = BaseClass("LevelBehavior104010301",LevelBehaviorBase)
--版署主线第三章通用关卡逻辑

function LevelBehavior104010301:__init(fight)
	self.fight = fight
end

function LevelBehavior104010301.GetGenerates()
	local generates = {
        900040,   --木从士
        900041,   --火从士
        900042,   --冰从士
        900030,   --木盾从士
        900050,   --木弓从士
        900051,   --火弓从士
        910040,   --精英从士
        900060,   --水尾狐
    }
	return generates
end

function LevelBehavior104010301:Init()
	self.missionState = 0
    self.role = nil
    self.posName = "Judian"
	self.deathCount = 0
	self.monsterList = {
        900040,900041,900042
    }
end

function LevelBehavior104010301:Update()
	self.role = BehaviorFunctions.GetCtrlEntity()
    self:CreateMonster()
end

function LevelBehavior104010301:__delete()

end

--在某个点附近创建怪
function LevelBehavior104010301:CreateMonster()
    if self.missionState == 0 then
        local pos = BehaviorFunctions.GetTerrainPositionP(self.posName, 10020001, "MainTask03")
        local posMe = BehaviorFunctions.GetPositionP(self.role)
        local distanceXZ = BehaviorFunctions.GetDistanceFromPos(pos, posMe)
        local distanceY = math.abs(pos.y- posMe.y)
        if distanceXZ < 30 and distanceY < 20 then
            self.monster1 = BehaviorFunctions.CreateEntity(self.monsterList[1], nil, pos.x+1, pos.y, pos.z, nil, nil, nil, self.levelId)
            self.monster2 = BehaviorFunctions.CreateEntity(self.monsterList[1], nil, pos.x-5, pos.y, pos.z, nil, nil, nil, self.levelId)
            self.monster3 = BehaviorFunctions.CreateEntity(self.monsterList[2], nil, pos.x, pos.y, pos.z+5, nil, nil, nil, self.levelId)
            self.monster4 = BehaviorFunctions.CreateEntity(self.monsterList[3], nil, pos.x, pos.y, pos.z-3, nil, nil, nil, self.levelId)
            BehaviorFunctions.DoLookAtTargetImmediately(self.monster1, self.role)
            BehaviorFunctions.DoLookAtTargetImmediately(self.monster2, self.role)
            BehaviorFunctions.DoLookAtTargetImmediately(self.monster3, self.role)
            BehaviorFunctions.DoLookAtTargetImmediately(self.monster4, self.role)
            self.missionState = 1
        end
    end
end

--死亡事件
function LevelBehavior104010301:Death(instanceId,isFormationRevive)
    if instanceId == self.monster1 or instanceId == self.monster2 or instanceId == self.monster3 or instanceId == self.monster4 then
        self.deathCount = self.deathCount + 1
		if self.deathCount == 4 then
			self:LevelFinish()
		end
    end
end

function LevelBehavior104010301:LevelFinish()
	BehaviorFunctions.SendTaskProgress(self.levelId, 1, 1)
	BehaviorFunctions.RemoveLevel(self.levelId)
end