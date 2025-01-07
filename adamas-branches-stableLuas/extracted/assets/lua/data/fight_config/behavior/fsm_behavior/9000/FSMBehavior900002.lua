FSMBehavior900002 = BaseClass("FSMBehavior900002",FSMBehaviorBase)
--和平总状态


function FSMBehavior900002.GetGenerates()
	local generates = {}
	return generates
end

function FSMBehavior900002:Init()
	--警戒相关的参数
	self.warnFrame = 0
	self.beHit = false
	self.nowAlertnessValue = self.MainBehavior.curAlertnessValue   --初始警戒值
	self.perAlertnessValue = 0   --每帧变化警戒值
	self.isWarnCD = false
	self.warnLimitRange = 0
	self.warnShortRange = 0
	self.warnLongRange = 0
	self.warnDelayTime = 0
	self.isLige = false   --是否被离歌仲魔刺杀
	self.inPeace = true		--沿用旧逻辑命名，实际指非战斗状态中，没有触发任何警戒的时候
	self.lifeBarDistance = nil  --血条显示距离

	--石龙修改数据表
	self.ShilongInfo = {
		LimitRange = 2,
		ShortRange =3,
		LongRange =3,
		DelayTime = self.MainBehavior.warnDelayTime*1.5,
	}

	--新UI的开关参数
	self.UIState = 0
	self.UIStateEnum = {
		Off = 0,
		QuestionOn= 1,
		WarnOn = 2,
	}
	self.isQuestionShow = nil

	--人和怪的相对关系状态
	self.isAngleIn = nil
	self.isShilong = nil
	self.distanceState = nil
	self.distanceStateEnum = {
		Limit = 0,    --极限近身，直接给感叹号
		Short = 1,    --短距离，给问号
		Long = 2,
		TooLong = 3,
	}
		
	self.warnState = 0
	self.warnStateEnum = {            --警告状态枚举
		Default = 0,
		GetReadyToWarn = 1,
		Warning = 2,
		WarnDone = 3,

	}
	
end

function FSMBehavior900002:Update()
	if BehaviorFunctions.CheckEntity(self.MainBehavior.battleTarget)==true then
		if self.MainBehavior.haveWarn == true then
			
			if self.ParentBehavior.hitWhenInitial == 1 then
				self.warnState = self.warnStateEnum.Warning
				if BehaviorFunctions.CustomFSMTryChangeState(self.MainBehavior.me) then
					return true
				end
			end
			
			local rolePos = BehaviorFunctions.GetPositionP(self.MainBehavior.battleTarget)
			local myPos = self.MainBehavior.myPos
			local xDifference = math.abs(rolePos.x - myPos.x)
			local zDifference = math.abs(rolePos.z - myPos.z)
			local height = math.abs(rolePos.y - myPos.y)
			local spatialDistance = math.sqrt(xDifference*xDifference+zDifference*zDifference+height*height)
			local yAngle = math.deg(math.acos(self.MainBehavior.battleTargetDistance/spatialDistance))
		
			--石龙判断
			if BehaviorFunctions.HasEntitySign(self.MainBehavior.battleTarget,610025) then
				self.isShilong = true

				self.hidePerkValue = BehaviorFunctions.GetEntityValue(self.MainBehavior.battleTarget,"alertValue")
				if self.hidePerkValue then
					self.warnLimitRange = self.ShilongInfo.LimitRange * (( 10000 - self.hidePerkValue)/10000)
					self.warnShortRange = self.ShilongInfo.ShortRange * (( 10000 - self.hidePerkValue)/10000)
					self.warnLongRange = self.ShilongInfo.LongRange * (( 10000 - self.hidePerkValue)/10000)
					self.warnDelayTime = self.ShilongInfo.DelayTime
				else
					self.warnLimitRange = self.ShilongInfo.LimitRange
					self.warnShortRange = self.ShilongInfo.ShortRange
					self.warnLongRange = self.ShilongInfo.LongRange
					self.warnDelayTime = self.ShilongInfo.DelayTime
				end
			else
				self.isShilong = false
				self.warnLimitRange = self.MainBehavior.warnLimitRange
				self.warnShortRange = self.MainBehavior.warnShortRange
				self.warnLongRange = self.MainBehavior.warnLongRange
				self.warnDelayTime = self.MainBehavior.warnDelayTime
			end
			
			--距离状态判断
			if self.MainBehavior.battleTargetDistance <= self.warnLimitRange and height <= self.MainBehavior.warnLimitHeight then
				self.distanceState = self.distanceStateEnum.Limit
			elseif self.MainBehavior.battleTargetDistance <= self.warnShortRange and height <= self.MainBehavior.warnLimitHeight then
				self.distanceState = self.distanceStateEnum.Short
			elseif self.MainBehavior.battleTargetDistance <= self.warnLongRange then
				self.distanceState = self.distanceStateEnum.Long
			else
				self.distanceState = self.distanceStateEnum.TooLong  --暂时没用这个状态
			end
			--角度状态判断
			if BehaviorFunctions.CompEntityLessAngle(self.MainBehavior.me,self.MainBehavior.battleTarget,self.MainBehavior.warnVisionAngle/2)
				and yAngle <= self.MainBehavior.warnVisionAngle/2 then
				self.isAngleIn = true
			end
			
			--离歌刺杀判断
			if BehaviorFunctions.HasEntitySign(self.MainBehavior.battleTarget,62001001) then
				self.isLige = true
				if self.isQuestionShow == true then
					BehaviorFunctions.ShowQuestionAlertnessUI(self.MainBehavior.me, false)
					self.isQuestionShow = false
				end
			else
				self.isLige = false
				if self.warnState == self.warnStateEnum.GetReadyToWarn and self.isQuestionShow == false then
					BehaviorFunctions.ShowQuestionAlertnessUI(self.MainBehavior.me, true)
					self.isQuestionShow = true
				end
			end
			
			--根据距离判断警戒状态
			if not BehaviorFunctions.CheckObstaclesBetweenEntity(self.MainBehavior.me,self.MainBehavior.battleTarget) then
				--极限近身检测
				if self.distanceState == self.distanceStateEnum.Limit then
					self.warnState = self.warnStateEnum.Warning   --直接感叹号
					self.inPeace = false
					if BehaviorFunctions.CustomFSMTryChangeState(self.MainBehavior.me) then
						return true
					end
					--近距离或中距离视线内疑问检测
				elseif self.distanceState == self.distanceStateEnum.Short
					or (self.distanceState == self.distanceStateEnum.Long and self.isAngleIn and not self.isShilong) then
					self.warnState = self.warnStateEnum.GetReadyToWarn   --问号
					self.inPeace = false
				end

				--安琪写的生态监测
				if self.MainBehavior.ecoMe
					and BehaviorFunctions.CheckEcoEntityGroup(self.MainBehavior.ecoMe)
					and BehaviorFunctions.GetEntityValue(self.MainBehavior.me,"monsterBeWarned") then
					self.warnState = self.warnStateEnum.Warning
					self.inPeace = false
					if BehaviorFunctions.CustomFSMTryChangeState(self.MainBehavior.me) then
						return true
					end
				end
			end
		
			--问号变成感叹号的逻辑
			if self.warnState == self.warnStateEnum.GetReadyToWarn and not self.isLige then
				--在警戒状态加问号
				if (self.UIState == self.UIStateEnum.Off or self.isQuestionShow == false) and not self.isLige then
					--只在这里创建一次，之后都用isshow来管理有没有问号
					BehaviorFunctions.CreateQuestionAlertnessUI(self.MainBehavior.me, self.MainBehavior.curAlertnessValue, self.MainBehavior.maxAlertnessValue, self.MainBehavior.alertUIOffset, self.MainBehavior.alertUIPoint)
					BehaviorFunctions.ShowQuestionAlertnessUI(self.MainBehavior.me, true)
					self.isQuestionShow = true
					self.UIState = self.UIStateEnum.QuestionOn
				end
				--对警戒值判断
				if self.nowAlertnessValue < self.MainBehavior.maxAlertnessValue then   --警戒值没满就变化
					if (self.distanceState == self.distanceStateEnum.Limit or (self.distanceState == self.distanceStateEnum.Short and self.isAngleIn and not self.isShilong))
						and not BehaviorFunctions.CheckObstaclesBetweenEntity(self.MainBehavior.me,self.MainBehavior.battleTarget)  then
						--self.warnFrame = self.MainBehavior.myFrame
						self.warnState = self.warnStateEnum.Warning   --直接感叹号
						self.inPeace = false
						if BehaviorFunctions.CustomFSMTryChangeState(self.MainBehavior.me) then
							return true
						end
					elseif (self.distanceState == self.distanceStateEnum.Short or (self.distanceState == self.distanceStateEnum.Long and self.isAngleIn and not self.isShilong))
						and not BehaviorFunctions.CheckObstaclesBetweenEntity(self.MainBehavior.me,self.MainBehavior.battleTarget) then
						self.perAlertnessValue = self.MainBehavior.maxAlertnessValue/(self.MainBehavior.warnDelayTime*30)
						self.nowAlertnessValue = self.nowAlertnessValue + self.perAlertnessValue
						BehaviorFunctions.SetQuestionAlertnessValue(self.MainBehavior.me, self.nowAlertnessValue)
					else
						--if not self.isWarnCD then(再说)
						self.perAlertnessValue = self.MainBehavior.maxAlertnessValue/(self.MainBehavior.warnDelayTime*30*2)  --减慢的速度是加快的1/2
						self.nowAlertnessValue = self.nowAlertnessValue - self.perAlertnessValue
						BehaviorFunctions.SetQuestionAlertnessValue(self.MainBehavior.me, self.nowAlertnessValue)
					end
				else
					self.warnState = self.warnStateEnum.Warning   --警戒值满了就变成感叹号状态
					if BehaviorFunctions.CustomFSMTryChangeState(self.MainBehavior.me) then
						return true
					end
				end

				if self.isQuestionShow == true and (self.nowAlertnessValue < 0 or (self.nowAlertnessValue == 0
							and self.warnState ~= self.warnStateEnum.Warning)) then    --警戒清零，隐藏问号
					BehaviorFunctions.ShowQuestionAlertnessUI(self.MainBehavior.me, false)
					--BehaviorFunctions.AddDelayCallByFrame(15, BehaviorFunctions, BehaviorFunctions.ShowQuestionAlertnessUI, self.MainBehavior.me, false)
					self.warnState = self.warnStateEnum.Default
					self.inPeace = true
					self.isQuestionShow = false
				end

				--安琪写的生态判断，后面删掉
				if self.MainBehavior.ecoMe
					and BehaviorFunctions.CheckEcoEntityGroup(self.MainBehavior.ecoMe)
					and BehaviorFunctions.GetEntityValue(self.MainBehavior.me,"monsterBeWarned") then --当外部传入的警告存在且为true时
					self.warnState = self.warnStateEnum.Warning
					self.inPeace = false
					if BehaviorFunctions.CustomFSMTryChangeState(self.MainBehavior.me) then
						return true
					end
				end
			end
			
			--无论是怎么进入到警戒状态的，只要inPeace==false，都会绑一个警戒状态。如果有警告延迟的，需要直接跳过延迟阶段。
			if self.inPeace==false
				and self.MainBehavior.ecoMe
				and BehaviorFunctions.CheckEcoEntityGroup(self.MainBehavior.ecoMe)==true --检测是否有生态分组
				and (BehaviorFunctions.GetEntityValue(self.MainBehavior.me,"warnState")==nil or BehaviorFunctions.GetEntityValue(self.MainBehavior.me,"warnState")==false) then --只需要改一次状态
				BehaviorFunctions.SetEntityValue(self.MainBehavior.me,"warnState",true) --警告状态，仅用于脱战。
				--索敌
				BehaviorFunctions.AddFightTarget(self.MainBehavior.me,self.MainBehavior.battleTarget)
			end
			--无警戒状态直接进入战斗
		else
			if self.MainBehavior.noWarnInFightRange > 0 and self.MainBehavior.battleTargetDistance < self.MainBehavior.noWarnInFightRange then
				BehaviorFunctions.AddFightTarget(self.MainBehavior.me,self.MainBehavior.battleTarget)
				self.inPeace = false
				self.MainBehavior.inFight = true
				if BehaviorFunctions.CustomFSMTryChangeState(self.MainBehavior.me) then
					return true
				end
			elseif self.MainBehavior.noWarnInFightRange == 0 then
				BehaviorFunctions.AddFightTarget(self.MainBehavior.me,self.MainBehavior.battleTarget)
				self.inPeace = false
				self.MainBehavior.inFight = true
				if BehaviorFunctions.CustomFSMTryChangeState(self.MainBehavior.me) then
					return true
				end
			end
		end
	end
	if self.inPeace == false and self.MainBehavior.addLifeBar== true then
		if self.lifeBarDistance == nil
			or (self.lifeBarDistance ~= nil
				and self.lifeBarDistance >self.MainBehavior.battleTargetDistance) then
			BehaviorFunctions.SetEntityLifeBarVisibleType(self.MainBehavior.me,2)
			self.MainBehavior.addLifeBar= false
		end
	end
		
end

function FSMBehavior900002:BreakSkill(instanceId,skillId,skillSign,skillType)
	if skillId == 62001010 then
		--self.warnState = self.warnStateEnum.Warning
		self.isLige = false
	end
end

--受击进入warnning状态
function FSMBehavior900002:Collide(attackInstanceId,hitInstanceId,instanceId)
	if (attackInstanceId == self.MainBehavior.battleTarget or (BehaviorFunctions.GetEntityOwner(attackInstanceId) and BehaviorFunctions.GetEntityOwner(attackInstanceId) ==self.MainBehavior.battleTarget)
			or BehaviorFunctions.GetCampType(attackInstanceId) ~= 2)
		and hitInstanceId == self.MainBehavior.me
		and self.MainBehavior.haveWarn == true
		and not BehaviorFunctions.HasEntitySign(self.MainBehavior.battleTarget,610025) then
		--and not BehaviorFunctions.HasBuffKind(self.MainBehavior.me,900000007) then
		--if not BehaviorFunctions.HasBuffKind(self.MainBehavior.me,900000001)
		--and self.beHit == false
		--and self.MainBehavior.warnSkillId then
		--BehaviorFunctions.AddBuff(1,self.MainBehavior.me,900000001)
		--self.beHit = true
		--end
		self.inPeace = false
		self.warnState = self.warnStateEnum.Warning
		if BehaviorFunctions.CustomFSMTryChangeState(self.MainBehavior.me) then
			return true
		end
	end

	--被暗杀直接进入战斗，跳过表演
	if hitInstanceId == self.MainBehavior.me and
		(BehaviorFunctions.GetEntityTemplateId(instanceId) == 62001004001
			or BehaviorFunctions.GetEntityTemplateId(instanceId) == 62001009001
			or BehaviorFunctions.GetEntityTemplateId(instanceId) == 610025012001) then
		self.warnState = self.warnStateEnum.Default
		BehaviorFunctions.AddFightTarget(self.MainBehavior.me,self.MainBehavior.battleTarget)
		self.inPeace = false
		self.MainBehavior.inFight = true
		if BehaviorFunctions.CustomFSMTryChangeState(self.MainBehavior.me) then
			return true
		end
	end
end

function FSMBehavior900002:OnLeaveState()
	self.ParentBehavior.hitWhenInitial = 0
end