CommonControlCarBehavior = BaseClass("CommonControlCarBehavior", BehaviorBase)
local _clamp = MathX.Clamp
local _max = math.max

local targetSpeed = 0.8
local hAcc = 0.02
local turnSpeed = 2.4
local turnAcc = 0.4
local clamp = MathX.Clamp
local zeroInput = { x = 0, y = 0 }
local _abs = math.abs
local CollideCheckLayer = FightEnum.LayerBit.EntityCollision

local MoveType = {
    OnGround = 1,
    OnFly = 2,
}

local brakeDotValue = 0.1 -- 低头速度 基础参数
local brakeDotNormal = -10 -- 产生低头的减速度阈值
local brakeDotSpeedLimit = 10 -- 产生低头的最小速度
local brakeDotBackValue = 0.5  -- 抬头速度 基础参数
local brakeBackNormal = -8  -- 产生抬头的减速度阈值

local shakeCameraWeak = -100
local shakeCameraStrong = -200


local crashAudioWeak = 80
local crashAudioStrong = 500


local distanceChangeMinSpeed  = 10 -- distance产生变化最小速度
local distanceChangeMaxSpeed  = 50-- distance产生变化最大速度
local distanceChangeMin = 7 -- distance最小值
local distanceChangeMax  = 7 -- distance最大值
local distanceDuration = 1 -- distance持续时间


local xDampingChangeMinSpeed  = 10 -- XDamping产生变化最小速度
local xDampingChangeMaxSpeed  = 20-- XDamping产生变化最大速度
local xDampingChangeMin = 0 -- XDamping最小值
local xDampingChangeMax  = 0 -- XDamping最大值
local yDampingChangeMinSpeed  = 10 -- YDamping产生变化最小速度
local yDampingChangeMaxSpeed  = 20-- YDamping产生变化最大速度
local yDampingChangeMin = 0 -- YDamping最小值
local yDampingChangeMax  = 0 -- YDamping最大值
local zDampingChangeMinSpeed  = 10 -- ZDamping产生变化最小速度
local zDampingChangeMaxSpeed  = 20-- ZDamping产生变化最大速度
local zDampingChangeMin = 0 -- ZDamping最小值
local zDampingChangeMax  = 0.5 -- ZDamping最大值
local dampingDuration = 1 -- damping持续时间


local fovChangeMinSpeed  = 10 -- fov产生变化最小速度
local fovChangeMaxSpeed  = 20-- fov产生变化最大速度
local fovChangeMin = 45 -- fov最小值
local fovChangeMax  = 70 -- fov最大值
local fovDuration = 1 -- fov持续时间


local radialBlurStrengthMin = 0 -- 动态模糊最小值
local radialBlurStrengthMax = 0.05 -- 动态模糊最大值
local radialBlurAlphaMin = 0    -- 动态模糊透明度最小值
local radialBlurAlphaMax = 1    -- 动态模糊透明度最大值
local radialBlurDuration = 5	--动态模糊持续时间

local getInCarSpeedLimit = 5 -- 显示上车按钮的速度限制
local getInOffCarAnimSpeedLimit = 1.5 -- 执行上下车动画的速度限制
local getInCarBlockDis = 6 -- 上车强刹距离
local getOffCarBlockDis = 10 -- 下车强刹距离

local radialBlurParams = {
    Dir = 0,
    Radius = 0.4,
    AlphaCurveId = 1007012005,
    Direction = 0,
    Count = 3,
    Center = { 0.5, 0.5 },
    ShowTemplateID = false,
    TemplateID = 0,
    PostProcessType = 2,
    Strength = 0.55,
    Alpha = 1.0,
    Duration = radialBlurDuration + 1,
    ID = 1
}



local BuildData = Config.DataBuild.Find

function CommonControlCarBehavior:Init()
end

---@param fight Fight
---@param entity Entity
function CommonControlCarBehavior:InitConfig(fight, entity, maxControlDistance, costElectricity, controlFrame)
    self.fight = fight
    self.entity = entity
    self.tempDir = Vec3.New()
    self.flyCheckBox = Vec3.New()
    self.edges = {}
    self.curSpeed = 0
    self.curTurnSpeed = 0
    self.ignoreList = {}
    self.brakeDotAddUp = 0
    self.isCar = true
    self.canSet = false
    self.GetInOffCarAnimFuc = nil
    self.bindDriveMove = false
	self.tcca = nil
    self.trafficManager = BehaviorFunctions.fight.entityManager.trafficManager
    self.cameraManager = BehaviorFunctions.fight.clientFight.cameraManager
    self.postProcessManager = BehaviorFunctions.fight.clientFight.postProcessManager
    self.carCamera = self.cameraManager:GetCamera(FightEnum.CameraState.Car)

    self.postProcessManager = self.fight.clientFight.postProcessManager
    self.maxControlDistance = maxControlDistance
    self.costElectricity = costElectricity
    self.initControlFrame = controlFrame
    self.controlFrame = controlFrame
    
	self.CrashAudioTimer = 0
	self.CrashAudioTime = 60

    EventMgr.Instance:AddListener(EventName.RemoveEntity, self:ToFunc("OnRemoveEntity"))
    EventMgr.Instance:AddListener(EventName.OnEnterStory, self:ToFunc("OnEnterStory"))
    EventMgr.Instance:AddListener(EventName.EnableRoadEdge, self:ToFunc("OnEnableRoadEdge"))
    EventMgr.Instance:AddListener(EventName.EnterSystemState, self:ToFunc("EnterSystemState"))

    self.rootTransform = self.entity.clientTransformComponent:GetTransform()
    self.checkTransform = self.entity.clientTransformComponent:GetTransform("ObstacleCheck")
    if not self.checkTransform then
        self.checkTransform = self.rootTransform
    end

    for k, v in pairs(BuildData) do
        if self.entity.entityId == v.instance_id then
            self.flyCheckBox:Set(v.size.x / 2, v.size.y/ 2, v.size.z/ 2)
            break
        end
    end

    self.forwardTransform = self.entity.clientTransformComponent:GetTransform("ForwardCheck")
    self.backTransform = self.entity.clientTransformComponent:GetTransform("BackCheck")
    local vec = self.forwardTransform.position - self.rootTransform.position
    self.wheelToGroundOffset = Vec3.Dot(self.rootTransform.rotation * Vec3.up, vec)

    self.MoveType = MoveType.OnGround

    ---------------飞车临时参数，PV使用
    self.tempOffset = Vec3.New()

    self.buttonInput = { x = 0, y = 0 }
    self.curHSpeed = { x = 0, y = 0 }
    self.curVSpeed = 0

    self.maxHeight = 100
    self.MaxHSpeed = 9 / 30
    self.hAcc = 1.2 / 30
    self.MaxVSpeed = 9 / 30
    self.vAcc = 1.2 / 30
    self.turnSpeed = 60 / 30
    self.downSpeed = 1.5 / 30
	
	self.tcca = self.entity.clientTransformComponent.gameObject:GetComponent(TCCAInvoke)
	if UtilsBase.IsNull(self.tcca) then
		self.tcca = self.entity.clientTransformComponent.gameObject:AddComponent(TCCAInvoke)
	end
	
	self.brake = false
	self.boost = false
	self.motor = false
end

function CommonControlCarBehavior:ClearDrive()
    self.fovTicker = nil
    self.distanceTicker = nil
    self.blurTicker = nil
    self.dampingTicker = nil
    self.curDistance = nil
    self.lastDistance = nil
    self.curFov = nil
    self.lastFov = nil

    self.curXDamping = nil
    self.curYDamping = nil
    self.curZDamping = nil
    self.lastXDamping = nil
    self.lastYDamping = nil
    self.lastZDamping = nil
    
	self.CrashAudioTimer = 0
    BehaviorFunctions.EndPostProcess(2)
end

function CommonControlCarBehavior:WorldInteractClick(uniqueId, instanceId)
    if instanceId == self.entity.instanceId then
        
        --进入操控状态
        local driverInstanceId = BehaviorFunctions.GetCtrlEntity()
        self:onDroneDrive(instanceId, driverInstanceId)
    end
end

--isClickInteract :是否是点击上车按钮的
function CommonControlCarBehavior:onDroneDrive(targetInstanceId, driverInstanceId, skipDuraton)
    if targetInstanceId ~= self.entity.instanceId then
        return
    end
    if self.curDriveId then
        return
    end
        
    --这里加一个保底，不能同时上俩个车
    
    local checkCanIn = BehaviorFunctions.CheckCanPlayDrive()
    if not checkCanIn then
        return
    end

    SystemStateMgr.Instance:AddState(SystemStateConfig.StateType.Car, targetInstanceId, driverInstanceId, skipDuraton)
end

function CommonControlCarBehavior:EnterSystemState(state, targetInstanceId, driverInstanceId, skipDuraton)
    if state ~= SystemStateConfig.StateType.Car then return end
    -- Log(targetInstanceId, self.entity.instanceId)
    if targetInstanceId ~= self.entity.instanceId then
        return
    end

    self:ClearDrive()
    --打开操作UI
    --监听是不是切换到驾驶状态了
    --EventMgr.Instance:AddListener(EventName.OnChangeActionmap, self:ToFunc("OpenDrivePanel"))
    InputManager.Instance:AddLayerCount("Drone")
    self:IsShowDrivePanel(true)
    
    self.curDriveId = driverInstanceId
    self.driver = BehaviorFunctions.GetEntity(self.curDriveId)
    
    -- 通知交通系统
    EventMgr.Instance:Fire(EventName.GetInCar, self.entity.instanceId,self.curDriveId)
    BgmManager.Instance:SetBgmState("BgmType","Drive")
    BgmManager.Instance:SetBgmState("GamePlayType", "Drive")

    -- 上车前加载音效
    local gameWwise = SoundManager.Instance:GetGameWwise()
	gameWwise:LoadSoundBank("Vehicle_SBK", -1, true)

    if not self.blockEffect then
        local callback = function()
            self.blockEffect = self.fight.entityManager:CreateEntity(20408001)
		    --self.blockEffect.clientTransformComponent:SetActivity(false)
	        self.RoadEdgeModify = self.blockEffect.clientTransformComponent.gameObject:GetComponentInChildren(RoadEdgeModify, true)
			self.blockEffectInit = false
        end

        self.fight.clientFight.assetsNodeManager:LoadEntity(20408001, callback)
    end

    if self.driver.skillComponent then
        self.driver.skillComponent:BreakBySelf()
        self.driver.skillComponent:ClearAnimation()
    end

    if self.driver.stateComponent then
        self.driver.stateComponent:SetState(FightEnum.EntityState.Idle)
    end
    --去掉玩家碰撞
    BehaviorFunctions.DoMagic(1, self.curDriveId, 1000055)
    
    self.fight.entityManager:SetTrafficCtrlEntity(driverInstanceId, self.entity.instanceId)
    --添加一个不产生世界碰撞的buff
    if self.driver.buffComponent then
        self.driver.buffComponent:AddState(FightEnum.EntityBuffState.ImmuneByCollision)
        self.driver.buffComponent:AddState(FightEnum.EntityBuffState.ImmuneToCollision)
        self.driver.buffComponent:AddState(FightEnum.EntityBuffState.ImmuneHit)
        self.driver.buffComponent:AddState(FightEnum.EntityBuffState.ImmuneDamage)
        self.driver.buffComponent:AddState(FightEnum.EntityBuffState.ImmuneWorldCollision)
        
    end
    
    --先走到固定的点位
    --获取固定点位
    if self.entity.clientTransformComponent and not self.leftDoor then
        self.leftDoor = self.entity.clientTransformComponent:GetTransform("GetInCarLeftCheck")
    end
    local callback = function()
		local eulerAngles = self.leftDoor.eulerAngles
        --这里只校验旋转
		BehaviorFunctions.SetEntityEuler(self.curDriveId,eulerAngles.x,eulerAngles.y,eulerAngles.z)
        --停止移动
        
        -- 车辆bip位置
        local bip = self.entity.clientTransformComponent:GetTransform("Bip")

        --人播放一个开车门的动作
        self.driver.stateComponent:SetState(FightEnum.EntityState.OpenDoor, FightEnum.OpenDoorState.OpenDoorStart, function()
            self:OnPalyAnimationCallback(targetInstanceId, driverInstanceId)
        end,bip)

        --车播放一个被开门的动作
        if self.entity.animatorComponent then
            self.entity.animatorComponent:PlayAnimation("GetInCar")
        end
    end
	
	if self.entity.moveComponent.moveType == FightEnum.MoveType.TrackPoint then
		self.entity.moveComponent.moveComponent:SetEnable(false, false)
	end
    
    --关闭所有的交互列表
    Fight.Instance.entityManager:CheckTriggerComponnet(self.curDriveId)
    
    
    local wasInitialized = self.tcca:WasInitialized()

    if wasInitialized then
        self.tcca:SetBlockInDistance(getInCarBlockDis)
    end


    self.driver.clientTransformComponent:BanKccMove(true)

    if self.driver.entityId ~= 1001 then
	    BehaviorFunctions.DoMagic(self.curDriveId,self.curDriveId,600000001)	--隐藏角色模型
        skipDuraton = true
    end

    if skipDuraton then
        -- 直接设置到位
        local getOffCarCheck = self.entity.clientTransformComponent:GetTransform("GetOffCarLeftCheck")
        local eulerAngles = getOffCarCheck.eulerAngles
		BehaviorFunctions.DoSetPosition(self.curDriveId, getOffCarCheck.position.x, getOffCarCheck.position.y,getOffCarCheck.position.z)
		BehaviorFunctions.SetEntityEuler(self.curDriveId,eulerAngles.x,eulerAngles.y,eulerAngles.z)
        --人播放一个开车门的动作
        self.driver.stateComponent:SetState(FightEnum.EntityState.OpenDoor, FightEnum.OpenDoorState.Driving)
		
		if self.tcca then
			self.tcca:ClearRunData()
            self.tcca:SetEffectEnable(true)
		end
        self:OnPalyAnimationCallback(targetInstanceId, driverInstanceId)
    else

        self.GetInOffCarAnimFuc = function()
            --local offset = self.leftDoor.position - self.entity.transformComponent.position
			
            --关闭所有的交互列表
            Fight.Instance.entityManager:CheckTriggerComponnet(self.curDriveId)
		    if self.tcca then
		        self.tcca:ClearRunData()
                self.tcca:SetEffectEnable(true)
		    end
            --寻路过去
            callback()
			BehaviorFunctions.DoSetPosition(self.curDriveId, self.leftDoor.position.x, self.leftDoor.position.y,self.leftDoor.position.z)
            --self.driver.moveComponent:PreciseMoveTo(1, self.leftDoor.position)
       end
    end
end

function CommonControlCarBehavior:OnPalyAnimationCallback(targetInstanceId, driverInstanceId)
    
    --隐藏玩家
    --self.driver.clientTransformComponent:SetGroupVisible("ModelGroup",false)
    -- 设置车辆为tcca模式
    self.entity.moveComponent.moveComponent:SetMoveType(2)
        
    if self.entity.attackComponent then
        self.entity.attackComponent:SetSleep(false)
    end

    --BehaviorFunctions.SetCameraState(FightEnum.CameraState.Car)
    SystemStateMgr.Instance:SetCameraState(SystemStateConfig.StateType.Car, FightEnum.CameraState.Car)
    self.carCamera:SetTccaCamera(self.tcca)

    if self.maxYPos == nil then
        self.maxYPos = self.entity.transformComponent.position.y + self.maxHeight
    end

	self.cameraManager:SetCameraFollow(self.entity,"CameraFollow")

    --BehaviorFunctions.SetPartEnableCollision(self.entity.instanceId, "CarCollide", false)
    self:SetBindMove(true)
    if self.entity.collistionComponent then
        self.entity.collistionComponent:SetPresentationOnlyTrigger(true)
    end
    --上车完成回调
    Fight.Instance.entityManager:CallBehaviorFun("GetInCarEnd")
    
    -- 上车点火
    BehaviorFunctions.DoEntityAudioPlay(self.entity.instanceId,"Drive_EngineStart",true)
    -- 引擎声音
    BehaviorFunctions.DoEntityAudioPlay(self.entity.instanceId,"Drive_Motor",true,"motor")

    -- todo 暂时为了开车流畅度写死加载距离
    if self.fight:GetFightMap() == 10020005 then
        SceneUnitManager.Instance:SetLoadBoundSize(500)
    end
end

function CommonControlCarBehavior:SetBindMove(ison)
    if ison then
        
		if self.driver.clientTransformComponent:GetIsLuaControlEntityMove()  then
            self.driver.clientTransformComponent:SetLuaControlEntityMove(false)
        end

        self.tcca:SetBindTransform( self.driver.clientTransformComponent.transform)
        self.bindDriveMove = true
    else
        
		if not self.driver.clientTransformComponent:GetIsLuaControlEntityMove()  then
            self.driver.clientTransformComponent:SetLuaControlEntityMove(true)
        end

        self.tcca:RemoveBindTransform( self.driver.clientTransformComponent.transform)
        self.bindDriveMove = false
    end

end
function CommonControlCarBehavior:OpenDrivePanel()
    local actionMap = InputManager.Instance.actionMapName
    if actionMap == "Drone" then
        self:IsShowDrivePanel(true)
    else
        self:IsShowDrivePanel(false)
    end
end

function CommonControlCarBehavior:IsShowDrivePanel(isShow)
    local mainUI = WindowManager.Instance:GetWindow("FightMainUIView")
    -- if not mainUI then return end
    -- local parent = mainUI.panelList
    -- UtilsUI.SetActiveByPosition(parent["DrivePanel"].gameObject, isShow)
    -- UtilsUI.SetActive(parent["FightNewSkillPanel"].gameObject, not isShow)
    -- UtilsUI.SetActiveByPosition(parent["FightInfoPanel"].gameObject, not isShow)

    if isShow then
        SystemStateMgr.Instance:SetFightVisible(SystemStateConfig.StateType.Car, "110010000")
        mainUI:OpenPanel(DrivePanel)
    else
        mainUI:ClosePanel(DrivePanel)
    end
end

function CommonControlCarBehavior:OnSetCarBroken(targetInstanceId,broken)
    if targetInstanceId ~= self.entity.instanceId then
        return
    end
    self.isBroken = broken
end

function CommonControlCarBehavior:DisableGetOffCar(targetInstanceId,disableGetOff)
    if targetInstanceId ~= self.entity.instanceId then
        return
    end
    self.disableGetOff = disableGetOff
end
function CommonControlCarBehavior:OnCarBrake(targetInstanceId,broken)
    if targetInstanceId ~= self.entity.instanceId then
        return
    end
    self.CarBrake = broken
end

function CommonControlCarBehavior:RemoveEffect()

    
	self.brake = false
	self.motor = false
    self.CarBrake = false

end


function CommonControlCarBehavior:OnStopDrive(targetInstanceId,skipDuraton)
    if targetInstanceId ~= self.entity.instanceId then
        return
    end
	
    if not self.curDriveId then
        return
    end
    if not self.bindDriveMove then --是否已经完成上车
        return
    end
    if self.disableGetOff then
        MsgBoxManager.Instance:ShowTips(TI18N("现在不能下车"))
		return
    end
    
    self:RemoveEffect()
    self:ClearEdges()
    if self.blockEffect then
        BehaviorFunctions.RemoveEntity(self.blockEffect.instanceId)
        self.blockEffect = nil
    end
	self.streetId = nil
	
    -- 通知交通系统
    EventMgr.Instance:Fire(EventName.GetOffCar, self.entity.instanceId,self.curDriveId)
    BgmManager.Instance:SetBgmState("BgmType","GamePlay")
    BgmManager.Instance:SetBgmState("GamePlayType", "Explore")

    -- 引擎声音
    BehaviorFunctions.DoEntityAudioStop(self.entity.instanceId,"Drive_Motor")
    BehaviorFunctions.DoEntityAudioStop(self.entity.instanceId,"Drive_BoostStart")
    --BehaviorFunctions.DoEntityAudioStop(self.entity.instanceId,"Drive_BoostLoop")

    
    -- 下车卸载音效
    local gameWwise = SoundManager.Instance:GetGameWwise()
	gameWwise:UnLoadSoundBank("Vehicle_SBK")

	--BehaviorFunctions.SetPartEnableCollision(self.entity.instanceId, "CarCollide", true)
	
    --EventMgr.Instance:RemoveListener(EventName.OnChangeActionmap, self:ToFunc("OpenDrivePanel"))
    InputManager.Instance:MinusLayerCount("Drone")
    self.tcca:ClearTccaCamera();
    --BehaviorFunctions.SetCameraState(FightEnum.CameraState.Operating)
    BehaviorFunctions.SetMainTarget(self.curDriveId)
    if self.entity.attackComponent then
        self.entity.attackComponent:SetSleep(true)
    end
    if self.entity.moveComponent.moveType == FightEnum.MoveType.TrackPoint then
        self.entity.moveComponent.moveComponent:SetEnable(false, true)
    end
    --隐藏驾驶面板
    self:IsShowDrivePanel(false)
    
    self.fight.entityManager:RemoveTrafficCtrlEntity(self.curDriveId)
    local downCarAnimDown = function()
        if self.driver.buffComponent then
            self.driver.buffComponent:RemoveState(FightEnum.EntityBuffState.ImmuneByCollision)
			self.driver.buffComponent:RemoveState(FightEnum.EntityBuffState.ImmuneToCollision)
            self.driver.buffComponent:RemoveState(FightEnum.EntityBuffState.ImmuneHit)
            self.driver.buffComponent:RemoveState(FightEnum.EntityBuffState.ImmuneDamage)
            self.driver.buffComponent:RemoveState(FightEnum.EntityBuffState.ImmuneWorldCollision)
        end
        local curPos = self.driver.transformComponent.position
        self.driver.transformComponent:SetPosition(curPos.x,curPos.y,curPos.z)
        self.driver.clientTransformComponent:BanKccMove(false)
        --玩家碰撞
        BehaviorFunctions.RemoveBuff(self.curDriveId, 1000055)
        --打开交互列表
        BehaviorFunctions.SetPartEnableCollision(self.driver.instanceId, "Body", true)
        --local leftDoor = self.entity.clientTransformComponent:GetTransform("GetInCarLeftCheck")
        --local leftDoorEulerAngles = leftDoor.eulerAngles
        --BehaviorFunctions.SetEntityEuler(self.curDriveId, 0,leftDoorEulerAngles.y,0)
        self.curDriveId = nil
        self.driver = nil
        --下车完成回调
        Fight.Instance.entityManager:CallBehaviorFun("GetOffCarEnd")


        --self.entity:SetWorldInteractState(true)

        -- todo 暂时为了开车流畅度写死加载距离
        if self.fight:GetFightMap() == 10020005 then
            SceneUnitManager.Instance:SetLoadBoundSize(-1)
        end
    end
	
	self.entity.collistionComponent:SetPresentationOnlyTrigger(false)
	
    --关闭所有的交互列表
    Fight.Instance.entityManager:CheckTriggerComponnet(self.curDriveId)
    BehaviorFunctions.SetPartEnableCollision(self.driver.instanceId, "Body", false)
    
    self.tcca:SetBlockInDistance(getOffCarBlockDis)

    if self.driver.entityId ~= 1001 then
	    BehaviorFunctions.RemoveBuff(self.curDriveId,600000001)	--隐藏角色模型
        skipDuraton = true
    end

    if skipDuraton then
        -- 直接设置到位

        --显示玩家
        --self.driver.clientTransformComponent:SetGroupVisible("ModelGroup",true)

        self:SetBindMove(false)
        local leftDoor = self.entity.clientTransformComponent:GetTransform("GetInCarLeftCheck")
        local leftDoorEulerAngles = leftDoor.eulerAngles
		BehaviorFunctions.DoSetPosition(self.curDriveId, leftDoor.position.x, leftDoor.position.y,leftDoor.position.z)
		BehaviorFunctions.SetEntityEuler(self.curDriveId,leftDoorEulerAngles.x,leftDoorEulerAngles.y,leftDoorEulerAngles.z)
        --人播放一个开车门的动作
        self.driver.stateComponent:SetState(FightEnum.EntityState.Idle)
        

        downCarAnimDown()
        if self.tcca then
            self.tcca:ClearRunData()
        end
    else
        
        self.GetInOffCarAnimFuc = function()
		    if self.tcca then
		        self.tcca:ClearRunData()
		    end

            
            self:SetBindMove(false)
			-- 恢复lua控制位置，但是依然不开启kccmove
			self.driver.clientTransformComponent:BanKccMove(true)
            self.entity.clientTransformComponent:Async()
             --车播放一个被开门的动作
            if self.entity.animatorComponent then
                self.entity.animatorComponent:PlayAnimation("GetOffCar")
            end
            --下车播动作

            --获取固定点位
            if not self.getOffCarCheck then
                self.getOffCarCheck = self.entity.clientTransformComponent:GetTransform("GetOffCarLeftCheck")
            end
            local myPos = self.getOffCarCheck.position or self.rootTransform.position
            local eulerAngles = self.getOffCarCheck.eulerAngles
            BehaviorFunctions.DoSetPosition(self.curDriveId, myPos.x, myPos.y, myPos.z)
            BehaviorFunctions.SetEntityEuler(self.curDriveId,eulerAngles.x,eulerAngles.y,eulerAngles.z)
            --显示玩家
            --self.driver.clientTransformComponent:SetGroupVisible("ModelGroup",true)
            
            -- 车辆bip位置
            local bip = self.entity.clientTransformComponent:GetTransform("Bip")
            self.driver.stateComponent:SetState(FightEnum.EntityState.OpenDoor, FightEnum.OpenDoorState.OpenDoorEnd, downCarAnimDown, bip)
        end
    end
    SystemStateMgr.Instance:RemoveState(SystemStateConfig.StateType.Car)
end

function CommonControlCarBehavior:Update()
    if not self.entity.moveComponent then
        return
    end
    self.CrashAudioTimer = self.CrashAudioTimer - 1

    local wasInitialized = self.tcca:WasInitialized()
    if self.entity.triggerComponent then
		local canSet = BehaviorFunctions.CheckCanPlayDrive()
		if canSet then
			canSet =  not wasInitialized or _abs(self.tcca:GetForwardVelocity()) <= getInCarSpeedLimit
		end
		self.entity.triggerComponent.activeEnter = canSet
    end
    if self.driver then
        
        if not self.GetInOffCarAnimFuc and self.bindDriveMove and wasInitialized then
            self:MoveOnGround()
            
            -- 活动/任务路程计数
            EventMgr.Instance:Fire(EventName.MonitorDistance, self.driver.transformComponent.position)
        else
            -- 等待上下车播放动画时机
            if self.GetInOffCarAnimFuc and (not wasInitialized or _abs(self.tcca:GetForwardVelocity()) <= getInOffCarAnimSpeedLimit) then
                self.GetInOffCarAnimFuc()
                self.GetInOffCarAnimFuc = nil
            end
        end
    end
end

function CommonControlCarBehavior:GetMoveDistance()
    local timeScale = self.entity.timeComponent:GetTimeScale()
    local moveInput = self:GetInput()
    local baseDistance = self.curSpeed * timeScale

    local oldSpeed = self.curSpeed
    --更新水平速度
    if moveInput.y ~= 0 then
        if _abs(targetSpeed - self.curSpeed) <= 1e-6 then
            return baseDistance
        end
        self.curSpeed = self.curSpeed + moveInput.y * hAcc
        self.curSpeed = clamp(self.curSpeed, -targetSpeed * 0.7, targetSpeed)
    else
        --阻尼
        self.curSpeed = self.curSpeed * 0.9
        if math.abs(self.curSpeed) < targetSpeed * 0.1 then
            self.curSpeed = 0
        end
    end

    local addDistance = (self.curSpeed - oldSpeed) * timeScale / 2
    return baseDistance + addDistance
end

function CommonControlCarBehavior:CheckObstacle(tempDir, moveDistance)
    ----考虑碰撞盒的大小，把它内嵌到车子内部，防止过近时检测错误
    --local checkPosition = self.checkTransform.position - self.checkTransform.forward * self.halfCheckBox.z
    --local checkDistance = self.obstacleDistance + self.halfCheckBox.z + moveDistance
    --local count, result = CustomUnityUtils.BoxCastNonAllocEntity(checkPosition, self.checkTransform.rotation, self.flyCheckBox,
    --        tempDir, checkDistance, CollideCheckLayer)
    --for i = 0, count - 1 do
    --    local collider = result[i].collider
    --    local name = tonumber(collider.gameObject.name)
    --    if name == self.curDriveId or name == self.entity.instanceId then
    --        count = count - 1
    --    end
    --end
    --return count
end

function CommonControlCarBehavior:GetInput()
    local moveInput = Fight.Instance.operationManager:GetKeyInput(FightEnum.KeyEvent.Drone_Move) or zeroInput
    local flyInput = Fight.Instance.operationManager:GetKeyInput(FightEnum.KeyEvent.Drone_Fly) or zeroInput
    if flyInput.x == 0 and flyInput.y == 0 then
        flyInput = self.buttonInput
        if flyInput.x == 0 and flyInput.y == 0 then
            flyInput = { x = FightMainUIView.bgInput.x, y = 0 }
        end
    end
    if flyInput.x ~= 0 then
        flyInput.x = flyInput.x > 0 and 1 or -1
    end
    if flyInput.y ~= 0 then
        flyInput.y = flyInput.y > 0 and 1 or -1
    end

    return moveInput, flyInput
end

function CommonControlCarBehavior:CostElectricity(costCount)
    return BehaviorFunctions.CostPlayerElectricity(costCount)
end

function CommonControlCarBehavior:ClickControlDroneUp(instanceId, down)
    if instanceId ~= self.entity.instanceId then
        return
    end
end

function CommonControlCarBehavior:ClickControlDroneDown(instanceId, down)
    if instanceId ~= self.entity.instanceId then
        return
    end
end

function CommonControlCarBehavior:ClickControlDroneLeft(instanceId, down)
    if instanceId ~= self.entity.instanceId then
        return
    end
end

function CommonControlCarBehavior:ClickControlDroneRight(instanceId, down)
    if instanceId ~= self.entity.instanceId then
        return
    end
end

function CommonControlCarBehavior:EnterTrigger(instanceId, entityId, playerId)
    if instanceId ~= self.entity.instanceId then
        return
    end
    if playerId == BehaviorFunctions.GetCtrlEntity() then
        self.onPlayerFollow = true
    end
end

function CommonControlCarBehavior:ExitTrigger(instanceId, entityId, playerId)
    if instanceId ~= self.entity.instanceId then
        return
    end
    if playerId == BehaviorFunctions.GetCtrlEntity() then
        self.onPlayerFollow = false
    end
end

function CommonControlCarBehavior:Death()
end

function CommonControlCarBehavior:OnCache()
    EventMgr.Instance:RemoveListener(EventName.RemoveEntity, self:ToFunc("OnRemoveEntity"))
    EventMgr.Instance:RemoveListener(EventName.OnEnterStory, self:ToFunc("OnEnterStory"))
    EventMgr.Instance:RemoveListener(EventName.EnableRoadEdge, self:ToFunc("OnEnableRoadEdge"))
    EventMgr.Instance:RemoveListener(EventName.EnterSystemState, self:ToFunc("EnterSystemState"))
    --EventMgr.Instance:RemoveListener(EventName.OnChangeActionmap, self:ToFunc("OpenDrivePanel"))
end

function CommonControlCarBehavior:OnRemoveEntity(instanceId)
    if self.curDriveId and instanceId == self.entity.instanceId then
        --self:OnStopDrive(instanceId)
    end
end

function CommonControlCarBehavior:OnEnterStory()

end

function CommonControlCarBehavior:OnEnableRoadEdge()
    if self.tcca then
        self.tcca:SetStreetBlock({})
    end
    if self.blockEffect then
        self.blockEffect.clientTransformComponent:SetActivity(false)
    end
end

function CommonControlCarBehavior:AddToIgnoreList(id)
    table.insert(self.ignoreList, id)
end

function CommonControlCarBehavior:CheckGround(distance, offsetY)
    local checkDistance = distance + self.wheelToGroundOffset
    local check, yHeight, xDir, yDir, zDir = CS.PhysicsTerrain.CarCheck(self.forwardTransform.position, self.backTransform.position,
            self.entity.transformComponent.rotation, checkDistance, offsetY)

    return yHeight, xDir, yDir, zDir
end

function CommonControlCarBehavior:UpdateFov(curForwardVelocity)
    
    local cameraSpeedFov = _clamp(curForwardVelocity,fovChangeMinSpeed,fovChangeMaxSpeed)
    local t = (cameraSpeedFov - fovChangeMinSpeed)/ (fovChangeMaxSpeed - fovChangeMinSpeed)
    local targetFov = fovChangeMin *(1-t) + fovChangeMax * t

    self.curFov = self.curFov or targetFov
    
    if not self.fovTicker or self.fovTicker >= fovDuration then
        self.fovTicker = 0
        self.lastFov = self.curFov
        self.curFov = targetFov
    end
    self.fovTicker = self.fovTicker + 1
    local offsetFov = self.curFov - self.lastFov
end

function CommonControlCarBehavior:UpdateDistance(curForwardVelocity)
    
    local cameraSpeedDistance = _clamp(curForwardVelocity,distanceChangeMinSpeed,distanceChangeMaxSpeed)
    local tDis = (cameraSpeedDistance - distanceChangeMinSpeed)/ (distanceChangeMaxSpeed - distanceChangeMinSpeed)
    local targetDistance = distanceChangeMin *(1-tDis) + distanceChangeMax * tDis

    self.curDistance = self.curDistance or targetDistance
    if not self.distanceTicker or self.distanceTicker >= distanceDuration then
        self.distanceTicker = 0
        self.lastDistance = self.curDistance
        self.curDistance = targetDistance
    end
    self.distanceTicker = self.distanceTicker + 1
    local offsetDistance = self.curDistance - self.lastDistance
end

function CommonControlCarBehavior:UpdateDamping(curForwardVelocity)
    
    local cameraSpeedXDamping = _clamp(curForwardVelocity,xDampingChangeMinSpeed,xDampingChangeMaxSpeed)
    local tXDamping = (cameraSpeedXDamping - xDampingChangeMinSpeed)/ (xDampingChangeMaxSpeed - xDampingChangeMinSpeed)
    local targetXDamping = xDampingChangeMin *(1-tXDamping) + xDampingChangeMax * tXDamping
    
    local cameraSpeedYDamping = _clamp(curForwardVelocity,yDampingChangeMinSpeed,yDampingChangeMaxSpeed)
    local tYDamping = (cameraSpeedYDamping - yDampingChangeMinSpeed)/ (yDampingChangeMaxSpeed - yDampingChangeMinSpeed)
    local targetYDamping = yDampingChangeMin *(1-tYDamping) + yDampingChangeMax * tYDamping
    
    local cameraSpeedZDamping = _clamp(curForwardVelocity,zDampingChangeMinSpeed,zDampingChangeMaxSpeed)
    local tZDamping = (cameraSpeedZDamping - zDampingChangeMinSpeed)/ (zDampingChangeMaxSpeed - zDampingChangeMinSpeed)
    local targetZDamping = zDampingChangeMin *(1-tZDamping) + zDampingChangeMax * tZDamping

    self.curXDamping = self.curXDamping or targetXDamping
    self.curYDamping = self.curYDamping or targetYDamping
    self.curZDamping = self.curZDamping or targetZDamping
    if not self.dampingTicker or self.dampingTicker >= dampingDuration then
        self.dampingTicker = 0
        self.lastXDamping = self.curXDamping
        self.curXDamping = targetXDamping
        self.lastYDamping = self.curYDamping
        self.curYDamping = targetYDamping
        self.lastZDamping = self.curZDamping
        self.curZDamping = targetZDamping
    end
    self.dampingTicker = self.dampingTicker + 1
    local offsetXDamping = self.curXDamping - self.lastXDamping
    local offsetYDamping = self.curYDamping - self.lastYDamping
    local offsetZDamping = self.curZDamping - self.lastZDamping
    local dampingLerp = self.dampingTicker/ dampingDuration

    local doSetXDamping = self.lastXDamping + offsetXDamping * dampingLerp
    local doSetYDamping = self.lastYDamping + offsetYDamping * dampingLerp
    local doSetZDamping = self.lastZDamping + offsetZDamping * dampingLerp
end

function CommonControlCarBehavior:UpdateBlur(curForwardVelocity)
    -- 初始化动态模糊
    if not self.postProcessManager.postProcess[2] then
		radialBlurParams.Strength = 0
		radialBlurParams.Alpha = 0
		self.postProcessManager:AddPostProcess(2, radialBlurParams, self.entity)
    end
    -- 更新动态模糊
    
    local cameraSpeedFov = _clamp(curForwardVelocity,fovChangeMinSpeed,fovChangeMaxSpeed)
    local t = (cameraSpeedFov - fovChangeMinSpeed)/ (fovChangeMaxSpeed - fovChangeMinSpeed)
    local targetFov = fovChangeMin *(1-t) + fovChangeMax * t

    if not self.blurTicker or self.blurTicker >= radialBlurDuration then
        self.blurTicker = 0
        radialBlurParams.Strength = radialBlurStrengthMin *(1-t) + radialBlurStrengthMax * t
        radialBlurParams.Alpha = radialBlurAlphaMin *(1-t) + radialBlurAlphaMax * t
		radialBlurParams.instanceId = self.entity.instanceId
       self.postProcessManager.postProcess[2]:UpdateRadialBlurParams(radialBlurParams)
    end
    self.blurTicker = self.blurTicker + 1

end

function CommonControlCarBehavior:MoveOnGround()
    --self.entity.clientTransformComponent:Async()
    --local yHeight, xDir, yDir, zDir
    --if self.entity.moveComponent.moveType == FightEnum.MoveType.TrackPoint then
        --yHeight, xDir, yDir, zDir = self.entity.moveComponent.moveComponent:CheckGround(1.5, 0)
    --else
        --yHeight, xDir, yDir, zDir = self:CheckGround(1.5, 0)
    --end

    --local lookAt = Quat.LookRotationA(xDir, yDir, zDir)
	
    --if moveInput.x ~= 0 then
        --self.curTurnSpeed = self.curTurnSpeed + turnAcc * moveInput.x
    --elseif self.curTurnSpeed ~= 0 then
        --self.curTurnSpeed = self.curTurnSpeed * 0.8
        --if math.abs(self.curTurnSpeed) < turnSpeed * 0.1 then
            --self.curTurnSpeed = 0
        --end
    --end
    --self.curTurnSpeed = clamp(self.curTurnSpeed, 

    
    if self.trafficManager.enableRoadEdge then
         -- 射线地板查询道路或路口
        local myPos = self.entity.transformComponent.position
        self.edges = self.edges or {}
        self.cloestEdges = self.cloestEdges or {}
        local streetId ,crossId = self.trafficManager:GetStreetAtPos(myPos)
        if streetId or crossId then
            crossId = crossId and crossId * 10000
            streetId = crossId or streetId
            if self.streetId ~= streetId then
                self.streetId = streetId
                local newSteet = crossId and streetId/10000 or streetId
                
                
                for i, v in ipairs(self.edges) do
                    self.trafficManager:PushVec3List(v)
                end
                TableUtils.ClearTable(self.edges)
                if crossId then
                    self.trafficManager:GetEdgesInCross(newSteet,nil,self.edges)
                    
                    
                else
                    
                    self.trafficManager:GetStreetEdge(newSteet,self.edges)
                end
                -- 向插件传递边缘信息
                self.tcca:SetStreetBlock(self.edges)
            end
        end
        
        
        -- 边缘特效
        if self.blockEffect and self.RoadEdgeModify:HasEnable() then
            if self.streetId and #self.edges > 0 then
                
                
                self.trafficManager:PushVec3List(self.cloestEdges)
                TableUtils.ClearTable(self.cloestEdges)
                self.trafficManager:GetClosestEdge(myPos,self.edges,5,15,1.5,self.cloestEdges)
                
                if #self.cloestEdges > 0 then
                    self.blockEffect.clientTransformComponent:SetActivity(true)
                    self.RoadEdgeModify:SetRoadPoint(self.cloestEdges , 100)
        
                else
                    self.blockEffect.clientTransformComponent:SetActivity(false)
                end
            end
        else
            if self.blockEffect then
                self.blockEffect.clientTransformComponent:SetActivity(false)
            end
        end
    end
   

    
    local curForwardVelocity = self.tcca:GetForwardVelocity()
    local accValue = self.tcca:GetForwardAC()

    if self.lastForwardVelocity then
        if accValue < shakeCameraWeak then
            self:BrakeEffect()
        end
    end

    self.lastForwardVelocity = curForwardVelocity



    -- fov
    --self:UpdateFov(curForwardVelocity)

    -- distance
    --self:UpdateDistance(curForwardVelocity)

    
    -- damping
    --self:UpdateDamping(curForwardVelocity)

    -- 动态模糊
    --self:UpdateBlur(curForwardVelocity)


    
	local moveInput = self:GetInput()

    local inputX = moveInput.x
    local inputY = moveInput.y
    local inDrone = InputManager.Instance.actionMapName == "Drone"
    
    if self.CarBrake or not inDrone then
		inputY = -1
		self.tcca:SetSteeringDelta(0)
        if curForwardVelocity< 0.1 then
            self:RemoveEffect()
			inputY = 0
        end
		self.tcca:SetMotorDelta(inputY)
		return 
    end
    
	
	if self.isBroken and( math.sqrt((moveInput.x)^2 + (moveInput.y)^2) > 0.05 )then
		MsgBoxManager.Instance:ShowTips(TI18N("车辆故障，无法操控"))
        return 
    end

    -- 撞击音效
    if _abs(accValue) > crashAudioStrong then
        self:PlayCrashEffect("Drive_HeavyCrash")
    elseif _abs(accValue) > crashAudioWeak then
        self:PlayCrashEffect("Drive_SlightCrash")
    end


    self.tcca:SetSteeringDelta(inputX)
	self.tcca:SetMotorDelta(inputY)
    
    -- 引擎声音
    local rpmValue = self.tcca:GetForwardAngularVelocity()
	GameWwiseContext.SetRTPCValue("RTPC_RPM", _abs(rpmValue))
end

function CommonControlCarBehavior:ClearEdges()
    for i, v in ipairs(self.edges) do
        self.trafficManager:PushVec3List(v)
    end
    
    TableUtils.ClearTable(self.edges)
    self.trafficManager:PushVec3List(self.cloestEdges)
	TableUtils.ClearTable(self.cloestEdges)
end

function CommonControlCarBehavior:PlayCrashEffect(event)
    
    if self.CrashAudioTimer <= 0 then
        self.CrashAudioTimer = self.CrashAudioTime
        BehaviorFunctions.DoEntityAudioPlay(self.entity.instanceId,event,true)
    end
end


function CommonControlCarBehavior:BrakeEffect()
   -- BehaviorFunctions.SetCameraDistance2(FightEnum.CameraState.Car,9,0.1,self.CarOriginDis,10)
   
	--BehaviorFunctions.AddBuff(1,self.entity.instanceId,1000011)
	BehaviorFunctions.AddBuff(1,self.entity.instanceId,1000022)
	--BehaviorFunctions.AddBuff(1,self.entity.instanceId,1000012)
end

local propellerId = 20305022

function CommonControlCarBehavior:KeyInput(key, status)
	if not self.curDriveId then
		return 
	end
	if (key == FightEnum.KeyEvent.Drone_Brake or key == FightEnum.KeyEvent.Drone_Boost) and self.isBroken then
        
		MsgBoxManager.Instance:ShowTips(TI18N("车辆故障，无法操控"))
        return 
    end
	if self.CarBrake then
		return
	end

    if not self.tcca or not self.tcca:WasInitialized() then
        return
    end

    local inDrone = InputManager.Instance.actionMapName == "Drone"
    if  not inDrone then
        return
    end
    
	if key == FightEnum.KeyEvent.Drone_Brake and self.tcca then
		self.brake = status == FightEnum.KeyInputStatus.Down
        --BehaviorFunctions.CarBrake(self.entity.instanceId,true)
	end
    self.tcca:ApplyHandBrake(self.brake)

    local moveInput = self:GetInput()
	if key == FightEnum.KeyEvent.Drone_Boost and self.tcca then
  		self.tcca:SetBoostDelta(status == FightEnum.KeyInputStatus.Down) 
    
	end
end