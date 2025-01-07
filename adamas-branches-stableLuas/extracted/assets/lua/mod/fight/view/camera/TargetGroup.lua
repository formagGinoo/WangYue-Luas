TargetGroup = BaseClass("TargetGroup")


function TargetGroup:__init(clientFight)
	self.targets = {}
	self.clientFight = clientFight
	self.targetGroup = GameObject("TargetGroup")
	self.cinemachineTargetGroup = self.targetGroup:AddComponent(CinemachineTargetGroup)
	self.targetGroup.transform:SetParent(self.clientFight.fightRoot.transform)
end

function TargetGroup:AddMember(index,transform,weight)
	self.targets[index] = transform
	self.cinemachineTargetGroup:AddMember(transform,weight,1)
end

function TargetGroup:RemoveMember(index)
	local transform = self.targets[index]
	self.cinemachineTargetGroup:RemoveMember(transform)
	self.targets[index] = nil
end

function TargetGroup:SetMemberWeight(index,weight)
	local transform = self.targets[index]
	local i = self.cinemachineTargetGroup:FindMember(transform)
	local target = self.cinemachineTargetGroup.m_Targets[i]
	target.weight = weight
	self.cinemachineTargetGroup.m_Targets[i] = target
end

function TargetGroup:__delete()

end