ControlAtomizeWindow = BaseClass("ControlAtomizeWindow", BaseWindow)

function ControlAtomizeWindow:__init()
    self:SetAsset("Prefabs/UI/Hacking/ControlAtomizePanel.prefab")

    self.inputManager = Fight.Instance.clientFight.inputManager
end

function ControlAtomizeWindow:__delete()

end

--缓存对象
function ControlAtomizeWindow:__CacheObject()
    self:SetCacheMode(UIDefine.CacheMode.destroy)
end

function ControlAtomizeWindow:__BindListener()
    self.Into_btn.onClick:AddListener(self:ToFunc("CompleteAtomize"))
    self.Quit_btn.onClick:AddListener(self:ToFunc("QuitAtomize"))

    self.DragBg:SetActive(true)

    local bgdragBehaviour = self.DragBg:GetComponent(UIDragBehaviour) or self.DragBg:AddComponent(UIDragBehaviour)
    local onbgBeginDrag = function(data)
        self:BGBeginDrag(data)
    end
    bgdragBehaviour.onBeginDrag = onbgBeginDrag
    local cbbgOnDrag = function(data)
        self:BGDrag(data)
    end
    bgdragBehaviour.onDrag = cbbgOnDrag

    local cbbgOnEndDrag = function(data)
        self:BGEndDrag(data)
    end
    bgdragBehaviour.onEndDrag = cbbgOnEndDrag

    local onbgDown = function(data)
        self:BGDown(data)
    end
    bgdragBehaviour.onPointerDown = onbgDown
    local onbgUp = function(data)
        self:BGUp(data)
    end
    bgdragBehaviour.onPointerUp = onbgUp
end

function ControlAtomizeWindow:CompleteAtomize()
    Fight.Instance.entityManager:CallBehaviorFun("CompleteAtomize", self.AtomizeInstanceId)
end

function ControlAtomizeWindow:QuitAtomize()
    Fight.Instance.entityManager:CallBehaviorFun("QuitAtomize", self.AtomizeInstanceId)
end

function ControlAtomizeWindow:__Hide()
    EventMgr.Instance:Fire(EventName.ShowCursor, false)
end

function ControlAtomizeWindow:__ShowComplete()
    EventMgr.Instance:Fire(EventName.ShowCursor, true)
    self:SetCanControl(false)
end


function ControlAtomizeWindow:SetAtomizeId(instanceId)
    self.AtomizeInstanceId = instanceId
end

function ControlAtomizeWindow:SetCanControl(isCanControl)
    self.DragBg:SetActive(isCanControl)
    self.BoxBg:SetActive(isCanControl)
end

function ControlAtomizeWindow:Close_HideCallBack()
    Fight.Instance.entityManager:CallBehaviorFun("OnStopDrive", self.droneInstanceId)
end

--事件
function ControlAtomizeWindow:BGBeginDrag(data)
    FightMainUIView.bgInput.x = 0
    FightMainUIView.bgInput.y = 0
end

function ControlAtomizeWindow:BGDrag(data)
    FightMainUIView.bgInput.x = data.delta.x
    FightMainUIView.bgInput.y = data.delta.y
    self.inputManager:KeyDown(FightEnum.KeyEvent.ScreenMove)
end

function ControlAtomizeWindow:BGEndDrag(data)
    FightMainUIView.bgInput.x = 0
    FightMainUIView.bgInput.y = 0
    self.inputManager:KeyUp(FightEnum.KeyEvent.ScreenMove)
end

function ControlAtomizeWindow:BGDown()
    self.inputManager:KeyDown(FightEnum.KeyEvent.ScreenPress)
end

function ControlAtomizeWindow:BGUp()
    self.inputManager:KeyUp(FightEnum.KeyEvent.ScreenPress)
end