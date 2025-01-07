
AssetTaskItem = BaseClass("AssetTaskItem", Module)

function AssetTaskItem:__init()
	self.parent = nil
	self.object = nil
	self.node = {}
	self.awardItemMap = {}
	self.isLoadObject = false
	self.loadDone = false
	self.defaultShow = true
end

function AssetTaskItem:__delete()
	for i, v in ipairs(self.awardItemMap) do
		PoolManager.Instance:Push(PoolType.class, "CommonItem", v.awardItem)
	end
	
end

function AssetTaskItem:InitItem(object, taskInfo, defaultShow)
	self.object = object
	self.node = UtilsUI.GetContainerObject(self.object.transform)

	self.taskInfo = taskInfo
	self:Show()
end

function AssetTaskItem:Show()
	self:SetShowIcon()
	self:SetMainInfo()
	self:UpdateDropItemView()
end

function AssetTaskItem:SetShowIcon()
	SingleIconLoader.Load(self.node.TaskIcon,self.taskInfo.icon)
end

function AssetTaskItem:SetMainInfo()
	local curValue = mod.SystemTaskCtrl:GetTaskProgress(self.taskInfo.id)
    local targetValue = ConditionManager.GetConditionTarget(self.taskInfo.condition)

	if curValue >= targetValue then
		self.node.GetBtn_btn.onClick:RemoveAllListeners()
		self.node.GetBtn_btn.onClick:AddListener(function()
			self:OnClickGet()
		end)
	end

	self.node.Doing:SetActive(curValue < targetValue and curValue ~= -1) -- 进行中
	self.node.GetBtn:SetActive(curValue >= targetValue) -- 可领取
	self.node.Received:SetActive(curValue == -1) --已完成

	if curValue == -1 then
		curValue = targetValue
	else
		curValue = curValue < targetValue and curValue or targetValue
	end

	self.node.TaskDesc_txt.text = string.format("%s (%d/%d)",self.taskInfo.desc, curValue, targetValue) 
end

function AssetTaskItem:UpdateDropItemView()
    local rewardList = ItemConfig.GetReward2(self.taskInfo.reward)
    for i, reward in ipairs(rewardList) do
        self:UpdateRewardInfo(reward,i)
    end

	for i = #rewardList + 1, #self.awardItemMap, 1 do
		if not UtilsBase.IsNull(self.awardItemMap[i].obj) then
			UtilsUI.SetActive(self.awardItemMap[i].obj, false)
		end
	end
end

function AssetTaskItem:UpdateRewardInfo(reward,i)
	local obj
	local awardItem
	if self.awardItemMap[i] == nil or UtilsBase.IsNull(self.awardItemMap[i].obj) then
		obj = GameObject.Instantiate(self.node.CommonItem)
		obj.transform:SetParent(self.node.RewardContent.transform)
		
		awardItem = PoolManager.Instance:Pop(PoolType.class, "CommonItem")
		if not awardItem then
			awardItem = CommonItem.New()
		end 

		self.awardItemMap[i] = {awardItem = awardItem, obj = obj}
	else
		obj = self.awardItemMap[i].obj
		awardItem = self.awardItemMap[i].awardItem
	end

	local itemId = reward[1]
	local num = reward[2]
	local itemInfo = {template_id = itemId, count = num or 0, scale = 1}
	awardItem:InitItem(obj, itemInfo, true)
end

function AssetTaskItem:TaskUpdata()
	self:Show()
end

function AssetTaskItem:OnClickGet()
    mod.SystemTaskCtrl:SystemTaskCommit(self.taskInfo.id)
end

function AssetTaskItem:OnReset()
	self.node.GetBtn_btn.onClick:RemoveAllListeners()
end