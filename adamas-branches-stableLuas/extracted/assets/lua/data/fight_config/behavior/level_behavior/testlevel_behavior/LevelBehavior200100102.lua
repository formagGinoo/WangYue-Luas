LevelBehavior200100102 = BaseClass("LevelBehavior200100102",LevelBehaviorBase)
--fight初始化
function LevelBehavior200100102:__init(fight)
	self.fight = fight
end

--预加载
function LevelBehavior200100102.GetGenerates()
	local generates = {900010}
	return generates
end

--UI预加载
function LevelBehavior200100102.GetUIGenerates()
	local generates = {
		FightEnum.PreLoadUI.FightTips--中间横幅和底部横幅
	}
	return generates
end

--参数初始化
function LevelBehavior200100102:Init()
	self.role = 0           --当前角色
	self.missionState = 0   --关卡流程

	self.wave = 0           --波数计数
	self.waveLimit = 5      --波数上限
	self.time = 0		    --世界时间
	self.timeStart = 0      --记录时间
	self.monsters = { Count = 0 }      --怪物的instance和其总数
	self.battleArea1 = false--是否处于战斗区域1

	self.tutorial = 0		
	self.pressCheck = 0		--检测核心被动按钮按压
	self.pressTime = 0		--检测核心被动按钮按压时长
	
	self.tutoMon = 0

	self.monstersGroup = {}
	self.groupTime = { Time = 0 , Mark = 0 }
	
	--创建关卡通用行为树
	self.levelBeha = BehaviorFunctions.CreateBehavior("LevelBehavior",self)
	--创建相机行为树
	self.levelCam = BehaviorFunctions.CreateBehavior("LevelCamera",self)
	--创建怪物组行为树
	self.monstersGroupBeha = BehaviorFunctions.CreateBehavior("LevelMonstersGroup",self)

end

--帧事件
function LevelBehavior200100102:Update()
	--每帧获得当前角色
	self.role = BehaviorFunctions.GetCtrlEntity()
	--获取时间，区域
	self.time = BehaviorFunctions.GetFightFrame()	
	--检测玩家是否处于战斗区域内
	self.battleArea1 = BehaviorFunctions.GetInAreaById("BattleArea1",self.role)

	--初始化，角色出生点
	if  self.missionState == 0 then
		self.entites = {}   --初始化self.entites表
		--获取地点
		local pb1 = BehaviorFunctions.GetTerrainPositionP("C1")
		BehaviorFunctions.SetPlayerBorn(pb1.x,pb1.y,pb1.z+6)	--角色位置
		self.timeStart =BehaviorFunctions.GetFightFrame()
		BehaviorFunctions.InitCameraAngle(180)
		local mp1 = BehaviorFunctions.GetTerrainPositionP("C1")
		BehaviorFunctions.DoLookAtPositionImmediately(self.role,mp1.x,nil,mp1.y)
		
		--初始化空气墙
		BehaviorFunctions.SetWallEnable("AW1",false)
		BehaviorFunctions.SetWallEnable("AW2",false)
		BehaviorFunctions.SetWallEnable("AW3",false)
		BehaviorFunctions.SetWallEnable("AW4",false)
		self.missionState = 1
		self.timeStart = BehaviorFunctions.GetFightFrame()		
		
		--UI显隐
		BehaviorFunctions.SetFightMainNodeVisible(2,"QTE",false)	--QTE隐藏
		BehaviorFunctions.SetFightMainNodeVisible(2,"J",false) 		--普攻隐藏
		BehaviorFunctions.SetFightMainNodeVisible(2,"K",false)		--闪避隐藏
		BehaviorFunctions.SetFightMainNodeVisible(2,"I",false)		--红技能隐藏
		BehaviorFunctions.SetFightMainNodeVisible(2,"O",false)		--蓝技能隐藏
		BehaviorFunctions.SetFightMainNodeVisible(2,"L",false)		--大招隐藏
		BehaviorFunctions.SetFightMainNodeVisible(2,"R",false)		--连携隐藏
		BehaviorFunctions.SetFightMainNodeVisible(2,"Joystick",false)--摇杆隐藏
	end	

	--开启技能辅助轮
	self.levelBeha:SkillTips()
	
	--关卡流程
		if self.missionState == 1 and self.time - self.timeStart >= 30 then
			BehaviorFunctions.ActiveSceneObj("trainerbgm",true)			--BGM
			self.levelBeha:OpenRemoteDialog(100201)							--叙慕核心被动引导前对话
			self.missionState = 2		
		end
		
		if self.missionState == 2 and self.levelBeha:DialogCheck() == true then
			BehaviorFunctions.ShowTip(1002001)								--tips：释放核心被动
			self.missionState = 5
		
		elseif self.missionState == 5 and self.tutorial == 9 then
			self.missionState = 6											--结束教程阶段
		
		elseif self.missionState == 10 then									--击败第一波敌人
			self.timeStart = BehaviorFunctions.GetFightFrame()
			self.missionState = 11
		
		elseif self.missionState == 11 and self.time - self.timeStart == 30 then
			self.levelBeha:OpenRemoteDialog(100204)							--向心对话1
			self.missionState = 12
		
		elseif self.missionState == 12 and self.levelBeha:DialogCheck() == true then 
			self.timeStart = BehaviorFunctions.GetFightFrame()
			BehaviorFunctions.ShowTip(1002003)								--tips：击败剩余训练人偶
			self.missionState = 20											--刷出第二波敌人
		
		elseif self.missionState == 21 then
			self.timeStart = BehaviorFunctions.GetFightFrame()
			self.missionState = 22
		
		elseif self.missionState == 22 and self.time - self.timeStart == 30 then
			self.levelBeha:OpenRemoteDialog(100205)							--向心提示最后一波敌人
			self.missionState = 23
		
		elseif self.missionState == 23 and self.levelBeha:DialogCheck() == true then
			self.timeStart = BehaviorFunctions.GetFightFrame()
			BehaviorFunctions.ShowTip(1002003)								--tips：击败剩余训练人偶
			self.missionState = 25											--刷出最后一波波敌人
			
		elseif self.missionState == 30 and self.monsters.Count == 0 then
			self.levelBeha:OpenRemoteDialog(100206)							--向心告知贝露贝特的事
			self.missionState = 31		
										  	 
		elseif self.missionState == 31 and self.levelBeha:DialogCheck() == true then
			self.missionState = 40
		
		end
	
	--关卡退出倒计时
	if self.missionState == 40  then
		self.levelBeha:LevelEndCount(3)
		self.missionState = 41
	end
	
	--引导流程
	if self.wave == 1 and self.missionState == 5 and self.tutorial == 0 then
		self.timeStart = BehaviorFunctions.GetFightFrame()
		self.tutorial = 1

	elseif self.tutorial == 1 and self.time - self.timeStart == 61	then
		self.levelBeha:ShowGuideByDistance(100201,self.tutoMon,5,2)		   --根据距离显示引导：释放核心被动
		BehaviorFunctions.DoMagic(self.role, self.role,200000004,1, FightEnum.MagicConfigFormType.Level) --红技能能量+1
		self.levelBeha:TutorialGuide(100201)							   --引导使用红技能
		BehaviorFunctions.SetFightMainNodeVisible(2,"I",true)			   --红技能显示
		self.tutorial = 2
		
	elseif self.tutorial == 2 and BehaviorFunctions.CheckKeyDown(FightEnum.KeyEvent.RedSkill) then
		self.timeStart = BehaviorFunctions.GetFightFrame()
		self.tutorial = 3
		
	elseif self.tutorial == 3 and self.time - self.timeStart == 30 then
		self.levelBeha:TutorialGuide(100202)							   --引导核心被动值
		self.levelBeha:ShowGuideByDistance(100201,self.tutoMon,5,2)		   --根据距离显示引导：释放核心被动
		self.tutorial = 4

	elseif self.tutorial == 4 and BehaviorFunctions.CheckKeyDown(FightEnum.KeyEvent.GuideClick) then
		BehaviorFunctions.DoMagic(self.role, self.role,200000005,1, FightEnum.MagicConfigFormType.Level)--核心被动加满
		BehaviorFunctions.SetFightMainNodeVisible(2,"I",false) 				--红技能隐藏
		self.levelBeha:TutorialGuide(100203)							    --引导核心被动
		BehaviorFunctions.SetFightMainNodeVisible(2,"J",true) 				--普攻显示
		self.timeStart = BehaviorFunctions.GetFightFrame()
		self.tutorial =4.5
		
		
	elseif self.tutorial == 4.5 and self.time - self.timeStart == 1 then
		self:StopTime()														--过一帧暂停时间，不然动效出不来
		self.timeStart = BehaviorFunctions.GetFightFrame()
		self.tutorial = 5		
	
	elseif self.tutorial == 5 then
		if BehaviorFunctions.CheckKeyPress(FightEnum.KeyEvent.Attack) == true and self.pressCheck == 0 then
			self.timeStart = BehaviorFunctions.GetFightFrame()
			self.pressCheck = 1
		end	
		
		if BehaviorFunctions.GetKeyPressFrame(FightEnum.KeyEvent.Attack) >= 7 then
			self:Continue()
		end
		
		if BehaviorFunctions.CheckKeyUp(FightEnum.KeyEvent.Attack) == true and self.pressCheck == 1 then
			self.pressTime = self.time - self.timeStart
			self.pressCheck = 0
				
			if self.pressTime >= 7 then
				self.levelBeha:ShowGuideByDistance(100202,self.tutoMon,5,2)		   --根据距离显示引导：击败训练人偶
				self.timeStart = BehaviorFunctions.GetFightFrame()
				BehaviorFunctions.SetFightMainNodeVisible(2,"J",false) 				--普攻隐藏
				self.tutorial = 6
				
			elseif self.pressTime < 7 then
				self.levelBeha:TutorialGuide(100203)							   --引导核心被动
			end
		end			
		
	elseif self.tutorial == 6 and self.time - self.timeStart == 30 then
		self:StopTime()
		BehaviorFunctions.SetFightMainNodeVisible(2,"J",true) 				--普攻显示
		self.levelBeha:TutorialGuide(100204)							  	--连击动效显示
		self.tutorial = 7
	
		
	elseif self.tutorial == 7 then
		BehaviorFunctions.DoMagic(self.role, self.role,200000005,1, FightEnum.MagicConfigFormType.Level)--玩家没进入下一个引导前，一直充满核心被动能量
		if BehaviorFunctions.CheckKeyDown(FightEnum.KeyEvent.GuideClick) then
			self:Continue()
			BehaviorFunctions.SetFightMainNodeVisible(2,"QTE",true)				--QTE显示
			BehaviorFunctions.SetFightMainNodeVisible(2,"K",true)				--闪避显示
			BehaviorFunctions.SetFightMainNodeVisible(2,"I",true)				--红技能显示
			BehaviorFunctions.SetFightMainNodeVisible(2,"O",true)				--蓝技能显示
			BehaviorFunctions.SetFightMainNodeVisible(2,"L",true)				--大招显示
			BehaviorFunctions.SetFightMainNodeVisible(2,"Joystick",true)		--摇杆显示
			BehaviorFunctions.SetEntityValue(self.tutoMon,"idle",0)				--敌人恢复正常逻辑
			self.timeStart = BehaviorFunctions.GetFightFrame()
			self.tutorial = 8
		end
		
	elseif self.tutorial == 8 and self.time - self.timeStart == 60 then	
		BehaviorFunctions.ShowTip(1002002)										--tips：击败训练人偶
		self.tutorial = 9
	end
	
	--分组攻击命令
	if self.missionState >= 5 and self.monsters.Count ~= 0 then
		
		if self.wave == 2 then
			self.monstersGroupBeha:MonsterGroupAttack(self.monstersGroup,1,5,1)
		end
		
		if self.wave == 3 then
			self.monstersGroupBeha:MonsterGroupAttack(self.monstersGroup,2,5,1)
		end
	end
	
	--召怪流程
	if self.missionState >= 5 and self.monsters.Count == 0  then
		if self.wave == 0 then
			
			local mp1 = BehaviorFunctions.GetTerrainPositionP("C1")
			self.tutoMon = BehaviorFunctions.CreateEntity(900010)
			BehaviorFunctions.SetEntityValue(self.tutoMon,"idle",1)
			BehaviorFunctions.DoSetPosition(self.tutoMon,mp1.x,mp1.y,mp1.z)		
			table.insert(self.monsters,{wave = 1,instanceId = self.tutoMon})
			
			self.levelCam:Position_Camera(self.role,mp1,1)				--玩家看向目标点

			BehaviorFunctions.SetWallEnable("AW1",false)
			self.wave = self.wave + 1
			
		elseif self.wave == 1  and self.missionState == 20 then
			
			if self.time - self.timeStart == 60 then				
				
				self.levelBeha:CreatMonster(self.monsters,{
						{id = 900010 ,posName = "C1",wave = 2},
						{id = 900010 ,posName = "C1",X_offset = 2,Z_offset = 2,wave = 2},
						{id = 900010 ,posName = "C1",X_offset = 2,Z_offset = -2,wave = 2}
					})

				local mp1 = BehaviorFunctions.GetTerrainPositionP("C1")

				self.levelCam:Position_Camera(self.role,mp1,1)			--玩家看向目标出生点

				self.monstersGroupBeha:MonsterGroup(self.monstersGroup,1,self.monsters[1].instanceId,self.monsters[2].instanceId,self.monsters[3].instanceId)

				self.wave = self.wave + 1
				
				--指引敌人
				BehaviorFunctions.SetGuide(100108,mp1.x,mp1.y,mp1.z)
				BehaviorFunctions.SetGuideState(false)
				BehaviorFunctions.HideGuidePointState()
				BehaviorFunctions.ShowTip(1002002)

			end
			
		elseif self.wave == 2  and self.missionState == 25 then
			
			if self.time - self.timeStart == 60 then

					self.levelBeha:CreatMonster(self.monsters,{
							{id = 900010 ,posName = "C1",wave = 3},
							{id = 900010 ,posName = "C1",X_offset = 2,Z_offset = 2,wave = 3},
							{id = 900010 ,posName = "C1",X_offset = 2,Z_offset = -2,wave = 3}
						})

					local mp1 = BehaviorFunctions.GetTerrainPositionP("C1")

					self.levelCam:Position_Camera(self.role,mp1,1)			--玩家看向目标出生点

					self.monstersGroupBeha:MonsterGroup(self.monstersGroup,2,self.monsters[1].instanceId,self.monsters[2].instanceId,self.monsters[3].instanceId)

					self.wave = self.wave + 1
				
				--指引敌人
				BehaviorFunctions.SetGuide(100108,mp1.x,mp1.y,mp1.z)
				BehaviorFunctions.SetGuideState(false)
				BehaviorFunctions.HideGuidePointState()
			end
		end	
	end
	--怪物数量记录
	self.monsters.Count = self.levelBeha:WaveCount(self.monsters,self.wave)
	--清怪检测
	if self.monsters.Count == 0 then
		if self.wave == 1 and self.missionState == 6 then
			self.missionState = 10

		elseif self.wave == 2 and self.missionState == 20 then
			self.missionState = 21

		elseif self.wave == 3 and self.missionState == 25 then
			self.missionState = 30

		end
	end
end

--死亡事件
function LevelBehavior200100102:Death(instanceId)
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
function LevelBehavior200100102:StopTime()        --暂停实体时间和行为
	local npcs = BehaviorFunctions.SearchNpc()
	for i in ipairs(npcs)  do
		BehaviorFunctions.DoMagic(npcs[i], npcs[i],200000001,1, FightEnum.MagicConfigFormType.Level)
	end
end

--解除时间暂停
function LevelBehavior200100102:Continue()        --解除暂停
	local npcs = BehaviorFunctions.SearchNpc()
	for i in ipairs(npcs)  do
		BehaviorFunctions.RemoveBuff(npcs[i],200000001)
	end
end

--获取目前可交互npc的id
function LevelBehavior200100102:EnterTrigger(triggerInstanceId,triggerEntityId,roleInstanceId)
	self.InterInstance = triggerInstanceId
	BehaviorFunctions.SetFightMainNodeVisible(2,"ButtomRight",false)	--右侧UI隐藏
end

--离开范围时，取消所有交互ui
function LevelBehavior200100102:ExitTrigger(triggerInstanceId,triggerEntityId,roleInstanceId)
	self.InterInstance = nil
	BehaviorFunctions.SetFightMainNodeVisible(2,"ButtomRight",true)	--右侧UI显示
end