TaskReviewNode = BaseClass("TaskReviewNode", Module)

function TaskReviewNode:__init()
    self.object = nil
	self.node = {}
    self.curNodeData = {}
end

function TaskReviewNode:Destroy()
end

function TaskReviewNode:InitNode(object, data, isShow, isLock)
	-- 获取对应的组件
	self.object = object
    self.node = UtilsUI.GetContainerObject(self.object.transform)
	self.curNodeData = data
	self.progress = mod.TaskReviewCtrl:GetNodeStatistic(data.review_id,data.node_id)
	self.type = data.node_type
	if isLock then
		self:InitLockNode()
	elseif not isShow then
		if data.node_type == 6 then
			self:InitLockEndingNode()
		else
			self:InitUnShowNode()
		end 
	elseif data.node_type == 1 then
		self:InitStartNode()
	elseif data.node_type == 2 then
		self:InitPhotoNode()
	elseif data.node_type == 3 then
		self:InitJumpNode()
	elseif data.node_type == 4 then
		self:InitNormalNode()
	elseif data.node_type == 5 then
		self:InitOptionNode()
	elseif data.node_type == 6 then
		self:InitEndingNode()
	elseif data.node_type == 7 then
		self:InitListNode()
	end
	if isShow and not isLock then
		self:SetProgress()
	end
	self.object:SetActive(true)
end

function TaskReviewNode:SetProgress()
	if self.node.ProgressTxt then
		if self.progress then
			UtilsUI.SetActive(self.node.ProgressTxt,true)
			self.node.ProgressTxt_txt.text = self.progress .. "%"
		else
			UtilsUI.SetActive(self.node.ProgressTxt,false)
		end
	end
end

function TaskReviewNode:InitLockNode()
	--UtilsUI.SetActive(self.UnLockTxt,true)
end

function TaskReviewNode:InitUnShowNode()
	
end

function TaskReviewNode:InitLockEndingNode()

end

--1 UnLockNode_
function TaskReviewNode:InitStartNode()
	UtilsUI.SetActive(self.node.UnLockTxt,false)
end

--2 PhotoEventNode_
function TaskReviewNode:InitPhotoNode()
	UtilsUI.SetActive(self.node.Photo,true)
	UtilsUI.SetActive(self.node.Info,true)
	UtilsUI.SetActive(self.node.EndTips,false)
	
	self.node.PhotoEventDesc_txt.text = self.curNodeData.node_val[1]
	SingleIconLoader.Load(self.node.PhotoImg, self.curNodeData.node_val[2])
	self.node.EventTips_txt.text = self.curNodeData.jump_dec
end

--3 JumpNode_
function TaskReviewNode:InitJumpNode()
	self.node.JumpNodeTitle_txt.text = self.curNodeData.node_val[1]
	self.node.JumpNodeDesc_txt.text = self.curNodeData.node_val[2]
	SingleIconLoader.Load(self.node.JumpNodeImg, self.curNodeData.node_val[3])
end

local unSelectColor = Color(1,1,1)
local selectColor = Color(0,0,0)
--4 NormalEventNode_
function TaskReviewNode:InitNormalNode()
	if mod.TaskCtrl:CheckTaskStepIsFinish(self.curNodeData.node_route[1],self.curNodeData.node_route[2]) then
		self.node.NormalEventDesc_txt.color = selectColor
		UtilsUI.SetActive(self.node.Select,true)
		UtilsUI.SetActive(self.node.UnSelect,false)
	else
		self.node.NormalEventDesc_txt.color = unSelectColor
		UtilsUI.SetActive(self.node.Select,false)
		UtilsUI.SetActive(self.node.UnSelect,true)
	end
	self.node.NormalEventDesc_txt.text = self.curNodeData.node_val[1]
	self.node.EventTips_txt.text = self.curNodeData.jump_dec
end

--5 NormalEventNode_
function TaskReviewNode:InitOptionNode()
	self.node.NormalEventDesc_txt.text = self.curNodeData.node_val[1]
	self.node.EventTips_txt.text = self.curNodeData.jump_dec
end

--6 PhotoEventNode_
function TaskReviewNode:InitEndingNode()
	UtilsUI.SetActive(self.node.Photo,true)
	UtilsUI.SetActive(self.node.Info,true)
	UtilsUI.SetActive(self.node.EndTips,true)
	
	self.node.PhotoEventDesc_txt.text = self.curNodeData.node_val[1]
	SingleIconLoader.Load(self.node.PhotoImg, self.curNodeData.node_val[2])
	self.node.EventTips_txt.text = self.curNodeData.jump_dec
end

--7 ListNode_
local unShowColor = Color(1,1,1)
local showColor = Color(0.22,0.25,0.29)
function TaskReviewNode:InitListNode()
	self.listInfo = TaskReviewConfig.GetTaskGroup(self.curNodeData.node_val[2])
	for i = 1, 5, 1 do
		if self.listInfo[i] then
			local isShow = mod.TaskCtrl:CheckTaskIsFinish(self.listInfo[i].task_show)
			UtilsUI.SetActive(self.node["UnLockBg"..i], isShow)
			UtilsUI.SetActive(self.node["LockBg"..i], not isShow)
			if isShow then
				self.node["OptionDesc"..i.."_txt"].text = self.listInfo[i].dec
				self.node["OptionDesc"..i.."_txt"].color = showColor
			else
				self.node["OptionDesc"..i.."_txt"].text = TI18N("事件未解锁")
				self.node["OptionDesc"..i.."_txt"].color = unShowColor
			end
			
		else
			UtilsUI.SetActive(self.node["Option"..i],false)
		end
	end
end

function TaskReviewNode:OnReset()
	
end