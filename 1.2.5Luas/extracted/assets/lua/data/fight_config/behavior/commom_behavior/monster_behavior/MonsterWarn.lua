MonsterWarn = BaseClass("MonsterWarn",EntityBehaviorBase)
--警戒状态
function MonsterWarn:Init()
	self.MonsterCommonBehavior = self.ParentBehavior
	self.MonsterCommonParam = self.MainBehavior.MonsterCommonParam
	self.warnFrame = 0
	self.beHit = false
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
			if self.MonsterCommonParam.inPeace == true then

				--极限近身检测
				if self.MonsterCommonParam.battleTargetDistance <= self.MonsterCommonParam.warnLimitRange 
					and height <= self.MonsterCommonParam.warnLimitHeight then  --无论通过什么手段进入警告状态，warnState都应该是true。
					self.warnFrame = self.MonsterCommonParam.myFrame
					self.MonsterCommonParam.warnState = self.MonsterCommonParam.warnStateEnum.Warning
					self.MonsterCommonParam.inPeace = false
					--近距离疑问检测
				elseif self.MonsterCommonParam.battleTargetDistance <= self.MonsterCommonParam.warnShortRange 
					and height <= self.MonsterCommonParam.warnLimitHeight then  --无论通过什么手段进入警告状态，warnState都应该是true。
					self.warnFrame = self.MonsterCommonParam.myFrame
					self.MonsterCommonParam.warnState = self.MonsterCommonParam.warnStateEnum.GetReadyToWarn
					self.MonsterCommonParam.inPeace = false
					--视野范围内检测
				elseif self.MonsterCommonParam.battleTargetDistance <= self.MonsterCommonParam.warnLongRange
					and BehaviorFunctions.CompEntityLessAngle(self.MonsterCommonParam.me,self.MonsterCommonParam.battleTarget,self.MonsterCommonParam.warnVisionAngle/2) 
					and yAngle <= self.MonsterCommonParam.warnVisionAngle/2
					and not BehaviorFunctions.HasEntitySign(self.MonsterCommonParam.battleTarget,610025) then
					self.warnFrame = self.MonsterCommonParam.myFrame
					self.MonsterCommonParam.warnState = self.MonsterCommonParam.warnStateEnum.GetReadyToWarn
					self.MonsterCommonParam.inPeace = false
				end

				--安琪写的生态监测
				if self.MonsterCommonParam.ecoMe
					and BehaviorFunctions.CheckEcoEntityGroup(self.MonsterCommonParam.ecoMe)
					and BehaviorFunctions.CheckEcoEntityGroup(self.MonsterCommonParam.ecoMe) ==true
					and BehaviorFunctions.GetEntityValue(self.MonsterCommonParam.me,"monsterBeWarned")  --当外部传入的警告存在时
					and  BehaviorFunctions.GetEntityValue(self.MonsterCommonParam.me,"monsterBeWarned")==true then  --当外部传入的警告是true时，进入警告状态。
					self.MonsterCommonParam.warnState = self.MonsterCommonParam.warnStateEnum.Warning
					self.MonsterCommonParam.inPeace = false
				end
			end


			--警戒延迟,如果延迟了足够时长后，每一帧都在警戒空间中，则会进入警戒状态。
			if self.MonsterCommonParam.warnState == self.MonsterCommonParam.warnStateEnum.GetReadyToWarn
				 and not BehaviorFunctions.HasEntitySign(self.MonsterCommonParam.battleTarget,62001001) then--刺杀标记
				if not BehaviorFunctions.HasBuffKind(self.MonsterCommonParam.me,900000024) then
					BehaviorFunctions.AddBuff(self.MonsterCommonParam.me,self.MonsterCommonParam.me,900000024)
				end
				
				if self.MonsterCommonParam.myFrame - self.warnFrame >= self.MonsterCommonParam.warnDelayTime*30 then
					if self.MonsterCommonParam.battleTargetDistance <= self.MonsterCommonParam.warnShortRange then
						self.MonsterCommonParam.warnState = self.MonsterCommonParam.warnStateEnum.Warning
					elseif self.MonsterCommonParam.battleTargetDistance <= self.MonsterCommonParam.warnLongRange
						and BehaviorFunctions.CompEntityLessAngle(self.MonsterCommonParam.me,self.MonsterCommonParam.battleTarget,self.MonsterCommonParam.warnVisionAngle/2) then
						self.MonsterCommonParam.warnState = self.MonsterCommonParam.warnStateEnum.Warning
					else
						self.MonsterCommonParam.warnState = self.MonsterCommonParam.warnStateEnum.Default
						self.MonsterCommonParam.inPeace = true
					end
				end
				--安琪写的生态判断，后面删掉
				if self.MonsterCommonParam.ecoMe
					and BehaviorFunctions.CheckEcoEntityGroup(self.MonsterCommonParam.ecoMe)
					and BehaviorFunctions.CheckEcoEntityGroup(self.MonsterCommonParam.ecoMe) ==true
					and BehaviorFunctions.GetEntityValue(self.MonsterCommonParam.me,"monsterBeWarned")  --当外部传入的警告存在时
					and BehaviorFunctions.GetEntityValue(self.MonsterCommonParam.me,"monsterBeWarned")==true then  --当外部传入的警告是true时，进入警告状态。
					self.MonsterCommonParam.warnState = self.MonsterCommonParam.warnStateEnum.Warning
					self.MonsterCommonParam.inPeace = false 
				end
			end
			--警戒行为
			if self.MonsterCommonParam.warnState == self.MonsterCommonParam.warnStateEnum.Warning 
				and not BehaviorFunctions.HasEntitySign(self.MonsterCommonParam.battleTarget,62001001) then--刺杀标记
				BehaviorFunctions.AddFightTarget(self.MonsterCommonParam.me,self.MonsterCommonParam.battleTarget)
				self.MonsterCommonParam.inFight = true
				--移除问号
				if BehaviorFunctions.HasBuffKind(self.MonsterCommonParam.me,900000024)==true then
					BehaviorFunctions.RemoveBuff(self.MonsterCommonParam.me,900000024)
				end
				--添加叹号
				if not BehaviorFunctions.HasBuffKind(self.MonsterCommonParam.me,900000025) then
					BehaviorFunctions.AddBuff(self.MonsterCommonParam.me,self.MonsterCommonParam.me,900000025)
				end
				--释放警戒技能
				if  BehaviorFunctions.CanCtrl(self.MonsterCommonParam.me) then
					if self.MonsterCommonParam.warnSkillId then
						BehaviorFunctions.DoLookAtTargetImmediately(self.MonsterCommonParam.me,self.MonsterCommonParam.battleTarget)
						BehaviorFunctions.CastSkillByTarget(self.MonsterCommonParam.me,self.MonsterCommonParam.warnSkillId,self.MonsterCommonParam.battleTarget)
					end
				end	
				self.MonsterCommonParam.warnState = self.MonsterCommonParam.warnStateEnum.WarnDone
				if BehaviorFunctions.CheckEcoEntityGroup(self.MonsterCommonParam.ecoMe)
					and BehaviorFunctions.CheckEcoEntityGroup(self.MonsterCommonParam.ecoMe) == true then  --有组的时候警告别人哦，没组的时候就当这里放了个屁。
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
	
	
end


--受击进入warnning状态
function MonsterWarn:Collide(attackInstanceId,hitInstanceId,instanceId)
	if (attackInstanceId == self.MonsterCommonParam.battleTarget or (BehaviorFunctions.GetEntityOwner(attackInstanceId) and BehaviorFunctions.GetEntityOwner(attackInstanceId) ==self.MonsterCommonParam.battleTarget))
		and hitInstanceId == self.MonsterCommonParam.me
		and self.MonsterCommonParam.haveWarn == true 
		and self.MonsterCommonParam.inFight ==false
		and self.MonsterCommonParam.warnState ~= self.MonsterCommonParam.warnStateEnum.Warning
		and not BehaviorFunctions.HasEntitySign(self.MonsterCommonParam.battleTarget,610025) then
		--and not BehaviorFunctions.HasBuffKind(self.MonsterCommonParam.me,900000007) then
		--if not BehaviorFunctions.HasBuffKind(self.MonsterCommonParam.me,900000001) 
			--and self.beHit == false
			--and self.MonsterCommonParam.warnSkillId then
			--BehaviorFunctions.AddBuff(self.MonsterCommonParam.me,self.MonsterCommonParam.me,900000001)
			--self.beHit = true
		--end
		self.MonsterCommonParam.inPeace = false
		self.MonsterCommonParam.warnState = self.MonsterCommonParam.warnStateEnum.Warning
	end
	
	--被暗杀直接进入战斗，跳过表演
	if hitInstanceId == self.MonsterCommonParam.me and 
		(BehaviorFunctions.GetEntityTemplateId(instanceId) == 62001004001 
		or BehaviorFunctions.GetEntityTemplateId(instanceId) == 62001009001
		or BehaviorFunctions.GetEntityTemplateId(instanceId) == 610025012001)then
		self.MonsterCommonParam.warnState = self.MonsterCommonParam.warnStateEnum.Default
		BehaviorFunctions.AddFightTarget(self.MonsterCommonParam.me,self.MonsterCommonParam.battleTarget)
		self.MonsterCommonParam.inPeace = false
		self.MonsterCommonParam.inFight = true
	end
end

----警告技能监听
----打断
--function MonsterWarn:BreakSkill(instanceId,skillId,skillType)
	--if instanceId == self.MonsterCommonParam.me and skillId == self.MonsterCommonParam.warnSkillId then
		----移除behit霸体
		--if self.beHit == true and BehaviorFunctions.HasBuffKind(self.MonsterCommonParam.me,900000001) then
			--BehaviorFunctions.RemoveBuff(self.MonsterCommonParam.me,900000001)
			--self.beHit = false
		--end
	--end
--end
----完成
--function MonsterWarn:FinishSkill(instanceId,skillId,skillType)
	--if instanceId == self.MonsterCommonParam.me and skillId == self.MonsterCommonParam.warnSkillId then
		----移除behit霸体
		--if self.beHit == true and BehaviorFunctions.HasBuffKind(self.MonsterCommonParam.me,900000001) then
			--BehaviorFunctions.RemoveBuff(self.MonsterCommonParam.me,900000001)
			--self.beHit = false
		--end
	--end
--end