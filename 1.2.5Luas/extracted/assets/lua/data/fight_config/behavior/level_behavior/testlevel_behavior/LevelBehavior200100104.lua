LevelBehavior200100104 = BaseClass("LevelBehavior200100104",LevelBehaviorBase)
--fight初始化
function LevelBehavior200100104:__init(fight)
	self.fight = fight
end

--预加载
function LevelBehavior200100104.GetGenerates()
	local generates = {900000102,900020,900021,900022,900023,910024,910025,200000102,200000103,81004001}
	return generates
end

--UI预加载
function LevelBehavior200100104.GetUIGenerates()
	local generates = {
		FightEnum.PreLoadUI.FightTips--中间横幅和底部横幅
	}
	return generates
end

--参数初始化
function LevelBehavior200100104:Init()
	self.role = 0           --当前角色
	self.missionState = 0   --关卡流程

	self.wave = 0           --波数计数
	self.waveLimit = 5      --波数上限
	self.time = 0		    --世界时间
	self.timeStart = 0      --记录时间
	self.monsters = { Count = 0 }--怪物的instance和其总数

	self.monstersGroup = {}
	self.groupTime = { Time = 0 , Mark = 0 }
	self.mark = 0

	--创建关卡通用行为树
	self.levelBeha = BehaviorFunctions.CreateBehavior("LevelBehavior",self)
	--创建相机行为树
	self.levelCam = BehaviorFunctions.CreateBehavior("LevelCamera",self)
	--创建怪物组行为树
	self.monstersGroupBeha = BehaviorFunctions.CreateBehavior("LevelMonstersGroup",self)
	--怪物出生攻击等待时间
	self.waitingTime = 0
	self.switch = 0
end

--帧事件
function LevelBehavior200100104:Update()
	--每帧获得当前角色
	self.role = BehaviorFunctions.GetCtrlEntity()
	--获取助战角色
	self.supportRole = BehaviorFunctions.GetQTEEntity(1)
	--获取时间，区域
	self.time = BehaviorFunctions.GetFightFrame()

	--初始化，角色出生点
	if  self.missionState == 0 then
		self.entites = {}   --初始化self.entites表
		
		--玩家角色出生
		self.levelBeha:PlayerBorn("Born1","s1")	

		--初始化空气墙
		BehaviorFunctions.SetWallEnable("AW1",true)
		BehaviorFunctions.SetWallEnable("AW2",true)
		BehaviorFunctions.SetWallEnable("AW3",true)
		BehaviorFunctions.SetWallEnable("AW4",true)
		BehaviorFunctions.SetWallEnable("AW5",true)
		BehaviorFunctions.SetWallEnable("AW6",true)
		BehaviorFunctions.SetWallEnable("AW8",true)

		self.missionState = 1
		self.timeStart = BehaviorFunctions.GetFightFrame()
	end
	
	--开启技能辅助轮
	self.levelBeha:SkillTips()
	
	--关卡流程
	if self.missionState == 1 and self.time - self.timeStart >= 30 then
		if self.supportRole then
			BehaviorFunctions.AddEntitySign(self.supportRole,10000017,-1)	--助战角色AI停止
			BehaviorFunctions.DoSetPositionP(self.supportRole,"s7")			--将刻刻传送至洞窟
		end
		BehaviorFunctions.ActiveSceneObj("wastelandbgm",true)			--BGM
		self.levelBeha:OpenRemoteDialog(100401)							--叙慕表示应当尽快救刻刻
		self.missionState = 2
		
	elseif self.missionState == 2 and self.levelBeha:DialogCheck() == true then
		BehaviorFunctions.ShowTip(1004001)								--tips:在附近寻找刻刻的踪迹
		self.roadSign = self.levelBeha:SetRoadSign("s6",0.2)			--放置路标
		self.levelBeha:SetPositionGuide(100401,"s6",0.75)				--指引：在附近寻找刻刻的踪迹
		self.missionState = 3
	
	elseif self.missionState == 3 and self.levelBeha:DistanceToPosition(self.role , "s6") <= 1 then
		BehaviorFunctions.SetFightMainNodeVisible(2,"main",false)		--隐藏主UI
		BehaviorFunctions.CancelJoystick()								--取消玩家摇杆
		BehaviorFunctions.OpenRemoteDialog(100402,false)				--色金蜥蜴嘶鸣
		BehaviorFunctions.RemoveEntity(self.roadSign)					--删除路标
		self.timeStart = BehaviorFunctions.GetFightFrame()
		self.missionState = 3.5
		
	elseif self.missionState == 3.5	and self.time - self.timeStart == 61 then
		BehaviorFunctions.SetFightMainNodeVisible(2,"main",false)		--隐藏主UI
		self.levelBeha:OpenRemoteDialog(100403)							--叙慕感叹敌人多
		self.missionState = 3.6
		
	elseif self.missionState == 3.6	and self.time - self.timeStart == 121 then
		BehaviorFunctions.SetFightMainNodeVisible(2,"main",true)		--恢复主UI
		BehaviorFunctions.SetEntityValue(self.monsters[1].instanceId,"runAi",true)
		BehaviorFunctions.SetEntityValue(self.monsters[2].instanceId,"runAi",true)
		BehaviorFunctions.SetEntityValue(self.monsters[3].instanceId,"runAi",true)
		BehaviorFunctions.ShowTip(1004002)								--tips:击败色金生物
		self.levelBeha:SetPositionGuide(100402,"s6",0.75)				--指引：击败埋伏于此的色金生命
		BehaviorFunctions.HideGuidePointState()
		self.timeStart = BehaviorFunctions.GetFightFrame()
		self.missionState = 4
		
	elseif self.missionState == 4 then
		if self.wave == 1 and self.monsters.Count == 0 then				
			self.missionState = 5										--检测玩家击破第一批怪物
			self.timeStart = BehaviorFunctions.GetFightFrame()
			BehaviorFunctions.CancelGuide()
		end
		
	elseif self.missionState == 5 and self.time - self.timeStart == 30 then
		self.levelBeha:OpenRemoteDialog(100404)							--叙慕与向心进行通讯
		self.missionState = 6
		
	elseif self.missionState == 6 and self.levelBeha:DialogCheck() == true then
		local target = BehaviorFunctions.GetTerrainPositionP("qimai1")
		self.levelCam:Position_Camera(self.role,target,2)				--镜头锁定地点
		BehaviorFunctions.ShowTip(1004003)								--tips:前往向心指定的气脉
		self.qimai = self.levelBeha:SetInteractionPoint("qimai1",0.9)	--设置气脉
		self.missionState = 7
		
	elseif self.missionState == 7 then
		self.levelBeha:ShowGuideByDistance(100403,self.qimai,3,0.75)	--根据距离显示引导：协助向心分析气脉流向
		if self.InterInstance == self.qimai then
			self.switch = 1
			BehaviorFunctions.ShowTip(1003002)							--tips:与气脉进行共鸣
			if BehaviorFunctions.CheckKeyDown(FightEnum.KeyEvent.Common1) then
				self.levelBeha:RemoveInteractionPoint(self.qimai)		--交互后移除气脉
				BehaviorFunctions.SetFightMainNodeVisible(2,"ButtomRight",true)--右侧UI显示
				BehaviorFunctions.ActiveUI(FightEnum.UIActiveType.Main,false)--隐藏战斗ui
				BehaviorFunctions.InteractTrigger(false)				--隐藏交互按钮
				self.levelBeha:OpenRemoteDialog(100410)					--叙慕表示已经准备好了
				BehaviorFunctions.HideTip()
				self.missionState = 8
			end
		elseif self.InterInstance == nil and self.switch == 1 then
			self.switch = 0
			BehaviorFunctions.HideTip()
		end
		
	elseif self.missionState == 8 and self.levelBeha:DialogCheck() == true then	
		BehaviorFunctions.ShowTip(1004004)								--tips:协助向心解析气脉
		self.levelBeha:SetPositionGuide(100404,"qimai1",0.75)			--指引：在向心分析完成前守住气脉
		BehaviorFunctions.HideGuidePointState()
		self.timeStart = BehaviorFunctions.GetFightFrame()
		self.missionState = 9											--放出第二波三只怪物
		
	elseif self.missionState == 9 then
		if self.monsters.Count == 0 and self.wave == 2 then
			BehaviorFunctions.ShowTip(1004006)							--tips:解析完成进度50%
			self.missionState = 10
		end
		
	elseif self.missionState == 11 then
		if self.monsters.Count == 0 and self.wave == 2 then
			BehaviorFunctions.ShowTip(1004008)							--tips:解析完成进度100%
			self.timeStart = BehaviorFunctions.GetFightFrame()
			self.missionState = 12
		end
		
	elseif self.missionState == 12 and self.time - self.timeStart == 60 then
		BehaviorFunctions.SetFightMainNodeVisible(2,"main",false)		--隐藏主UI
		BehaviorFunctions.CancelJoystick()								--取消摇杆
		BehaviorFunctions.ActiveSceneObj("Timeline_05",true)			--看气脉汇聚
		BehaviorFunctions.ActiveSceneObj("qimai1_start",true)			--气脉汇聚特效
		self.timeStart = BehaviorFunctions.GetFightFrame()
		self.missionState = 12.1

	elseif self.missionState == 12.1 and self.time - self.timeStart == 41 then
		BehaviorFunctions.ActiveSceneObj("qimai1_loop",true)			--气脉循环特效
		BehaviorFunctions.ActiveSceneObj("qimai1_start",false)			--气脉汇聚特效
		self.missionState = 13
	
	elseif self.missionState == 13 and self.time - self.timeStart == 175 then	
		BehaviorFunctions.SetFightMainNodeVisible(2,"main",true)		--恢复主UI
		BehaviorFunctions.ActiveSceneObj("Timeline_05",false)			--退出timeline
		BehaviorFunctions.ActiveSceneObj("TimelineCamera2",false)		--退出timeline
		self.levelBeha:OpenRemoteDialog(100413)							--向心找到了刻刻
		self.missionState = 14
		
	elseif self.missionState == 14 and self.levelBeha:DialogCheck() == true then
		local position = BehaviorFunctions.GetTerrainPositionP("patrol1_5")
		self.levelCam:Position_Camera(self.role,position,1)
		BehaviorFunctions.SetWallEnable("AW1",false)
		BehaviorFunctions.SetWallEnable("AW2",false)
		BehaviorFunctions.SetWallEnable("AW7",false)
		BehaviorFunctions.ShowTip(1004009)							--tips:跟随气脉的指引找到刻刻
		self.roadSign = self.levelBeha:SetRoadSign("patrol1_5",0.2)	--放置路标
		self.levelBeha:SetPositionGuide(100405,"patrol1_5",0.75)	--指引：帮助刻刻
		self.missionState = 15
		
	elseif self.missionState == 15 then
		if self.levelBeha:DistanceToPosition(self.role , "patrol1_5") <= 5 then
			BehaviorFunctions.SetFightMainNodeVisible(2,"main",false)	--隐藏主UI
			BehaviorFunctions.RemoveEntity(self.roadSign)				--移除路标
			BehaviorFunctions.CancelJoystick()							--取消摇杆
			BehaviorFunctions.ActiveSceneObj("Timeline_02",true)		--播片
			BehaviorFunctions.DoSetPosition(self.role,0,0,0)			--把玩家模型移走
			BehaviorFunctions.SetWallEnable("AW2",true)
			self.timeStart = BehaviorFunctions.GetFightFrame()
			self.missionState = 16
		end		
		
	elseif self.missionState == 16 and self.time - self.timeStart == 146 then
		BehaviorFunctions.ShowTip(1004011)							--字幕：刻刻没想到是陷阱
		
	elseif self.missionState == 16 and self.time - self.timeStart == 300 then
		BehaviorFunctions.ShowTip(1004012)							--字幕：你就是刻刻对吧
		
	elseif self.missionState == 16 and self.time - self.timeStart == 336 then
		BehaviorFunctions.ShowTip(1004013)							--字幕：所以你就是叙慕？左边就交给你了
		
	elseif self.missionState == 16 and self.time - self.timeStart == 427 then
		BehaviorFunctions.ShowTip(1004014)							--字幕：这种混战哪还能分左右？
		
	elseif self.missionState == 16 and self.time - self.timeStart == 495 then
		local position = BehaviorFunctions.GetTerrainPositionP("s5")--把玩家送回来
		BehaviorFunctions.DoSetPositionP(self.role,position)
		
	elseif self.missionState == 16 and self.time - self.timeStart == 510 then
		BehaviorFunctions.ActiveSceneObj("Timeline_02",false)		--退出timeline
		BehaviorFunctions.ActiveSceneObj("TimelineCamera",false)	--退出timeline
		BehaviorFunctions.ActiveSceneObj("qimai1_end",true)
		BehaviorFunctions.ActiveSceneObj("qimai1_loop",false)		--气脉循环特效关闭
		self.missionState = 17
		
	elseif self.missionState == 17 then	
		if self.tutoMon then
			local position = BehaviorFunctions.GetPositionP(self.tutoMon)
			BehaviorFunctions.DoLookAtTargetImmediately(self.role,self.tutoMon)
			self.levelCam:Position_Camera(self.role,position,1)
		end
		BehaviorFunctions.SetEntityValue(self.tutoMon,"runAi",true)		--恢复怪物AI
		BehaviorFunctions.SetFightMainNodeVisible(2,"main",true)		--还原主UI
		BehaviorFunctions.ShowTip(1004010)								--tips:从色金生命的包围中脱围
		self.levelBeha:SetPositionGuide(100406,"s5",0.75)				--指引：击败所有色金生命
		BehaviorFunctions.HideGuidePointState()
		self.missionState = 18
		
	elseif self.missionState == 18 then
		--if self.hitInstanceId == self.tutoMon then
			--self.timeStart = BehaviorFunctions.GetFightFrame()
			--self.missionState = 19
		--end
		BehaviorFunctions.AddEntitySign(1,10000020,-1)
		BehaviorFunctions.SetEntityValue(1,"LevelUiTarget",self.tutoMon)

		self.timeStart = BehaviorFunctions.GetFightFrame()
		self.missionState = 19
		
	elseif self.missionState == 19 and self.time - self.timeStart == 60 then
		self:StopTime()												--暂停时间
		self.timeStart = BehaviorFunctions.GetFightFrame()
		self.levelBeha:TutorialGuide(100401)						--引导韧性值
		self.missionState = 19.5
		
	elseif self.missionState == 19.5 and BehaviorFunctions.CheckKeyDown(FightEnum.KeyEvent.GuideClick) 
		or self.missionState == 19.5 and self.time - self.timeStart == 150 then
		self:Continue()												--继续	
		BehaviorFunctions.RemoveEntitySign(1,10000020)
		self.missionState = 20
		
	elseif self.missionState == 20 and self.wave == 3 and self.monsters.Count == 0 then
		local position = BehaviorFunctions.GetTerrainPositionP("mb205")
		self.levelCam:Position_Camera(self.role,position,1)
		self.missionState = 21
		
	elseif self.missionState == 21 then	
		BehaviorFunctions.ShowTip(1004015) 									--tips：周围出现了其他色金蜥蜴！
		self.timeStart = BehaviorFunctions.GetFightFrame()
		self.missionState = 22
		
	elseif self.missionState == 22 and self.time - self.timeStart == 30 then
		BehaviorFunctions.SetEntityValue(self.monsters[1].instanceId,"runAi",true)
		BehaviorFunctions.SetEntityValue(self.monsters[2].instanceId,"runAi",true)
		
	elseif self.missionState == 22 and self.wave == 4 and self.monsters.Count == 0 then
		local position = BehaviorFunctions.GetTerrainPositionP("s7")
		self.npcKeke = BehaviorFunctions.CreateEntity(81004001,nil,position.x,position.y - 0.1,position.z)
		self.levelCam:Position_Camera(self.role,position,1)
		BehaviorFunctions.ShowTip(1004016)									--tips：与刻刻进行交谈
		self.missionState = 23
		
	elseif self.missionState == 23 then
		self.levelBeha:ShowGuideByDistance(100407,self.npcKeke,3,1.8)		--根据距离显示引导：与刻刻进行对话
		BehaviorFunctions.DoLookAtTargetImmediately(self.npcKeke,self.role)
		if self.InterInstance == self.npcKeke then
			if BehaviorFunctions.CheckKeyDown(FightEnum.KeyEvent.Common1) then
				BehaviorFunctions.InteractTrigger(false)					--隐藏交互按钮
				self.levelBeha:OpenRemoteDialog(100420)						--刻刻犟嘴
				BehaviorFunctions.HideTip()
				self.missionState = 24
			end
		end		
		
	elseif self.missionState == 24 and self.levelBeha:DialogCheck() == true then
		self.missionState = 40
		
	elseif self.missionState == 40 then
		--self.levelBeha:LevelEndCount(3)									--关卡结束倒计时
		BehaviorFunctions.SetFightResult(true)								--关卡胜利
		self.missionState = 41		
	end
	
	--分组攻击命令
	if self.missionState >= 1 and self.monsters.Count ~= 0 then

		if self.wave == 1 and self.missionState == 4 and self.time - self.timeStart >= 120 then
			self.monstersGroupBeha:MonsterGroupAttack(self.monstersGroup,1,5,1)
		end

		if self.wave == 2 and self.missionState < 10 then
			self.monstersGroupBeha:MonsterGroupAttack(self.monstersGroup,2,5,1)
		end
		
		if self.wave == 2 and self.missionState == 11 then
			self.monstersGroupBeha:MonsterGroupAttack(self.monstersGroup,3,5,1)
		end

		if self.wave == 4 then
			self.monstersGroupBeha:MonsterGroupAttack(self.monstersGroup,4,5,1)
		end
	end	
	
	--召怪流程
	if self.wave == 0 and self.missionState == 3.5 then
		self.levelBeha:CreatMonster(self.monsters,{
				{id = 900021 ,posName = "mb107",lookatposName = "s6",wave = 1},
				{id = 900022 ,posName = "mb108",lookatposName = "s6",wave = 1},
				{id = 900023 ,posName = "mb109",lookatposName = "s6",wave = 1}
			})

		BehaviorFunctions.SetEntityValue(self.monsters[1].instanceId,"closeBornSkill",true)
		BehaviorFunctions.SetEntityValue(self.monsters[2].instanceId,"closeBornSkill",true)
		BehaviorFunctions.SetEntityValue(self.monsters[3].instanceId,"closeBornSkill",true)
		
		BehaviorFunctions.SetEntityValue(self.monsters[1].instanceId,"runAi",false)
		BehaviorFunctions.SetEntityValue(self.monsters[2].instanceId,"runAi",false)
		BehaviorFunctions.SetEntityValue(self.monsters[3].instanceId,"runAi",false)
		
		local mp1 = BehaviorFunctions.GetTerrainPositionP("mb108")
		self.levelCam:Position_Camera(self.role,mp1,1)--玩家看向目标出生点

		self.monstersGroupBeha:MonsterGroup(self.monstersGroup,1,self.monsters[1].instanceId,self.monsters[2].instanceId,self.monsters[3].instanceId)
		self.waitingTime = BehaviorFunctions.GetFightFrame()--怪物攻击前等待时间

		self.wave = self.wave + 1
		
	elseif self.wave == 1 and self.missionState == 9  and self.time - self.timeStart == 30 then
		self.levelBeha:CreatMonster(self.monsters,{
				{id = 900022 ,posName = "mb101",lookatposName = "qimai1",wave = 2},
				{id = 900020 ,posName = "mb102",lookatposName = "qimai1",wave = 2}
			})
		
		BehaviorFunctions.SetEntityValue(self.monsters[1].instanceId,"closeBornSkill",true)
		BehaviorFunctions.SetEntityValue(self.monsters[2].instanceId,"closeBornSkill",true)
		
		local mp1 = BehaviorFunctions.GetTerrainPositionP("mb102")
		self.levelCam:Position_Camera(self.role,mp1,1)			--玩家看向目标出生点
		
		self.monstersGroupBeha:MonsterGroup(self.monstersGroup,2,self.monsters[1].instanceId,self.monsters[2].instanceId)
		
		self.wave = self.wave + 1
		
	elseif self.wave == 2 and self.missionState == 10 then
		self.levelBeha:CreatMonster(self.monsters,{
				{id = 900020 ,posName = "mb105",lookatposName = "qimai1",wave = 2},
				{id = 900023 ,posName = "mb106",lookatposName = "qimai1",wave = 2}
			})
		
			BehaviorFunctions.SetEntityValue(self.monsters[1].instanceId,"closeBornSkill",true)
			BehaviorFunctions.SetEntityValue(self.monsters[2].instanceId,"closeBornSkill",true)
		
		local mp1 = BehaviorFunctions.GetTerrainPositionP("mb105")
		self.levelCam:Position_Camera(self.role,mp1,1)			--玩家看向目标出生点
		
		self.missionState = 11
		
		self.monstersGroupBeha:MonsterGroup(self.monstersGroup,3,self.monsters[1].instanceId,self.monsters[2].instanceId)
		
	elseif self.wave == 2 and self.missionState == 17 then
		self.levelBeha:CreatMonster(self.monsters,{
				{id = 910024 ,posName = "mb205",lookatposName = "s5",wave = 3},
			})		
		self.tutoMon = self.monsters[1].instanceId
		BehaviorFunctions.SetEntityValue(self.tutoMon,"runAi",false)
		BehaviorFunctions.SetEntityValue(self.monsters[1].instanceId,"closeBornSkill",true)
		self.wave = self.wave + 1	

	elseif self.wave == 3 and self.missionState == 21 then
			self.levelBeha:CreatMonster(self.monsters,{
					{id = 900021 ,posName = "mb204",lookatposName = "s5",wave = 4},
					{id = 900023 ,posName = "mb206",lookatposName = "s5",wave = 4}
				})
		BehaviorFunctions.SetEntityValue(self.monsters[1].instanceId,"closeBornSkill",true)
		BehaviorFunctions.SetEntityValue(self.monsters[2].instanceId,"closeBornSkill",true)
		
		BehaviorFunctions.DoLookAtTargetImmediately(self.monsters[1].instanceId,self.role)
		BehaviorFunctions.DoLookAtTargetImmediately(self.monsters[2].instanceId,self.role)
		
		BehaviorFunctions.SetEntityValue(self.monsters[1].instanceId,"runAi",false)
		BehaviorFunctions.SetEntityValue(self.monsters[2].instanceId,"runAi",false)
		
		self.wave = self.wave + 1
		self.monstersGroupBeha:MonsterGroup(self.monstersGroup,4,self.monsters[1].instanceId,self.monsters[2].instanceId)
	end
		
	--怪物数量记录
	self.monsters.Count = self.levelBeha:WaveCount(self.monsters,self.wave)
end
	
--死亡事件
function LevelBehavior200100104:Death(instanceId)
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
	
--获取目前可交互npc的id
function LevelBehavior200100104:EnterTrigger(triggerInstanceId,triggerEntityId,roleInstanceId)
	self.InterInstance = triggerInstanceId
	BehaviorFunctions.SetFightMainNodeVisible(2,"ButtomRight",false)	--右侧UI隐藏
	BehaviorFunctions.InteractTrigger(true,1,-550,360)					--显示交互按钮
end

--离开范围时，取消所有交互ui
function LevelBehavior200100104:ExitTrigger(triggerInstanceId,triggerEntityId,roleInstanceId)
	self.InterInstance = nil
	BehaviorFunctions.SetFightMainNodeVisible(2,"ButtomRight",true)		--右侧UI显示
	BehaviorFunctions.InteractTrigger(false)							--隐藏交互按钮
end

--时间暂停
function LevelBehavior200100104:StopTime()        --暂停实体时间和行为
	local npcs = BehaviorFunctions.SearchNpc()
	for i in ipairs(npcs)  do
		--BehaviorFunctions.AddBuff(self.role,npcs[i],200100101001,1)
		BehaviorFunctions.DoMagic(npcs[i], npcs[i], 200000001, 1, FightEnum.MagicConfigFormType.Level)
	end
end

--解除时间暂停
function LevelBehavior200100104:Continue()        --解除暂停
	local npcs = BehaviorFunctions.SearchNpc()
	for i in ipairs(npcs)  do
		BehaviorFunctions.RemoveBuff(npcs[i],200000001)
	end
end