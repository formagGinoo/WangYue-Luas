WDmgType5FontAnimObj = BaseClass("WDmgType5FontAnimObj",FontAnimObj)

function WDmgType5FontAnimObj:__init()
    self.path ="Prefabs/UI/Font/dmg_type5_w.prefab"
end

function WDmgType5FontAnimObj:OnCache()
    self.fight.objectPool:Cache(WDmgType5FontAnimObj, self)
end