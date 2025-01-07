FightTopTargetPanel = BaseClass("FightTopTargetPanel", BasePanel)

local TOP_GUIDE_CFG = Config.DataTips.data_top_guide
local TOP_TARGET_STATE = {
    InProgress = 1,
    Succeed = 2,
    Finish = 3
}
local STATE_COLOR = {
    [TOP_TARGET_STATE.InProgress] = Color(248 / 255, 248 / 255, 248 / 255, 1),
    [TOP_TARGET_STATE.Succeed] = Color(85 / 255, 254 / 255, 218 / 255, 1),
    [TOP_TARGET_STATE.Finish] = Color(191 / 255, 193 / 255, 194 / 255, 1),
}

function FightTopTargetPanel:__init()
    self:SetAsset("Prefabs/UI/Fight/FightTips/FightTopTargetPanel.prefab")

    self.tipsConfig = nil
    self.topTargetPool = {}
    self.topTargetOnShow = {}
end

function FightTopTargetPanel:__Show()
    self.tipsConfig = TOP_GUIDE_CFG[self.args[1]]
    if not self.tipsConfig or not next(self.tipsConfig) then
        LogError(" top guide config not found id = "..self.args[1])
        self:Hide()
    end

    UnityUtils.SetActive(self.GuideTarget, true)
    self:ShowTargets()
end

function FightTopTargetPanel:__BindListener()
    self.FightTopTargetPanel_Exit_hcb.HideAction:AddListener(self:ToFunc("Hide"))
end

function FightTopTargetPanel:ShowTargets()
    self.finishCount = 0
    for i = 1, #self.tipsConfig.targets do
        local targetObj = self:GetTargetTemp()

        targetObj.Desc_txt.text = self.tipsConfig.targets[i]
        targetObj.Cur_txt.text = self.tipsConfig.init_num[i]
        targetObj.Target_txt.text = self.tipsConfig.target_num[i]

        targetObj.Desc_txt.color = STATE_COLOR[TOP_TARGET_STATE.InProgress]
        targetObj.Cur_txt.color = STATE_COLOR[TOP_TARGET_STATE.InProgress]
        targetObj.Target_txt.color = STATE_COLOR[TOP_TARGET_STATE.InProgress]
        targetObj.Meanless1_txt.color = STATE_COLOR[TOP_TARGET_STATE.InProgress]
        targetObj.Meanless2_txt.color = STATE_COLOR[TOP_TARGET_STATE.InProgress]
        targetObj.Meanless3_txt.color = STATE_COLOR[TOP_TARGET_STATE.InProgress]
        targetObj.state = TOP_TARGET_STATE.InProgress

        UnityUtils.SetActive(targetObj.Succeed, false)
        UnityUtils.SetActive(targetObj.Finish, false)
        UnityUtils.SetActive(targetObj.object, true)
        self.topTargetOnShow[i] = targetObj
    end
end

function FightTopTargetPanel:GetTargetTemp()
    if self.topTargetPool and next(self.topTargetPool) then
        return table.remove(self.topTargetPool)
    end

    local obj = self:PopUITmpObject("TargetTemp")
    obj.objectTransform:SetParent(self.GuideTarget.transform)
    UnityUtils.SetLocalScale(obj.objectTransform, 1, 1, 1)
    UtilsUI.GetContainerObject(obj.objectTransform, obj)

    return obj
end

function FightTopTargetPanel:ChangeTargetDesc(index, desc)
    if not self.topTargetOnShow or not self.topTargetOnShow[index] then
        return
    end

    self.topTargetOnShow[index].Cur_Open:SetActive(true)
    -- 临时处理 如果没有关掉的话手动关一下
    self.topTargetOnShow[index]["22079"]:SetActive(false)
    self.topTargetOnShow[index]["22079"]:SetActive(true)
    self.topTargetOnShow[index].Cur_txt.text = desc
end

function FightTopTargetPanel:TargetFinish(index)
    if not self.topTargetOnShow or not self.topTargetOnShow[index] then
        return
    end

    if self.topTargetOnShow[index].state ~= TOP_TARGET_STATE.InProgress then
        return
    end

    self.finishCount = self.finishCount + 1
    self.topTargetOnShow[index].state = TOP_TARGET_STATE.Succeed
    self.topTargetOnShow[index].Desc_txt.color = STATE_COLOR[TOP_TARGET_STATE.Succeed]
    self.topTargetOnShow[index].Cur_txt.color = STATE_COLOR[TOP_TARGET_STATE.Succeed]
    self.topTargetOnShow[index].Target_txt.color = STATE_COLOR[TOP_TARGET_STATE.Succeed]
    self.topTargetOnShow[index].Meanless1_txt.color = STATE_COLOR[TOP_TARGET_STATE.Succeed]
    self.topTargetOnShow[index].Meanless2_txt.color = STATE_COLOR[TOP_TARGET_STATE.Succeed]
    self.topTargetOnShow[index].Meanless3_txt.color = STATE_COLOR[TOP_TARGET_STATE.Succeed]
    UnityUtils.SetActive(self.topTargetOnShow[index].Succeed, true)
    UnityUtils.SetActive(self.topTargetOnShow[index]["22080"], true)
    UnityUtils.SetActive(self.topTargetOnShow[index].Finish, false)

    -- 等动效 改成hide action
    local callBackFunc = function ()
        self:FinishCallBack(index)
    end
    self.tempTimer = LuaTimerManager.Instance:AddTimer(1, 0.6, callBackFunc)
end

function FightTopTargetPanel:FinishCallBack(index)
    self.topTargetOnShow[index].state = TOP_TARGET_STATE.Finish
    self.topTargetOnShow[index].Desc_txt.color = STATE_COLOR[TOP_TARGET_STATE.Finish]
    self.topTargetOnShow[index].Cur_txt.color = STATE_COLOR[TOP_TARGET_STATE.Finish]
    self.topTargetOnShow[index].Target_txt.color = STATE_COLOR[TOP_TARGET_STATE.Finish]
    self.topTargetOnShow[index].Meanless1_txt.color = STATE_COLOR[TOP_TARGET_STATE.Finish]
    self.topTargetOnShow[index].Meanless2_txt.color = STATE_COLOR[TOP_TARGET_STATE.Finish]
    self.topTargetOnShow[index].Meanless3_txt.color = STATE_COLOR[TOP_TARGET_STATE.Finish]
    UnityUtils.SetActive(self.topTargetOnShow[index].Succeed, false)
    UnityUtils.SetActive(self.topTargetOnShow[index].Finish, true)

    if self.finishCount == #self.tipsConfig.targets then
        UnityUtils.SetActive(self.FightTopTargetPanel_Exit, true)
    end
end

function FightTopTargetPanel:ClosePanel()
    UnityUtils.SetActive(self.FightTopTargetPanel_Exit, true)
end

function FightTopTargetPanel:__Hide()
    for k, v in pairs(self.topTargetOnShow) do
        local temp = v
        UnityUtils.SetActive(temp.object, false)
        table.insert(self.topTargetPool, temp)
        self.topTargetOnShow[k] = nil
    end

    if self.tempTimer then
        LuaTimerManager.Instance:RemoveTimer(self.tempTimer)
        self.tempTimer = nil
    end

    Fight.Instance.entityManager:CallBehaviorFun("TopTargetClose", self.tipsConfig.id)
	Fight.Instance.taskManager:CallBehaviorFun("TopTargetClose", self.tipsConfig.id)
end

function FightTopTargetPanel:__delete()
    self.FightTopTargetPanel_Exit_hcb.HideAction:RemoveAllListeners()
end