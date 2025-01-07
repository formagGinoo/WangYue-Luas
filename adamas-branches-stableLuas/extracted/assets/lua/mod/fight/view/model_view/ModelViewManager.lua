ModelViewManager = BaseClass("ModelViewManager")

function ModelViewManager:__init(fight)
    self.worldTerrain = HWorldTerrain.Instance
    self.fight = fight
    self.sceneMap = {}
    self:LoadView(ModelViewConfig.ViewType.Role, function ()
        self:GetView(ModelViewConfig.ViewType.Role).modelRoot:SetActive(false)
    end)
    self.curView = nil
    self.viewStack = {}
end

function ModelViewManager:LoadView(type, callback)
    if not self.sceneMap[type] then
        self.sceneMap[type] = PluralModelView.New(self.fight)
        self.sceneMap[type]:LoadView(type,callback)
	elseif callback then
		callback()
    end
end

function ModelViewManager:GetView(type)
    if type then
        return self.sceneMap[type]
    else
        return self.sceneMap[ModelViewConfig.ViewType.Role]
    end
end

function ModelViewManager:ShowView(type)
    if self.curView == type then
        return
    end

    if self.CameraSettingTimer then
        LuaTimerManager.Instance:RemoveTimer(self.CameraSettingTimer)
    end

    for key, viewType in pairs(self.viewStack) do
        local view = self:GetView(viewType)
        if view.type ~= type and view.isActive then
            view:HideView(true)
        end
    end
    if #self.viewStack == 0 then
        self.worldTerrain:OnPause()
    end
    table.insert(self.viewStack, type)
    self:GetView(type):ShowView()
    self.curView = type

end

function ModelViewManager:HideView(type)
    if type == self.curView then
        self:GetView(type):HideView()
        self.curView = nil
        table.remove(self.viewStack)
        if #self.viewStack > 0 then
            self:GetView(self.viewStack[#self.viewStack]):ShowView()
            self.curView = self.viewStack[#self.viewStack]
        elseif #self.viewStack == 0 then
            self.worldTerrain:OnResume()
            self.CameraSettingTimer = LuaTimerManager.Instance:AddTimer(1, 0.5, function()
                CameraManager.Instance:SetInheritPosition(FightEnum.CameraState.Operating, true)
            end)
        end
    end
    
end

function ModelViewManager:__delete()
    for key, value in pairs(self.sceneMap) do
        value:DeleteMe()
    end
end