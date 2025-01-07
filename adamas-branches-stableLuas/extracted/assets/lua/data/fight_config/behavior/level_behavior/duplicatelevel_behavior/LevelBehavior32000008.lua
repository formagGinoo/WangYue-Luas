LevelBehavior32000008 = BaseClass("LevelBehavior32000008",LevelBehaviorBase)
--梦魇-初难度1-3


function LevelBehavior32000008.GetGenerates()
	local generates = {2000,790012000,790013000,790006000,790008000}
	return generates
end

function LevelBehavior32000008:__init(fight)
	self.fight = fight
end


function LevelBehavior32000008:Init()

	self.bornPos = "born"
	self.role = nil
	self.count = 0    --单一波次内怪物数量
	self.allCount = nil  --总怪物数量
	self.currentWave = 0 --当前波次
	self.missionState = 0
	self.dieCount = 0  --单一波次内死亡数
	self.sumDieCount = 0  --总死亡数
	self.lastCount = 0  --剩余怪物
	self.delayTime = 0

	self.monsterStateEnum = {
		Default = 0,
		Live = 1,
		Dead = 2,
	}
	
	--自定义参数
	self.wave = 2 --波次
	self.tipId = 32000007  --目标计数tips
	self.monsterList =
	{
		[1] = {Id = nil , state = self.monsterStateEnum.Default ,bp = "mon1" ,wave = 1 ,lev = 25 ,entityId = 790012000},  --1从士
		[2] = {Id = nil , state = self.monsterStateEnum.Default ,bp = "mon2" ,wave = 1 ,lev = 25 ,entityId = 790013000},  --1从士射手
		[3] = {Id = nil , state = self.monsterStateEnum.Default ,bp = "mon3" ,wave = 1 ,lev = 25 ,entityId = 790006000},  --1尾狐
		[4] = {Id = nil , state = self.monsterStateEnum.Default ,bp = "mon4" ,wave = 1 ,lev = 25 ,entityId = 790008000},  --1箴石之劣
		[5] = {Id = nil , state = self.monsterStateEnum.Default ,bp = "mon5" ,wave = 1 ,lev = 25 ,entityId = 790012000},  --1从士
		[6] = {Id = nil , state = self.monsterStateEnum.Default ,bp = "mon1" ,wave = 2 ,lev = 25 ,entityId = 790012000},  --2从士
		[7] = {Id = nil , state = self.monsterStateEnum.Default ,bp = "mon2" ,wave = 2 ,lev = 25 ,entityId = 790013000},  --2从士射手
		[8] = {Id = nil , state = self.monsterStateEnum.Default ,bp = "mon3" ,wave = 2 ,lev = 25 ,entityId = 790006000},  --2尾狐
		[9] = {Id = nil , state = self.monsterStateEnum.Default ,bp = "mon4" ,wave = 2 ,lev = 25 ,entityId = 790006000},  --2尾狐
		[10] = {Id = nil , state = self.monsterStateEnum.Default ,bp = "mon5" ,wave = 2 ,lev = 25 ,entityId = 790013000},  --2从士射手
	}
	
end

--添加黑幕，用于重载副本时不会显得过于怪异
function LevelBehavior32000006.NeedBlackCurtain()
	return true, 0
end

function LevelBehavior32000008:Update()
	self.time = BehaviorFunctions.GetFightFrame()
	self.role = BehaviorFunctions.GetCtrlEntity()
	
	if self.missionState == 0 then
		
		--隐藏ui
		BehaviorFunctions.SetFightMainNodeVisible(2,"Map",false) --隐藏地图
		BehaviorFunctions.SetFightMainNodeVisible(2,"RightTop",false) --系统四件套

		--玩家初始点位设置
		local bornPos = BehaviorFunctions.GetTerrainPositionP("born",self.levelId)
		--local bornRos = BehaviorFunctions.GetTerrainPositionR(self.bornPos,self.levelId)
		BehaviorFunctions.SetPlayerBorn(bornPos.x,bornPos.y,bornPos.z)	--设置角色出生点
		
		--设置关卡相机，此处点位后方需要填的是关卡id
		local fp1 = BehaviorFunctions.GetTerrainPositionP("mon2",32000008)
		self.empty = BehaviorFunctions.CreateEntity(2001,nil,fp1.x,fp1.y,fp1.z)
		self.levelCam = BehaviorFunctions.CreateEntity(22001)
		BehaviorFunctions.CameraEntityFollowTarget(self.levelCam,self.role,"CameraTarget")
		--看向目标
		BehaviorFunctions.CameraEntityLockTarget(self.levelCam,self.empty)
		BehaviorFunctions.DoLookAtTargetImmediately(self.role,self.empty)
		--隐藏相机
		--BehaviorFunctions.AddDelayCallByFrame(60,BehaviorFunctions,BehaviorFunctions.SetEntityShowState,self.levelCam,false)
		
		--延时移除目标和镜头
		BehaviorFunctions.AddDelayCallByFrame(60,BehaviorFunctions,BehaviorFunctions.RemoveEntity,self.levelCam)
		BehaviorFunctions.AddDelayCallByFrame(200,BehaviorFunctions,BehaviorFunctions.RemoveEntity,self.empty)
		
		
		BehaviorFunctions.ShowCommonTitle(4,"开始挑战",true) 
		self.allCount = #self.monsterList
		
		BehaviorFunctions.ShowTip(self.tipId)
		
		self.currentWave = 1
		self.missionState = 1

		--第一次刷怪
	elseif self.missionState == 1 then
		self.delayTime = self.delayTime + 1
		if self.delayTime > 70 then
			self:CreatMonster(self.currentWave)
			self.delayTime = 0
			self.missionState = self.currentWave + 0.1
		end
		--后续刷怪
	elseif self.missionState == self.currentWave and self.missionState ~= 1 then
		self.delayTime = self.delayTime + 1
		if self.delayTime > 5 then
			self:CreatMonster(self.currentWave)
			self.delayTime = 0
			self.missionState = self.currentWave + 0.1
		end

	elseif self.missionState == self.currentWave + 0.1 then
		--计数tips
		self.lastCount = self.allCount - self.sumDieCount
		BehaviorFunctions.ChangeSubTipsDesc(1,self.tipId,self.lastCount)
		
		--计算怪物死亡
		if self.allDie == true then
			--计算波次
			if self.wave > self.currentWave then
				self.currentWave = self.currentWave + 1
				self.missionState = self.missionState + 0.9
				self.allDie = false
			elseif self.wave == self.currentWave then
				--副本成功
				BehaviorFunctions.AddDelayCallByFrame(50,BehaviorFunctions,BehaviorFunctions.SetDuplicateResult,true)
				BehaviorFunctions.HideTip(self.tipId)
				BehaviorFunctions.ShowCommonTitle(5,"挑战成功",true)
				--显示ui
				--BehaviorFunctions.AddDelayCallByFrame(55,BehaviorFunctions,BehaviorFunctions.SetFightMainNodeVisible,2,"Map",true)      --显示地图
				--BehaviorFunctions.AddDelayCallByFrame(55,BehaviorFunctions,BehaviorFunctions.SetFightMainNodeVisible,2,"RightTop",true) --系统四件套
				

				self.currentWave = 999
			end
		end
	end
end

function LevelBehavior32000008:CreatMonster(wave)

	for i,v in ipairs(self.monsterList) do
		if v.wave == wave and v.state == self.monsterStateEnum.Default then
			local pos = BehaviorFunctions.GetTerrainPositionP(v.bp,self.levelId)
			local rot = BehaviorFunctions.GetTerrainRotationP(v.bp,self.levelId)
			v.Id = BehaviorFunctions.CreateEntity(v.entityId,nil,pos.x,pos.y,pos.z,nil,nil,nil,self.levelId,v.lev)
			BehaviorFunctions.SetEntityEuler(v.Id,rot.x,rot.y,rot.z)
			v.state = self.monsterStateEnum.Live
			self.count = self.count + 1
			--看向玩家
			BehaviorFunctions.DoLookAtTargetImmediately(v.Id,self.role)
			--关闭警戒
			BehaviorFunctions.SetEntityValue(v.Id,"haveWarn",false)
			--设置脱战范围
			BehaviorFunctions.SetEntityValue(v.Id,"ExitFightRange",500)
			--设置目标追踪范围
			BehaviorFunctions.SetEntityValue(v.Id,"targetMaxRange",500)
		end
	end
	
end


function LevelBehavior32000008:Death(instanceId,isFormationRevive)
	--计算怪物全部死亡
	for i,v in ipairs(self.monsterList) do
		--计算当前波次怪物死亡数
		if v.Id == instanceId and v.wave == self.currentWave then
			v.state = self.monsterStateEnum.Dead
			self.dieCount = self.dieCount + 1
			self.sumDieCount = self.sumDieCount + 1
		end
	end

	if self.dieCount == self.count then
		self.allDie = true
		self.dieCount = 0
		self.count = 0
	end
	--玩家角色全部死亡，副本失败
	if isFormationRevive == true then
		BehaviorFunctions.ShowCommonTitle(6,"挑战失败",true)
		BehaviorFunctions.SetDuplicateResult(false)
		self.missionState = 999
	end
end

----挑战开始
--function CommonLevelBehavior:ChallengeStart(challangeName)
----开启挑战，记录开始时间，打开tip
--self.challengeStart = true
--self.startTime = BehaviorFunctions.GetFightFrame()
--BehaviorFunctions.ShowCommonTitle(4,challangeName,true)
--BehaviorFunctions.ShowTip(32000008)
--end



--移除


function LevelBehavior32000008:__delete()

end








