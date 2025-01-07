CoopDisplayPanel = BaseClass("CoopDisplayPanel", BasePanel)

function CoopDisplayPanel:__init(parent, blurRadius)
    self:SetAsset("Prefabs/UI/Fight/Coop/CoopDisplayPanel.prefab")

    self.parent = parent
    self.closeTimer = nil
    self.mainImg = nil
    self.mainName = nil
    self.subImg = nil
    self.subName = nil
    self.backRadius = blurRadius and blurRadius or 1
end

function CoopDisplayPanel:__delete()
    if self.closeTimer then
        LuaTimerManager.Instance:RemoveTimer(self.closeTimer)
		self.closeTimer = nil
    end

end

function CoopDisplayPanel:__Hide()
    if self.blurBack then
        self.blurBack:Hide()
    end
end

function CoopDisplayPanel:__Show()
    SingleIconLoader.Load(self.Main, self.mainImg)
    SingleIconLoader.Load(self.MainName, self.mainName)
    SingleIconLoader.Load(self.Sub, self.subImg)
    SingleIconLoader.Load(self.SubName, self.subName)

    self.Character:SetActive(true)
end

function CoopDisplayPanel:__ShowComplete()
    local setting = { blurRadius = self.blurRadius}
    if not self.blurBack then
        self.blurBack = BlurBack.New(self, setting)
    end
    
    self:SetActive(false)
    self.blurBack:Show()
    self.closeTimer = LuaTimerManager.Instance:AddTimer(1, 2, self:ToFunc("Close"))
end

function CoopDisplayPanel:SetCoopCharacter(main, sub)
    local mainImg, mainName = AssetConfig.GetCoopCharacterAndName(main)
    local subImg, subName = AssetConfig.GetCoopCharacterAndName(sub)

    self.mainImg = mainImg
    self.mainName = mainName
    self.subImg = subImg
    self.subName = subName
end

function CoopDisplayPanel:Close()
    self:Hide()
end