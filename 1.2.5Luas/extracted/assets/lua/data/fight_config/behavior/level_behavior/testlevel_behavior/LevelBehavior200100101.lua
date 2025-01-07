LevelBehavior200100101 = BaseClass("LevelBehavior200100101",LevelBehaviorBase)
--fight初始化
function LevelBehavior200100101:__init(fight)
	self.fight = fight
end

--预加载
function LevelBehavior200100101.GetGenerates()
	local generates = {900010,900000102}
	return generates
end

--UI预加载
function LevelBehavior200100101.GetUIGenerates()
	local generates = {
		FightEnum.PreLoadUI.FightTips--中间横幅和底部横幅
	}
	return generates
end

--参数初始化
function LevelBehavior200100101:Init()
	self.role = 0           --当前角色
	self.missionState = 0   --关卡流程

	self.wave = 0           --波数计数
	self.waveLimit = 5      --波数上限
	self.time = 0		    --世界时间
	self.timeStart = 0      --记录时间
	self.monsters = { Count = 0 }      --怪物的instance和其总数
	
	self.battleArea1 = false--是否处于战斗区域1


	self.tutorial = 0       --教学进度
	self.tutoMon = 0        --教学怪物instanceId
	self.buffSwitch = 0		--检测buff存在情况

	self.monstersGroup = {}
	self.groupTime = {}
	self.roadSign = 0
	
	--创建关卡通用行为树
	self.levelBeha = BehaviorFunctions.CreateBehavior("LevelBehavior",self)
	--创建相机行为树
	self.levelCam = BehaviorFunctions.CreateBehavior("LevelCamera",self)
	--创建怪物组行为树
	self.monstersGroupBeha = BehaviorFunctions.CreateBehavior("LevelMonstersGroup",self)
end

--帧事件
function LevelBehavior200100101:Update()
	--每帧获得当前角色
	self.role = BehaviorFunctions.GetCtrlEntity()
	--获取时间，区域
	self.time = BehaviorFunctions.GetFightFrame()
	--检测玩家是否处于战斗区域内
	self.battleArea1 = BehaviorFunctions.GetInAreaById("BattleArea1",self.role)

	--怪物数量记录
	self.monsters.Count = self.levelBeha:WaveCount(self.monsters,self.wave)

	--初始化，角色出生点
	if  self.missionState == 0 then
		self.entites = {}   --初始化self.entites表
		--获取地点
		local pb1 = BehaviorFunctions.GetTerrainPositionP("Born1")
		BehaviorFunctions.InitCameraAngle(125)--初始相机角度
		BehaviorFunctions.SetPlayerBorn(pb1.x,pb1.y,pb1.z)--角色位置
		local mb1 = BehaviorFunctions.GetTerrainPositionP("C1")
		BehaviorFunctions.DoLookAtPositionImmediately(self.role,mb1.x,nil,mb1.z)
		self.timeStart =BehaviorFunctions.GetFightFrame()
		
		--初始化空气墙
		BehaviorFunctions.SetWallEnable("AW1",false)
		BehaviorFunctions.SetWallEnable("AW2",false)
		BehaviorFunctions.SetWallEnable("AW3",false)
		BehaviorFunctions.SetWallEnable("AW4",false)

		self.missionState = 1
		--Log("Missionstate 进程 1")
	end

	--开启技能辅助轮
	self.levelBeha:SkillTips()

	if self.tutorial < 2 then
		--UI显隐
		--BehaviorFunctions.ActiveUI(FightEnum.UIActiveType.Main,false)
		BehaviorFunctions.SetFightMainNodeVisible(2,"QTE",false)	--QTE隐藏
		BehaviorFunctions.SetFightMainNodeVisible(2,"J",false) 		--普攻隐藏
		BehaviorFunctions.SetFightMainNodeVisible(2,"K",false)		--闪避隐藏
		BehaviorFunctions.SetFightMainNodeVisible(2,"I",false)		--红技能隐藏
		BehaviorFunctions.SetFightMainNodeVisible(2,"O",false)		--蓝技能隐藏
		BehaviorFunctions.SetFightMainNodeVisible(2,"L",false)		--大招隐藏
		BehaviorFunctions.SetFightMainNodeVisible(2,"R",false)		--连携隐藏
		BehaviorFunctions.SetFightMainNodeVisible(2,"Core",false)	--核心被动隐藏
	end

	--教学引导流程
	if self.missionState >= 1 then
		
		--核心被动禁用
		BehaviorFunctions.SetFightMainNodeVisible(2,"Core",false)--核心被动隐藏
		BehaviorFunctions.DoMagic(self.role, self.role,200000006,1, FightEnum.MagicConfigFormType.Level)--清空核心被动能量
		
		if self.tutorial == 0 then
			BehaviorFunctions.ActiveSceneObj("trainerbgm",true)			--BGM
			self.timeStart = BehaviorFunctions.GetFightFrame()
			self.tutorial = 1
		end
		if self.tutorial == 1 and self.time - self.timeStart >= 30 then
			self.levelBeha:OpenRemoteDialog(100101)					--开启第一次通讯，叙慕与向心的对话
			self.tutorial = 2

		elseif self.tutorial == 2 and self.levelBeha:DialogCheck() == true then
			self.levelBeha:SetPositionGuide(100101,"C1",2)			--标记目标战斗地点
			self.roadSign = self.levelBeha:SetRoadSign("C1")		--插个路标
		
			BehaviorFunctions.ShowTip(1001001)						--拉横幅：前往中心开始训练
			self.tutorial = 3
			self.missionState = 5                                   --前情提要结束，玩家进入区域1开始刷怪

		elseif self.tutorial == 3  and self.wave == 1 then
			BehaviorFunctions.CancelJoystick()
			BehaviorFunctions.SetFightMainNodeVisible(2,"Joystick",false)--摇杆隐藏
			self.timeStart = BehaviorFunctions.GetFightFrame()		--刷怪后开始计时，计时一秒
			self.tutorial = 4

		elseif self.tutorial == 4  and self.wave == 1 and self.time - self.timeStart == 30 then
			self.levelBeha:OpenRemoteDialog(100104)					--让玩家开始训练
			self.levelBeha:ShowGuideByDistance(100102,self.tutoMon,5,2)--根据距离显示引导：击败敌人
			BehaviorFunctions.HideGuidePointState()
			self.tutorial = 5

		elseif self.tutorial == 5 and self.levelBeha:DialogCheck() == true then--检查玩家是否继续了对话
			BehaviorFunctions.SetFightMainNodeVisible(2,"Joystick",true)--摇杆显示
			BehaviorFunctions.SetFightMainNodeVisible(2,"J",true) 		--普攻显示
			BehaviorFunctions.SetFightMainNodeVisible(2,"I",true)		--红技能显示
			self.levelBeha:TutorialGuide(100101)						--开启普攻教学
			self.tutorial = 6

		elseif self.tutorial == 6 then
			
			self.levelBeha:ShowGuideByDistance(100103,self.tutoMon,5,2)--根据距离显示引导：释放普攻

			if  BehaviorFunctions.CheckKeyUp(FightEnum.KeyEvent.Attack) then--玩家完成普攻引导，继续游戏
				self.timeStart = BehaviorFunctions.GetFightFrame()
				self.tutorial = 7
			end

		elseif self.tutorial == 7 and self.time - self.timeStart == 90 then
			BehaviorFunctions.DoMagic(self.role, self.role, 200000004, 1, FightEnum.MagicConfigFormType.Level)--红技能能量+1

		elseif self.tutorial == 7 and self.time - self.timeStart >= 91 then
			self.levelBeha:TutorialGuide(100102)						--开启教学：提示玩家普攻可以积攒技能
			self.timeStart = BehaviorFunctions.GetFightFrame()
			self.tutorial = 8

		elseif self.tutorial == 8 and BehaviorFunctions.CheckKeyDown(FightEnum.KeyEvent.GuideClick) then
			self.levelBeha:TutorialGuide(100103)						--开启红技能引导
			self.tutorial = 9

		elseif self.tutorial == 9  then

			self.levelBeha:ShowGuideByDistance(100104,self.tutoMon,5,2)--根据距离显示引导：释放技能

			if self.tutorial == 9 and BehaviorFunctions.CheckKeyUp(FightEnum.KeyEvent.RedSkill)
				or self.tutorial == 9 and BehaviorFunctions.CheckKeyUp(FightEnum.KeyEvent.BlueSkill) then
				BehaviorFunctions.SetFightMainNodeVisible(2,"L",true)	--大招按钮显示
				self.tutorial = 11										--玩家完成红技能引导，继续游戏
				self.timeStart = BehaviorFunctions.GetFightFrame()
			end


		elseif self.tutorial == 11 and self.time - self.timeStart == 91 then
			self.levelBeha:TutorialGuide(100104)						--开启教学：提示必杀能量
			self.timeStart = BehaviorFunctions.GetFightFrame()
			self.tutorial = 12

		elseif self.tutorial == 12 and BehaviorFunctions.CheckKeyDown(FightEnum.KeyEvent.GuideClick) then
			BehaviorFunctions.DoMagic(self.role, self.role, 200000003, 1, FightEnum.MagicConfigFormType.Level)	--大招能量充满
			self.levelBeha:TutorialGuide(100105)						--开启教学：指引玩家使用大招
			self.tutorial = 13
			--self:StopTime()

		elseif self.tutorial == 13  then
			self.levelBeha:ShowGuideByDistance(100105,self.tutoMon,5,2)--根据距离显示引导：引导大招

			if self.tutorial == 13 and BehaviorFunctions.CheckKeyDown(FightEnum.KeyEvent.UltimateSkill) then
				BehaviorFunctions.SetFightMainNodeVisible(2,"O",true)	--蓝技能显示
				self.tutorial = 15										--玩家完成大招引导，继续游戏
			end

		elseif self.tutorial == 15 and self.monsters.Count == 1 and self.wave == 1 then
			self.levelBeha:ShowGuideByDistance(100108,self.tutoMon,5,2)	--根据距离显示引导：击败维修机器人

		elseif self.tutorial == 15 and self.monsters.Count == 0 and self.wave == 1 then
			self.timeStart= BehaviorFunctions.GetFightFrame()
			self.tutorial = 16
			
		elseif self.tutorial == 16 and self.time - self.timeStart == 60 then
			BehaviorFunctions.CancelGuide()
			self.levelBeha:OpenRemoteDialog(100105)						--向心和叙慕谈起脉者	

		elseif self.tutorial == 16 and self.levelBeha:DialogCheck() == true then
			BehaviorFunctions.ShowTip(1001002)								--拉横幅：进行下一项训练内容
			if self.levelBeha:DistanceToPosition(self.role,"C1") > 5 then
				local position = BehaviorFunctions.GetTerrainPositionP("C1")
				self.levelCam:Position_Camera(self.role,position,1)				--看向中心点
				self.levelBeha:SetPositionGuide(100101,"C1",2)				--标记目标战斗地点
				self.roadSign = self.levelBeha:SetRoadSign("C1")			--插个路标
			end	
			self.tutorial = 17		
		
		elseif self.tutorial == 17 and self.levelBeha:DistanceToPosition(self.role,"C1") <= 5 then	
			self.tutorial = 18											

		elseif self.tutorial == 18 then
			self.timeStart = BehaviorFunctions.GetFightFrame()
			
			--除了闪避以外其他全部隐藏
			BehaviorFunctions.CancelJoystick()
			BehaviorFunctions.SetFightMainNodeVisible(2,"K",false)		--闪避隐藏
			BehaviorFunctions.SetFightMainNodeVisible(2,"J",false) 		--普攻隐藏
			BehaviorFunctions.SetFightMainNodeVisible(2,"I",false)		--红技能隐藏
			BehaviorFunctions.SetFightMainNodeVisible(2,"O",false)		--蓝技能隐藏
			BehaviorFunctions.SetFightMainNodeVisible(2,"L",false)		--大招隐藏
			BehaviorFunctions.SetFightMainNodeVisible(2,"Joystick",false)--摇杆隐藏
			
			self.tutorial = 19

		elseif self.tutorial == 19 and self.time - self.timeStart == 61	then
			self.levelBeha:SetPositionGuide(100111,"C1")				--目标：超算敌人
			BehaviorFunctions.CancelJoystick()
			BehaviorFunctions.SetGuideState(false)
			BehaviorFunctions.HideGuidePointState()

			self.tutorial = 20

		elseif self.tutorial == 20 then
			if BehaviorFunctions.GetEntityValue(self.tutoMon2,"TutoAttack") == nil then
				BehaviorFunctions.SetEntityValue(self.tutoMon2,"TutoAttack",1)--机器人攻击
			end
			self.tutorial = 20.1

		elseif self.tutorial == 20.1 then
			local tutoAttacking = BehaviorFunctions.GetEntityValue(self.tutoMon2,"tutoAttacking")
			if tutoAttacking == 1 then
				self.timeStart = BehaviorFunctions.GetFightFrame()
				self.tutorial = 20.2
			end

		elseif self.tutorial == 20.2 and self.time - self.timeStart == 24  then
			self:StopTime()
			BehaviorFunctions.SetFightMainNodeVisible(2,"K",true)		--闪避显示
			self.levelBeha:TutorialGuide(100106)						--提示超算
			self.tutorial = 20.3

		elseif self.tutorial == 20.3 and BehaviorFunctions.CheckKeyDown(FightEnum.KeyEvent.Dodge) then
			self:Continue()
			self.tutorial = 21


		elseif self.tutorial == 21 and BehaviorFunctions.GetEntityValue(self.tutoMon2,"DodgeDet") == true	then
			self.timeStart = BehaviorFunctions.GetFightFrame()
			self.tutorial = 22

		elseif self.tutorial == 22 and self.time - self.timeStart >= 30 then
			self.levelBeha:SetPositionGuide(100112,"C1")				--目标：超算反击
			BehaviorFunctions.SetGuideState(false)
			BehaviorFunctions.HideGuidePointState()
			self.levelBeha:TutorialGuide(100107)						--提示超算反击
			BehaviorFunctions.SetFightMainNodeVisible(2,"K",false)		--闪避隐藏
			BehaviorFunctions.SetFightMainNodeVisible(2,"J",true) 		--普攻显示
			self.tutorial = 23
			self:StopTime()

		elseif self.tutorial == 23 and BehaviorFunctions.CheckKeyDown(FightEnum.KeyEvent.Attack) then
			self:Continue()
			--解除教学模式
			BehaviorFunctions.SetEntityValue(self.tutoMon2,"idle",0)
			--显示目标：击杀敌人
			self.levelBeha:SetPositionGuide(100108,"C1")				--目标：击败敌人
			BehaviorFunctions.SetGuideState(false)
			BehaviorFunctions.HideGuidePointState()
			--技能显示
			BehaviorFunctions.SetFightMainNodeVisible(2,"K",true)		--闪避显示
			BehaviorFunctions.SetFightMainNodeVisible(2,"Joystick",true)--摇杆显示
			BehaviorFunctions.SetFightMainNodeVisible(2,"I",true)		--红技能显示
			BehaviorFunctions.SetFightMainNodeVisible(2,"O",true)		--蓝技能显示
			BehaviorFunctions.SetFightMainNodeVisible(2,"L",true)		--大招显示

			self.timeStart = BehaviorFunctions.GetFightFrame()
			self.tutorial = 24

		elseif self.tutorial == 24 and self.wave == 2 and self.monsters.Count == 0 then
			self.timeStart = BehaviorFunctions.GetFightFrame()
			self.tutorial = 25

		elseif self.tutorial == 25 and self.time - self.timeStart == 90 then
			BehaviorFunctions.CancelJoystick()
			self.levelBeha:OpenRemoteDialog(100110)
			self.tutorial = 26

		elseif self.tutorial == 26 and BehaviorFunctions.CheckKeyDown(FightEnum.KeyEvent.Common1)
			or self.tutorial == 26 and BehaviorFunctions.CheckKeyDown(FightEnum.KeyEvent.Common2) then
			self.timeStart = BehaviorFunctions.GetFightFrame()
			self.tutorial = 27

		elseif self.tutorial == 27 and self.time - self.timeStart == 30 then
			self.tutorial = 28
		
		elseif self.tutorial == 28 and self.wave == 3 and self.monsters.Count == 0 then
			self.timeStart = BehaviorFunctions.GetFightFrame()
			self.tutorial = 29
		
		elseif self.tutorial == 29 and self.time - self.timeStart == 30 then
			self.levelBeha:OpenRemoteDialog(100111)
			self.tutorial = 30
			
		elseif self.tutorial == 30 and self.levelBeha:DialogCheck() == true then
			self.missionState = 40
		end	
		
		--教程用锁血buff
		if BehaviorFunctions.CheckEntity(self.tutoMon) == true then
			if self.tutorial < 15 and self.tutorial >= 4 then
				if self.buffSwitch == 0 then
					BehaviorFunctions.DoMagic(self.tutoMon, self.tutoMon, 200000002, 1, FightEnum.MagicConfigFormType.Level)
					self.buffSwitch = 1
				end
				if BehaviorFunctions.GetEntityAttrValueRatio(self.tutoMon,1001) <= 2000 then--20%血以下进行回血
					BehaviorFunctions.ChangeEntityAttr(self.tutoMon,1001,50000)--复制前建议看下应该回多少血
				end
			end
			if self.tutorial >= 15 then
				BehaviorFunctions.RemoveBuff(self.tutoMon,200000002)
			end
		end

		--关卡退出倒计时
		if self.missionState == 40  then
			self.levelBeha:LevelEndCount(3)
			self.missionState = 41
		end
	end

	--分组攻击命令
	if self.missionState >= 5 and self.monsters.Count ~= 0 then

		if self.wave == 3 then
			self.monstersGroupBeha:MonsterGroupAttack(self.monstersGroup,1,5,1)
		end
	end

	--召怪流程
	if self.missionState == 5 and self.monsters.Count == 0  then
		
		if self.wave == 0 and self.levelBeha:DistanceToPosition(self.role,"C1") <= 5 then
			
			--生成教学怪物
			local mp1 = BehaviorFunctions.GetTerrainPositionP("C1")
			self.tutoMon = BehaviorFunctions.CreateEntity(900010)
			BehaviorFunctions.SetEntityValue(self.tutoMon,"idle",1)
			BehaviorFunctions.DoSetPosition(self.tutoMon,mp1.x,mp1.y,mp1.z)
			table.insert(self.monsters,{wave = 1,instanceId = self.tutoMon})
			
			self.wave = self.wave + 1
			
			self.levelCam:Position_Camera(self.role,mp1,1)			--玩家看向目标出生点
			
			BehaviorFunctions.RemoveEntity(self.roadSign)			--删除路标

			--刷1只会主动攻击的怪让玩家触发超算
		elseif self.wave == 1 and self.tutorial == 18 then
			local mp1 = BehaviorFunctions.GetTerrainPositionP("C1")

			self.tutoMon2 = BehaviorFunctions.CreateEntity(900010)

			BehaviorFunctions.SetEntityValue(self.tutoMon2,"idle",1)
			BehaviorFunctions.DoSetPosition(self.tutoMon2,mp1.x,mp1.y,mp1.z)

			table.insert(self.monsters,{wave = 2,instanceId = self.tutoMon2})
			
			self.wave = self.wave + 1

			self.levelCam:Position_Camera(self.role,mp1,1)			--玩家看向目标出生点
			BehaviorFunctions.DoLookAtTargetImmediately(self.role,self.tutoMon2)	
			
			BehaviorFunctions.RemoveEntity(self.roadSign)			--删除路标

		elseif self.tutorial == 28 and self.wave == 2 then
			
			self.levelBeha:CreatMonster(self.monsters,{
					{id = 900010 ,posName = "C1",wave = 3},
					{id = 900010 ,posName = "C1",X_offset = 2,Z_offset = 2,wave = 3},
					{id = 900010 ,posName = "C1",X_offset = 2,Z_offset = -2,wave = 3}
				})
			
			local mp1 = BehaviorFunctions.GetTerrainPositionP("C1")

			self.levelCam:Position_Camera(self.role,mp1,1)			--玩家看向目标出生点
			
			self.monstersGroupBeha:MonsterGroup(self.monstersGroup,1,self.monsters[1].instanceId,self.monsters[2].instanceId,self.monsters[3].instanceId)

			self.wave = self.wave + 1

		end
	end

	--清怪检测
	if self.monsters.Count == 0 then
		if self.wave == 1 and self.tutorial == 15 then
			self.timeStart = BehaviorFunctions.GetFightFrame()
			BehaviorFunctions.CancelGuide()
		end
	end
end

--死亡事件
function LevelBehavior200100101:Death(instanceId)
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

--时间暂停
function LevelBehavior200100101:StopTime()        --暂停实体时间和行为
	local npcs = BehaviorFunctions.SearchNpc()
	for i in ipairs(npcs)  do
		--BehaviorFunctions.AddBuff(self.role,npcs[i],200100101001,1)
		BehaviorFunctions.DoMagic(npcs[i], npcs[i], 200000001, 1, FightEnum.MagicConfigFormType.Level)
	end
end

--解除时间暂停
function LevelBehavior200100101:Continue()        --解除暂停
	local npcs = BehaviorFunctions.SearchNpc()
	for i in ipairs(npcs)  do
		BehaviorFunctions.RemoveBuff(npcs[i],200000001)
	end
end

--获取目前可交互npc的id
function LevelBehavior200100101:EnterTrigger(triggerInstanceId,triggerEntityId,roleInstanceId)
	self.InterInstance = triggerInstanceId
	BehaviorFunctions.SetFightMainNodeVisible(2,"ButtomRight",false)	--右侧UI隐藏
end

--离开范围时，取消所有交互ui
function LevelBehavior200100101:ExitTrigger(triggerInstanceId,triggerEntityId,roleInstanceId)
	self.InterInstance = nil
	BehaviorFunctions.SetFightMainNodeVisible(2,"ButtomRight",true)	--右侧UI显示
end

function LevelBehavior200100101:__delete()

end

