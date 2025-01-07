Behavior2030802 = BaseClass("Behavior2030802",EntityBehaviorBase)
--喷火装置

function Behavior2030802.GetGenerates()
	-- local generates = {}
	-- return generates
end

function Behavior2030802:Init()
	self.me = self.instanceId	
	self.battleTarget = nil
	
	self.ecoId = nil	
	self.ecoState = nil
	
	self.myStateEnum = 
	{
		on = 1,--喷火状态
		off = 2,--关闭状态
	}
	
	self.myState = self.myStateEnum.on
end

function Behavior2030802:LateInit()
	BehaviorFunctions.DoMagic(self.me,self.me,900000020)
end


function Behavior2030802:Update()
	if BehaviorFunctions.GetEntityEcoId(self.me) then
		self.ecoId = BehaviorFunctions.GetEntityEcoId(self.me)
		self.ecoState = BehaviorFunctions.GetEcoEntityState(self.a)
		--获得该生态的状态
		if self.ecoState == 0 then
			self.myState = self.myStateEnum.on
		elseif self.ecoState == 1 then
			self.myState = self.myStateEnum.off
		end
	end
	
	--在开启状态下
	if self.myState == self.myStateEnum.on then
		if BehaviorFunctions.CanCtrl(self.me) then
			BehaviorFunctions.CastSkillBySelfPosition(self.me,203080201)
			BehaviorFunctions.SetEntityValue(self.me,"isOff",false)
		end
	--在关闭状态下
	elseif self.myState == self.myStateEnum.off then
		BehaviorFunctions.BreakSkill(self.me)
		BehaviorFunctions.SetEntityValue(self.me,"isOff", true)	
		--if not BehaviorFunctions.CanCtrl(self.me) then
			--BehaviorFunctions.BreakSkill(self.me)
			--BehaviorFunctions.SetEntityValue(self.me,"isOff", true)	
		--end
	end
end

function Behavior2030802:Damage(InstanceId,hitInstanceId,damageType,magicId,damageElementType,damageVal,attackType,partType,damageInfo,attackInstanceId,isCirt,camp)
	if hitInstanceId == self.me then
		if damageElementType == FightEnum.ElementType.Water then
			if self.myState == self.myStateEnum.on then
                BehaviorFunctions.SetEcoEntityState(self.ecoId,1)
                BehaviorFunctions.ShowTip(100000002,"喷火装置已关闭")
                self.myState = self.myStateEnum.off
			end
		elseif damageElementType == FightEnum.ElementType.Fire then
			if self.myState == self.myStateEnum.off then
				BehaviorFunctions.SetEcoEntityState(self.ecoId,0)
				BehaviorFunctions.ShowTip(100000002,"喷火装置已点燃")
				self.myState = self.myStateEnum.on
			end
		end				
	end
end






