FightInteractTriggerView = BaseClass("FightInteractTriggerView",ExtendView)
FightInteractTriggerView.MODULE = FightFacade

function FightInteractTriggerView:__init()
    self.timer = nil
    self.timeoutCb = nil
    self.nowCdTime = 0
    self.maxCdTime = 0
end

function FightInteractTriggerView:__delete()
    self:RemoveTimer()
    EventMgr.Instance:RemoveListener(EventName.ActiveInteract, self:ToFunc("ActiveInteract"))
end

function FightInteractTriggerView:__CacheObject()
    self.interactTriggerTrans = self:Find("other/interact_trigger")
    self.interactTriggerNode = self:Find("other/interact_trigger").gameObject
    self.cdFillAmount = self:Find("other/interact_trigger/cd",Image)
end

function FightInteractTriggerView:__BindListener()
    self:Find("other/interact_trigger",Button):SetClick(self:ToFunc("InteractTriggerClick"))
    EventMgr.Instance:AddListener(EventName.ActiveInteract, self:ToFunc("ActiveInteract"))
end


function FightInteractTriggerView:__BindEvent()

end

function FightInteractTriggerView:__Hide()

end

function FightInteractTriggerView:ActiveInteract(flag,icon,x,y,scale,cdTime)

    self.interactTriggerNode:SetActive(flag)
    if not flag then
        return
    end

    self.maxCdTime = cdTime or 0
    self.nowCdTime = 0

    if not x then x = -200 end
    if not y then y = 360 end
    if not scale then scale = 1 end

    UnityUtils.SetLocalScale(self.interactTriggerTrans,scale,scale,1)
    CustomUnityUtils.SetAnchoredPosition(self.interactTriggerTrans,x,y)
    
    self:RemoveTimer()
    if self.maxCdTime > 0 then
        self.cdFillAmount.fillAmount = 1
        self.timer = LuaTimerManager.Instance:AddTimer(0,0,self:ToFunc("RefreshCd"))
    else
        self.cdFillAmount.fillAmount = 0
    end
end

function FightInteractTriggerView:InteractTriggerClick()
    if self.nowCdTime >= self.maxCdTime then
        self:ActiveInteract(false)
		EventMgr.Instance:Fire(EventName.KeyAutoUp, FightEnum.KeyEvent.Common1)
    end
end

function FightInteractTriggerView:RefreshCd()
    self.nowCdTime = self.nowCdTime + Time.deltaTime
    local fillAmount = self.nowCdTime / self.maxCdTime
    if fillAmount > 1 then fillAmount = 1 end
    self.cdFillAmount.fillAmount = 1 - fillAmount
    if self.nowCdTime >= self.maxCdTime then
        self:RemoveTimer()
    end
end

function FightInteractTriggerView:RemoveTimer()
    if self.timer then
        LuaTimerManager.Instance:RemoveTimer(self.timer)
        self.timer = nil
    end
end