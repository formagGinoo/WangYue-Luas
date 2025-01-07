Behavior200001180 = BaseClass("Behavior200001180",EntityBehaviorBase)
function Behavior200001180.GetGenerates()


end

function Behavior200001180.GetMagics()

end

function Behavior200001180:Init()
	self.active = false --是否激活当前功能
	
	
	self.me = self.instanceId
	self.target = {} --会被吸引的敌人
	self.targetNum = 0
	self.targetList = {} --会被吸引的目标
	self.walkKey = false
	self.radius = 20   --检测范围
end

function Behavior200001180:LateInit()
	BehaviorFunctions.SetEntityValue(self.me,"follow_200001180",false)
end


function Behavior200001180:Update()
	self.role = BehaviorFunctions.GetCtrlEntity()
	self.active = BehaviorFunctions.GetEntityValue(self.me,"active_200001180")
	self.follow = BehaviorFunctions.GetEntityValue(self.me,"follow_200001180")
	
	--激活功能后，判断周围是否有敌人
	if not self.me then	
	elseif self.me and self.active== true then
		
		--判断当前是否有吸引目标
		if next(self.targetList) == nil then
			self.targetList = BehaviorFunctions.SearchNpcList(self.me, self.radius, FightEnum.EntityCamp.Camp2, {FightEnum.EntityNpcTag.Monster,FightEnum.EntityNpcTag.NPC},nil,nil,false) --搜索范围内的目标
			
			--如果周围有敌人,则会判断是否满足条件
			if next(self.targetList) ~= nil then 
				for i = 1, #self.targetList do
					if BehaviorFunctions.GetEntityState(self.targetList[i]) ~= FightEnum.EntityState.Die then --检查当前实体是否存活
						if BehaviorFunctions.GetEntityState(self.targetList[i]) ~= FightEnum.EntityState.Pathfinding  and BehaviorFunctions.GetEntityState(self.targetList[i]) ~= FightEnum.EntityState.Hit and BehaviorFunctions.GetEntityState(self.targetList[i]) ~= FightEnum.EntityState.Stun 
							and BehaviorFunctions.GetEntityState(self.targetList[i]) ~= FightEnum.EntityState.Move  then
							table.insert(self.target,self.targetList[i]) --添加到target表里
						end
						
					end
				end
			end
		end
		
		--关闭激活按钮
		BehaviorFunctions.SetEntityValue(self.me,"active_200001180",false)
		self.targetList = {} --targetlist表置空
		
	end
	
		
	--如果周围有满足条件的敌人，则会判断是否可以继续前进
	if next(self.target) ~= nil then
		
		if self.follow == nil or self.follow == false then
			for i = 1, #self.target do
				local pos = BehaviorFunctions.GetDistanceBetweenObstaclesAndEntity(self.target[i],self.me) --获得目标与自己的距离
				if pos > 1 then --如果目标大于1m，就会靠近
					
					if BehaviorFunctions.GetNpcType(self.target[i]) == FightEnum.EntityNpcTag.NPC then
						--BehaviorFunctions.DoMoveForward(self.target[i],3)
						BehaviorFunctions.DoLookAtTargetImmediately(self.target[i],self.me)
					else
						BehaviorFunctions.SetPathFollowEntity(self.target[i],self.me)
						BehaviorFunctions.DoLookAtTargetImmediately(self.target[i],self.me)
						if BehaviorFunctions.GetEntityState(self.target[i]) ~= FightEnum.EntityState.Move then
							BehaviorFunctions.DoSetEntityState(self.target[i],FightEnum.EntityState.Move)

							--BehaviorFunctions.DoMoveForward(self.target[i],1)
							--BehaviorFunctions.DoSetMoveType(self.guard2,FightEnum.EntityMoveSubState.Walk)
						end


						--if BehaviorFunctions.GetNpcType(self.target[i]) == FightEnum.EntityNpcTag.NPC and self.walkKey == false then
						----BehaviorFunctions.PlayAnimation(self.target[i],"Walk")
						--self.walkKey = true
						--BehaviorFunctions.DoMoveForward(self.target[i],1)
						--end
					end
					

					
				else --小于2m会停止
					BehaviorFunctions.StopMove(self.target[i])
					BehaviorFunctions.ClearPathFinding(self.target[i])
					BehaviorFunctions.DoLookAtTargetImmediately(self.target[i],self.me)
					table.remove(self.target,i)
					
					--if BehaviorFunctions.GetNpcType(self.target[i]) == FightEnum.EntityNpcTag.NPC then
						--BehaviorFunctions.PlayAnimation(self.target[i],"Motou_in")
					--end
					
					break
				end
			end
		end
		
		
		if self.follow == true then
			for i = 1, #self.target do
				BehaviorFunctions.StopMove(self.target[i])
				BehaviorFunctions.ClearPathFinding(self.target[i])
				BehaviorFunctions.DoLookAtTargetImmediately(self.target[i],self.me)
				table.remove(self.target,i)
				break
			end
		end
		
		
	end	
end

