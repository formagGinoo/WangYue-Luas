Behavior2050105 = BaseClass("Behavior2050105",EntityBehaviorBase) --在怪物身上使用CheckEcoEntityGroup,来决定是否要调用这个函数。
--资源预加载
function Behavior2050105.GetGenerates()
	local generates = {}
	return generates
end

function Behavior2050105:Init()
	--self.me = self.instanceId
	--self.mission=0
	--self.bornPosition={}
	--self.warnKey=true
	--self.warnOthers= false
	--self.treasureBoxList={2010101,2010102,2010103,2010104}
	--self.mission=0
	--self.treasureBox=0 --给一个初始化id
------------------------------------------------
	self.me = self.instanceId
	self.treasureBoxList = { [2010101] = true, [2010102] = true, [2010103] = true, [2010104] = true }
	self.treasureBox = nil --宝箱insID
	self.myStateEnum =
	{
		inactive = 1,--未激活状态
		activated = 2,--已激活状态
		finish =3 ,--战斗是否完成
	}
	self.myState = self.myStateEnum.inactive

	-- self.ecoGroupMember = {}--生态组成员

	self.enemyGroup = {}	--组成员中的怪物

	self.ecoId = nil

	self.ecoState = nil

	self.inited = false
end

function Behavior2050105:InitInfo()
	local myEntity = BehaviorFunctions.GetEntity(self.instanceId)
	if not myEntity then
		return
	end

	local groupMember = BehaviorFunctions.GetEcoEntityGroup(nil, self.sInstanceId)
	if groupMember then
		for i,v in pairs(groupMember) do
			if not BehaviorFunctions.CheckEntity(v.instanceId) then
				goto continue
			end

			local entity = BehaviorFunctions.GetEntity(v.instanceId)
			local isMonster = entity.tagComponent and entity.tagComponent:IsMonster()
			if not isMonster and self.treasureBoxList[entity.entityId] then
				self.treasureBox = v.instanceId
			elseif isMonster and v.instanceId ~= self.instanceId then
				self.enemyGroup[v.ecoId] = v.instanceId
			end

			::continue::
		end
	end

	self.groupId = myEntity.sGroup

	local enemyGroup = BehaviorFunctions.GetEcoEntityGroupMember(self.groupId, FightEnum.EcoEntityType.Monster)
	self.enemyCount = 0
	if enemyGroup then
		for k, v in pairs(enemyGroup) do
			if BehaviorFunctions.GetEcoEntityByEcoId(v) then
				self.enemyCount = self.enemyCount + 1
			end
		end
	end

	self.ecoState = BehaviorFunctions.GetEcoEntityState(self.sInstanceId)
	self.inited = true
end

function Behavior2050105:Update()
	-- 不是生态就返回
	if not self.sInstanceId then
		return
	end

	if not self.inited then
		self:InitInfo()
	end

	local treasureState = self.myState == self.myStateEnum.finish
	if self.treasureState ~= treasureState and self.treasureBox then
		BehaviorFunctions.SetEntityWorldInteractState(self.treasureBox, treasureState)
		self.treasureState = treasureState
	end

	if self.ecoState == 0 then
		for ecoId, instanceId in pairs(self.enemyGroup) do
			if not BehaviorFunctions.CheckEntity(instanceId) then
				goto continue
			end

			if not BehaviorFunctions.HasBuffKind(instanceId, 200000009) then
				BehaviorFunctions.SetEntityShowState(instanceId,false)
				--停止怪物逻辑
				BehaviorFunctions.AddBuff(instanceId, instanceId, 200000009)
			end

			if not BehaviorFunctions.HasBuffKind(instanceId, 200000100) then
				--隐藏怪物血条
				BehaviorFunctions.AddBuff(instanceId, instanceId, 200000100)
			end

			::continue::
		end
		self.myState = self.myStateEnum.inactive
	elseif self.ecoState == 1 then
		for ecoId, instanceId in pairs(self.enemyGroup) do
			if BehaviorFunctions.CheckEntity(instanceId) then
				-- todo 怎么会每一帧都生成一个实体给他的
				if BehaviorFunctions.HasBuffKind(instanceId, 200000009) then
					BehaviorFunctions.SetEntityShowState(instanceId, true)
					BehaviorFunctions.CreateEntity(900000104, instanceId)
					BehaviorFunctions.RemoveBuff(instanceId, 200000009)
				end

				if BehaviorFunctions.HasBuffKind(instanceId, 200000100) then
					BehaviorFunctions.RemoveBuff(instanceId, 200000100)
				end
			end

			if BehaviorFunctions.CheckEntity(self.treasureBox) then
				if BehaviorFunctions.HasBuffKind(self.treasureBox,200000009) then
					--恢复宝箱逻辑
					BehaviorFunctions.RemoveBuff(self.treasureBox,200000009)
				end
			end

			if BehaviorFunctions.CheckEntity(self.treasureBox) then
				BehaviorFunctions.SetEntityValue(self.treasureBox,"lockState",2) --初始化的时候给一个上锁状态
			end
		end
		self.myState = self.myStateEnum.activated
	elseif self.ecoState == 2 then
		if BehaviorFunctions.CheckEntity(self.treasureBox) then
			BehaviorFunctions.SetEntityValue(self.treasureBox,"lockState",3)  --解锁
		end
		self.myState = self.myStateEnum.finish
		--打开宝箱交互显示
		self.treasureState = true
		BehaviorFunctions.SetEntityWorldInteractState(self.treasureBox, true)
	end
end


function Behavior2050105:EnterTrigger(triggerInstanceId, triggerEntityId, roleInstanceId)
	if triggerInstanceId == self.treasureBox then
		if self.ecoState ~= 1 and self.enemyCount > 0 then
			BehaviorFunctions.SetEcoEntityState(self.sInstanceId, 1)
		elseif self.ecoState ~= 2 and self.enemyCount == 0 then
			BehaviorFunctions.SetEcoEntityState(self.sInstanceId, 2)
		end
	end
end

--如何只在死亡的时候触发(正常解锁逻辑)
function Behavior2050105:Death(instanceId, isFormationRevive)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	if not entity.sInstanceId or not self.enemyGroup[entity.sInstanceId] then
		return
	end

	self.enemyGroup[entity.sInstanceId] = nil
	self.enemyCount = self.enemyCount - 1
	if self.enemyCount == 0 then
		BehaviorFunctions.SetEcoEntityState(self.sInstanceId, 2)
		BehaviorFunctions.SetEntityValue(self.treasureBox, "lockState", 3)  --解锁
		BehaviorFunctions.InteractEntityHit(self.me, FightEnum.SysEntityOpType.Death)
	end
end

function Behavior2050105:RemoveEntity(instanceId, sInstanceId)
	if self.treasureBox and self.treasureBox == instanceId then
		self.treasureBox = nil
	elseif sInstanceId and self.enemyGroup[sInstanceId] then
		self.enemyGroup[sInstanceId] = nil
		self.enemyCount = self.enemyCount - 1
	end
end

function Behavior2050105:CreateEcoGroupEntity(sInstanceId, instanceId, groupId)
	if not self.groupId or self.groupId ~= groupId or self.instanceId == instanceId then
		return
	end

	local entity = BehaviorFunctions.GetEntity(instanceId)
	if not entity then
		return
	end

	if not self.treasureBox and self.treasureBoxList[entity.entityId] then
		self.treasureBox = instanceId
	elseif not self.enemyGroup[sInstanceId] then
		self.enemyGroup[sInstanceId] = instanceId
		self.enemyCount = self.enemyCount + 1
	end
end

function Behavior2050105:EcoEntityStateUpdate(sInstanceId)
	if not self.sInstanceId or self.sInstanceId ~= sInstanceId then
		return
	end

	self.ecoState = BehaviorFunctions.GetEcoEntityState(sInstanceId)
end