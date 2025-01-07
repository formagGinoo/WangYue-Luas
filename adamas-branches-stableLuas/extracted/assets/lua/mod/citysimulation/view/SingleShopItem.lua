SingleShopItem = BaseClass("SingleShopItem")

local color = {
    ["black"] = Color(36/255, 41/255, 50/255, 1),
    ["grey"] = Color(90/255, 91/255, 104/255, 1),
    ["white"] = Color(1, 1, 1, 1),
}

-- 绑定传入对象的引用，更新数据
function SingleShopItem:UpdateData(data)
    self.transform = data.object.transform
    self.id = data.store_id
    UtilsUI.GetContainerObject(self.transform, self)
    
    self.ShopName_txt.text = data.name
    self.ResTypeName_txt.text = data.sub_name
    
    -- 切换店铺时更新显示状态和委托列表
    self.Button_btn.onClick:AddListener(function() 
        EventMgr.Instance:Fire(EventName.RefreshShopInfoArea, self.id)
    end)
end 


function SingleShopItem:SetSelectState(_isSelect)
    if _isSelect then
        self.Selected:SetActive(true)
        self.Unselected:SetActive(false)
        self.ShopName_txt.color = color["white"]
        self.ResTypeName_txt.color = color["white"]
    else
        self.Selected:SetActive(false)
        self.Unselected:SetActive(true)
        self.ShopName_txt.color = color["black"]
        self.ResTypeName_txt.color = color["grey"]
    end
end
