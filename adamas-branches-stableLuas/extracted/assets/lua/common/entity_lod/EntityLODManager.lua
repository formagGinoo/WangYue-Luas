EntityLODManager = SingleClass("EntityLODManager")

function EntityLODManager:__init()
    local EntityLODRoot = GameObject("EntityLODRoot")
    local EntityLODRootTransform = EntityLODRoot.transform
    GameObject.DontDestroyOnLoad(EntityLODRootTransform)
    self.EntityLODManager = EntityLODRoot:AddComponent(CS.EntityLODManager)
end

function EntityLODManager:OnCreateEntity(instanceId, transform, access)
    self.EntityLODManager:OnCreateEntity(instanceId, transform, access)
end

function EntityLODManager:OnRemoveEntity(instanceId)
    self.EntityLODManager:OnRemoveEntity(instanceId)
end

function EntityLODManager:SetReferenceId(instanceId)
    self.EntityLODManager:SetReferenceId(instanceId)
end

function EntityLODManager:OnReLoad()
    self.EntityLODManager:OnReLoad()
end

--设置新的位置后，立刻触发一次更新
function EntityLODManager:Async(instanceId)
    self.EntityLODManager:Async(instanceId)
end