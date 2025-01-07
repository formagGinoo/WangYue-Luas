---@class InputManager
InputManager = SingleClass("InputManager")

local Input = Input
local KeyCode = KeyCode
local Time = Time
local angleRange = 360 / 128
local KeyCodeEvent = {
    --[KeyCode.J] = FightEnum.KeyEvent.Attack,
    [KeyCode.H] = FightEnum.KeyEvent.Attack,
    [KeyCode.K] = FightEnum.KeyEvent.Dodge,
    [KeyCode.L] = FightEnum.KeyEvent.UltimateSkill,
    [KeyCode.R] = FightEnum.KeyEvent.Interaction,
    [KeyCode.O] = FightEnum.KeyEvent.Jump,
    [KeyCode.I] = FightEnum.KeyEvent.NormalSkill,
    [KeyCode.U] = FightEnum.KeyEvent.Partner,
    [KeyCode.Alpha1] = FightEnum.KeyEvent.Change1,
    [KeyCode.Alpha2] = FightEnum.KeyEvent.Change2,
    [KeyCode.Alpha3] = FightEnum.KeyEvent.Change3,
    [KeyCode.C] = FightEnum.KeyEvent.Lock,
    [KeyCode.Space] = FightEnum.KeyEvent.Jump,
    [KeyCode.LeftShift] = FightEnum.KeyEvent.Dodge,
    [KeyCode.X] = FightEnum.KeyEvent.LeaveClimb,
    [KeyCode.F] = FightEnum.KeyEvent.Aim,
}

local KeyEvent2BehaviorBtn = FightEnum.KeyEvent2BehaviorBtn

local KeyboardAddAttr = {
    [KeyCode.KeypadPeriod] = { FightEnum.PlayerAttr.CurStaminaValue, 999999 },
    [KeyCode.Keypad1] = { EntityAttrsConfig.AttrType.NormalSkillPoint, 5000 },
    [KeyCode.Keypad2] = { EntityAttrsConfig.AttrType.ExSkillPoint, 5000 },
    [KeyCode.Keypad3] = { EntityAttrsConfig.AttrType.CommonAttr1, 9999999 },
    [KeyCode.Keypad4] = { EntityAttrsConfig.AttrType.CoreRes, 999999 },
    [KeyCode.Keypad5] = { EntityAttrsConfig.AttrType.DefineRes1, 999999 },
    [KeyCode.Keypad6] = { EntityAttrsConfig.AttrType.DefineRes2, 999999 },
}

function InputManager:__init(fightClient)
    self.fightClient = fightClient
    self.forbidKey = {}
    self.nextFrameKeyUps = {}
    self.canCameraInput = true
    self.cameraMouseInput = false
    self.cutMoveInput = { x = 0, y = 0 }
    self.actionMapName = "Player"
    self.actionEnable = {}
    self.actionCacheByPlayer = {}
    self.deviceName = nil
    self.useCursorCount = 0
    self.otherMapInputCache = {}

    self.layerCount = 0
    self.timeIndex = 0
    self.layerQueue = {}
    self:AddLayerCountByPriority(self.actionMapName)
    self.whiteList = {"GuideMaskPanel", }
    self.canNotBack = false

    self.canInput = true
    self.canInputCount = 1

    self.hostingMode = false

    if not UtilsUI.CheckPCPlatform() or Application.platform == RuntimePlatform.WindowsEditor then
        self.disPlayMouse = true
    else
        self.disPlayMouse = false
    end

    self.ActionAssetCallback = GameObject.Find("EventSystem"):GetComponent(ActionAssetCallback)
    self.ActionAssetCallback.InputLuaAction:RemoveAllListeners()
    self.ActionAssetCallback:AddLuaListener(self:ToFunc("OnInputUpdate"))
    self.ActionAssetCallback:SwitchActionMapFromLua(self.actionMapName)
    EventMgr.Instance:AddListener(EventName.FightPause, self:ToFunc("OnFightPause"))
    EventMgr.Instance:AddListener(EventName.ShowCursor, self:ToFunc("ShowCursor"))
    EventMgr.Instance:AddListener(EventName.StoryDialogStart, self:ToFunc("StoryDialogStart"))
    EventMgr.Instance:AddListener(EventName.StoryDialogEnd, self:ToFunc("StoryDialogEnd"))
    EventMgr.Instance:AddListener(EventName.ActionInput, self:ToFunc("ActionInputBack"))
end

function InputManager:UpdateScreenMove(x, y)
    if InputImageChangerManager.Instance:GetNowDevice() ~= InputImageChangerManager.Instance.DeviceType.KeyMouse or  
    self.disPlayMouse == false and not Input.GetKey(KeyCode.LeftAlt) and self.useCursorCount == 0 then
        FightMainUIView.bgInput.x = x
        FightMainUIView.bgInput.y = y
    end
end

function InputManager:BeforeUpdate()
    if self.screenMoveX and self.screenMoveY and self.deviceName then
        self:UpdateScreenMove(self.screenMoveX, self.screenMoveY)
    end

    -- PV专用
    if Input.GetKeyUp(KeyCode.F7) then
        mod.GmCtrl:DisPlayMouse()
    end
    
    if Input.GetKeyUp(KeyCode.F6) then
        DebugClientInvoke.CloseAllUI()
    end
    
    --TODO 仅供测试调试
    if Application.platform == RuntimePlatform.WindowsEditor  or 
    Application.platform == RuntimePlatform.WindowsPlayer then
        for key, v in pairs(KeyboardAddAttr) do
            if self:GetKeyDown(key) then
                --BehaviorFunctions.SetFightResult(true)
                if key == KeyCode.KeypadPeriod then
                    local player = Fight.Instance.playerManager:GetPlayer()
                    player.fightPlayer:AddAttrValue(v[1], v[2])
                else
                    local entity = Fight.Instance.playerManager:GetPlayer():GetCtrlEntityObject()
                    entity.attrComponent:AddValue(v[1], v[2])
                end
            end
        end

        if Input.GetKeyUp(KeyCode.F8) then
            if Time.timeScale == 0 then
                FightDebugManager.Instance.pauseNextFrame = true
                Time.timeScale = 1
            else
                Time.timeScale = 0
            end
        end

        if Input.GetKeyUp(KeyCode.F9) then
            Time.timeScale = 0.2
        end

        if Input.GetKeyUp(KeyCode.F10) then
             Time.timeScale = 0.5
        end
        if Input.GetKeyUp(KeyCode.F11) then
            Time.timeScale = 1
        end
        if Input.GetKeyUp(KeyCode.F12) then
            if Time.timeScale < 2 then
                Time.timeScale = 2
                return
            end
            Time.timeScale = Time.timeScale + 2
            if Time.timeScale > 12 then
                Time.timeScale = 2
            end
        end
        if Input.GetKeyUp(KeyCode.Keypad0) then
            BehaviorFunctions.ChangePlayerAttr(1653,0.5)
        end
    end
    if (InputDefine.AltShowCursorMap[self.actionMapName]) and self.disPlayMouse == false then
        if Input.GetKey(KeyCode.LeftAlt) then
            Cursor.lockState = CursorLockMode.None
            Cursor.visible = true
        elseif self.useCursorCount == 0 then
            Cursor.lockState = CursorLockMode.Locked
            Cursor.visible = false
        end
    end
end
local editor = ctx.Editor
local windowPlayer = ctx.WindowPlayer
InputManager.EnableKeyboard = false
function InputManager:GetKeyDown(keyCode)
    if editor or windowPlayer or InputManager.EnableKeyboard then
        return Input.GetKeyDown(keyCode)
    end
end
function InputManager:GetKeyUp(keyCode)
    if editor or windowPlayer or InputManager.EnableKeyboard then
        return Input.GetKeyUp(keyCode)
    end
end
function InputManager:GetKey(keyCode)
    if editor or windowPlayer or InputManager.EnableKeyboard then
        return Input.GetKey(keyCode)
    end
end

function InputManager:SetCanInputState(state)
    if state == self.canInput then
        self.canInputCount = self.canInputCount + 1
        return
    else
        self.canInputCount = self.canInputCount - 1
        if self.canInputCount < 1 then
            self.canInput = state
            self.canInputCount = 1
        end
    end
end

function InputManager:GetCanInputState()
    if not self.canInput or self.canInput == false then
        return false
    end
    return true
end

function InputManager:CheckPcDevice(deviceName)
    local deviceList = {
        Mouse = "Mouse",
        Keyboard = "Keyboard",
    }
    if not UtilsUI.CheckPCPlatform() then
        return true
    end
    for k, device in pairs(deviceList) do
        if deviceName == device then
            return true
        end
    end
    return false
end

-- 仅允许按特定按键
function InputManager:SetOnlyKeyInputState(type, state)
    if state ~= true then
        self.onlyKey = nil
    else
        self.onlyKey = type
    end
end

function InputManager:GetOnlyKeyInputState()
    return self.onlyKey
end

function InputManager:SwitchHostingMode(state)
    self.hostingMode = state or false
end
function InputManager:GetHostingModeState()
    return self.hostingMode      
end

function InputManager:SetKeyDisable(type, state)
    if not self.keyDisableList then
        self.keyDisableList = {}
    end
    self.keyDisableList[FightEnum.KeyEventToAction[type]] = state
end

function InputManager:GetKeyDisable()
    return self.keyDisableList
end

function InputManager:OnInputUpdate(type, state, deviceName, inputValue)
    if not self:GetInputSuccessState(deviceName, type, state) then return end
    self.deviceName = deviceName
    if self.hostingMode then -- 托管模式
        if state == FightEnum.InputActionPhase.Performed or (state == FightEnum.InputActionPhase.Started and type == FightEnum.KeyEventToAction[FightEnum.KeyEvent.Move]) then
            self:KeyDown(FightEnum.ActionToKeyEvent[type], { x = inputValue.x, y = inputValue.y })
        elseif state == FightEnum.InputActionPhase.Canceled then
            self:KeyUp(FightEnum.ActionToKeyEvent[type], { x = inputValue.x, y = inputValue.y })
        end
        return
    end

    if FightEnum.ActionToKeyEvent[type] then
        if state == FightEnum.InputActionPhase.Performed or (state == FightEnum.InputActionPhase.Started and type == FightEnum.KeyEventToAction[FightEnum.KeyEvent.Move]) then
			if type == FightEnum.KeyEventToAction[FightEnum.KeyEvent.Move] and FightMainUIView.CancelJoyStick then
				return
			end
            --全局屏蔽按键
            if self:GetCanInputState() == false then return end
            -- 仅允许按特定按键
            if self.onlyKey ~= nil and type ~= self.onlyKey then return end
            if InputDefine.KeyEventPerformedFunc[type] then
                InputDefine.KeyEventPerformedFunc[type]()
            end
            
            --转向 接收到cancel再停止
            --编辑器特殊处理，需要按下拖动，pc和手机端相同逻辑
            if type == FightEnum.KeyEventToAction[FightEnum.KeyEvent.ScreenMove] then
                if self.disPlayMouse == true then return end
                self.screenMoveX = inputValue.x
                self.screenMoveY = inputValue.y
            end

            self:KeyDown(FightEnum.ActionToKeyEvent[type], { x = inputValue.x, y = inputValue.y })
        elseif state == FightEnum.InputActionPhase.Canceled then
            self:KeyUp(FightEnum.ActionToKeyEvent[type], { x = inputValue.x, y = inputValue.y })
            if type == FightEnum.KeyEventToAction[FightEnum.KeyEvent.ScreenMove] then
                if self.disPlayMouse == true then
                    return
                end
                self.screenMoveX = 0
                self.screenMoveY = 0
			elseif type == FightEnum.KeyEventToAction[FightEnum.KeyEvent.Move] then
				FightMainUIView.CancelJoyStick = false --临时处理
            end
        end
    else
        self.otherMapInputCache[type] = inputValue
    end
end

function InputManager:GetInputSuccessState(deviceName, type, state)
    if state == FightEnum.InputActionPhase.Canceled then
        return true
    end
    if not self:CheckPcDevice(deviceName) then return false end
    if deviceName == "Mouse" and type == "Attack" then
        if self.disPlayMouse == true then
            return false
        elseif self.disPlayMouse == false and Input.GetKey(KeyCode.LeftAlt) then
            return false
        end
    end
    if self.keyDisableList and self.keyDisableList[type] == true then return false end
    if self.switchingActionMap == true  then 
        return false
    end
    return true
end

function InputManager:KeyDown(key, value)
    if self.forbidKey[key] then
        return
    end

    if key == FightEnum.KeyEvent.ScreenPress or key == FightEnum.KeyEvent.ScreenMove or key == FightEnum.KeyEvent.Jump then
        BehaviorFunctions.ResetTimeAutoFixTime(true)
    end

    local btnNames = KeyEvent2BehaviorBtn[key]
    if btnNames then
        for _, btnName in pairs(btnNames) do
            EventMgr.Instance:Fire(EventName.PlayClickEffect, btnName, true)
        end
    end
    EventMgr.Instance:Fire(EventName.ActionInput, key, value)
    Fight.Instance.entityManager:CallBehaviorFun("KeyInput", key, FightEnum.KeyInputStatus.Down)

    BehaviorFunctions.fight.operationManager:UpdateInput(key, FightEnum.InputActionPhase.Performed, value)
end

function InputManager:KeyUp(key, value)
    local operationManager = BehaviorFunctions.fight.operationManager
    if operationManager and operationManager.operations[key] and not (operationManager.operations[key].pressPhase == FightEnum.InputActionPhase.Performed) then
        return
    end
    if key == FightEnum.KeyEvent.ScreenPress or key == FightEnum.KeyEvent.ScreenMove or key == FightEnum.KeyEvent.Jump then
        BehaviorFunctions.ResetTimeAutoFixTime(false)
    end

    local btnNames = KeyEvent2BehaviorBtn[key]
    if btnNames then
        for _, btnName in pairs(btnNames) do
            EventMgr.Instance:Fire(EventName.PlayClickEffect, btnName, false)
        end
    end
    EventMgr.Instance:Fire(EventName.ActionInputEnd, key, value)
    if Fight.Instance.entityManager then
        Fight.Instance.entityManager:CallBehaviorFun("KeyInput", key, FightEnum.KeyInputStatus.Up)
    end

    BehaviorFunctions.fight.operationManager:UpdateInput(key, FightEnum.InputActionPhase.Canceled, value)
end

function InputManager:SetNextFrameKeyUp(key)
    table.insert(self.nextFrameKeyUps, key)
end

function InputManager:AfterUpdate()
    for i = #self.nextFrameKeyUps, 1, -1 do
        --应用下一帧抬起的数据
        local key = table.remove(self.nextFrameKeyUps)
        self:KeyUp(key, { x = 0, y = 0 })
    end
end

function InputManager:ClearAllInput()
    for keyCode, keyEvent in pairs(KeyCodeEvent) do
        local btnNames = FightEnum.KeyEvent2BehaviorBtn[keyEvent]
        if btnNames then
            for _, btnName in pairs(btnNames) do
                EventMgr.Instance:Fire(EventName.PlayClickEffect, btnName, false)
            end
        end
    end
end

--1<<0 -> 是否有移动输入
--1<<1-8 -> 移动数据
function InputManager:GetMoveCompress(x, y)
    local angle = Vector2.SignedAngle(Vector2.up, Vector2(x, y)) + 270 --+180为了符号转正，+90 以up为参考
    local bitValue = math.floor(angle / angleRange + 0.5)
    bitValue = bitValue << 1 | 1
    return bitValue
end

function InputManager:SetCanCameraInput(canCameraInput)
    self.canCameraInput = canCameraInput
end

function InputManager:SetCameraMouseInput(isCameraMouseInput)
    self.cameraMouseInput = isCameraMouseInput
end

function InputManager.CameraInput(name)
    if BehaviorFunctions.fight.clientFight.inputManager.forbidKey[FightEnum.KeyEvent.ScreenMove] then
        return 0
    end
    if InputManager.Instance.cameraMouseInput or not InputManager.Instance.canCameraInput then
        return 0
    end

    if name == "Mouse X" then
        local x = FightMainUIView.bgInput.x
        if InputManager.Instance.deviceName ~= "GamePad" then
            FightMainUIView.bgInput.x = 0
        end
        if x ~= 0 then
            BehaviorFunctions.ResetTimeAutoFixTime()
        end
        return x
    end

    if name == "Mouse Y" then
        local y = FightMainUIView.bgInput.y
        if InputManager.Instance.deviceName ~= "GamePad" then
            FightMainUIView.bgInput.y = 0
        end
        if y ~= 0 then
            BehaviorFunctions.ResetTimeAutoFixTime()
        end
        return y
    end
    return 0
end

function InputManager:SetActionEnable(opType, keyEvent, enable)
    if not self.actionEnable[keyEvent] then
        self.actionEnable[keyEvent] = {
            behavior = nil,
            level = nil,
        }
    end

    --设置UI是否显示
    if FightEnum.KeyEvent2BehaviorBtn[keyEvent] then
        EventMgr.Instance:Fire(EventName.SetNodeVisible, opType, FightEnum.KeyEvent2BehaviorBtn[keyEvent][1], enable, nil)
    end

    if opType == FightEnum.BehaviorUIOpType.behavior then
        self.actionEnable[keyEvent].behavior = enable
    else
        self.actionEnable[keyEvent].level = enable
    end

    local behaviorEnable = self.actionEnable[keyEvent].behavior
    local levelEnable = self.actionEnable[keyEvent].level
    local realEnable
    if opType == FightEnum.BehaviorUIOpType.level then
        realEnable = levelEnable
    else
        if levelEnable == nil then
            realEnable = behaviorEnable
        else
            realEnable = levelEnable
        end
    end
    if realEnable == nil then
        return
    end

    local playerObject = Fight.Instance.playerManager:GetPlayer():GetCtrlEntityObject()
    local ActionName = FightEnum.KeyEventToAction[keyEvent]
    if opType == FightEnum.BehaviorUIOpType.behavior and playerObject and next(playerObject) then
        local curPlayer = playerObject.entityId
        if not self.actionCacheByPlayer[curPlayer] then
            self.actionCacheByPlayer[curPlayer] = {}
        end

        if not self.actionCacheByPlayer[curPlayer][ActionName] then
            self.actionCacheByPlayer[curPlayer][ActionName] = { initState = true, curState = realEnable }
        end
        self.actionCacheByPlayer[curPlayer][ActionName].curState = realEnable
    end

    if realEnable then
        self.ActionAssetCallback:EnableAction(ActionName)
    else
        self.ActionAssetCallback:DisableAction(ActionName)
    end
end

function InputManager:UpdatePlayerBindAction(isReset)
    local playerObject = Fight.Instance.playerManager:GetPlayer():GetCtrlEntityObject()
    local curPlayer = playerObject.entityId
    if self.actionCacheByPlayer[curPlayer] then
        for k, v in pairs(self.actionCacheByPlayer[curPlayer]) do
            local isEnable
            if isReset then
                isEnable = v.initState
            else
                isEnable = v.curState
            end
            if isEnable then
                self.ActionAssetCallback:EnableAction(k)
            else
                self.ActionAssetCallback:DisableAction(k)
            end
        end
    end
end

function InputManager:GetNowActionMapName()
    return self.actionMapName
end

function InputManager:SwitchActionMap(mapName)
	if self.actionMapName == mapName then 
		return 
	end
    self.switchingActionMap = true
    self.actionMapName = mapName
    TableUtils.ClearTable(self.otherMapInputCache)
    EventMgr.Instance:Fire(EventName.OnChangeActionmap, self.actionMapName)
    local function SwitchActionMapCallBack()
        self.switchingActionMap = false
        if self.ActionAssetCallback then
            self.ActionAssetCallback:SwitchActionMapFromLua(mapName)
        end
    end
    LuaTimerManager.Instance:AddTimer(1,0,SwitchActionMapCallBack)
    --LogError(mapName)
end

function InputManager:OnFightPause(isPause)
    self:ShowCursor(isPause)
end
function InputManager:StoryDialogStart(dialogId)
    if StoryConfig.GetStoryType(dialogId) ~= StoryConfig.DialogType.TipAside then
        self:ShowCursor(true)
    end
end

function InputManager:StoryDialogEnd(dialogId)
    if StoryConfig.GetStoryType(dialogId) ~= StoryConfig.DialogType.TipAside then
        self:ShowCursor(false)
    end
end

function InputManager:ShowCursor(isShow)
    if self.disPlayMouse == true then
        return
    end
    if isShow then
        self.useCursorCount = self.useCursorCount + 1
    else
        self.useCursorCount = self.useCursorCount - 1
        if self.useCursorCount < 0 then
            self.useCursorCount = 0
        end
    end

    if self.useCursorCount > 0 then
        Cursor.lockState = CursorLockMode.None
        Cursor.visible = true
    else
        Cursor.lockState = CursorLockMode.Locked
        Cursor.visible = false
    end
end

function InputManager:__delete()
    self.ActionAssetCallback.InputLuaAction:RemoveAllListeners()
    self.ActionAssetCallback = nil
    self.useCursorCount = 0
    Cursor.lockState = CursorLockMode.None
    Cursor.visible = true
    EventMgr.Instance:RemoveListener(EventName.FightPause, self:ToFunc("OnFightPause"))
    EventMgr.Instance:RemoveListener(EventName.ShowCursor, self:ToFunc("ShowCursor"))
    EventMgr.Instance:RemoveListener(EventName.StoryDialogStart, self:ToFunc("StoryDialogStart"))
    EventMgr.Instance:RemoveListener(EventName.StoryDialogEnd, self:ToFunc("StoryDialogEnd"))
    EventMgr.Instance:RemoveListener(EventName.ActionInput, self:ToFunc("ActionInputBack"))
end

function InputManager:ForbidKey(keyEvent, isFobid)
    self.forbidKey[keyEvent] = isFobid
end

function InputManager:AddLayerCountByPriority(state)
    local setting = {}
    setting.state = state
    setting.priority = SystemStateConfig.GetActionMapWeight(state)
    self.timeIndex = self.timeIndex + 1
    setting.timeIndex = self.timeIndex
    table.insert(self.layerQueue, setting)
end

function InputManager:AddLayerCount(newState)
    --Log("AddLayerCount", newState)
    self:SetCanNotBackTimer(0.6)

    self:AddLayerCountByPriority(newState)
   
    --按优先级排序
    table.sort(self.layerQueue, function(a, b)
        if a.priority == b.priority then
            return a.timeIndex < b.timeIndex
        end  
        return a.priority > b.priority
    end)
    local layer = self.layerQueue[1]
    
    if layer and layer.state then
        --切换到最顶上的状态
        self:SwitchActionMap(layer.state)
    end
end

--不填默认移除最后面的state
function InputManager:MinusLayerCount(removeState)
    --Log("MinusLayerCount", removeState)
    --移除对应的state
    local state = self:RemovePanelLayerList(removeState)
    if not state then
        return 
    end
    self:SwitchActionMap(state)
    return state
end

function InputManager:RemovePanelLayerList(removeState)
    local removeIndex
    for i, v in ipairs(self.layerQueue) do
        if v.state == removeState then
            removeIndex = i
            break
        end
    end
    if not removeIndex then return end
    table.remove(self.layerQueue, removeIndex)
    local setting = self.layerQueue[1]
    if not setting then
        return
    end
    return setting.state
end

function InputManager:SetGuideCanNotBackState(state)
    self.guideCanNotBack = state
end

function InputManager:SetCanNotBackTimer(time)
    if self.canNotBack == true and self.backTimer then
        LuaTimerManager.Instance:RemoveTimer(self.backTimer)
    end
    self.canNotBack = true
    self.backTimer = LuaTimerManager.Instance:AddTimer(1, time,function()
        self.canNotBack = false
    end)
end

function InputManager:ActionInputBack(key, value)
    if key == FightEnum.KeyEvent.Back then
        if self.canNotBack == true or self.guideCanNotBack == true then
            return
        end
        local maxOrder = 0
        local maxView = nil
        for panelName, panel in pairs(PanelManager.Instance.panelList) do
            if maxOrder < panel:GetOrderId() then
                maxOrder = panel:GetOrderId()
                maxView = panel
            end
        end
        for windowName, window in pairs(WindowManager.Instance.windows) do
            
            for panelName, panel in pairs(window.panelList) do
                if maxOrder < panel:GetOrderId() and panel:IsAcceptInput() == true then
                    maxOrder = panel:GetOrderId()
                    maxView = panel
                end
            end

            if maxOrder < window:GetOrderId() then
                maxOrder = window:GetOrderId()
                maxView = window
            end
        end
        for _, whiteListPanel in pairs(self.whiteList) do
            if whiteListPanel == maxView then
                return
            end
        end
        if maxView:Active() ~= true then
            return
        end
        maxView:CloseByCommand()
    end
end

--注册双指触控监听
--调用方式 InputManager.Instance:SetTouchAction(self:ToFunc("OnTouchEvent"))
function InputManager:SetTouchAction(callback)
    self.ActionAssetCallback:SetTouchAction(callback)
end

function InputManager:RemoveTouchAction()
    self.ActionAssetCallback:RemoveTouchAction()
end


