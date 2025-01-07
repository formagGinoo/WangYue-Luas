---@class AnnouncementCtrl : Controller
AnnouncementCtrl = BaseClass("AnnouncementCtrl", Controller)

local DataNoticeImg = Config.DataNoticeImg.Find

local saveKey  = "AnnouncementRecordId"
local showType = {
    Gameing = 1, -- 游戏内
    LoginGame = 2, -- 登录页
    All = 3, -- 都展示
}

AnnouncementCtrl.TagType = {
    gameTag = 1,
    activityTag = 2,
}

-- 后台通知的类型
local informType = {
    updateTip = 1,
    newServerTip = 2,
    activityTip = 3,
    systemTip = 4,
    versionTip = 5,
}

local ShowInformType = {
    [informType.updateTip] = {
        showGameType = showType.All,
        tag = AnnouncementCtrl.TagType.gameTag
    },
    [informType.activityTip] = {
        showGameType = showType.Gameing,
        tag = AnnouncementCtrl.TagType.activityTag
    },
    [informType.systemTip] = {
        showGameType = showType.All,
        tag = AnnouncementCtrl.TagType.activityTag
    },
    [informType.versionTip] = {
        showGameType = showType.Gameing,
        tag = AnnouncementCtrl.TagType.gameTag
    },
}

local _tinsert = table.insert
local _tsort = table.sort

function AnnouncementCtrl:__init()
    EventMgr.Instance:AddListener(EventName.AnnouncementRefresh, self:ToFunc("RefreshAnnouncements"))

    -- 添加一个获取公告的对象
    self.announRoot = GameObject("AnnouncementRoot")
	GameObject.DontDestroyOnLoad(self.announRoot)
    self.AnnouncementList = self.announRoot.gameObject:AddComponent(AnnouncementList)
    self.AnnouncementList.requestCb = self:ToFunc("RequestAnnouncementsCB")

    self.announcementMap = {}
    self.readList = {}
end

function AnnouncementCtrl:__delete()
    EventMgr.Instance:RemoveListener(EventName.AnnouncementRefresh, self:ToFunc("RefreshAnnouncements"))
    GameObject.Destroy(self.announRoot)

    if self.timer then
        LuaTimerManager.Instance:RemoveTimer(self.timer)
    end
end

function AnnouncementCtrl:__InitComplete()
end

function AnnouncementCtrl:RefreshAnnouncements()
    
end

-- 这里只有登录成功或者被定时器调用
function AnnouncementCtrl:RequestAnnouncementsList()
    local channel = mod.LoginCtrl:GetChannelId()
    self.AnnouncementList:RequestAnnouncementList(channel)
    self:TimerRequestAnnouncementsList()
    EventMgr.Instance:Fire(EventName.AnnouncementRefresh)
end

function AnnouncementCtrl:TimerRequestAnnouncementsList()
    if self.timer then
        LuaTimerManager.Instance:RemoveTimer(self.timer)
    end
    self.timer = LuaTimerManager.Instance:AddTimer(0, 600, self:ToFunc("RequestAnnouncementsList"))
end

function AnnouncementCtrl:SavePlayerPrefs(val)
	PlayerPrefs.SetString(saveKey, tostring(val))
	PlayerPrefs.Save()
end

function AnnouncementCtrl:GetPlayerPrefs()
	return PlayerPrefs.GetString(saveKey)
end

function AnnouncementCtrl:LoadRecordID()
    local strRecordIs = self:GetPlayerPrefs()
    if not strRecordIs or strRecordIs == "" then return end
    local map = StringHelper.Split(strRecordIs, "&")
    
    for _, value in pairs(map) do
        local id = tonumber(value)
        if id then
            self.readList[id] = true
        end
    end
end

function AnnouncementCtrl:GetAnnouncementImgKey(str)
    local strMap = StringHelper.Split(str, "&")
    local imgKey
    local content = ""
    for idx, val in ipairs(strMap) do
        if not imgKey and DataNoticeImg[val] then
            imgKey = DataNoticeImg[val].banner
        else
            content = content .. val
        end
    end
    return imgKey, content
end

function AnnouncementCtrl:RequestAnnouncementsCB(map)
    print("map -= ", map)
    if not map or map.Count <= 0 then return end
    self.announcementMap = {}

    local list = {}
    for i = 0, map.Count - 1 do
        local announcement = map[i]
        local data = {}
        data.id = announcement.id
        data.lv = announcement.lv
        data.type = announcement.type
        data.sort = announcement.sort
        data.title = announcement.title
        data.summary = announcement.summary
        data.open_day_min = announcement.open_day_min
        data.open_day_max = announcement.open_day_max
        data.valid_time_st = announcement.valid_time_st
        data.valid_time_ed = announcement.valid_time_ed
        local imgKey, content = self:GetAnnouncementImgKey(announcement.content)
        data.content = content
        data.banner = imgKey
        data.channel_names = StringHelper.Split(announcement.channel_names, ",")
        _tinsert(list, data)
    end

    for _, data in ipairs(list) do
        local type = data.type
        local typeData = ShowInformType[type]
        if typeData then
            self.announcementMap[typeData.tag] = self.announcementMap[typeData.tag] or {}
            _tinsert(self.announcementMap[typeData.tag], data)
        else
            LogError("出现了一个规划外的公告, id = "..data.id)
        end
    end

    for _, list in pairs(self.announcementMap) do
        _tsort(list, function(a, b)
            if a.sort ~= b.sort then
                return a.sort < b.sort
            else
                return a.id < b.id
            end
        end)
    end
    self:LoadRecordID()
end

function AnnouncementCtrl:OpenAnnouncementWindow()
    if self:CheckCanOpen() then 
        WindowManager.Instance:OpenWindow(AnnouncementWindow)
        return true
    end
    MsgBoxManager.Instance:ShowTips(TI18N("暂无公告！"))
end

function AnnouncementCtrl:CheckCanOpen()
    local list = self:GetannouncementList(AnnouncementCtrl.TagType.gameTag)
    if list and #list > 0 then return true end
    list = self:GetannouncementList(AnnouncementCtrl.TagType.activityTag)
    if list and #list > 0 then return true end
    return false
end

function AnnouncementCtrl:GetAnnouncementsInfo()
    mod.ShopFacade:SendMsg("announcements_list")
end

function AnnouncementCtrl:UpdateAnnouncementsList(announcementList)
    -- if not self.announcementList then self.announcementList = {[1] = {},[2] = {}} end
    -- for k, v in pairs(announcementList) do
    --     table.insert(self.announcementList[v.tab],v)
    -- end
    -- table.sort(self.announcementList[1],sortByPriority)
    -- table.sort(self.announcementList[2],sortByPriority)
end

function AnnouncementCtrl:AddAnnouncementsReadId(id)
    if not self.readList then
        self.readList = {}
    end
    if self.readList[id] then return end
    
    self.readList[id] = true
    local str = ""
    for key, _ in pairs(self.readList) do
        str = str..key.."&"
    end
    self:SavePlayerPrefs(str)
    EventMgr.Instance:Fire(EventName.AnnouncementRefresh)
end

function AnnouncementCtrl:CheckChannel(tab, curChannel)
    for _, channel in pairs(tab) do
        if channel == curChannel then
            return true
        end
    end
end

-- 判断游戏内还是游戏外
-- 判断对应的公告是否在展示时间内
-- 探索等级限制
-- 渠道限制
function AnnouncementCtrl:GetannouncementList(type)
    local isGameing = true
    if not Fight.Instance then
        isGameing = false
    end

    if not self.announcementMap or not self.announcementMap[type] then return end

    local time = TimeUtils.serverTime
    if isGameing and not TimeUtils.serverTime then return end
    time = time or os.time()
    -- 探索等级
    local info = mod.WorldLevelCtrl:GetAdventureInfo()
    local roleLv = info.lev or 1

    -- 渠道
    local channel = mod.LoginCtrl:GetChannelId() or ""
    time = TimeUtils.serverTime and TimeUtils.GetCurTimestamp() or time

    local data = self.announcementMap[type]
    local list  = {}
    for k, info in pairs(data)do
        local type = info.type
        local typeData = ShowInformType[type]

        local isInsert = false
        if isGameing and (typeData.showGameType == showType.Gameing or typeData.showGameType == showType.All) then
            isInsert = true
        elseif not isGameing and (typeData.showGameType == showType.LoginGame or typeData.showGameType == showType.All) then
            isInsert = true
        end

        -- 世界等级
        if isGameing and roleLv < info.lv then
            isInsert = false
        end
        -- 渠道
        if channel ~= "" and not self:CheckChannel(info.channel_names, channel) then
            isInsert = false
        end

        if isInsert and time >= info.valid_time_st and time <= info.valid_time_ed then
            table.insert(list,info)
        end
    end
    return list
end

function AnnouncementCtrl:GetRedPointState(id)
    if not self.readList then return true end
    if self.readList[id] then return false end
    return true
end

function AnnouncementCtrl:CheckActiveLabRedPoint()
    local list = self:GetannouncementList(AnnouncementCtrl.TagType.activityTag)
    if not list or not next(list) then return false end
    if not self.readList or not next(list) then return true end
    for _, v in pairs(list) do
        if not self.readList[v.id] then 
            return true
        end
    end
    return false
end

function AnnouncementCtrl:CheckGameLabRedPoint()
    local list = self:GetannouncementList(AnnouncementCtrl.TagType.gameTag)
    if not list or not next(list) then return false end
    if not self.readList or not next(list) then return true end
    for _, v in pairs(list) do
        if not self.readList[v.id] then 
            return true
        end
    end
    return false
end

