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
    [KeyCode.I] = FightEnum.KeyEvent.NormalSkill,
    [KeyCode.O] = FightEnum.KeyEvent.Jump,
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
    [KeyCode.Keypad0] = { EntityAttrsConfig.AttrType.Energy, 999999 },
    [KeyCode.KeypadPeriod] = { FightEnum.PlayerAttr.CurStaminaValue, 999999 },
    [KeyCode.Keypad1] = { EntityAttrsConfig.AttrType.NormalSkillPoint, 300 },
    [KeyCode.Keypad2] = { EntityAttrsConfig.AttrType.ExSkillPoint, 300 },
    [KeyCode.Keypad3] = { EntityAttrsConfig.AttrType.CommonAttr1, 9999999 },
    [KeyCode.Keypad4] = { EntityAttrsConfig.AttrType.CoreRes, 999999 },
    [KeyCode.Keypad5] = { EntityAttrsConfig.AttrType.DefineRes1, 999999 },
    [KeyCode.Keypad6] = { EntityAttrsConfig.AttrType.DefineRes2, 999999 },
}

function InputManager:__init(fightClient)
    self.fightClient = fightClient
    --self.input = 0
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
    self.whiteList = {"GuideMaskPanel", }
    self.canNotBack = false

    self.canInput = true
    self.guildType = 0

    self.ActionAssetCallback = GameObject.Find("EventSystem"):GetComponent(ActionAssetCallback)
    self.ActionAssetCallback.InputLuaAction:RemoveAllListeners()
    self.ActionAssetCallback:AddLuaListener(self:ToFunc("OnInputUpdate"))

    EventMgr.Instance:AddListener(EventName.FightPause, self:ToFunc("OnFightPause"))
    EventMgr.Instance:AddListener(EventName.ShowCursor, self:ToFunc("ShowCursor"))
    EventMgr.Instance:AddListener(EventName.StoryDialogStart, self:ToFunc("StoryDialogStart"))
    EventMgr.Instance:AddListener(EventName.StoryDialogEnd, self:ToFunc("StoryDialogEnd"))
    EventMgr.Instance:AddListener(EventName.ActionInput, self:ToFunc("ActionInputBack"))
end

function InputManager:UpdateScreenMove(x, y)
    if not (Application.platform == RuntimePlatform.WindowsEditor and self.deviceName == "Mouse") and not Input.GetKey(KeyCode.LeftAlt) and self.useCursorCount == 0 then
        FightMainUIView.bgInput.x = x
        FightMainUIView.bgInput.y = y
    end
end

function InputManager:BeforeUpdate()
    if self.screemMoveX and self.screemMoveY and self.deviceName then
        self:UpdateScreenMove(self.screemMoveX, self.screemMoveY)
    end
    
    if Application.platform == RuntimePlatform.WindowsEditor then
        
        -- j特殊规则，按下连点
        local j = self:GetKey(KeyCode.J)
        if j then
            -- j的连点攻击特殊处理
            self:KeyDown(FightEnum.KeyEvent.Attack)
            self:KeyDown(FightEnum.KeyEvent.AttackJ)
            local operationMgr = BehaviorFunctions.fight.operationManager
            operationMgr:RemoveKeyPress(FightEnum.KeyEvent.Attack)
        else
            if self:GetKeyUp(KeyCode.J) then
                self:KeyUp(FightEnum.KeyEvent.Attack)
                self:KeyUp(FightEnum.KeyEvent.AttackJ)
            end
        end

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
    end
    if Application.platform == RuntimePlatform.WindowsPlayer then
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

function InputManager:MoveInput(x, y)
    --self.input = self.input | self:GetMoveCompress(x,y)
end

function InputManager:SetCanInputState(state)
    self.canInput = state
end

function InputManager:GetCanInputState()
    if not self.canInput or self.canInput == false then
        return false
    end
    return true
end

-- 仅允许按特定按键
function InputManager:SetOnlyKeyInputState(type, state)
    if state ~= true then
        self.onlyKey = nil
    else
        self.onlyKey = type
    end
end

function InputManager:OnInputUpdate(type, state, deviceName, inputValue)
    --编辑器模式屏蔽鼠标左键攻击
    if ctx.Editor and deviceName == "Mouse" and type == "Attack" then
        return
    end

    self.deviceName = deviceName
    
    if FightEnum.ActionToKeyEvent[type] then
        if state == FightEnum.InputActionPhase.Performed or (state == FightEnum.InputActionPhase.Started and type == FightEnum.KeyEventToAction[FightEnum.KeyEvent.Move]) then
			if type == FightEnum.KeyEventToAction[FightEnum.KeyEvent.Move] and FightMainUIView.CancelJoyStick then
				return
			end

            --全局屏蔽按键
            if self:GetCanInputState() == false then
                return
            end

            -- 仅允许按特定按键
            if self.onlyKey ~= nil and type ~= self.onlyKey then
                return
            end

			self:KeyDown(FightEnum.ActionToKeyEvent[type], { x = inputValue.x, y = inputValue.y })

            --转向 接收到cancel再停止
            --编辑器特殊处理，需要按下拖动，pc和手机端相同逻辑
            if type == FightEnum.KeyEventToAction[FightEnum.KeyEvent.ScreenMove] then
                self.screemMoveX = inputValue.x
                self.screemMoveY = inputValue.y
            end

            if type == FightEnum.KeyEventToAction[FightEnum.KeyEvent.MoveMode] then
                local roleId = BehaviorFunctions.GetCtrlEntity()
                local mode = BehaviorFunctions.GetEntityMoveMode(roleId)
                if mode == FightEnum.EntityMoveMode.Walk then
                    BehaviorFunctions.SetEntityMoveMode(roleId, FightEnum.EntityMoveMode.Run)
                elseif mode == FightEnum.EntityMoveMode.Run then
                    BehaviorFunctions.SetEntityMoveMode(roleId, FightEnum.EntityMoveMode.Walk)
                end
            end

            if type == FightEnum.KeyEventToAction[FightEnum.KeyEvent.Interaction] then
                EventMgr.Instance:Fire(EventName.WorldInteractKeyClick)
            end

            if type == FightEnum.KeyEventToAction[FightEnum.KeyEvent.Map] then
                local isDup = mod.WorldMapCtrl:CheckIsDup()
                if isDup then
                    return
                end
                local isOpen, failDesc = Fight.Instance.conditionManager:CheckSystemOpen(SystemConfig.SystemOpenId.Map)
                if not isOpen then
                    MsgBoxManager.Instance:ShowTips(failDesc)
                    return
                end
                WindowManager.Instance:OpenWindow(WorldMapWindow)
            elseif type == FightEnum.KeyEventToAction[FightEnum.KeyEvent.System] then
                WindowManager.Instance:OpenWindow(SystemMenuWindow)
            elseif type == FightEnum.KeyEventToAction[FightEnum.KeyEvent.Character] then
                local isOpen, failDesc = Fight.Instance.conditionManager:CheckSystemOpen(SystemConfig.SystemOpenId.Role)
                if not isOpen then
                    MsgBoxManager.Instance:ShowTips(failDesc)
                    return
                end
                RoleMainWindow.OpenWindow(mod.RoleCtrl:GetCurUseRole())
            elseif type == FightEnum.KeyEventToAction[FightEnum.KeyEvent.Team] then
                local isOpen, failDesc = Fight.Instance.conditionManager:CheckSystemOpen(SystemConfig.SystemOpenId.Formation)
                if not isOpen then
                    MsgBoxManager.Instance:ShowTips(failDesc)
                    return
                end
                if BehaviorFunctions.CheckPlayerInFight() then
                    MsgBoxManager.Instance:ShowTips(TI18N("战斗中无法操作"))
                    return
                end
                local entity = Fight.Instance.playerManager:GetPlayer():GetCtrlEntityObject()
                for i = 1, #FormationConfig.FormationState, 1 do
                    if entity.stateComponent:IsState(FormationConfig.FormationState[i]) then
                        break
                    end
                    if i == #FormationConfig.FormationState then
                        MsgBoxManager.Instance:ShowTips(TI18N("当前无法操作"))
                        return
                    end
                end
                FormationWindowV2.OpenWindow()
            elseif type == FightEnum.KeyEventToAction[FightEnum.KeyEvent.Backpack] then
                local isOpen, failDesc = Fight.Instance.conditionManager:CheckSystemOpen(SystemConfig.SystemOpenId.Bag)
                if not isOpen then
                    MsgBoxManager.Instance:ShowTips(failDesc)
                    return
                end
                WindowManager.Instance:OpenWindow(BagWindow)
            elseif type == FightEnum.KeyEventToAction[FightEnum.KeyEvent.Mission] then
                local isOpen, failDesc = Fight.Instance.conditionManager:CheckSystemOpen(SystemConfig.SystemOpenId.Task)
                if not isOpen then
                    MsgBoxManager.Instance:ShowTips(failDesc)
                    return
                end
                WindowManager.Instance:OpenWindow(TaskMainWindow)
            elseif type == FightEnum.KeyEventToAction[FightEnum.KeyEvent.Tutorial] then
                local isOpen, failDesc = Fight.Instance.conditionManager:CheckSystemOpen(SystemConfig.SystemOpenId.Teach)
                if not isOpen then
                    MsgBoxManager.Instance:ShowTips(failDesc)
                    return
                end
                WindowManager.Instance:OpenWindow(TeachWindow)
            elseif type == FightEnum.KeyEventToAction[FightEnum.KeyEvent.AutoPlay] then
                local panel =  PanelManager.Instance:GetPanel(StoryDialogPanel)
                if panel then
                    panel:OnClick_ChangePlayState()
                end
            elseif type == FightEnum.KeyEventToAction[FightEnum.KeyEvent.Skip] then
                local panel =  PanelManager.Instance:GetPanel(StoryDialogPanel)
                if panel then
                    panel:OnClick_SkipDialog()
                end
            elseif type == FightEnum.KeyEventToAction[FightEnum.KeyEvent.Next] then
                local panel =  PanelManager.Instance:GetPanel(StoryDialogPanel)
                if panel then
                    panel:OnClick_NextDialog()
                end
            end
        elseif state == FightEnum.InputActionPhase.Canceled then
            self:KeyUp(FightEnum.ActionToKeyEvent[type], { x = inputValue.x, y = inputValue.y })
            if type == FightEnum.KeyEventToAction[FightEnum.KeyEvent.ScreenMove] then
                self.screemMoveX = 0
                self.screemMoveY = 0
			elseif type == FightEnum.KeyEventToAction[FightEnum.KeyEvent.Move] then
				FightMainUIView.CancelJoyStick = false --临时处理
            elseif type == FightEnum.KeyEventToAction[FightEnum.KeyEvent.AimMode] then
            end
        end
    else
        self.otherMapInputCache[type] = inputValue
    end
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
    if key == FightEnum.KeyEvent.ScreenPress or key == FightEnum.KeyEvent.ScreenMove or key == FightEnum.KeyEvent.Jump then
        BehaviorFunctions.ResetTimeAutoFixTime(false)
    end

    local btnNames = KeyEvent2BehaviorBtn[key]
    if btnNames then
        for _, btnName in pairs(btnNames) do
            EventMgr.Instance:Fire(EventName.PlayClickEffect, btnName, false)
        end
    end
    Fight.Instance.entityManager:CallBehaviorFun("KeyInput", key, FightEnum.KeyInputStatus.Up)

    BehaviorFunctions.fight.operationManager:UpdateInput(key, FightEnum.InputActionPhase.Canceled, value)
end

function InputManager:SetNextFrameKeyUp(key)
    table.insert(self.nextFrameKeyUps, key)
end

function InputManager:AfterUpdate()
    --self:ClearMove()
    for i = #self.nextFrameKeyUps, 1, -1 do
        --应用下一帧抬起的数据
        local key = table.remove(self.nextFrameKeyUps)
        self:KeyUp(key, { x = 0, y = 0 })
    end
end

function InputManager:ClearMove()

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

    --self.input = 0
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
    if ctx.Editor then
        -- Cursor.visible = self.cameraMouseInput
    end
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

function InputManager:SwitchActionMap(mapName)
    self.actionMapName = mapName
    TableUtils.ClearTable(self.otherMapInputCache)
    self.ActionAssetCallback:SwitchActionMapFromLua(mapName)
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
    if Application.platform ~= RuntimePlatform.WindowsPlayer then
        return
    end

    if isShow then
        self.useCursorCount = self.useCursorCount + 1
    else
        self.useCursorCount = self.useCursorCount - 1
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
    EventMgr.Instance:RemoveListener(EventName.FightPause, self:ToFunc("OnFightPause"))
    EventMgr.Instance:RemoveListener(EventName.ShowCursor, self:ToFunc("ShowCursor"))
    EventMgr.Instance:RemoveListener(EventName.StoryDialogStart, self:ToFunc("StoryDialogStart"))
    EventMgr.Instance:RemoveListener(EventName.StoryDialogEnd, self:ToFunc("StoryDialogEnd"))
    EventMgr.Instance:RemoveListener(EventName.ActionInput, self:ToFunc("ActionInputBack"))
end

function InputManager:ForbidKey(keyEvent, isFobid)
    self.forbidKey[keyEvent] = isFobid
end

local panelLayerList = {}
function InputManager:AddLayerCount(oldState, newState)
    -- TODO 记录对应panellayerlist加上重复打开同一个面板的判断，防止引用计数错误
    self:SetCanNotBackTimer(0.6)
    if oldState == newState then
        self.layerCount = self.layerCount + 1
        return
    end
    if self.layerCount == 0 or not self.layerCount then
        self.oldActionState = oldState
        self:SwitchActionMap(newState)
        self.layerCount = 0
    end
    self.layerCount = self.layerCount + 1
end

function InputManager:MinusLayerCount()
    if self.layerCount == 0 then
        return
    end
    self.layerCount = self.layerCount - 1
    if self.layerCount == 0 then
        self:SwitchActionMap(self.oldActionState)
    end
end

function InputManager:SetCanNotBackTimer(time)
    if self.canNotBack == true then
        LuaTimerManager.Instance:RemoveTimer(self.backTimer)
    end
    self.canNotBack = true
    self.backTimer = LuaTimerManager.Instance:AddTimer(1, time,function()
        self.canNotBack = false
    end)
end

function InputManager:ActionInputBack(key, value)
    if key == FightEnum.KeyEvent.Back then
        if self.canNotBack == true then
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