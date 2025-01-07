AssetsWeaponPool = BaseClass("AssetsWeaponPool", AssetsPool)

function AssetsWeaponPool:__init()
    self.callBacks = {}
    self.referenceCount = 0
end

function AssetsWeaponPool:LoadWeapon(weaponId, callBack)
    self.loader = AssetBatchLoader.New("AssetsWeaponPool"..weaponId)
    self.loaderHelp = FightResuorcesLoadHelp.New()
    if callBack then
		table.insert(self.callBacks,callBack)
	end

    self.loaderHelp:PreloadWeapon(weaponId)
    self:Load()
end

function AssetsWeaponPool:LoadGldier(gliderId, callBack)
    self.loader = AssetBatchLoader.New("AssetsGliderPool"..gliderId)
    self.loaderHelp = FightResuorcesLoadHelp.New()
    if callBack then
		table.insert(self.callBacks,callBack)
	end

    self.loaderHelp:PreloadGlider(gliderId)
    self:Load()
end

function AssetsWeaponPool:Load()
    self.loader:AddListener(self:ToFunc("LoadDone"))
    self.resCount = self.loaderHelp.resList
    self.loader:LoadAll(self.loaderHelp.resList)
end

function AssetsWeaponPool:AddCallBack(callBack)
	if callBack then
		table.insert(self.callBacks, callBack)
	end
end

function AssetsWeaponPool:LoadDone()
    for k, v in pairs(self.loaderHelp.resList) do
        local assets = self:Get(v.path, true)
        if assets.transform then
            self:Cache(v.path, assets)
        end
    end

    for k, v in pairs(self.callBacks) do
		v()
	end
end
