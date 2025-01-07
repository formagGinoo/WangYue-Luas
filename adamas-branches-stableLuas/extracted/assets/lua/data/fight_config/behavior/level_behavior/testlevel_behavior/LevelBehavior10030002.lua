--主线第7关，二层

LevelBehavior10030002 = BaseClass("LevelBehavior10030002",LevelBehaviorBase)
--fight初始化
function LevelBehavior10030002:__init(fight)
	self.fight = fight
end

--预加载
function LevelBehavior10030002.GetGenerates()
	local generates = {900000102,910024,910025,900021,900022,900023,900020}
	return generates
end
function LevelBehavior10030002.GetMagics()
	local generates = {900000008,900000009}
	return generates
end
--UI预加载
function LevelBehavior10030002.GetUIGenerates()
	local generates = {
		FightEnum.PreLoadUI.RemoteDialog,--带头像的剧情对话框UI
		FightEnum.PreLoadUI.FightTalkDialog,--纯文字的剧情对话框UI
		FightEnum.PreLoadUI.GuideMask,--教学引导UI
		FightEnum.PreLoadUI.FightTips--中间横幅和底部横幅
	}
	return generates
end

--参数初始化
function LevelBehavior10030002:Init()
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
	self.option = 0
	self.optionState = 0
	self.hexin = 0
end

--帧事件
function LevelBehavior10030002:Update()

	--每帧获得当前角色
	self.role = BehaviorFunctions.GetCtrlEntity()
	--助战角色
	self.role2 = BehaviorFunctions.GetQTEEntity(1)
	--获取时间
	self.time = BehaviorFunctions.GetFightFrame()

	self.wave1Count = self:WaveCount(1)
	self.wave2Count = self:WaveCount(2)
	self.wave3Count = self:WaveCount(3)
	self.wave4Count = self:WaveCount(4)
	self.wave5Count = self:WaveCount(5)
	self.wave6Count = self:WaveCount(6)
	--关卡主流程
	--第一波怪
	
	--轨道相机测试
	--BehaviorFunctions.ActiveSceneObj("dollycamera",true)
	--BehaviorFunctions.SetSceneCameraLock("dollycamera",self.role)
	--BehaviorFunctions.ActiveSceneObj("bridge",true)
	
	--选择
	if self.option == 0  then
		if self.optionState == 0 then
			BehaviorFunctions.ActiveUI(FightEnum.UIActiveType.Main,false)
			BehaviorFunctions.ShowTip(2001003)
			BehaviorFunctions.AddDelayCallByTime(4,BehaviorFunctions,BehaviorFunctions.ShowTip,2001004)
			BehaviorFunctions.AddDelayCallByTime(5,BehaviorFunctions,BehaviorFunctions.ActiveUI,FightEnum.UIActiveType.Main,true)
			self.option1Pos = self.LevelBehavior:SetRoadSign("o1")
			self.option2Pos = self.LevelBehavior:SetRoadSign("o2")	
			self.optionState = 1
		end	
		if self.optionState == 1 then
			if BehaviorFunctions.GetDistanceFromTarget(self.role,self.option1Pos) <= 1 then
				self.option = 100
				BehaviorFunctions.HideTip()
				BehaviorFunctions.RemoveEntity(self.option1Pos)
				BehaviorFunctions.RemoveEntity(self.option2Pos)
			elseif BehaviorFunctions.GetDistanceFromTarget(self.role,self.option2Pos) <= 1 then
				self.option = 200
				BehaviorFunctions.HideTip()
				BehaviorFunctions.RemoveEntity(self.option1Pos)
				BehaviorFunctions.RemoveEntity(self.option2Pos)
			end	
		end
	end
	--选择了左：
	if self.option == 100 then
		--交互1
		if self.missionState == 0 then
			--tips相关
			self.LevelBehavior:SetPositionGuide(2001001,"t1")
			self.roadSign = self.LevelBehavior:SetRoadSign("t1")
			local pos = BehaviorFunctions.GetTerrainPositionP("t1")
			self.LevelCamera:Position_Camera(self.role,pos,0.1)	
			self.missionState = 10	
		end		
		--第1波怪
		if self.missionState == 10 and BehaviorFunctions.GetDistanceFromTarget(self.role,self.roadSign) <= 2 then
			self:OpenRemoteDialogSpecial(200103)
			BehaviorFunctions.CancelGuide()
			BehaviorFunctions.RemoveEntity(self.roadSign)
			--延迟召怪
			BehaviorFunctions.AddDelayCallByTime(3.5,self,self.CreatMonster,{
				{id = 900020 ,posName = "mb101",lookatposName = "t1",wave = 1,bronskill = false},
				--{id = 900021 ,posName = "mb102",lookatposName = "t1",wave = 1,bronskill = false},
				{id = 900022 ,posName = "mb103",lookatposName = "t1",wave = 1,bronskill = false},
				--{id = 900020 ,posName = "mb104",lookatposName = "t1",wave = 1,bronskill = false},
			})

			self.timeStart = self.time	
			self.missionState = 20
		end
		--交互2
		if self.missionState == 20 and self.wave1Count == 0 and self.time - self.timeStart > 5*30 then
			--tips相关
			self.LevelBehavior:SetPositionGuide(2001001,"t2")
			self.roadSign = self.LevelBehavior:SetRoadSign("t2")
			local pos = BehaviorFunctions.GetTerrainPositionP("t2")
			self.LevelCamera:Position_Camera(self.role,pos,0.1)
			self.missionState = 30	
		end
		--第2波怪
		if self.missionState == 30 and BehaviorFunctions.GetDistanceFromTarget(self.role,self.roadSign) <= 2 then
			self:OpenRemoteDialogSpecial(200103)
			BehaviorFunctions.CancelGuide()
			BehaviorFunctions.RemoveEntity(self.roadSign)
			BehaviorFunctions.AddDelayCallByTime(3.5,self,self.CreatMonster,{
					{id = 900021 ,posName = "mb201",lookatposName = "t2",wave = 2,bronskill = false},
					--{id = 900022 ,posName = "mb202",lookatposName = "t2",wave = 2,bronskill = false},
					{id = 900023 ,posName = "mb203",lookatposName = "t2",wave = 2,bronskill = false},
					--{id = 900020 ,posName = "mb204",lookatposName = "t2",wave = 2,bronskill = false},
				})
			self.timeStart = self.time
			self.missionState = 40
		end
		--交互3
		if self.missionState == 40 and self.wave2Count == 0 and self.time - self.timeStart > 5*30 then
			--tips相关
			self.LevelBehavior:SetPositionGuide(2001001,"t3")
			self.roadSign = self.LevelBehavior:SetRoadSign("t3")
			local pos = BehaviorFunctions.GetTerrainPositionP("t3")
			self.LevelCamera:Position_Camera(self.role,pos,0.1)
			self.missionState = 50
		end
		--第3波怪
		if self.missionState == 50 and BehaviorFunctions.GetDistanceFromTarget(self.role,self.roadSign) <= 2 then
			self:OpenRemoteDialogSpecial(200103)
			BehaviorFunctions.CancelGuide()
			BehaviorFunctions.RemoveEntity(self.roadSign)
			BehaviorFunctions.AddDelayCallByTime(3.5,self,self.CreatMonster,{
					{id = 900020 ,posName = "mb301",lookatposName = "t3",wave = 3,bronskill = false},
					{id = 900020 ,posName = "mb302",lookatposName = "t3",wave = 3,bronskill = false},
					{id = 900020 ,posName = "mb303",lookatposName = "t3",wave = 3,bronskill = false},
					--{id = 900020 ,posName = "mb304",lookatposName = "t3",wave = 3,bronskill = false},
				})
			self.timeStart = self.time
			self.missionState = 60
		end
		--交互4
		if self.missionState == 60 and self.wave3Count == 0 and self.time - self.timeStart > 5*30 then
			--tips相关
			self.LevelBehavior:SetPositionGuide(2001001,"t4")
			self.roadSign = self.LevelBehavior:SetRoadSign("t4")
			local pos = BehaviorFunctions.GetTerrainPositionP("t4")
			self.LevelCamera:Position_Camera(self.role,pos,0.1)
			self.missionState = 70
		end	
		if self.missionState == 70 and BehaviorFunctions.GetDistanceFromTarget(self.role,self.roadSign) <= 2 then
			BehaviorFunctions.ActiveUI(FightEnum.UIActiveType.Main,false)
			BehaviorFunctions.CancelGuide()
			BehaviorFunctions.RemoveEntity(self.roadSign)
			BehaviorFunctions.SetWallEnable("option1AW",true)
			BehaviorFunctions.SetWallEnable("Dollyairwall",true)
			self:OpenRemoteDialog(200101)
			BehaviorFunctions.AddDelayCallByTime(5,BehaviorFunctions,BehaviorFunctions.ShowTip,2001001)
			self.hexin = 1
			self.timeStart = self.time
			self.missionState = 80
		end
		if self.missionState == 80 and self.time - self.timeStart >= 8*30  then
			BehaviorFunctions.ActiveSceneObj("dollycamera",true)
			BehaviorFunctions.SetSceneCameraLock("dollycamera",self.role)
			BehaviorFunctions.ActiveUI(FightEnum.UIActiveType.Main,true)
			self.missionState = 90		
		end
		if self.missionState == 90 then
			self.LevelBehavior:SetPositionGuide(2001002,"e1")
			self.roadSign = self.LevelBehavior:SetRoadSign("e1")
			self:CreatMonster({
					{id = 900021 ,posName = "mb401",lookatposName = "s1",wave = 4,bronskill = false},
					{id = 900022 ,posName = "mb402",lookatposName = "s1",wave = 4,bronskill = false},
					{id = 900023 ,posName = "mb403",lookatposName = "s1",wave = 4,bronskill = false},
					{id = 900021 ,posName = "mb404",lookatposName = "s1",wave = 4,bronskill = false},
				})	
			self.timeStart = self.time	
			self.missionState = 100
		end
		if self.missionState == 100 and self.wave4Count == 0 and self.time - self.timeStart >0 then
			self:CreatMonster({
					{id = 900020 ,posName = "mb501",lookatposName = "s1",wave = 5,bronskill = false},
					{id = 900021 ,posName = "mb502",lookatposName = "s1",wave = 5,bronskill = false},
					{id = 900021 ,posName = "mb503",lookatposName = "s1",wave = 5,bronskill = false},
					{id = 900020 ,posName = "mb504",lookatposName = "s1",wave = 5,bronskill = false},
				})
			self.timeStart = self.time
			self.missionState = 110	
		end
		if self.missionState == 110 and self.wave5Count == 0 and self.time - self.timeStart >0 then
			self:CreatMonster({
					{id = 900021 ,posName = "mb601",lookatposName = "s1",wave = 6,bronskill = false},
					{id = 900021 ,posName = "mb602",lookatposName = "s1",wave = 6,bronskill = false},
					{id = 900022 ,posName = "mb603",lookatposName = "s1",wave = 6,bronskill = false},
					{id = 900022 ,posName = "mb604",lookatposName = "s1",wave = 6,bronskill = false},
				})
			self.timeStart = self.time
			self.missionState = 120
		end
		if self.missionState == 120 and self.wave6Count == 0 and self.time - self.timeStart >0 then
			BehaviorFunctions.ActiveSceneObj("dollycamera",false)
			self.missionState = 200
		end
	end
	--选择了右：
	if self.option == 200 then
		--交互1
		if self.missionState == 0 then
			--tips相关
			self.LevelBehavior:SetPositionGuide(2001001,"t8")
			self.roadSign = self.LevelBehavior:SetRoadSign("t8")
			local pos = BehaviorFunctions.GetTerrainPositionP("t8")
			self.LevelCamera:Position_Camera(self.role,pos,0.1)
			self.missionState = 10
		end
		--第1波怪
		if self.missionState == 10 and BehaviorFunctions.GetDistanceFromTarget(self.role,self.roadSign) <= 2 then
			self:OpenRemoteDialogSpecial(200103)
			BehaviorFunctions.CancelGuide()
			BehaviorFunctions.RemoveEntity(self.roadSign)
			BehaviorFunctions.AddDelayCallByTime(3.5,self,self.CreatMonster,{
					--{id = 900020 ,posName = "mb601",lookatposName = "s1",wave = 1,bronskill = false},
					{id = 900020 ,posName = "mb602",lookatposName = "s1",wave = 1,bronskill = false},
					{id = 900020 ,posName = "mb603",lookatposName = "s1",wave = 1,bronskill = false},
					--{id = 900020 ,posName = "mb604",lookatposName = "s1",wave = 1,bronskill = false},
				})
			self.timeStart = self.time
			self.missionState = 20
		end
		--交互2
		if self.missionState == 20 and self.wave1Count == 0 and self.time - self.timeStart > 5*30 then
			--tips相关
			self.LevelBehavior:SetPositionGuide(2001001,"t7")
			self.roadSign = self.LevelBehavior:SetRoadSign("t7")
			local pos = BehaviorFunctions.GetTerrainPositionP("t7")
			self.LevelCamera:Position_Camera(self.role,pos,0.1)
			self.missionState = 30
		end
		--第2波怪
		if self.missionState == 30 and BehaviorFunctions.GetDistanceFromTarget(self.role,self.roadSign) <= 2 then
			self:OpenRemoteDialogSpecial(200103)
			BehaviorFunctions.CancelGuide()
			BehaviorFunctions.RemoveEntity(self.roadSign)
			BehaviorFunctions.AddDelayCallByTime(3.5,self,self.CreatMonster,{
					--{id = 900021 ,posName = "mb501",lookatposName = "s1",wave = 2,bronskill = false},
					{id = 900022 ,posName = "mb502",lookatposName = "s1",wave = 2,bronskill = false},
					{id = 900023 ,posName = "mb503",lookatposName = "s1",wave = 2,bronskill = false},
					--{id = 900020 ,posName = "mb504",lookatposName = "s1",wave = 2,bronskill = false},
				})
			self.timeStart = self.time
			self.missionState = 40
		end
		--交互3
		if self.missionState == 40 and self.wave2Count == 0 and self.time - self.timeStart > 5*30 then
			--tips相关
			self.LevelBehavior:SetPositionGuide(2001001,"t6")
			self.roadSign = self.LevelBehavior:SetRoadSign("t6")
			local pos = BehaviorFunctions.GetTerrainPositionP("t6")
			self.LevelCamera:Position_Camera(self.role,pos,0.1)
			self.missionState = 50
		end
		--第3波怪
		if self.missionState == 50 and BehaviorFunctions.GetDistanceFromTarget(self.role,self.roadSign) <= 2 then
			self:OpenRemoteDialogSpecial(200103)
			BehaviorFunctions.CancelGuide()
			BehaviorFunctions.RemoveEntity(self.roadSign)
			BehaviorFunctions.AddDelayCallByTime(3.5,self,self.CreatMonster,{
					{id = 900021 ,posName = "mb401",lookatposName = "s1",wave = 3,bronskill = false},
					{id = 900022 ,posName = "mb402",lookatposName = "s1",wave = 3,bronskill = false},
					{id = 900022 ,posName = "mb403",lookatposName = "s1",wave = 3,bronskill = false},
					--{id = 900020 ,posName = "mb404",lookatposName = "s1",wave = 3,bronskill = false},
				})
			self.timeStart = self.time
			self.missionState = 60
		end
		--交互4
		if self.missionState == 60 and self.wave3Count == 0 and self.time - self.timeStart > 5*30 then
			--tips相关
			self.LevelBehavior:SetPositionGuide(2001001,"t5")
			self.roadSign = self.LevelBehavior:SetRoadSign("t5")
			local pos = BehaviorFunctions.GetTerrainPositionP("t5")
			self.LevelCamera:Position_Camera(self.role,pos,0.1)
			self.missionState = 70
		end
		if self.missionState == 70 and BehaviorFunctions.GetDistanceFromTarget(self.role,self.roadSign) <= 2 then
			BehaviorFunctions.ActiveUI(FightEnum.UIActiveType.Main,false)
			BehaviorFunctions.CancelGuide()
			BehaviorFunctions.RemoveEntity(self.roadSign)
			BehaviorFunctions.SetWallEnable("option2AW",true)
			BehaviorFunctions.SetWallEnable("Dollyairwall",true)
			self:OpenRemoteDialog(200102)
			BehaviorFunctions.AddDelayCallByTime(5,BehaviorFunctions,BehaviorFunctions.ShowTip,2001002)
			self.hexin = 2
			self.timeStart = self.time
			self.missionState = 80
		end
		if self.missionState == 80 and self.time - self.timeStart >= 8*30  then
			BehaviorFunctions.ActiveSceneObj("dollycamera",true)
			BehaviorFunctions.SetSceneCameraLock("dollycamera",self.role)
			BehaviorFunctions.ActiveUI(FightEnum.UIActiveType.Main,true)
			self.missionState = 90
		end
		if self.missionState == 90 then
			self.LevelBehavior:SetPositionGuide(2001002,"e1")
			self.roadSign = self.LevelBehavior:SetRoadSign("e1")
			self:CreatMonster({
					{id = 900020 ,posName = "mb301",lookatposName = "s1",wave = 4,bronskill = false},
					{id = 900020 ,posName = "mb302",lookatposName = "s1",wave = 4,bronskill = false},
					{id = 900020 ,posName = "mb303",lookatposName = "s1",wave = 4,bronskill = false},
					{id = 900020 ,posName = "mb304",lookatposName = "s1",wave = 4,bronskill = false},
				})
			self.timeStart = self.time
			self.missionState = 100
		end
		if self.missionState == 100 and self.wave4Count == 0 and self.time - self.timeStart >0 then
			self:CreatMonster({
					{id = 900020 ,posName = "mb201",lookatposName = "s1",wave = 5,bronskill = false},
					{id = 900021 ,posName = "mb202",lookatposName = "s1",wave = 5,bronskill = false},
					{id = 900022 ,posName = "mb203",lookatposName = "s1",wave = 5,bronskill = false},
					{id = 900023 ,posName = "mb204",lookatposName = "s1",wave = 5,bronskill = false},
				})
			self.timeStart = self.time
			self.missionState = 110
		end
		if self.missionState == 110 and self.wave5Count == 0 and self.time - self.timeStart >0 then
			self:CreatMonster({
					{id = 900020 ,posName = "mb101",lookatposName = "s1",wave = 6,bronskill = false},
					{id = 900021 ,posName = "mb102",lookatposName = "s1",wave = 6,bronskill = false},
					{id = 900022 ,posName = "mb103",lookatposName = "s1",wave = 6,bronskill = false},
					{id = 900023 ,posName = "mb104",lookatposName = "s1",wave = 6,bronskill = false},
				})
			self.timeStart = self.time
			self.missionState = 120
		end
		if self.missionState == 120 and self.wave6Count == 0 and self.time - self.timeStart >0 then
			self.hexin = 0
			BehaviorFunctions.ActiveSceneObj("dollycamera",false)
			BehaviorFunctions.ShowTip(2001005)
			BehaviorFunctions.DoMagic(self.role, self.role,200000006,1, FightEnum.MagicConfigFormType.Level)
			self.missionState = 200
		end		
	end
	
	----最终演出调试
	--if self.missionState == 888 then
		--self.LevelBehavior:SetPositionGuide(2001002,"e1")
		--self.roadSign = self.LevelBehavior:SetRoadSign("e1")
		--self.missionState = 200
	--end
	
	--2合1,进电梯
	if self.missionState >= 90 and self.missionState <= 200 and BehaviorFunctions.GetDistanceFromTarget(self.role,self.roadSign) <= 2 then
		BehaviorFunctions.ActiveSceneObj("dollycamera",false)
		self.hexin = 0
		BehaviorFunctions.DoMagic(self.role, self.role,200000006,1, FightEnum.MagicConfigFormType.Level)
		if #self.monsters ~= 0 then
			for i = 1,#self.monsters,1 do
				BehaviorFunctions.RemoveEntity(self.monsters[i].instanceId)
			end
		end
		BehaviorFunctions.CancelGuide()
		BehaviorFunctions.RemoveEntity(self.roadSign)
		BehaviorFunctions.SetWallEnable("option2AW",true)
		BehaviorFunctions.ActiveSceneObj("timeline1",true)
		BehaviorFunctions.ShowTip(2001006)
		BehaviorFunctions.ActiveUI(FightEnum.UIActiveType.Main,false)
		
		self.timeStart = self.time
		self.missionState = 210		
	end
	--看桥出现
	if self.missionState == 210 and self.time - self.timeStart > 3.1*30 then
		BehaviorFunctions.ActiveUI(FightEnum.UIActiveType.Main,true)
		BehaviorFunctions.RemoveEntity(self.roadSign)
		self.LevelBehavior:SetPositionGuide(2001003,"e2")
		self.roadSign = self.LevelBehavior:SetRoadSign("e2")	
		local e2 = BehaviorFunctions.GetTerrainPositionP("e2")
		self.LevelCamera:Position_Camera(self.role,e2,0.1)
		self.missionState = 220
	end
	--飞龙在天
	if self.missionState == 220 and BehaviorFunctions.GetDistanceFromTarget(self.role,self.roadSign) <= 2 then
		self:OpenRemoteDialogSpecial(200104)
		BehaviorFunctions.CancelGuide()
		BehaviorFunctions.RemoveEntity(self.roadSign)
		BehaviorFunctions.SetWallEnable("midAW",true)
		self.missionState = 230
	end
	--下一个电梯
	if self.missionState == 230 then
		self.LevelBehavior:SetPositionGuide(2001004,"e3")
		self.roadSign = self.LevelBehavior:SetRoadSign("e3")
		self.missionState = 240
	end
	--结束
	if self.missionState == 240  and BehaviorFunctions.GetDistanceFromTarget(self.role,self.roadSign) <= 2 then 
		BehaviorFunctions.CancelGuide()
		BehaviorFunctions.RemoveEntity(self.roadSign)
		self.missionState = 999
		self.endState = 1
	end
	
	
	--核心充能
	if  self.hexin == 1 then
		if BehaviorFunctions.GetEntityTemplateId(self.role) == 1003 then
			BehaviorFunctions.DoMagic(self.role, self.role,200000005,1, FightEnum.MagicConfigFormType.Level)
		elseif BehaviorFunctions.GetEntityTemplateId(self.role) == 1004 then
			BehaviorFunctions.DoMagic(self.role, self.role,200000006,1, FightEnum.MagicConfigFormType.Level)
		end
		BehaviorFunctions.SetSceneCameraLock("dollycamera",self.role)
	elseif self.hexin == 2 then
		if BehaviorFunctions.GetEntityTemplateId(self.role) == 1004 then
			BehaviorFunctions.DoMagic(self.role, self.role,200000005,1, FightEnum.MagicConfigFormType.Level)
		elseif BehaviorFunctions.GetEntityTemplateId(self.role) == 1003 then
			BehaviorFunctions.DoMagic(self.role, self.role,200000006,1, FightEnum.MagicConfigFormType.Level)
		end
		BehaviorFunctions.SetSceneCameraLock("dollycamera",self.role)
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
function LevelBehavior10030002:Death(instanceId)
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
function LevelBehavior10030002:CreatMonster(monsterList)
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
function LevelBehavior10030002:WaveCount(waveNum)
	local count	= 0
	for i = #self.monsters,1,-1  do
		if self.monsters[i].wave == waveNum then
			count = count + 1
		end
	end
	return count
end

--关卡初始化
function LevelBehavior10030002:LevelInit()
	self.role = BehaviorFunctions.GetCtrlEntity()
	self.role2 = BehaviorFunctions.GetQTEEntity(1)
	local Born1 = BehaviorFunctions.GetTerrainPositionP("born1")
	local S1 = BehaviorFunctions.GetTerrainPositionP("s1")
	BehaviorFunctions.SetPlayerBorn(Born1.x,Born1.y,Born1.z)	--角色位置
	BehaviorFunctions.DoLookAtPositionImmediately(self.role,S1.x,nil,S1.z)
	BehaviorFunctions.InitCameraAngle(0)
	BehaviorFunctions.ActiveSceneObj("trainerbgm",true)
	BehaviorFunctions.SetWallEnable("option1AW",false)
	BehaviorFunctions.SetWallEnable("option2AW",false)
	BehaviorFunctions.SetWallEnable("midAW",false)
	BehaviorFunctions.SetWallEnable("Dollyairwall",false)
end

function LevelBehavior10030002:__delete()

end

--打开对话框
function LevelBehavior10030002:OpenRemoteDialog(DialogID)
	BehaviorFunctions.CancelJoystick()--取消玩家摇杆
	BehaviorFunctions.OpenRemoteDialog(DialogID,false)
end
--打开对话框
function LevelBehavior10030002:OpenRemoteDialogSpecial(DialogID)
	BehaviorFunctions.CancelJoystick()--取消玩家摇杆
	BehaviorFunctions.OpenRemoteDialog(DialogID,true)
end
