PartnerBagSortPanel = BaseClass("PartnerBagSortPanel", BasePanel)

local Black = Color(0 / 255, 0 / 255, 0 / 255, 1)
local White = Color(255 / 255, 255 / 255, 255 / 255, 1)

local SortTypeNum = 3
local QualityNum = 5

function PartnerBagSortPanel:__init(parent)
    self:SetAsset("Prefabs/UI/PartnerBag/PartnerBagSortPanel.prefab")
    self.elementItems = {}
end

function PartnerBagSortPanel:__BindEvent()

end

function PartnerBagSortPanel:__BindListener()

    self:BindCloseBtn(self.Cancel_btn,self:ToFunc("Close_HideCallBack"))
    self:BindCloseBtn(self.CommonBack1_btn,self:ToFunc("Close_HideCallBack"))

    self.Submit_btn.onClick:AddListener(self:ToFunc("OnClick_Sure"))
    ---选择排序
    for i = 1, SortTypeNum do
        local name = "Text" .. i .. "_txt"
        local selectName = "Select" .. i
        local onToggleFunc = function(isSelect)
            self:SelectSortRule(i, isSelect)
            if isSelect then
                self[name].color = White
            else
                self[name].color = Black
            end
            self[selectName]:SetActive(isSelect)
        end
        self["Sort" .. i .. "_tog"].onValueChanged:RemoveAllListeners()
        self["Sort" .. i .. "_tog"].onValueChanged:AddListener(onToggleFunc)
    end

    ---创建职业选项 
    local partnerCareer = PartnerBagConfig.GetPartnerAllWorkCareer()
    for index, element in pairs(partnerCareer) do
        local typeObj = self.elementItems[element.id] or self:GetElementObj()
        typeObj.Text_txt.text = element.name
        if element.icon ~= "" then
            SingleIconLoader.Load(typeObj.Icon, element.icon)
        end
        
        local onClickFunc = function(isSelect)
            self:SelectElement(isSelect, element.id)
            if isSelect then
                typeObj.Text_txt.color = White
            else
                typeObj.Text_txt.color = Black
            end
            typeObj.ElementSelect:SetActive(isSelect)
        end
        typeObj.Toggle_tog.onValueChanged:RemoveAllListeners()
        typeObj.Toggle_tog.onValueChanged:AddListener(onClickFunc)
        self.elementItems[element.id] = typeObj
    end

    ---选择品质
    for i = 1, QualityNum do
        local name = "Quality" .. i .. "Text_txt"
        local selectName = "QualitySelect" .. i
        local onToggleFunc = function(isSelect)
            if isSelect then
                self[name].color = White
            else
                self[name].color = Black
            end
            self[selectName]:SetActive(isSelect)
            self:SelectQuality(isSelect, i)
        end
        self["Quality" .. i .. "_tog"].onValueChanged:RemoveAllListeners()
        self["Quality" .. i .. "_tog"].onValueChanged:AddListener(onToggleFunc)
    end
end

function PartnerBagSortPanel:__Create()

end

--缓存对象
function PartnerBagSortPanel:__CacheObject()
    self:SetCacheMode(UIDefine.CacheMode.destroy)
end

function PartnerBagSortPanel:__Show()
    local setting = { bindNode = self.BlurNode }
    self:SetBlurBack(setting)
    self.TitleText_txt.text = TI18N("排序")
    self:initSortRule()
end

function PartnerBagSortPanel:__ShowComplete()
end

function PartnerBagSortPanel:__Hide()
end

function PartnerBagSortPanel:initSortRule()
    self.sortRule = self.sortRule or {
        sortType = PartnerBagConfig.SortType.SortByQuality,
        element = {},
        quality = {},
    }
    
    local sortTog = "Sort"..self.sortRule.sortType.."_tog"
    local sortSelect = "Select"..self.sortRule.sortType
    local sortText = "Text"..self.sortRule.sortType.."_txt"
    self[sortTog].isOn = true
    self[sortSelect]:SetActive(true)
    self[sortText].color = White
    
    for i = 1, QualityNum do
        self["Quality" .. i .. "_tog"].isOn = self.sortRule.quality[i] and true or false
    end

    for id, elementItem in pairs(self.elementItems) do
        elementItem.Toggle_tog.isOn = self.sortRule.element[id] and true or false
    end
end

function PartnerBagSortPanel:SelectSortRule(key)
    self.sortRule.sortType = key
end

function PartnerBagSortPanel:SelectQuality(isSelect, key)
    if isSelect then
        self.sortRule.quality[key] = key
    else
        self.sortRule.quality[key] = nil
    end
end

function PartnerBagSortPanel:SelectElement(isSelect, key)
    if isSelect then
        self.sortRule.element[key] = key
    else
        self.sortRule.element[key] = nil
    end
end

function PartnerBagSortPanel:GetElementObj()
    local obj = self:PopUITmpObject("Element")
    obj.objectTransform:SetParent(self.ElementList.transform)
    UnityUtils.SetLocalScale(obj.objectTransform, 1, 1, 1)
    UnityUtils.SetLocalPosition(obj.objectTransform, 0, 0, 0)
    UtilsUI.GetContainerObject(obj.objectTransform, obj)
    obj.objectTransform:SetActive(true)

    return obj
end

function PartnerBagSortPanel:Close_HideCallBack()
    PanelManager.Instance:ClosePanel(self)
end

function PartnerBagSortPanel:OnClick_Sure()
    EventMgr.Instance:Fire(EventName.PartnerBagSortSubmit, self.sortRule)
    self:Close_HideCallBack()
end