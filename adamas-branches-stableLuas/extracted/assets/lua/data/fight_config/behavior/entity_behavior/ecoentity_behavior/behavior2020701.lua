Behavior2020701 = BaseClass("Behavior2020701",EntityBehaviorBase)

--休息用空实体
function Behavior2020701.GetGenerates()
	-- local generates = {}
	-- return generates
end

function Behavior2020701:Init()
	self.me = self.instanceId	
	--休息按钮
	self.breakInteractId = nil
	--休息直至按钮
	self.breakUntillMorningInteractId = nil
	self.breakUntillAfternonInteractId = nil
	self.breakUntillNightInteractId = nil
	--交互总控
	self.interactSwitch = false
	--休息时间交互界面
	self.breakTimeInterface = false
	--休息黑幕间隔时间
	self.blackCurtainTime = 5
	--休息黑幕淡入淡出时间
	self.blackCurtainFadeTime = 3
	--玩家当前队伍信息
	self.playerFormation = nil
end

function Behavior2020701:Update()
	--离开交互范围切休息界面没关闭时
	if self.interactSwitch == false and self.breakTimeInterface == true then
		BehaviorFunctions.WorldInteractRemove(self.me,self.breakUntillMorningInteractId)
		BehaviorFunctions.WorldInteractRemove(self.me,self.breakUntillAfternonInteractId)
		BehaviorFunctions.WorldInteractRemove(self.me,self.breakUntillNightInteractId)
		self.breakTimeInterface = false
	end
end

function Behavior2020701:WorldInteractClick(uniqueId, instanceId)
	if instanceId ~= self.me then
		return
	end
	--点击休息按钮
	if uniqueId == self.breakInteractId then
		BehaviorFunctions.WorldInteractRemove(self.me,self.breakInteractId)
		
		self.breakTimeInterface = true
		self.breakUntillMorningInteractId = BehaviorFunctions.WorldInteractActive(self.me,WorldEnum.InteractType.Talk,nil,"休息至早上",1)
		self.breakUntillAfternonInteractId = BehaviorFunctions.WorldInteractActive(self.me,WorldEnum.InteractType.Talk,nil,"休息至中午",1)
		self.breakUntillNightInteractId = BehaviorFunctions.WorldInteractActive(self.me,WorldEnum.InteractType.Talk,nil,"休息至晚上",1)
		 
	--点击休息时间按钮
	elseif uniqueId == self.breakUntillMorningInteractId 
		or uniqueId == self.breakUntillAfternonInteractId
		or uniqueId == self.breakUntillNightInteractId then
		self:PlayerSleep()
	end
end

function Behavior2020701:EnterTrigger(triggerInstanceId,triggerEntityId,roleInstanceId)
	if triggerInstanceId == self.instanceId and self.interactSwitch == false then
		self.breakInteractId = BehaviorFunctions.WorldInteractActive(self.me,WorldEnum.InteractType.Talk,nil,"休息",1)
		self.interactSwitch = true
	end
end

function Behavior2020701:ExitTrigger(triggerInstanceId,triggerEntityId,roleInstanceId)
	if triggerInstanceId == self.instanceId and self.interactSwitch == true then
		BehaviorFunctions.WorldInteractRemove(self.me,self.breakInteractId)
		self.interactSwitch = false
	end
end

--玩家睡觉表现
function Behavior2020701:PlayerSleep()
	BehaviorFunctions.ShowBlackCurtain(true,self.blackCurtainFadeTime)
	BehaviorFunctions.WorldInteractRemove(self.me,self.breakUntillMorningInteractId)
	BehaviorFunctions.WorldInteractRemove(self.me,self.breakUntillAfternonInteractId)
	BehaviorFunctions.WorldInteractRemove(self.me,self.breakUntillNightInteractId)
	BehaviorFunctions.AddDelayCallByTime(self.blackCurtainTime,BehaviorFunctions,BehaviorFunctions.ShowBlackCurtain,false,self.blackCurtainFadeTime)
	BehaviorFunctions.AddDelayCallByTime(self.blackCurtainTime,self,self.Assignment,"interactSwitch",false)
	BehaviorFunctions.AddDelayCallByTime(self.blackCurtainTime + 0.5,self,self.TeamRevive)
end

--玩家队伍全体复活、回血效果
function Behavior2020701:TeamRevive()
	--血量恢复横幅
	BehaviorFunctions.ShowTip(202070101)
	self.playerFormation = BehaviorFunctions.GetCurFormationEntities()
	for index,instanceId in ipairs(self.playerFormation) do
		--复活magic
		BehaviorFunctions.DoMagic(instanceId,instanceId,200000111)
		--回血magic
		BehaviorFunctions.DoMagic(instanceId,instanceId,200000014)
	end
end

--赋值
function Behavior2020701:Assignment(variable,value)
	self[variable] = value
end




