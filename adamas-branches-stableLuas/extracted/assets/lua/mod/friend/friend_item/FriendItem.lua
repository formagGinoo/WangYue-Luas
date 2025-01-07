FriendItem = BaseClass("FriendItem", Module)


function FriendItem:__init()
	self.parent = nil
	self.playerInfo = nil
	self.object = nil
    self.isSelect = nil
	self.node = {}
end

function FriendItem:InitItem(object, playerInfo)
	self.object = object
    self.playerInfo = playerInfo
    EventMgr.Instance:AddListener(EventName.RemakrNameChange,self:ToFunc("RemarkChange"))
    EventMgr.Instance:AddListener(EventName.FriendStateRefresh,self:ToFunc("StateChange"))
	self.node = UtilsUI.GetContainerObject(self.object.transform)

    UtilsUI.SetHideCallBack(self.node.Select_out,self:ToFunc("SelectOut"))

    if self.isSelect == false then
        self.isSelect = nil
        self:SetSelect(false)
    end
    self.isSelect = nil
	self:Show()
end


function FriendItem:Show()
	self:SetName()
    self:SetState()
    self:SetHeadIcon()
    self:SetLv()
end

function FriendItem:SetName()
    local remark = mod.FriendCtrl:GetFriendRemark(self.playerInfo.information.uid)
    if remark and remark ~= "" then 
        self.node.RemarkName_txt.text = mod.FriendCtrl:GetFriendRemark(self.playerInfo.information.uid)
        UtilsUI.SetActiveByScale(self.node.RemarkName,true)
        UtilsUI.SetActiveByScale(self.node.NickName,false)
    else
        self.node.NickName_txt.text = self.playerInfo.information.nick_name
        UtilsUI.SetActiveByScale(self.node.RemarkName,false)
        UtilsUI.SetActiveByScale(self.node.NickName,true)
    end
end

function FriendItem:SetState()
    if self.playerInfo.offline_timestamp > 0 then 
        local time = TimeUtils.convertSecondsToDHMs(TimeUtils.GetCurTimestamp() - self.playerInfo.offline_timestamp)
        if time.days >= 31 then
            time.days = 31
        end
        if time.days > 0 then 
            self.node.OffLineTime_txt.text = string.format(TI18N("%d天前"), time.days)
        elseif time.hours > 0 then
            self.node.OffLineTime_txt.text = string.format(TI18N("%d小时前"), time.hours)
        else
            self.node.OffLineTime_txt.text = string.format(TI18N("%d分钟前"), time.minutes)
        end
        UtilsUI.SetActiveByScale(self.node.OnLine,false)
        UtilsUI.SetActiveByScale(self.node.OffLine,true)
    else
        UtilsUI.SetActiveByScale(self.node.OnLine,true)
        UtilsUI.SetActiveByScale(self.node.OffLine,false)
    end
end

function FriendItem:SetHeadIcon()
    if self.playerInfo.information.avatar_id == 0 then
        self.playerInfo.information.avatar_id = 1001001
    end
    local path = RoleConfig.HeroBaseInfo[self.playerInfo.information.avatar_id].chead_icon
    SingleIconLoader.Load(self.node.HeadIcon, path)
    SingleIconLoader.Load(self.node.HeadIconFrame,InformationConfig.GetFrameIcon(self.playerInfo.information.frame_id))
end

function FriendItem:SetLv()
    self.node.LvTxt_txt.text = self.playerInfo.adventure_lev
end

local defaultNameColor = Color(0.86,0.86,0.86)
local selectNameColor = Color(0.15,0.15,0.15)
function FriendItem:SetSelect(isSelect)
    if self.isSelect and self.isSelect == isSelect then return end
    self.isSelect = isSelect
    
    if isSelect then
        self.selectTimer = LuaTimerManager.Instance:AddTimer(1,0.1,function()
            self.node.NickName_txt.color = selectNameColor
            UtilsUI.SetActive(self.node.Select,isSelect)
            self.node.Select_anim:Play("UI_FriendItem_Select_in",0,0)
            LuaTimerManager.Instance:RemoveTimer(self.selectTimer)
            self.selectTimer = nil
        end)
    else
        self.node.Select_anim:Play("UI_FriendItem_Select_out")
    end
end

function FriendItem:SelectOut()
    if self.isSelect == true then return end
    self.node.NickName_txt.color = defaultNameColor
    UtilsUI.SetActive(self.node.Select,false)
end

function FriendItem:SetBtnEvent(noShowPanel, btnFunc, onClickRefresh)
	local itemBtn = self.node.ClickBtn_btn
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

function FriendItem:OnReset()
    self.node.ClickBtn_btn.onClick:RemoveAllListeners()
    EventMgr.Instance:RemoveListener(EventName.RemakrNameChange,self:ToFunc("RemarkChange"))
    EventMgr.Instance:RemoveListener(EventName.FriendStateRefresh,self:ToFunc("StateChange"))
    self.node.NickName_txt.color = defaultNameColor
    UtilsUI.SetActive(self.node.Select,false)
end

function FriendItem:RemarkChange(id)
    if id == self.playerInfo.information.uid then
        self:SetName()
    end
end

function FriendItem:StateChange(id)
    if id == self.playerInfo.information.uid then
        self:SetState()
    end
end