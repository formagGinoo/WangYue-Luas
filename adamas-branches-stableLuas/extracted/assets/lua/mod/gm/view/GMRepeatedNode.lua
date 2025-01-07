GMRepeatedNode = BaseClass("GMRepeatedNode")
--数组节点
local itemPrefab = "Prefabs/UI/Gm/RepeatedNode.prefab"
local _tinsert = table.insert
--[[
    parent : 父节点 
]]--
function GMRepeatedNode:__init(protoType, name, parent)
    self.isfold = false
    self.object = nil
    self.parent = parent
    self.protoType = protoType
    self.name = name
    self.itemObjList = {}
    self.itemObjectName = "RepeatedNode"
    if not self.assetLoader then
        self.assetLoader = AssetMgrProxy.Instance:GetLoader("RepeatedNodeLoader")
    end
    self:CreatItem()
end

function GMRepeatedNode:CreatItem()
    local item = PoolManager.Instance:Pop(PoolType.object, self.itemObjectName)

    if not item then
        local callback = function()
            self.object = self.assetLoader:Pop(itemPrefab)
            self.object.transform:SetParent(self.parent.transform)
            self.object.transform.localScale = Vector3.one
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

function GMRepeatedNode:__delete()
    self.isfold = false
    if self.object then
        PoolManager.Instance:Push(PoolType.object, self.itemObjectName, self.object)
    end
    if self.assetLoader then
        AssetMgrProxy.Instance:CacheLoader(self.assetLoader)
        self.assetLoader = nil
    end
    for i, v in pairs(self.itemObjList) do
        v:DeleteMe()
    end
    TableUtils.ClearTable(self.itemObjList)
end

function GMRepeatedNode:InitItem()
    self.node = UtilsUI.GetContainerObject(self.object.transform)
    self:BindListener()
    --根据id获取配置数据
    self:UpdateItem()
end

function GMRepeatedNode:BindListener()
    self.node.folded_btn.onClick:RemoveAllListeners()
    self.node.folded_btn.onClick:AddListener(self:ToFunc("OnClickFolded"))
    self.node.add_btn.onClick:RemoveAllListeners()
    self.node.add_btn.onClick:AddListener(self:ToFunc("OnClickAddBtn"))
end

function GMRepeatedNode:UpdateItem()
    self.node.name_txt.text = self.name
    --通过type的值去实例化不同的预制
    self:InstanceChildNode()
    self:UpdateFoldedView()
end

function GMRepeatedNode:InstanceChildNode()
    --查看protoType的类型
    local protoKey = self.protoType
    local obj
    
    --值类型
    if GmConfig.protocolSingleType[protoKey] then
        obj = self:GetSingleNode(protoKey, self.node.childNode)
    else
        --代表是结构体类型
        obj = self:GetStructNode(protoKey, protoKey, self.node.childNode)
    end
    _tinsert(self.itemObjList, obj)
end

--获取结构节点
function GMRepeatedNode:GetStructNode(protoType, name, parent)
    local item = GMStructNode.New(protoType, name, parent)
    return item
end

--获取普通节点
function GMRepeatedNode:GetSingleNode(name, parent)
    local item = GMSingleNode.New(name, parent)
    return item
end

--所有的输入
function GMRepeatedNode:GetInput()
    local data = {}
    for i, node in pairs(self.itemObjList) do
        local name, childData = node:GetInput()
        _tinsert(data, childData)
    end
    return self.name, data
end

function GMRepeatedNode:OnClickFolded()
    self.isfold = not self.isfold
    self:UpdateFoldedView()
end

function GMRepeatedNode:UpdateFoldedView()
    if self.isfold then
        UnityUtils.SetEulerAngles(self.node.folded.transform, 0,0,0)
    else
        UnityUtils.SetEulerAngles(self.node.folded.transform, 0,0,-90)
    end
    self.node.childNode:SetActive(not self.isfold)
end

function GMRepeatedNode:OnClickAddBtn()
    --加号到底是增加struct还是其他的取决于当前的type
    self:InstanceChildNode()
end


