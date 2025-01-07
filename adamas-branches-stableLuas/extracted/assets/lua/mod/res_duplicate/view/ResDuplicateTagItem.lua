ResDuplicateTagItem = BaseClass("ResDuplicateTagItem")

local ColorType = {
    def = {name = Color(0, 0, 0, 1), desc = Color(94/255, 95/255, 99/255, 1)},
    select = {name = Color(243/255, 217/255, 184/255, 1), desc = Color(160/255, 142/255, 119/255, 1)},
}

function ResDuplicateTagItem:__init()

end

function ResDuplicateTagItem:SetData(parent, data)
    self.item = data.obj
    self.transform = self.item.transform
    UtilsUI.GetContainerObject(self.transform, self)
    if not data.cfg then
        return
    end
    self.parent = parent
    self.cfg = data.cfg
    self.index = data.index
    self.item:SetActive(true)
    self:UpdateSelectState(false)
    self:UpdateView()
end

function ResDuplicateTagItem:UpdateView()
    self.ClickBtn_btn.onClick:AddListener(self:ToFunc("ClickSelect"))
    self.ResName_txt.text = self.cfg.name
    self.ResDesc_txt.text = self.cfg.sub_name
end

function ResDuplicateTagItem:ClickSelect()
   self.parent:SelectTag(self.index)
end

function ResDuplicateTagItem:UpdateSelectState(isSelect)
    self.Select:SetActive(isSelect)
    local colorInfo = isSelect and ColorType.select or ColorType.def
    self.ResName_txt.color = colorInfo.name
    self.ResDesc_txt.color = colorInfo.desc
end

