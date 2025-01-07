ClassPool = BaseClass("ClassPool",BasePool)

function ClassPool:__init()

end

function ClassPool:__delete()

end

function ClassPool:OnPush(poolKey,poolObj,parentObj)
    poolObj:OnReset()
end