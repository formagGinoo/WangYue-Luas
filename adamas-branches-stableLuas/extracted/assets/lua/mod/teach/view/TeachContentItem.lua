TeachContentItem = BaseClass("TeachContentItem")
local SelectColor = {
    [1] = Color(166/255, 165/255, 165/255, 1),
    [2] = Color(57/255, 63/255, 74/255, 1),
}

function TeachContentItem:__init()

end

function TeachContentItem:SetData(parent, data)
    self.item = data.obj
    self.transform = self.item.transform
    UtilsUI.GetContainerObject(self.transform, self)
    if not data.teachData then
        return
    end
    self.isSelect = false
    self.parent = parent
    self.index = data.index
    self.data = data.teachData
    self.TeachTemp_btn.onClick:RemoveAllListeners()
    self:InitView()
    self.item:SetActive(true)
end

function TeachContentItem:InitView()
    self.TeachTemp_btn.onClick:AddListener(self:ToFunc("SelectItem"))
    UtilsUI.SetHideCallBack(self.Select_out, self:ToFunc("SelectOut"))
    self.Select:SetActive(false)
    
    local data = self.data
    local teachId = data.teachId
    local teachCfg = TeachConfig.GetTeachTypeIdCfg(teachId)
    self.TeachName_txt.text = teachCfg.teach_name
    self.TeachName_txt.color = SelectColor[1]

    self:UpdateRed()
end

function TeachContentItem:SelectItem()
    if self.isSelect or self.Select.activeSelf == true then return end
    self.isSelect = true
    self.Select:SetActive(true)
    -- self.Select_anim:Play("Select_Teach_Open", 0, 0)
    self.TeachName_txt.color = SelectColor[2]
    self.parent:SelectTeachItem(self.index, self.item)
end

function TeachContentItem:CancelSelect()
    if not self.isSelect then return end
    self.TeachName_txt.color = SelectColor[1]
    self.isSelect = false
    self.Select:SetActive(false)
    -- self.Select_anim:Play("Select_Teach_out", 0, 0)
end

function TeachContentItem:UpdateRed()
    local isRed = BehaviorFunctions.fight.teachManager:CheckShowRedByTeachId(self.data.teachId)
    self.Red:SetActive(isRed)
end

function TeachContentItem:SelectOut()
    self.Select:SetActive(false)
end