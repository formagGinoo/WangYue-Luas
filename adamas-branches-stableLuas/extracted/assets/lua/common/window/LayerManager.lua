LayerManager = SingleClass("LayerManager")
function LayerManager:__init()
    self.layerCount = 0
    self.whiteList = {"GuideMaskPanel", }
    EventMgr.Instance:AddListener(EventName.ActionInput, self:ToFunc("ActionInputBack"))
end

function LayerManager:__delete()
    EventMgr.Instance:RemoveListener(EventName.ActionInput, self:ToFunc("ActionInputBack"))
end

function LayerManager:ActionInputBack(key, value)
    if key == FightEnum.KeyEvent.Back then
        if self.canNotBack == true then
            return
        end
        local maxOrder = 0
        local maxView = nil
        for panelName, panel in pairs(PanelManager.Instance.panelList) do
            for _, whiteListPanel in pairs(self.whiteList) do
                if whiteListPanel == panelName then
                    goto continue
                end
            end
            if maxOrder < panel:GetOrderId() then
                maxOrder = panel:GetOrderId()
                maxView = panel
            end
            ::continue::
        end
        for windowName, window in pairs(WindowManager.Instance.windows) do
            
            for panelName, panel in pairs(window.panelList) do
                if maxOrder < panel:GetOrderId() and panel:IsAcceptInput() == true then
                    maxOrder = panel:GetOrderId()
                    maxView = panel
                end
            end

            if maxOrder < window:GetOrderId() then
                maxOrder = window:GetOrderId()
                maxView = window
            end
        end
        maxView:CloseByCommand()
    end
end