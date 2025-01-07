AlchemyRecipeUnlockPanel = BaseClass("AlchemyRecipeUnlockPanel", BasePanel)

function AlchemyRecipeUnlockPanel:__init()
    self:SetAsset("Prefabs/UI/Alchemy/AlchemyRecipeUnlockPanel.prefab")
    self.FormulaObjList = {}
    self.curFormulaData = {}
    self.selectFormulaData = nil
end

function AlchemyRecipeUnlockPanel:__BindListener()
     

    self:BindCloseBtn(self.CommonGrid_btn,self:ToFunc("OnClick_CloseBtn"))
    self:BindCloseBtn(self.CommonBack1_btn,self:ToFunc("OnClick_CloseBtn"))

    self.MinusButton_btn.onClick:AddListener(self:ToFunc("OnClick_MinusButton"))
    self.PlusButton_btn.onClick:AddListener(self:ToFunc("OnClick_PlusButton"))

    self.Mix_btn.onClick:AddListener(self:ToFunc("OnClick_MixButton"))

    self.MixItemSlider_sld.onValueChanged:AddListener(self:ToFunc("OnValueChanged_MixItemSlider"))
end

function AlchemyRecipeUnlockPanel:__BindEvent()
    EventMgr.Instance:AddListener(EventName.GetAlchemyAward, self:ToFunc("RefreshFormulaList"))
end

function AlchemyRecipeUnlockPanel:__CacheObject()
    self:SetCacheMode(UIDefine.CacheMode.destroy)
end

function AlchemyRecipeUnlockPanel:__Create()

end

function AlchemyRecipeUnlockPanel:__delete()
    EventMgr.Instance:RemoveListener(EventName.GetAlchemyAward, self:ToFunc("RefreshFormulaList"))
    for _, v in ipairs(self.FormulaObjList) do
        PoolManager.Instance:Push(PoolType.class, "AlchemyFormulaItem",v.formulaItem)
    end
end

function AlchemyRecipeUnlockPanel:__Hide()

end

--self.args = {formulaId = id }
function AlchemyRecipeUnlockPanel:__Show()
    self.TitleText_txt.text = TI18N("已解锁配方")
    self.formulaId = self.args.formulaId

    self.curFormulaData = mod.AlchemyCtrl:GetHistoryFormulaListById(self.formulaId)
    self.count = 1
end

function AlchemyRecipeUnlockPanel:__ShowComplete()
    if not self.blurBack then
        local setting = { bindNode = self.BlurNode }
        self.blurBack = BlurBack.New(self, setting)
    end
    self:SetActive(false)
    self.blurBack:Show({self:ToFunc("RefreshFormulaScroll")})
end

function AlchemyRecipeUnlockPanel:__CacheObject()
    self:SetCacheMode(UIDefine.CacheMode.destroy)
end

function AlchemyRecipeUnlockPanel:RefreshFormulaList(rewardList)
    self:RefreshFormulaScroll()
end

function AlchemyRecipeUnlockPanel:RefreshFormulaScroll()
    local col = 1
    local row = math.ceil((self.FormulaScroll_rect.rect.height - 25) / 145)
    local FormulaCount = #self.curFormulaData

    local listNum = FormulaCount 
    self.FormulaScroll_recyceList:SetLuaCallBack(self:ToFunc("RefreshFormulaCell"))
    self.FormulaScroll_recyceList:SetCellNum(listNum)
end

function AlchemyRecipeUnlockPanel:RefreshFormulaCell(index,go)
    if not go then
        return 
    end
    local formulaItem
    local formulaObj
    if self.FormulaObjList[index] then
        formulaItem = self.FormulaObjList[index].formulaItem
        formulaObj = self.FormulaObjList[index].formulaObj
    else
        local uiContainer = {}
        uiContainer = UtilsUI.GetContainerObject(go.transform, uiContainer)
        formulaItem = PoolManager.Instance:Pop(PoolType.class, "AlchemyFormulaItem")
        if not formulaItem then
            formulaItem = AlchemyFormulaItem.New()
        end
        formulaObj = uiContainer.FormulaItem
        self.FormulaObjList[index] = {}
        self.FormulaObjList[index].formulaItem = formulaItem
        self.FormulaObjList[index].formulaObj = formulaObj
    end

    formulaItem:InitFotmula(formulaObj,self.curFormulaData[index],self.count,true)
    local onClickFunc = function()
        self:OnClick_SingleFormula(self.FormulaObjList[index].formulaItem)
        self:UpdateMixBtnState()
    end
    formulaItem:SetBtnEvent(false,onClickFunc)

    if index == 1 then
        onClickFunc()
    end
end

function AlchemyRecipeUnlockPanel:OnClick_SingleFormula(singleFormula)    
    if self.selectFormula and self.selectFormula ~= singleFormula then
        self.selectFormula:SetSelect(false)
        self.selectFormula:SetCount(1)
    end
    singleFormula:SetSelect(true)
    singleFormula:SetCount(self.count)
    self.selectFormula = singleFormula

    self:SetSliderLimit()
end

function AlchemyRecipeUnlockPanel:SetSliderLimit()
    self.maxCount = self.selectFormula:GetMaxMixCount()
    self.MixItemSlider_sld.value = 1
    self:UpdataSliderInfo()
end

function AlchemyRecipeUnlockPanel:OnClick_MixButton()
    if self.selectFormula:CheckmateriaIsEnough() == false then
        return
    end
    mod.AlchemyCtrl:AlchemyMix(self.formulaId, self.selectFormula.solution, self.count)
end

function AlchemyRecipeUnlockPanel:OnClick_CloseBtn()
    PanelManager.Instance:ClosePanel(self)
end

function AlchemyRecipeUnlockPanel:OnClick_MinusButton()
    if not self.MixItemSlider_sld or self.MixItemSlider_sld.value <= self.MixItemSlider_sld.minValue  then
        return
    end
    if self.sliderIsfull == true then
        return
    end
    self.MixItemSlider_sld.value = self.MixItemSlider_sld.value - 1
    self.MixNum_txt.text = math.floor(self.MixItemSlider_sld.value)
    self:UpdateSliderValue()
end

function AlchemyRecipeUnlockPanel:OnClick_PlusButton()
    if not self.MixItemSlider_sld or self.MixItemSlider_sld.value >= self.MixItemSlider_sld.maxValue then
        return
    end
    if self.sliderIsfull == true then
        return
    end
    self.MixItemSlider_sld.value = math.floor(self.MixItemSlider_sld.value + 1)
    self:UpdateSliderValue()
end

function AlchemyRecipeUnlockPanel:OnValueChanged_MixItemSlider()
    self:UpdateSliderValue()
end

function AlchemyRecipeUnlockPanel:UpdateSliderValue()
    self.count = math.floor(self.MixItemSlider_sld.value)
    self.MixNum_txt.text = self.count
    self.selectFormula:SetCount(self.count)
end

function AlchemyRecipeUnlockPanel:UpdataSliderInfo()
    self.MaxNum_txt.text = self.maxCount
    self.MinNum_txt.text = 1
    self.MixItemSlider_sld.maxValue = self.maxCount
    self.MixItemSlider_sld.minValue = 1
    self.sliderIsfull = false
    self.MixItemSlider_sld.interactable = true
    if self.MixItemSlider_sld.maxValue <=  self.MixItemSlider_sld.minValue then
        self.MixItemSlider_sld.maxValue = self.MixItemSlider_sld.minValue + 0.01
        self.MixItemSlider_sld.value = self.MixItemSlider_sld.maxValue 
        self.MaxNum_txt.text = 1
        self.sliderIsfull = true
        self.MixItemSlider_sld.interactable = false
    end 
    self.count = 1
end

function AlchemyRecipeUnlockPanel:UpdateMixBtnState()
    local isEnough = self.selectFormula:CheckmateriaIsEnough()
    if isEnough  == true then
        self:SetMixBtnState(true)
    elseif isEnough == false then
        self:SetMixBtnState(false)
    end
end

function AlchemyRecipeUnlockPanel:SetMixBtnState(state)
    UtilsUI.SetActive(self.CanNotMix, not state)
    UtilsUI.SetActive(self.CanMix, state)
end