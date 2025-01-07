CommonMail = BaseClass("CommonMail", Module)

function CommonMail:__init()
	self.object = nil
	self.mailInfo = nil
	self.node = {}
	self.isSelect = false
	self.isRead = false
	self.loadDone = false
	self.defaultShow = true
end

function CommonMail:InitMail(object, mailInfo)
	-- 获取对应的组件
	self.object = object
	self.node = UtilsUI.GetContainerObject(self.object.transform)
	
	self.loadDone = true

	self.mailInfo = mailInfo

	self.isRead = mailInfo.read_flag == 1
	self.isRecevie = mailInfo.reward_flag == 1
	EventMgr.Instance:AddListener(EventName.MailRead, self:ToFunc("RefreshRedPoint"))
	EventMgr.Instance:AddListener(EventName.MailGetAward, self:ToFunc("RefreshRecevie"))
	self:Show()
end

function CommonMail:Show()
	if not self.loadDone then return end
	self:SetSelectBox()
	self:SetTitle()
	self:SetIcon()
	self:SetTime()
	self:SetRedPoint()

	if self.defaultShow then
		self.object:SetActive(true)
	end
end

function CommonMail:SetTitle()
	self.node.Title_txt.text = self.mailInfo.title
end

local defaultIcon = "Textures/Icon/Single/MailIcon/Default.png"
local readIcon = "Textures/Icon/Single/MailIcon/Read.png"
function CommonMail:SetIcon()
	local path
	if self.mailInfo.item_list and #self.mailInfo.item_list > 0 then 
		path = ItemConfig.GetItemIcon(self.mailInfo.item_list[1].key)
	else
		if self.isRead then 
			path = readIcon
		else
			path = defaultIcon
		end
	end
	SingleIconLoader.Load(self.node.Icon, path)
end

function CommonMail:SetSender()
	self.node.SenderName_txt.text = self.mailInfo.sender
end

function CommonMail:SetTime()
	if self.mailInfo.expire_ts == 0 then
		UtilsUI.SetActiveByScale(self.node.Time,false)
		return 
	else
		UtilsUI.SetActiveByScale(self.node.Time,true)
	end
	local time = TimeUtils.convertSecondsToDHMs(self.mailInfo.expire_ts - TimeUtils.GetCurTimestamp())
	if time.days > 0 then 
		self.node.Time_txt.text = TI18N(string.format("%d天",time.days))
	else
		self.node.Time_txt.text = TI18N(string.format("%d时",time.hours))
	end 
	
end

local selectColor = Color(1,1,1)
local unselectColor = Color(0,0,0)
function CommonMail:SetSelectBox()
	self.node.SelectBox:SetActive(self.isSelect)
	if self.isSelect then 
		self.node.Title_txt.color = selectColor
		self.node.Time_txt.color = selectColor
	else 
		self.node.Title_txt.color = unselectColor
		self.node.Time_txt.color = unselectColor
	end
	UtilsUI.SetActive(self.node.UnSelect,not self.isSelect)
end

function CommonMail:ReSetSelectBox()
	if not self.isSelect then return end
	self.isSelect = false
	self:SetSelectBox()
end

function CommonMail:OnClick()
	self.isSelect = true
	self:SetSelectBox()
end

function CommonMail:RefreshRecevie(id)
	if id == self.mailInfo.id then 
		self.isRecevie = true
		self:SetRedPoint()
	end
end

function CommonMail:RefreshRedPoint(id)
	if id == self.mailInfo.id then 
		self.isRead = true
		self:SetRedPoint()
		self:SetIcon()
	end
end

function CommonMail:SetRedPoint()
	if self.isRead and self.isRecevie then 
		self.node.CommonMail_canvas.alpha = 0.5
	else
		self.node.CommonMail_canvas.alpha = 1
	end
	self.node.RedPoint:SetActive(not self.isRead or not self.isRecevie)
end

function CommonMail:SetBtnEvent(noShowPanel, btnFunc, onClickRefresh)
	local itemBtn = self.node.InfoBtn_btn
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
			if not noShowPanel then MailCtrl:ChangeShowMail(self.mailInfo) end
		end
		itemBtn.onClick:RemoveAllListeners()
		itemBtn.onClick:AddListener(onclickFunc)
	end
end

function CommonMail:OnReset()
	EventMgr.Instance:RemoveListener(EventName.MailRead, self:ToFunc("RefreshRedPoint"))
	EventMgr.Instance:RemoveListener(EventName.MailGetAward, self:ToFunc("RefreshRecevie"))
	self.object = nil
	self.mailInfo = nil
	self.node = {}
	self.isSelect = false
	self.isRead = false
	self.loadDone = false
	self.defaultShow = true
end