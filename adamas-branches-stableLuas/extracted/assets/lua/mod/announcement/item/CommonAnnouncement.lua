CommonAnnouncement = BaseClass("CommonAnnouncement", Module)

function CommonAnnouncement:__init()
	self.object = nil
	self.announcementInfo = nil
	self.node = {}
	self.isSelect = false
	self.loadDone = false
	self.defaultShow = true
end

function CommonAnnouncement:InitAnnouncement(object, announcementInfo)
	-- 获取对应的组件
	self.object = object
	self.node = UtilsUI.GetContainerObject(self.object.transform)
	
	self.loadDone = true

	self.announcementInfo = announcementInfo
	self.isRed = mod.AnnouncementCtrl:GetRedPointState(self.announcementInfo.id)
	self.object:SetActive(false)
	self:Show()
end

function CommonAnnouncement:Show()
	if not self.loadDone then return end
	self:SetSelectBox()
	self:SetTitle()
	self:SetRedPoint()

	if self.defaultShow then
		self.object:SetActive(true)
	end
end

local function truncateUTF8String(str, length)
    local currentIndex = 1
    local numChars = 0
    while currentIndex <= #str do
        numChars = numChars + 1
        if numChars > length then
            break
        end
        local byte = string.byte(str, currentIndex)
        if byte >= 0xC0 and byte <= 0xFD then
            currentIndex = currentIndex + 2
        else
            currentIndex = currentIndex + 1
        end
    end
    return string.sub(str, 1, currentIndex - 1) .. "..."
end

function CommonAnnouncement:SetTitle()
	local str = self.announcementInfo.title
	local maxLen = 17
	if string.len(str) > maxLen then
		str = truncateUTF8String(str, maxLen)
	end
	self.node.Title_txt.text = str
end

local selectColor = Color(1,1,1)
local unselectColor = Color(0,0,0)
function CommonAnnouncement:SetSelectBox()
	self.node.SelectBox:SetActive(self.isSelect)
	if self.isSelect then 
		self.node.Title_txt.color = selectColor
	else 
		self.node.Title_txt.color = unselectColor
	end
	UtilsUI.SetActive(self.node.SelectBg,self.isSelect)
	UtilsUI.SetActive(self.node.UnSelectBg,not self.isSelect)
end

function CommonAnnouncement:ReSetSelectBox()
	if not self.isSelect then return end
	self.isSelect = false
	self:SetSelectBox()
end

function CommonAnnouncement:OnClick()
	self.isSelect = true
	self:SetSelectBox()
end

function CommonAnnouncement:SetRedPoint()
	self.node.RedPoint:SetActive(self.isRed)
end

function CommonAnnouncement:SetBtnEvent(noShowPanel, btnFunc, onClickRefresh)
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
			if not noShowPanel then AnnouncementCtrl:ChangeShowAnnouncement(self.announcementInfo) end
		end
		itemBtn.onClick:RemoveAllListeners()
		itemBtn.onClick:AddListener(onclickFunc)
	end
end

function CommonAnnouncement:OnReset()
	self.object = nil
	self.announcementInfo = nil
	self.node = {}
	self.isSelect = false
	self.loadDone = false
	self.defaultShow = true
end