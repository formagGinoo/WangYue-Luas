ActivityTaskPanel = BaseClass("ActivityTaskPanel", BasePanel)
local _tinsert = table.insert

local defSelectTagIdx = 1

function ActivityTaskPanel:__init()
    self:SetAsset("Prefabs/UI/Activity/ActivityTaskPanel.prefab")
	self.activationNodes = {}
    self.dayOnShow = {}
end

function ActivityTaskPanel:__CacheObject()

end

function ActivityTaskPanel:__BindListener()
    
end

function ActivityTaskPanel:__Show()
	
	EventMgr.Instance:AddListener(EventName.ActivityTaskUpdate, self:ToFunc("OnActivityTaskUpdate"))
	EventMgr.Instance:AddListener(EventName.SystemTaskFinish, self:ToFunc("OnSystemTaskUpdate"))
	EventMgr.Instance:AddListener(EventName.SystemTaskChange, self:ToFunc("OnSystemTaskUpdate"))
	EventMgr.Instance:AddListener(EventName.SystemTaskFinished, self:ToFunc("OnSystemTaskUpdate"))
	EventMgr.Instance:AddListener(EventName.SystemTaskUpdate, self:ToFunc("OnSystemTaskUpdate"))
	
    self.ActivityTaskItemMap = {}
    self.taskObjs = {}
    self.selectTagIdx = nil
    self:UpdateDayList()
    self:SelectTag(mod.ActivityCtrl:GetDefaultDay(self.args.id))
    self:InitActivityProgress()
end

function ActivityTaskPanel:__Hide()

	for _, luaObj in pairs(self.taskObjs) do
        luaObj:Destory()
        luaObj:DeleteMe()
	end
	self.taskObjs = {}
	EventMgr.Instance:RemoveListener(EventName.ActivityTaskUpdate, self:ToFunc("OnActivityTaskUpdate"))
	EventMgr.Instance:RemoveListener(EventName.SystemTaskFinish, self:ToFunc("OnSystemTaskUpdate"))
	EventMgr.Instance:RemoveListener(EventName.SystemTaskChange, self:ToFunc("OnSystemTaskUpdate"))
	EventMgr.Instance:RemoveListener(EventName.SystemTaskFinished, self:ToFunc("OnSystemTaskUpdate"))
	EventMgr.Instance:RemoveListener(EventName.SystemTaskUpdate, self:ToFunc("OnSystemTaskUpdate"))
end

function ActivityTaskPanel:__delete()
    self.DuplicateContetnt_recyceList:CleanAllCell()

	self.activationNodes = {}
    self.dayOnShow = {}
	for _, v in pairs(self.activationNodes) do
		if v.cacheObjList then
			for _, obj in pairs(v.cacheObjList) do
				ItemManager.Instance:PushItemToPool(obj)
			end
			v.cacheObjList = {}
		end
	end

	for _, luaObj in pairs(self.taskObjs) do
        luaObj:Destory()
        luaObj:DeleteMe()
	end
    
	self.taskObjs = {}
end

function ActivityTaskPanel:UpdateDayList()
    self.taskGroupList = ActivityConfig.GetActivityTask(self.args.id)

    for i, v in ipairs(self.taskGroupList) do
        local dayObj = self:GetDayObj(i)
        self.dayOnShow[i] = dayObj

        local isComplete = mod.ActivityCtrl:CheckTaskDayComplete(v)
        local hasCanGet = mod.ActivityCtrl:CheckTaskDayCanGet(v)
        local lock = mod.ActivityCtrl:CheckTaskDayLock(self.args.id,i)

        UnityUtils.SetActive(dayObj.Complete, isComplete)
        UnityUtils.SetActive(dayObj.RedPoint, hasCanGet)
        UnityUtils.SetActive(dayObj.Lock, lock)
        UnityUtils.SetActive(dayObj.fenge, i ~= #self.taskGroupList)
        
        self.dayOnShow[i].lock = lock


        local clickFunc = function ()
            if lock then
                MsgBoxManager.Instance:ShowTips(string.format(TI18N("累计登陆%s天解锁"), tostring(i)))
            else
                self:SelectTag(i)
            end
        end
        
        dayObj.ClickBtn_btn.onClick:RemoveAllListeners()
        dayObj.ClickBtn_btn.onClick:AddListener(clickFunc)
    end

end

function ActivityTaskPanel:GetDayObj(index)
    if next(self.dayOnShow) and self.dayOnShow[index] then
        return self.dayOnShow[index]
    end

    local dayObj = self:PopUITmpObject("DayTemp")
    dayObj.objectTransform:SetParent(self.Days.transform)

    UtilsUI.GetContainerObject(dayObj.objectTransform, dayObj)
    UnityUtils.SetLocalScale(dayObj.objectTransform, 1, 1, 1)
    dayObj.object:SetActive(true)

    return dayObj
end

function ActivityTaskPanel:SelectTag(idx)
    if self.selectTagIdx == idx then return end
    
    self.selectTagIdx = idx
    self:UpdateDaysColor()
    self:OnSystemTaskUpdate()
end

function ActivityTaskPanel:UpdateDaysColor()
    for index, tagItem in pairs(self.dayOnShow) do
        if index ~= self.selectTagIdx then
            UnityUtils.SetActive(tagItem.Select, false)
            
            if tagItem.lock then
                tagItem.DayNum_txt.text ="<color=#696377>".."0"..index.."</color>"
                tagItem.DayTxt_txt.text = "<color=#696377>"..TI18N("天").."</color>"
            else
                tagItem.DayNum_txt.text ="<color=#FFFFFF>".."0"..index.."</color>"
                tagItem.DayTxt_txt.text = "<color=#FFFFFF>"..TI18N("天").."</color>"
            end
        else
            UnityUtils.SetActive(tagItem.Select, true)
            tagItem.DayNum_txt.text ="<color=#F0CD96>".."0"..index.."</color>"
            tagItem.DayTxt_txt.text = "<color=#F0CD96>"..TI18N("天").."</color>"
        end
    end
end
function ActivityTaskPanel:OnSystemTaskUpdate()
    
	self:UpdateDayList()
	
	for _, luaObj in pairs(self.taskObjs) do
        luaObj:Destory()
        luaObj:DeleteMe()
	end
	self.taskObjs = {}

    --self.DuplicateContetnt_recyceList:CleanAllCell()
    
    self.DuplicateContetnt_recyceList:SetLuaCallBack(self:ToFunc("UpdateActivityTaskItem"))
    self.DuplicateContetnt_recyceList:SetCellNum(#self.taskGroupList[self.selectTagIdx],true)

end

function ActivityTaskPanel:UpdateActivityTaskItem(index, obj)
    local rect = obj:GetComponent(RectTransform)
    UnityUtils.SetAnchoredPosition(rect, 0, 0)

    local taskId = self.taskGroupList[self.selectTagIdx][index]

    
    --local dupItem = PoolManager.Instance:Pop(PoolType.class, "ActivityTaskItem")
    
    local dupItem = ActivityTaskItem.New()
    table.insert(self.taskObjs, dupItem)

    dupItem:SetData(self, {taskId = taskId, obj = obj, index = index})
end

function ActivityTaskPanel:SystemTaskCommit(taskId)
    mod.SystemTaskCtrl:SystemTaskCommit(taskId)
end

function ActivityTaskPanel:InitActivityProgress()

    self.ActivityProgressContainer = UtilsUI.GetContainerObject(self.ActivityProgress.transform)
    
    self.taskGears = ActivityConfig:GetTaskGearArray(self.args.id)

	TableUtils.ClearTable(self.activationNodes)
    local nodeIndex = 0
    for nodeIndex, v in ipairs(self.taskGears) do
        local rewardKey = v.num
        local rewardId = v.reward_id
		local activationNode = {}
        self.activationNodes[rewardKey] = activationNode
		
        self.ActivityProgressContainer["node"..nodeIndex.."_txt"].text = v.num
		local nodeTransform =  self.ActivityProgressContainer["node"..nodeIndex].transform
		activationNode.transform = nodeTransform
		
		local nodes = UtilsUI.GetContainerObject(nodeTransform)
		activationNode.node = nodes
	end
	
	local progress = nil
	local maxProgress = nil
	local percent = nil
	progress,maxProgress,percent = mod.ActivityCtrl:GetTaskSumRewardInfo(self.args.id)
    self.ActivityProgressContainer.ProgressBarFill_img.fillAmount =  percent
    self.ActivityProgressContainer.DoneTxt_txt.text = TI18N("已完成任务数")

	self:RefreshActivityProgress()
	
end
function ActivityTaskPanel:OnActivityTaskUpdate()
    self:UpdateDayList()
    self:UpdateDaysColor()
	self:RefreshActivityProgress()
end

function ActivityTaskPanel:UpdateNodes(rewardKey,rewardId , num)

    local status = mod.ActivityCtrl:GetTaskSumRewardStatus(self.args.id,rewardKey) or 3
    local canGet = status == 1
    local hasGet = status == 2
    
    local activationNode = self.activationNodes[rewardKey]
    local rewardList = ActivityConfig.GetRewardList(rewardId)
    activationNode.cacheObjList = activationNode.cacheObjList or {}
    if rewardList then
        local rewardConfig = rewardList[1]
        local itemInfo = nil
        local showEffect = false
        if canGet then
            itemInfo = {template_id = rewardConfig[1], count = rewardConfig[2], acquired = false,btnFunc = function ()
                mod.ActivityCtrl:ReceiveTaskSumReward(self.args.id,rewardKey)
            end}
            
            --UtilsUI.SetEffectSortingOrder(nodes["22124"], self.canvas.sortingOrder + 1)
            --UtilsUI.SetEffectSortingOrder(nodes["22126"], self.canvas.sortingOrder + 1)
            --UtilsUI.SetEffectSortingOrder(nodes["22127"], self.canvas.sortingOrder + 1)
            showEffect = true
        elseif hasGet then
            itemInfo = {template_id = rewardConfig[1], count = rewardConfig[2], acquired = true}
        else
            itemInfo = {template_id = rewardConfig[1], count = rewardConfig[2]}
        end

        UnityUtils.SetActive(activationNode.node.notReach, not (canGet or hasGet) )
        UnityUtils.SetActive(activationNode.node.reach, (canGet or hasGet))
		
		local itemContainer = UtilsUI.GetContainerObject(activationNode.node.CommonItem)
		
        
        local layer = WindowManager.Instance:GetCurOrderLayer()
        UtilsUI.SetEffectSortingOrder(itemContainer.Effect, layer + 1)
        UnityUtils.SetActive(itemContainer.Effect, showEffect)

        local item = activationNode.cacheObjList[1]
        if not item then
            item = ItemManager.Instance:GetItem(activationNode.node.CommonItem.transform, itemInfo)
            table.insert(activationNode.cacheObjList, item)
        end
        
        item:SetItem(itemInfo)
        item:Show()
    end
end

local singleStep = 0.02
function ActivityTaskPanel:ProgressAnim()
	self.step = self.step + singleStep
	local amount = self.curAmount + self.step
	amount = amount > self.nextAmount and self.nextAmount or amount
    self.ActivityProgressContainer.ProgressBarFill_img.fillAmount =  amount
	
	if amount >= self.nextAmount then
		self.playAnim = false
		self.curAmount = nil
		self.nextAmount = nil
		self.step = 0
		if self.updateTimer then
			LuaTimerManager.Instance:RemoveTimer(self.updateTimer)
		end
	end
end

function ActivityTaskPanel:RefreshActivityProgress()
    
	local progress,maxProgress,percent = mod.ActivityCtrl:GetTaskSumRewardInfo(self.args.id)

    self.ActivityProgressContainer.DoneNum_txt.text = progress
    self.ActivityProgressContainer.TotalNum_txt.text = "/"..maxProgress
	
	self.step = self.step or 0
	self.curAmount = self.curAmount or self.ActivityProgressContainer.ProgressBarFill_img.fillAmount
	self.nextAmount = percent
	
	if not self.playAnim and self.curAmount < self.nextAmount then
		self.playAnim = true
		self.updateTimer = LuaTimerManager.Instance:AddTimer(0, 0.02, self:ToFunc("ProgressAnim"))
	end

    
    for k, v in ipairs(self.taskGears) do
        local rewardKey = v.num
        local rewardId = v.reward_id
        self:UpdateNodes(rewardKey, rewardId , v.num)
	end

end

