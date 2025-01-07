FixedEuler = BaseClass("FixedEuler")

function FixedEuler:__init(cameraManager)
	self.cameraManager = cameraManager
	self.fight = cameraManager.clientFight.fight
    self.fixedEulerData = nil
end

function FixedEuler:Update()
    self:UpdateEulerData()
end

function FixedEuler:__delete()
end

function FixedEuler:AddNewData(params)
    local curCamera = self.cameraManager:GetCurActiveCamera()
    local lockingPOV = CinemachineInterface.GetCinemachinePOV(curCamera.transform)
    if not lockingPOV then return end

    self.fixedEulerData = params
    self.fixedEulerData.curTime = 0

    local axisV = lockingPOV.m_VerticalAxis
    self.fixedEulerData.startVVal = axisV.Value

    local axisH = lockingPOV.m_HorizontalAxis
    self.fixedEulerData.startHVal = axisH.Value

end

function FixedEuler:RemoveEffect()
end

function FixedEuler:UpdateEulerData()
    if not self.fixedEulerData then
        return
    end
	local curCamera = self.cameraManager:GetCurActiveCamera()
    local lockingPOV = CinemachineInterface.GetCinemachinePOV(curCamera.transform)
    if not lockingPOV then return end

    local data = self.fixedEulerData
    local curTime = data.curTime
    local allTime = data.allTime
    if curTime > allTime then
        self.fixedEulerData = nil
        return
    end

    local timeScale = self.cameraManager:GetMainRoleTimeScale()
    data.curTime = data.curTime + FightUtil.deltaTimeSecond * timeScale
    local t = data.curTime / allTime
    -- 垂直
    local axisV = lockingPOV.m_VerticalAxis
    if data.verticalVal then
        local val = (1 - t) * data.startVVal + t * data.verticalVal
        axisV.Value = val
        lockingPOV.m_VerticalAxis = axisV
    end

    -- 水平
    local axisH = lockingPOV.m_HorizontalAxis
    if data.horizontalVal then
        local val = (1 - t) * data.startHVal + t * data.horizontalVal
        axisH.Value = val
        lockingPOV.m_HorizontalAxis = axisH
    end

end
