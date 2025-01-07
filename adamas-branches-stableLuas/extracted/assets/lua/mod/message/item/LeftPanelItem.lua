LeftPanelItem = BaseClass("LeftPanelItem", Module)
local itemPrefab = "Prefabs/UI/Message/LeftInfoItem2.prefab"

function LeftPanelItem:__init(ItemInfo)
    if ItemInfo then
    self.parent = ItemInfo.parent                                 --父节点
	self.messages = ItemInfo.messages
    self.messageMainId = ItemInfo.messageMainId                          --对话到当前节点
    self.clickfunc = ItemInfo.clickCallback
    self.closeNodefunc = ItemInfo.closeNode
    self.updeatMessage  = ItemInfo.UpdeatMessage
    end
    self.nowNode = nil
    self.itemObjectName = "LeftPanelItem"
    
    self.assetLoader = AssetMgrProxy.Instance:GetLoader("LeftPanelItemLoader")
    self.RoelMessageItem = {}
    self.IsActive = false
    self:LoadItem()
end

function LeftPanelItem:__delete()
    if self.assetLoader then
        AssetMgrProxy.Instance:CacheLoader(self.assetLoader)
        self.assetLoader = nil
    end
    if self.object then
        PoolManager.Instance:Push(PoolType.object, self.itemObjectName, self.object)
    end
end

function LeftPanelItem:Hide()

    for _k, _v in pairs(self.RoelMessageItem) do
        if _v.Item then
            _v.Item:Hide()
            _v.Item:DeleteMe()
            _v.Item = nil
        end
    end
    self.RoelMessageItem = {}
end

function LeftPanelItem:InitItem()
    if not self.parent then
        self:DeleteMe()
        return
    end
	self.node = UtilsUI.GetContainerObject(self.object.transform)
    UtilsUI.AddUIChild(self.parent, self.object)
    self.node.LeftItemBtn_btn.onClick:AddListener(self:ToFunc("OnClick_Self"))
    self:Show()
end

function LeftPanelItem:Show()
    local config = Config.DataMessageType.Find[self.messageMainId]
	self:SetName(config)
    self:SetHeadIcon(config)
    self:UpdateDownBox() --初始的时候生成
end


function LeftPanelItem:SetName(config)
    if config.message_main_name == "<nick_name>" then
        self.node.LeftContentName_txt.text = InformationConfig.GetDefalultName()
        self.node.LeftContentBaiName_txt.text = InformationConfig.GetDefalultName()
    else
        self.node.LeftContentName_txt.text = config.message_main_name
        self.node.LeftContentBaiName_txt.text = config.message_main_name
    end
end

function LeftPanelItem:SetHeadIcon(config)
    if config then
        local path = config.icon
        SingleIconLoader.Load(self.node.LeftContentHeadIcon, path)
    end
end

function LeftPanelItem:ClosePanel()

    self.node.Selected:SetActive(false)
    self.node.NotSelected:SetActive(true)
    self.node.LeftDownNode:SetActive(false)
    -- self.node.LeftItemBg:SetActive(false)
    -- self.node.DownArrow:SetActive(false)
    -- self.node.RightArrow:SetActive(true)
    -- self.node.LeftContentBaiName:SetActive(true)
    -- self.node.LeftContentName:SetActive(false)

    for _k, _v in pairs(self.RoelMessageItem) do
        if _v.Item then
            _v.Item:CloseItem()
            _v.Item:DeleteMe()
            _v.Item = nil
            _v.itemInfo = nil
        end
    end
    self.RoelMessageItem ={}
end

 --打开自身的下拉框,并且创造messageitem
function LeftPanelItem:OnClick_Self()

    self.IsActive = not self.IsActive
    self.node.Selected:SetActive(self.IsActive)
    self.node.NotSelected:SetActive(not self.IsActive)
    self.node.LeftDownNode:SetActive(self.IsActive)
    --self.node.LeftItemBg:SetActive(self.IsActive)
    --self.node.DownArrow:SetActive(self.IsActive)
    --self.node.RightArrow:SetActive(not self.IsActive)
    --self.node.LeftContentBaiName:SetActive(not self.IsActive)
    --self.node.LeftContentName:SetActive(self.IsActive)
    if self.IsActive then
       self:UpdateDownBox()
    end
end

function LeftPanelItem:ShowTalkPanel(messageId,talkId)
    self.clickfunc(messageId,talkId)
end

--创建下拉框里的item
function LeftPanelItem:CreatRoelMessageItem(messageId,talkId,type)
    if not self.RoelMessageItem[messageId]then
        self.RoelMessageItem[messageId]={}
        local itemInfo = {
        parent = self.node.LeftDownNode,
        messageId = messageId,
        talkId = talkId,
        type = type,
        clickCallback = self:ToFunc("ShowTalkPanel"),
        clickCloseNode = self:ToFunc("CloseNode"),
        changeType = self:ToFunc("ChangConditionType")
    }
        self.RoelMessageItem[messageId].itemInfo = itemInfo
        self.RoelMessageItem[messageId].Item = RoelMessagesItem.New(itemInfo)
    end
end

function LeftPanelItem:CloseRoelMessageItem()
    for _k, _v in pairs(self.RoelMessageItem) do
        if _v.Item then
            _v.Item:SetActive(false)
        end
    end
end

function LeftPanelItem:CloseNode(node)
    self.closeNodefunc(node)
end

--打开下拉框
function LeftPanelItem:UpdateDownBox()

    for _k, _v in pairs(self.messages) do 
       self:CreatRoelMessageItem(_k,_v.talkId,_v.type)
    end
end

--更改状态
function LeftPanelItem:ChangConditionType()
    self.messages = self.updeatMessage(self.messageMainId)
    self:UpdateDownBox()
end


function LeftPanelItem:LoadItem()
    local item = self:CreatItem()
    if item then
        self.object = item
        self:InitItem()
    end
end

function LeftPanelItem:CreatItem()
    local item = PoolManager.Instance:Pop(PoolType.object, self.itemObjectName)
    if not item then
        local callback = function()
            self.object = self.assetLoader:Pop(itemPrefab)
            self:LoadDone()
        end

        local resList = {
            {path = itemPrefab, type = AssetType.Prefab}
        }
        self.assetLoader:AddListener(callback)
        self.assetLoader:LoadAll(resList)
        return false
    end
    return item
end

function LeftPanelItem:LoadDone()
    self:InitItem()
end
