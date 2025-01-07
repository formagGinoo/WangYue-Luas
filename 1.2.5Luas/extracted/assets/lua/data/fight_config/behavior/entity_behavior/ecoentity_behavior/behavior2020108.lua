Behavior2020108 = BaseClass("Behavior2020108",EntityBehaviorBase)
--炼金系统入口
local DataItem = Config.DataItem.data_item

--预加载
function Behavior2020108.GetGenerates()

end

function Behavior2020108:Init()
	self.me = self.instanceId
	self.defaultDialogId = nil
	self.npcId = nil
end

function Behavior2020108:LateInit()
	if self.sInstanceId then
		self.npcId = self.sInstanceId
	end
	self.defaultDialogId = BehaviorFunctions.GetNpcDialogId(self.npcId)
end


function Behavior2020108:Update()
	self.role = BehaviorFunctions.GetCtrlEntity	()

end


--进入交互范围，添加交互列表
function Behavior2020108:EnterTrigger(triggerInstanceId,triggerEntityId,roleInstanceId)
	
	if self.isTrigger then
		return
	end
	self.isTrigger = triggerInstanceId == self.me
	if not self.isTrigger then
		return
	end
		self.interactUniqueId = BehaviorFunctions.WorldNPCInteractActive(self.me,"炼金")
end



--退出交互范围，移除交互列表
function Behavior2020108:ExitTrigger(triggerInstanceId,triggerEntityId,roleInstanceId)
	if self.isTrigger and triggerInstanceId == self.me then
		self.isTrigger = nil
		BehaviorFunctions.WorldInteractRemove(self.interactUniqueId)
	end
end

--点击交互:播放默认对话
function Behavior2020108:WorldInteractClick(uniqueId)
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