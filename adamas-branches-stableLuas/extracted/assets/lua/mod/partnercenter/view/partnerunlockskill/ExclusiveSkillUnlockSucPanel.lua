ExclusiveSkillUnlockSucPanel = BaseClass("ExclusiveSkillUnlockSucPanel", BasePanel)
local _tinsert = table.insert
--初始化
function ExclusiveSkillUnlockSucPanel:__init(parent)
    self:SetAsset("Prefabs/UI/PartnerSkill/ExclusiveSkillUnlockSucPanel.prefab")
    self.parent = parent
end

--添加监听器
function ExclusiveSkillUnlockSucPanel:__BindListener()
    self.CloseBtn_btn.onClick:AddListener(self:ToFunc("ClickClose"))
end

function ExclusiveSkillUnlockSucPanel:__BindEvent()
end

--缓存对象
function ExclusiveSkillUnlockSucPanel:__CacheObject()
    self:SetCacheMode(UIDefine.CacheMode.destroy)
end

function ExclusiveSkillUnlockSucPanel:__Create()
end

function ExclusiveSkillUnlockSucPanel:__delete()

end

function ExclusiveSkillUnlockSucPanel:__Hide()

end

function ExclusiveSkillUnlockSucPanel:__ShowComplete()
end

function ExclusiveSkillUnlockSucPanel:ClickClose()
	PanelManager.Instance:ClosePanel(ExclusiveSkillUnlockSucPanel)
end

function ExclusiveSkillUnlockSucPanel:__Show()
    self:SetBlurBack()
    self.skillId = self.args.skillId
    self.skillCfg = PartnerCenterConfig.GetPartnerSkillConfig(self.skillId)
    self:UpdateView()
end

function ExclusiveSkillUnlockSucPanel:UpdateView()
    if not self.skillCfg then return end
    local skillCfg = self.skillCfg
    local skillIcon = skillCfg.icon
    
    SingleIconLoader.Load(self.SkillIcon, skillIcon)
    self.Desc_txt.text = skillCfg.desc
    self.SkillName_txt.text = skillCfg.name
end
