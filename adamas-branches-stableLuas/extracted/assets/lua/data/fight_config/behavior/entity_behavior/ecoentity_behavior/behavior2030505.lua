Behavior2030505 = BaseClass("Behavior2030505",EntityBehaviorBase)

local BF = BehaviorFunctions
local FES = FightEnum.EntityState
local FK = FightEnum.KeyEvent
local FE = FightEnum
local FEAS = FightEnum.EntityAimState
local FEET = FightEnum.ElementType
local FEAET = FightEnum.AnimEventType
--电压陷阱
function Behavior2030505.GetGenerates()
	 local generates = {203050501,2030505001,2030505002}
	 return generates
end

function Behavior2030505:Init()
	self.me = self.instanceId
	self.entityId = 0
	self.battleTarget = nil
	self.bullet = nil
	self.ON = false
	self.role = 0
	self.target = {}
	self.targetNow = 0

	self.hackKey = 0

	self.randomShoot = false

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
	
	
	--骇入功能-电磁场相关
	self.myStateEnum =
	{
		default = 1, --默认状态
		inactive = 2,--未激活状态
		activated = 3,--已激活状态
		destroy = 4 --销毁状态
	}
	self.myState = self.myStateEnum.default
	--激活特效ID
	self.activatedEffect = nil
	--激活特效实体ID
	self.activatedEffectEntityID = 203050501
	
	self.target = {} --会被吸引的敌人
	self.targetNum = 0
	self.targetList = {} --会被吸引的目标
	
	self.checkRadius = 2.5 --电磁场检测范围
end


function Behavior2030505:LateInit()
	BehaviorFunctions.AddBuff(self.me,self.me,200001180)
	BehaviorFunctions.AddBuff(self.me,self.me,200001181)
	BehaviorFunctions.AddBuff(self.me,self.me,200001182)
end
	

function Behavior2030505:Update()

	self.frameNow = BehaviorFunctions.GetFightFrame()
	self.role = BehaviorFunctions.GetCtrlEntity()
	
end


--点击下侧按钮,爆炸
function Behavior2030505:HackingClickDown(instanceId)
	if instanceId == self.me then
		BehaviorFunctions.SetEntityValue(self.me,"follow_200001180",true) --摧毁前清除周围敌人的寻路
		BehaviorFunctions.SetEntityValue(self.me,"active_200001181",true)
		
	end
end

--点击右侧按钮,电磁场
function Behavior2030505:HackingClickRight(instanceId)
	if instanceId == self.me then
		
		if BehaviorFunctions.GetEntityValue(self.me,"active_200001182") == true then
			BehaviorFunctions.SetEntityValue(self.me,"active_200001182",false)
			BehaviorFunctions.SetEntityHackActiveState(self.me, false)
		else
			BehaviorFunctions.SetEntityValue(self.me,"active_200001182",true)
			BehaviorFunctions.SetEntityHackActiveState(self.me, true)
		end
		
	end
end

--点击左侧按钮，吸引敌人
function Behavior2030505:HackingClickLeft(instanceId)
	if instanceId == self.me then
		BehaviorFunctions.SetEntityValue(self.me,"active_200001180",true)
	end
end