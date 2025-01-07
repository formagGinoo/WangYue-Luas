Behavior100901 = BaseClass("Behavior100901",EntityBehaviorBase)

local BF = BehaviorFunctions
local FES = FightEnum.EntityState
local FK = FightEnum.KeyEvent
local FE = FightEnum
local FEAS = FightEnum.EntityAimState
local FEET = FightEnum.ElementType
local FEAET = FightEnum.AnimEventType

function Behavior100901.GetGenerates()
	local generates = {
		
	}
	return generates
end

function Behavior100901:Init()
	--变量声明
	self.Me = self.instanceId		--记录自己
	self.Player = BF.GetCtrlEntity()
	self.owner = BF.GetCtrlEntity() --获取祁玉
	self.FightFrame = BF.GetFightFrame()
	self.BuffFrame = BF.GetFightFrame()
	self.BuffTime = 0

end

function Behavior100901:Update()
	
	self.Player = BF.GetCtrlEntity() --持续获取当前角色
	self.FightFrame = BF.GetFightFrame()
	--绑定跟随角色Root节点
	if BF.CheckEntity(self.Me) then
		--local p = BehaviorFunctions.GetEntityTransformPos(self.Player,"Root")
		local i = BF.GetEntityTemplateId(self.Player)
		if i == 1007 then
			--BF.BindTransform(self.Me,"root",{x = 0, y = 0, z = 0},self.Player)
			BF.ResetBindTransform(self.Me, self.Player,"root")
		elseif i == 1002 then
			--BF.BindTransform(self.Me,"Role",{x = 0, y = 0, z = 0},self.Player)
			BF.ResetBindTransform(self.Me, self.Player,"Role")
		else	
			BF.ResetBindTransform(self.Me, self.Player,"Root")
		end
			
			
			
		--BehaviorFunctions.DoSetPosition(self.Me,p.x,p.y,p.z)
			if self.FightFrame - self.BuffFrame >= 60 then
				local L = BehaviorFunctions.GetEntitySkillLevel(self.owner,1009010)
				BF.DoMagic(self.owner,self.Player,100901001,L)
				self.BuffFrame = self.FightFrame
				self.BuffTime = self.BuffTime + 1
			end
	end
end

--在场角色命中给祁玉增加核心充能
function Behavior100901:Collide(attackInstanceId,hitInstanceId,instanceId,shakeStrenRatio,attackType,camp,skillType)
	--祁玉有perk2
	if BF.HasEntitySign(self.owner,10091003) and skillType == 2 then
	--local I = BF.GetEntityTemplateId(instanceId)
		if attackInstanceId == self.Player and attackInstanceId ~= self.owner then
			BF.ChangeEntityAttr(self.owner,1204,0.09,1)	--总1 
		end
	end
end
