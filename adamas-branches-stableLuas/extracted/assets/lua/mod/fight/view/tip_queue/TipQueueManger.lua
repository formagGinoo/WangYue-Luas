---@class TipQueueManger
TipQueueManger = BaseClass("TipQueueManger")

function TipQueueManger:__init(fight)
    TipQueueManger.Instance = self
    self.fight = fight
    self.tipQueue = {}
    self.centerQueue = {}
    self.whiteQueue = {}--白名单队列
    self.curPanelName = nil
    self.waitTimer = nil
    self.delayTimer = nil
    self.isPauseFight = false
    self.pauseCount = 0
    
    self.levelTipList = {}
    self.levelTipMap = {}
    self:_BindEvent()
end

local TipPriority = 
{
    Fight = 100,
    ["WorldLevelChangeTipPanel"] = 101,
    IdentityOption = 101,  -- 道途选项解锁

    Adventure = 103, --探索等级

    IdentityLvUp = 104, -- 人物道途身份
    IdentityExp = 105, -- 人物道途经验

    WorldTitle_1 = 102, -- 世界标题-- 进入小区域
    WorldTitle_3 = 205, -- 世界标题-- 任务结束
    WorldTitle_5 = 205, -- 世界标题-- 挑战结束
    WorldTitle_6 = 205, -- 世界标题-- 战斗胜利
    WorldTitle_8 = 205, -- 世界标题-- 城市威胁结束
    WorldTitle_9 = 102, -- 世界标题-- 进入中区域
    DefaultWorldTitle = 106,-- 默认世界标题

    ["GetPartnerPanel"] = 107, -- 获取月灵玉
    ["SystemOpenWindow"] = 108, --系统开启
    RogueTipsPanel = 107, -- 大世界肉鸽进度提示
    RogueSelectRewardWindow = 108, -- 大世界肉鸽卡牌抽取

    ["PartnerConcludeSucPanel"] = 200,--缔结月灵
    ["NewPartnerPanel"] = 201,--获得新月灵
    ["NewRolePanelV2"] = 202, --获得新角色
    ["AbilityFirstGetPanel"] = 203,--获得新能力
    ["GetItemPanel"] = 204, --获得物品
    ["PartnerSkillUnlockPanel"] = 206, --月灵技能解锁
    ["BaseLevChangeTipPanel"] = 207, --月灵武器升级
    ["BaseStageChangeTipPanel"] = 208, -- 月灵武器突破
    ["LevelInstructionWindow"] = 208,    -- 关卡玩法介绍


    System = 300,
	
	["TaskChapterOpenWindow"] = 301,--章节开启弹窗
	["TaskChapterWindow"] = 302,--章节奖励弹窗
	["TaskChapterCloseWindow"] = 303,--章节结束弹窗
}

--优化，为了实现在某个界面中需要打开其他的弹窗问题
local WhiteList = {
    ["TaskChapterWindow"] = { GetItemPanel = true },
}

function TipQueueManger:_BindEvent()
    EventMgr.Instance:AddListener(EventName.AddSystemContent, self:ToFunc("AddSystemContent"))
    EventMgr.Instance:AddListener(EventName.AddFightContent, self:ToFunc("AddFightContent"))
    EventMgr.Instance:AddListener(EventName.ShowCommonTitle, self:ToFunc("ShowCommonTitle"))
    EventMgr.Instance:AddListener(EventName.AdventureChange, self:ToFunc("AdventureChange"))
    EventMgr.Instance:AddListener(EventName.PauseTipQueue, self:ToFunc("PauseGlobal"))
    EventMgr.Instance:AddListener(EventName.ResumeTipQueue, self:ToFunc("ResumeGlobal"))
    EventMgr.Instance:AddListener(EventName.TipHideEvent, self:ToFunc("TipHideEvent"))

    EventMgr.Instance:AddListener(EventName.IdentityExpChange,self:ToFunc("IdentityExpChange"))
    EventMgr.Instance:AddListener(EventName.IdentityLvChange,self:ToFunc("IdentityLvChange"))
    EventMgr.Instance:AddListener(EventName.IdentityOptionUnlock,self:ToFunc("IdentityOptionUnlock"))
    EventMgr.Instance:AddListener(EventName.RemoveLevel,self:ToFunc("RemoveLevel"))
end

function TipQueueManger:_RemoveEvent()
    EventMgr.Instance:RemoveListener(EventName.AddSystemContent, self:ToFunc("AddSystemContent"))
    EventMgr.Instance:RemoveListener(EventName.AddFightContent, self:ToFunc("AddFightContent"))
    EventMgr.Instance:RemoveListener(EventName.ShowCommonTitle, self:ToFunc("ShowCommonTitle"))
    EventMgr.Instance:RemoveListener(EventName.AdventureChange, self:ToFunc("AdventureChange"))
    EventMgr.Instance:RemoveListener(EventName.PauseTipQueue, self:ToFunc("PauseGlobal"))
    EventMgr.Instance:RemoveListener(EventName.ResumeTipQueue, self:ToFunc("ResumeGlobal"))
    EventMgr.Instance:RemoveListener(EventName.TipHideEvent, self:ToFunc("TipHideEvent"))

    EventMgr.Instance:RemoveListener(EventName.IdentityExpChange,self:ToFunc("IdentityExpChange"))
    EventMgr.Instance:RemoveListener(EventName.IdentityLvChange,self:ToFunc("IdentityLvChange"))
    EventMgr.Instance:RemoveListener(EventName.IdentityOptionUnlock,self:ToFunc("IdentityOptionUnlock"))
    EventMgr.Instance:RemoveListener(EventName.RemoveLevel,self:ToFunc("RemoveLevel"))
end

function TipQueueManger:__delete()
    if self.waitTimer then
        LuaTimerManager.Instance:RemoveTimer(self.waitTimer)
        self.waitTimer = nil
    end

    self:ClearDelayTimer()

    self.tipQueue = nil
    self:_RemoveEvent()
    TipQueueManger.Instance = nil
end

function TipQueueManger:PauseFightTip()
    if self.isPauseFight == true then
        return
    end
    self.isPauseFight = true
    self:ClearDelayTimer()
    if self.curPanel then
        self.curPanel:Hide()
    end
end

function TipQueueManger:ResumeFightTip()
    if self.isPauseFight == false then
        return
    end
    self.isPauseFight = false
    self:TryShow()
end

function TipQueueManger:PauseGlobal()
    self.pauseCount = self.pauseCount + 1
end

function TipQueueManger:ResumeGlobal()
    self.pauseCount = self.pauseCount - 1
    if self.pauseCount <= 0 then
        self.pauseCount = 0
    else
        return
    end
    self:TryShow()
end

function TipQueueManger:TryShow()
    if self.isDisplay then
        return
    end
    self:StartNextTip()
end

function TipQueueManger:TipHideEvent(className)
    if self.curPanelName and className ~= self.curPanelName then
        return
    end
    if not self.curPanelName then
        return 
    end
    self.curPanel = nil
    self.isDisplay = false
    if self.hideTimer then
        LuaTimerManager.Instance:RemoveTimer(self.hideTimer)
        self.hideTimer = nil
    end

    self.hideTimer = LuaTimerManager.Instance:AddTimer(1, 0, self:ToFunc("StartNextTip"))
end

function TipQueueManger:StartNextTip()
    if self.pauseCount > 0 or not SystemStateMgr.Instance:CanShowSystemTip() then
        return
    end
    self.isDisplay = false
    if self.isPauseFight or not SystemStateMgr.Instance:CanShowFightTip() then
        self:ShowCenterContent()
        return
    end
    if next(self.centerQueue) and next(self.tipQueue) then
        if self.centerQueue[1].priority >= self.tipQueue[1].priority then
            self:ShowCenterContent()
        else
            self:ShowTopContent()
        end
    elseif next(self.centerQueue) then
            self:ShowCenterContent()
    elseif next(self.tipQueue) then
        self:ShowTopContent()
    end
end

function TipQueueManger:ClearDelayTimer()
    if self.delayTimer then
        LuaTimerManager.Instance:RemoveTimer(self.delayTimer)
        self.delayTimer = nil
    end
end


function TipQueueManger:ShowCommonTitle(type, title, default, icon)
    local priority = TipPriority["WorldTitle_"..type] or TipPriority.DefaultWorldTitle
    local args = {type, title, default, icon}
    local setting = {
        args = args,
        priority = priority
    }
    self:AddTopContent(WorldTitlePanel, setting)
end

function TipQueueManger:AdventureChange(addExp, oldRank)
     for index, value in ipairs(self.tipQueue) do
         if value.panelType == AdventureChangedPanel then
            if addExp then
                value.args[2] = value.args[2] or addExp
                value.args[2] = value.args[2] + addExp
            end
             value.args[3] = value.args[3] or oldRank
             return
         end
    end
    local priority = TipPriority.Adventure
    local args = {addExp, oldRank}
    local setting = {
        args = args,
        priority = priority
    }
    self:AddTopContent(AdventureChangedPanel, setting)
end

function TipQueueManger:IdentityExpChange(changeList)
    for index, value in ipairs(self.tipQueue) do
        if value.panelType == IdentityChangeTipPanel then
           if changeList and not value.args.type then
                for _,v1 in ipairs(changeList) do
                    local isnew = true
                    for _,v2 in ipairs(value.args) do
                        if v1.id == v2.id then
                            isnew = false
                            v1.val = v1.val + v2.val
                        end
                    end
                    if isnew then
                        table.insert(value.args,v1)
                    end
                end
                    
                return
            end
        end
    end
    local priority = TipPriority.IdentityExp
    local args = changeList
    local setting = {
        args = args,
        priority = priority
    }
    self:AddTopContent(IdentityChangeTipPanel, setting)
end

function TipQueueManger:IdentityLvChange(lv,type)
    local priority = TipPriority.IdentityLvUp
    local args = {type = type,lv = lv}
    local setting = {
        args = args,
        priority = priority
    }
    self:AddTopContent(IdentityChangeTipPanel, setting)
end

function TipQueueManger:IdentityOptionUnlock()
    local priority = TipPriority.IdentityOption
    local args = {}
    local setting = {
        args = args,
        priority = priority
    }
    self:AddTopContent(IdentityOptionUnlockPanel, setting)
end

function TipQueueManger:AddFightContent(panelType, setting)
    local priority = TipPriority[panelType.__className] or TipPriority.Fight
    setting = setting or {}
    setting.priority = setting.priority or priority
    self:AddTopContent(panelType, setting)
end

function TipQueueManger:AddSystemContent(panelType, setting)
    local priority = TipPriority[panelType.__className] or TipPriority.System
    setting = setting or {}
    setting.priority = setting.priority or priority
    self:AddCenterContent(panelType, setting)
end


--只会在战斗界面出现
function TipQueueManger:AddTopContent(panelType, setting)
    TipQueueManger.Log("AddTopContent", panelType.__className)
    TipQueueManger.LogTable("TipQueueManger:AddTopContent", setting.args)
	setting = setting or {}
    setting.panelType = panelType
	table.insert(self.tipQueue, setting)
    table.sort(self.tipQueue, function (a, b)
        return a.priority > b.priority
    end)

    if not self.isDisplay and not self.delayTimer then
        self.delayTimer = LuaTimerManager.Instance:AddTimer(1, setting.delayTime or 0.5, function ()
            self:TryShow()
            self:ClearDelayTimer()
        end)
    end
end

function TipQueueManger:ShowTopContent()
    if self.tipQueue and next(self.tipQueue) then
        self.isDisplay = true
        local data = table.remove(self.tipQueue, 1)
        self.curPanelName = data.panelType.__className
        TipQueueManger.Log("ShowTopContent", data.panelType.__className)
        TipQueueManger.LogTable("TipQueueManger:ShowTopContent", data.args)
        if data.isWindow then
            WindowManager.Instance:OpenWindow(data.panelType, data.args)
        else
            print(data.priority)
            self.curPanel = PanelManager.Instance:OpenPanel(data.panelType, data.args)
        end
    end
end

--可以在任意地方出现
function TipQueueManger:AddCenterContent(panelType, setting)
    setting = setting or {}
    setting.panelType = panelType
    TipQueueManger.Log("AddCenterContent",  setting.panelType.__className)
    local settingClassName = setting.panelType and setting.panelType.__className
    --如果存在当前界面的白名单内，就不进队列,直接弹
    if WhiteList[self.curPanelName] and WhiteList[self.curPanelName][settingClassName] then
        self:ShowContent(setting)
    else
        table.insert(self.centerQueue, setting)
        table.sort(self.centerQueue, function (a, b)
            return a.priority > b.priority
        end)
        if not self.isDisplay and not self.delayTimer then
            self.delayTimer = LuaTimerManager.Instance:AddTimer(1, setting.delayTime or 0.1, function ()
                self:TryShow()
                self:ClearDelayTimer()
            end)
        end
    end
end

function TipQueueManger:ShowCenterContent()
    if next(self.centerQueue) then
        self.isDisplay = true
        local data = table.remove(self.centerQueue, 1)
        self.curPanelName = data.panelType.__className
        TipQueueManger.Log("ShowCenterContent",  data.panelType.__className)
        if data.isWindow then
            WindowManager.Instance:OpenWindow(data.panelType, data.args)
        else
            PanelManager.Instance:OpenPanel(data.panelType, data.args, nil, data.preloadAssets)
        end
    end
end

function TipQueueManger:ShowContent(setting)
    TipQueueManger.Log("ShowCenterContent",  setting.panelType.__className)
    if setting.isWindow then
        WindowManager.Instance:OpenWindow(setting.panelType, setting.args)
    else
        PanelManager.Instance:OpenPanel(setting.panelType, setting.args, nil, setting.preloadAssets)
    end
end

local showLog = false
function TipQueueManger.Log(...)
    if showLog then Log("TipQueueManger", ...) end
end

function TipQueueManger.LogTable(...)
    if showLog then LogTable(...) end
end

--处理一下关卡提示的管理
local _tiqUniqueId = 0
local timeIndex = 0
function TipQueueManger:AddLevelTips(tipsId, levelId, ...)
	_tiqUniqueId = _tiqUniqueId + 1
    timeIndex = timeIndex + 1

    local tipsConfig = SystemConfig.GetTipConfig(tipsId)
    self.levelTipList[tipsConfig.type] = self.levelTipList[tipsConfig.type] or {}
    local content
    if ... then
        content = string.format(tipsConfig.content, ...)
    else
        content = tipsConfig.content
    end
    local info = {
        tipsUniqueId = _tiqUniqueId, 
        type = tipsConfig.type,
        levelId = levelId, 
        timeIndex = timeIndex,
        time = tipsConfig.time,
        tipsId = tipsId, 
        content = content,
        subContent = {},
    }
    table.insert(self.levelTipList[tipsConfig.type], info)
    table.sort(self.levelTipList[tipsConfig.type], function(a, b)
        return a.timeIndex > b.timeIndex
    end)
    self.levelTipMap[_tiqUniqueId] = info
    self:LevelTipChanged(info.type)
    return _tiqUniqueId
end

function TipQueueManger:ChangeLevelTitleTips(tipsUniqueId, ...)
	local info = self.levelTipMap[tipsUniqueId]
    if not info then return LogError("关卡提示不存在:"..tipsUniqueId) end
    local tipsConfig = SystemConfig.GetTipConfig(info.tipsId)
    timeIndex = timeIndex + 1
    info.timeIndex = timeIndex
    if ... then
        info.content = string.format(tipsConfig.content, ...)
    end
    table.sort(self.levelTipList[info.type], function(a, b)
        return a.timeIndex > b.timeIndex
    end)
    self:LevelTipChanged(info.type)
end

function TipQueueManger:ChangeLevelSubTipsState(index, tipsUniqueId, state)
    local info = self.levelTipMap[tipsUniqueId]
    if not info then return LogError("关卡提示不存在:"..tipsUniqueId) end
    if self.levelTipList[info.type][1].tipsUniqueId == tipsUniqueId  then
        local view = WindowManager.Instance:GetWindow("FightMainUIView")
        view:CallActivePanelFunc("ChangeSubTipsV2Success", index, tipsUniqueId, state)
    end
end

function TipQueueManger:ChangeLevelSubTips(index, tipsUniqueId, ...)
    local info = self.levelTipMap[tipsUniqueId]
    if not info then return LogError("关卡提示不存在:"..tipsUniqueId) end
    local tipsConfig = SystemConfig.GetTipConfig(info.tipsId)
    local desc
    if ... then
        desc = string.format(tipsConfig.sub_content[index], ...)
    else
        desc = tipsConfig.sub_content[index]
    end

    info.subContent[index] = desc
    if self.levelTipList[info.type][1].tipsUniqueId == tipsUniqueId  then
        local view = WindowManager.Instance:GetWindow("FightMainUIView")
        view:CallActivePanelFunc("ChangeSubTipsDescV2", index, tipsUniqueId)
    end
end

function TipQueueManger:GetLevelSubTipsInfo(tipsUniqueId)
    return self.levelTipMap[tipsUniqueId]
end

function TipQueueManger:RemoveLevelTips(tipsUniqueId, onlyData)
    local info = self.levelTipMap[tipsUniqueId]
    if info then
        self.levelTipMap[tipsUniqueId] = nil
        for k, v in pairs(self.levelTipList[info.type]) do
            if v.tipsUniqueId == tipsUniqueId then
                if self.levelTipList[info.type][1].tipsUniqueId == tipsUniqueId  then
                    table.remove(self.levelTipList[info.type], k)
                    if not onlyData then
                        self:LevelTipChanged(info.type)
                    end
                else
                    table.remove(self.levelTipList[info.type], k)
                end
                break
            end
        end
    end
end

function TipQueueManger:Update()
    for tipsUniqueId, info in pairs(self.levelTipMap) do
        if info.type == FightEnum.FightTipsType.Center then
            info.time = info.time - Global.deltaTime
            if info.time <= 0 then
                self:RemoveLevelTips(tipsUniqueId)
            end
        end
    end
end

function TipQueueManger:RemoveLevel(level)
    for tipsUniqueId, info in pairs(self.levelTipMap) do
        if info.levelId == level then
            self:RemoveLevelTips(tipsUniqueId)
        end
    end
end

function TipQueueManger:LevelTipChanged(type)
    local info = self.levelTipList[type] and self.levelTipList[type][1]
    if type == FightEnum.FightTipsType.Center then
        if info then
            MsgBoxManager.Instance:ShowTips(info.content, info.time, nil, true)
        else
            MsgBoxManager.Instance:HideTips()
        end
    elseif type == FightEnum.FightTipsType.GuideTips then
        if info then
            local tipsConfig = SystemConfig.GetTipConfig(info.tipsId)
            local view = WindowManager.Instance:GetWindow("FightMainUIView")
            view:CallActivePanelFunc("SetTipsGuideDescV2", info.tipsUniqueId, tipsConfig)
        else
            local view = WindowManager.Instance:GetWindow("FightMainUIView")
            view:CallActivePanelFunc("ShowTaskGuide", true)
        end
    elseif type == FightEnum.FightTipsType.CurtainTips then
        if info then
            local tipsConfig = SystemConfig.GetTipConfig(info.tipsId)
            CurtainManager.Instance:ShowBlackCurtainTipsV2(info.tipsId, info.tipsUniqueId)
        else
            CurtainManager.Instance:CurtainTipsEnd(0, 0.3, true)
        end
    end
end