StoryEventManager = BaseClass("StoryEventManager")

function StoryEventManager:__init()
    self.triggerFuns = {}
    self.triggerFuns[StoryConfig.StoryTrigger.OpenNpcStore] = self.OpenNpcStore
    self.triggerFuns[StoryConfig.StoryTrigger.OpenTalent] = self.OpenTalent
    self.triggerFuns[StoryConfig.StoryTrigger.OpenMailing] = self.OpenMailing
    self.triggerFuns[StoryConfig.StoryTrigger.Task] = self.ReceiveTask
    self.triggerFuns[StoryConfig.StoryTrigger.OpenAlchemy] = self.OpenAlchemy
    self.triggerFuns[StoryConfig.StoryTrigger.OpenTrade] = self.OpenTrade
    self.triggerFuns[StoryConfig.StoryTrigger.Bargain] = self.OpenBargain
    self.triggerFuns[StoryConfig.StoryTrigger.TaskDuplicate] = self.OpenTaskDuplicate
    self.triggerFuns[StoryConfig.StoryTrigger.CitySimulation] = self.OpenCitySimulationMainWindow
    self.triggerFuns[StoryConfig.StoryTrigger.NightMareDuplicate] = self.OpenNightMareDuplicate
end 

function StoryEventManager:BehaviorTrigger(triggerId, npcId, instanceId)
    EventMgr.Instance:Fire(EventName.StoryTriggerEvent, triggerId, npcId, instanceId)
    if self.triggerFuns[triggerId] then
        self.triggerFuns[triggerId](self, npcId, instanceId)
    end
end

function StoryEventManager:GetBehaviorTriggerContext(triggerId, npcId, original)
    local subContent

    if triggerId == StoryConfig.StoryTrigger.OpenTrade then
        original, subContent = mod.TradeCtrl:SetNpcDialog(original)
    end

    return original, subContent
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

function StoryEventManager:OpenTrade(npcId, instanceId)
    LuaTimerManager.Instance:AddTimerByNextFrame(1, 0, function ()
        mod.TradeCtrl:EntryTradeByNpcId(npcId, instanceId)
    end)
end

function StoryEventManager:OpenBargain(npcId, instanceId)
    LuaTimerManager.Instance:AddTimerByNextFrame(1, 0, function ()
        local param, camera_params = StoryConfig.GetNpcBargainJump(npcId)
        if not param then
            LogError("讨价还价 参数为空")
            return
        end
        mod.BargainCtrl:EnterBargainNpc(param[1], param[2], npcId, instanceId)
    end)
end

function StoryEventManager:OpenTaskDuplicate(npcId, instanceId)
    BehaviorFunctions.OpenTaskDuplicateUiByNpc(npcId)
end

function StoryEventManager:OpenCitySimulationMainWindow(npcId, instanceId)
    BehaviorFunctions.OpenCitySimulationMainWindow(npcId)
end

function StoryEventManager:OpenNightMareDuplicate(npcId, instanceId)
    BehaviorFunctions.OpenNightMareDuplicateUiByNpc(npcId)
end 

function StoryEventManager:OpenMailing(npcId, instanceId)
	local mailingId = StoryConfig.GetMailingId(npcId)
	mod.MailingCtrl:OpenExchangeWindow(mailingId, npcId)
end

function StoryEventManager:ReceiveTask(npcId, instanceId)
    --TODO不用了
    -- local taskId = mod.TaskCtrl:GetNpcAcceptTask(npcId)
    -- if not taskId then
    --     return
    -- end
    
    --mod.TaskCtrl:AcceptTask(taskId)
end