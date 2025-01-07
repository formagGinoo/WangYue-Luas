UnlockPartnerItem = BaseClass("UnlockPartnerItem")
function UnlockPartnerItem:__init()

end

function UnlockPartnerItem:SetData(parent, partnerData)
    self.item = partnerData.obj
    self.transform = self.item.transform
    self:InitContainerObjList()
    if not partnerData.data then
        self.Content:SetActive(false)
        return
    end
    self.parent = parent
    self.index = partnerData.index
    self:InitView()
    self:UpdatePartnerInfo(partnerData.data)
    self.item:SetActive(true)
    self.Content:SetActive(true)
end

function UnlockPartnerItem:InitView()
    self.SelectBtn_btn.onClick:AddListener(self:ToFunc("ClickSelect"))

    self.DefBg:SetActive(false)
    self.Select:SetActive(false)

    self:SetColor()
end

function UnlockPartnerItem:InitContainerObjList()
    local uiContainer = self.transform:GetComponent(UIContainer)
    if uiContainer then
        local listName = uiContainer.ListName
        local listObjects = uiContainer.ListObj

        local listCompName = uiContainer.ListCompName
        local listCompObjects = uiContainer.ListComponent

        for i = 0, listName.Count - 1 do
            local name = listName[i]
            self[name] = listObjects[i]
        end

        for i = 0, listCompName.Count - 1 do
            local name = listCompName[i]
            self[name] = listCompObjects[i]
        end
    end
end

function UnlockPartnerItem:UpdatePartnerInfo(partner)
    local partnerCfg = ItemConfig.GetItemConfig(partner.partnerId)
    self.PartnerName_txt.text = partnerCfg.name
    SingleIconLoader.Load(self.PartnerIcon, partnerCfg.head_icon)
    self.PartnerLv_txt.text = "LV."..partner.lev

    local skillId = partner.skillId
    local skillCfg = RoleConfig.GetPartnerSkillConfig(skillId)
    self.SkillName_txt.text = skillCfg.name.."LV."..partner.skillLv
    SingleIconLoader.Load(self.SkillIcon, skillCfg.icon)
    self.Lv_txt.text = partner.skillLv
end

function UnlockPartnerItem:SelectObj()
    self.DefBg:SetActive(true)
    self.Select:SetActive(true)
    self:SetColor(true)
end

function UnlockPartnerItem:ClickSelect()
    self.DefBg:SetActive(true)
    self.parent:OnClickPartner(self.index)
    self:SetColor(true)
end

function UnlockPartnerItem:CancelSelect()
    self.DefBg:SetActive(false)
    self:SetColor()
end

function UnlockPartnerItem:SetColor(isSelect)
    local color = isSelect and UnlockConfig.SelectPartnerColor[1] or UnlockConfig.SelectPartnerColor[2]
    self.PartnerName_txt.color = color
    self.SkillName_txt.color = color
end