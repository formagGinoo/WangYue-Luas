DuplicateItem = BaseClass("DuplicateItem")

local colorInfo = {
    select = Color(0, 0, 0, 1),
    def = Color(1, 1, 1, 1),
}

function DuplicateItem:__init()

end

function DuplicateItem:Destory()

end

function DuplicateItem:SetData(parent, data)
    self.item = data.obj
    self.transform = self.item.transform
    UtilsUI.GetContainerObject(self.transform, self)

	self.awardItemMap = {}
    self.parent = parent
    self.index = data.index
    self.dupId = data.dupId
    self.item:SetActive(true)
    self:UpdateView()
end

function DuplicateItem:UpdateView()
    self.DuplicateItem_btn.onClick:AddListener(self:ToFunc("GoDuplicate"))
    self.Lv_txt.text = self.index
    self.Select:SetActive(false)

    local conditionMgr = Fight.Instance.conditionManager
    local dupCfg = ResDuplicateConfig.GetDuplicateInfo(self.dupId)
    local isOpen = conditionMgr:CheckConditionByConfig(dupCfg.condition)
    self.isOpen = isOpen
    self.Lock:SetActive(not isOpen)
    self.Lv:SetActive(isOpen)
end

function DuplicateItem:UpdateSelectState(isSelect)
    self.Select:SetActive(isSelect)
    local color = isSelect and colorInfo.select or colorInfo.def
    self.Lv_txt.color = color
end

function DuplicateItem:GoDuplicate()
    local conditionMgr = Fight.Instance.conditionManager
    if not self.isOpen then
        local dupCfg = ResDuplicateConfig.GetDuplicateInfo(self.dupId)
        local desc = conditionMgr:GetConditionDesc(dupCfg.condition)
        MsgBoxManager.Instance:ShowTips(desc)
        return
    end
    self.parent:SelectDup(self.index)
end


