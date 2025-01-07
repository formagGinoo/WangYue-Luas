LevelBehavior302010101 = BaseClass("LevelBehavior302010101",LevelBehaviorBase)
--阻止抢劫，需要必须让玩家回到载具？

function LevelBehavior302010101:__init(fight)
	self.fight = fight
end


function LevelBehavior302010101.GetGenerates()
	local generates = {2040802,2040803,790014001,8011001,203020601,200000101,600080}
	return generates
end


function LevelBehavior302010101:Init()
	self.role = 0
	self.initState = 0
	self.missionState = 0
	self.createState = 0
	self.bgmState = 0
	self.npcState = 0
	
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
	self.monLevBias = {     --怪物世界等级偏移
		[FightEnum.EntityNpcTag.Monster] = -2,
		[FightEnum.EntityNpcTag.Elite] = 0,
		[FightEnum.EntityNpcTag.Boss] = 0,
	}
	
	--世界等级偏移计算
	local npcTag = BehaviorFunctions.GetTagByEntityId(790014001)
	local worldMonsterLevel = BehaviorFunctions.GetEcoEntityLevel(npcTag)
	local monsterLevel = worldMonsterLevel + self.monLevBias[npcTag]
	self.monLev = monsterLevel
	--
	
	self.npc = 0
	self.npcPos = 0
	self.interactEmpty = 0 --npc处交互空实体
	
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

	--驾驶骇入相关-------
	self.zszlOn = nil  --是否装备箴石之劣
	self.hackId = 0
	self.driveHack = false
	self.PartnerPosDrive = {x = -2, y = 0, z = 0}
	-------
end

function LevelBehavior302010101:Update()
	self.time = BehaviorFunctions.GetFightFrame()
	self.role = BehaviorFunctions.GetCtrlEntity()
	self.onCar = BehaviorFunctions.CheckEntityDrive(self.role)
	if BehaviorFunctions.GetDrivingEntity(self.role) then
		self.carCur = BehaviorFunctions.GetDrivingEntity(self.role)
		self.car = self.carCur
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

	--初始流程
	if self.initState == 0 then
		BehaviorFunctions.SetTrafficMode(2)
		local aiCarPos = BehaviorFunctions.GetTerrainPositionP("R1AICar1",10020005,"Task_Sub_Drive")
		local look = BehaviorFunctions.GetTerrainPositionP("R1AICarLook1",10020005,"Task_Sub_Drive")
		self.aiCar = BehaviorFunctions.CreateEntity(2040802,nil,aiCarPos.x,aiCarPos.y,aiCarPos.z,look.x,look.y,look.z,self.levelId,nil)
		--屏蔽车交互
		BehaviorFunctions.SetEntityWorldInteractState(self.aiCar, false)
		
		local monPos = BehaviorFunctions.GetTerrainPositionP("R1Mon1",10020005,"Task_Sub_Drive")
		self.npcPos = BehaviorFunctions.GetTerrainPositionP("R1NPC1",10020005,"Task_Sub_Drive")
		self.monster1 = BehaviorFunctions.CreateEntity(790014001,nil,monPos.x,monPos.y,monPos.z,self.npcPos.x,self.npcPos.y,self.npcPos.z,self.levelId,self.monLev)
		self.npc = BehaviorFunctions.CreateEntity(8011001,nil,self.npcPos.x,self.npcPos.y,self.npcPos.z,monPos.x,monPos.y,monPos.z,self.levelId,nil)
		
		BehaviorFunctions.RemoveBehavior(self.monster1)  --让怪物能移动

		self.initState = 1
	end
	
	--流程开始
	if self.initState == 1 then
		local dis = BehaviorFunctions.GetDistanceFromTarget(self.role,self.npc)
		if dis < 75 then
			BehaviorFunctions.ShowCommonTitle(7,"发现城市威胁",true)
			BehaviorFunctions.StartStoryDialog(self.dialogList[1].id)
			self.initState = 2
		end
	end
	--
	
	if self.initState == 3 then
		local x,y,z = BehaviorFunctions.GetEntityTransformPos(self.aiCar,"GetInCarLeftCheck")
		self.position.x = x
		self.position.y = y
		self.position.z = z
		local pos = BehaviorFunctions.GetTerrainPositionP("MonRoute1",self.levelId,"Task_Sub_Drive")
		BehaviorFunctions.DoLookAtPositionImmediately(self.monster1,pos.x,pos.y,pos.z)
		--BehaviorFunctions.SetPathFollowEntity(self.monster1,self.aiCar)
		if BehaviorFunctions.GetEntityState(self.monster1) ~= FightEnum.EntityState.Move then
			BehaviorFunctions.DoSetEntityState(self.monster1,FightEnum.EntityState.Move)
		end
		
		if BehaviorFunctions.HasBuffKind(self.monster1,900000045) == false then
			BehaviorFunctions.AddBuff(self.monster1,self.monster1,900000045)    --加霸体防止打断
		end
		if BehaviorFunctions.HasBuffKind(self.monster1,900000007) == false then
			BehaviorFunctions.AddBuff(self.monster1,self.monster1,900000007)    --加无敌防止打死
		end
		
		BehaviorFunctions.StartStoryDialog(self.dialogList[2].id)
		BehaviorFunctions.DoLookAtTargetImmediately(self.npc,self.role)
		self.initState = 31
	end
	
	if self.initState == 31 then
		BehaviorFunctions.DoLookAtTargetImmediately(self.monster1,self.aiCar)
		self.initState = 4
	end
	
	if self.initState == 4 then
		local monPos = BehaviorFunctions.GetPositionP(self.monster1)
		local distance = BehaviorFunctions.GetDistanceFromPos(monPos,self.position)
		if distance < 5 then
			BehaviorFunctions.PlayAnimation(self.aiCar,"GetInCar")
			BehaviorFunctions.RemoveEntity(self.monster1)
			BehaviorFunctions.StartCarRoute(self.aiCar,200,true)
			BehaviorFunctions.CarEnableCheckObstacle(self.aiCar,false)
			BehaviorFunctions.ShowTip(40000000)
			BehaviorFunctions.SetTaskGuideEntity(nil,self.aiCar,nil,nil,false,true) --给车加追踪
			
			self.initState = 5
			self.missionState = 1
		end
	end
	
	if self.bgmState == 0 then	--持续播bgm直至追车成功
		BehaviorFunctions.SetBgmState("BgmType","DriveGamePlay")
		BehaviorFunctions.SetBgmState("GamePlayType","TenseDrive")
	end
	
	if self.missionState == 1 then
		if self.onCar == true then
			BehaviorFunctions.ShowTip(40000001)
			BehaviorFunctions.ChangeSubTipsDesc(1,40000001,self.progress2 .. "%")
			self.missionState = 2
		end
	end
	
	--距离判断
	if self.missionState == 2 then
		self.dis = BehaviorFunctions.GetDistanceFromTarget(self.aiCar,self.role)
		
		if self.onCar == true then --在车上
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
						
						self.monster2 = BehaviorFunctions.CreateEntity(790014001,nil,self.x,self.y,self.z,lookPos.x,lookPos.y,lookPos.z,self.levelId,self.monLev)
						self.monsterNum = self.monsterNum + 1
						BehaviorFunctions.SetTaskGuideEntity(nil,self.monster2,nil,nil,false,false)  --切追踪目标为怪
						
						BehaviorFunctions.GetOffCar(self.car)
						self:QuitDriveHack() --取消骇入表现
		
						BehaviorFunctions.DoLookAtTargetImmediately(self.monster2,self.role)
						BehaviorFunctions.SetEntityValue(self.monster2,"haveWarn",false)
						BehaviorFunctions.ShowTip(40000003)
						BehaviorFunctions.ChangeSubTipsDesc(1,40000003,self.monsterNum)
						self.missionState = 3
						self.bgmState = 1
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
		end
	end
end

function LevelBehavior302010101:Death(instanceId, isFormationRevive)
	if instanceId == self.monster2 then
		self.monsterNum = self.monsterNum - 1
		local pos = BehaviorFunctions.GetPositionP(instanceId)
		self.drop = BehaviorFunctions.CreateEntity(2020702,nil,pos.x,pos.y,pos.z,nil,nil,nil,self.levelId,nil)
		BehaviorFunctions.ChangeSubTipsDesc(1,40000003,self.monsterNum)
		BehaviorFunctions.ShowTip(40000006)
		BehaviorFunctions.SetTaskGuideEntity(nil,self.drop,nil,nil,false,false)  --切追踪目标为掉落物
		self.missionState = 11
	end
end

function LevelBehavior302010101:WorldInteractClick(uniqueId, instanceId)
	if instanceId == self.drop then
		BehaviorFunctions.RemoveEntity(self.drop)
		BehaviorFunctions.ShowTip(40000007)
		--npc处交互空实体、加追踪
		self.interactEmpty = BehaviorFunctions.CreateEntity(200000101,nil,self.npcPos.x,self.npcPos.y,self.npcPos.z,nil,nil,nil,self.levelId)
		BehaviorFunctions.ChangeWorldInteractInfo(self.interactEmpty,"Textures/Icon/Single/FuncIcon/Trigger_look.png","交互")
		BehaviorFunctions.SetTaskGuideEntity(nil,self.interactEmpty,nil,nil,false,true)  --切追踪目标为npc交互空实体
	end
	
	if instanceId == self.interactEmpty then
		BehaviorFunctions.SetEntityWorldInteractState(self.interactEmpty,false)
		BehaviorFunctions.StartStoryDialog(self.dialogList[6].id)
	end
end

function LevelBehavior302010101:StoryEndEvent(dialogId)
	if dialogId == self.dialogList[1].id then
		self.initState = 3
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
		BehaviorFunctions.AddDelayCallByFrame(60,self,self.LevelFinish)
	end
end

function LevelBehavior302010101:LevelFinish()
	BehaviorFunctions.HideTip()
	BehaviorFunctions.FinishLevel(self.levelId)
end

--赋值
function LevelBehavior302010101:Assignment(variable,value)
	self[variable] = value
end


--驾驶骇入
function LevelBehavior302010101:DriveHack(bindTarget, hackTarget)
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
function LevelBehavior302010101:DriveHackLine(target,targetDot)
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
function LevelBehavior302010101:QuitDriveHack()
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

--车辆按路点移动结束后回调
function LevelBehavior302010101:onTrackPointMoveEnd(targetInstanceId)
	if targetInstanceId ~= self.aiCar then
		return
	end
	
	if targetInstanceId == self.aiCar then
		BehaviorFunctions.StartCarRoute(self.aiCar,200,true)
	end
end