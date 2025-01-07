LevelBehavior200100103 = BaseClass("LevelBehavior200100103",LevelBehaviorBase)
--fight初始化
function LevelBehavior200100103:__init(fight)
	self.fight = fight
end

--预加载
function LevelBehavior200100103.GetGenerates()
	local generates = {900020,900021,900022,900023,900000102,910024,200000101,200000102,200000103}
	return generates
end

--mgaic预加载
function LevelBehavior200100103.GetMagics()
	local generates = {200000104}
	return generates
end

--UI预加载
function LevelBehavior200100103.GetUIGenerates()
	local generates = {
		FightEnum.PreLoadUI.FightTips--中间横幅和底部横幅
	}
	return generates
end

--参数初始化
function LevelBehavior200100103:Init()
	self.role = 0           --当前角色
	self.missionState = 0   --关卡流程

	self.wave = 0           --波数计数
	self.waveLimit = 5      --波数上限
	self.time = 0		    --世界时间
	self.timeStart = 0      --记录时间
	self.monsters = { Count = 0 }      --怪物的instance和其总数

	self.tutorial = 0
	self.pressCheck = 0
	self.pressTime = 0

	self.tutoMon = nil

	self.monstersGroup = {}
	self.groupTime = { Time = 0 , Mark = 0 }
	self.mark = 0
	
	--创建关卡通用行为树
	self.levelBeha = BehaviorFunctions.CreateBehavior("LevelBehavior",self)
	--创建相机行为树
	self.levelCam = BehaviorFunctions.CreateBehavior("LevelCamera",self)
	--创建怪物组行为树
	self.monstersGroupBeha = BehaviorFunctions.CreateBehavior("LevelMonstersGroup",self)
	
	--教学怪参数
	self.tutoMonMoveState = 0
	self.buffSwitch = 0
	self.checkState = {}
end

--帧事件
function LevelBehavior200100103:Update()
	--每帧获得当前角色
	self.role = BehaviorFunctions.GetCtrlEntity()
	--获取时间，区域
	self.time = BehaviorFunctions.GetFightFrame()

	--初始化，角色出生点
	if  self.missionState == 0 then
		self.entites = {}   --初始化self.entites表
		----获取地点
		--local pb1 = BehaviorFunctions.GetTerrainPositionP("Born3")
		--BehaviorFunctions.SetPlayerBorn(pb1.x,pb1.y,pb1.z)	--角色位置
		--self.timeStart =BehaviorFunctions.GetFightFrame()
		--BehaviorFunctions.InitCameraAngle(180)
		--local mp1 = BehaviorFunctions.GetTerrainPositionP("s3")
		--BehaviorFunctions.DoLookAtPositionImmediately(self.role,mp1.x,mp1.y)
		
		--玩家角色出生
		self.levelBeha:PlayerBorn("Born3","s4")

		--初始化空气墙
		BehaviorFunctions.SetWallEnable("AW1",true)
		BehaviorFunctions.SetWallEnable("AW2",true)
		BehaviorFunctions.SetWallEnable("AW3",true)
		BehaviorFunctions.SetWallEnable("AW4",true)
		BehaviorFunctions.SetWallEnable("AW5",true)
		BehaviorFunctions.SetWallEnable("AW6",true)
		BehaviorFunctions.SetWallEnable("AW7",true)
		BehaviorFunctions.SetWallEnable("AW8",true)

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
	if self.missionState == 1 and self.time - self.timeStart == 0 then
		BehaviorFunctions.ActiveSceneObj("wastelandbgm",true)				--BGM
		BehaviorFunctions.SetFightMainNodeVisible(2,"main",false)
		--BehaviorFunctions.ActiveSceneObj("Timeline_01",true)				--开始播放开头剧情
		BehaviorFunctions.PlaySceneTimeline("Timeline_01")
		self.timeStart = BehaviorFunctions.GetFightFrame()
		self.missionState = 2
	
	elseif self.missionState == 2 and self.time - self.timeStart == 300 then
		BehaviorFunctions.ShowTip(1003005)									--刻刻表示叙慕的名字第一次听说
		
	elseif self.missionState == 2 and self.time - self.timeStart == 420 then
		BehaviorFunctions.SetEntityValue(self.tutoMon,"jumpOut",true)		--蜥蜴跑出来偷袭
		
	elseif self.missionState == 2 and self.time - self.timeStart == 540 then
		BehaviorFunctions.DoSetEntityState(self.tutoMon,FightEnum.EntityState.Move)
		BehaviorFunctions.DoSetMoveType(self.tutoMon,FightEnum.EntityMoveSubState.Walk)
		
	elseif self.missionState == 2 and self.time - self.timeStart == 655 then
		BehaviorFunctions.DoLookAtTargetImmediately(self.role,self.tutoMon)	--逻辑演出：刻刻回头开枪
		BehaviorFunctions.CastSkillByTarget(self.role,1004001,self.tutoMon)
	
	elseif self.missionState == 2 and self.time - self.timeStart == 677 then	
		BehaviorFunctions.ShowTip(1003006)									--刻刻表示不耐烦
		
	elseif self.missionState == 2 and self.time - self.timeStart == 788 then
		local tutomon = BehaviorFunctions.GetPositionP(self.tutoMon)
		self.levelCam:Position_Camera(self.role,tutomon,1)
		
	elseif self.missionState == 2 and self.time - self.timeStart == 800 then
		BehaviorFunctions.StopSceneTimeline()								--timeline剧情结束
		BehaviorFunctions.ActiveSceneObj("TimelineCamera",false)			--timeline镜头	
		self.timeStart = BehaviorFunctions.GetFightFrame()
		self.missionState = 3

	elseif self.missionState == 3 then
		local tutomon = BehaviorFunctions.GetPositionP(self.tutoMon)
		self.levelCam:Position_Camera(self.role,tutomon,1)
		self.missionState = 4
		
	elseif self.missionState == 4 then
		self.timeStart = BehaviorFunctions.GetFightFrame()				--结束对话，切回正常镜头，引导环节开始
		self.missionState = 5
		
	elseif self.missionState == 5 then
		BehaviorFunctions.SetFightMainNodeVisible(2,"main",true)
		if self.tutorial == 9 then
			BehaviorFunctions.ShowTip(1003001)							--tips：击败色金生物
			self.missionState = 6										--教学流程结束
		end
		
	elseif self.missionState == 6 then
		if self.wave == 1 and self.monsters.Count == 0 then
			self.missionState = 7										--玩家击败教学敌人
			self.timeStart = BehaviorFunctions.GetFightFrame()
		end
		
	elseif self.missionState == 7 and self.time - self.timeStart == 15 then
		self.levelBeha:OpenRemoteDialog(100304)							--刻刻想确认土地的气脉情况
		BehaviorFunctions.SetWallEnable("AW5",false)
		self.missionState = 8
	
	elseif self.missionState == 8 and self.levelBeha:DialogCheck() == true then
		local point = BehaviorFunctions.GetTerrainPositionP("qimai2")	
		self.qimai = BehaviorFunctions.CreateEntity(200000102,nil,point.x-1,point.y + 0.75 , point.z+2)--设置气脉
		self.missionState = 9											--刷出第二波敌人
	
	elseif self.missionState == 9 then
		self.levelBeha:ShowGuideByDistance(100303,self.qimai,3,0.75)	--根据距离显示引导：探查附近气脉
		if self.InterInstance == self.qimai then
			BehaviorFunctions.ShowTip(1003002)							--tips:与气脉进行共鸣
			if BehaviorFunctions.CheckKeyDown(FightEnum.KeyEvent.Common1) then
				local position	= BehaviorFunctions.GetTerrainPositionP("qimai2")
				BehaviorFunctions.DoLookAtPositionImmediately(self.role,position.x,nil,position.z)--玩家立刻看向交互点
				BehaviorFunctions.CastSkillByPositionP(self.role,1004090,"qimai2")--刻刻释放交互动作
				self.levelBeha:RemoveInteractionPoint(self.qimai)		--交互后移除气脉
				BehaviorFunctions.SetFightMainNodeVisible(2,"ButtomRight",true)--右侧UI显示
				BehaviorFunctions.ActiveUI(FightEnum.UIActiveType.Main,false)--隐藏战斗ui
				BehaviorFunctions.InteractTrigger(false)				--隐藏交互按钮
				BehaviorFunctions.HideTip()
				self.missionState = 9.1
			end
		elseif self.InterInstance == nil then
			BehaviorFunctions.HideTip()
		end
		
	elseif self.missionState == 9.1 then
		local target = BehaviorFunctions.GetTerrainPositionP("patrol1_2")
		target.y = target.y + 1
		local refP = BehaviorFunctions.GetTerrainPositionP("qimai2")
		self.levelCam:OTS_Camera(self.role,target,refP,3)
		self.timeStart = BehaviorFunctions.GetFightFrame()
		self.missionState = 9.2
	
	elseif self.missionState == 9.2 and self.time - self.timeStart == 30 then	
		BehaviorFunctions.ActiveSceneObj("qimai2_start",true)			--气脉汇聚特效
		self.timeStart = BehaviorFunctions.GetFightFrame()
		self.missionState = 9.3
		
	elseif self.missionState == 9.3 and self.time - self.timeStart == 97 then
		BehaviorFunctions.ActiveSceneObj("qimai2_start",false)
		BehaviorFunctions.ActiveSceneObj("qimai2_loop",true)			--气脉循环特效
		self.timeStart = BehaviorFunctions.GetFightFrame()
		self.missionState = 9.4
		
	elseif self.missionState == 9.4 and self.time - self.timeStart == 30 then
		self.levelBeha:OpenRemoteDialog(100306)							--刻刻认为前方可能有些不寻常的东西		
		self.missionState = 9.5
		
	elseif self.missionState == 9.5 and self.levelBeha:DialogCheck() == true then
		--预留：给出镜头，就在刻刻想去前方确认的时候，周围的色金开始动了起来
		self.missionState = 10
		
	elseif self.missionState == 10 then
		BehaviorFunctions.ShowTip(1003003)								--tips:色金生物被惊扰了
		self.levelBeha:SetPositionGuide(100305,"qimai2")				--引导：击败色金生物
		BehaviorFunctions.HideGuidePointState()
		BehaviorFunctions.SetEntityValue(self.monsters[1].instanceId,"jumpOut",true)--第二波蜥蜴全部跳出，进入战斗状态
		BehaviorFunctions.SetEntityValue(self.monsters[2].instanceId,"jumpOut",true)
		BehaviorFunctions.SetEntityValue(self.monsters[3].instanceId,"jumpOut",true)
		self.missionState = 11
		
	elseif self.missionState == 11 then
		if self.wave == 2 and self.monsters.Count == 0 then
			self.missionState = 11.1										--玩家击败第二波敌人
			self.timeStart = BehaviorFunctions.GetFightFrame()
		end	
		
	elseif self.missionState == 11.1 then
		local position = BehaviorFunctions.GetTerrainPositionP("patrol1_1")
		self.levelCam:Position_Camera(self.role,position,1)				--引导玩家看向
		BehaviorFunctions.SetWallEnable("AW4",false)
		self.roadSign = self.levelBeha:SetRoadSign("patrol1_1",-0.3)	--放置路标
		self.levelBeha:SetPositionGuide(100307,"patrol1_1",0.75)		--指引：沿着气脉前进
		BehaviorFunctions.ShowTip(1003007)								--tips:前往气脉混乱的源头
		self.missionState = 11.2
		
	elseif self.missionState == 11.2 then
		if self.levelBeha:DistanceToPosition(self.role,"patrol1_1") <= 1 then
			BehaviorFunctions.RemoveEntity(self.roadSign)				--移除路标
			BehaviorFunctions.SetWallEnable("AW4",true)					--封锁战斗区域
			self.timeStart = BehaviorFunctions.GetFightFrame()
			self.missionState = 12
		end
		
	elseif self.missionState == 12 and self.time - self.timeStart == 15 then		
		self.levelBeha:OpenRemoteDialog(100307)							--刻刻希望隐秘行动
		self.missionState = 13
		
	elseif self.missionState == 13 and self.levelBeha:DialogCheck() == true then
		BehaviorFunctions.SetEntityValue(self.patrol1.instanceId,"jumpOut",true)
		BehaviorFunctions.SetEntityValue(self.patrol2.instanceId,"jumpOut",true)
		BehaviorFunctions.SetWallEnable("AW2",false)
		BehaviorFunctions.SetWallEnable("AW8",false)
		self.missionState = 13.5
		
	elseif self.missionState == 13.5 then
		BehaviorFunctions.SetWallEnable("AW2",false)
		BehaviorFunctions.ShowTip(1003004)								--tips:前往混乱气脉的源头
		self.levelBeha:SetPositionGuide(100306,"s5")					--引导：追寻气脉的源头
		self.missionState = 14
		
	elseif self.missionState == 14 then
		local disturbed = self:CheckLizardState()						--检测玩家有没有惊扰到蜥蜴
		if disturbed == true then
			self.missionState = 15										--如果惊扰到蜥蜴则要求玩家先击败蜥蜴
			BehaviorFunctions.SetWallEnable("AW2",true)
		end
		
		if self.levelBeha:DistanceToPosition(self.role,"s5") <= 15 then --玩家靠近了目标点
			BehaviorFunctions.SetWallEnable("AW2",true)					--封住墙不让玩家出去
			for i = 1, self.monsters.Count do
				BehaviorFunctions.RemoveEntity(self.monsters[i].instanceId)--删除蜥蜴
			end
			self.missionState = 20										
		end	
	
	elseif self.missionState == 15 then
		BehaviorFunctions.ShowTip(1003003)								--tips:色金生物被惊扰了
		self.levelBeha:SetPositionGuide(100305,"s2")					--引导：击败色金生物
		BehaviorFunctions.HideGuidePointState()
		self.missionState = 16
		
	elseif self.missionState == 16 then
		local disturbed = self:CheckLizardState()						--检测玩家是否还处于惊扰蜥蜴状态
		if disturbed ~= true then
			self.missionState = 13.5									--如果惊扰到的蜥蜴已经死了则返回14
		end
		
	elseif self.missionState == 20 then
		if self.levelBeha:DistanceToPosition(self.role,"s5") <= 2 then
			self.missionState = 21										--检测到玩家抵达了终点
		end
		
	elseif self.missionState == 21 then
		self.levelBeha:OpenRemoteDialog(100308)							--刻刻察觉到是陷阱
		self.missionState = 22	
		
	elseif self.missionState == 22 and self.levelBeha:DialogCheck() == true then
		local fp1 = BehaviorFunctions.GetTerrainPositionP("s5")
		local mb1 = BehaviorFunctions.GetTerrainPositionP("mb204")
		local mb2 = BehaviorFunctions.GetTerrainPositionP("mb205")
		local mb3 = BehaviorFunctions.GetTerrainPositionP("mb206")

		self.mon1 = BehaviorFunctions.CreateEntity(900021,nil,fp1.x-5,fp1.y,fp1.z+3)
		self.mon2 = BehaviorFunctions.CreateEntity(910024,nil,fp1.x-6,fp1.y,fp1.z)
		self.mon3 = BehaviorFunctions.CreateEntity(900023,nil,fp1.x-5,fp1.y,fp1.z-3)
		
		BehaviorFunctions.SetEntityValue(self.mon1,"closeBornSkill",true)
		BehaviorFunctions.SetEntityValue(self.mon1,"runAi",false)
		BehaviorFunctions.DoLookAtTargetImmediately(self.mon1,self.role)
		BehaviorFunctions.SetEntityValue(self.mon2,"closeBornSkill",true)
		BehaviorFunctions.SetEntityValue(self.mon2,"runAi",false)
		BehaviorFunctions.DoLookAtTargetImmediately(self.mon2,self.role)
		BehaviorFunctions.SetEntityValue(self.mon3,"closeBornSkill",true)
		BehaviorFunctions.SetEntityValue(self.mon3,"runAi",false)
		BehaviorFunctions.DoLookAtTargetImmediately(self.mon3,self.role)
		
		local p = BehaviorFunctions.GetPositionP(self.mon2)
		self.levelCam:Position_Camera(self.role,p,1)
		BehaviorFunctions.DoLookAtTargetImmediately(self.role,self.mon2)
		self.missionState = 23
		
	elseif self.missionState == 23 then
		self.levelBeha:OpenRemoteDialog(100309)							--刻刻察觉到是陷阱
		self.missionState = 24
		
	elseif self.missionState == 24 and self.levelBeha:DialogCheck() == true then
		BehaviorFunctions.SetFightMainNodeVisible(2,"main",false)		--隐藏主UI
		BehaviorFunctions.ActiveSceneObj("Timeline_04",true)			--timeline:叙慕抵达现场
		self.timeStart = BehaviorFunctions.GetFightFrame()
		self.missionState = 40		
		
	elseif self.missionState == 40 and self.time - self.timeStart == 180 then		
		BehaviorFunctions.ShowTip(1003008)								--叙慕抵达荒漠	
		
	elseif self.missionState == 40 and self.time - self.timeStart == 233 then
		BehaviorFunctions.ShowTip(1003009)								--叙慕抵达荒漠
		
	elseif self.missionState == 40 and self.time - self.timeStart == 300 then
		BehaviorFunctions.SetFightResult(true)
		self.missionState = 41
	end
	
	--蜥蜴巡逻逻辑
	if self.wave == 3 and self.missionState < 20 then
		if BehaviorFunctions.CheckEntity(self.patrol1.instanceId) == true then
			if BehaviorFunctions.GetEntityValue(self.patrol1.instanceId,"runAi") ~= true then
				self.patrol1.CurrentP = self.levelBeha:MonsterPatrol(self.patrol1.instanceId,{"patrol1_5","patrol1_4","patrol1_3"},self.patrol1.CurrentP)
				if self.levelBeha:PatrolDet(self.patrol1.instanceId,self.role,45,5) == true
					or self.patrol1.beenHit == true then
					BehaviorFunctions.SetEntityValue(self.patrol1.instanceId,"runAi",true)	--关闭游荡逻辑
				end
			end
		end

		if BehaviorFunctions.CheckEntity(self.patrol2.instanceId) == true then
			if BehaviorFunctions.GetEntityValue(self.patrol2.instanceId,"runAi") ~= true then
				self.patrol2.CurrentP = self.levelBeha:MonsterPatrol(self.patrol2.instanceId,{"patrol1_4","patrol1_2","patrol1_1"},self.patrol2.CurrentP)
				if self.levelBeha:PatrolDet(self.patrol2.instanceId,self.role,45,5) == true
					or self.patrol2.beenHit == true then
					BehaviorFunctions.SetEntityValue(self.patrol2.instanceId,"runAi",true)	--关闭游荡逻辑
				end
			end
		end
	end

	--引导流程
	if self.wave == 1 and self.missionState == 5 and self.tutorial == 0 then
		self.timeStart = BehaviorFunctions.GetFightFrame()
		self.tutorial = 1

	elseif self.tutorial == 1 and self.time - self.timeStart == 60	then
		self.levelBeha:ShowGuideByDistance(100301,self.tutoMon,5,2)			--根据距离显示引导：释放刻刻核心被动
		BehaviorFunctions.DoMagic(self.role, self.role,200000004,1, FightEnum.MagicConfigFormType.Level)--红技能能量+1
		self.levelBeha:TutorialGuide(100301)							   --引导使用红技能
		BehaviorFunctions.SetFightMainNodeVisible(2,"I",true)			   --红技能显示
		self.tutorial = 2

	elseif self.tutorial == 2 and BehaviorFunctions.CheckKeyDown(FightEnum.KeyEvent.RedSkill) then
		self.timeStart = BehaviorFunctions.GetFightFrame()
		self.tutorial = 3

	elseif self.tutorial == 3 and self.time - self.timeStart == 30 then
		self.levelBeha:ShowGuideByDistance(100301,self.tutoMon,5,2)			--根据距离显示引导：释放刻刻核心被动
		self.levelBeha:TutorialGuide(100302)							    --引导核心被动值
		self.tutorial = 4

	elseif self.tutorial == 4 and BehaviorFunctions.CheckKeyDown(FightEnum.KeyEvent.GuideClick) then
		BehaviorFunctions.DoMagic(self.role, self.role,200000005,1, FightEnum.MagicConfigFormType.Level)--核心被动加满
		BehaviorFunctions.SetFightMainNodeVisible(2,"I",false) 				--红技能隐藏
		self.levelBeha:TutorialGuide(100303)							    --引导核心被动
		BehaviorFunctions.SetFightMainNodeVisible(2,"J",true) 				--普攻显示
		self.timeStart = BehaviorFunctions.GetFightFrame()
		self.tutorial = 4.5
	
	elseif self.tutorial == 4.5 and self.time - self.timeStart == 3 then
		self:StopTime()
		self.tutorial = 5

	elseif self.tutorial == 5 then
		if BehaviorFunctions.CheckKeyPress(FightEnum.KeyEvent.Attack) == true and self.pressCheck == 0 then
			self.timeStart = BehaviorFunctions.GetFightFrame()
			self.pressCheck = 1
		end

		if BehaviorFunctions.GetKeyPressFrame(FightEnum.KeyEvent.Attack) >= 7 and self.pressCheck == 1 then
			self:Continue()
			self.pressCheck = 2
			self.timeStart = BehaviorFunctions.GetFightFrame()
		
		elseif BehaviorFunctions.CheckKeyUp(FightEnum.KeyEvent.Attack) and self.pressCheck == 1 then	
			if self.time - self.timeStart < 7 then
				self.levelBeha:TutorialGuide(100303)						--引导核心被动
				self.pressCheck = 0
			end
		end

		if  self.pressCheck == 2 then
			if BehaviorFunctions.CheckKeyUp(FightEnum.KeyEvent.Attack) == true  then
				self.timeStart = BehaviorFunctions.GetFightFrame()
				self.tutorial = 6
				 
			elseif self.time - self.timeStart == 60 then
				self.timeStart = BehaviorFunctions.GetFightFrame()
				self.tutorial = 6
			end
		end


	elseif self.tutorial == 6 and self.time - self.timeStart == 30 then
		self.levelBeha:ShowGuideByDistance(100302,self.tutoMon,5,2)			--根据距离显示引导：击败敌人并前往汇合点
		self.timeStart = BehaviorFunctions.GetFightFrame()

		self.tutorial = 7

	elseif self.tutorial == 7 then
		BehaviorFunctions.SetFightMainNodeVisible(2,"K",true)				--闪避显示
		BehaviorFunctions.SetFightMainNodeVisible(2,"I",true)				--红技能显示
		BehaviorFunctions.SetFightMainNodeVisible(2,"O",true)				--蓝技能显示
		BehaviorFunctions.SetFightMainNodeVisible(2,"L",true)				--大招显示
		BehaviorFunctions.SetFightMainNodeVisible(2,"Joystick",true)		--摇杆显示
		BehaviorFunctions.SetEntityValue(self.tutoMon,"idle",0)				--敌人恢复正常逻辑
		self.timeStart = BehaviorFunctions.GetFightFrame()
		self.tutorial = 8

	elseif self.tutorial == 8 and self.time - self.timeStart == 60 then
		self.tutorial = 9
	end
	
	--教程用锁血buff	
	if BehaviorFunctions.CheckEntity(self.tutoMon) == true then
		if self.tutorial < 8 and self.tutorial >= 1 then
			if self.buffSwitch == 0 then
				BehaviorFunctions.DoMagic(self.tutoMon, self.tutoMon, 200000002, 1, FightEnum.MagicConfigFormType.Level)
				self.buffSwitch = 1
			end
			if BehaviorFunctions.GetEntityAttrValueRatio(self.tutoMon,1001) <= 2000 then--20%血以下进行回血
				BehaviorFunctions.ChangeEntityAttr(self.tutoMon,1001,50000)
			end
		end
		if self.tutorial >= 8 then
			BehaviorFunctions.RemoveBuff(self.tutoMon,200000002)
		end
	end
	
	--教学怪运行逻辑
	if self.tutoMon ~= nil then
		if self.wave == 1 and self.missionState == 1 then
			BehaviorFunctions.SetEntityValue(self.tutoMon,"runAi",false)--出生时关闭正常逻辑
		end
		if self.tutorial < 7 then
			self:MonsterTutorialMode(self.tutoMon)						--持续进行教学逻辑
		elseif self.tutorial == 7 then
			BehaviorFunctions.SetEntityValue(self.tutoMon,"runAi",true)	--关闭教学逻辑
		end
	end

	--分组攻击命令
	if self.missionState >= 5 and self.monsters.Count ~= 0 then

		if self.wave == 2 then
			self.monstersGroupBeha:MonsterGroupAttack(self.monstersGroup,1,5,1)
		end

		if self.wave == 3 then
			--self.monstersGroupBeha:MonsterGroupAttack(self.monstersGroup,2,5,1)
		end
	end
	
	--召怪流程
	if self.missionState >= 1 and self.monsters.Count == 0  then
		if self.wave == 0  then

			local mp1 = BehaviorFunctions.GetTerrainPositionP("mb401")

			self.tutoMon = BehaviorFunctions.CreateEntity(900020)
			BehaviorFunctions.DoSetPosition(self.tutoMon,mp1.x,mp1.y,mp1.z)
			BehaviorFunctions.DoLookAtTargetImmediately(self.tutoMon,self.role)
			table.insert(self.monsters,{wave = 1,instanceId = self.tutoMon})
			BehaviorFunctions.SetEntityValue(self.tutoMon,"runAi",false)--出生时关闭正常逻辑
			BehaviorFunctions.SetEntityValue(self.tutoMon,"bornType",2)--出生时设置为手动跳出模式

			self.wave = self.wave + 1

		elseif self.wave == 1  and self.missionState == 9 then
				
				self.levelBeha:CreatMonster(self.monsters,{
						{id = 900021 ,posName = "mb301",lookatposName = "qimai2",wave = 2},
						{id = 900022 ,posName = "mb302",lookatposName = "qimai2",wave = 2},
						{id = 900023 ,posName = "mb303",lookatposName = "qimai2",wave = 2}
					})
			
				BehaviorFunctions.SetEntityValue(self.monsters[1].instanceId,"bornType",2)--出生时设置为手动跳出模式
				BehaviorFunctions.SetEntityValue(self.monsters[2].instanceId,"bornType",2)--出生时设置为手动跳出模式
				BehaviorFunctions.SetEntityValue(self.monsters[3].instanceId,"bornType",2)--出生时设置为手动跳出模式

				self.monstersGroupBeha:MonsterGroup(self.monstersGroup,1,self.monsters[1].instanceId,self.monsters[2].instanceId,self.monsters[3].instanceId)

				self.wave = self.wave + 1

		elseif self.wave == 2  and self.missionState == 11.1 then
			
			--加入埋伏蜥蜴
			self.levelBeha:CreatMonster(self.monsters,{
					{id = 900020 ,posName = "mb207",lookatposName = "patrol1_1",wave = 3},
					{id = 900021 ,posName = "mb208",lookatposName = "patrol1_2",wave = 3},
					{id = 900022 ,posName = "mb209",lookatposName = "patrol1_2",wave = 3},
					{id = 900023 ,posName = "mb210",lookatposName = "patrol1_4",wave = 3},
					{id = 900022 ,posName = "mb211",lookatposName = "patrol1_3",wave = 3}
					--{id = 900021 ,posName = "mb212",lookatposName = "patrol1_2",wave = 3}
				})
			--埋伏蜥蜴添加范围圈
			BehaviorFunctions.DoMagic(self.monsters[1].instanceId,self.monsters[1].instanceId,200000104,1)
			BehaviorFunctions.DoMagic(self.monsters[2].instanceId,self.monsters[2].instanceId,200000104,1)
			BehaviorFunctions.DoMagic(self.monsters[3].instanceId,self.monsters[3].instanceId,200000104,1)
			BehaviorFunctions.DoMagic(self.monsters[4].instanceId,self.monsters[4].instanceId,200000104,1)
			BehaviorFunctions.DoMagic(self.monsters[5].instanceId,self.monsters[5].instanceId,200000104,1)
			--BehaviorFunctions.DoMagic(self.monsters[4].instanceId,self.monsters[6].instanceId,200000104,1)
			
			--加入巡逻蜥蜴
			local fp1 = BehaviorFunctions.GetTerrainPositionP("patrol1_2")
			local mb1 = BehaviorFunctions.GetTerrainPositionP("patrol1_5")
			local mb2 = BehaviorFunctions.GetTerrainPositionP("patrol1_4")
			self.patrol1 ={}
			self.patrol2 ={}
			self.patrol1.CurrentP = 1
			self.patrol2.CurrentP = 1
			self.patrol1.instanceId = BehaviorFunctions.CreateEntity(900020,nil,mb1.x,mb1.y,mb1.z)
			BehaviorFunctions.DoLookAtPositionImmediately(self.patrol1.instanceId,fp1.x,nil,fp1.z)
			table.insert(self.monsters,{wave = 3,instanceId = self.patrol1.instanceId})
			self.patrol2.instanceId = BehaviorFunctions.CreateEntity(900023,nil,mb2.x,mb2.y,mb2.z)
			table.insert(self.monsters,{wave = 3,instanceId = self.patrol2.instanceId})
			BehaviorFunctions.DoLookAtPositionImmediately(self.patrol2.instanceId,fp1.x,nil,fp1.z)			
			
			--巡逻蜥蜴设置
			--BehaviorFunctions.SetEntityValue(self.monsters[1].instanceId,"closeBornSkill",true)
			BehaviorFunctions.SetEntityValue(self.patrol1.instanceId,"runAi",false)
			BehaviorFunctions.SetEntityValue(self.patrol1.instanceId,"bornType",2)--出生时设置为手动跳出模式
			--BehaviorFunctions.SetEntityValue(self.patrol1.instanceId,"jumpOut",true)
			
			--BehaviorFunctions.SetEntityValue(self.monsters[2].instanceId,"closeBornSkill",true)
			BehaviorFunctions.SetEntityValue(self.patrol2.instanceId,"runAi",false)
			BehaviorFunctions.SetEntityValue(self.patrol2.instanceId,"bornType",2)--出生时设置为手动跳出模式
			--BehaviorFunctions.SetEntityValue(self.patrol2.instanceId,"jumpOut",true)				

			--self.monstersGroupBeha:MonsterGroup(self.monstersGroup,2,self.monsters[1].instanceId,self.monsters[2].instanceId,self.monsters[3].instanceId)
			self.wave = self.wave + 1
		end		
	end	
	--怪物数量记录
	self.monsters.Count = self.levelBeha:WaveCount(self.monsters,self.wave)
end


--死亡事件
function LevelBehavior200100103:Death(instanceId)
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
function LevelBehavior200100103:StopTime()        --暂停实体时间和行为
	local npcs = BehaviorFunctions.SearchNpc()
	for i in ipairs(npcs)  do
		BehaviorFunctions.DoMagic(npcs[i], npcs[i],200000001,1, FightEnum.MagicConfigFormType.Level)
	end
end

--解除时间暂停
function LevelBehavior200100103:Continue()        --解除暂停
	local npcs = BehaviorFunctions.SearchNpc()
	for i in ipairs(npcs)  do
		BehaviorFunctions.RemoveBuff(npcs[i],200000001)
	end
end

--获取目前可交互npc的id
function LevelBehavior200100103:EnterTrigger(triggerInstanceId,triggerEntityId,roleInstanceId)
	self.InterInstance = triggerInstanceId
	BehaviorFunctions.SetFightMainNodeVisible(2,"ButtomRight",false)	--右侧UI隐藏	
	BehaviorFunctions.InteractTrigger(true,1,-550,360)					--显示交互按钮
end

--离开范围时，取消所有交互ui
function LevelBehavior200100103:ExitTrigger(triggerInstanceId,triggerEntityId,roleInstanceId)
	self.InterInstance = nil
	BehaviorFunctions.SetFightMainNodeVisible(2,"ButtomRight",true)		--右侧UI显示
	BehaviorFunctions.InteractTrigger(false)							--隐藏交互按钮
end

--怪物教学发呆逻辑
function LevelBehavior200100103:MonsterTutorialMode(monsterID)
	local tutoMonState = BehaviorFunctions.GetEntityState(monsterID)
	local distance = BehaviorFunctions.GetDistanceFromTarget(monsterID,self.role)
	--持续朝向玩家
	if tutoMonState ~= FightEnum.EntityState.Die and BehaviorFunctions.CanCastSkill(monsterID) == true then
		BehaviorFunctions.DoLookAtTargetByLerp(monsterID,self.role,true,0,180,-2)
	end
	--判断距离
	if distance >= 3 and self.tutoMonMoveState == 0 and tutoMonState ~= FightEnum.EntityState.Die and tutoMonState ~= FightEnum.EntityState.Move then
		self.tutoMonMoveState = 1

	elseif distance < 3 and self.tutoMonMoveState == 1 and tutoMonState ~= FightEnum.EntityState.Die and tutoMonState ~= FightEnum.EntityState.FightIdle then
		self.tutoMonMoveState = 0
	end	
	
	--
	if self.missionState >= 4 then
		--切换移动状态
		if BehaviorFunctions.CanCastSkill(monsterID) == true then
	
			if self.tutoMonMoveState == 1 and tutoMonState ~= FightEnum.EntityState.Die and tutoMonState ~= FightEnum.EntityState.Move then
				BehaviorFunctions.DoSetEntityState(monsterID,FightEnum.EntityState.Move)
				BehaviorFunctions.DoSetMoveType(monsterID,FightEnum.EntityMoveSubState.Run)
	
			elseif self.tutoMonMoveState == 0 and tutoMonState ~= FightEnum.EntityState.Die and tutoMonState ~= FightEnum.EntityState.FightIdle then
				BehaviorFunctions.DoSetEntityState(monsterID,FightEnum.EntityState.FightIdle)
			end	
		end	
	end	
end
	
--检测蜥蜴出生逻辑
function LevelBehavior200100103:CheckLizardState()
	
	local checkState = {}
	self.monsters.Count = self.levelBeha:WaveCount(self.monsters,self.wave)	
	
	--检测组中蜥蜴的跳出情况
	for i = 1, self.monsters.Count do
		if BehaviorFunctions.CheckEntity(self.monsters[i].instanceId) ~= nil then
			local monsterID = self.monsters[i].instanceId
			if monsterID ~= self.patrol1.instanceId and monsterID ~= self.patrol2.instanceId then	
				table.insert(checkState,i,{monsterID = monsterID , aiState = BehaviorFunctions.GetEntityValue(monsterID,"jumpOut")})
				if checkState[i].aiState == true then
					BehaviorFunctions.RemoveBuff(monsterID,200000104)
				end
				
			elseif monsterID == self.patrol1.instanceId or monsterID == self.patrol2.instanceId then
				table.insert(checkState,i,{monsterID = monsterID , aiState = BehaviorFunctions.GetEntityValue(monsterID,"runAi")})
			end
		end
	end
	
	--若其中有跳出，则返回true
	for i = 1, #checkState do
		if checkState[i].aiState == true then
			return true
		end
	end
end

function LevelBehavior200100103:Collide(attackInstanceId,hitInstanceId)
	if self.patrol1 ~= nil then
		if hitInstanceId == self.patrol1.instanceId then
			self.patrol1.beenHit = true
		end
	end
	if self.patrol2 ~= nil then
		if hitInstanceId == self.patrol2.instanceId then
			self.patrol2.beenHit = true
		end
	end
end