Behavior40022002 = BaseClass("Behavior40022002",EntityBehaviorBase)

local BF = BehaviorFunctions
local FES = FightEnum.EntityState
local FK = FightEnum.KeyEvent
local FE = FightEnum
local FEAS = FightEnum.EntityAimState
local FEET = FightEnum.ElementType
local FEAET = FightEnum.AnimEventType
local FEEAT = FightEnum.EAttackType

function Behavior40022002.GetGenerates()
end

function Behavior40022002.GetMagics()
	local generates = {}
	return generates
end

function Behavior40022002:Init()
	self.Me = self.instanceId
	self.role = BF.GetCtrlEntity()
	self.curTarget = BF.GetEntityValue(self.Me,"battleTarget")
end

function Behavior40022002:Update()
	--设置阵营
	self.camp = BehaviorFunctions.GetCampType(self.Me)
	if self.camp ~= 3 then
		BehaviorFunctions.ChangeCamp(self.Me,3)
		BehaviorFunctions.SetLookIKEnable(self.Me,false)
	end

	--获取角色锁定目标
	self.LockTarget = BehaviorFunctions.GetEntityValue(self.role,"LockTarget")
	self.AttackTarget = BehaviorFunctions.GetEntityValue(self.role,"AttackTarget")
	self.LockAltnTarget = BehaviorFunctions.GetEntityValue(self.role,"LockAltnTarget")
	
	--确定攻击目标
	--如果角色没有锁定的目标，则搜索距离自己最近的目标，如果角色有锁定的目标，则跟着角色攻击
	if BehaviorFunctions.CheckEntity(self.LockTarget) and self.LockTarget ~= self.Me then
		self.battleTarget = self.LockTarget
	elseif BehaviorFunctions.CheckEntity(self.AttackTarget) and self.AttackTarget ~= self.Me then
		self.battleTarget = self.AttackTarget
	elseif BehaviorFunctions.CheckEntity(self.AttackAltnTarget) and self.AttackAltnTarget ~= self.Me then
		self.battleTarget = self.AttackAltnTarget
	else
		local distance
		self.AllTargetList = BehaviorFunctions.SearchEntities(self.Me,20,0,360,{2,3},nil,nil,1004,1,0,nil,false,true,0,0,false,false,false)
		if next(self.AllTargetList) then
			--存在实体
			if BehaviorFunctions.CheckEntity(self.AllTargetList[1][1]) then
				local minValue = 20
				local minIndex
				for i,v in ipairs(self.AllTargetList) do
					--得到目标和角色的距离
					distance = BF.GetDistanceFromTarget(self.Me,v[1],false)
					--	distance = BF.GetDistanceFromTarget(self.Me,v[1],false)
					--不断遍历最小值
					if distance < minValue and v[1] ~= self.Me then
						minValue = distance
						minIndex = v[1]
					end
					--返回最近的目标
					self.battleTarget = minIndex
				end
			end
		end
	end
	
	BehaviorFunctions.SetEntityValue(self.Me,"battleTarget",self.battleTarget)
end


function Behavior40022002:RemoveBuff(entityInstanceId, buffInstanceId,buffId)
	if buffId == 40022002 and entityInstanceId == self.Me then
		BehaviorFunctions.SetLookIKEnable(self.Me,true)
		BehaviorFunctions.ChangeCamp(self.Me,2)
		BehaviorFunctions.SetEntityValue(self.Me,"battleTarget",self.curTarget)
	end
end