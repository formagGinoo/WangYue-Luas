PartnerConcludeSucPanel = BaseClass("PartnerConcludeSucPanel", BasePanel)

local COLOR_yellow  = Color(230/255, 255/255, 22/255, 1)
local COLOR_red  = Color(255/255, 0, 0, 1)
--初始化
function PartnerConcludeSucPanel:__init(parent)
    self:SetAsset("Prefabs/UI/Partner/PartnerConcludeSucPanel.prefab")
end

--添加监听器
function PartnerConcludeSucPanel:__BindListener()
end

--缓存对象
function PartnerConcludeSucPanel:__CacheObject()
    self:SetCacheMode(UIDefine.CacheMode.hide)
end

function PartnerConcludeSucPanel:__Create()
end

function PartnerConcludeSucPanel:__delete()
end

function PartnerConcludeSucPanel:__Hide()
    if self.waitCloseTimer then
        LuaTimerManager.Instance:RemoveTimer(self.waitCloseTimer)
        self.waitCloseTimer = nil
    end
end

function PartnerConcludeSucPanel:__ShowComplete()
end

function PartnerConcludeSucPanel:__Show()
    self.fight = BehaviorFunctions.fight
    self.roleCtrl = mod.RoleCtrl
    self.partnerId = self.args.id

    local partnerCfg = PartnerConfig.GetPartnerConfig(self.partnerId)
    self.MsgContent:SetActive(false)
    self.RightTip:SetActive(true)
    self.NewTip:SetActive(self.args.isNew)

    self:UpdateMsgView()
    self:UpdateTipView()

    if partnerCfg.quality >= 5 then
        self.MsgContent:SetActive(true)
    end
    self.waitCloseTimer = LuaTimerManager.Instance:AddTimer(1, 10, self:ToFunc("ClosePanel"))
end

function PartnerConcludeSucPanel:ClosePanel()
    PanelManager.Instance:ClosePanel(self)
end

function PartnerConcludeSucPanel:UpdateMsgView()
    local goldenNum = self.roleCtrl:GetDailyGoldenConcludeNum()

    local concludeDailyCfg = SystemConfig.GetCommonValue("PartnerConcludeDailyNum")
    local maxGlodenNum = concludeDailyCfg.int_val

    local concludeMsgCfg = SystemConfig.GetCommonValue("PartnerConcludeMsg")
    local msgTip = concludeMsgCfg.string_val

    local lastNum = maxGlodenNum - goldenNum

    local color = lastNum > 0 and COLOR_yellow or COLOR_red
    self.LastNumTip_txt.text = lastNum
    self.LastNumTip_txt.color = color
end

function PartnerConcludeSucPanel:UpdateTipView()
    local partnerCfg = PartnerConfig.GetPartnerConfig(self.partnerId)
    local iconPath = partnerCfg.chead_icon
    local name = partnerCfg.name
    self.Name_txt.text = name
    SingleIconLoader.Load(self.Icon, iconPath)
end