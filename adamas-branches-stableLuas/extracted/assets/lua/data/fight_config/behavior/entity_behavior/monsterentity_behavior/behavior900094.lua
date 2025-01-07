
Behavior900094 = BaseClass("Behavior900094",EntityBehaviorBase)

--第三只巡逻


--资源预加载
local BF = BehaviorFunctions
local FES = FightEnum.EntityState
local FK = FightEnum.KeyEvent
local FE = FightEnum
local FEAS = FightEnum.EntityAimState
local FEET = FightEnum.ElementType
local FEAET = FightEnum.AnimEventType

function Behavior900094.GetGenerates()
	local generates = {}
	return generates
end


function Behavior900094:Init()
	self.me = self.instanceId
	self.missionState = 0
	self.walk = false
	self.insay = false
end

function Behavior900094:Update()
	self.role = BehaviorFunctions.GetCtrlEntity()
	local firstPos = BehaviorFunctions.GetTerrainPositionP("XW41",10020004,"PV999")
	local sayPos = BehaviorFunctions.GetTerrainPositionP("XW42",10020004,"PV999")
	local lastPos = BehaviorFunctions.GetTerrainPositionP("XW43",10020004,"PV999")
	
	local myPos = BehaviorFunctions.GetPositionP(self.me)
	
	local sayDis = BehaviorFunctions.GetDistanceFromPos(myPos,sayPos)
	local endDis = BehaviorFunctions.GetDistanceFromPos(myPos,lastPos)

	--local distance = BehaviorFunctions.GetDistanceFromTarget(self.me,self.role)
	----店长跟着玩家
	--if distance > 4 then
		--BehaviorFunctions.SetPathFollowEntity(self.me,self.role)
		--if BehaviorFunctions.GetEntityState(self.me) ~= FightEnum.EntityState.Move then
			--BehaviorFunctions.DoSetEntityState(self.me,FightEnum.EntityState.Move)
		--end
	--elseif distance <= 4 then
		--BehaviorFunctions.StopMove(self.me)
		--BehaviorFunctions.DoLookAtTargetImmediately(self.me,self.role)
	--end
	
	--起始点走到对话点
	if  (not self.walk) and self.missionState == 0 then
		BehaviorFunctions.SetPathFollowPos(self.me,sayPos)
		if BehaviorFunctions.GetEntityState(self.me) ~= FightEnum.EntityState.Move then
			BehaviorFunctions.DoSetEntityState(self.me,FightEnum.EntityState.Move)
			self.walk = true
			self.missionState = 1 
		end
	end
	
	--走到对话点停下
	if self.missionState == 1 and  sayDis < 0.5 then
		BehaviorFunctions.StopMove(self.me)
		BehaviorFunctions.DoLookAtPositionImmediately(self.me,sayPos.x,sayPos.y,sayPos.z,true)
		self.walk = false
		self.missionState = 2
	end

	--对话完播alert
	--if self.missionState == 2 then
		--if not self.inAlert then
			--BehaviorFunctions.CastSkillBySelfPosition(self.me,90009004)
			--self.inAlert = true
		--end
	--end
	
	----对话
	--if self.missionState == 3 and not self.insay then
		--BehaviorFunctions.StartStoryDialog(601011401)
		--self.insay = true
	--end
	
	
	
	--对话点走到终点
	if self.missionState == 4 and self.walk == false then
		BehaviorFunctions.DoLookAtPositionImmediately(self.me,lastPos.x,lastPos.y,lastPos.z,true)
		BehaviorFunctions.SetPathFollowPos(self.me,lastPos)
		if BehaviorFunctions.GetEntityState(self.me) ~= FightEnum.EntityState.Move then
			BehaviorFunctions.DoSetEntityState(self.me,FightEnum.EntityState.Move)
			self.walk = true
			self.missionState = 5
		end
	end
	
	if self.missionState== 5 and  endDis < 0.5 then
		BehaviorFunctions.StopMove(self.me)
		self.walk = false
		self.missionState = 6
	end
end
	
function Behavior900094:StoryEndEvent(dialogId)
	if dialogId == 601011401 then
		BehaviorFunctions.CastSkillBySelfPosition(self.me,90009004)
	end
end
	
function Behavior900094:FinishSkill(instanceId,skillId,skillSign,skillType)
	if skillId == 90009004 then
		self.missionState = 4
	end
end
