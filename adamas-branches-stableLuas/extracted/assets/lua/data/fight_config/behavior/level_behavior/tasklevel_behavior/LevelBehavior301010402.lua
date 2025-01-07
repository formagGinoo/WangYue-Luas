LevelBehavior301010402 = BaseClass("LevelBehavior301010402",LevelBehaviorBase)


function LevelBehavior301010402.GetGenerates()
	local generates = {200000101,203051135}
	return generates
end


function LevelBehavior301010402:__init(fight)
	----关卡参数----
	self.fight = fight
	self.role = nil
	self.frame = nil

	self.itemState =
	{
		Defult = 1,
		Normal = 2,
		Clicked = 3,
	}

	self.itemList =
	{
		[1]	= {itemId = 200000101, state = self.itemState.Defult, id = nil, posName = "ItemPos1", text = "查看", trigger = false, interactId = nil, guide = nil, itemType = true, logId = nil, canLog = true},
		[2]	= {itemId = 200000101, state = self.itemState.Defult, id = nil, posName = "ItemPos2", text = "查看", trigger = false, interactId = nil, guide = nil, itemType = false, logId = 202102501, canLog = true},
		[3]	= {itemId = 200000101, state = self.itemState.Defult, id = nil, posName = "ItemPos3", text = "查看", trigger = false, interactId = nil, guide = nil, itemType = false, logId = 202102601, canLog = true},
	}

	----关卡进度参数----
	self.missionState = 0
end


function LevelBehavior301010402:init()

end


function LevelBehavior301010402:Update()
	self.frame = BehaviorFunctions.GetFightFrame()
	self.role = BehaviorFunctions.GetCtrlEntity()

	if self.missionState == 0 then
		self:SummonItem(self.itemList)
		--self:GuidePointer()
		self.missionState = 1
	end
	
	if self.missionState == 1 then
		
	end

	if self.missionState == 2 then
		BehaviorFunctions.SendTaskProgress(301010403,1,1)
		self.missionState = 999
		BehaviorFunctions.RemoveLevel(self.levelId)
	end
end


function LevelBehavior301010402:SummonItem(List)
	for i,v in ipairs(List) do
		if v.state ~= self.itemState.Clicked then
			local pos = BehaviorFunctions.GetTerrainPositionP(v.posName,self.levelId)
			v.id = BehaviorFunctions.CreateEntity(v.itemId,nil,pos.x,pos.y,pos.z,nil,nil,nil,self.levelId)
			BehaviorFunctions.CreateEntity(203051135,nil,pos.x,pos.y,pos.z,nil,nil,nil,self.levelId)
		end
	end
end


function LevelBehavior301010402:EnterTrigger(triggerInstanceId,triggerEntityId,roleInstanceId)
	for i,v in ipairs(self.itemList) do
		if triggerInstanceId == v.id and v.trigger == false and v.state == self.itemState.Defult then
			v.interactId = BehaviorFunctions.WorldInteractActive(v.id,1,nil,v.text,1)
			v.trigger = true
		end
	end
end


function LevelBehavior301010402:ExitTrigger(triggerInstanceId,triggerEntityId,roleInstanceId)
	for i,v in ipairs(self.itemList) do
		if triggerInstanceId == v.id and v.trigger == true and v.interactId then
			BehaviorFunctions.WorldInteractRemove(v.id,v.interactId)
			v.interactId = nil
			v.trigger = false
		end
	end
end


function LevelBehavior301010402:WorldInteractClick(uniqueId,instanceId)
	for i,v in ipairs(self.itemList) do
		if instanceId == v.id and v.interactId == uniqueId then
			BehaviorFunctions.WorldInteractRemove(v.id,v.interactId)
			v.state = self.itemState.Clicked
			--self:GuidePointer()
			
			if v.logId and v.canLog == true then
				BehaviorFunctions.StartStoryDialog(v.logId)
				v.canLog = false
			end
			
			
			if v.itemType == true then
				for i,v in ipairs(self.itemList) do
					if v.guide then
						v.state = self.itemState.Clicked
						--self:GuidePointer()
					end
				end
				self.missionState = 2
			end
		end
	end
end


function LevelBehavior301010402:GuidePointer()
	for i,v in ipairs(self.itemList) do
		--如果信号塔已经被关闭则不添加标记
		if v.guide == nil and v.state ~= self.itemState.Clicked then
			local pos = BehaviorFunctions.GetPositionP(v.id)
			local target = BehaviorFunctions.CreateEntity(2001,nil,pos.x,pos.y,pos.z,nil,nil,nil,self.levelId)
			BehaviorFunctions.AddEntityGuidePointer(target,FightEnum.GuideType.Rogue_Challenge,0.8,false)
			v.guide = target
		end

		--检测信号塔标记是否可以被移除
		if v.guide and v.state == self.itemState.Clicked then
			BehaviorFunctions.RemoveEntity(v.guide)
		end
	end
end