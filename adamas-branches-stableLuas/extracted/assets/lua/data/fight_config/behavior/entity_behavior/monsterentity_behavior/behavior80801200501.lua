Behavior80801200501 = BaseClass("Behavior80801200501",EntityBehaviorBase)
local BF = BehaviorFunctions
local FES = FightEnum.EntityState
local FK = FightEnum.KeyEvent
local FE = FightEnum
local FEAS = FightEnum.EntityAimState
local FEET = FightEnum.ElementType
local FEAET = FightEnum.AnimEventType

--资源预加载
function Behavior80801200501.GetGenerates()
	local generates = {}
	return generates
end



function Behavior80801200501:Init()
	
	self.Me = self.instanceId		--记录自己
	self.player = BehaviorFunctions.GetCtrlEntity()
	self.state = 0 
	self.Distance = 0

end


function Behavior80801200501:LateInit()
	
end


function Behavior80801200501:Update()

end

--检测世界交互
function Behavior80801200501:WorldInteractClick(uniqueId,instanceId)
	if instanceId == self.Me then
		--BehaviorFunctions.DoLookAtTargetByLerp(self.Me,self.player,false,180,180,-1)
		
		
		--创建爱心特效
		local A = BF.CreateEntityByEntity(self.Me,8080120050101)
		BF.BindTransform(A,"Cat3",{x = 0, y = 0.5, z = 0},self.Me)
		
		if self.state == 0 then
			if BF.HasBuffKind(self.player,40027001) then
				local i = BF.GetEntityValue(1,40027001)
					if i < 5 then
						BF.SetEntityValue(1,40027001,i+1)
						self.state = 1
						BF.SetEntityWorldInteractState(self.Me, false)--关闭自身交互窗口
					end
			elseif	BF.HasBuffKind(self.player,40027002) then
				if BF.GetBuffCount(self.player,40027004) <= 5  then
					self.state = 1
					BF.SetEntityWorldInteractState(self.Me, false)--关闭自身交互窗口
				end
			else
				BF.PlayAnimation(self.Me,"Pounch",FightEnum.AnimationLayer.BaseLayer)	
				
			end
		end
		BehaviorFunctions.InteractEntityHit(self.Me)
	end
end