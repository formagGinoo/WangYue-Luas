TeachTagItem = BaseClass("TeachTagItem")

local StateColor = {
    [1] = Color(1, 1, 1, 1),
    [2] = Color(114/255, 117/255, 127/255, 1),
}

function TeachTagItem:__init()

end

function TeachTagItem:SetData(parent, data)
    self.item = data.obj
    self.transform = self.item.transform
    UtilsUI.GetContainerObject(self.transform, self)
    if not data.cfg then
        return
    end
    self.parent = parent
    self.index = data.index
    self.cfg = data.cfg
    self:InitView()
    self.item:SetActive(true)
end

function TeachTagItem:InitView()
    self.TagTemp_btn.onClick:AddListener(self:ToFunc("ClickSelect"))

    local name = self.cfg.name
    self.TagName_txt.text = name

    self:UpdateIcon()
end

function TeachTagItem:UpdateIcon(isSelect)
    local Icon = isSelect and self.cfg.select_icon or self.cfg.cancel_icon
    SingleIconLoader.Load(self.Icon, Icon)
    self.Select:SetActive(isSelect)

    local color = isSelect and StateColor[1] or StateColor[2]
    self.TagName_txt.color = color
end

function TeachTagItem:ClickSelect()
    if self.isSelect then return end
    self:UpdateIcon(true)
    self.isSelect = true
    self.parent:SelectTagItem(self.index)
end

function TeachTagItem:CancelSelect()
    if not self.isSelect then return end
    self.isSelect = false
    self:UpdateIcon()
end