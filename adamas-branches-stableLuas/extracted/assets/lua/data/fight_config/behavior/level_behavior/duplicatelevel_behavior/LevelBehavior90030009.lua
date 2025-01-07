LevelBehavior90030009 = BaseClass("LevelBehavior90030009",LevelBehaviorBase)
--关卡测试关
function LevelBehavior90030009:__init(fight)
	self.fight = fight
end

function LevelBehavior90030009.GetGenerates()
	--local generates = {910040,900041,900042}
	--local generates = {900022,910040,900041,900042}
	local generates = {900120}
	return generates
end

function LevelBehavior90030009:Init()
	self.role = 1
	self.missionState = 0
	self.monster1 = 0
	self.monster2 = 0
	self.monster3 = 0 
	self.pos = 0
	self.pos2 = 0
	self.createId = 900120
    self.fightTypeEnum = {
        common = 1,  --普通模式，正常怪物
        baka = 2,  --傻瓜模式，不动不死
    }
    self.fightType = 1
end

function LevelBehavior90030009:Update()
	self.time = BehaviorFunctions.GetFightFrame()
	self.role = BehaviorFunctions.GetCtrlEntity()

	self.pos = BehaviorFunctions.GetTerrainPositionP("pos1",self.levelId)
	self.pos2 = BehaviorFunctions.GetTerrainPositionP("pos2",self.levelId)
	
	if self.missionState == 0 then
		BehaviorFunctions.InMapTransport(self.pos.x,self.pos.y,self.pos.z)
		self.monster1 = BehaviorFunctions.CreateEntity(self.createId,nil,self.pos2.x,self.pos2.y,self.pos2.z)
		self.missionState = 1
    elseif self.missionState == 1 and self.fightType == self.fightTypeEnum.baka then
        BehaviorFunctions.AddLevelTips(100000002,self.levelId,"怪变成傻子啦，开打！")
        --移除怪物逻辑
	    BehaviorFunctions.AddBuff(self.role,self.monster1,900000012)
        --角色无敌
		BehaviorFunctions.AddBuff(self.role,self.role,1000075)
        self.missionState = 2
    elseif self.missionState == 2 and self.fightType == self.fightTypeEnum.common then
        BehaviorFunctions.AddLevelTips(100000002,self.levelId,"怪恢复正常啦，小心！")
        if BehaviorFunctions.HasBuffKind(self.monster1,900000012) then
			BehaviorFunctions.RemoveBuff(self.monster1,900000012)
		end
        if BehaviorFunctions.HasBuffKind(self.role,1000075) then
			BehaviorFunctions.RemoveBuff(self.role,1000075)
		end
        self.missionState = 1
    end


    if Input.GetKeyDown(KeyCode.Keypad9) then
        self.fightType = 2
    end
    if Input.GetKeyDown(KeyCode.Keypad8) then
        self.fightType = 1
    end
end

--死亡事件
function LevelBehavior90030009:RemoveEntity(instanceId)
	if instanceId == self.monster1 then
		self.monster1 = BehaviorFunctions.CreateEntity(self.createId,nil,self.pos2.x,self.pos2.y,self.pos2.z)
	end
end

function LevelBehavior90030009:__delete()

end

function LevelBehavior90030009:GMSetMonsterId(id)
	if id ~= self.createId and self.monster1 then
		self.createId = id
		BehaviorFunctions.RemoveEntity(self.monster1)
	end
end