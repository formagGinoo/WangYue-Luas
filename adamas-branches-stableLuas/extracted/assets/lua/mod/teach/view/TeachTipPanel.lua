TeachTipPanel = BaseClass("TeachTipPanel",BasePanel)
local ShowTime = 5

function TeachTipPanel:__init()
    self:SetAsset("Prefabs/UI/Teach/TeachTipPanel.prefab")
    self.time = 0
end

function TeachTipPanel:__CacheObject()

end

function TeachTipPanel:__BindListener()
    self.Content_btn.onClick:AddListener(self:ToFunc("ClickContentBtn"))
    self.TeachTipPanel_Eixt_hcb.HideAction:AddListener(self:ToFunc("HidePanel"))
end

function TeachTipPanel:ClickContentBtn()
    PanelManager.Instance:OpenPanel(GuideImageTipPanel, {self.teachId})
    self:CloseTip()
end

function TeachTipPanel:SelfUpdate()
    return true
end

function TeachTipPanel:__Show()
    self.TeachTipPanel_Open:SetActive(true)
    self.TeachTipPanel_Eixt:SetActive(false)

	self.teachId = self.args[1]
    self.closeCallback = self.args[2]
    self.time = 0
    self:InitView()
end

function TeachTipPanel:__Hide()
    self.TeachTipPanel_Open:SetActive(false)

    if self.closeCallback then
        self.closeCallback()
    end
    self.closeCallback = nil
    
    LuaTimerManager.Instance:AddTimerByNextFrame(1, 0.1, function ()
        BehaviorFunctions.fight.teachManager:CloseTeachShowInfo(TeachConfig.ShowType.ShowTip)
    end)
end

function TeachTipPanel:HidePanel()
    self.parentWindow:ClosePanel(self)
end

function TeachTipPanel:__delete()

end

function TeachTipPanel:CloseTip()
    self.TeachTipPanel_Eixt:SetActive(true)
end

function TeachTipPanel:Update()
    self:UpdateTimePro()
end

function TeachTipPanel:UpdateTimePro()
    if not self:Active() then return end
    -- 暂停了就不计算时间了
    if BehaviorFunctions.fight:CheckFightPause() then return end

    self.time = self.time + Time.deltaTime
    local pro = 1 - self.time / ShowTime
    self.TimePro_img.fillAmount = pro
    if self.time >= ShowTime then
        self:CloseTip()
    end
end

function TeachTipPanel:InitView()
    local cfg = TeachConfig.GetTeachTypeIdCfg(self.teachId)
    local tagType = cfg.teach_tag
    local tagCfg = TeachConfig.GetTeachTagConfig(tagType)
    local icon = tagCfg.weak_icon
    SingleIconLoader.Load(self.Icon, icon)
    self.TeachName_txt.text = cfg.teach_name
    self.TimePro_img.fillAmount = 1
end