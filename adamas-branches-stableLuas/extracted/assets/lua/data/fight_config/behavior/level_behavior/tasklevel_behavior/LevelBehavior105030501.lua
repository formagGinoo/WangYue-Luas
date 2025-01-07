LevelBehavior105030501 = BaseClass("LevelBehavior105030501",LevelBehaviorBase)
--召唤一只箴石之猎，打死后显示佩从玉

function LevelBehavior105030501:__init(fight)
	self.fight = fight
end

function LevelBehavior105030501.GetGenerates()
	local generates = {900070, 900080}
	return generates
end

function LevelBehavior105030501:Init()
	self.missionState = 0
    self.role = nil
    self.posName = "Panjudian"
	self.deathCount = 0
	self.monsterList = {
        900080
    }
    self.peicongyuEcoId = 3201001010001
end

function LevelBehavior105030501:Update()
	self.role = BehaviorFunctions.GetCtrlEntity()
    self:CreateMonster()
end

function LevelBehavior105030501:__delete()

end

--在某个点附近创建怪
function LevelBehavior105030501:CreateMonster()
    if self.missionState == 0 then
        local pos = BehaviorFunctions.GetTerrainPositionP(self.posName, 10020004, "MainTask04")
        local posMe = BehaviorFunctions.GetPositionP(self.role)
        local distanceXZ = BehaviorFunctions.GetDistanceFromPos(pos, posMe)
        local distanceY = math.abs(pos.y - posMe.y)
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
function LevelBehavior105030501:Death(instanceId,isFormationRevive)
    if instanceId == self.monster1 or instanceId == self.monster2 or instanceId == self.monster3 or instanceId == self.monster4 then
        self.deathCount = self.deathCount + 1
		if self.deathCount == 1 then
            BehaviorFunctions.ChangeEcoEntityCreateState(self.peicongyuEcoId, true)
			self:LevelFinish()
		end
    end
end

function LevelBehavior105030501:LevelFinish()
	BehaviorFunctions.SendTaskProgress(self.levelId + 100, 1, 1)
	BehaviorFunctions.RemoveLevel(self.levelId)
end