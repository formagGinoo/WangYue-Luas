FormationCoverPanel = BaseClass("FormationCoverPanel", BasePanel)

function FormationCoverPanel:__init()
    self:SetAsset("Prefabs/UI/Formation/FormationCoverPanel.prefab")
end

function FormationCoverPanel:__CacheObject()
    self:SetCacheMode(UIDefine.CacheMode.destroy)
end

function FormationCoverPanel:__Create()
    self.oldRole = {}
    self.newRole = {}
    for i = 1, 3, 1 do
        self.oldRole[i] = {}
        self.newRole[i] = {}
        UtilsUI.GetContainerObject(self["OldRole"..i.."_rect"], self.oldRole[i])
        UtilsUI.GetContainerObject(self["NewRole"..i.."_rect"], self.newRole[i])
    end
end

function FormationCoverPanel:__BindListener()
    self:SetHideNode("CommonTipPart_Exit")
    self:BindCloseBtn(self.Cancel_btn,self:ToFunc("Back"))
    self:BindCloseBtn(self.CommonBack1_btn,self:ToFunc("Back"))
    self:BindCloseBtn(self.Submit_btn,self:ToFunc("Back"),self:ToFunc("SubmitFun"))
end

function FormationCoverPanel:__Hide()
    if self.blurBack then
        self.blurBack:Hide()
    end
end

function FormationCoverPanel:__Show()
    self.curId = self.args.curId
    self:ShowDetail()
end

function FormationCoverPanel:__ShowComplete()
    if not self.blurBack then
        local setting = { passEvent = UIDefine.BlurBackCaptureType.Scene, blurRadius = 3, bindNode = self.BlurBack }
        self.blurBack = BlurBack.New(self, setting)
    end
    self:SetActive(false)
    self.blurBack:Show({function ()
        self:SetActive(true)
    end})
end

function FormationCoverPanel:ShowDetail()
    local curList = mod.FormationCtrl:GetFormationInfo(self.curId).roleList
    local targetList = mod.FormationCtrl:GetFormationInfo(0).roleList

    for i = 1, 3, 1 do
        local oldId = curList[i] or 0
        local oldRoleObj = self.oldRole[i]
        oldRoleObj.Null:SetActive(oldId == 0)
        oldRoleObj.NotNull:SetActive(oldId ~= 0)
        if oldId ~= 0 then
            local config = ItemConfig.GetItemConfig(oldId)
            local frontImg, backImg = ItemManager.GetItemColorImg(config.quality)
            local backPath = AssetConfig.GetQualityIcon(backImg)
            --SingleIconLoader.Load(itemObj.QualityFront, frontPath)
            SingleIconLoader.Load(oldRoleObj.Quality, backPath)
            local roleData = mod.RoleCtrl:GetRoleData(oldId)
            oldRoleObj.Name = config.Name
            oldRoleObj.Level_txt.text = "Lv."..roleData.lev
            SingleIconLoader.Load(oldRoleObj.Icon,config.rhead_icon)
        end

        local newId = targetList[i] or 0
        local newRoleObj = self.newRole[i]
        newRoleObj.Null:SetActive(newId == 0)
        newRoleObj.NotNull:SetActive(newId ~= 0)
        if newId ~= 0 then
            local config = ItemConfig.GetItemConfig(newId)
            local frontImg, backImg = ItemManager.GetItemColorImg(config.quality)
            local backPath = AssetConfig.GetQualityIcon(backImg)
            --SingleIconLoader.Load(itemObj.QualityFront, frontPath)
            SingleIconLoader.Load(newRoleObj.Quality, backPath)
            local roleData = mod.RoleCtrl:GetRoleData(newId)
            newRoleObj.Name = config.Name
            newRoleObj.Level_txt.text = "Lv."..roleData.lev
            SingleIconLoader.Load(newRoleObj.Icon,config.rhead_icon)
        end
    end
end

function FormationCoverPanel:Back()
    PanelManager.Instance:ClosePanel(self)
end

function FormationCoverPanel:SubmitFun()
    local curInfo = mod.FormationCtrl:GetFormationInfo(0)
    mod.FormationCtrl:ReqFormationUpdate(self.curId, curInfo.roleList)
end