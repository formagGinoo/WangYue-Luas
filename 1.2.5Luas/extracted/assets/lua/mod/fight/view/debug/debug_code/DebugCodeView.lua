DebugCodeView = BaseClass("DebugCodeView", BaseView)

function DebugCodeView:__init()
    self:SetAsset("Prefabs/UI/FightDebug/DebugCode.prefab")
    self:SetParent(UIDefine.canvasRoot.transform)
end

function DebugCodeView:__BindListener()
    self.inputBox = UtilsUI.GetInputField(self.InputBox)
    self.Submit_btn.onClick:AddListener(self:ToFunc("OnClick_Submit"))
    self.Cancel_btn.onClick:AddListener(self:ToFunc("OnClick_Close"))
    self.Pause_btn.onClick:AddListener(self:ToFunc("PauseAndResume"))
end

function DebugCodeView:__Show()
    -- self:AddHistory("InputManager.EnableKeyboard = true")
    -- self:AddHistory("ClientTransformComponent.HideEffect = true")
end

function DebugCodeView:LoadCode(code)
    local res = load(code)
    if res then
        res()
    end
end

function DebugCodeView:AddHistory(str)
    local obj = GameObject.Instantiate(self.History)
    obj:SetActive(true)
    obj.transform:SetParent(self.Content.transform)
    obj.transform.localPosition = Vector3.zero
    obj.transform.localScale = Vector3.one
    UtilsUI.GetText(obj).text = str
    local btn = obj:GetComponent(Button)
    btn.onClick:AddListener(function ()
        self.inputBox.text = str
        self:LoadCode(str)
    end)
end

function DebugCodeView:OnClick_Submit()
    local command = self.inputBox.text
    if #command < 5 then
        return
    end
    self:LoadCode(command)
    self:AddHistory(command)
end

function DebugCodeView:OnClick_Close()
    self:Hide()
end

function DebugCodeView:PauseAndResume()
    if BehaviorFunctions.fight.fightState ~= FightEnum.FightState.Pause then
        BehaviorFunctions.Pause()
    else
        BehaviorFunctions.Resume()
    end
end