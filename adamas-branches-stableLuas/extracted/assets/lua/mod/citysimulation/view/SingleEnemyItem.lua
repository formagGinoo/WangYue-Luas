SingleEnemyItem = BaseClass("SingleEnemyItem")

function SingleEnemyItem:UpdateData(data)
    self.obj = data.obj
    self.transform = self.obj.transform
    self.transform:SetParent(data.parent)
    self.transform.localScale = Vector3.one
    self.transform.anchoredPosition3D = Vector3.zero
    self.obj:SetActive(true)
    UtilsUI.GetContainerObject(self.transform, self)
    
    SingleIconLoader.Load(self.EnemyIcon, data.icon)
    self.EnemyLevel_txt.text = "LV." .. data.level
end 