Behavior2030216 = BaseClass("Behavior2030216",EntityBehaviorBase)
--刷怪淤脉
function Behavior2030216.GetGenerates()
	-- local generates = {}
	-- return generates
end

function Behavior2030216:Init()
	self.me = self.instanceId	
	self.battleTarget = nil
end

function Behavior2030216:LateInit()
	
end


function Behavior2030216:Update()
	self.battleTarget = BehaviorFunctions.GetCtrlEntity()
	----免疫受击
	--if not BehaviorFunctions.HasBuffKind(self.me,900000001) then
		--BehaviorFunctions.AddBuff(self.me,self.me,900000001)
	--end
	--免疫受击朝向
	if not BehaviorFunctions.HasBuffKind(self.me,900000020) then
		BehaviorFunctions.DoMagic(self.me,self.me,900000020)
	end
	--锁血
	if not BehaviorFunctions.HasBuffKind(self.me,900000056) then
		BehaviorFunctions.AddBuff(self.me,self.me,900000056)
	end
end

--function Behavior2030216:PartHit(instanceId,partName,life,damage,attackType,shakeStrenRatio)
	--if instanceId == self.me and partName == "Core" and attackType == 170 then
		--BehaviorFunctions.SetEntityAttr(self.me,1001,0)
	--end
--end

function Behavior2030216:BeforeDamage(InstanceId,hitInstanceId,damageType,magicId,damageElementType,damageVal,attackType,partType,damageInfo,attackInstanceId,isCirt)
	if hitInstanceId == self.me and damageType == 170 then
		if BehaviorFunctions.HasBuffKind(self.me,900000056) then
			BehaviorFunctions.RemoveBuff(self.me,900000056)
			BehaviorFunctions.SetEntityAttr(self.me,1001,0)
		end
	end
end

--function Behavior2030216:Collide(attackInstanceId,hitInstanceId,instanceId,shakeStrenRatio,attackType)
	--if hitInstanceId == self.me and attackType == 170 then
		--BehaviorFunctions.SetEntityAttr(self.me,1001,0)
	--end
--end




