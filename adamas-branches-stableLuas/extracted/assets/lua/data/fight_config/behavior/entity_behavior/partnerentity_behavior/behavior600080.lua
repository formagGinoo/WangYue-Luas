Behavior600080 = BaseClass("Behavior600080",EntityBehaviorBase)

local BF = BehaviorFunctions
local FES = FightEnum.EntityState
local FK = FightEnum.KeyEvent
local FE = FightEnum
local FEAS = FightEnum.EntityAimState
local FEET = FightEnum.ElementType
local FEAET = FightEnum.AnimEventType

local hackKeyType = {
	None = 0,
	ShortTouch = 1,
	LongTouch = 2
}

--资源预加载
function Behavior600080.GetGenerates()
	local generates = {6000800103,60008003011}
	return generates
end

function Behavior600080.GetMagics()
	local generates = {200001101,200001102,200001103,200001104,200001105,200001106,200001107,
						200001110,200001111,200001112,200001113,200001114,200001115,200001116,200001117,200001118,200001119,
						200001120,200001121,200001161,200001183,600000005,600000004}
	return generates
end

function Behavior600080:Init()
	self.me = self.instanceId	--记录自身
	--接入通用AI
	self.PartnerAllParm = BehaviorFunctions.CreateBehavior("PartnerAllParm",self)
	self.PartnerCastSkill = BehaviorFunctions.CreateBehavior("PartnerCastSkill",self)
	self.PartnerAllParm.autoRemove = false	--不自动退场
	self.PartnerAllParm.diyuePart = "Bip001 R Hand"
	self.mission = 0
	self.time = 0
	self.state = 0
	self.curShowPos = {}
	--骇入状态
	self.hackState = 0
	self.hackStateEnum = {
		HackStart = 0,
		Hack = 1,
		Hacking = 2,
		HackEnd = 3,
		Build = 4,
		Building = 5,
		BuildEnd = 6,
		Photo = 7
		}
	
	--是否骇入
	self.isHacking = false
	
	--缓存技能按钮
	self.curSkillId = 0
	
	--距离
	self.distance = 0
	
	--仲魔按钮长按区分变量
	self.hackFrame = 0
	self.hackbtnFrame = 45
	
	self.hackKey = 0
	self.hackPos = 0
	
	self.x =0
	self.y =0
	self.z =0
	
	self.PartnerPos = {x = 0.2, y = 0.2, z = -0.6}
	self.PartnerPosHack = {x = -0.5, y = 0, z = -0.4}
	self.PartnerPosBuild = {x = -0.5, y = 0, z = -0.4}
	self.bullet = 0
	self.tempCallback = nil
	
	self.hackId = nil
	self.hackEntity = 0
	self.hackEntityCur = false
	self.drive = 0 --是否开始驾驶无人机的判断
	self.diveId = 0
	
	self.hackMonitorId = nil --骇入的摄像头id
	self.hackMonitor = true --是否骇入摄像头
	
	----骇入特效相关-----------------------------------------------------------------------------------------
	self.fxhack = nil
	self.fxhackScreen = nil
	self.fxhacking = nil
	self.hackMonitor = false
	self.fxhackLine = nil
	self.fxhackLineDis = nil
	self.fxhackLineCur = false

	self.fxAttackArm = 0

	self.fxAttachCover =0

	self.fxhackZone = nil --骇入网格特效
	self.fxhackZoneStart = nil --骇入网格进入退出特效
	
	self.fxhackFrameIn = 0 --进入骇入的帧率
	self.fxhackFrameNow = 0 --在骇入模式下，现在的世界帧率
	self.fxhackFrameCd = 600 --下次刷新矩阵特效的cd
	
	self.fxselect = nil
	self.hackOnId = nil
	self.hackOn = false

	----其他---------------------------------------------------------------------------------------------------
	
	
	self.driveSound01 = 0
	
	self.SearchTarget = 0
	
	self.PartnerAllParm.skillList = {
		--主动技能列表
		{
			id = 60008041,
			showType = 2,	--1变身型，2召唤型
			frame = 78,	--技能持续时间，时间结束自动进入退场流程
			skillType = 3, --1战前释放，2战中释放，3不需要战前战中切换
			distance =	2,	--召唤技能释放距离
			angle = 90,  --召唤技能释放角度
			targetType = 2,	--目标点：1以角色为中心，2以敌人为中心
			createPos = 1, --创建点：1以角色为中心，2以敌人为中心
			stableShow = 0,	--是否需要在指定位置稳定创建
			Camera = 2,		--是否使用3D动态镜头，0为不需要，1为使用水平投影，2为3D动态，一般使用水平投影
			rolePerform = 4,	--0不使用角色出场动作，,1使用前召唤，2使用后召唤
		}
	}
	
	--连携技能列表
	self.PartnerAllParm.connectSkillList = {
		{	--炮击
			id = 60008040,
			showType = 2,	--1变身型，2召唤型,不填默认为召唤型
			frame = 40,	--技能持续时间，时间结束自动进入退场流程
			distance =	1,	--召唤技能释放距离
			angle = 300,  --召唤技能释放角度
			targetType = 1,	--1以角色为中心，2以敌人为中心
			createPos = 1, --创建点：1以角色为中心，2以敌人为中心
			connectType = 1, --连携类型：1普攻，2技能，3核心，4闪避，0默认不释放
			rushRange = 0,	--召唤冲刺技能极限范围，需要在技能帧事件中位移事件配置技能标记
			stableShow = 1,	--是否需要在指定位置稳定创建，0不需要，1需要，需要的话要手动上浮空buff和修改下落速度，危险危险
			Camera = 1,		--是否使用3D动态镜头，1为使用水平投影，2为3D动态，一般使用水平投影
			sign = 60008001,	--触发连携的EntitySign，没有则不填
		}
	}
	
	
	--无人机速度相关
	self.driveAttr = {}
	self.driveMaxHSpeed = 12
	self.driveHAcc = 3
	self.driveMaxVSpeed = 12
	self.driveVAcc = 3
	self.driveCostElectricity = 0.1
	
	
	--打印
	self.photo = false

	-----PV临时
	self.buildPosition = Vec3.New()
	self.normalVec3 = Vec3.New()
	self.canBuild = false
	self.onQuickBuild = false
	-----PV临时
	
	--驾驶骇入相关
	self.driveHack = false
	self.PartnerPosDrive = {x = -2, y = 0, z = 0}
	
	self.abilityId = 0
	self.count = 0
	self.campNow = 3
end

function Behavior600080:LateInit()
	self.role = BF.GetEntityOwner(self.me)  --获得角色
	self.ctrlRole = BehaviorFunctions.GetCtrlEntity()	--记录当前前台角色
	--self.roleFrontPos = BF.GetPositionOffsetBySelf(self.ctrlRole,5,0) --获得角色90度5米处位置坐标
	--self.rolePos = BF.GetPositionP(self.ctrlRole)
	
	
end



function Behavior600080:Update()
	self.role = BF.GetEntityOwner(self.me)  --获得角色
	self.time = BF.GetFightFrame() 		--获得世界帧数
	self.ctrlRole = BehaviorFunctions.GetCtrlEntity()	--更新当前前台角色
	self.roleState = BF.GetEntityState(self.ctrlRole) --获得角色状态
	self.roleFrontPos = BF.GetPositionOffsetBySelf(self.ctrlRole,5,0) --获得角色90度5米处位置坐标
	self.state = BF.GetEntityState(self.ctrlRole) --获得角色状态


	self.rolePos = BF.GetPositionP(self.ctrlRole)
	
	--接入佩从通用AI
	self.PartnerAllParm:Update()
	self.PartnerCastSkill:Update()
	
	
----骇入链接线相关逻辑-----------------------------------------------------------------------------------------------------------
	
	if self.role == 1 then
		--骇入物id与骇入物状态判断
		--如果骇入物id不为空，则判断当前骇入物是否存在
		if self.hackId ~= nil then
			self.hackEntityCur = BehaviorFunctions.CheckEntity(self.hackId)
		end
		--如果骇入物id不为空，且骇入物存在，则获得骇入物实体id
		if self.hackId ~= nil and self.hackEntityCur ==true  then
			self.hackEntity = BehaviorFunctions.GetEntityTemplateId(self.hackId) --获得骇入物的实体id
		end
		--如果骇入物id不为空，但骇入物不存在，则置空骇入物id
		if self.hackId ~= nil and self.hackEntityCur == false then
			self.hackId = nil
			self.hackEntity = nil
		end
		
		if self.fxhackLineCur == true and self.hackId ~= nil and self.fxhackLine then
			if self.hackMonitor and self.hackMonitorId and BehaviorFunctions.CheckEntity(self.hackMonitorId) then
				self.fxhackLineDis = BehaviorFunctions.GetTransformDistance(self.hackMonitorId,"CameraTarget1",self.hackId,"HackPoint") --获取连接点和箴石之劣的距离
				BehaviorFunctions.ClientEffectRelation(self.fxhackLine,self.hackMonitorId,"CameraTarget1",self.hackId,"HackPoint",self.fxhackLineDis) --进行目标与箴石之劣的连接
			else
				self.fxhackLineDis = BehaviorFunctions.GetTransformDistance(self.me,"WeaponCaseLeft",self.hackId,"HackPoint") --获取连接点和箴石之劣的距离
				BehaviorFunctions.ClientEffectRelation(self.fxhackLine,self.me,"WeaponCaseLeft",self.hackId,"HackPoint",self.fxhackLineDis) --进行目标与箴石之劣的连接
			end
			
		end
		
		--移除链接特效
		if self.fxhackLineCur == true and (self.hackId == nil or self.hackEntityCur == false ) then
			self:RemoveHackLine()
		end
		
			
	----骇入相关--------------------------------------------------------------------------------------------------------------------------	
		--只有idle和move状态下可以进行骇入建造
		if BehaviorFunctions.CheckEntityState(self.ctrlRole, FightEnum.EntityState.Idle) or  BehaviorFunctions.CheckEntityState(self.ctrlRole, FightEnum.EntityState.Move) then
			BehaviorFunctions.DisableSkillButton(self.me,FightEnum.KeyEvent.PartnerSkill , false)
		else
			BehaviorFunctions.DisableSkillButton(self.me,FightEnum.KeyEvent.PartnerSkill , true)
		end
		
		--检测退出骇入技能的窗口，隐藏仲魔
		if BehaviorFunctions.GetSkillSign(self.me,802001) then
			BF.CallCommonBehaviorFunc(self.me, "StopPartnerLeave")	--打断佩从离场流程
			--BF.ShowPartner(self.role,false)	--隐藏仲魔
			BF.ShowPartnerByAbilityWheel(self.me,false)
		end
		
		--检测执行骇入的技能窗口
		if BehaviorFunctions.GetSkillSign(self.me,800401) and self.hackOnId ~= nil and self.hackOn == true then
			if BehaviorFunctions.CheckEntity(self.hackOnId) then
				BehaviorFunctions.CallBehaviorFuncByEntity(self.hackOnId,"CallHackUp",self.hackOnId)
				self.hackOnId = nil
				self.hackOn = false
			end
		end
		
		--检测射击技能
		if BehaviorFunctions.GetSkillSign(self.me,804002) then
			if self.fxAttackArm then
				BehaviorFunctions.RemoveEntity(self.fxAttackArm)
			end
		end
	
		--检测驾驶骇入技能,修改箴石之劣特效表现
		if BehaviorFunctions.GetSkillSign(self.me,806001) then
			if self.fxhackDriveScreen then
				BehaviorFunctions.PlayAnimation(self.fxhack,"FxHackArm_Loop_Ani") --让箴石之劣的花臂特效进入loop
			end
		end
	
		--骇入模式检测，如果角色进入了骇入模式，箴石之劣需要做出“进入骇入模式”的表现
		if BehaviorFunctions.GetHackMode() == FightEnum.HackMode.Hack and self.hackState ~= self.hackStateEnum.Hack and self.photo == false then
			self:CheckState()
		end
		
		--建造模式检测，如果角色进入了建造模式，箴石之劣需要做出“进入建造模式”的表现
		if BehaviorFunctions.GetHackMode() == FightEnum.HackMode.Build and self.hackState ~= self.hackStateEnum.Build then
			BehaviorFunctions.BindTransform(self.me,"",self.PartnerPosBuild,self.ctrlRole) --绑定挂点
			self:CheckState()
		end
		
		--设置骇入idle动作，如果当前没有在播放技能，且不在hackstart模式下，会播放待机动作的技能
		if BehaviorFunctions.CanCastSkill(self.me) and self.hackState ~= self.hackStateEnum.HackStart then
			if BehaviorFunctions.GetHackMode() == FightEnum.HackMode.Hack then
				BehaviorFunctions.CastSkillBySelfPosition(self.me,60008002)
			end
		end
		
		--检测“骇入技能2”（目前执行骇入默认是执行这个技能）的窗口，删除花臂特效,如果是骇入摄像头，花臂特效进入循环
		if BehaviorFunctions.GetSkillSign(self.me,800401) then
			if self.hackMonitor == true and self.fxhack then
				BehaviorFunctions.BreakSkill(self.me)                             --打断骇入技能2
				BehaviorFunctions.CastSkillBySelfPosition(self.me,60008002)       --播放箴石之劣待机动作技能
				--BehaviorFunctions.PlayAnimation(self.fxhack,"FxHackArm_Loop_Ani") --让花臂特效进入loop
			else
				BehaviorFunctions.RemoveEntity(self.fxhack)                       --移除骇入花臂特效
			end
		end
		
		
	----骇入无人机相关----------------------------------------------------------------------------------------------------------------------
			
		--检测开始驾驶无人机的技能窗口，进入驾驶的动作播放完毕，让花臂特效进入loop
		if BehaviorFunctions.GetSkillSign(self.me,803101) then
			BehaviorFunctions.BreakSkill(self.me) --打断进入驾驶技能
			BehaviorFunctions.CastSkillBySelfPosition(self.me,60008033) --播放驾驶待机技能，让箴石之劣播放待机动作
			BehaviorFunctions.PlayAnimation(self.fxhack,"FxHackArm_Loop_Ani") --让花臂特效进入loop
			BehaviorFunctions.PlayAnimation(self.fxhackScreen,"FxHackArmScreen_Loop_Ani") --让花臂屏幕特效进入loop
		end
		
		--检测停止驾驶无人机技能的窗口，箴石之劣停止骇入演出结束，开始播放退场动作
		if BehaviorFunctions.GetSkillSign(self.me,803201) then
			BehaviorFunctions.RemoveEntity(self.fxhack) --移除箴石之劣花臂特效
			BehaviorFunctions.RemoveEntity(self.fxhackScreen) --移除箴石之劣的手臂屏幕特效
			BehaviorFunctions.BreakSkill(self.me) --打断停止驾驶的技能
			BehaviorFunctions.CastSkillBySelfPosition(self.me,60008020) --使用退出技能
			self.isHacking = false --箴石之劣是否在骇入建造模式的判断置否
			self.hackState = self.hackStateEnum.HackStart  --骇入阶段状态重置
		end

		
	----骇入特效的处理------------------------------------------------------------------------------------
		--if  self.fxhackZone ~= nil and BehaviorFunctions.CheckEntity(self.fxhackZone) then --检测是否有网格矩阵特效	
			--self.fxhackFrameNow = BehaviorFunctions.GetFightFrame()
			--if self.fxhackFrameNow > self.fxhackFrameCd + self.fxhackFrameIn then --检测cd
				--BehaviorFunctions.RemoveEntity(self.fxhackZone) --移除网格矩阵特效
				--self.fxhackZone = BehaviorFunctions.CreateEntity(6000800103,nil,self.Position.x,self.Position.y,self.Position.z)--创建网格矩阵特效，解决玩家走出矩阵生成范围的问题
				--self.fxhackFrameIn = BehaviorFunctions.GetFightFrame() --获得生成网格矩阵特效的时间
			--end
		--end
		
		
	----箴石之劣相关特殊处理---------------------------------------------------------------------------------------------------------	
		
		--增加“隐藏碰撞”的buff
		if BehaviorFunctions.HasBuffKind(self.me,600080010) then
		else
			BehaviorFunctions.AddBuff(self.me,self.me,600080010)
		end
	
		--增加“防止死亡”的buff
		if BehaviorFunctions.HasBuffKind(self.me,600080101) then
		else
			BehaviorFunctions.AddBuff(self.me,self.me,600080101)
		end
		
		
		
		
	----进入骇入表现的处理---------------------------------------------------------------------------------------------------------------
		if BehaviorFunctions.GetSkillSign(self.me,600080061) then
			--骇入特效相关
			self.Position = BehaviorFunctions.GetPositionP(self.ctrlRole) --获得角色位置
			--网格矩阵特效
			if  self.fxhackZone == nil then --检测是否有网格矩阵特效
				self.fxhackZone = BehaviorFunctions.CreateEntity(6000800103,nil,self.Position.x,self.Position.y,self.Position.z)--创建网格矩阵特效
				self.fxhackFrameIn = BehaviorFunctions.GetFightFrame() --获得生成网格矩阵特效的时间
				--BehaviorFunctions.DoSetPosition(self.fxhackZone,self.Position.x,self.Position.y,self.Position.z)
			end
		end
		
		if BehaviorFunctions.GetSkillSign(self.me,600080062) then
			BehaviorFunctions.DoMagic(self.ctrlRole,self.ctrlRole,600080023)
		end
	end
end

--检测按下了仲魔技能按钮，短按进入骇入模式，长按进入建造模式
function Behavior600080:KeyInput(key, status)
end
			
--玩家被攻击
function Behavior600080:Collide(attackInstanceId,hitInstanceId,instanceId,shakeStrenRatio,attackType)
	if hitInstanceId == self.ctrlRole then
	end
end

--进入骇入模式
function  Behavior600080:EnterHack(abilityId)
--	if BehaviorFunctions.GetCtrlEntity() == self.ctrlRole then --当前角色是否出战
	if self.role == 1 then
		if abilityId == 101 then
			if self.isHacking == false then
				BehaviorFunctions.EnterHackingMode() --进入骇入模式
				self:callPartner()
				self.isHacking = true
				
				--BehaviorFunctions.CastSkillBySelfPosition(self.ctrlRole,1001061)
				----网格进入退出特效
				--进入骇入表现
				----如果没有特效，则增加特效buff
				--if not BehaviorFunctions.HasBuffKind(self.ctrlRole,200001161) then
					--BehaviorFunctions.AddBuff(self.ctrlRole,self.ctrlRole,200001161) --增加特效buff
					--if self.fxhackZoneStart ~= nil and BehaviorFunctions.CheckEntity(self.fxhackZoneStart) then --保底，buff的特效实体存在
						--BehaviorFunctions.PlayAnimation(self.fxhackZoneStart,"FxHackZoneStart_Ani") --播放进入动画
					--end
				--else --如果有特效buff，则为了播放动画，需要先删除特效buff，在增加特效buff
					--BehaviorFunctions.RemoveBuff(self.ctrlRole,200001161) --移除特效buff
					--BehaviorFunctions.AddBuff(self.ctrlRole,self.ctrlRole,200001161) --增加buff
					--if self.fxhackZoneStart ~= nil and BehaviorFunctions.CheckEntity(self.fxhackZoneStart) then --保底，buff的特效实体存在
						--BehaviorFunctions.PlayAnimation(self.fxhackZoneStart,"FxHackZoneStart_Ani") --播放进入动画
					--end
				--end

			end
		elseif abilityId == 102 then
			BehaviorFunctions.OpenBuildControlPanel()	--进入建造模式
		--	self:EnterBuild()
		elseif abilityId == 104 then
			BehaviorFunctions.OpenBluePrintWindow()	--进入蓝图界面
		end
	end
	--end
end

--切换骇入和建造模式时，骇入建造检测
function Behavior600080:CheckState()
	--if BehaviorFunctions.GetCtrlEntity() == self.role then --当前角色是否出战
		--检测骇入模式
		if BehaviorFunctions.GetHackMode() == FightEnum.HackMode.Hack then
			self.hackState = self.hackStateEnum.Hack
			BehaviorFunctions.BreakSkill(self.me)
			BehaviorFunctions.CastSkillBySelfPosition(self.me,60008001) --使用“进入骇入”技能，播放进入骇入的表演动作
			BehaviorFunctions.BindTransform(self.me,"",self.PartnerPosHack,self.ctrlRole)
			self.fxhackScreen = BehaviorFunctions.CreateEntity(6000800102,self.me) --创建箴石之劣手部的电脑屏幕的特效
			BehaviorFunctions.PlayAnimation(self.fxhackScreen,"FxHackArmScreen_Begin_Ani") --播放花臂屏幕特效的出场动作
		end
		--检测建造模式
		if BehaviorFunctions.GetHackMode() == FightEnum.HackMode.Build then
			self.hackId = nil
			if self.fxhackScreen then
				BehaviorFunctions.RemoveEntity(self.fxhackScreen)		
			end
			BehaviorFunctions.BreakSkill(self.me)
			BehaviorFunctions.CastSkillBySelfPosition(self.me,60008012) --使用“建造待机”技能，播放进入建造的表演动作，直接进入待机
			BehaviorFunctions.RemoveBindTransform(self.ctrlRole) --移除骨骼点绑定
			BehaviorFunctions.BindTransform(self.me,"",self.PartnerPosBuild,self.ctrlRole) --重新把箴石之劣绑定到建造应该有的位置
			self.hackState = self.hackStateEnum.Build
		end
	--end
end

--获取骇入物id，选中骇入物
function Behavior600080:Hacking(instanceId)
	self.hackId = instanceId
	BehaviorFunctions.DoEntityAudioPlay(self.me,"Hack_select",false)
	
	
	if self.role == 1 then
		
		self.hackEntity = BehaviorFunctions.GetEntityTemplateId(self.hackId)
		--骇入连线
		if not self.hackMonitor  then
			if self.fxhackLine then
			else
				self.fxhackLine = BehaviorFunctions.CreateEntity(6000800302,self.me,0,0,0)
			end
			self.fxhackLineCur = true	
		elseif  self.hackMonitor == true and self.hackMonitorId and BehaviorFunctions.CheckEntity(self.hackMonitorId) then
			if self.fxhackLine then
			else
				self.posLine = BehaviorFunctions.GetPositionP(self.me)
				self.fxhackLine = BehaviorFunctions.CreateEntity(6000800302,self.hackMonitorId,self.posLine.x,self.posLine.y,self.posLine.z)
			end
			self.fxhackLineCur = true
		end
	else 
	end
end

--停止骇入时（准星挪开目标时）
function Behavior600080:StopHacking(instanceId)
	self.hackId = nil --把骇入目标id置空
	
	if self.fxselect then
		BehaviorFunctions.RemoveEntity(self.fxselect)
		self.fxselect = nil
	end
	
	if self.fxhackLine then
		self:RemoveHackLine()
	end
end	
	
--检测按下上键后，执行表现
function Behavior600080:BegainHackingClickUp(instanceId)
	--if instanceId == self.hackId then
		BehaviorFunctions.BreakSkill(self.me)
		BehaviorFunctions.RemoveEntity(self.fxhack) --移除花臂特效
		self.fxhack = BehaviorFunctions.CreateEntity(6000800101,self.me) --重新创建花臂特效
		BehaviorFunctions.PlayAnimation(self.fxhack,"FxHackArm_Begin_Ani") --播放花臂特效的出场动作

		BehaviorFunctions.CastSkillBySelfPosition(self.me,60008004)
		
		if BehaviorFunctions.GetNpcType(instanceId) == FightEnum.EntityNpcTag.Monster and BehaviorFunctions.GetHackingButtonIsActive(instanceId, HackingConfig.HackingKey.Up) == true then
			if BehaviorFunctions.HasBuffKind(instanceId,200001183) then
				BehaviorFunctions.SetEntityValue(self.hackId,"active_200001183",true)
				BehaviorFunctions.SetEntityValue(self.hackId,"camp_200001183",self.campNow)
				BehaviorFunctions.SetHackingButtonActive(instanceId, HackingConfig.HackingKey.Up,false)
			else
			end
		end
	self.hackEntityNow = BehaviorFunctions.GetEntityTemplateId(instanceId)
	self.tag = BehaviorFunctions.GetNpcType(instanceId)
	
	--如果对方是npc，则骇入后关闭按钮
	if self.tag == FightEnum.EntityNpcTag.NPC and self.hackEntityNow ~= 808012003 and self.hackEntityNow ~= 808012001 and self.hackEntityNow ~= 808012002 and self.hackEntityNow ~= 2030518 then
		BehaviorFunctions.SetHackingButtonActive(instanceId, HackingConfig.HackingKey.Up,false)
	end
	
	self.tag = 0
	
	
	--检测是否是特殊的骇入逻辑	，如果是，则检测技能帧事件
	if self.hackEntityNow == 808012001 or self.hackEntityNow == 808012002 or self.hackEntityNow == 808012003  or self.hackEntityNow == 2030518 or
		self.hackEntityNow == 2030516 then
		self.hackOn = true
		self.hackOnId = instanceId
	end
	
	--end
	--end
end

--检测按下下键后，执行表现
function Behavior600080:BegainHackingClickDown(instanceId)
	--if BehaviorFunctions.GetCtrlEntity() == self.role then --当前角色是否出战
		--if instanceId == self.hackId then
			BehaviorFunctions.BreakSkill(self.me)
			--BehaviorFunctions.CreateEntity(6000800301,self.hackId)--骇入物特效
			BehaviorFunctions.RemoveEntity(self.fxhack) --移除花臂特效
			self.fxhack = BehaviorFunctions.CreateEntity(6000800101,self.me) --重新创建花臂特效
			BehaviorFunctions.PlayAnimation(self.fxhack,"FxHackArm_Begin_Ani") --播放花臂特效的出场动作
		--BehaviorFunctions.DoEntityAudioPlay(self.me,"Hack_Start",true)

			BehaviorFunctions.CastSkillBySelfPosition(self.me,60008004)

	self.tag = BehaviorFunctions.GetNpcType(instanceId)


	if self.tag == FightEnum.EntityNpcTag.NPC  then
		BehaviorFunctions.SetHackingButtonActive(instanceId, HackingConfig.HackingKey.Down,false)
	end

	self.tag = 0
		
		--end
	--end
end


--检测按下右键后，执行表现
function Behavior600080:BegainHackingClickRight(instanceId)
			BehaviorFunctions.BreakSkill(self.me)
			BehaviorFunctions.RemoveEntity(self.fxhack) --移除花臂特效
			self.fxhack = BehaviorFunctions.CreateEntity(6000800101,self.me) --重新创建花臂特效
			BehaviorFunctions.PlayAnimation(self.fxhack,"FxHackArm_Begin_Ani") --播放花臂特效的出场动作

			BehaviorFunctions.CastSkillBySelfPosition(self.me,60008004)

		--end
	--end
end

--检测按下左键后，执行表现
function Behavior600080:BegainHackingClickLeft(instanceId)
		BehaviorFunctions.BreakSkill(self.me)
		BehaviorFunctions.RemoveEntity(self.fxhack) --移除花臂特效
		self.fxhack = BehaviorFunctions.CreateEntity(6000800101,self.me) --重新创建花臂特效
		BehaviorFunctions.PlayAnimation(self.fxhack,"FxHackArm_Begin_Ani") --播放花臂特效的出场动作

			BehaviorFunctions.CastSkillBySelfPosition(self.me,60008004)
end

--检测到开始驾驶时
function Behavior600080:OnDriveDrone(instanceId, curDriveId)
	--if BehaviorFunctions.GetCtrlEntity() == self.role then --当前角色是否出战
	if self.role == 1 then
		if curDriveId == self.ctrlRole and self.drive == 0 then
			self.drive = 1 --检测开始驾驶
			self.driveId = instanceId --获得当前驾驶的无人机的id
			
			BehaviorFunctions.BindTransform(self.me,"",self.PartnerPosHack,self.ctrlRole) --把箴石之劣与角色绑定
			BehaviorFunctions.DoLookAtPositionImmediately(self.me,self.roleFrontPos.x,self.roleFrontPos.y,self.roleFrontPos.z,true)	--箴石之劣设置朝向角色前方
			BehaviorFunctions.CallCommonBehaviorFunc(self.me, "StopPartnerLeave")	--打断佩从离场流程
		--	BehaviorFunctions.ShowPartner(self.role, true)	--显示仲魔
			BehaviorFunctions.ShowPartnerByAbilityWheel(self.me,true)
			BehaviorFunctions.BreakSkill(self.me) --打断技能
			BehaviorFunctions.CastSkillBySelfPosition(self.me,60008031) --箴石之劣使用“进入驾驶”技能，播放进入驾驶的表演动作
			self.fxhack = BehaviorFunctions.CreateEntity(6000800101,self.me) --创建花臂特效
			BehaviorFunctions.PlayAnimation(self.fxhack,"FxHackArm_Begin_Ani") --播放花臂特效的出场动作
			self.fxhackScreen = BehaviorFunctions.CreateEntity(6000800102,self.me)
			BehaviorFunctions.PlayAnimation(self.fxhackScreen,"FxHackArmScreen_Begin_Ani")
		end
	end
	--end
end

--检测到停止驾驶时
function Behavior600080:OnStopDriveDrone(instanceId, curDriveId)
	if self.role == 1 then
		if curDriveId == self.ctrlRole then
				self.drive = 0 --重置驾驶状态
				self.driveId = 0 --驾驶id置空
				
				BehaviorFunctions.CastSkillBySelfPosition(self.me,60008032) --播放结束驾驶技能
				BehaviorFunctions.PlayAnimation(self.fxhack,"FxHackArm_End_Ani") --让花臂特效进入end
				BehaviorFunctions.PlayAnimation(self.fxhackScreen,"FxHackArmScreen_End_Ani")
				
				BehaviorFunctions.RemoveEntity(self.fxhacking) --移除持续骇入的特效
				--self:RemoveHackLine() --移除驾驶连线
			
			--如果正在加速，则移除加速
			if BehaviorFunctions.HasBuffKind(instanceId,2000010221) then
				BehaviorFunctions.RemoveBuff(instanceId,2000010221)
				BehaviorFunctions.SetDroneParams(instanceId, 9 , 1.2, 7, 1.2, 0.1)
			end
			
			--BehaviorFunctions.RemoveEntity(self.driveSound01)
		end
	end
end

--退出骇入建造模式时
function Behavior600080:ExitHacking()
	if self.role == 1 then
		if self.abilityId and self.abilityId ~= 0 then
			BehaviorFunctions.ApplyAbilityWheelCoolTime(self.abilityId)
		end
		--if BehaviorFunctions.GetCtrlEntity() == self.role then --当前角色是否出战
		BehaviorFunctions.RemoveBindTransform(self.me)	--取消绑定
		self.hackId = nil
		--BehaviorFunctions.RemoveEntity(self.fxhackLine)
		BehaviorFunctions.BreakSkill(self.me)
		BehaviorFunctions.CastSkillBySelfPosition(self.me,60008020)
		self.isHacking = false
		self.hackState = self.hackStateEnum.HackStart
		--BehaviorFunctions.RemoveEntity(self.fxhack)
		if self.fxhack then
			BehaviorFunctions.RemoveEntity(self.fxhack)
		end
		
		if self.fxhackScreen then
			BehaviorFunctions.RemoveEntity(self.fxhackScreen)
		end
			
			
		--检测是否有矩阵特效，如果有的话，则去除
		if BehaviorFunctions.CheckEntity(self.fxhackZone) then
			BehaviorFunctions.RemoveEntity(self.fxhackZone)
			self.fxhackZone = nil
		end
		--检测是否有矩阵进入退出特效，如果有的话，则播放退出动画
		if BehaviorFunctions.HasBuffKind(self.ctrlRole,200001161) and self.fxhackZoneStart ~= nil then
			--BehaviorFunctions.RemoveBuff(self.ctrlRole,200001161)
			--BehaviorFunctions.AddBuff(self.ctrlRole,self.ctrlRole,200001161)
			--if self.fxhackZoneStart ~= nil and BehaviorFunctions.CheckEntity(self.fxhackZoneStart) then
				--BehaviorFunctions.PlayAnimation(self.fxhackZoneStart,"FxHackZoneEnd_Ani") --播放退出动画
			--end
			BehaviorFunctions.RemoveBuff(self.ctrlRole,200001161)
		end
		--end
		
		--去除音效的特效
		if self.fxselect then
			BehaviorFunctions.RemoveEntity(self.fxselect)
			self.fxselect = nil
		end
		
		if self.fxhackLine then
			self:RemoveHackLine()
		end
		
	end
end

--退出骇入建造模式时
function Behavior600080:OnExitBuilding()
	if self.role == 1 then
		--if self.abilityId and self.abilityId ~= 0 then
			--BehaviorFunctions.ApplyAbilityWheelCoolTime(self.abilityId)
		--end
		--if BehaviorFunctions.GetCtrlEntity() == self.role then --当前角色是否出战
		BehaviorFunctions.RemoveBindTransform(self.me)	--取消绑定
		self.hackId = nil
		--BehaviorFunctions.RemoveEntity(self.fxhackLine)
		BehaviorFunctions.BreakSkill(self.me)
		BehaviorFunctions.CastSkillBySelfPosition(self.me,60008020)
		--self.isHacking = false
		self.hackState = self.hackStateEnum.HackStart
		--BehaviorFunctions.RemoveEntity(self.fxhack)
		if self.fxhack then
			BehaviorFunctions.RemoveEntity(self.fxhack)
		end
	
		if self.fxhackScreen then
			BehaviorFunctions.RemoveEntity(self.fxhackScreen)
		end

	end
end

--移除骇入连线
function Behavior600080:RemoveHackLine()
	self.fxhackLineCur = false --关闭连线状态
	BehaviorFunctions.ClientEffectRemoveRelation(self.fxhackLine) --移除连线
	BehaviorFunctions.RemoveEntity(self.fxhackLine)
	self.fxhackLine = nil
	self.hackId = nil --当前骇入目标置空
	--BehaviorFunctions.DoEntityAudioStop(self.me,"Hack_Line",0.1,0.1)
end

--骇入摄像头
function Behavior600080:CameraHack(instanceId,hacking)
	if hacking == true then --正在骇入摄像头时
		if self.fxhackLine then
			self:RemoveHackLine() --移除连接线
		end
		self.hackMonitor = true --设置正在骇入摄像头中
		self.hackMonitorId = instanceId --设置骇入摄像头id
		
		
		
		----隐藏当前骇入的摄像头模型
		--if not BehaviorFunctions.HasBuffKind(self.hackMonitorId,200000101) and self.hackMonitorId then
			--BehaviorFunctions.AddBuff(self.hackMonitorId,self.hackMonitorId,200000101)
		--end
		
	else --停止骇入摄像头时
		self.hackMonitor = false
		
		----取消骇入时，移除摄像头的隐藏magic
		--if BehaviorFunctions.HasBuffKind(self.hackMonitorId,200000101) and self.hackMonitorId then
			--BehaviorFunctions.RemoveBuff(self.hackMonitorId,200000101)
		--end
		
	end
	
end


--箴石之劣技能被打断时的处理
function Behavior600080:BreakSkill(instanceId,skillId,skillSign,skillType)
	--骇入技能2被打断
	if instanceId == self.me and skillId == 60008004 then
		if self.fxhack then
			BehaviorFunctions.RemoveEntity(self.fxhack) --如果在执行骇入时，骇入技能被打断，则会去掉骇入特效
		end
	end

	--进入骇入的技能被打断
	if instanceId == self.me and skillId == 60008001 and BehaviorFunctions.GetHackMode() == FightEnum.HackMode.Hack then
		if self.fxhack then
			BehaviorFunctions.PlayAnimation(self.fxhackScreen,"FxHackArmScreen_Loop_Ani") --播放花臂特效的循环动作
		end
	end

	--炮击技能被打断时
	if instanceId == self.me and skillId == 60008040 then
		if self.fxAttackArm then
			BehaviorFunctions.RemoveEntity(self.fxAttackArm)
		end
	end
	
	--退出技能被打断时
	if instanceId == self.me and skillId == 60008020 then
		BF.CallCommonBehaviorFunc(self.me, "StopPartnerLeave")	--打断佩从离场流程
		--BF.ShowPartner(self.role,false)	--隐藏仲魔
		--BF.ShowPartnerByAbilityWheel(self.me,false)
	end

end

--箴石之劣技能结束时的处理
function Behavior600080:FinishSkill(instanceId,skillId,skillSign,skillType)
	--若进入骇入技能没有检测到技能窗口且被打断，技能正常结束，则花臂屏幕特效进入循环
	if instanceId == self.me then
		if skillId == 60008001 and BehaviorFunctions.GetHackMode() == FightEnum.HackMode.Hack then
			BehaviorFunctions.PlayAnimation(self.fxhackScreen,"FxHackArmScreen_End_Ani") --播放花臂屏幕特效的循环动作
		end
	end
	
	--炮击技能结束时
	if instanceId == self.me and skillId == 60008040 then
		if self.fxAttackArm then
			BehaviorFunctions.RemoveEntity(self.fxAttackArm)
		end
	end
	
	--进场动作结束
	if instanceId == self.me and skillId == 60008006 then
		BehaviorFunctions.DoEntityAudioPlay(self.me,"Hack_During",true)
	end
	
	--技能结束
	if instanceId == self.me and skillId == 60008020 then
		BF.CallCommonBehaviorFunc(self.me, "StopPartnerLeave")	--打断佩从离场流程
		--BF.ShowPartner(self.role,false)	--隐藏仲魔
		BF.ShowPartnerByAbilityWheel(self.me,false)
	end
	
end

--驾驶骇入
function Behavior600080:DriveHack(Target)
--	if BehaviorFunctions.GetCtrlEntity() == self.role then --装备箴石之劣的角色是否出战
	if self.role == 1 then
		if self.driveHack == false then
			self.driveHack = true
			--BehaviorFunctions.EnterHackingMode() --进入骇入模式
			--local Pos = BF.GetPositionOffsetBySelf(self.role,0.5,0) --获得角色周围的位置
			--BF.DoSetPosition(self.me,Pos.x - 2,Pos.y,Pos.z - 0.3)	--设置召唤位置
			--BehaviorFunctions.CastSkillBySelfPosition(self.me,600080004)
	
			BehaviorFunctions.BindTransform(self.me,"",self.PartnerPosDrive,self.ctrlRole) --绑定角色
			
			--如果有选择目标，则朝向目标，如果无目标则朝向前方
			if Target then
				BehaviorFunctions.DoLookAtTargetImmediately(self.me,Target,"CameraTarget",true)	--设置朝向目标
			else
				BehaviorFunctions.DoLookAtPositionImmediately(self.me,self.roleFrontPos.x,self.roleFrontPos.y,self.roleFrontPos.z,true)	--设置朝向
			end
			
			--self.hackState = self.hackStateEnum.HackStart --设置为“刚开始骇入”的状态
			--BehaviorFunctions.RemoveKeyPress(FightEnum.KeyEvent.Partner) --移除仲魔技能长按状态
			--self.hackState = self.hackStateEnum.Hack --设置在骇入模式的状态
	
			--特殊buff
			BehaviorFunctions.SetUseParentTimeScale(self.me, false)--不使用创建者时间缩放
			BehaviorFunctions.DoMagic(self.me,self.me,1000055,1)	--仲魔召唤技能无敌buff
			BehaviorFunctions.DoMagic(self.me,self.me,600000014,1)	--允许穿墙buff
			BehaviorFunctions.DoMagic(self.me,self.me,600000016,1)	--浮空buff
	
			--出场表现
			BehaviorFunctions.CallCommonBehaviorFunc(self.me, "StopPartnerLeave")	--打断佩从离场流程
			--BehaviorFunctions.ShowPartner(self.role, true)	--显示仲魔
			BehaviorFunctions.ShowPartnerByAbilityWheel(self.me,true)
			--	BehaviorFunctions.RemoveEntitySign(self.me,600003)	--移除主动技能在场状态
			BehaviorFunctions.CastSkillBySelfPosition(self.me,60008060)--使用进入骇入模式的技能
			--BehaviorFunctions.CreateEntity(600000002,self.me) --创建出场特效
			--self.fxhack = BehaviorFunctions.CreateEntity(6000800101,self.me) --创建花臂特效
			--BehaviorFunctions.PlayAnimation(self.fxhack,"FxHackFast_Begin_Ani") --播放花臂特效的出场动作
			self.fxhackDriveScreen = BehaviorFunctions.CreateEntity(6000800102,self.me)
			BehaviorFunctions.PlayAnimation(self.fxhackDriveScreen,"FxHackArmScreen_Begin_Ani") --播放花臂屏幕特效的出场动作
			--BehaviorFunctions.DoEntityAudioPlay(self.me,"Hack_Start",true)--播放音效
			
			----创建驾驶的链接特效
			--if self.fxhackDriveLine then
			--else
				--self.fxhackDriveLine = BehaviorFunctions.CreateEntity(6000800302,self.me,0,0,0)
				--BehaviorFunctions.ClientEffectRelation(self.fxhackDriveLine,self.me,"WeaponCaseLeft",self.me,"WeaponCaseLeft",0)
			--end
		end
	end
	--end
end

----驾驶无人机时使用骇入连线
--function Behavior600080:DriveHackLine(Target,TargetDot)
	----if BehaviorFunctions.GetCtrlEntity() == self.role then --装备箴石之劣的角色是否出战
		--if self.driveHack == true then
			--if self.fxhackDriveLine and Target then
				--self.fxhackDriveLineDis = BehaviorFunctions.GetTransformDistance(self.me,"WeaponCaseLeft",Target,TargetDot)
				--BehaviorFunctions.ClientEffectRelation(self.fxhackLine,self.me,"WeaponCaseLeft",self.hackId,TargetDot,self.fxhackDriveLine)				
			--end
		--end	
	----end
--end

--退出驾驶骇入
function Behavior600080:QuitDriveHack()
	--if BehaviorFunctions.GetCtrlEntity() == self.role then --装备箴石之劣的角色是否出战
		if self.driveHack == true then
			BehaviorFunctions.RemoveBindTransform(self.me)	--取消绑定
			--BehaviorFunctions.RemoveEntity(self.fxhackLine)
			BehaviorFunctions.BreakSkill(self.me)
			BehaviorFunctions.CastSkillBySelfPosition(self.me,60008020)
			self.driveHack = false

			--if self.fxhackDriveLine then
				--BehaviorFunctions.RemoveEntity(self.fxhackDriveLine)
			--end
		end
	--end
end

--轮盘按钮回调
function Behavior600080:AbilityWheelFreePartnerSkill(instanceId,abilityId,skillId,isQuickOutbound)
	--如果处于轮盘中
	if self.role == 1 then
		if instanceId == self.me then
			--如果传进来的是骇入或者建造
			if abilityId == 101 or abilityId == 102 or abilityId == 104 then
				--检查能力是否可用
				if BehaviorFunctions.CheckAbilityCanUse(abilityId) then
					--检查轮盘按钮是否可用
					if BehaviorFunctions.CheckBtnUseSkill(self.ctrlRole,FightEnum.KeyEvent.PartnerSkill,true) then
						self.abilityId = abilityId
						self:EnterHack(abilityId)	--进入骇入模式
						--BehaviorFunctions.CloseFightAbilityWheel()	--关闭轮盘
					end
				else 
					--如果是长按
					if isQuickOutbound then
						--BehaviorFunctions.CloseFightAbilityWheel()	--关闭轮盘
					end
					BehaviorFunctions.ShowTip(80000005)		--显示tips
				end
			end
		end
	end
end

--function Behavior600080:SkillFrameUpdate(instanceId,skillId,skillFrame)
	--if instanceId == self.me then
		--if skillId == 60008041 then
			--if skillFrame == 23 then
				--BehaviorFunctions.AddFollowTarget(self.me,"Bip001 R Hand")
				--BehaviorFunctions.SetFollowTargetWeight(self.me,"Bip001 R Hand",0.3)
			--end
			
			--if skillFrame == 53 then
				--BehaviorFunctions.RemoveFollowTarget(self.me,"Bip001 R Hand")
			--end
		--end
	--end
--end

--检测到增加buff
function Behavior600080:AddBuff(entityInstanceId, buffInstanceId,buffId)
	if entityInstanceId == self.ctrlRole and buffId == 200001161 then --检测到增加骇入-网格进入退出特效
		self.fxhackZoneStart = buffInstanceId
	end
	
	
end

function Behavior600080:callPartner()
	BehaviorFunctions.BindTransform(self.me,"",self.PartnerPosHack,self.ctrlRole) --绑定角色
	self.roleFrontPos = BF.GetPositionOffsetBySelf(self.ctrlRole,5,0) --确保获取到了角色前方的位置，方便设置朝向
	if self.roleFrontPos then
		BehaviorFunctions.DoLookAtPositionImmediately(self.me,self.roleFrontPos.x,self.roleFrontPos.y,self.roleFrontPos.z,true)	--设置朝向
	end
	
	--self.hackState = self.hackStateEnum.HackStart --设置为“刚开始骇入”的状态
	--BehaviorFunctions.RemoveKeyPress(FightEnum.KeyEvent.Partner) --移除仲魔技能长按状态
	self.hackState = self.hackStateEnum.Hack --设置在骇入模式的状态

	--特殊buff
	BehaviorFunctions.SetUseParentTimeScale(self.me, false)--不使用创建者时间缩放
	BehaviorFunctions.DoMagic(self.me,self.me,1000055,1)	--仲魔召唤技能无敌buff
	BehaviorFunctions.DoMagic(self.me,self.me,600000014,1)	--允许穿墙buff
	BehaviorFunctions.DoMagic(self.me,self.me,600000016,1)	--浮空buff
	--BehaviorFunctions.AddBuff(self.me,self.me,600000014)
	--BehaviorFunctions.SetEntityShowState(self.me,false)
	
	
	--出场表现
	BehaviorFunctions.CallCommonBehaviorFunc(self.me, "StopPartnerLeave")	--打断佩从离场流程
	--BehaviorFunctions.ShowPartner(self.role, true)	--显示仲魔
	BehaviorFunctions.ShowPartnerByAbilityWheel(self.me,true)
	--	BehaviorFunctions.RemoveEntitySign(self.me,600003)	--移除主动技能在场状态
	BehaviorFunctions.CastSkillBySelfPosition(self.me,60008006)--使用进入骇入模式的技能
	--BehaviorFunctions.CreateEntity(600000002,self.me) --创建出场特效
	--self.fxhack = BehaviorFunctions.CreateEntity(6000800101,self.me) --创建花臂特效
	--BehaviorFunctions.PlayAnimation(self.fxhack,"FxHackFast_Begin_Ani") --播放花臂特效的出场动作
	self.fxhackScreen = BehaviorFunctions.CreateEntity(6000800102,self.me)
	BehaviorFunctions.PlayAnimation(self.fxhackScreen,"FxHackArmScreen_Begin_Ani") --播放花臂屏幕特效的出场动作
end