Behavior203050800 = BaseClass("Behavior203050800",EntityBehaviorBase)

local BF = BehaviorFunctions
local FES = FightEnum.EntityState
local FK = FightEnum.KeyEvent
local FE = FightEnum
local FEAS = FightEnum.EntityAimState
local FEET = FightEnum.ElementType
local FEAET = FightEnum.AnimEventType
--电压陷阱
function Behavior203050800.GetGenerates()
	-- local generates = {}
	-- return generates
end

function Behavior203050800:Init()
	self.me = self.instanceId	
	self.battleTarget = nil
	self.bullet = 2030508001
	self.ON = false
	self.role = 0
	self.target = {}
	self.targetNow = 0
	
	self.hackKey = 0
	
	
	
	--变量声明
	self.Me = self.instanceId		--记录自己

	self.LockDistance = 60
	self.CancelLockDistance = 30

	--组合缩写
	self.RAB = self.RoleAllBehavior
	self.RAP = self.RoleAllParm
	
	
	self.frameNow = 0
	self.frameNext = 0
	self.shootCd = 40
end

function Behavior203050800:LateInit()
	
end


function Behavior203050800:Update()
	
	self.frameNow = BehaviorFunctions.GetFightFrame()
	
	--if BF.CheckEntity(self.Me) then

		----角色目标选择判断
		--self.RAB.RoleSelectTarget:Update(self.LockDistance,self.CancelLockDistance)

		------角色锁定目标判断
		----self.RAB.RoleLockTarget:Update(self.LockDistance,self.CancelLockDistance)
	--end
	
	----通用角色参数开放
	--self.RAP:SetEntityValuePart()
	
	--self.target = BF.SearchEntities(self.Me,30,0,360,2,1,nil,1004,
		--1,0.3,nil,false,true,1,0.2,false,true)
	
	self.role = BehaviorFunctions.GetCtrlEntity()
	
	--print(self.target)
	--if BehaviorFunctions.CanCastSkill(self.me) and self.ON == true then
	--	--搜索实体，阵营为2，拥有怪物和boss的标签
	--	self.target = BehaviorFunctions.SearchEntityOnScreen(self.me,FightEnum.EntityCamp.Camp2,100,{FightEnum.EntityNpcTag.Monster,FightEnum.EntityNpcTag.Boss})
	--	--如果目标不为空，则开始遍历
	--	if self.target and next(self.target) then
	--		for i = 1, #self.target do
	--			--检测目标是否存在并且存活
	--			if self.target[i].instanceId then
	--				if BehaviorFunctions.GetEntityState(self.target[i].instanceId) ~= (FightEnum.EntityState.Death or FightEnum.EntityState.Die) then
	--					BehaviorFunctions.SetEntityTrackTarget(self.me,self.target[i].instanceId)
	--					--if BehaviorFunctions.Probability(5000) then
	--						--BehaviorFunctions.CastSkillByTarget(self.me,2030508002,self.target[i].instanceId)
	--					--else
	--						--BehaviorFunctions.CastSkillByTarget(self.me,2030508001,self.target[i].instanceId)
	--					--end
	--
	--					BehaviorFunctions.CastSkillByTarget(self.me,2030508001,self.target[i].instanceId)
	--					self.targetNow = self.target[i].instanceId
	--					break
	--				end
	--			end
	--		end
	--	end
	--end
	if self.frameNow > self.frameNext then
		if self.targetId and  self.ON then
			if BehaviorFunctions.CheckEntity(self.targetId) and BehaviorFunctions.GetEntityState(self.targetId) ~= FightEnum.EntityState.Die then
				BehaviorFunctions.SetEntityTrackTarget(self.me,self.targetId)
				BehaviorFunctions.CastSkillByTarget(self.me,2030508001,self.targetId)
				self.targetNow = self.targetId
				self.randomShoot = true
				self.frameNext = self.frameNow + self.shootCd
			end
		end
	end	
end

function Behavior203050800:PVSetAttackTarget(targetId)
	self.targetId = targetId
end

----点击上侧按钮
--function Behavior203050800:HackingClickUp(instanceId)
	--if instanceId == self.me then
		--if self.ON ~= true then
			--self.ON = true
			--print("click up")
		--else
			--self.ON = false
		--end
	--end
--end

--function Behavior203050800:HackingClickDown(instanceId)
	----if instanceId == self.me then
		----self.ON = false
		----BehaviorFunctions.SetEntityValue(self.role,"battleTarget",self.role)
		----BehaviorFunctions.RemoveEntity(self.me)
	----end
--end

--function Behavior203050800:OnPartnerBuildSuccess()
	--self.ON = true
--end

function Behavior203050800:KeyInput(key, status)
	if key == FightEnum.KeyEvent.Activation and status == FightEnum.KeyInputStatus.Down then
		self.hackKey = 1
		self.ON = true
	end

	if key == FightEnum.KeyEvent.Activation and status == FightEnum.KeyInputStatus.Up and self.hackKey == 1 then
		self.hackKey = 0
		self.ON = false
	end
end


--function Behavior203050800:KeyInput(key, status)
	----if key == FightEnum.KeyEvent.Activation and status == FightEnum.KeyInputStatus.Down then
	----	--self.hackKey = 1
	----	self.ON = true
	----end
	----
	----if key == FightEnum.KeyEvent.Activation and status == FightEnum.KeyInputStatus.Up then
	----	--self.hackKey = 0
	----	self.ON = false
	----end
--end