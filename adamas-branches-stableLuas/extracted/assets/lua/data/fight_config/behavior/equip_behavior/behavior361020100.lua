Behavior361020100 = BaseClass("Behavior361020100",EntityBehaviorBase)

local BF = BehaviorFunctions
function Behavior361020100.GetGenerates()

end
function Behavior361020100.GetMagics()
	local generates = {361020101}
	return generates
end

function Behavior361020100:Init()
	--变量声明
	self.Me = self.instanceId		--记录自己
	self.Role1 = 0
	self.Role2 = 0
	self.Role3 = 0
end

function Behavior361020100:Update()
	self.Role1 = BF.GetCtrlEntity()
	self.Role2 = BF.GetQTEEntity(1)
	self.Role3 = BF.GetQTEEntity(2)
	if BF.HasEntitySign(1,10000009) and (self.Me == self.Role1 or self.Me == self.Role2) then
		if BF.CheckEntity(self.Role1) and not BF.HasBuffKind(self.Role1,361020101) then
			BF.DoMagic(self.Me,self.Role1,361020101,1)
		elseif BF.CheckEntity(self.Role1) and BF.HasBuffKind(self.Role1,361010101) then
			BF.ResetBuff(self.Role1,361020101)
		end
		if BF.CheckEntity(self.Role2) and not BF.HasBuffKind(self.Role2,361020101) then
			BF.DoMagic(self.Me,self.Role2,361020101,1)
		elseif BF.CheckEntity(self.Role2) and BF.HasBuffKind(self.Role1,361010101) then
			BF.ResetBuffByKind(self.Role2,361020101)
		end
	else
		if BF.CheckEntity(self.Role1) and BF.HasBuffKind(self.Role1,361020101) then
			BF.RemoveBuff(self.Role1,361020101,5)
		end
		if BF.CheckEntity(self.Role2) and BF.HasBuffKind(self.Role2,361020101) then
			BF.RemoveBuff(self.Role2,361020101,5)
		end
	end
end

function Behavior361020100:Die(attackInstanceId,dieInstanceId)
	if dieInstanceId == self.Me then
		if BF.CheckEntity(self.Role1) and BF.HasBuffKind(self.Role1,361020101) then
			BF.RemoveBuff(self.Role1,361020101,5)
		end
		if BF.CheckEntity(self.Role2) and BF.HasBuffKind(self.Role2,361020101) then
			BF.RemoveBuff(self.Role2,361020101,5)
		end
		if BF.CheckEntity(self.Role3) and BF.HasBuffKind(self.Role3,361020101) then
			BF.RemoveBuff(self.Role3,361020101,5)
		end
	end
end