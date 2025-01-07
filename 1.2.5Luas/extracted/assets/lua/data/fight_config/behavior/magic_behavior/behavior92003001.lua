Behavior92003001 = BaseClass("Behavior92003001",EntityBehaviorBase)
function Behavior92001015.GetGenerates()


end

function Behavior92003001.GetMagics()

end

function Behavior92003001:Init()
	self.me = self.instanceId		--记录自己
	self.hp = BehaviorFunctions.GetEntityAttrVal(self.me,1001) --获取生命最大值
	
	--博弈临时逻辑
	self.HurtTime = 0
	self.hited = 0
	self.HurtFrame = 0
	self.DamageCount = 0
	self.HurtCount = 1
	self.hitedFrame = 0
	self.hitedCount = 0
end

function Behavior92003001:Update()
	self.skillIndex = BehaviorFunctions.GetEntityValue(self.me,"HasSkill")
	
	BehaviorFunctions.SetEntityValue(self.me,"hited",self.hited)
	self.myFrame = BehaviorFunctions.GetFightFrame()
	
	if self.hited <= 0 then
		self.hited = 0
	end
	
	
	--触发博弈重置计数
	if self.hited >= 10 or self.DamageCount >= self.hp * 0.2 then
		if self.skillIndex ~= nil or self.hited >= 15 then
			BehaviorFunctions.AddBuff(self.me,self.me,92003002,1)
			self.DamageCount = 0
			self.hited = 0		
		end
	end
	
	--每过1秒重置1次伤害计数和开关
	if self.HurtFrame < self.myFrame then 
		self.DamageCount = 0
		self.HurtCount = 0
	end
	
	--5秒内不被击，开始减少被击计数，每秒-3
	if self.hitedFrame < self.myFrame then
		if self.hitedCount < self.myFrame then
			self.hited = self.hited - 3
			self.hitedCount = self.myFrame + 30
		end
	end
	
end


--受击计数
function Behavior92003001:Collide(attackInstanceId,hitInstanceId)
	if hitInstanceId == self.me then
		if BehaviorFunctions.GetBuffCount(hitInstanceId, 92003002) == 0 then
			self.hited = self.hited + 1
		end
		--如果是5秒内第一次被击，冻结计数
		self.hitedFrame = self.myFrame + 150
	end
end

--伤害计数
function Behavior92003001:AfterDamage(attackInstanceId,hitInstanceId,damageType,magicId,damageElementType,damageVal)
	if hitInstanceId == self.me and BehaviorFunctions.GetBuffCount(hitInstanceId, 92003002) == 0 then
		if self.HurtCount == 0 then--如果是1秒内第一次受到伤害
			self.HurtCount = 1 --打开受击判断开关
			self.DamageCount = self.DamageCount + damageVal
			self.HurtFrame = self.myFrame + 30 --开始计时
		else
			self.DamageCount = self.DamageCount + damageVal
		end

	end
end