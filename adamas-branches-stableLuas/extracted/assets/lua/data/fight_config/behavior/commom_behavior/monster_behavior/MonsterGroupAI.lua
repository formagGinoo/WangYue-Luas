MonsterGroupAI = BaseClass("MonsterGroupAI",LevelBehaviorBase)

function MonsterGroupAI:Init()
	
	self.typeWeight = 0	--策划在monster表自行配置的初始权重
	self.cameraWeight = 0 	--基于怪物与镜头相对角度的权重
	self.distanceWeight = 0	--基于怪物和角色的距离的权重
	self.monsterAttackWeight = 0 --基于上面三个权重加起来的总和
	
	self.angle = 180			--记录相机朝向和怪物之间的夹角
	self.fov = 60				--默认的fov大小
	self.isInCamera = 0				--记录怪物是否在相机内的布尔值
	self.minAngleInCamera = 10	--相机内最大权重的最小角度
	self.maxAngleInCamera = 25	--相机内最小权重的最大角度
	self.minAngleOffCamera = 25 	--相机外最大权重的最小角度
	self.maxAngleOffCamera = 90	--相机外最小权重的最大角度
	self.maxWeightInCamera = 20	--相机内基于角度的最大权重
	self.minWeightInCamera = 0	--相机内基于角度的最小权重
	self.maxWeightOffCamera = -10	--相机外基于角度的最大权重
	self.minWeightOffCamera = -20	--相机外基于角度的最小权重
	
	self.minDistanceOfMelee = 6	--近战怪物最大权重的最近距离
	self.maxDistanceOfMelee = 10	--近战怪物最小权重的最远距离
	self.minDistanceOfRemote = 8	--远程怪物最大权重的最近距离
	self.maxDistanceOfRemote = 15	--远程怪物最小权重的最远距离
	self.maxWeightOfMelee = 20	--近战怪物基于距离的最大权重
	self.minWeightOfMelee = 0 	--近战怪物基于距离的最小权重
	self.maxWeightOfRemote = 20	--远程怪物基于距离的最大权重
	self.minWeightOfRemote = 0	--远程怪物基于距离的最小权重
	
	self.initialGroupList = {}	--同一个组id的怪物列表
	self.groupWeightList = {}	--带实体id和权重的怪物列表
	self.sortMonsterList = {}	--排序后的组列表
	
	self.maxMeleeNum = 2		--最大可攻击的近战怪物数量
	self.maxRemoteNum = 1		--最大可攻击的远程怪物数量
	self.curMeleeNum = 0		--当前可攻击的近战怪物数量
	self.curRemoteNum = 0		--当前可攻击的远程怪物数量
	
	self.battleTarget = 0		--玩家，即怪物的战斗目标
	self.battleTargetDistance = 0	--怪物和玩家的距离
	self.monsterAttackRange = 0	--怪物的攻击范围类型，近战或远程
	
	self.intensitySkillCd = 10	--分级技能的公共冷却时间
	self.intensitySkillFrame = 0	--记录分级技能公共冷却结束时间
	
	self.commonGroupCd = 5		--群组怪物释放完技能后的公共冷却，即使攻击性易主了也受这个限制
	self.commonMeleeCdFrame = {}	--记录群组近战怪物可释放技能时间的数组，本质是一个先入先出的队列
	self.commonRemoteCdFrame = {}	--记录群组远程怪物可释放技能时间的数组，本质是一个先入先出的队列

	self.everyMeleeCd = 5			--任意一个近战怪物释放了攻击性技能，其他所有近战cd内都无法释放技能
	self.everyMeleeCdFrame =0		--记录上述的可释放时间
	
		
	-- LogError("MonsterGroupAI Inited")
end
	
function MonsterGroupAI:BeforeUpdate()
	--获取同组的怪物列表
	self.initialGroupList = {}
	self.initialGroupList = BehaviorFunctions.GetAllFightTarget()

	if self.initialGroupList and next(self.initialGroupList) then
		self.groupWeightList = {}
		--倒序遍历，提前删除掉已经死掉的实体
		for k = #self.initialGroupList, 1, -1 do
			if not BehaviorFunctions.CheckEntity(self.initialGroupList[k]) then
				table.remove(self.initialGroupList, k)
			end
		end
		--开始遍历所有群组怪物
		for k = 1, #self.initialGroupList do
			if BehaviorFunctions.CheckEntity(self.initialGroupList[k]) then
				--获取怪物本身权重
				if BehaviorFunctions.GetMonsterPriority(self.initialGroupList[k]) ~= nil then
					self.typeWeight = BehaviorFunctions.GetMonsterPriority(self.initialGroupList[k])
				else
					self.typeWeight = 0
				end
					
				--根据怪物是否在相机内，以及与相机之间夹角大小，计算角度权重
				if BehaviorFunctions.GetEntityAngleWithCamera(self.initialGroupList[k]) then
					self.angle = BehaviorFunctions.GetEntityAngleWithCamera(self.initialGroupList[k])
				end
				if self.angle <= self.fov/2 then
					self.isInCamera = 1
				else 
					self.isInCamera = 0
				end
				if self.isInCamera == 1 then
					if self.angle <= self.minAngleInCamera then
						self.cameraWeight = self.maxWeightInCamera
					elseif self.angle >= self.maxAngleInCamera then
						self.cameraWeight = self.minWeightInCamera
					else
						self.cameraWeight = (self.maxAngleInCamera - self.angle) / (self.maxAngleInCamera - self.minAngleInCamera) * (self.maxWeightInCamera - self.minWeightInCamera)
					end
				elseif self.isInCamera == 0 then
					if self.angle <= self.minAngleOffCamera then
						self.cameraWeight = self.maxWeightOffCamera
					elseif self.angle >= self.maxAngleOffCamera then
						self.cameraWeight = self.minWeightOffCamera
					else
						self.cameraWeight = (self.maxAngleOffCamera - self.angle) / (self.maxAngleOffCamera - self.minAngleOffCamera) * (self.maxWeightOffCamera - self.minWeightOffCamera)
					end
				end
				
	
				
				--根据怪物是近战还是远程，以及和玩家的距离，计算距离权重
				self.battleTarget = BehaviorFunctions.GetCtrlEntity()
				self.battleTargetDistance = BehaviorFunctions.GetDistanceFromTarget(self.initialGroupList[k],self.battleTarget)
				
				self.monsterAttackRange = BehaviorFunctions.GetMonsterAttackType(self.initialGroupList[k])
				if self.monsterAttackRange == nil then
					self.monsterAttackRange = 1
				end
				if self.monsterAttackRange == 1 then
					if self.battleTargetDistance <= self.minDistanceOfMelee then
						self.distanceWeight = self.maxWeightOfMelee
					elseif self.battleTargetDistance >= self.maxDistanceOfMelee then
						self.distanceWeight = self.minWeightOfMelee
					else
						self.distanceWeight = (self.maxDistanceOfMelee - self.battleTargetDistance) / (self.maxDistanceOfMelee - self.minDistanceOfMelee) * (self.maxWeightOfMelee - self.minWeightOfMelee)
					end
				elseif self.monsterAttackRange == 2 then
					if self.battleTargetDistance <= self.minDistanceOfRemote then
						self.distanceWeight = self.maxWeightOfRemote
					elseif self.battleTargetDistance >= self.maxDistanceOfRemote then
						self.distanceWeight = self.minWeightOfRemote
					else
						self.distanceWeight = (self.maxDistanceOfRemote - self.battleTargetDistance) / (self.maxDistanceOfRemote - self.minDistanceOfRemote) * (self.maxWeightOfRemote - self.minWeightOfRemote)
					end
				end
				
				--获取怪物最终权重，并赋值
				self.monsterAttackWeight = self.typeWeight + self.cameraWeight + self.distanceWeight
				self.groupWeightList[k] = {id = self.initialGroupList[k], monsterAttackWeight = self.monsterAttackWeight, monsterAttackRange = self.monsterAttackRange}
			end
			
			--给怪物权重排序
			self.sortMonsterList = self:SortMonsterList(self.groupWeightList)
		
			--初始化当前攻击性名额
			self.curMeleeNum = 0
			self.curRemoteNum = 0
			
			--在释放技能的怪物占用攻击性名额
			for i = 1, #self.sortMonsterList do
				if BehaviorFunctions.GetEntityState(self.sortMonsterList[i].id) == 7 
					and self:IsBattleSkill(BehaviorFunctions.GetSkill(self.sortMonsterList[i].id),BehaviorFunctions.GetEntityValue(self.sortMonsterList[i].id,"skillList"),4) 
					then
					--if not BehaviorFunctions.HasEntitySign(self.sortMonsterList[i].id,10000035) then
						--BehaviorFunctions.AddEntitySign(self.sortMonsterList[i].id,10000035,-1,false)
					--end
					if self.sortMonsterList[i].monsterAttackRange == 1 then
						self.curMeleeNum = self.curMeleeNum + 1
					elseif self.sortMonsterList[i].monsterAttackRange == 2 then
						self.curRemoteNum = self.curRemoteNum +1
					end
				end
			end
			--按权重排序，根据近远程给怪物分配攻击性名额
			for i = 1, #self.sortMonsterList do
				if BehaviorFunctions.GetEntityState(self.sortMonsterList[i].id) ~= 7 then
					if self.sortMonsterList[i].monsterAttackRange == 1 then				
						if self.curMeleeNum < self.maxMeleeNum then
							BehaviorFunctions.AddEntitySign(self.sortMonsterList[i].id,10000035,-1,false)
							self.curMeleeNum = self.curMeleeNum + 1
						else
							BehaviorFunctions.RemoveEntitySign(self.sortMonsterList[i].id,10000035)
						end
					elseif self.sortMonsterList[i].monsterAttackRange == 2 then
						if self.curRemoteNum < self.maxRemoteNum then
							BehaviorFunctions.AddEntitySign(self.sortMonsterList[i].id,10000035,-1,false)
							self.curRemoteNum = self.curRemoteNum + 1
						else
							BehaviorFunctions.RemoveEntitySign(self.sortMonsterList[i].id,10000035)
						end
					end
				end
			end
		end
	end
	
	--检测分级公共冷却时间，到了则移除分级公共冷却标记
	if self.intensitySkillFrame < BehaviorFunctions.GetFightFrame() then
		BehaviorFunctions.RemoveEntitySign(1,10000034)
	end
	
	--检查针对所有怪物释放技能的冷却时间，到了则移除对应冷却标记
	if self.everyMeleeCdFrame < BehaviorFunctions.GetFightFrame() then
		BehaviorFunctions.RemoveEntitySign(1,10000038)
	end
	
	--检测群组公共冷却队列
	--先把远近程过期的公共冷却移除掉
	if self.commonMeleeCdFrame then
		for k = #self.commonMeleeCdFrame, 1, -1 do
			if self.commonMeleeCdFrame[k] <= BehaviorFunctions.GetFightFrame() then
				table.remove(self.commonMeleeCdFrame, k)
			end
		end
	end
	if self.commonRemoteCdFrame then
		for k = #self.commonRemoteCdFrame, 1, -1 do
			if self.commonRemoteCdFrame[k] <= BehaviorFunctions.GetFightFrame() then
				table.remove(self.commonRemoteCdFrame, k)
			end
		end
	end
	--检查远近程队列里记录的冷却时间是否等于人数上限，相等则附加对应标记，否则移除标记
	if #self.commonMeleeCdFrame >= self.maxMeleeNum then
		BehaviorFunctions.AddEntitySign(1,10000036,-1,false)
	else
		BehaviorFunctions.RemoveEntitySign(1,10000036)
	end
	if #self.commonRemoteCdFrame >= self.maxRemoteNum then
		BehaviorFunctions.AddEntitySign(1,10000037,-1,false)
	else
		BehaviorFunctions.RemoveEntitySign(1,10000037)
	end
	
end

function MonsterGroupAI:Update()
	-- LogError("monsterGroupAI update")
end


function MonsterGroupAI:AddEntitySign(instanceId,sign)
	--添加强度技能标记时，计算公共冷却
	if instanceId == 1 and sign == 10000034 then
		self.intensitySkillFrame = BehaviorFunctions.GetFightFrame() + self.intensitySkillCd * 30
	end
	
	--添加针对所有怪物释放技能冷却的标记时，计算冷却时间
	if instanceId == 1 and sign == 10000038 then
		self.everyMeleeCdFrame = BehaviorFunctions.GetFightFrame() + self.everyMeleeCd * 30
	end
end



--怪物技能释放完后，根据远近程存入对应群组公共冷却时间
function MonsterGroupAI:FinishSkill(instanceId,skillId,SkillConfigSign,skillType)
	if self:IsGroupMonster(instanceId, self.initialGroupList) then
		--判断技能分级是否大于4，即战斗技能
		if self:IsBattleSkill(skillId,BehaviorFunctions.GetEntityValue(instanceId,"skillList"),4) then
			local Frame = BehaviorFunctions.GetFightFrame() + self.commonGroupCd * 30
			local monsterAttackRange = BehaviorFunctions.GetMonsterAttackType(instanceId)
			if monsterAttackRange == 1 then
				if #self.commonMeleeCdFrame == 0 then
					table.insert(self.commonMeleeCdFrame, Frame)
				else
					table.insert(self.commonMeleeCdFrame, #self.commonMeleeCdFrame + 1, Frame)
				end
			elseif monsterAttackRange ==2 then
				if #self.commonRemoteCdFrame == 0 then
					table.insert(self.commonRemoteCdFrame, Frame)
				else
					table.insert(self.commonRemoteCdFrame, #self.commonRemoteCdFrame + 1, Frame)
				end
			end
		end
	end
end

--保险起见，释放技能被打断的也根据远近程存入对应群组公共冷却时间
function MonsterGroupAI:BreakSkill(instanceId,skillId,SkillConfigSign,skillType)
	if self:IsGroupMonster(instanceId, self.initialGroupList) then
		--判断技能分级是否大于4，即战斗技能
		if self:IsBattleSkill(skillId,BehaviorFunctions.GetEntityValue(instanceId,"skillList"),4) then
			local Frame = BehaviorFunctions.GetFightFrame() + self.commonGroupCd * 30
			local monsterAttackRange = BehaviorFunctions.GetMonsterAttackType(instanceId)
			if monsterAttackRange == 1 then
				if #self.commonMeleeCdFrame == 0 then
					table.insert(self.commonMeleeCdFrame, Frame)
				else
					table.insert(self.commonMeleeCdFrame, #self.commonMeleeCdFrame + 1, Frame)
				end
			elseif monsterAttackRange ==2 then
				if #self.commonRemoteCdFrame == 0 then
					table.insert(self.commonRemoteCdFrame, Frame)
				else
					table.insert(self.commonRemoteCdFrame, #self.commonRemoteCdFrame + 1, Frame)
				end
			end
		end
	end
end

--自定义排序函数
function MonsterGroupAI:SortMonsterList(monsterList)
	local list = {}
	for k = 1, #monsterList do
		list[k] = monsterList[k]
	end
	--怪物列表排序，优先级：优先weight降序，weight相同则id升序
	table.sort(list,function(a,b)
		if a.monsterAttackWeight == b.monsterAttackWeight then
			return a.id < b.id
		else
			return a.monsterAttackWeight > b.monsterAttackWeight 
		end
	end)
	return list		
end

--自定义函数，判断实体是否属于怪物列表
function MonsterGroupAI:IsGroupMonster(instanceId,list)
	if list then
		for k = 1, #list do
			if instanceId == list[k] then
				return true
			end
		end
		return false
	end
end

--自定义函数，判断该技能是否某分级
function MonsterGroupAI:IsBattleSkill(skillId,list,grade)
	if list then
		for k = 1, #list do
			if skillId == list[k].id then
				--如果忘记填grade了，那么定义为普通战斗技能
				if not list[k].grade then
					list[k].grade = 5
				end
				if list[k].grade > grade then
					return true
				end
			end
		end
		return false
	end
end
	