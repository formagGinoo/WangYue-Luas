TaskBehavior103090104 = BaseClass("TaskBehavior103090104")

function TaskBehavior103090104:__init()
    self.frame = 0
end

function TaskBehavior103090104:Update()
    self.frame = self.frame + 1
    if self.frame == 60 then
        MsgBoxManager.Instance:ShowTips(TI18N("这里有一个船的建造教学，教学结束后开启下一个任务"), 2)
    elseif self.frame == 120 then
        BehaviorFunctions.SendTaskProgress(1030901, 4, 4)
    end
end