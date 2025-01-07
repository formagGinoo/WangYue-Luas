GameSetWindow = BaseClass("GameSetWindow", BaseWindow)

function GameSetWindow:__init()
    self:SetAsset("Prefabs/UI/Role/CommonMainWindow2.prefab")
end


function GameSetWindow:__BindListener()
    self:SetHideNode("CommonMainWindow_Exit")
    self:BindCloseBtn(self.CommonBack2_btn, self:ToFunc("HideCallback"), self:ToFunc("OnClick_Close"))
end


function GameSetWindow:__Hide()
 
end

function GameSetWindow:__Show()
    self.curTag = GameSetConfig.PanelType.Volume
    self.GoldCurrencyBar:SetActive(false)
    self:CreatePanel()
end


function GameSetWindow:CreatePanel()
    local uniqueId = self.uniqueId
    local callback = function ()
        self:InitTag(uniqueId)
    end

    self:OpenPanel(CommonLeftTabPanel, {
        name = TI18N("设置"), name2 = "shezhi", 
        tabList = GameSetConfig.PanelToggle, callback = callback, notDelay = true})
end

function GameSetWindow:InitTag()
    self:GetPanel(CommonLeftTabPanel):SelectType(self.curTag)
end



function GameSetWindow:HideCallback()
    WindowManager.Instance:CloseWindow(self)
end