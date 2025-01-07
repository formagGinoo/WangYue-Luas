Behavior20305023 = BaseClass("Behavior20305023",EntityBehaviorBase)

local BF = BehaviorFunctions
local FES = FightEnum.EntityState
local FK = FightEnum.KeyEvent
local FE = FightEnum
local FEAS = FightEnum.EntityAimState
local FEET = FightEnum.ElementType
local FEAET = FightEnum.AnimEventType
--电压陷阱
function Behavior20305023.GetGenerates()
	 local generates = {20305080101,203050804,203051201,203051202,203051203,203051204,203050231}
	 return generates
end

function Behavior20305023:Init()
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
	self.shootCdLow = 10
	self.shootCdHigh = 15
	
	self.ONFire = false
	self.accel = false
	self.fxfire01 = nil
	self.fxfire02 = nil
	self.drive = 0
	
	self.hackKey = false
end

function Behavior20305023:LateInit()

end


function Behavior20305023:Update()

	self.frameNow = BehaviorFunctions.GetFightFrame()
	self.role = BehaviorFunctions.GetCtrlEntity()
	if self.frameNow > self.frameNext then
		if self.targetId and  self.ON then
			if BehaviorFunctions.CheckEntity(self.targetId) and BehaviorFunctions.GetEntityState(self.targetId) ~= FightEnum.EntityState.Die then
				Log(self.targetId)
				BehaviorFunctions.SetEntityTrackTarget(self.me,self.targetId)
				if BehaviorFunctions.Probability(10000) then
					BehaviorFunctions.CastSkillByTarget(self.me,2030502302,self.targetId)
				else
					BehaviorFunctions.CastSkillByTarget(self.me,2030502301,self.targetId)
				end
				--BehaviorFunctions.DoLookAtTaget(self.me,self.targetId)
				self.targetNow = self.targetId
				self.randomShoot = true
				self.frameNext = self.frameNow + BehaviorFunctions.Random(self.shootCdLow,self.shootCdHigh)
			end
		end
	end
	
	--if self.ONFire == true and self.accel == false and not BehaviorFunctions.HasBuffKind(self.me,2030502301)  then
		--BehaviorFunctions.AddBuff(self.me,self.me,2030502301)
	--end

	--if self.ONFire == true and self.accel == true and not BehaviorFunctions.HasBuffKind(self.me,2030502302) then
		--BehaviorFunctions.AddBuff(self.me,self.me,2030502302)
		--BehaviorFunctions.RemoveBuff(self.me,2030502301)
	--end
end


function Behavior20305023:KeyInput(key, status)
	if BehaviorFunctions.GetCtrlEntity() ~= self.role then --当前角色是否出战
		return
	end
	if key == FightEnum.KeyEvent.Activation and status == FightEnum.KeyInputStatus.Down then
		if self.ON ~= true then
			self.ON = true
			print("click up")
		else
			self.ON = false
		end
	end
	
	if key == FightEnum.KeyEvent.Activation and status == FightEnum.KeyInputStatus.Up then
		if self.ON ~= false then
			self.ON = false
			print("click up")
		end
	end
end

function Behavior20305023:PVSetAttackTarget(targetId)
	self.targetId = targetId
end

----点击上侧按钮
--function Behavior20305023:HackingClickUp(instanceId)
	--if instanceId == self.me then
		--if self.ON ~= true then
			--self.ON = true
			--print("click up")
		--else
			--self.ON = false
		--end
	--end
--end

----开始驾驶
--function Behavior20305023:OnDriveDrone(instanceId,curDriveId)
	--if curDriveId == self.role then
		--self.ONFire = true
		--self.accel = false
		--self.drive = 1
	--end
--end

----取消驾驶
--function  Behavior20305023:OnStopDriveDrone(instanceId,curDriveId)
	--self.ONFire = false
	--self.accel = false
	----BehaviorFunctions.RemoveEntity(self.fxfire01)
	----BehaviorFunctions.RemoveEntity(self.fxfire02)
	--self.fxfire01 = nil
	--self.fxfire02 = nil
	----BehaviorFunctions.BreakSkill(self.me)
	--self.drive = 0

	--if BehaviorFunctions.HasBuffKind(self.me,203051201) then
		--BehaviorFunctions.RemoveBuff(self.me,203051201)
	--end

	--if BehaviorFunctions.HasBuffKind(self.me,203051202) then
		--BehaviorFunctions.RemoveBuff(self.me,203051202)
	--end
--end

----点击无人机的加速按钮
--function Behavior20305023:OnTouchAddSpeed(isTouch)
	--if isTouch == true then
		--self.ON = true
		--self.accel = true
	--else
		--self.ON = true
		--self.accel = false
		--BehaviorFunctions.RemoveBuff(self.me,203051202)
	--end
--end

--function Behavior20305023:KeyInput(key, status)
	----是否按下加速按钮
	--if key == FightEnum.KeyEvent.Accel and status == FightEnum.KeyInputStatus.Down and self.drive == 1 then
		--self.ON = true
		--self.accel = true
		----BehaviorFunctions.RemoveEntity(self.fxfire01)
		----self.fxfire01 = nil
		----BehaviorFunctions.CastSkillByPosition(self.me,203051203)
	--end

	--if key == FightEnum.KeyEvent.Accel and status == FightEnum.KeyInputStatus.Up and self.drive == 1 then
		--self.ON = true
		--self.accel = false
		----BehaviorFunctions.RemoveEntity(self.fxfire02)
		----self.fxfire02 = nil
		----BehaviorFunctions.CastSkillByPosition(self.me,203051204)
		--BehaviorFunctions.RemoveBuff(self.me,203051202)
	--end
--end


