Behavior2020115 = BaseClass("Behavior2020115",EntityBehaviorBase)
--胸针

--预加载
function Behavior2020115.GetGenerates()
	-- local generates = {}
	-- return generates
end

function Behavior2020115:Init()
	self.me = self.instanceId
	self.ecoId = self.sInstanceId
	self.groupMember = {}
	self.shentuEcoId = nil
end 

function Behavior2020115:LateInit()
	--找神途
	self.groupMember= BehaviorFunctions.GetEcoEntityGroupMember(nil,nil,self.ecoId)
	for i,v in pairs(self.groupMember) do
		if v ~= self.ecoId then
			self.shentuEcoId = v
		end
	end
	--神途在就隐藏神途
	if self.shentuEcoId then
		BehaviorFunctions.ChangeEcoEntityCreateState(self.shentuEcoId,false)
	end
end

function Behavior2020115:WorldInteractClick(uniqueId, instanceId)
	if instanceId ~= self.me then
		return
	end
	BehaviorFunctions.SetEntityWorldInteractState(self.me,false)
	BehaviorFunctions.SetEntityBineVisible(self.me,"Body",false)
	BehaviorFunctions.SetEntityBineVisible(self.me,"Wall",true)
	local transPos = BehaviorFunctions.GetPositionOffsetBySelf(self.me,15,0)
	BehaviorFunctions.InMapTransport(transPos.x,transPos.y,transPos.z)
	local role = BehaviorFunctions.GetCtrlEntity()
	BehaviorFunctions.DoLookAtTargetImmediately(role,self.me)
	BehaviorFunctions.ShowBlackCurtain(true,0,true)
	BehaviorFunctions.ChangeEcoEntityCreateState(self.shentuEcoId,true)
	BehaviorFunctions.AddDelayCallByTime(1,BehaviorFunctions,BehaviorFunctions.ShowBlackCurtain,false,2)
end

function Behavior2020115:RemoveEntity(instanceId)
	if instanceId == BehaviorFunctions.GetEcoEntityByEcoId(self.shentuEcoId) then
		BehaviorFunctions.InteractEntityHit(self.me)
		BehaviorFunctions.ShowCommonTitle(WorldTitlePanel.TitleType.Victory,"")
		BehaviorFunctions.SetEntityBineVisible(self.me,"Wall",false)
	end
end