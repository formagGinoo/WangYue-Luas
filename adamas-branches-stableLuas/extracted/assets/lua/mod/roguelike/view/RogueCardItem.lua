RogueCardItem = BaseClass("RogueCardItem")
--卡牌： 能响应拖动函数

local itemPrefab = "Prefabs/UI/WorldRogue/RogueCardItem.prefab"

--[[
    parent : 父节点
    cardId : 卡牌id 
    cardLevel : 卡牌等级
    clickCallback : 点击callback
    isCanDrag : 是否打开drag操作
]]--
function RogueCardItem:__init(itemInfo, obj)
    self:SetItemInfo(itemInfo)
    
    self.itemObjectName = "RogueCardItem"
    self.assetLoader = AssetMgrProxy.Instance:GetLoader("RogueCardItemLoader")
    self.object = obj
    if not self.object then
        self:LoadItem()
        self.loadObj = true
    else
        self:InitItem()
        self.loadObj = false
    end
end

function RogueCardItem:SetItemInfo(itemInfo)
    self.parent = itemInfo.parent
    self.parentClass = itemInfo.parentClass
    self.cardId = itemInfo.id
    self.cardNum = itemInfo.num or 1
    --UI系列事件
    self.isCanDrag = itemInfo.isCanDrag
    self.isEquip = itemInfo.isEquip or false
    self.clickCallback = itemInfo.clickCallback
    self.BeginDragCallBack = itemInfo.BeginDragCallBack
    self.OnDragCallBack = itemInfo.OnDragCallBack
    self.EndDragCallBack = itemInfo.EndDragCallBack
    self.InsKey = itemInfo.InsKey
end

function RogueCardItem:__delete()
    if self.assetLoader then
        AssetMgrProxy.Instance:CacheLoader(self.assetLoader)
        self.assetLoader = nil
    end
    if self.loadObj and self.object then
        PoolManager.Instance:Push(PoolType.object, self.itemObjectName, self.object)
    end
end

function RogueCardItem:CreatItem()
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

function RogueCardItem:LoadItem()
    local item = self:CreatItem()
    
    if item then
        self.object = item
        self:InitItem()
    end
end

function RogueCardItem:LoadDone()
    self:InitItem()
end

function RogueCardItem:InitItem()
    if self.parentClass then
        self.isSelect = self.parentClass:CheckSelectCard(self.InsKey)
    end
    if self.parent then
        --设置父节点
        UtilsUI.AddUIChild(self.parent, self.object)
    end
    UtilsUI.SetActive(self.object, true)
    self.node = UtilsUI.GetContainerObject(self.object.transform)
    self.node.Select:SetActive(self.isSelect or false)

    --绑定点击事件
    self.node.cardItemBack_btn.onClick:RemoveAllListeners()
    self.node.cardItemBack_btn.onClick:AddListener(self:ToFunc("OnClickSelf"))
    self:BindListener()
    --根据id获取配置数据
    self:UpdateItem()
end

function RogueCardItem:BindListener()
    --绑定drag事件
    local dragBehaviour = self.object:GetComponent(UIDragBehaviour)
    if self.isCanDrag and not dragBehaviour then
        dragBehaviour = self.object:AddComponent(UIDragBehaviour)
    end
    if self.isCanDrag then
        dragBehaviour.ignorePass = true
        dragBehaviour.onBeginDrag = function(data)
            self:BeginDrag(data)
        end
        dragBehaviour.onDrag = function(data)
            self:OnDrag(data)
        end
        dragBehaviour.onEndDrag = function(data)
            self:EndDrag(data)
        end
    else
        --绑定drag事件
        if not dragBehaviour then
            return 
        end
        dragBehaviour.onBeginDrag = nil
        dragBehaviour.onDrag = nil
        dragBehaviour.onEndDrag = nil
    end
end

function RogueCardItem:UpdateDrag(isCanDrag)
    self.isCanDrag = isCanDrag
    self:BindListener()
end

function RogueCardItem:UpdateUI(itemInfo)
    self:SetItemInfo(itemInfo)
    self:InitItem()
end

function RogueCardItem:UpdateItem()
    local cardCfg = RoguelikeConfig.GetWorldRougeCardConfigById(self.cardId)
    if not cardCfg then
        LogErrorf("找不到这张卡牌的配置,id: "..self.cardId)
        return 
    end
    --名字
    self.node.cardName_txt.text = RoguelikeConfig.QualityColor[cardCfg.quality]..cardCfg.name..'</color>'
    --type 
    self.node.typeName_txt.text = cardCfg.type
    --typeText
    self.node.typeText_txt.text = cardCfg.name_pinyin
    --icon
    self:SetIcon(cardCfg)
    --品质
    self:SetQuality(cardCfg.quality)
    --des 
    self:SetDesc(self.cardId, self.cardNum)
    --num
    self:SetNum(self.cardNum)
    --是否装备
    self:SetEquip(self.isEquip)
    --特效
    self:UpdateEffect(self.cardId)
end

function RogueCardItem:SetDesc(cardId, cardNum)
    --对卡牌数量做保底限制
    local maxCardNum = mod.RoguelikeCtrl:GetRogueCardVersionMaxNum(cardId)
    cardNum = cardNum > maxCardNum and maxCardNum or cardNum
    
    local levelCfg = RoguelikeConfig.GetWorldRougeCardLevelConfigById(cardId, cardNum)
    if levelCfg then
        --描述
        --magic_id
        self.node.des_txt.text = levelCfg.desc
    end
end

function RogueCardItem:SetNum(num)
    --是否显示num
    local isShowNumBg = false
    if num > 1 then
        isShowNumBg = true
        self.node.num_txt.text = 'X'..num
    end
    self.node.numRoot:SetActive(isShowNumBg)
end

--已经加持
function RogueCardItem:SetEquip(isEquip)
    -- 是否已装备
    self.node.isEquiped:SetActive(isEquip)
end

function RogueCardItem:SetIcon(cardCfg)
    --icon
    SingleIconLoader.Load(self.node.icon, cardCfg.icon)
    --type_icon
    SingleIconLoader.Load(self.node.typeIcon, cardCfg.type_icon)
end

function RogueCardItem:SetQuality(quality)
    local frontPath = AssetConfig.GetQualityCardRogueIcon('front'..quality)
    AtlasIconLoader.Load(self.node.qualityFront, frontPath)
    local qualityPath = AssetConfig.GetQualityCardRogueIcon('bg'..quality)
    AtlasIconLoader.Load(self.node.qualityBg, qualityPath)
    local qualitycircle = AssetConfig.GetQualityCardRogueIcon('circle'..quality)
    AtlasIconLoader.Load(self.node.qualityCircle, qualitycircle)
end

function RogueCardItem:UpdateEffect(cardId)
    local isShowEffect = mod.RoguelikeCtrl:GetNewCardRed(cardId)
    self.node.effect:SetActive(isShowEffect or false)
end

function RogueCardItem:OnClickSelf()
    if self.parentClass and self.parentClass.isRestart then
        self.isSelect = not self.isSelect
        if self.isSelect and self.parentClass:CheckDiscardBlessedUp() then
            self.isSelect = false
            -- 丢失到达上限
            return
        end
        self.node.Select:SetActive(self.isSelect)
    end

    if self.clickCallback then
        --点击过后清楚红点标记
        mod.RoguelikeCtrl:ClearNewCardRedById(self.cardId)
        --刷新特效
        self:UpdateEffect()
        self.clickCallback(self.cardId, self.isSelect, self.InsKey)
    end
end

function RogueCardItem:BeginDrag(data)
    if not self.object then
        return
    end
    if self.BeginDragCallBack then
        self.BeginDragCallBack(data, self.cardId)
    end
end

function RogueCardItem:OnDrag(data)
    if not self.object then
        return
    end
    if self.OnDragCallBack then
        self.OnDragCallBack(data, self.cardId)
    end
end

function RogueCardItem:EndDrag(data)
    if not self.object then
        return
    end
    if self.EndDragCallBack then
        self.EndDragCallBack(data, self.cardId)
    end
end
