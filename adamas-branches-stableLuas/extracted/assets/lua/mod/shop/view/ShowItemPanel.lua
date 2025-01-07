ShowItemPanel = BaseClass("ShowItemPanel", BasePanel)

local DataItem = Config.DataItem.Find
function ShowItemPanel:__init()
    self:SetAsset("Prefabs/UI/Common/ShowItemPanel.prefab")
end

function ShowItemPanel:__BindListener()
    self:BindCloseBtn(self.CloseButton_btn, self:ToFunc("ClosePanel"))
end

function ShowItemPanel:__BindEvent()

end

function ShowItemPanel:__delete()
    if self.value then
        self.value = nil
    end
end

function ShowItemPanel:__Hide()
    BehaviorFunctions.Resume()
end

function ShowItemPanel:__Show()
    self.value = self.args.value
    BehaviorFunctions.Pause()
    self:InitShow()
end

function ShowItemPanel:__ShowComplete()
    if not self.blurBack then
        local setting = { bindNode = self.BlurNode }
        self.blurBack = BlurBack.New(self, setting)
    end
    self.blurBack:Show()
end

function ShowItemPanel:InitShow()
    local config  = DataItem[self.value.template_id]
    self.NameTxt_txt.text = config.name
    self.DecsTxt_txt.text = config.desc
    SingleIconLoader.Load(self.AwardIcon,config.icon)
end

function ShowItemPanel:ClosePanel()
    PanelManager.Instance:ClosePanel(self)
end