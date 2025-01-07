-- 人物全身 Loader
-- 包括RoleTposeLoader、MixRoleTposeLoader
-- @ljh
MixRoleTposeLoader = BaseClass("MixRoleTposeLoader")

function MixRoleTposeLoader:__init(setting, callback, allCompleteCallback)
    self.setting = setting
    self.callback = callback
    self.allCompleteCallback = allCompleteCallback
    -- 是否中途取消
    self.cancel = false
    self.classes = setting.classes
    self.sex = setting.sex
    self.sexTxt = (self.sex == 1 and "male" or "female")
    self.looks = setting.looks 

    self.tpose = nil
    self.headTpose = nil
    self.weapon = nil

    self.roleTposeLoader = nil
    self.weaponTposeLoader = nil
end

function MixRoleTposeLoader:__delete()
    if self.roleTposeLoader ~= nil then
        self.roleTposeLoader:DeleteMe()
        self.roleTposeLoader = nil
    end
    if self.weaponTposeLoader ~= nil then
        self.weaponTposeLoader:DeleteMe()
        self.weaponTposeLoader = nil
    end
end

function MixRoleTposeLoader:Load()
    local callback = function(result) self:BuildRoleTpose(result) end
    self.roleTposeLoader = RoleTposeLoader.New(self.setting, callback)
    self.roleTposeLoader:Load()
end

function MixRoleTposeLoader:Cancel()
    self.cancel = true
    if self.roleTposeLoader ~= nil then
        self.roleTposeLoader:Cancel()
    end
    if self.weaponTposeLoader ~= nil then
        self.weaponTposeLoader:Cancel()
    end
end

function MixRoleTposeLoader:BuildRoleTpose(result)
    if not self.cancel then
        self.callback(result)
        self.tpose = result.tpose

        local callback = function(result) self:BuildWeaponTpose(result) end
        self.weaponTposeLoader = WeaponTposeLoader.New(self.setting, callback)
        self.weaponTposeLoader:Load()
    end
end

function MixRoleTposeLoader:BuildWeaponTpose(result)
    if not self.cancel then
        self.weapon = result.weapon
        self.weapon2 = result.weapon2

        local point = nil
        if self.classes == SceneConstData.Classes.ranger or self.classes == SceneConstData.Classes.devine then
            point = UtilsBase.GetChildPath(self.tpose.transform, "Bip_L_Weapon")
        else
            point = UtilsBase.GetChildPath(self.tpose.transform, "Bip_R_Weapon")
        end

        local t = self.weapon:GetComponent(Transform)
        self.weapon.name = "Mesh_Weapon"
        -- Utils.ChangeLayersRecursively(t, "Model")
        t:SetParent(self.tpose.transform:Find(point))
        t.localPosition = Vector3.zero
        t.localRotation = Quaternion.identity
        t.localScale = Vector3.one

        if self.weapon2 ~= nil then
            local point = UtilsBase.GetChildPath(self.tpose.transform, "Bip_L_Weapon")
            local t2 = self.weapon2:GetComponent(Transform)
            self.weapon2.name = "Mesh_Weapon"
            -- Utils:ChangeLayersRecursively(t2, "Model")
            t2:SetParent(self.tpose.transform:Find(point))
            t2.localPosition = Vector3.zero
            t2.localRotation = Quaternion.identity
            t2.localScale = Vector3.one
        end

        self:AllComplete()
    end
end

function MixRoleTposeLoader:AllComplete()
    if self.allCompleteCallback ~= nil then
        self.allCompleteCallback({ tpose = self.tpose, weapon = self.weapon, weapon2 = self.weapon2 })
    end
end