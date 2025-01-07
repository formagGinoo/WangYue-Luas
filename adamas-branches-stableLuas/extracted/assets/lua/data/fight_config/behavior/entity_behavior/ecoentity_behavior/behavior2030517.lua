Behavior2030517 = BaseClass("Behavior2030517",EntityBehaviorBase)
--序章用电梯
function Behavior2030517.GetGenerates()
	-- local generates = {}
	-- return generates
end

function Behavior2030517:Init()
	self.me = self.instanceId	
	self.role = nil
	
	self.ecoId = nil	
	self.ecoState = nil
	
	self.myStateEnum = 
	{
		inactive = 1,--未激活状态
		activated = 2,--已激活状态
	}
	self.myState = self.myStateEnum.inactive
	
	self.canInteract = false
	
	self.extraParam = nil
	
	self.tpPos = nil
end

function Behavior2030517:LateInit()
	
end


function Behavior2030517:Update()
	self.role = BehaviorFunctions.GetCtrlEntity()
	if BehaviorFunctions.GetEntityEcoId(self.me) then
		self.ecoId = BehaviorFunctions.GetEntityEcoId(self.me)
		self.ecoState = BehaviorFunctions.GetEcoEntityState(self.ecoId)
		if not self.extraParam then
			--获取额外参数
			self.extraParam = BehaviorFunctions.GetEcoEntityExtraParam(self.ecoId)
			self.tpPos = {mapId = self.extraParam[1].mapId , logic = self.extraParam[1].logic ,pos = self.extraParam[1].pos }
			if self.extraParam[1].posText then
				local text = "前往 "..self.extraParam[1].posText
				BehaviorFunctions.ChangeWorldInteractInfo(self.me,nil,text)
			end
		end
		
		--获得该生态的状态
		if self.ecoState == 0 then
			self.myState = self.myStateEnum.inactive
		elseif self.ecoState == 1 then
			self.myState = self.myStateEnum.activated
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

function Behavior2030517:WorldInteractClick(uniqueId,instanceId)
	if instanceId == self.me then
		--在激活状态下
		if self.myState == self.myStateEnum.activated then
			--传送玩家
			local pos = BehaviorFunctions.GetTerrainPositionP(self.tpPos.pos,10020005,self.tpPos.logic)
			local rotate = BehaviorFunctions.GetTerrainRotationP(self.tpPos.pos,10020005,self.tpPos.logic)
			BehaviorFunctions.AddDelayCallByFrame(5,BehaviorFunctions,BehaviorFunctions.InMapTransport,pos.x,pos.y,pos.z)
			BehaviorFunctions.AddDelayCallByFrame(5,BehaviorFunctions,BehaviorFunctions.SetEntityEuler,self.role,rotate.x,rotate.y,rotate.z)
			BehaviorFunctions.AddDelayCallByFrame(10,BehaviorFunctions,BehaviorFunctions.CameraPosReduction,0)

			--传送黑幕
			BehaviorFunctions.ShowBlackCurtain(true,0)
			BehaviorFunctions.AddDelayCallByFrame(20,BehaviorFunctions,BehaviorFunctions.ShowBlackCurtain,false,0.8)
			
			----抵达了位置横幅
			--BehaviorFunctions.ChangeTitleTipsDesc(203051702,self.extraParam[1].posText)
			--BehaviorFunctions.AddDelayCallByFrame(20,BehaviorFunctions,BehaviorFunctions.ShowTip,203051702)
		else
			--按下了电梯按钮，但是没有任何回应
			BehaviorFunctions.ShowTip(203051701)
		end
	end
end

function Behavior2030517:EnterTrigger(triggerInstanceId,triggerEntityId,roleInstanceId)
	if triggerInstanceId == self.me then
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









