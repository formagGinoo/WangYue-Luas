RoleAttributeDetailPanel = BaseClass("RoleAttributeDetailPanel", BasePanel)

local Attr2AttrPercent = EntityAttrsConfig.Attr2AttrPercent
local AttrPercent2Attr = EntityAttrsConfig.AttrPercent2Attr

local DataAttrsDefine = Config.DataAttrsDefine.Find
local DataHeroAttrShow = Config.DataHeroAttrShow.Find

--初始化
function RoleAttributeDetailPanel:__init(parent)
    self:SetAsset("Prefabs/UI/Role/RoleAttributeDetailPanel.prefab")
    self.attrItemList = {}
end

--添加监听器
function RoleAttributeDetailPanel:__BindListener()
    self:SetHideNode("RoleAttributeDetailPanel_Eixt")
    self:BindCloseBtn(self.CommonBack2_btn,self:ToFunc("Close_HideCallBack"))
end

--缓存对象
function RoleAttributeDetailPanel:__CacheObject()
    self:SetCacheMode(UIDefine.CacheMode.hide)
end
--
function RoleAttributeDetailPanel:__Create()

end

function RoleAttributeDetailPanel:__delete()

end

function RoleAttributeDetailPanel:__Hide()
    if self.blurBack then
        self.blurBack:Hide()
    end
end

function RoleAttributeDetailPanel:__ShowComplete()
    if not self.blurBack then
        local setting = { passEvent = UIDefine.BlurBackCaptureType.UI, blurRadius = 2, bindNode = self.BlurBack }
        self.blurBack = BlurBack.New(self, setting)
    end
    self:SetActive(false)
    self.blurBack:Show({ self:ToFunc("BlurComplete") })
end

function RoleAttributeDetailPanel:BlurComplete()
    self:SetActive(true)
end

function RoleAttributeDetailPanel:__Show()
    self:SetAcceptInput(true)
    self:UpdateData(mod.RoleCtrl:GetCurUISelectRole())
end

function RoleAttributeDetailPanel:ShowUpDateTip()

end

function RoleAttributeDetailPanel:UpdateData(heroId)
    self.heroId = heroId
    self.curRoleInfo = mod.RoleCtrl:GetRoleData(heroId)
    self:UpdateShow()
end

function RoleAttributeDetailPanel:onRoleInfoUpdate(idx, roleData)
    if self.heroId ~= roleData.id then
        return
    end
    self.curRoleInfo = roleData
    self:UpdateShow()
end

function RoleAttributeDetailPanel:UpdateShow()
    ---@type Entity
    local roleEntity
    local entityList = Fight.Instance.playerManager:GetPlayer():GetEntityList()
    for _, entity in pairs(entityList) do
        if entity.masterId == self.heroId then
            roleEntity = entity
            break
        end
    end

    for k, item in pairs(self.attrItemList) do
        item.object:SetActive(false)
    end

    local baseAttrs = EntityAttrsConfig.GetHeroBaseAttr(self.heroId, self.curRoleInfo.lev)
    local stageAttrs = EntityAttrsConfig.GetHeroStageAttr(self.heroId, self.curRoleInfo.stage)
    ---展示属性
    local group1, group2 = 0, 0
    for index, attrInfo in ipairs(DataHeroAttrShow) do
        local item = self.attrItemList[index] or self:getAttributeItem()
        item.Name_txt.text = attrInfo.is_show_process == 1 and attrInfo.sum_name or DataAttrsDefine[attrInfo.attr_id].name

        ---区分在编队中的角色， 不在编队中的角色
        ---详细属性才需要
        if attrInfo.is_show_process == 1 then
            if roleEntity then
                local baseValue = roleEntity.attrComponent:GetBaseValue(attrInfo.attr_id)
                item.Value_txt.text = tostring(baseValue)
                item.AddValue_txt.text = "+" .. (roleEntity.attrComponent:GetValue(attrInfo.attr_id) - baseValue)
            else
                local baseValue = baseAttrs[attrInfo.attr_id] + (stageAttrs[attrInfo.attr_id] or 0)
                item.Value_txt.text = baseValue
                local percentId = Attr2AttrPercent[attrInfo.attr_id]
                item.AddValue_txt.text = "+" .. baseValue * (baseAttrs[percentId] + (stageAttrs[percentId] or 0))
            end
        else
            local value
            if roleEntity then
                value = roleEntity.attrComponent:GetValue(attrInfo.attr_id)
            else
                value = baseAttrs[attrInfo.attr_id] + (stageAttrs[attrInfo.attr_id] or 0)
            end
            if DataAttrsDefine[attrInfo.attr_id] and DataAttrsDefine[attrInfo.attr_id].value_type == FightEnum.AttrValueType.Percent then
                if not roleEntity then
                    value = value * 0.0001
                end
                item.Value_txt.text = (value * 100) .. "%"
            else
                item.Value_txt.text = value
            end
            item.AddValue_txt.text = ""
        end
        --放入不同的位置
        if attrInfo.group == 1 then
            group1 = group1 + 1
            item.Bg:SetActive(group1 % 2 == 1)
            item.objectTransform:SetParent(self.BaseAttributeList.transform)
        elseif attrInfo.group == 2 then
            group2 = group2 + 1
            item.Bg:SetActive(group2 % 2 == 1)
            item.objectTransform:SetParent(self.OtherAttributeList.transform)
        end
        UnityUtils.SetLocalScale(item.objectTransform, 1, 1, 1)
        self.attrItemList[index] = item
    end
end

function RoleAttributeDetailPanel:getAttributeItem()
    local obj = self:PopUITmpObject("AttributeItem")
    UtilsUI.GetContainerObject(obj.objectTransform, obj)
    UnityUtils.SetLocalPosition(obj.objectTransform, 0, 0, 0)
    obj.objectTransform:SetActive(false)
    return obj
end

function RoleAttributeDetailPanel:Close_HideCallBack()
    self:Hide()
end