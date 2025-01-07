FightJoyStickPanel = BaseClass("FightJoyStickPanel", BasePanel)

local _floor = math.floor
local _atan = math.atan
local _rad2Deg = math.deg(1)
local stop = { x = 0, y = 0 }

FightJoyStickPanel.IsJoystickDown = false

function FightJoyStickPanel:__init(mainView)
    self:SetAsset("Prefabs/UI/Fight/FightJoyStickPanel.prefab")
    self.mainView = mainView
    self.moveMode = 0
end

function FightJoyStickPanel:__BindListener()
    self.canvasGroup = self.gameObject:GetComponent(CanvasGroup)
end

function FightJoyStickPanel:__CacheObject()
	self.stickCmp = self.JoystickPointRange:GetComponent(CS.UnityEngine.InputSystem.OnScreen.OnScreenStick)
end

function FightJoyStickPanel:__BaseShow()
    self:SetParent(self.mainView.PanelParent.transform)
end

function FightJoyStickPanel:__Show()
    self.startPoint = self.JoystickPoint.transform.position
    self:UpdateJoyStickCycle(false)
end

function FightJoyStickPanel:__ShowComplete()
    self.mainView:AddLoadDoneCount()
end

function FightJoyStickPanel:__delete()

end

function FightJoyStickPanel:__Hide()
end

function FightJoyStickPanel:Update()
	if FightMainUIView.CancelJoyStick then
		return 
	end
	
    local moveEvent = Fight.Instance.operationManager:GetMoveEvent(true)
	if not moveEvent then
		return
	end

    local z = 360 - _floor(_atan(moveEvent.x, moveEvent.y) * _rad2Deg) % 360
    for i = 1, 2 do
        CustomUnityUtils.SetLocalEulerAngles(self["JoyPointDir" .. i].transform, 0, 0, z)
    end
    CustomUnityUtils.SetLocalEulerAngles(self.JoystickPointImage.transform, 0, 0, z)
    local isMove = moveEvent.x ~= 0 or moveEvent.y ~= 0
    self:UpdateJoyStickCycle(isMove)
    if isMove then
        self:UpdateEntityMoveMode(moveEvent)
    end
end

function FightJoyStickPanel:UpdatePlayer()
    self.player = Fight.Instance.playerManager:GetPlayer()
    self.playerObject = Fight.Instance.playerManager:GetPlayer():GetCtrlEntityObject()

    if not self.playerObject then
        return
    end

    self.moveMode = self.playerObject.stateComponent:GetMoveMode()
end

function FightJoyStickPanel:SetVisibleByAlpha(priority, visible, stopControl)
    if not self.canvasGroup then
        return
    end

    local cPriority = priority
    local cVisible = visible

    self.uiVisible = self.uiVisible or {}
    if stopControl then
        self.uiVisible[priority] = nil
        cPriority = -9999
        if cVisible == nil then
            cVisible = true
        end
    else
        self.uiVisible[priority] = visible
    end

    for p, v in pairs(self.uiVisible) do
        if cPriority < p then
            cPriority = p
            cVisible = v
        end
    end

    self.canvasGroup.alpha = cVisible and 1 or 0
end

function FightJoyStickPanel:UpdateJoyStickType(type)
    for i = 0, 2 do
        self["JoystickImage" .. i .. "_canvas"].alpha = type == i and 1 or 0
    end
end

function FightJoyStickPanel:UpdateJoyStickCycle(isMove)
    if isMove then
        self.JoystickPointImage_canvas.alpha = 1
        self:UpdateJoyStickType(self.moveMode)
    else
        self.JoystickPointImage_canvas.alpha = 0
        self:UpdateJoyStickType(0)
        self.moveMode = 0
    end
end

function FightJoyStickPanel:UpdateEntityMoveMode(move)
    if not self.playerObject then
        return
    end
    local mode = self.playerObject.stateComponent:GetMoveMode()
    local walk = move.x * move.x + move.y * move.y < 0.25
    if walk then
        if self.moveMode ~= FightEnum.EntityMoveMode.Walk then
            self.moveMode = FightEnum.EntityMoveMode.Walk
            self:UpdateJoyStickCycle(true)
            if mode ~= FightEnum.EntityMoveMode.InjuredWalk then
                self.playerObject.stateComponent:SetMoveMode(FightEnum.EntityMoveMode.Walk)
            end
        end
    else
        if self.moveMode ~= FightEnum.EntityMoveMode.Run then
            self.moveMode = FightEnum.EntityMoveMode.Run
            self:UpdateJoyStickCycle(true)
            if mode ~= FightEnum.EntityMoveMode.InjuredWalk then
                self.playerObject.stateComponent:SetMoveMode(FightEnum.EntityMoveMode.Run)
            end
        end
    end
end

---TODO需要处理
function FightJoyStickPanel:CancelJoystick()
    self:JoystickUp()
	
	local moveEvent = Fight.Instance.operationManager:GetMoveEvent(true)
	if not moveEvent or (moveEvent.x == 0 and moveEvent.y == 0) then
		return 
	end

	FightMainUIView.CancelJoyStick = true
	Fight.Instance.clientFight.inputManager:KeyUp(FightEnum.KeyEvent.Move, { x = 0, y = 0})
end

function FightJoyStickPanel:JoystickUp()
    self:UpdateJoyStickCycle(false)
end