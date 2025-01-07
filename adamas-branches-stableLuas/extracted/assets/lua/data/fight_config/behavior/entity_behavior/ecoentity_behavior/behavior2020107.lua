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
	self.effect = nil
end

function Behavior2020107:LateInit()
	if self.sInstanceId then
		self.npcId = self.sInstanceId
	end
	self.defaultDialogId = BehaviorFunctions.GetNpcDialogId(self.npcId)
end


function Behavior2020107:Update()
	local myRotateY = BehaviorFunctions.GetEntityWorldAngle(self.me)
	--匹配特效角速度
	local nextRotateY = myRotateY + 6
	if not self.effect then
		local myPos = BehaviorFunctions.GetPositionP(self.me)
		self.effect = BehaviorFunctions.CreateEntityByEntity(self.me,202010701,myPos.x,myPos.y,myPos.z)
		BehaviorFunctions.SetEntityWorldAngle(self.effect,myRotateY)
	end
	BehaviorFunctions.SetEntityWorldAngle(self.me,nextRotateY)	
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
			self.interactUniqueId = BehaviorFunctions.WorldNPCInteractActive(self.me,"气脉汇聚")
	end

end

--退出交互范围，移除交互列表
function Behavior2020107:ExitTrigger(triggerInstanceId,triggerEntityId,roleInstanceId)
	if self.isTrigger and triggerInstanceId == self.me then
		self.isTrigger = nil
		BehaviorFunctions.WorldInteractRemove(self.me,self.interactUniqueId)
	end
end

--点击交互:播放默认对话
function Behavior2020107:WorldInteractClick(uniqueId, instanceId)
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