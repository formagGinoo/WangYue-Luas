Behavior2030512 = BaseClass("Behavior2030512",EntityBehaviorBase)

local BF = BehaviorFunctions
local FES = FightEnum.EntityState
local FK = FightEnum.KeyEvent
local FE = FightEnum
local FEAS = FightEnum.EntityAimState
local FEET = FightEnum.ElementType
local FEAET = FightEnum.AnimEventType


function Behavior2030512:Init()
	self.me = self.instanceId	
	self.battleTarget = nil
	self.bullet = 203051201
	self.ON = false
	self.role = 0
	self.bullet = nil
	self.accel = false
	
	self.fxfire01 = nil
	self.fxfire02 = nil
	
	self.drive = 0
	
end

function Behavior2030512:LateInit()
	
end


function Behavior2030512:Update()

	
	self.role = BehaviorFunctions.GetCtrlEntity()
	
	if self.ON == true and self.accel == false and not BehaviorFunctions.HasBuffKind(self.me,203051201)  then
		BehaviorFunctions.AddBuff(self.me,self.me,203051201)
		--BehaviorFunctions.BreakSkill(self.me)
		----BehaviorFunctions.CastSkillBySelfPosition(self.me,203051201)
		--self.x,self.y,self.z = BehaviorFunctions.GetEntityTransformPos(self.me,"Attack")
		--self.fxfire01 = BehaviorFunctions.CreateEntityByEntity(self.me,20305120101)
		--BehaviorFunctions.BindTransform(self.fxfire01,"Attack",{x = 0, y = 0, z = 0},self.me)
	end
	
	if BehaviorFunctions.CanCastSkill(self.me) and self.ON == true and self.accel == true and not BehaviorFunctions.HasBuffKind(self.me,203051202) then
		BehaviorFunctions.AddBuff(self.me,self.me,203051202)
		BehaviorFunctions.RemoveBuff(self.me,203051201)
		--BehaviorFunctions.BreakSkill(self.me)
		----BehaviorFunctions.CastSkillBySelfPosition(self.me,203051201)
		--self.x,self.y,self.z = BehaviorFunctions.GetEntityTransformPos(self.me,"Attack")
		--self.fxfire02 = BehaviorFunctions.CreateEntityByEntity(self.me,20305120102)
		--BehaviorFunctions.BindTransform(self.fxfire02,"Attack",{x = 0, y = 0, z = 0},self.me)
	end
end

--点击上侧按钮
function Behavior2030512:HackingClickUp(instanceId)
	--if instanceId == self.me and self.drive ~= 1 then
		--if self.ON ~= true then
			--self.ON = true
		--else
			--self.ON = false
			--BehaviorFunctions.RemoveEntity(self.bullet)
			--self.bullet = nil
		--end
	--end
end

--点击下侧按钮
function Behavior2030512:HackingClickDown(instanceId)
	if instanceId == self.me then
		self.ON = false
		BehaviorFunctions.RemoveEntity(self.me)
	end
end

--建造完成
function Behavior2030512:OnPartnerBuildSuccess()
	self.ON = false
end

--开始驾驶
function Behavior2030512:OnDriveDrone(instanceId,curDriveId)
	if curDriveId == self.role then
		self.ON = true
		self.accel = false		
		self.drive = 1
	end
end

--取消驾驶
function  Behavior2030512:OnStopDriveDrone(instanceId,curDriveId)
	self.ON = false
	self.accel = false
	--BehaviorFunctions.RemoveEntity(self.fxfire01)
	--BehaviorFunctions.RemoveEntity(self.fxfire02)
	self.fxfire01 = nil
	self.fxfire02 = nil
	--BehaviorFunctions.BreakSkill(self.me)
	self.drive = 0
	
	if BehaviorFunctions.HasBuffKind(self.me,203051201) then
		BehaviorFunctions.RemoveBuff(self.me,203051201)
	end

	if BehaviorFunctions.HasBuffKind(self.me,203051202) then
		BehaviorFunctions.RemoveBuff(self.me,203051202)
	end

end

--点击无人机的加速按钮
function Behavior2030512:OnTouchAddSpeed(isTouch)
	if isTouch == true then
		self.ON = true
		self.accel = true
		--BehaviorFunctions.RemoveEntity(self.fxfire01)
		--self.fxfire01 = nil
		--BehaviorFunctions.CastSkillByPosition(self.me,203051203)
	else
		self.ON = true
		self.accel = false
		--BehaviorFunctions.RemoveEntity(self.fxfire02)
		--self.fxfire02 = nil
		--BehaviorFunctions.CastSkillByPosition(self.me,203051204)
		BehaviorFunctions.RemoveBuff(self.me,203051202)
	end
end


function Behavior2030512:KeyInput(key, status)
	--是否按下加速按钮
	if key == FightEnum.KeyEvent.Accel and status == FightEnum.KeyInputStatus.Down and self.drive == 1 then
		self.ON = true
		self.accel = true
		--BehaviorFunctions.RemoveEntity(self.fxfire01)
		--self.fxfire01 = nil
		BehaviorFunctions.CastSkillByPosition(self.me,203051203)
	end

	if key == FightEnum.KeyEvent.Accel and status == FightEnum.KeyInputStatus.Up and self.drive == 1 then
		self.ON = true
		self.accel = false
		--BehaviorFunctions.RemoveEntity(self.fxfire02)
		--self.fxfire02 = nil
		BehaviorFunctions.CastSkillByPosition(self.me,203051204)
		BehaviorFunctions.RemoveBuff(self.me,203051202)
	end

end
