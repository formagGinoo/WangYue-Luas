DmgType7FontAnimObj = BaseClass("DmgType7FontAnimObj",FontAnimObj)

function DmgType7FontAnimObj:__init()
    self.path ="Prefabs/UI/Font/dmg_type7.prefab"
end

function DmgType7FontAnimObj:OnCache()
    self.fight.objectPool:Cache(DmgType7FontAnimObj, self)
end