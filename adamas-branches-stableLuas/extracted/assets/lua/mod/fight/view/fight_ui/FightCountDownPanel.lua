FightCountDownPanel = BaseClass("FightCountDownPanel", BasePanel)

function FightCountDownPanel:__init()
    self:SetAsset("Prefabs/UI/WorldTitle/V2/FightCountDownPanel.prefab")
end

function FightCountDownPanel:__BindListener()
    
end

function FightCountDownPanel:__Show()
    self.second = self.args.second
    self.timer = self.args.second
    self.id = self.args.id

    if not self.timer or not self.id then
        LogError("传入倒计时或ID为空")
        PanelManager.Instance:ClosePanel(self)
        return
    end

    self:BeginCountdown()
end

function FightCountDownPanel:__delete()
    LuaTimerManager.Instance:RemoveTimer(self.countDownTimer)
    LuaTimerManager.Instance:RemoveTimer(self.closeTimer)
    LuaTimerManager.Instance:RemoveTimer(self.controlTimer)
end

function FightCountDownPanel:BeginCountdown()
    self.CountDownPart:SetActive(false)
    local mainUI = WindowManager.Instance:GetWindow("FightMainUIView")
    local parent = mainUI.panelList
    BehaviorFunctions.ClearAllInput()
    UtilsUI.SetActive(parent["FightNewSkillPanel"].gameObject, false)
    UtilsUI.SetActive(parent["FightJoyStickPanel"].gameObject, false)
    -- 更新倒计时
    local countDownCb = function()
        -- 倒计时结束
        if self.timer <= 0 then
            self.StartText:SetActive(true)
            self.CountText:SetActive(false)

            -- 执行回调
            Fight.Instance.entityManager:CallBehaviorFun("OnCountDownFinishEvent", self.id)

            self._anim:Play("UI_FightCountDownPanel_StartText",0,0)
            SoundManager.Instance:PlaySound("UIMissionObjectiveChange")
            return
        end

        -- 倒计时开始
        if self.timer == self.second then
            self.CountDownPart:SetActive(true)
            self.StartText:SetActive(false)
            self.CountText:SetActive(true)
        end

        self.CountText_txt.text = self.timer
        self.timer = self.timer - 1
        self._anim:Play("UI_FightCountDownPanel_CountText",0,0)
        SoundManager.Instance:PlaySound("UICountDown")
    end

    -- 持续显示0.5秒开始后关闭界面
    local closeTimer = function()
        self.CountDownPart:SetActive(false)
        PanelManager.Instance:ClosePanel(self)
    end
    local controlTimer = function()
        UtilsUI.SetActive(parent["FightNewSkillPanel"].gameObject, true)
        UtilsUI.SetActive(parent["FightJoyStickPanel"].gameObject, true)
    end
    countDownCb()
    self.countDownTimer = LuaTimerManager.Instance:AddTimer(self.timer + 1, 1, countDownCb)
    self.controlTimer = LuaTimerManager.Instance:AddTimer(1, self.timer + 1.5, controlTimer)
    self.closeTimer = LuaTimerManager.Instance:AddTimer(1, self.timer + 3.5, closeTimer)
end