MessageInfromItem = BaseClass("MessageInfromItem", Module)
local itemPrefab = "Prefabs/UI/Phone/InformItem.prefab"

function MessageInfromItem:__init(ItemInfo)
	self.parent = ItemInfo.parent                                 --父节点
	self.messageInfo = ItemInfo.itemInfo                          --对话到当前节点
    self.clickfunc = ItemInfo.clickCallback                      --
    self.messageId = ItemInfo.selfmessageId                       --messageId
    self.groupId = Config.DataMessageCome.Find[self.messageId].group_id  --对应的短信组
    self.firstMessageInfo = Config.DataMessageDialog.Find[mod.MessageCtrl:GetFirstTalkId(self.messageId)]    --对应短息组的第一句信息
    self.MessageComeInfo = Config.DataMessageCome.Find[self.messageId]                      --对应短信的Come信息
    self.MessageTypeInfo = Config.DataMessageType.Find[self.MessageComeInfo.message_main_id]     --对应短信的Type信息（用来显示头像和名字）
    self.nowNode = nil
    self.itemObjectName = "MessageInfromItem"
    self.assetLoader =  AssetMgrProxy.Instance:GetLoader("MessageInfromItemLoader")
    self:LoadItem()
end

function MessageInfromItem:InitItem()
	self.node = UtilsUI.GetContainerObject(self.object.transform)
    UtilsUI.AddUIChild(self.parent, self.object)
    self.node.InformBg_btn.onClick:AddListener(self:ToFunc("OnClick"))
    self:Show()
end

function MessageInfromItem:Show()
	self:SetName()
    self:SetHeadIcon()
    self:SetContent()
end

function MessageInfromItem:SetName()
    if self.MessageTypeInfo.message_main_name == "<nick_name>" then
        self.node.InformNameText_txt.text = InformationConfig.GetDefalultName()
    else
        self.node.InformNameText_txt.text = self.MessageTypeInfo.message_main_name
    end
end

function MessageInfromItem:SetContent()
    local str = self.firstMessageInfo.talk_content
    if self.firstMessageInfo.type ==2 then
        --self.node.InformIconNode:SetActive(true)
        self.node.InformText:SetActive(true)
        self.node.InformText_txt.text = Config.DataMeme.Find[tonumber(str)].title
        --local path = Config.DataMeme.Find[tonumber(str)].meme
        --SingleIconLoader.Load(self.node.InformContentIcon, path)
    else
        self.node.InformText:SetActive(true)
        local len = string.len(str)
        local content = ""
        if len>30 then
            content = string.sub(str,1,21).."..."
            else
            content = str
        end
        self.node.InformText_txt.text = content
    end
end

function MessageInfromItem:GetByteCount(str)
    local realByteCount=#str
    local length=0
    local curBytePos=1
    while(true) do
        local step=1 --遍历字节的递增值
        local byteVal=string.byte(str,curBytePos)
 
        if byteVal>239 then
            step=4
        elseif byteVal>223 then
            step=3
        elseif byteVal>191 then
            step=2
        else
            step=1
        end
        curBytePos=curBytePos+step
        length=length+1
        if curBytePos>realByteCount then
            break
        end
    end
    return length
end
function MessageInfromItem:SetHeadIcon()
    if self.MessageTypeInfo then
        local path = self.MessageTypeInfo.icon
        SingleIconLoader.Load(self.node.InformHeadIcon, path)
    end
end


function MessageInfromItem:OnClick()
    if self.clickfunc then
        self.clickfunc(self.messageInfo,self.messageId)
    end
end


function MessageInfromItem:LoadItem()
    local item = self:CreatItem()
    
    if item then
        self.object = item
        self:InitItem()
    end
end

function MessageInfromItem:CreatItem()
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

function MessageInfromItem:LoadDone()
    self:InitItem()
    AssetMgrProxy.Instance:CacheLoader(self.assetLoader)
end
