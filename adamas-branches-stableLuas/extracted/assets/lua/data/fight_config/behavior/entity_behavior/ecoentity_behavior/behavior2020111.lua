Behavior2020111 = BaseClass("Behavior2020111",EntityBehaviorBase)
--任务副本入口
function Behavior2020111.GetGenerates()

end

function Behavior2020111:Init()
	self.me = self.instanceId
	self.ecoId = self.sInstanceId
	self.eco = 2003001130001
end

function Behavior2020111:LateInit()
	--self.param = BehaviorFunctions.GetEcoEntityExtraParam(self.ecoId)
	--self.name = nil
	--if  self.param and next(self.param) then
		--for k,v in pairs(self.param) do
			--if v["name"]~=nil then
				--self.name = v["name"]
			--end
		--end
	--end
	--if self.name then
		--BehaviorFunctions.ChangeWorldInteractInfo(self.me,nil,self.name)
	--end
end


function Behavior2020111:Update()
	if BehaviorFunctions.CheckTaskStepIsFinish(1980101,7) then
		--获取生态ID
		self.ecoEntity = BehaviorFunctions.GetEcoEntityByEcoId(self.eco)
		--移除空洞
		--BehaviorFunctions.AddDelayCallByTime(0.1,BehaviorFunctions,BehaviorFunctions.InteractEntityHit,self.ecoEntity,false)
		BehaviorFunctions.InteractEntityHit(self.ecoEntity,false)
	end
end


function Behavior2020111:WorldInteractClick(uniqueId, instanceId)
	if instanceId == self.me then
		--BehaviorFunctions.WorldInteractRemove(self.me,uniqueId)
		BehaviorFunctions.PlayAnimation(self.me,"FxQiActive")
		BehaviorFunctions.DoJumpToSystemByTypeAndInstanceId(9, instanceId)--打开任务副本UI
	end
end

--BehaviorFunctions.Transport(10020001,698.08606,93.1100006,1827.80164)