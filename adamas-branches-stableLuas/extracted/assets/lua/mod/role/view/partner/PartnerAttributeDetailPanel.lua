PartnerAttributeDetailPanel = BaseClass("PartnerAttributeDetailPanel", BasePanel)

local Attr2AttrPercent = EntityAttrsConfig.Attr2AttrPercent
local AttrPercent2Attr = EntityAttrsConfig.AttrPercent2Attr

local DataAttrsDefine = Config.DataAttrsDefine.Find
local DataHeroAttrShow = Config.DataHeroAttrShow.Find

--初始化
function PartnerAttributeDetailPanel:__init(parent)
    self:SetAsset("Prefabs/UI/Role/PartnerAttributeDetailPanel.prefab")
    self.attrItemList = {}
end

--添加监听器
function PartnerAttributeDetailPanel:__BindListener()
    self.CommonBack2_btn.onClick:AddListener(self:ToFunc("PlayExitAnim"))
end

--缓存对象
function PartnerAttributeDetailPanel:__CacheObject()
    self:SetCacheMode(UIDefine.CacheMode.destroy)
end
--
function PartnerAttributeDetailPanel:__Create()

end

function PartnerAttributeDetailPanel:__Show()
    self.uid = self.args.uid
    self.uniqueId = self.args.uniqueId
    self:SetAcceptInput(true)
    self.BaseAttrName_txt.text = TI18N("属性详情")
    self:UpdateData(mod.RoleCtrl:GetCurUISelectRole())
end

function PartnerAttributeDetailPanel:__delete()

end

function PartnerAttributeDetailPanel:__Hide()
    if self.blurBack then
        self.blurBack:Hide()
        self.blurBack = nil
    end
end

function PartnerAttributeDetailPanel:__ShowComplete()
    if not self.blurBack then
        local setting = { passEvent = UIDefine.BlurBackCaptureType.UI, blurRadius = 2, bindNode = self.BlurBack }
        self.blurBack = BlurBack.New(self, setting)
    end
    self:SetActive(false)
    self.blurBack:Show({ self:ToFunc("BlurComplete") })
end

function PartnerAttributeDetailPanel:BlurComplete()
    self:SetActive(true)
end

function PartnerAttributeDetailPanel:ShowUpDateTip()

end

function PartnerAttributeDetailPanel:UpdateData(heroId)
    self.heroId = heroId
    self.curRoleInfo = mod.RoleCtrl:GetRoleData(heroId,self.uid)
    self.PartnerData = mod.BagCtrl:GetPartnerData(self.uniqueId, self.uid, self.heroId)
    self:UpdateShow()
end

function PartnerAttributeDetailPanel:onRoleInfoUpdate(idx, roleData)
    if self.heroId ~= roleData.id then
        return
    end
    self.curRoleInfo = roleData
    self:UpdateShow()
end

function PartnerAttributeDetailPanel:UpdateShow()
    local roleEntity
    local entityList = Fight.Instance.playerManager:GetPlayer():GetEntityList()
    for _, entity in pairs(entityList) do
        if entity.masterId == self.heroId then
            roleEntity = entity
            break
        end
    end

    local attrTable = RoleConfig.PartnerAttrShowList(self.heroId) or {}
    local partnerData = self.PartnerData
    local partnerId = partnerData.template_id
    local attrRes = RoleConfig.GetPartnerPlateAttr(partnerData)
    local group1, group2 = 0, 0
    for index, attr in ipairs(attrTable) do
        local attrValue = RoleConfig.GetPartnerAttr(partnerId, partnerData.lev, attr) + (attrRes[attr] or 0)
        local item = self.attrItemList[index] or self:getAttributeItem()
        self.attrItemList[index] = item
        group1 = group1 + 1
        item.Bg:SetActive(group1 % 2 == 1)
        item.objectTransform:SetParent(self.BaseAttributeList.transform)
        UnityUtils.SetLocalScale(item.objectTransform, 1, 1, 1)
        if attr >= 1 and attr <= 3  and roleEntity then
            local baseAttr = roleEntity.attrComponent:GetBaseValue(attr)
            local attrPercentValue = RoleConfig.GetPartnerAttr(partnerId, partnerData.lev, attr + 20) + (attrRes[attr + 20] or 0) / 10000
            attrValue = attrValue +  math.floor(baseAttr * attrPercentValue)
        end
        item.Name_txt.text = DataAttrsDefine[attr].name
        local name, value = RoleConfig.GetShowAttr(attr, attrValue)
        item.Value_txt.text = value
        item.AddValue_txt.text = ""
    end
end

function PartnerAttributeDetailPanel:getAttributeItem()
    local obj = self:PopUITmpObject("AttributeItem")
    UtilsUI.GetContainerObject(obj.objectTransform, obj)
    UnityUtils.SetLocalPosition(obj.objectTransform, 0, 0, 0)
    obj.objectTransform:SetActive(true)
    return obj
end

function PartnerAttributeDetailPanel:__AfterExitAnim()
    PanelManager.Instance:ClosePanel(self)
end