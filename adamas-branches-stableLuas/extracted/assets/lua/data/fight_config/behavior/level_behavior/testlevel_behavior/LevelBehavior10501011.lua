--主线第5章

LevelBehavior10501011 = BaseClass("LevelBehavior10501011",LevelBehaviorBase)
--fight初始化
function LevelBehavior10501011:__init(fight)
	self.fight = fight
	self.levelstate = 0
end

--预加载
function LevelBehavior10501011.GetGenerates()
	local generates = {900130,910040}
	return generates
end
function LevelBehavior10501011.GetMagics()
	local generates = {}
	return generates
end
--UI预加载
function LevelBehavior10501011.GetUIGenerates()
	local generates = {
		FightEnum.PreLoadUI.RemoteDialog,--带头像的剧情对话框UI
		FightEnum.PreLoadUI.FightTalkDialog,--纯文字的剧情对话框UI
		FightEnum.PreLoadUI.GuideMask,--教学引导UI
		FightEnum.PreLoadUI.FightTips--中间横幅和底部横幅
	}
	return generates
end

--参数初始化
function LevelBehavior10501011:Init()
	self.missionState = 0   --关卡流程
	self.createId = 910040
	self.createI2 = 900130
	self.bell = BehaviorFunctions.GetEcoEntityByEcoId(1001002020001)
end

--帧事件
function LevelBehavior10501011:Update()
	if self.missionState == 0 then
		--BehaviorFunctions.CreateEntity(self.createId,nil,self.pos2.x,self.pos2.y,self.pos2.z).
		
		self.monster1 = BehaviorFunctions.CreateEntityByPosition(self.createId, nil, "congShiBornPos", "Task_Main_51", 10501011, self.levelId, nil)
		self.monster2 = BehaviorFunctions.CreateEntityByPosition(self.createI2, nil, "congShiBornPos2", "Task_Main_51", 10501011, self.levelId, nil)
		
		BehaviorFunctions.ShowGuideImageTips(20022)
		
		BehaviorFunctions.SetEntityWorldInteractState(self.bell, false)
		
		self.missionState = 1
	end
end

--死亡事件
function LevelBehavior10501011:RemoveEntity(instanceId)
	if instanceId == self.monster1 or instanceId == self.monster2 then
		if self.levelstate == 0 then
			self.levelstate = 1
		elseif self.levelstate == 1 then
			BehaviorFunctions.SetEntityWorldInteractState(self.bell, true)
			BehaviorFunctions.FinishLevel(self.levelId)
		end

	end

end
