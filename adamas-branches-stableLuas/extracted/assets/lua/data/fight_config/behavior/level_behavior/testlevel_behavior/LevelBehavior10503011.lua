--主线第5章

LevelBehavior10503011 = BaseClass("LevelBehavior10503011",LevelBehaviorBase)
--fight初始化
function LevelBehavior10503011:__init(fight)
	self.fight = fight
end

--预加载
function LevelBehavior10503011.GetGenerates()
	local generates = {900040}
	return generates
end
function LevelBehavior10503011.GetMagics()
	local generates = {}
	return generates
end
--UI预加载
function LevelBehavior10503011.GetUIGenerates()
	local generates = {
		FightEnum.PreLoadUI.RemoteDialog,--带头像的剧情对话框UI
		FightEnum.PreLoadUI.FightTalkDialog,--纯文字的剧情对话框UI
		FightEnum.PreLoadUI.GuideMask,--教学引导UI
		FightEnum.PreLoadUI.FightTips--中间横幅和底部横幅
	}
	return generates
end

--参数初始化
function LevelBehavior10503011:Init()
	self.missionState = 0   --关卡流程
	self.createId = 900040
end

--帧事件
function LevelBehavior10503011:Update()
	if self.missionState == 0 then
		--BehaviorFunctions.CreateEntity(self.createId,nil,self.pos2.x,self.pos2.y,self.pos2.z)
		
		self.monster1 = BehaviorFunctions.CreateEntityByPosition(self.createId, nil, "rivermonsterpos", "Task_Main_53", 10503011, self.levelId, nil)
		
		self.missionState = 1
	end
end

--死亡事件
function LevelBehavior10503011:RemoveEntity(instanceId)
	if instanceId == self.monster1 then
		BehaviorFunctions.SendTaskProgress(1050301, 3, 1)

	end

end