IdentityItem = BaseClass("IdentityItem", Module)

function IdentityItem:__init()
    self.object = nil
	self.isSelect = nil
	self.node = {}
    self.curItemData = {}
end

function IdentityItem:Destroy()
	
end

function IdentityItem:InitItem(object, identityInfo)
	--获取对应的组件
	self.object = object
	
    self.node = UtilsUI.GetContainerObject(self.object.transform)
	self.object:SetActive(true)
	self:SetItem(identityInfo)
	EventMgr.Instance:AddListener(EventName.IdentityChange,self:ToFunc("UpdataInfo"))
	EventMgr.Instance:AddListener(EventName.IdentitRewardRefresh,self:ToFunc("UpdataRedPoint"))
	self:Show()
end

function IdentityItem:UpdataInfo(lastId,id)
	if lastId and lastId == self.identityId then
		self:Show()
	elseif id and id == self.identityId then
		self:Show()
	end
end

function IdentityItem:UpdataRedPoint(id)
	if id and id == self.identityId then
		self:SetRedPoint()
	end
end

function IdentityItem:SetItem(identityInfo)
	self.identityId = identityInfo.id
	self.identityLv = identityInfo.lv
	self.identityConfig = IdentityConfig.GetIdentityTitleConfig(self.identityId,self.identityLv)
end

function IdentityItem:Show()
	if self.identityLv > 0 then
		UtilsUI.SetActiveByScale(self.node.UnGetTips,false)
		UtilsUI.SetActiveByScale(self.node.GetIcon,true)
		if self.identityId == mod.IdentityCtrl:GetNowIdentity().id then
			UtilsUI.SetActiveByScale(self.node.InUseTips,true)
		else
			UtilsUI.SetActiveByScale(self.node.InUseTips,false)
		end
	else
		UtilsUI.SetActiveByScale(self.node.InUseTips,false)
		UtilsUI.SetActiveByScale(self.node.UnGetTips,true)
		UtilsUI.SetActiveByScale(self.node.GetIcon,false)
	end

	self.node.IdentityName_txt.text = self.identityConfig.name
	self:SetSelect()
	self:SetRedPoint()
end

local unSelectColor = Color(0,0,0)
local selectColor = Color(1,1,1)
function IdentityItem:SetSelect()
	if self.isSelect then
		UtilsUI.SetActive(self.node.Select,true)
		self.node.IdentityName_txt.color = selectColor
	else
		UtilsUI.SetActive(self.node.Select,false)
		self.node.IdentityName_txt.color = unSelectColor
	end
end

function IdentityItem:SetRedPoint()
	local state = mod.IdentityCtrl:CheckIdentityRedPointById(self.identityId)
	UtilsUI.SetActive(self.node.RedPoint,state)
end

function IdentityItem:SetBtnEvent(noShowPanel, btnFunc, onClickRefresh)
	local itemBtn = self.node.IdentityItem_btn
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
		end
		itemBtn.onClick:RemoveAllListeners()
		itemBtn.onClick:AddListener(onclickFunc)
	end
end



function IdentityItem:OnReset()
	self.object = nil
	self.isSelect = nil
	self.node = {}
    self.curItemData = {}
	EventMgr.Instance:RemoveListener(EventName.IdentityChange,self:ToFunc("UpdataInfo"))
end