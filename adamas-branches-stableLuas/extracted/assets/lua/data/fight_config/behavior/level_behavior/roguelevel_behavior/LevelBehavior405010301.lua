LevelBehavior405010301 = BaseClass("LevelBehavior405010301",LevelBehaviorBase)
--阻止抢劫，需要必须让玩家回到载具？

function LevelBehavior405010301:__init(fight)
	self.fight = fight
end


function LevelBehavior405010301.GetGenerates()
	local generates = {2040802,2040803,900070,8011001,203020601,200000101,600080}
	return generates
end


function LevelBehavior405010301:Init()
	self.role = 0
	self.initState = 0
	self.missionState = 0
	self.createState = 0
	
	self.car = 0
	self.aiCar = 0
	self.onCar = 0
	self.carCur = 0
	
	self.carPos = 0
	self.rolePos = 0
	self.dis = 0
	
	self.inArea = 0
	self.progress1 = 0
	self.progress2 = 0
	
	self.monster1 = 0
	self.monster2 = 0
	self.monsterNum = 0
	self.monLev = 5
	
	self.npc = 0
	self.npcState = 0
	self.npcPos = 0
	self.interactEmpty = 0 --npc处交互空实体
	
	self.tipState = 0 --装备箴石之劣提醒
	
	
	self.drop = 0
	
	self.position = {}
	
	self.dialogList = 
	{
		[1] = {id = 602040101},
		[2] = {id = 602040201},
		[3] = {id = 602040301},
		[4] = {id = 602040401},
		[5] = {id = 602040501},
		[6] = {id = 602040601},
	}
	self.guidePointer = 0
	self.guidePointer2 = 0
	
	--驾驶骇入相关-------
	self.zszlOn = nil  --是否装备箴石之劣
	self.hackId = 0
	self.driveHack = false
	self.PartnerPosDrive = {x = -2, y = 0, z = 0}
	-------
	
	------追踪标--- -----------------------------------------------------------------------------------------------------
	self.guide = nil
	self.guideEntity = nil
	self.guideDistance = 70
	self.guidePos = nil
	self.GuideTypeEnum = {
		Police = FightEnum.GuideType.Rogue_Police,
		Challenge = FightEnum.GuideType.Rogue_Challenge,
		Riddle = FightEnum.GuideType.Rogue_Riddle,
	}
	----------------
	
end

function LevelBehavior405010301:Update()
	self.time = BehaviorFunctions.GetFightFrame()
	self.role = BehaviorFunctions.GetCtrlEntity()
	self.onCar = BehaviorFunctions.CheckEntityDrive(self.role)
	if BehaviorFunctions.GetDrivingEntity(self.role) then
		self.carCur = BehaviorFunctions.GetDrivingEntity(self.role)
	end
	
	if BehaviorFunctions.GetPartnerInstanceId(self.role) then  --驾驶骇入相关
		local partner = BehaviorFunctions.GetPartnerInstanceId(self.role)
		if BehaviorFunctions.GetEntityTemplateId(partner) == 600080 then
			self.partner = BehaviorFunctions.GetPartnerInstanceId(self.role)
			self.zszlOn = 1
			
		elseif BehaviorFunctions.GetEntityTemplateId(partner) ~= 600080 then
			self.zszlOn = 0
		end
		
	elseif not BehaviorFunctions.GetPartnerInstanceId(self.role) then
		self.zszlOn = 0
	end

	--关卡追踪标
	if self.guidePos and self.initState < 4 then
		local pos = BehaviorFunctions.GetTerrainPositionP(self.guidePos.position,self.guidePos.positionId,self.guidePos.logicName)
		self:RogueGuidePointer(pos,self.guideDistance,self.GuideTypeEnum.Police)
	else
		if self.rogueEventId then
			self.guidePos = BehaviorFunctions.GetRoguelikePointInfo(self.rogueEventId)
		end
	end
	
	--初始流程
	if self.initState == 0 then
		BehaviorFunctions.SetTrafficMode(2)
		local carPos = BehaviorFunctions.GetTerrainPositionP("R1Car1",10020005,"RogueDrive")
		local carlook = BehaviorFunctions.GetTerrainPositionP("R1CarLook1",10020005,"RogueDrive")
		self.car = BehaviorFunctions.CreateEntity(2040803,nil,carPos.x,carPos.y,carPos.z,carlook.x,carlook.y,carlook.z,self.levelId,nil)

		local aiCarPos = BehaviorFunctions.GetTerrainPositionP("R1AICar1",10020005,"RogueDrive")
		local look = BehaviorFunctions.GetTerrainPositionP("R1AICarLook1",10020005,"RogueDrive")
		self.aiCar = BehaviorFunctions.CreateEntity(2040802,nil,aiCarPos.x,aiCarPos.y,aiCarPos.z,look.x,look.y,look.z,self.levelId,nil)
		--屏蔽车交互
		BehaviorFunctions.SetEntityWorldInteractState(self.aiCar, false)
		BehaviorFunctions.SetEntityWorldInteractState(self.car, false)
		
		local monPos = BehaviorFunctions.GetTerrainPositionP("R1Mon1",10020005,"RogueDrive")
		self.npcPos = BehaviorFunctions.GetTerrainPositionP("R1NPC1",10020005,"RogueDrive")
		self.monster1 = BehaviorFunctions.CreateEntity(900070,nil,monPos.x,monPos.y,monPos.z,self.npcPos.x,self.npcPos.y,self.npcPos.z,self.levelId,5)
		self.npc = BehaviorFunctions.CreateEntity(8011001,nil,self.npcPos.x,self.npcPos.y,self.npcPos.z,monPos.x,monPos.y,monPos.z,self.levelId,nil)
		
		BehaviorFunctions.RemoveBehavior(self.monster1)  --让怪物能移动
		BehaviorFunctions.StartStoryDialog(self.dialogList[1].id)
		self.initState = 1
	end
	
	--流程开始
	if self.initState == 2 then
		local dis = BehaviorFunctions.GetDistanceFromTarget(self.role,self.npc)
		if dis < 50 then
			BehaviorFunctions.ShowCommonTitle(7,"发现城市威胁",true)
			
			self.initState = 3
		end
	end
	--
	
	if self.initState == 3 then
		local x,y,z = BehaviorFunctions.GetEntityTransformPos(self.aiCar,"GetInCarLeftCheck")
		self.position.x = x
		self.position.y = y
		self.position.z = z
		--if BehaviorFunctions.GetEntityState(self.monster1) ~= FightEnum.EntityState.Move then
			--BehaviorFunctions.DoLookAtTargetImmediately(self.monster1,self.aiCar)
			--BehaviorFunctions.DoSetEntityState(self.monster1,FightEnum.EntityState.Move)
		--end
		
		if BehaviorFunctions.HasBuffKind(self.monster1,900000045) == false then
			BehaviorFunctions.AddBuff(self.monster1,self.monster1,900000045)    --加霸体防止打断
		end
		if BehaviorFunctions.HasBuffKind(self.monster1,900000007) == false then
			BehaviorFunctions.AddBuff(self.monster1,self.monster1,900000007)    --加无敌防止打死
		end
		
		BehaviorFunctions.StartStoryDialog(self.dialogList[2].id)
		BehaviorFunctions.DoLookAtTargetImmediately(self.npc,self.role)
		self.initState = 4
	end

	if self.initState == 4 then
		local monPos = BehaviorFunctions.GetPositionP(self.monster1)
		local distance = BehaviorFunctions.GetDistanceFromPos(monPos,self.position)
		
		if distance < 5 then
			BehaviorFunctions.RemoveEntityGuidePointer(self.guide)  --移除rogue追踪
			
			BehaviorFunctions.PlayAnimation(self.aiCar,"GetInCar")
			BehaviorFunctions.RemoveEntity(self.monster1)
			BehaviorFunctions.StartCarRoute(self.aiCar,200,1)

			self.guidePointer = BehaviorFunctions.AddEntityGuidePointer(self.aiCar,self.GuideTypeEnum.Police,0,false)
			self.guidePointer2 = BehaviorFunctions.AddEntityGuidePointer(self.car,self.GuideTypeEnum.Police,0,false)
			BehaviorFunctions.ShowTip(40000000)
			
			--看ai车相机
			self.levelCam = BehaviorFunctions.CreateEntity(22001)
			BehaviorFunctions.CameraEntityFollowTarget(self.levelCam,self.role,"CameraTarget")
			BehaviorFunctions.CameraEntityLockTarget(self.levelCam,self.aiCar,"HitCase")
			BehaviorFunctions.DoLookAtTargetImmediately(self.role,self.aiCar)
			BehaviorFunctions.AddDelayCallByFrame(90,BehaviorFunctions,BehaviorFunctions.RemoveEntity,self.levelCam)
			
			BehaviorFunctions.AddDelayCallByFrame(120,self,self.Assignment,"initState",6)
			self.initState = 5
		end
	end
	
	if self.initState > 2 and self.initState < 5 then
		if BehaviorFunctions.GetEntityState(self.monster1) ~= FightEnum.EntityState.Move then
			BehaviorFunctions.DoLookAtTargetImmediately(self.monster1,self.aiCar)
			BehaviorFunctions.DoSetEntityState(self.monster1,FightEnum.EntityState.Move)
		end
	end
	
	if self.initState == 6 then
		BehaviorFunctions.SetEntityWorldInteractState(self.car,true)
		--看车相机
		self.levelCam = BehaviorFunctions.CreateEntity(22001)
		BehaviorFunctions.CameraEntityFollowTarget(self.levelCam,self.role,"CameraTarget")
		BehaviorFunctions.CameraEntityLockTarget(self.levelCam,self.car,"HitCase")
		BehaviorFunctions.DoLookAtTargetImmediately(self.role,self.car)
		BehaviorFunctions.AddDelayCallByFrame(45,BehaviorFunctions,BehaviorFunctions.RemoveEntity,self.levelCam)
		self.initState = 7
	end

	if self.missionState == 0 then
		if self.onCar == true and self.carCur == self.car then
			BehaviorFunctions.ShowTip(40000001)
			BehaviorFunctions.ChangeSubTipsDesc(1,40000001,self.progress2 .. "%")
			BehaviorFunctions.RemoveEntityGuidePointer(self.guidePointer2)
			self.missionState = 1
		end
	end
	
	--距离判断
	if self.missionState == 1 then
		self.dis = BehaviorFunctions.GetDistanceFromTarget(self.aiCar,self.role)
		
		if self.onCar == true and self.carCur == self.car then --在车上
			
			if self.tipState == 1 then
				self.guidePointer = BehaviorFunctions.AddEntityGuidePointer(self.aiCar,self.GuideTypeEnum.Police,0,false)
				if self.guidePointer2 then
					BehaviorFunctions.RemoveEntityGuidePointer(self.guidePointer2)
				end
				self.tipState = 0
			end
			
			--在区域内
			if self.dis ~= 0 and self.dis < 30 then		
				if self.inArea == 0 then
					self.inArea = 1
					self.startTime = BehaviorFunctions.GetFightFrame()
				end
		
				if self.inArea == 1 then
					local timechange = self.time - self.startTime
					self.progress1 = math.floor(timechange/3)
					--骇入表现
					self.hackId = self.aiCar
					self:DriveHack(self.car,self.aiCar)
					self:DriveHackLine(self.aiCar,"HitCase")
					--骇入表现
					
					if self.progress1 >= 1 then
						self.startTime = BehaviorFunctions.GetFightFrame()
					end
		
					if self.progress2 < 100 then
						self.progress2 = self.progress2 + self.progress1
						BehaviorFunctions.ChangeSubTipsDesc(1,40000001,self.progress2 .. "%")
		
					elseif self.progress2 >= 100 then
						BehaviorFunctions.EndCarRoute(self.aiCar)
						local aiCarPos = BehaviorFunctions.GetPositionP(self.aiCar)
						self.fxBoom = BehaviorFunctions.CreateEntity(203020601,nil,aiCarPos.x,aiCarPos.y,aiCarPos.z,nil,nil,nil,self.levelId)
						
						BehaviorFunctions.PlayAnimation(self.aiCar,"GetOffCar")
						BehaviorFunctions.StartStoryDialog(self.dialogList[5].id)
						BehaviorFunctions.ShowTip(40000002)
						self.x,self.y,self.z = BehaviorFunctions.GetEntityTransformPos(self.aiCar,"GetInCarLeftCheck")
						local lookPos = BehaviorFunctions.GetPositionP(self.role)
						self.monster2 = BehaviorFunctions.CreateEntity(900070,nil,self.x,self.y,self.z,lookPos.x,lookPos.y,lookPos.z,self.levelId,self.monLev)
						self.monsterNum = self.monsterNum + 1
						
						BehaviorFunctions.GetOffCar(self.car)
						BehaviorFunctions.RemoveEntityGuidePointer(self.guidePointer)
						self:QuitDriveHack() --取消骇入表现
		
						BehaviorFunctions.DoLookAtTargetImmediately(self.monster2,self.role)
						BehaviorFunctions.SetEntityValue(self.monster2,"haveWarn",false)
						BehaviorFunctions.ShowTip(40000003)
						BehaviorFunctions.ChangeSubTipsDesc(1,40000003,self.monsterNum)
						self.missionState = 2
						self.inArea = 2
					end
				end
			end
		
			--在区域外
			if self.dis > 30 then		
				self.inArea = 0
				self:QuitDriveHack()
			end
		
		elseif self.onCar == false then
			self.startTime = BehaviorFunctions.GetFightFrame() --处理下车后一直呆在区域内，上车后进度积累不正确的问题
			self:QuitDriveHack() --取消骇入表现
			if self.tipState == 0 then
				self.guidePointer2 = BehaviorFunctions.AddEntityGuidePointer(self.car,self.GuideTypeEnum.Police,0,false)
				BehaviorFunctions.ShowTip(40000009)--返回车辆以继续
				--移除ai车追踪
				if self.guidePointer then
					BehaviorFunctions.RemoveEntityGuidePointer(self.guidePointer)
				end
				self.tipState = 1
			end
		end
	end
end

function LevelBehavior405010301:Death(instanceId, isFormationRevive)
	if instanceId == self.monster2 then
		self.monsterNum = self.monsterNum - 1
		local pos = BehaviorFunctions.GetPositionP(instanceId)
		self.drop = BehaviorFunctions.CreateEntity(2020702,nil,pos.x,pos.y,pos.z,nil,nil,nil,self.levelId,nil)
		BehaviorFunctions.ChangeSubTipsDesc(1,40000003,self.monsterNum)
		BehaviorFunctions.ShowTip(40000006)
		self.guideDrop = BehaviorFunctions.AddEntityGuidePointer(self.drop,self.GuideTypeEnum.Police,0,false)
		self.missionState = 11
	end
end

function LevelBehavior405010301:WorldInteractClick(uniqueId, instanceId)
	--if instanceId == self.car then  ----需新接口判断处于驾驶状态
		--if self.missionState == 0 then
			--BehaviorFunctions.ShowTip(40000001)
			--BehaviorFunctions.ChangeSubTipsDesc(1,40000001,self.progress2 .. "%")
			--BehaviorFunctions.RemoveEntityGuidePointer(self.guidePointer2)
			--self.missionState = 1
		--end
	--end
	
	if instanceId == self.drop then
		BehaviorFunctions.RemoveEntity(self.drop)
		BehaviorFunctions.ShowTip(40000007)
		--npc处交互空实体、加追踪
		self.interactEmpty = BehaviorFunctions.CreateEntity(200000101,nil,self.npcPos.x,self.npcPos.y,self.npcPos.z,nil,nil,nil,self.levelId)
		BehaviorFunctions.ChangeWorldInteractInfo(self.interactEmpty,"Textures/Icon/Single/FuncIcon/Trigger_look.png","交互")
		self.guideNPC = BehaviorFunctions.AddEntityGuidePointer(self.interactEmpty,self.GuideTypeEnum.Police,0,false)
	end
	
	if instanceId == self.interactEmpty then
		BehaviorFunctions.SetEntityWorldInteractState(self.interactEmpty,false)
		BehaviorFunctions.StartStoryDialog(self.dialogList[6].id)
	end
end

function LevelBehavior405010301:EndRogue()
	BehaviorFunctions.ShowCommonTitle(8,"已清除城市威胁",true)
	BehaviorFunctions.HideTip()
	BehaviorFunctions.RemoveLevel(self.levelId)
	BehaviorFunctions.SetRoguelikeEventCompleteState(self.rogueEventId,true)
end

function LevelBehavior405010301:StoryEndEvent(dialogId)
	if dialogId == self.dialogList[1].id then
		self.initState = 2
	end
	
	if dialogId == self.dialogList[2].id then
		BehaviorFunctions.StartStoryDialog(self.dialogList[3].id)
	end
	
	if dialogId == self.dialogList[3].id then
		BehaviorFunctions.StartStoryDialog(self.dialogList[4].id)
	end
	
	if dialogId == self.dialogList[6].id then
		BehaviorFunctions.ShowBlackCurtain(true,1)
		BehaviorFunctions.AddDelayCallByFrame(60,BehaviorFunctions,BehaviorFunctions.ShowBlackCurtain,false,1)
		BehaviorFunctions.AddDelayCallByFrame(65,self,self.EndRogue)
	end
end

--赋值
function LevelBehavior405010301:Assignment(variable,value)
	self[variable] = value
end


--驾驶骇入
function LevelBehavior405010301:DriveHack(bindTarget, hackTarget)
	if self.zszlOn == 1 then
		if BehaviorFunctions.GetEntityTemplateId(self.partner) and BehaviorFunctions.GetEntityTemplateId(self.partner) == 600080 then --装备箴石之劣的角色是否出战
			if self.driveHack == false then
				self.driveHack = true
				--BehaviorFunctions.EnterHackingMode() --进入骇入模式
				--local Pos = BF.GetPositionOffsetBySelf(self.role,0.5,0) --获得角色周围的位置
				--BF.DoSetPosition(self.partner,Pos.x - 2,Pos.y,Pos.z - 0.3)	--设置召唤位置
				--BehaviorFunctions.CastSkillBySelfPosition(self.partner,600080004)
	
				BehaviorFunctions.BindTransform(self.partner,"",self.PartnerPosDrive,bindTarget) --绑定载具，不然表现有问题
	
				--如果有选择目标，则朝向目标，如果无目标则朝向前方
				if hackTarget then
					BehaviorFunctions.DoLookAtTargetImmediately(self.partner,hackTarget,"CameraTarget",true)	--设置朝向目标
				else
					BehaviorFunctions.DoLookAtPositionImmediately(self.partner,self.roleFrontPos.x,self.roleFrontPos.y,self.roleFrontPos.z,true)	--设置朝向
				end
	
				--self.hackState = self.hackStateEnum.HackStart --设置为“刚开始骇入”的状态
				--BehaviorFunctions.RemoveKeyPress(FightEnum.KeyEvent.Partner) --移除仲魔技能长按状态
				--self.hackState = self.hackStateEnum.Hack --设置在骇入模式的状态
	
				--特殊buff
				BehaviorFunctions.SetUseParentTimeScale(self.partner, false)--不使用创建者时间缩放
				BehaviorFunctions.DoMagic(self.partner,self.partner,1000055,1)	--仲魔召唤技能无敌buff
				BehaviorFunctions.DoMagic(self.partner,self.partner,600000014,1)	--允许穿墙buff
				BehaviorFunctions.DoMagic(self.partner,self.partner,600000016,1)	--浮空buff
	
				--出场表现
				BehaviorFunctions.CallCommonBehaviorFunc(self.partner, "StopPartnerLeave")	--打断佩从离场流程
				BehaviorFunctions.ShowPartner(self.role, true)	--显示仲魔
				
				--	BehaviorFunctions.RemoveEntitySign(self.partner,600003)	--移除主动技能在场状态
				BehaviorFunctions.CastSkillBySelfPosition(self.partner,60008060)--使用进入骇入模式的技能
				--BehaviorFunctions.CreateEntity(600000002,self.partner) --创建出场特效
				--self.fxhack = BehaviorFunctions.CreateEntity(6000800101,self.partner) --创建花臂特效
				--BehaviorFunctions.PlayAnimation(self.fxhack,"FxHackFast_Begin_Ani") --播放花臂特效的出场动作
				self.fxhackDriveScreen = BehaviorFunctions.CreateEntity(6000800102,self.partner)
				BehaviorFunctions.PlayAnimation(self.fxhackDriveScreen,"FxHackArmScreen_Begin_Ani") --播放花臂屏幕特效的出场动作
				--BehaviorFunctions.DoEntityAudioPlay(self.partner,"Hack_Start",true)--播放音效
			
				--创建驾驶的链接特效
				if self.fxhackDriveLine then
				else
					self.fxhackDriveLine = BehaviorFunctions.CreateEntity(6000800302,self.partner,0,0,0)
					BehaviorFunctions.ClientEffectRelation(self.fxhackDriveLine,self.partner,"WeaponCaseLeft",self.partner,"WeaponCaseLeft",0)
				end
			end
		end
		
	--未装备箴石之劣佩从情况
	elseif self.zszlOn == 0 then
		if self.driveHack == false then
			self.driveHack = true
			--创建驾驶的链接特效
			if self.fxhackDriveLine then
			else
				self.fxhackDriveLine = BehaviorFunctions.CreateEntity(6000800302,self.car,0,0,0) --需在car预设中新增一个与特效出生点匹配的挂点
				BehaviorFunctions.ClientEffectRelation(self.fxhackDriveLine,self.car,"WeaponCaseLeft",self.car,"WeaponCaseLeft",0)
			end
		end
	end
end

--使用骇入连线
function LevelBehavior405010301:DriveHackLine(target,targetDot)
	if self.zszlOn == 1 then
		--出战角色装备箴石之劣
		if BehaviorFunctions.GetEntityTemplateId(self.partner) == 600080 then 
			if self.driveHack == true then
				if self.fxhackDriveLine and target then
					self.fxhackDriveLineDis = BehaviorFunctions.GetTransformDistance(self.partner,"WeaponCaseLeft",target,targetDot)
					BehaviorFunctions.ClientEffectRelation(self.fxhackDriveLine,self.partner,"WeaponCaseLeft",self.hackId,targetDot,self.fxhackDriveLineDis)
				end
			end
		end
		--未装备箴石之劣
	elseif self.zszlOn == 0 then
		if self.driveHack == true then
			if self.fxhackDriveLine and target then
				self.fxhackDriveLineDis = BehaviorFunctions.GetTransformDistance(self.car,"WeaponCaseLeft",target,targetDot)
				BehaviorFunctions.ClientEffectRelation(self.fxhackDriveLine,self.car,"WeaponCaseLeft",self.hackId,targetDot,self.fxhackDriveLineDis)
			end
		end
	end
end

--退出驾驶骇入
function LevelBehavior405010301:QuitDriveHack()
	if self.zszlOn == 1 then
		if BehaviorFunctions.GetEntityTemplateId(self.partner) == 600080 then --装备箴石之劣的角色是否出战
			if self.driveHack == true then
				BehaviorFunctions.RemoveBindTransform(self.partner)	--取消绑定
				--BehaviorFunctions.RemoveEntity(self.fxhackDriveLine) --去除线特效
				BehaviorFunctions.ShowPartner(self.role, false)	--隐藏仲魔
				BehaviorFunctions.BreakSkill(self.partner)
				BehaviorFunctions.CastSkillBySelfPosition(self.partner,60008020)
				self.driveHack = false
	
				if self.fxhackDriveLine then
					BehaviorFunctions.RemoveEntity(self.fxhackDriveLine)
					self.fxhackDriveLine = nil
				end
			end
		end
	--未装备箴石之劣
	elseif self.zszlOn == 0 then
		if self.driveHack == true then
			--BehaviorFunctions.RemoveBindTransform(self.car)	--取消绑定
			self.driveHack = false

			if self.fxhackDriveLine then
				BehaviorFunctions.RemoveEntity(self.fxhackDriveLine)
				self.fxhackDriveLine = nil
			end
		end
	end
end

--肉鸽追踪
function LevelBehavior405010301:RogueGuidePointer(guidePos,guideDistance,guideType)
	local playerPos = BehaviorFunctions.GetPositionP(self.role)
	local distance = BehaviorFunctions.GetDistanceFromPos(playerPos,guidePos)
	if distance <= guideDistance then
		if not self.guide then
			self.guideEntity = BehaviorFunctions.CreateEntity(2001,nil,guidePos.x,guidePos.y,guidePos.z,nil,nil,nil,self.levelId)
			self.guide = BehaviorFunctions.AddEntityGuidePointer(self.guideEntity,guideType,0,false)
		end
	else
		--移除追踪标空实体
		if self.guideEntity and BehaviorFunctions.CheckEntity(self.guideEntity) then
			BehaviorFunctions.RemoveEntity(self.guideEntity)
			self.guideEntity = nil
		end
		--移除追踪标
		BehaviorFunctions.RemoveEntityGuidePointer(self.guide)
		self.guide = nil
	end
end

--车辆按路点移动结束后回调
function LevelBehavior405010301:onTrackPointMoveEnd(targetInstanceId)
	if targetInstanceId ~= self.aiCar then
		return
	end
	
	if targetInstanceId == self.aiCar then
		BehaviorFunctions.StartCarRoute(self.aiCar,200,1)
	end
end