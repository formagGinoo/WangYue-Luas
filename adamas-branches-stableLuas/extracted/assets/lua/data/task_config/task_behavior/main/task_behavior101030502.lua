TaskBehavior101030502 = BaseClass("TaskBehavior101030502")
--任务3.1：叙慕摔伤需要采集草药

function TaskBehavior101030502.GetGenerates()
	local generates = {}
	return generates
end

function TaskBehavior101030502:__init(taskInfo)
	self.taskInfo = taskInfo
	self.role = nil
	self.missionState = 0
end

function TaskBehavior101030502:Update()
	self.role = BehaviorFunctions.GetCtrlEntity()

	if self.missionState == 0 then
		--隐藏按钮
		self:HideButton()
		BehaviorFunctions.SetFightMainNodeVisible(2,"Map",false) --隐藏地图
		--更新任务追踪
		BehaviorFunctions.SetGuideTask(self.taskInfo.taskId)
		--模拟叙慕摔伤腿的情况
		--给叙慕扣血
		local currentLifeRatio = BehaviorFunctions.GetEntityAttrValueRatio(self.role,1001)
		if currentLifeRatio > 5000 then
			local currentLife = BehaviorFunctions.GetEntityAttrVal(self.role,1001)
			local remainLife = currentLife * 0.5
			BehaviorFunctions.SetEntityAttr(self.role,1001,remainLife)
		end
		--关闭可攀爬状态
		BehaviorFunctions.SetClimbEnable(false)
		--设置受伤行走和受伤待机
		BehaviorFunctions.SetIdleType(self.role,FightEnum.EntityIdleType.InjuredIdle)
		BehaviorFunctions.SetEntityMoveMode(self.role,FightEnum.EntityMoveMode.InjuredWalk)
		self.missionState = 1
	end
	
	if self.missionState == 1 then
		----图片引导使用药品
		--BehaviorFunctions.ShowGuideImageTips(20014)
		--self.missionState = 2
		BehaviorFunctions.SendTaskProgress(101030502,1,1)
		self.missionState = 2
	end
end


--图片引导开启/关闭检测
function TaskBehavior101030502:OnGuideImageTips(tipsId,isOpen)
	--if tipsId == 20014 and isOpen == false then
		--BehaviorFunctions.SendTaskProgress(101030502,1,1)
		--self.missionState = 3
	--end
end


function TaskBehavior101030502:HideButton()
	BehaviorFunctions.SetFightMainNodeVisible(2,"I",false) --技能
	BehaviorFunctions.SetFightMainNodeVisible(2,"J",false) --普攻
	BehaviorFunctions.SetFightMainNodeVisible(2,"O",false) --跳跃
	BehaviorFunctions.SetFightMainNodeVisible(2,"K",false) --疾跑
	BehaviorFunctions.SetFightMainNodeVisible(2,"L",false) --大招
	BehaviorFunctions.SetFightMainNodeVisible(2,"Core",false) --核心被动条
	BehaviorFunctions.SetFightMainNodeVisible(2,"PowerGroup",false,1)--隐藏能量条
end

function TaskBehavior101030502:StoryStartEvent(dialogId)
	for i,v in ipairs(self.dialogList) do
		if dialogId == v.Id then
			v.state = self.dialogStateEnum.Playing
			self.currentDialog = v.Id
		end
	end
end

function TaskBehavior101030502:StoryEndEvent(dialogId)
	for i,v in ipairs(self.dialogList) do
		if dialogId == v.Id then
			if dialogId == self.dialogList[1].Id then
				self.missionState = 2
			end
			v.state = self.dialogStateEnum.PlayOver
			self.currentDialog = nil
		end		
	end
end