PartnerSkillUnLockResItem = BaseClass("PartnerSkillUnLockResItem")

local colorVal = {
    [1] = Color(77/255, 82/255, 87/255, 1),
    [2] = Color(203/255, 90/255, 90/255, 1),
}

function PartnerSkillUnLockResItem:__init()

end

function PartnerSkillUnLockResItem:Destory()
    PoolManager.Instance:Push(PoolType.class, "CommonItem", self.awardItem.awardItem)
    GameObject.Destroy(self.awardItem.obj)
end

function PartnerSkillUnLockResItem:OnReset()
    
end

function PartnerSkillUnLockResItem:SetData(parent, data)
    self.item = data.obj
    self.transform = self.item.transform
    UtilsUI.GetContainerObject(self.transform, self)
    self.item:SetActive(true)

    self.partner = parent
    self.data = data
    self:UpdateView()
end

function PartnerSkillUnLockResItem:UpdateView()
    local itemId = self.data.resId
    local needNum = self.data.num

    local itemCfg = ItemConfig.GetItemConfig(itemId)

    local awardItem = PoolManager.Instance:Pop(PoolType.class, "CommonItem")
    if not awardItem then
        awardItem = CommonItem.New()
    end 

    local itemInfo = {template_id = itemId, scale = 1}
    awardItem:InitItem(self.CommonItem, itemInfo, true)
    self.awardItem = {awardItem = awardItem, obj = self.CommonItem}
    local itemNum = mod.BagCtrl:GetItemCountById(itemId)
    local color = itemNum >= needNum and "FFFFFF" or "FF0000"
    local desc = string.format("<color=#%s>%s</color>", color, itemNum)
    self.ShowNum_txt.text = desc .. "/" .. needNum
end
