WDmgType3FontAnimObj = BaseClass("WDmgType3FontAnimObj",FontAnimObj)

function WDmgType3FontAnimObj:__init()
    self.path ="Prefabs/UI/Font/dmg_type3_w.prefab"
end

function WDmgType3FontAnimObj:OnCache()
    self.fight.objectPool:Cache(WDmgType3FontAnimObj, self)
end