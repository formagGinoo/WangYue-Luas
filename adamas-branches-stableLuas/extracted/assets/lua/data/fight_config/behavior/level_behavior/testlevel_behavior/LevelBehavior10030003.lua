--主线第5关，换人及属性教学

LevelBehavior10030003 = BaseClass("LevelBehavior10030003",LevelBehaviorBase)
--fight初始化
function LevelBehavior10030003:__init(fight)
	self.fight = fight
end

--预加载
function LevelBehavior10030003.GetGenerates()
	local generates = {900000102,910024,910025,900021,900022,900023,900020,9001}
	return generates
end
function LevelBehavior10030003.GetMagics()
	local generates = {900000008,900000009}
	return generates
end
--UI预加载
function LevelBehavior10030003.GetUIGenerates()
	local generates = {
		FightEnum.PreLoadUI.RemoteDialog,--带头像的剧情对话框UI
		FightEnum.PreLoadUI.FightTalkDialog,--纯文字的剧情对话框UI
		FightEnum.PreLoadUI.GuideMask,--教学引导UI
		FightEnum.PreLoadUI.FightTips--中间横幅和底部横幅
	}
	return generates
end

--参数初始化
function LevelBehavior10030003:Init()
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
	self.haveDoor1 = false
	self.haveDoor2 = false
	self.haveDoor3 = false
	self.wave3Acitve = false
	self.talkActive = false
	self.doorTipState = 0
	--受击提示计数
	self.door1AttackCount = 0
	self.door2AttackCount = 0
	self.door3AttackCount = 0
end

--帧事件
function LevelBehavior10030003:Update()

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
	--三个门对应3个npc
		local door1pos = BehaviorFunctions.GetTerrainPositionP("door1")
		local door2pos = BehaviorFunctions.GetTerrainPositionP("door2")
		local door3pos = BehaviorFunctions.GetTerrainPositionP("door3")
		self.door1 = BehaviorFunctions.CreateEntity(9001,nil,door1pos.x,door1pos.y,door1pos.z)
		self.door2 = BehaviorFunctions.CreateEntity(9001,nil,door2pos.x,door2pos.y,door2pos.z)
		self.door3 = BehaviorFunctions.CreateEntity(9001,nil,door3pos.x,door3pos.y,door3pos.z)
		self.haveDoor1 = true
		self.haveDoor2 = true
		self.haveDoor3 = true
		--关卡内怪物
		self:CreatMonster({
				{id = 900020 ,posName = "tempmb101",lookatposName = "tempborn1",wave = 1,bronskill = true},
				{id = 900020 ,posName = "tempmb102",lookatposName = "tempborn1",wave = 1,bronskill = true},
				{id = 900021 ,posName = "tempmb103",lookatposName = "tempborn1",wave = 1,bronskill = true},
				{id = 900023 ,posName = "tempmb201",lookatposName = "tempe2",wave = 2,bronskill = true},
				{id = 900022 ,posName = "tempmb202",lookatposName = "tempe2",wave = 2,bronskill = true},
				{id = 900023 ,posName = "tempmb203",lookatposName = "tempe2",wave = 2,bronskill = true},
				{id = 900020 ,posName = "tempmb301",lookatposName = "tempe2",wave = 3,bronskill = true},
				{id = 900020 ,posName = "tempmb302",lookatposName = "tempe2",wave = 3,bronskill = true},
				{id = 900020 ,posName = "tempmb303",lookatposName = "tempe2",wave = 3,bronskill = true},
				{id = 900020 ,posName = "tempmb304",lookatposName = "tempe2",wave = 3,bronskill = true},
			})
		--弱对应属性
		BehaviorFunctions.DoMagic(self.door1,self.door1,900000016)
		BehaviorFunctions.DoMagic(self.door2,self.door2,900000017)
		BehaviorFunctions.DoMagic(self.door3,self.door3,900000016)
		--隐藏npc
		BehaviorFunctions.DoMagic(self.door1,self.door1,900000018)
		BehaviorFunctions.DoMagic(self.door2,self.door2,900000018)
		BehaviorFunctions.DoMagic(self.door3,self.door3,900000018)
		--tips相关
		self:OpenRemoteDialog(100505)
		BehaviorFunctions.AddDelayCallByTime(4,BehaviorFunctions,BehaviorFunctions.ActiveUI,FightEnum.UIActiveType.Main,true)
		BehaviorFunctions.AddDelayCallByTime(5,self.LevelBehavior,self.LevelBehavior.TutorialGuide,100501)
		self.missionState = 5
	end
	if self.missionState == 5 and BehaviorFunctions.CheckKeyDown(FightEnum.KeyEvent.Change1) then
		BehaviorFunctions.ShowTip(1005001)
		self.LevelBehavior:SetPositionGuide(1005001,"tempe1")
		self.roadSign = self.LevelBehavior:SetRoadSign("tempe1")
		local tempe1 = BehaviorFunctions.GetTerrainPositionP("tempe1")
		self.LevelCamera:Position_Camera(self.role,tempe1,0.1)
		self.missionState = 10	
	end
	
	--出洞
	if self.missionState == 10 and BehaviorFunctions.GetDistanceFromTarget(self.role,self.roadSign) <= 1 then
		BehaviorFunctions.CancelGuide()
		BehaviorFunctions.RemoveEntity(self.roadSign)
		BehaviorFunctions.SetEntityValue(self.monsters[1].instanceId,"jumpOut",true)
		BehaviorFunctions.SetEntityValue(self.monsters[2].instanceId,"jumpOut",true)
		BehaviorFunctions.SetEntityValue(self.monsters[3].instanceId,"jumpOut",true)
		BehaviorFunctions.ShowTip(1004002)	
		self.missionState = 20
	end
	--清怪
	if self.missionState == 20 and self.wave1Count == 0 then
		--对话
		self:OpenRemoteDialogSpecial(100506)
		self.missionState = 25
	end
		
	--入洞指引	
	if self.missionState == 25 and self:DialogOver() then	
		--tips相关
		BehaviorFunctions.ShowTip(1005004)
		self.LevelBehavior:SetPositionGuide(1005002,"tempe2")			
		self.roadSign = self.LevelBehavior:SetRoadSign("tempe2")		    
		local tempe2 = BehaviorFunctions.GetTerrainPositionP("tempe2")
		--self.LevelCamera:Position_Camera(self.role,tempe2,0.1)
		self.missionState = 30
	end
	--进入洞穴
	if self.missionState == 30 and BehaviorFunctions.GetDistanceFromTarget(self.role,self.roadSign) <= 1 then
		BehaviorFunctions.CancelGuide()
		BehaviorFunctions.RemoveEntity(self.roadSign)
		BehaviorFunctions.SetEntityValue(self.monsters[1].instanceId,"jumpOut",true)
		BehaviorFunctions.SetEntityValue(self.monsters[2].instanceId,"jumpOut",true)
		BehaviorFunctions.SetEntityValue(self.monsters[3].instanceId,"jumpOut",true)
		
		--tips相关
		self.LevelBehavior:SetPositionGuide(1005002,"tempe3")			
		self.roadSign = self.LevelBehavior:SetRoadSign("tempe3")		   
		local tempe3 = BehaviorFunctions.GetTerrainPositionP("tempe3")
		--self.LevelCamera:Position_Camera(self.role,tempe3,0.1)
		self.missionState = 40 
	end
	if self.missionState == 40 and self.wave3Acitve == false then
		local rolePos = BehaviorFunctions.GetPositionP(self.role)
		local monsterPos = BehaviorFunctions.GetTerrainPositionP("tempmb301")
		if BehaviorFunctions.GetDistanceFromPos(rolePos,monsterPos)  <= 5 then
			if #self.monsters ~= 0 then
				for i = 1,#self.monsters do
					BehaviorFunctions.SetEntityValue(self.monsters[i].instanceId,"jumpOut",true)
					if i == #self.monsters then
						self.wave3Acitve = true
					end
				end
			end
		end
	end
	--出洞
	if self.missionState == 40 and BehaviorFunctions.GetDistanceFromTarget(self.role,self.roadSign) <= 1 then
		BehaviorFunctions.CancelGuide()
		BehaviorFunctions.RemoveEntity(self.roadSign)
		self:OpenRemoteDialogSpecial(100512)
		if #self.monsters ~= 0 then
			for i = 1,#self.monsters,1 do
				BehaviorFunctions.RemoveEntity(self.monsters[i].instanceId)
			end
		end
		self.missionState = 50
	end
	
	if self.missionState == 50 and self:DialogOver() then
		self.missionState = 999
		self.endState =1
	end


	--出生演出
	if self.bronActState == 0  then
		BehaviorFunctions.ActiveUI(FightEnum.UIActiveType.Main,false)
		BehaviorFunctions.ActiveSceneObj("Timeline_03",true)  --出生镜头
		BehaviorFunctions.ActiveSceneObj("wastelandbgm",true) --bgm
		BehaviorFunctions.AddDelayCallByTime(0.5,self,self.OpenRemoteDialog,100501) 
		BehaviorFunctions.AddDelayCallByTime(4,self,self.OpenRemoteDialog,100502)
		BehaviorFunctions.AddDelayCallByTime(7.5,self,self.OpenRemoteDialog,100503)
		BehaviorFunctions.AddDelayCallByTime(12,self,self.OpenRemoteDialog,100504)
		--第一波怪提前召
		self.timeStart = BehaviorFunctions.GetFightFrame()
		self.bronActState = 1
	end
	if self.bronActState == 1 and self.time - self.timeStart >= (15+5)*30 then
		BehaviorFunctions.ActiveSceneObj("Timeline_03",false)
		self.bronActState = 2
		self.missionState = 1
	end
	
	
	
	--doortips
	if self.haveDoor1 or self.haveDoor2 or self.haveDoor3 then
		if self.doorTipState == 0 and self.haveDoor1 == true and BehaviorFunctions.GetDistanceFromTarget(self.role,self.door1) <=3 then
			BehaviorFunctions.ShowTip(1005002)
			self.doorTipState = 1
		end
		if self.doorTipState == 1 and self.haveDoor2 == true and BehaviorFunctions.GetDistanceFromTarget(self.role,self.door2) <=3 then
			BehaviorFunctions.ShowTip(1005003)
			self.doorTipState = 2
		end
		if self.doorTipState == 2 and self.haveDoor3 == true and BehaviorFunctions.GetDistanceFromTarget(self.role,self.door3) <=3 then
			BehaviorFunctions.ShowTip(1005002)
			self.doorTipState = 3
		end	
	end
	
	--弱智保底
	if self.door1AttackCount == 5 and BehaviorFunctions.GetEntityTemplateId(self.role) == 1003 then
		self.LevelBehavior:TutorialGuide(100503)
	elseif self.door2AttackCount == 5 and BehaviorFunctions.GetEntityTemplateId(self.role) == 1004 then
		self.LevelBehavior:TutorialGuide(100502)
	elseif self.door3AttackCount == 5 and BehaviorFunctions.GetEntityTemplateId(self.role) == 1003 then
		self.LevelBehavior:TutorialGuide(100503)	
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
function LevelBehavior10030003:Death(instanceId)
	local i = 0
	for i = #self.monsters,1,-1 do
		if self.monsters[i].instanceId == instanceId then
			table.remove(self.monsters,i)
		end
	end
	if instanceId == self.role then
		BehaviorFunctions.SetFightResult(false)
	end
	--3门判断
	if self.haveDoor1  or self.haveDoor2 or self.haveDoor3 then
		if instanceId == self.door1 then
			self.haveDoor1 = false
			BehaviorFunctions.SetWallEnable("AW2",false)
			BehaviorFunctions.ActiveSceneObj("door1",false)
		end
		if instanceId == self.door2 then
			self.haveDoor2 = false
			BehaviorFunctions.SetWallEnable("AW3",false)
			BehaviorFunctions.ActiveSceneObj("door2",false)
		end
		if instanceId == self.door3 then
			self.haveDoor3 = false
			BehaviorFunctions.SetWallEnable("AW9",false)
			BehaviorFunctions.ActiveSceneObj("door3",false)
		end
	end
end


function LevelBehavior10030003:BeforeDamage(attackInstanceId,hitInstanceId,damageType,magicId,damageElementType,damageVal)
	--door3判断:door3受击，怪物全部召唤
	if hitInstanceId == self.door3 and self.wave3Acitve == false then
		if #self.monsters ~= 0 then
			for i = 1,#self.monsters do
				BehaviorFunctions.SetEntityValue(self.monsters[i].instanceId,"jumpOut",true)
				if i == #self.monsters then
					self.wave3Acitve = true				
				end			
			end	
		end
	end
	--door2判断:door2受击，对话
	if hitInstanceId == self.door2 and self.talkActive == false then
		if self.talkActive == false then
			self:OpenRemoteDialogSpecial(100509)
			self.talkActive = true
		end
	end
	--受击计数，提示用
	if hitInstanceId == self.door1 and BehaviorFunctions.GetEntityTemplateId(attackInstanceId) == 1003 then
		self.door1AttackCount = self.door1AttackCount + 1
	elseif hitInstanceId == self.door2 and BehaviorFunctions.GetEntityTemplateId(attackInstanceId) == 1004 then
		self.door2AttackCount = self.door2AttackCount + 1
	elseif hitInstanceId == self.door3 and BehaviorFunctions.GetEntityTemplateId(attackInstanceId) == 1003 then
		self.door3AttackCount = self.door3AttackCount + 1
	end
end

--刷怪
function LevelBehavior10030003:CreatMonster(monsterList)
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
function LevelBehavior10030003:WaveCount(waveNum)
	local count	= 0
	for i = #self.monsters,1,-1  do
		if self.monsters[i].wave == waveNum then
			count = count + 1
		end
	end
	return count
end

--关卡初始化
function LevelBehavior10030003:LevelInit()
	self.role = BehaviorFunctions.GetCtrlEntity()
	self.role2 = BehaviorFunctions.GetQTEEntity(1)
	local roleBorn = BehaviorFunctions.GetTerrainPositionP("tempborn1")
	local roleLoookAt = BehaviorFunctions.GetTerrainPositionP("temps1")
	BehaviorFunctions.SetPlayerBorn(roleBorn.x,roleBorn.y,roleBorn.z)	--角色位置
	BehaviorFunctions.DoLookAtPositionImmediately(self.role,roleLoookAt.x,nil,roleLoookAt.z)
	BehaviorFunctions.InitCameraAngle(270)
	BehaviorFunctions.SetWallEnable("AW5",true)
	BehaviorFunctions.SetWallEnable("AW7",true)
	BehaviorFunctions.SetWallEnable("AW8",false)
	BehaviorFunctions.SetWallEnable("AW4",false)
	BehaviorFunctions.SetWallEnable("AW2",true) --堵出生洞口的，对应door1
	BehaviorFunctions.SetWallEnable("AW3",true) --堵洞口的，对应door2
	BehaviorFunctions.SetWallEnable("AW9",true) --堵洞口的，对应door3
	BehaviorFunctions.ActiveSceneObj("door1",true)
	BehaviorFunctions.ActiveSceneObj("door2",true)
	BehaviorFunctions.ActiveSceneObj("door3",true)
	BehaviorFunctions.ActiveSceneObj("qimai03",true)
	BehaviorFunctions.ActiveSceneObj("qimai04",true)
end


function LevelBehavior10030003:__delete()

end

--打开对话框
function LevelBehavior10030003:OpenRemoteDialog(DialogID)
	BehaviorFunctions.CancelJoystick()--取消玩家摇杆
	BehaviorFunctions.OpenRemoteDialog(DialogID,false)
end

--打开对话框
function LevelBehavior10030003:OpenRemoteDialogSpecial(DialogID)
	BehaviorFunctions.CancelJoystick()--取消玩家摇杆
	BehaviorFunctions.OpenRemoteDialog(DialogID,true)
end

--对话结束检测
function LevelBehavior10030003:DialogOver()
	if BehaviorFunctions.CheckKeyDown(FightEnum.KeyEvent.Common2) then
		return true	
	else
		return false
	end
end