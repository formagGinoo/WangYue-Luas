NightMareBuffIcon = BaseClass("NightMareBuffIcon", BaseView)
--bufficon： 能响应拖动函数

local itemPrefab = "Prefabs/UI/NightMareDuplicate/NightMareBuffIcon.prefab"

--[[
    parent : 父节点
    buffId : buffId 
    clickCallback : 点击callback
    isCanDrag : 是否打开drag操作
]]--
function NightMareBuffIcon:__init(itemInfo)
    self:SetAsset(itemPrefab)
    self.parent = itemInfo.parent
    self.parentClass = itemInfo.parentClass
    self.buffId = itemInfo.buffId
    self.pointId = itemInfo.pointId
    
    --UI系列事件
    self.isCanDrag = itemInfo.isCanDrag
    self.clickCallback = itemInfo.clickCallback
    self.BeginDragCallBack = itemInfo.BeginDragCallBack
    self.OnDragCallBack = itemInfo.OnDragCallBack
    self.EndDragCallBack = itemInfo.EndDragCallBack
end

function NightMareBuffIcon:__Show()
	self.transform:SetParent(self.parent)
    self:UpdateItem()
end

function NightMareBuffIcon:__delete()
    if self.assetLoader then
        self.assetLoader:DeleteMe()
        self.assetLoader = nil
    end
    if self.node then
        self.node.cardItemBack_btn.onClick:RemoveAllListeners()
    end
    if self.object then
        PoolManager.Instance:Push(PoolType.object, self.itemObjectName, self.object)
    end
end

function NightMareBuffIcon:CreatItem()
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

function NightMareBuffIcon:LoadItem()
    local item = self:CreatItem()

    if item then
        self.object = item
        self:InitItem()
    end
end

function NightMareBuffIcon:LoadDone()
    self:InitItem()
end

function NightMareBuffIcon:InitItem()
    --设置父节点
    UtilsUI.AddUIChild(self.parent, self.object)
    self.node = UtilsUI.GetContainerObject(self.object.transform)

    --绑定点击事件
    --self.node.cardItemBack_btn.onClick:AddListener(self:ToFunc("OnClickSelf"))
    self:BindListener()
    --根据id获取配置数据
    self:UpdateItem()
end

function NightMareBuffIcon:UpdateCardId(id)
    self.cardId = id
end

function NightMareBuffIcon:BindListener()
    --绑定drag事件
    if self.isCanDrag then
        local dragBehaviour = self.object:GetComponent(UIDragBehaviour)
        if not dragBehaviour then
            dragBehaviour = self.object:AddComponent(UIDragBehaviour)
        end
        dragBehaviour.ignorePass = true
        dragBehaviour.onPointerDown = function(data)
            self:OnPointerDown(data)
        end
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
end

function NightMareBuffIcon:UpdateDrag(isCanDrag)
    self.isCanDrag = isCanDrag
    self:BindListener()
end

function NightMareBuffIcon:UpdateItem()
    local buffCfg = NightMareConfig.GetDataSystemBuff(self.buffId)
    --品质
    --self:SetQuality(buffCfg.quality)
    --底图
    --SingleIconLoader.Load(self.node.cardItemBack, buffCfg.icon)
    --特效
    --self:UpdateEffect()
end

function NightMareBuffIcon:SetQuality(quality)
    local frontPath = AssetConfig.GetQualityRogueIcon(quality)
    AtlasIconLoader.Load(self.node.qualityFront, frontPath)
end

function NightMareBuffIcon:UpdateEffect()
    
end

function NightMareBuffIcon:OnClickSelf()
    if self.clickCallback then
        --刷新特效
        self:UpdateEffect()
        self.clickCallback(self.buffId)
    end
end

function NightMareBuffIcon:OnPointerDown(data)
    if not self.object then
        return
    end
    if self.onPointerDown then
        self.onPointerDown(data, self.buffId)
    end
end

function NightMareBuffIcon:BeginDrag(data)
    if not self.object then
        return
    end
    if self.BeginDragCallBack then
        self.BeginDragCallBack(data, self.buffId)
    end
end

function NightMareBuffIcon:OnDrag(data)
    if not self.object then
        return
    end
    if self.OnDragCallBack then
        self.OnDragCallBack(data, self.buffId)
    end
end

function NightMareBuffIcon:EndDrag(data)
    if not self.object then
        return
    end
    if self.EndDragCallBack then
        self.EndDragCallBack(data, self.buffId)
    end
end
