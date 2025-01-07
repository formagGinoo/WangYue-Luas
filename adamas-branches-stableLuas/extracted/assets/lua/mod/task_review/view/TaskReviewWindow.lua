TaskReviewWindow = BaseClass("TaskReviewWindow", BaseWindow)

local LineNameDict = 
{
    [1] = "RLine",
    [2] = "DLine",
    [3] = "ULine",
    [4] = "RDLine",
    [5] = "RULine",
    [12] = "RDRLine",
    [13] = "RURLine",
    [21] = "DRULine",
    [31] = "URDLine",
}

function TaskReviewWindow:__init()
	self:SetAsset("Prefabs/UI/TaskReview/TaskReviewWindow.prefab")
    self.TaskNodeList = {}
    self.LineNodeList = {}
    self.TaskLineDict = {}
    self.unShowNode = {}
    self.maxScale = 1
    self.minScale = 0.5
    self.mapScale = 1
end

function TaskReviewWindow:__BindListener()
    self.scaleBar = self.ScaleBar:GetComponent(Scrollbar)
    self.scaleBar.onValueChanged:AddListener(self:ToFunc("OnValueChange_Scale"))

    self.ScalePlu_btn.onClick:AddListener(self:ToFunc("OnClickScalePlu"))
    self.ScaleMin_btn.onClick:AddListener(self:ToFunc("OnClickScaleMin"))

    self.MailuoBtn_btn.onClick:AddListener(self:ToFunc("OnClickMailuoBtn"))
    self.ReviewBtn_btn.onClick:AddListener(self:ToFunc("OnClickReviewBtn"))
    self:BindCloseBtn(self.CommonBack2_btn,self:ToFunc("OnClickClose"))
end

function TaskReviewWindow:__CacheObject()
    self:SetCacheMode(UIDefine.CacheMode.destroy)
end

function TaskReviewWindow:__Create()
    
end

function TaskReviewWindow:__delete()
    for i, v in ipairs(self.TaskNodeList) do
        PoolManager.Instance:Push(PoolType.class, "TaskReviewNode", v)
    end
    self.TaskNodeList = nil
    self.LineNodeList = nil
    self.TaskLineDict = nil
    self.unShowNode = nil
end

function TaskReviewWindow:__Hide()
    
end

function TaskReviewWindow:__TempShow()
    local scroll = self.ScrollView.transform:GetComponent(ScrollRect)
    scroll.inertia = false
    local function SetCont()
        if self.ShowContent then
            UnityUtils.SetAnchoredPosition(self.ShowContent.transform,0,0)
        end
    end
    local function SetInertia()
        scroll.inertia = true
    end
    LuaTimerManager.Instance:AddTimer(10, 0.05, SetCont)
    LuaTimerManager.Instance:AddTimer(1, 0.5, SetInertia)
end

function TaskReviewWindow:__Show()
    self.pageId = TaskReviewConfig.GetPageId(self.args.type,self.args.sec_type)
    self.Title1_txt.text = TaskReviewConfig.GetPageTitle(self.args.type,self.args.sec_type)
    self.Title2_txt.text = TaskReviewConfig.GetPageSmallTitle(self.args.type,self.args.sec_type)
    self.taskList = TaskReviewConfig.GetPageTaskList(self.pageId)
    self.mpaSize = TaskReviewConfig.GetPageContentSize(self.pageId)
    self.ShowContent_rect.sizeDelta = Vector2(self.mpaSize[1]*100,self.mpaSize[2]*100)
end

function TaskReviewWindow:__ShowComplete()
    self:InitTaskNode()
    self:DrawLine()
end

function TaskReviewWindow:InitTaskNode()
    for _, v in ipairs(self.taskList) do
        if self.unShowNode[v.node_id] then
            for _, nodeid in ipairs(v.base_jump) do
                self.unShowNode[nodeid] = true
            end
        else
            local taskNode = PoolManager.Instance:Pop(PoolType.class, "TaskReviewNode")
            if not taskNode then
                taskNode = TaskReviewNode.New()
            end
            local isShow = mod.TaskCtrl:CheckTaskStepIsFinish(v.node_show[1],v.node_show[2]) -- mod.TaskCtrl:CheckTaskIsFinish(v.node_show)
            local isLock = self:CheckNodeIsLock(v.node_task_show)
            local type = isShow and v.node_type or 0
            local nodeObjName
            if not isShow and v.node_type == 6 then
                type = 8
            end
            if not isLock then
                type = 9
                for _, nodeid in ipairs(v.base_jump) do
                    self.unShowNode[nodeid] = true
                end
                self.ShowContent_rect.sizeDelta = Vector2(v.x_id*100 + 500,self.mpaSize[2]*100)
            end
            nodeObjName = TaskReviewConfig.GetNodeByType(type)
            local objectInfo = self:PopUITmpObject(nodeObjName, self.ShowContent_rect)
            taskNode:InitNode(objectInfo.object, v, isShow, not isLock)
            UnityUtils.SetAnchoredPosition(objectInfo.objectTransform,v.x_id*100,v.y_id*100)
            self.TaskNodeList[v.node_id] = taskNode    
        end
    end
end

function TaskReviewWindow:DrawLine()
    for _, v in ipairs(self.taskList) do
        for i, id in ipairs(v.base_jump) do
            self:ConnectLine(v.node_id,id,v.ligature_type[i],#v.base_jump)
        end
    end
end

function TaskReviewWindow:ConnectLine(id1,id2,lineType,lineCount)
    if self.unShowNode[id1] or self.unShowNode[id2] then return end
    local node1rect = self.TaskNodeList[id1].node["_rect"]
    local node2rect = self.TaskNodeList[id2].node["_rect"]
    local node1data = self.TaskNodeList[id1].curNodeData
    local node2data = self.TaskNodeList[id2].curNodeData
    local startPos
    local endPos
    if lineType == 1 then
		startPos = self.TaskNodeList[id1].node.R_rect
        endPos = self.TaskNodeList[id2].node.L_rect
	elseif lineType == 2 then
		startPos = self.TaskNodeList[id1].node.D_rect
        endPos = self.TaskNodeList[id2].node.U_rect
	elseif lineType == 3 then
		startPos = self.TaskNodeList[id1].node.U_rect
        endPos = self.TaskNodeList[id2].node.D_rect
	elseif lineType == 4 then
		startPos = self.TaskNodeList[id1].node.R_rect
        endPos = self.TaskNodeList[id2].node.U_rect
	elseif lineType == 5 then
		startPos = self.TaskNodeList[id1].node.R_rect
        endPos = self.TaskNodeList[id2].node.D_rect
	elseif lineType == 12 then
		startPos = self.TaskNodeList[id1].node.R_rect
        endPos = self.TaskNodeList[id2].node.L_rect
	elseif lineType == 13 then
		startPos = self.TaskNodeList[id1].node.R_rect
        endPos = self.TaskNodeList[id2].node.L_rect
	elseif lineType == 21 then
		startPos = self.TaskNodeList[id1].node.D_rect
        endPos = self.TaskNodeList[id2].node.D_rect
	elseif lineType == 31 then
		startPos = self.TaskNodeList[id1].node.U_rect
        endPos = self.TaskNodeList[id2].node.U_rect
	end

    local lineName = LineNameDict[lineType]

    if self:CheckLineSelect(id1,id2) then
        lineName = lineName .. "Select"
    end

    local position1 = startPos.anchoredPosition + node1rect.anchoredPosition
    local position2 = endPos.anchoredPosition + node2rect.anchoredPosition

    local vec = position2 - position1

    local objectInfo = self:PopUITmpObject(lineName, self.ShowContent_rect)
    UnityUtils.SetAnchoredPosition(objectInfo.objectTransform,position1.x,position1.y)
    UtilsUI.SetActive(objectInfo.object,true)

    local taskLine = PoolManager.Instance:Pop(PoolType.class, "TaskReviewLine")
    if not taskLine then
        taskLine = TaskReviewLine.New()
    end
    taskLine:InitLine(objectInfo.object,vec,lineType,lineCount > 1)
    table.insert(self.LineNodeList,taskLine)
    self.TaskLineDict[id1] = objectInfo
end

function TaskReviewWindow:CheckLineSelect(id1,id2)
    local node1data = self.TaskNodeList[id1].curNodeData
    local node2data = self.TaskNodeList[id2].curNodeData
    --return mod.TaskCtrl:CheckTaskIsFinish(node2data.node_route) and mod.TaskCtrl:CheckTaskIsFinish(node1data.node_route)
    return mod.TaskCtrl:CheckTaskStepIsFinish(node2data.node_route[1], node2data.node_route[2]) 
        and mod.TaskCtrl:CheckTaskStepIsFinish(node1data.node_route[1], node1data.node_route[2])
end

function TaskReviewWindow:OnClickScalePlu()
    local val = (self.scaleBar.value + 0.1)
    if val < 0 then
        val = 0
    end
    if val > 1 then
        val = 1
    end
    self.scaleBar.value = val
end

function TaskReviewWindow:OnClickScaleMin()
    local val = (self.scaleBar.value - 0.1)
    if val < 0 then
        val = 0
    end
    if val > 1 then
        val = 1
    end
    self.scaleBar.value = val
end
                -- +1200                         1600
 --   -1311.2     --->     - 110          2600          800
function TaskReviewWindow:OnValueChange_Scale(value)
    --local scale = self.mapScale
    --local x = self.ShowContent_rect.anchoredPosition.x + 960/self.mapScale
    --local y = self.ShowContent_rect.anchoredPosition.y
    self.mapScale = self.maxScale - ((self.maxScale - self.minScale) * (1 - value))
    self:RefreshContentScale()
    --x = x - 960/self.mapScale
    --y = y
    --UnityUtils.SetLocalScale(self.ShowContent.transform, self.mapScale, self.mapScale, self.mapScale)
    --UnityUtils.SetAnchoredPosition(self.ShowContent.transform,x,y)
end

function TaskReviewWindow:RefreshContentScale()
    local _, minPos, maxPos
    _, minPos = RectTransformUtility.ScreenPointToLocalPointInRectangle(self.ShowContent.transform, Vector2(0, 0), ctx.UICamera)
    _, maxPos = RectTransformUtility.ScreenPointToLocalPointInRectangle(self.ShowContent.transform, Vector2(Screen.width, Screen.height), ctx.UICamera)

    local centerPos = { x = (minPos.x + maxPos.x) * -0.5, y = (minPos.y + maxPos.y) * -0.5}
    local width = (centerPos.x * self.mapScale) + (self.ScrollView_rect.rect.width * 0.5)
    UnityUtils.SetLocalScale(self.ShowContent.transform, self.mapScale, self.mapScale, self.mapScale)
    UnityUtils.SetLocalPosition(self.ShowContent.transform, width, self.ShowContent.transform.localPosition.y)
end

function TaskReviewWindow:OnClickMailuoBtn()
    WindowManager.Instance:OpenWindow(TaskReviewMainWindow)
    -- WindowManager.Instance:CloseWindow(self)
end

function TaskReviewWindow:OnClickReviewBtn()
    MsgBoxManager.Instance:ShowTips(TI18N("功能暂未开启，敬请期待"))
end

function TaskReviewWindow:OnClickClose()
    WindowManager.Instance:CloseWindow(self)
end

function TaskReviewWindow:CheckNodeIsLock(taskList)
    if not taskList or #taskList == 0 then return true end 
    for i, v in ipairs(taskList) do
        if mod.TaskCtrl:CheckTaskNodeIsFinish(v) then
            return true
        end
    end
    return false
end