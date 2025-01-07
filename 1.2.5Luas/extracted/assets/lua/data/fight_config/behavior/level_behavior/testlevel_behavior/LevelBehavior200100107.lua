LevelBehavior200100107 = BaseClass("LevelBehavior200100107",LevelBehaviorBase)
--fight初始化
function LevelBehavior200100107:__init(fight)
	self.fight = fight
end

--预加载
function LevelBehavior200100107.GetGenerates()
	local generates = {910024}
	return generates
end

--参数初始化
function LevelBehavior200100107:Init()
	self.role = 0       --当前角色
	self.missionState = 0       --关卡流程
	self.actState = 0       --演出流程
	self.time = 0           --计时
	self.monsters = {
		count = 0
	}
	self.wave = 0
	self.tip1 = 0
end

--帧事件
function LevelBehavior200100107:Update()
	self.role = BehaviorFunctions.GetCtrlEntity()
	self.timefps = BehaviorFunctions.GetFightFrame()
	self.triger = BehaviorFunctions.GetInAreaById("Triger",self.role)
	self.time = self.timefps/30
	if  self.missionState == 0 then
		self.entites = {}   --初始化self.entites表
		BehaviorFunctions.SetWallEnable("AW2",false)
		BehaviorFunctions.InitCameraAngle(90)
		local pb1 = BehaviorFunctions.GetTerrainPositionP("PB1")
		BehaviorFunctions.DoSetPosition(self.role,pb1.x,pb1.y,pb1.z)
		self.timeStart = self.time
		self.missionState = 1
	end
	if self.missionState == 1 and self.time - self.timeStart >= 3 then
		local mb1 = BehaviorFunctions.GetTerrainPositionP("mb100")
		self.monsters.count = self:CreatMonster(
			1,
			910024,mb1.x,mb1.y,mb1.z
		)
		self.wave = self.wave + 1
		BehaviorFunctions.ShowTip(1101)
		self.missionState = 2
	end
	if self.missionState == 2 and self.wave == 1 and self.monsters.count == 0 then
		self.missionState = 10
		self.actState = 1
	end
	--演出
	if self.missionState == 10 then
		if self.actState < 10 then
			BehaviorFunctions.UseRenderHeight(self.role,true)
		end
		if self.actState == 1  then
			BehaviorFunctions.ActiveSceneObj("vc1",true)
			self.timeStart = self.time
			self.actState = 5
		end
		if self.actState == 5 and self.time - self.timeStart >= 3 then
			BehaviorFunctions.ActiveSceneObj("vc2",true)
			BehaviorFunctions.ShowTip(1102)
			BehaviorFunctions.SceneObjPlayAnim("dianti","up")
			self.timeStart = self.time
			self.actState =10
		end
		--电梯到顶,相机在升高一点
		if self.actState == 10 and self.time - self.timeStart >= 10 then
			BehaviorFunctions.UseRenderHeight(self.role,false)
			BehaviorFunctions.DoSetPositionOffset(self.role,0,36.82,0)
			BehaviorFunctions.ActiveSceneObj("vc3",true)
			BehaviorFunctions.ActiveUI(FightEnum.UIActiveType.Main,false)
			self.timeStart = self.time
			self.actState =15
		end

		--相机升高结束，看向火箭
		if self.actState == 15 and self.time - self.timeStart >= 1.5 then
			BehaviorFunctions.ActiveSceneObj("vc4",true)
			self.timeStart = self.time
			self.actState =20
		end
		--看向火箭停留1秒，突然拉近看黑人大吊（志鹏特殊癖好）
		if self.actState == 20 and self.time - self.timeStart >= 2 then
			BehaviorFunctions.ActiveSceneObj("vc5",true)
			self.timeStart = self.time
			self.actState =25
		end
		--相机落到地面
		if self.actState == 25 and self.time - self.timeStart >= 0.5 then
			BehaviorFunctions.ActiveSceneObj("vc6",true)
			self.timeStart = self.time
			self.actState =30
		end
		--落地结束，转向月亮
		if self.actState == 30 and self.time - self.timeStart >= 4 then
			BehaviorFunctions.ActiveSceneObj("vc7",true)
			BehaviorFunctions.ActiveSceneObj("long",true)
			self.timeStart = self.time
			self.actState =35
		end
		--落地结束，转向月亮结束，变焦
		if self.actState == 35 and self.time - self.timeStart >= 3 then
			BehaviorFunctions.ActiveSceneObj("vc8",true)
			BehaviorFunctions.SceneObjPlayAnim("long","say")
			self.timeStart = self.time
			self.actState =36
		end
		if self.actState == 36 and self.time - self.timeStart >= 3 then
			BehaviorFunctions.ShowTip(1109)
			self.timeStart = self.time
			self.actState =37
		end
		if self.actState == 37 and self.time - self.timeStart >= 1.5 then
			BehaviorFunctions.ShowTip(1110)
			self.timeStart = self.time
			self.actState =38
		end
		--龙飞火箭
		if self.actState == 38 and self.time - self.timeStart >= 3 then
			BehaviorFunctions.ActiveSceneObj("vc9",true)
			BehaviorFunctions.SceneObjPlayAnim("long","fly")
			self.timeStart = self.time
			self.actState =39
		end
		--龙落地
		if self.actState == 39 and self.time - self.timeStart >= 3 then
			BehaviorFunctions.ActiveSceneObj("vc10",true)
			BehaviorFunctions.SceneObjPlayAnim("long","fly2")
			self.timeStart = self.time
			self.actState =40
		end
		--结束
		if self.actState == 40 and self.time - self.timeStart >= 4 then
			BehaviorFunctions.ActiveSceneObj("vc1",false)
			BehaviorFunctions.ActiveSceneObj("vc2",false)
			BehaviorFunctions.ActiveSceneObj("vc3",false)
			BehaviorFunctions.ActiveSceneObj("vc4",false)
			BehaviorFunctions.ActiveSceneObj("vc5",false)
			BehaviorFunctions.ActiveSceneObj("vc6",false)
			BehaviorFunctions.ActiveSceneObj("vc7",false)
			BehaviorFunctions.ActiveSceneObj("vc8",false)
			BehaviorFunctions.ActiveSceneObj("vc9",false)
			BehaviorFunctions.ActiveSceneObj("vc10",false)
			BehaviorFunctions.SetWallEnable("W1",false)
			BehaviorFunctions.ActiveSceneObj("w1",false)
			self.timeStart = self.time
			self.actState =50
		end
		if self.actState == 50 and self.time - self.timeStart >= 5 then
			BehaviorFunctions.CameraLockAtPosition({123.53,90,60},1)
			BehaviorFunctions.ShowTip(1103)
			BehaviorFunctions.SetGuide(1007,123.53,90,60)
			self.actState =999
			self.missionState = 20
		end
	end
	--交互测试
	if self.missionState == 20  then
		BehaviorFunctions.ActiveUI(FightEnum.UIActiveType.Main,true)
		if self.triger == true then
			BehaviorFunctions.ActiveUI(FightEnum.UIActiveType.Operation,false)
			--BehaviorFunctions.ActiveUI(FightEnum.UIActiveType.Joystic,false)
			BehaviorFunctions.InteractTrigger(true,1,-500)
			--BehaviorFunctions.CancelJoystick()
			if self.tip1 == 0  then
				BehaviorFunctions.ShowTip(1104)
				self.tip1=self.tip1 + 1
			end
		elseif self.triger == false then
			BehaviorFunctions.ActiveUI(FightEnum.UIActiveType.Operation,true)
			--BehaviorFunctions.ActiveUI(FightEnum.UIActiveType.Joystic,true)
			BehaviorFunctions.InteractTrigger(false)
		end
		if BehaviorFunctions.GetKeyDown(FightEnum.KeyEvent.Common1) then
			BehaviorFunctions.ActiveUI(FightEnum.UIActiveType.Operation,true)
			--BehaviorFunctions.ActiveUI(FightEnum.UIActiveType.Joystic,true)
			BehaviorFunctions.InteractTrigger(false)
			BehaviorFunctions.SceneObjPlayAnim("long","jump")
			BehaviorFunctions.CameraLockAtPosition({123.53,90,60},1)
			BehaviorFunctions.SetWallEnable("AW2",true)
			BehaviorFunctions.CancelGuide()
			self.timeStart = self.time
			self.missionState = 30
		end
	end
	if self.missionState == 30 and self.time - self.timeStart >= 3 then
		local mb101 = BehaviorFunctions.GetTerrainPositionP("mb101")
		local mb102 = BehaviorFunctions.GetTerrainPositionP("mb102")
		local mb103 = BehaviorFunctions.GetTerrainPositionP("mb103")
		local mb104 = BehaviorFunctions.GetTerrainPositionP("mb104")
		self.monsters.count = self:CreatMonster(
			4,
			910024,mb101.x,mb101.y,mb101.z,
			910024,mb102.x,mb102.y,mb102.z,
			910024,mb103.x,mb103.y,mb103.z,
			910024,mb104.x,mb104.y,mb104.z
		)
		BehaviorFunctions.ShowTip(1105)
		self.missionState = 40
	end
	if self.missionState == 40 and self.monsters.count == 0 then
		self.timeStart =self.time
		self.missionState = 50
	end
	if self.missionState == 50 and self.time - self.timeStart >=1 then
		local canshu = 3
		BehaviorFunctions.ShowTip(1106,canshu)
		self.timeStart =self.time
		self.missionState = 51
	end
	if self.missionState == 51 and self.time - self.timeStart >=1 then
		local canshu = 2
		BehaviorFunctions.ShowTip(1106,canshu)
		self.timeStart =self.time
		self.missionState = 52
	end
	if self.missionState == 52 and self.time - self.timeStart >=1 then
		local canshu = 1
		BehaviorFunctions.ShowTip(1106,canshu)
		self.timeStart =self.time
		self.missionState = 53
	end
	if self.missionState == 53 and self.time - self.timeStart >=1 then
		BehaviorFunctions.SetFightResult(true)
		self.missionState = 999
	end

end
function LevelBehavior200100107:CreatMonster(...)
	--MonsterNum,Monster1Id,Monster1PosX,Monster1PosY,Monster1PosZ,Monster2Id,Monster2PosX,Monster2PosY,Monster2PosZ...
	local i = 0
	local v = 0
	local MonsterIdnPos = {}
	local MId = 2
	local MPosX = 3
	local MPosY = 4
	local MPosZ = 5
	for i,v in ipairs{...} do
		MonsterIdnPos[i] = v
	end
	for a = 1,MonsterIdnPos[1] do
		local MonsterId = BehaviorFunctions.CreateEntity(MonsterIdnPos[MId])      --召怪,返回怪物实体id
		self.monsters[MonsterId] = MonsterId
		BehaviorFunctions.DoSetPosition(MonsterId,MonsterIdnPos[MPosX],MonsterIdnPos[MPosY],MonsterIdnPos[MPosZ])
		MId = MId + 4
		MPosX = MPosX + 4
		MPosY = MPosY + 4
		MPosZ = MPosZ + 4
		--BehaviorFunctions.DoLookAtTargetImmediately(MonsterId,1)
	end
	return MonsterIdnPos[1]
end
function LevelBehavior200100107:Death(instanceId)
	if self.monsters[instanceId] then
		self.monsters[instanceId] = nil
		self.monsters.count = self.monsters.count - 1
	end
end
function LevelBehavior200100107:__delete()

end