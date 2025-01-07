HeadAlertnessManager = BaseClass("HeadAlertnessManager")

function HeadAlertnessManager:__init(clientFight)
    self.clientFight = clientFight
    self.visible = true
    self.HeadAlertnessMap = {}
    self.MonsterHeadAlertnessMap = {}
    self.MonsterWarnHeadAlertnessMap = {}
    self.NpcSelectMap = {}
    self.SummonCarMap = {}
    self.HeadViewMap = {}
    self.HeadAlertnessRoot = nil
end

function HeadAlertnessManager:__delete()
    for k, v in pairs(self.HeadAlertnessMap) do
        v:Cache()
    end

    for k, v in pairs(self.MonsterHeadAlertnessMap) do
        v:Cache()
    end

    for k, v in pairs(self.MonsterWarnHeadAlertnessMap) do
        v:Cache()
    end

    for k, v in pairs(self.NpcSelectMap) do
        v:Cache()
    end

    for k, v in pairs(self.SummonCarMap) do
        v:Cache()
    end

    if not UtilsBase.IsNull(self.HeadAlertnessRoot) then
        GameObject.Destroy(self.HeadAlertnessRoot)
    end
    self.HeadAlertnessRoot = nil
    self.HeadAlertnessMap = {}
    self.MonsterHeadAlertnessMap = {}
    self.MonsterWarnHeadAlertnessMap = {}
    self.HeadViewMap = {}
    self.NpcSelectMap = {}
    self.SummonCarMap = {}
end

function HeadAlertnessManager:StartFight()
    self.HeadAlertnessRoot = self.clientFight.assetsPool:Get("Prefabs/UI/Fight/HeadAlertness/HeadAlertnessRoot.prefab")
    self.HeadAlertnessRoot.transform:SetParent(self.clientFight.fightRootTrans)

    local canvas = self.HeadAlertnessRoot:GetComponent(Canvas)
    canvas.referencePixelsPerUnit = 1
end

function HeadAlertnessManager:Update()
    if DebugClientInvoke.Cache.closeUI == true then
		return
	end

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

    for k, v in pairs(self.MonsterHeadAlertnessMap) do
        if not BehaviorFunctions.CheckEntity(k) then
            removeList[k] = true
            v:Cache()
        else
            v:Update()
        end
    end
    for k, v in pairs(self.MonsterWarnHeadAlertnessMap) do
        if not BehaviorFunctions.CheckEntity(k) then
            removeList[k] = true
            v:Cache()
        else
            v:Update()
        end
    end

    for k, v in pairs(self.NpcSelectMap) do
        if not BehaviorFunctions.CheckEntity(k) then
            removeList[k] = true
            v:Cache()
        else
            v:Update()
        end
    end

    for k, v in pairs(self.SummonCarMap) do
        if not BehaviorFunctions.CheckEntity(k) then
            removeList[k] = true
            v:Cache()
        else
            v:Update()
        end
    end
    for k, v in pairs(removeList) do
        if self.MonsterHeadAlertnessMap[k] then
            self.MonsterHeadAlertnessMap[k] = nil
        end
        if self.MonsterWarnHeadAlertnessMap[k] then
            self.MonsterWarnHeadAlertnessMap[k] = nil
        end

        if self.HeadAlertnessMap[k] then
            self.HeadAlertnessMap[k] = nil
        end

        if self.HeadViewMap[k] then
            self.HeadViewMap[k] = nil
        end

        if self.NpcSelectMap[k] then
            self.NpcSelectMap[k] = nil
        end
        if self.SummonCarMap[k] then
            self.SummonCarMap[k] = nil
        end
    end
end

-- -------------刺杀警戒值----------------
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

    
    if self.HeadViewMap[instanceId] then
        self.HeadViewMap[instanceId]:Show(false)
    end
    if self.MonsterHeadAlertnessMap[instanceId]then
        self.MonsterHeadAlertnessMap[instanceId]:Show(false)
    end
    if self.MonsterWarnHeadAlertnessMap[instanceId] then
        self.MonsterWarnHeadAlertnessMap[instanceId]:Show(false)
    end
end

function HeadAlertnessManager:ShowHeadAlertnessUI(instanceId, isShow)
    if self.HeadAlertnessMap[instanceId] then
        self.HeadAlertnessMap[instanceId]:Show(isShow)

        if isShow and self.HeadViewMap[instanceId] then
            self.HeadViewMap[instanceId]:Show(false)
        end
        if self.MonsterHeadAlertnessMap[instanceId] and isShow then
            self.MonsterHeadAlertnessMap[instanceId]:Show(false)
        end
        if isShow and self.MonsterWarnHeadAlertnessMap[instanceId] then
            self.MonsterWarnHeadAlertnessMap[instanceId]:Show(false)
        end
    end
end

function HeadAlertnessManager:SetHeadAlertnessValue(instanceId, curAlertnessValue)
    local entity = self.clientFight.fight.entityManager:GetEntity(instanceId)

    if entity and self.HeadAlertnessMap[instanceId] then
        self.HeadAlertnessMap[instanceId]:SetCurAlertnessValue(curAlertnessValue)
    end
end

-- -------------怪物警戒值----------------
function HeadAlertnessManager:CreateMonsterHeadAlertnessUI(instanceId, curAlertnessValue, maxAlertnessValue, offset, attachPoint)
    if not self.visible then
        return
    end

    local entity = self.clientFight.fight.entityManager:GetEntity(instanceId)
    if not entity then
        return
    end

    if not self.MonsterHeadAlertnessMap[instanceId] then
        self.MonsterHeadAlertnessMap[instanceId] = {}
        local HeadAlertnessObj = self.clientFight.fight.objectPool:Get(MonsterAlertnessObj)
        HeadAlertnessObj:Init(entity, self.HeadAlertnessRoot.transform, curAlertnessValue, maxAlertnessValue, offset, attachPoint)
        self.MonsterHeadAlertnessMap[instanceId] = HeadAlertnessObj
        self:ShowHeadAlertnessUI(instanceId, true)
    end

    if self.HeadViewMap[instanceId] then
        self.HeadViewMap[instanceId]:Show(false)
    end
    if self.HeadAlertnessMap[instanceId] then
        self.HeadAlertnessMap[instanceId]:Show(false)
    end
    if self.MonsterWarnHeadAlertnessMap[instanceId] then
        self.MonsterWarnHeadAlertnessMap[instanceId]:Show(false)
    end
end

function HeadAlertnessManager:ShowMonsterHeadAlertnessUI(instanceId, isShow)
    if self.MonsterHeadAlertnessMap[instanceId] then
        self.MonsterHeadAlertnessMap[instanceId]:Show(isShow)

        if isShow and self.HeadViewMap[instanceId] then
            self.HeadViewMap[instanceId]:Show(false)
        end
        if isShow and self.HeadAlertnessMap[instanceId] then
            self.HeadAlertnessMap[instanceId]:Show(false)
        end
        if isShow and self.MonsterWarnHeadAlertnessMap[instanceId] then
            self.MonsterWarnHeadAlertnessMap[instanceId]:Show(false)
        end
    end
end

function HeadAlertnessManager:SetMonsterHeadAlertnessValue(instanceId, curAlertnessValue)
    local entity = self.clientFight.fight.entityManager:GetEntity(instanceId)

    if entity and self.MonsterHeadAlertnessMap[instanceId] then
        self.MonsterHeadAlertnessMap[instanceId]:SetCurAlertnessValue(curAlertnessValue)
    end
end

-- -------------怪物警告----------------
function HeadAlertnessManager:CreateMonsterWarnHeadAlertnessUI(instanceId, curAlertnessValue, maxAlertnessValue, offset, attachPoint)
    if not self.visible then
        return
    end

    local entity = self.clientFight.fight.entityManager:GetEntity(instanceId)
    if not entity then
        return
    end

    if not self.MonsterWarnHeadAlertnessMap[instanceId] then
        self.MonsterWarnHeadAlertnessMap[instanceId] = {}
        local HeadAlertnessObj = self.clientFight.fight.objectPool:Get(MonsterWarnAlertnessObj)
        HeadAlertnessObj:Init(entity, self.HeadAlertnessRoot.transform, curAlertnessValue, maxAlertnessValue, offset, attachPoint)
        self.MonsterWarnHeadAlertnessMap[instanceId] = HeadAlertnessObj
        self:ShowHeadAlertnessUI(instanceId, true)
    end

    if self.HeadViewMap[instanceId] then
        self.HeadViewMap[instanceId]:Show(false)
    end
    if self.HeadAlertnessMap[instanceId] then
        self.HeadAlertnessMap[instanceId]:Show(false)
    end
    if self.MonsterHeadAlertnessMap[instanceId] then
        self.MonsterHeadAlertnessMap[instanceId]:Show(false)
    end
end

function HeadAlertnessManager:ShowMonsterWarnHeadAlertnessUI(instanceId, isShow)
    if self.MonsterWarnHeadAlertnessMap[instanceId] then
        self.MonsterWarnHeadAlertnessMap[instanceId]:Show(isShow)

        if isShow and self.HeadViewMap[instanceId] then
            self.HeadViewMap[instanceId]:Show(false)
        end
        if isShow and self.HeadAlertnessMap[instanceId] then
            self.HeadAlertnessMap[instanceId]:Show(false)
        end
        if self.MonsterHeadAlertnessMap[instanceId] and isShow then
            self.MonsterHeadAlertnessMap[instanceId]:Show(false)
        end
    end
end

function HeadAlertnessManager:CreateNPCSelectUI(instanceId, offset, attachPoint)
    if not self.visible then
        return
    end

    local entity = self.clientFight.fight.entityManager:GetEntity(instanceId)
    if not entity then
        return
    end

    if not self.NpcSelectMap[instanceId] then
        self.NpcSelectMap[instanceId] = {}
        local NPCSelectObj = self.clientFight.fight.objectPool:Get(NPCSelectObj)
        NPCSelectObj:Init(entity, self.HeadAlertnessRoot.transform, offset, attachPoint)
        self.NpcSelectMap[instanceId] = NPCSelectObj
        self:ShowNPCSelectUI(instanceId, true)
    end
end

function HeadAlertnessManager:ShowNPCSelectUI(instanceId, isShow)
    if self.NpcSelectMap[instanceId] then
        self.NpcSelectMap[instanceId]:Show(isShow)
        return
    end
    self:CreateNPCSelectUI(instanceId)
end

function HeadAlertnessManager:CheckNPCSelectUI(instanceId)
    if self.NpcSelectMap[instanceId] then
        return self.NpcSelectMap[instanceId]:CheckIsShow()
    end
    return false
end


function HeadAlertnessManager:CreateSummonCarUI(instanceId, offset, attachPoint)
    if not self.visible then
        return
    end

    local entity = self.clientFight.fight.entityManager:GetEntity(instanceId)
    if not entity then
        return
    end

    if not self.SummonCarMap[instanceId] then
        self.SummonCarMap[instanceId] = {}
        local SummonCarObj = self.clientFight.fight.objectPool:Get(SummonCarObj)
        SummonCarObj:Init(entity, self.HeadAlertnessRoot.transform, offset, attachPoint)
        self.SummonCarMap[instanceId] = SummonCarObj
        self:ShowSummonCarUI(instanceId, true)
    end
end

function HeadAlertnessManager:ShowSummonCarUI(instanceId, isShow)
    if self.SummonCarMap[instanceId] then
        self.SummonCarMap[instanceId]:Show(isShow)
        return
    end
    self:CreateSummonCarUI(instanceId)
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

    if self.HeadAlertnessMap[instanceId] then
        self.HeadAlertnessMap[instanceId]:Show(false)
    end
    if self.MonsterHeadAlertnessMap[instanceId] then
        self.MonsterHeadAlertnessMap[instanceId]:Show(false)
    end
    if self.MonsterWarnHeadAlertnessMap[instanceId] then
        self.MonsterWarnHeadAlertnessMap[instanceId]:Show(false)
    end
end

function HeadAlertnessManager:ShowHeadViewUI(instanceId, isShow)
    if self.HeadViewMap[instanceId] then
        self.HeadViewMap[instanceId]:Show(isShow)

        if self.HeadAlertnessMap[instanceId] and self.HeadAlertnessMap[instanceId]:isShow() then
            self.HeadAlertnessMap[instanceId]:Show(false)
        end
        if self.MonsterHeadAlertnessMap[instanceId] and self.MonsterHeadAlertnessMap[instanceId]:isShow() then
            self.MonsterHeadAlertnessMap[instanceId]:Show(false)
        end
        if isShow and self.MonsterWarnHeadAlertnessMap[instanceId] then
            self.MonsterWarnHeadAlertnessMap[instanceId]:Show(false)
        end
    end
end

function HeadAlertnessManager:SetHeadViewValue(instanceId, curViewValue)
    local entity = self.clientFight.fight.entityManager:GetEntity(instanceId)

    if entity and self.HeadViewMap[instanceId] then
        self.HeadViewMap[instanceId]:SetCurViewValue(curViewValue)
    end
end