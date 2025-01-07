BlackListItem = BaseClass("BlackListItem", Module)

function BlackListItem:__init()
	self.playerInfo = nil
	self.object = nil

	self.node = {}
end

function BlackListItem:InitItem(object, playerInfo)
	self.object = object
    self.playerInfo = playerInfo

	self.node = UtilsUI.GetContainerObject(self.object.transform)

    self:SetClickEvent()
	self:Show()
end


function BlackListItem:Show()
	self:SetName()
    self:SetState()
    self:SetLv()
    self:SetHeadIcon()
end

function BlackListItem:SetName()
    local remark = mod.FriendCtrl:GetFriendRemark(self.playerInfo.information.uid)
    if remark and remark ~= "" then
        self.node.NickName_txt.text = remark
    else
        self.node.NickName_txt.text = self.playerInfo.information.nick_name
    end
end

function BlackListItem:SetState()
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

function BlackListItem:SetHeadIcon()
    local path = RoleConfig.HeroBaseInfo[self.playerInfo.information.avatar_id].chead_icon
    SingleIconLoader.Load(self.node.HeadIcon, path)
    SingleIconLoader.Load(self.node.HeadIconFrame,InformationConfig.GetFrameIcon(self.playerInfo.information.frame_id))
end

function BlackListItem:SetLv()
    self.node.LvTxt_txt.text = self.playerInfo.adventure_lev
end

function BlackListItem:SetClickEvent()
    self.node.AvatarItem_btn.onClick:RemoveAllListeners()
    self.node.AvatarItem_btn.onClick:AddListener(self:ToFunc("ShowPlayerInfo"))

    self.node.DeleteBtn_btn.onClick:RemoveAllListeners()
    self.node.DeleteBtn_btn.onClick:AddListener(self:ToFunc("OnClick_DeleteBtn"))
end

function BlackListItem:ShowPlayerInfo()
    WindowManager.Instance:OpenWindow(PlayerInfoWindow,{uid = self.playerInfo.information.uid})
end

function BlackListItem:OnClick_DeleteBtn()
    mod.FriendCtrl:RemoveBlackList(self.playerInfo.information.uid)
end