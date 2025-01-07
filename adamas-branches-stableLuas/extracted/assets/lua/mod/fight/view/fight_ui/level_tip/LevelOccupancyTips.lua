LevelOccupancyTips = BaseClass("LevelOccupancyTips",BasePanel)

local DuplicateLevel = Config.DataDuplicate.data_duplicate_level
function LevelOccupancyTips:__init()
    self.m_levelManager = Fight.Instance.levelManager
    self:SetAsset("Prefabs/UI/Fight/LevelTips/LevelOccupancyTips.prefab")
end

function LevelOccupancyTips:__CacheObject()
    self:SetCacheMode(UIDefine.CacheMode.destroy)
end

function LevelOccupancyTips:__BindListener()
    self.Submit_btn.onClick:AddListener(self:ToFunc("OnClickShowBtn"))
    self.CommonBack1_btn.onClick:AddListener(self:ToFunc("OnClickCloseBtn"))
end

function LevelOccupancyTips:__Show()
    self.sureCallBack = self.args and self.args.sureCallBack
    self.hideCallBack = self.args and self.args.hideCallBack
    self:UpdateView()
    if InputManager.Instance then
        InputManager.Instance:SetCanInputState(false)
    end
end

function LevelOccupancyTips:__Hide()
    if InputManager.Instance then
        InputManager.Instance:SetCanInputState(true)
    end
end

function LevelOccupancyTips:__delete()
  
end

function LevelOccupancyTips:UpdateView()
    local id = self.m_levelManager:GetCurLevelOccupancyId()
    local levelName = DuplicateLevel[id].level_name
    self.TipDesc_txt.text = string.format("当前[%s]占用本区域中\n完成本关卡挑战后可激活其他玩法内容", levelName)
end

function LevelOccupancyTips:OnClickCloseBtn()
    PanelManager.Instance:ClosePanel(self)
end

function LevelOccupancyTips:OnClickShowBtn()
    if self.sureCallBack then
        self.sureCallBack()
        self.sureCallBack = nil
    end
    PanelManager.Instance:ClosePanel(self)
end

function LevelOccupancyTips:OnClickCancelBtn()
    if self.hideCallBack then
        self.hideCallBack()
        self.hideCallBack = nil
    end
    PanelManager.Instance:ClosePanel(self)
end
