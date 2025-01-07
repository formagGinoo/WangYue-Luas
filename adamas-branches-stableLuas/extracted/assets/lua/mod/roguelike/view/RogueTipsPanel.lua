RogueTipsPanel = BaseClass("RogueTipsPanel", BasePanel)
--rogue提示

function RogueTipsPanel:__init(parent)
    self:SetAsset("Prefabs/UI/WorldRogue/RogueTipsPanel.prefab")
    self.scheduleList = {}
end

function RogueTipsPanel:__CacheObject()
    self:SetCacheMode(UIDefine.CacheMode.destroy)
end

function RogueTipsPanel:__ShowComplete()

end

function RogueTipsPanel:__BindListener()
    
end

function RogueTipsPanel:OnClickClose()
    PanelManager.Instance:ClosePanel(self)
end

function RogueTipsPanel:__Show()
    self.eventConfig = RoguelikeConfig.GetRougelikeEventConfig(self.args.eventId) --事件配置
    
    self.areaLogicConfig = RoguelikeConfig.GetWorldRougeAreaLogic(self.args.areaId) --逻辑区域配置
    if self.areaLogicConfig then
        self.scheduleRewardConfig = RoguelikeConfig:GetRogueScheduleCardReward(self.areaLogicConfig.schedule_card_reward_id) --区域奖励配置
    end
    
    self:OpenTimer()
    self:UpdateUI()
end

function RogueTipsPanel:__Hide()

end

function RogueTipsPanel:__delete()
    self:StopTimer()
end

function RogueTipsPanel:UpdateUI()
    if self.args and not self.args.isShowProgress then
        self.tips_txt.text = TI18N("已检测到附近有事件发生")
        self.progressBarBg:SetActive(false)
        self.progressBar:SetActive(false)
        return 
    end
    
    self.progressBarBg:SetActive(true)
    self.progressBar:SetActive(true)
    --刷新tips提示
    self:UpdateTips()
    --刷新进度点
    self:UpdateEventPoint()
end

function RogueTipsPanel:UpdateTips()
    self.tips_txt.text = self.areaLogicConfig.name.."进度"
end

function RogueTipsPanel:UpdateEventPoint()
    --获取目前的进度
    local index = mod.RoguelikeCtrl:GetAreaDoneEventNum(self.areaLogicConfig.area_logic)
    
    local maxProgress = self.areaLogicConfig.over_num
    local nowProgress = index/maxProgress
    self.progressBar_img.fillAmount = nowProgress
    
    if self.scheduleRewardConfig and self.scheduleRewardConfig.schedule then
        --进度点的位置需要计算一下
        for i, point in ipairs(self.scheduleRewardConfig.schedule) do
            if point ~= 0 then --30
                --有几个进度点就实例化几个
                self:InitSchedule(nowProgress, point)
            end
        end
    end
end

function RogueTipsPanel:InitSchedule(nowProgress, point)
	self.scheduleList[point] = {}
    self.scheduleList[point].obj = GameObject.Instantiate(self.shedule, self.container.transform)
    UtilsUI.SetActive(self.scheduleList[point].obj, true)
    self.scheduleList[point].node = UtilsUI.GetContainerObject(self.scheduleList[point].obj)
    --位置
    local pointPos = self.progressBar.transform.sizeDelta.x * point * 0.01
    local pos = self.progressBar.transform.localPosition
    self.scheduleList[point].obj.transform.localPosition = Vec3.New(pos.x + pointPos, pos.y, pos.z)
    if nowProgress >= (point * 0.01) then
        self.scheduleList[point].node.select:SetActive(true)
        self.scheduleList[point].node.noSelect:SetActive(false)
    else
        self.scheduleList[point].node.select:SetActive(false)
        self.scheduleList[point].node.noSelect:SetActive(true)
    end
end

function RogueTipsPanel:OpenTimer()
    if not self.timer then
        self.timer = LuaTimerManager.Instance:AddTimer(1, 2.5, function()
           self:OnClickClose()
        end)
    end
end

function RogueTipsPanel:StopTimer()
    if self.timer then
        LuaTimerManager.Instance:RemoveTimer(self.timer)
        self.timer = nil
    end
end





