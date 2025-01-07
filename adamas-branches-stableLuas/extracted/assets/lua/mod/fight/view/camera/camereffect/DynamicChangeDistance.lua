DynamicChangeDistance = BaseClass("DynamicChangeDistance")

--[[
    local params = {
        cameraState = cameraState,
        targetInsId = targetInsId,
        bindName = bindName,
        time = time,
        maxDis = maxDis,
    }
]]

function DynamicChangeDistance:__init(cameraManager)
	self.cameraManager = cameraManager
	self.fight = cameraManager.clientFight.fight
    self.dynamciChangeMap = {}
    self.targetChangeMap = {}
end

function DynamicChangeDistance:Update()
    self:UpdateCameraDistance()
end

function DynamicChangeDistance:__delete()
end

function DynamicChangeDistance:AddNewData(params)
    local cameraState = params.cameraState

    if not params.isTargetDis then
        if params.isOpen then
            self.dynamciChangeMap[cameraState] = params
        else
            self.dynamciChangeMap[cameraState] = nil
        end
    else
        if params.isReplace or not self.targetChangeMap[cameraState] then
            self.targetChangeMap[cameraState] = params
        end
    end
end

function DynamicChangeDistance:RemoveEffect(state)
    self.dynamciChangeMap[state] = nil
end

function DynamicChangeDistance:UpdateCameraDistance()
    for state, params in pairs(self.dynamciChangeMap) do
        self:GetNewDistance(state, params)
    end

    for state, params in pairs(self.targetChangeMap) do
        self:UpdateTargetCamerDis(state, params)
    end
end

function DynamicChangeDistance:GetNewDistance(state, params)
    local instanceId = BehaviorFunctions.GetCtrlEntity()
    local entity = BehaviorFunctions.GetEntity(instanceId)
    local rolePos = entity.clientTransformComponent.transform.position

    local target = BehaviorFunctions.GetEntity(params.targetInsId)
    local clientTransformComponent = target.clientTransformComponent
    local lookatTarget = clientTransformComponent:GetTransform(params.bindName)
    local targetPos = lookatTarget.position
    if self:IsContainPos(rolePos, targetPos) then return end

    local camera = self.cameraManager:GetCamera(state)
    local curDis = camera:GetCurCameraDistance()
    if curDis >= params.maxDis then return end
    local maxDistance = params.maxDis

    local newDis = MathX.lerp_number(curDis, maxDistance, params.time)
    newDis = math.min(newDis, maxDistance)
    camera:SetCameraDistance(newDis)
end

function DynamicChangeDistance:IsContainPos(pos1, pos2)
    local cameraComponent = self.cameraManager.mainCameraComponent
    local left = cameraComponent.rect.xMin
    local right = cameraComponent.rect.xMax
    local top = cameraComponent.rect.yMax
    local bottom = cameraComponent.rect.yMin

    local point1ScreenPos = cameraComponent:WorldToViewportPoint(pos1)
    local point2ScreenPos = cameraComponent:WorldToViewportPoint(pos2)

    local isPoint1InsideCamera = point1ScreenPos.x >= left and point1ScreenPos.x <= right and point1ScreenPos.y >= bottom and point1ScreenPos.y <= top
    local isPoint2InsideCamera = point2ScreenPos.x >= left and point2ScreenPos.x <= right and point2ScreenPos.y >= bottom and point2ScreenPos.y <= top
    return isPoint1InsideCamera and isPoint2InsideCamera
end

function DynamicChangeDistance:UpdateTargetCamerDis(state, params)
    local camera = self.cameraManager:GetCamera(state)
    local curDis = camera:GetCurCameraDistance()
    local targetDis = params.targetDis
    local allTime = params.allTime

    params.curTime = params.curTime or 0
    local curTime = params.curTime
    if curTime >= allTime then
        self.targetChangeMap[state] = nil
        return
    end

    local t = curTime / allTime
    local newDis = (1 - t) * curDis + t * targetDis
    if camera.SetCameraDistance then
        camera:SetCameraDistance(newDis)
    end
    params.curTime = params.curTime + FightUtil.deltaTimeSecond
end