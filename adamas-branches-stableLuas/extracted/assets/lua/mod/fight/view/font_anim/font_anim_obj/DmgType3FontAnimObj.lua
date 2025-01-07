DmgType3FontAnimObj = BaseClass("DmgType3FontAnimObj",FontAnimObj)

function DmgType3FontAnimObj:__init()
    self.path ="Prefabs/UI/Font/dmg_type3.prefab"
end

function DmgType3FontAnimObj:OnCache()
    self.fight.objectPool:Cache(DmgType3FontAnimObj, self)
end