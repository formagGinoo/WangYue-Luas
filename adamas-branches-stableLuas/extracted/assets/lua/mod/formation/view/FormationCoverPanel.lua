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
    -- for i = 1, 3, 1 do
    --     self.oldRole[i] = {}
    --     self.newRole[i] = {}
    --     UtilsUI.GetContainerObject(self["OldRole"..i.."_rect"], self.oldRole[i])
    --     UtilsUI.GetContainerObject(self["NewRole"..i.."_rect"], self.newRole[i])
    -- end
end

function FormationCoverPanel:__BindListener()
     
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
    self.TitleText_txt.text = TI18N("提示")
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
    self:PushAllUITmpObject("RoleDetailItem", self.Cache_rect)
    local curList = mod.FormationCtrl:GetFormationInfo(self.curId).roleList
    local targetList = mod.FormationCtrl:GetFormationInfo(0).roleList

    for i = 1, #curList, 1 do
        local id = curList[i]
        if id and id ~= 0 then
            local obj = self:PopUITmpObject("RoleDetailItem", self.oldInfo_rect)
            local item = RoleDetailItem.New()
            item:InitItem(obj.object, id)
            item:SetRedPoint(false)
        end
    end

    for i = 1, #targetList, 1 do
        local id = targetList[i]
        if id and id ~= 0 then
            local obj = self:PopUITmpObject("RoleDetailItem", self.newInfo_rect)
            local item = RoleDetailItem.New()
            item:InitItem(obj.object, id)
            item:SetRedPoint(false)
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