Behavior800002001 = BaseClass("Behavior800002001",EntityBehaviorBase)
--NPC对话空实体
local DataItem = Config.DataItem.data_item

--预加载
function Behavior800002001.GetGenerates()
	-- local generates = {}
	-- return generates
end

function Behavior800002001:Init()
	self.me = self.instanceId
	self.npcId = nil
	self.npcName = nil
	self.defaultDialogId = nil
	self.init = false
end

function Behavior800002001:LateInit()
	if self.sInstanceId then
		self.npcId = self.sInstanceId
		self.npcName = BehaviorFunctions.GetNpcName(self.npcId)
	end
	self.defaultDialogId = BehaviorFunctions.GetNpcDialogId(self.npcId)
end


function Behavior800002001:Update()
	self.defaultDialogId = BehaviorFunctions.GetNpcDialogId(self.npcId)

	--隐藏名字显示
	if self.init == false then
		BehaviorFunctions.SetNpcHeadInfoVisible(self.npcId,false)
		self.init = true
	end
end


--进入交互范围，添加交互列表
function Behavior800002001:EnterTrigger(triggerInstanceId,triggerEntityId,roleInstanceId)
	if self.defaultDialogId	> 0 then
		if self.isTrigger then
			return
		end
		self.isTrigger = triggerInstanceId == self.me
		if not self.isTrigger then
			return
		end
			self.interactUniqueId = BehaviorFunctions.WorldNPCInteractActive(self.me,self.npcName)
	end

end

--退出交互范围，移除交互列表
function Behavior800002001:ExitTrigger(triggerInstanceId,triggerEntityId,roleInstanceId)
	if self.isTrigger and triggerInstanceId == self.me then
		self.isTrigger = nil
		BehaviorFunctions.WorldInteractRemove(self.me,self.interactUniqueId)
	end
end

--点击交互:播放默认对话
function Behavior800002001:WorldInteractClick(uniqueId, instanceId)
	if instanceId ~= self.me then
		return
	end
	if self.defaultDialogId	 then
		if self.interactUniqueId and self.interactUniqueId == uniqueId then
			BehaviorFunctions.WorldInteractRemove(self.me,self.interactUniqueId)
			if self.npcId then
				BehaviorFunctions.ActiveMapIcon(self.npcId)
			end
			BehaviorFunctions.StartNPCDialog(self.defaultDialogId,self.me)
			self.isTrigger = nil
		end
	end
end