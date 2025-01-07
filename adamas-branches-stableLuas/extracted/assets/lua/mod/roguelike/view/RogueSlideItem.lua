RogueSlideItem = BaseClass("RogueSlideItem")
--滑动列表里面的卡牌 --todo

local itemPrefab = "Prefabs/UI/WorldRogue/RogueSlideItem.prefab"

--[[
    parent : 父节点
    cardId : 卡牌id 
    cardNum : 卡牌数量
    isCanDrag : 是否打开drag操作
]]--
function RogueSlideItem:__init(itemInfo, obj)
    if itemInfo then
        self.parent = itemInfo.parent
        self.cardId = itemInfo.id
        self.cardNum = itemInfo.num or 1
        self.index = itemInfo.index
        --UI系列事件
        self.isCanDrag = itemInfo.isCanDrag
        self.onPointerEnter = itemInfo.onPointerEnter
        self.onPointerExit = itemInfo.onPointerExit
        self.clickCallback = itemInfo.clickCallback
        self.BeginDragCallBack = itemInfo.BeginDragCallBack
        self.OnDragCallBack = itemInfo.OnDragCallBack
        self.EndDragCallBack = itemInfo.EndDragCallBack
    end
    self.itemObjectName = "RogueSlideItem"
    if not self.assetLoader then
        self.assetLoader = AssetMgrProxy.Instance:GetLoader("RogueSlideItemLoader")
    end
    
    self.object = obj
    if self.object then
        self:InitItem()
        self.loadObj = false
    else
        --没有object就只能自己创建
        self:CreatItem()
        self.loadObj = true
    end
end

function RogueSlideItem:CreatItem()
    local item = PoolManager.Instance:Pop(PoolType.object, self.itemObjectName)
    
    if not item then
        local callback = function()
            self.object = self.assetLoader:Pop(itemPrefab)
            --设置父节点
            UtilsUI.AddUIChild(self.parent, self.object)
            self:InitItem()
        end

        local resList = {
            {path = itemPrefab, type = AssetType.Prefab}
        }
        self.assetLoader:AddListener(callback)
        self.assetLoader:LoadAll(resList)
    else
        self.object = item
        --设置父节点
        UtilsUI.AddUIChild(self.parent, self.object)
        self:InitItem()
    end
end

function RogueSlideItem:__delete()
    if self.loadObj and self.object then
        PoolManager.Instance:Push(PoolType.object, self.itemObjectName, self.object)
    end
    if self.assetLoader then
        AssetMgrProxy.Instance:CacheLoader(self.assetLoader)
        self.assetLoader = nil
    end
end

function RogueSlideItem:InitItem()
    self.node = UtilsUI.GetContainerObject(self.object.transform)
    self:BindListener()
    --根据id获取配置数据
    self:UpdateItem()
end

function RogueSlideItem:BindListener()
    --绑定drag事件
    local dragBehaviour = self.object:GetComponent(UIDragBehaviour)
    if not dragBehaviour then
        dragBehaviour = self.object:AddComponent(UIDragBehaviour)
    end
    dragBehaviour.ignorePass = true
    
    if self.isCanDrag then
        dragBehaviour.onBeginDrag = function(data)
            self:BeginDrag(data)
        end
        dragBehaviour.onDrag = function(data)
            self:OnDrag(data)
        end
        dragBehaviour.onEndDrag = function(data)
            self:EndDrag(data)
        end
    end
    dragBehaviour.onPointerEnter = function(data)
        self:OnPointerEnter(data)
    end
    dragBehaviour.onPointerExit = function(data)
        self:OnPointerExit(data)
    end
end

function RogueSlideItem:UpdateUI(id, obj)
    if self.object and self.node then
        self.cardId = id
        self:InitItem()
    end
end

function RogueSlideItem:UpdateItem()
    local cardCfg = RoguelikeConfig.GetWorldRougeCardConfigById(self.cardId)
    --名字
    self.node.itemName_txt.text = RoguelikeConfig.QualityColor[cardCfg.quality]..cardCfg.name..'</color>'
    --品质
    self:SetQuality(cardCfg.quality)
    --icon
    self:SetIcon(cardCfg)
    --num 
    self:SetNum(self.cardNum)
end

function RogueSlideItem:SetNum(num)
    --是否显示num
    if num > 1 then
        self.node.numBg:SetActive(true)
        self.node.num_txt.text = 'X'..num
    else
        self.node.numBg:SetActive(false)
    end
end

function RogueSlideItem:SetIcon(cardCfg)
    self.node.icon:SetActive(false)
    SingleIconLoader.Load(self.node.icon, cardCfg.icon, function()
        if self.node then
            self.node.icon:SetActive(true)
        end
    end)
    --iconBg
    self.node.typeShowIcon:SetActive(false)
    SingleIconLoader.Load(self.node.typeShowIcon, cardCfg.type_show_icon, function()
        if self.node then
            self.node.typeShowIcon:SetActive(true)
        end
    end)
end

function RogueSlideItem:SetQuality(quality)
    local bgPath = AssetConfig.GetQualitySlideRogueIcon('slideBg'..quality)
    local frontPath = AssetConfig.GetQualitySlideRogueIcon('line'..quality)
    self.node.qualityBg:SetActive(false)
    self.node.qualityLine:SetActive(false)
    AtlasIconLoader.Load(self.node.qualityBg, bgPath, function()
        if self.node then
            self.node.qualityBg:SetActive(true)
        end
    end)
    AtlasIconLoader.Load(self.node.qualityLine, frontPath, function()
        if self.node then
            self.node.qualityLine:SetActive(true)
        end
    end)
end

function RogueSlideItem:SelectItem(isSelect)
    if not self.node then return end 
    self.node.select:SetActive(isSelect)
end

function RogueSlideItem:BeginDrag(data)
    if not self.object then
        return
    end

    if self.BeginDragCallBack then
        self.BeginDragCallBack(data, self.cardId)
    end
end

function RogueSlideItem:OnDrag(data)
    if not self.object then
        return
    end
    if self.OnDragCallBack then
        self.OnDragCallBack(data, self.cardId)
    end
end

function RogueSlideItem:EndDrag(data)
    if not self.object then
        return
    end
    if self.EndDragCallBack then
        self.EndDragCallBack(data, self.cardId)
    end
end

--鼠标悬停事件
function RogueSlideItem:OnPointerEnter(data)
    if not self.object then
        return
    end
    
    if self.onPointerEnter then
        self.onPointerEnter(data, self.cardId, self.index)
    end
end

--鼠标离开事件
function RogueSlideItem:OnPointerExit(data)
    if not self.object then
        return
    end
    
    if self.onPointerExit then
        self.onPointerExit(data, self.cardId, self.index)
    end
end


