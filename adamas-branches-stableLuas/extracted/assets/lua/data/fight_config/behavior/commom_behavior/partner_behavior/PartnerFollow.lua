PartnerFollow = BaseClass("PartnerFollow",EntityBehaviorBase)

function PartnerFollow:Init()
	self.PartnerAllParm = self.MainBehavior.PartnerAllParm
	self.followPositionOffset = Vec3.New(2,0,0) --跟随偏移
	self.teleportPositionOffset = Vec3.New(2,0,0) --传送偏移
	self.followType = 1--跟随类型，1地面，2浮空
	self.followRadius = 3 --位置不合法的时候扩散查询的位置
	--self.followRadiusByWalk = 5 --走路跟随半径
	self.followRadiusByRun = 10 --跑步跟随的半径
	self.reachDistance = 1.5 --到达距离
	self.teleportDistance = 15 --瞬移距离
	self.teleportYDistance = 3 --高度差传送距离
	self.rotateOnMove = false --移动状态下才能转向
	self.me = self.instanceId
	self.followState = 1 --1小于walk距离不做任何操作，2walk中，到达才会切换成1,3run
	self.moveTotalFrame = 60 --移动总帧数
	self.moveTotalDistance = 1--移动总长度，moveTotalTime时间内移动距离总和小于moveTotalDistance，视为被卡主，走传送逻辑
	self.changeFrame = 0
	self.tpFrame = 0

	self.stuckCheckCount = 0
	self.moveRing = {}--记录移动位移的环形区
	self.moveRingIndex = 0--环形区当前下标
	self.lastPosition = nil
	self.followPosition = Vec3.New(0,0,0)
	self.idlePositionCache = Vec3.New(0,0,0)
	self.rolePosCache = Vec3.New(0,0,0)
end

function PartnerFollow:Update()
	--定义主人：若创建者在前台，那他就是主人；若创建者不在前台，则当前操控角色是主人
	if BehaviorFunctions.CheckEntityForeground(BehaviorFunctions.GetEntityOwner(self.me)) then
		self.role = BehaviorFunctions.GetEntityOwner(self.me)
	else
		self.role = BehaviorFunctions.GetCtrlEntity()
	end

	if not BehaviorFunctions.CheckPartnerShow(BehaviorFunctions.GetEntityOwner(self.me)) then
		return
	end
	local p1 = BehaviorFunctions.GetPositionP(self.role)
	local p2 = BehaviorFunctions.GetPositionP(self.me)
	local yDiff = BehaviorFunctions.CheckPlayerInFight() and 0 or p1.y - p2.y--战斗中不检测高度
	if not self:CanFollow() then
		local dis,pos = self:GetDistance()
		
		if BehaviorFunctions.CanCtrl(self.me) and dis > self.teleportDistance and not self.IsTeleport or math.abs(yDiff) > self.teleportYDistance then
			local findPos,tpPos = self:GetTeleportPos()
			if findPos then
				self:TeleportStart(tpPos)    --佩从瞬移
				--BehaviorFunctions.DoSetPosition(self.me,pos.x,pos.y,pos.z)
				--BehaviorFunctions.DoMagic(self.me,self.me,600000005,1)	--播放仲魔出场特效
				self.stuckCheckCount = 0 
			end
		end
		return
	end
	local dis,pos = self:GetDistance()

	if --[[BehaviorFunctions.CheckPlayerInFight() and --]] (dis > self.teleportDistance and not self.IsTeleport) or math.abs(yDiff) > self.teleportYDistance then
		local findPos,tpPos = self:GetTeleportPos()
		if findPos then
			self:TeleportStart(tpPos)    --佩从瞬移
			--BehaviorFunctions.DoSetPosition(self.me,pos.x,pos.y,pos.z)
			--BehaviorFunctions.DoMagic(self.me,self.me,600000005,1)	--播放仲魔出场特效
			self.stuckCheckCount = 0 
		end
		return
	end
	
	
	if self.IsTeleport then--正在传送中
		return
	end
	if BehaviorFunctions.CheckPlayerInFight() and not BehaviorFunctions.CheckEntityState(self.me,FightEnum.EntityState.FightIdle) then
		--BehaviorFunctions.SetEntityValue(self.me,"follow",false)
		local lookatPos = BehaviorFunctions.GetEntityPositionOffset(self.role,0,0,100)
		BehaviorFunctions.DoLookAtPositionByLerp(self.me,lookatPos.x,nil,lookatPos.z,true,0,180,-2)
		--return
	end

	--是否被卡主，计算逻辑是，60帧内总位移小于1米
	if BehaviorFunctions.CheckEntityState(self.me,FightEnum.EntityState.Move) then 
		self.stuckCheckCount = self.stuckCheckCount + 1
		self:RecordMoveDistance()
	else
		self:ClearRecordMoveDistance()
	end
	if BehaviorFunctions.CheckEntityState(self.me,FightEnum.EntityState.Move) and 
		self.stuckCheckCount > self.moveTotalFrame and self:CheckStuck() and self.IsTeleport == false then
        _,pos = CombinationFunctions.GetCanBornPosition(pos,0)
		self:ClearRecordMoveDistance()
		local findPos,tpPos = self:GetTeleportPos()
		if findPos then
			self:TeleportStart(tpPos)    --佩从瞬移
			--BehaviorFunctions.DoSetPosition(self.me,pos.x,pos.y,pos.z)
			--BehaviorFunctions.DoMagic(self.me,self.me,600000005,1)	--播放仲魔出场特效
			self.stuckCheckCount = 0    
		end
		--BehaviorFunctions.DoSetPosition(self.me,pos.x,pos.y,pos.z)
		--BehaviorFunctions.DoMagic(self.me,self.me,600000005,1)	--播放仲魔出场特效

	end
	if dis > self.followRadiusByRun then
		self:ChangeToRun()
		BehaviorFunctions.DoLookAtPositionByLerp(self.me,pos.x,nil,pos.z,true,0,180,-2)
	elseif dis > self.reachDistance then
		self:ChangeToWalk()
		BehaviorFunctions.DoLookAtPositionByLerp(self.me,pos.x,nil,pos.z,true,0,360,-2)
	elseif dis <= self.reachDistance then
		self:ChangeToIdle(pos)
		self:ClearRecordMoveDistance()
		if self.followType == 1 then
			BehaviorFunctions.CancelLookAt(self.me)
		end
	end
	if BehaviorFunctions.CheckEntityState(self.me,FightEnum.EntityState.Idle) and not self.rotateOnMove then
		local lookatPos = BehaviorFunctions.GetEntityPositionOffset(self.role,0,0,100)
		BehaviorFunctions.DoLookAtPositionByLerp(self.me,lookatPos.x,nil,lookatPos.z,true,0,180,-2)
	end
	
	
end
--记录位移数据
function PartnerFollow:GetMoveDistance()
	if not self.lastPosition then
		self.lastPosition = Vec3.New(0,0,0)
		local lastPosition = BehaviorFunctions.GetPositionP(self.me)
		self.lastPosition.x = lastPosition.x
		self.lastPosition.y = lastPosition.y
		self.lastPosition.z = lastPosition.z
		return 0
	end
	local position = BehaviorFunctions.GetPositionP(self.me)
	local dis = BehaviorFunctions.GetDistanceFromPos(self.lastPosition,position)
	-- if dis < 0.06 then
	-- 	dis = 0
	-- end
	self.lastPosition.x = position.x
	self.lastPosition.y = position.y
	self.lastPosition.z = position.z
	--Log("GetMoveDistance lastPosition x="..self.lastPosition.x.."y= "..self.lastPosition.y.."z= "..self.lastPosition.z)
	--Log("GetMoveDistance position x="..position.x.."y= "..position.y.."z= "..position.z)
	--Log("dis "..dis)
	return dis
end
--记录位移数据
function PartnerFollow:RecordMoveDistance()
	self.moveRingIndex = self.moveRingIndex == self.moveTotalFrame and 1 or self.moveRingIndex + 1
	self.moveRing[self.moveRingIndex] = self:GetMoveDistance(self.moveRingIndex)
end
--清除位移记录
function PartnerFollow:ClearRecordMoveDistance()
	self.stuckCheckCount = 0
	self.moveRingIndex = 0
	TableUtils.ClearTable(self.moveRing)
end
--判断是否卡主
function PartnerFollow:CheckStuck()
	local totalDis = 0
	local index = self.moveRingIndex
	for i = 1,self.moveTotalFrame do
		if self.moveRing[index] then
			totalDis = totalDis + self.moveRing[index]
		else
			break
		end
		index = index == 1 and self.moveTotalFrame or index - 1
	end
	return totalDis < self.moveTotalDistance
end

function PartnerFollow:GetDistance()
	local pos1 = BehaviorFunctions.GetPositionP(self.me)
	local rolePos = BehaviorFunctions.GetPositionP(self.role)
	local dis = BehaviorFunctions.GetDistanceFromPos(rolePos,self.rolePosCache)
	if BehaviorFunctions.CheckEntityState(self.me,FightEnum.EntityState.FightIdle) and dis < 1 then
		return BehaviorFunctions.GetDistanceFromPos(pos1,self.idlePositionCache),self.idlePositionCache
	end
	local left = BehaviorFunctions.GetEnityOnScreenLeft(self.me)
	local rolePosX,rolePosY,rolePosZ = BehaviorFunctions.GetPosition(self.role)
	
	local offsetX,offsetZ = Fight.Instance.clientFight.cameraManager:GetMove(self.followPositionOffset.x,self.followPositionOffset,z)
	self.followPosition:Set(rolePosX+offsetX,rolePosY,rolePosZ+offsetZ)
	return BehaviorFunctions.GetDistanceFromPos(pos1,self.followPosition),self.followPosition
end

function PartnerFollow:GetTeleportPos()
	if self.followType == 1 then--地面，半径扩宽寻找落点
		local rolePosOffset = BehaviorFunctions.GetEntityPositionOffset(self.role,self.teleportPositionOffset.x,self.teleportPositionOffset.y,self.teleportPositionOffset.z)
		local rolePos = BehaviorFunctions.GetPositionP(self.role)
		local pos,result = BehaviorFunctions.GetChangeOptimumPos(self.role,nil,self.followRadius,1,self.followRadius,self.followRadius,1)--(instanceId,targetId,radius,type,up,down)
		return result,pos
	else
		return true,BehaviorFunctions.GetEntityPositionOffset(self.role,self.teleportPositionOffset.x,self.teleportPositionOffset.y,self.teleportPositionOffset.z)
	end
end

function PartnerFollow:CanChange()
    local frame = BehaviorFunctions.GetFightFrame()
    return frame > self.changeFrame 
end

function PartnerFollow:ChangeToIdle(pos)
	if not BehaviorFunctions.CheckEntityState(self.me,FightEnum.EntityState.FightIdle) and self:CanChange() then
		self.idlePositionCache:Set(pos.x,pos.y,pos.z)
		self.changeFrame = BehaviorFunctions.GetFightFrame() + 30
		BehaviorFunctions.CancelLookAt(self.me)		
		BehaviorFunctions.DoSetEntityState(self.me,FightEnum.EntityState.FightIdle)
		local rolePos = BehaviorFunctions.GetPositionP(self.role)
		self.rolePosCache:Set(rolePos.x,rolePos.y,rolePos.z)
		if self.followType == 2 then
			local lookatPos = BehaviorFunctions.GetPositionP(self.role)
			BehaviorFunctions.DoLookAtPositionByLerp(self.me,lookatPos.x,nil,lookatPos.z,true,0,180,-2)
		end
	end
end

function PartnerFollow:ChangeToRun()
	if BehaviorFunctions.GetSubMoveState(self.me) ~= FightEnum.EntityMoveSubState.Run and self:CanChange() then
		self.changeFrame = BehaviorFunctions.GetFightFrame() + 30
		BehaviorFunctions.DoSetMoveType(self.me,FightEnum.EntityMoveSubState.Run)
	end
end

function PartnerFollow:ChangeToWalk()
	if BehaviorFunctions.GetSubMoveState(self.me) ~= FightEnum.EntityMoveSubState.Walk and self:CanChange() then
		self.changeFrame = BehaviorFunctions.GetFightFrame()
		BehaviorFunctions.DoSetMoveType(self.me,FightEnum.EntityMoveSubState.Walk)
	end
end

--瞬移开始
function PartnerFollow:TeleportStart(curPos)
	self.changeFrame = 0
	local frame = BehaviorFunctions.GetFightFrame()
	if not self.IsTeleport and curPos and frame > self.tpFrame then
		self.tpPos = curPos
		--self:ChangeToIdle()
		self.followState = 1
		BehaviorFunctions.DoSetEntityState(self.me,FightEnum.EntityState.Idle)
		self.tpFrame = BehaviorFunctions.GetFightFrame() + 60
		BehaviorFunctions.DoMagic(self.me,self.me,600000006,1)	--播放佩从离场特效
		BehaviorFunctions.AddDelayCallByTime(0.5,self,self.TeleportEnd)
		--BehaviorFunctions.AddDelayCallByTime(0.5,BehaviorFunctions,BehaviorFunctions.DoSetPosition,self.me,curPos.x,curPos.y,curPos.z)    --延迟1秒再设置佩从新位置
		--BehaviorFunctions.AddDelayCallByTime(0.5,BehaviorFunctions,BehaviorFunctions.DoMagic,self.me,self.me,600000005,1)     --延迟1秒再播放佩从出场特效
		--BehaviorFunctions.AddDelayCallByTime(0.5,BehaviorFunctions,BehaviorFunctions.DoSetEntityState,self.me,FightEnum.EntityState.Idle)
		self.IsTeleport = true
	end
end

--瞬移结束
function PartnerFollow:TeleportEnd()
	local dis,pos = self:GetDistance()
	--local _,tpPos = self:GetTeleportPos()
	local tpPos = self.tpPos
	--LogError("TeleportEnd1 "..tpPos.x.."  "..tpPos.y.."  "..tpPos.z)
	local pos1 = BehaviorFunctions.GetPositionP(self.role)
	local dis = BehaviorFunctions.GetDistanceFromPos(tpPos,pos1)
	--LogError("dis "..dis)
	--LogError("TeleportEnd2 "..pos1.x.."  "..pos1.y.."  "..pos1.z)
	BehaviorFunctions.DoSetPosition(self.me,tpPos.x,tpPos.y,tpPos.z)
	BehaviorFunctions.DoMagic(self.me,self.me,600000005,1)
	BehaviorFunctions.CancelLookAt(self.me)
	BehaviorFunctions.DoSetEntityState(self.me,FightEnum.EntityState.Idle)
	self:ClearRecordMoveDistance()
	self.IsTeleport = false
end

function PartnerFollow:CanFollow()
	if self.PartnerAllParm.ResidentTarget and self.PartnerAllParm.ResidentTarget > 0 then
		return not BehaviorFunctions.CheckEntity(self.PartnerAllParm.ResidentTarget)--有目标时候不进入跟随
	end
	return not BehaviorFunctions.GetEntityValue(self.me,"wander")
	and BehaviorFunctions.CanCtrl(self.me)
end