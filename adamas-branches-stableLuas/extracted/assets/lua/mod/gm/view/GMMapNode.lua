GMMapNode = BaseClass("GMMapNode")
--map节点 

local itemPrefab = "Prefabs/UI/Gm/MapNode.prefab"
local _tinsert = table.insert
--[[
    parent : 父节点 
]]--
function GMMapNode:__init(protoType1, protoType2, name, parent)
    self.isfold = false
    self.object = nil
    self.parent = parent
    self.key = protoType1 --map的键值对第一个（通常为基础类型）
    self.value = protoType2 --map的键值对第2个
    self.name = name
    self.childNodeList = {}--存放childNode的List
    self.itemObjList = {} --存放类的节点的list
    self.itemObjectName = "MapNode"
    if not self.assetLoader then
        self.assetLoader = AssetMgrProxy.Instance:GetLoader("MapNodeLoader")
    end
    self:CreatItem()
end

function GMMapNode:CreatItem()
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
        self.object.transform:SetParent(self.parent.transform)
        self.object.transform.localScale = Vector3.one
        --设置父节点
        --UtilsUI.AddUIChild(self.parent, self.object)
        self:InitItem()
    end
end

function GMMapNode:__delete()
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
    
    self:PushChildNodeItem()
end

function GMMapNode:InitItem()
    self.node = UtilsUI.GetContainerObject(self.object.transform)
    self:BindListener()
    --根据id获取配置数据
    self:UpdateItem()
end

function GMMapNode:BindListener()
    self.node.folded_btn.onClick:RemoveAllListeners()
    self.node.folded_btn.onClick:AddListener(self:ToFunc("OnClickFolded"))
    self.node.add_btn.onClick:RemoveAllListeners()
    self.node.add_btn.onClick:AddListener(self:ToFunc("OnClickAddBtn"))
end

function GMMapNode:UpdateItem()
    --通过type的值去实例化不同的预制
    self.node.name_txt.text = self.name
    self:InstanceChildNode()
    self:UpdateFoldedView()
end


function GMMapNode:InstanceChildNode()
    --实例化ChildNode
    local childNode = self:CreateChildNode()
    _tinsert(self.childNodeList, childNode)

    local container = UtilsUI.GetContainerObject(childNode.transform)
    --再判断key，和value，这里要严格控制key和value节点
    local keyObj = self:GetNodeObj(self.key, container.keyNode)
    local valueObj = self:GetNodeObj(self.value, container.valueNode)
    
    self.itemObjList[keyObj] = valueObj
end

function GMMapNode:GetNodeObj(protoType, parent)
    --判断类型，使用不同的控件，value基本上要么是基础类型要么是struct， 目前未发现map嵌套map，后续可修改-- todo 
    local obj
    if GmConfig.protocolSingleType[protoType] then
        obj = self:GetSingleNode(protoType, parent)
    else
        obj = self:GetStructNode(protoType, protoType, parent)
    end
    return obj
end

--获取结构节点
function GMMapNode:GetStructNode(protoType, name, parent)
    local item = GMStructNode.New(protoType, name, parent)
    return item
end

--获取普通节点
function GMMapNode:GetSingleNode(name, parent)
    local item = GMSingleNode.New(name, parent)
    return item
end

function GMMapNode:CreateChildNode()
    local obj = GameObject.Instantiate(self.node.childNode, self.object.transform)
    UtilsUI.SetActive(obj, true)
    
    return obj
end

function GMMapNode:PushChildNodeItem()
    for i, obj in pairs(self.childNodeList) do
        GameObject.Destroy(obj)
    end
    TableUtils.ClearTable(self.childNodeList)
end

--所有的输入
function GMMapNode:GetInput()
    local data = {}
    for keyNode, valueNode in pairs(self.itemObjList) do
        local keyTypeName, keyChildData = keyNode:GetInput()
        local valueTypeName, valueChildData = valueNode:GetInput()
        if keyChildData ~= "" then
            data[keyChildData] = valueChildData
        end
    end
    return self.name, data
end

function GMMapNode:OnClickFolded()
    self.isfold = not self.isfold
    self:UpdateFoldedView()
end

function GMMapNode:OnClickAddBtn()
    --加号到底是增加struct还是其他的取决于当前的type
    self:InstanceChildNode()
end

function GMMapNode:UpdateFoldedView()
    if self.isfold then
        UnityUtils.SetEulerAngles(self.node.folded.transform, 0,0,0)
    else
        UnityUtils.SetEulerAngles(self.node.folded.transform, 0,0,-90)
    end
    self.node.childNode:SetActive(not self.isfold)
end


