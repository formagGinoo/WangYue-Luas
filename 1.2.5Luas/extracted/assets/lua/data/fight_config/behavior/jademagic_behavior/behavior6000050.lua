Behavior6000050 = BaseClass("Behavior6000050",EntityBehaviorBase)

local BF = BehaviorFunctions

function Behavior6000050.GetGenerates()

end
function Behavior6000050.GetMagics()

end

function Behavior6000050:Init()
	self.me = self.instanceId		--记录自己
	self.safeTime = 0 --默认减伤次数为2
end

--设置伤害减免次数
function Behavior6000050:Update()
	
	if BF.CheckEntity(self.me) then
		--减伤次数判断
		if BF.CheckPlayerInFight() and self.key == 0 then
			self.safeTime = 2
			self.key = 1
		elseif not BF.CheckPlayerInFight() then
			self.safeTime = 0
			self.key = 0
		end
	end
end

--伤害判断
function Behavior6000050:BeforeDamage(InstanceId,hitInstanceId,damageType,magicId,damageElementType,damageVal,attackType,partType,damageInfo,attackInstanceId,isCirt)
	if hitInstanceId == self.me and self.safeTime > 0 then
		self.safeTime = self.safeTime - 1
		damageInfo.damage = damageInfo.damage*0.9
		BF.AddBuff(self.me,self.me,6000051,1)
	end
end