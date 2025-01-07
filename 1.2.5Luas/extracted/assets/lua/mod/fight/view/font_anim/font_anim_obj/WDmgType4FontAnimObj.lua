WDmgType4FontAnimObj = BaseClass("WDmgType4FontAnimObj",FontAnimObj)

function WDmgType4FontAnimObj:__init()
    self.path ="Prefabs/UI/Font/dmg_type4_w.prefab"
end

function WDmgType4FontAnimObj:OnCache()
    self.fight.objectPool:Cache(WDmgType4FontAnimObj, self)
end