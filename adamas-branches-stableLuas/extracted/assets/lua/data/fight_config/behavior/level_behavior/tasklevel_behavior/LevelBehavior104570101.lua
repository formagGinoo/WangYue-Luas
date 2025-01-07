LevelBehavior104570101 = BaseClass("LevelBehavior104570101",LevelBehaviorBase)
--Boss战贝露贝特和巴西利克斯
function LevelBehavior104570101:__init(fight)
	self.fight = fight
end

function LevelBehavior104570101.GetGenerates()
	local generates = {920011,709200200}
	return generates
end

function LevelBehavior104570101.GetStorys()
	local storys = {}
	return storys
end

----程序黑幕
--function LevelBehavior104570101.NeedBlackCurtain()
--return true
--end

function LevelBehavior104570101:Init()
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
		[3] = {Id = 490001,state = self.dialogStateEnum.NotPlaying},	--巴西利克斯死亡播放
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
	self.monsterLevelBias = {     --怪物世界等级偏移
		[FightEnum.EntityNpcTag.Monster] = 0,
		[FightEnum.EntityNpcTag.Elite] = 0,
		[FightEnum.EntityNpcTag.Boss] = 5,
	}
end

function LevelBehavior104570101:Update()
	self.role = BehaviorFunctions.GetCtrlEntity()
	self.roleTotalFrame = BehaviorFunctions.GetEntityFrame(self.role)

	--开场剧情
	if self.missionState == 0 then
		local inArea = BehaviorFunctions.CheckEntityInArea(self.role,"BossArea","Logic104570101")
		if inArea then
			BehaviorFunctions.SetActiveBGM("FALSE")--关闭默认BGM
			self.missionState = 1
		end
	
		--怪物出生处理
	elseif self.missionState == 1 then
		--将玩家传送至场地内
		local tp1 = BehaviorFunctions.GetTerrainPositionP("tp_BossArea",104570101)
		BehaviorFunctions.Transport(104570101,tp1.x,tp1.y,tp1.z)
		BehaviorFunctions.DoSetPosition(self.role,tp1.x,tp1.y,tp1.z)
		--世界等级偏移计算
		local npcTag = BehaviorFunctions.GetTagByEntityId(709200200)
		local worldMonsterLevel = BehaviorFunctions.GetEcoEntityLevel(npcTag)
		local monsterLevel = worldMonsterLevel + self.monsterLevelBias[npcTag]
		--召唤巴西利克斯
		local pos = BehaviorFunctions.GetTerrainPositionP("Boss1",104570101)
		self.baxilikes = BehaviorFunctions.CreateEntity(709200200,nil,pos.x,pos.y,pos.z,nil,nil,nil,self.levelId,monsterLevel)
		BehaviorFunctions.DoLookAtTargetImmediately(self.baxilikes,self.role)
		--召唤贝露贝特
		local pos2 = BehaviorFunctions.GetTerrainPositionP("Boss1",104570101)
		self.beilubeite2 = BehaviorFunctions.CreateEntity(920011,nil,pos.x,pos.y,pos.z,nil,nil,nil,self.levelId)
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
		BehaviorFunctions.ShowTip(104570101)
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

		--巴西利克斯bgm逻辑
		if currentLifeRatio <= 6700 and self.bgmLogic[1].BgmList[2].bgmState == false then
			self:BgmChangeLogic(self.bgmLogic,1,2)
		elseif currentLifeRatio <= 3400 and self.bgmLogic[1].BgmList[3].bgmState == false then
			self:BgmChangeLogic(self.bgmLogic,1,3)
		end
	end

	--击败巴西利克斯，进入贝露贝特timeline
	if self.missionState == 6 then
		--BehaviorFunctions.AddBuff(self.role,self.role,10011991)
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
		--BehaviorFunctions.StartStoryDialog(self.dialogList[3].Id)
		self.missionState = 8
	end

	--pv版切流程贝露贝特Boss战
	if self.missionState == 8 then
		--移除Boss战结束缓时效果
		BehaviorFunctions.RemoveBuff(self.role,900000065)
		BehaviorFunctions.FinishLevel(104570101)
		self.missionState = 9
	end

	
end

function LevelBehavior104570101:WeakGuide(guideId)
	for i,v in ipairs(self.weakGuide) do
		if v.Id == guideId then
			BehaviorFunctions.ShowWeakGuide(guideId)
			v.state = true
		end
	end
end

function LevelBehavior104570101:RemoveEntity(instanceId)

end

function LevelBehavior104570101:__delete()

end

--死亡事件
function LevelBehavior104570101:Die(attackInstanceId,dieInstanceId)
	--如若巴西利克斯死亡
	if dieInstanceId == self.baxilikes then
		--移除巴西利克斯BGM
		if BehaviorFunctions.HasBuffKind(1,900000016) then
			BehaviorFunctions.RemoveBuff(1,900000016)
		end
		self.missionState = 6

	elseif dieInstanceId == self.beilubeite then
		----发送第一次任务进度，代表副本完成

	end
end

--死亡动画后事件
function LevelBehavior104570101:Death(instanceId,isFormationRevive)
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
		----移除关卡
		--BehaviorFunctions.RemoveLevel(104570101)

	end
end

function LevelBehavior104570101:StoryStartEvent(dialogId)

end


function LevelBehavior104570101:BgmChangeLogic(group,groupNum,memberNum)
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
function LevelBehavior104570101:Assignment(variable,value)
	self[variable] = value
end
