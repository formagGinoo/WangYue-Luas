BindObjBase = BaseClass("BindObjBase", PoolBaseClass)
BindObjBase.DistanceThreshold = {
    [0] = 40^2,--开始高频刷新
    [1] = 10^2,
    [2] = 10^2,
    [3] = 20^2,
    [4] = 30^2
}

local DistanceThreshold = BindObjBase.DistanceThreshold

function BindObjBase:__init()
    self.bindChildObjManage = Fight.Instance.clientFight.bindChildObjManage
    self.timer = 0
    self.cacheData = nil
    self.headUpdateComp = nil
end

function BindObjBase:LoadInfoObj(instanceId)
    self.instanceId = instanceId
    local isGet, object = self:GetObject()
    if isGet then
        self:OnLoadDone(object)
    end
end

function BindObjBase:GetObject()
end

function BindObjBase:OnLoadDone(obj)
    local entity = BehaviorFunctions.GetEntity(self.instanceId)
    if not entity then
        self.bindChildObjManage:DestoryObj(self.instanceId, self.type)
        return
    end

    local parent = Fight.Instance.clientFight.headInfoManager:GetRoot()
    obj.transform:SetParent(parent.transform)
    self.gameObject = obj

    local bindName = self.data[1]
    self.headUpdateComp = obj:GetComponent(HeadInfoUpdate)
    self.headUpdateComp:Init(entity.clientEntity.clientTransformComponent.transform, DistanceThreshold[4], bindName)

    self.node = UtilsUI.GetContainerObject(self.gameObject.transform)
    if self.cacheData then
        self:InitView(self.cacheData)
    end
end

function BindObjBase:Destory()
    self.bindChildObjManage:DestoryObj(self.instanceId, self.type)
end

function BindObjBase:InitData(data, type)
    self.data = data
    self.cacheData = data
    self.type = type
    self:InitView(self.cacheData)
end

function BindObjBase:InitView(data)
end

local parent
local tempVec3 = Vec3.New()
function BindObjBase:Update()
    if not self.gameObject then return end

    local entity = BehaviorFunctions.CheckEntity(self.instanceId)
    if not entity then
        self:Destory()
        return
    end

    self.timer = self.timer - FightUtil.deltaTimeSecond
    if self.timer > 0 then
        return
    end

    local distancePower = 0
    if self.headUpdateComp then
        distancePower = self.headUpdateComp:CustomUpdate()
    end

    if distancePower > HeadInfoObj.DistanceThreshold[0] then
        self.timer = 1
    else
        self.timer = 0
    end
    self:UpdateShow(distancePower)
end

function BindObjBase:UpdateShow(distancePower)
end

function BindObjBase:OnReset()
end