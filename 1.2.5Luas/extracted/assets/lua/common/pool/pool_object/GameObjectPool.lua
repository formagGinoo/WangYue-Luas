GameObjectPool = BaseClass("GameObjectPool",BasePool)

function GameObjectPool:__init()

end

function GameObjectPool:__delete()

end

function GameObjectPool:OnCheckNormal(poolKey,poolObj)
    return true
end

function GameObjectPool:OnMoveParent(poolKey,poolObj,parentObj)
    poolObj.gameObject.name = poolKey
    poolObj.transform:SetParent(parentObj.transform)
    UnityUtils.SetLocalPosition(poolObj.transform,0,0,0)
	UnityUtils.SetLocalEulerAngles(poolObj.transform,0,0,0)
	UnityUtils.SetLocalScale(poolObj.transform,1,1,1)
end

function GameObjectPool:OnRemove(poolKey,poolObj)
    poolObj:Destroy()
end

function GameObjectPool:OnPush(poolKey,poolObj,parentObj)
    poolObj.gameObject:SetActive(true)
end

function GameObjectPool:OnCheckClear()

end 