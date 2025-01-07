RoleAiBase = BaseClass("RoleAiBase",EntityBehaviorBase)

local BF = BehaviorFunctions

--角色Ai组合
function RoleAiBase:Init()

	self.Me = self.instanceId	--记录自己
	--通用参数组合初始化
	self.RoleAllParm = self.MainBehavior.RoleAllParm --获取主lua组合
	self.RoleAllBehavior = self.ParentBehavior 		 --获取上一级组合
	self.RAP = self.RoleAllParm
	self.RAB = self.RoleAllBehavior

	self.AiLevel = 1	--AI等级/熟练度
	
	self.FirstAim = ""		--行为模式
	self.SecondAim = ""		--次要行为模式
	self.Role1Position = {}             		--当前控制角色坐标
	self.Role1Distance = 0              		--当前控制角色距离
	self.Role1NormalFollowActiveDistance = 3   	--当前角色常态跟随激活距离
	self.Role1NormalFollowCancelDistance = 1.8	--当前角色常态跟随取消距离
	self.Role1FightFollowActiveDistance = 15   	--当前角色战斗跟随激活距离
	self.Role1FightFollowCancelDistance = 5		--当前角色战斗跟随取消距离

	self.FightTarget = 0						--战斗目标
	self.FightTargetPart = 0					--战斗目标部位
	self.FightTargetPosition = {}				--战斗目标坐标
	self.FightTargetDistance = 0				--战斗目标距离
	self.FightType = ""							--战斗类型

	self.FollowTarget = 0						--跟随目标
	self.FollowTargetPosition = {}				--跟随目标坐标
	self.FollowTargetDistance = 0				--跟随目标距离
	self.FollowType = ""						--跟随类型
	self.FollowActiveDistance = 0				--跟随激活距离
	self.FollowCancelDistance = 0				--跟随取消距离

	--权重类型参数
	self.FollowMoveProbability = 150	--跟随进行闪避概率
	self.FollowMoveResRatio = 5500		--跟随进行闪避当前资源比率底线
	self.FollowMoveJudgeFrame = 0		--跟随进行闪避判断间隔时间

	self.FollowShiftSkillProbability = 800 --跟随进行位移技能概率
	
end

function RoleAiBase:Update(Purpose)

	--组合缩写
	self.RAP = self.RoleAllParm
	
	----关卡逻辑点施加参考
	--if not BF.HasEntitySign(目标角色,10000017) and self.KaiGuan == 0 then
		--BF.AddEntitySign(目标角色,10000017,-1)
		--local p1 = BF.ConvertToP(104,88,88)
		--local p2 = BF.ConvertToP(94,88,81)
		--local p3 = BF.ConvertToP(109,88,65)
		----........
		--BF.SetEntityValue(目标角色,"LevelMovePositon",{p1,p2,p3})
		--self.KaiGuan = 1
	--end
	
	--关卡逻辑点移动判断
	if BF.CheckEntityForeground(self.Me) and BF.CanCtrl(self.Me) and BF.HasEntitySign(self.Me,10000018) and self.RAP.LevelMovePosition ~= 0 then
		for i = 1,#self.RAP.LevelMovePosition,1 do
			--如果目标点存在
			if self.RAP.LevelMovePosition[i] ~= 1 then
				local D = BF.GetDistanceFromPos(self.RAP.MyPos,self.RAP.LevelMovePosition[i])
				local M = BF.GetSubMoveState(self.Me)
				--自身与目标点距离判断
				if D > 1 then
					if M ~= FightEnum.EntityMoveSubState.Run then
						BF.DoSetMoveType(self.Me,FightEnum.EntityMoveSubState.Run)
						self.RAP.LeisurelyIdleChangeFrame = self.RAP.RealFrame + 150
					end
					BF.DoLookAtPositionByLerp(self.Me,self.RAP.LevelMovePosition[i].x,self.RAP.LevelMovePosition[i].y,self.RAP.LevelMovePosition[i].z,1,300,0)
					break
				elseif D <= 1 then
					if i == #self.RAP.LevelMovePosition then
						BF.StopMove(self.Me)
					end
					self.RAP.LevelMovePosition[i] = 1
					break
				end
			end
		end
		local n = 0
		--关卡点移动结束判断
		for i = 1, #self.RAP.LevelMovePosition,1 do
			--路径达成计数
			if self.RAP.LevelMovePosition[i] == 1 then
				n = n + 1
			end
			--全部路径达成，移除关卡移动标记，清空路径点
			if n == #self.RAP.LevelMovePosition then
				BF.RemoveEntitySign(self.Me,10000018)
				self.RAP.LevelMovePosition = 0
			end
		end	
	end
	
	local d1 = 0
	--AI逻辑判断
	if BF.CheckEntity(self.Me) and self.RAP.Role1 ~= self.Me and BF.CheckEntityForeground(self.Me) and not BF.HasEntitySign(self.Me,10000017) 
		and not BF.HasEntitySign(self.Me,10000018) and BF.HasEntitySign(self.Me,10000004) then

		--记录当前操控角色、坐标、距离
		if BF.CheckEntity(self.RAP.Role1) then
			self.Role1Position = BF.GetPositionP(self.RAP.Role1)
			self.Role1Distance = BF.GetDistanceFromTarget(self.Me,self.RAP.Role1)
		else
			self.Role1Position = {}
			self.Role1Distance = 0
		end

		--自身攻击目标判断
		if self.RAP.AttackTarget == 0 or self.RAP.AttackTarget == nil then
			--备用目标存在则设置为攻击目标
			if self.RAP.SecondTarget ~= 0 and self.RAP.SecondTarget ~= nil then
				self.RAP.AttackTarget = self.RAP.SecondTarget
				self.RAP.AttackTargetPart = self.RAP.SecondTargetPart
			end
		end
		
		--筛选战斗目标
		if BF.CheckEntity(self.RAP.Role1) and BF.CheckEntity(self.RAP.AttackTarget)
			and BF.GetDistanceFromTarget(self.RAP.Role1,self.RAP.AttackTarget) < self.Role1FightFollowActiveDistance then
			self.FightTarget = self.RAP.AttackTarget
			self.FightTargetPart = self.RAP.AttackTargetPart
			self.FightTargetPosition = BF.GetPositionP(self.FightTarget)
			self.FightTargetDistance = BF.GetDistanceFromTarget(self.Me,self.FightTarget)
		elseif BF.CheckEntity(self.RAP.Role1) and BF.CheckEntity(self.RAP.AttackTarget)
			and BF.GetDistanceFromTarget(self.RAP.Role1,self.RAP.AttackTarget) >= self.Role1FightFollowActiveDistance then
			--所有搜索目标合集：半径15，0-360角度，2阵营，1类型(Npc)，无存在buff，无不存在buff，1距离权重,1角度权重，Npc标签
			local a = BF.SearchEntities(self.Me,15,0,360,2,1,nil,1004,1,1,nil,false,1,1,false,true)
			if BF.CheckEntity(a[1][1]) and BF.GetDistanceFromTarget(self.RAP.Role1,a[1][2]) < self.Role1FightFollowActiveDistance then
				self.FightTarget = a[1][1]
				self.FightTargetPart = a[1][2]
				self.FightTargetPosition = BF.GetPositionP(a[1][1])
				self.FightTargetDistance = BF.GetDistanceFromTarget(self.Me,a[1][1])
			else
				self.FightTarget = 0
				self.FightTargetPart = 0
				self.FightTargetPosition = 0
				self.FightTargetDistance = 0
			end
		else
			self.FightTarget = 0
			self.FightTargetPart = 0
			self.FightTargetPosition = 0
			self.FightTargetDistance = 0
		end
		
		--行为模式判断
		if self.RAP.Role1 ~= 0 and self.RAP.Role1 ~= nil and (self.FightTarget == 0 or self.FightTarget == nil) then
			--设置一般跟随参数
			self.FirstAim = "Follow"
			self.FollowTarget = self.RAP.Role1
			self.FollowTargetPosition = self.Role1Position
			self.FollowTargetDistance = self.Role1Distance
			self.FollowActiveDistance = self.Role1NormalFollowActiveDistance
			self.FollowCancelDistance = self.Role1NormalFollowCancelDistance	
		--存在攻击目标且在战斗范围内，则设置自身为战斗状态
		elseif BF.CheckEntity(self.FightTarget) then
			self.FirstAim = "Fight"
			--设置战斗跟随参数
			self.FollowTarget = self.FightTarget
			self.FollowTargetPosition = self.FightTargetPosition
			self.FollowTargetDistance = self.FightTargetDistance
			self.FollowActiveDistance = self.MainBehavior.FightCancelDistance
			self.FollowCancelDistance = self.MainBehavior.FightActiveDistance
		end

		--行为模式为战斗时，判断战斗状态
		if self.FirstAim == "Fight" and self.FightTarget ~= 0 and self.FightTarget ~= nil then
			--默认设置为战斗中状态，判断目标距离小于战斗取消距离，则继续战斗
			if self.FightTargetDistance < self.FollowActiveDistance and (self.FightType == "" or self.FightType == "Fighting") then
				self.FightType = "Fighting"

				self:RunStep(Purpose)
				
			--战斗目标距离过远时战斗类型改为战斗跟随
			elseif self.FightTargetDistance >= self.FollowActiveDistance and self.FightType ~= "FightFollow" then
				self.FightType = "FightFollow"
				self.RAP.ClickButton[1] = 0
				self.RAP.ClickButtonFrame[1] = self.RAP.RealFrame
			end
		else
			self.FightType = ""
		end

		--行为模式为跟随，或行为模式为战斗且战斗类型为战斗跟随时
		if (self.FirstAim == "Follow" or (self.FirstAim == "Fight" and self.FightType == "FightFollow"))
			and BF.CanCtrl(self.Me) and BF.CheckEntity(self.FollowTarget) then
			
			local M = BF.GetSubMoveState(self.Me)
			--跟随判断
			if self.FollowTargetDistance >= self.FollowActiveDistance and self.FollowType ~= "Following" then
				if M ~= FightEnum.EntityMoveSubState.Run then
					BF.DoSetMoveType(self.Me,FightEnum.EntityMoveSubState.Run)
					self.RAP.LeisurelyIdleChangeFrame = self.RAP.RealFrame + 150
				end
				BF.DoLookAtPositionByLerp(self.Me,self.FollowTargetPosition.x,self.FollowTargetPosition.y,self.FollowTargetPosition.z,1,300,0)
				self.FollowType = "Following"
			--持续跟随
			elseif self.FollowType == "Following" and BF.CheckEntity(self.FollowTarget) then
				--障碍判断
				self:CheckObstacles(self.FollowTarget)
				--持续移动判定
				if M ~= FightEnum.EntityMoveSubState.Run then
					BF.DoSetMoveType(self.Me,FightEnum.EntityMoveSubState.Run)
					self.RAP.LeisurelyIdleChangeFrame = self.RAP.RealFrame + 150
				end
				BF.DoLookAtPositionByLerp(self.Me,self.FollowTargetPosition.x,self.FollowTargetPosition.y,self.FollowTargetPosition.z,1,300,0)
			end
			
			--位移技能释放判断
			self:FollowSkillCatch()
			
			--停止跟随判断
			if self.FollowType == "Following" and self.FollowTargetDistance < self.FollowCancelDistance then
				BF.StopMove(self.Me)
				BF.SetIdleType(self.Me,FightEnum.EntityIdleType.FightIdle)
				self.RAP.LeisurelyIdleChangeFrame = self.RAP.RealFrame + 150
				self.FollowType = "FollowPause"
			--模式为战斗时恢复战斗
			elseif self.FightType == "FightFollow" and self.FightTargetDistance < self.FollowCancelDistance then
				BF.StopMove(self.Me)
				BF.SetIdleType(self.Me,FightEnum.EntityIdleType.FightIdle)
				self.RAP.LeisurelyIdleChangeFrame = self.RAP.RealFrame + 150
				self.FightType = "Fighting"
				self.FollowType = "FollowPause"
			end
		elseif (self.FightType == "Following" and not BF.CheckEntity(self.FollowTarget)) 
			or (self.FirstAim == "Fight" and self.FightType ~= "FightFollow") then
			self.FollowType = ""
		end
	--清除AI参数判断
	elseif (not BF.CheckEntityForeground(self.Me) or self.Me == self.RAP.Role1 ) and self.FirstAim ~= "" then
		self.FirstAim = ""
		self.SecondAim = ""
		self.FightTarget = 0
		self.FightTargetPosition = {}
		self.FightTargetDistance = 0
		self.FollowTarget = 0
		self.FollowTargetPosition = {}
		self.FollowTargetDistance = 0
		self.FollowActiveDistance = 0
		self.FollowCancelDistance = 0
		if self.FollowType == "Following" or self.FightType == "FightFollow" then
			local M = BF.GetSubMoveState(self.Me)
			if M == FightEnum.EntityMoveSubState.Run then
				BF.StopMove(self.Me)
				BF.SetIdleType(self.Me,FightEnum.EntityIdleType.FightIdle)
				self.RAP.LeisurelyIdleChangeFrame = self.RAP.RealFrame + 150
			end
			self.FollowType = ""
			self.FightType = ""
		end
	end
end

--AI跳转用空节点
function RoleAiBase:SkipStep()
	return true
end

--AI执行意图
function RoleAiBase:RunStep(Purpose)
	local c = 0
	if Purpose ~= 0 then
		for i = 1 ,#Purpose,1 do
			if c ~= 0 then
				i = c + i
				c = 0
			end
			if Purpose[i][1] ~= 0 and Purpose[i][1]() == true then
				Purpose[i][2] = true
				if Purpose[i][3] ~= nil then
					--条件判断
					for j = 1,#Purpose[i][3],1 do
						local P = Purpose[i][3][j]
						if P[2] == "BuffKind" or P[2] == "EntitySign" or P[2] == "SkillSign" then
							if self:HasCondition(P[3],P[4]) then
								c = P[1] - 2
								break
							end
						elseif P[2] == "Attr" then
							if self:ResCondition(P[3],P[4]) then
								c = P[1] - 2
								break
							end
						end
					end
				end
			elseif Purpose[i][1] == 0 and Purpose[i][3] ~= nil then
				--条件判断
				for j = 1,#Purpose[i][3],1 do
					local P = Purpose[i][3][j]
					if P[2] == "BuffKind" or P[2] == "EntitySign" or P[2] == "SkillSign" then
						if self:HasCondition(P[3],P[4]) then
							c = P[1] - 2
							break
						end
					elseif P[2] == "Attr" then
						if self:ResCondition(P[3],P[4]) then
							c = P[1] - 2
							break
						end
					end
				end
			else
				Purpose[i][2] = false
				break
			end
		end
	end
end

--AI点击按钮步骤：按键类型
function RoleAiBase:ClickButton(KeyEvent,Probability)
	if (BF.HasEntitySign(1,10000009) and BF.Probability(Probability[3]))
		or (BF.HasEntitySign(1,10000015) and BF.Probability(Probability[2]))
		or (not BF.HasEntitySign(1,10000009) and not BF.HasEntitySign(1,10000015) and BF.Probability(Probability[1]))then
		self.RAB.RoleClickButtonCache:ClickButton(KeyEvent)
		return true
	end
end

--AI点击按钮组步骤
function RoleAiBase:ClickButtonGroup(...)

	--可变参数体组成：{{KeyEvent、优先级、操作类型},{概率集}}...
	local G = {...}
	local W1 = 0 	--前一优先级
	local W2 = 0	--后一优先级
	local B = 0		--按钮类型
	local M = ""	--操作类型
	for i = 1,#G,1 do
		--缔约状态且缔约概率通过，或极闪状态且极闪概率通过，或不存在缔约极闪状态且概率通过
		if BF.CheckBtnUseSkill(self.Me,G[i][1][1]) 
			and ((BF.HasEntitySign(1,10000009) and BF.Probability(G[i][2][3]))
				or (BF.HasEntitySign(1,10000015) and BF.Probability(G[i][2][2]))
				or (not BF.HasEntitySign(1,10000009) and not BF.HasEntitySign(1,10000015) and BF.Probability(G[i][2][1]))) then
			W2 = G[i][1][2]
			if W2 >= W1 then
				B = G[i][1][1]
				W1 = W2
				M = G[i][1][3]
			end
		end
	end
	if B ~= 0 then
		if M == "Click" then
			self.RAB.RoleClickButtonCache:ClickButton(B)
		else
			self.RAB.RoleClickButtonCache:PressButton(B)
		end
		return true
	else
		return false
	end
end

--AI长按按钮帧数步骤
function RoleAiBase:PressButton(KeyEvent,RecordFrame,IfClick)
	self.RAB.RoleClickButtonCache:PressButton(KeyEvent,1)

	if IfClick == true then
		self.RAB.RoleClickButtonCache:ClickButton(KeyEvent)
	end

	if (self.RAP.PressButton[1] == KeyEvent and self.RAP.PressButtonFrame[1] >= RecordFrame)
		or (self.RAP.PressButton[2] == KeyEvent and self.RAP.PressButtonFrame[2] >= RecordFrame) 
		or (self.RAP.PressButton[3] == KeyEvent and self.RAP.PressButtonFrame[3] >= RecordFrame) then
		return true
	else
		return false
	end
end

--AI存在条件判定步骤
function RoleAiBase:HasCondition(HasCon,Probability)
	--HasCon{EntitySign,BuffKind,SkillSign}
	--值>0,则>=判断；值<0,则<=判断；值=0,则=0判断
	--实体标记、Buff类型或技能窗口条件达成，则返回true
	local N = 0
	if (BF.HasEntitySign(1,10000009) and BF.Probability(Probability[3]))
		or (BF.HasEntitySign(1,10000015) and BF.Probability(Probability[2]))
		or (not BF.HasEntitySign(1,10000009) and not BF.HasEntitySign(1,10000015) and BF.Probability(Probability[1]))then
		if HasCon[1] ~= nil then
			if HasCon[1] < 0 then
				HasCon[1] = -HasCon[1]
				if not BF.HasEntitySign(self.Me,HasCon[1]) then
					N = N + 1
				end
			elseif HasCon[1] > 0 then
				if BF.HasEntitySign(self.Me,HasCon[1]) then
					N = N + 1
				end
			end
		end
		if HasCon[2] ~= nil then
			if HasCon[2] < 0 then
				HasCon[2] = -HasCon[2]
				if not BF.HasBuffKind(self.Me,HasCon[2]) then
					N = N + 1
				end
			elseif HasCon[2] > 0 then
				if BF.HasBuffKind(self.Me,HasCon[2]) then
					N = N + 1
				end
			end
		end
		if HasCon[3] ~= nil then
			if HasCon[3] < 0 then
				HasCon[3] = -HasCon[3]
				if not BF.GetSkillSign(self.Me,HasCon[3]) then
					N = N + 1
				end
			elseif HasCon[3] > 0 then
				if BF.GetSkillSign(self.Me,HasCon[3]) then
					N = N + 1
				end
			end
		end
	end
	if N > 0 then
		return true
	else
		return false
	end
end

--AI资源量判定步骤
function RoleAiBase:ResCondition(Res,Probability)
	--Res{Type,Num,Ratio}
	--Num>0,则>=判断；Num<0,则<=判断；Num=0,则=0判断
	--资源固定值或比率达成条件，则返回true
	local N1 = 0 
	local N = BF.GetEntityAttrVal(self.Me,Res[1])
	local R = BF.GetEntityAttrValueRatio(self.Me,Res[1])
	
	if (BF.HasEntitySign(1,10000009) and BF.Probability(Probability[3])) 
		or (BF.HasEntitySign(1,10000015) and BF.Probability(Probability[2]))
		or (not BF.HasEntitySign(1,10000009) and not BF.HasEntitySign(1,10000015) and BF.Probability(Probability[1]))then
		
		if Res[2] ~= nil then
			if Res[2] > 0 and N >= Res[2] then
				N1 = N1 + 1
			elseif Res[2] < 0 and N <= Res[2] then
				N1 = N1 + 1
			elseif Res[2] == 0 and N == 0 then
				N1 = N1 + 1
			end
		end
		if Res[3] ~= nil then
			if Res[3] > 0 and R >= Res[3] then
				N1 = N1 + 1
			elseif Res[3] < 0 and R <= Res[3] then
				N1 = N1 + 1
			elseif Res[3] == 0 and R == 0 then
				N1 = N1 + 1
			end
		end
	end
	if N1 > 0 then
		return true
	else
		return false
	end
end

function RoleAiBase:FollowSkillCatch()
	
	--跟随参数判断
	if BF.CheckEntity(self.FollowTarget) and self.FollowType == "Following" then
		--行为模式为战斗 ，设定闪避概率和闪避值比率底线、位移技能概率
		if self.FirstAim == "Fight" and self.FightType == "FightFollow" then
			if self.FollowTargetDistance > self.FollowCancelDistance + 3 then
				self.FollowMoveProbability = 350
				self.FollowMoveResRatio = 7000
				self.FollowShiftSkillProbability = 1000
			elseif	self.FollowTargetDistance > self.FollowCancelDistance + 5 then
				self.FollowMoveProbability = 450
				self.FollowMoveResRatio = 6500
				self.FollowShiftSkillProbability = 1200
			elseif	self.FollowTargetDistance > self.FollowCancelDistance + 7 then
				self.FollowMoveProbability = 550
				self.FollowMoveResRatio = 6000
				self.FollowShiftSkillProbability = 1400
			else
				self.FollowMoveProbability = 250
				self.FollowMoveResRatio = 7500
				self.FollowShiftSkillProbability = 800
			end
		--行为模式为跟随，设定闪避概率和闪避值比率底线
		elseif self.FirstAim == "Follow" then
			if self.FollowTargetDistance > self.FollowCancelDistance + 3 then
				self.FollowMoveProbability = 250
				self.FollowMoveResRatio = 5000
			elseif	self.FollowTargetDistance > self.FollowCancelDistance + 5 then
				self.FollowMoveProbability = 350
				self.FollowMoveResRatio = 4500
			elseif	self.FollowTargetDistance > self.FollowCancelDistance + 7 then
				self.FollowMoveProbability = 450
				self.FollowMoveResRatio = 4000
			else
				self.FollowMoveProbability = 150
				self.FollowMoveResRatio = 5500
			end
		end
	end
	
	--位移型技能/闪避/移动接近目标，直到两者距离不大于跟随取消距离
	if self.FollowType == "Following" and self.FollowCancelDistance < self.FollowTargetDistance then
		--尝试释放突进型技能并接近目标，突进型技能集不为空且概率通过，且技能集有符合释放条件的技能
		local FSS = self.MainBehavior.FollowShiftSkill
		if BF.CheckEntity(self.FightTarget) and FSS ~= nil and BF.Probability(self.FollowShiftSkillProbability) 
			and self:ForSkill(self.FollowTargetDistance,FSS) then
			for i = 1,#FSS,1 do
				--如果技能集不为空
				if FSS[i] ~= nil then
					--技能释放尝试返回true
					if self.RAB.RoleCatchSkill:ActiveSkill(FSS[i][2],FSS[i][3],FSS[i][4],FSS[i][5],FSS[i][6],FSS[i][7],FSS[i][8]) then
						--技能消耗判断
						if FSS[i][8] == true and FSS[i][9] ~= 0 then
							BF.CastSkillCost(self.Me,FSS[i][9])
						elseif FSS[i][8] == true and FSS[i][9] == 0 then
							BF.CastSkillCost(self.Me,FSS[i][4])
						end
						break
					end
				end
			end
		--尝试释放闪避技能并接近目标，概率通过且当前闪避值比率大于释放需求比率时
		elseif BF.Probability(self.FollowMoveProbability) and self.RAP.MoveResRatio > self.FollowMoveResRatio
			and self.FollowMoveJudgeFrame < self.RAP.RealFrame then
			self.FollowMoveJudgeFrame = self.RAP.RealFrame + 12
			self.RAP.JoystickPosX = self.FollowTargetPosition.x
			self.RAP.JoystickPosZ = self.FollowTargetPosition.z
			if self.RAB.RoleCatchSkill:MoveSkill(1,3,3,0,0,0) then
				BF.CastSkillCost(self.Me,self.MainBehavior.MoveSkill[1])
			end
		end
	end
end

--循环检验技能集合
function RoleAiBase:ForSkill(dis,SkillGroup)
	if SkillGroup ~= nil then
		for i = 1,#SkillGroup,1 do
			if SkillGroup[i] ~= nil and SkillGroup[i][1] >= dis
				and BF.CheckBtnUseSkill(self.Me,SkillGroup[i][2]) then
				return true
			end
		end
		return false
	end
end

--AI检查障碍阻挡(初版)
function RoleAiBase:CheckObstacles(CheckEntity)
	if BF.CheckEntity(CheckEntity) and CheckEntity == self.RAP.Role1 and BF.CheckObstaclesBetweenEntity(CheckEntity,self.Me,true) then
		local p1 = BF.GetPositionP(CheckEntity)
		local p2 = self.RAP.MyPos
		local d = BF.GetDistanceBetweenObstaclesAndEntity(CheckEntity,self.Me,true)
		if d >= 1.5 then
			local d1 = d - 0.5
			local p3 = BF.GetPositionOffsetP(p1,p2,d1,0)
			BF.DoSetPositionP(self.Me,p3)
		else
			local a = BF.GetEntityAngle(CheckEntity,self.Me)
			local p4 = BF.GetPositionOffsetBySelf(CheckEntity,2,a)
			local n = 1
			if 330 <= a < 360 then
				a = 310
			elseif 0 <= a < 30 then
				a = 30
			end
			local c = 0
			for i = 0,359,20 do
				if n == 1 then
					if c ~= 0 then
						i = c + 20
						c = 0
					end
					if i == 0 then
						i = a + 20
						c = a + 20
					elseif i > 330 or i < 30 then
						i = 30
						c = 30
					else
						c = i
					end
					if  a - 10 <= i <= a + 10 then
						n = 0
					else
						p4 = BF.GetPositionOffsetBySelf(CheckEntity,2,i)
						if not BF.CheckObstaclesBetweenPos(p1,p4,true) then
							BF.DoSetPositionP(self.Me,p4)
							break
						end
					end
				elseif n == 0 then
					break
				end
			end
		end
	end
end