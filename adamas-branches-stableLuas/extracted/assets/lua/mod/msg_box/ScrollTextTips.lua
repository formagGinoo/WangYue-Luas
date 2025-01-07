ScrollTextTips = BaseClass("ScrollTextTips", BaseView)

local defaultTips = TI18N("获得奖励")

function ScrollTextTips:__init(msgBoxType)
	self:SetAsset("Prefabs/UI/Common/ScrollTextTips.prefab")
	self:SetParent(UIDefine.canvasRoot.transform)
    self.showList = {}
    self.tipList = {}
end

function ScrollTextTips:__Create()
    self.length = self.TipObj_rect.sizeDelta.y + 5
end


function ScrollTextTips:__Show()
	self:TryShowNextTips()
end

function ScrollTextTips:__Hide()
	
end

function ScrollTextTips:ShowTips(content)
    table.insert(self.tipList, content)

    self:TryShowNextTips()
end

function ScrollTextTips:TryShowNextTips()
    if not self.active then return end
    if not next(self.tipList) then return end
    if #self.showList >= 3 then
        self:RemoveTips()
        return
    end

    local content = table.remove(self.tipList, 1)
    local showData = {}

    showData.obj = self:PopUITmpObject("TipObj", self.Content_rect)
    showData.obj.Text_txt.text = content
    showData.timer = LuaTimerManager.Instance:AddTimer(1,1, self:ToFunc("RemoveTips"))

    table.insert(self.showList,showData)
end

function ScrollTextTips:RemoveTips()
    local showData = table.remove(self.showList, 1)
    LuaTimerManager.Instance:RemoveTimer(showData.timer)
    self:PushUITmpObject("TipObj", showData.obj, self.Cache_rect)
    local pos = self.Content_rect.anchoredPosition
    UnityUtils.SetAnchoredPosition(self.Content_rect, pos.x, pos.y - self.length)
    self:TryShowNextTips()
end