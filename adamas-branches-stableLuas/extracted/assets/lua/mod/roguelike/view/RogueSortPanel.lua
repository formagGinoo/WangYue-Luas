RogueSortPanel = BaseClass("RogueSortPanel", BasePanel)

local DataHeroElement = Config.DataHeroElement.Find

local Black = Color(64 / 255, 67 / 255, 74 / 255, 1)
local White = Color(255 / 255, 255 / 255, 255 / 255, 1)

RogueSortPanel.QualityLevel = {
    [1] = "蓝",
    [2] = "紫",
    [3] = "橙"
}

function RogueSortPanel:__init(parent)
    self:SetAsset("Prefabs/UI/WorldRogue/RogueSortPanel.prefab")
    self.elementItems = {}
    self.selectRule = nil
    self.quality = nil
end



function RogueSortPanel:__BindEvent()

end

function RogueSortPanel:__CacheObject()
    self:SetCacheMode(UIDefine.CacheMode.destroy)
end

function RogueSortPanel:__BindListener()
     
    self:BindCloseBtn(self.Cancel_btn,self:ToFunc("Close_HideCallBack"))
    self:BindCloseBtn(self.CommonBack1_btn,self:ToFunc("Close_HideCallBack"))

    self.Submit_btn.onClick:AddListener(self:ToFunc("OnClick_Sure"))
    ---选择排序
    for i = 1, 2 do
        local name = "Text" .. i .. "_txt"
        local selectNode = "Select"..i
        local onToggleFunc = function(isSelect)
            self:SelectSortRule(i, isSelect)
            self[selectNode]:SetActive(isSelect)
            if isSelect then
                self[name].color = White
            else
                self[name].color = Black
            end
        end
        self["Sort" .. i .. "_tog"].onValueChanged:RemoveAllListeners()
        self["Sort" .. i .. "_tog"].onValueChanged:AddListener(onToggleFunc)
    end

    ---选择品质
    for i = 1, 3 do
        local name = "Quality" .. i .. "Text_txt"
        local selectNode = "QualitySelect"..i
        local onToggleFunc = function(isSelect)
            if isSelect then
                self[name].color = White
            else
                self[name].color = Black
            end
            self[selectNode]:SetActive(isSelect)
            self:SelectQuality(i, isSelect)
        end
        self[name].text = self.QualityLevel[i]
        self["Quality" .. i .. "_tog"].onValueChanged:RemoveAllListeners()
        self["Quality" .. i .. "_tog"].onValueChanged:AddListener(onToggleFunc)
    end
    
end

function RogueSortPanel:__Create()

end

function RogueSortPanel:__Show()
    self.TitleText_txt.text = TI18N("排序筛选")
end

function RogueSortPanel:__ShowComplete()
    if not self.blurBack then
        local setting = { passEvent = UIDefine.BlurBackCaptureType.UI, blurRadius = 3, bindNode = self.BlurBack }
        self.blurBack = BlurBack.New(self, setting)
    end
    self.blurBack:Show()
end

function RogueSortPanel:__Hide()
    if self.blurBack then
        self.blurBack:Hide()
    end
end

function RogueSortPanel:SelectSortRule(i, isOn)
    self.selectRule = i
    if self.selectRule == 2 then
        self.Item3:SetActive(true)
        self:SelectQuality(1, true)
    else
        self.quality = nil
        self.Item3:SetActive(false)
    end
end

function RogueSortPanel:SelectQuality(i, isOn)
    self.quality = i
end

function RogueSortPanel:Close_HideCallBack()
    PanelManager.Instance:ClosePanel(self)
end

function RogueSortPanel:OnClick_Sure()
    ----- 应用新选择的规则
    EventMgr.Instance:Fire(EventName.RefreshBySort, self.quality)
    self:Close_HideCallBack()
end