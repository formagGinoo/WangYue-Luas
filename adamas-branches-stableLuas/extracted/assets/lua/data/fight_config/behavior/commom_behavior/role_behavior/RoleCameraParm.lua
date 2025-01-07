RoleCameraParm = BaseClass("RoleCameraParm",EntityBehaviorBase)

local BF = BehaviorFunctions
local FE = FightEnum
local FK = FightEnum.KeyEvent
local FEMSS = FightEnum.EntityMoveSubState
local FESS = FightEnum.EntitySwimState
local FES = FightEnum.EntityState
local FECS = FightEnum.EntityClimbState
local FEAET = FightEnum.AnimEventType
local FEET = FightEnum.ElementType
local FEPA = FightEnum.PlayerAttr
local EACAT = EntityAttrsConfig.AttrType
local _abs = math.abs

function RoleCameraParm:Init()
	self.Me = self.instanceId		--记录自己
	self.RAB = self.ParentBehavior
	self.RAP = self.MainBehavior.RoleAllParm
	
	self.distance = 0	--相机最终距离
	self.cameraDistance = 5		--默认相机距离为5，暂时废弃
	self.enemyDistance = 0	--群怪增加的相机距离
	self.highDistance = 0	--空战增加的相机距离
	
	self.deafultDistance = {
		Operating = 5,
		WeakLocking = 5,
		ForceLocking = 6,
		Fighting = 5,
		}
	
	
	
	self.monFarTarget = 0
	self.curFarTarget = 0
	self.blendFrame = 0.2
	self.blendDistance = 0
	self.distanceSet = true
	self.distanceFrame = 5	--300帧设置一次距离相机
	self.distanceTime = 0
	self.highCamera = false
	self.mission = 0
	
	
	self.setParmsDistance = 8
	self.parmFrame = 90		--默认切换时间为90
	self.parmTime = 0
	self.parmSet = true		--能否设置相机参数
	self.targetFly = false	--当前攻击的目标是否被击飞
	self.enemyCount = 0	--周围敌人数量计数
	self.setCameraState = 0	 --没有设置过相机
	self.cameraSwitchFrame = 0
	self.cameraSwitchTime = 60
	self.roleDistance = 0
	
	--距离动态参数相关
	self.minDistance = 0
	self.maxDistance = 2
	self.cancelDistance = 5
	
	self.cameraMode = 0		--相机模式：0默认，1集中，2群殴
end

function RoleCameraParm:Update()
	self.cameraState = BF.GetCameraState()
	--如果当前不在强锁状态下
	if not BF.HasEntitySign(1,10000007) and BF.GetCtrlEntity() == self.Me then
		if self.RAP.extraCameraDistance then
			self.roleDistance = self.RAP.extraCameraDistance
		end
		
		self.distance = self.enemyDistance + self.highDistance + self.roleDistance	--管理相机距离
		self.jumpState = BF.GetEntityJumpState(self.Me)
		
		if self.RAP.LockTarget and self.RAP.LockTarget ~= 0 and BF.CheckEntity(self.RAP.LockTarget) then
			self.RAP.cameraParams = BF.GetEntityValue(self.RAP.LockTarget,"cameraParams")
		end
			
		if self.mission == 0 then
			--Y轴折扣
			--BehaviorFunctions.SetCamerIgnoreData(FightEnum.CameraState.Fight,true,0.3)
			--锁Y轴
			--BF.SetFixedCameraVerticalDir(FE.CameraState.Fight,true)
			BF.SetCorrectCameraState(FE.CameraState.Fight, false)	
			--BF.SetCorrectCameraState(FE.CameraState.Fight, false)
			self.mission = 1	
		end
	
		
			
		--每帧管理相机的距离
	--	if self.RAP.roleCameraState == 0 and self.cameraSwitchFrame < self.RAP.RealFrame then
			if BF.GetEntityState(self.Me) ~= FightEnum.EntityState.Glide 
				and BF.GetEntityState(self.Me) ~= FightEnum.EntityState.Swim 
				and BF.GetEntityState(self.Me) ~= FightEnum.EntityState.Jump
				and BF.GetEntityState(self.Me) ~= FightEnum.EntityState.Climb then
				if self.cameraState == FE.CameraState.Operating or self.cameraState == FE.CameraState.WeakLocking or self.cameraState == FE.CameraState.Fight then
					BF.ChangeCameraDistance(FE.CameraState.Fight,true,self.distance)
					BF.ChangeCameraDistance(FE.CameraState.Operating,true,self.distance)
					BF.ChangeCameraDistance(FE.CameraState.WeakLocking,true,self.distance)
				end
			end
	--	end
		
		----如果在获取到额外参数的情况下，关闭角色内部的相机参数调整，直接接收外部
		--if self.RAP.roleCameraState == 0 and self.setCameraState == 0 then
			----如果外部有参数传进来
			--if BF.GetEntityValue(self.Me,"extraCameraDistance") and self.cameraSwitchFrame < self.RAP.RealFrame then
				--BF.SetCameraDistance(FE.CameraState.Fight, self.RAP.extraCameraDistance, 1, true)
				--BF.SetCameraDistance(FE.CameraState.WeakLocking, self.RAP.extraCameraDistance, 1, true)
				--BF.SetCameraDistance(FE.CameraState.Operating, self.RAP.extraCameraDistance, 1, true)
				--self.RAP.roleCameraState = 1
				--self.setCameraState = 1
				--self.cameraSwitch = false
				--self.cameraSwitchFrame = self.RAP.RealFrame + self.cameraSwitchTime
			--elseif not BF.GetEntityValue(self.Me,"extraCameraDistance") and self.cameraSwitchFrame < self.RAP.RealFrame then
				--BF.SetCameraDistance(FE.CameraState.Fight, self.deafultDistance.Fighting, 1, true)
				--BF.SetCameraDistance(FE.CameraState.WeakLocking, self.deafultDistance.WeakLocking, 1, true)
				--BF.SetCameraDistance(FE.CameraState.Operating, self.deafultDistance.Operating, 1, true)
				--self.RAP.roleCameraState = 0
				--self.setCameraState = 0
				--self.cameraSwitchFrame = self.RAP.RealFrame + self.cameraSwitchTime
			--end
		--end	
			
		--群怪判断相机逻辑入口
		if BF.GetCtrlEntity() == self.Me then
			--高空相机状态下
			if not self.highCamera then
				--获取7.5米内离自己相机中心最远的目标
				self.monFarTarget,self.enemyCount = self:GetFarTarget(self.setParmsDistance)
				--如果有当前最远的目标，且该目标不是当前攻击的目标
				if self.monFarTarget and self.monFarTarget ~= 0 and self.enemyCount ~= 1 then
					--设置相机距离
					--self:CameraDistance()
					self.cameraMode = 2		--设置相机状态为群怪相机
				else
					self.enemyDistance = 0
					self.cameraMode = 0
				end
			end
		end
		
		--如果主动发起跳跃，切操作相机
		--if self.jumpState == 1 or self.jumpState == 4 or self.jumpState == 5 then
			--BF.RemoveAllLookAtTarget()
			--BF.RemoveAllFollowTarget()
			--BF.AddLookAtTarget(self.Me,"CameraTarget")
			--BF.AddFollowTarget(self.Me,"CameraTarget")
			--BF.SetCameraState(FightEnum.CameraState.Operating)
		--end
		
		
		--被击飞太高的情况下，移除锁定
		--if not BF.HasEntitySign(1,10000007) then
			--if self.RAP.LockTarget and self.RAP.LockTarget ~= 0 then
				--if BF.GetHitType(self.RAP.LockTarget) == FightEnum.EntityHitState.HitFlyUp or BehaviorFunctions.GetHitType(self.RAP.LockTarget) == FightEnum.EntityHitState.HitFlyFall then
					--if BF.CheckEntityHeight(self.RAP.LockTarget) > 5 then
						--self.RAP.CancelLockFrame = self.RAP.RealFrame - 1
						--self:CleanTarget("LockTarget")
						--self:CleanTarget("AttackTarget")
						--BF.RemoveAllLookAtTarget()
						--BF.SetCameraState(FightEnum.CameraState.Operating)
						--BF.CameraPosReduction(0.2,false,0.4)
					--end
				--end
			--end
		--end
	
		
		--过渡时间计时
		if self.blending == true then
			if self.blendFrame < self.RAP.RealFrame then
				self.blending = false
			else
				self:SetCameraBlend(self.blendDistance,FightEnum.CameraState.Operating)
			end
		end
		
		--相机距离设置冷却退出计时
		if self.distanceSet == false then
			if self.distanceTime < self.RAP.RealFrame then
				self.distanceSet = true
			end
		end
		
		
		--冷却时间结束，设置相机参数可设置
		if not self.parmSet and self.parmTime < self.RAP.RealFrame then
			self.parmSet = true
		end
		
		--self:HighFightCamera()
	end
end

--地面设置相机距离
function RoleCameraParm:CameraDistance()
	--如果可以设置相机参数
	if not BF.HasEntitySign(self.Me,600000021) then
		local distance = _abs(BF.GetTransformScreenX(self.monFarTarget,""))	--获取目标在相机中的投影距离
		--根据怪物群的距离设置相机距离
		if distance > self.cancelDistance then
			self.enemyDistance = 0
		elseif distance > self.maxDistance then
			self.enemyDistance = self.maxDistance	
		--如果当前距离大于可应用的最小值，则开始应用距离设置
		elseif distance > self.minDistance then
			self.enemyDistance = distance
		end
	end
end


--计算目标高度，暂时废弃
function RoleCameraParm:CountHeight()
	local target
	
	if self.RAP.LockTarget and self.RAP.LockTarget ~= 0 then
		target = self.RAP.LockTarget
	elseif self.RAP.AttackTarget and self.RAP.AttackTarget ~= 0 then
		target = self.RAP.AttackTarget
	end
	
	if target and self.highCamera == false then
		--if BF.GetHitType(target) == FE.EntityHitState.HitFlyUp or BF.GetHitType(target) == FE.EntityHitState.HitFlyFall then
			local h1 = BF.CheckEntityHeight(target)
			local h2 = BF.CheckEntityHeight(self.Me)
			local height = _abs(h2 - h1)
		
			local distance = BF.GetDistanceFromTarget(self.Me,target)
			if distance <= 0 then
				distance = 0.1
			end
			local value = height/distance
			
		if not BF.HasEntitySign(self.Me,600000021) then
			--超过高度阈值，进入持续高空相机状态
			if value > 0.5 then
				--if self.cameraState == FE.CameraState.Operating or self.cameraState == FE.CameraState.Fighting then
				if self.cameraState == FE.CameraState.Operating 
					or self.cameraState == FE.CameraState.WeakLocking 
					or self.cameraState == FE.CameraState.Fight then
					BF.SetCameraDistance(FE.CameraState.Operating,6.5,1 * FightUtil.deltaTimeSecond,true)
					BF.SetCameraDistance(FE.CameraState.WeakLocking,6.5,1 * FightUtil.deltaTimeSecond,true)
					BF.SetCameraDistance(FE.CameraState.Fight,6.5,1 * FightUtil.deltaTimeSecond,true)
					self.parmTime = self.RAP.RealFrame + self.parmFrame		--增加相机参数设置冷却
					self.parmSet = false  --标记为不可设置相机参数
					self.targetFly = true
				end
				--end
			else
			--如果目标不在空中 尝试重置位置
				if self.targetFly then
				--	if self.cameraState == FE.CameraState.Operating or self.cameraState == FE.CameraState.Fighting then
					if self.cameraState == FE.CameraState.Operating 
						or self.cameraState	== FE.CameraState.WeakLocking 
						or self.cameraState	== FE.CameraState.Fight then
						BF.SetCameraDistance(FE.CameraState.Operating,self.cameraDistance,self.parmFrame * FightUtil.deltaTimeSecond,true)
						BF.SetCameraDistance(FE.CameraState.WeakLocking,self.cameraDistance,self.parmFrame * FightUtil.deltaTimeSecond,true)
						BF.SetCameraDistance(FE.CameraState.Fight,self.cameraDistance,self.parmFrame * FightUtil.deltaTimeSecond,true)
						self.parmTime = self.RAP.RealFrame + self.parmFrame		--增加相机参数设置冷却
						self.parmSet = false  --标记为不可设置相机参数
						self.targetFly = false
					end
				--	end	
				end
			end
		end
		--end
	end
end

--拿到最远的目标
function RoleCameraParm:GetFarTarget(curDistance)
	local target
	local distance
	local List = {}
	local count = 0
	--搜索
	self.AllTargetList = BehaviorFunctions.SearchEntities(self.Me,curDistance,0,360,2,1,nil,1004,0,0,nil,false,true,0.2,0.8,false,false,true)
	if next(self.AllTargetList) then
		--存在实体
		if BehaviorFunctions.CheckEntity(self.AllTargetList[1][1]) then
			local maxValue = 0
			local maxIndex = 0
			for i,v in ipairs(self.AllTargetList) do
				--得到目标和角色的距离
				distance = _abs(BF.GetTransformScreenX(v[1],""))
			--	distance = BF.GetDistanceFromTarget(self.Me,v[1],false)
				--不断遍历最大值
				if distance > maxValue then
					maxValue = distance
					count = count + 1		--敌人数量计数+1
					--剔除当前锁定的目标v[1] ~= self.RAP.LockTarget
					if (self.RAP.LockTarget and self.RAP.LockTarget ~= 0 )
						or (self.RAP.LockAltnTarget and self.RAP.LockAltnTarget ~= 0 )
						or (self.RAP.AttackTarget and self.RAP.AttackTarget ~= 0 )
						or	(self.RAP.AttackAltnTarget and self.RAP.AttackAltnTarget ~= 0 )
						 then
						--得到当前最远的目标
						maxIndex = v[1]
					end
				end
				target = maxIndex
			end
			
			--local maxIndex = 1
			--local maxValue = List[maxIndex]
			--for i, v in ipairs(List) do
				--if v > maxValue then
					--maxIndex = i
					--maxValue = v
				--end
			--end
		end
	end
	return target,count
end

--闪避设置锁定目标
function RoleCameraParm:Dodge(attackInstanceId,hitInstanceId,limit)
	if not BF.HasEntitySign(1,10000001) and not BF.HasEntitySign(1,10000007) then
		if BF.GetDistanceFromTarget(attackInstanceId,self.Me,false) < self.MainBehavior.LockDistance then
			--if self.RAP.LockTarget == 0
				--and self.RAP.CtrlRole == self.Me 
				--and self.RAP.LockAltnTarget ~= 0
				--and self.RAP.LockAltnTarget ~= nil then
				--self.RAP.CancelLockFrame = self.RAP.RealFrame + 60
				--if BF.GetCameraState() ~= FE.CameraState.Fight then
					--BF.SetCorrectEulerData(FE.CameraState.Fight,true,0.2,10)
					--BF.SetCorrectCameraState(FE.CameraState.Fight, false)
					--BF.SetCameraState(FE.CameraState.Fight)
				--end
				--BF.RemoveAllLookAtTarget()
				--BF.AddLookAtTarget(self.RAP.LockAltnTarget,self.RAP.LockAltnTargetPoint)
			--end
		end
	end
end




--计算距离
function RoleCameraParm:CountDistance(minValue,maxValue,targetValue)
	local distance = BF.GetTransformScreenX(self.monFarTarget,"")	--获取目标在相机中的投影距离
	distance = _abs(distance)
	
	--如果目标超出了极限值，则设置为最小值
	if distance > targetValue then
		distance = 0
	--如果目标大于最大值,则设置等于最大值
	elseif distance > maxValue	then
		distance = maxValue
	end
	return distance
end


--差值过渡设置相机，废弃
function RoleCameraParm:SetBlendTime(distance,time)
	self.blending = true
	local blendDistance = (self.distance - distance)/time	--每帧过渡多少
	self.blendFrame = self.RAP.RealFrame + time
	return distance
end

--设置相机过渡
--function RoleCameraParm:SetCameraBlend(distance,cameraState)
	----每帧设置
	--if BF.GetCameraState() == cameraState then
		--BF.Setdistance(cameraState,self.distance + distance)
	--end
--end


--空战相机镜头切换
function RoleCameraParm:HighFightCamera()
	--如果角色在空中释放技能
	if BF.GetSkill(self.Me) then
		local skillType = BF.GetSkillConfigSign(self.Me)
		if skillType ~= 170 and skillType ~= 171 and skillType ~= 172 and skillType ~= 80 and skillType ~= 81 and skillType ~= 82 then
	if not BF.HasEntitySign(self.Me,600000021) then
		if BF.GetCameraState() == FightEnum.CameraState.Fight then
			--如果自己在空中而且没有处于空战状态，设置一次自己在空战
			if BF.CheckEntityHeight(self.Me) > 0 and self.highCamera == false then
				--设置空中相机的参数
				BF.SetFixedCameraVerticalDir(FightEnum.CameraState.Fight,false)
				BehaviorFunctions.SetBodyDamping(0.5,0.5,0.5)
				BF.SetCameraState(FightEnum.CameraState.Fight)
				BF.SetCameraParams(FightEnum.CameraState.Fight,9999903,false)
			--	if self.cameraState == FE.CameraState.Operating or self.cameraState == FE.CameraState.Fight then
				if self.cameraState == FE.CameraState.Fight then
					BF.SetCameraDistance(FE.CameraState.Fight,7,0.8,true)
					self.parmSet = false
				end
			--	end
				self.highCamera = true
			end
		
			--如果自己在地面了，设置回来
			if self.highCamera and BF.CheckEntityHeight(self.Me) == 0 and self.parmSet then
				BF.SetFixedCameraVerticalDir(FightEnum.CameraState.Fight,true)
				--BehaviorFunctions.SetBodyDamping(0.5,0.5,0.5)
				BF.SetCameraState(FightEnum.CameraState.Operating)
				BF.SetCameraParams(FightEnum.CameraState.Fight,9999901,false)
				self.highCamera = false
			end
		
		end
	end
		end
	end
end


