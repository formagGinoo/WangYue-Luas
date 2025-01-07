LevelBehavior1022 = BaseClass("LevelBehavior1022",LevelBehaviorBase)
--fight初始化
function LevelBehavior1022:__init(fight)
	self.fight = fight
end

--预加载
function LevelBehavior1022.GetGenerates()
	local generates = {900020,900021,900022,900023,910024,910025,900010}
	return generates
end

--参数初始化
function LevelBehavior1022:Init()

	self.missionState = 0
	--创建关卡通用行为树
	self.levelBeha = BehaviorFunctions.CreateBehavior("LevelBehavior",self)
end

--UI预加载
function LevelBehavior1022.GetUIGenerates()
	local generates = {
		FightEnum.PreLoadUI.RemoteDialog,--带头像的剧情对话框UI
		FightEnum.PreLoadUI.FightTalkDialog,--纯文字的剧情对话框UI
		FightEnum.PreLoadUI.GuideMask,--教学引导UI
		FightEnum.PreLoadUI.FightTips--中间横幅和底部横幅
	}
	return generates
end
	

--帧事件
function LevelBehavior1022:Update()
	--每帧获得当前角色
	self.role = BehaviorFunctions.GetCtrlEntity()
	--获取时间，区域
	self.time = BehaviorFunctions.GetFightFrame()

	--初始化，角色出生点
	if  self.missionState == 0 then
		self.entites = {}   --初始化self.entites表

		--玩家角色出生
		self.levelBeha:PlayerBorn("Born1","s1")

		--初始化空气墙
		BehaviorFunctions.SetWallEnable("AW1",false)
		BehaviorFunctions.SetWallEnable("AW2",false)
		BehaviorFunctions.SetWallEnable("AW3",false)
		BehaviorFunctions.SetWallEnable("AW4",false)
		BehaviorFunctions.SetWallEnable("AW5",false)
		BehaviorFunctions.SetWallEnable("AW6",false)
		BehaviorFunctions.SetWallEnable("AW7",false)
		BehaviorFunctions.SetWallEnable("AW8",false)

		self.missionState = 1
		self.timeStart = BehaviorFunctions.GetFightFrame()
	end

	--关卡开始
	if self.Missionstate == 1 and self.time - self.timestart >= 90 then



	end

	if self.Missionstate ==20 then

	end


end

