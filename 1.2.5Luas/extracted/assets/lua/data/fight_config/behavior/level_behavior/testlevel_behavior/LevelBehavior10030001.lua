--主线第6关，缔约教学

LevelBehavior10030001 = BaseClass("LevelBehavior10030001",LevelBehaviorBase)
--fight初始化
function LevelBehavior10030001:__init(fight)
	self.fight = fight
end

--预加载
function LevelBehavior10030001.GetGenerates()
	local generates = {900000102,910024,910025,900021,900022,900023,900020}
	return generates
end
function LevelBehavior10030001.GetMagics()
	local generates = {900000008,900000009}
	return generates
end
--UI预加载
function LevelBehavior10030001.GetUIGenerates()
	local generates = {
		FightEnum.PreLoadUI.RemoteDialog,--带头像的剧情对话框UI
		FightEnum.PreLoadUI.FightTalkDialog,--纯文字的剧情对话框UI
		FightEnum.PreLoadUI.GuideMask,--教学引导UI
		FightEnum.PreLoadUI.FightTips--中间横幅和底部横幅
	}
	return generates
end

--参数初始化
function LevelBehavior10030001:Init()
	self.levelentity = 1    --关卡entity
	self.monsters = {}
	self.missionState = 0   --关卡流程
	self.time = 0		    --世界时间
	self.timeStart = 0      --记录时间
	--关卡流程初始化
	self:LevelInit()
	--分组参数
	self.monstersGroup = {}
	self.groupTime = { Time = 0 , Mark = 0 }

	--创建关卡通用行为树
	self.LevelBehavior = BehaviorFunctions.CreateBehavior("LevelBehavior",self)
	--创建相机行为树
	self.LevelCamera = BehaviorFunctions.CreateBehavior("LevelCamera",self)
	self.bronActState = 0
	self.teachState = 0
	self.endState = 0
	
end

--帧事件
function LevelBehavior10030001:Update()
	
	--每帧获得当前角色
	self.role = BehaviorFunctions.GetCtrlEntity()
	--助战角色
	self.role2 = BehaviorFunctions.GetQTEEntity(1)
	--获取时间
	self.time = BehaviorFunctions.GetFightFrame()

	self.wave1Count = self:WaveCount(1)
	self.wave2Count = self:WaveCount(2)
	self.wave3Count = self:WaveCount(3)
	--关卡主流程
	if self.missionState == 1  then
		--BehaviorFunctions.RemoveEntitySign(self.role2,10000017)
		self.LevelBehavior:SetPositionGuide(1006001,"MB201")			--标记刻刻战斗位置
		self.roadSign = self.LevelBehavior:SetRoadSign("MB201")		--插个路标
		local MB201 = BehaviorFunctions.GetTerrainPositionP("MB201")
		self.LevelCamera:Position_Camera(self.role,MB201,0.1)
		self.missionState = 10
	end
	--第一波怪
	if self.missionState == 10 and BehaviorFunctions.GetDistanceFromTarget(self.role,self.roadSign) <= 3 then
		BehaviorFunctions.CancelGuide()
		BehaviorFunctions.RemoveEntity(self.roadSign)
		BehaviorFunctions.SetEntityValue(self.monsters[1].instanceId,"jumpOut",true)
		BehaviorFunctions.SetEntityValue(self.monsters[2].instanceId,"jumpOut",true)
		--BehaviorFunctions.SetEntityValue(self.monsters[3].instanceId,"jumpOut",true)
		--BehaviorFunctions.SetEntityValue(self.monsters[4].instanceId,"jumpOut",true)	
		self.timeStart = BehaviorFunctions.GetFightFrame()
		self.missionState = 20
	end
	--清除第一波怪看灯球演出
	if self.missionState == 20 and self.wave1Count == 0  and self.time -self.timeStart > 1 then
		self.LevelBehavior:SetPositionGuide(1006002,"C1")
		BehaviorFunctions.ShowTip(1006001)
		self.roadSign = self.LevelBehavior:SetRoadSign("C1")		--插个路标
		local MB201 = BehaviorFunctions.GetTerrainPositionP("C1")
		self.LevelCamera:Position_Camera(self.role,MB201,0.1)
		self.missionState = 30
	end
	if self.missionState == 30 and BehaviorFunctions.GetDistanceFromTarget(self.role,self.roadSign) <= 3 then
		BehaviorFunctions.CancelGuide()
		BehaviorFunctions.RemoveEntity(self.roadSign)
		BehaviorFunctions.ActiveUI(FightEnum.UIActiveType.Main,false)
		BehaviorFunctions.ActiveSceneObj("timeline3",true)
		BehaviorFunctions.AddDelayCallByTime(0.5,self,self.OpenRemoteDialog,100605)
		BehaviorFunctions.AddDelayCallByTime(4,self,self.OpenRemoteDialog,100606)
		BehaviorFunctions.AddDelayCallByTime(7.1,self,self.OpenRemoteDialog,100607)
		self.timeStart = BehaviorFunctions.GetFightFrame()
		self.missionState = 40
	end
	if self.missionState == 40 and self.time - self.timeStart >= 30*12 then
		self:CreatMonster({
				{id = 910024 ,posName = "C101",lookatposName = "C1",wave = 2,bronskill = false},
				{id = 910025 ,posName = "C102",lookatposName = "C1",wave = 2,bronskill = false},
				--{id = 910024 ,posName = "C103",lookatposName = "C1",wave = 2,bronskill = false},
				--{id = 910025 ,posName = "C104",lookatposName = "C1",wave = 2,bronskill = false},
			})
		self.missionState = 50
	end
	
	if self.missionState == 50 and self.time - self.timeStart >= 30*13 then
		BehaviorFunctions.ActiveSceneObj("timeline3",false)	
		BehaviorFunctions.ActiveSceneObj("timelinecamera",false)
		BehaviorFunctions.ActiveUI(FightEnum.UIActiveType.Main,true)
		self.timeStart = BehaviorFunctions.GetFightFrame()
		self.teachState = 1
		self.missionState =60
	end
	
	--第二波怪，战斗中触发缔约教学
	if self.missionState == 60 and self.wave2Count == 0  and self.time - self.timeStart > 1 then
		self.timeStart = BehaviorFunctions.GetFightFrame()
		self:CreatMonster({
				--{id = 900020 ,posName = "C101",lookatposName = "C1",wave = 3,bronskill = false},
				{id = 900021 ,posName = "C102",lookatposName = "C1",wave = 3,bronskill = false},
				{id = 900020 ,posName = "C103",lookatposName = "C1",wave = 3,bronskill = false},
				{id = 900023 ,posName = "C104",lookatposName = "C1",wave = 3,bronskill = false},
			})	
		self.timeStart = self.time
		self.missionState = 70
	end

	if self.missionState == 70 and self.wave3Count == 0 and  self.time -self.timeStart > 1 then
		local E1 = BehaviorFunctions.GetTerrainPositionP("E1")
		self.LevelCamera:Position_Camera(self.role,E1,1)
		self.LevelBehavior:SetPositionGuide(1006003,"E1")			--标记刻刻战斗位置
		BehaviorFunctions.ShowTip(1006003)
		self.endSign = self.LevelBehavior:SetRoadSign("E1")		    --插个路标
		self.missionState = 80
	end
	if self.missionState == 80  and BehaviorFunctions.GetDistanceFromTarget(self.role,self.endSign) <= 1 then
		BehaviorFunctions.CancelGuide()
		BehaviorFunctions.RemoveEntity(self.endSign)
		self:OpenRemoteDialogSpecial(100608)
		self.missionState = 90
	end
	if self.missionState == 90 and self:DialogOver() then
		self.missionState = 999
		self.endState =1
	end
		
    --出生表演
	if self.bronActState == 0  then
		BehaviorFunctions.ActiveUI(FightEnum.UIActiveType.Main,false)	
		BehaviorFunctions.ActiveSceneObj("timeline1",true)
		BehaviorFunctions.ActiveSceneObj("trainerbgm",true) --bgm
		BehaviorFunctions.AddDelayCallByTime(1,self,self.OpenRemoteDialog,100601) --开启第一次通讯，叙慕与向心的对话
		BehaviorFunctions.AddDelayCallByTime(5,self,self.OpenRemoteDialog,100602)	
		BehaviorFunctions.AddDelayCallByTime(11,self,self.OpenRemoteDialog,100603)
		BehaviorFunctions.AddDelayCallByTime(19,self,self.OpenRemoteDialog,100604)	
		--第一波怪提前召
		self:CreatMonster({
				{id = 900020 ,posName = "MB201",lookatposName = "C1",wave = 1,bronskill = true},
				--{id = 900021 ,posName = "MB202",lookatposName = "C1",wave = 1,bronskill = true},
				--{id = 900022 ,posName = "MB203",lookatposName = "C1",wave = 1,bronskill = true},
				{id = 900023 ,posName = "MB204",lookatposName = "C1",wave = 1,bronskill = true},
			})			
		self.timeStart = BehaviorFunctions.GetFightFrame()
		self.bronActState = 1
	end
	if self.bronActState == 1 and self.time - self.timeStart >= 22*30 then
		BehaviorFunctions.ActiveSceneObj("timeline1",false)
		BehaviorFunctions.ActiveSceneObj("timeline2",true)
		if BehaviorFunctions.GetEntityState(self.role) ~= FightEnum.EntityState.Move then
			BehaviorFunctions.DoSetMoveType(self.role,FightEnum.EntityMoveSubState.Run)
			self.timeStart = BehaviorFunctions.GetFightFrame()
			self.bronActState = 2
		end
		if self.role2 then
			local kekeS1 = BehaviorFunctions.GetTerrainPositionP("kekeS1")
			local keke1 = BehaviorFunctions.GetTerrainPositionP("keke1")
			BehaviorFunctions.AddEntitySign(self.role2,10000017,-1)
			BehaviorFunctions.DoSetPositionP(self.role2,keke1)
			BehaviorFunctions.DoLookAtPositionImmediately(self.role2,kekeS1.x,nil,kekeS1.z)
			if BehaviorFunctions.GetEntityState(self.role2) ~= FightEnum.EntityState.Move then
				BehaviorFunctions.DoSetMoveType(self.role2,FightEnum.EntityMoveSubState.Run)
			end
		end
	end
	if self.bronActState == 2 then
		local rolepos = BehaviorFunctions.GetPositionP(self.role)
		local targetpos = BehaviorFunctions.GetTerrainPositionP("xumuS1")
		if BehaviorFunctions.GetDistanceFromPos(rolepos,targetpos) <= 1 then
			BehaviorFunctions.StopMove(self.role)
			if self.role2 then
				BehaviorFunctions.StopMove(self.role2)
			end
			self.timeStart = BehaviorFunctions.GetFightFrame()
			self.bronActState = 3
		end
	end
	if self.bronActState == 3 and self.time -self.timeStart >=1*30 then
		BehaviorFunctions.ActiveSceneObj("timeline2",false)
		BehaviorFunctions.ActiveUI(FightEnum.UIActiveType.Main,true)
		BehaviorFunctions.SetFightMainNodeVisible(2,"R",false)       --隐藏缔约按钮
		self.bronActState = 999
		self.missionState = 1
	end
	
	
	--教学
	--按缔约按钮
	if self.teachState == 1 then
		BehaviorFunctions.DoMagic(self.role,self.role,200000007)    --加满缔约能量
		BehaviorFunctions.SetFightMainNodeVisible(2,"R",true)       --显示缔约按钮
		self.LevelBehavior:TutorialGuide(100601)				--开启缔约教学
		self.timeStart = BehaviorFunctions.GetFightFrame()
		self.teachState = 2
	end
	--时停
	if self.teachState == 2 and self.time - self.timeStart >0 then
		BehaviorFunctions.DoMagic(self.levelentity,self.levelentity,200000008)   --THE WORLD!!!
		BehaviorFunctions.DoMagic(self.levelentity,self.role,200000008)
		if self.role2 then
		  BehaviorFunctions.DoMagic(self.levelentity,self.role2,200000008)
		end
		self.teachState = 3
	end
	--如果按了缔约就解除时停
	if self.teachState == 3 and BehaviorFunctions.CheckKeyDown(FightEnum.KeyEvent.Execute) then
		BehaviorFunctions.KeyAutoUp(FightEnum.KeyEvent.Change1)
		BehaviorFunctions.RemoveBuff(self.levelentity,200000008)
		BehaviorFunctions.RemoveBuff(self.role,200000008)
		if self.role2 then
			BehaviorFunctions.RemoveBuff(self.role2,200000008)
		end
		self.teachState = 4
	end
	--等timeline播完,准备进行qte教学，先时停
	if self.teachState == 4 and BehaviorFunctions.GetSkillSign(self.role,10000004) then
		BehaviorFunctions.DoMagic(self.levelentity,self.levelentity,200000008)   --THE WORLD!!!
		BehaviorFunctions.DoMagic(self.levelentity,self.role,200000008)
		if self.role2 then
			BehaviorFunctions.DoMagic(self.levelentity,self.role2,200000008)
		end
		self.timeStart = BehaviorFunctions.GetFightFrame()
		self.teachState = 5	
	end
	--qtetips
	if self.teachState == 5 and self.time - self.timeStart > 15 then
		self.LevelBehavior:TutorialGuide(100602)	
		self.teachState = 6
	end
	--qte按键检测
	if  self.teachState == 6 and BehaviorFunctions.CheckKeyDown(FightEnum.KeyEvent.Change1) then
		BehaviorFunctions.RemoveBuff(self.levelentity,200000008)
		BehaviorFunctions.RemoveBuff(self.role,200000008)
		if self.role2 then
			BehaviorFunctions.RemoveBuff(self.role2,200000008)
		end	
		self.teachState = 7
	end		
	if self.teachState == 7 and BehaviorFunctions.HasBuffKind(self.role,1000011) then --缔约扣能量buff检测
		BehaviorFunctions.DoMagic(self.levelentity,self.levelentity,200000008)   --THE WORLD!!!
		BehaviorFunctions.DoMagic(self.levelentity,self.role,200000008)
		if self.role2 then
			BehaviorFunctions.DoMagic(self.levelentity,self.role2,200000008)
		end
		self.timeStart = BehaviorFunctions.GetFightFrame()
		self.teachState = 8
	end
	if self.teachState == 8 and self.time - self.timeStart > 15 then
		self.LevelBehavior:TutorialGuide(100603)				               --开启缔约教学
		BehaviorFunctions.KeyAutoUp(FightEnum.KeyEvent.Execute)
		self.teachState = 9
	end
	if self.teachState == 9 and BehaviorFunctions.CheckKeyDown(FightEnum.KeyEvent.Execute) then
		BehaviorFunctions.RemoveBuff(self.levelentity,200000008)
		BehaviorFunctions.RemoveBuff(self.role,200000008)
		if self.role2 then
			BehaviorFunctions.RemoveBuff(self.role2,200000008)
		end
		self.teachState = 999
	end


		
		
	--结束倒计时
	if self.endState == 1 and self.time - self.timeStart >=1*30 then
		local canshu = 3
		BehaviorFunctions.ShowTip(1106,canshu)
		self.timeStart = self.time
		self.endState = 2
	end
	if self.endState == 2 and self.time - self.timeStart >=1*30 then
		local canshu = 2
		BehaviorFunctions.ShowTip(1106,canshu)
		self.timeStart =self.time
		self.endState = 3
	end
	if self.endState == 3 and self.time - self.timeStart >=1*30 then
		local canshu = 1
		BehaviorFunctions.ShowTip(1106,canshu)
		self.timeStart =self.time
		self.endState = 4
	end
	if self.endState == 4 and self.time - self.timeStart >=1*30 then
		BehaviorFunctions.SetFightResult(true)
		self.endState = 999
	end
end


--死亡事件
function LevelBehavior10030001:Death(instanceId)
	local i = 0
	for i = #self.monsters,1,-1 do
		if self.monsters[i].instanceId == instanceId then
			table.remove(self.monsters,i)
		end
	end
	if instanceId == self.role then
		BehaviorFunctions.SetFightResult(false)
	end
end

--刷怪
function LevelBehavior10030001:CreatMonster(monsterList)
	local MonsterId = 0
	for a = #monsterList,1,-1 do
		if monsterList[a].lookatposName then
			local posP = BehaviorFunctions.GetTerrainPositionP(monsterList[a].posName)
			local lookatposP = BehaviorFunctions.GetTerrainPositionP(monsterList[a].lookatposName)
			MonsterId = BehaviorFunctions.CreateEntity(monsterList[a].id,nil,posP.x,posP.y,posP.z,lookatposP.x,nil,lookatposP.z)
			table.insert(self.monsters,{wave =monsterList[a].wave,instanceId =MonsterId})
		else
			local posP = BehaviorFunctions.GetTerrainPositionP(monsterList[a].posName)
			MonsterId = BehaviorFunctions.CreateEntity(monsterList[a].id,nil,posP.x,posP.y,posP.z)
			BehaviorFunctions.DoLookAtTargetImmediately(MonsterId,self.role)
			table.insert(self.monsters,{wave = monsterList[a].wave,instanceId = MonsterId})
		end
		if monsterList[a].bronskill == false then
			BehaviorFunctions.SetEntityValue(MonsterId,"closeBornSkill",true)
		elseif monsterList[a].bronskill == true then
			BehaviorFunctions.SetEntityValue(MonsterId,"closeBornSkill",false)
			BehaviorFunctions.SetEntityValue(MonsterId,"bornType",2)
		end
	end
	table.sort(self.monsters,function(a,b)
			if a.wave < b.wave then
				return true
			elseif a.wave == b.wave then
				if a.instanceId < b.instanceId then
					return true
				end
			end
		end)
end

--波数计数
function LevelBehavior10030001:WaveCount(waveNum)
	local count	= 0
	for i = #self.monsters,1,-1  do
		if self.monsters[i].wave == waveNum then
			count = count + 1
		end
	end
	return count
end

--关卡初始化
function LevelBehavior10030001:LevelInit()
	self.role = BehaviorFunctions.GetCtrlEntity()
	--self.role2 = BehaviorFunctions.GetQTEEntity(1)
	local Born1 = BehaviorFunctions.GetTerrainPositionP("xumu1")
	local S1 = BehaviorFunctions.GetTerrainPositionP("xumuS1")
	BehaviorFunctions.SetPlayerBorn(Born1.x,Born1.y,Born1.z)	--角色位置
	BehaviorFunctions.DoLookAtPositionImmediately(self.role,S1.x,nil,S1.z)
	BehaviorFunctions.InitCameraAngle(120)
	BehaviorFunctions.SetWallEnable("AW1",false)
	BehaviorFunctions.SetWallEnable("AW2",false)
	BehaviorFunctions.SetWallEnable("AW3",false)
	BehaviorFunctions.SetWallEnable("AW4",false)
	--BehaviorFunctions.ActiveSceneObj("timelinevcam",true)
end

function LevelBehavior10030001:__delete()

end

--打开对话框
function LevelBehavior10030001:OpenRemoteDialog(DialogID)
	BehaviorFunctions.CancelJoystick()--取消玩家摇杆
	BehaviorFunctions.OpenRemoteDialog(DialogID,false)
end
--打开对话框
function LevelBehavior10030001:OpenRemoteDialogSpecial(DialogID)
	BehaviorFunctions.CancelJoystick()--取消玩家摇杆
	BehaviorFunctions.OpenRemoteDialog(DialogID,true)
end

--对话结束检测
function LevelBehavior10030001:DialogOver()
	if BehaviorFunctions.CheckKeyDown(FightEnum.KeyEvent.Common2) then
		return true
	else
		return false
	end
end