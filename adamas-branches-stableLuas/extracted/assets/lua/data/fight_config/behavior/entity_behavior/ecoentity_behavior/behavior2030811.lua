Behavior2030811 = BaseClass("Behavior2030811",EntityBehaviorBase)
--蓄电装置
function Behavior2030811.GetGenerates()
	local generates = {
		2030812,		--火焰灼烧
	}
	return generates
end
function Behavior2030811.GetMagics()
	local generates = {1000116,1000117}
	return generates
end

function Behavior2030811:Init()
	self.me = self.instanceId
	self.battleTarget = nil
	self.BoxFire = 1000117		--火焰灼烧
	self.BoxFireDeath = 1000116		--火焰消散

	self.AnimCheck = false

	self.ecoId = nil	
	self.ecoState = nil

	self.myStateEnum = 
	{
		inactive = 1,--未激活状态
		charging = 2,--充能状态
		coldDown = 3,--冷却状态
		activated = 4,--已激活状态
	}
	--需要储存的能量值
	self.maxElementValue = 1000
	--每次攻击所获得能量值
	self.addElementValue = 300
	--当前累积能量值
	self.currentElementValue = 0
	--能量百分比
	self.currentEnergyPercent = 0--由于材质溶解的原因，0代表100%，1代表0%，设置特效能量显示的时候记得用1减去百分比
	
	--未受击多少秒开始能量衰减
	self.coldDownTime = 1
	--能量衰减开始时间
	self.coldDownStartTime = 0
	--能量衰减速度(能量百分比/秒)
	self.coldDownSpeed = 50
	
	--能量显示特效实例ID
	self.energyEffect1 = nil
	self.energyEffect2 = nil
	
	--充能特效ID
	self.chargingEffect = nil
	
	--初始状态设置为未激活状态
	self.myState = self.myStateEnum.inactive

	self.HitCheck = false
	self.DoMagicCheck = false
	self.FirstCollideCheck = false
end

function Behavior2030811:LateInit()
	BehaviorFunctions.SetEntityValue(self.me,"isOpen",false)
end

function Behavior2030811:Update()
	--自动上涨能量条，自己死亡
	if self.HitCheck == true then
		if self.maxElementValue > self.currentElementValue then
			self.currentElementValue = self.currentElementValue + self.coldDownSpeed
		end
	end

	if self.maxElementValue <= self.currentElementValue then
		if BehaviorFunctions.GetEntityValue(self.me,"isOpen") == false then
			BehaviorFunctions.SetEntityValue(self.me,"isOpen",true)
		end
		if self.DoMagicCheck == false then
			BehaviorFunctions.RemoveBuff(self.me,self.BoxFire)
			BehaviorFunctions.AddBuff(self.me,self.me,self.BoxFireDeath)
			self.DoMagicCheck = true
		end
	end

end

function Behavior2030811:FirstCollide(attackInstanceId,hitInstanceId,instanceId,attackType,skillType, atkElement)
	if hitInstanceId == self.me then

		if atkElement == FightEnum.ElementType.Fire then
			--加火焰特效
			if BehaviorFunctions.GetBuffCount(self.me, self.BoxFire) < 1 then	-- and self.maxElementValue < self.currentElementValue
				self.HitCheck = true
				BehaviorFunctions.AddBuff(self.me,self.me,self.BoxFire)
				self.FirstCollideCheck = true
			end
		end

	end
end

function Behavior2030811:Damage(InstanceId,hitInstanceId,damageType,magicId,damageElementType,damageVal,attackType,partType,damageInfo,attackInstanceId,isCirt,camp)
	if hitInstanceId == self.me then
		if damageElementType == FightEnum.ElementType.Fire then
			if self.FirstCollideCheck == true then
				if self.maxElementValue > self.currentElementValue then
					self.currentElementValue = self.currentElementValue + self.addElementValue
				end
			end
		end
	end
end