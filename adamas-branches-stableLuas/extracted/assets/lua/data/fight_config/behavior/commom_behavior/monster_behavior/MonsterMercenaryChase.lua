MonsterMercenaryChase = BaseClass("MonsterMercenaryChase",EntityBehaviorBase)
--佣兵追击状态

function MonsterMercenaryChase:Init()
	self.MonsterCommonBehavior = self.ParentBehavior
	self.MonsterCommonParam = self.MainBehavior.MonsterCommonParam
	--逻辑变量
	self.inChase = false
	self.inFightRange = false
	self.inPathFinding = false
	self.pathFindingArrive = false
	self.targetInForbiddenArea = false
	self.forbiddenDisappear = false
	self.bornPosition = nil
	self.missionState = 0
end

function MonsterMercenaryChase:Update()
	self.MonsterCommonParam.inMercenaryChase = BehaviorFunctions.IsMercenaryChase(self.MonsterCommonParam.me)
	if self.bornPosition == nil then
		local posx, posy, posz = BehaviorFunctions.GetPosition(self.MonsterCommonParam.me)
		self.bornPosition = Vec3.New(posx, posy, posz)
	end	
	if self.MonsterCommonParam.battleTargetDistance <= 15 then
		self.inFightRange = true
	else
		self.inFightRange = false
	end
	
	if self.MonsterCommonParam.inMercenaryChase == true and self.inChase == false and not self.targetInForbiddenArea then
		self.MonsterCommonParam.inPeace = false
		self.MonsterCommonParam.haveWarn = false
		self.MonsterCommonParam.inFight = false
		self.MonsterCommonParam.canExitFight = false
		self.inChase = true
	elseif self.MonsterCommonParam.inMercenaryChase == true and self.targetInForbiddenArea and not self.forbiddenDisappear then
		self.forbiddenDisappear = true
		self:MercenaryReborn()
	end
		
	--追击状态
	if 	self.inChase == true and self.MonsterCommonParam.inFight == false then
		if self.inFightRange == false and BehaviorFunctions.CanCtrl(self.MonsterCommonParam.me) then
			--在距离外设置寻路
			if self:PathFindingBegin() and self.inPathFinding == false and self.MonsterCommonParam.inFight == false then
				--寻路开始
				self.inPathFinding = true
				if BehaviorFunctions.GetEntityState(self.MonsterCommonParam.me) ~= FightEnum.EntityState.Move then
					BehaviorFunctions.DoSetEntityState(self.MonsterCommonParam.me,FightEnum.EntityState.Move)
					BehaviorFunctions.DoSetMoveType(self.MonsterCommonParam.me,FightEnum.EntityMoveSubState.Run)
				end
			end
		else
			--在距离内停止寻路，进入战斗
			if (self.inPathFinding and self.pathFindingArrive) or self.inFightRange == true then
				if BehaviorFunctions.GetEntityState(self.MonsterCommonParam.me) == FightEnum.EntityState.Move then
					BehaviorFunctions.StopMove(self.MonsterCommonParam.me)
					BehaviorFunctions.DoSetEntityState(self.MonsterCommonParam.me,FightEnum.EntityState.Idle)
				end
				--停止寻路
				BehaviorFunctions.ClearPathFinding(self.MonsterCommonParam.me)
				self.pathFindingArrive = nil
				--进入战斗
				self.MonsterCommonParam.inFight = true
				--索敌
				BehaviorFunctions.AddFightTarget(self.MonsterCommonParam.me,self.MonsterCommonParam.battleTarget)
			end		
		end
	end
	
	self:ToyMercenary()
end


function MonsterMercenaryChase:PathFindingBegin()
	local result = BehaviorFunctions.SetPathFollowEntity(self.MonsterCommonParam.me,self.MonsterCommonParam.battleTarget)
	if result == true then
		return true
	else
		return false
	end
end

function MonsterMercenaryChase:PathFindingEnd(instanceId,result)
	if instanceId == self.MonsterCommonParam.me and result == true	then
		--抵达目标地点
		BehaviorFunctions.ClearPathFinding(self.MonsterCommonParam.me)
		self.pathFindingArrive = true
		self.inPathFinding = false
	elseif instanceId == self.MonsterCommonParam.me and result == false then
		--寻路异常
		BehaviorFunctions.ClearPathFinding(self.MonsterCommonParam.me)
		self.inPathFinding = false
	end
end

function MonsterMercenaryChase:MercenaryReborn()
	--停止逻辑
	BehaviorFunctions.StopMove(self.MonsterCommonParam.me)
	BehaviorFunctions.CancelLookAt(self.MonsterCommonParam.me)
	BehaviorFunctions.DoMagic(1,self.MonsterCommonParam.me,900000021)
	BehaviorFunctions.RemoveFightTarget(self.MonsterCommonParam.me,self.MonsterCommonParam.battleTarget)
	if  BehaviorFunctions.HasBuffKind(self.MonsterCommonParam.me,900000007) then
		BehaviorFunctions.RemoveBuff(self.MonsterCommonParam.me,900000007)
	end
	self.MonsterCommonParam.actKey=true
	if self.MonsterCommonParam.pathFindKey == false then
		BehaviorFunctions.ClearPathFinding(self.MonsterCommonParam.me)
		self.MonsterCommonParam.pathFindKey = true
	end
	--逻辑变量初始化
	self.forbiddenDisappear = false
	self.inChase = false
	self.inFightRange = false
	self.inPathFinding = false
	self.pathFindingArrive = false
	self.targetInForbiddenArea = false
	self.MonsterCommonParam.skillState = self.MonsterCommonParam.SkillStateEnum.Default
	self.MonsterCommonParam.inFight = false
	self.MonsterCommonParam.inPeace = true
	self.MonsterCommonParam.warnState = self.MonsterCommonParam.warnStateEnum.Default
	self.MonsterCommonParam.exitFightState = self.MonsterCommonParam.ExitFightStateEnum.Default
	BehaviorFunctions.DoMagic(1,self.MonsterCommonParam.me,900000012)
end


function MonsterMercenaryChase:MercenaryHuntAreaState(isIn)
 	if isIn == true then
		self.targetInForbiddenArea = true
	else
		self.targetInForbiddenArea = false	
		if BehaviorFunctions.HasBuffKind(self.MonsterCommonParam.me,900000012) then
			BehaviorFunctions.RemoveBuff(self.MonsterCommonParam.me,900000012)
		end
	end
end

function MonsterMercenaryChase:ToyMercenary()    --演示专用
	local EcoId = BehaviorFunctions.GetEntityEcoId(self.MonsterCommonParam.me)
	if EcoId == 4000901010012 then   --确认是玩具，开始操控
		if self.missionState == 0 then
			local StateValue1 = false
			local StateValue2 = false
			self.missionState = 1
		end
		StateValue1 = BehaviorFunctions.GetEntityValue(self.MonsterCommonParam.me, "StateValue1")
		StateValue2 = BehaviorFunctions.GetEntityValue(self.MonsterCommonParam.me, "StateValue2")
		local pos = BehaviorFunctions.GetTerrainPositionP("Yongbing02", 10020004, "WorldTgc_npc")
		--状态1，开始流程时，传到某个点，停住
		if StateValue1 == true and not StateValue2 then
			BehaviorFunctions.DoSetPosition(self.MonsterCommonParam.me, pos.x, pos.y, pos.z)
			BehaviorFunctions.StopMove(self.MonsterCommonParam.me)
			BehaviorFunctions.ClearPathFinding(self.MonsterCommonParam.me)
			--BehaviorFunctions.AddBuff(1, self.MonsterCommonParam.me, 200000009, 1)  --屏蔽怪物逻辑
			self.toyState = true
		elseif StateValue1 == true and StateValue2 == true then
			--if BehaviorFunctions.GetEntityState(self.MonsterCommonParam.me) ~= FightEnum.EntityState.Move then
			--BehaviorFunctions.DoSetEntityState(self.MonsterCommonParam.me,FightEnum.EntityState.Move)
			--BehaviorFunctions.DoSetMoveType(self.MonsterCommonParam.me,FightEnum.EntityMoveSubState.Run)
			--BehaviorFunctions.RemoveBuff(self.MonsterCommonParam.me, 200000009)
			self.inPathFinding = false
			self.toyState = false
		end
	end
end

function MonsterMercenaryChase:WorldInteractClick(uniqueId,instanceId)   --演示专用
	local chuanshu = BehaviorFunctions.GetEcoEntityByEcoId(2002002010002)
	--local shopitem = BehaviorFunctions.GetEcoEntityByEcoId(2002002010001)
	--点了传书，进状态1
	if instanceId == chuanshu then
		BehaviorFunctions.SetEntityValue(self.MonsterCommonParam.me, "StateValue1", true)
	end
	--点了买生态商品，进状态2
	--if instanceId == shopitem then
		--BehaviorFunctions.SetEntityValue(self.MonsterCommonParam.me, "StateValue2", true)
	--end
end

--退出商店回调，进状态2
function MonsterMercenaryChase:OnExitShop(shop_id)
	--BehaviorFunctions.SetEntityValue(self.MonsterCommonParam.me, "StateValue2", true)
end

function Behavior800050:StoryEndEvent(dialogId)
	if dialogId == 501280501 then
		BehaviorFunctions.SetEntityValue(self.MonsterCommonParam.me, "StateValue2", true)
	end
end