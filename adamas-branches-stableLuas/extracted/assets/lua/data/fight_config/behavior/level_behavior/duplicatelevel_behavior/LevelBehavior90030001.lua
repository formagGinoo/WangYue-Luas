LevelBehavior90030001 = BaseClass("LevelBehavior90030001",LevelBehaviorBase)
--动态创建关卡1
function LevelBehavior90030001:__init(fight)
	self.fight = fight
end


function LevelBehavior90030001.GetGenerates()
	--local generates = {910040,900041,900042}
	--local generates = {900022,910040,900041,900042}
	local generates = {2080101, 2080102, 2080103, 2080104, 2080105, 2080106, 900120, 900130, 910120, 2041301}
	return generates
end


function LevelBehavior90030001:Init()
	self.missionState = 1
	self.monster1 = 0
	self.monster2 = 0
	self.monster3 = 0
	self.pos = 0
	self.pos2 = 0
	self.createId = 900040
	self.isEnter = false
	self.tixinglema = false
	self.doorOpen = true
	self.eco = 2003001130001
	self.kaichangbai = false
	self.isZuobi = false
	self.guoguan1 = false
	self.guoguan2 = false
	self.guoguan3 = false

	--究极手物品创建信息
	self.jiujishouList = {
		{entityId = 2080102, posName = "muban1", instanceId = nil},
		{entityId = 2080102, posName = "muban1_1", instanceId = nil},
		{entityId = 2080102, posName = "muban2", instanceId = nil},
		{entityId = 2080102, posName = "muban3", instanceId = nil},
		{entityId = 2080102, posName = "muban4", instanceId = nil},
	}

	--怪物列表
	self.monsterList = {
		{entityId = 900120, posName = "monster1", instanceId = nil, lev = 14, wave = 1, isDead = false},
		{entityId = 900130, posName = "monster2", instanceId = nil, lev = 14, wave = 1, isDead = false},
	}
end

function LevelBehavior90030001:Update()
	self.time = BehaviorFunctions.GetFightFrame()
	self.role = BehaviorFunctions.GetCtrlEntity()

	if self.missionState == 1 then
		BehaviorFunctions.SetTipsGuideState(false)
		local bornPos = BehaviorFunctions.GetTerrainPositionP("BornPos_true", self.levelId)
		BehaviorFunctions.InMapTransport(bornPos.x,bornPos.y,bornPos.z)
		--开局镜头
		self:SetLevelRoleCamera()
		if self.kaichangbai == false then
			BehaviorFunctions.PlayBackGroundText(9001)
			self:DisablePlayerInput(true,true)
			self.kaichangbai = true
		end
		self:CreateAll()
		self.missionState = 2
		
		--关门并看向
	elseif self.missionState == 2 and self.isEnter then
		--禁用角色输入
		self:DisablePlayerInput(true,true)
		--关门
		BehaviorFunctions.AddDelayCallByTime(1.5, BehaviorFunctions, BehaviorFunctions.SceneObjPlayAnim, "Door3", "Door_close")
		BehaviorFunctions.AddDelayCallByTime(1.5, BehaviorFunctions, BehaviorFunctions.SceneObjPlayAnim, "Door4", "Door_close")
		BehaviorFunctions.AddDelayCallByTime(1.5, BehaviorFunctions, BehaviorFunctions.DoEntityAudioPlay, self.role,"Temple_CloseDoor", false)
		self.doorOpen = false
		--看向门
		self:SetLevelCamera(3, "doorPos", "followDoor",1.5,1)
		self.missionState = 0
		BehaviorFunctions.AddDelayCallByTime(5, self, self.Assignment, "missionState", 3)

		--招怪吼叫
	elseif self.missionState == 3 and self.isEnter then
		--看向怪物出生点
		self:SetLevelCamera(3, "monsterLookAtPos", "followMonster",1.5,1.5)
		--延迟创建怪物并做处理
		BehaviorFunctions.AddDelayCallByTime(1.5, self, self.CreateMonsterAndOther)
		self.missionState = 0
		BehaviorFunctions.AddDelayCallByTime(5, self, self.Assignment, "missionState", 4)
		--恢复自由
	elseif self.missionState == 4 and self.isEnter then
		--恢复角色输入
		self:DisablePlayerInput(false,false)
		self.missionState = 0
	elseif self.missionState == 5 then
		--禁用角色输入
		self:DisablePlayerInput(true,true)
		BehaviorFunctions.AddDelayCallByTime(1.5, BehaviorFunctions, BehaviorFunctions.SceneObjPlayAnim, "Door3", "Door_open")
		BehaviorFunctions.AddDelayCallByTime(1.5, BehaviorFunctions, BehaviorFunctions.SceneObjPlayAnim, "Door4", "Door_open")
		BehaviorFunctions.AddDelayCallByTime(1.5, BehaviorFunctions, BehaviorFunctions.DoEntityAudioPlay, self.role,"Temple_OpenDoor",false)
		BehaviorFunctions.AddDelayCallByTime(2, BehaviorFunctions, BehaviorFunctions.DoEntityAudioPlay, self.role,"Temple_CompletePuzzle",false)
		self.doorOpen = true
		self:SetLevelCamera(3, "doorPos", "followDoor",1.5,1)
		--恢复角色输入
		BehaviorFunctions.AddDelayCallByTime(5.5, self, self.DisablePlayerInput, false,false)
		self.missionState = 0
	end
	
	--究极手的建造物体保底
	if self.missionState ~= 1 then
		for i, v in pairs(self.jiujishouList) do
			local pos = BehaviorFunctions.GetPositionP(v.instanceId)
			--print(i,pos.y)
			if pos.y < -10 then
				BehaviorFunctions.RemoveEntity(v.instanceId)
				v.instanceId = BehaviorFunctions.CreateEntityByPosition(v.entityId, nil, v.posName, nil, nil, nil, self.levelId)
			end
		end
	end
end

--点击交互回调（交互神像）
function LevelBehavior90030001:WorldInteractClick(uniqueId,instanceId)
	if instanceId == self.jiaohu then
		BehaviorFunctions.PlayBackGroundText(9002)
		BehaviorFunctions.ActiveSceneObj("fxyueneng1", true)
		BehaviorFunctions.ActiveSceneObj("fxyueneng2", true)
		BehaviorFunctions.DoEntityAudioPlay(self.role,"Temple_InteractCarving",false)
		--禁用角色输入
		self:DisablePlayerInput(true,true)
	end
end

--播完空洞传音回调
function LevelBehavior90030001:BackGroundEnd(GroupID)
	if GroupID == 9002 then
		BehaviorFunctions.SetDuplicateResult(true)
		--开启角色输入
		self:DisablePlayerInput(false,false)
	elseif GroupID == 9001 then
		--开启角色输入
		self:DisablePlayerInput(false,false)
	elseif GroupID == 9003 then
		--如果还没进入精英区，恢复角色输入
		if not self.isEnter then
			--BehaviorFunctions.AddDelayCallByTime(2, self, self.DisablePlayerInput, false,false)
			self:DisablePlayerInput(false,false)
		end
	elseif GroupID == 9004 then
		--开启角色输入
		self:DisablePlayerInput(false,false)
		--遣送回起点改过自新
		if self.monster3 then
			BehaviorFunctions.RemoveEntity(self.monster3)
		end
		self.missionState = 1
		self.isEnter = false
		self.isZuobi = false
		if self.doorOpen == false then
			BehaviorFunctions.SceneObjPlayAnim("Door3","Door_open")
			BehaviorFunctions.SceneObjPlayAnim("Door4","Door_open")
			self.doorOpen = true
		end
	end
end

--区域进入
function LevelBehavior90030001:EnterArea(triggerInstanceId, areaName, logicName)	
	--提醒一下
	if triggerInstanceId == self.role and areaName == "Area3" and self.tixinglema == false then
		--禁用角色输入
		self:DisablePlayerInput(true,true)
		BehaviorFunctions.PlayBackGroundText(9003)
		self.tixinglema = true
	end
	--如果来到了精英怪区	
	if triggerInstanceId == self.role and (areaName == "Area1" or areaName == "Area2") then
		self.isEnter = true
	end

	--如果人掉下去了
	if triggerInstanceId == self.role and areaName == "Area4" then
		--传回起始点
		self:CreateAll()
		local bornPos = BehaviorFunctions.GetTerrainPositionP("BornPos_true", self.levelId)
		BehaviorFunctions.InMapTransport(bornPos.x,bornPos.y,bornPos.z)
		local pos1 = BehaviorFunctions.GetTerrainPositionP("BornLookAtPos",self.levelId)
		local empty1 = BehaviorFunctions.CreateEntity(2001,nil,pos1.x,pos1.y,pos1.z,nil,nil,nil,self.levelId)
		BehaviorFunctions.DoLookAtTargetImmediately(self.role,empty1)
		BehaviorFunctions.AddDelayCallByFrame(45,BehaviorFunctions,BehaviorFunctions.RemoveEntity,empty1)
	end
	--如果被识别到在作弊
	if triggerInstanceId == self.role and areaName == "AreaFangzuobi" then
		self.isZuobi = true
	end
	--当来到了终点区
	if triggerInstanceId == self.role and areaName == "AreaShenxiang" and self.isZuobi then
		--禁用角色输入
		self:DisablePlayerInput(true,true)
		--教育作弊者
		BehaviorFunctions.PlayBackGroundText(9004)
	end
	--当中途解谜成功
	if triggerInstanceId== self.role and areaName == "AreaGuoguan1" and not self.guoguan1 then
		BehaviorFunctions.DoEntityAudioPlay(self.role,"Temple_CompletePuzzle",false)
		self.guoguan1 = true
	elseif triggerInstanceId== self.role and areaName == "AreaGuoguan2" and not self.guoguan2 then
		BehaviorFunctions.DoEntityAudioPlay(self.role,"Temple_CompletePuzzle",false)
		self.guoguan2 = true
	elseif triggerInstanceId== self.role and areaName == "AreaGuoguan3" and not self.guoguan3 then
		BehaviorFunctions.DoEntityAudioPlay(self.role,"Temple_CompletePuzzle",false)
		self.guoguan3 = true
	end	
end	

--检查死亡
function LevelBehavior90030001:Death(instanceId,isFormationRevive)
	--全队死亡传回起点
	if isFormationRevive then
		if self.monster3 then
			BehaviorFunctions.RemoveEntity(self.monster3)
		end
		self.missionState = 1
		self.isEnter = false
		if self.doorOpen == false then
			BehaviorFunctions.SceneObjPlayAnim("Door3","Door_open")
			BehaviorFunctions.SceneObjPlayAnim("Door4","Door_open")  --人死了把门打开，不然待会进不来了
			self.doorOpen = true
		end
	end
end

function LevelBehavior90030001:Die(attackInstanceId,dieInstanceId)
	if dieInstanceId == self.monster3 then
		BehaviorFunctions.AddDelayCallByTime(1, self, self.Assignment, "missionState", 5)
	end
end
	
--赋值
function LevelBehavior90030001:Assignment(variable,value)
	self[variable] = value
end

--禁用角色移动
function LevelBehavior90030001:DisablePlayerInput(isOpen,closeUI)
	--取消摇杆移动
	BehaviorFunctions.CancelJoystick()
	if isOpen then
		----禁用摇杆输入
		--BehaviorFunctions.SetJoyMoveEnable(self.role,false)
		--关闭按键输入
		for i,v in pairs(FightEnum.KeyEvent) do
			BehaviorFunctions.ForbidKey(v,true)
		end
		--关闭镜头操作
		BehaviorFunctions.SetCameraMouseInput(true)
	else
		BehaviorFunctions.SetJoyMoveEnable(self.role,true)
		for i,v in pairs(FightEnum.KeyEvent) do
			BehaviorFunctions.ForbidKey(v,false)
		end
		--开启镜头操作
		BehaviorFunctions.SetCameraMouseInput(false)
	end
	if closeUI then
		--屏蔽战斗主UI
		BehaviorFunctions.SetFightMainNodeVisible(2,"PanelParent",false)
	else
		--显示战斗主UI
		BehaviorFunctions.SetFightMainNodeVisible(2,"PanelParent",true)
	end	
end

--设置关卡相机函数
function LevelBehavior90030001:SetLevelCamera(time,lookAtPos,followPos,inTime,outTime)
	self.levelCam = BehaviorFunctions.CreateEntity(22001,nil,nil,nil,nil,nil,nil,nil,self.levelId)
	local pos1 = BehaviorFunctions.GetTerrainPositionP(lookAtPos,self.levelId)
	local empty1 = BehaviorFunctions.CreateEntity(2001,nil,pos1.x,pos1.y,pos1.z,nil,nil,nil,self.levelId)
	local pos2 = BehaviorFunctions.GetTerrainPositionP(followPos,self.levelId)
	local empty2 = BehaviorFunctions.CreateEntity(2001,nil,pos2.x,pos2.y,pos2.z,nil,nil,nil,self.levelId)
	BehaviorFunctions.CameraEntityFollowTarget(self.levelCam,empty2)
	-- --设置镜头过渡
	if inTime then
		BehaviorFunctions.SetVCCameraBlend("**ANY CAMERA**","LevelCamera", inTime)
	end
	if outTime then
		BehaviorFunctions.SetVCCameraBlend("LevelCamera","**ANY CAMERA**", outTime)
	end
	--看向目标
	BehaviorFunctions.CameraEntityLockTarget(self.levelCam,empty1)
	--BehaviorFunctions.DoLookAtTargetImmediately(empty2,empty1)
	--延时移除目标和镜头
	BehaviorFunctions.AddDelayCallByTime(time,BehaviorFunctions,BehaviorFunctions.RemoveEntity,self.levelCam)
	BehaviorFunctions.AddDelayCallByTime(time,BehaviorFunctions,BehaviorFunctions.RemoveEntity,empty1)
	BehaviorFunctions.AddDelayCallByTime(time,BehaviorFunctions,BehaviorFunctions.RemoveEntity,empty2)
end

--设置关卡相机函数(角色)
function LevelBehavior90030001:SetLevelRoleCamera()
	self.empty = BehaviorFunctions.CreateEntity(2001, nil, 140,8,-63)
	self.levelCam = BehaviorFunctions.CreateEntity(22001)
	BehaviorFunctions.CameraEntityFollowTarget(self.levelCam,self.role,"CameraTarget")
	--看向目标
	BehaviorFunctions.CameraEntityLockTarget(self.levelCam,self.empty)
	BehaviorFunctions.DoLookAtTargetImmediately(self.role,self.empty)
	--进入过渡改为0
	BehaviorFunctions.SetVCCameraBlend("**ANY CAMERA**","LevelCamera", 0)
	--延时移除目标和镜头
	BehaviorFunctions.AddDelayCallByFrame(45,BehaviorFunctions,BehaviorFunctions.RemoveEntity,self.levelCam)
	BehaviorFunctions.AddDelayCallByFrame(45,BehaviorFunctions,BehaviorFunctions.RemoveEntity,self.empty)
end

--精英区，创建怪物并做处理
function LevelBehavior90030001:CreateMonsterAndOther()
	self.monster3 = BehaviorFunctions.CreateEntityByPosition(910120, nil, "monster3", nil, nil, self.levelId, 14)
	BehaviorFunctions.SetEntityValue(self.monster3,"haveWarn",false)   --关闭警戒
	BehaviorFunctions.CastSkillByTarget(self.monster3, 91012008, self.role)   --战吼技能
	BehaviorFunctions.DoLookAtTargetImmediately(self.monster3, self.role)
end

--遍历刷新创建
function LevelBehavior90030001:CreateAll()
	--怪物创建
	for i, v in pairs(self.monsterList) do
		--如果已经有了，就销毁掉
		if v.instanceId then
			BehaviorFunctions.RemoveEntity(v.instanceId)
		end
		v.instanceId = BehaviorFunctions.CreateEntityByPosition(v.entityId, nil, v.posName, nil, nil, self.levelId, v.lev)
	end
	
	--创建究极手相关物品
	for i, v in pairs(self.jiujishouList) do
		--如果已经有了，就销毁掉
		if v.instanceId then
			BehaviorFunctions.RemoveEntity(v.instanceId)
		end
		v.instanceId = BehaviorFunctions.CreateEntityByPosition(v.entityId, nil, v.posName, nil, nil, self.levelId)
		
		--关卡末交互点创建
		if self.jiaohu then
			BehaviorFunctions.RemoveEntity(self.jiaohu)
		end
		self.jiaohu = BehaviorFunctions.CreateEntityByPosition(2041301, nil, "jiaohu2", nil, nil, self.levelId)
	end
end