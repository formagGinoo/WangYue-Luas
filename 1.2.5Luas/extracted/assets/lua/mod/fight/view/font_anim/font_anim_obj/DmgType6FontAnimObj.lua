DmgType6FontAnimObj = BaseClass("DmgType6FontAnimObj",FontAnimObj)

function DmgType6FontAnimObj:__init()
    self.path ="Prefabs/UI/Font/dmg_type6.prefab"
end

function DmgType6FontAnimObj:OnCache()
    self.fight.objectPool:Cache(DmgType6FontAnimObj, self)
end