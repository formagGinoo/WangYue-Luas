Behavior999901 = BaseClass("Behavior999901",EntityBehaviorBase)

function Behavior999901.GetGenerates()
	local generates = {}
	return generates
end

function Behavior999901.GetMagics()
	local generates = {900000008,900000009}
	return generates
end

local BF=BehaviorFunctions
--初始化，执行1帧
function Behavior999901:Init()
	
	--通用参数：
	self.me = self.instanceId
	
	--通用变量：
	self.skillCd = 15
	self.skillFrame = 0
	self.castSkill=0 --技能状态
	self.skillId = 92001004
	self.randomDirect=0
	
	
		
end

function Behavior999901:Update()
	
	
	
	--每一帧获取参数：
	self.battleTarget = BehaviorFunctions.GetCtrlEntity()--记录玩家
	self.battleTargetDistance = BehaviorFunctions.GetDistanceFromTarget(self.me,self.battleTarget)--记录玩家与目标之间的距离
	self.fightFrame = BehaviorFunctions.GetFightFrame()--记录世界的帧数计算
	self.myFrame = BehaviorFunctions.GetEntityFrame(self.me)--自己的帧数计算
	self.myState = BehaviorFunctions.GetEntityState(self.me)--记录自己的状态
	self.targetState = BehaviorFunctions.GetEntityState(self.battleTarget)--记录目标的状态
	self.groupSkillSign = BehaviorFunctions.GetEntityValue(self.me,"GroupSkill")--实体传值，2#传值
	self.LifeRatio = BehaviorFunctions.GetEntityAttrValueRatio(self.me,1001)
	
	if self.battleTarget ~= nil and BehaviorFunctions.CanCtrl(self.me) then--目标角色不为空，并且自身不处于异常状态下才能进行行为：能否行动
		--移动逻辑：
		if self.battleTargetDistance <=4 then
			
			BehaviorFunctions.StopMove(self.me)
			BehaviorFunctions.DoLookAtTargetByLerp(self.me,self.battleTarget,0,60,0.-1)
			
			--技能判断：技能状态+技能CD+角度+受击状态
			if self.castSkill ==0 and BehaviorFunctions.CompEntityLessAngle(self.me,self.battleTarget,40) and BehaviorFunctions.GetEntityState(self.battleTarget)~= FightEnum.EntityState.Hit and self.fightFrame >= self.skillFrame then
				self.castSkill =1
				BehaviorFunctions.CastSkillByTarget(self.me,self.skillId,self.battleTarget)
				self.skillFrame = self.fightFrame+self.skillCd*30
				self.castSkill =0
			end
			
			if BF.GetEntityState(self.me) ~= FightEnum.EntityState.Skill then
				if BF.GetSubMoveState(self.me) ~= FightEnum.EntityMoveSubState.WalkBack then
					BehaviorFunctions.DoSetMoveType(self.me,FightEnum.EntityMoveSubState.WalkBack)
				end
			end
			
		
		elseif self.battleTargetDistance >4 and self.battleTargetDistance <=10 then
			
			BehaviorFunctions.DoLookAtTargetByLerp(self.me,self.battleTarget,0,60,0.-1)--持续面朝向玩家
			
			
			
			if self.randomDirect == 0 then
				self.randomDirect = BehaviorFunctions.Random(1,2)
			end
			

			
			if BF.GetSubMoveState(self.me) ~= FightEnum.EntityMoveSubState.WalkRight then--如果不在右走状态
				if self.randomDirect == 1 then
					BehaviorFunctions.DoSetMoveType(self.me,FightEnum.EntityMoveSubState.WalkRight)
				end				
			end
			
			if BF.GetSubMoveState(self.me) ~= FightEnum.EntityMoveSubState.WalkLeft then--如果不在左走状态
				if self.randomDirect == 2 then
					BehaviorFunctions.DoSetMoveType(self.me,FightEnum.EntityMoveSubState.WalkLeft)
				end
			end
			
			
			
		elseif self.battleTargetDistance >10 then
			
			if BehaviorFunctions.GetSubMoveState(self.me) ~= FightEnum.EntityMoveSubState.Run then
				BehaviorFunctions.DoSetMoveType(self.me,FightEnum.EntityMoveSubState.Run)
				BehaviorFunctions.DoLookAtTargetByLerp(self.me,self.battleTarget,0,60,0.-1)	
				self.randomDirect = 0
			end	
		end
			
			
	end	
	
	function Behavior999901:CastSkill(instanceId,skillId,skillSign,skillType)
		
		
		--如果玩家释放闪避，则逼近玩家：
		if instanceId == self.battleTarget and skillSign == 1 and BF.GetEntityState(self.me) ~= FightEnum.EntityState.Skill  then
			BF.CastSkillByTarget(self.me,92001008,self.battleTarget)
		end
		
		--如果玩家释放普攻、技能或者大招，则反击玩家：
		if instanceId == self.battleTarget and BF.GetEntityState(self.me) ~= FightEnum.EntityState.Skill  then
			
			
			if  skillSign == 1 or skillSign == 10 or skillSign == 20 or skillSign == 70 then
				BF.CastSkillByTarget(self.me,92001010,self.battleTarget)
			end
		end
		
	end
	
	
	 
	
end