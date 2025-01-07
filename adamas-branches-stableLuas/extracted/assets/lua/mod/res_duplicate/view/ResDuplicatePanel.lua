ResDuplicatePanel = BaseClass("ResDuplicatePanel", BasePanel)
local _tinsert = table.insert

local defSelectTagIdx = 1

function ResDuplicatePanel:__init()
    self:SetAsset("Prefabs/UI/ResDuplicate/ResDuplicatePanel.prefab")
end

function ResDuplicatePanel:__CacheObject()

end

function ResDuplicatePanel:__BindListener()

end

function ResDuplicatePanel:__Show()
    self:InitCurrencyBar()
    self.tagItemMap = {}
    self.duplicateItemMap = {}
    self.selectTagIdx = nil
    self:UpdateTagList()

    local selectIdx = self.parentWindow:GetSubSelectTagIdx()
    if selectIdx and selectIdx ~= 0 then
        defSelectTagIdx = selectIdx
    end
    self:SelectTag(defSelectTagIdx)
end

function ResDuplicatePanel:__Hide()
    self:CacheCurrencyBar()
    self.ResContent_recyceList:CleanAllCell()
    self.DuplicateContetnt_recyceList:CleanAllCell()

    for _, luaObj in pairs(self.tagItemMap) do
        luaObj:DeleteMe()
    end
    self.tagItemMap = {}

    for _, luaObj in pairs(self.duplicateItemMap) do
        luaObj:Destory()
        luaObj:DeleteMe()
    end
    self.duplicateItemMap = {}
end

function ResDuplicatePanel:__delete()

end

function ResDuplicatePanel:UpdateTagList()
    self.ResContent_recyceList:CleanAllCell()
    local tagList = ResDuplicateConfig.GetResDuplicateTagList()
    local len = TableUtils.GetTabelLen(tagList)
    self.tagList = tagList

    self.ResContent_recyceList:SetLuaCallBack(self:ToFunc("UpdateTagItem"))
    self.ResContent_recyceList:SetCellNum(len)
end

function ResDuplicatePanel:UpdateTagItem(index, obj)
    local rect = obj:GetComponent(RectTransform)
    UnityUtils.SetAnchoredPosition(rect, 0, 0)

    local tagCfg = ResDuplicateConfig.GetResDuplicateTagInfo(index)
    local tagItem = ResDuplicateTagItem.New()

    tagItem:SetData(self, {cfg = tagCfg, obj = obj, index = index})
    self.tagItemMap[index] = tagItem
end

function ResDuplicatePanel:SelectTag(idx)
    if self.selectTagIdx == idx then return end

    for index, tagItem in pairs(self.tagItemMap) do
        if index ~= idx then
            tagItem:UpdateSelectState(false)
        else
            tagItem:UpdateSelectState(true)
        end
    end
    self.selectTagIdx = idx
    self:UpdateDuplicateList(idx)
end

function ResDuplicatePanel:UpdateDuplicateList(tagId)
    self.DuplicateContetnt_recyceList:CleanAllCell()
    local conditionMgr = Fight.Instance.conditionManager

    local duplicateList = ResDuplicateConfig.GetResDuplicateList(tagId)
    local list = {}
    for dupId, _ in pairs(duplicateList) do
        local cfg = ResDuplicateConfig.GetResourceDuplicateType(dupId)
        if conditionMgr:CheckConditionByConfig(cfg.condition) then
            _tinsert(list, dupId)
        end
    end
    table.sort(list, function (a, b)
        return a < b
    end)
    self.duplicateList = list
    self.DuplicateContetnt_recyceList:SetLuaCallBack(self:ToFunc("UpdateDuplicateItem"))
    self.DuplicateContetnt_recyceList:SetCellNum(#list)
end

function ResDuplicatePanel:UpdateDuplicateItem(index, obj)
    local rect = obj:GetComponent(RectTransform)
    UnityUtils.SetAnchoredPosition(rect, 0, 0)

    local resId = self.duplicateList[index]

    local dupCfg = ResDuplicateConfig.GetResourceDuplicateType(resId)
    local dupItem = ResDuplicateItem.New()

    dupItem:SetData(self, {cfg = dupCfg, obj = obj, index = index})
    self.duplicateItemMap[index] = dupItem
end

-- 初始化货币栏
function ResDuplicatePanel:InitCurrencyBar()
    self.CurrencyBar1 = Fight.Instance.objectPool:Get(CurrencyBar)
    self.CurrencyBar1:init(self.CurrencyBar, ResDuplicateConfig.FightCostResId)
end

-- 移除货币栏
function ResDuplicatePanel:CacheCurrencyBar()
    self.CurrencyBar1:OnCache()
end