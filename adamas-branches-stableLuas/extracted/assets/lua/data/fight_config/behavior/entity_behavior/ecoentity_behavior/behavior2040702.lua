Behavior2040702 = BaseClass("Behavior2040702",EntityBehaviorBase)
--实机演示大平原流程实体

function Behavior2040702.GetGenerates()
	local generates = {2030701}
	return generates
end

function Behavior2040702:Init()
	--self.me = self.instanceId
	--self.role = BehaviorFunctions.GetCtrlEntity()
	--self.missionState = 0
	--self.coreState = 0
	--self.yuState = 0
	--self.aniState = 0
	--self.yuId = 0
	--self.roleTemId = 0
	--self.MP1 = 0
	--self.MP2 = 0
	--self.Pos1 = 0
	--self.Pos2 = 0
	--self.moveFlag = false
	--self.Flag1 = 0
	
	--self.ecoList1 = {
		--[1] = {ecoId = 2002101010001}, 						--宝箱
		--[2] = {ecoId = 4002101010101,tag = "Monster"},
		--[3] = {ecoId = 4002101010102,tag = "Monster"},
		--[4] = {ecoId = 4002101010103,tag = "Monster"},
		--[5] = {ecoId = 4002101010104,tag = "Monster"},  --从士弓
		--}
	--self.ecoList2 = {
		--[1] = {ecoId = 4002101010111,routePos = "PY02Route2",instanceId = 0,tag = "Monster"}, --火
		--[2] = {ecoId = 4002101010112,routePos = "PY02Route3",instanceId = 0,tag = "Monster"}, --飞
		--[3] = {ecoId = 4002101010113,routePos = "PY02Route1",instanceId = 0,tag = "Monster"}, --冰
		--}
	--self.ecoList3 = {
		--[1] = {ecoId = 2002101010002}, 						--宝箱
		--[2] = {ecoId = 2002101010003}, 						--bomb
		--[3] = {ecoId = 4002101010121,routePos = "PY03Route11",instanceId = 0,tag = "Monster"},
		--[4] = {ecoId = 4002101010122,tag = "Monster"},
		--[5] = {ecoId = 4002101010123,tag = "Monster"},
		--[6] = {ecoId = 4002101010124,tag = "Monster"},
		--[7] = {ecoId = 4002101010125,tag = "Monster"},
		--[8] = {ecoId = 4002101010126,tag = "Monster"},
		--[9] = {ecoId = 4002101010127,tag = "Monster"},
		--[10] = {ecoId = 4002101010128,tag = "Monster"},
		--}
	--self.ecoList4 = {
		--[1] = {ecoId = 4002101010131,tag = "Monster"},
		--[2] = {ecoId = 4002101010132,tag = "Monster"},
		--}
	--self.ecoList5 = {
		--[1] = {ecoId = 4002101010141,tag = "Monster"}, --石龙
		--[2] = {ecoId = 4002101010142,tag = "Monster"},
		--[3] = {ecoId = 4002101010143,tag = "Monster"},
		--}
	--self.instanceList1 = {}
	--self.instanceList2 = {}
	--self.instanceList3 = {}
	
	--self.createState1 = 0
	--self.createState2 = 0
	--self.createState3 = 0
	
	--self.areaEnter1 = false
	--self.areaEnter2 = false
	--self.showSelf = false
	--self.areaEnter4 = false
	
	----BehaviorFunctions.ChangeEcoEntityCreateState(3002101010001,false)
end

function Behavior2040702:Update()
	--self.time = BehaviorFunctions.GetFightFrame()
	--self.role = BehaviorFunctions.GetCtrlEntity()
	--self.roleTemId = BehaviorFunctions.GetEntityTemplateId(self.role)
	------路牌的显隐
	----if self.showSelf == false then
		----if not BehaviorFunctions.HasBuffKind(self.me,200000101) then
			----BehaviorFunctions.AddBuff(self.me,self.me,200000101)
		----end
		----self.showSelf = true
	----end
	--if self.aniState == 0 then
		--if BehaviorFunctions.GetEcoEntityByEcoId(4002101010131) then
			--local instanceId1 = BehaviorFunctions.GetEcoEntityByEcoId(4002101010131)
			--BehaviorFunctions.PlayAnimation(instanceId1,"Sit")
			--self.aniState = 1
		--end
	--end
	
	--if self.coreState == 0  then
			----设置玩家能量条
			--BehaviorFunctions.SetEntityAttr(self.role,1204,3)
			----打开核心UI
			--BehaviorFunctions.SetCoreUIEnable(self.role,true)
			--self.coreState = 1
	--end
	
	--if self.moveFlag == true then
		--self:MovePlatform(self.MP1,-0.3)
		--self:MovePlatform(self.MP2,0.3)
		--if self.Flag1 == 0 then
			--BehaviorFunctions.DoMove(self.MP1,-0.3,0)
			--BehaviorFunctions.DoMove(self.MP2,0.3,0)
		--end
		
		--if self.Flag1 == 1 then
			--BehaviorFunctions.DoMove(self.MP1,0.3,0)
			--BehaviorFunctions.DoMove(self.MP2,-0.3,0)
		--end
	--end
	
	--if self.missionState == 0 then
		
		--self.missionState = 2
	
	--elseif self.missionState == 20 then
		--self:SetPatrol(self.ecoList2)
		--self.missionState = 25
		
	--elseif self.missionState == 30 then
		----多点巡逻
		--local instanceId = BehaviorFunctions.GetEcoEntityByEcoId(4002101010121)
		--local startPos = BehaviorFunctions.GetPositionP(instanceId)
		--local routePos1 = BehaviorFunctions.GetTerrainPositionP("PY03Route11",10020001,"LogicPY01")
		--local routePos2 = BehaviorFunctions.GetTerrainPositionP("PY03Route12",10020001,"LogicPY01")
		--local routePos3 = BehaviorFunctions.GetTerrainPositionP("PY03Route13",10020001,"LogicPY01")
		--local patrolPosList = {startPos,routePos1,routePos2,routePos3}	
		--BehaviorFunctions.SetEntityValue(instanceId,"peaceState",1)  -- 1是巡逻
		--BehaviorFunctions.SetEntityValue(instanceId,"patrolPositionList",patrolPosList)
		--BehaviorFunctions.SetEntityValue(instanceId,"canReturn",true)
		
		--local instanceId4 = BehaviorFunctions.GetEcoEntityByEcoId(4002101010122)
		--local instanceId5 = BehaviorFunctions.GetEcoEntityByEcoId(4002101010127)
		--BehaviorFunctions.PlayAnimation(instanceId4,"Sit")
		--BehaviorFunctions.PlayAnimation(instanceId5,"Sit")
		--self.missionState = 35
		
	--elseif self.missionState == 40 then
		--local instanceId7 = BehaviorFunctions.GetEcoEntityByEcoId(self.ecoList5[1].ecoId)
		--local instanceId8 = BehaviorFunctions.GetEcoEntityByEcoId(self.ecoList5[2].ecoId)
		--local instanceId9 = BehaviorFunctions.GetEcoEntityByEcoId(self.ecoList5[3].ecoId)
		--BehaviorFunctions.SetEntityValue(instanceId7,"haveWarn",false)
		--BehaviorFunctions.SetEntityValue(instanceId8,"haveWarn",false)
		--BehaviorFunctions.SetEntityValue(instanceId9,"haveWarn",false)
		--self.missionState = 45
	--end
		
	--if self.yuState == 0 then
		--if BehaviorFunctions.GetEcoEntityByEcoId(3002101010001) and self.yuPos then
			--self.yuId = BehaviorFunctions.GetEcoEntityByEcoId(3002101010001)
			--BehaviorFunctions.DoSetPosition(self.yuId,self.yuPos.x,self.yuPos.y,self.yuPos.z)
			--self.yuState = 1
		--end
	--end
	
	----if self.createState1 == 0 then
		----for k,v in pairs(self.ecoList1) do
			----if #self.instanceList1 == 4 then
				----self.createState1 = 1
			----end
			
			----if BehaviorFunctions.GetEcoEntityState(v.ecoId) == false then
				----BehaviorFunctions.ChangeEcoEntityCreateState(v.ecoId,true)
			----end
			
			----if v.tag == "Monster" and BehaviorFunctions.GetEcoEntityByEcoId(v.ecoId) then
				----local instanceId = BehaviorFunctions.GetEcoEntityByEcoId(v.ecoId)
				----table.insert(self.instanceList1,instanceId)
			----end
		----end
	----end
end

function Behavior2040702:Die(attackInstanceId,instanceId)

end

function Behavior2040702:Death(instanceId,isFormationRevive)
	--角色死亡判负
	if isFormationRevive then
		
	end
end
	
--往返巡逻
function Behavior2040702:SetPatrol(ecoList)
	--for i,v in pairs(ecoList) do
		--local instanceId = BehaviorFunctions.GetEcoEntityByEcoId(v.ecoId)
		--ecoList[i].instanceId = instanceId
		--if v.routePos then
			--local patrolPosList = {}
			--local routePos = BehaviorFunctions.GetTerrainPositionP(v.routePos,10020001,"LogicPY01")
			--local startPos = BehaviorFunctions.GetPositionP(v.instanceId)
			--patrolPosList = {startPos,routePos}
			--BehaviorFunctions.SetEntityValue(v.instanceId,"peaceState",1)  -- 1是巡逻
			--BehaviorFunctions.SetEntityValue(v.instanceId,"patrolPositionList",patrolPosList)
			--BehaviorFunctions.SetEntityValue(v.instanceId,"canReturn",true)
		--end
	--end
end

function Behavior2040702:EnterArea(triggerInstanceId, areaName, logicName)
	----if triggerInstanceId == self.role and areaName == "PY01Enter" then

			----if BehaviorFunctions.GetEcoEntityByEcoId(4002101010132) then
				----local instanceId2 = BehaviorFunctions.GetEcoEntityByEcoId(4002101010132)
				----BehaviorFunctions.PlayAnimation(instanceId2,"Sit")
			----end
			----self.aniState = 1
		----end
	----end
	--if triggerInstanceId == self.role and areaName == "PY02Enter" then
		--if self.areaEnter1 == false then
			--self.missionState = 20
			--self.areaEnter1 = true
		--end
	--end
	
	--if triggerInstanceId == self.role and areaName == "PY03Enter" then
		--if self.areaEnter2 == false then
			--self.missionState = 30
			--self.areaEnter2 = true
		--end
	--end
	
	--if triggerInstanceId == self.role and areaName == "PY04Enter" then
		--if self.areaEnter4 == false then
			--self.areaEnter4 = true
			--self.missionState = 40
		--end
		
		--if not BehaviorFunctions.HasBuffKind(self.role,1000100) then
			--BehaviorFunctions.AddBuff(self.role,self.role,1000100)
		--end
		
		----if self.MP1 == 0 and self.MP2 == 0 then
			----self.Pos1 = BehaviorFunctions.GetTerrainPositionP("MP1",10020001,"LogicPY01")
			----self.endPos1 = Vec3.New(self.Pos1.x-40,self.Pos1.y,self.Pos1.z)
			----self.Pos2 = BehaviorFunctions.GetTerrainPositionP("MP2",10020001,"LogicPY01")
			----self.endPos2 = Vec3.New(self.Pos2.x+40,self.Pos2.y,self.Pos2.z)
			----self.MP1 = BehaviorFunctions.CreateEntity(2030701,nil,self.Pos1.x,self.Pos1.y,self.Pos1.z)
			----self.MP2 = BehaviorFunctions.CreateEntity(2030701,nil,self.Pos2.x,self.Pos2.y,self.Pos2.z)
			----self.moveFlag = true
		----end
	--end
end

function Behavior2040702:ExitArea(triggerInstanceId, areaName, logicName)
	--if triggerInstanceId == self.role and areaName == "PY04Enter" then
		--if BehaviorFunctions.HasBuffKind(self.role,1000100) then
			--BehaviorFunctions.RemoveBuff(self.role,1000100)
		--end
	--end
end

--从士弓掉落处理
function Behavior2040702:Die(attackInstanceId,dieInstanceId)
	--local instanceId = BehaviorFunctions.GetEcoEntityByEcoId(4002101010104)
	--if dieInstanceId == instanceId then
		--self.yuPos = BehaviorFunctions.GetPositionP(dieInstanceId)
		--if not BehaviorFunctions.GetEcoEntityByEcoId(3002101010001) then
			--BehaviorFunctions.ChangeEcoEntityCreateState(3002101010001,true)
		--end
	--end	
end

--刺杀结束
function Behavior2040702:FinishSkill(instanceId,skillId,skillSign,skillType)
	--if skillId == 62001006 and self.aniState == 1 then
		--local instanceId1 = BehaviorFunctions.GetEcoEntityByEcoId(4002101010131)
		--BehaviorFunctions.SetEntityValue(instanceId1,"haveWarn",false)
		--self.aniState = 2
	--end
end

--移动平台
function Behavior2040702:MovePlatform(instanceId)
	--if instanceId == self.MP1 then
		--local pos1 = BehaviorFunctions.GetPositionP(instanceId)
		--local dis1 = BehaviorFunctions.GetDistanceFromPos(pos1,self.Pos1)
		--local dis11 = BehaviorFunctions.GetDistanceFromPos(pos1,self.endPos1)
		--if dis1 < 0.3 then
			--self.Flag1 = 0
		--end
		
		--if dis11 < 0.3 then
			--self.Flag1 = 1
		--end
	--end
	
	--if instanceId == self.MP2 then
		--local pos2 = BehaviorFunctions.GetPositionP(instanceId)
		--local dis2 = BehaviorFunctions.GetDistanceFromPos(pos2,self.Pos2)
		--local dis21 = BehaviorFunctions.GetDistanceFromPos(pos2,self.endPos2)
		--if dis2 < 0.3 then
			--self.Flag1 = 0
		--end
		--if dis21 < 0.3 then
			--self.Flag1 = 1
		--end
	--end
end
	