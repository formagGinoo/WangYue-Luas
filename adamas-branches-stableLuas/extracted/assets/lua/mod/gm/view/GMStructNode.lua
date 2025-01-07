GMStructNode = BaseClass("GMStructNode")
--数组节点

local itemPrefab = "Prefabs/UI/Gm/StructNode.prefab"
local _tinsert = table.insert
--[[
    parent : 父节点 
]]--
function GMStructNode:__init(protoType, name, parent)
    self.isfold = false
    self.object = nil
    self.parent = parent
    self.protoType = protoType
    self.name = name
    self.itemObjList = {}
    self.itemObjectName = "StructNode"
    if not self.assetLoader then
        self.assetLoader = AssetMgrProxy.Instance:GetLoader("StructNodeLoader")
    end
    self:CreatItem()
end

function GMStructNode:CreatItem()
    local item = PoolManager.Instance:Pop(PoolType.object, self.itemObjectName)

    if not item then
        local callback = function()
            self.object = self.assetLoader:Pop(itemPrefab)
            self.object.transform:SetParent(self.parent.transform)
            self.object.transform.localScale = Vector3.one
            --设置父节点
           -- UtilsUI.AddUIChild(self.parent, self.object)
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

function GMStructNode:__delete()
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

function GMStructNode:InitItem()
    self.node = UtilsUI.GetContainerObject(self.object.transform)
    self:BindListener()
    --根据id获取配置数据
    self:UpdateItem()
end

function GMStructNode:BindListener()
    self.node.folded_btn.onClick:RemoveAllListeners()
    self.node.folded_btn.onClick:AddListener(self:ToFunc("OnClickFolded"))
end

function GMStructNode:UpdateItem()
    --通过type的值去实例化不同的预制
    self.node.name_txt.text = self.name
    self:InstanceChildNode()
    self:UpdateFoldedView()
end


function GMStructNode:InstanceChildNode()
    --查看protoType的类型
    local protoKey = self.protoType
    local proto = GmConfig.ProtocolExportData[protoKey]
    if not proto then
        LogError("该协议结构目前未支持"..protoKey)
        return
    end
    --只要是结构体，必然要循环
    for key, v in pairs(proto) do
        self:InstanceControlNode(key)
    end
end

function GMStructNode:InstanceControlNode(key)
    --判断类型，使用不同的控件
    --长度>=3，(数组 类型 名字)/(map<>)
    --长度为2个, 类型 名字
    --key --读取按__划分 
    local split = StringHelper.Split(key, "__")
    local obj
    if #split == 2 then
        if GmConfig.protocolSingleType[split[1]] then
            obj = self:GetSingleNode(split[2], self.node.childNode)
        else
            obj = self:GetStructNode(split[1], split[1], self.node.childNode)
        end
    else
        if split[1] == "repeated" then
            obj = self:GetRepeatedNode(split[2], split[3], self.node.childNode)
        elseif split[1] == "map" then
            obj = self:GetMapNode(split[2], split[3], split[5],self.node.childNode)
        end
    end
    _tinsert(self.itemObjList, obj)
end

--获取数组节点
function GMStructNode:GetRepeatedNode(protoType, name, parent)
    local item = GMRepeatedNode.New(protoType, name, parent)
    return item
end

--获取结构节点
function GMStructNode:GetStructNode(protoType, name, parent)
    local item = GMStructNode.New(protoType, name, parent)
    return item
end

--获取普通节点
function GMStructNode:GetSingleNode(key, parent)
    local item = GMSingleNode.New(key, parent)
    return item
end

--获取map节点
function GMStructNode:GetMapNode(protoType1, protoType2, name, parent)
    local item = GMMapNode.New(protoType1, protoType2, name, parent)
    return item
end

function GMStructNode:GetInput()
    local data = {}
    for i, node in pairs(self.itemObjList) do
        local name, childData = node:GetInput()
        data[name] = childData
    end
    
    return self.name, data
end

function GMStructNode:OnClickFolded()
    self.isfold = not self.isfold
    self:UpdateFoldedView()
end

function GMStructNode:UpdateFoldedView()
    if self.isfold then
        UnityUtils.SetEulerAngles(self.node.folded.transform, 0,0,0)
    else
        UnityUtils.SetEulerAngles(self.node.folded.transform, 0,0,-90)
    end
    self.node.childNode:SetActive(not self.isfold)
end


