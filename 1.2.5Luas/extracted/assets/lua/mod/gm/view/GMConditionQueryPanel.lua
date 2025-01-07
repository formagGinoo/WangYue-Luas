GMConditionQueryPanel = BaseClass("GMConditionQueryPanel", BasePanel)

function GMConditionQueryPanel:__init()
    self:SetAsset("Prefabs/UI/Gm/ConditionQueryPanel.prefab")
    self.cacheMode = UIDefine.CacheMode.hide
end

function GMConditionQueryPanel:__ShowComplete()
    self.checkBoth = false
    self.isClient = false
    self.clientResult = false

    self.conditionInput = self.ParamInput1.transform:GetComponent(TMP_InputField)
end

function GMConditionQueryPanel:__BindListener()
    self.DoBtn_btn.onClick:AddListener(self:ToFunc("CheckClientCondition"))
    self.ResetBtn_btn.onClick:AddListener(self:ToFunc("CheckServerCondition"))
    self.ClearBtn_btn.onClick:AddListener(self:ToFunc("CheckBoth"))
    self.CloseBtn_btn.onClick:AddListener(self:ToFunc("ClosePanel"))

    EventMgr.Instance:AddListener(EventName.ConditionCheck, self:ToFunc("ShowResult"))
end

function GMConditionQueryPanel:CheckClientCondition()
    if not self.conditionInput.text or self.conditionInput.text == "" then
        return
    end

    self.isClient = true
    self.conditionId = self.conditionInput.text
    local state = Fight.Instance.conditionManager:CheckConditionByConfig(tonumber(self.conditionId))

    self:ShowResult({state = state})
end

function GMConditionQueryPanel:CheckServerCondition()
    if not self.conditionInput.text or self.conditionInput.text == "" then
        return
    end

    self.conditionId = self.conditionInput.text
    Fight.Instance.conditionManager:QueryServer(tonumber(self.conditionId))
end

function GMConditionQueryPanel:CheckBoth()
    if not self.conditionInput.text or self.conditionInput.text == "" then
        return
    end

    self.checkBoth = true
    self.conditionId = self.conditionInput.text
    self.clientResult = Fight.Instance.conditionManager:CheckConditionByConfig(tonumber(self.conditionId))
    Fight.Instance.conditionManager:QueryServer(tonumber(self.conditionId))
end

function GMConditionQueryPanel:ShowResult(data)
    if self.checkBoth then
        self:ShowBothResult(data)
        return
    end

    local obj = self:PopUITmpObject("HistoryItem")
    obj.objectTransform:SetParent(self.HistoryContent.transform)
    UnityUtils.SetLocalScale(obj.objectTransform, 1, 1, 1)
    UtilsUI.SetActive(obj.object, true)

    local resultDesc = string.format("%s%s查询结果为%s", self.conditionId, self.isClient and "前端" or "后端", tostring(data.state))
    obj.objectTransform:Find("Text"):GetComponent(TextMeshProUGUI).text = resultDesc

    self.isClient = false
end

function GMConditionQueryPanel:ShowBothResult(data)
    local obj = self:PopUITmpObject("HistoryItem")
    obj.objectTransform:SetParent(self.HistoryContent.transform)
    UnityUtils.SetLocalScale(obj.objectTransform, 1, 1, 1)
    UtilsUI.SetActive(obj.object, true)

    local resultDesc = string.format("conditionId = %s, 前端查询为%s, 后端为%s", self.conditionId, self.clientResult, tostring(data.state))
    obj.objectTransform:Find("Text"):GetComponent(TextMeshProUGUI).text = resultDesc

    self.checkBoth = false
    self.clientResult = false
end

function GMConditionQueryPanel:ClosePanel()
    self:Hide()
end

function GMConditionQueryPanel:__hide()
    self.checkBoth = false
    self.isClient = false
end