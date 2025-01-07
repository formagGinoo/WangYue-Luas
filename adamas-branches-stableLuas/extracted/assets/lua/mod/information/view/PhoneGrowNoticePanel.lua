PhoneGrowNoticePanel = BaseClass("PhoneGrowNoticePanel", BasePanel)

local _tinsert = table.insert
local _tsort = table.sort

function PhoneGrowNoticePanel:__init()
    self:SetAsset("Prefabs/UI/Phone/PhoneGrowNoticePanel.prefab")
    self.noticeDataList = {}
    self.cacheListCont = {}
end

function PhoneGrowNoticePanel:__CacheObject()
    self:SetCacheMode(UIDefine.CacheMode.destroy)
end

function PhoneGrowNoticePanel:__BindEvent()
    EventMgr.Instance:AddListener(EventName.GrowNoticeSummaryUpdate, self:ToFunc("ResetNoticeList"))
end

function PhoneGrowNoticePanel:__delete()
    EventMgr.Instance:RemoveListener(EventName.GrowNoticeSummaryUpdate, self:ToFunc("ResetNoticeList"))

    for k, v in pairs(self.cacheListCont) do
        if v.luaCommonItem then
            PoolManager.Instance:Push(PoolType.class, "CommonItem", v.luaCommonItem)
            v.luaCommonItem = nil
        end
    end
end

function PhoneGrowNoticePanel:__BindListener()
    self.PhoneGrowNoticePanelCloseBtn_btn.onClick:AddListener(self:ToFunc("OnClickPhoneGrowNoticePanelCloseBtn"))
end

function PhoneGrowNoticePanel:__Show()
    self.parentWindow = self.args.parent
    self:ResetNoticeList()
end

function PhoneGrowNoticePanel:ResetNoticeList()
    local growNoticeManager = Fight.Instance.growNoticeManager
    TableUtils.ClearTable(self.noticeDataList)

    local noticeDatas = growNoticeManager:GetAllNotice()

    for index, v in pairs(noticeDatas) do
        if v.isShow then
            _tinsert(self.noticeDataList, v)
        end
    end

    _tsort(self.noticeDataList, function (t1, t2)
        local order1 = growNoticeManager:GetOverrideSort(t1.index)
        local order2 = growNoticeManager:GetOverrideSort(t2.index)
        if order1 ~= order2 then
            return order1 > order2
        end
        return t1.index < t2.index
    end)

    self.NoticeList_recyceList:SetCellLuaCallBack(self:ToFunc("RefreshNoticeList"))
    self.NoticeList_recyceList:SetCellNum(#self.noticeDataList, true)
end

function PhoneGrowNoticePanel:RefreshNoticeList(index, goUniqueId, go)
    local cont = self.cacheListCont[goUniqueId]
    if not cont then
        cont = UtilsUI.GetContainerObject(go)
        self.cacheListCont[goUniqueId] = cont 
        cont.luaCommonItem = PoolManager.Instance:Pop(PoolType.class, "CommonItem") or CommonItem.New()
    end

    cont.ClickBtn_btn.onClick:RemoveAllListeners()
    cont.TipsTitle_txt.text = self.noticeDataList[index].showTitle
    cont.TipsNotice_txt.text = self.noticeDataList[index].showNoticeText
    cont.ClickBtn_btn.onClick:AddListener(self.noticeDataList[index].clickFunc)

    local commonItemDataSet = {template_id = self.noticeDataList[index].showItem, count = 0, scale = 0.73}
    cont.luaCommonItem:InitItem(cont.CommonItem, commonItemDataSet, true)
end

function PhoneGrowNoticePanel:__Hide()

end

function PhoneGrowNoticePanel:__BeforeExitAnim()

end
 
function PhoneGrowNoticePanel:__AfterExitAnim()
    --self.parentWindow:ReturnMenu()
end

function PhoneGrowNoticePanel:OnClickPhoneGrowNoticePanelCloseBtn()
    self.parentWindow:ReturnMenu()
end