TaskBehavior101030601 = BaseClass("TaskBehavior101030601")
--任务3.2：叙慕在背包中使用草药

function TaskBehavior101030601.GetGenerates()
	local generates = {}
	return generates
end

function TaskBehavior101030601:__init(taskInfo)
	self.taskInfo = taskInfo
	self.role = nil
	self.missionState = 0
	self.currentDialog = nil
	self.dialogStateEnum = {
		Default = 0,
		NotPlaying = 1,
		Playing = 2,
		PlayOver = 3,
	}
	self.dialogList =
	{
		--[1] = {Id = 101030601,state = self.dialogStateEnum.NotPlaying},--叙慕脚好timeline
		
		[1] = {Id = 101031301,state = self.dialogStateEnum.NotPlaying},--版署包叙慕脚好timeline
	}
end

function TaskBehavior101030601:Update()
	self.role = BehaviorFunctions.GetCtrlEntity()
	
	if self.missionState == 0 then
		--隐藏按钮
		self:HideButton()
		BehaviorFunctions.SetFightMainNodeVisible(2,"Map",false) --隐藏地图
		----模拟叙慕摔伤腿的情况
		----给叙慕扣血
		--local currentLifeRatio = BehaviorFunctions.GetEntityAttrValueRatio(self.role,1001)
		--if currentLifeRatio > 5000 then
			--local currentLife = BehaviorFunctions.GetEntityAttrVal(self.role,1001)
			--local remainLife = currentLife * 0.5
			--BehaviorFunctions.SetEntityAttr(self.role,1001,remainLife)
		--end
		--关闭可攀爬状态
		BehaviorFunctions.SetClimbEnable(false)
		--设置受伤行走和受伤待机
		BehaviorFunctions.SetIdleType(self.role,FightEnum.EntityIdleType.InjuredIdle)
		BehaviorFunctions.SetEntityMoveMode(self.role,FightEnum.EntityMoveMode.InjuredWalk)
		self.missionState = 1
	end
	
	if self.missionState == 1 then
		--黑幕隐藏动作变化过程
		BehaviorFunctions.ShowBlackCurtain(true,0)
		--恢复可跑步
		BehaviorFunctions.AddDelayCallByFrame(10,BehaviorFunctions,BehaviorFunctions.SetIdleType,self.role,FightEnum.EntityIdleType.LeisurelyIdle)
		BehaviorFunctions.AddDelayCallByFrame(10,BehaviorFunctions,BehaviorFunctions.SetEntityMoveMode,self.role,FightEnum.EntityMoveMode.Run)
		--恢复可攀爬状态
		BehaviorFunctions.AddDelayCallByFrame(10,BehaviorFunctions,BehaviorFunctions.SetClimbEnable,true)
		--播放恢复后的timeline
		BehaviorFunctions.AddDelayCallByFrame(30,BehaviorFunctions,BehaviorFunctions.StartStoryDialog,self.dialogList[1].Id)
		--恢复被禁用的按键
		BehaviorFunctions.SetFightMainNodeVisible(2,"J",true) --普攻
		BehaviorFunctions.SetFightMainNodeVisible(2,"O",true) --跳跃
		BehaviorFunctions.SetFightMainNodeVisible(2,"K",true) --疾跑
		BehaviorFunctions.StopSetFightMainNodeVisible("J")
		BehaviorFunctions.StopSetFightMainNodeVisible("O")
		BehaviorFunctions.StopSetFightMainNodeVisible("K")
		--去掉黑幕
		BehaviorFunctions.AddDelayCallByFrame(30,BehaviorFunctions,BehaviorFunctions.ShowBlackCurtain,false,0.5)
		self.missionState = 2
	end
	
	
	--任务通过
	if self.missionState == 3 then
		--BehaviorFunctions.SendTaskProgress(101030601,1,1)
	end
end

function TaskBehavior101030601:HideButton()
	BehaviorFunctions.SetFightMainNodeVisible(2,"I",false) --技能
	BehaviorFunctions.SetFightMainNodeVisible(2,"J",false) --普攻
	BehaviorFunctions.SetFightMainNodeVisible(2,"O",false) --跳跃
	BehaviorFunctions.SetFightMainNodeVisible(2,"K",false) --疾跑
	BehaviorFunctions.SetFightMainNodeVisible(2,"L",false) --大招
	BehaviorFunctions.SetFightMainNodeVisible(2,"Core",false) --被动条
	BehaviorFunctions.SetFightMainNodeVisible(2,"PowerGroup",false,1)--隐藏能量条
end

function TaskBehavior101030601:StoryStartEvent(dialogId)
	for i,v in ipairs(self.dialogList) do
		if dialogId == v.Id then
			if self.missionState == 2 and dialogId == self.dialogList[1].Id then
				BehaviorFunctions.SendTaskProgress(101030601,1,1)
				--背包图文
				BehaviorFunctions.AddDelayCallByFrame(30,BehaviorFunctions,BehaviorFunctions.ShowGuideImageTips,20003)
			end
			v.state = self.dialogStateEnum.Playing
			self.currentDialog = v.Id
		end
	end
end

function TaskBehavior101030601:StoryEndEvent(dialogId)
	for i,v in ipairs(self.dialogList) do
		if dialogId == v.Id then
			if self.missionState == 2 and dialogId == self.dialogList[1].Id then
				self.missionState = 3
			end
			v.state = self.dialogStateEnum.PlayOver
			self.currentDialog = nil
		end		
	end
end

function TaskBehavior101030601:OnGuideImageTips(tipsId,isOpen)
	if tipsId == 20003 and isOpen == false then
		BehaviorFunctions.PlayGuide(2010,1,1)
	end
end