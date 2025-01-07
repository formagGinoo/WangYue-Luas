TaskBehavior103080102 = BaseClass("TaskBehavior103080102")

function TaskBehavior103080102:__init()
    self.frame = 0
end

function TaskBehavior103080102:Update()
    self.frame = self.frame + 1
    if self.frame == 60 then
        MsgBoxManager.Instance:ShowTips(TI18N("这里会有一个和脉灵交互成功的回调，回调结束后开启下一个任务"), 2)
    elseif self.frame == 120 then
        BehaviorFunctions.SendTaskProgress(1030801, 2, 1)
    end
end

function TaskBehavior103080102:MailingExchangeFinish(npcId, mailingId)
    -- if npcId == 8102099 then
    --     MsgBoxManager.Instance:ShowTips(TI18N("这里会有一个和脉灵交互成功的回调，回调结束后开启下一个任务"))
    -- end
end