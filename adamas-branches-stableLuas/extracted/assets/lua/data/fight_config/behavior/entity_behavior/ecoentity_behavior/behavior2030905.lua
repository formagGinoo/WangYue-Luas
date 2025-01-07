Behavior2030905 = BaseClass("Behavior2030905",EntityBehaviorBase)
--通风口

function Behavior2030905.GetGenerates()
	local generates = {2040901}
	return generates
end

function Behavior2030905:Init()
	self.me = self.instanceId
	self.time = 0
	self.ecoId = nil
	self.groupMember = nil
	self.groupTable  = {}
	self.AtomizeConfig = nil
	self.isSet = false

	self.tipsId = 102670119
	self.openAnim = false
	self.closeAnim = false

	self.missionState = 0
	self.CallF = nil

	--延时调用
	self.delayCallList = {}
	--当前延时数量
	self.currentdelayCallNum = 0
end

function Behavior2030905:LateInit()
	self.ecoId = self.sInstanceId
	if self.ecoId then
		self.groupMember = BehaviorFunctions.GetEcoEntityGroupMember(nil,nil,self.ecoId)
		for i,v in pairs(self.groupMember) do
			table.insert(self.groupTable,v)
		end
		self.AtomizeConfig = {
			{
				ecoId = self.groupTable[1],
			},

			{
				ecoId = self.groupTable[2],
			},
		}
	else
		self.AtomizeConfig = nil
	end
end

function Behavior2030905:Update()

	self.entityId = BehaviorFunctions.GetEntityTemplateId(self.me)
	self.time = BehaviorFunctions.GetFightFrame()
	self.role = BehaviorFunctions.GetCtrlEntity()
	self.distance = BehaviorFunctions.GetDistanceFromTarget(self.me,self.role,false)

	if not self.AtomizeConfig then
		self.AtomizeConfig = BehaviorFunctions.GetEntityValue(self.me,"AtomizeConfig")
		Log(self.AtomizeConfig)

	elseif self.AtomizeConfig then
		if not self.isSet and self.AtomizeConfig then
			local hasEcoId = self.AtomizeConfig[1].ecoId and self.AtomizeConfig[2].ecoId
			local hasInstanceId = self.AtomizeConfig[1].instanceId and self.AtomizeConfig[2].instanceId
			if (hasEcoId and (BehaviorFunctions.GetEcoEntityByEcoId(self.AtomizeConfig[1].ecoId) and BehaviorFunctions.GetEcoEntityByEcoId(self.AtomizeConfig[2].ecoId)))
			   or (hasInstanceId and (BehaviorFunctions.GetEntity(self.AtomizeConfig[1].instanceId) and BehaviorFunctions.GetEntity(self.AtomizeConfig[2].instanceId))) then
				BehaviorFunctions.SetAtomizePointsConfig(self.AtomizeConfig)
				self.isSet = true
			end
		end

		--判断距离添加移除示意特效
		--if BehaviorFunctions.HasEntitySign(self.role,62003) then
		if self.distance < 5 then
			if BehaviorFunctions.GetEntityTemplateId(self.me) == 2040901 or BehaviorFunctions.GetEntityTemplateId(self.me) == 2040902 then
				BehaviorFunctions.DoMagic(self.me,self.me,200000901,1)
			elseif BehaviorFunctions.GetEntityTemplateId(self.me) == 2040903 or BehaviorFunctions.GetEntityTemplateId(self.me) == 2040904 then
				BehaviorFunctions.DoMagic(self.me,self.me,200000904,1)
			end
		else
			BehaviorFunctions.RemoveBuff(self.me,200000901)
			BehaviorFunctions.RemoveBuff(self.me,200000904)
		end
		--else
		--BehaviorFunctions.RemoveBuff(self.me,200000901)
		--BehaviorFunctions.RemoveBuff(self.me,200000904)
		--end

		if self.missionState == 0 then
			if BehaviorFunctions.GetEntityValue(self.me,"canOpenKey") == nil then
				BehaviorFunctions.SetEntityValue(self.me,"canOpenKey",false)
			end
			self.missionState = 1
		end

		if BehaviorFunctions.GetEntityValue(self.me,"canOpenKey") == true then
			if self.openAnim == false then
				BehaviorFunctions.PlayAnimation(self.me,"Open")
				self.openAnim = true
			end
				self.CallF = BehaviorFunctions.AddDelayCallByFrame(47,BehaviorFunctions,BehaviorFunctions.PlayAnimation,self.me,"Opened")
				-- BehaviorFunctions.PlayAnimation(self.me,"Opened")
		else
			-- if self.closeAnim == false then
				BehaviorFunctions.PlayAnimation(self.me,"Closed")
				-- self.closeAnim = true
			-- end
		end

	end
end

function Behavior2030905:WorldInteractClick(uniqueId,instanceId)
	if self.me == instanceId then
		if BehaviorFunctions.GetEntityValue(self.me,"canOpenKey") == false then
			-- self.tips = BehaviorFunctions.AddLevelTips(self.tipsId)
			BehaviorFunctions.ShowCommonTitle(10,"管道没有打开",true)
			BehaviorFunctions.SetEntityWorldInteractState(self.me,false)
			self:AddLevelDelayCallByFrame(150,BehaviorFunctions,BehaviorFunctions.SetEntityWorldInteractState,self.me,true)
		else
			BehaviorFunctions.DoCrossSpace(instanceId)
			BehaviorFunctions.AddEntitySign(self.role,62003010,-1,false)
		end
	end
end

function Behavior2030905:RemoveEntity(instanceId)
	if instanceId == self.me then
		if self.CallF then
			BehaviorFunctions.RemoveDelayCall(self.CallF)
			self.CallF = nil
		end
	end
end

--关卡延时调用帧数（卸载时自动移除剩余的DelayCall）
function Behavior2030905:AddLevelDelayCallByFrame(frame,obj,callback,...)
	local delayId = BehaviorFunctions.AddDelayCallByFrame(frame,obj,callback,...)
	self.currentdelayCallNum = self.currentdelayCallNum + 1
	table.insert(self.delayCallList,self.currentdelayCallNum,delayId)
	return delayId
end
--移除所有关卡延时调用
function Behavior2030905:RemoveAllLevelDelayCall()
	for i,delaycallId in ipairs(self.delayCallList) do
		BehaviorFunctions.RemoveDelayCall(delaycallId)
	end
end