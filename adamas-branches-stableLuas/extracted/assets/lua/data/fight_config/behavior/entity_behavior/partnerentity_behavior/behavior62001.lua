Behavior62001 = BaseClass("Behavior62001",EntityBehaviorBase)

--local EntityNpcTagBit = FightEnum.EntityNpcTagBit
--local npcTag = EntityNpcTagBit.Monster|EntityNpcTagBit.Elite|EntityNpcTagBit.Boss

--资源预加载
function Behavior62001.GetGenerates()
	local generates = {}
	return generates
end

function Behavior62001.GetMagics()
	local generates = {62001011,1000053,1000052,1000051,1000062,1000063,62001012}
	return generates
end

function Behavior62001:Init()
	self.me = self.instanceId	--记录自身

	--接入通用AI
	self.PartnerAllParm = BehaviorFunctions.CreateBehavior("PartnerAllParm",self)
	self.PartnerCastSkill = BehaviorFunctions.CreateBehavior("PartnerCastSkill",self)
	
	self.PartnerAllParm.partnerType = 0         --初始佩从类型，0连携，1变身，2召唤，3跟随，4附身
	
	self.PartnerAllParm.autoRemove = false	--不自动退场
	self.PartnerAllParm.diyuePart = "Bip001 R Hand"

	self.PartnerAllParm.autoChangeBtn = false
	self.PartnerAllParm.hasFightSkill = true

	self.role = 0
	self.mission = 0
	self.time = 0
	self.LockTarget = 0
	self.LockTargetPoint = 0
	self.LockTargetPart = 0

	self.AttackTarget = 0
	self.AttackTargetPoint = 0
	self.AttackTargetPart = 0

	self.LockAltnTarget = 0
	self.LockAltnTargetPoint = 0
	self.LockAltnTargetPart = 0

	self.AttackAltnTarget = 0
	self.AttackAltnTargetPoint = 0
	self.AttackAltnTargetPart = 0

	self.assingTarget = 0
	--self.noTarget = 0
	self.battleTarget = 0
	--缓存技能按钮
	self.curSkillId = 0
	self.curAssTarget = 0
	self.curBtnState = 0

	self.connectSkill = 62001614	--连携技能id
	self.connectTime = 0
	self.PartnerAllParm.useOwnSkill = false

	--暗杀相关
	self.assTarget = 0	--暗杀目标
	self.targetAssLimit = 0	--目标被暗杀限制
	self.assingTarget = 0	--暗杀中目标锁定
	self.setPartnerBtn = 0 --按钮设置状态
	self.assNewTarget = 0	--暗杀目标缓存
	self.AllTargetList = {}	--可暗杀目标列表
	self.assTargetState = 0
	self.assEndState = 0	--是否处于暗杀结束流程
	self.assEndFrame = 90	--暗杀结束的时间
	self.assProtectFrame = 0	--暗杀保护计时

	--暗杀成长
	self.assDistance = 15 --最终暗杀距离
	self.baseAssDistance = 13--基础距离
	self.growAssDistance = 0.5 --每级增加的系数
	self.highAssDis = 20
	self.jumpAssDis = 10
	self.curHitFlyBullet = 0
	
	--角色相关
	self.Role1 = 0					--序号1角色
	self.Role2 = 0					--序号2角色
	self.Role3 = 0					--序号3角色
	--self.PartnerAllParm.chainTrans = false
	--self.PartnerAllParm.chainSave = true
	self.checkHeight = false
	--连携技能列表
	--self.PartnerAllParm.connectSkillList = {

	--{	--下落攻击连携
	--id = 62001613,
	--showType = 2,	--1变身型，2召唤型,不填默认为召唤型
	--frame = 119,	--技能持续时间，时间结束自动进入退场流程
	--distance =	1,	--召唤技能释放距离
	--angle = 90,  --召唤技能释放角度
	--targetType = 1,	--1以角色为中心，2以敌人为中心
	--connectType = 5, --连携类型：1普攻，2技能，3核心，4闪避，5下落攻击，0默认不释放
	--rushRange = 0,	--召唤冲刺技能极限范围，需要在技能帧事件中位移事件配置技能标记
	--stableShow = 1,	--是否需要在指定位置稳定创建，0不需要，1需要，需要的话要手动上浮空buff和修改下落速度，危险危险
	--Camera = 2,		--是否使用3D动态镜头，1为使用水平投影，2为3D动态，一般使用水平投影
	--}
	--}

	--连击相关
	self.targetList = {}
	self.skillTarget = 0
	
	self.PartnerAllParm.skillList = {
		--主动技能列表
		{--单击Q放主动技能
			id = 62001614,
			showType = 2,	--1变身型，2召唤型
			frame = 200,	--技能持续时间，时间结束自动进入退场流程
			skillType = 2, --1战前释放，2战中释放，3不需要战前战中切换
			distance =	2,	--召唤技能释放距离
			angle = 280,  --召唤技能释放角度
			targetType = 2,	--目标点：1以角色为中心，2以敌人为中心
			createPos = 1, --创建点：1以角色为中心，2以敌人为中心
			rushRange = 10,	--召唤冲刺技能极限范围，需要在技能帧事件中位移事件配置技能标记
			rolePerform = 1,	--0不使用角色出场动作，,1使用前召唤，2使用后召唤
			stableShow = 0,	--是否需要在指定位置稳定创建，0不需要，1需要
			Camera = 1,		--是否使用3D动态镜头，1为使用水平投影，2为3D动态，一般使用水平投影
		}

		--{--单点Q出生
			--id = 62001620,
			--showType = 2,	--1变身型，2召唤型
			--frame = 98,	--技能持续时间，时间结束自动进入退场流程
			--skillType = 2, --1战前释放，2战中释放，3不需要战前战中切换
			--distance =	3,	--召唤技能释放距离
			--angle = 60,  --召唤技能释放角度
			--targetType = 2,	--目标点：1以角色为中心，2以敌人为中心
			--createPos = 1, --创建点：1以角色为中心，2以敌人为中心。连线方向作为0度
			--stableShow = 0,	--是否需要在指定位置稳定创建
			--Camera = 0,		--是否使用3D动态镜头，0为不需要，1为使用水平投影，2为3D动态，一般使用水平投影
			--rolePerform = 3,	--0不使用角色出场动作，,1使用前召唤，2使用后召唤
		--}
	}

	self.myCameraWeight = 0	--相机权重系数
	--self.diyue = 0
	self.cameraReturn = false	--相机还原状态
	self.connectCamera = false	--默认连携相机不打开
	self.flyTarget = {}
	
	----出生和驻场
	--self.PartnerBornAndExist = BehaviorFunctions.CreateBehavior("PartnerBornAndExist",self)
	--self.PartnerBornAndExist.existOnStart = false           --是否初始在场？
	--self.PartnerBornAndExist.residentTime = -1              --驻场时间，单位秒。配负数表示永久
	--self.PartnerBornAndExist.bornOffset = Vec3.New(2,0,-2)  --出生坐标，基于主人面向建立坐标系偏移
	--self.PartnerBornAndExist.bornRadius = 3                 --点位不合法的时候搜索合法点位的半径
	

	----驻场索敌
	--self.PartnerResidentLockTarget = BehaviorFunctions.CreateBehavior("PartnerResidentLockTarget",self)
	--self.PartnerResidentLockTarget.ResidentLockTargetMode = 2   --驻场锁定模式：1-优先锁主人当前的锁定目标  2-锁离自己最近的目标,但主人被打就会锁攻击怪

	----驻场技能
	--self.PartnerResidentCastSkill = BehaviorFunctions.CreateBehavior("PartnerResidentCastSkill",self)
	----驻场技能列表
	--self.PartnerResidentCastSkill.ResidentSkillList = {
		--{
			--id = 62001618,
			--needTarget = 1,	       --开放参数：1需要锁定目标，2不需要锁定目标
			--minDistance = 0,       --开放参数：技能释放最小距离（有等号），不需要目标就跳过此判断
			--maxDistance = 6,       --开放参数：技能释放最大距离（无等号），不需要目标就跳过此判断
			--angle = 90,           --开放参数：释放角度，不需要目标就跳过此判断
			--cd = 15,           	   --开放参数：技能cd，单位：秒
			--frame = 0              --用来计算cd，必须要填
		--}
	--}

	----连携技能，玩家要在触发连携的技能里配技能窗口600000030
	--self.PartnerResidentCastSkill.ConnectSkill = {
		--id = 62001619,				--技能id
		--cd = 5,                      --技能cd，单位：秒
		--frame = 0,              --用来计算cd，必须要填
		--summonDis = 3,               --以主人面向为正方向，偏移距离
		--summonAngle = 45             --以主人面向为正方向，偏移角度
	--}

	----驻场跟随
	--self.PartnerFollow = BehaviorFunctions.CreateBehavior("PartnerFollow",self)
	--self.PartnerFollow.followPositionOffset = Vec3.New(0,0,0)    --跟随目标点坐标，基于主人面向建立坐标系偏移
	--self.PartnerFollow.followRadius = 3                           --位置不合法的时候扩散查询的位置
	--self.followType = 1                                           --佩从瞬移类型，1地面，2浮空（地面会检测瞬移点是否在地面）
	--self.teleportPositionOffset = Vec3.New(2,0,-1)                 --瞬移点坐标，基于主人面向建立坐标系偏移
	--self.PartnerFollow.teleportDistance = 21                     --瞬移距离（超过会瞬移）
	--self.PartnerFollow.followRadiusByRun = 10                     --跑步距离（超过会跑）
	--self.PartnerFollow.reachDistance = 2                        --停下距离（超过会走，≤会停下切待机）

	--self.PartnerFollow.rotateOnMove = true                       --是否在移动状态下才能转向？

	----驻场周旋
	--self.PartnerWander = BehaviorFunctions.CreateBehavior("PartnerWander",self)
	--self.PartnerWander.runDistance = 10                   --跑步距离（超过会跑）
	--self.PartnerWander.walkBackDistance = 3              --后退距离（超过会前走或左右走，≤会后走）
	--self.PartnerWander.walkTime = 3.466                  --走路时间
	--self.PartnerWander.walkLRTime = 4                --左右走时间
	--self.PartnerWander.walkBackTime = 1.733              --后走时间
	--self.PartnerWander.angle = 60                    --转身角度
end



function Behavior62001:Update()
	self.time = BehaviorFunctions.GetFightFrame()
	self.role = BehaviorFunctions.GetEntityOwner(self.me)
	self.ctrlRole = BehaviorFunctions.GetCtrlEntity()
	self.roleEntityId = BehaviorFunctions.GetEntityTemplateId(self.role)
	self.myEntityId = 62001
	self.roleState = BehaviorFunctions.GetEntityState(self.role)
	self.rolePos = BehaviorFunctions.GetPositionP(self.role)
	self.Role1 = BehaviorFunctions.GetQTEEntity(1)
	self.Role2 = BehaviorFunctions.GetQTEEntity(2)
	self.Role3 = BehaviorFunctions.GetQTEEntity(3)
	
	BehaviorFunctions.AddEntitySign(self.role,62001,-1,false)	--标记为携带了离歌
	
	--接入佩从通用AI
	self.PartnerAllParm:Update()
	self.PartnerCastSkill:Update()
	--self.PartnerCastSkill:Update()
	--self.PartnerBornAndExist:Update()
	--self.PartnerResidentLockTarget:Update()
	--self.PartnerResidentCastSkill:Update()
	--self.PartnerFollow:Update()
	--self.PartnerWander:Update()


	self.diyueHand = BehaviorFunctions.GetEntityValue(self.PartnerAllParm.role,"diyueHand")	--获取缓存的缔约挂点
	--BehaviorFunctions.SetEntityValue(self.role,"chain",self.chain)	--获取锁链id
	
	--根据战斗状态切换当前的技能类型
	if BehaviorFunctions.CheckPlayerInFight() then
		self.PartnerAllParm.partnerType = 0
		self.PartnerAllParm.autoChangeBtn = true
	else
		if not BehaviorFunctions.CheckPartnerShow(self.role) then
			self.PartnerAllParm.partnerType = 1
			self.PartnerAllParm.showType = 1
			self.PartnerAllParm.autoChangeBtn = false
		end
	end
	
	--判断仲魔的角色是否处于前台
	if self.role == BehaviorFunctions.GetCtrlEntity() then
		BehaviorFunctions.AddEntitySign(self.role,62001003,-1,false)	--标记为处于前台

		--仲魔等级成长
		self:PartnerGrow()

		self.fightSkillPos = BehaviorFunctions.GetPositionOffsetBySelf(self.role,3,300)	--战中技能释放位置
		self.worldSkillPos = BehaviorFunctions.GetPositionOffsetBySelf(self.role,0,0)	--战前技能释放位置
		self.MyFrontPos = BehaviorFunctions.GetPositionOffsetBySelf(self.role,10,0) --角色前方的位置
		self.partnerFrontPos = BehaviorFunctions.GetPositionOffsetBySelf(self.me,10,0) --仲魔前方的位置


		BehaviorFunctions.SetUseParentTimeScale(self.me, false)--不使用创建者时间缩放

		--暗杀总入口：如果不处于暗杀过程中且暗杀无cd，且不处于暗杀禁用状态，执行暗杀搜索
		if not BehaviorFunctions.HasEntitySign(self.role,62001001) and not BehaviorFunctions.HasEntitySign(self.ctrlRole,600000003) then
			self:AssassinTarget()
		else
			if BehaviorFunctions.CheckEntity(self.assTarget) then
				--BehaviorFunctions.RemoveBuff(self.assTarget,1000046)
				BehaviorFunctions.StopFightUIEffect("22105", "main")
				BehaviorFunctions.HideAssassinLifeBarTip(self.role, self.assTarget)
			end
		end

		--仲魔暗杀临时传距离
		BehaviorFunctions.SetEntityValue(self.role,"assDistance",self.assDistance)
		BehaviorFunctions.SetEntityValue(self.role,"highAssDis",self.highAssDis)
		BehaviorFunctions.SetEntityValue(self.role,"jumpAssDis",self.jumpAssDis)

		BehaviorFunctions.SetEntityValue(self.role,"connectSkillTarget",self.PartnerCastSkill.curSkillTarget)


		--更新仲魔按钮状态
		if BehaviorFunctions.CheckPlayerInFight() and self.curSkillId ~= self.connectSkill then
			self.curSkillId = self.connectSkill
			BehaviorFunctions.ChangePartnerSkill(self.role, self.connectSkill)
			BehaviorFunctions.DisableSkillButton(self.me,FightEnum.KeyEvent.Partner , false)
		elseif not BehaviorFunctions.CheckPlayerInFight() and self.curSkillId ~= 62001001 and not BehaviorFunctions.CheckPartnerShow(self.role) then
			self.curSkillId = 62001001
			BehaviorFunctions.DisableSkillButton(self.me,FightEnum.KeyEvent.Partner , false)
			BehaviorFunctions.ChangePartnerSkill(self.role, 62001001)
			--elseif not BehaviorFunctions.CheckPlayerInFight() and BehaviorFunctions.CheckEntityHeight(self.me) > 0 and self.curSkillId ~= 62001007 then
			--self.curSkillId = 62001007
			--BehaviorFunctions.DisableSkillButton(self.me,FightEnum.KeyEvent.Partner , false)
			--BehaviorFunctions.ChangePartnerSkill(self.role, 62001007)
		end

		--技能标记
		if self.role == BehaviorFunctions.GetCtrlEntity() and BehaviorFunctions.HasBuffKind(self.role,600000025) and self.connectTime < self.time then
			BehaviorFunctions.AddSkillEventActiveSign(self.role,610040)
		else
			BehaviorFunctions.RemoveSkillEventActiveSign(self.role,610040)
		end

		--如果离歌退场，移除屏幕特效保底
		if not BehaviorFunctions.CheckPartnerShow(self.role) and BehaviorFunctions.GetBuffCount(self.role,600000035) ~= 0 then
			BehaviorFunctions.RemoveBuff(self.role,600000035)
		end
		
		
		--被动3处决
		if BehaviorFunctions.HasEntitySign(self.me,6200103) then
			if self.mission == 0 then
				--如果携带者是叙慕
				BehaviorFunctions.DoMagic(self.me,self.me,600000043,1)	--离歌处决行为树
				BehaviorFunctions.AddEntitySign(self.role,600000045,-1,false)	--添加标记可以使用PV模式QTE连携
				self.mission = 1
			end
		end
		
		--被动1
		if BehaviorFunctions.HasEntitySign(self.me,6200101) then
			if not self.initBuff then
				BehaviorFunctions.AddBuff(self.me,self.role,62001031)
				self.initBuff = true
			end
		end
		--仲魔连携技能

		if BehaviorFunctions.CheckKeyDown(FightEnum.KeyEvent.Partner) and BehaviorFunctions.GetCtrlEntity() == self.role then
			if BehaviorFunctions.CheckBtnUseSkill(self.me,FightEnum.KeyEvent.Partner) then
				--BehaviorFunctions.AddEntitySign(self.role,600000,-1,false)	--标记仲魔在场
				--BehaviorFunctions.DoMagic(self.me,self.me,62001001,1)
				if BehaviorFunctions.CheckPlayerInFight() then

				elseif not BehaviorFunctions.CheckPlayerInFight() and not BehaviorFunctions.HasEntitySign(self.role,62001001) then
					--BehaviorFunctions.RemoveBuff(self.assingTarget,1000046)--移除暗杀锁定
					if BehaviorFunctions.CheckEntityHeight(self.role) > 0 then
						self.curHighPos = BehaviorFunctions.GetPositionP(self.role)
						BehaviorFunctions.DoMagic(self.role,self.role,1000066)
						BehaviorFunctions.AddBuff(self.me,self.me,1000066)--浮空buff
						--self:HighAssassin()
						if self.roleState == FightEnum.EntityState.Jump then
							self.assingTarget = self.assTarget	--确定暗杀目标
							--BehaviorFunctions.SetFightPanelVisible("0")
							BehaviorFunctions.SetFightPanelVisible("00010000")--隐藏角色UI
							BehaviorFunctions.SetJoyStickVisibleByAlpha(2, false, false)
							BehaviorFunctions.DoMagic(self.role,self.role,1000051)--播放仲魔变身出现特效
							BehaviorFunctions.AddDelayCallByTime(0.15,self,self.HighAssassin)
							BehaviorFunctions.AddEntitySign(self.role,62001001,-1,false)	--标记为正在暗杀
							BehaviorFunctions.StopFightUIEffect("22105", "main")--清除预暗杀UI
						elseif self.roleState == FightEnum.EntityState.Glide then
							self.assingTarget = self.assTarget	--确定暗杀目标
							--BehaviorFunctions.SetFightPanelVisible("0")
							BehaviorFunctions.SetFightPanelVisible("00010000")--隐藏角色UI
							BehaviorFunctions.SetJoyStickVisibleByAlpha(2, false, false)
							BehaviorFunctions.DoMagic(self.role,self.role,1000051)--播放仲魔变身出现特效
							BehaviorFunctions.AddDelayCallByTime(0.2,self,self.GlideAssassin)
							BehaviorFunctions.AddEntitySign(self.role,62001001,-1,false)	--标记为正在暗杀
							BehaviorFunctions.StopFightUIEffect("22105", "main")--清除预暗杀UI
						end
					elseif BehaviorFunctions.CheckEntityHeight(self.role) == 0 then
						--BehaviorFunctions.AddEntitySign(self.role,62001001,-1,false)	--标记为正在暗杀
						if BehaviorFunctions.HasEntitySign(self.role,610025) then
							self:readyHenshin(0.12)
						end
					end
					--BehaviorFunctions.CastSkillCost(self.me,62001008)
				end
				--如果技能可用但没目标
			elseif not BehaviorFunctions.CheckPlayerInFight() and BehaviorFunctions.GetBtnSkillCD(self.me,FightEnum.KeyEvent.Partner) <= 0 then
				BehaviorFunctions.ShowTip(80000000)
			end
		end
		--不处于前台时清掉暗杀标记
	else
		if BehaviorFunctions.CheckEntity(self.assTarget) then
			--BehaviorFunctions.RemoveBuff(self.assTarget,1000046)
			BehaviorFunctions.StopFightUIEffect("22105", "main")
			BehaviorFunctions.HideAssassinLifeBarTip(self.role, self.assTarget)
		end
		BehaviorFunctions.RemoveEntitySign(self.role,62001003)
	end


	--暗杀保底
	if self.assProtectFrame < self.time and self.assEndState == 1 then
		BehaviorFunctions.BreakSkill(self.me)
		BehaviorFunctions.CastSkillBySelfPosition(self.me,62001006)
		self:PartnerExit()	--退场
		--BehaviorFunctions.RemoveEntitySign(self.role,62001001)--移除处于刺杀状态
		if self.assingTarget then
			BehaviorFunctions.SetEntityLifeBarDelayDeathHide(self.assingTarget, false)
		end
		self.assEndState = 0
	end

	--判断攻击目标位置，地面2空中1
	--if self.PartnerAllParm.HasTarget then
		--if self.PartnerCastSkill.curSkillTarget then
			--if self.PartnerCastSkill.curSkillTarget ~= 0 and BehaviorFunctions.CheckEntity(self.PartnerCastSkill.curSkillTarget) then
				--if BehaviorFunctions.HasEntitySign(self.role,600000010) then
					--if  BehaviorFunctions.CheckEntityHeight(self.PartnerCastSkill.curSkillTarget) == 0 then
						--BehaviorFunctions.RemoveSkillEventActiveSign(self.me,1006001)
						--BehaviorFunctions.AddSkillEventActiveSign(self.me,1006002)
					--else
						--BehaviorFunctions.RemoveSkillEventActiveSign(self.me,1006002)
						--BehaviorFunctions.AddSkillEventActiveSign(self.me,1006001)
					--end
				--end
			--end
		--end
	--end



	--连携技能用，判断高度开启Y轴偏移
	--if self.checkHeight and BehaviorFunctions.HasEntitySign(self.role,600000010) then
		--local distance = BehaviorFunctions.GetDistanceFromTarget(self.me,self.role,false)
		--local height = BehaviorFunctions.CheckEntityHeight(self.me)
		--local heightRadius = 0.12 * distance - 0.03 * height

		--if heightRadius < 0 then
			--heightRadius = 0
		--elseif heightRadius > 1 then
			--heightRadius = 1
		--end

		--BehaviorFunctions.SetCamerIgnoreData(FightEnum.CameraState.Fight,true,heightRadius)
	--else
		--BehaviorFunctions.SetCamerIgnoreData(FightEnum.CameraState.Fight,true,0.2)
	--end

end

function Behavior62001:AddSkillSign(instanceId,sign)
	if instanceId == self.me or instanceId == self.role then

		--佩从离场时停
		if sign == 600000009 then
			BehaviorFunctions.AddBuff(self.me,self.me,600000031,1)					--时停
		end

		--if sign == 600000006 then
			--BehaviorFunctions.DoMagic(self.me,self.me,600000004,1)	--播放离场特效
			--BehaviorFunctions.DoMagic(self.me,self.me,600000006,1)  --播放离场特效
			--BehaviorFunctions.DoMagic(self.PartnerAllParm.CtrlRole,self.PartnerAllParm.CtrlRole,600000048,1)	--角色缔约结束特效
			--BehaviorFunctions.RemoveBuff(self.PartnerAllParm.CtrlRole,600000050)	--移除角色缔约状态
			--BehaviorFunctions.RemoveBuff(self.me,600000049)	--移除佩从缔约状态
			--BehaviorFunctions.RemoveFollowTarget(self.me,"HitCase")	--移除相机关注点
			--BehaviorFunctions.RemoveLookAtTarget(self.me,"HitCase")	--移除相机注视点
			--BehaviorFunctions.SetGroupPositionMode(1)	--设置回3D相机
			--BehaviorFunctions.RemoveEntitySign(self.role,600000010)
			--BehaviorFunctions.RemoveEntitySign(1,600000010)--移除连携相机标记
			--self.connectCamera = false
			----移除锁链
			--if self.chain and self.chain ~= 0 then
				--if BehaviorFunctions.CheckEntity(self.chain) then
					--BehaviorFunctions.RemoveEntity(self.chain)
				--end
			--end
			--BehaviorFunctions.CallCommonBehaviorFunc(self.me, "DoPartnerLeave")		--进入仲魔退场流程
			----BehaviorFunctions.RemoveEntitySign(self.role,600021012)
			----BehaviorFunctions.DoMagic(self.me,self.me,600000024,1)		--离场顿帧
			----BehaviorFunctions.DoMagic(self.me,self.me,600000006,1)		--播放退场特效
		--end

		--追击仲魔顿帧，废弃
		if sign == 600000008 and BehaviorFunctions.HasBuffKind(self.role,600000025) then
			BehaviorFunctions.DoMagic(self.role,self.role,600000010)
			BehaviorFunctions.DoMagic(self.role,self.role,600000009)
		end

		if sign == 62001001 then
			self:DoAssassinSkill()
		end

		--被暗杀标记
		if sign == 62001101 then
			BehaviorFunctions.AddEntitySign(self.assingTarget,62001101,150,false)
		end

		--if sign == 62001003 then
		--if BehaviorFunctions.GetDistanceFromTarget(instanceId,self.battleTarget,false) < 0.5 then
		--BehaviorFunctions.CastSkillByTarget(self.me,62001003,self.battleTarget)
		--end
		--end

		--暗杀地面接触
		if sign == 62001011 then
			BehaviorFunctions.CastSkillByTarget(self.me,62001009,self.assingTarget)
			--BehaviorFunctions.RemoveEntitySign(self.role,62001001)
		end

		--播放后受击
		if sign == 62001062 then
			BehaviorFunctions.RemoveBuff(self.assingTarget,900000057)
			--BehaviorFunctions.DoLookAtPositionImmediately(self.assingTarget,self.partnerFrontPos.x,self.partnerFrontPos.y,self.partnerFrontPos.z,true)
			BehaviorFunctions.AddEntitySign(self.assingTarget,62001062,4500,false)
		end

		--暗杀时没踹前静止怪物行为
		if sign == 62001020 or sign == 62001009 then
			BehaviorFunctions.DoMagic(self.me,self.assingTarget,900000057,1)
		end
		----暗杀空中接触
		--if sign == 62001007 then
		--BehaviorFunctions.CastSkillByTarget(self.me,62001004,self.assingTarget)
		--end
		--设置相机
		--if sign == 62001997 then
		--BehaviorFunctions.SetMainTarget(self.me)--设置相机目标
		--end

		--连携技能
		--if sign == 600000002 and BehaviorFunctions.CheckPlayerInFight() then

			--self:CallPartnerFight(self.connectSkill,self.role,2,280)
			----BehaviorFunctions.OpenPartnerFightBanner(self.me)	--播放横幅
			----BehaviorFunctions.DoMagic(self.me,self.role,600000025)
			----self.PartnerX,self.PartnerY,self.PartnerZ = BehaviorFunctions.GetEntityTransformPos(self.me,"")

			----	self.diyue = BehaviorFunctions.CreateEntity(1000000002,self.me)
			----	BehaviorFunctions.ClientEffectRelation(self.diyue,self.role,self.me,0)
			----BehaviorFunctions.DoMagic(self.me,self.role,600000035,1)	--播放屏幕特效

		--end

		--播放结束屏幕特效
		if sign == 600000033 then
			BehaviorFunctions.DoMagic(self.me,self.role,600000036,1)
			BehaviorFunctions.AddDelayCallByFrame(2,self,self.DelayEndEffect,self.role)
		end

		--暗杀开始
		if sign == 62001009 or sign == 62001007 or sign == 62001013 then
			BehaviorFunctions.RemoveBuff(self.me,1000066)
			BehaviorFunctions.DoMagic(self.me,self.me,1000066)
			BehaviorFunctions.DoLookAtPositionImmediately(self.assingTarget,self.partnerFrontPos.x,self.partnerFrontPos.y,self.partnerFrontPos.z,true)	--转向目标
			BehaviorFunctions.CastSkillByTarget(self.me,62001011,self.assingTarget)	--释放暗杀开始技能
			BehaviorFunctions.SetEntityLifeBarDelayDeathHide(self.assingTarget, true)	--开启血条延迟销毁（death后）
			--BehaviorFunctions.RemoveBuff(self.me,600000051)	--移除浮空不下坠
		end

		--播放下落循环
		if sign == 62001999 then
			BehaviorFunctions.BreakSkill(self.me)
			BehaviorFunctions.CastSkillBySelfPosition(self.me,62001005)
			BehaviorFunctions.RemoveBuff(self.me,600000014)	--移除允许穿墙
			self.assEndState = 1
			self.assProtectFrame = self.time + self.assEndFrame
		end


		--暗杀噶头
		if sign == 62001003 or sign == 62001002 or sign == 62001010 then
			BehaviorFunctions.RemoveBuff(self.assingTarget,900000054)
			--延迟移除怪物顿帧
		end

		--暗杀攻击帧镜头模糊
		if sign == 62001002 then
			----BehaviorFunctions.DoMagic(self.me,self.assingTarget,1000050)
			--BehaviorFunctions.DoMagic(self.me,self.me,1000061)
			BehaviorFunctions.DoShowPosVague(self.me, 0.5, 10, 100000022, 0.85, 1, 40, 0.5,0.5, 0,30)--镜头模糊
		end

		--仲魔变身
		if sign == 600000002 and instanceId == self.role then
			self:readyHenshin(0.12)
		end


		--可以释放QTE
		--if sign == 62001615 then
			----BehaviorFunctions.SetGroupPositionMode(1)	--3D相机
			----BehaviorFunctions.AddEntitySign(self.role,600021012,-1,false)
			--BehaviorFunctions.AddEntitySign(1,600021012,-1,false)
		--end


		if sign == 62001614 then
			--if self.PartnerAllParm.HasTarget then
				--如果有缓存的击飞目标
				--if self.skillTarget and self.skillTarget ~= 0 and BehaviorFunctions.CheckEntity(self.skillTarget) then
				if next(self.targetList) then
					for index,target in pairs(self.targetList) do
						if BehaviorFunctions.CheckEntity(target) then
					--BehaviorFunctions.SetSoftZone(false)	--关闭全屏缓出
							BehaviorFunctions.CastSkillByTarget(self.me,62001615,target)
							break
						end
					end
				else
					self.PartnerCastSkill:EndCreatePartnerSkill()
				end
			--end
		end

	end
end

--暗杀技能
function Behavior62001:DoAssassinSkill()

	--播放QTE
	self.Assassin1QTE = BehaviorFunctions.DoShowAssassinQTE(self.me, 2.5, 0.8, 2)
	--添加顿帧
	BehaviorFunctions.DoMagic(self.me,self.me,1000047)
end


--落地回调
function Behavior62001:OnLand(instanceId)
	if instanceId == self.me and BehaviorFunctions.GetSkill(self.me) == 62001005 then

		BehaviorFunctions.BreakSkill(self.me)
		BehaviorFunctions.CastSkillBySelfPosition(self.me,62001006)
		self:PartnerExit()	--退场
		--	BehaviorFunctions.RemoveEntitySign(self.role,62001001)--移除处于刺杀状态
		if self.assingTarget then
			BehaviorFunctions.SetEntityLifeBarDelayDeathHide(self.assingTarget, false)
		end
		self.assEndState = 0
	end
end


function Behavior62001:Collide(attackInstanceId,hitInstanceId,instanceId,shakeStrenRatio,attackType)
	if attackInstanceId == self.me and BehaviorFunctions.GetEntityTemplateId(instanceId) == 62001008001 then
		BehaviorFunctions.AddSkillEventActiveSign(self.role,1001999)
		BehaviorFunctions.AddBuff(self.me,self.role,62001003,1)	--让角色受到我的顿帧影响
	end

	if attackInstanceId == self.me and BehaviorFunctions.GetEntityTemplateId(instanceId) == 62001009001 and hitInstanceId == self.assingTarget then
		BehaviorFunctions.PlayIKShake(hitInstanceId, 6200101, 1)
		if BehaviorFunctions.HasEntitySign(self.me,6200102) then
			BehaviorFunctions.AddBuff(self.me,hitInstanceId,62001032,1)
		end
	end
	if attackInstanceId == self.me and BehaviorFunctions.GetEntityTemplateId(instanceId) == 62001004001 and hitInstanceId == self.assingTarget then
		BehaviorFunctions.PlayIKShake(hitInstanceId, 6200101, 1)
		if BehaviorFunctions.HasEntitySign(self.me,6200102) then
			BehaviorFunctions.AddBuff(self.me,hitInstanceId,62001032,1)
		end
		--BehaviorFunctions.DoMagic(1,1,1000063)
	end

	--检测到最后一刀
	if attackInstanceId == self.me and BehaviorFunctions.GetEntityTemplateId(instanceId) == 62001614003 then
		BehaviorFunctions.RemoveBuff(hitInstanceId,600000051)	--移除浮空buff
		self.flyTarget = {}		--清空缓存的目标列表
	end

	--不忽略Y轴
	if attackInstanceId == self.me and BehaviorFunctions.GetEntityTemplateId(instanceId) == 62001614005	then
		self.checkHeight = true
		BehaviorFunctions.AddEntitySign(1,60001002,-1,false)	--标记为刻刻可以连携
		BehaviorFunctions.AddEntitySign(1,62001614005,-1,false)	--标记为离歌正在技能中
	end

	----检测到最后一刀
	--if attackInstanceId == self.me and BehaviorFunctions.GetEntityTemplateId(instanceId) == 62001614004 then
	--BehaviorFunctions.RemoveBuff(hitInstanceId,600000051)	--移除浮空buff
	--end
	
	--缓存被命中的单位列表
	if attackInstanceId == self.me and BehaviorFunctions.GetEntityTemplateId(instanceId) == 62001614001	then
		table.insert(self.flyTarget,hitInstanceId)
	end
end

--击飞目标技能判断
function Behavior62001:Hit(attackInstanceId,hitInstanceId,hitType,camp,bulletInstanceId)
	if BehaviorFunctions.GetEntityTemplateId(bulletInstanceId) == 62001614005 then
		if hitInstanceId and BehaviorFunctions.CheckEntity(hitInstanceId) then
			--添加连击目标列表
			if BehaviorFunctions.GetHitType(hitInstanceId) == FightEnum.EntityHitState.HitFlyUp or BehaviorFunctions.GetHitType(hitInstanceId) == FightEnum.EntityHitState.HitFlyFall then
				self.skillTarget = hitInstanceId
				table.insert(self.targetList,self.skillTarget)
				BehaviorFunctions.AddSkillEventActiveSign(self.me,62001614)
				BehaviorFunctions.RemoveSkillEventActiveSign(self.me,62001615)
			end
		end
	end
end


--结束暗杀QTE
function Behavior62001:EndAssassinQTE(qteId,result)
	if qteId == self.Assassin1QTE then
		--移除顿帧
		BehaviorFunctions.RemoveBuff(self.me,1000062)
		BehaviorFunctions.RemoveBuff(self.me,1000066)--移除浮空buff
		BehaviorFunctions.RemoveBuff(self.me,1000047)--移除顿帧
		if BehaviorFunctions.GetBuffCount(self.role,60023001) > 0 then
			--根据结果释放,0失败，2完美，1普通
			if result == 0 then
				BehaviorFunctions.DoEntityAudioPlay(self.me,"Assassin_fail",true)
				BehaviorFunctions.CastSkillByTarget(self.me,62001010,self.assingTarget)
			elseif result == 2 or result == 1 then
				BehaviorFunctions.DoEntityAudioPlay(self.me,"Assassin_success",true)
				BehaviorFunctions.CastSkillByTarget(self.me,62001002,self.assingTarget)
				--BehaviorFunctions.CastSkillByTarget(self.me,62001009,self.assingTarget)
				BehaviorFunctions.DoShowPosVague(self.me, 0.15, 20, 100000005, 0.85, 1, 40, 0.5,0.35, 0,30)--镜头模糊
			end
		else
			--根据结果释放,0失败，2完美，1普通
			if result == 0 then
				BehaviorFunctions.DoEntityAudioPlay(self.me,"Assassin_fail",true)
				BehaviorFunctions.CastSkillByTarget(self.me,62001010,self.assingTarget)
			elseif result == 2 then
				BehaviorFunctions.DoEntityAudioPlay(self.me,"Assassin_success",true)
				BehaviorFunctions.CastSkillByTarget(self.me,62001002,self.assingTarget)
				--BehaviorFunctions.CastSkillByTarget(self.me,62001009,self.assingTarget)
				BehaviorFunctions.DoShowPosVague(self.me, 0.15, 20, 100000005, 0.85, 1, 40, 0.5,0.35, 0,30)--镜头模糊
			elseif result == 1 then
				BehaviorFunctions.DoEntityAudioPlay(self.me,"Assassin_finish",true)
				BehaviorFunctions.CastSkillByTarget(self.me,62001003,self.assingTarget)
				--BehaviorFunctions.CastSkillByTarget(self.me,62001004,self.assingTarget)
			end
		end
	end
end

--变身
function Behavior62001:Henshin()
	--BehaviorFunctions.SetFightPanelVisible("0")--隐藏UI
	BehaviorFunctions.SetFightPanelVisible("00010000")--隐藏角色UI
	BehaviorFunctions.DoLookAtPositionImmediately(self.me,self.MyFrontPos.x,self.MyFrontPos.y,self.MyFrontPos.z)--设置朝向
	BehaviorFunctions.ShowPartner(self.role, true)--显示仲魔
	BehaviorFunctions.DoMagic(self.me,self.me,600000003)--震屏
	BehaviorFunctions.DoMagic(self.me,self.me,1000053)	--播放仲魔变身出现特效
	BehaviorFunctions.DoMagic(self.me,self.me,1000055)	--角色变身佩从通用初始buff
	BehaviorFunctions.DoMagic(self.me,self.me,600000014)	--允许穿墙
	BehaviorFunctions.DoMagic(self.me,self.me,1000038)	--允许穿墙
	BehaviorFunctions.RemoveAllFollowTarget()
	BehaviorFunctions.AddFollowTarget(self.me,"CameraTarget")
	--BehaviorFunctions.DoMagic(self.me,self.me,600000051)	--浮空不下坠
	BehaviorFunctions.CastSkillByTarget(self.me,62001001,self.assTarget)--释放暗杀开始技能
	--BehaviorFunctions.CastSkillCost(self.me,62001001)--按钮资源扣除
	BehaviorFunctions.AddEntitySign(self.ctrlRole,600000012,-1,false)
end

--空中暗杀
function Behavior62001:HighAssassin()
	BehaviorFunctions.AddEntitySign(self.role,600000021,-1,false)
	--BehaviorFunctions.DoSetPosition(self.role,self.curHighPos.x,self.curHighPos.y,self.curHighPos.z)--设置坐标
	--BehaviorFunctions.SetFightPanelVisible("0")
	BehaviorFunctions.DoLookAtTargetByLerp(self.me,self.assingTarget,false,360,360,-2,false)--设置朝向
	BehaviorFunctions.DoSetPosition(self.me,self.curHighPos.x,self.curHighPos.y,self.curHighPos.z)--设置坐标
	BehaviorFunctions.DoMagic(self.me,self.me,1000055)--无敌
	BehaviorFunctions.DoMagic(self.me,self.me,600000014)	--允许穿墙
	BehaviorFunctions.ShowPartner(self.role, true)	--显示
	BehaviorFunctions.DoMagic(self.me,self.me,1000053)--播放仲魔变身出现特效

	BehaviorFunctions.AddDelayCallByFrame(6,BehaviorFunctions,BehaviorFunctions.DoMagic,self.role,self.role,1000048)
	--BehaviorFunctions.SetMainTarget(self.me)
	BehaviorFunctions.RemoveAllFollowTarget()
	BehaviorFunctions.AddFollowTarget(self.me,"CameraTarget")
	BehaviorFunctions.CastSkillByTarget(self.me,62001007,self.assTarget)--播放技能
	BehaviorFunctions.AddEntitySign(self.ctrlRole,600000012,-1,false)
	--BehaviorFunctions.DoMagic(self.me,self.me,600000051)	--浮空不下坠
	--BehaviorFunctions.CastSkillCost(self.me,62001001)
	--BehaviorFunctions.AddDelayCallByTime(1,BehaviorFunctions,BehaviorFunctions.DoMagic,self.role,self.role,1000048)
end

--滑翔暗杀
function Behavior62001:GlideAssassin()
	BehaviorFunctions.AddEntitySign(self.role,600000021,-1,false)
	--BehaviorFunctions.DoSetPosition(self.role,self.curHighPos.x,self.curHighPos.y,self.curHighPos.z)--设置坐标
	BehaviorFunctions.SetBodyDamping(0.5,0.5,0.5)
	BehaviorFunctions.DoLookAtTargetByLerp(self.me,self.assingTarget,false,360,360,-2,false)--设置朝向
	BehaviorFunctions.DoSetPosition(self.me,self.curHighPos.x,self.curHighPos.y,self.curHighPos.z)--设置坐标
	BehaviorFunctions.DoMagic(self.me,self.me,1000055)--无敌
	BehaviorFunctions.DoMagic(self.me,self.me,600000014)	--允许穿墙
	BehaviorFunctions.ShowPartner(self.role, true)	--显示
	BehaviorFunctions.DoMagic(self.me,self.me,1000053)--播放仲魔变身出现特效
	BehaviorFunctions.AddDelayCallByFrame(6,BehaviorFunctions,BehaviorFunctions.DoMagic,self.role,self.role,1000048)
	--BehaviorFunctions.SetMainTarget(self.me)
	BehaviorFunctions.RemoveAllFollowTarget()
	BehaviorFunctions.AddFollowTarget(self.me,"CameraTarget")
	BehaviorFunctions.CastSkillByTarget(self.me,62001013,self.assTarget)--播放技能
	BehaviorFunctions.AddEntitySign(self.ctrlRole,600000012,-1,false)
	--BehaviorFunctions.DoMagic(self.me,self.me,600000051)	--浮空不下坠
	--BehaviorFunctions.CastSkillCost(self.me,62001001)
	--BehaviorFunctions.AddDelayCallByTime(1,BehaviorFunctions,BehaviorFunctions.DoMagic,self.role,self.role,1000048)
end

--仲魔退场
function Behavior62001:PartnerExit()
	BehaviorFunctions.AddDelayCallByTime(1,self,self.delayHidePartner)
	BehaviorFunctions.DoMagic(self.me,self.me,1000052)
	BehaviorFunctions.DoMagic(self.role,self.role,1000054)
	BehaviorFunctions.CastSkillCost(self.me,62001001)--设置资源消耗
	--设置位置
	self.myPos = BehaviorFunctions.GetPositionP(self.me)
	BehaviorFunctions.DoSetEntityState(self.role,FightEnum.EntityState.Idle)
	BehaviorFunctions.DoSetPosition(self.role,self.myPos.x,self.myPos.y,self.myPos.z)
	BehaviorFunctions.SetCameraStateForce(FightEnum.CameraState.Operating,false)
	BehaviorFunctions.RemoveAllFollowTarget()
	--BehaviorFunctions.SetMainTarget(self.role)
	BehaviorFunctions.RemoveAllFollowTarget()
	BehaviorFunctions.AddFollowTarget(self.role,"CameraTarget")
	BehaviorFunctions.RemoveBuff(self.role,1000048)
	BehaviorFunctions.RemoveBuff(self.me,1000055)
	BehaviorFunctions.RemoveBuff(self.role,1000055)
	BehaviorFunctions.SetFightPanelVisible("-1")--移除UI隐藏
	BehaviorFunctions.SetJoyStickVisibleByAlpha(2, true, true) --摇杆状态
	BehaviorFunctions.SetCoreUIEnable(self.role, true)--显示核心能量条
	BehaviorFunctions.RemoveEntitySign(self.ctrlRole,600000021)	--移除当前正在变身
	--BehaviorFunctions.RemoveEntitySign(self.role,600000)--移除仲魔在场标记
end

--暗杀目标搜索
function Behavior62001:AssassinTarget()
	--如果携带了暗杀仲魔且不在战斗中
	if not BehaviorFunctions.CheckPlayerInFight() and BehaviorFunctions.GetBtnSkillCD(self.me,FightEnum.KeyEvent.Partner) <= 0 then
		--搜索目标
		if self.roleState == FightEnum.EntityState.Glide then
			self.AllTargetList = BehaviorFunctions.SearchEntities(self.role,self.highAssDis,315,45,2,1,900000053,1004,0,0,nil,false,true,0.2,0.8,false,false,true)
		elseif self.roleState == FightEnum.EntityState.Jump then
			self.AllTargetList = BehaviorFunctions.SearchEntities(self.role,self.jumpAssDis,315,45,2,1,900000053,1004,0,0,nil,false,true,0.2,0.8,false,false,true)
		else
			self.AllTargetList = BehaviorFunctions.SearchEntities(self.role,self.assDistance,315,45,2,1,900000053,1004,0,0,nil,false,true,0.2,0.8,false,false,true)
		end
		self.setPartnerBtn = 1	--脱战重置按钮设置状态
		if next(self.AllTargetList) then
			--存在实体
			if BehaviorFunctions.CheckEntity(self.AllTargetList[1][1]) then
				self.assNewTarget = self.AllTargetList[1][1]
				--让暗杀目标始终更新
				if self.assNewTarget == self.assTarget then
					--BehaviorFunctions.AddBuff(self.role,self.assTarget,1000046)
					BehaviorFunctions.PlayFightUIEffect("22105", "main", nil, self.assTarget)
				else
					if BehaviorFunctions.CheckEntity(self.assTarget) then
						--BehaviorFunctions.RemoveBuff(self.assTarget,1000046)
						BehaviorFunctions.HideAssassinLifeBarTip(self.role, self.assTarget)
						BehaviorFunctions.StopFightUIEffect("22105", "main")
					end
					self.assTarget = self.assNewTarget
				--	BehaviorFunctions.PlayFightUIEffect("22105", "main", nil, self.assTarget)
				end
				--存在时且按钮不处于cd时打开暗杀按钮并进行预计算
				BehaviorFunctions.DisableSkillButton(self.me,FightEnum.KeyEvent.Partner , false)
				BehaviorFunctions.ShowAssassinLifeBarTip(self.role, self.assTarget, 0, 1000049,1000050)

			end
		else
			--不存在时禁用暗杀按钮
			BehaviorFunctions.DisableSkillButton(self.me,FightEnum.KeyEvent.Partner , true)
			BehaviorFunctions.StopFightUIEffect("22105", "main")
			self.assTarget = 0
		end
	else
		if self.assTarget ~= 0 then
			BehaviorFunctions.HideAssassinLifeBarTip(self.role, self.assTarget)
			--BehaviorFunctions.RemoveBuff(self.assTarget,1000046)
			BehaviorFunctions.StopFightUIEffect("22105", "main")
			self.assTarget = 0
		end

		--进入战斗打开仲魔按钮
		if self.setPartnerBtn == 0 then
			BehaviorFunctions.DisableSkillButton(self.me,FightEnum.KeyEvent.Partner , false)
			self.setPartnerBtn = 1
		end
	end
end


--获取仲魔养成等级
function Behavior62001:PartnerGrow()

	local skillLevel = 0
	local assDisGrow = 0
	local assVal = 0

	
	--检查技能等级
	for i = 1,99 do
		if BehaviorFunctions.HasEntitySign(self.role,6200100800 + i) then
			skillLevel = i
		end
	end

	--增加暗杀距离
	if skillLevel == 1 then
		assDisGrow = 0
	elseif skillLevel > 1 then
		assDisGrow = self.growAssDistance * skillLevel
	end
	
	if self.Role1 and BehaviorFunctions.HasBuffKind(self.Role1,40034001) then
		assVal = BehaviorFunctions.GetEntityValue(self.Role1,"assVal")
	elseif self.Role2 and BehaviorFunctions.HasBuffKind(self.Role2,40034001) then
		assVal = BehaviorFunctions.GetEntityValue(self.Role2,"assVal")
	elseif self.Role3 and BehaviorFunctions.HasBuffKind(self.Role3,40034001) then
		assVal = BehaviorFunctions.GetEntityValue(self.Role3,"assVal")
	else
		assVal = 0
	end
	
	--最终暗杀距离=基础暗杀距离+成长距离
	if assVal then
		self.assDistance = (self.baseAssDistance + assDisGrow) * (1 + assVal/10000)
	else
		self.assDistance = (self.baseAssDistance + assDisGrow)
	end

	--缓存更新
	--if self.assDistance ~= assDistance then
	--self.assDistance = assDistance
	--end
end



--延迟隐藏佩从
function Behavior62001:delayHidePartner()
	if self.role and not BehaviorFunctions.HasEntitySign(self.me,62001001) then
		--BehaviorFunctions.BreakSkill(self.me)
		BehaviorFunctions.ShowPartner(self.role,false)
		BehaviorFunctions.RemoveBuff(self.me,1000038)
		if BehaviorFunctions.HasBuffKind(self.role,40019001) then
			BehaviorFunctions.SetEntityValue(self.me,"assingTarget",self.assingTarget)
		end
		self.assingTarget = 0
		BehaviorFunctions.RemoveEntitySign(self.role,62001001)--移除处于刺杀状态
		BehaviorFunctions.RemoveEntitySign(self.ctrlRole,600000012)
		BehaviorFunctions.SetBodyDamping()
	end
end
--离场重置
--function Behavior62001:OnTransport()
--BehaviorFunctions.BreakSkill(self.me)	--打断自身技能
--BehaviorFunctions.ShowPartner(self.role, false)	--隐藏仲魔
--BehaviorFunctions.RemoveEntitySign(self.me,600002)	--移除退场标记
--BehaviorFunctions.RemoveEntitySign(self.role,600000)	--结束仲魔在场状态
--BehaviorFunctions.RemoveEntitySign(self.role,self.me)	--结束自己在场状态
--BehaviorFunctions.RemoveBuff(self.me,1000055)	--移除无敌buff
----移除溶解buff
--if BehaviorFunctions.GetBuffCount(self.me,600000006) ~= 0 then
--BehaviorFunctions.RemoveBuff(self.me,600000006)
--end
--end

function Behavior62001:CastSkill(instanceId,skillId,skillSign,skillType)
	--每次释放技能清空连击目标列表
	if instanceId == self.me and skillId == 62001614 then
		BehaviorFunctions.RemoveSkillEventActiveSign(self.me,62001614)
		BehaviorFunctions.AddSkillEventActiveSign(self.me,62001615)
		self.targetList = {}
	end
end

--function Behavior62001:CastSkill(instanceId,skillId,skillSign,skillType)
--if instanceId == self.role then
----战魂检测
--if BehaviorFunctions.HasBuffKind(self.role,600000025) and self.connectTime < self.time then
--if skillType == 10 then
--BehaviorFunctions.CallCommonBehaviorFunc(self.me, "StopPartnerLeave")	--终止正在进行的离场流程
--BehaviorFunctions.RemoveBuff(self.me,600000031)	--离场定帧移除
--self:CallPartnerFight(62001604,self.battleTarget,5,280)
--self.connectTime = self.time + 70
--end

--if skillType == 40 then
--BehaviorFunctions.CallCommonBehaviorFunc(self.me, "StopPartnerLeave")	--终止正在进行的离场流程
--BehaviorFunctions.RemoveBuff(self.me,600000031)
--self:CallPartnerFight(62001507,self.battleTarget,5,280)
--self.connectTime = self.time + 110
--end

--if skillId == self.roleEntityId * 1000 + 5 then
--BehaviorFunctions.CallCommonBehaviorFunc(self.me, "StopPartnerLeave")	--终止正在进行的离场流程
--BehaviorFunctions.RemoveBuff(self.me,600000031)
--self:CallPartnerFight(62001617,self.battleTarget,5,280)
--self.connectTime = self.time + 80
--end


----if skillId == 1006001 then
----BehaviorFunctions.CallCommonBehaviorFunc(self.me, "StopPartnerLeave")	--终止正在进行的离场流程
----BehaviorFunctions.RemoveBuff(self.me,600000031)
----self:CallPartnerFight(62001617,self.battleTarget,5,280)
----self.connectTime = self.time + 80
----end

--end
--end
--end


--延迟移除屏幕特效
function Behavior62001:DelayEndEffect(instanceId)
	if instanceId then
		BehaviorFunctions.RemoveBuff(self.role,600000035)
	end
end

--function Behavior62001:BeforeDie(instanceId)
--if instanceId == self.role then
--BehaviorFunctions.RemoveEntitySign(self.role,600000)	--结束仲魔在场状态
--end
--end

--仲魔离场回调
--function Behavior62001:PartnerHide(instanceId)
	--if instanceId == self.me then
		--BehaviorFunctions.RemoveEntitySign(self.me,600002)
		--BehaviorFunctions.RemoveEntitySign(self.role,600000)	--结束仲魔在场状态
		--BehaviorFunctions.RemoveEntitySign(self.role,self.me)	--结束自己在场状态
		--BehaviorFunctions.RemoveBuff(self.me,1000055)	--移除无敌buff
		--BehaviorFunctions.RemoveBuff(self.me,600000031)	--移除离场顿帧
		--BehaviorFunctions.BreakSkill(self.me)
		----BehaviorFunctions.ShowPartner(self.role,false)
		--BehaviorFunctions.DoMagic(self.me,self.PartnerAllParm.role,600000048,1)	--播放缔约结束特效
		--BehaviorFunctions.RemoveBuff(self.PartnerAllParm.role,600000050)	--移除角色被缔约特效
		--BehaviorFunctions.RemoveBuff(self.me,600000049)	--移除自己被缔约特效
		--BehaviorFunctions.SetCorrectCameraState(FightEnum.CameraState.Fight, true)--开启回正
	--end
--end

--移除时候清空暗杀标记
function Behavior62001:BeforePartnerReplaced(roleInstanceId, partnerInstanceId)
	if partnerInstanceId == self.me then
		--携带了暗杀类型的仲魔
		BehaviorFunctions.RemoveEntitySign(self.role,62001003)
	end
end


--设置相机组权重
--参数：施法参照点，1以自身，2以目标
function Behavior62001:SetCameraTargetWeight(skillType)
	local rolePos = BehaviorFunctions.GetTransformScreenX(self.role,"")	--获取角色在相机中的位置
	local myPos = BehaviorFunctions.GetTransformScreenX(self.me,"")	--获取自己在相机中的位置
	local distance = math.abs(myPos - rolePos)	--获取投影位置差

	--限制距离参数
	if distance > self.cameraDistance.Max then
		distance = self.cameraDistance.Max
	elseif distance < self.cameraDistance.Min then
		distance = self.cameraDistance.Min
	end

	--权重计算公式
	self.myCameraWeight = (1/5) ^ (4*distance)

	--当角色距离距离佩从距离>12米，判定为远距离
	--if distance > self.cameraDistance.Long then
	--self.myCameraWeight = distance * self.cameraRatio.Long
	--elseif distance > self.cameraDistance.Mid then
	--self.myCameraWeight = distance * self.cameraRatio.Mid
	--elseif distance > self.cameraDistance.Short then
	--self.myCameraWeight = distance * self.cameraRatio.Short
	--end
end

function Behavior62001:BreakSkill(instanceId,skillId,skillSign,skillType)
	if skillId == 62001615 and instanceId == self.me then
		BehaviorFunctions.RemoveEntitySign(1,600021012)	--移除叙慕连携
		BehaviorFunctions.RemoveEntitySign(1,60001002)	--移除刻刻连携
		BehaviorFunctions.RemoveEntitySign(1,62001614005)	--移除离歌正在技能中
		--移除浮空目标列表
		if next(self.flyTarget) then
			for i,target in ipairs(self.flyTarget) do
				BehaviorFunctions.RemoveBuff(target,600000051)	--移除浮空列表目标的浮空buff
			end
		end
	end
end

--准备变身入口
function Behavior62001:readyHenshin(delayTime)
	if not BehaviorFunctions.CheckPlayerInFight() then
		BehaviorFunctions.AddEntitySign(self.role,600000021,-1,false)
		BehaviorFunctions.SetCameraStateForce(FightEnum.CameraState.Operating,true)
		BehaviorFunctions.DoSetPosition(self.me,self.worldSkillPos.x,self.worldSkillPos.y,self.worldSkillPos.z)--设置坐标
		--BehaviorFunctions.SetMainTarget(self.me)--设置相机目标
		BehaviorFunctions.RemoveAllFollowTarget()
		BehaviorFunctions.AddFollowTarget(self.me,"CameraTarget")
		BehaviorFunctions.DoMagic(self.me,self.me,600000002)	--暗杀镜头偏移
		BehaviorFunctions.SetJoyStickVisibleByAlpha(2, false, false)	--设置摇杆透明
		self.assingTarget = self.assTarget	--确定暗杀目标
		BehaviorFunctions.AddDelayCallByTime(delayTime,self,self.Henshin)	--变身
		BehaviorFunctions.StopFightUIEffect("22105", "main")--清除预暗杀UI
		BehaviorFunctions.AddEntitySign(self.role,62001001,-1,false)	--标记为正在暗杀
	end
end

--重置相机位置
function Behavior62001:ReturnCamera(returnTime,finishTime)
	BehaviorFunctions.SetCameraStateForce(1,false)	--设置回操作
	BehaviorFunctions.CameraPosReduction(returnTime,false,finishTime)	--重置相机位置
	BehaviorFunctions.RemoveAllLookAtTarget()
	BehaviorFunctions.AddLookAtTarget(self.ctrlRole,"CameraTarget")
end

--被换下时清除暗杀标记
function Behavior62001:RemoveEntity()
	BehaviorFunctions.StopFightUIEffect("22105", "main")
end

--将暗杀子弹设置成只对目标有效
function Behavior62001:KeyFrameAddEntity(instanceId,entityId)
	if entityId == 62001004001 or entityId == 62001009001 then
		if BehaviorFunctions.HasEntitySign(self.role,62001001) then
			if self.assingTarget and self.assingTarget ~= 0 and BehaviorFunctions.CheckEntity(self.assingTarget) then
				BehaviorFunctions.SetAttackCheckList(instanceId, {self.assingTarget})
			else
				BehaviorFunctions.RemoveEntity(instanceId)	--移除暗杀子弹
			end
		end
	end
end

----帧事件实体
--function Behavior62001:KeyFrameAddEntity(instanceId,entityId)

----击飞子弹
--if entityId == 62001008001 then
--self.curHitFlyBullet = instanceId
--end
--end

----判断处决子弹碰撞目标
--function Behavior62001:FirstCollide(attackInstanceId,hitInstanceId,instanceId,attackType)
----如果当前正在执行处决
--if instanceId == self.curHitFlyBullet then
----把目标的位置设置到空中
--BehaviorFunctions.DoPreciseMove(hitInstanceId, self.role, 0, 0, 1.5, 7)
--end
--end
