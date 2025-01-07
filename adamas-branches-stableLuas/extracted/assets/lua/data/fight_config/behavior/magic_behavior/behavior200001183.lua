Behavior200001183 = BaseClass("Behavior200001183",EntityBehaviorBase)

local BF = BehaviorFunctions
local FES = FightEnum.EntityState
local FK = FightEnum.KeyEvent
local FE = FightEnum
local FEAS = FightEnum.EntityAimState
local FEET = FightEnum.ElementType
local FEAET = FightEnum.AnimEventType
local FEEAT = FightEnum.EAttackType


function Behavior200001183.GetGenerates()


end

function Behavior200001183.GetMagics()
	local generates = {200001184,90004001}
	return generates
end

function Behavior200001183:Init()
	self.active = false --是否激活当前功能
	
	
	self.me = self.instanceId
	self.target = {} --会被吸引的敌人
	self.targetNum = 0
	self.targetList = {} --会被吸引的目标
	
	self.active = false
	
	self.curTarget = BF.GetEntityValue(self.me,"battleTarget")
	self.battleTarget = nil
	
	self.battleTargetList = {}
	
	self.frame = 0
	self.frameNext = 0
	self.frameTime = 900
	self.frameKey = false
	
	self.frameSelf = 0
	self.frameSelfNext = 0
	self.frameSelfTime = 60
	self.frameSelfKey = false
end


function Behavior200001183:Update()
	self.role = BehaviorFunctions.GetCtrlEntity()
	self.active = BehaviorFunctions.GetEntityValue(self.me,"active_200001183")
	self.campChange = BehaviorFunctions.GetEntityValue(self.me,"camp_200001183")
	

	if not self.me then	
	elseif self.me then
		if self.active then
			self.frame = BehaviorFunctions.GetFightFrame()
			self.frameSelf =BehaviorFunctions.GetFightFrame()
			if self.frameKey == false then
				self.frameKey = true
				
				
				self.frameNext = self.frame + self.frameTime
				
				
			end
			
			if self.frameSelfKey == false then
				self.frameSelfKey = true
				
				
				self.frameSelfNext = self.frameSelf + self.frameSelfTime
			end
			
			if self.frame < self.frameNext then
				--判断自己是不是怪物
				if BehaviorFunctions.GetNpcType(self.me) == FightEnum.EntityNpcTag.Monster then

					--设置阵营
					
					if  self.campChange ~= BehaviorFunctions.GetCampType(self.me) then
						self.camp = BehaviorFunctions.GetCampType(self.me)
						 BehaviorFunctions.ChangeCamp(self.me,self.campChange)
						BehaviorFunctions.SetLookIKEnable(self.me,false)
					end

					----获取角色锁定目标
					--self.LockTarget = BehaviorFunctions.GetEntityValue(self.role,"LockTarget")
					--self.AttackTarget = BehaviorFunctions.GetEntityValue(self.role,"AttackTarget")
					--self.LockAltnTarget = BehaviorFunctions.GetEntityValue(self.role,"LockAltnTarget")

					----确定攻击目标
					----如果角色没有锁定的目标，则搜索距离自己最近的目标，如果角色有锁定的目标，则跟着角色攻击
					--if BehaviorFunctions.CheckEntity(self.LockTarget) and self.LockTarget ~= self.me then
					--self.battleTarget = self.LockTarget
					--elseif BehaviorFunctions.CheckEntity(self.AttackTarget) and self.AttackTarget ~= self.me then
					--self.battleTarget = self.AttackTarget
					--elseif BehaviorFunctions.CheckEntity(self.AttackAltnTarget) and self.AttackAltnTarget ~= self.me then
					--self.battleTarget = self.AttackAltnTarget
					--else
					local distance
					self.AllTargetList = BehaviorFunctions.SearchNpcList(self.me, 20, FightEnum.EntityCamp.Camp2 , {FightEnum.EntityNpcTag.Monster,FightEnum.EntityNpcTag.Player},nil,nil,false)
					--self.AllTargetList = BehaviorFunctions.SearchEntities(self.me,20,0,360,{FightEnum.EntityCamp.Camp2,FightEnum.EntityCamp.Camp3},nil,nil,1004,1,0,nil,false,true,0,0,false,false,false)
					if next(self.AllTargetList) then
						--存在实体
 						if BehaviorFunctions.CheckEntity(self.AllTargetList[1]) then
							local minValue = 10
							local minIndex
							for i=1,#self.AllTargetList do
								--得到目标和角色的距离
								distance = BF.GetDistanceFromTarget(self.me,self.AllTargetList[i])
								--	distance = BF.GetDistanceFromTarget(self.me,v[1],false)
								--不断遍历最小值
								if distance < minValue and self.AllTargetList[i] ~= self.me then
									minValue = distance
									minIndex = self.AllTargetList[i]
								end
								--返回最近的目标
								self.battleTarget = minIndex
							end
						end
					else
						self.AllTargetList = BehaviorFunctions.SearchNpcList(self.me, 20, FightEnum.EntityCamp.Camp1 , {FightEnum.EntityNpcTag.Monster,FightEnum.EntityNpcTag.Player},nil,nil,false)
						if next(self.AllTargetList) then
							--存在实体
							if BehaviorFunctions.CheckEntity(self.AllTargetList[1]) then
								local minValue = 10
								local minIndex
								for i=1,#self.AllTargetList do
									--得到目标和角色的距离
									distance = BF.GetDistanceFromTarget(self.me,self.AllTargetList[i])
									--	distance = BF.GetDistanceFromTarget(self.me,v[1],false)
									--不断遍历最小值
									if distance < minValue and self.AllTargetList[i] ~= self.me then
										minValue = distance
										minIndex = self.AllTargetList[i]
									end
									--返回最近的目标
									self.battleTarget = minIndex
								end
							end
						end
					end
					
					
					--end

					if self.battleTarget then
						BehaviorFunctions.SetEntityValue(self.me,"battleTarget",self.battleTarget)
						--BehaviorFunctions.ShowWarnAlertnessUI(self.me, true)
					else
						if self.frameSelf > self.frameSelfNext then
							BehaviorFunctions.DoMagic(self.me,self.me,200001184,nil,nil,nil,self.me,nil)
							self.frameSelfNext = self.frameSelf + self.frameSelfTime
							self.frameSelfKey = false
							--BehaviorFunctions.ShowWarnAlertnessUI(self.me, true)
						end
						
					end


					--BehaviorFunctions.SetEntityValue(self.me,"active_200001183",false)

				end
			else
				self.battleTarget = nil
				BehaviorFunctions.SetEntityValue(self.me,"battleTarget",nil)
				BehaviorFunctions.SetEntityValue(self.me,"active_200001183",false)
				BehaviorFunctions.ChangeCamp(self.me,self.camp)
				BehaviorFunctions.SetLookIKEnable(self.me,true)

				if next(self.battleTargetList) then
					for i = 1, #self.battleTargetList do
						if self.battleTargetList[i] and BehaviorFunctions.CheckEntity(self.battleTargetList[i]) then
							BehaviorFunctions.SetEntityValue(self.battleTargetList[i],"battleTarget",nil)
						end
					end
				end

				--BehaviorFunctions.ShowWarnAlertnessUI(self.me,false)
				
			end
		end
		
		
		
	end
	

		

end


function Behavior200001183:RemoveBuff(entityInstanceId, buffInstanceId,buffId)
	if buffId == 40022002 and entityInstanceId == self.me then
		BehaviorFunctions.SetLookIKEnable(self.me,true)
		BehaviorFunctions.ChangeCamp(self.me,2)
		BehaviorFunctions.SetEntityValue(self.me,"battleTarget",self.curTarget)
	end
end


function BehaviorBase:Hit(attackInstanceId,hitInstanceId,hitType,camp)
	if attackInstanceId == self.me and hitInstanceId ~= self.role then
		BehaviorFunctions.SetEntityValue(hitInstanceId,"battleTarget",self.me)
		if next(self.battleTargetList) then
			for i = 1, #self.battleTargetList do
				if hitInstanceId ~= self.battleTargetList[i] then
					table.insert(self.battleTargetList,hitInstanceId)
				end
			end
		else
			table.insert(self.battleTargetList,hitInstanceId)
		end

		
	end
end