Behavior2020301 = BaseClass("Behavior2020301",EntityBehaviorBase)
--气脉入口
function Behavior2020301.GetGenerates()
	--预加载
	local generates = {}
	return generates
end

function Behavior2020301:Init()
	--初始化
	self.me = self.instanceId--记录自己
	self.doActive = false
	self.timeStart = 0
	self.time = 0
	self.actTime = 3
	self.actState =0
end


function Behavior2020301:Update()
	if not self.dropentity then
		self.dropentity = BehaviorFunctions.GetEntityEcoId(self.me)--获取传书生态id
	end
	self.isActive = BehaviorFunctions.CheckEntityEcoState(self.me)--每帧检测实体的状态
	self.time = BehaviorFunctions.GetFightFrame()/30--世界时间
	-----------------成功失败判断
	
	--如果隐藏状态下还触发了交互按钮则移除
	if BehaviorFunctions.HasBuffKind(self.me,200000106) == true and self.interactUniqueId ~= nil then
		BehaviorFunctions.WorldInteractRemove(self.interactUniqueId)
		self.interactUniqueId = nil
	end
end

function Behavior2020301:WorldInteractClick(uniqueId)--点击交互列表
	if self.interactUniqueId and self.interactUniqueId == uniqueId then
		BehaviorFunctions.OpenSceneMsgWindow(1,self.dropentity) --交互事件
		
		--BehaviorFunctions.WorldInteractRemove(self.interactUniqueId)--移除交互按钮
	end
end
function Behavior2020301:EnterTrigger(triggerInstanceId,triggerEntityId,roleInstanceId)--进入交互范围
	if self.isTrigger then--已经触发过了，则跳过
		return
	end
	self.isTrigger = triggerInstanceId == self.me--判断现在触发的是不是自己
	if not self.isTrigger then--现在触发的不是自己，则跳过
		return
	end
	--if not self.opentime or (self.opentime and self.time> self.opentime + 0.5) then--没打开过或者打开过了0.5秒
		--self.interactUniqueId = BehaviorFunctions.WorldInteractActive(WorldEnum.InteractType.Talk,200001,"查看", 1)--物品类型，图标，文字，品质
	--end
	if BehaviorFunctions.HasBuffKind(self.me,200000106) == false then
		self.interactUniqueId = BehaviorFunctions.WorldInteractActive(WorldEnum.InteractType.Talk,200001,"查看", 1)--物品类型，图标，文字，品质
	end
end

function Behavior2020301:ExitTrigger(triggerInstanceId,triggerEntityId,roleInstanceId)--退出交互范围
	if self.isTrigger and triggerInstanceId == self.me then--如果已经进入交互范围
		self.isTrigger = false--则变量变为false
		if BehaviorFunctions.HasBuffKind(self.me,200000106) == false then
			BehaviorFunctions.WorldInteractRemove(self.interactUniqueId)--移除交互按钮
		end
	end
end