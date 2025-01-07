Behavior2030401 = BaseClass("Behavior2030401",EntityBehaviorBase) 
--关闭的木门
--资源预加载
function Behavior2030401.GetGenerates()
	local generates = {}
	return generates
end

function Behavior2030401:Init()
	self.me = self.instanceId
	self.role = BehaviorFunctions.GetCtrlEntity()
end

function Behavior2030401:Update()

	self.role = BehaviorFunctions.GetCtrlEntity()
	
	--接收外界传值
	local remove = BehaviorFunctions.GetEntityValue(self.me,"Remove")
	
	if remove == true then
		--发送移除消息
		BehaviorFunctions.InteractEntityHit(self.me,false)
	end
end




