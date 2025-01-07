RoleAttributeDetailPanel = BaseClass("RoleAttributeDetailPanel", BasePanel)

local Attr2AttrPercent = EntityAttrsConfig.Attr2AttrPercent
local AttrPercent2Attr = EntityAttrsConfig.AttrPercent2Attr

local DataAttrsDefine = Config.DataAttrsDefine.Find
local DataPlayerAttrsDefine = Config.DataPlayerAttrsDefine.Find
local DataHeroAttrShow = Config.DataHeroAttrShow.Find

--初始化
function RoleAttributeDetailPanel:__init(parent)
    self:SetAsset("Prefabs/UI/Role/RoleAttributeDetailPanel.prefab")
    self.attrItemList = {}
end

--添加监听器
function RoleAttributeDetailPanel:__BindListener()
    self.CommonBack2_btn.onClick:AddListener(self:ToFunc("PlayExitAnim"))
end

--缓存对象
function RoleAttributeDetailPanel:__CacheObject()
    self:SetCacheMode(UIDefine.CacheMode.destroy)
end
--
function RoleAttributeDetailPanel:__Create()

end

function RoleAttributeDetailPanel:__Show()
    self:SetBlurBack()
    self.uid = self.args.uid
    self:SetAcceptInput(true)
    self:UpdateData(mod.RoleCtrl:GetCurUISelectRole())
end

function RoleAttributeDetailPanel:__delete()

end

function RoleAttributeDetailPanel:__Hide()

end

function RoleAttributeDetailPanel:__ShowComplete()

end

function RoleAttributeDetailPanel:BlurComplete()
    self:SetActive(true)
end

function RoleAttributeDetailPanel:ShowUpDateTip()

end

function RoleAttributeDetailPanel:UpdateData(heroId)
    self.heroId = heroId
    self.curRoleInfo = mod.RoleCtrl:GetRoleData(heroId,self.uid)
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
        item.object:SetActive(true)
    end

    local baseAttrs = EntityAttrsConfig.GetHeroBaseAttr(self.heroId, self.curRoleInfo.lev)
    local stageAttrs = EntityAttrsConfig.GetHeroStageAttr(self.heroId, self.curRoleInfo.stage)

    local finalAttrMap, baseAttrMap = mod.RoleCtrl:GetstaticAttr(self.heroId,self.uid)

    ---展示属性
    local group1, group2, group3 = 0, 0, 0
    for index, attrInfo in ipairs(DataHeroAttrShow) do
        local item = self.attrItemList[index] or self:getAttributeItem()
        local isPlayerAttr = false
        local attrConfig = DataAttrsDefine[attrInfo.attr_id]
        if attrConfig then
            item.Name_txt.text = attrInfo.is_show_process == 1 and attrInfo.sum_name or attrConfig.name
        else
            attrConfig = DataPlayerAttrsDefine[attrInfo.attr_id]
            isPlayerAttr = true
            item.Name_txt.text = DataPlayerAttrsDefine[attrInfo.attr_id].name
        end

        ---区分在编队中的角色， 不在编队中的角色
        ---详细属性才需要
        if attrInfo.is_show_process == 1 then
            if roleEntity and not self.uid then
                local baseValue = roleEntity.attrComponent:GetBaseValue(attrInfo.attr_id)
                item.Value_txt.text = tostring(baseValue)
                item.AddValue_txt.text = "+" .. string.format("%.1f",roleEntity.attrComponent:GetValue(attrInfo.attr_id) - baseValue)
            else
                local baseValue = baseAttrMap[attrInfo.attr_id] or 0
                local extraValue = finalAttrMap[attrInfo.attr_id] - baseValue
                item.Value_txt.text = baseValue
                item.AddValue_txt.text = "+" .. string.format("%.1f", extraValue)
            end
        else
            local value
            if isPlayerAttr then
                value = BehaviorFunctions.GetPlayerAttrVal(attrInfo.attr_id)
            elseif roleEntity and not self.uid then
                value = roleEntity.attrComponent:GetValue(attrInfo.attr_id)
            else
                local baseValue = finalAttrMap[attrInfo.attr_id] or 0
                local percent = 0
                local percentId = EntityAttrsConfig.Attr2AttrPercent[attrInfo.attr_id]
                if percentId and finalAttrMap[percentId] then
                    percent = finalAttrMap[percentId] * 0.0001
                end
                value = baseValue * (1 + percent)

            end
            if attrConfig and attrConfig.value_type == FightEnum.AttrValueType.Percent then
                if not roleEntity or self.uid then
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
        elseif attrInfo.group == 3 then
            group3 = group3 + 1
            item.Bg:SetActive(group3 % 2 == 1)
            item.objectTransform:SetParent(self.ElementAttributeList.transform)
        end
        UnityUtils.SetAnchored3DPosition(item.objectTransform, 0, 0, 0)
        
        UnityUtils.SetLocalScale(item.objectTransform, 1, 1, 1)
        self.attrItemList[index] = item
    end
    if group1 == 0 then
        UtilsUI.SetActive(self.BaseAttribute,false)
        UtilsUI.SetActive(self.BaseAttributeList,false)
    end
    if group2 == 0 then
        UtilsUI.SetActive(self.OtherAttribute,false)
        UtilsUI.SetActive(self.OtherAttributeList,false)
    end
    if group3 == 0 then
        UtilsUI.SetActive(self.ElementAttribute,false)
        UtilsUI.SetActive(self.ElementAttributeList,false)
    end
end

function RoleAttributeDetailPanel:getAttributeItem()
    local obj = self:PopUITmpObject("AttributeItem")
    UtilsUI.GetContainerObject(obj.objectTransform, obj)
    obj.objectTransform:SetActive(true)
    return obj
end

function RoleAttributeDetailPanel:__AfterExitAnim()
    self.parentWindow:ClosePanel(self)
end