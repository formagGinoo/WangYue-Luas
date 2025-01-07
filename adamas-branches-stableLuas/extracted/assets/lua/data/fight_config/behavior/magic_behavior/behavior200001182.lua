Behavior200001182 = BaseClass("Behavior200001182",EntityBehaviorBase)
function Behavior200001182.GetGenerates()


end

function Behavior200001182.GetMagics()

end

function Behavior200001182:Init()
	self.active = false --是否激活当前功能
	
	
	self.me = self.instanceId
	self.target = {} --会被吸引的敌人
	self.targetNum = 0
	self.targetList = {} --会被吸引的目标
	
		--骇入功能-电磁场相关
	self.myStateEnum =
	{
		default = 1, --默认状态
		inactive = 2,--未激活状态
		activated = 3,--已激活状态
		destroy = 4 --销毁状态
	}
	self.myState = self.myStateEnum.default
	--激活触发伤害特效ID
	self.activatedEffect = 20033
	--激活特效实体ID
	self.activatedEffectEntityID = 20032
	
	self.checkRadius = 2.5 --电磁场检测范围
end

function Behavior200001182:Update()
	self.role = BehaviorFunctions.GetCtrlEntity()
	self.active = BehaviorFunctions.GetEntityValue(self.me,"active_200001182")
	self.pos = BehaviorFunctions.GetPositionP(self.me)
	
	--激活功能后，判断周围是否有敌人
	if not self.me then	
	elseif self.me then
		--激活功能后，判断周围是否有敌人
		if not self.me then
		elseif self.me then
			if self.active == true then
				if self.myState ~= self.myStateEnum.activated then
					self:ActivateTrap()
				elseif self.myState == self.myStateEnum.activated then
					self.targetList = BehaviorFunctions.SearchNpcList(self.me, self.checkRadius, FightEnum.EntityCamp.Camp2, {FightEnum.EntityNpcTag.Monster},nil,nil,false) --搜索范围内的目标
					--如果周围有敌人,则会判断是否满足条件
					if next(self.targetList) ~= nil then
						for i = 1, #self.targetList do
							if BehaviorFunctions.GetEntityState(self.targetList[i]) ~= FightEnum.EntityState.Die and
								BehaviorFunctions.GetDistanceBetweenObstaclesAndEntity(self.me,self.targetList[i]) < self.checkRadius then --检查当前实体是否存活
								table.insert(self.target,self.targetList[i]) --添加到target表里
								break
							end
						end
					end

					--如果周围有满足条件的敌人，则会生成电磁场
					if next(self.target) ~= nil and #self.target > 0 then
						--BehaviorFunctions.CreateEntity(20305300201,20305300201,pos.x,pos.y,pos.z)
						BehaviorFunctions.SetEntityValue(self.me,"follow_200001180",true) --摧毁前清除周围敌人的寻路
						BehaviorFunctions.CreateEntity(20033,self.me,self.pos.x,self.pos.y,self.pos.z)
						self:DestroyTrap()
					end
				end
			else
				if self.myState == self.myStateEnum.activated then
					self:DeactivateTrap()
				end
			end
		end
		--if self.active== true then
			--if self.myState == self.myStateEnum.activated then
				--self:ActivateTrap()
				--self.targetList = BehaviorFunctions.SearchNpcList(self.me, 20, FightEnum.EntityCamp.Camp2, {FightEnum.EntityNpcTag.Monster},nil,nil,false) --搜索范围内的目标

				----如果周围有敌人,则会判断是否满足条件
				--if next(self.targetList) ~= nil then
					--for i = 1, #self.targetList do
						--if BehaviorFunctions.GetEntityState(self.targetList[i]) ~= FightEnum.EntityState.Die and
							--BehaviorFunctions.GetDistanceBetweenObstaclesAndEntity(self.me,self.targetList[i]) < self.checkRadius then --检查当前实体是否存活
							--table.insert(self.target,self.targetList[i]) --添加到target表里
							--break
						--end
					--end
				--end

				----如果周围有满足条件的敌人，则会生成电磁场
				--if next(self.target) ~= nil and #self.target > 0 then
					--BehaviorFunctions.CreateEntity(20305300201,20305300201,pos.x,pos.y,pos.z)
					--self:DestroyTrap()
				--end
			--end
		--else
			--if self.myState == self.myStateEnum.activated then
				--self:DeactivateTrap()
			--end
		--end
	end
	
		

end

--开启陷阱
function Behavior200001182:ActivateTrap()
	self.myState = self.myStateEnum.activated
	local myPos = BehaviorFunctions.GetPositionP(self.me)
	self.activatedEffect = BehaviorFunctions.CreateEntity(self.activatedEffectEntityID,self.me,myPos.x,myPos.y,myPos.z)
end

--关闭陷阱
function Behavior200001182:DeactivateTrap()
	self.myState = self.myStateEnum.inactive
	BehaviorFunctions.PlayAnimation(self.activatedEffect,"xianjin_anim_over")
	BehaviorFunctions.AddDelayCallByFrame(30,BehaviorFunctions,BehaviorFunctions.RemoveEntity,self.activatedEffect)
end

--摧毁陷阱
function Behavior200001182:DestroyTrap()
	self.myState = self.myStateEnum.default
	BehaviorFunctions.PlayAnimation(self.activatedEffect,"xianjin_anim_over")
	BehaviorFunctions.AddDelayCallByFrame(30,BehaviorFunctions,BehaviorFunctions.RemoveEntity,self.activatedEffect)
	BehaviorFunctions.SetEntityValue(self.me,"active_200001182",false)
	BehaviorFunctions.SetEntityHackActiveState(self.me, false) --设置按钮为关闭
	self.targetList = {} --targetlist表置空
	self.target = {}
	--BehaviorFunctions.AddDelayCallByFrame(30,BehaviorFunctions,BehaviorFunctions.RemoveEntity,self.me)
end