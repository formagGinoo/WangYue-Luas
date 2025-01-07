---@class OperationManager
OperationManager = BaseClass("OperationManager")
function OperationManager:__init(fight)
	self.fight = fight
	--{
	--	"action":{
	--		PressFrame:
	--		phase:
	--		value:
	--		}
	--}
	self.operations = {} --map
	self.moveEvent = Vector2.zero
	self.enableInstanceMap = {}
end

function OperationManager:BeforeUpdate()
	for _, v in pairs(self.operations) do
		v.pressFrame = v.pressFrame + 1
	end

	if ctx.IsDebug and FightDebugManager.Instance.pauseNextFrame then
		Time.timeScale = 0
		FightDebugManager.Instance.pauseNextFrame = false
	end
end

function OperationManager:AfterUpdate()
	if ctx then
		self.fight.clientFight.inputManager:AfterUpdate()
		self.moveEvent.x = 0
		self.moveEvent.y = 0
	end
end

function OperationManager:UpdateInput(key, phase, value)
	if not self.operations[key] then
		self.operations[key] = {}
	end
	if phase ~= self.operations[key].pressPhase then
		self.operations[key].pressFrame = 0
	end
	self.operations[key].pressPhase = phase
	self.operations[key].value = value
end

function OperationManager:CheckMove()
	if not self.operations[FightEnum.KeyEvent.Move] then
		return false
	end
	return self.operations[FightEnum.KeyEvent.Move].pressPhase == FightEnum.InputActionPhase.Performed
end

function OperationManager:CheckJump()
	return self:CheckKeyDown(FightEnum.KeyEvent.Jump)
end

function OperationManager:GetKeyPressFrame(key, instanceId)
	if instanceId and not self.enableInstanceMap[instanceId] then
		return 0
	end
	if self.operations[key] and self.operations[key].pressPhase == FightEnum.InputActionPhase.Performed then
		return self.operations[key].pressFrame
	end
	return 0
end

function OperationManager:RemoveKeyPress(key)
	if not self.operations[key] then
		return
	end
	self.operations[key].pressFrame = 0
	self.operations[key].pressPhase = FightEnum.InputActionPhase.Canceled
	if self.operations[key].value then
		if self.operations[key].value.x then
			self.operations[key].value.x = 0
			self.operations[key].value.y = 0
		else
			self.operations[key].value = 0
		end
	end
end

function OperationManager:SetEnableInstanceMap(map)
	self.enableInstanceMap = {}
	if not map then
		return
	end
	for k, v in pairs(map) do
		self.enableInstanceMap[v] = true
	end
end

-- 获取按下状态，当前帧按下，上一帧不按下
function OperationManager:CheckKeyDown(key, instanceId)
	if instanceId and not self.enableInstanceMap[instanceId] then
		return false
	end
	if self.operations[key] then
		return self.operations[key].pressPhase == FightEnum.InputActionPhase.Performed and self.operations[key].pressFrame == 1
	end
	return false
end

-- 获取按下状态，当前帧抬起
function OperationManager:CheckKeyUp(key, instanceId)
	if instanceId and not self.enableInstanceMap[instanceId] then
		return false
	end
	if self.operations[key] then
		return self.operations[key].pressPhase == FightEnum.InputActionPhase.Canceled and self.operations[key].pressFrame == 1
	end
	return false
end

function OperationManager:SetUseOriginalMoveEventState(isUse)
	self.fixedUseOriginalMoveEvent = isUse
end

function OperationManager:CheckUseOriginalMoveEvent()
	if self.fixedUseOriginalMoveEvent then return true end
	
	local player = Fight.Instance.playerManager:GetPlayer():GetCtrlEntityObject()
	if player.stateComponent:IsState(FightEnum.EntityState.Climb) then
		return true
	end
end

function OperationManager:GetMoveEvent(isOriginal)
	if not self.operations[FightEnum.KeyEvent.Move] then
		return
	end
	local moveInput = self.operations[FightEnum.KeyEvent.Move].value
	if not moveInput or (moveInput.x == 0 and moveInput.y == 0) then
		return
	end

	if not isOriginal and not self:CheckUseOriginalMoveEvent() then
		self.moveEvent.x, self.moveEvent.y = Fight.Instance.clientFight.cameraManager:GetMove(moveInput.x,moveInput.y)
	else
		self.moveEvent.x = moveInput.x
		self.moveEvent.y = moveInput.y
	end
	return self.moveEvent
end

function OperationManager:GetKeyInput(Key)
	if not self.operations[Key] then
		return
	end
	return self.operations[Key].value
end

function OperationManager:__delete()

end
