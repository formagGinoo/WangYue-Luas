FightRightTipPanel = BaseClass("FightRightTipPanel", BasePanel)

function FightRightTipPanel:__init(mainView)
    self.mainView = mainView
    self:SetAsset("Prefabs/UI/Fight/FightRightTip/FightRightTipPanel.prefab")
    self.curList = {}
    self.queue = {}
    self.curTimer = 0
end

function FightRightTipPanel:__delete()
    EventMgr.Instance:RemoveListener(EventName.LevelMarkActive, self:ToFunc("AddTip"))
end

function FightRightTipPanel:__CacheObject()
	local spacing = self.Content:GetComponent(VerticalLayoutGroup).spacing
	local unitY = self.TipNode_rect.sizeDelta.y
	self.offsetY = spacing + unitY
end

function FightRightTipPanel:__BindListener()
    EventMgr.Instance:AddListener(EventName.LevelMarkActive, self:ToFunc("AddTip"))
end

function FightRightTipPanel:__BaseShow()
	self:SetParent(self.mainView.PanelParent.transform)
end

function FightRightTipPanel:__ShowComplete()
	self.mainView:AddLoadDoneCount()
end

function FightRightTipPanel:AddTip(jumpId)
    local config = JumpToSystemConfig.GetNPCJumpConfig(jumpId)
    table.insert(self.queue, config)
    self:PopItem()
end

function FightRightTipPanel:PopItem()
    if not next(self.queue) then return end

    if #self.curList < 2 then
        local config = table.remove(self.queue, 1)
        local obj = self:PopUITmpObject("TipNode", self.Content_rect)
        obj.ContentText_txt.text = config.name
        obj.GetItemPanel_in_hcb.HideAction:AddListener(self:ToFunc("PushItem"))
        SingleIconLoader.Load(obj.Icon, config.icon)
        table.insert(self.curList, obj)
    else
        return
    end
    self:PopItem()
end

function FightRightTipPanel:PushItem()
    if not next(self.curList) then return end
    local info = table.remove(self.curList, 1)
    info.GetItemPanel_in_hcb.HideAction:RemoveAllListeners()
    local anchoredPosition  = self.Content_rect.anchoredPosition
	UnityUtils.SetAnchoredPosition(self.Content_rect, anchoredPosition.x, anchoredPosition.y - self.offsetY)
    self:PushUITmpObject("TipNode", info, self.Cache_rect)
    self:PopItem()
end

local showTime = 3 -- 显示时间
function FightRightTipPanel:Update()
    -- if not self.active then return end
    -- if not next(self.curList) then return end

    -- self.curTimer = self.curTimer + Global.deltaTime
    -- if self.curTimer >= showTime then
    --     self.curTimer = 0
    --     local obj = table.remove(self.curList, 1)
    --     self:PushItem(obj)
    -- end
end