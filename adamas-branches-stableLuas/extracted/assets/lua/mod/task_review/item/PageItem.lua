PageItem = BaseClass("PageItem", Module)

function PageItem:__init()
    self.object = nil
	self.node = {}
end

function PageItem:Destroy()
end

function PageItem:InitItem(object, data)
	self.object = object
    self.node = UtilsUI.GetContainerObject(self.object.transform)
	self.curData = data
	self:ShowInfo()
	self.object:SetActive(true)
end

function PageItem:ShowInfo()
	self.node.PageName_txt.text = self.curData.chapter_name --TaskReviewConfig.GetPageTitle(self.curData.type,self.curData.sec_type)
	self.node.PageName1_txt.text = self.curData.chapter_name_pin
	SingleIconLoader.Load(self.node.PageImg, self.curData.chapter_icon)
end

function PageItem:OnReset()
	
end

function PageItem:SetBtnEvent(noShowPanel, btnFunc, onClickRefresh)
	local itemBtn = self.node.PageImg_btn
	if noShowPanel and not btnFunc then
		itemBtn.enabled = false
	else
		itemBtn.enabled = true
		local onclickFunc = function()
			if btnFunc then
				btnFunc()
				if onClickRefresh then
					self:Show()
				end
				return
			end
			if not noShowPanel then ItemManager.Instance:ShowItemTipsPanel(self.itemInfo) end
		end
		itemBtn.onClick:RemoveAllListeners()
		itemBtn.onClick:AddListener(onclickFunc)
	end
end