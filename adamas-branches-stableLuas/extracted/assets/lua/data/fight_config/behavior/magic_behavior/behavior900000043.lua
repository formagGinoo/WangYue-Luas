
Behavior900000043 = BaseClass("Behavior900000043",EntityBehaviorBase)
function Behavior900000043.GetGenerates()


end

function Behavior900000043.GetMagics()

end

function Behavior900000043:Init()
	self.me = self.instanceId		--记录自己
	self.key =true
	
end

function Behavior900000043:Update()
	self.battleTarget = BehaviorFunctions.GetCtrlEntity()
	if BehaviorFunctions.CheckEntity(self.battleTarget) 
		and self.key ==true then
		BehaviorFunctions.AddBuff(self.battleTarget,self.battleTarget,1000036)
		self.key = false
	end
end


function Behavior900000043:FirstCollide(attackInstanceId,hitInstanceId,instanceId,attackType)
	if attackInstanceId ==self.me
		and hitInstanceId ==self.battleTarget
		and BehaviorFunctions.GetBuffCount(self.battleTarget,1000036) ~= 0 then
		BehaviorFunctions.RemoveBuff(self.battleTarget,1000036)
	end
end


--暂不启用--行为树BUFF移除时移除角色头像BUFF，保底
--function Behavior900000043:RemoveBuff(entityInstanceId, buffInstanceId,buffId)
	--if entityInstanceId == self.me and buffId == 900000043 then
		--self.battleTarget = BehaviorFunctions.GetCtrlEntity()
		----local role1 = BehaviorFunctions.GetQTEEntity(1)
		----local role2 = BehaviorFunctions.GetQTEEntity(2)
		----local role3 = BehaviorFunctions.GetQTEEntity(3)
		--if BehaviorFunctions.CheckEntity(self.battleTarget) and BehaviorFunctions.GetBuffCount(self.battleTarget,1000036) ~= 0 then
			--BehaviorFunctions.RemoveBuff(self.battleTarget,1000036)
		--end
		----if BehaviorFunctions.CheckEntity(role2) and BehaviorFunctions.GetBuffCount(self.battleTarget,1000036) ~= 0 then
			----BehaviorFunctions.RemoveBuff(role2,1000036)
		----end
		----if BehaviorFunctions.CheckEntity(role3) and BehaviorFunctions.GetBuffCount(self.battleTarget,1000036) ~= 0 then
			----BehaviorFunctions.RemoveBuff(role3,1000036)
		----end
	--end
--end