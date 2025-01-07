TaskReviewMainWindow = BaseClass("TaskReviewMainWindow", BaseWindow)

function TaskReviewMainWindow:__init()
	self:SetAsset("Prefabs/UI/TaskReview/TaskReviewMainWindow.prefab")
	self.PageItemList = {}
end

function TaskReviewMainWindow:__BindListener()
    self:BindCloseBtn(self.CommonBack2_btn,self:ToFunc("OnClickClose"))
end

function TaskReviewMainWindow:__CacheObject()

end

function TaskReviewMainWindow:__Create()
    
end

function TaskReviewMainWindow:__delete()

end

function TaskReviewMainWindow:__TempShow()
    local scroll = self.PageList.transform:GetComponent(ScrollRect)
    scroll.inertia = false
    local function SetCont()
        UnityUtils.SetAnchoredPosition(self.PageContent.transform,0,0)
        --scroll.verticalScrollbar.value = 0
    end
    local function SetInertia()
        scroll.inertia = true
    end
    LuaTimerManager.Instance:AddTimer(1, 0.05, SetCont)
    LuaTimerManager.Instance:AddTimer(1, 0.5, SetInertia)
end

function TaskReviewMainWindow:__Show()
	self.pageList = TaskReviewConfig.GetPageList()
    self:RefreshPageList()
end

function TaskReviewMainWindow:__ShowComplete()

end

function TaskReviewMainWindow:RefreshPageList()
	for key, v in pairs(self.pageList) do
        if v.open_task == 0 or mod.TaskCtrl:CheckTaskIsFinish(v.open_task) then
            local pageItem = PoolManager.Instance:Pop(PoolType.class, "PageItem")
            if not pageItem then
                pageItem = PageItem.New()
            end
            local objectInfo = self:PopUITmpObject("PageItem", self.PageContent_rect)
            pageItem:InitItem(objectInfo.object,v)
            self.PageItemList[key] = pageItem
            local onClickFunc = function()
                mod.TaskReviewCtrl:RequestTaskStatistic(v.type,v.sec_type)
                self:OnClick_PageItem(v.type,v.sec_type)
            end
            pageItem:SetBtnEvent(false, onClickFunc, false)
        end
    end
end

function TaskReviewMainWindow:OnClick_PageItem(type,sec_type)
	WindowManager.Instance:OpenWindow(TaskReviewWindow,{type = type,sec_type = sec_type})
    --WindowManager.Instance:CloseWindow(self)
end

function TaskReviewMainWindow:OnClickClose()
    WindowManager.Instance:CloseWindow(self)
end

function TaskReviewMainWindow:__Hide()
    
end

