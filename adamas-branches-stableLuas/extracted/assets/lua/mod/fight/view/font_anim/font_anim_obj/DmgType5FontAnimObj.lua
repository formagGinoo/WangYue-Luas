DmgType5FontAnimObj = BaseClass("DmgType5FontAnimObj",FontAnimObj)

function DmgType5FontAnimObj:__init()
    self.path ="Prefabs/UI/Font/dmg_type5.prefab"
end

function DmgType5FontAnimObj:OnCache()
    self.fight.objectPool:Cache(DmgType5FontAnimObj, self)
end