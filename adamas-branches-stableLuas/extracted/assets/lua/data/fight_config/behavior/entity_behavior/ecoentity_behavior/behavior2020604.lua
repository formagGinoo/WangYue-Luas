Behavior2020604 = BaseClass("Behavior2020604",EntityBehaviorBase)
--大悬钟门
function Behavior2020604.GetGenerates()

end

function Behavior2020604:Init()
	self.me = self.instanceId
	self.ecoMe = self.sInstanceId
	--门状态
	self.stateEnum = {
		Default = 1,    --关着状态
		Actived = 0,    --开着状态
		Open = 2		--开门ing
		}
	
	----锁状态
	--self.keyStateEnum =
	--{
		--Open =0,
		--Locked = 1
	--}
	
	--默认状态
	self.state = self.stateEnum.Actived
	--self.keyState = self.keyStateEnum.Locked

	self.totalFrame = 0
 
end

function Behavior2020604:LateInit()
	-- 获取电梯状态
	self.state = BehaviorFunctions.GetEcoEntityState(self.ecoMe)
	
	-- 获取对应的动画帧数时间
	self.openDurationTime = BehaviorFunctions.GetEntityAnimationFrame(self.me,"Open")
end

function Behavior2020604:Update()
	self.role = BehaviorFunctions.GetCtrlEntity()
	local ecoState = BehaviorFunctions.GetEcoEntityState(self.ecoMe)

	--设置状态：如果门没有打开过&状态actived，设置成default
	if self.state == self.stateEnum.Actived and ecoState == 0 then
		BehaviorFunctions.PlayAnimation(self.me,"Default")
		self.state = self.stateEnum.Default
	end
	
	--如果门开了，移除交互
	if ecoState == 1 then
		BehaviorFunctions.PlayAnimation(self.me,"Actived")
		BehaviorFunctions.SetEntityWorldInteractState(self.me, false)
		--隐藏碰撞骨骼
		BehaviorFunctions.DoMagic(1,self.me,900000028)
	end
end


--交互
function Behavior2020604:WorldInteractClick(uniqueId, instanceId)
	if instanceId ~= self.me then
		return
	end
	
	if instanceId ==self.me then
		if self.state == self.stateEnum.Default then
			BehaviorFunctions.PlayAnimation(self.me,"Open")
			self.state = self.stateEnum.Actived
			self.openTime = BehaviorFunctions.GetEntityFrame(self.me)
			--设置生态状态
			BehaviorFunctions.SetEcoEntityState(self.ecoMe, 1)
			--移除交互
			BehaviorFunctions.SetEntityWorldInteractState(self.me, false)

		end
		--计算动画播完
		if self.upTime then
			self.totalFrame = self.totalFrame + 1
			if self.totalFrame >= 50 then
				--设置状态
				BehaviorFunctions.PlayAnimation(self.me,"Actived")
				self.state = self.stateEnum.Actived
				--隐藏碰撞骨骼
				BehaviorFunctions.DoMagic(1,self.me,900000028)
				--清空数据
				self.totalFrame = 0
				self.openTime = nil
			end
		end

	end
end