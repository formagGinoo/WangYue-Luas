MailProxy = BaseClass("MailProxy",Proxy)

function MailProxy:__init()

end

function MailProxy:__InitProxy()
    self:BindMsg("mail_list")
    self:BindMsg("mail_read")
    self:BindMsg("mail_get_reward")
    self:BindMsg("mail_get_reward_all")
    self:BindMsg("mail_delete")
    self:BindMsg("mail_delete_read")
end

function MailProxy:__InitComplete()
end

-- 邮件列表
function MailingProxy:Send_mail_list()
end
function MailProxy:Recv_mail_list(data)
    mod.MailCtrl:UpdateMailsList(data.mail_list)
    EventMgr.Instance:Fire(EventName.MailRefresh)
end

-- 标记已读
function MailProxy:Send_mail_read(Id)
    return {id = Id}
end
function MailProxy:Recv_mail_read(data)
    mod.MailCtrl:SetMailRead(data.id)
end

-- 领取奖励
function MailProxy:Send_mail_get_reward(Id)
    return {id = Id}
end
function MailProxy:Recv_mail_get_reward(id)
    mod.MailCtrl:SetMailGetReward({id.id})
end

-- 领取全部奖励
function MailProxy:Send_mail_get_reward_all()
end
function MailProxy:Recv_mail_get_reward_all(id_list)
    mod.MailCtrl:SetMailGetReward(id_list.id_list)
end

-- 删除邮件
function MailProxy:Send_mail_delete(idList)
    return {id_list = idList}
end
function MailProxy:Recv_mail_delete(data)
    mod.MailCtrl:DeleteMail(data.id_list)
end

-- 删除已读邮件
function MailProxy:Send_mail_delete_read()
end
function MailProxy:Recv_mail_delete_read(data)
    mod.MailCtrl:DeleteMail(data.id_list)
end