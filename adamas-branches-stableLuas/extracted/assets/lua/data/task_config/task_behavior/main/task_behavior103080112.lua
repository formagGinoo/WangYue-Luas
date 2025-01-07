TaskBehavior103080112 = BaseClass("TaskBehavior103080112")

function TaskBehavior103080112:__init()
    self.frame = 0
end

function TaskBehavior103080112:Update()
    self.frame = self.frame + 1
    if self.frame == 60 then
        MsgBoxManager.Instance:ShowTips(TI18N("这里有一个拼接教学，教学结束后开启下一个任务"), 2)
    elseif self.frame == 120 then
        BehaviorFunctions.SendTaskProgress(1030801, 12, 4)
    end
end