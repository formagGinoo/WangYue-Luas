WDmgType6FontAnimObj = BaseClass("WDmgType6FontAnimObj",FontAnimObj)

function WDmgType6FontAnimObj:__init()
    self.path ="Prefabs/UI/Font/dmg_type6_w.prefab"
end

function WDmgType6FontAnimObj:OnCache()
    self.fight.objectPool:Cache(WDmgType6FontAnimObj, self)
end