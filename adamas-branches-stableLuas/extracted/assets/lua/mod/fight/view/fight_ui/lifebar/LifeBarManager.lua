LifeBarManager = BaseClass("LifeBarManager")

function LifeBarManager:__init(clientFight)
    self.clientFight = clientFight
    self.visible = true
    self.lifeBarMap = {}
    self.removeList = {}
    self.lifeBarRoot = nil
    EventMgr.Instance:AddListener(EventName.RemoveEntity, self:ToFunc("OnRemoveLifeBar"))
    EventMgr.Instance:AddListener(EventName.CloseAllUI, self:ToFunc("CloseAllUI"))
end

function LifeBarManager:__delete()
	if not UtilsBase.IsNull(self.lifeBarRoot) then
		GameObject.Destroy(self.lifeBarRoot)
	end
	self.lifeBarRoot = nil
    self.lifeBarMap = {}
    EventMgr.Instance:RemoveListener(EventName.RemoveEntity, self:ToFunc("OnRemoveLifeBar"))
    EventMgr.Instance:RemoveListener(EventName.CloseAllUI, self:ToFunc("CloseAllUI"))

end

function LifeBarManager:StartFight()
    self.lifeBarRoot = self.clientFight.assetsPool:Get("Prefabs/UI/Fight/LifeBar/LifeBarRoot.prefab")
    self.lifeBarRoot.transform:SetParent(self.clientFight.fightRootTrans)
end

function LifeBarManager:SetLiftBarRootVisibleState(isVisible)
    UtilsUI.SetActive(self.lifeBarRoot, isVisible)
end

function LifeBarManager:GetLifeBarRootVisibleState()
    return self.lifeBarRoot.activeSelf
end

function LifeBarManager:CloseAllUI()
    -- PV专用
	if DebugClientInvoke.Cache.closeUI == true then
		UtilsUI.SetActiveByScale(self.lifeBarRoot,false)
		return
	else
		UtilsUI.SetActiveByScale(self.lifeBarRoot,true)
	end
end


function LifeBarManager:Update()
    for k, v in pairs(self.removeList) do
        if self.lifeBarMap[k] then
            self.lifeBarMap[k] = nil
            self.removeList[k] = nil
        end
    end
    for k, v in pairs(self.lifeBarMap) do
        v:Update()
    end
end


function LifeBarManager:ShowLifeBar(entity, lifeBarObj)
    if not self.lifeBarMap[entity.instanceId] then
        self.lifeBarMap[entity.instanceId] = {}
        self.lifeBarMap[entity.instanceId] = lifeBarObj
        
    end
end

function LifeBarManager:OnRemoveLifeBar(instanceId)
    for k, v in pairs(self.lifeBarMap) do
        if k == instanceId then
            self.removeList[k] = true
            return
        end
    end
end

function LifeBarManager:ClearLifeBarMap()
    TableUtils.ClearTable(self.lifeBarMap)
end