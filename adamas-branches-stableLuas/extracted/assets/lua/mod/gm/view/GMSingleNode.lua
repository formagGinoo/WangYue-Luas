GMSingleNode = BaseClass("GMSingleNode")
--数组节点

local itemPrefab = "Prefabs/UI/Gm/SingleNode.prefab"

--[[
    parent : 父节点 
]]--
function GMSingleNode:__init(name, parent)
    self.object = nil
    self.parent = parent
    self.name = name
    self.itemObjectName = "SingleNode"
    if not self.assetLoader then
        self.assetLoader = AssetMgrProxy.Instance:GetLoader("SingleNodeLoader")
    end
    self:CreatItem()
end

function GMSingleNode:CreatItem()
    local item = PoolManager.Instance:Pop(PoolType.object, self.itemObjectName)

    if not item then
        local callback = function()
            self.object = self.assetLoader:Pop(itemPrefab)
            --设置父节点
            self.object.transform:SetParent(self.parent.transform)
            self.object.transform.localScale = Vector3.one
            --UtilsUI.AddUIChild(self.parent, self.object)
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
        self.object.transform:SetParent(self.parent.transform)
        self.object.transform.localScale = Vector3.one
        --UtilsUI.AddUIChild(self.parent, self.object)
        self:InitItem()
    end
end

function GMSingleNode:__delete()
    if self.object then
        PoolManager.Instance:Push(PoolType.object, self.itemObjectName, self.object)
    end
    if self.assetLoader then
        AssetMgrProxy.Instance:CacheLoader(self.assetLoader)
        self.assetLoader = nil
    end
    self.SearchTextTmp.text = ""
end

function GMSingleNode:InitItem()
    self.node = UtilsUI.GetContainerObject(self.object.transform)
    self:BindListener()
    --根据id获取配置数据
    self:UpdateItem()
end

function GMSingleNode:BindListener()
    self.SearchTextTmp = self.node.inputField:GetComponent(TMP_InputField)
    --self.SearchTextTmp.onEndEdit:AddListener(self:ToFunc("OnEndEdit"))
end

function GMSingleNode:UpdateItem()
    --通过key的值去实例化不同的预制
    self.node.name_txt.text = self.name
end

function GMSingleNode:GetInput()
    local inputText = self.SearchTextTmp.text
    
    if tonumber(inputText) then 
        inputText = tonumber(inputText)
    elseif inputText == "true" then
        inputText = true
    elseif inputText == "false" then
        inputText = false
	elseif inputText == "" then 
		return 	
    end
    
    return self.name, inputText
end

