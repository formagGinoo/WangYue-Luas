BindIconObj = BaseClass("BindIconObj", BindObjBase)
local objPrefab = "Prefabs/UI/Fight/BindChild/BindChildIconObj.prefab"

function BindIconObj:GetObject()
    local obj = PoolManager.Instance:Pop(PoolType.object, "BindIconObj")
    if not obj then
        local callback = function ()
            local object = self.assertLoader:Pop(objPrefab)
            self:OnLoadDone(object)
            if self.assertLoader then
                AssetMgrProxy.Instance:CacheLoader(self.assertLoader)
                self.assertLoader = nil
            end
        end
        local resList = {
            {path = objPrefab, type = AssetType.Prefab}
        }
        if self.assertLoader then
            AssetMgrProxy.Instance:CacheLoader(self.assertLoader)
            self.assertLoader = nil
        end
        self.assertLoader = AssetMgrProxy.Instance:GetLoader("BindIconObjLoader")
        self.assertLoader:AddListener(callback)
        self.assertLoader:LoadAll(resList)
        return false
    end
    return true, obj
end

--[[
    data结构：{挂点名字，图片路径}
]]
function BindIconObj:InitView(cacheData)
    if not self.gameObject then
        return
    end
    local data = cacheData or self.data
    self.node.Icon:SetActive(false)
    SingleIconLoader.Load(self.node.Icon, data[2])
    self.cacheData = nil
end

function BindIconObj:UpdateShow(distance)
    if not self.node then return end
    for i = 1, #BindObjBase.DistanceThreshold do
        self.node.Icon:SetActive(distance < BindObjBase.DistanceThreshold[i])
    end
end

function BindIconObj:OnReset()
    if self.gameObject then
        PoolManager.Instance:Push(PoolType.object, "BindIconObj", self.gameObject)
    end
    self.gameObject = nil
    self.instanceId = nil
    self.entity = nil
    self.parent = nil
    self.timer = 0
    self.cacheData = nil
    self.type = nil
end