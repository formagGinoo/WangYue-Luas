LevelBehavior101070102 = BaseClass("LevelBehavior101070102",LevelBehaviorBase)
--Boss战贝露贝特
function LevelBehavior101070102:__init(fight)
	self.fight = fight
end

function LevelBehavior101070102.GetGenerates()
	local generates = {92001}
	return generates
end

function LevelBehavior101070102.GetStorys()
	local storys = {101070102,101071001}
	return storys
end

----程序黑幕
--function LevelBehavior101070102.NeedBlackCurtain()
	--return true
--end

function LevelBehavior101070102:Init()
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
		[2] = {Id = 101090501,state = self.dialogStateEnum.NotPlaying}, --贝露贝特快死时播放
		[3] = {Id = 101090601,state = self.dialogStateEnum.NotPlaying}, --贝露贝特死时播放
		[4] = {Id = 82001,state = self.dialogStateEnum.NotPlaying}, --衔接切天空timeline
		[5] = {Id = 101071001,state = self.dialogStateEnum.NotPlaying}, --获得玉佩timeline
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

	self.monLev = 10--怪物等级
end

function LevelBehavior101070102:Update()
	
	local result = BehaviorFunctions.ReturnDuplicateCountdownRemain()
	LogError(result)
	
	self.role = BehaviorFunctions.GetCtrlEntity()
	self.roleTotalFrame = BehaviorFunctions.GetEntityFrame(self.role)
	
	if self.missionState == 0 then
		BehaviorFunctions.SetActiveBGM("FALSE")--关闭默认BGM
		--播放切裂天空
		BehaviorFunctions.StartStoryDialog(self.dialogList[4].Id)
		local pos = BehaviorFunctions.GetTerrainPositionP("Boss_Pos",self.levelId)
		self:LevelLookAtPos(pos,22002,-1)
		self.missionState = 0.1
	end
	
	--创建贝露贝特
	if self.missionState == 0.2 then
		--隐藏目标
		BehaviorFunctions.HideTip()
		BehaviorFunctions.SetTipsGuideState(false)
		
		BehaviorFunctions.SetFightMainNodeVisible(2,"Map",false) --隐藏地图
		
		----关闭核心UI
		--BehaviorFunctions.SetCoreUIEnable(self.role,false)
		
		--禁用角色输入
		self:DisablePlayerInput(true,true)
		
		----将玩家传送至目标位置
		--local tp1 = BehaviorFunctions.GetTerrainPositionP("Born_Pos",self.levelId)
		--local tp1R = BehaviorFunctions.GetTerrainRotationP("Born_Pos",self.levelId)
		--BehaviorFunctions.InMapTransport(tp1.x,tp1.y,tp1.z)
		--BehaviorFunctions.SetEntityEuler(self.role,tp1R.x,tp1R.y,tp1R.z)
		
		--召唤贝露贝特
		local pos = BehaviorFunctions.GetTerrainPositionP("Boss_Pos",self.levelId)
		--BehaviorFunctions.UpdateDuplicateRevivePos(pos)
		self.beilubeite = BehaviorFunctions.CreateEntity(92001,nil,pos.x,pos.y,pos.z,nil,nil,nil,self.levelId,self.monLev)
		
		BehaviorFunctions.DoLookAtTargetImmediately(self.beilubeite,self.role)
		self.roleFrame = BehaviorFunctions.GetEntityFrame(self.role)
		BehaviorFunctions.StartStoryDialog(self.dialogList[1].Id)
		
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
		
		--贝露贝特bgm开始
		BehaviorFunctions.SetActiveBGM("TRUE")--开启默认BGM
		self:BgmChangeLogic(self.bgmLogic,1,1)
		
		self.missionState = 1
	end
	
	if self.missionState == 1 then
		--停止行为树
		BehaviorFunctions.AddBuff(self.role,self.beilubeite,900000012)
		BehaviorFunctions.DoSetMoveType(self.beilubeite,FightEnum.EntityMoveSubState.Walk)
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

	--与贝露贝特战斗过程中
	if self.missionState < 10 then
		if BehaviorFunctions.CheckEntity(self.beilubeite) then
			local currentLifeRatio = BehaviorFunctions.GetEntityAttrValueRatio(self.beilubeite,1001)
			--贝露贝特15%血量对话
			if currentLifeRatio <= 1500 and self.dialogList[2].state == self.dialogStateEnum.NotPlaying then
				self.missionState = 10
				BehaviorFunctions.StartStoryDialog(self.dialogList[2].Id)
				self.dialogList[2].state = self.dialogStateEnum.Playing
			end

			--贝露贝特bgm逻辑
			if currentLifeRatio <= 5000 and self.bgmLogic[1].BgmList[2].bgmState == false then
				self:BgmChangeLogic(self.bgmLogic,1,2)
			end
		end
	end
	
	--与贝露贝特战斗结束
	if self.missionState == 10  then
		--施加无敌
		if not BehaviorFunctions.HasBuffKind(self.beilubeite,900000007) then
			BehaviorFunctions.AddBuff(self.beilubeite,self.beilubeite,900000007)
			BehaviorFunctions.SetEntityValue(self.beilubeite,"skillList",{})
			self.missionState = 11
			--BehaviorFunctions.AddBuff(self.beilubeite,self.beilubeite,900000012)
		end
		----添加Boss战结束缓时效果
		--BehaviorFunctions.AddBuff(self.role,self.role,900000065)
		--延迟下一个阶段
		--BehaviorFunctions.HideTip()
		----移除关卡
		--BehaviorFunctions.RemoveLevel(101070102)
		----传送回大世界地图
		--local tp1 = BehaviorFunctions.GetTerrainPositionP("tp_Jade",10020001,"Logic10020001_6")
		--BehaviorFunctions.Transport(10020001,tp1.x,tp1.y,tp1.z)
	end
	
	if self.missionState == 11 then
		--强制逼格黑白闪
		if BehaviorFunctions.CanCastSkill(self.beilubeite) then
			BehaviorFunctions.CastSkillByTarget(self.beilubeite,92001916,self.role)
			self:BgmChangeLogic(nil)
			--停止巴西利克斯BGM
			BehaviorFunctions.SetActiveBGM("FALSE")--关闭默认BGM
			self.missionState = 11.5
		end
	end
	
	if self.missionState == 12 then
		BehaviorFunctions.StartStoryDialog(self.dialogList[5].Id)
		BehaviorFunctions.RemoveEntity(self.beilubeite)
		BehaviorFunctions.ShowBlackCurtain(false,0.5,true)
		self.missionState = 13
	end
	
	if self.missionState == 14 then
		----移除Boss战结束缓时效果
		--BehaviorFunctions.RemoveBuff(self.role,900000065)
		--发送第二次任务进度，代表离歌副本完成
		BehaviorFunctions.SendTaskProgress(101070101,1,1)
		BehaviorFunctions.SetDuplicateResult(true)
		----传送回大世界地图
		--local tp1 = BehaviorFunctions.GetTerrainPositionP("tp_Jade",10020001,"Logic10020001_6")
		--BehaviorFunctions.Transport(10020001,tp1.x,tp1.y,tp1.z)
		self.missionState = 15
	end
end

function LevelBehavior101070102:WeakGuide(guideId)
	for i,v in ipairs(self.weakGuide) do
		if v.Id == guideId then
			BehaviorFunctions.ShowWeakGuide(guideId)
			v.state = true
		end
	end
end

function LevelBehavior101070102:RemoveEntity(instanceId)

end

function LevelBehavior101070102:__delete()

end

--死亡事件
function LevelBehavior101070102:Die(attackInstanceId,dieInstanceId)		
	if dieInstanceId == self.beilubeite then
		----发送第二次任务进度，代表离歌副本完成
		--BehaviorFunctions.SendTaskProgress(101070101,1,1)
		self:BgmChangeLogic(nil)
		self.missionState = 10
	end
end

--死亡动画后事件
function LevelBehavior101070102:Death(instanceId,isFormationRevive)
	if isFormationRevive then
		--BehaviorFunctions.StopBgmSound()
		--if BehaviorFunctions.CheckEntity(self.beilubeite) then
			--BehaviorFunctions.RemoveEntity(self.beilubeite)
		--end
		--BehaviorFunctions.ActiveSceneObj("AirWall",false,self.levelId)
		--BehaviorFunctions.HideTip()
		--self.missionState = 0
	else
		--贝露贝特死亡
		if instanceId == self.beilubeite then
			--self:BgmChangeLogic(nil)
			--self.missionState = 10
		end
	end
end

function LevelBehavior101070102:CastSkill(instanceId,skillId,skillType)
	if instanceId == self.beilubeite and skillId == 92001916 then
		BehaviorFunctions.AddDelayCallByFrame(220,BehaviorFunctions,BehaviorFunctions.ShowBlackCurtain,true,0.3,true)
	end
end

function LevelBehavior101070102:FinishSkill(instanceId,skillId,skillType)
	if instanceId == self.beilubeite and skillId == 92001916 then
		BehaviorFunctions.AddDelayCallByFrame(90,self,self.Assignment,"missionState",12)
		BehaviorFunctions.AddDelayCallByFrame(60,BehaviorFunctions,BehaviorFunctions.DoEntityAudioPlay,2,"Play_v_story_qingwu_5",true)
	end
end

function LevelBehavior101070102:StoryStartEvent(dialogId)
	for i,v in ipairs(self.dialogList) do
		if dialogId == v.Id then
			v.state = self.dialogStateEnum.PlayOver
			self.currentDialog = nil
		end
	end
end

function LevelBehavior101070102:StoryEndEvent(dialogId)
	for i,v in ipairs(self.dialogList) do
		if dialogId == v.Id then
			if dialogId == self.dialogList[4].Id then
				self.missionState = 0.2
			end
			if dialogId == self.dialogList[1].Id then
				if self.missionState < 3 then
					self.missionState = 3
				end
			end
			if dialogId == self.dialogList[5].Id then
				self.missionState = 14
			end
			v.state = self.dialogStateEnum.PlayOver
			self.currentDialog = nil
		end
	end
end

function LevelBehavior101070102:StoryPassEvent(dialogId)
	if dialogId == 101090402 then
		self.missionState = 3
	--elseif dialogId == 101090503 then
		--self.missionState = 11
	end
end

function LevelBehavior101070102:BgmChangeLogic(group,groupNum,memberNum)
	if group then
		BehaviorFunctions.SetBgmState("BgmType",group[groupNum].Bgmtype)
		BehaviorFunctions.SetBgmState("GamePlayType",group[groupNum].BgmList[memberNum].bgmName)
		group[groupNum].BgmList[memberNum].bgmState = true
	else
		BehaviorFunctions.SetBgmState("BgmType","GamePlay")
		BehaviorFunctions.SetBgmState("GamePlayType","Explore")
	end
end

function LevelBehavior101070102:LevelLookAtPos(pos,type,frame,bindTransform)
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

function LevelBehavior101070102:DisablePlayerInput(isOpen,closeUI)
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

--复活逻辑
function LevelBehavior101070102:Revive(instanceId, entityId)
	--if instanceId == self.role then
		--self.missionState = 0
	--end
end

--赋值
function LevelBehavior101070102:Assignment(variable,value)
	self[variable] = value
end

function LevelBehavior101070102:DuplicateCountdownFinish()
	LogError("111")
end
