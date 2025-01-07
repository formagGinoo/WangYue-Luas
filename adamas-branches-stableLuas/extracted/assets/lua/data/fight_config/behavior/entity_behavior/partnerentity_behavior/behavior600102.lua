Behavior600102 = BaseClass("Behavior600102",EntityBehaviorBase)
--资源预加载
function Behavior600102.GetGenerates()
	local generates = {}
	return generates
end

function Behavior600102.GetMagics()
	local generates = {60010206}
	return generates
end



function Behavior600102:Init()
	self.PartnerAllParm = BehaviorFunctions.CreateBehavior("PartnerAllParm",self)
	self.PartnerCastSkill = BehaviorFunctions.CreateBehavior("PartnerCastSkill",self)
	
	self.me = self.instanceId	--记录自身
	self.PartnerAllParm.partnerType = 0         --初始佩从类型，0连携，1变身，2召唤，3跟随，4附身

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
		----3连飞弹
		--{
			--id = 60010214,
			--needTarget = 1,	       --开放参数：1需要锁定目标，2不需要锁定目标
			--minDistance = 5,       --开放参数：技能释放最小距离（有等号），不需要目标就跳过此判断
			--maxDistance = 15,       --开放参数：技能释放最大距离（无等号），不需要目标就跳过此判断
			--angle = 90,           --开放参数：释放角度，不需要目标就跳过此判断
			--cd = 12,           	   --开放参数：技能cd，单位：秒
			--frame = 0              --用来计算cd，必须要填
		--},
		
		----敲击后撤
		--{
			--id = 60010210,
			--needTarget = 1,	       --开放参数：1需要锁定目标，2不需要锁定目标
			--minDistance = 0,       --开放参数：技能释放最小距离（有等号），不需要目标就跳过此判断
			--maxDistance = 2.5,       --开放参数：技能释放最大距离（无等号），不需要目标就跳过此判断
			--angle = 90,           --开放参数：释放角度，不需要目标就跳过此判断
			--cd = 10,           	   --开放参数：技能cd，单位：秒
			--frame = 0              --用来计算cd，必须要填
		--},

		----闪现
		--{
			--id = 60010211,
			--needTarget = 1,	       --开放参数：1需要锁定目标，2不需要锁定目标
			--minDistance = 1.5,       --开放参数：技能释放最小距离（有等号），不需要目标就跳过此判断
			--maxDistance = 8,       --开放参数：技能释放最大距离（无等号），不需要目标就跳过此判断
			--angle = 90,           --开放参数：释放角度，不需要目标就跳过此判断
			--cd = 8,           	   --开放参数：技能cd，单位：秒
			--frame = 0              --用来计算cd，必须要填
		--}
	--}

	----连携技能，玩家要在触发连携的技能里配技能窗口600000030
	----self.PartnerResidentCastSkill.ConnectSkill = {
		----id = 600120020,				--技能id
		----cd = 5,                      --技能cd，单位：秒
		----frame = 0,              --用来计算cd，必须要填
		----summonDis = 3,               --以主人面向为正方向，偏移距离
		----summonAngle = 80             --以主人面向为正方向，偏移角度
	----}

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
	--self.PartnerWander.runDistance = 8                   --跑步距离（超过会跑）
	--self.PartnerWander.walkBackDistance = 2              --后退距离（超过会前走或左右走，≤会后走）
	--self.PartnerWander.walkTime = 2.4                  --走路时间
	--self.PartnerWander.walkLRTime = 2.666                --左右走时间
	--self.PartnerWander.walkBackTime = 2.8              --后走时间
	--self.PartnerWander.angle = 60                    --转身角度
	
	self.PartnerAllParm.diyuePart = "Bip001 R Hand"
	
	
	self.PartnerAllParm.hasFightSkill = false	--是否会因为战斗影响技能切换
	self.PartnerAllParm.skillList = {
		--主动技能列表
		{--单点Q释放主动技能
			id = 60010204,
			showType = 2,	--1变身型，2单击出生，3长按主动
			frame = 110,	--技能持续时间，时间结束自动进入退场流程
			skillType = 3, --1战前释放，2战中释放，3不需要战前战中切换
			distance =	2,	--召唤技能释放距离
			angle = 90,  --召唤技能释放角度
			targetType = 2,	--目标点：1以角色为中心，2以敌人为中心
			createPos = 1, --创建点：1以角色为中心，2以敌人为中心
			stableShow = 0,	--是否需要在指定位置稳定创建
			Camera = 1,		--是否使用3D动态镜头，0为不需要，1为使用水平投影，2为3D动态，一般使用水平投影
			rolePerform = 4,	--0不使用角色出场动作，,1使用前召唤，2使用后召唤
			rushRange = 4,
		}
		
		--{--单点Q出生
			--id = 60010213,
			--showType = 2,	--1变身型，2单击出生，3长按主动
			--frame = 98,	--技能持续时间，时间结束自动进入退场流程
			--skillType = 3, --1战前释放，2战中释放，3不需要战前战中切换
			--distance =	3,	--召唤技能释放距离
			--angle = 60,  --召唤技能释放角度
			--targetType = 2,	--目标点：1以角色为中心，2以敌人为中心
			--createPos = 1, --创建点：1以角色为中心，2以敌人为中心。连线方向作为0度
			--stableShow = 0,	--是否需要在指定位置稳定创建
			--Camera = 0,		--是否使用3D动态镜头，0为不需要，1为使用水平投影，2为3D动态，一般使用水平投影
			--rolePerform = 3,	--0不使用角色出场动作，,1使用前召唤，2使用后召唤
		--}
	}
	
	self.PartnerAllParm.createDistance = 2
	self.PartnerAllParm.createAngle = 270
end



function Behavior600102:Update()
	self.myPos = BehaviorFunctions.GetPositionP(self.me)

	self.PartnerAllParm:Update()
	self.PartnerCastSkill:Update()
	--self.PartnerBornAndExist:Update()
	--self.PartnerResidentLockTarget:Update()
	--self.PartnerResidentCastSkill:Update()
	--self.PartnerFollow:Update()
	--self.PartnerWander:Update()
	
	--被动1
	if BehaviorFunctions.HasEntitySign(self.me,60010201) then
		if not self.initBuff then
			--如果是青门
			if BehaviorFunctions.GetEntityTemplateId(self.PartnerAllParm.role) == 1006 or BehaviorFunctions.GetEntityTemplateId(self.PartnerAllParm.role) == 1008 then
				BehaviorFunctions.AddBuff(self.me,self.PartnerAllParm.role,60010205)
				self.initBuff = true
			end
		end
	end
end	

function Behavior600102:SkillFrameUpdate(instanceId,skillId,skillFrame)
	if instanceId == self.me then
		if skillId == 60010204 then
			if skillFrame == 58 then
				BehaviorFunctions.CreateEntity(6001020311, self.me, self.myPos.x,self.myPos.y,self.myPos.z+0.5)
			end
		end
	end
end

--闪现消失技能放完之后
function Behavior600102:FinishSkill(instanceId,skillId,skillType)
	if skillId  == 60010211 then
		self:GetFlashPos(instanceId)
	end
end

--判断要闪到哪，然后放闪现出现
function Behavior600102:GetFlashPos(instanceId)
	local Target = self.PartnerAllParm.ResidentTarget    --锁定目标
	local AppearPos = nil								--闪现出现坐标
	local FlashDistance = 5 	                	--闪现距离
	
	if not Target then
		AppearPos = BehaviorFunctions.GetPositionOffsetBySelf(instanceId,-FlashDistance,0)
	else
		local angle = BehaviorFunctions.GetEntityAngle(instanceId,Target)
		local distance = BehaviorFunctions.GetDistanceFromTarget(instanceId,Target,false)
		if distance >= 1.5 and distance <= 2.5 then
			AppearPos = BehaviorFunctions.GetPositionOffsetBySelf(instanceId,-FlashDistance,0)
		elseif distance > 2.5 and distance <= 9 then
			local cosValue = (2 * distance^2 - FlashDistance^2) / (2 * distance^2)
			-- 将cos(angle)的值转化为angle的值，并将其转化为角度制
			local rad = math.acos(cosValue)
			angle = math.deg(rad)
			AppearPos = BehaviorFunctions.GetPositionOffsetBySelf(instanceId,FlashDistance,angle)
		end
	end
	
	if AppearPos then
		BehaviorFunctions.DoSetPositionP(instanceId, AppearPos)
		if BehaviorFunctions.CanCastSkill(instanceId) then
			BehaviorFunctions.CastSkillByTarget(instanceId,60010212,Target)
		end
		if BehaviorFunctions.GetEntityState(instanceId) == FightEnum.EntityState.Move then
			BehaviorFunctions.StopMove(instanceId)
		end
		BehaviorFunctions.DoSetEntityState(instanceId,FightEnum.EntityState.Idle)
	end
end