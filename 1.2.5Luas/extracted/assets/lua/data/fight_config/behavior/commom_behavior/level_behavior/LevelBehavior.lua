LevelBehavior = BaseClass("LevelBehavior",LevelBehaviorBase)
--fight初始化
function LevelBehavior:__init(fight)
	self.fight = fight
end

--预加载
function LevelBehavior.GetGenerates()
	local generates = {200000101,200000102,200000103}
	return generates
end

--参数初始化
function LevelBehavior:Init()
	self.patroList = {}
	self.patrolIndex = 1
end

--帧事件
function LevelBehavior:Update()

end

--玩家出生且看向
function LevelBehavior:PlayerBorn(bornPosition,lookAtPosition,levelId)
	local pb1 = BehaviorFunctions.GetTerrainPositionP(bornPosition,levelId)
	BehaviorFunctions.SetPlayerBorn(pb1.x,pb1.y,pb1.z)	--角色位置
	local lp1 = BehaviorFunctions.GetTerrainPositionP(lookAtPosition,levelId)
	local character = BehaviorFunctions.GetCtrlEntity()
	BehaviorFunctions.DoLookAtPositionImmediately(character,lp1.x,nil,lp1.z)
	--初始相机朝向
	local vector = {x = lp1.x-pb1.x,z = lp1.z-pb1.z}
	angle = math.deg(math.atan(vector.x,vector.z))
	--BehaviorFunctions.InitCameraAngle(angle)
end

--刷怪
function LevelBehavior:CreatMonster(list,monsterList)
	local role = BehaviorFunctions.GetCtrlEntity()
	local MonsterId = 0
	local X_offset
	local Z_offset
	for a = #monsterList,1,-1 do
		
		--X偏移值缺省参数
		if monsterList[a].X_offset ~= nil then
			X_offset = monsterList[a].X_offset
		else
			X_offset = 0
		end
		--Z偏移值缺省参数
		if monsterList[a].Z_offset ~= nil then
			Z_offset = monsterList[a].Z_offset
		else
			Z_offset = 0
		end

		if monsterList[a].lookatposName then
			
			local posP = BehaviorFunctions.GetTerrainPositionP(monsterList[a].posName)
			local lookatposP = BehaviorFunctions.GetTerrainPositionP(monsterList[a].lookatposName)
			MonsterId = BehaviorFunctions.CreateEntity(monsterList[a].id,nil,posP.x + X_offset,posP.y,posP.z + Z_offset,lookatposP.x, nil, lookatposP.z)
			table.insert(list,{wave =monsterList[a].wave,instanceId =MonsterId})
		else
			local posP = BehaviorFunctions.GetTerrainPositionP(monsterList[a].posName)
			MonsterId = BehaviorFunctions.CreateEntity(monsterList[a].id,nil,posP.x + X_offset,posP.y,posP.z + Z_offset)
			BehaviorFunctions.DoLookAtTargetImmediately(MonsterId,role)
			table.insert(list,{wave = monsterList[a].wave,instanceId = MonsterId})
		end
	end
	table.sort(list,function(a,b)
			if a.wave < b.wave then
				return true
			elseif a.wave == b.wave then
				if a.instanceId < b.instanceId then
					return true
				end
			end
		end)
end

--怪物数量检测
function LevelBehavior:WaveCount(list,waveNum)
	local count	= 0
	for i = #list,1,-1  do
		if list[i].wave == waveNum then
			count = count + 1
		end
	end
	return count
end


--打开对话框
function LevelBehavior:OpenRemoteDialog(DialogID)
	BehaviorFunctions.CancelJoystick()--取消玩家摇杆
	BehaviorFunctions.OpenRemoteDialog(DialogID,true)
end

--检测玩家对话框是否继续了
function LevelBehavior:DialogCheck()	
	if BehaviorFunctions.CheckKeyDown(FightEnum.KeyEvent.Common1) 
	or BehaviorFunctions.CheckKeyDown(FightEnum.KeyEvent.Common2) then
		return true
	else
		return false
	end
end

--打开教程引导
function LevelBehavior:TutorialGuide(TutorialID)
	BehaviorFunctions.CancelJoystick()--取消玩家摇杆
	BehaviorFunctions.ShowGuidTip(TutorialID)
end

--目标点设置指引
function LevelBehavior:SetPositionGuide(GuideID,PostionName,Y_offset)
	if Y_offset == nil then
		Y_offset = 0
	end
	local position = BehaviorFunctions.GetTerrainPositionP(PostionName)
	BehaviorFunctions.SetGuide(GuideID,position.x,position.y+Y_offset,position.z)
end

--目标点设置路标
function LevelBehavior:SetRoadSign(PostionName,Y_offset)
	--路标的Y轴偏移值
	if Y_offset == nil then
		Y_offset = 0
	end
	local position = BehaviorFunctions.GetTerrainPositionP(PostionName)
	local roadSign = BehaviorFunctions.CreateEntity(900000102,nil,position.x,position.y+Y_offset,position.z) --插个路标
	return roadSign
end

--技能辅助轮
function LevelBehavior:SkillTips()
	local role = BehaviorFunctions.GetCtrlEntity()
	local CoreResRatio = BehaviorFunctions.GetEntityAttrValueRatio(role,1204)
	--提示长按普攻动效显示判断
	if CoreResRatio == 10000 and not BehaviorFunctions.HasEntitySign(role,10030000) then
		BehaviorFunctions.SetFightMainNodeVisible(1,"JTips20015",true)
	else
		BehaviorFunctions.SetFightMainNodeVisible(1,"JTips20015",false)
	end
	--提示连点普攻动效显示判断
	if BehaviorFunctions.HasEntitySign(role,10030000) then
		BehaviorFunctions.SetFightMainNodeVisible(1,"JTips20014",true)
	else
		BehaviorFunctions.SetFightMainNodeVisible(1,"JTips20014",false)
	end
end

--附带图片的guidetips
function LevelBehavior:ImageGuide(guideID)
	self:StopTime()
	local closeCallback = function()
		self:Continue()
	end
	BehaviorFunctions.ShowGuideImageTips(guideID,closeCallback)
end

--根据距离显示guide
function LevelBehavior:ShowGuideByDistance(guideID,targetInstanceID,distance,Y_offset)
	local role = BehaviorFunctions.GetCtrlEntity()
	local location = BehaviorFunctions.GetPositionP(targetInstanceID)
	--指引显示地点的Y轴偏移值
	if Y_offset == nil then
		Y_offset = 0
	end
	--根据距离决定是否显示
	if BehaviorFunctions.GetDistanceFromTarget(role,targetInstanceID) < distance then --小于5米时，隐藏指引图标
		BehaviorFunctions.SetGuide(guideID,location.x,location.y+Y_offset,location.z)
		BehaviorFunctions.HideGuidePointState()
	else
		BehaviorFunctions.SetGuide(guideID,location.x,location.y+Y_offset,location.z)--超出距离后，显示指引图标
	end
end

--获取实体和场景地点坐标之间的距离
function LevelBehavior:DistanceToPosition(instance,position)
	local instancePos = BehaviorFunctions.GetPositionP(instance)
	local positionPos = BehaviorFunctions.GetTerrainPositionP(position)
	
	local distance = BehaviorFunctions.GetDistanceFromPos(instancePos,positionPos)
	return distance
end

--关卡退出倒计时
function LevelBehavior:LevelEndCount(time)
	local countTime = time
	local showTime = 0
	--添加一段时间后进行关卡结算
	BehaviorFunctions.AddDelayCallByTime(countTime,BehaviorFunctions,BehaviorFunctions.SetFightResult,true)
	--每秒经过显示tips
	for i = countTime,0,-1 do
		BehaviorFunctions.AddDelayCallByTime(showTime,BehaviorFunctions,BehaviorFunctions.ShowTip,1106,i)
		showTime = showTime + 1
	end
end

--在地点设置交互实体
function LevelBehavior:SetInteractionPoint(position,Y_offset)
	local positionP = BehaviorFunctions.GetTerrainPositionP(position)
	local inter = BehaviorFunctions.CreateEntity(200000102,nil,positionP.x,positionP.y + Y_offset,positionP.z)--设置交互实体
	return inter
end

--移除对应交互实体
function LevelBehavior:RemoveInteractionPoint(instanceID)
	local positionP = BehaviorFunctions.GetPositionP(instanceID)
	local inter = BehaviorFunctions.CreateEntity(200000103,nil,positionP.x,positionP.y,positionP.z)--设置交互实体
	--BehaviorFunctions.DoMagic(instanceID,instanceID,200000103,1, FightEnum.MagicConfigFormType.Level)	--添加地点交互消失特效
	BehaviorFunctions.RemoveEntity(instanceID)
end

--怪物巡逻
function LevelBehavior:MonsterPatrol(instanceId,patrolLocaList,currentP)

	local MonState = BehaviorFunctions.GetEntityState(instanceId)
	local patrolNum = #patrolLocaList
	local locaList = {}--记录实体巡逻地点
	
	for i = 1 , patrolNum ,1 do
		table.insert(locaList,i,patrolLocaList[i])
	end
	for i = patrolNum , 1 , -1 do
		if i ~= patrolNum then
			table.insert(locaList,patrolLocaList[i])
		end
	end
	
	--获取下一个前往的地点
	local targetpos = locaList[currentP]
	local distance = self:DistanceToPosition(instanceId,targetpos)
	local targetposP = BehaviorFunctions.GetTerrainPositionP(targetpos)
	
	BehaviorFunctions.DoLookAtPositionByLerp(instanceId,targetposP.x,nil,targetposP.z,true,0,180,-2)
	--BehaviorFunctions.DoLookAtPositionImmediately(instanceId,targetposP.x,targetposP.z)
	
	--判断距离,切换移动状态
	if BehaviorFunctions.CanCastSkill(instanceId) == true then
		if distance >= 0.1  and MonState ~= FightEnum.EntityState.Die and MonState ~= FightEnum.EntityState.Move then
			BehaviorFunctions.DoSetEntityState(instanceId,FightEnum.EntityState.Move)
			BehaviorFunctions.DoSetMoveType(instanceId,FightEnum.EntityMoveSubState.Walk)
	
		elseif distance < 0.1 and MonState ~= FightEnum.EntityState.Die then
			if currentP < #locaList  then
				currentP = currentP + 1
				--print("My next position:"..targetpos)
			elseif currentP == #locaList  then
				currentP = 1
				--print("Now ,got back")
			end
		end
	end
	return currentP
end

--检测面前扇形范围是否存在对应实体
function LevelBehavior:PatrolDet(instanceId,targetId,angle,distance)
	if instanceId then
		if targetId then
			local dis = BehaviorFunctions.GetDistanceFromTarget(instanceId,targetId)
			local det = BehaviorFunctions.CompEntityLessAngle(instanceId,targetId,angle)
			if det == true and dis < distance then
				return true
			end
		end
	end
end

--时间暂停
function LevelBehavior:StopTime()        --暂停实体时间和行为
	local entity = BehaviorFunctions.GetCtrlEntity()
	if entity then
		BehaviorFunctions.DoMagic(entity,entity,200000008)
	end
end

--解除时间暂停
function LevelBehavior:Continue()        --解除暂停
	local entity = BehaviorFunctions.GetCtrlEntity()
	if entity then
		BehaviorFunctions.RemoveBuff(entity,200000008)	
	end
end



	