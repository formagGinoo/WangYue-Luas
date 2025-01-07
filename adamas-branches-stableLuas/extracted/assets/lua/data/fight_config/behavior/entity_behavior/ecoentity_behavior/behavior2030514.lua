Behavior2030514 = BaseClass("Behavior2030514",EntityBehaviorBase)
--万人迷跳舞音响
function Behavior2030514.GetGenerates()
	-- local generates = {}
	-- return generates
end

function Behavior2030514:Init()
	self.me = self.instanceId	
	self.battleTarget = nil
	
end

function Behavior2030514:LateInit()
	
end


function Behavior2030514:Update()
	--self.isGuard = BehaviorFunctions.GetEntityValue(self.me,"isGuard")
	
end

--点击上侧按钮
function Behavior2030514:HackingClickUp(instanceId)
	if instanceId == self.me then
		--开始吸引范围内敌人（先作假，吸引固定敌人，可扩展）
		--激活ui显示
		--BehaviorFunctions.ShowTip(20305141)
		--BehaviorFunctions.SetEntityHackEnable(self.me,false)
		--BehaviorFunctions.SetEntityValue(self.me,"audioOpen",true)
	end
end




