DmgType4FontAnimObj = BaseClass("DmgType4FontAnimObj",FontAnimObj)

function DmgType4FontAnimObj:__init()
    self.path ="Prefabs/UI/Font/dmg_type4.prefab"
end

function DmgType4FontAnimObj:OnCache()
    self.fight.objectPool:Cache(DmgType4FontAnimObj, self)
end