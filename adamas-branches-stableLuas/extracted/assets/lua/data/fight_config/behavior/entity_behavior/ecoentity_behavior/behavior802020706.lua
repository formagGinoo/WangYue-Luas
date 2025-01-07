Behavior802020706 = BaseClass("Behavior802020706",EntityBehaviorBase)
--NPC手机
local DataItem = Config.DataItem.data_item

--预加载
function Behavior802020706.GetGenerates()
	-- local generates = {}
	-- return generates
end

function Behavior802020706:Init()
	self.me = self.instanceId
	self.role = nil
	self.npcId = nil
	self.npcName = nil
	self.defaultDialogId = nil
	self.effectSwitch = false
	self.init = false
	self.myguideIndex = nil 
end

function Behavior802020706:LateInit()
	if self.sInstanceId then
		self.npcId = self.sInstanceId
		self.npcName = BehaviorFunctions.GetNpcName(self.npcId)
	end
	self.defaultDialogId = BehaviorFunctions.GetNpcDialogId(self.npcId)
end


function Behavior802020706:Update()
	self.role = BehaviorFunctions.GetCtrlEntity()
	self.defaultDialogId = BehaviorFunctions.GetNpcDialogId(self.npcId)
	
	--隐藏名字显示
	if self.init == false then
		BehaviorFunctions.SetNpcHeadInfoVisible(self.npcId,false)
		self.init = true
	end
	
	if self.defaultDialogId > 0 then
		--根据距离显示实体标记
		if BehaviorFunctions.GetDistanceFromTarget(self.me,self.role) < 8 then
			if not self.myguideIndex then
				self.myguideIndex = BehaviorFunctions.AddEntityGuidePointer(self.me,FightEnum.GuideType.Collect)
			end
		else
			if self.myguideIndex then
				BehaviorFunctions.RemoveEntityGuidePointer(self.myguideIndex)
				self.myguideIndex = nil
			end
		end

		----显示交互提示特效
		--if self.effectSwitch == false then
			----交互提示特效
			--if not BehaviorFunctions.HasBuffKind(self.me,200000003) then
				--BehaviorFunctions.AddBuff(self.me,self.me,200000003)
			--end
		--elseif self.effectSwitch == true then
			----移除交互提示特效
			--if BehaviorFunctions.HasBuffKind(self.me,200000003) then
				--BehaviorFunctions.RemoveBuff(self.me,200000003)
			--end
		--end
	end
end


--进入交互范围，添加交互列表
function Behavior802020706:EnterTrigger(triggerInstanceId,triggerEntityId,roleInstanceId)
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
function Behavior802020706:ExitTrigger(triggerInstanceId,triggerEntityId,roleInstanceId)
	if self.isTrigger and triggerInstanceId == self.me then
		self.isTrigger = nil
		BehaviorFunctions.WorldInteractRemove(self.me,self.interactUniqueId)
	end
end

--点击交互:播放默认对话
function Behavior802020706:WorldInteractClick(uniqueId, instanceId)
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