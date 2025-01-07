LevelBehavior32000302 = BaseClass("LevelBehavior32000302",LevelBehaviorBase)
--离歌野外副本
function LevelBehavior32000302:__init(fight)
	self.fight = fight
end

function LevelBehavior32000302.GetGenerates()
	local generates = {70920011}
	return generates
end

function LevelBehavior32000302.GetStorys()
	local storys = {101070102,101071001}
	return storys
end

----程序黑幕
--function LevelBehavior32000302.NeedBlackCurtain()
--return true
--end

function LevelBehavior32000302:Init()
	self.role = BehaviorFunctions.GetCtrlEntity()
	self.missionState = 0
	self.dialogStateEnum = {
		Default = 0,
		NotPlaying = 1,
		Playing = 2,
		PlayOver = 3,
	}
	
	self.dialogList =
	{
		[1] = {Id = 101090401,state = self.dialogStateEnum.NotPlaying}, --贝露贝特开打后播放
	}

	self.bgmLogic =
	{
		[1] = {
			Bgmtype = "Boss" ,
			BgmList = {
				[1] = {bgmName = "Lige_01",bgmState = false},
				[2] = {bgmName = "Lige_02",bgmState = false},
			}
		}
	}


	self.monLev = 20--怪物等级
end

function LevelBehavior32000302:Update()


	self.role = BehaviorFunctions.GetCtrlEntity()
	self.roleTotalFrame = BehaviorFunctions.GetEntityFrame(self.role)

	if self.missionState == 0 then
		BehaviorFunctions.SetActiveBGM("FALSE")--关闭默认BGM
		local pos = BehaviorFunctions.GetTerrainPositionP("Boss_Pos",self.levelId)
		self:LevelLookAtPos(pos,22002,-1)
		self.missionState = 1
	end

	--创建贝露贝特
	if self.missionState == 1 then
		--隐藏目标
		BehaviorFunctions.HideTip()
		BehaviorFunctions.SetTipsGuideState(false)

		BehaviorFunctions.SetFightMainNodeVisible(2,"Map",false) --隐藏地图
		BehaviorFunctions.SetFightMainNodeVisible(2,"RightTop",false) --系统四件套	

		----关闭核心UI
		--BehaviorFunctions.SetCoreUIEnable(self.role,false)

		--禁用角色输入
		self:DisablePlayerInput(true,true)

		--召唤贝露贝特
		local pos = BehaviorFunctions.GetTerrainPositionP("Boss_Pos",self.levelId)
		--BehaviorFunctions.UpdateDuplicateRevivePos(pos)
		self.beilubeite = BehaviorFunctions.CreateEntity(70920011,nil,pos.x,pos.y,pos.z,nil,nil,nil,self.levelId,self.monLev)

		BehaviorFunctions.DoLookAtTargetImmediately(self.beilubeite,self.role)
		self.roleFrame = BehaviorFunctions.GetEntityFrame(self.role)

		--瘫痪条逻辑
		BehaviorFunctions.SetEntityValue(self.beilubeite,"canBreak",false)

		--开启空气墙
		BehaviorFunctions.ActiveSceneObj("AirWall",true,self.levelId)

		--添加BossUI
		BehaviorFunctions.SetEntityValue(1,"LevelUiTarget",self.beilubeite)

		--添加boss血条
		if not BehaviorFunctions.HasEntitySign(1,10000020) then
			BehaviorFunctions.AddEntitySign(1,10000020,-1)
		end
		BehaviorFunctions.StartStoryDialog(self.dialogList[1].Id)
		--贝露贝特bgm开始
		BehaviorFunctions.SetActiveBGM("TRUE")--开启默认BGM
		self:BgmChangeLogic(self.bgmLogic,1,1)

		self.missionState = 1
	end

	if self.missionState == 1 then
		--停止行为树
		BehaviorFunctions.AddBuff(self.role,self.beilubeite,900000012)
		BehaviorFunctions.DoSetMoveType(self.beilubeite,FightEnum.EntityMoveSubState.Walk)
		BehaviorFunctions.ShowCommonTitle(4,"开始挑战",true)
		self.missionState = 2
	end

	if self.missionState == 3 then
		BehaviorFunctions.RemoveBuff(self.beilubeite,900000012)
		BehaviorFunctions.ShowTip(101070102)
		--移除目标和镜头
		if self.levelCam2 then
			BehaviorFunctions.CameraEntityLockTarget(self.levelCam2,nil)
			BehaviorFunctions.RemoveEntity(self.levelCam2)
		end
		self:DisablePlayerInput(false,false)
		self.missionState = 4
	end


	if self.missionState == 10 then
		--发送第二次任务进度，代表离歌副本完成
		--BehaviorFunctions.SetDuplicateResult(true)	
		--BehaviorFunctions.AddDelayCallByFrame(30,BehaviorFunctions,BehaviorFunctions.ExitDuplicate)
		BehaviorFunctions.SetDuplicateResult(true)
		BehaviorFunctions.ShowCommonTitle(5,"挑战成功",true)
		
		self.missionState = 16
	end
	
end

function LevelBehavior32000302:WeakGuide(guideId)
	for i,v in ipairs(self.weakGuide) do
		if v.Id == guideId then
			BehaviorFunctions.ShowWeakGuide(guideId)
			v.state = true
		end
	end
end

function LevelBehavior32000302:RemoveEntity(instanceId)

end

function LevelBehavior32000302:__delete()

end

--死亡事件
function LevelBehavior32000302:Die(attackInstanceId,dieInstanceId)
	if dieInstanceId == self.beilubeite then
		----发送第二次任务进度，代表离歌副本完成

		self:BgmChangeLogic(nil)
		self.missionState = 10
	end
end

--死亡动画后事件
function LevelBehavior32000302:Death(instanceId,isFormationRevive)
	--玩家角色全部死亡，副本失败
	if isFormationRevive == true then
		BehaviorFunctions.ShowCommonTitle(6,"挑战失败",true)
		BehaviorFunctions.SetDuplicateResult(false)
		self.missionState = 999
	end
end


function LevelBehavior32000302:BgmChangeLogic(group,groupNum,memberNum)
	if group then
		BehaviorFunctions.SetBgmState("BgmType",group[groupNum].Bgmtype)
		BehaviorFunctions.SetBgmState("GamePlayType",group[groupNum].BgmList[memberNum].bgmName)
		group[groupNum].BgmList[memberNum].bgmState = true
	else
		BehaviorFunctions.SetBgmState("BgmType","GamePlay")
		BehaviorFunctions.SetBgmState("GamePlayType","Explore")
	end
end

function LevelBehavior32000302:LevelLookAtPos(pos,type,frame,bindTransform)
	self.empty2 = BehaviorFunctions.CreateEntity(2001,nil,pos.x,pos.y,pos.z,nil,nil,nil,self.levelId)
	self.levelCam2 = BehaviorFunctions.CreateEntity(type,nil,0,0,0,nil,nil,nil,self.levelId)
	----立刻朝向目标点
	--BehaviorFunctions.DoLookAtTargetImmediately(self.role,self.empty2)
	if bindTransform then
		BehaviorFunctions.CameraEntityFollowTarget(self.levelCam2,self.role,bindTransform)
	else
		BehaviorFunctions.CameraEntityFollowTarget(self.levelCam2,self.role)
	end
	BehaviorFunctions.CameraEntityLockTarget(self.levelCam2,self.empty2)
	if frame > 0 then
		--延迟移除目标和镜头
		BehaviorFunctions.AddDelayCallByFrame(frame,BehaviorFunctions,BehaviorFunctions.SetEntityShowState,self.levelCam2, false)
		BehaviorFunctions.AddDelayCallByFrame(frame,BehaviorFunctions,BehaviorFunctions.CameraEntityLockTarget,self.levelCam2,nil)
		BehaviorFunctions.AddDelayCallByFrame(frame,BehaviorFunctions,BehaviorFunctions.RemoveEntity,self.levelCam2)
	end
end

function LevelBehavior32000302:DisablePlayerInput(isOpen,closeUI)
	--取消摇杆移动
	BehaviorFunctions.CancelJoystick()
	if isOpen then
		----禁用摇杆输入
		--BehaviorFunctions.SetJoyMoveEnable(self.role,false)
		--关闭按键输入
		for i,v in ipairs(FightEnum.KeyEvent) do
			BehaviorFunctions.ForbidKey(i,true)
		end
	else
		BehaviorFunctions.SetJoyMoveEnable(self.role,true)
		for i,v in ipairs(FightEnum.KeyEvent) do
			BehaviorFunctions.ForbidKey(i,false)
		end
	end
	if closeUI then
		--屏蔽战斗主UI
		BehaviorFunctions.SetFightMainNodeVisible(2,"PanelParent",false)
	else
		--显示战斗主UI
		BehaviorFunctions.SetFightMainNodeVisible(2,"PanelParent",true)
	end
end

function LevelBehavior32000302:StoryStartEvent(dialogId)
	for i,v in ipairs(self.dialogList) do
		if dialogId == v.Id then
			v.state = self.dialogStateEnum.PlayOver
			self.currentDialog = nil
		end
	end
end

function LevelBehavior32000302:StoryEndEvent(dialogId)
	for i,v in ipairs(self.dialogList) do
		if dialogId == v.Id then

			if dialogId == self.dialogList[1].Id then
				if self.missionState < 3 then
					self.missionState = 3
				end
			end

			v.state = self.dialogStateEnum.PlayOver
			self.currentDialog = nil
		end
	end
end

--复活逻辑
function LevelBehavior32000302:Revive(instanceId, entityId)
	--if instanceId == self.role then
	--self.missionState = 0
	--end
end

--赋值
function LevelBehavior32000302:Assignment(variable,value)
	self[variable] = value
end

function LevelBehavior32000302:DuplicateCountdownFinish()
	LogError("111")
end
