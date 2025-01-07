SetVolumePanel = BaseClass("SetVolumePanel", BasePanel)

function SetVolumePanel:__init()
    self.ctrl = mod.GameSetCtrl
    self:SetAsset("Prefabs/UI/GameSet/SetVolumePanel.prefab")
end

function SetVolumePanel:__Create()
 
end

function SetVolumePanel:__BindListener()
    self.TotalSlider_sld.onValueChanged:AddListener(self:ToFunc("OnTotalVolumeChange"))
    self.MusicSlider_sld.onValueChanged:AddListener(self:ToFunc("OnMusicVolumeChange"))
    self.EffectSlider_sld.onValueChanged:AddListener(self:ToFunc("OnEffectVolumeChange"))
    self.LanSlider_sld.onValueChanged:AddListener(self:ToFunc("OnLanVolumeChange"))
    self.btnSelectLan_btn.onClick:AddListener(self:ToFunc("OnSelectLanguage"))
    self.lanMenu_btn.onClick:AddListener(self:ToFunc("OnHideSelectLanguage"))
end

function SetVolumePanel:__Show()
    -- 设置默认保存音量
    for saveKey, v in pairs(GameSetConfig.Volume) do
        local volume = self.ctrl:GetVolume(saveKey)
        self[v.SetUIFun](self, volume)
    end
end

function SetVolumePanel:OnTotalVolumeChange()
    self:SetTotalVolume(math.floor(self.TotalSlider_sld.value), true)
end

function SetVolumePanel:OnMusicVolumeChange()
    self:SetMusicVolume(math.floor(self.MusicSlider_sld.value), true)
end

function SetVolumePanel:OnEffectVolumeChange()
    self:SetEffectVolume(math.floor(self.EffectSlider_sld.value), true)
end

function SetVolumePanel:OnLanVolumeChange()
    self:SetLanVolume(math.floor(self.LanSlider_sld.value), true)
end

function SetVolumePanel:SetTotalVolume(volume, bSave)
    self.TotalVolumeOpen:SetActive(volume > 0)
    self.TotalVolumeClose:SetActive(volume == 0)
    self.TotalVolume_txt.text = tostring(volume)

    if bSave then
       self.ctrl:SetVolume(GameSetConfig.SaveKey.VolumeTotal, volume)
    else
        self.TotalSlider_sld.value = volume
    end
end

function SetVolumePanel:SetMusicVolume(volume, bSave)
    self.MusicVolumeOpen:SetActive(volume > 0)
    self.MusicVolumeClose:SetActive(volume == 0)
    self.MusicVolume_txt.text = tostring(volume)

    if bSave then
       self.ctrl:SetVolume(GameSetConfig.SaveKey.VolumeMusic, volume)
    else
        self.MusicSlider_sld.value = volume
    end
end

function SetVolumePanel:SetEffectVolume(volume, bSave)
    self.EffectVolumeOpen:SetActive(volume > 0)
    self.EffectVolumeClose:SetActive(volume == 0)
    self.EffectVolume_txt.text = tostring(volume)

    if bSave then
       self.ctrl:SetVolume(GameSetConfig.SaveKey.VolumeEffect, volume)
    else
        self.EffectSlider_sld.value = volume
    end
end

function SetVolumePanel:SetLanVolume(volume, bSave)
    self.LanVolumeOpen:SetActive(volume > 0)
    self.LanVolumeClose:SetActive(volume == 0)
    self.LanVolume_txt.text = tostring(volume)

    if bSave then
        self.ctrl:SetVolume(GameSetConfig.SaveKey.VolumeLanguage, volume)
    else
        self.LanSlider_sld.value = volume
    end
end

function SetVolumePanel:OnSelectLanguage()
    if self.lanMenu.gameObject.activeSelf then
        self.lanMenu:SetActive(false)
    else
        self.lanMenu:SetActive(true)
    end
end

function SetVolumePanel:OnHideSelectLanguage()
    self.lanMenu:SetActive(false)
end