RogueSelectRewardWindow = BaseClass("RogueSelectRewardWindow", BaseWindow)
--奖励选择界面

local _insert = table.insert
local UnActiveAlpha = Color(1, 1, 1, 0.3)
local ActiveAlpha = Color(1, 1, 1, 1)

function RogueSelectRewardWindow:__init(parent)
    self:SetAsset("Prefabs/UI/WorldRogue/RogueSelectRewardWindow.prefab")
    self.parent = parent
    self.contentItem = {}
    self.selectCardId = nil
end

function RogueSelectRewardWindow:__CacheObject()
    self:SetCacheMode(UIDefine.CacheMode.destroy)
end

function RogueSelectRewardWindow:__ShowComplete()

end

function RogueSelectRewardWindow:__BindListener()
    self.submitBtn_btn.onClick:AddListener(self:ToFunc("OnClickSubmitBtn"))
end

function RogueSelectRewardWindow:OnClickClose()
    WindowManager.Instance:CloseWindow(self)
end

function RogueSelectRewardWindow:__Show()
    --获取到该事件对应的卡牌组
    self:UpdateUI()
end

function RogueSelectRewardWindow:__Hide()

end

function RogueSelectRewardWindow:__delete()
    for _, v in pairs(self.contentItem) do
        self:PushUITmpObject("item", v.obj)
    end
    self.contentItem = {}
end

function RogueSelectRewardWindow:UpdateUI()
    self:UpdateLeft()
    self:UpdateCenter()
    self:UpdateRight()
end

function RogueSelectRewardWindow:UpdateLeft()

end

function RogueSelectRewardWindow:UpdateCenter()
    self:UpdateTop()
    self:UpdateScrollView()
end

function RogueSelectRewardWindow:UpdateRight()
    self:UpdateBtnState()
end

--更新顶部
function RogueSelectRewardWindow:UpdateTop()
    --获取目前所在的逻辑区域
    local logicAreaId = self.args.areaLogicId
    self.areaLogicConfig = RoguelikeConfig.GetWorldRougeAreaLogic(logicAreaId) --逻辑区域配置
    --获取目前的进度
    local index = mod.RoguelikeCtrl:GetAreaDoneEventNum(logicAreaId)
    
    local maxProgress = self.areaLogicConfig.over_num
    local nowProgress = index/maxProgress
    nowProgress = nowProgress > 1 and 1 or nowProgress
    self.title_txt.text = self.areaLogicConfig.name..TI18N("隐患清除进度已达到  ")..math.floor(nowProgress * 100)..'%'
end

function RogueSelectRewardWindow:UpdateScrollView()
    local data = self.args.cardList
    for i, id in pairs(data) do
        if not self.contentItem[i] then
            self.contentItem[i] = {}
        end
        self.contentItem[i].cardId = id
        self.contentItem[i].obj = self:PopUITmpObject("item", self.Content.transform)
        self.contentItem[i].obj.cardItemBack_btn.onClick:AddListener(function()
            self:OnClickSelectBtn(i)
        end)
        UnityUtils.SetActive(self.contentItem[i].obj.object, true)
        self:UpdateItem(i)
    end
end

function RogueSelectRewardWindow:UpdateItem(i)
    local card = self.contentItem[i].obj
    local cardCfg = RoguelikeConfig.GetWorldRougeCardConfigById(self.contentItem[i].cardId)
    --名字
    card.cardName_txt.text = RoguelikeConfig.QualityColor[cardCfg.quality]..cardCfg.name..'</color>'
    --type
    card.typeName_txt.text = cardCfg.type
    --typeText
    card.typeText_txt.text = cardCfg.name_pinyin
    --品质
    self:SetQuality(card, cardCfg.quality)
    --icon
    SingleIconLoader.Load(card.icon, cardCfg.icon)
    --type_icon
    SingleIconLoader.Load(card.typeIcon, cardCfg.type_icon)
    
    local levelCfg = RoguelikeConfig.GetWorldRougeCardLevelConfigById(self.contentItem[i].cardId, 1)
    --描述
    --magic_id
    card.des_txt.text = levelCfg.desc

    --如果已经有该卡牌了，得显示获得该卡牌后的会获得的增益
    local cardCount = mod.RoguelikeCtrl:GetCardBagById(self.contentItem[i].cardId)
    if cardCount then
        --获得之后的增益
        card.strengthText:SetActive(true)
        card.strengthText_txt.text = TI18N("获得后可强化效果至")..'X'..(cardCount + 1)
    else
        card.strengthText:SetActive(false)
    end
end

function RogueSelectRewardWindow:SetQuality(card, quality)
    local frontPath = AssetConfig.GetQualityCardRogueIcon('front'..quality)
    AtlasIconLoader.Load(card.qualityFront, frontPath)
    local qualityPath = AssetConfig.GetQualityCardRogueIcon('bg'..quality)
    AtlasIconLoader.Load(card.qualityBg, qualityPath)
    local qualitycircle = AssetConfig.GetQualityCardRogueIcon('circle'..quality)
    AtlasIconLoader.Load(card.qualityCircle, qualitycircle)
end

function RogueSelectRewardWindow:UpdateBtnState()
    if not self.selectCardId then
        --self.submitBtn_img.color = UnActiveAlpha
        self.submitBtnRoot:SetActive(false)
        self.noActiveBtnRoot:SetActive(true)
    else
        --self.submitBtn_img.color = ActiveAlpha
        self.submitBtnRoot:SetActive(true)
        self.noActiveBtnRoot:SetActive(false)
    end
end

--选择卡牌
function RogueSelectRewardWindow:OnClickSelectBtn(idx)
    for i, v in pairs(self.contentItem) do
        UtilsUI.SetActive(v.obj.select, idx == i)
    end
    self.selectCardId = self.contentItem[idx].cardId
    self:UpdateBtnState()
end

--确定获得
function RogueSelectRewardWindow:OnClickSubmitBtn()
    if not self.selectCardId then
        return
    end
    mod.RoguelikeCtrl:ChoseCardList(self.selectCardId)
    self:OnClickClose()
end





