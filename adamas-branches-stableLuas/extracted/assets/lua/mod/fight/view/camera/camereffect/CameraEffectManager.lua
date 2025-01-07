CameraEffectManager = BaseClass("CameraEffectManager")

CameraEffectManager.EffectType = {
    DynamicDistance = 1,
    FixedEuler = 2,
}

CameraEffectManager.EffectClassByType = {
    [CameraEffectManager.EffectType.DynamicDistance] = "DynamicChangeDistance",
    [CameraEffectManager.EffectType.FixedEuler] = "FixedEuler",
}


function CameraEffectManager:__init(cameraManager)
	self.cameraManager = cameraManager
	self.fight = cameraManager.clientFight.fight
    self.effectMap = {}
	self:InitEffectData()
end

function CameraEffectManager:InitEffectData()
    for _, type in pairs(CameraEffectManager.EffectType) do
        local tempClass = CameraEffectManager.EffectClassByType[type]
        local windowClass = _G[tempClass]
        local effect = windowClass.New(self.cameraManager)
        self.effectMap[type] = effect
    end
end

function CameraEffectManager:__delete()
    for _, effect in pairs(self.effectMap) do
        effect:DeleteMe()
    end
    self.effectMap = {}
end

function CameraEffectManager:Update(lerpTime)
    for type, class in pairs(self.effectMap) do
        if class.Update then
            class:Update(lerpTime)
        end
    end
end

function CameraEffectManager:AddNewEffect(effectType, params)
    local tempClass = self.effectMap[effectType]
    if not tempClass then return end
    tempClass:AddNewData(params)
end

function CameraEffectManager:RemoveEffect(effectType, cameraState)
    local tempClass = self.effectMap[effectType]
    if not tempClass then return end
    tempClass:RemoveEffect(cameraState)
end