DmgType1FontAnimObj = BaseClass("DmgType1FontAnimObj",FontAnimObj)

function DmgType1FontAnimObj:__init()
    self.path ="Prefabs/UI/Font/dmg_type1.prefab"
end

function DmgType1FontAnimObj:OnCache()
    self.fight.objectPool:Cache(DmgType1FontAnimObj, self)
end