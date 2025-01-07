HeadAlertnessManager = BaseClass("HeadAlertnessManager")

function HeadAlertnessManager:__init(clientFight)
    self.clientFight = clientFight
    self.visible = true
    self.HeadAlertnessMap = {}
    self.HeadViewMap = {}
    self.HeadAlertnessRoot = nil
end

function HeadAlertnessManager:__delete()
    for k, v in pairs(self.HeadAlertnessMap) do
        v:Cache()
    end

    if not UtilsBase.IsNull(self.HeadAlertnessRoot) then
        GameObject.Destroy(self.HeadAlertnessRoot)
    end
    self.HeadAlertnessRoot = nil
    self.HeadAlertnessMap = {}
    self.HeadViewMap = {}
end

function HeadAlertnessManager:StartFight()
    self.HeadAlertnessRoot = self.clientFight.assetsPool:Get("Prefabs/UI/Fight/HeadAlertness/HeadAlertnessRoot.prefab")
    self.HeadAlertnessRoot.transform:SetParent(self.clientFight.fightRootTrans)

    local canvas = self.HeadAlertnessRoot:GetComponent(Canvas)
    canvas.referencePixelsPerUnit = 1
end

function HeadAlertnessManager:Update()
    local removeList = {}
    for k, v in pairs(self.HeadAlertnessMap) do
        if not BehaviorFunctions.CheckEntity(k) then
            removeList[k] = true
            v:Cache()
        else
            v:Update()
        end
    end

    for k, v in pairs(self.HeadViewMap) do
        if not BehaviorFunctions.CheckEntity(k) then
            removeList[k] = true
            v:Cache()
        else
            v:Update()
        end
    end

    for k, v in pairs(removeList) do
        if self.HeadAlertnessMap[k] then
            self.HeadAlertnessMap[k] = nil
        end

        if self.HeadViewMap[k] then
            self.HeadViewMap[k] = nil
        end
    end
end

-- -------------警戒值----------------
function HeadAlertnessManager:CreateHeadAlertnessUI(instanceId, curAlertnessValue, maxAlertnessValue)
    if not self.visible then
        return
    end

    local entity = self.clientFight.fight.entityManager:GetEntity(instanceId)
    if not entity then
        return
    end

    if not self.HeadAlertnessMap[instanceId] then
        self.HeadAlertnessMap[instanceId] = {}
        local HeadAlertnessObj = self.clientFight.fight.objectPool:Get(ArcAlertnessObj)
        HeadAlertnessObj:Init(entity, self.HeadAlertnessRoot.transform, curAlertnessValue, maxAlertnessValue)
        self.HeadAlertnessMap[instanceId] = HeadAlertnessObj
        self:ShowHeadAlertnessUI(instanceId, true)
    end
end

function HeadAlertnessManager:ShowHeadAlertnessUI(instanceId, isShow)
    if self.HeadAlertnessMap[instanceId] then
        self.HeadAlertnessMap[instanceId]:Show(isShow)

        if isShow and self.HeadViewMap[instanceId] then
            self.HeadViewMap[instanceId]:Show(false)
        end
    end
end

function HeadAlertnessManager:SetHeadAlertnessValue(instanceId, curAlertnessValue)
    local entity = self.clientFight.fight.entityManager:GetEntity(instanceId)

    if entity and self.HeadAlertnessMap[instanceId] then
        self.HeadAlertnessMap[instanceId]:SetCurAlertnessValue(curAlertnessValue)
    end
end

-- -------------视野----------------
function HeadAlertnessManager:CreateHeadViewUI(instanceId, curViewValue, maxViewValue)
    if not self.visible then
        return
    end

    local entity = self.clientFight.fight.entityManager:GetEntity(instanceId)
    if not entity then
        return
    end

    if not self.HeadViewMap[instanceId] then
        self.HeadViewMap[instanceId] = {}
        local HeadViewObj = self.clientFight.fight.objectPool:Get(DiamondViewObj)
        HeadViewObj:Init(entity, self.HeadAlertnessRoot.transform, curViewValue, maxViewValue)
        self.HeadViewMap[instanceId] = HeadViewObj
        self.HeadViewMap[instanceId]:Show(instanceId, true)
    end
end

function HeadAlertnessManager:ShowHeadViewUI(instanceId, isShow)
    if self.HeadViewMap[instanceId] then
        self.HeadViewMap[instanceId]:Show(isShow)

        if self.HeadAlertnessMap[instanceId] and self.HeadAlertnessMap[instanceId]:isShow() then
            self.HeadViewMap[instanceId]:Show(false)
        end
    end
end

function HeadAlertnessManager:SetHeadViewValue(instanceId, curViewValue)
    local entity = self.clientFight.fight.entityManager:GetEntity(instanceId)

    if entity and self.HeadViewMap[instanceId] then
        self.HeadViewMap[instanceId]:SetCurViewValue(curViewValue)
    end
end