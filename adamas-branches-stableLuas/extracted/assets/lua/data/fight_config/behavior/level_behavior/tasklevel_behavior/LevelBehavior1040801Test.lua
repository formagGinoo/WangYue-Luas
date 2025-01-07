LevelBehavior1040801 = BaseClass("LevelBehavior1040801",LevelBehaviorBase)
--Boss战贝露贝特和巴西利克斯
function LevelBehavior1040801:__init(fight)
	self.fight = fight
end

function LevelBehavior1040801.GetGenerates()
	local generates = {920011,92002}
	return generates
end

function LevelBehavior1040801.GetStorys()
	local storys = {101070101}
	return storys
end

----程序黑幕
--function LevelBehavior1040801.NeedBlackCurtain()
	--return true
--end

function LevelBehavior1040801:Init()
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
		[1] = {Id = 101090101,state = self.dialogStateEnum.NotPlaying}, --开场timeline
		[2] = {Id = 101090201,state = self.dialogStateEnum.NotPlaying}, --开打3秒后播放
		--[3] = {Id = 49001,state = self.dialogStateEnum.NotPlaying},	--巴西利克斯死亡播放
		[3] = {Id = 490001,state = self.dialogStateEnum.NotPlaying},	--巴西利克斯死亡播放
		[4] = {Id = 101090401,state = self.dialogStateEnum.NotPlaying}, --贝露贝特开打后播放
		[5] = {Id = 101090501,state = self.dialogStateEnum.NotPlaying}, --贝露贝特快死时播放
		[6] = {Id = 101090601,state = self.dialogStateEnum.NotPlaying}, --贝露贝特死时播放
	}
	
	self.bgmLogic = 
	{
		[1] = {
			Bgmtype = "Boss" ,
			BgmList = {
			[1] = {bgmName = "Baxilikesi_01",bgmState = false},
			[2] = {bgmName = "Baxilikesi_02",bgmState = false},
			[3] = {bgmName = "Baxilikesi_03",bgmState = false},
			  		  }
			  }
	}

	self.monLev = 10--怪物等级
end

function LevelBehavior1040801:Update()
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
		BehaviorFunctions.DoSetPosition(self.role,tp1.x,tp1.y,tp1.z)
		--召唤巴西利克斯
		local pos = BehaviorFunctions.GetTerrainPositionP("Boss1",10020001,"Logic10020001_6")
		self.baxilikes = BehaviorFunctions.CreateEntity(92002,nil,pos.x,pos.y,pos.z,nil,nil,nil,nil,self.monLev)
		BehaviorFunctions.DoLookAtTargetImmediately(self.baxilikes,self.role)
		--召唤贝露贝特
		local pos2 = BehaviorFunctions.GetTerrainPositionP("Boss1",10020001,"Logic10020001_6")
		self.beilubeite2 = BehaviorFunctions.CreateEntity(920011,nil,pos.x,pos.y,pos.z)
		BehaviorFunctions.DoLookAtTargetImmediately(self.beilubeite2,self.role)
		--巴西利克斯与贝露贝特合体
		BehaviorFunctions.EntityCombination(self.baxilikes,self.beilubeite2,true)
		--玩家看向巴西利克斯
		BehaviorFunctions.DoLookAtTargetImmediately(self.role,self.baxilikes)
		----看向巴西利克斯镜头
		--self.levelCam = BehaviorFunctions.CreateEntity(22001)
		--BehaviorFunctions.CameraEntityFollowTarget(self.levelCam,self.role,"CameraTarget")
		--self.empty = BehaviorFunctions.CreateEntity(2001,nil,pos.x,pos.y-5,pos.z)
		--BehaviorFunctions.CameraEntityLockTarget(self.levelCam,self.empty)
		----过一秒后移除镜头
		--BehaviorFunctions.AddDelayCallByFrame(30,BehaviorFunctions,BehaviorFunctions.RemoveEntity,self.levelCam)
		--BehaviorFunctions.AddDelayCallByFrame(30,BehaviorFunctions,BehaviorFunctions.RemoveEntity,self.empty)
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
		--巴西利克斯bgm开始
		BehaviorFunctions.SetActiveBGM("TRUE")--开启默认BGM
		self:BgmChangeLogic(self.bgmLogic,1,1)
		self.missionState = 5
	end

	--和巴西利克斯战斗的判断
	if self.missionState == 5 then
		local currentLifeRatio = BehaviorFunctions.GetEntityAttrValueRatio(self.baxilikes,1001)		
		--开场三秒后播放对话
		if self.roleTotalFrame - self.roleFrame == 100 and self.dialogList[2].state == self.dialogStateEnum.NotPlaying then
			BehaviorFunctions.StartStoryDialog(self.dialogList[2].Id)
			self.dialogList[2].state = self.dialogStateEnum.Playing
		end
		--巴西利克斯bgm逻辑
		if currentLifeRatio <= 6700 and self.bgmLogic[1].BgmList[2].bgmState == false then
			self:BgmChangeLogic(self.bgmLogic,1,2)
		elseif currentLifeRatio <= 3400 and self.bgmLogic[1].BgmList[3].bgmState == false then
			self:BgmChangeLogic(self.bgmLogic,1,3)
		end
	end

	--击败巴西利克斯，进入贝露贝特timeline
	if self.missionState == 6 then
		BehaviorFunctions.AddBuff(self.role,self.role,10011991)
		----添加Boss战结束缓时效果
		--BehaviorFunctions.AddBuff(self.role,self.role,900000065)
		--延迟下一个阶段
		BehaviorFunctions.AddDelayCallByFrame(30,self,self.Assignment,"missionState",6.2)
		--停止巴西利克斯BGM
		BehaviorFunctions.SetActiveBGM("FALSE")--关闭默认BGM
		--关闭空气墙
		BehaviorFunctions.ActiveSceneObj("airwall",false,self.levelId)
		--BehaviorFunctions.StartStoryDialog(self.dialogList[3].Id)
		self.missionState = 6.1
	end
	
	if self.missionState == 6.2 then
		BehaviorFunctions.StartStoryDialog(self.dialogList[3].Id)
		--BehaviorFunctions.StartStoryDialog(self.dialogList[3].Id)
		self.missionState = 7
	end
	
	--pv版切流程贝露贝特Boss战
	if self.missionState == 8 then
		--移除Boss战结束缓时效果
		BehaviorFunctions.RemoveBuff(self.role,900000065)
		BehaviorFunctions.CreateDuplicate(101070102)
		----传送到贝露贝特地图
		--BehaviorFunctions.Transport(500100001,252.86,2.151,130.8)
		self.missionState = 9
	end
	
	----创建贝露贝特
	--if self.missionState == 8 then
		----开启贝露贝特场景
		--BehaviorFunctions.ActiveSceneObjByPath("Scene10020001/SubScene",false)
		--BehaviorFunctions.ActiveSceneObj("blbt_Scene",true,self.levelId)
		----显示玩家模型
		----if BehaviorFunctions.HasBuffKind(self.role,900000010) == true then
			--BehaviorFunctions.RemoveBuff(self.role,900000010)
		----end
		----将玩家传送至目标位置
		--local tp1 = BehaviorFunctions.GetTerrainPositionP("tp_BossArea",10020001,"Logic10020001_6")
		--BehaviorFunctions.DoSetPosition(self.role,tp1.x,tp1.y,tp1.z)
		--local pos = BehaviorFunctions.GetTerrainPositionP("Boss1",10020001,"Logic10020001_6")
		--self.beilubeite = BehaviorFunctions.CreateEntity(92001,nil,pos.x,pos.y,pos.z,nil,nil,nil,nil,self.monLev)
		--BehaviorFunctions.DoLookAtTargetImmediately(self.beilubeite,self.role)
		--self.roleFrame = BehaviorFunctions.GetEntityFrame(self.role)
		--BehaviorFunctions.StartStoryDialog(self.dialogList[4].Id)
		--BehaviorFunctions.ShowTip(101070102)
		----瘫痪条逻辑
		--BehaviorFunctions.SetEntityValue(self.beilubeite,"canBreak",false)
		----看向贝露贝特镜头
		--self.levelCam = BehaviorFunctions.CreateEntity(22001)
		--BehaviorFunctions.DoLookAtTargetImmediately(self.role,self.beilubeite)
		--BehaviorFunctions.CameraEntityFollowTarget(self.levelCam,self.role,"CameraTarget")
		--self.empty = BehaviorFunctions.CreateEntity(2001,nil,pos.x,pos.y-5,pos.z)
		--BehaviorFunctions.CameraEntityLockTarget(self.levelCam,self.empty)
		----添加BossUI
		--BehaviorFunctions.SetEntityValue(1,"LevelUiTarget",self.beilubeite)
		----添加boss血条
		--if not BehaviorFunctions.HasEntitySign(1,10000020) then
			--BehaviorFunctions.AddEntitySign(1,10000020,-1)
		--end
		----过一秒后移除镜头
		--BehaviorFunctions.AddDelayCallByFrame(30,BehaviorFunctions,BehaviorFunctions.RemoveEntity,self.levelCam)
		--BehaviorFunctions.AddDelayCallByFrame(30,BehaviorFunctions,BehaviorFunctions.RemoveEntity,self.empty)
		----贝露贝特BGM
		--BehaviorFunctions.PlayBgmSound("Bgm_Boss_Lige")
		--self.missionState = 9
	--end

	----与贝露贝特战斗过程中
	--if self.missionState == 9 then
		----添加boss血条
		--if not BehaviorFunctions.HasEntitySign(1,10000020) then
			--BehaviorFunctions.AddEntitySign(1,10000020,-1)
		--end
		--local currentLifeRatio = BehaviorFunctions.GetEntityAttrValueRatio(self.beilubeite,1001)
		----贝露贝特15%血量对话
		--if currentLifeRatio <= 1500 and self.dialogList[5].state == self.dialogStateEnum.NotPlaying then
			--BehaviorFunctions.StartStoryDialog(self.dialogList[5].Id)
			--self.dialogList[5].state = self.dialogStateEnum.Playing
		--end
	--end
	
	----与贝露贝特战斗结束
	--if self.missionState == 10  then
		------开启黑幕
		----BehaviorFunctions.ShowBlackCurtain(true,0,false)		
		------延迟移除黑幕
		----BehaviorFunctions.AddDelayCallByFrame(60,BehaviorFunctions,BehaviorFunctions.ShowBlackCurtain,false,1,false)
		----关闭贝露贝特场景
		--BehaviorFunctions.ActiveSceneObjByPath("Scene10020001/SubScene",true)
		--BehaviorFunctions.ActiveSceneObj("blbt_Scene",false,self.levelId)
		--BehaviorFunctions.HideTip()
		----移除关卡
		--BehaviorFunctions.RemoveLevel(101070101)
		--self.missionState = 11
	--end
end

function LevelBehavior1040801:WeakGuide(guideId)
	for i,v in ipairs(self.weakGuide) do
		if v.Id == guideId then
			BehaviorFunctions.ShowWeakGuide(guideId)
			v.state = true
		end
	end
end

function LevelBehavior1040801:RemoveEntity(instanceId)

end

function LevelBehavior1040801:__delete()

end

--死亡事件
function LevelBehavior1040801:Die(attackInstanceId,dieInstanceId)
	--如若巴西利克斯死亡
	if dieInstanceId == self.baxilikes then
		--移除巴西利克斯BGM
		if BehaviorFunctions.HasBuffKind(1,900000016) then
			BehaviorFunctions.RemoveBuff(1,900000016)
		end
		----移除背上的贝露贝特
		--BehaviorFunctions.RemoveEntity(self.beilubeite2)
		--BehaviorFunctions.DoMagic(self.baxilikes,self.baxilikes,900000010)
		--发送第一次任务进度，代表龙副本完成
		BehaviorFunctions.SendTaskProgress(101070101,1,1)
		self.missionState = 6
		
	elseif dieInstanceId == self.beilubeite then
		----发送第一次任务进度，代表副本完成
		--BehaviorFunctions.SendTaskProgress(101070101,1,1)
	end
end

--死亡动画后事件
function LevelBehavior1040801:Death(instanceId,isFormationRevive)
	if isFormationRevive then
		BehaviorFunctions.StopBgmSound()
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
	--else
		----贝露贝特死亡
		--if instanceId == self.beilubeite then
			--BehaviorFunctions.StopBgmSound()
			----移除贝露贝特BGM
			--if BehaviorFunctions.HasBuffKind(1,900000017) then
				--BehaviorFunctions.RemoveBuff(1,900000017)
			--end
			--self.missionState = 10
		--end
	end
end

function LevelBehavior1040801:StoryStartEvent(dialogId)

end

function LevelBehavior1040801:StoryEndEvent(dialogId)
	for i,v in ipairs(self.dialogList) do
		if dialogId == v.Id then
			if self.missionState == 1 and dialogId == self.dialogList[1].Id then
				self.missionState = 4
			end
			
			if self.missionState == 7 and dialogId == self.dialogList[3].Id then
				self.missionState = 8
			end

			v.state = self.dialogStateEnum.PlayOver
			self.currentDialog = nil
		end
	end
end

function LevelBehavior1040801:BgmChangeLogic(group,groupNum,memberNum)
	if group then
		BehaviorFunctions.SetBgmState("BgmType",group[groupNum].Bgmtype)
		BehaviorFunctions.SetBgmState("GamePlayType",group[groupNum].BgmList[memberNum].bgmName)
		group[groupNum].BgmList[memberNum].bgmState = true
	else
		BehaviorFunctions.SetBgmState("BgmType","GamePlay")
		BehaviorFunctions.SetBgmState("GamePlayType","Explore")
	end
end

--赋值
function LevelBehavior1040801:Assignment(variable,value)
	self[variable] = value
end
