AgeTipPanel = BaseClass("AgeTipPanel", BasePanel)

function AgeTipPanel:__init()
    self:SetAsset("Prefabs/UI/Login/AgeTipPanel.prefab")
end

function AgeTipPanel:__CacheObject()
    self:SetCacheMode(UIDefine.CacheMode.destroy)
end

function AgeTipPanel:__BindListener()
     --新版不用这行
    self.CommonBack1_btn.onClick:AddListener(self:ToFunc("PlayExitAnim"))
    self.CommonGrid_btn.onClick:AddListener(self:ToFunc("PlayExitAnim"))
    self.Submit_btn.onClick:AddListener(self:ToFunc("PlayExitAnim"))
end

function AgeTipPanel:__Show()
    self.ContentText_txt.text = SystemConfig.GetCommonValue("LoadpageAgeLimit").string_val

    if not self.blurBack then
		local setting = { bindNode = self.BlurNode }
		self.blurBack = BlurBack.New(self, setting)
	end
	self:SetActive(false)
	self.blurBack:Show()
end

function AgeTipPanel:__Hide()

end

-- function AgeTipPanel:__BeforeExitAnim()
--    Log("显示开始播放动效")
-- end
function AgeTipPanel:__AfterExitAnim()
    --退场动效结束后执行，没有动效组件或者“节点”就会直接执行
    PanelManager.Instance:ClosePanel(self)
end