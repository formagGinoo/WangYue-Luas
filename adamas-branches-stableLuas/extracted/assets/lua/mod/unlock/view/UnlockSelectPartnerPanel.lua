UnlockSelectPartnerPanel = BaseClass("UnlockSelectPartnerPanel", BasePanel)

function UnlockSelectPartnerPanel:__init()
    self:SetAsset("Prefabs/UI/Unlock/UnlockSelectPartnerPanel.prefab")
end

function UnlockSelectPartnerPanel:__delete()
end

function UnlockSelectPartnerPanel:__BindListener()
     
    self:BindCloseBtn(self.Submit_btn,self:ToFunc("ClickCloseCallBack"),function()
        self.case = 2
    end)
    self:BindCloseBtn(self.Cancel_btn,self:ToFunc("ClickCloseCallBack"),function()
        self.case = 1
    end)
    self:BindCloseBtn(self.CommonBack1_btn,self:ToFunc("ClickCloseCallBack"),function()
        self.case = 1
    end)
end

function UnlockSelectPartnerPanel:ClickCloseCallBack()
    if self.case == 1 then
        self:ExitCb()
    else
        self:ClickSureBtnCb()
    end
end

function UnlockSelectPartnerPanel:ExitCb()
    self:Hide()
end

function UnlockSelectPartnerPanel:ClickSureBtnCb()
    self.parentWindow:UpdateSelectPartnerData(self.selectPartner)
    self:Hide()
end

function UnlockSelectPartnerPanel:__Create()

end

function UnlockSelectPartnerPanel:__ShowComplete()
    if not self.blurBack then
        local setting = { passEvent = UIDefine.BlurBackCaptureType.UI, blurRadius = 2, bindNode = self.BlurBack }
        self.blurBack = BlurBack.New(self, setting)
    end
    self.blurBack:Show()
end

function UnlockSelectPartnerPanel:__Show()
    self.TitleText_txt.text = TI18N("选择月灵")
    self.selectPartner = self.args.select_data
    self.unlockManager = BehaviorFunctions.fight.unlockManager
    self.partnerMap = self.unlockManager:GetPartnerMap()
    self.partnerItemMap = {}

    self.RoleList_recyceList:SetLuaCallBack(self:ToFunc("RefreshItemCell"))
    self.RoleList_recyceList:SetCellNum(#self.partnerMap)
end

function UnlockSelectPartnerPanel:__Hide()
    for k, v in pairs(self.partnerItemMap) do
        v:DeleteMe()
    end
    self.partnerItemMap = {}
end

function UnlockSelectPartnerPanel:RefreshItemCell(index, obj)
    local rect = obj:GetComponent(RectTransform)
    UnityUtils.SetAnchoredPosition(rect, 0, 0)
    local data = self.partnerMap[index]
    local partnerItem = UnlockPartnerItem.New()
    local partnerData = {
        data = data,
        obj = obj,
        index = index
    }

    partnerItem:SetData(self, partnerData)

    if not data then return end
    if data.uniqueId == self.selectPartner.uniqueId then
        partnerItem:SelectObj()
    end
    table.insert(self.partnerItemMap, partnerItem)
end

function UnlockSelectPartnerPanel:OnClickPartner(idx)
    for key, obj in pairs(self.partnerItemMap) do
        if key ~= idx then
            obj:CancelSelect()
        end
    end
    self.selectPartner = self.partnerMap[idx]
end

