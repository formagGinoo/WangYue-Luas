-- 这里主要是做一个比较轻量的管理器，没有使用HeadInfoManager是因为那边的比较复杂
BindChildObjManage = BaseClass("BindChildObjManage")

BindChildObjManage.ShowType = {
    Icon = 1,
}

BindChildObjManage.TypeClass = {
    [BindChildObjManage.ShowType.Icon] = {"BindIconObj", BindIconObj}
}

function BindChildObjManage:__init(clientFight)
    self.clientFight = clientFight

    self.headInfoMap = {}
    self.iconObjMap = {}
end

function BindChildObjManage:__delete()

end

function BindChildObjManage:StartFight()
    if not self.clientFight then
        self.clientFight = Fight.Instance.clientFight
    end
    local hadeInfoMgr = self.clientFight.headInfoManager
    self.headInfoRoot = hadeInfoMgr.headInfoRoot
    if not self.headInfoRoot then
        LogError("缺少头部信息对象父节点")
    end
end

function BindChildObjManage:Update()
    for _, class in pairs(self.iconObjMap) do
        class:Update()
    end
end

function BindChildObjManage:DeleteMe()
    for k, v in pairs(self.iconObjMap) do
        v:DeleteMe()
    end
    self.iconObjMap = {}
end

function BindChildObjManage:ShowTypeObj(instanceId, type, params)
    local list = self:GetTypeList(type)
    if not list[instanceId] then
        self:CreateObj(instanceId, type)
    end

    if params then
        list[instanceId]:InitData(params, type)
    end
end

function BindChildObjManage:HideTypeObj(instanceId, type)
    self:DestoryObj(instanceId, type)
end

function BindChildObjManage:GetTypeList(type)
    if type == BindChildObjManage.ShowType.Icon then
        return self.iconObjMap
    end
end

function BindChildObjManage:CreateObj(instanceId, type)
    local list = self:GetTypeList(type)

    if not list[instanceId] then
        list[instanceId] = self:GetObjInfo(type)
        list[instanceId]:LoadInfoObj(instanceId)
    end
end

function BindChildObjManage:GetObjInfo(type)
    local classData = BindChildObjManage.TypeClass[type]
    local className = classData[1]
    local class = classData[2]

    local infoTmp = PoolManager.Instance:Pop(PoolType.class, className)
    if not infoTmp then
        infoTmp = class.New(self)
    end
    return infoTmp
end

function BindChildObjManage:DestoryObj(instanceId, type)
    local list = self:GetTypeList(type)
    if list and list[instanceId] then
        self:PushHeadInfoToPool(type, list[instanceId])
        list[instanceId] = nil
    end
end

function BindChildObjManage:PushHeadInfoToPool(type, class)
    local classData = BindChildObjManage.TypeClass[type]
    local className = classData[1]
    PoolManager.Instance:Push(PoolType.class, className, class)
end