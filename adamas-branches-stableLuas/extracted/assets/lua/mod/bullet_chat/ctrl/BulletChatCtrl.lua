BulletChatCtrl = BaseClass("BulletChatCtrl", Controller)

local _tinsert = table.insert
local _tremove = table.remove
local _tsort = table.sort
local mFloor = math.floor
local DataBulletClose = Config.DataBulletClose.Find

function BulletChatCtrl:__init()
    --EventMgr.Instance:AddListener(EventName.StoryDialogStart, self:ToFunc("OnStartStory"))
    --EventMgr.Instance:AddListener(EventName.StoryDialogEnd, self:ToFunc("OnStopStory"))

    self.bulletChatInterval = Config.DataCommonCfg.Find["BulletChatInterval"].int_val
    self.bulletTimerGroup = TableUtils.NewTable()
end

function BulletChatCtrl:__delete()
    --EventMgr.Instance:RemoveListener(EventName.StoryDialogStart, self:ToFunc("OnStartStory"))
    --EventMgr.Instance:RemoveListener(EventName.StoryDialogEnd, self:ToFunc("OnStopStory"))
end

function BulletChatCtrl:OnStartStory(dialogId)
    local stroyInfo = StoryConfig.GetStoryConfig(dialogId)
    if stroyInfo.type == 5 and stroyInfo.child_type ~= StoryConfig.ChildType.Explore and not DataBulletClose[dialogId] then
        self.curPlayStroy = dialogId
        self.curTime = 0
        self.timeOffset = 0
        self.isPause = false
        self.lastSendTime = nil
        self.curPrefabricateBullet = BulletChatConfig.GetPrefabricateBullet(dialogId)
        self.curWaitPlayBullet = FixedQueue.New()
        self.curJumpQueue = FixedQueue.New()
        self:InitTimer()
        self.playBulletTimer = LuaTimerManager.Instance:AddTimer(0, 1, self:ToFunc("CheckWaitPlayBullte"))

        self:CheckWaitPlayBullte()

        self:RequestBullteChat()
        PanelManager.Instance:OpenPanel(BulletChatPanel)
    end
end

function BulletChatCtrl:CheckWaitPlayBullte()
    if self:IsPause() then
        return
    end

    self.curTime = self.curTime + 1

    local length = #self.curPrefabricateBullet
    for i = length, 1, -1 do
        local bullteInfo = self.curPrefabricateBullet[i]
        if bullteInfo.second <= self.curTime then
            self.curWaitPlayBullet:Push(bullteInfo)
            _tremove(self.curPrefabricateBullet, i)
        else
            break
        end
    end

    EventMgr.Instance:Fire(EventName.CheckBullet)
end

function BulletChatCtrl:TryGetBullte()
    if self.curJumpQueue and self.curJumpQueue:Length() > 0 then
        return self.curJumpQueue:Pop(), true
    end

    if self.curWaitPlayBullet then
        return self.curWaitPlayBullet:Pop()
    end
end

function BulletChatCtrl:GetStoryTime()
    return self.curTime - self.timeOffset
end

function BulletChatCtrl:OnStopStory(dialogId)
    if self.curPlayStroy == dialogId then
        self.curPlayStroy = nil
        if self.playBulletTimer then
            LuaTimerManager.Instance:RemoveTimer(self.playBulletTimer)
            self.playBulletTimer = nil
        end
        self:RemoveAllTimer()
        PanelManager.Instance:ClosePanel(BulletChatPanel)
    end
end

function BulletChatCtrl:RequestBullteChat()
    mod.BulletChatFacade:SendMsg("bullet_chat_history", self.curPlayStroy)
end

function BulletChatCtrl:ReceiveBullteChat(timelineId, bulletChatList)
    if timelineId ~= self.curPlayStroy then
        return
    end
    for index, bulletChat in ipairs(bulletChatList) do
        local time = bulletChat.send_time
        local content = bulletChat.content
        local color = bulletChat.color
        if color == BulletChatEnum.EmoteColor then
            --是表情
            _tinsert(self.curPrefabricateBullet, {type = BulletChatEnum.Type.Emote, second = time, memeId = tonumber(content)})
        else
            _tinsert(self.curPrefabricateBullet, {type = BulletChatEnum.Type.Text, second = time, text = content, color = string.format("#%X", color)})
        end
    end
    _tsort(self.curPrefabricateBullet, BulletChatConfig.SortBulletInfoFunc)
end

--错误码
--101011 不存在的Timeline
--101012 弹幕时间坐标非法
--101013 弹幕发送时间频繁
--101014 弹幕超出上限
function BulletChatCtrl:SendBullteChat(bullteContent, color)
    -- r g b 表示颜色 a 表示是否为图片
    local curTime = self:GetStoryTime()
    
    if self.lastSendTime then
        if (curTime - self.lastSendTime) < self.bulletChatInterval then
            MsgBoxManager.Instance:ShowTips(TI18N("弹幕发送时间频繁"))
            return false
        end
    end

    if color ~= BulletChatEnum.EmoteColor then
        local newText = ""
        local checkText, newText = SWBlocking.Query(bullteContent, newText)
        if checkText then
            MsgBoxManager.Instance:ShowTips(TI18N("存在敏感内容, 请调整后重新输入"))
            EventMgr.Instance:Fire(EventName.FireBulletSuccess)
            return false
        end
    end


    local id, cmd = mod.BulletChatFacade:SendMsg("bullet_chat_send", self.curPlayStroy, curTime, bullteContent, color)

    mod.LoginCtrl:AddClientCmdEvent(id, cmd, function(noticeCode)
        if noticeCode == 0 then
            if color == BulletChatEnum.EmoteColor then
                self.curJumpQueue:Push({type = BulletChatEnum.Type.Emote, second = curTime, memeId = tonumber(bullteContent)})
            else
                self.curJumpQueue:Push({type = BulletChatEnum.Type.Text, second = curTime, text = bullteContent, color = string.format("#%X", color)})
            end
            EventMgr.Instance:Fire(EventName.CheckBullet)
        elseif noticeCode == 101011 then
            LogError("不存在的Timeline")
        elseif noticeCode == 101012 then
            LogError("弹幕时间坐标非法 " .. curTime)
        elseif noticeCode == 101013 then
            MsgBoxManager.Instance:ShowTips(TI18N("[Server]弹幕发送时间频繁"))
        elseif noticeCode == 101014 then
            MsgBoxManager.Instance:ShowTips(TI18N("弹幕发送数量已达上限"))
        else
            LogError("未知错误码 " .. noticeCode)
        end
    end)

    self.lastSendTime = curTime

    EventMgr.Instance:Fire(EventName.FireBulletSuccess)

    return true
end

function BulletChatCtrl:BulletPause()
    if not self.isPause then
        --self.pauseTime = TimeUtils.GetCurTimestamp()
        StoryController.Instance:SetSpeed(0)
        self.isPause = true
        EventMgr.Instance:Fire(EventName.BulletPause)
    end
end

function BulletChatCtrl:BulletRestore()
    if self.isPause then
        --local restoreTime = TimeUtils.GetCurTimestamp()
        StoryController.Instance:SetSpeed(1)
        --self.timeOffset = self.timeOffset + restoreTime - self.pauseTime
        self.isPause = false
        EventMgr.Instance:Fire(EventName.BulletRestore)
    end
end

function BulletChatCtrl:IsPause()
    return self.isPause
end

function BulletChatCtrl:InitTimer()
    self.tableIndex = 0
end

function BulletChatCtrl:AddTimer(count, time, func)
    self.tableIndex = self.tableIndex + 1
    local curTime = self:GetStoryTime()

    time = mFloor(time + 0.5)

    local tb = {index = self.tableIndex, startTime = curTime, stopTime = curTime + time, timer = nil, count = count, callback = func}
    local timer = LuaTimerManager.Instance:AddTimerByNextFrame(count, time, function ()
        self:TimerFunc(tb)
    end)

    tb.timer = timer
    self.bulletTimerGroup[self.tableIndex] = tb

    return self.tableIndex
end

function BulletChatCtrl:TimerFunc(tb)
    local curTime = self:GetStoryTime()
    if (not self:IsPause()) and curTime >= (tb.stopTime - 1) then
        if tb.count ~= 0 then
            tb.count = tb.count - 1
        end
        tb.callback()
    else
        --LogInfo(string.format("Timer【%d】 当前时间%d 结束时间%d 延迟时间%d", tb.index, curTime, tb.stopTime, tb.stopTime - curTime))
        LuaTimerManager.Instance:RemoveTimer(tb.timer)
        tb.timer = LuaTimerManager.Instance:AddTimerByNextFrame(tb.count, tb.stopTime - curTime, function ()
            self:TimerFunc(tb)
        end)
    end
end

function BulletChatCtrl:RemoveTimer(timerIndex)
    local timer = self.bulletTimerGroup[timerIndex]
    if timer ~= nil then
        LuaTimerManager.Instance:RemoveTimer(timer.timer)
        self.bulletTimerGroup[timerIndex] = nil
    end
end

function BulletChatCtrl:RemoveAllTimer()
    for index, timer in pairs(self.bulletTimerGroup) do
        LuaTimerManager.Instance:RemoveTimer(timer.timer)
    end

    TableUtils.ClearTable(self.bulletTimerGroup)
end

function BulletChatCtrl:OnOpenSharePanel()
    self:BulletPause()
    EventMgr.Instance:Fire(EventName.BulletEnterShare)
    PanelManager.Instance:OpenPanel(BulletChatShotPanel)
end

function BulletChatCtrl:OnCloseSharePanel()
    PanelManager.Instance:ClosePanel(BulletChatShotPanel)
    EventMgr.Instance:Fire(EventName.BulletExitShare)
    self:BulletRestore()
end