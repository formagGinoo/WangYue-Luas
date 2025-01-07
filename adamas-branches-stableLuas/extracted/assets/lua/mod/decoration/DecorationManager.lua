DecorationManager = BaseClass("DecorationManager")


function DecorationManager:__init()
    self.decorationController = DecorationController.New()
    self.mainUi = nil
    --EventMgr.Instance:AddListener(EventName.StartFight, self:ToFunc("OnStartFight"))
end

function DecorationManager:StartFight()
    local result =  mod.AssetPurchaseCtrl:GetCurAssetId()
    if result then
        --当前在场景资产中
        mod.DecorationCtrl:EnterScene(result)
    end
end

function DecorationManager:OpenDecorationControlPanel(decorationId,type)
    --进入装修
    SystemStateMgr.Instance:AddState(SystemStateConfig.StateType.Decoration,decorationId,type)
end

function DecorationManager:GetDecorationController()
    return self.decorationController
end

function DecorationManager:Update()
    self.decorationController:Update()
end

--进入编辑模式
function DecorationManager:TempOpenDecorationControlPanel(decorationId, type)
    SoundManager.Instance:PlaySound("ChongGou_Enter")
    InputManager.Instance:AddLayerCount("Build")
    SystemStateMgr.Instance:SetFightVisible(SystemStateConfig.StateType.Decoration, "100010000")
    local mainUi = WindowManager.Instance:GetWindow("FightMainUIView")
    mainUi:ClosePanel(DecorationMainPanel)
    self.DecorationControlPanel = mainUi:OpenPanel(DecorationControlPanel,{ decorationId = decorationId, type = type })
end

--退出编辑模式
function DecorationManager:CloseDecorationControlPanel()
    InputManager.Instance:MinusLayerCount("Build")
    local mainUi = WindowManager.Instance:GetWindow("FightMainUIView")
    mainUi:ClosePanel(DecorationControlPanel)
    self.buildControlPanel = nil
    Fight.Instance.entityManager:CallBehaviorFun("OnExitBuilding")
    SystemStateMgr.Instance:RemoveState(SystemStateConfig.StateType.Decoration)
    mainUi:OpenPanel(DecorationMainPanel)
end

function DecorationManager:HideMouseCursor()
   InputManager.Instance.disPlayMouse = false
   Cursor.lockState = CursorLockMode.Locked
   Cursor.visible = false
end

function DecorationManager:ShowMouseCursor()
   InputManager.Instance.disPlayMouse = true
   Cursor.lockState = CursorLockMode.None
   Cursor.visible = true
end

