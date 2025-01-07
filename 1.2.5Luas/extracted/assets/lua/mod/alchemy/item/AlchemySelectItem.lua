AlchemySelectItem = BaseClass("AlchemySelectItem", Module)

function AlchemySelectItem:__init()

end

function AlchemySelectItem:__delete()

end

function AlchemySelectItem:InitItem(object, AlchemyInfo, defaultShow)
	-- 获取对应的组件
	self.object = object
	self.node = UtilsUI.GetContainerObject(self.object.transform)
	if defaultShow ~= nil then self.defaultShow = defaultShow end
	self.loadDone = true
	self.AlchemyInfo = AlchemyInfo
	self.object:SetActive(false)
    self:AddClickListener()
	self:Show()
end

function AlchemySelectItem:Show()
	if not self.loadDone then 
        return 
    end
	
    if self.defaultShow then
		self.object:SetActive(true)
	end
end

function AlchemySelectItem:AddClickListener()

end

function AlchemySelectItem:OnReset()

end