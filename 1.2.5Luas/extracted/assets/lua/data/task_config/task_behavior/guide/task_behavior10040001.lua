TaskBehavior10040001 = BaseClass("TaskBehavior10040001")
--超算教学

function TaskBehavior10040001:__init(taskInfo)
	self.taskInfo = taskInfo
	self.teachState = 0
	self.startFrame = 0
	self.hideState = 0
	self.safeFrame = 0
end

function TaskBehavior10040001:Update()
	self.role = BehaviorFunctions.GetCtrlEntity()
	self.myFrame = BehaviorFunctions.GetFightFrame()
	self.teachMonster = BehaviorFunctions.GetEcoEntityByEcoId(12001)
	if self.hideState == 0  then
		BehaviorFunctions.SetFightMainNodeVisible(2,"K",false) --闪避
		self.hideState = 1
	end
	if self.teachMonster and self.teachState == 0 then
		BehaviorFunctions.DoMagic(1,self.teachMonster,900000026)
		self.teachState = 1
	end
	if self.teachState == 1 and self.delayFrame and self.myFrame - self.startFrame >= self.delayFrame then
		BehaviorFunctions.ShowGuidTip(101001)
		BehaviorFunctions.SetFightMainNodeVisible(2,"K",true) --闪避
		BehaviorFunctions.DoMagic(1,1,200000008)
		self.delayFrame = nil
		self.safeFrame = self.myFrame
		self.teachState = 2
	end
	if self.teachState == 2  and BehaviorFunctions.CheckKeyDown(FightEnum.KeyEvent.GuideClick)then
		BehaviorFunctions.RemoveBuff(1,200000008)
		BehaviorFunctions.RemoveBuff(self.teachMonster,900000026)
		BehaviorFunctions.ShowWeakGuide(10008)
		BehaviorFunctions.AddDelayCallByTime(5,BehaviorFunctions,BehaviorFunctions.ShowGuideImageTips,10016)
		BehaviorFunctions.SendTaskProgress(self.taskInfo.taskId,1,1)
		self.teachState = 3
	end
	
	--强保底，15s不点继续跑
	if self.teachState == 2 and self.myFrame - self.safeFrame > 900 then
		if BehaviorFunctions.HasBuffKind(1,200000008) then
			BehaviorFunctions.RemoveBuff(1,200000008)
		end
		BehaviorFunctions.SendTaskProgress(self.taskInfo.taskId,1,1)
		self.teachState = 3
	end
end

function TaskBehavior10040001:RemoveTask()
	
end

function TaskBehavior10040001:CastSkill(instanceId,skillId,skillType)
	if self.teachMonster and instanceId == self.teachMonster and self.teachState == 1 then
		if skillId == 90004001 then
			self.delayFrame = 30
			self.startFrame = self.myFrame
		elseif skillId == 90004002 then
			self.delayFrame = 25
			self.startFrame = self.myFrame

		elseif skillId == 90004003 then
			self.delayFrame = 30
			self.startFrame = self.myFrame
		end
	end
end

function TaskBehavior10040001:Death(instanceId)
	if instanceId == self.teachMonster then
		if BehaviorFunctions.HasBuffKind(1,200000008) then
			BehaviorFunctions.RemoveBuff(1,200000008)
		end
		BehaviorFunctions.SetFightMainNodeVisible(2,"K",true) --闪避
		BehaviorFunctions.SendTaskProgress(self.taskInfo.taskId,1,1)
	end
end