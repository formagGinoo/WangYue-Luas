Behavior2030907 = BaseClass("Behavior2030907",EntityBehaviorBase)
--通风口障碍
function Behavior2030907.GetGenerates()
	-- local generates = {}
	-- return generates
end

function Behavior2030907:Init()
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

function Behavior2030907:LateInit()
	
end


function Behavior2030907:Update()
	--if BehaviorFunctions.CheckKeyDown(FightEnum.KeyEvent.Interaction) then
		--if self.myState ~= self.myStateEnum.activated then
			--self:ActivateTrap()
		--elseif self.myState == self.myStateEnum.activated then
			--self:DeactivateTrap()
		--end
	--end
end

--点击上侧按钮
function Behavior2030907:HackingClickUp(instanceId)
	if instanceId == self.me then
		-- BehaviorFunctions.ShowTip(2050402)
		BehaviorFunctions.ShowCommonTitle(10,"通风口已激活",true)
		BehaviorFunctions.SetEntityHackEnable(self.me,false)
		BehaviorFunctions.InteractEntityHit(self.me)
	end
end



