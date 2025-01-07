RoleSortPanel = BaseClass("RoleSortPanel", BasePanel)

local DataHeroElement = Config.DataHeroElement.Find

local Black = Color(101 / 255, 107 / 255, 117 / 255, 1)
local White = Color(255 / 255, 255 / 255, 255 / 255, 1)

function RoleSortPanel:__init(parent)
    self:SetAsset("Prefabs/UI/Role/RoleSortPanel.prefab")
    self.elementItems = {}
end

function RoleSortPanel:__BindEvent()

end

function RoleSortPanel:__BindListener()
    self:SetHideNode("CommonTipPart_Exit")
    self:BindCloseBtn(self.Cancel_btn,self:ToFunc("Close_HideCallBack"))
    self:BindCloseBtn(self.CommonBack1_btn,self:ToFunc("Close_HideCallBack"))

    self.Submit_btn.onClick:AddListener(self:ToFunc("OnClick_Sure"))
    ---选择排序
    for i = 1, 5 do
        local name = "Text" .. i .. "_txt"
        local selectName = "Select" .. i
        local onToggleFunc = function(isSelect)
            self:SelectSortRule(i, isSelect)
            if isSelect then
                self[name].color = Black
            else
                self[name].color = White
            end
            self[selectName]:SetActive(isSelect)
        end
        self["Sort" .. i .. "_tog"].onValueChanged:RemoveAllListeners()
        self["Sort" .. i .. "_tog"].onValueChanged:AddListener(onToggleFunc)
    end

    ---选择品质
    for i = 4, 5 do
        local name = "Quality" .. i .. "Text_txt"
        local selectName = "QualitySelect" .. i
        local onToggleFunc = function(isSelect)
            if isSelect then
                self[name].color = Black
            else
                self[name].color = White
            end
            self[selectName]:SetActive(isSelect)
            self:SelectQuality(isSelect, i)
        end
        self["Quality" .. i .. "_tog"].onValueChanged:RemoveAllListeners()
        self["Quality" .. i .. "_tog"].onValueChanged:AddListener(onToggleFunc)
    end

    ---创建元素选项
    for index, element in pairs(DataHeroElement) do
        local typeObj = self.elementItems[index] or self:GetElementObj()
        typeObj.Text_txt.text = element.name
        if #element.element_icon_big > 4 then
            SingleIconLoader.Load(typeObj.Icon, element.element_icon_big)
        end
        local onClickFunc = function(isSelect)
            self:SelectElement(isSelect, element.element)
            if isSelect then
                typeObj.Text_txt.color = Black
            else
                typeObj.Text_txt.color = White
            end
            typeObj.ElementSelect:SetActive(isSelect)
        end
        typeObj.Toggle_tog.onValueChanged:RemoveAllListeners()
        typeObj.Toggle_tog.onValueChanged:AddListener(onClickFunc)
        self.elementItems[index] = typeObj
    end
    local extraHeight = math.ceil(#DataHeroElement / 5) * 53
    UnityUtils.SetSizeDelata(self.Item2.transform, 950, 52 + extraHeight)
end

function RoleSortPanel:__Create()

end

function RoleSortPanel:__Show()
    self:initSortRule()
end

function RoleSortPanel:__ShowComplete()
    if not self.blurBack then
        local setting = { passEvent = UIDefine.BlurBackCaptureType.UI, blurRadius = 3, bindNode = self.BlurBack }
        self.blurBack = BlurBack.New(self, setting)
    end
    self.blurBack:Show()
end

function RoleSortPanel:__Hide()
    if self.blurBack then
        self.blurBack:Hide()
    end
end

function RoleSortPanel:initSortRule()
    self.sortRule = {
        sortType = RoleConfig.RoleSortType.default,
        element = {},
        quality = {},
    }

    self.Sort1_tog.isOn = true
    for i = 4, 5 do
        self["Quality" .. i .. "_tog"].isOn = false
    end

    for _, elementItem in pairs(self.elementItems) do
        elementItem.Toggle_tog.isOn = false
    end
end

function RoleSortPanel:ShowInfo()


end

function RoleSortPanel:SelectSortRule(key)
    self.sortRule.sortType = key
end

function RoleSortPanel:SelectQuality(isSelect, key)
    if isSelect then
        table.insert(self.sortRule.quality, key)
    else
        for index, v in pairs(self.sortRule.quality) do
            if v == key then
                table.remove(self.sortRule.quality, index)
                break
            end
        end
    end
end

function RoleSortPanel:SelectElement(isSelect, key)
    if isSelect then
        table.insert(self.sortRule.element, key)
    else
        for index, v in pairs(self.sortRule.element) do
            if v == key then
                table.remove(self.sortRule.element, index)
                break
            end
        end
    end
end

function RoleSortPanel:GetElementObj()
    local obj = self:PopUITmpObject("Element")
    obj.objectTransform:SetParent(self.ElementList.transform)
    UnityUtils.SetLocalScale(obj.objectTransform, 1, 1, 1)
    UnityUtils.SetLocalPosition(obj.objectTransform, 0, 0, 0)
    UtilsUI.GetContainerObject(obj.objectTransform, obj)
    obj.objectTransform:SetActive(true)

    return obj
end

function RoleSortPanel:Close_HideCallBack()
    self.parentWindow:UpdateRoleList({
        sortType = RoleConfig.RoleSortType.default,
        element = {},
        quality = {},
    })
    self.parentWindow:RefreshItemList()
    self:Hide()
end

function RoleSortPanel:OnClick_Sure()
    --- 应用新选择的规则
    self.parentWindow:UpdateRoleList(self.sortRule)
    self.parentWindow:RefreshItemList()
    self:Hide()
end