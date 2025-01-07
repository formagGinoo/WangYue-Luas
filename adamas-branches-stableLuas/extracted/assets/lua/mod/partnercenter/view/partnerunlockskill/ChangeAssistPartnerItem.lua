ChangeAssistPartnerItem = BaseClass("ChangeAssistPartnerItem")

function ChangeAssistPartnerItem:__init()

end

function ChangeAssistPartnerItem:Destory()

end
function ChangeAssistPartnerItem:OnReset()
    
end

function ChangeAssistPartnerItem:SetData(parent, data)
    self.item = data.obj
    self.transform = self.item.transform
    UtilsUI.GetContainerObject(self.transform, self)
    self.item:SetActive(true)
    self.data = data
    self.parent = parent

    self.SelectBtn_btn.onClick:AddListener(self:ToFunc("ClickSelect"))

    self:UpdateView()
end

function ChangeAssistPartnerItem:ClickSelect()
    self.parent:SelectPartnerSkill(self.data.skillId)
end

function ChangeAssistPartnerItem:UpdateView()
    local data = self.data
    local partnerId = data.template_id
    
    local partnerCfg = PartnerConfig.GetPartnerConfig(partnerId)
    if not partnerCfg then
        return
    end
end
