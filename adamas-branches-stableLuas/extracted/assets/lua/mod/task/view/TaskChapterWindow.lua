TaskChapterWindow = BaseClass("TaskChapterWindow",BaseWindow)

local enumArrow = {
    left = 1 , --左侧箭头
    right = 2 --右侧箭头
}
local ProgressPercent = 0.25
local DataTask = Config.DataTask --任务表
local DataReward = Config.DataReward.Find --奖励表
local DataTaskReward = Config.DataTaskReward.Find --奖励弹窗任务表
local maxProgressNum = 4

function TaskChapterWindow:__init()
    self:SetAsset("Prefabs/UI/Task/TaskChapterWindow.prefab")
    self.maxChapterId = 0 --奖励表中最大的章节id
    self.selectTab = nil --默认为1，收到服务端数据后更新
    self.nowTaskId = nil --当前的任务id
    self.nowDataTaskKey = nil --当前任务的key
    self.rewardItemObjs = {} --icon
    self.rewardPoint = {} --激活点
    self.node = {} --进度条
    self.taskRewardTb = {}--目前能够看到几个任务列表
end

function TaskChapterWindow:__delete()
    self:__RemoveListener()
    for _, v in pairs(self.rewardItemObjs) do
        ItemManager.Instance:PushItemToPool(v.item)
        self:PushUITmpObject("Item", v.itemParent)
    end
    self.rewardItemObjs = {}
    self.rewardPoint = {}
    self.taskRewardTb = {}
end

function TaskChapterWindow:__CacheObject()
    self:SetCacheMode(UIDefine.CacheMode.destroy)
end

function TaskChapterWindow:__Show()
    self.notTempHide = self.args.notTempHide or false
    self:UpdateCenter()
end

function TaskChapterWindow:__RepeatShow()
    
end

function TaskChapterWindow:__Create()
    self.nowTaskId = self.args.taskId or mod.TaskCtrl:GetGuideTaskId()
    local step =  mod.TaskCtrl:GetTaskStep(self.nowTaskId)
    self.nowDataTaskKey = string.format("%s_%s",self.nowTaskId,step)
    self.rightTexture.transform:SetActive(false)
    for i = 1, maxProgressNum do
        local point = self.progressPoint.transform:GetChild(i-1)
        local container = UtilsUI.GetContainerObject(point.transform)
        table.insert(self.rewardPoint, {point = point, container = container} )
    end
    self.node = UtilsUI.GetContainerObject(self.progressLight)
    --判断目前在第几章任务
    self:UpdateSelectTaskInfo()
end

function TaskChapterWindow:__ShowComplete()
    if not self.blurBack then
        local setting = {bindNode = self.BlurNode}
        self.blurBack = BlurBack.New(self, setting)
    end
    local callBack = function ()
        if BehaviorFunctions.fight.clientFight.cameraManager:GetCameraState() == FightEnum.CameraState.Operating then
            BehaviorFunctions.fight.clientFight.cameraManager:SetFOV(60)
        end
    end
    self.blurBack:Show()
end

function TaskChapterWindow:__BindListener()
    EventMgr.Instance:AddListener(EventName.RecivedTaskReward, self:ToFunc("ClickItemCallback"))
    self.onClickCloseImage_btn.onClick:AddListener(function()
        self:RefreshEffectOut()
        self:PlayExitAnim()
    end)
    --左箭头点击
    self.leftArrow_btn.onClick:AddListener(function()
        self:OnClickArrow(enumArrow.left)
    end)
    --右箭头点击
    self.rightArrow_btn.onClick:AddListener(function()
        self:OnClickArrow(enumArrow.right)
    end)
    UtilsUI.SetAnimationEventCallBack(self.gameObject, self:ToFunc("RefreshEffectIn"))
end

function TaskChapterWindow:__BindEvent()
    
    
end

function TaskChapterWindow:__RemoveListener()
    EventMgr.Instance:RemoveListener(EventName.RecivedTaskReward, self:ToFunc("ClickItemCallback"))
    self.onClickCloseImage_btn.onClick:RemoveAllListeners()
    self.leftArrow_btn.onClick:RemoveAllListeners()
    self.rightArrow_btn.onClick:RemoveAllListeners()
end

function TaskChapterWindow:__Hide()
    
end

function TaskChapterWindow:UpdateCenter()
    --更新立绘
    self:UpdateRightTexture()
    --判断是否显示左右箭头
    self:UpdateArrow()
    --更新标题和介绍
    self:UpdateTitleAndIntroduce()
    self:UpdateIcon()
    --更新任务进度
    self:UpdateProgress()
end

function TaskChapterWindow:UpdateSelectTaskInfo()
    --知道目前的任务id self.nowTaskId
    local taskCfg = DataTask.data_task[self.nowDataTaskKey]
    for i, v in pairs(DataTaskReward) do
		local isStarted = false
        if v.type == taskCfg.type and v.sec_type == Config.DataTaskType.FindNodesInfo[taskCfg.id] .sec_type then --寻找当前章节
			isStarted = true --按章节加入到taskReward表中
        end
        local isFinished = mod.TaskCtrl:CheckTaskIsFinish(v.chapter_end)
        if isStarted or isFinished then
            self.taskRewardTb[v.sec_type] = v --按章节加入到taskReward表中
        end
    end
    if next(self.taskRewardTb) then
        self.maxChapterId = self.taskRewardTb[#self.taskRewardTb].id
    end

    
    if not self.args.mainView then
        --仅在任务面板进来时判断
        --如果有红点, 显示最近一章的
        --如果都没红点，显示最后一章，显示最后一章
        self.selectTab = self:GetSelectTbByTaskView()
    else
        self.selectTab = self:GetSelectTbByMainView()
    end

    --如果做完了主线任务，或者没找到该配置
    if not self.selectTab then
        --显示当前完成的最后一章
        self.selectTab = self.maxChapterId
    end
end

function TaskChapterWindow:GetSelectTbByMainView()
    local chapterInfo = TaskConfig.GetTaskChapterInfoByTaskId(self.nowTaskId)
    
    if chapterInfo then
        return chapterInfo.id
    end
    
    return
end

function TaskChapterWindow:GetSelectTbByTaskView()
    local redId
    for i, v in ipairs(self.taskRewardTb) do
        local isRed = mod.TaskCtrl:CheckNowTaskChapterIsRed(v.id)
        if isRed then
            redId = v.id
        end
    end
    
    return redId
end

function TaskChapterWindow:UpdateArrow()
    --如果不是主界面点击打开的，则按情况显示俩个箭头
    if not self.args.mainView then
        local isleftActive = DataTaskReward[self.selectTab - 1] and self.taskRewardTb[DataTaskReward[self.selectTab - 1].sec_type]
        local isrightActive = DataTaskReward[self.selectTab + 1] and self.taskRewardTb[DataTaskReward[self.selectTab + 1].sec_type]
        self.leftArrow.transform:SetActive(isleftActive or false)
        self.rightArrow.transform:SetActive(isrightActive or false)
        self:UpdateArrowRed()
    else
        self.leftArrow.transform:SetActive(false)
        self.rightArrow.transform:SetActive(false)
    end
end

function TaskChapterWindow:UpdateArrowRed()
    local isleftRedActive = mod.TaskCtrl:CheckNowTaskChapterIsRed(self.selectTab -1)
    local isrightRedActive = mod.TaskCtrl:CheckNowTaskChapterIsRed(self.selectTab + 1)
    self.leftRed.transform:SetActive(isleftRedActive)
    self.rightRed.transform:SetActive(isrightRedActive)
end

function TaskChapterWindow:UpdateRightTexture()
    --todo 立绘会闪一下
    local taskRewardInfo = DataTaskReward[self.selectTab] --任务章节奖励
    if not taskRewardInfo then
        return
    end
    if taskRewardInfo.task_stand ~= "" then
        local callback = function()
            self.rightTexture.transform:SetActive(true)
        end
        SingleIconLoader.Load(self.rightTexture, taskRewardInfo.task_stand, callback)
    end
end

function TaskChapterWindow:UpdateTitleAndIntroduce()
    --更新该任务节点的titile和描述
    local taskCfg = DataTask.data_task[self.nowDataTaskKey] --任务表
    local taskRewardInfo = DataTaskReward[self.selectTab] --任务章节奖励
    if not taskRewardInfo then
        return
    end
    local taskTypeCfg = TaskConfig.GetTaskTypeInfo(taskRewardInfo.type, taskRewardInfo.sec_type) --任务表子表

    if not mod.TaskCtrl:CheckTaskIsFinish(taskRewardInfo.chapter_end) then
        --任务描述
        self.introduceTitle_txt.text = TI18N("剧情简介")
        self.introduceText_txt.text = taskCfg.task_desc 
    else
        --回顾
        self.introduceTitle_txt.text = TI18N("剧情回顾")
        self.introduceText_txt.text = taskRewardInfo.finish_desc 
    end
    
    self.titleName_txt.text = taskTypeCfg.sec_type_subhead --副标题
    local width = self.titleName_txt.preferredWidth
    UnityUtils.SetSizeDelata(self.titleBG.transform, width + 30, self.titleBG.transform.rect.height)
	
	
    if taskRewardInfo.sec_type == 1 then --第一章显示序章
        self.chapterWord.transform:SetActive(true)
        self.chapterNum.transform:SetActive(false)
    else
        self.chapterWord.transform:SetActive(false)
        self.chapterNum.transform:SetActive(true)
        
        if taskRewardInfo.sec_type <= 10 then
            self.chapterNum_txt.text = '0' .. (taskRewardInfo.sec_type - 1) 
        else
            self.chapterNum_txt.text = taskRewardInfo.sec_type - 1
        end
    end 
end

function TaskChapterWindow:UpdateIcon()
    for _, v in pairs(self.rewardItemObjs) do
        ItemManager.Instance:PushItemToPool(v.item)
        self:PushUITmpObject("Item", v.itemParent)
    end
	
	self.rewardItemObjs = {}
    
    local taskRewardInfo = DataTaskReward[self.selectTab] --任务章节奖励
    if not taskRewardInfo then
        return
    end
    local rewardList = TaskConfig.GetTaskChapterInfo(taskRewardInfo.type, taskRewardInfo.sec_type).task_reward
	for k, v in ipairs(rewardList) do
        local isFinished = mod.TaskCtrl:CheckTaskIsFinish(v[1])
		isFinished = isFinished or false
        --v[1] 是任务id
        if v[1] ~= 0 then
            self.rewardPoint[k].container.dark.transform:SetActive(not isFinished)
            self.rewardPoint[k].container.light.transform:SetActive(isFinished)
        else
            --配置为0就隐藏节点
            self.rewardPoint[k].container.dark.transform:SetActive(false)
            self.rewardPoint[k].container.light.transform:SetActive(false)
        end
        --v[2] 是道具id
		if v[2] ~= 0 then 
			local rewardCfg = DataReward[v[2]]
			for _, itemInfoData in ipairs(rewardCfg.reward_list) do
                --有没有被领取
                local isRecived = TaskConfig.CheckTaskIsReceived(v[1])
				isRecived = isRecived and true or false
                local isShowTips = mod.TaskCtrl:CheckChapterIsRedByTaskId(v[1])
                
                local itemInfo
                if isShowTips then
                    itemInfo = {template_id = itemInfoData[1], count = itemInfoData[2], acquired = isRecived, scale = 1, acquiredScale = 0.93, btnFunc = function ()
                        self:OnClickItem(v[1])
                    end}
                else
                    itemInfo = {template_id = itemInfoData[1], count = itemInfoData[2], acquired = isRecived, scale = 1, acquiredScale = 0.93}
                end
                --创建Item节点
                local itemParent = self:PopUITmpObject("Item", self.RewardGroup.transform)
                UtilsUI.SetActive(itemParent.object, true)
                UnityUtils.SetLocalScale(itemParent.objectTransform, 0.7, 0.7, 0.7)
                
                local item = ItemManager.Instance:GetItem(itemParent.objectTransform, itemInfo)
				table.insert(self.rewardItemObjs, {item = item, itemParent = itemParent})
                
				goto continue 
			end
			::continue::
		end
	end
end

--当前任务的进度
function TaskChapterWindow:UpdateProgress()
    local taskCfg = DataTask.data_task[self.nowDataTaskKey] --当前任务表配置 
    local taskRewardInfo = DataTaskReward[self.selectTab]--章节任务奖励配置
    if not taskRewardInfo then
        return
    end
    if not mod.TaskCtrl:CheckTaskIsFinish(taskRewardInfo.chapter_end) then
        self:NowTaskProgress(taskRewardInfo, isInProgress)
    else
        self:ReViewTaskProgress()
    end
end

--正常进度的章节
function TaskChapterWindow:NowTaskProgress(taskRewardInfo, isInProgress)
    --先隐藏掉 
    self:HideAllProgressUI()
    local num, startTask, endTask = TaskConfig.GetTaskPointProgress(taskRewardInfo)
    local maxCount = DataTask.data_task_Countbyid[self.nowTaskId]
    local value = num/maxCount
    value = string.format("%0.2f", value)
    self.percentValue_txt.text = math.floor(value * 100).."%"
    self:UpdateProgressUI(num, value)
end

--回顾进度的章节
function TaskChapterWindow:ReViewTaskProgress()
    self.percentValue_txt.text = "100%"
    self:ShowAllProgressUI()
end

--刷新进度条ui
function TaskChapterWindow:UpdateProgressUI(num, progressValue)
    for i = 1, num do
		local str = 'progress' .. i
        UtilsUI.SetActive(self.node[str], true)
		self.node[str..'_img'].fillAmount = 1
    end
    local str = 'progress' .. (num + 1)..'_img'
	UtilsUI.SetActive(self.node[str].transform, true)
    self.node[str].fillAmount = progressValue
end

--隐藏所有进度条ui
function TaskChapterWindow:HideAllProgressUI()
    for i = 1, maxProgressNum do
        local str = 'progress' .. i
        UtilsUI.SetActive(self.node[str], false)
    end
end

--显示所有进度条ui
function TaskChapterWindow:ShowAllProgressUI()
    for i = 1, maxProgressNum do
        local str = 'progress' .. i
        UtilsUI.SetActive(self.node[str], true)
		self.node[str..'_img'].fillAmount = 1
    end
end

--刷新特效
function TaskChapterWindow:RefreshEffectIn()
    local taskRewardInfo = DataTaskReward[self.selectTab] --任务章节奖励
    if not taskRewardInfo then
        return
    end
    for k, v in ipairs(taskRewardInfo.task_reward) do
        local isFinished = mod.TaskCtrl:CheckTaskIsFinish(v[1])
        isFinished = isFinished or false
        --有没有被领取
        local isRecived = TaskConfig.CheckTaskIsReceived(v[1])
        isRecived = isRecived and true or false
        
        local layer = WindowManager.Instance:GetCurOrderLayer()
        UtilsUI.SetEffectSortingOrder(self.rewardItemObjs[k].itemParent.itemEffect, layer + 1)
        --是否显示特效
        UtilsUI.SetActive(self.rewardItemObjs[k].itemParent.itemEffect, isFinished and not isRecived)
    end
end

function TaskChapterWindow:RefreshEffectOut()
    --先隐藏所有特效
    if self.rewardItemObjs then
        for _, v in pairs(self.rewardItemObjs) do
            if v.itemParent and v.itemParent.itemEffect then
                UtilsUI.SetActive(v.itemParent.itemEffect, false)
            end
        end
    end
end

function TaskChapterWindow:__AfterExitAnim()
    self:OnClickClose_CallBack()
end

function TaskChapterWindow:OnClickClose_CallBack()
    WindowManager.Instance:CloseWindow(self)
end

function TaskChapterWindow:OnClickArrow(arrow)
    if arrow == enumArrow.left then
        self.selectTab = self.selectTab - 1
    else
        self.selectTab = self.selectTab + 1
    end
    self:UpdateCenter()
    self:RefreshEffectIn()
end

function TaskChapterWindow:OnClickItem(taskId)
    --mod.TaskFacade:SendMsg("task_reward", self.selectTab)
    local orderId, protoId = mod.TaskFacade:SendMsg("task_reward", self.selectTab)
    SystemConfig.WaitProcessing(orderId, protoId)
end

function TaskChapterWindow:ClickItemCallback()
    self:UpdateIcon()
    self:RefreshEffectIn()
end


