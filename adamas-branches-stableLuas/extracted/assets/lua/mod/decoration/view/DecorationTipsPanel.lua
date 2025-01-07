DecorationTipsPanel = BaseClass("DecorationTipsPanel",BasePanel)

function DecorationTipsPanel:__init()
    self:SetAsset("Prefabs/UI/Decoration/DecorationTips.prefab")
    self.buyNum = 1
end

function DecorationTipsPanel:__Show()
    if self.args then
        self:InitShow(self.args.type)
    end
end

function DecorationTipsPanel:__BindListener()
    self.CommonBack1_btn.onClick:AddListener(self:ToFunc("Close_Panel"))
    self.tempEnterButton_btn.onClick:AddListener(self:ToFunc("OnclickEnter"))
    self.tempCancelButton_btn.onClick:AddListener(self:ToFunc("OnclickCancel"))

    self.BuyMinButton_btn.onClick:AddListener(self:ToFunc("OnclickMin"))
    self.MinusButton_btn.onClick:AddListener(self:ToFunc("OnclickMinus"))
    self.PlusButton_btn.onClick:AddListener(self:ToFunc("OnclickPlus"))
    self.BuyMaxButton_btn.onClick:AddListener(self:ToFunc("OnclickMax"))

    EventMgr.Instance:AddListener(EventName.UpdateDecorationInfo, self:ToFunc("Close_Panel"))
end

function DecorationTipsPanel:InitShow(type)
   
    if type == DecorationConfig.decorationTipTypes.buy then
        self.DecorationBuyTip:SetActive(true)
        self:DecorationInfoShow()
    elseif type == DecorationConfig.decorationTipTypes.save then
        self.DecorationSaveTip_:SetActive(true)
    end
end

function DecorationTipsPanel:DecorationInfoShow()
    local config = self.args.config
    self.BuyInfoNameText_txt.text = config.name
    self.BuyInfoDesText_txt.text = config.desc
    SingleIconLoader.Load(self.tempBuyIcon,config.icon)
    self.buyNum = 1
    self:UpdatePrice(0)
end
--计算价格
function DecorationTipsPanel:UpdatePrice(num)
    self.buyNum = self.buyNum + num
    if self.buyNum<1 then
        self.buyNum = 1
    end
    self.BuyNumText_txt.text = self.buyNum
    self.IconNumText_txt.text = "x"..self.buyNum

    local pratice = self.args.config.cost_value[1][2]*self.buyNum
    local curGold = mod.BagCtrl:GetGoldCount()
    if curGold<pratice then
        self.CostNumText_txt.text = string.format(TI18N("拥有：<color=%s>%s</color>"), AlchemyConfig.TextColor.Red, pratice)
    else
        self.CostNumText_txt.text = pratice
    end
    self.allPratice = pratice
end
function DecorationTipsPanel:OnclickMin()
    self.buyNum = 0
    self:UpdatePrice(0)
end
function DecorationTipsPanel:OnclickMinus()
    self:UpdatePrice(-1)
end

function DecorationTipsPanel:OnclickPlus()

    local maxLimit =  -1
    local config = self.args.config
    for k, vlaue in ipairs(config.building_condition_list) do
        if vlaue[1]~=0 then
            local isOpen, failDesc = Fight.Instance.conditionManager:CheckConditionByConfig(vlaue[1])
            if isOpen then
                maxLimit = vlaue[2]
            end
        else
            if vlaue[2]~=0 then
                maxLimit = vlaue[2]
            end
        end
    end
    
    local curHave = mod.DecorationCtrl:GetrealDecorationCount(self.args.config.id)
    if curHave+ self.buyNum +1>maxLimit and maxLimit>0 then
        --物件达到上限了不能购买
        MsgBoxManager.Instance:ShowTips(TI18N("购买数量超出上限，无法购买"))
        return
    end
    self:UpdatePrice(1)
end

function DecorationTipsPanel:OnclickMax()
    --物件拥有上限
    local maxLimit = 0
    for _k, _v in ipairs(self.args.config.building_condition_list) do
        if _v[1]~=0 then
            local isOpen, failDesc = Fight.Instance.conditionManager:CheckConditionByConfig(_v[1])
            if isOpen then
                maxLimit = _v[2]
            end
        end
    end
    local curHave = mod.DecorationCtrl:GetrealDecorationCount(self.args.config.id)
    self.buyNum = maxLimit-curHave
    self:UpdatePrice(0)
end

function DecorationTipsPanel:OnclickEnter()
    --发消息给服务器1，字长id ,物件id，数量
    local assetId = self.args.config.asset_id
    local decorationId = self.args.config.id
    local num = self.buyNum

    local curGold = mod.BagCtrl:GetGoldCount()
    if curGold<self.allPratice then
        MsgBoxManager.Instance:ShowTips(TI18N("货币不足，无法购买"))
        return
    end
    if num<=0 then
        MsgBoxManager.Instance:ShowTips(TI18N("购买数量不能为0"))
        return
    end
    mod.DecorationCtrl:SendBuyDecoration(assetId,decorationId,num)
end


function DecorationTipsPanel:OnclickCancel()
    PanelManager.Instance:ClosePanel(self)
end
function DecorationTipsPanel:Close_Panel()
    PanelManager.Instance:ClosePanel(self)
end

function DecorationTipsPanel:__delete()
    self.buyNum = 0
end

