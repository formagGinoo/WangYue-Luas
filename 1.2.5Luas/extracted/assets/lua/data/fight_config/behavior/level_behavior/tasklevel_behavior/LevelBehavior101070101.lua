LevelBehavior101070101 = BaseClass("LevelBehavior101070101",LevelBehaviorBase)
--Boss战贝露贝特和巴西利克斯
function LevelBehavior101070101:__init(fight)
	self.fight = fight
end

function LevelBehavior101070101.GetGenerates()
	local generates = {92001,92002}
	return generates
end

function LevelBehavior101070101.GetStorys()
	local storys = {101070101}
	return storys
end

--程序黑幕
function LevelBehavior101070101.NeedBlackCurtain()
	return true
end

function LevelBehavior101070101:Init()
	self.role = BehaviorFunctions.GetCtrlEntity()
	self.missionState = 0
	
	self.weakGuide =
	{
		[1] = {Id = 20001,state = false,Describe ="推动摇杆进行移动"},
		[2] = {Id = 20002,state = false,Describe ="长按进入跑步状态"},
		[3] = {Id = 20003,state = false,Describe ="连续点击2次跳跃可二段跳"},
		[4] = {Id = 20004,state = false,Describe ="长按在墙面上奔跑"},
		[5] = {Id = 20005,state = false,Describe ="点击按钮使用普通攻击"},
	}
	
	self.dialogStateEnum = {
		Default = 0,
		NotPlaying = 1,
		Playing = 2,
		PlayOver = 3,
	}
	
	self.dialogList =
	{
		[1] = {Id = 101070101,state = self.dialogStateEnum.NotPlaying},
		[2] = {Id = 101070201,state = self.dialogStateEnum.NotPlaying},
		[3] = {Id = 101070301,state = self.dialogStateEnum.NotPlaying},
		[4] = {Id = 101070401,state = self.dialogStateEnum.NotPlaying},
		[5] = {Id = 101070501,state = self.dialogStateEnum.NotPlaying},
		[6] = {Id = 101070601,state = self.dialogStateEnum.NotPlaying},
		[7] = {Id = 101070701,state = self.dialogStateEnum.NotPlaying},
		[8] = {Id = 101070801,state = self.dialogStateEnum.NotPlaying},
		[9] = {Id = 49001,state = self.dialogStateEnum.NotPlaying},
	}

end

function LevelBehavior101070101:Update()
	self.role = BehaviorFunctions.GetCtrlEntity()
	self.roleTotalFrame = BehaviorFunctions.GetEntityFrame(self.role)
	
	--开场剧情
	if self.missionState == 0 then
		local inArea = BehaviorFunctions.CheckEntityInArea(self.role,"BossArea","Logic10020001_6")
		if inArea then
			BehaviorFunctions.SetActiveBGM("FALSE")--关闭默认BGM
			--播放boss出场timeline
			BehaviorFunctions.StartStoryDialog(self.dialogList[1].Id)
			self.missionState = 1
		end
		
	--怪物出生处理
	elseif self.missionState == 4 then
		--将玩家传送至场地内
		local tp1 = BehaviorFunctions.GetTerrainPositionP("tp_BossArea",10020001,"Logic10020001_6")
		BehaviorFunctions.Transport(10020001,tp1.x,tp1.y,tp1.z)
		--BehaviorFunctions.DoSetPosition(self.role,tp1.x,tp1.y,tp1.z)
		--召唤巴西利克斯
		local pos = BehaviorFunctions.GetTerrainPositionP("Boss1",10020001,"Logic10020001_6")
		self.baxilikes = BehaviorFunctions.CreateEntity(92002,nil,pos.x,pos.y,pos.z)
		BehaviorFunctions.DoLookAtTargetImmediately(self.baxilikes,self.role)
		--召唤贝露贝特
		local pos2 = BehaviorFunctions.GetTerrainPositionP("Boss1",10020001,"Logic10020001_6")
		self.beilubeite2 = BehaviorFunctions.CreateEntity(92001,nil,pos.x,pos.y,pos.z)
		BehaviorFunctions.DoLookAtTargetImmediately(self.beilubeite2,self.role)
		--巴西利克斯与贝露贝特合体
		BehaviorFunctions.EntityCombination(self.baxilikes,self.beilubeite2,true)
		--玩家看向巴西利克斯
		BehaviorFunctions.DoLookAtTargetImmediately(self.role,self.baxilikes)
		--看向巴西利克斯镜头
		self.levelCam = BehaviorFunctions.CreateEntity(22001)
		BehaviorFunctions.CameraEntityFollowTarget(self.levelCam,self.role,"CameraTarget")
		self.empty = BehaviorFunctions.CreateEntity(2001,nil,pos.x,pos.y-5,pos.z)
		BehaviorFunctions.CameraEntityLockTarget(self.levelCam,self.empty)
		--过一秒后移除镜头
		BehaviorFunctions.AddDelayCallByFrame(30,BehaviorFunctions,BehaviorFunctions.RemoveEntity,self.levelCam)
		BehaviorFunctions.AddDelayCallByFrame(30,BehaviorFunctions,BehaviorFunctions.RemoveEntity,self.empty)
		--tips目标：击败巴西利克斯
		BehaviorFunctions.ShowTip(101070101)
		--添加BossUI
		BehaviorFunctions.SetEntityValue(1,"LevelUiTarget",self.baxilikes)		
		--添加boss血条
		if not BehaviorFunctions.HasEntitySign(1,10000020) then
			BehaviorFunctions.AddEntitySign(1,10000020,-1)
		end
		--贝露贝特不传入boss血条
		if not BehaviorFunctions.HasEntitySign(self.beilubeite2,10000031) then
			BehaviorFunctions.AddEntitySign(self.beilubeite2,10000031,-1)
		end
		--开启空气墙
		BehaviorFunctions.ActiveSceneObj("airwall",true,self.levelId)
		--记录巴西利克斯开战时间
		self.roleFrame = BehaviorFunctions.GetEntityFrame(self.role)
		--巴西利克斯BGM
		BehaviorFunctions.PlayBgmSound("Bgm_Boss_Baxilikesi")--开启巴西利克斯BGM
		self.missionState = 5
	end

	--和巴西利克斯战斗的判断
	if self.missionState == 5 then
		----巴西利克斯BGM(废弃)
		--if not BehaviorFunctions.HasBuffKind(1,900000016) then
			--BehaviorFunctions.AddBuff(1,1,900000016)
		--end
		local currentLifeRatio = BehaviorFunctions.GetEntityAttrValueRatio(self.baxilikes,1001)
		----巴西利克斯50%血量对话
		--if currentLifeRatio <= 5000 and currentLifeRatio > 1000 and self.dialogList[4].state == self.dialogStateEnum.NotPlaying then
			--BehaviorFunctions.StartStoryDialog(self.dialogList[4].Id)
			--self.dialogList[4].state = self.dialogStateEnum.Playing
		--end
		
		--开场三秒后播放对话
		if self.roleTotalFrame - self.roleFrame == 100 and self.dialogList[3].state == self.dialogStateEnum.NotPlaying then
			BehaviorFunctions.StartStoryDialog(self.dialogList[3].Id)
			self.dialogList[2].state = self.dialogStateEnum.Playing
		end
	end

	--击败巴西利克斯，进入贝露贝特timeline
	if self.missionState == 6 then
		--停止巴西利克斯BGM
		BehaviorFunctions.StopBgmSound()
		--BehaviorFunctions.StartStoryDialog(self.dialogList[9].Id)
		local pb1 = BehaviorFunctions.GetTerrainPositionP("P49001",10020001,"Logic10020001_6")
		local lp1 = BehaviorFunctions.GetTerrainPositionP("Face49001",10020001,"Logic10020001_6")
		BehaviorFunctions.StartStoryDialog(self.dialogList[9].Id,{},0,0,pb1,lp1)
		--隐藏玩家模型
		if BehaviorFunctions.HasBuffKind(self.role,900000010) == false then
			--BehaviorFunctions.DoMagic(self.role,self.role,900000010)
			BehaviorFunctions.AddBuff(self.role,self.role,900000010)
		end
		self.missionState = 7
	end
	
	--创建贝露贝特
	if self.missionState == 8 then
		--显示玩家模型
		--if BehaviorFunctions.HasBuffKind(self.role,900000010) == true then
			BehaviorFunctions.RemoveBuff(self.role,900000010)
		--end
		--将玩家传送至目标位置
		local tp1 = BehaviorFunctions.GetTerrainPositionP("tp_BossArea",10020001,"Logic10020001_6")
		BehaviorFunctions.DoSetPosition(self.role,tp1.x,tp1.y,tp1.z)
		local pos = BehaviorFunctions.GetTerrainPositionP("Boss1",10020001,"Logic10020001_6")
		self.beilubeite = BehaviorFunctions.CreateEntity(92001,nil,pos.x,pos.y,pos.z)
		BehaviorFunctions.DoLookAtTargetImmediately(self.beilubeite,self.role)
		self.roleFrame = BehaviorFunctions.GetEntityFrame(self.role)
		BehaviorFunctions.StartStoryDialog(self.dialogList[5].Id)
		BehaviorFunctions.ShowTip(101070102)
		--瘫痪条逻辑
		BehaviorFunctions.SetEntityValue(self.beilubeite,"canBreak",false)
		--看向贝露贝特镜头
		self.levelCam = BehaviorFunctions.CreateEntity(22001)
		BehaviorFunctions.DoLookAtTargetImmediately(self.role,self.beilubeite)
		BehaviorFunctions.CameraEntityFollowTarget(self.levelCam,self.role,"CameraTarget")
		self.empty = BehaviorFunctions.CreateEntity(2001,nil,pos.x,pos.y-5,pos.z)
		BehaviorFunctions.CameraEntityLockTarget(self.levelCam,self.empty)
		--添加BossUI
		BehaviorFunctions.SetEntityValue(1,"LevelUiTarget",self.beilubeite)
		--添加boss血条
		if not BehaviorFunctions.HasEntitySign(1,10000020) then
			BehaviorFunctions.AddEntitySign(1,10000020,-1)
		end
		--过一秒后移除镜头
		BehaviorFunctions.AddDelayCallByFrame(30,BehaviorFunctions,BehaviorFunctions.RemoveEntity,self.levelCam)
		BehaviorFunctions.AddDelayCallByFrame(30,BehaviorFunctions,BehaviorFunctions.RemoveEntity,self.empty)
		--贝露贝特BGM
		BehaviorFunctions.PlayBgmSound("Bgm_Boss_Lige")
		self.missionState = 9
	end

	--与贝露贝特战斗过程中
	if self.missionState == 9 then
		----贝露贝特BGM（废弃）
		--if not BehaviorFunctions.HasBuffKind(1,900000017) then
			--BehaviorFunctions.AddBuff(1,1,900000017)
		--end
		local currentLifeRatio = BehaviorFunctions.GetEntityAttrValueRatio(self.beilubeite,1001)
		--贝露贝特50%血量对话
		if currentLifeRatio <= 5000 and currentLifeRatio > 2500 and self.dialogList[6].state == self.dialogStateEnum.NotPlaying then
			BehaviorFunctions.StartStoryDialog(self.dialogList[6].Id)
			self.dialogList[6].state = self.dialogStateEnum.Playing
		----贝露贝特25%血量对话	
		--elseif currentLifeRatio <= 2500 and currentLifeRatio > 0 and self.dialogList[7].state == self.dialogStateEnum.NotPlaying then
			--BehaviorFunctions.StartStoryDialog(self.dialogList[7].Id)
			--self.dialogList[7].state = self.dialogStateEnum.Playing
		end
	end
	
	--与贝露贝特战斗结束
	if self.missionState == 10  then
		BehaviorFunctions.StopBgmSound()
		BehaviorFunctions.ActiveSceneObj("airwall",false,self.levelId)
		BehaviorFunctions.HideTip()
		--移除关卡
		BehaviorFunctions.RemoveLevel(101070101)
		self.missionState = 11
	end
end

function LevelBehavior101070101:WeakGuide(guideId)
	for i,v in ipairs(self.weakGuide) do
		if v.Id == guideId then
			BehaviorFunctions.ShowWeakGuide(guideId)
			v.state = true
		end
	end
end

function LevelBehavior101070101:RemoveEntity(instanceId)

end

function LevelBehavior101070101:__delete()

end

--死亡事件
function LevelBehavior101070101:Death(instanceId,isFormationRevive)
	if isFormationRevive then
		if BehaviorFunctions.CheckEntity(self.baxilikes) then
			BehaviorFunctions.RemoveEntity(self.baxilikes)
			BehaviorFunctions.RemoveEntity(self.beilubeite2)
		end
		if BehaviorFunctions.CheckEntity(self.beilubeite) then
			BehaviorFunctions.RemoveEntity(self.beilubeite)
		end
		BehaviorFunctions.ActiveSceneObj("airwall",false,self.levelId)
		BehaviorFunctions.HideTip()
		--移除巴西利克斯BGM
		if BehaviorFunctions.HasBuffKind(1,900000016) then
			BehaviorFunctions.RemoveBuff(1,900000016)
		end
		--移除贝露贝特BGM
		if BehaviorFunctions.HasBuffKind(1,900000017) then
			BehaviorFunctions.RemoveBuff(1,900000017)
		end
		--移除关卡
		BehaviorFunctions.RemoveLevel(101070101)
	else
		--如若巴西利克斯死亡
		if instanceId == self.baxilikes then
			--移除巴西利克斯BGM
			if BehaviorFunctions.HasBuffKind(1,900000016) then
				BehaviorFunctions.RemoveBuff(1,900000016)
			end
			--移除背上的贝露贝特
			BehaviorFunctions.RemoveEntity(self.beilubeite2)
			self.missionState = 6
		end
		
		--贝露贝特死亡
		if instanceId == self.beilubeite then
			--移除贝露贝特BGM
			if BehaviorFunctions.HasBuffKind(1,900000017) then
				BehaviorFunctions.RemoveBuff(1,900000017)
			end
			--发送第一次任务进度，代表副本完成
			BehaviorFunctions.SendTaskProgress(101070101,1,1)
			--BehaviorFunctions.StartStoryDialog(self.dialogList[8].Id)
			self.missionState = 10
		end
	end
end

function LevelBehavior101070101:StoryStartEvent(dialogId)

end

function LevelBehavior101070101:StoryEndEvent(dialogId)
	for i,v in ipairs(self.dialogList) do
		if dialogId == v.Id then
			if self.missionState == 1 and dialogId == self.dialogList[1].Id then
				--播放boss出场timeline
				BehaviorFunctions.StartStoryDialog(self.dialogList[2].Id)
				self.missionState = 3
			end
			
			if self.missionState == 3 and dialogId == self.dialogList[2].Id then				
				self.missionState = 4
			end
			
			if self.missionState == 7 and dialogId == self.dialogList[9].Id then
				self.missionState = 8
			end

			--if dialogId == self.dialogList[8].Id then
				----隐藏战斗UI
				--BehaviorFunctions.SetFightMainNodeVisible(2,"PanelParent",false)
				----延迟显示战斗UI
				--BehaviorFunctions.AddDelayCallByFrame(140,BehaviorFunctions,BehaviorFunctions.SetFightMainNodeVisible,2,"PanelParent",true)
				----展示击败标签
				--BehaviorFunctions.ShowCommonTitle(6,"巴西利克斯",true)
				----移除关卡
				--BehaviorFunctions.RemoveLevel(101070101)
				----发送任务成功
				--BehaviorFunctions.SendTaskProgress(101070101,1,1)
			--end
			v.state = self.dialogStateEnum.PlayOver
			self.currentDialog = nil
		end
	end
end