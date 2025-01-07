Behavior2020110 = BaseClass("Behavior2020110",EntityBehaviorBase)
--资源副本入口
function Behavior2020110.GetGenerates()

end

function Behavior2020110:Init()
	self.me = self.instanceId
	self.ecoId = self.sInstanceId
end

function Behavior2020110:LateInit()
	self.param = BehaviorFunctions.GetEcoEntityExtraParam(self.ecoId)
	self.name = nil
	if  self.param and next(self.param) then
		for k,v in pairs(self.param) do
			if v["name"]~=nil then
				self.name = v["name"]
			end
		end
	end
	if self.name then
		BehaviorFunctions.ChangeWorldInteractInfo(self.me,nil,self.name)
	end
end


--function Behavior2020110:Update()
	--Log(self.name)
--end


function Behavior2020110:WorldInteractClick(uniqueId, instanceId)
	if instanceId == self.me then
		BehaviorFunctions.WorldInteractRemove(self.me,uniqueId)
		BehaviorFunctions.PlayAnimation(self.me,"FxQiActive")
		BehaviorFunctions.OpenResourceDuplicateUi(self.ecoId)
	end
end

--BehaviorFunctions.Transport(10020001,698.08606,93.1100006,1827.80164)