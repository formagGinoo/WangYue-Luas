Behavior600120 = BaseClass("Behavior600120",EntityBehaviorBase)
--资源预加载
function Behavior600120.GetGenerates()
	local generates = {}
	return generates
end

function Behavior600120.GetMagics()
	local generates = {}
	return generates
end



function Behavior600120:Init()
	
	self.PartnerAllParm = BehaviorFunctions.CreateBehavior("PartnerAllParm",self)
	self.PartnerCastSkill = BehaviorFunctions.CreateBehavior("PartnerCastSkill",self)
	
	self.me = self.instanceId	--记录自身
	self.PartnerAllParm.partnerType = 2         --初始佩从类型，0连携，1变身，2召唤，3跟随，4附身

	--出生和驻场
	self.PartnerBornAndExist = BehaviorFunctions.CreateBehavior("PartnerBornAndExist",self)
    self.PartnerBornAndExist.existOnStart = false           --是否初始在场？
    self.PartnerBornAndExist.residentTime = -1              --驻场时间，单位秒。配负数表示永久
	self.PartnerBornAndExist.bornOffset = Vec3.New(2,0,-2)  --出生坐标，基于主人面向建立坐标系偏移
	self.PartnerBornAndExist.bornRadius = 3                 --点位不合法的时候搜索合法点位的半径
	
	--驻场索敌
	self.PartnerResidentLockTarget = BehaviorFunctions.CreateBehavior("PartnerResidentLockTarget",self)
	self.PartnerResidentLockTarget.ResidentLockTargetMode = 2   --驻场锁定模式：1-优先锁主人当前的锁定目标  2-锁离自己最近的目标,但主人被打就会锁攻击怪
	
	--驻场技能
	self.PartnerResidentCastSkill = BehaviorFunctions.CreateBehavior("PartnerResidentCastSkill",self)
	--驻场技能列表
	self.PartnerResidentCastSkill.ResidentSkillList = {
		{
			id = 600120010,
			needTarget = 1,	       --开放参数：1需要锁定目标，2不需要锁定目标
			minDistance = 0,       --开放参数：技能释放最小距离（有等号），不需要目标就跳过此判断
			maxDistance = 2.5,       --开放参数：技能释放最大距离（无等号），不需要目标就跳过此判断
			angle = 90,           --开放参数：释放角度，不需要目标就跳过此判断
			cd = 8,           	   --开放参数：技能cd，单位：秒
			frame = 0              --用来计算cd，必须要填
		}
	}
 
	--连携技能，玩家要在触发连携的技能里配技能窗口600000030
	self.PartnerResidentCastSkill.ConnectSkill = {
		id = 600120020,				--技能id
		cd = 5,                      --技能cd，单位：秒
		frame = 0,              --用来计算cd，必须要填
		summonDis = 3,               --以主人面向为正方向，偏移距离
		summonAngle = 80             --以主人面向为正方向，偏移角度
	}
	
	--驻场跟随
	self.PartnerFollow = BehaviorFunctions.CreateBehavior("PartnerFollow",self)
	self.PartnerFollow.followPositionOffset = Vec3.New(0,0,0)    --跟随目标点坐标，基于主人面向建立坐标系偏移
	self.PartnerFollow.followRadius = 3                           --位置不合法的时候扩散查询的位置
	self.followType = 1                                           --佩从瞬移类型，1地面，2浮空（地面会检测瞬移点是否在地面）
	self.teleportPositionOffset = Vec3.New(2,0,-1)                 --瞬移点坐标，基于主人面向建立坐标系偏移
	self.PartnerFollow.teleportDistance = 21                     --瞬移距离（超过会瞬移）
	self.PartnerFollow.teleportYDistance = 8                      --高度差传送距离（超过会瞬移）
    self.PartnerFollow.followRadiusByRun = 10                     --跑步距离（超过会跑）
	self.PartnerFollow.reachDistance = 3                     --停下距离（超过会走，≤会停下切待机）
	
	self.PartnerFollow.rotateOnMove = true                       --是否在移动状态下才能转向？

	--驻场周旋
	self.PartnerWander = BehaviorFunctions.CreateBehavior("PartnerWander",self)
	self.PartnerWander.runDistance = 8                   --跑步距离（超过会跑）
    self.PartnerWander.walkBackDistance = 2              --后退距离（超过会前走或左右走，≤会后走）
    self.PartnerWander.walkTime = 2.666                  --走路时间
	self.PartnerWander.walkLRTime = 1.667                --左右走时间
	self.PartnerWander.walkBackTime = 2.666              --后走时间
    self.PartnerWander.angle = 60                    --转身角度
	
	self.PartnerAllParm.diyuePart = "Bip001 L Hand"  --锁链特效连接怪的骨骼
	
	self.PartnerAllParm.autoRemove = false
	self.PartnerAllParm.hasFightSkill = false	--是否会因为战斗影响技能切换
	self.PartnerAllParm.skillList = {
		--主动技能列表
		{--长按Q释放主动技能
			id = 600120001,
			showType = 3,	--1变身型，2单击出生，3长按主动
			frame = 98,	--技能持续时间，时间结束自动进入退场流程
			skillType = 3, --1战前释放，2战中释放，3不需要战前战中切换
			distance =	4.5,	--召唤技能释放距离
			angle = 110,  --召唤技能释放角度
			targetType = 2,	--目标点：1以角色为中心，2以敌人为中心
			createPos = 2, --创建点：1以角色为中心，2以敌人为中心。连线方向作为0度
			stableShow = 0,	--是否需要在指定位置稳定创建
			Camera = 1,		--是否使用3D动态镜头，0为不需要，1为使用水平投影，2为3D动态，一般使用水平投影
			rolePerform = 4,	--0不使用角色出场动作，,1使用前召唤，2使用后召唤
		},
		
		{--单点Q出生
			id = 600120030,
			showType = 2,	--1变身型，2单击出生，3长按主动
			frame = 98,	--技能持续时间，时间结束自动进入退场流程
			skillType = 3, --1战前释放，2战中释放，3不需要战前战中切换
			distance =	3,	--召唤技能释放距离
			angle = 60,  --召唤技能释放角度
			targetType = 2,	--目标点：1以角色为中心，2以敌人为中心
			createPos = 1, --创建点：1以角色为中心，2以敌人为中心。连线方向作为0度
			stableShow = 0,	--是否需要在指定位置稳定创建
			Camera = 1,		--是否使用3D动态镜头，0为不需要，1为使用水平投影，2为3D动态，一般使用水平投影
			rolePerform = 3,	--0不使用角色出场动作，,1使用前召唤，2使用后召唤
		}
	}
	
	self.PartnerAllParm.createDistance = 2
	self.PartnerAllParm.createAngle = 270
	
end

function Behavior600120:Update()
	

	self.PartnerAllParm:Update()
	self.PartnerCastSkill:Update()
	self.PartnerBornAndExist:Update()
	self.PartnerResidentLockTarget:Update()
	self.PartnerResidentCastSkill:Update()
	self.PartnerFollow:Update()
	self.PartnerWander:Update()

	--佩从专属被动效果：棍类武器角色伤害+a%
	--当前版本没有棍类武器，所以先写死义向
	if BehaviorFunctions.HasEntitySign(self.me,60012001) then
		if not self.initBuff then
			if BehaviorFunctions.GetEntityTemplateId(self.PartnerAllParm.role) == 1005 then
				BehaviorFunctions.AddBuff(self.me,self.PartnerAllParm.role,600120002)
				self.initBuff = true
			end	
		end
	end
	
end	

function Behavior600120:CastSkill(instanceId,skillId,SkillConfigSign,skillType)
	if instanceId == self.me and skillId == 600120030 then
		BehaviorFunctions.AddPostProcessByTemplateId(self.PartnerAllParm.role, 600000010, FightEnum.PostProcessType.FullScreen)
	end
end