DuplicateMonsterItem = BaseClass("DuplicateMonsterItem")

function DuplicateMonsterItem:__init()

end

function DuplicateMonsterItem:Destory()

end

function DuplicateMonsterItem:SetData(parent, itemData)
    self.item = itemData.obj
    self.transform = self.item.transform
    UtilsUI.GetContainerObject(self.transform, self)
    if not itemData.data then
        return
    end
    
    self.parent = parent
	self.data = itemData.data
    self.item:SetActive(true)
    self:UpdateView()
end

function DuplicateMonsterItem:UpdateView()
    SingleIconLoader.Load(self.Icon, self.data.icon)

    local lvDesc = self.data.level
    self.MonsterLv_txt.text = lvDesc
end


