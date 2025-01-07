--主线第5章

LevelBehavior10502021 = BaseClass("LevelBehavior10502021",LevelBehaviorBase)
--fight初始化
function LevelBehavior10502021:__init(fight)
	self.fight = fight
end

--预加载
function LevelBehavior10502021.GetGenerates()
	local generates = {910040,900080}
	return generates
end
function LevelBehavior10502021.GetMagics()
	local generates = {}
	return generates
end
--UI预加载
function LevelBehavior10502021.GetUIGenerates()
	local generates = {
		FightEnum.PreLoadUI.RemoteDialog,--带头像的剧情对话框UI
		FightEnum.PreLoadUI.FightTalkDialog,--纯文字的剧情对话框UI
		FightEnum.PreLoadUI.GuideMask,--教学引导UI
		FightEnum.PreLoadUI.FightTips--中间横幅和底部横幅
	}
	return generates
end

--参数初始化
function LevelBehavior10502021:Init()
	self.missionState = 0   --关卡流程
	self.createId = 910040
	self.createId2 = 900080
	self.levelstate = 0
end

--帧事件
function LevelBehavior10502021:Update()
	if self.missionState == 0 then
		--BehaviorFunctions.CreateEntity(self.createId,nil,self.pos2.x,self.pos2.y,self.pos2.z)
		
		self.monster1 = BehaviorFunctions.CreateEntityByPosition(self.createId2, nil, "gassmonsterpos1", "Task_Main_52", 10502021, self.levelId, nil)
		self.monster2 = BehaviorFunctions.CreateEntityByPosition(self.createId2, nil, "gassmonsterpos2", "Task_Main_52", 10502021, self.levelId, nil)
		self.monster3 = BehaviorFunctions.CreateEntityByPosition(self.createId, nil, "gassmonsterpos3", "Task_Main_52", 10502021, self.levelId, nil)
		
		
		
		self.missionState = 1
	end
end

--死亡事件
function LevelBehavior10502021:RemoveEntity(instanceId)
	if instanceId == self.monster1 or instanceId == self.monster2 or instanceId == self.monster3 then
		self.levelstate = self.levelstate + 1
		
		if self.levelstate >= 3 then
			BehaviorFunctions.FinishLevel(self.levelId)
		end
	end

end