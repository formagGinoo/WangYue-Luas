TaskChapterOpenWindow = BaseClass("TaskChapterOpenWindow",BaseWindow)
local DataTask = Config.DataTask.data_task

function TaskChapterOpenWindow:__init()
    self:SetAsset("Prefabs/UI/Task/ChapterOpen.prefab")

end

function TaskChapterOpenWindow:__delete()
    
end

function TaskChapterOpenWindow:__Show()
    self.nowTaskId = mod.TaskCtrl:GetGuideTaskId()
    self.taskInfo = DataTask[self.nowTaskId]
    self.taskTypeInfo = TaskConfig.GetTaskTypeInfo(self.taskInfo.type, self.taskInfo.sec_type)
    self:UpdateTitleAndName()
end

function TaskChapterOpenWindow:__Hide()
    
end

function TaskChapterOpenWindow:__RepeatShow()

end

function TaskChapterOpenWindow:__BindListener()
    UtilsUI.SetAnimationEventCallBack(self.gameObject, self:ToFunc("PlayEndCallback"))
end

function TaskChapterOpenWindow:__RemoveListener()

end

function TaskChapterOpenWindow:__ShowComplete()
	
end

function TaskChapterOpenWindow:UpdateTitleAndName()
    if self.taskTypeInfo.sec_type == 1 then --第一章显示序章
        self.chapterTitle_txt.text = TI18N("序章")
    else
        if self.taskTypeInfo.sec_type <= 10 then
            self.chapterTitle_txt.text = '0' .. (self.taskTypeInfo.sec_type - 1)..TI18N("章")
        else
            self.chapterTitle_txt.text = (self.taskTypeInfo.sec_type - 1)..TI18N("章")
        end
    end
    self.chapterName_txt.text = self.taskTypeInfo.sec_type_subhead
end

function TaskChapterOpenWindow:PlayEndCallback()
    self:OnClickClose_CallBack()
end

function TaskChapterOpenWindow:OnClickClose_CallBack()
    WindowManager.Instance:CloseWindow(TaskChapterOpenWindow)
end




