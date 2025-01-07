Behavior2020107 = BaseClass("Behavior2020107",EntityBehaviorBase)
--气脉竹
local DataItem = Config.DataItem.data_item

--预加载
function Behavior2020107.GetGenerates()
	-- local generates = {}
	-- return generates
end

function Behavior2020107:Init()
	self.me = self.instanceId
	self.guide = nil
	self.npcId = nil
	self.defaultDialogId = nil
end

function Behavior2020107:LateInit()
	if self.sInstanceId then
		self.npcId = self.sInstanceId
	end
	self.defaultDialogId = BehaviorFunctions.GetNpcDialogId(self.npcId)
end


function Behavior2020107:Update()
	if not self.guide then
		if not BehaviorFunctions.CheckTaskIsFinish(900000005) then
			self.role = BehaviorFunctions.GetCtrlEntity()
			if BehaviorFunctions.GetDistanceFromTarget(self.me,self.role)<10 then
				BehaviorFunctions.ShowGuideImageTips(40003)
				BehaviorFunctions.SendTaskProgress(900000005,1,1)
				self.guide = true
			end
		end
	end
end


--进入交互范围，添加交互列表
function Behavior2020107:EnterTrigger(triggerInstanceId,triggerEntityId,roleInstanceId)
	if self.defaultDialogId	> 0 then
		if self.isTrigger then
			return
		end
		self.isTrigger = triggerInstanceId == self.me
		if not self.isTrigger then
			return
		end
			self.interactUniqueId = BehaviorFunctions.WorldNPCInteractActive(self.me,"气脉竹")
	end

end

--退出交互范围，移除交互列表
function Behavior2020107:ExitTrigger(triggerInstanceId,triggerEntityId,roleInstanceId)
	if self.isTrigger and triggerInstanceId == self.me then
		self.isTrigger = nil
		BehaviorFunctions.WorldInteractRemove(self.interactUniqueId)
	end
end

--点击交互:播放默认对话
function Behavior2020107:WorldInteractClick(uniqueId)
	if self.defaultDialogId	 then
		if self.interactUniqueId and self.interactUniqueId == uniqueId then
			BehaviorFunctions.WorldInteractRemove(self.interactUniqueId)
			if self.npcId then
				BehaviorFunctions.ActiveMapIcon(self.npcId)
			end
			BehaviorFunctions.StartStoryDialog(self.defaultDialogId)
			self.isTrigger = nil
		end
	end
end