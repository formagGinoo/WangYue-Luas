FSMBehavior800001 = BaseClass("FSMBehavior800001",FSMBehaviorBase)
--NPC通用AI-子状态机-默认状态总控

--初始化
function FSMBehavior800001:Init()
	self.me = self.instanceId
end


--初始化结束
function FSMBehavior800001:LateInit()

end

--帧事件
function FSMBehavior800001:Update()
	Log("111")
end
