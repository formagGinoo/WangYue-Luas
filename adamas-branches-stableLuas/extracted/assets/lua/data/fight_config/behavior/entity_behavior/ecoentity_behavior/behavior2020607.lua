Behavior2020607 = BaseClass("Behavior2020607",EntityBehaviorBase)
--大悬钟门
function Behavior2020607.GetGenerates()

end

function Behavior2020607:Init()
	self.me = self.instanceId
	self.ecoMe = self.sInstanceId
	--门状态
	self.stateEnum = {
		Closed02 = 0,     --关着状态
		Opened02 = 1,    --开着状态
	}

	----锁状态
	--self.keyStateEnum =
	--{
	--Open =0,
	--Locked = 1
	--}
	self.isOpen = false
	self.isActive = false
	self.lock = false
	self.button = nil
	self.role = nil
	--默认状态
	self.state = self.stateEnum.Opened02
	--self.keyState = self.keyStateEnum.Locked

	self.totalFrame = 0

end

function Behavior2020607:LateInit()
	-- 获取门状态
	self.state = BehaviorFunctions.GetEcoEntityState(self.ecoMe)

	-- 获取对应的动画帧数时间
	self.openDurationTime = BehaviorFunctions.GetEntityAnimationFrame(self.me,"Opening02")
end

function Behavior2020607:Update()
	self.role = BehaviorFunctions.GetCtrlEntity()
	local ecoState = BehaviorFunctions.GetEcoEntityState(self.ecoMe) --获取门的生态状态
	--self.box = BehaviorFunctions.CheckEntityEcoState(nil,4002001040010) --获取箱子还在不在
	if self.lock == false then
	BehaviorFunctions.SetEntityWorldInteractState(self.me, false)
		self.lock = true
	end
	
	
	if  BehaviorFunctions.CheckTaskIsFinish(1045401) and self.isActive == false then
		BehaviorFunctions.SetEntityWorldInteractState(self.me, true)
		self.isActive = true
	end

	--设置状态：如果门打开过&状态Closed02，设置成Opened02
	    if self.state == self.stateEnum.Closed02 and ecoState == 1 then
		  BehaviorFunctions.PlayAnimation(self.me,"Closed02")
		  self.state = self.stateEnum.Opened02
	    end

	--如果门开了，移除交互
	    if ecoState == 1 and self.isOpen == false then
		  BehaviorFunctions.PlayAnimation(self.me,"Opened02")
		  BehaviorFunctions.SetEntityWorldInteractState(self.me, false)
		  BehaviorFunctions.SetEntityBineVisible(self.me,"Airwall",false)
		self.isOpen = true
		end
		--隐藏碰撞骨骼
		BehaviorFunctions.DoMagic(1,self.me,900000028)

end


--点击交互
function Behavior2020607:WorldInteractClick(uniqueId,instanceId)

		if instanceId ~= self.me then
			return
		end

		if instanceId ==self.me and self.state == self.stateEnum.Closed02 then
			--if self.box == true then
			--BehaviorFunctions.StartStoryDialog(202070501)

			--elseif self.box == false then
			BehaviorFunctions.PlayAnimation(self.me,"Opening02")
			self.state = self.stateEnum.Opened02
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
				BehaviorFunctions.PlayAnimation(self.me,"Opened02")
				self.state = self.stateEnum.Opened02
				--隐藏碰撞骨骼
				BehaviorFunctions.DoMagic(1,self.me,900000028)
				--清空数据
				self.totalFrame = 0
				self.openTime = nil
			end
		end			

end






