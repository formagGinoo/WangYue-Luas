Behavior2030407 = BaseClass("Behavior2030407",EntityBehaviorBase)
--跑酷玩法交互的金币道具
function Behavior2030407.GetGenerates()
	local generates = {}
	return generates
end

function Behavior2030407:Init()
	self.me = self.instanceId
	self.ecoMe = self.sInstanceId
	self.role = nil	
	self.Active = false
	self.pos = 0
	self.effect = 0
end
 


function Behavior2030407:Update()
	self.role = BehaviorFunctions.GetCtrlEntity()	
end

--进入交互范围，添加交互列表
function Behavior2030407:EnterTrigger(triggerInstanceId,triggerEntityId,roleInstanceId)
	if triggerInstanceId == self.me and roleInstanceId == self.role then

		--创建消失特效
		self.pos = BehaviorFunctions.GetPositionP(self.me)
		self.effect = BehaviorFunctions.CreateEntity(203040701,nil,self.pos.x,self.pos.y,self.pos.z)
		--播放消失音效
		BehaviorFunctions.DoEntityAudioPlay(self.me,"OpenWorld_Gold",false)
		--移除金币实体
		BehaviorFunctions.RemoveEntity(self.me)
	end
end

