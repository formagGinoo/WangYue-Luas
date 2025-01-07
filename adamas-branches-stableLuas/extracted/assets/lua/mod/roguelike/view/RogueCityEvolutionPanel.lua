RogueCityEvolutionPanel = BaseClass("RogueCityEvolutionPanel", BasePanel)
--城市衍化界面

local _insert = table.insert
local AreaMap = Config.DataMap.data_map_area

function RogueCityEvolutionPanel:__init(parent)
    self:SetAsset("Prefabs/UI/WorldRogue/RogueCityEvolutionPanel.prefab")
    self.parent = parent
    self.contentItem = {} --scrollview 
    self.point = {}--进度点
    self.allArea = {}
end

function RogueCityEvolutionPanel:__CacheObject()
    self:SetCacheMode(UIDefine.CacheMode.destroy)
end

function RogueCityEvolutionPanel:__ShowComplete()

end

function RogueCityEvolutionPanel:__BindListener()
    self:BindCloseBtn(self.CommonBack2_btn,self:ToFunc("OnClickClose"))
    self.canEvolutionBtn_btn.onClick:AddListener(self:ToFunc("OnClickEvolutionBtn"))
    self.noEvolutionBtn_btn.onClick:AddListener(self:ToFunc("OnClickNoEvolutionBtn"))
    EventMgr.Instance:AddListener(EventName.RefreshEvolutionPanel, self:ToFunc("RefreshEvolutionPanel"))
end

function RogueCityEvolutionPanel:OnClickClose()
    if self.parentWindow then
        self.parentWindow:ClosePanel(self)
    else
        PanelManager.Instance:ClosePanel(self)
    end
end

function RogueCityEvolutionPanel:__Show()
    self.tips:SetActive(false)
    --获取到所有区域对应的事件
    local logicArea = mod.RoguelikeCtrl:GetAreaLogicMaps()
    self.allArea = {}
    for i, v in pairs(logicArea) do
        _insert(self.allArea, v)
    end
    table.sort(self.allArea, function(a, b)
        return a.area_logic_id < b.area_logic_id
    end)
    self:UpdateUI()
end

function RogueCityEvolutionPanel:__Hide()

end

function RogueCityEvolutionPanel:__delete()
    for i, v in pairs(self.point) do
        if v.pointObj then
            self:PushUITmpObject("progressPoint", v.pointObj)
        end
    end
    self.point = {}

    for i2, v2 in pairs(self.contentItem) do
        if v2.obj then
            self:PushUITmpObject("item", v2.obj)
        end
        if v2.progressPoint then
            for _, v in pairs(v2.progressPoint) do
                if v.obj then
                    GameObject.Destroy(v.obj)
                end
            end
        end
    end
    self.contentItem = {}
    self.allArea = {}
    EventMgr.Instance:RemoveListener(EventName.RefreshEvolutionPanel, self:ToFunc("RefreshEvolutionPanel"))
end

function RogueCityEvolutionPanel:RefreshEvolutionPanel()
    self:UpdateEvolutionBtnAndTips()
end

function RogueCityEvolutionPanel:UpdateUI()
    self:UpdateTop()
    self:UpdateCenter()
end

function RogueCityEvolutionPanel:UpdateTop()
    self:UpdateTopProgress()
    self:UpdateEvolutionBtnAndTips()
end

function RogueCityEvolutionPanel:UpdateCenter()
    self:UpdateScrollView()
end

function RogueCityEvolutionPanel:UpdateTopProgress()
    local lenth = #self.allArea --总长度
    local everyWidth = self.totalProgressBar.transform.sizeDelta.x / lenth --每一个点的长度
    local pos = self.totalProgressBar.transform.localPosition
    
    self.progressNum = 0 --目前总进度值
    for idx, info in ipairs(self.allArea) do
        --实例化几个point
        if not self.point[idx] then
            self.point[idx] = {}
            self.point[idx].pointObj = self:PopUITmpObject("progressPoint", self.topProgress.transform)
            UtilsUI.SetActive(self.point[idx].pointObj.object, true)
            self.point[idx].pointObj.object.transform.localPosition = Vec3.New(pos.x +(idx * everyWidth), pos.y, pos.z)
        end
        self.point[idx].pointObj.num_txt.text = idx
        --进度值
        local progressAmount = mod.RoguelikeCtrl:GetAreaEventProgress(info.area_logic_id)
        --代表该区域已经完成所有事件
        if progressAmount >= 1 then
            self.progressNum = self.progressNum + 1
        end
    end

    --对进度点控制
    for key, value in ipairs(self.point) do
        if key < self.progressNum then
            UtilsUI.SetActive(value.pointObj.active, true)
            UtilsUI.SetActive(value.pointObj.noActive, false)
            UtilsUI.SetActive(value.pointObj.jiantou, false)
        elseif key == self.progressNum then
            UtilsUI.SetActive(value.pointObj.active, true)
            UtilsUI.SetActive(value.pointObj.noActive, false)
            UtilsUI.SetActive(value.pointObj.jiantou, true)
        else
            UtilsUI.SetActive(value.pointObj.active, false)
            UtilsUI.SetActive(value.pointObj.noActive, true)
            UtilsUI.SetActive(value.pointObj.jiantou, false)
        end
    end

    self.totalProgressBar_img.fillAmount = self.progressNum/lenth
end

function RogueCityEvolutionPanel:UpdateEvolutionBtnAndTips()
    --城市衍化等级是否满足
    local maxSchedule = #self.allArea
    
    local isCanReSet = false --是否显示重启按钮
    local gameNum = mod.RoguelikeCtrl:GetGameRoundId()
    local gameReplayConfig = RoguelikeConfig.GetRogueGameReplay(gameNum)
    if gameReplayConfig then
        --游戏前期通过探索等级做限制
        local isPass, desc = Fight.Instance.conditionManager:CheckConditionByConfig(gameReplayConfig.condition)
        local tips = Fight.Instance.conditionManager:GetConditionDesc(gameReplayConfig.condition)
        if not isPass then
            self.tips_txt.text = tips
        else
            self.tips_txt.text = tips..TI18N("【已达成】")
        end
        isCanReSet = isPass
        UnityUtils.SetLocalPosition(self.tips.transform, 0,0,0)
    else
        --当玩家探索等级达到一定等级后 转化为【时间累计次数】的方式
        --下次刷新时间 - 上次刷新时间
        local roGueMainCfg = RoguelikeConfig.GetRoguelikeMainConfig(mod.RoguelikeCtrl:GetMainId())
        local nextRefreshTime = TimeUtils.GetRefreshTimeByRefreshId(roGueMainCfg.game_num_refresh)
        local refreshTimes = mod.RoguelikeCtrl:GetGameRefreshTimes()
        isCanReSet = refreshTimes > 0
        self.tips_txt.text = string.format(TI18N("获取次数: %s次"),refreshTimes)..' '..string.format(TI18N("权限恢复倒计时: %s天"),nextRefreshTime.days)
        UnityUtils.SetLocalPosition(self.tips.transform, -105,0,0)
    end
    
    self.tips:SetActive(true)
    isCanReSet = isCanReSet and self.progressNum >= maxSchedule
    self.canEvolutionBtn:SetActive(isCanReSet)
    self.noEvolutionBtn:SetActive(not isCanReSet)
end

function RogueCityEvolutionPanel:UpdateScrollView()
    for i, info in ipairs(self.allArea) do
        if not self.contentItem[i] then
            self.contentItem[i] = {}
            self.contentItem[i].obj = self:PopUITmpObject("item", self.Content.transform)
            self.contentItem[i].obj.itemBg_btn.onClick:AddListener(function()
                self:OnClickRogueArea(info.area_logic_id)
            end)
            UnityUtils.SetActive(self.contentItem[i].obj.object, true)
        end
        --读取该区域对应的配置
        local logicCfg = RoguelikeConfig.GetWorldRougeAreaLogic(info.area_logic_id)
        --该区域的进度值
        local nowProgress = mod.RoguelikeCtrl:GetAreaEventProgress(info.area_logic_id)
        --刷新区域框
        self:UpdateItem(i, logicCfg, nowProgress)
        
        --刷新进度节点
        --读取区域对应的奖励节点配置
        local scheduleRewardConfig = RoguelikeConfig:GetRogueScheduleCardReward(logicCfg.schedule_card_reward_id) --区域奖励配置
        if scheduleRewardConfig and scheduleRewardConfig.schedule then
            for _, point in ipairs(scheduleRewardConfig.schedule) do
                if point ~= 0 then --30
                    --有几个进度点就实例化几个
                    self:InitSchedule(i, point, nowProgress, self.contentItem[i].obj)
                end
            end
        end
    end
end

function RogueCityEvolutionPanel:UpdateItem(i, cfg, nowProgress)
    local card = self.contentItem[i].obj
    --区域名
    card.areaName_txt.text = cfg.name
    nowProgress = nowProgress > 1 and 1 or nowProgress
    --区域进度值
    card.progressBar_img.fillAmount = nowProgress
    card.progressText_txt.text = math.floor(nowProgress * 100) ..'%'
    
    if cfg.icon ~= "" then
        SingleIconLoader.Load(card.itemBg, cfg.icon)
    end
end

function RogueCityEvolutionPanel:InitSchedule(i, point, nowProgress, parentNode)
    if not self.contentItem[i].progressPoint then
        self.contentItem[i].progressPoint = {}
    end
    if not self.contentItem[i].progressPoint[point] then
        self.contentItem[i].progressPoint[point] = {}
        self.contentItem[i].progressPoint[point].obj = GameObject.Instantiate(parentNode.schedule, parentNode.progress.transform)
        UtilsUI.SetActive(self.contentItem[i].progressPoint[point].obj, true)
        self.contentItem[i].progressPoint[point].node = UtilsUI.GetContainerObject(self.contentItem[i].progressPoint[point].obj)
    end
    --位置
    local pointPos = parentNode.progressBar.transform.sizeDelta.x * point * 0.01
    local pos = parentNode.progressBar.transform.localPosition
    local pointObj = self.contentItem[i].progressPoint[point]
    --刷新进度点
    pointObj.obj.transform.localPosition = Vec3.New(pos.x + pointPos, pos.y, pos.z)
    pointObj.node.select:SetActive(nowProgress >= (point * 0.01))
    pointObj.node.noSelect:SetActive(nowProgress < (point * 0.01))
end

--点击区域(跳转到小地图对应的rogue区域)
function RogueCityEvolutionPanel:OnClickRogueArea(logicId)
    --logicId
    self:OnClickClose()
    --获取跳转的id
    local logicConfig = RoguelikeConfig.GetWorldRougeAreaLogic(logicId)
    local jumpMapId = 10020004
    
    for i, v in pairs(AreaMap) do
        if v.id == logicConfig.map_id then
            jumpMapId = v.map_id
            break
        end
    end
    WindowManager.Instance:OpenWindow(WorldMapWindow, {JumpMapId = jumpMapId, logicAreaId = logicId})
end

function RogueCityEvolutionPanel:OnClickEvolutionBtn()
    PanelManager.Instance:OpenPanel(RogueBlessedPanel, {isRestart = true})
end

function RogueCityEvolutionPanel:OnClickNoEvolutionBtn()
    local gameNum = mod.RoguelikeCtrl:GetGameRoundId()
    local gameReplayConfig = RoguelikeConfig.GetRogueGameReplay(gameNum)
    local isPass = true
    local desc
    local tips = ""
    
    local refreshTimes = mod.RoguelikeCtrl:GetGameRefreshTimes()
    if gameReplayConfig then
        --游戏前期通过探索等级做限制
        isPass, desc = Fight.Instance.conditionManager:CheckConditionByConfig(gameReplayConfig.condition)
        tips = Fight.Instance.conditionManager:GetConditionDesc(gameReplayConfig.condition)
    end
    
    --1.当区域进度未满足要求时提示：还有区域未稳定无法开启新演变
    --2.当区域进度满足但conditon条件未满足：提示文本为conditon文本
    --3.当区域进度满足，且conditon条件但演变次数：当前演变次数不足无法开启新演变
    if self.progressNum < #self.allArea then
        MsgBoxManager.Instance:ShowTips(TI18N("还有区域隐患未清除无法领取新诏令！"))
    elseif not isPass then
        MsgBoxManager.Instance:ShowTips(TI18N(tips))
    elseif refreshTimes <= 0 then
        MsgBoxManager.Instance:ShowTips(TI18N("当前诏令获取次数不足无法获取新诏令"))
    end
end

