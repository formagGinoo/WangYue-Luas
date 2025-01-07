-- 奖励弹窗>新功能开启>新角色获取>指引
-- 这里可以选择吧数据缓存在这里，或者可以去调用对应的管理器方法

NoticeManger = BaseClass("NoticeManger")
local _tinsert = table.insert
local _tremove = table.remove

function NoticeManger:__init(fight)
	self.fight = fight
    self.newRoleIdMap = {}
    self.newGetPartnerMap = {}
    self.newPartnerMap = {}
    self.getItemPanelMap = {}
    self.concludePartnerPnl = {}
    self:BindListener()

    self.canInsert = true
end

function NoticeManger:BindListener()
    EventMgr.Instance:AddListener(EventName.SystemOpen, self:ToFunc("CheckShowNotice"))
    EventMgr.Instance:AddListener(EventName.GetRole, self:ToFunc("AddNewRole"))
    EventMgr.Instance:AddListener(EventName.NoticeQueueActive, self:ToFunc("SetActive"))
    -- EventMgr.Instance:AddListener(EventName.CloseNoticePnl, self:ToFunc("CloseNoticePnlEvent"))
    --EventMgr.Instance:AddListener(EventName.OnWindowOpen, self:ToFunc("OnWindowOpen"))
end

-- function NoticeManger:OnWindowOpen()
--     local curWindow = WindowManager.Instance:GetCurWindow()
--     if not curWindow or curWindow ~= "FightMainUIView" then
--         return
--     end
--     self:CheckShowNotice()
-- end

-- function NoticeManger:CloseNoticePnlEvent()
--     self.isShow = false
--     self:CheckShowNotice()
-- end

function NoticeManger:SetActive(flag)
    self.canInsert = flag or false
end

function NoticeManger:AddNewRole(roleId)
    if not self.canInsert then
        return
    end
    _tinsert(self.newRoleIdMap, roleId)
    self:CheckShowNewRolePnl()
end

function NoticeManger:CheckShowNewRolePnl()
    if not next(self.newRoleIdMap) then return end
    local roleId = self.newRoleIdMap[1]

    -- 展示界面
    local setting = {
        args = {roleId = roleId},
        preloadAssets =  {{path = Config.DataHeroQuality.Find[Config.DataHeroMain.Find[roleId].quality].tips_effect, type = AssetType.Prefab}}
    }
    EventMgr.Instance:Fire(EventName.AddSystemContent, NewRolePanelV2, setting)

    _tremove(self.newRoleIdMap, 1)
    return true
end

function NoticeManger:AddNewGetPartner(partnerId)
    _tinsert(self.newGetPartnerMap, partnerId)
    self:CheckShowGetPartnerPanel()
end

function NoticeManger:CheckShowGetPartnerPanel()
    if not next(self.newGetPartnerMap) then return end
    local partnerId = self.newGetPartnerMap[1]
	_tremove(self.newGetPartnerMap, 1)
    -- 展示界面
    EventMgr.Instance:Fire(EventName.AddFightContent, GetPartnerPanel, {args = {partnerId}})
    return true
end

-- 首次获取新的组配从
function NoticeManger:AddNewPartner(partnerId)
    _tinsert(self.newPartnerMap, partnerId)
    self:CheckShowPartnerPnl()
end

function NoticeManger:CheckShowPartnerPnl()
    if not next(self.newPartnerMap) then return end
    local partnerId = self.newPartnerMap[1]
    _tremove(self.newPartnerMap, 1)

    local setting = {
        args = {partnerId = partnerId}, 
        preloadAssets = {
            {path = Config.DataPartnerQuality.Find[Config.DataPartnerMain.Find[partnerId].quality].tips_effect, type = AssetType.Prefab}
        }
    }

    EventMgr.Instance:Fire(EventName.AddSystemContent, NewPartnerPanel, setting)

    return true
end

function NoticeManger:AddConcludePartnerPanel(partnerId, isNew)
    _tinsert(self.concludePartnerPnl, {partnerId, isNew})
    self:CheckShowConcludePartnerPanel()
end

function NoticeManger:CheckShowConcludePartnerPanel()
    if not next(self.concludePartnerPnl) then return end
    local data = self.concludePartnerPnl[1]
    local partnerId = data[1]
    local isNew = data[2]
    _tremove(self.concludePartnerPnl, 1)

    local setting = {
        args = {id = partnerId, isNew = isNew},
    }

    EventMgr.Instance:Fire(EventName.AddSystemContent, PartnerConcludeSucPanel, setting)
    return true
end

function NoticeManger:CheckShowNotice()
    -- 检查系统提示弹窗
    local systemMgr = self.fight.systemManager
    if systemMgr:CheckShowSystemOpenPnl() then
        --self.isShow = true
        return
    end

--     if self.isShow then return end

-- --[[
--     1.功能开启弹窗只会在主界面打开
--     2.获得奖励弹窗>新功能开启>新角色获取>指引
--     3.如果同时有角色获取弹窗和功能开启弹窗，但目前不是在主界面，则弹出角色弹窗，在回到主界面后弹出功能弹窗
-- ]]

--     local mainUI = WindowManager.Instance:GetWindow("FightMainUIView")

--     if not mainUI or not mainUI:Active() then 
--         self:CheckShowNoticeNotInMainUI()
--         return 
--     end

--     -- 检查系统提示弹窗
--     local systemMgr = self.fight.systemManager
--     if systemMgr:CheckShowSystemOpenPnl() then
--         self.isShow = true
--         return
--     end

--     self:CheckShowNoticeNotInMainUI()
end