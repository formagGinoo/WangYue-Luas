StrideOverMachine = BaseClass("StrideOverMachine",MachineBase)

local Vec3 = Vec3
local Quat = Quat

local AnimFrame = 52
local ClimbingFrame = 17
local ForwardFrame = 9

function StrideOverMachine:__init()

end

function StrideOverMachine:Init(fight,entity)
	self.fight = fight
	self.entity = entity
	
	self.tempVec = Vec3.New(0, 0, 0)
	self.rotateSpeed = 20 * FightUtil.deltaTimeSecond
end

function StrideOverMachine:OnEnter()
	self.entity.logicMove = true
	self.entity.animatorComponent:PlayAnimation(Config.EntityCommonConfig.AnimatorNames.StrideOver)
	
	local animFrame = self.entity.animatorComponent.animFrame
	self.remainChangeTime = animFrame * FightUtil.deltaTimeSecond
	
	local pos = self.entity.transformComponent:GetPosition()
	local rot = self.entity.transformComponent:GetRotation()
	local strideOverY, strideOverZ = self.entity.climbComponent:GetStrideOverOffset()
	self.offsetY = strideOverY / ClimbingFrame -- 这里计算有误，没有考虑旋转，因为没表现异常，暂不处理
	self.endY = pos.y + strideOverY
	
	local height = self.entity.collistionComponent.height
	local offsetZ = (rot * Vec3.forward * strideOverZ) / ForwardFrame
	self.offsetZ = Vec3.ProjectOnPlane(offsetZ, Vec3.up)
	
	--大概肩膀的位置，后续优化
	self.endZ = pos + (rot * Vec3.up * (height - 0.15)) + (rot * Vec3.forward * strideOverZ)
	--self.endZ = Vec3.ProjectOnPlane(self.endZ, Vec3.up)
	
	self.startRotation = rot
	self.toRotation = Quat.Euler(0, self.startRotation:ToEulerAngles().y, 0)
	if self.toRotation == rot then
		self.toRotation = nil
	end
end

function StrideOverMachine:Update()
	local pos = self.entity.transformComponent:GetPosition()
	local rot = self.entity.transformComponent:GetRotation()
	self.remainChangeTime = self.remainChangeTime - FightUtil.deltaTimeSecond
	if self.remainChangeTime <= 0 then
		self.entity.stateComponent:SetState(FightEnum.EntityState.Idle)
	elseif self.endY - pos.y > 0.01 then -- 这里计算有误，没有考虑旋转，因为没表现异常，暂不处理
		local offsetY = self.offsetY
		if offsetY + pos.y > self.endY then
			offsetY = self.endY - pos.y
		end
		self.tempVec:Set(0, offsetY, 0)
		local offset = self.startRotation * self.tempVec
		self.entity.moveComponent:SetPositionOffset(offset.x, offset.y, offset.z)
	elseif Vec3.DistanceXZ(pos, self.endZ) > 0.01 then
		local curDir = self.endZ - pos
		local rotDir = rot * Vec3.forward
		rotDir.y, curDir.y = 0, 0
		if Vec3.Dot(curDir, rotDir) > 0 then
			self.entity.moveComponent:SetPositionOffset(self.offsetZ.x, self.offsetZ.y, self.offsetZ.z)
		end
	end
	
	if self.toRotation then
		local rotate = Quat.RotateTowards(rot, self.toRotation, self.rotateSpeed)
		self.entity.transformComponent:SetRotation(rotate)
		if self.toRotation == rot then
			self.toRotation = nil
		end
	end
end

function StrideOverMachine:OnLeave()
	self.entity.logicMove = false
	
	local euler = self.entity.transformComponent:GetRotation():ToEulerAngles()
	local rotation = Quat.Euler(0, euler.y, 0)
	self.entity.transformComponent:SetRotation(rotation)
end

function StrideOverMachine:CanMove()
	local moveEnableFrame = AnimFrame - (ClimbingFrame + ForwardFrame)
	return self.remainChangeTime <= moveEnableFrame * FightUtil.deltaTimeSecond
end

function StrideOverMachine:CanJump()
	return false
end

function StrideOverMachine:CanClimb()
	return false
end

function StrideOverMachine:CanCastSkill()
	return false
end

function StrideOverMachine:OnCache()
	self.fight.objectPool:Cache(StrideOverMachine,self)
end

function StrideOverMachine:__cache()

end

function StrideOverMachine:__delete()

end