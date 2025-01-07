---@class MailCtrl : Controller
MailCtrl = BaseClass("MailCtrl", Controller)

ERRORCODE = 
{
    Default = 1001,
    AlreadyRead = 1002,
    AlreadyRecevie = 1003,
}

local function sortByPriority(a,b)
    if a.reward_flag == b.reward_flag then
        if (#a.item_list > 0 and #b.item_list > 0) or (#a.item_list == 0 and #b.item_list == 0) then
            return a.send_ts > b.send_ts
        else
            return #a.item_list > 0
        end
    else
        return a.reward_flag == 0
    end

end

function MailCtrl:__init()
    self.mailList = {}
    --EventMgr.Instance:AddListener(EventName.Mailsrefresh, self:ToFunc("RefreshMails"))
end

function MailCtrl:__delete()
    --EventMgr.Instance:RemoveListener(EventName.Mailsrefresh, self:ToFunc("RefreshMails"))
end

function MailCtrl:__InitComplete()
end

function MailCtrl:GetMailsInfo()
    mod.ShopFacade:SendMsg("mail_list")
end

function MailCtrl:UpdateMailsList(mailList)
    for k, v in ipairs(mailList) do
        if v.type == 0 then 
            local mailInfo = Config.DataMail.Find[v.template_id]
            mailList[k].title = mailInfo.title
            mailList[k].content = mailInfo.content
            mailList[k].sender = mailInfo.sender
        end
    end
    if #self.mailList > 0 then 
        for _, v in ipairs(mailList) do
            for k, v2 in pairs(self.mailList) do
                if v2.id == v.id then
                    goto continue
                end
            end
            table.insert(self.mailList,v)
            ::continue::
        end
    else
        self.mailList = mailList
    end
    EventMgr.Instance:Fire(EventName.MailRefresh)
end

function MailCtrl:RecevieMail(mail)
    table.insert(self.mailList,mail)
    table.sort(self.mailList,sortByPriority)
end

function MailCtrl:DestoryMail(mailid)
    for k, v in pairs(self.mailList) do
        if v.id == mailid then 
            table.remove(self.mailList,k)
            return
        end
    end
end

function MailCtrl:SetMailRead(id)
    for k, v in pairs(self.mailList) do
        if v.id == id then 
            self.mailList[k].read_flag = 1
            if not v.item_list or #v.item_list == 0 then
                self.mailList[k].reward_flag = 1 
                EventMgr.Instance:Fire(EventName.MailGetAward,id)
            end
            EventMgr.Instance:Fire(EventName.MailRead,id)
            return
        end
    end
end

function MailCtrl:GetReward(id)
    local id,cmd = mod.MailFacade:SendMsg("mail_get_reward",id)
    mod.LoginCtrl:AddClientCmdEvent(id,cmd,function(codeId)
        if codeId == ERRORCODE.Default then
            MsgBoxManager.Instance:ShowTips("背包已满,领取邮件失败！")
        elseif codeId == ERRORCODE.AlreadyRead then
            --MsgBoxManager.Instance:ShowTips("邮件已读！")
        elseif codeId == ERRORCODE.AlreadyRecevie then
            MsgBoxManager.Instance:ShowTips("邮件已经领取过了！")
        end
    end)
end

function MailCtrl:SetMailGetReward(idList)
    if not idList or not next(idList) then
        MsgBoxManager.Instance:ShowTips("背包已满,领取邮件失败！")
        return 
    end
    local itemList = {}

    for _, v1 in ipairs(idList) do
        for k, v2 in pairs(self.mailList) do
            if v2.id == v1 then 
                self.mailList[k].reward_flag = 1
                self.mailList[k].read_flag = 1
                EventMgr.Instance:Fire(EventName.MailRead,v1)
                EventMgr.Instance:Fire(EventName.MailGetAward,v1)
                for _, v3 in ipairs(v2.item_list) do
                    table.insert(itemList,{count = v3.value,template_id = v3.key,unique = 0})
                end
            end
        end
    end
    if itemList and next(itemList) then 
        PanelManager.Instance:OpenPanel(GetItemPanel, {reward_list = itemList})
    end
end

function MailCtrl:DeleteMail(id_list)
    for _, v in ipairs(id_list) do
        for k, v2 in pairs(self.mailList) do
            if v2.id == v then
                table.remove(self.mailList,k)
                EventMgr.Instance:Fire(EventName.MailRefresh)
            end
        end
    end
end

function MailCtrl:CheckCanDeleteRead()
    for _, v in pairs(self.mailList) do
        if v.reward_flag == 1 then
            return true
        end
    end
    return false
end

function MailCtrl:DeleteRead()
    mod.MailFacade:SendMsg("mail_delete_read")
end

function MailCtrl:RefreshMails()

end

function MailCtrl:CheckCanGetAll()
    local time = TimeUtils.GetCurTimestamp()
    for _, v in pairs(self.mailList) do
        if v.reward_flag == 0 and #v.item_list > 0 and (v.expire_ts > time or v.expire_ts == 0) then
            return true
        end
    end
    return false
end

function MailCtrl:GetAll()
    mod.MailFacade:SendMsg("mail_get_reward_all")
end

function MailCtrl:GetmailList()
    local time = TimeUtils.GetCurTimestamp()
    for i = #self.mailList, 1, -1 do
        if self.mailList[i].expire_ts ~= 0 and self.mailList[i].expire_ts < time then
            table.remove(self.mailList,i)
        end
    end
    table.sort(self.mailList,sortByPriority)
    return self.mailList
end

function MailCtrl:MailRedPoint()
    for _, v in pairs(self.mailList) do
        if v.reward_flag == 0 then
            return true
        end
    end
    return false
end