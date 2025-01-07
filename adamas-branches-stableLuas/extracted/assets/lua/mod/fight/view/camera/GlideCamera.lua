GlideCamera = BaseClass("GlideCamera")
local bindNode = "ItemCase_r"

local cameraParamsId = 80001
local lerpTime = 0.1
function GlideCamera:__init(cameraManager)
	self.cameraManager = cameraManager
	self.fight = cameraManager.clientFight.fight
	self.delyTime = 0
end

function GlideCamera:LerpVal(a, b, t)
    return a + (b - a) * t
end

function GlideCamera:NormalizeEuler(value)
	if value < -180 then
		value = value + 360
	elseif value > 180 then
		value = value - 360
	end
	return value
end

function GlideCamera:Update(lerpTime)
    do return end
    
    if not Fight.Instance then return end
    local instanceId = BehaviorFunctions.GetCtrlEntity()
	local entity = BehaviorFunctions.GetEntity(instanceId)
    local glideTrans = entity.clientTransformComponent:GetTransform(bindNode)
    if not entity.stateComponent or not entity.stateComponent:CanGlide() then
        if self.addGlideFollow then
            local state = self.cameraManager:GetCameraState()
            self.cameraManager:RemoveFollowTarget(glideTrans, state)
            self.addGlideFollow = false
            BehaviorFunctions.SetCameraParams(state)
        end
		self.delyTime = 0
        return
    end
	self.delyTime = self.delyTime + Time.deltaTime
	if self.delyTime <= FightUtil.deltaTimeSecond * 3 then return end
    if not self.addGlideFollow then
        local state = self.cameraManager:GetCameraState()
        self.cameraManager:AddFollowTarget(glideTrans, state, 2)
        BehaviorFunctions.SetGlideCameraParams(state, cameraParamsId)
        self.addGlideFollow = true
    end
    --self:LerpCameraSoftZone()
end 

function GlideCamera:LerpCameraSoftZone()
	--if self.delyTime <= 1 then return end
    local cameraCfg = Config.CameraParams[cameraParamsId]
    local curCamera = self.cameraManager:GetCurCamera()
    if not curCamera.SetCameraSoftZoneInfo then return end
    local curWidth, curHeight = curCamera:GetCameraSoftZoneInfo()
    local targetWidth, targetHeight = cameraCfg.BodySoftWidth, cameraCfg.BodySoftHeight

    local newWidth = self:LerpVal(curWidth, targetWidth, lerpTime)
    local newHeight = self:LerpVal(curHeight, targetHeight, lerpTime)
    --curCamera:SetCameraSoftZoneInfo(newWidth, newHeight)
	
	local lastVal = curCamera.framingTransposer.m_XDamping
	local val = self:LerpVal(lastVal, 0.1, 0.1)
	--BehaviorFunctions.SetBodyDamping(val, val, val)
end