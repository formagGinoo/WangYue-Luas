CustomRewardPanel = BaseClass("CustomRewardPanel", BasePanel)

function CustomRewardPanel:__init(parent)
    self:SetAsset("Prefabs/UI/CitySimulation/CustomRewardPanel.prefab")

    self.rewardItemDic = {}
end

function CustomRewardPanel:__BindListener()
    self.CommonBack1_btn.onClick:AddListener(self:ToFunc("PlayExitAnim"))
end

function CustomRewardPanel:__Show()
    self.rewardItemNum = 6
    
    self:RefreshRewardList(self.rewardItemNum)
end

-- 
function CustomRewardPanel:RefreshRewardList(_len)
    if not self.RewardScrollView_recyceList then
        return
    end

    self.RewardScrollView_recyceList:CleanAllCell()
    self.RewardScrollView_recyceList:SetLuaCallBack(self:ToFunc("UpdateRewardItem"))
    self.RewardScrollView_recyceList:SetCellNum(_len)
end

-- 
function CustomRewardPanel:UpdateRewardItem(_index, _obj)
    if not _obj then
        return
    end

    if not self.rewardItemDic[_index] then
        self.rewardItemDic[_index] = SingleCustomRewardItem.New()
    end

    local data = {  }

    local item = self.rewardItemDic[_index]
    item:UpdateData(data)
end

function CustomRewardPanel:__ShowComplete()
    if not self.blurBack then
        local setting = { bindNode = self.BlurNode }
        self.blurBack = BlurBack.New(self, setting)
    end

    local cb = function ()
        self:BlurShowCb()
    end
    self.blurBack:Show({cb})
end

function CustomRewardPanel:BlurShowCb()
    if self.args and self.args.showCallback then
        self.args.showCallback()
    end
end

function CustomRewardPanel:__AfterExitAnim()
    self.parentWindow:ClosePanel(self)
end

