Behavior2030801 = BaseClass("Behavior2030801",EntityBehaviorBase)
--蓄电装置
function Behavior2030801.GetGenerates()
	-- local generates = {}
	-- return generates
end

function Behavior2030801:Init()
	self.me = self.instanceId	
	self.battleTarget = nil
	
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
	self.addElementValue = 50
	--当前累积能量值
	self.currentElementValue = 0	
	--能量百分比
	self.currentEnergyPercent = 0--由于材质溶解的原因，0代表100%，1代表0%，设置特效能量显示的时候记得用1减去百分比
	
	--未受击多少秒开始能量衰减
	self.coldDownTime = 10
	--能量衰减开始时间
	self.coldDownStartTime = 0
	--能量衰减速度(能量百分比/秒)
	self.coldDownSpeed = -0.1
	
	--能量显示特效实例ID
	self.energyEffect1 = nil
	self.energyEffect2 = nil
	
	--充能特效ID
	self.chargingEffect = nil
	
	--初始状态设置为未激活状态
	self.myState = self.myStateEnum.inactive
end

function Behavior2030801:LateInit()
	--创建能量显示特效
	self.energyEffect1 = BehaviorFunctions.CreateEntity(203080101,self.me)
	self.energyEffect2 = BehaviorFunctions.CreateEntity(203080102,self.me)
	--设置能量显示特效为初始值为0
	self:ChangeEnergyPercentage(0)
	--该实体生命值不会降低至1以下
	BehaviorFunctions.DoMagic(self.me,self.me,900000056)
end


function Behavior2030801:Update()
	if BehaviorFunctions.GetEntityEcoId(self.me) then
		self.ecoId = BehaviorFunctions.GetEntityEcoId(self.me)
		self.ecoState = BehaviorFunctions.GetEcoEntityState(self.me)
		--获得该生态的状态
		if self.ecoState == 0 then
			--设置为未激活状态
			self.myState = self.myStateEnum.inactive
			--播放未激活待机动画
			BehaviorFunctions.PlayAnimation(self.me,"InactiveMode_Idle")
		elseif self.ecoState == 1 then
			--设置为激活状态
			self.myState = self.myStateEnum.activated
			--激活循环特效
			BehaviorFunctions.CreateEntity(203080105,self.me)
			--播放激活待机动画
			BehaviorFunctions.PlayAnimation(self.me,"ActiveMode_Idle")
		end
	end
	
	--在未激活状态下
	if self.myState == self.myStateEnum.inactive then
		BehaviorFunctions.SetEntityValue(self.me,"isOpen",false)
		
	--在充能状态下
	elseif self.myState == self.myStateEnum.charging then	
		--超过时间没有受击则进入冷却状态
		if BehaviorFunctions.GetFightFrame() == self.coldDownStartTime then
			self.myState = self.myStateEnum.coldDown
		end
		
	--在冷却状态下
	elseif self.myState == self.myStateEnum.coldDown then
		--每秒进行能量衰减，直至能量为0
		if self.currentEnergyPercent > 0 then
			if BehaviorFunctions.GetFightFrame() >= self.coldDownStartTime then
				self:IncreaseEnergyPercentage(self.coldDownSpeed)
				self.coldDownStartTime = BehaviorFunctions.GetFightFrame() + 30
			end
		
		--能量为0时返回未激活状态
		elseif self.currentEnergyPercent == 0 then
			self.myState = self.myStateEnum.inactive
			BehaviorFunctions.PlayAnimation(self.me,"IntoInactiveMode")
		end
		
	--在激活状态下
	elseif self.myState == self.myStateEnum.activated then
		BehaviorFunctions.SetEntityValue(self.me,"isOpen",true)
	end
end

--修改能量值百分比
function Behavior2030801:ChangeEnergyPercentage(value)
	if value > 1 then
		self.currentEnergyPercent = 1
	elseif value < 0 then
		self.currentEnergyPercent = 0
	end
	--修改能量显示特效显示百分比
	BehaviorFunctions.SetMPAPValue(self.energyEffect1,"_DissolveControl",1-self.currentEnergyPercent)
	BehaviorFunctions.SetMPAPValue(self.energyEffect2,"_DissolveControl",1-self.currentEnergyPercent)
end

--增减能量百分比
function Behavior2030801:IncreaseEnergyPercentage(value)
	--修改总能量百分比
	self.currentEnergyPercent = self.currentEnergyPercent + value
	--修改能量显示特效显示百分比
	self:ChangeEnergyPercentage(self.currentEnergyPercent)
	--更新当前能量值
	self.currentElementValue = self.maxElementValue * self.currentEnergyPercent
end

function Behavior2030801:FirstCollide(attackInstanceId,hitInstanceId,instanceId,attackType,skillType, atkElement)
	if hitInstanceId == self.me then
		--如果处于未激活状态下，受到电属性攻击进入充能状态
		if self.myState == self.myStateEnum.inactive and atkElement == FightEnum.ElementType.Gold then
			self.myState = self.myStateEnum.charging
			--播放充能状态动画
			BehaviorFunctions.PlayAnimation(self.me,"IntoChargingMode")
		--处于冷却状态时，受到电属性攻击进入充能状态
		elseif self.myState == self.myStateEnum.coldDown and atkElement == FightEnum.ElementType.Gold then
			self.myState = self.myStateEnum.charging
		end
	end
end

function Behavior2030801:Damage(InstanceId,hitInstanceId,damageType,magicId,damageElementType,damageVal,attackType,partType,damageInfo,attackInstanceId,isCirt,camp)
	if hitInstanceId == self.me then
		if damageElementType == FightEnum.ElementType.Gold then		
			--如果处于充能状态
			if self.myState == self.myStateEnum.charging then
				if self.currentElementValue < self.maxElementValue then
					self.currentElementValue = self.currentElementValue + self.addElementValue					
					--计算能量百分比
					self.currentEnergyPercent = self.currentElementValue/self.maxElementValue					
					--修改能量显示特效显示百分比
					self:ChangeEnergyPercentage(self.currentEnergyPercent)					
					--更新进入冷却状态的时间
					self.coldDownStartTime = BehaviorFunctions.GetFightFrame() + self.coldDownTime * 30		
					
					--受击充能特效
					self.chargingEffect = BehaviorFunctions.CreateEntity(203080103,self.me)											
					--能量蓄满时进入激活状态
					if self.currentElementValue >= self.maxElementValue then
						BehaviorFunctions.SetEcoEntityState(self.ecoId,1)
						BehaviorFunctions.ShowTip(100000002,"蓄电装置已启动")
						BehaviorFunctions.PlayAnimation(self.me,"IntoActiveMode")
						--激活出生特效
						BehaviorFunctions.CreateEntity(203080104,self.me)
						--激活循环特效
						BehaviorFunctions.AddDelayCallByFrame(25,BehaviorFunctions,BehaviorFunctions.CreateEntity,203080105,self.me)
						self.myState = self.myStateEnum.activated
					end
				end
			end
		end
	end
end






