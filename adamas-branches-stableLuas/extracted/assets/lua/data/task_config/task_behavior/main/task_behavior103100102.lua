TaskBehavior103100102 = BaseClass("TaskBehavior103100102")

function TaskBehavior103100102:__init()
    self.frame = 0
end

function TaskBehavior103100102:Update()
    self.frame = self.frame + 1
    if self.frame == 60 then
        MsgBoxManager.Instance:ShowTips(TI18N("这里有一个飞行踏板的建造教学，教学结束后开启下一个任务"), 2)
    elseif self.frame == 120 then
        BehaviorFunctions.SendTaskProgress(1031001, 2, 4)
    end
end