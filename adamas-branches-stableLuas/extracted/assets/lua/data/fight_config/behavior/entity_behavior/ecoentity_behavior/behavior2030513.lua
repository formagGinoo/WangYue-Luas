Behavior2030513 = BaseClass("Behavior2030513",EntityBehaviorBase)
--智能终端小电脑
function Behavior2030513.GetGenerates()
	-- local generates = {}
	-- return generates
end

function Behavior2030513:Init()
	self.me = self.instanceId	
	
end

function Behavior2030513:LateInit()
	
end


function Behavior2030513:Update()
	self.isGuard = BehaviorFunctions.GetEntityValue(self.me,"isGuard")
	self.isLock = BehaviorFunctions.GetEntityValue(self.me,"isLock")
	--只有上锁的电脑显示交互组件
	if self.isLock == nil and not self.lockOver then
		BehaviorFunctions.SetEntityWorldInteractState(self.me, false)
	elseif self.isLock == true then
		BehaviorFunctions.SetEntityWorldInteractState(self.me, true)
	end
end

--点击上侧按钮
function Behavior2030513:HackingClickUp(instanceId)
	if instanceId == self.me then
		----检查有无敌人看管、有无上锁（临时写法，直接检查id）
		--if not self.isGuard  and not self.isLock then

			----激活ui显示
			--BehaviorFunctions.ShowTip(20305131)
			--BehaviorFunctions.SetEntityHackEnable(self.me,false)
			--BehaviorFunctions.SetEntityValue(self.me,"GetFile",true)

		--elseif self.isGuard == true then
			----被看管无法激活ui显示
			--BehaviorFunctions.ShowTip(20305132)

		--elseif self.isLock == true then
			----上锁ui显示
			--BehaviorFunctions.ShowTip(20305133)
		--end
	end
end

function Behavior2030513:WorldInteractClick(uniqueId, instanceId)
	if instanceId == self.me then
		----解锁显示
		--BehaviorFunctions.ShowTip(20305134)
		--BehaviorFunctions.SetEntityWorldInteractState(self.me, false)
		--BehaviorFunctions.AddDelayCallByFrame(5,BehaviorFunctions,BehaviorFunctions.WorldInteractRemove,self.me)
		--self.lockOver = true 
		----self.isLock = false
		--BehaviorFunctions.SetEntityValue(self.me,"isLock", false)
	end 
end


