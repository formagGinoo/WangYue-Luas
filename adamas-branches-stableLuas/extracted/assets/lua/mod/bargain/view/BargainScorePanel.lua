BargainScorePanel = BaseClass("BargainScorePanel", BasePanel)

function BargainScorePanel:__init()
    self:SetAsset("Prefabs/UI/Bargain/BargainScorePanel.prefab")
end

function BargainScorePanel:__BindListener()
    self:BindCloseBtn(self.CloseButton_btn, self:ToFunc("OnClickCloseBtn"))
    --UtilsUI.SetHideCallBack(self.BargainScorePanel_out, self:ToFunc("CloseCallback"))
end

function BargainScorePanel:__BindEvent()
    
end

function BargainScorePanel:__CacheObject()
    self:SetCacheMode(UIDefine.CacheMode.destroy)
end

function BargainScorePanel:__delete()

end

function BargainScorePanel:__Show()
    self.animator = self.gameObject:GetComponent(Animator)
    self:Init(self.args.negotiateId, self.args.negotiateCount, self.args.score)
    self.CloseButtonText_txt.text = TI18N("点击空白处关闭")
    
end

function BargainScorePanel:__ShowComplete()
    if not self.blurBack then
        local setting = { bindNode = self.BlurNode }
        self.blurBack = BlurBack.New(self, setting)
    end
    self:SetActive(false)
    self.blurBack:Show({self:ToFunc("PlayAnim")})


end

function BargainScorePanel:OnClickCloseBtn()
    self.animator:Play("UI_BargainScorePanel_out")
    UtilsUI.SetHideCallBack(self.BargainScorePanel_out, self:ToFunc("CloseCallback"))
end

function BargainScorePanel:CloseCallback()
    PanelManager.Instance:ClosePanel(BargainScorePanel)
    mod.BargainCtrl:ExitBargain()
end

function BargainScorePanel:Init(negotiateId, negotiateCount, score)
    local bargainInfo = BargainConfig.GetBargainInfo(negotiateId, negotiateCount)
    local type = bargainInfo.bargain_type
    
    if type == BargainEnum.Type.Shop then
        local discount = 1 + (score * bargainInfo.param / 10000)
        if not score or score == 0 then
            UtilsUI.SetActive(self.BargainFail, true)
            self.ScoreText_txt.text = string.format(TI18N("商店中商品降价——"))
            mod.BargainCtrl:SetCurBaraginResultType(BargainEnum.ResultType.Draw)
        elseif discount < 1 then
            UtilsUI.SetActive(self.BargainSuccess, true)
            self.ScoreText_txt.text = string.format(TI18N("商店中商品降价<color=%s>%.2f%%</color>"),
                BargainConfig.Color.Green, 100 - discount * 100)
            mod.BargainCtrl:SetCurBaraginResultType(BargainEnum.ResultType.Success)
        else
            UtilsUI.SetActive(self.BargainFail, true)
            self.ScoreText_txt.text = string.format(TI18N("商店中商品涨价<color=%s>%.2f%%</color>"), 
                BargainConfig.Color.Red, discount * 100 - 100)
            mod.BargainCtrl:SetCurBaraginResultType(BargainEnum.ResultType.Fail)
        end

    elseif type == BargainEnum.Type.Trade then
        local discount = 1 + (score * bargainInfo.param / 10000)
        if not score or score == 0 then
            UtilsUI.SetActive(self.BargainFail, true)
            self.MatchInfoText_txt.text = TI18N("本次交易增幅——")
            mod.BargainCtrl:SetCurBaraginResultType(BargainEnum.ResultType.Draw)
        elseif discount > 1 then
            UtilsUI.SetActive(self.BargainSuccess, true)
            self.ScoreText_txt.text = string.format(TI18N("本次交易增幅<color=%s>%.2f%%</color>"), 
            BargainConfig.Color.Green, discount * 100 - 100)
            mod.BargainCtrl:SetCurBaraginResultType(BargainEnum.ResultType.Success)
        else
            UtilsUI.SetActive(self.BargainFail, true)
            self.ScoreText_txt.text = string.format(TI18N("本次交易减幅<color=%s>%.2f%%</color>"), 
            BargainConfig.Color.Red, 100 - discount * 100)
            mod.BargainCtrl:SetCurBaraginResultType(BargainEnum.ResultType.Fail)
        end
    elseif type == BargainEnum.Type.Bargain then
        if not score or score < bargainInfo.param then
            UtilsUI.SetActive(self.BargainFail, true)
            self.ScoreText_txt.text = string.format("达到%.2f分交涉成功", bargainInfo.param)
            mod.BargainCtrl:SetCurBaraginResultType(BargainEnum.ResultType.Fail)
        else
            UtilsUI.SetActive(self.BargainSuccess, true)
            self.ScoreText_txt.text = string.format("达到%.2f分交涉成功", bargainInfo.param)
            mod.BargainCtrl:SetCurBaraginResultType(BargainEnum.ResultType.Success)
        end
    end
end

function BargainScorePanel:PlayAnim()
    if self.args.score > 0 then
        self.animator:Play("UI_BargainScorePanel_chenggong")
    else
        self.animator:Play("UI_BargainScorePanel_shibai")
    end
end