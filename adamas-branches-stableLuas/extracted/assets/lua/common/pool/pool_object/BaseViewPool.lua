BaseViewPool = BaseClass("BaseViewPool",BasePool)

function BaseViewPool:__init()

end

function BaseViewPool:__delete()

end

function BaseViewPool:OnMoveParent(poolKey,poolObj,parentObj)
    poolObj.gameObject.name = poolKey
    poolObj.transform:SetParent(parentObj.transform)
    UnityUtils.SetLocalPosition(poolObj.transform,0,0,0)
	UnityUtils.SetLocalEulerAngles(poolObj.transform,0,0,0)
	UnityUtils.SetLocalScale(poolObj.transform,1,1,1)
end

function BaseViewPool:OnRemove(poolKey,poolObj)
    poolObj:Destroy()
end

function BaseViewPool:OnPush(poolKey,poolObj,parentObj)
    poolObj:Hide()
    poolObj:OnReset()
end