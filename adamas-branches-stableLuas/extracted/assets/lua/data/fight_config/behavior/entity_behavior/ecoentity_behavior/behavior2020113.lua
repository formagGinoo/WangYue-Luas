Behavior2020113 = BaseClass("Behavior2020113",EntityBehaviorBase)
--资产玩法入口传送点
function Behavior2020113.GetGenerates()
	-- local generates = {}
	-- return generates
end

function Behavior2020113:Init()
	self.me = self.instanceId	
	self.role = nil
	
	self.ecoId = nil	
	self.ecoState = nil
	
	self.myStateEnum = 
	{
		inactive = 1,--未激活状态
		activated = 2,--已激活状态
		special = 3 ,--任务特殊处理
	}
	--[[Eco 0 ,1 ,2 对应 未激活，已激活，特殊状态]]
	self.myState = self.myStateEnum.activated
	
	self.canInteract = false
	
	self.extraParam = nil --额外参数
	
	self.assetId = nil --前往的资产Id
	
	self.taskMessage1 = nil
	self.taskMessage2 = nil
	self.ecoMessage1 = nil
	self.ecoMessage2 = nil
	
end

function Behavior2020113:LateInit()
	
end


function Behavior2020113:Update()
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
		
		
		--五月任务流程，进入限制处理
		--任务未完成，设置成不可激活
		--未完成资产购买
		if not BehaviorFunctions.CheckTaskStepIsFinish(1980101,9) then
			if self.ecoState ~= 2 and not self.ecoMessage1 then
				BehaviorFunctions.SetEcoEntityState(self.ecoId,2)
				self.ecoMessage1 = true
			end
		--已完成资产购买
		elseif BehaviorFunctions.CheckTaskStepIsFinish(1980101, 9) then
			if self.ecoState ~= 1 and not self.ecoMessage2 then
				BehaviorFunctions.SetEcoEntityState(self.ecoId,1)
				self.ecoMessage2 = true
			end
		end
		--获得该生态的状态
		if self.ecoState == 0 then
			self.myState = self.myStateEnum.inactive
		elseif self.ecoState == 1 then
			self.myState = self.myStateEnum.activated
		elseif self.ecoState == 2 then
			self.myState = self.myStateEnum.special
		end
	end
	
	--在未激活状态下
	if self.myState == self.myStateEnum.inactive then
		self.canInteract = false
	--在激活状态下
	elseif self.myState == self.myStateEnum.activated then
		self.canInteract = true
	end
end

function Behavior2020113:WorldInteractClick(uniqueId,instanceId)
	if instanceId == self.me then
		--在激活状态下
		--五月临时需求：资产第一次交互
		if self.myState == self.myStateEnum.activated then
			----第一次进资产
			--if  BehaviorFunctions.CheckTaskStepIsFinish(1980101,9) 
				--and not BehaviorFunctions.CheckTaskStepIsFinish(1980101,10)
				--and not self.taskMessage1 then
				--BehaviorFunctions.SendTaskProgress(1980101,10,1)
				--self.taskMessage1 = true
			--end
			----又回来资产了
			--if  BehaviorFunctions.CheckTaskStepIsFinish(1980101,13) and not self.taskMessage1 
				--and not BehaviorFunctions.CheckTaskStepIsFinish(1980101,14) then
				--BehaviorFunctions.SendTaskProgress(1980101,14,1)
				--self.taskMessage1 = true
			--end
			BehaviorFunctions.EnterAssetScene(self.assetId)
		elseif self.myState == self.myStateEnum.special then
			MsgBoxManager.Instance:ShowTips(TI18N("请先购买资产"), 3)	
			if BehaviorFunctions.CheckTaskStepIsFinish(1980101,8) and
				not BehaviorFunctions.CheckTaskStepIsFinish(1980101,9) and not self.taskMessage2 then
				BehaviorFunctions.SendTaskProgress(1980101,9,1)
				self.taskMessage2 = true
			end	
		end
	end
end

function Behavior2020113:EnterTrigger(triggerInstanceId,triggerEntityId,roleInstanceId)
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









