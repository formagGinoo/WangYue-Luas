MonsterItem = BaseClass("MonsterItem")

function MonsterItem:__init()

end

function MonsterItem:Destory()
end

function MonsterItem:SetData(parent, data)
    self.item = data.obj
    self.transform = self.item.transform
    UtilsUI.GetContainerObject(self.transform, self)
    if not data.cfg then
        return
    end

	self.awardItemMap = {}
    self.parent = parent
    self.cfg = data.cfg
    self.item:SetActive(true)
    self:UpdateView()
end

function MonsterItem:UpdateView()
    SingleIconLoader.Load(self.Icon, self.cfg.icon)

    local lvDesc = self.cfg.level
    self.MonsterLv_txt.text = lvDesc
end



