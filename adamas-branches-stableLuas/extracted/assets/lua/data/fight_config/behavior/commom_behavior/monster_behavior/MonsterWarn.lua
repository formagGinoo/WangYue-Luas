MonsterWarn = BaseClass("MonsterWarn",EntityBehaviorBase)
--警戒状态
function MonsterWarn:Init()
	self.MonsterCommonBehavior = self.ParentBehavior
	self.MonsterCommonParam = self.MainBehavior.MonsterCommonParam
	self.warnFrame = 0
	self.beHit = false
	self.nowAlertnessValue = self.MonsterCommonParam.curAlertnessValue   --初始警戒值
	self.perAlertnessValue = 0   --每帧变化警戒值
	self.isWarnCD = false
	self.warnLimitRange = 0
	self.warnShortRange = 0
	self.warnLongRange = 0
	self.warnDelayTime = 0
	self.isLige = false   --是否被离歌仲魔刺杀

	--石龙修改数据表
	self.ShilongInfo = {
		LimitRange = 2,
		ShortRange =3,
		LongRange =3,
		DelayTime = self.MonsterCommonParam.warnDelayTime*1.5,
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
end

function MonsterWarn:Update()
	if BehaviorFunctions.CheckEntity(self.MonsterCommonParam.battleTarget)==true 
		and self.MonsterCommonParam.initialState == self.MonsterCommonParam.InitialStateEnum.Done
		and self.MonsterCommonParam.exitFightState ~= self.MonsterCommonParam.ExitFightStateEnum.Exiting then
		if self.MonsterCommonParam.haveWarn == true   then
			local rolePos = BehaviorFunctions.GetPositionP(self.MonsterCommonParam.battleTarget)
			local myPos = self.MonsterCommonParam.myPos
			local xDifference = math.abs(rolePos.x - myPos.x)
			local zDifference = math.abs(rolePos.z - myPos.z)
			local height = math.abs(rolePos.y - myPos.y)
			local spatialDistance = math.sqrt(xDifference*xDifference+zDifference*zDifference+height*height)
			local yAngle = math.deg(math.acos(self.MonsterCommonParam.battleTargetDistance/spatialDistance))
			
			--石龙判断
			if BehaviorFunctions.HasEntitySign(self.MonsterCommonParam.battleTarget,610025) then
				self.isShilong = true
				
				self.hidePerkValue = BehaviorFunctions.GetEntityValue(self.MonsterCommonParam.battleTarget,"alertValue")
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
				self.warnLimitRange = self.MonsterCommonParam.warnLimitRange
				self.warnShortRange = self.MonsterCommonParam.warnShortRange
				self.warnLongRange = self.MonsterCommonParam.warnLongRange
				self.warnDelayTime = self.MonsterCommonParam.warnDelayTime
			end
			--距离状态判断
			if self.MonsterCommonParam.battleTargetDistance <= self.warnLimitRange and height <= self.MonsterCommonParam.warnLimitHeight then
				self.distanceState = self.distanceStateEnum.Limit
			elseif self.MonsterCommonParam.battleTargetDistance <= self.warnShortRange and height <= self.MonsterCommonParam.warnLimitHeight then
				self.distanceState = self.distanceStateEnum.Short
			elseif self.MonsterCommonParam.battleTargetDistance <= self.warnLongRange then
				self.distanceState = self.distanceStateEnum.Long
			else
				self.distanceState = self.distanceStateEnum.TooLong  --暂时没用这个状态
			end
			--角度状态判断
			if BehaviorFunctions.CompEntityLessAngle(self.MonsterCommonParam.me,self.MonsterCommonParam.battleTarget,self.MonsterCommonParam.warnVisionAngle/2)
				and yAngle <= self.MonsterCommonParam.warnVisionAngle/2 then
				self.isAngleIn = true
			end
			--离歌刺杀判断
			if BehaviorFunctions.HasEntitySign(self.MonsterCommonParam.battleTarget,62001001) then
				self.isLige = true
				if self.isQuestionShow == true then
					BehaviorFunctions.ShowQuestionAlertnessUI(self.MonsterCommonParam.me, false)
					self.isQuestionShow = false
				end
				--BehaviorFunctions.AddDelayCallByTime(5.5, self, self.Assignment, "warnState", 2)  --2是warning
			else
				self.isLige = false
				if self.MonsterCommonParam.warnState == self.MonsterCommonParam.warnStateEnum.GetReadyToWarn and self.isQuestionShow == false then 
					BehaviorFunctions.ShowQuestionAlertnessUI(self.MonsterCommonParam.me, true)
					self.isQuestionShow = true
				end
			end
			
			--根据距离判断警戒状态
			if self.MonsterCommonParam.inPeace == true 
				and not BehaviorFunctions.CheckObstaclesBetweenEntity(self.MonsterCommonParam.me,self.MonsterCommonParam.battleTarget) then
				--极限近身检测
				if self.distanceState == self.distanceStateEnum.Limit then
					--self.warnFrame = self.MonsterCommonParam.myFrame
					self.MonsterCommonParam.warnState = self.MonsterCommonParam.warnStateEnum.Warning   --直接感叹号
					self.MonsterCommonParam.inPeace = false
				--近距离或中距离视线内疑问检测
				elseif self.distanceState == self.distanceStateEnum.Short 
					or (self.distanceState == self.distanceStateEnum.Long and self.isAngleIn and not self.isShilong) then
					--self.warnFrame = self.MonsterCommonParam.myFrame
					self.MonsterCommonParam.warnState = self.MonsterCommonParam.warnStateEnum.GetReadyToWarn   --问号
					self.MonsterCommonParam.inPeace = false
				end

				--安琪写的生态监测
				if self.MonsterCommonParam.ecoMe
					and BehaviorFunctions.CheckEcoEntityGroup(self.MonsterCommonParam.ecoMe)
					and BehaviorFunctions.GetEntityValue(self.MonsterCommonParam.me,"monsterBeWarned") then
					self.MonsterCommonParam.warnState = self.MonsterCommonParam.warnStateEnum.Warning
					self.MonsterCommonParam.inPeace = false
				end
			end
			
			-- 问号变成感叹号的逻辑
			if self.MonsterCommonParam.warnState == self.MonsterCommonParam.warnStateEnum.GetReadyToWarn and not self.isLige then
				--在警戒状态加问号
				if (self.UIState == self.UIStateEnum.Off or self.isQuestionShow == false) and not self.isLige then
					--只在这里创建一次，之后都用isshow来管理有没有问号
					BehaviorFunctions.CreateQuestionAlertnessUI(self.MonsterCommonParam.me, self.MonsterCommonParam.curAlertnessValue, self.MonsterCommonParam.maxAlertnessValue, self.MonsterCommonParam.alertUIOffset, self.MonsterCommonParam.alertUIPoint)
					BehaviorFunctions.ShowQuestionAlertnessUI(self.MonsterCommonParam.me, true)
					self.isQuestionShow = true
					self.UIState = self.UIStateEnum.QuestionOn
				end
				--对警戒值判断
				if self.nowAlertnessValue < self.MonsterCommonParam.maxAlertnessValue then   --警戒值没满就变化
					if (self.distanceState == self.distanceStateEnum.Limit or (self.distanceState == self.distanceStateEnum.Short and self.isAngleIn and not self.isShilong))
						and not BehaviorFunctions.CheckObstaclesBetweenEntity(self.MonsterCommonParam.me,self.MonsterCommonParam.battleTarget)  then
						--self.warnFrame = self.MonsterCommonParam.myFrame
 						self.MonsterCommonParam.warnState = self.MonsterCommonParam.warnStateEnum.Warning   --直接感叹号
						self.MonsterCommonParam.inPeace = false
					elseif (self.distanceState == self.distanceStateEnum.Short or (self.distanceState == self.distanceStateEnum.Long and self.isAngleIn and not self.isShilong))
						and not BehaviorFunctions.CheckObstaclesBetweenEntity(self.MonsterCommonParam.me,self.MonsterCommonParam.battleTarget) then
						self.perAlertnessValue = self.MonsterCommonParam.maxAlertnessValue/(self.MonsterCommonParam.warnDelayTime*30)
						self.nowAlertnessValue = self.nowAlertnessValue + self.perAlertnessValue
						BehaviorFunctions.SetQuestionAlertnessValue(self.MonsterCommonParam.me, self.nowAlertnessValue)
					else
						--if not self.isWarnCD then(再说)
						self.perAlertnessValue = self.MonsterCommonParam.maxAlertnessValue/(self.MonsterCommonParam.warnDelayTime*30*2)  --减慢的速度是加快的1/2
						self.nowAlertnessValue = self.nowAlertnessValue - self.perAlertnessValue
						BehaviorFunctions.SetQuestionAlertnessValue(self.MonsterCommonParam.me, self.nowAlertnessValue)
					end
				else
					self.MonsterCommonParam.warnState = self.MonsterCommonParam.warnStateEnum.Warning   --警戒值满了就变成感叹号状态
				end
				
				if self.isQuestionShow == true and (self.nowAlertnessValue < 0 or (self.nowAlertnessValue == 0 
					and self.MonsterCommonParam.warnState ~= self.MonsterCommonParam.warnStateEnum.Warning)) then    --警戒清零，隐藏问号
					BehaviorFunctions.ShowQuestionAlertnessUI(self.MonsterCommonParam.me, false)
					--BehaviorFunctions.AddDelayCallByFrame(15, BehaviorFunctions, BehaviorFunctions.ShowQuestionAlertnessUI, self.MonsterCommonParam.me, false)
					self.MonsterCommonParam.warnState = self.MonsterCommonParam.warnStateEnum.Default
					self.MonsterCommonParam.inPeace = true
					self.isQuestionShow = false
				end

				--安琪写的生态判断，后面删掉
				if self.MonsterCommonParam.ecoMe
					and BehaviorFunctions.CheckEcoEntityGroup(self.MonsterCommonParam.ecoMe)
					and BehaviorFunctions.GetEntityValue(self.MonsterCommonParam.me,"monsterBeWarned") then --当外部传入的警告存在且为true时
					self.MonsterCommonParam.warnState = self.MonsterCommonParam.warnStateEnum.Warning
					self.MonsterCommonParam.inPeace = false
				end
			end

			--警戒行为
			if self.MonsterCommonParam.warnState == self.MonsterCommonParam.warnStateEnum.Warning then--刺杀标记
				BehaviorFunctions.AddFightTarget(self.MonsterCommonParam.me,self.MonsterCommonParam.battleTarget)
				self.nowAlertnessValue = 0  --警戒值清零
				self.MonsterCommonParam.inFight = true
				--添加叹号（会直接顶掉问号，不用单独移除）
				if self.UIState ~= self.UIStateEnum.WarnOn then
					--BehaviorFunctions.ShowQuestionAlertnessUI(self.MonsterCommonParam.me, false)   --隐藏问号
					BehaviorFunctions.ShowWarnAlertnessUI(self.MonsterCommonParam.me, true)
					BehaviorFunctions.CreateWarnAlertnessUI(self.MonsterCommonParam.me, self.MonsterCommonParam.alertUIOffset, self.MonsterCommonParam.alertUIPoint)
					BehaviorFunctions.AddDelayCallByFrame(31, BehaviorFunctions, BehaviorFunctions.ShowWarnAlertnessUI, self.MonsterCommonParam.me, false)
					self.nowAlertnessValue = 0
					self.UIState = self.UIStateEnum.WarnOn
				end
				--释放警戒技能
				if BehaviorFunctions.CanCtrl(self.MonsterCommonParam.me) then
					if self.MonsterCommonParam.warnSkillId then
						BehaviorFunctions.DoLookAtTargetImmediately(self.MonsterCommonParam.me,self.MonsterCommonParam.battleTarget)
						BehaviorFunctions.CastSkillByTarget(self.MonsterCommonParam.me,self.MonsterCommonParam.warnSkillId,self.MonsterCommonParam.battleTarget)
					end
				end	
				self.MonsterCommonParam.warnState = self.MonsterCommonParam.warnStateEnum.WarnDone
				self.UIState = self.UIStateEnum.Off
				self.isQuestionShow = false
				if BehaviorFunctions.CheckEcoEntityGroup(self.MonsterCommonParam.ecoMe)
					and BehaviorFunctions.CheckEcoEntityGroup(self.MonsterCommonParam.ecoMe) == true then  --有组的时候警告别人哦，没组的时候没用
					self.MonsterCommonParam.inPeace = false  --警戒状态的标记
					--被警告的怪物，在走到警告行为的时候，不再传值。
					if BehaviorFunctions.GetEntityValue(self.MonsterCommonParam.me,"monsterBeWarned")==nil then --没走被警告的怪物
						BehaviorFunctions.SetEntityValue(self.MonsterCommonParam.me,"warnOthers",true) --警告别人
					elseif BehaviorFunctions.GetEntityValue(self.MonsterCommonParam.me,"monsterBeWarned")==true then
						BehaviorFunctions.SetEntityValue(self.MonsterCommonParam.me,"monsterBeWarned",nil)
					end
				end		
			end
			--无论是怎么进入到警戒状态的，只要inPeace==false，都会绑一个警戒状态。如果有警告延迟的，需要直接跳过延迟阶段。
			if self.MonsterCommonParam.inPeace==false
				and self.MonsterCommonParam.ecoMe
				and BehaviorFunctions.CheckEcoEntityGroup(self.MonsterCommonParam.ecoMe)==true --检测是否有生态分组
				and (BehaviorFunctions.GetEntityValue(self.MonsterCommonParam.me,"warnState")==nil or BehaviorFunctions.GetEntityValue(self.MonsterCommonParam.me,"warnState")==false) then --只需要改一次状态
				BehaviorFunctions.SetEntityValue(self.MonsterCommonParam.me,"warnState",true) --警告状态，仅用于脱战。
				--索敌
				BehaviorFunctions.AddFightTarget(self.MonsterCommonParam.me,self.MonsterCommonParam.battleTarget)
			end
			--无警戒状态直接进入战斗
		else
			if self.MonsterCommonParam.inFight == false then
				if self.MonsterCommonParam.noWarnInFightRange > 0 and self.MonsterCommonParam.battleTargetDistance < self.MonsterCommonParam.noWarnInFightRange then
					BehaviorFunctions.AddFightTarget(self.MonsterCommonParam.me,self.MonsterCommonParam.battleTarget)
					self.MonsterCommonParam.inFight = true
					self.MonsterCommonParam.inPeace = false
				elseif self.MonsterCommonParam.noWarnInFightRange == 0 then
					BehaviorFunctions.AddFightTarget(self.MonsterCommonParam.me,self.MonsterCommonParam.battleTarget)
					self.MonsterCommonParam.inFight = true
					self.MonsterCommonParam.inPeace = false
				end
			end
		end
	end
	if self.MonsterCommonParam.inPeace == false and self.MonsterCommonParam.addLifeBar== true then
		if self.MonsterCommonParam.lifeBarDistance == nil
			or (self.MonsterCommonParam.lifeBarDistance ~= nil
				and self.MonsterCommonParam.lifeBarDistance >self.MonsterCommonParam.battleTargetDistance) then
			BehaviorFunctions.SetEntityLifeBarVisibleType(self.MonsterCommonParam.me,2)
			self.MonsterCommonParam.addLifeBar= false
		end
	end
	
	if self.MonsterCommonParam.exitFightState == self.MonsterCommonParam.ExitFightStateEnum.Exiting then
		self.isAngleIn = false
	end
	
	if self.MonsterCommonParam.inFight == true then
		--and self.MonsterCommonParam.warnState ~= self.MonsterCommonParam.warnStateEnum.WarnDone
		--and self.MonsterCommonParam.haveWarn == false then
		--self.MonsterCommonParam.haveWarn = true
		--self.MonsterCommonParam.warnState = self.MonsterCommonParam.warnStateEnum.Warning
		BehaviorFunctions.ShowQuestionAlertnessUI(self.MonsterCommonParam.me, false)
	end
	
end

function MonsterWarn:BreakSkill(instanceId,skillId,skillSign,skillType)
	if skillId == 62001010 then
		--self.MonsterCommonParam.warnState = self.MonsterCommonParam.warnStateEnum.Warning
		self.isLige = false
	end
end

--受击进入warnning状态
function MonsterWarn:Collide(attackInstanceId,hitInstanceId,instanceId)
	if (attackInstanceId == self.MonsterCommonParam.battleTarget or (BehaviorFunctions.GetEntityOwner(attackInstanceId) and BehaviorFunctions.GetEntityOwner(attackInstanceId) ==self.MonsterCommonParam.battleTarget)
		or BehaviorFunctions.GetCampType(attackInstanceId) ~= 2)
		and hitInstanceId == self.MonsterCommonParam.me
		and self.MonsterCommonParam.haveWarn == true 
		and self.MonsterCommonParam.inFight ==false
		and self.MonsterCommonParam.warnState ~= self.MonsterCommonParam.warnStateEnum.Warning
		and not BehaviorFunctions.HasEntitySign(self.MonsterCommonParam.battleTarget,610025) then
		--and not BehaviorFunctions.HasBuffKind(self.MonsterCommonParam.me,900000007) then
		--if not BehaviorFunctions.HasBuffKind(self.MonsterCommonParam.me,900000001) 
			--and self.beHit == false
			--and self.MonsterCommonParam.warnSkillId then
			--BehaviorFunctions.AddBuff(1,self.MonsterCommonParam.me,900000001)
			--self.beHit = true
		--end
		self.MonsterCommonParam.inPeace = false
		self.MonsterCommonParam.warnState = self.MonsterCommonParam.warnStateEnum.Warning
	end
	
	--被暗杀直接进入战斗，跳过表演
	if hitInstanceId == self.MonsterCommonParam.me and 
		(BehaviorFunctions.GetEntityTemplateId(instanceId) == 62001004001 
		or BehaviorFunctions.GetEntityTemplateId(instanceId) == 62001009001
		or BehaviorFunctions.GetEntityTemplateId(instanceId) == 610025012001) then
		self.MonsterCommonParam.warnState = self.MonsterCommonParam.warnStateEnum.Default
		BehaviorFunctions.AddFightTarget(self.MonsterCommonParam.me,self.MonsterCommonParam.battleTarget)
		self.MonsterCommonParam.inPeace = false
		self.MonsterCommonParam.inFight = true
	end
end 

--赋值
function MonsterWarn:Assignment(variable,value)
	self.MonsterCommonParam[variable] = value
end

----警告技能监听
----打断
--function MonsterWarn:BreakSkill(instanceId,skillId,skillSign,skillType)
	--if instanceId == self.MonsterCommonParam.me and skillId == self.MonsterCommonParam.warnSkillId then
		----移除behit霸体
		--if self.beHit == true and BehaviorFunctions.HasBuffKind(self.MonsterCommonParam.me,900000001) then
			--BehaviorFunctions.RemoveBuff(self.MonsterCommonParam.me,900000001)
			--self.beHit = false
		--end
	--end
--end
----完成
--function MonsterWarn:FinishSkill(instanceId,skillId,skillSign,skillType)
	--if instanceId == self.MonsterCommonParam.me and skillId == self.MonsterCommonParam.warnSkillId then
		----移除behit霸体
		--if self.beHit == true and BehaviorFunctions.HasBuffKind(self.MonsterCommonParam.me,900000001) then
			--BehaviorFunctions.RemoveBuff(self.MonsterCommonParam.me,900000001)
			--self.beHit = false
		--end
	--end
--end