-- 武器 Loader
-- @ljh
WeaponTposeLoader = BaseClass("WeaponTposeLoader")

function WeaponTposeLoader:__init(setting, callback)
    self.setting = setting
    self.callback = callback
    -- 是否中途取消
    self.cancel = false
    self.classes = setting.classes
    self.sex = setting.sex
    self.sexTxt = (self.sex == 1 and "male" or "female")
    self.looks = setting.looks 

    self.weapon = nil
    self.weapon2 = nil

    self.assetLoader = nil

    -- 分包逻辑需要使用的内容
    self.resData = {
        classes = self.classes
        ,sex = self.sex

        ,weaponId = nil
        ,weaponPath = ""
    }

    for k, v in pairs(self.looks) do
        if v.looks_type == LooksType.Weapon then
            if v.looks_val then
                -- FIX ME
                self.resData.weaponId = 10001
                self.resData.weaponPath = string.format("Unit/Weapon/Prefab/%s.prefab", self.resData.weaponId)
            end
        end
    end
    -- 应该取默认值
    if self.resData.weaponPath == "" then
        self.resData.weaponId = 10001
        self.resData.weaponPath = string.format("Unit/Weapon/Prefab/%s.prefab", self.resData.weaponId)
    end
end

function WeaponTposeLoader:__delete()
    if self.assetLoader ~= nil then
        self.assetLoader:DeleteMe()
        self.assetLoader = nil
    end
end

function WeaponTposeLoader:Load()
    local resList = {
        {path = self.resData.weaponPath, type = AssetType.Prefab}
    }
    
    local callback = function()
        if self.cancel then
            self.assetLoader:DeleteMe()
            self.assetLoader = nil
        else
            self:BuildTpose()
        end
    end
    self.assetLoader = AssetBatchLoader.New("WeaponTposeLoader[" .. self.resData.weaponId.. "]");
    self.assetLoader:AddListener(callback)
    self.assetLoader:LoadAll(resList)
end

function WeaponTposeLoader:Cancel()
    self.cancel = true
end

function WeaponTposeLoader:BuildTpose()
    if self.assetLoader == nil then
        return
    end
    self.weapon = self.assetLoader:Pop(self.resData.weaponPath)
    self.weapon.name = "weapon"

    if self.classes == SceneConstData.Classes.gladiator then
        self.weapon2 = AssetMgrProxy.Instance:CloneGameObject(self.weapon)
    end

    if self.callback ~= nil then
        self.callback({weapon = self.weapon, weapon2 = self.weapon2 })
    end
    self.assetLoader:DeleteMe()
    self.assetLoader = nil
end
