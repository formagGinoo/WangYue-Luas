LifeBarManager = BaseClass("LifeBarManager")

function LifeBarManager:__init(clientFight)
    self.clientFight = clientFight
    self.visible = true
    self.lifeBarMap = {}
    self.lifeBarRoot = nil
end

function LifeBarManager:__delete()
    for k, v in pairs(self.lifeBarMap) do
        v:DeleteMe()
    end

	if not UtilsBase.IsNull(self.lifeBarRoot) then
		GameObject.Destroy(self.lifeBarRoot)
	end
	self.lifeBarRoot = nil
    self.lifeBarMap = {}
end

function LifeBarManager:StartFight()
    self.lifeBarRoot = self.clientFight.assetsPool:Get("Prefabs/UI/Fight/LifeBar/LifeBarRoot.prefab")
    self.lifeBarRoot.transform:SetParent(self.clientFight.fightRootTrans)
	--UtilsUI.AddUIChild(UIDefine.canvasRoot, self.lifeBarRoot)
end

function LifeBarManager:SetLiftBarRootVisibleState(isVisible)
    self.lifeBarRoot:SetActive(isVisible)
end

function LifeBarManager:Update()
    local removeList = {}
    for k, v in pairs(self.lifeBarMap) do
        if not BehaviorFunctions.CheckEntity(k) then
            removeList[k] = true
            v:Cache()
        else
            v:Update()
        end
    end

    for k, v in pairs(removeList) do
        if self.lifeBarMap[k] then
            self.lifeBarMap[k] = nil
        end
    end
end

function LifeBarManager:ShowLifeBar(entity, leftTime)
    --临时 TODO 
    --if entity.entityId ~= 1003 and entity.entityId ~= 1004 and entity.entityId ~= 1005 then
        --return
    --end

    if not self.visible then
        return
    end

    if not self.lifeBarMap[entity.instanceId] then
        self.lifeBarMap[entity.instanceId] = {}

        local lifeBarObj = self.clientFight.fight.objectPool:Get(LifeBarObj)
        lifeBarObj:SetInitInfo(entity)
        lifeBarObj:SetLeftTime(leftTime)
        lifeBarObj:Show()

        self.lifeBarMap[entity.instanceId] = lifeBarObj
    else
        self.lifeBarMap[entity.instanceId]:SetLeftTime(leftTime)
        self.lifeBarMap[entity.instanceId]:Show()
    end
end