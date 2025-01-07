TaskBehavior103080109 = BaseClass("TaskBehavior103080109")

function TaskBehavior103080109:__init()
    self.frame = 0
end

function TaskBehavior103080109:Update()
    self.frame = self.frame + 1
    if self.frame == 60 then
        MsgBoxManager.Instance:ShowTips(TI18N("这里有一个搬运教学，教学结束后开启下一个任务"), 2)
    elseif self.frame == 120 then
        BehaviorFunctions.SendTaskProgress(1030801, 9, 4)
    end
end