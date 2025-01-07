Behavior2020114 = BaseClass("Behavior2020114",EntityBehaviorBase)
--资产玩法出口传送点
function Behavior2020114.GetGenerates()
	-- local generates = {}
	-- return generates
end

function Behavior2020114:Init()
	self.me = self.instanceId	
	self.role = nil
	
	self.ecoId = nil	
	self.ecoState = nil
	
	self.myStateEnum = 
	{
		inactive = 1,--未激活状态
		activated = 2,--已激活状态
	}
	self.myState = self.myStateEnum.activated
	
	self.canInteract = false
	
	self.extraParam = nil --额外参数
	
	self.assetId = nil --前往的资产Id
	
end

function Behavior2020114:LateInit()
	
end


function Behavior2020114:Update()
	self.role = BehaviorFunctions.GetCtrlEntity()
	
	--根据距离显示实体标记
	if BehaviorFunctions.GetDistanceFromTarget(self.me,self.role) < 20 then
		if not self.myguideIndex then
			self.myguideIndex = BehaviorFunctions.AddEntityGuidePointer(self.me,201,1.5)
		end
	else
		if self.myguideIndex then
			BehaviorFunctions.RemoveEntityGuidePointer(self.myguideIndex)
			self.myguideIndex = nil
		end
	end
	
	if BehaviorFunctions.GetEntityEcoId(self.me) then
		self.ecoId = BehaviorFunctions.GetEntityEcoId(self.me)
		self.ecoState = BehaviorFunctions.GetEcoEntityState(self.ecoId)
		if not self.extraParam then
			--获取额外参数
			self.extraParam = BehaviorFunctions.GetEcoEntityExtraParam(self.ecoId)
			--获取前往的资产的ID
			self.assetId = tonumber(self.extraParam[1].AssetId)
			--修改交互为前往的资产的名字
			if self.extraParam[1].posText then
				local text = "前往 "..self.extraParam[1].posText
				BehaviorFunctions.ChangeWorldInteractInfo(self.me,nil,text)
			end
		end
		--第1次进资产
		if  BehaviorFunctions.CheckTaskStepIsFinish(1980101,9)
			and not BehaviorFunctions.CheckTaskStepIsFinish(1980101,10)
			and not self.taskMessage1 then
			BehaviorFunctions.SendTaskProgress(1980101,10,1)
			self.taskMessage1 = true
		end
		
		--第2次进资产
		if  BehaviorFunctions.CheckTaskStepIsFinish(1980101,13)
			and not BehaviorFunctions.CheckTaskStepIsFinish(1980101,14)
			and not self.taskMessage1 then
			BehaviorFunctions.SendTaskProgress(1980101,14,1)
			self.taskMessage1 = true
		end
		----获得该生态的状态
		--if self.ecoState == 0 then
			--self.myState = self.myStateEnum.inactive
		--elseif self.ecoState == 1 then
			--self.myState = self.myStateEnum.activated
		--end
	end
	
	--在未激活状态下
	if self.myState == self.myStateEnum.inactive then
		self.canInteract = false
	--在激活状态下
	elseif self.myState == self.myStateEnum.activated then
		self.canInteract = true
	end
end

function Behavior2020114:WorldInteractClick(uniqueId,instanceId)
	if instanceId == self.me then
		--在激活状态下
		if self.myState == self.myStateEnum.activated then
			--五月特殊流程特判
			if  BehaviorFunctions.CheckTaskStepIsFinish(1980101,11) and not BehaviorFunctions.CheckTaskStepIsFinish(1980101,12) and not self.taskMessage then
				BehaviorFunctions.SendTaskProgress(1980101,12,1)
				self.taskMessage = ture
			end

			BehaviorFunctions.ExitAssetScene(self.assetId)
		end
	end
end

function Behavior2020114:EnterTrigger(triggerInstanceId,triggerEntityId,roleInstanceId)
	if triggerInstanceId == self.me and self.extraParam then
		if self.canInteract == false then
			--BehaviorFunctions.SetEntityWorldInteractState(self.me, false)
		else
			if self.extraParam[1].posText then
				local text = "前往 "..self.extraParam[1].posText
				BehaviorFunctions.ChangeWorldInteractInfo(self.me,nil,text)
			end
			--BehaviorFunctions.SetEntityWorldInteractState(self.me, true)
		end
	end
end









