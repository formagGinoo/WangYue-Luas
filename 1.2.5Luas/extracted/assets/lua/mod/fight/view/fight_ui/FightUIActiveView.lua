FightUIActiveView = BaseClass("FightUIActiveView",ExtendView)
FightUIActiveView.MODULE = FightFacade

function FightUIActiveView:__init()

end

function FightUIActiveView:__delete()
    EventMgr.Instance:RemoveListener(EventName.ActiveView, self:ToFunc("ActiveView"))
end

function FightUIActiveView:__CacheObject()
end

function FightUIActiveView:__BindListener()
    EventMgr.Instance:AddListener(EventName.ActiveView, self:ToFunc("ActiveView"))
end

function FightUIActiveView:__Hide()

end

function FightUIActiveView:OnLoadDone()
	self.rootNode = self.MainView.gameObject
	self.mainNode = self.MainView.PanelParent
	self.joystickNode = self.MainView.joyStickPanel.gameObject
	--self.operationNode = self.MainView.skillPanel.gameObject
end

function FightUIActiveView:ActiveView(activeType,flag)
    local node = nil
    if activeType == FightEnum.UIActiveType.Root then
        node = self.rootNode
    elseif activeType == FightEnum.UIActiveType.Main then
        node = self.mainNode
    elseif activeType == FightEnum.UIActiveType.Joystick then
        node = self.joystickNode
    elseif activeType == FightEnum.UIActiveType.Operation then
        node = self.operationNode
    end
    
    if node then
        node:SetActive(flag)
    end
end