LevelBehavior31004 = BaseClass("LevelBehavior31004",LevelBehaviorBase)
--屠龙
function LevelBehavior31004:__init(fight)
	self.fight = fight
end


function LevelBehavior31004.GetGenerates()
	local generates = {92002,92001,2020201}
	return generates
end

function LevelBehavior31004.GetStorys()
	local story = {20001,22001,23001,49001}
	return story
end


function LevelBehavior31004:Init()
	self.role = 1
	self.missionState = 0
	self.deathState = 0
	self.winState = 0
		
	self.storyStateEnum = {
		Default = 0,
		NotPlaying = 1,
		Playing = 2,
		PlayOver = 3,
	}
	self.storyList = 
	{
		[1] = 20001,
		[2] = 22001,
		[3] = 23001,
		[4] = 49001,
	}
	self.VibeEnum =
	 {
		Default = 0,
		Bxlks = 1,
		Blbt = 2,
	}
	self.time = nil
	self.timeStart = nil
	
	self.scenceList = {
		"Scene10020001/SubScene/Level1",
		"Scene10020001/SubScene/Level3",
		"Scene10020001/SubScene/Level2/Level2/Rock",
		"Scene10020001/SubScene/Level2/Level2/Effects",
		"Scene10020001/SubScene/Level2/Level2/Plant",
		"Scene10020001/SubScene/Level2/Level2/Parterre",
		"Scene10020001/SubScene/Level2/Level2/House",
		"Scene10020001/SubScene/Level2/Level2/Brick",
		"Scene10020001/SubScene/Level2/Level2/Streetlights",
		"Scene10020001/SubScene/Level2/Level2/Vine",
		"Scene10020001/SubScene/Level2/Level2/Tree_001",
		"Scene10020001/SubScene/Level2/Level2/Building_01",
		"Scene10020001/SubScene/Level2/Level2/Leaf",
		"Scene10020001/SubScene/Level2/Level2/Prop",
		"Scene10020001/SubScene/Level2/Level2/Bush",
		"Scene10020001/SubScene/Level2/Level2/Decals",
		"Scene10020001/SubScene/Level2/Level2/Car",
	}
end

function LevelBehavior31004:Update()
	self.time = BehaviorFunctions.GetFightFrame()
	self.role = BehaviorFunctions.GetCtrlEntity()

	if self.missionState == 0  then
		self:SwitchVibe(self.VibeEnum.Bxlks)
		--隐藏任务标记
		BehaviorFunctions.SetGuideShowState(FightEnum.GuideType.Task, false)
		BehaviorFunctions.SetTaskGuideDisState(false)
		--BehaviorFunctions.SetFightMainNodeVisible(2,"Map",false) --地图隐藏
		--local treasure = BehaviorFunctions.GetEcoEntityByEcoId(40012)
		--if BehaviorFunctions.CheckEntity(treasure) ~= false then
			--BehaviorFunctions.SetEntityValue(treasure,"lockState",2)
		--end
		local pos = BehaviorFunctions.GetTerrainPositionP("bossS1",self.levelId)
		--BehaviorFunctions.DoSetPosition(self.role,260,65,495)
		BehaviorFunctions.InMapTransport(260,65,495)
		BehaviorFunctions.DoLookAtPositionImmediately(self.role,274.4,65.186,520,272.33)
		BehaviorFunctions.StartStoryDialog(20001)
		self.missionState = 10
	end
	if self.missionState == 10 then
		BehaviorFunctions.SetCameraDistance(6)
		BehaviorFunctions.ActiveSceneObj("airwall",true,self.levelId)
		self.missionState = 20
	end
	
	--龙出场timeline开始
	if self.missionState == 20 then	
		if self.timeLineState == self.storyStateEnum.PlayOver then
			--隐藏生态实体
			BehaviorFunctions.DoMagic(1,1,200000103)
			BehaviorFunctions.ShowBlackCurtain(false,0)
			--local pos = BehaviorFunctions.GetTerrainPositionP("bossS1",self.levelId)
			--添加龙bgm
			BehaviorFunctions.AddBuff(1,1,900000016)
			--self.monster = BehaviorFunctions.CreateEntity(92002,nil,274.4,65.186,520,272.33,nil,516.79)
			--self.monster2 = BehaviorFunctions.CreateEntity(92001,nil,pos.x+10,pos.y,pos.z+10)
			--local pb1 = Vec3.New(274.4,65.186,520)
			--local lp1 = Vec3.New(272.33,nil,516.79)
			--BehaviorFunctions.EntityCombination(self.monster,self.monster2,true)
			--BehaviorFunctions.StartStoryDialog(22001,{self.monster,self.monster2},0,0.5,pb1,lp1)
			--self.timeLineState = self.storyStateEnum.Playing

			self.missionState = 30
		end
	end
	
	--龙出场timeline结束
	if self.missionState == 30 then
		if self.timeLineState == self.storyStateEnum.PlayOver then
			BehaviorFunctions.ActiveSceneObj("airWallEffect",true,self.levelId)
			self.timeLineState = self.storyStateEnum.NotPlaying
		end
	end
	
	--贝露贝特timeline结束后
	if self.missionState == 40 then
		--添加贝露贝特bgm
		if BehaviorFunctions.HasBuffKind(1,900000017) == false then
			BehaviorFunctions.AddBuff(1,1,900000017)
		end
		if self.timeLineState == self.storyStateEnum.PlayOver then
			--BehaviorFunctions.ShowBlackCurtain(false,0.5)
			local pos = BehaviorFunctions.GetTerrainPositionP("bossS2",self.levelId)
			self.monster3 = BehaviorFunctions.CreateEntity(92001,nil,pos.x,pos.y,pos.z)
			self.empty = BehaviorFunctions.CreateEntity(2001,nil,pos.x,pos.y - 1,pos.z)
			BehaviorFunctions.DoLookAtTargetImmediately(self.monster3,self.role)
			BehaviorFunctions.DoLookAtTargetImmediately(self.role,self.monster3)
			--设置关卡相机
			local levelCam = BehaviorFunctions.CreateEntity(22002)
			BehaviorFunctions.CameraEntityFollowTarget(levelCam,self.role)
			BehaviorFunctions.CameraEntityLockTarget(levelCam,self.empty)
			BehaviorFunctions.AddDelayCallByFrame(2,BehaviorFunctions,BehaviorFunctions.RemoveEntity,levelCam)
			--显示玩家模型
			if BehaviorFunctions.HasBuffKind(self.role,900000010) == true then
				BehaviorFunctions.RemoveBuff(self.role,900000010)
			end
			self.missionState = 50
		else
			--隐藏玩家模型且传送
			if BehaviorFunctions.HasBuffKind(self.role,900000010) == false then
				BehaviorFunctions.DoMagic(self.role,self.role,900000010)
				local pos2 = BehaviorFunctions.GetTerrainPositionP("playerS2",self.levelId)
				--BehaviorFunctions.DoSetPosition(self.role,pos2.x,pos2.y,pos2.z)
				BehaviorFunctions.InMapTransport(pos2.x,pos2.y,pos2.z)
			end
		end
	end
	
	--击败贝露贝特后
	if self.missionState == 60 then
		BehaviorFunctions.StartStoryDialog(23001)
		--发送关卡完成消息
		--BehaviorFunctions.SetDuplicateResult(true)
		--发送巴西利克斯氛围移除消息
		local bxlksVolume = BehaviorFunctions.GetEcoEntityByEcoId(40014)
		if BehaviorFunctions.CheckEntity(bxlksVolume) then
			BehaviorFunctions.InteractEntityHit(bxlksVolume,FightEnum.SysEntityOpType.Death)
			self.bxlksVolume = bxlksVolume
		end
		self.timeLineState = self.storyStateEnum.Playing
		self.missionState = 70
		self.winState = 999
	end
	
	--如果宝箱没有被上锁则上锁
	if self.winState < 1000 then
		local treasure = BehaviorFunctions.GetEcoEntityByEcoId(40012)
		if BehaviorFunctions.CheckEntity(treasure) ~= false then
			BehaviorFunctions.SetEntityValue(treasure,"lockState",2)
			BehaviorFunctions.SetEntityValue(treasure,"isHide",true)
		end
	end

	if self.winState == 999 then
		----开启Boss奖励宝箱
		--local treasure = BehaviorFunctions.GetEcoEntityByEcoId(40012)
		--if BehaviorFunctions.CheckEntity(treasure) ~= false then
			--BehaviorFunctions.SetEntityValue(treasure,"lockState",3)
		--end
		self.winState = 1000
	end
	
	--播放完贝露贝特离去timeline，下面的处理主要是清理关卡逻辑
	if self.winState == 1000 and self.timeLineState == self.storyStateEnum.PlayOver then 	
		--展示击败标签
		BehaviorFunctions.ShowCommonTitle(6,"巴西利克斯",true)
		self.winState = 1001
		--在四秒后进入黑幕
		self.timeStart = self.time + 120		
	end
	
	--进入黑幕后切换回正常氛围，移除当前场景
	if self.winState == 1001 and self.timeStart == self.time then
		--淡入黑屏0.5秒
		BehaviorFunctions.ShowBlackCurtain(true,0.5)
		--移除贝露贝特bgm
		if BehaviorFunctions.HasBuffKind(1,900000017) == true then
			BehaviorFunctions.RemoveBuff(1,900000017)
		end
		self.timeStart = self.time + 120
		self.winState = 1002
		--一秒后移除空气墙、恢复正常场景、移除关卡
		BehaviorFunctions.AddDelayCallByFrame(30,BehaviorFunctions,BehaviorFunctions.ActiveSceneObj,"airwall",false,self.levelId)
		BehaviorFunctions.AddDelayCallByFrame(30,self,self.SwitchVibe,self.VibeEnum.Normal)
		BehaviorFunctions.AddDelayCallByFrame(35,BehaviorFunctions,BehaviorFunctions.RemoveLevel,31004)
		BehaviorFunctions.AddDelayCallByTime(4.5,BehaviorFunctions,BehaviorFunctions.ShowBlackCurtain,false,0.5)
		--移除巴西利克斯氛围
		local bxlksVolume = BehaviorFunctions.GetEcoEntityByEcoId(40014)
		if BehaviorFunctions.CheckEntity(self.bxlksVolume) then
			BehaviorFunctions.AddDelayCallByFrame(30,BehaviorFunctions,BehaviorFunctions.RemoveEntity,self.bxlksVolume)
		end
		--显示生态实体
		BehaviorFunctions.AddDelayCallByFrame(30,BehaviorFunctions,BehaviorFunctions.DoMagic,1,1,200000104)
		--开启Boss奖励宝箱
		local treasure = BehaviorFunctions.GetEcoEntityByEcoId(40012)
		if BehaviorFunctions.CheckEntity(treasure) ~= false then
			BehaviorFunctions.AddDelayCallByTime(4,BehaviorFunctions,BehaviorFunctions.SetEntityValue,treasure,"lockState",2)
			BehaviorFunctions.AddDelayCallByTime(4,BehaviorFunctions,BehaviorFunctions.SetEntityValue,treasure,"isHide",true)
			BehaviorFunctions.AddDelayCallByTime(5.2,BehaviorFunctions,BehaviorFunctions.SetEntityValue,treasure,"lockState",3)
			BehaviorFunctions.AddDelayCallByTime(5.2,BehaviorFunctions,BehaviorFunctions.SetEntityValue,treasure,"isHide",false)
		end
		--设置关卡成功
		BehaviorFunctions.AddDelayCallByTime(4.5,BehaviorFunctions,BehaviorFunctions.SetDuplicateResult,true)
		--设置玩家位置
		BehaviorFunctions.AddDelayCallByFrame(30,BehaviorFunctions,BehaviorFunctions.DoSetPosition,self.role,290.93338,65.1753235,529.172119)
		
	end	
	
	if self.winState == 1002 and self.time == self.timeStart then
		--恢复任务指引
		BehaviorFunctions.SetGuideShowState(FightEnum.GuideType.Task, true)
		BehaviorFunctions.SetTaskGuideDisState(true)
		--BehaviorFunctions.SetFightMainNodeVisible(2,"Map",true) --地图显示
		self.winState = 1003
		--设置相机看向熙来
		local flowerWall = BehaviorFunctions.GetEcoEntityByEcoId(1002)
		if flowerWall ~= nil then
			local levelCam = BehaviorFunctions.CreateEntity(22002)
			BehaviorFunctions.CameraEntityFollowTarget(levelCam,self.role)
			BehaviorFunctions.DoLookAtTargetImmediately(self.role,flowerWall)
			BehaviorFunctions.CameraEntityLockTarget(levelCam,flowerWall)
			BehaviorFunctions.AddDelayCallByTime(3,BehaviorFunctions,BehaviorFunctions.RemoveEntity,levelCam)
		end
	end
	
	--小队死亡处理
	if self.deathState == 2 then
		--恢复任务指引
		BehaviorFunctions.SetGuideShowState(FightEnum.GuideType.Task, true)
		BehaviorFunctions.SetTaskGuideDisState(true)
		--BehaviorFunctions.SetFightMainNodeVisible(2,"Map",true) --地图显示
		--显示生态实体
		BehaviorFunctions.DoMagic(1,1,200000104)
		if self.monster then
			BehaviorFunctions.RemoveEntity(self.monster)
		end
		if self.monster2 then
			BehaviorFunctions.RemoveEntity(self.monster2)
		end
		if self.monster3 then
			BehaviorFunctions.RemoveEntity(self.monster3)
		end
		self:SwitchVibe(self.VibeEnum.Normal)
		BehaviorFunctions.ShowTip(3001003)
		BehaviorFunctions.ActiveSceneObj("airwall",false,self.levelId)
		--移除龙bgm
		if BehaviorFunctions.HasBuffKind(1,900000016) == true then
			BehaviorFunctions.RemoveBuff(1,900000016)
		end
		--移除贝露贝特bgm
		if BehaviorFunctions.HasBuffKind(1,900000017) == true then
			BehaviorFunctions.RemoveBuff(1,900000017)
		end
		--移除强锁标签
		if BehaviorFunctions.HasEntitySign(1,10000007) then
			BehaviorFunctions.RemoveEntitySign(1,10000007)
			BehaviorFunctions.SetCameraParams(FightEnum.CameraState.ForceLocking,90002)--改回强锁参数
		end
		--移除Boss血条标签
		if BehaviorFunctions.HasEntitySign(1,10000020) then
			BehaviorFunctions.AddEntitySign(1,10000021,-1)
			--BehaviorFunctions.RemoveEntitySign(1,10000020)
		end
		BehaviorFunctions.SetDuplicateResult(false)
		BehaviorFunctions.RemoveLevel(31004)
		self.deathState = 999
	end
end

--移除事件
function LevelBehavior31004:RemoveEntity(instanceId)
	if self.winState == 1 then
		if instanceId == self.monster then
			local pb1 = BehaviorFunctions.GetTerrainPositionP("P49001",10020001,"Logic10020001_5")
			local lp1 = BehaviorFunctions.GetTerrainPositionP("Face49001",10020001,"Logic10020001_5")
			--BehaviorFunctions.StartStoryDialog(23001)
			BehaviorFunctions.StartStoryDialog(49001,{},0,0,pb1,lp1)
			BehaviorFunctions.ActiveSceneObj("airWallEffect",false,self.levelId)
			self.timeLineState = self.storyStateEnum.Playing
			self.blbtTimelineDelay = BehaviorFunctions.AddDelayCallByFrame(985,self,self.SwitchVibe,self.VibeEnum.Blbt)
			--self:SwitchVibe(self.VibeEnum.Blbt)
			self.missionState = 40
			--if self.bgm then
				--BehaviorFunctions.RemoveEntity(self.bgm)--龙bgm
			--end
			--移除龙bgm
			if BehaviorFunctions.HasBuffKind(1,900000016) == true then
				BehaviorFunctions.RemoveBuff(1,900000016)
			end
		end	
	end
	if self.winState == 2 then
		if instanceId == self.monster3 then
			--BehaviorFunctions.ShowBlackCurtain(true,0.5)
			self.timeStart = BehaviorFunctions.GetFightFrame()
			self.missionState = 60
			--BehaviorFunctions.StartStoryDialog(23001)
			--self:SwitchVibe(self.VibeEnum.Normal)
			--self.timeLineState = self.storyStateEnum.Playing
			--self.winState = 999
		end
		----移除贝露贝特bgm
		--if BehaviorFunctions.HasBuffKind(1,900000017) == true then
			--BehaviorFunctions.RemoveBuff(1,900000017)
		--end
	end
end

function LevelBehavior31004:Death(instanceId,isFormationRevive)
	if instanceId == self.monster then
		BehaviorFunctions.RemoveEntity(self.monster2)
		self.winState = 1
	end
	if instanceId == self.monster3 then
		self.winState = 2
	end
	if isFormationRevive then
		self.deathState = 2 
	end
end

function LevelBehavior31004:__delete()

end

function LevelBehavior31004:StoryStartEvent(dialogId)
	for i,v in ipairs(self.storyList) do
		if v == dialogId then
			self.timeLineState = self.storyStateEnum.Playing
		end
	end
end

function LevelBehavior31004:StoryEndEvent(dialogId)
	for i,v in ipairs(self.storyList) do
		if v == dialogId then
			self.timeLineState = self.storyStateEnum.PlayOver
		end
	end
	if dialogId == 49001 then
		BehaviorFunctions.RemoveDelayCall(self.blbtTimelineDelay)
		self:SwitchVibe(self.VibeEnum.Blbt)
		--BehaviorFunctions.ShowBlackCurtain(true,0)
		self.timeStart = BehaviorFunctions.GetFightFrame()
	end
	if dialogId == 20001 then
		--BehaviorFunctions.ShowBlackCurtain(true,0)
		local pos = BehaviorFunctions.GetTerrainPositionP("bossS1",self.levelId)
		self.monster = BehaviorFunctions.CreateEntity(92002,nil,274.4,65.186,520,272.33,nil,516.79)
		self.monster2 = BehaviorFunctions.CreateEntity(92001,nil,pos.x+10,pos.y,pos.z+10)
		local pb1 = Vec3.New(274.4,65.186,520)
		local lp1 = Vec3.New(272.33,nil,516.79)
		BehaviorFunctions.EntityCombination(self.monster,self.monster2,true)
		BehaviorFunctions.StartStoryDialog(22001,{self.monster,self.monster2},0,0.5,pb1,lp1)
		self.timeLineState = self.storyStateEnum.Playing
	end
end

function LevelBehavior31004:SwitchVibe(VibeName)
	if VibeName == self.VibeEnum.Bxlks then
		--停止场景和生态更新
		BehaviorFunctions.SetSceneObjectLoadPause(true)
		BehaviorFunctions.SetEcosystemEntityLoadPause(true)
		--隐藏部分场景
		for i,v in ipairs(self.scenceList) do
			BehaviorFunctions.ActiveSceneObjByPath(self.scenceList[i],false)
		end
	elseif VibeName == self.VibeEnum.Blbt then
		--恢复部分场景
		for i,v in ipairs(self.scenceList) do
			BehaviorFunctions.ActiveSceneObjByPath(self.scenceList[i],true)
		end
		--隐藏巴西利克斯氛围
		local bxlksVolume = BehaviorFunctions.GetEcoEntityByEcoId(40014)
		if BehaviorFunctions.CheckEntity(bxlksVolume) then
			BehaviorFunctions.AddBuff(bxlksVolume,bxlksVolume,1001)
		end
		--隐藏大平原场景
		BehaviorFunctions.ActiveSceneObj("blbt",true,self.levelId)
		BehaviorFunctions.ActiveSceneObjByPath("Scene10020001/SubScene",false)
		BehaviorFunctions.ActiveSceneObjByPath("Scene10020001/HWorldAssets",false)
		
	elseif VibeName == self.VibeEnum.Normal then
		--恢复场景和生态更新
		BehaviorFunctions.SetSceneObjectLoadPause(false)
		BehaviorFunctions.SetEcosystemEntityLoadPause(false)
		--恢复部分场景
		for i,v in ipairs(self.scenceList) do
			BehaviorFunctions.ActiveSceneObjByPath(self.scenceList[i],true)
		end
		--复原大平原场景
		BehaviorFunctions.ActiveSceneObj("bxlks",false,self.levelId)
		BehaviorFunctions.ActiveSceneObj("blbt",false,self.levelId)
		BehaviorFunctions.ActiveSceneObjByPath("Scene10020001/SubScene",true)
		BehaviorFunctions.ActiveSceneObjByPath("Scene10020001/HWorldAssets",true)
		BehaviorFunctions.ActiveSceneObjByPath("Scene10020001/GraphicManager_10020001",true)
	end
end
