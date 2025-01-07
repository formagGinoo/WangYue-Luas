TaskChapterCloseWindow = BaseClass("TaskChapterCloseWindow",BaseWindow)
local DataTask = Config.DataTask.data_task

function TaskChapterCloseWindow:__init()
    self:SetAsset("Prefabs/UI/Task/ChapterClose.prefab")

end

function TaskChapterCloseWindow:__delete()
   
end

function TaskChapterCloseWindow:__Show()
    self.nowTaskId = self.args.taskId
    self.taskInfo = DataTask[self.nowTaskId]
    self.taskTypeInfo = TaskConfig.GetTaskTypeInfo(self.taskInfo.type, self.taskInfo.sec_type)
    self:UpdateTitleAndName()
end

function TaskChapterCloseWindow:__RepeatShow()

end

function TaskChapterCloseWindow:__BindListener()
    UtilsUI.SetAnimationEventCallBack(self.gameObject, self:ToFunc("PlayEndCallback"))
end

function TaskChapterCloseWindow:__RemoveListener()

end

function TaskChapterCloseWindow:__Hide()
    
end

function TaskChapterCloseWindow:__ShowComplete()
    
end

function TaskChapterCloseWindow:UpdateTitleAndName()
    if self.taskTypeInfo.sec_type == 1 then --第一章显示序章
        self.chapterTitle_txt.text = TI18N("序章")
    else
        if self.taskTypeInfo.sec_type <= 10 then
            self.chapterTitle_txt.text = '0' .. (self.taskTypeInfo.sec_type - 1)..TI18N("章")
        else
            self.chapterTitle_txt.text = (self.taskTypeInfo.sec_type - 1) ..TI18N("章")
        end
    end
    self.chapterName_txt.text = self.taskTypeInfo.sec_type_subhead
end


function TaskChapterCloseWindow:PlayEndCallback()
    self:OnClickClose_CallBack()
end

function TaskChapterCloseWindow:OnClickClose_CallBack()
	local setting = {
		isWindow = true,
		args =  {taskId = self.args.taskId, mainView = true}
	}
    EventMgr.Instance:Fire(EventName.AddSystemContent, TaskChapterWindow, setting)
    WindowManager.Instance:CloseWindow(TaskChapterCloseWindow)
end




