PartnerResidentLockTarget = BaseClass("PartnerResidentLockTarget",EntityBehaviorBase)

function PartnerResidentLockTarget:Init()
	
	self.PartnerAllBehavior = self.ParentBehavior
	self.PartnerAllParm = self.MainBehavior.PartnerAllParm --获取母树
    self.me = self.instanceId
	
	self.PartnerAllParm.ResidentTarget = 0   --驻场锁定目标
	self.ResidentLockTargetMode = 1   --开放参数：驻场锁定模式：主人在战斗状态时，1-优先锁主人当前的锁定目标  2-锁离自己最近的目标,但主人被打就会锁攻击怪
	self.IfOwnerHit = false         --主人受击标记，记录主人是否受击
	self.OwnerHitFrame = 0          --用来计算主人受击标记多久后消失
	self.OwnerHitAttacker = 0       --主人受击时，记录攻击者
end

function PartnerResidentLockTarget:Update()
	self.PartnerAllParm.ResidentTarget = 0
	--驻场索敌逻辑
	if BehaviorFunctions.CheckPlayerInFight() then
		--主人在战斗状态（被怪物添加到仇恨列表）
		--模式1
		if self.ResidentLockTargetMode == 1 then
			local LockTarget = BehaviorFunctions.GetEntityValue(self.PartnerAllParm.role,"LockTarget")
			if LockTarget and LockTarget ~= 0 and BehaviorFunctions.CheckEntity(LockTarget) then
				self.PartnerAllParm.ResidentTarget = LockTarget     --锁定主人当前锁定的目标，不用判断索敌范围
			else
				if self.IfOwnerHit then
					if self.OwnerHitAttacker ~= 0 and BehaviorFunctions.CheckEntity(self.OwnerHitAttacker) then
						self.PartnerAllParm.ResidentTarget = self.OwnerHitAttacker   --锁定打主人的怪，不用判断索敌范围
					end
				else
					--在索敌范围内找离自己最近的怪
					local MonsterList = BehaviorFunctions.SearchNpcList(self.me,self.PartnerAllParm.ResidentTargetRange,2,nil,nil,nil,true)   --获取索敌范围内所有怪物列表
					if MonsterList then
						if MonsterList[1] and MonsterList[2] then  --如果列表有2个数据，则开始循环遍历比较距离，锁定最短距离的那个怪
							local Dis = BehaviorFunctions.GetDistanceFromTarget(self.me,MonsterList[1],false)
							local FinalMonster = MonsterList[1]
							for i = 2,#MonsterList do
								local Dis2 = BehaviorFunctions.GetDistanceFromTarget(self.me,MonsterList[i],false)
								if Dis2 < Dis then
									Dis = Dis2
									FinalMonster = MonsterList[i]
								end
							end
							if BehaviorFunctions.CheckEntity(FinalMonster) then
								self.PartnerAllParm.ResidentTarget = FinalMonster
							end
						else
							if BehaviorFunctions.CheckEntity(MonsterList[1]) and
								BehaviorFunctions.GetDistanceFromTarget(self.me,MonsterList[1],false) <= self.PartnerAllParm.ResidentTargetRange then
								self.PartnerAllParm.ResidentTarget = MonsterList[1]   --如果列表只有1个数据，则直接锁定这个怪
							end
						end
					end
				end
			end
			--模式2
		elseif self.ResidentLockTargetMode == 2 then
			if self.IfOwnerHit then
				if self.OwnerHitAttacker ~= 0 and BehaviorFunctions.CheckEntity(self.OwnerHitAttacker) then
					self.PartnerAllParm.ResidentTarget = self.OwnerHitAttacker   --锁定打主人的怪
				end
			else
				local MonsterList = BehaviorFunctions.SearchNpcList(self.me,self.PartnerAllParm.ResidentTargetRange,2,nil,nil,nil,true)   --获取佩从附近所有怪物列表
					if MonsterList[1] and MonsterList[2] then  --如果列表有2个数据，则开始循环遍历比较距离，锁定最短距离的那个怪
						local Dis = BehaviorFunctions.GetDistanceFromTarget(self.me,MonsterList[1],false)
						local FinalMonster = MonsterList[1]
						for i = 2,#MonsterList do
							local Dis2 = BehaviorFunctions.GetDistanceFromTarget(self.me,MonsterList[i],false)
							if Dis2 < Dis then
								Dis = Dis2
								FinalMonster = MonsterList[i]
							end
						end
						if BehaviorFunctions.CheckEntity(FinalMonster) then
							self.PartnerAllParm.ResidentTarget = FinalMonster
						end
					else
						if BehaviorFunctions.CheckEntity(MonsterList[1]) and 
						BehaviorFunctions.GetDistanceFromTarget(self.me,MonsterList[1],false) <= self.PartnerAllParm.ResidentTargetRange then
							self.PartnerAllParm.ResidentTarget = MonsterList[1]   --如果列表只有1个数据，则直接锁定这个怪
						end
					end
			end
		end
	else
		--主人不在战斗状态，主人打谁就锁谁
		local LockTarget = BehaviorFunctions.GetEntityValue(self.PartnerAllParm.role,"LockTarget")
		if LockTarget and LockTarget ~= 0 and BehaviorFunctions.CheckEntity(LockTarget) then
			self.PartnerAllParm.ResidentTarget = LockTarget     --锁定主人当前锁定的目标，不用判断索敌范围
		end
	end
	--print("最终锁定目标：",self.PartnerAllParm.ResidentTarget)
	--if BehaviorFunctions.CheckPlayerInFight() then
		--print("角色进战")
	--else
		--print("角色脱战")
	--end
	
	--主人受击标记持续15秒，时间到了消失
	if self.PartnerAllParm.time >= self.OwnerHitFrame then
		self.IfOwnerHit = false
	end
end

--检查主人是否受击，受击标记持续15秒
function PartnerResidentLockTarget:Hit(attackInstanceId,hitInstanceId,hitType,camp)
	if hitInstanceId == self.PartnerAllParm.role then
		self.IfOwnerHit = true
		self.OwnerHitFrame = self.PartnerAllParm.time + 450
	end
	if BehaviorFunctions.GetCampType(attackInstanceId) == 2 then
		self.OwnerHitAttacker = attackInstanceId
	end
end