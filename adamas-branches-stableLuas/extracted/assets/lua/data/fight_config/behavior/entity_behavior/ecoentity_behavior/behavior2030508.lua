Behavior2030508 = BaseClass("Behavior2030508",EntityBehaviorBase)

local BF = BehaviorFunctions
local FES = FightEnum.EntityState
local FK = FightEnum.KeyEvent
local FE = FightEnum
local FEAS = FightEnum.EntityAimState
local FEET = FightEnum.ElementType
local FEAET = FightEnum.AnimEventType
--电压陷阱
function Behavior2030508.GetGenerates()
	-- local generates = {}
	-- return generates
end

function Behavior2030508:Init()
	self.me = self.instanceId
	self.entityId = 0
	self.battleTarget = nil
	self.bullet = 203050801
	self.ON = false
	self.role = 0
	self.target = {}
	self.targetNow = 0

	self.hackKey = 0

	self.randomShoot = false
	
	self.active = false



	--变量声明
	self.Me = self.instanceId		--记录自己

	self.LockDistance = 60
	self.CancelLockDistance = 30

	--组合缩写
	self.RAB = self.RoleAllBehavior
	self.RAP = self.RoleAllParm

	self.frameNow = 0
	self.frameNext = 0
	self.shootCd = 0
	self.shootCdLow = 15
	self.shootCdHigh = 20
	
	self.dis = 0 --炮台与目标距离
	self.disLimit = 30 --炮台攻击最大距离
end

function Behavior2030508:LateInit()

end


function Behavior2030508:Update()

	self.frameNow = BehaviorFunctions.GetFightFrame()
	--
	self.role = BehaviorFunctions.GetCtrlEntity()
	
	if self.targetId ~= nil and BehaviorFunctions.CheckEntity(self.targetId) and BehaviorFunctions.GetEntityState(self.targetId) ~= FightEnum.EntityState.Die then
		self.dis = BehaviorFunctions.GetDistanceFromTarget(self.me,self.targetId,false) --炮台与目标的距离
		self.collider = BehaviorFunctions.CheckObstaclesBetweenEntity(self.me,self.targetId,false)
	end

	--
	--if self.frameNow > self.frameNext then
	--	if BehaviorFunctions.CanCastSkill(self.me) and self.ON == true then
	--		--搜索实体，阵营为2，拥有怪物和boss的标签
	--		self.target = BehaviorFunctions.SearchEntityOnScreen(self.me,FightEnum.EntityCamp.Camp2,100,{FightEnum.EntityNpcTag.Monster,FightEnum.EntityNpcTag.Boss})
	--		--如果目标不为空，则开始遍历
	--		if self.target and next(self.target) then
	--			for i = 1, #self.target do
	--				--检测目标是否存在并且存活
	--				if self.target[i].instanceId then
	--
	--				end
	--			end
	--		end
	--	end
	--end
	
	
	--炮台技能帧数计算
	if self.frameNow > self.frameNext then
		--目标存在，自己可以放技能攻击
		if self.targetId and  self.active  and BehaviorFunctions.CanCastSkill(self.me) then
			--目标存活
			if BehaviorFunctions.CheckEntity(self.targetId) and BehaviorFunctions.GetEntityState(self.targetId) ~= FightEnum.EntityState.Die then
				--炮台和目标之间没碰撞，且距离小于最大攻击距离
				if self.collider ~= true and self.dis < self.disLimit then
					BehaviorFunctions.DoLookAtTaget(self.me,self.targetId) --设置朝向
					BehaviorFunctions.SetEntityTrackTarget(self.me,self.targetId) --设置追踪目标
					BehaviorFunctions.CastSkillByTarget(self.me,203050801,self.targetId) --释放炮击技能

					--self.targetNow = self.targetId
					--self.randomShoot = true
					--计算下次技能释放的世界帧数
					self.frameNext = self.frameNow + BehaviorFunctions.Random(self.shootCdLow,self.shootCdHigh)
					
					if not BehaviorFunctions.CheckEntity(self.targetId) or BehaviorFunctions.GetEntityState(self.targetId) == FightEnum.EntityState.Die then
						self.targetId = nil
					end
					
				end	
			end
		end
	end
end

--function Behavior2030508:PVSetAttackTarget(targetId)
	--self.targetId = targetId
--end

----点击上侧按钮
--function Behavior2030508:HackingClickUp(instanceId)
	--if instanceId == self.me then
		--if self.ON ~= true then
			--self.ON = true
			--Log("111")
		--else
			--self.ON = false
			--Log("222")
		--end
	--end
--end

--function Behavior2030508:HackingClickDown(instanceId)
	--if instanceId == self.me then
		--self.ON = false
		----BehaviorFunctions.SetEntityValue(self.role,"battleTarget",self.role)
		--BehaviorFunctions.RemoveEntity(self.me)
	--end
--end

--function Behavior2030508:OnPartnerBuildSuccess()
	--self.ON = true
--end

--function Behavior2030508:KeyInput(key, status)
	--if key == FightEnum.KeyEvent.Activation and status == FightEnum.KeyInputStatus.Down then
		--self.hackKey = 1
		--self.ON = true
		--Log("11111")
	--end

	--if key == FightEnum.KeyEvent.Activation and status == FightEnum.KeyInputStatus.Up and self.hackKey == 1 then
		--self.hackKey = 0
		--self.ON = false
		--Log("22222")
	--end
--end


--function Behavior2030508:KeyInput(key, status)
	----if key == FightEnum.KeyEvent.Activation and status == FightEnum.KeyInputStatus.Down then
	----	--self.hackKey = 1
	----	self.ON = true
	----end
	----
	----if key == FightEnum.KeyEvent.Activation and status == FightEnum.KeyInputStatus.Up then
	----	--self.hackKey = 0
	----	self.ON = false
	----	self.randomShoot = false
	----end
--end

--function Behavior2030508:ShootRandom(instanceId)
	--if instanceId then
		--if BehaviorFunctions.Probability(4000) then
			--BehaviorFunctions.CastSkillByTarget(self.me,203050801,instanceId)
		--else
			--if BehaviorFunctions.Probability(5000) then
				--BehaviorFunctions.CastSkillByTarget(self.me,203050802,instanceId)
			--else
				--BehaviorFunctions.CastSkillByTarget(self.me,203050803,instanceId)
			--end

		--end

	--end
--end

--function BehaviorBase:FirstCollide(attackInstanceId,hitInstanceId,instanceId,attackType,camp)
	--if hitInstanceId == self.targetNow then
		--BehaviorFunctions.SetEntityValue(self.targetNow,"battleTarget",self.me)
	--end
--end


--上键激活
function Behavior2030508:HackingClickUp(instanceId)
	if instanceId == self.me then
		if self.active ~= true then
			self.active = true
		else
			self.active = false
		end
	end

end

----敌人进入范围
--function Behavior2030508:ExtraEnterTrigger(triggerInstanceId,triggerEntityId,InstanceId)
	--if triggerInstanceId == self.me then
		--if self.active == true then
			--if BehaviorFunctions.GetEntityState(InstanceId) ~= FightEnum.EntityState.Die and InstanceId ~= self.role then
				--self.targetId = InstanceId
				--print(self.targetId)
			--end
		--end
	--end
--end

--当检测到玩家攻击敌人时，将敌人设为目标
function Behavior2030508:Collide(attackInstanceId,hitInstanceId,instanceId,shakeStrenRatio,attackType,camp)
	if attackInstanceId == self.role then
		if BehaviorFunctions.CheckEntity(hitInstanceId) and BehaviorFunctions.GetEntityState(hitInstanceId) ~= FightEnum.EntityState.Die then
			self.targetId = hitInstanceId
		end
	end
end