SystemOpenPanel = BaseClass("SystemOpenPanel",BasePanel)
local DataSystemOpen = Config.DataSystemOpen.data_system_open

function SystemOpenPanel:__init()
    self:SetAsset("Prefabs/UI/Notice/SystemOpenPanel.prefab")
end

function SystemOpenPanel:__delete()
end

function SystemOpenPanel:__CacheObject()
    self:SetCacheMode(UIDefine.CacheMode.destroy)
end

function SystemOpenPanel:__BindListener()
    --self:SetHideNode("SystemOpenWindow_Exit")
    self:BindCloseBtn(self.MaskBtn_btn, self:ToFunc("PlayExitAnim"))
end


function SystemOpenPanel:__AfterExitAnim()
    PanelManager.Instance:ClosePanel(self)
end


function SystemOpenPanel:__Create()

end

function SystemOpenPanel:__ShowComplete()
	if not self.blurBack then
		local setting = { bindNode = self.BlurBack }
		self.blurBack = BlurBack.New(self, setting)
	end
	self.blurBack:Show()
end

function SystemOpenPanel:__Show(args)
    if self.args.showSystem then
        self["Tip3"]:SetActive(true)
        self["Tip3_txt"].text = self.args.showSystem
    else
        self["Tip3"]:SetActive(false)
    end
    self.systemId = self.args.systemId
    self:UpdateView()
    self.ArrowTip:SetActive(false)
    self.MaskBtn:SetActive(true)
end

function SystemOpenPanel:UpdateView()
    local cfg = DataSystemOpen[self.systemId]
    self.TitleName_txt.text = cfg.name

    for i = 1, 2 do
        local desc = cfg["notice_desc"..i]
        local isNull = desc == ""
        self["Tip"..i]:SetActive(not isNull)
        if not isNull then
            self["Tip"..i.."_txt"].text = desc
        end
    end

    SingleIconLoader.Load(self.SystemIcon, cfg.notice_icon)
end

function SystemOpenPanel:__Hide()
    self:RemoveTimer()
end

function SystemOpenPanel:RemoveTimer()
	if self.delayTimer then
		LuaTimerManager.Instance:RemoveTimer(self.delayTimer)
	end
	
	self.delayTimer = nil
end
