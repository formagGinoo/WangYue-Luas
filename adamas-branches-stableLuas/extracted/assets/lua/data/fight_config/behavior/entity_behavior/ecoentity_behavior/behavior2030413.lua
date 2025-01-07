Behavior2030413 = BaseClass("2030413",EntityBehaviorBase)

local BF = BehaviorFunctions
local FES = FightEnum.EntityState
local FK = FightEnum.KeyEvent
local FE = FightEnum
local FEAS = FightEnum.EntityAimState
local FEET = FightEnum.ElementType
local FEAET = FightEnum.AnimEventType


function Behavior2030413:Init()
	self.me = self.instanceId	
	self.ecoMe = self.sInstanceId
	self.missionState = 0 --关卡状态
	self.missionStateEnum = {default = 0, start = 1, ongoing = 2, success = 3, fail = 4} --关卡状态枚举
	self.bindLevel = nil --绑定关卡
	
end

function Behavior2030413:LateInit()
	self.bindLevel = BehaviorFunctions.GetEcoEntityBindLevel(self.ecoMe)
end


function Behavior2030413:Update()
	if self.missionState == 0 then
		if self.bindLevel then
			BehaviorFunctions.AddLevel(self.bindLevel)
			self.missionState = 1
		end
	elseif self.missionState == 1 then
	end
end