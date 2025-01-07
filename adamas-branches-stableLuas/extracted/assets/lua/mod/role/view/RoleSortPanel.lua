RoleSortPanel = BaseClass("RoleSortPanel", BasePanel)

local DataHeroElement = Config.DataHeroElement.Find

local Black = Color(0 / 255, 0 / 255, 0 / 255, 1)
local White = Color(255 / 255, 255 / 255, 255 / 255, 1)

function RoleSortPanel:__init(parent)
    self:SetAsset("Prefabs/UI/Role/RoleSortPanel.prefab")
    self.elementItems = {}
end

function RoleSortPanel:__BindEvent()

end

function RoleSortPanel:__BindListener()
     
    self:BindCloseBtn(self.Cancel_btn,self:ToFunc("Close_HideCallBack"))
    self:BindCloseBtn(self.CommonBack1_btn,self:ToFunc("Close_HideCallBack"))

    self.Submit_btn.onClick:AddListener(self:ToFunc("OnClick_Sure"))
    ---选择排序
    for i = 1, 3 do
        local name = "Text" .. i .. "_txt"
        local selectName = "Select" .. i
        local onToggleFunc = function(isSelect)
            self:OnToggleFunc(i, isSelect)
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
                typeObj.Text_txt.color = White
            else
                typeObj.Text_txt.color = Black
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
    self:SetCavansLayer(4)
    
    self.TitleText_txt.text = TI18N("排序")
    if self.args and self.args.rule then
        self.sortRule = TableUtils.CopyTable(self.args.rule)
    else
        self.sortRule = {
            sortType = RoleConfig.RoleSortType.default,
            element = {},
            quality = {},
        }
    end
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
        self.blurBack = nil
    end
end

function RoleSortPanel:initSortRule()
    self["Sort"..self.sortRule.sortType.."_tog"].isOn = true
    self:OnToggleFunc(self.sortRule.sortType, true)
    for i = 4, 5 do
        local isOn = false
        for _, v in pairs(self.sortRule.quality) do
            if i == v then 
                isOn = true 
                break 
            end
        end
        self["Quality" .. i .. "_tog"].isOn = isOn
    end

    for k, elementItem in pairs(self.elementItems) do
        local isOn = false
        for _, v in pairs(self.sortRule.element) do
            if k == v then isOn = true  break end
        end
        elementItem.Toggle_tog.isOn = isOn
    end
end

function RoleSortPanel:OnToggleFunc(i, isSelect)
    local name = "Text" .. i .. "_txt"
    local selectName = "Select" .. i
    self:SelectSortRule(i, isSelect)
    if isSelect then
        self[name].color = White
    else
        self[name].color = Black
    end
    self[selectName]:SetActive(isSelect)
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
    -- UnityUtils.SetLocalScale(obj.objectTransform, 1, 1, 1)
    -- UnityUtils.SetLocalPosition(obj.objectTransform, 0, 0, 0)
    -- UtilsUI.GetContainerObject(obj.objectTransform, obj)
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