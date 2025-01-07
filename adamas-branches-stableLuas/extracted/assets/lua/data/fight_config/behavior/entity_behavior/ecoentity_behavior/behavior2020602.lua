Behavior2020602 = BaseClass("Behavior2020602",EntityBehaviorBase)
--大悬钟门
function Behavior2020602.GetGenerates()

end

function Behavior2020602:Init()
	self.me = self.instanceId
	self.ecoMe = self.sInstanceId
	--门状态
	self.stateEnum = {
		Default = 0,     --关着状态
		Actived = 1,    --开着状态
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

function Behavior2020602:LateInit()
	-- 获取电梯状态
	self.state = BehaviorFunctions.GetEcoEntityState(self.ecoMe)
	
	-- 获取对应的动画帧数时间
	self.openDurationTime = BehaviorFunctions.GetEntityAnimationFrame(self.me,"Open")
end

function Behavior2020602:Update()
	self.role = BehaviorFunctions.GetCtrlEntity()
	local ecoState = BehaviorFunctions.GetEcoEntityState(self.ecoMe) --获取门的生态状态
	--self.boxId = BehaviorFunctions.GetEcoEntityByEcoId(2002001040010)
	self.box = BehaviorFunctions.CheckEntityEcoState(nil,4002001040010) --获取箱子还在不在
	
	
	--设置状态：如果门打开过&状态Default，设置成Actived
	if self.state == self.stateEnum.Default and ecoState == 1 then
		BehaviorFunctions.PlayAnimation(self.me,"Default")
		self.state = self.stateEnum.Actived
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
function Behavior2020602:WorldInteractClick(uniqueId, instanceId)
	if instanceId ~= self.me then
		return
	end
	
	if instanceId ==self.me and self.state == self.stateEnum.Default then
		if self.box == true then
			BehaviorFunctions.StartStoryDialog(202070501)
		
		elseif self.box == false then
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