WDmgType2FontAnimObj = BaseClass("WDmgType2FontAnimObj",FontAnimObj)

function WDmgType2FontAnimObj:__init()
    self.path ="Prefabs/UI/Font/dmg_type2_w.prefab"
end

function WDmgType2FontAnimObj:OnCache()
    self.fight.objectPool:Cache(WDmgType2FontAnimObj, self)
end