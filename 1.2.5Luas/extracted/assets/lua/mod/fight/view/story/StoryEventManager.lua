StoryEventManager = BaseClass("StoryEventManager")

function StoryEventManager:__init(mgr)
    self.storyDialogManager = mgr
    self.triggerFuns = {}
    self.triggerFuns[StoryConfig.StoryTrigger.OpenNpcStore] = self.OpenNpcStore
    self.triggerFuns[StoryConfig.StoryTrigger.OpenTalent] = self.OpenTalent
    self.triggerFuns[StoryConfig.StoryTrigger.OpenMailing] = self.OpenMailing
    self.triggerFuns[StoryConfig.StoryTrigger.Task] = self.ReceiveTask
    self.triggerFuns[StoryConfig.StoryTrigger.OpenAlchemy] = self.OpenAlchemy
end

function StoryEventManager:BehaviorTrigger(triggerId, npcId, instanceId)
    EventMgr.Instance:Fire(EventName.StoryTriggerEvent, triggerId, npcId, instanceId)
    if self.triggerFuns[triggerId] then
        self.triggerFuns[triggerId](self, npcId, instanceId)
    end
end

function StoryEventManager:OpenNpcStore(npcId, instanceId)
    local shopId, condition, camera_params = StoryConfig.GetNpcStoreId(npcId)
    if not shopId then
        return
    end
    local isPass = Fight.Instance.conditionManager:CheckConditionByConfig(condition)
    if not isPass then
        return
    end
    -- 打开npc商店
    mod.ShopCtrl:GetShopGoodsAndOpenShop(shopId, npcId, camera_params)
end

function StoryEventManager:OpenAlchemy(npcId, instanceId)
    WindowManager.Instance:OpenWindow(AlchemyMainWindow)
end

function StoryEventManager:OpenTalent(npcId, instanceId)
    WindowManager.Instance:OpenWindow(TalentMainWindow)
end

function StoryEventManager:OpenMailing(npcId, instanceId)
	local mailingId = StoryConfig.GetMailingId(npcId)
	mod.MailingCtrl:OpenExchangeWindow(mailingId, npcId)
end

function StoryEventManager:ReceiveTask(npcId, instanceId)
    local taskId = mod.TaskCtrl:GetNpcAcceptTask(npcId)
    if not taskId then
        return
    end

    mod.TaskCtrl:AcceptTask(taskId)
end