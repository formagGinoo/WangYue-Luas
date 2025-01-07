Behavior8012005 = BaseClass("Behavior8012005",EntityBehaviorBase)
local BF = BehaviorFunctions
local FES = FightEnum.EntityState
local FK = FightEnum.KeyEvent
local FE = FightEnum
local FEAS = FightEnum.EntityAimState
local FEET = FightEnum.ElementType
local FEAET = FightEnum.AnimEventType

--资源预加载
function Behavior8012005.GetGenerates()
	local generates = {}
	return generates
end



function Behavior8012005:Init()
	
	self.Me = self.instanceId		--记录自己
	self.player = BehaviorFunctions.GetCtrlEntity()
	self.state = 0 
	self.Distance = 0

end


function Behavior8012005:LateInit()
	
end


function Behavior8012005:Update()
	self.player = BehaviorFunctions.GetCtrlEntity() --获取玩家
	self:FollowPlayer()--跟随逻辑

	
	
end

--宠物跟随逻辑
function Behavior8012005:FollowPlayer()
	
	--控制交互列表显隐逻辑
	--if BF.HasBuffKind(self.player,40027001) and self.state == 0 then
		--BehaviorFunctions.SetEntityWorldInteractState(self.Me, true)--开启自身交互窗口
	--else
		--BehaviorFunctions.SetEntityWorldInteractState(self.Me, false)--关闭自身交互窗口
	--end
	
	
	--跟随角色逻辑
	if self.state == 1 then
		self.Distance = BehaviorFunctions.GetDistanceFromTarget(self.Me,self.player)--获取和玩家距离
		
		BehaviorFunctions.SetPathFollowEntity(self.Me,self.player)
		if BehaviorFunctions.GetSubMoveState(self.Me) ~= FightEnum.EntityMoveSubState.Run then
			BehaviorFunctions.DoSetMoveType(self.Me,FightEnum.EntityMoveSubState.Run)
		end
		--BehaviorFunctions.DoLookAtTargetImmediately(self.Me,self.player,"Root") --持续朝向玩家
		
		
		----类似小怪的游荡逻辑
		--if self.Distance > 4 then
			--BehaviorFunctions.DoMoveForward(self.Me,0.2)
		--elseif self.Distance > 1.5 and self.Distance <= 4 then
			--BehaviorFunctions.DoMoveForward(self.Me,0.04)
		--elseif self.Distance <= 1.5 then

		--end
		
		----宠爱一生增益BUFF消失后，回到0阶段
		--if BF.HasBuffKind(self.player,40027001) then
			--if BF.GetBuffCount(self.player,40027003) == 0 then
				--self.state = 0
			--end
		--elseif BF.HasBuffKind(self.player,40027002) then
			--if BF.GetBuffCount(self.player,40027004) == 0 then
				--self.state = 0
			--end	
		--end
	end
end


--检测世界交互
function Behavior8012005:WorldInteractClick(uniqueId,instanceId)
	if instanceId == self.Me then
		--BehaviorFunctions.DoLookAtTargetByLerp(self.Me,self.player,false,180,180,-1)
		
		
		--创建爱心特效
		local A = BF.CreateEntityByEntity(self.Me,801200501)
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
		
	end
end