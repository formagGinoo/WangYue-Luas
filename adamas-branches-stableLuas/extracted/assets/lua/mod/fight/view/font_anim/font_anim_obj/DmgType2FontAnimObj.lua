DmgType2FontAnimObj = BaseClass("DmgType2FontAnimObj",FontAnimObj)

function DmgType2FontAnimObj:__init()
    self.path ="Prefabs/UI/Font/dmg_type2.prefab"
end

function DmgType2FontAnimObj:OnCache()
    self.fight.objectPool:Cache(DmgType2FontAnimObj, self)
end