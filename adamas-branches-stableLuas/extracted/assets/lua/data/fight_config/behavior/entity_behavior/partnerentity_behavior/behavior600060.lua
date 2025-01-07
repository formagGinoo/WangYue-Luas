Behavior600060 = BaseClass("Behavior600060",EntityBehaviorBase)
--资源预加载
function Behavior600060.GetGenerates()
	local generates = {}
	return generates
end

function Behavior600060.GetMagics()
	local generates = {60006006}
	return generates
end



function Behavior600060:Init()
	self.PartnerAllParm = BehaviorFunctions.CreateBehavior("PartnerAllParm",self)
	self.PartnerCastSkill = BehaviorFunctions.CreateBehavior("PartnerCastSkill",self)
	
	self.me = self.instanceId	--记录自身
	self.PartnerAllParm.partnerType = 3         --初始佩从类型，0连携，1变身，2召唤，3跟随，4附身

	--出生和驻场
	self.PartnerBornAndExist = BehaviorFunctions.CreateBehavior("PartnerBornAndExist",self)
	self.PartnerBornAndExist.existOnStart = true           --是否初始在场？
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
		--尾巴前砸
		{
			id = 600060010,
			needTarget = 1,	       --开放参数：1需要锁定目标，2不需要锁定目标
			minDistance = 0,       --开放参数：技能释放最小距离（有等号），不需要目标就跳过此判断
			maxDistance = 4,       --开放参数：技能释放最大距离（无等号），不需要目标就跳过此判断
			angle = 90,           --开放参数：释放角度，不需要目标就跳过此判断
			cd = 8,           	   --开放参数：技能cd，单位：秒
			frame = 0              --用来计算cd，必须要填
		},

		--后跳
		{
		id = 600060011,
		needTarget = 1,	       --开放参数：1需要锁定目标，2不需要锁定目标
		minDistance = 0,       --开放参数：技能释放最小距离（有等号），不需要目标就跳过此判断
		maxDistance = 2,       --开放参数：技能释放最大距离（无等号），不需要目标就跳过此判断
		angle = 90,           --开放参数：释放角度，不需要目标就跳过此判断
		cd = 8,           	   --开放参数：技能cd，单位：秒
		frame = 0              --用来计算cd，必须要填
		}
	}

	--连携技能，玩家要在触发连携的技能里配技能窗口600000030
	--self.PartnerResidentCastSkill.ConnectSkill = {
		--id = 600120020,				--技能id
		--cd = 5,                      --技能cd，单位：秒
		--frame = 0,              --用来计算cd，必须要填
		--summonDis = 3,               --以主人面向为正方向，偏移距离
		--summonAngle = 80             --以主人面向为正方向，偏移角度
	--}

	--驻场跟随
	self.PartnerFollow = BehaviorFunctions.CreateBehavior("PartnerFollow",self)
	self.PartnerFollow.followPositionOffset = Vec3.New(0,0,0)    --跟随目标点坐标，基于主人面向建立坐标系偏移
	self.PartnerFollow.followRadius = 3                           --位置不合法的时候扩散查询的位置
	self.followType = 1                                           --佩从瞬移类型，1地面，2浮空（地面会检测瞬移点是否在地面）
	self.teleportPositionOffset = Vec3.New(2,0,-1)                 --瞬移点坐标，基于主人面向建立坐标系偏移
	self.PartnerFollow.teleportDistance = 21                     --瞬移距离（超过会瞬移）
	self.PartnerFollow.teleportYDistance = 8                      --高度差传送距离（超过会瞬移）
	self.PartnerFollow.followRadiusByRun = 10                     --跑步距离（超过会跑）
	self.PartnerFollow.reachDistance = 2                        --停下距离（超过会走，≤会停下切待机）

	self.PartnerFollow.rotateOnMove = true                       --是否在移动状态下才能转向？

	--驻场周旋
	self.PartnerWander = BehaviorFunctions.CreateBehavior("PartnerWander",self)
	self.PartnerWander.runDistance = 8                   --跑步距离（超过会跑）
	self.PartnerWander.walkBackDistance = 2              --后退距离（超过会前走或左右走，≤会后走）
	self.PartnerWander.walkTime = 1.666                  --走路时间
	self.PartnerWander.walkLRTime = 1.666                --左右走时间
	self.PartnerWander.walkBackTime = 1.666              --后走时间
	self.PartnerWander.angle = 60                    --转身角度
	
	self.PartnerAllParm.diyuePart = "Bip001 Neck"
	
	
	self.PartnerAllParm.hasFightSkill = false	--是否会因为战斗影响技能切换
	self.PartnerAllParm.skillList = {
		--主动技能列表
		{--长按Q释放主动技能
			id = 600060006,
			showType = 3,	--1变身型，2单击出生，3长按主动
			frame = 60,	--技能持续时间，时间结束自动进入退场流程
			skillType = 3, --1战前释放，2战中释放，3不需要战前战中切换
			distance =	2,	--召唤技能释放距离
			angle = 90,  --召唤技能释放角度
			targetType = 2,	--目标点：1以角色为中心，2以敌人为中心
			createPos = 1, --创建点：1以角色为中心，2以敌人为中心
			stableShow = 0,	--是否需要在指定位置稳定创建
			Camera = 2,		--是否使用3D动态镜头，0为不需要，1为使用水平投影，2为3D动态，一般使用水平投影
			rolePerform = 3,	--0不使用角色出场动作，,1使用前召唤，2使用后召唤
		},
		
		{--单点Q出生
			id = 600060012,
			showType = 2,	--1变身型，2单击出生，3长按主动
			frame = 98,	--技能持续时间，时间结束自动进入退场流程
			skillType = 3, --1战前释放，2战中释放，3不需要战前战中切换
			distance =	3,	--召唤技能释放距离
			angle = 60,  --召唤技能释放角度
			targetType = 2,	--目标点：1以角色为中心，2以敌人为中心
			createPos = 1, --创建点：1以角色为中心，2以敌人为中心。连线方向作为0度
			stableShow = 0,	--是否需要在指定位置稳定创建
			Camera = 0,		--是否使用3D动态镜头，0为不需要，1为使用水平投影，2为3D动态，一般使用水平投影
			rolePerform = 4,	--0不使用角色出场动作，,1使用前召唤，2使用后召唤
		}
	}
	
	self.PartnerAllParm.createDistance = 2
	self.PartnerAllParm.createAngle = 270
end



function Behavior600060:Update()
	

	self.PartnerAllParm:Update()
	self.PartnerCastSkill:Update()
	self.PartnerBornAndExist:Update()
	self.PartnerResidentLockTarget:Update()
	self.PartnerResidentCastSkill:Update()
	self.PartnerFollow:Update()
	self.PartnerWander:Update()
	
	if BehaviorFunctions.HasEntitySign(self.me,60006001) then
		if not self.initBuff then
			BehaviorFunctions.DoMagic(self.me,self.PartnerAllParm.role,600060014)	--异常抵抗
			self.initBuff = true
		end
	end
end	



function Behavior600060:FirstCollide(attackInstanceId,hitInstanceId,instanceId,attackType)
	--添加魅惑buff
	if BehaviorFunctions.GetEntityTemplateId(instanceId) == 600060005001 and attackInstanceId == self.me then
		--if BehaviorFunctions.CheckPlayerInFight() then
			--BehaviorFunctions.DoMagic(self.me,hitInstanceId,600060002,1)
		--else
		--	BehaviorFunctions.DoMagic(self.me,hitInstanceId,600060001,1)
		--end
		if BehaviorFunctions.GetBuffCount(self.PartnerAllParm.role,40022001) > 0 then
			BehaviorFunctions.DoMagic(attackInstanceId,hitInstanceId,40022002)
		else
			--如果没有perk，正常添加魅惑buff
			BehaviorFunctions.DoMagic(attackInstanceId,hitInstanceId,600060001)
		end
	end
	
	
end


function Behavior600060:CastSkill(instanceId,skillId,skillType)
	if instanceId == self.me and skillId == 600060006 then
			if not BehaviorFunctions.HasEntitySign(self.PartnerAllParm.role,100000007) then
				--BehaviorFunctions.AddEntitySign(self.PartnerAllParm.role,600000011,-1,false)	--标记为不使用动态相机权重
				if self.PartnerAllParm.HasTarget then
					local distance = BehaviorFunctions.GetDistanceFromTarget(self.PartnerAllParm.role,self.PartnerAllParm.battleTarget,false)
					local height = BehaviorFunctions.CheckEntityHeight(self.PartnerAllParm.battleTarget)
					if distance > 2 and height < 1 then
						BehaviorFunctions.SetVCCameraBlend("ForceLockingCamera","FightingCamera",0.2)
						BehaviorFunctions.SetVCCameraBlend("ForceLockingCamera","WeakLockingCamera",0.2)
						BehaviorFunctions.SetCameraStateForce(FightEnum.CameraState.ForceLocking,true)
						BehaviorFunctions.SetCameraParams(FightEnum.CameraState.ForceLocking,600060006,false)
						--BehaviorFunctions.SetCameraStateForce(FightEnum.CameraState.Operating,true)
						--BehaviorFunctions.SetVCCameraBlend("FightingCamera","OperatingCamera",0.2)
						--BehaviorFunctions.RemoveAllLookAtTarget()
						--BehaviorFunctions.RemoveAllFollowTarget()
						--BehaviorFunctions.AddFollowTarget(self.PartnerAllParm.role,"CameraTarget")
						--BehaviorFunctions.AddLookAtTarget(self.PartnerAllParm.role,"CameraTarget")
					--	BehaviorFunctions.CameraPosReduction(0.2,false,0.5)
						
						--BehaviorFunctions.DoMagic(self.me,self.PartnerAllParm.role,600060006)	--相机偏移
						BehaviorFunctions.RemoveAllLookAtTarget()
						BehaviorFunctions.RemoveAllFollowTarget()
						--BehaviorFunctions.AddFollowTarget(self.me,"CameraTarget")
						BehaviorFunctions.AddFollowTarget(self.PartnerAllParm.role,"CameraTarget")
						BehaviorFunctions.AddLookAtTarget(self.battleTarget,"HitCase")
						self.curTarget = self.battleTarget
					end
				else
					BehaviorFunctions.CameraPosReduction(0.2,false,0.5)	--重置相机位置
					--BehaviorFunctions.SetCameraStateForce(FightEnum.CameraState.Operating,false)
					--BehaviorFunctions.AddLookAtTarget(self.PartnerAllParm.CtrlRole,"CameraTarget")
				end
			end
	end
end



function Behavior600060:AddSkillSign(instanceId,sign)
	if instanceId == self.me then
		if sign == 600060006 then
			if not BehaviorFunctions.HasEntitySign(self.PartnerAllParm.role,100000007) then
				BehaviorFunctions.SetVCCameraBlend("ForceLockingCamera","OperatingCamera",1)
				BehaviorFunctions.SetVCCameraBlend("ForceLockingCamera","FightCamera",1)
				BehaviorFunctions.RemoveAllFollowTarget()
				BehaviorFunctions.AddFollowTarget(self.PartnerAllParm.CtrlRole,"CameraTarget")
				BehaviorFunctions.RemoveAllLookAtTarget()
				if self.PartnerAllParm.HasTarget then
					BehaviorFunctions.SetCameraStateForce(FightEnum.CameraState.Fight,false)
					BehaviorFunctions.AddLookAtTarget(self.PartnerAllParm.battleTarget,"HitCase")
				else
					BehaviorFunctions.SetCameraStateForce(FightEnum.CameraState.Operating,false)
					BehaviorFunctions.AddLookAtTarget(self.PartnerAllParm.CtrlRole,"CameraTarget")
				end
				BehaviorFunctions.SetCameraStateForce(FightEnum.CameraState.Operating,false)
			end
		end
		
		if sign == 600000020 then
			if not BehaviorFunctions.HasEntitySign(1,10000007) and self.PartnerAllParm.role == self.PartnerAllParm.CtrlRole then
				BehaviorFunctions.SetCameraStateForce(FightEnum.CameraState.Operating,false)	--接触强制相机设置
				self:ReturnCamera(0.2,0.5)
			end
		end
	end
end

function Behavior600060:KeyFrameAddEntity(instanceId,entityId)
	--if instanceId == self.me then
		if entityId == 600060005001 then
			BehaviorFunctions.ChangeToTrackMoveComponent(instanceId,100000031,100000032,true,0.5,0)
		end
	--end
end




