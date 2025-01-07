Behavior2030503 = BaseClass("Behavior2030503",EntityBehaviorBase)
--电压陷阱
function Behavior2030503.GetGenerates()
	-- local generates = {}
	-- return generates
end

function Behavior2030503:Init()
	self.me = self.instanceId	
	self.battleTarget = nil
	
	self.myStateEnum = 
	{
		default = 1, --默认状态
		inactive = 2,--未激活状态
		activated = 3,--已激活状态
		destroy = 4 --销毁状态
	}
	self.myState = self.myStateEnum.default
	--激活特效ID
	self.activatedEffect = nil
	--激活特效实体ID
	self.activatedEffectEntityID = 203050301
end

function Behavior2030503:LateInit()
	BehaviorFunctions.AddBuff(self.me,self.me,200001182)
	BehaviorFunctions.AddBuff(self.me,self.me,200001181)
end


function Behavior2030503:Update()
	--if BehaviorFunctions.CheckKeyDown(FightEnum.KeyEvent.Interaction) then
		--if self.myState ~= self.myStateEnum.activated then
			--self:ActivateTrap()
		--elseif self.myState == self.myStateEnum.activated then
			--self:DeactivateTrap()
		--end
	--end
end

----开启陷阱
--function Behavior2030503:ActivateTrap()
	--self.myState = self.myStateEnum.activated
	--local myPos = BehaviorFunctions.GetPositionP(self.me)
	--self.activatedEffect = BehaviorFunctions.CreateEntity(self.activatedEffectEntityID,self.me,myPos.x,myPos.y,myPos.z)
--end

----关闭陷阱
--function Behavior2030503:DeactivateTrap()
	--self.myState = self.myStateEnum.inactive
	--BehaviorFunctions.PlayAnimation(self.activatedEffect,"xianjin_anim_over")
	--BehaviorFunctions.AddDelayCallByFrame(30,BehaviorFunctions,BehaviorFunctions.RemoveEntity,self.activatedEffect)
--end

----摧毁陷阱
--function Behavior2030503:DestoryTrap()
	--self.myState = self.myStateEnum.destroy
	--BehaviorFunctions.PlayAnimation(self.activatedEffect,"xianjin_anim_over")
	--BehaviorFunctions.AddDelayCallByFrame(30,BehaviorFunctions,BehaviorFunctions.RemoveEntity,self.activatedEffect)
	--BehaviorFunctions.AddDelayCallByFrame(30,BehaviorFunctions,BehaviorFunctions.RemoveEntity,self.me)
--end

--点击上侧按钮
function Behavior2030503:HackingClickUp(instanceId)
	--if instanceId == self.me then
		--if self.myState ~= self.myStateEnum.activated then
			--self:ActivateTrap()
		--elseif self.myState == self.myStateEnum.activated then
			--self:DeactivateTrap()
		--end
	--end
	if instanceId == self.me then
		if BehaviorFunctions.GetEntityValue(self.me,"active_200001182") == true then
			BehaviorFunctions.SetEntityValue(self.me,"active_200001182",false)
			BehaviorFunctions.SetEntityHackActiveState(self.me, false)
		else
			BehaviorFunctions.SetEntityValue(self.me,"active_200001182",true)
			BehaviorFunctions.SetEntityHackActiveState(self.me, true)
		end
	end
end


--点击下侧按钮,爆炸
function Behavior2030503:HackingClickDown(instanceId)
	if instanceId == self.me then
		BehaviorFunctions.SetEntityValue(self.me,"level_200001181",3)
		BehaviorFunctions.SetEntityValue(self.me,"active_200001181",true)
	end
end

function Behavior2030503:EnterTrigger(triggerInstanceId,triggerEntityId,roleInstanceId)
	--if triggerInstanceId == self.me then
		--if self.myState == self.myStateEnum.activated then
			--if BehaviorFunctions.CanCastSkill(self.me) then
				--BehaviorFunctions.CastSkillBySelfPosition(self.me,203050301)
				--self:DestoryTrap()
			--end
		--end
	--end
end

function Behavior2030503:ExtraEnterTrigger(triggerInstanceId,triggerEntityId,InstanceId)
	--if triggerInstanceId == self.me then
		--if self.myState == self.myStateEnum.activated then
			--if BehaviorFunctions.CanCastSkill(self.me) then
				--BehaviorFunctions.CastSkillBySelfPosition(self.me,203050301)
				--self:DestoryTrap()
			--end
		--end
	--end
end






