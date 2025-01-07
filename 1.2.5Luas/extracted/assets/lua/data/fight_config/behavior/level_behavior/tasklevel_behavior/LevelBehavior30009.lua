LevelBehavior30009 = BaseClass("LevelBehavior30009",LevelBehaviorBase)
--动态创建关卡1
function LevelBehavior30009:__init(fight)
	self.fight = fight
end


function LevelBehavior30009.GetGenerates()
	local generates = {92001,92002,910024,900040,2030201,2030202}
	return generates
end

BehaviorFunctions.StartStoryDialog(101030201)
function LevelBehavior30009:Init()
	self.role = BehaviorFunctions.GetCtrlEntity()
	self.missionState = 0
	self.currentDialog = nil
	self.dialogStateEnum = {
		Default = 0,
		NotPlaying = 1,
		Playing = 2,
		PlayOver = 3,
	}
	self.dialogList =
	 {
		[23] = {Id = 101010101,state = self.dialogStateEnum.NotPlaying},
		[24] = {Id = 101010201,state = self.dialogStateEnum.NotPlaying},
		[1] = {Id = 101030101,state = self.dialogStateEnum.NotPlaying},
		[2] = {Id = 101030201,state = self.dialogStateEnum.NotPlaying},
		[3] = {Id = 101030301,state = self.dialogStateEnum.NotPlaying},
		[4] = {Id = 101030401,state = self.dialogStateEnum.NotPlaying},
		[5] = {Id = 101040101,state = self.dialogStateEnum.NotPlaying},
		[6] = {Id = 101040201,state = self.dialogStateEnum.NotPlaying},
		[7] = {Id = 101050101,state = self.dialogStateEnum.NotPlaying},
		[8] = {Id = 101060101,state = self.dialogStateEnum.NotPlaying},
		[9] = {Id = 101060801,state = self.dialogStateEnum.NotPlaying},
		[10] = {Id = 101060901,state = self.dialogStateEnum.NotPlaying},
		[11] = {Id = 101061001,state = self.dialogStateEnum.NotPlaying},
		[12] = {Id = 101061101,state = self.dialogStateEnum.NotPlaying},
		[13] = {Id = 101070101,state = self.dialogStateEnum.NotPlaying},
		[14] = {Id = 101070201,state = self.dialogStateEnum.NotPlaying},
		[15] = {Id = 101070301,state = self.dialogStateEnum.NotPlaying},
		[16] = {Id = 101070401,state = self.dialogStateEnum.NotPlaying},
		[17] = {Id = 101070501,state = self.dialogStateEnum.NotPlaying},
		[18] = {Id = 101070601,state = self.dialogStateEnum.NotPlaying},
		[19] = {Id = 101070701,state = self.dialogStateEnum.NotPlaying},
		[20] = {Id = 101070801,state = self.dialogStateEnum.NotPlaying},
		[21] = {Id = 101080101,state = self.dialogStateEnum.NotPlaying},
		[22] = {Id = 101080201,state = self.dialogStateEnum.NotPlaying},

		}
	self.monsterStateEnum = {
		Default = 0,
		Live = 1,
		Dead = 2,
	}
	self.monsterList = 
	{
		[1] = {Id = nil , state = self.monsterStateEnum.Default ,bp = "mb1",entityId = 900040},
		[2] = {Id = nil , state = self.monsterStateEnum.Default ,bp = "mb2",entityId = 900040},
		[3] = {Id = nil , state = self.monsterStateEnum.Default ,bp = "mb3",entityId = 900040},
		[4] = {Id = nil , state = self.monsterStateEnum.Default ,bp = "mb4",entityId = 900040},
		[5] = {Id = nil , state = self.monsterStateEnum.Default ,bp = "mb5",entityId = 900040},
		[6] = {Id = nil , state = self.monsterStateEnum.Default ,bp = "mb6",entityId = 900040},
	}

	
	self.weakGuide = 
	{
		[1] = {Id = 20001,state = false,Describe ="推动摇杆进行移动"},
		[2] = {Id = 20002,state = false,Describe ="长按进入跑步状态"},
		[3] = {Id = 20003,state = false,Describe ="连续点击2次跳跃可二段跳"},
		[4] = {Id = 20004,state = false,Describe ="长按在墙面上奔跑"},
		[5] = {Id = 20005,state = false,Describe ="点击按钮使用普通攻击"},

		}
	
	self.checkPointList = 
	{
		[1] = {name = "checkPoint1",mission =2,state = false},
		[2] = {name = "checkPoint2",mission =3,state = false},
		[3] = {name = "checkPoint3",mission =5,state = false},
		[4] = {name = "checkPoint4",mission =7,state = false},
		[5] = {name = "checkPoint5",mission =10,state = false},
		[6] = {name = "checkPoint6",mission =12,state = false},
		[7] = {name = "checkPoint7",mission =13,state = false},
		[8] = {name = "checkPoint8",mission =17,state = false},
		[9] = {name = "checkPoint9",mission =21,state = false},
		[10] = {name = "checkPoint10",mission =23,state = false},
		[11] = {name = "checkPoint11",mission =25,state = false},
		[12] = {name = "checkPoint12",mission =32,state = false},

		}
	
	self.currentCheckPoint = nil
	self.nextTargetPos = nil
	
	self.weakGuideDuration = 0
	self.imageGuideDuration = 0
	
	self.roleFrame = nil
	self.boss2QTEphase = 0
	
	self.time = 0
	self.tipsTimer = 0
end

function LevelBehavior30009:Update()
	self.role = BehaviorFunctions.GetCtrlEntity()
	self.frame = BehaviorFunctions.GetFightFrame()
	self.roleTotalFrame = BehaviorFunctions.GetEntityFrame(self.role)
	
	--更新复活点
	self:UpdataCheckPoint()
	
	--关卡阶段0：找到司命
	if self.missionState == 0 then
		--隐藏按钮
		self:HideButton()
		
		--创建叙慕
		local pb1 = BehaviorFunctions.GetTerrainPositionP("pb1",20010005)
		BehaviorFunctions.SetPlayerBorn(pb1.x,pb1.y,pb1.z-5)
		--初始朝向镜头
		local fp1 = BehaviorFunctions.GetTerrainPositionP("fp1",20010005)
		self.empty = BehaviorFunctions.CreateEntity(2001,nil,fp1.x,fp1.y,fp1.z)
		self.levelCam = BehaviorFunctions.CreateEntity(22001)
		BehaviorFunctions.CameraEntityFollowTarget(self.levelCam,self.role,"CameraTarget")
		BehaviorFunctions.CameraEntityLockTarget(self.levelCam,self.empty)
		--创建花墙1和司命
		local flower1P = BehaviorFunctions.GetTerrainPositionP("flower1",20010005)
		local flower1R = BehaviorFunctions.GetTerrainRotationP("flower1",20010005)
		self.flower1 = BehaviorFunctions.CreateEntity(2030201,nil,flower1P.x,flower1P.y,flower1P.z)
		BehaviorFunctions.SetEntityEuler(self.flower1,flower1R.x,flower1R.y,flower1R.z)
		--创建花墙2
		local flower2P = BehaviorFunctions.GetTerrainPositionP("flower2",20010005)
		local flower2R = BehaviorFunctions.GetTerrainRotationP("flower2",20010005)
		self.flower2 = BehaviorFunctions.CreateEntity(2030202,nil,flower2P.x,flower2P.y,flower2P.z)
		BehaviorFunctions.SetEntityEuler(self.flower2,flower1R.x,flower2R.y,flower2R.z)
		--起名timeline
		BehaviorFunctions.StartStoryDialog(self.dialogList[23].Id)
		self.missionState = 1
	end
	
	--关卡阶段1：叙慕在附近听到了司命的抱怨声
	if self.missionState == 2 then
		--看完第一段剧情拉回镜头
		if BehaviorFunctions.CheckEntity(self.levelCam) then
			--弱引导推动摇杆
			self:WeakGuide(self.weakGuide[1].Id)
			BehaviorFunctions.RemoveEntity(self.levelCam)
		end
		
		local tutorialArea1 = BehaviorFunctions.CheckEntityInArea(self.role,"Tips20003","Logic10020001_1")
		if tutorialArea1 == true and self.weakGuide[3].state == false then
			--隐藏推动摇杆弱引导
			BehaviorFunctions.ShowWeakGuide(self.weakGuide[1].Id,true)
			--弱引导二段跳
			self:WeakGuide(self.weakGuide[3].Id)
		end
		
		local tutorialArea2 = BehaviorFunctions.CheckEntityInArea(self.role,"Tips20002","Logic10020001_1")
		if tutorialArea2 == true and self.weakGuide[2].state == false then
			--隐藏二段跳弱引导
			BehaviorFunctions.ShowWeakGuide(self.weakGuide[3].Id,true)
			--弱引导进行疾跑
			self:WeakGuide(self.weakGuide[2].Id)
		end
		
		local inArea = BehaviorFunctions.CheckEntityInArea(self.role,"Tips2000101","Logic10020001_1")
		if inArea == true and self.imageGuideDuration < 1 then
			--图片引导爬墙教学
			BehaviorFunctions.ShowGuideImageTips(20001)
			self.imageGuideDuration = 1
		end
		
		local inArea2 = BehaviorFunctions.CheckEntityInArea(self.role,"TL101030201","Logic10020001_1")
		if inArea2 == true then
			BehaviorFunctions.StartStoryDialog(self.dialogList[2].Id)
			self.missionState = 4
		end
	end
	
	--攀爬跑墙辅助
	if self.missionState < 4 
		or 22 < self.missionState and self.missionState < 25 then
		self.time = BehaviorFunctions.GetFightFrame()
		if self.time > self.tipsTimer then
			self.weakGuide[4].state = false
			self.tipsTimer = 0
		end
		if BehaviorFunctions.GetEntityState(self.role) == FightEnum.EntityState.Climb then
			--隐藏疾跑弱引导
			BehaviorFunctions.ShowWeakGuide(self.weakGuide[2].Id,true)
			--隐藏二段跳弱引导
			BehaviorFunctions.ShowWeakGuide(self.weakGuide[3].Id,true)
			if self.weakGuide[4].state == false then
				if self.tipsTimer == 0 then
					self.tipsTimer = BehaviorFunctions.GetFightFrame()+150
					self:WeakGuide(self.weakGuide[4].Id)
				end
			end
		end
	end
	--关闭攀爬辅助
	if BehaviorFunctions.GetEntityState(self.role) ~= FightEnum.EntityState.Climb then
		if self.weakGuide[4].state == true then
			BehaviorFunctions.ShowWeakGuide(self.weakGuide[4].Id,true)
			self.weakGuide[4].state = false
		end
	end
	
	--关卡阶段2：叙慕看到了花墙上的司命
	if self.missionState == 4 then
		local inArea = BehaviorFunctions.CheckEntityInArea(self.role,"TL101030301","Logic10020001_1")
		if inArea == true then
			BehaviorFunctions.StartStoryDialog(self.dialogList[3].Id)
			self.missionState = 5
		end
	end
	
	--关卡阶段3：叙慕需要打破花墙解救司命
	if self.missionState == 6 then
		if self.imageGuideDuration < 2 then
			local closeCallback = function()
				--弱引导普攻
				if self.weakGuide[5].state == false then
					self:WeakGuide(self.weakGuide[5].Id)
					self.weakGuide[5].state = true
				end
			end
			--图片引导爬清除淤脉
			BehaviorFunctions.ShowGuideImageTips(20003,closeCallback)
			self.imageGuideDuration = 2
		end
		if self.flower1 == nil then
			BehaviorFunctions.StartStoryDialog(self.dialogList[4].Id)
			if self.weakGuide[5].state == true then
				--隐藏普攻弱引导
				BehaviorFunctions.ShowWeakGuide(self.weakGuide[5].Id,true)
				self.weakGuide[5].state = false
			end
			self.missionState = 7
		end
	end
	
	--关卡阶段4：叙慕被司命告知一路向上
	if self.missionState == 8 then
		--给个镜头看向山顶
		local inArea = BehaviorFunctions.CheckEntityInArea(self.role,"SceneCamArea1","Logic10020001_1")
		if inArea == true then
			self:FocusPosCamera("fp2",22003,120,self.role)
			self.weakGuide[5].state = false
			self.missionState = 10
			----mission9先预留
		end
	end
	
	--关卡阶段5：前往山顶的中途遇到第一波怪物，基础普攻教学
	if self.missionState == 10 then
		if self.dialogList[5].state == self.dialogStateEnum.NotPlaying then
			local inArea = BehaviorFunctions.CheckEntityInArea(self.role,"TL101040101","Logic10020001_1")
			if inArea == true then
				--召唤战斗区域1的2只小怪
				local monsterList = {1,2}
				for i,v in ipairs (monsterList) do
					local pos = BehaviorFunctions.GetTerrainPositionP(self.monsterList[v].bp,20010005)
					self.monsterList[v].Id = BehaviorFunctions.CreateEntity(self.monsterList[v].entityId,nil,pos.x,pos.y,pos.z)
					self.monsterList[v].state = self.monsterStateEnum.Live
					BehaviorFunctions.DoLookAtTargetImmediately(self.monsterList[v].Id,self.role)
					BehaviorFunctions.SetEntityValue(self.monsterList[v].Id,"haveWarn",false)
					--BehaviorFunctions.AddBuff(self.monsterList[v].Id,self.monsterList[v].Id,900000012)
				end
				BehaviorFunctions.StartStoryDialog(self.dialogList[5].Id)
				self.dialogList[5].state = self.dialogStateEnum.Playing
				--弱引导普攻
				if self.weakGuide[5].state == false then
					self:WeakGuide(self.weakGuide[5].Id)
					self.weakGuide[5].state = true
				end
			end
		end
		local monsterList = {1,2}
		local listLenth = #monsterList
		for i,v in ipairs (monsterList) do
			if self.monsterList[v].state ~= self.monsterStateEnum.Dead then
				return 
			else 
				if i == listLenth then
					if self.weakGuide[5].state == true then
						--隐藏普攻弱引导
						BehaviorFunctions.ShowWeakGuide(self.weakGuide[5].Id,true)
						self.weakGuide[5].state = false
					end
					self.missionState = 12
					BehaviorFunctions.StartStoryDialog(self.dialogList[6].Id)
					if BehaviorFunctions.CheckEntity(self.flower2) then
						--玩家看着花墙消失
						local pos = BehaviorFunctions.GetTerrainPositionP("watchPosition1",20010005)
						self.empty = BehaviorFunctions.CreateEntity(2001,nil,pos.x,pos.y,pos.z)
						self.levelCam = BehaviorFunctions.CreateEntity(22001)
						BehaviorFunctions.CameraEntityFollowTarget(self.levelCam,self.empty)
						BehaviorFunctions.CameraEntityLockTarget(self.levelCam,self.flower2)
						BehaviorFunctions.AddDelayCallByFrame(80,BehaviorFunctions,BehaviorFunctions.RemoveEntity,self.levelCam)
						BehaviorFunctions.AddDelayCallByFrame(80,BehaviorFunctions,BehaviorFunctions.RemoveEntity,self.empty)
						BehaviorFunctions.DoLookAtTargetImmediately(self.role,self.flower2)
						BehaviorFunctions.SetEntityAttr(self.flower2,1001,0)
					end
					--mission11先预留
				end
			end
		end
	end
	
	--关卡阶段6：叙慕靠近了气脉竹
	if self.missionState == 12 then
		local inArea = BehaviorFunctions.CheckEntityInArea(self.role,"TL101050101","Logic10020001_1")
		if inArea == true then
			BehaviorFunctions.StartStoryDialog(self.dialogList[7].Id)
			self.missionState = 13
		end
	end
	
	--关卡阶段7：司命发现前方插着一把剑
	if self.missionState == 14 then
		--给个镜头看向剑
			self.missionState = 16
		--misson15先预留
	end
	
	--关卡阶段8：叙慕拿起了剑，回想起了和贝露贝特的过往
	if self.missionState == 16 then
		local inArea = BehaviorFunctions.CheckEntityInArea(self.role,"TL101060101","Logic10020001_1")
		if inArea == true then
			BehaviorFunctions.StartStoryDialog(self.dialogList[8].Id)
			self.missionState = 17
		end
	end
	
	--关卡阶段9：叙慕结束了回忆，此时发现周围已经被敌人包围
	if self.missionState == 18 then
		BehaviorFunctions.SetFightMainNodeVisible(2,"I",true) --技能
		--BehaviorFunctions.SetFightMainNodeVisible(2,"L",true) --大招
		BehaviorFunctions.SetFightMainNodeVisible(2,"Core",true) --被动条
		--BehaviorFunctions.SetFightMainNodeVisible(2,"R",true) --缔约
		--将玩家传送至场地内
		local tp2 = BehaviorFunctions.GetTerrainPositionP("tp2",20010005)
		BehaviorFunctions.DoSetPosition(self.role,tp2.x,tp2.y,tp2.z)
		local inArea = BehaviorFunctions.CheckEntityInArea(self.role,"TL101060101","Logic10020001_1")
		--召唤战斗区域2的三只小怪
		local monsterList = {3,4,5}
		for i,v in ipairs (monsterList) do
			local pos = BehaviorFunctions.GetTerrainPositionP(self.monsterList[v].bp,20010005)
			self.monsterList[v].Id = BehaviorFunctions.CreateEntity(self.monsterList[v].entityId,nil,pos.x,pos.y,pos.z)
			self.monsterList[v].state = self.monsterStateEnum.Live
			BehaviorFunctions.DoLookAtTargetImmediately(self.monsterList[v].Id,self.role)
			BehaviorFunctions.SetEntityValue(self.monsterList[v].Id,"haveWarn",false)
			BehaviorFunctions.AddBuff(self.monsterList[v].Id,self.monsterList[v].Id,900000012)
		end
		if inArea == true then
			BehaviorFunctions.StartStoryDialog(self.dialogList[9].Id)
			self.missionState = 19
		end
	end
	
	--关卡阶段10
	if self.missionState == 20 then
		local monsterList = {3,4,5}
		local listLenth = #monsterList
		local count = 0
		local inArea = BehaviorFunctions.CheckEntityInArea(self.role,"TL101061001","Logic10020001_1")
		for i,v in ipairs (monsterList) do
			if BehaviorFunctions.CheckEntity(self.monsterList[v].Id) == true then
				if BehaviorFunctions.HasBuffKind(self.monsterList[v].Id,900000012) then
					BehaviorFunctions.RemoveBuff(self.monsterList[v].Id,900000012)
				end
			end
			--分支1：如果击杀了三只怪物
			if self.monsterList[v].state == self.monsterStateEnum.Dead then
				count = count + 1
				if count == listLenth then
					BehaviorFunctions.StartStoryDialog(self.dialogList[10].Id)
					self.missionState = 21
				end
			else
			--分支2：如果没有击杀三只怪物
				if inArea == true then
					BehaviorFunctions.StartStoryDialog(self.dialogList[11].Id)
					self.dialogList[11].state = self.dialogStateEnum.Playing
					self.missionState = 21
				end

			end
		end
	end
	
	--关卡阶段11：叙慕继续朝上前进
	if self.missionState == 22 then
		local inArea = BehaviorFunctions.CheckEntityInArea(self.role,"TL101061101","Logic10020001_1")
		if inArea == true then
			BehaviorFunctions.StartStoryDialog(self.dialogList[12].Id)
			self.missionState = 24
		end
	end
	
	--关卡阶段12：叙慕到了山顶
	if self.missionState == 24 then
		local inArea = BehaviorFunctions.CheckEntityInArea(self.role,"TL101070101","Logic10020001_1")
		if inArea == true then
			--将玩家传送至场地内
			local tp1 = BehaviorFunctions.GetTerrainPositionP("tp1",20010005)
			BehaviorFunctions.DoSetPosition(self.role,tp1.x,tp1.y,tp1.z)
			--播放boss出场timeline
			BehaviorFunctions.StartStoryDialog(self.dialogList[13].Id)
			--召唤巴西利克斯
			local pos = BehaviorFunctions.GetTerrainPositionP("Boss1",20010005)
			self.baxilikes = BehaviorFunctions.CreateEntity(92002,nil,pos.x,pos.y,pos.z)
			BehaviorFunctions.DoLookAtTargetImmediately(self.baxilikes,self.role)
			--暂停巴西利克斯行为树
			BehaviorFunctions.SetEntityValue(self.baxilikes,"Stop",true)
			BehaviorFunctions.ActiveSceneObj("airwall",true,self.levelId)
			self.missionState = 25
		end
	end
	
	--战斗中途对话
	if self.missionState == 26 then
		if self.roleFrame == nil then
			self.roleFrame = BehaviorFunctions.GetEntityFrame(self.role)
		elseif self.roleTotalFrame - self.roleFrame == 100 and self.dialogList[14].state == self.dialogStateEnum.PlayOver then
			BehaviorFunctions.StartStoryDialog(self.dialogList[14].Id)
			self.roleFrame = BehaviorFunctions.GetEntityFrame(self.role)
		elseif self.roleTotalFrame - self.roleFrame == 400 and self.dialogList[15].state ~= self.dialogStateEnum.PlayOver then
			BehaviorFunctions.StartStoryDialog(self.dialogList[15].Id)
			self.roleFrame = BehaviorFunctions.GetEntityFrame(self.role)
		elseif self.roleTotalFrame - self.roleFrame == 700 and self.dialogList[16].state ~= self.dialogStateEnum.PlayOver then
			BehaviorFunctions.StartStoryDialog(self.dialogList[16].Id)
			self.roleFrame = BehaviorFunctions.GetEntityFrame(self.role)
		else 
			if BehaviorFunctions.CheckEntity(self.baxilikes) ~= true then
				self.missionState = 28
			end
		end
	end
	
	--击败巴西利克斯，准备打贝露贝特
	if self.missionState == 28 then
		local pos = BehaviorFunctions.GetTerrainPositionP("Boss1",20010005)
		self.beilubeite = BehaviorFunctions.CreateEntity(92001,nil,pos.x,pos.y,pos.z)
		BehaviorFunctions.DoLookAtTargetImmediately(self.beilubeite,self.role)
		self.roleFrame = BehaviorFunctions.GetEntityFrame(self.role)
		BehaviorFunctions.StartStoryDialog(self.dialogList[17].Id)
		self.missionState = 29
	end
	
	--与贝露贝特战斗过程中
	if self.missionState == 30 then
		local currentLifeRatio = BehaviorFunctions.GetEntityAttrValueRatio(self.beilubeite,1001)
		--拼刀QTE1对话
		if currentLifeRatio <= 5000 and currentLifeRatio > 1000 and self.dialogList[18].state == self.dialogStateEnum.NotPlaying then
			BehaviorFunctions.StartStoryDialog(self.dialogList[18].Id)
			self.dialogList[18].state = self.dialogStateEnum.Playing
		end

		--拼刀QTE2对话
		--elseif currentLifeRatio <= 1000 and currentLifeRatio > 0 and self.dialogList[19].state == self.dialogStateEnum.NotPlaying then
			--BehaviorFunctions.StartStoryDialog(self.dialogList[19].Id)
		--end
		
		----QTE1结束对话
		--if self.boss2QTEphase == 1 and self.dialogList[16].state == self.dialogStateEnum.NotPlaying then
			--BehaviorFunctions.StartStoryDialog(self.dialogList[16].Id)
		--end
		
		----QTE2结束对话
		--if self.boss2QTEphase == 2 and self.dialogList[20].state == self.dialogStateEnum.NotPlaying then
			--BehaviorFunctions.StartStoryDialog(self.dialogList[20].Id)
			--self.boss2QTEphase = 3
		--end
		
		--贝露贝特死亡
		if BehaviorFunctions.CheckEntity(self.beilubeite) ~= true then
			BehaviorFunctions.StartStoryDialog(self.dialogList[19].Id)
			--BehaviorFunctions.StartStoryDialog(self.dialogList[21].Id)
			BehaviorFunctions.ActiveSceneObj("airwall",false,self.levelId)
			self.missionState = 32
		end
	end
	
	
	--关卡阶段14：叙慕看到大世界
	if self.missionState == 32 then
		local inArea = BehaviorFunctions.CheckEntityInArea(self.role,"TL101080201","Logic10020001_1")
		if inArea == true then
			--将玩家传送至场地内
			local tp3 = BehaviorFunctions.GetTerrainPositionP("tp3",20010005)
			BehaviorFunctions.DoSetPosition(self.role,tp3.x,tp3.y,tp3.z)
			BehaviorFunctions.StartStoryDialog(self.dialogList[22].Id)
			self.missionState = 33
		end
	end
end

--延迟移除实体
function LevelBehavior30009:DelayRemoveEntity(InstanceId)
	if BehaviorFunctions.CheckEntity(InstanceId) == true then
		BehaviorFunctions.RemoveEntity(InstanceId)
	end
end

function LevelBehavior30009:Die(attackInstanceId,dieInstanceId)
	BehaviorFunctions.AddDelayCallByFrame(90,self,self.RevivePlayer)
	if dieInstanceId == self.flower1 then
		self.flower1 = nil		
	end
end

function LevelBehavior30009:FocusPosCamera(pos,cameraType,frame,follow,bone)
	local fp = BehaviorFunctions.GetTerrainPositionP(pos,20010005)
	self.empty = BehaviorFunctions.CreateEntity(2001,nil,fp.x,fp.y,fp.z)
	local levelCam = BehaviorFunctions.CreateEntity(cameraType)
	--选择跟随点
	if follow then
		if bone then
			BehaviorFunctions.CameraEntityFollowTarget(levelCam,follow,bone)
		else
			BehaviorFunctions.CameraEntityFollowTarget(levelCam,follow)
		end
	else
		BehaviorFunctions.CameraEntityFollowTarget(levelCam,self.role)
	end
	--注视目标点
	BehaviorFunctions.CameraEntityLockTarget(levelCam,self.empty)
	--添加延时移除
	BehaviorFunctions.AddDelayCallByFrame(frame,self,self.DelayRemoveEntity,levelCam)
	BehaviorFunctions.AddDelayCallByFrame(frame,self,self.DelayRemoveEntity,self.empty)
	--禁用省略过渡
	BehaviorFunctions.SetCanCameraInput(false)
	BehaviorFunctions.ForbidKey(FightEnum.KeyEvent.ScreenPress,true)
	BehaviorFunctions.ForbidKey(FightEnum.KeyEvent.ScreenMove,true)
	--恢复省略过渡
	BehaviorFunctions.AddDelayCallByFrame(frame,BehaviorFunctions,BehaviorFunctions.SetCanCameraInput,true)
	BehaviorFunctions.AddDelayCallByFrame(frame,BehaviorFunctions,BehaviorFunctions.ForbidKey,FightEnum.KeyEvent.ScreenPress,false)
	BehaviorFunctions.AddDelayCallByFrame(frame,BehaviorFunctions,BehaviorFunctions.ForbidKey,FightEnum.KeyEvent.ScreenMove,false)
end

function LevelBehavior30009:UpdataCheckPoint()
	for i,v in ipairs(self.checkPointList) do
		if v.mission == self.missionState then
			if self.currentCheckPoint ~= v.name then
				self.currentCheckPoint = v.name
				if i ~= #self.checkPointList then
					self.nextTargetPos = self.checkPointList[i + 1].name
				end
				v.state = true
			end
		end
	end
end

function LevelBehavior30009:RevivePlayer()
	if BehaviorFunctions.GetEntityAttrValueRatio(self.role,1001) == 0 then
		if BehaviorFunctions.GetEntityState(self.role) == FightEnum.EntityState.Death then
			BehaviorFunctions.SetEntityAttr(self.role,1001,20000)
			local pos = BehaviorFunctions.GetTerrainPositionP(self.currentCheckPoint,20010005)
			BehaviorFunctions.DoSetPosition(self.role,pos.x,pos.y,pos.z)
			local targetPos = BehaviorFunctions.GetTerrainPositionP(self.nextTargetPos,20010005)
			local empty = BehaviorFunctions.CreateEntity(2001,nil,targetPos.x,targetPos.y,targetPos.z)
			BehaviorFunctions.DoLookAtTargetImmediately(self.role,empty)
			self:FocusPosCamera(self.nextTargetPos,22001,0,self.role)
			BehaviorFunctions.AddDelayCallByFrame(120,self,self.DelayRemoveEntity,empty)
		end
	end
end

function LevelBehavior30009:HideButton()
	BehaviorFunctions.SetFightMainNodeVisible(2,"I",false) --技能
	BehaviorFunctions.SetFightMainNodeVisible(2,"L",false) --大招
	BehaviorFunctions.SetFightMainNodeVisible(2,"Core",false) --被动条
	BehaviorFunctions.SetFightMainNodeVisible(2,"R",false) --缔约
end

function LevelBehavior30009:WeakGuide(guideId)
	for i,v in ipairs(self.weakGuide) do
		if v.Id == guideId then
			BehaviorFunctions.ShowWeakGuide(guideId)
			v.state = true
		end
	end
end

function LevelBehavior30009:StoryStartEvent(dialogId)
	for i,v in ipairs(self.dialogList) do
		if dialogId == v.Id then
			v.state = self.dialogStateEnum.Playing
			self.currentDialog = v.Id
		end
	end
end

function LevelBehavior30009:StoryEndEvent(dialogId)
	for i,v in ipairs(self.dialogList) do
		if dialogId == v.Id then
			if self.missionState == 1 and dialogId == self.dialogList[23].Id then
				--救熊猫timeline
				BehaviorFunctions.StartStoryDialog(self.dialogList[24].Id)
			end
			if self.missionState == 1 and dialogId == self.dialogList[24].Id then
				--寻找司命timeline
				BehaviorFunctions.StartStoryDialog(self.dialogList[1].Id)
			end
			if self.missionState == 1 and dialogId == self.dialogList[1].Id then
				self.missionState = 2
			end
			--if self.missionState == 3 and dialogId == self.dialogList[2].Id then
				--self.missionState = 4
			--end
			if self.missionState == 5 and dialogId == self.dialogList[3].Id then
				self.missionState = 6
			end
			if self.missionState == 7 and dialogId == self.dialogList[4].Id then
				self.missionState = 8
			end
			if dialogId == self.dialogList[5].Id then
				----弱引导普攻
				--if self.weakGuide[5].state == false then
					--self:WeakGuide(self.weakGuide[5].Id)
					--self.weakGuide[5].state = true
				--end				
			end
			if self.missionState == 13 and dialogId == self.dialogList[7].Id then
				--图片引导治愈气脉竹
				BehaviorFunctions.ShowGuideImageTips(20004)
				self.missionState = 14
			end
			if self.missionState == 17 and dialogId == self.dialogList[8].Id then
				self.missionState = 18
			end
			if self.missionState == 19 and dialogId == self.dialogList[9].Id then
				self.missionState = 20
			end
			if self.missionState == 21 and dialogId == self.dialogList[10].Id then
				self.missionState = 22
			end
			if self.missionState == 21 and dialogId == self.dialogList[11].Id then
				self.missionState = 22
			end
			--if self.missionState == 23 and dialogId == self.dialogList[12].Id then
				--self.missionState = 24
			--end
			if self.missionState == 25 and dialogId == self.dialogList[13].Id then
				--恢复巴西利克斯行为树
				BehaviorFunctions.SetEntityValue(self.baxilikes,"Stop",false)
				self.missionState = 26
			end
			if self.missionState == 29 and dialogId == self.dialogList[17].Id then
				self.missionState = 30
			end
			if dialogId == self.dialogList[18].Id then
				self.boss2QTEphase = 1
			end

			if dialogId == self.dialogList[19].Id then
				BehaviorFunctions.StartStoryDialog(self.dialogList[20].Id)
				self.boss2QTEphase = 2
			end
			
			if dialogId == self.dialogList[20].Id then
				BehaviorFunctions.StartStoryDialog(self.dialogList[21].Id)
			end


			v.state = self.dialogStateEnum.PlayOver
			self.currentDialog = nil
		end
	end
end

function LevelBehavior30009:Death(instanceId,isFormationRevive)
	if isFormationRevive then
		
	else
		for i,v in ipairs(self.monsterList) do
			if instanceId == v.Id then
				v.state = self.monsterStateEnum.Dead
			end
		end
	end
end

function LevelBehavior30009:__delete()

end
