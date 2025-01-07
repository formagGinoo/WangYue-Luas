LevelBehavior404010601 = BaseClass("LevelBehavior404010601",LevelBehaviorBase)

function LevelBehavior404010601:__init(fight)
	self.fight = fight
	self.rogueData = nil --------rogue事件数据集
	self.roguePosName = nil -----rogue生成点位名称

	----肉鸽关卡开启参数--------------------------------------------------------------------------------------------------------------------------------
	self.missionStartDis = 30 ---挑战开始距离
	self.missionStartPos = nil --挑战开始位置
	self.missionCreate = false --检查关卡是否加载
	self.missionDistance = nil --操作角色与挑战关卡的距离
	self.eventId = nil ----------rogue事件ID
	self.missionUnloadDis = 90 --肉鸽玩法未开始的卸载距离
	self.unloaded = false

	------追踪标--------------------------------------------------------------------------------------------------------
	self.guide = nil
	self.guideEntity = nil
	self.guideDistance = 70
	self.guidePos = nil
	self.GuideTypeEnum = {
		Police = FightEnum.GuideType.Rogue_Police,
		Challenge = FightEnum.GuideType.Rogue_Challenge,
		Riddle = FightEnum.GuideType.Rogue_Riddle,
	}
	--怪物死亡数量
	self.monsterDead  = 0
end

function LevelBehavior404010601.GetGenerates()
	local generates = {790012000,808011001}
	return generates
end

function LevelBehavior404010601.GetMagics()
	local generates = {900000001,900000007,900000013,900000020,900000022,900000023}
	return generates
end

function LevelBehavior404010601:Init()
	--肉鸽事件信息获取
	self.eventId = self.rogueEventId
	self.rogueData = BehaviorFunctions.GetRoguelikePointInfo(self.rogueEventId)
	self.roguePosName = self.rogueData.position

	----可修改参数 ↓-----
	self.npcid = 808011001
	self.monsterentityid = 790012000
	self.mapname = Logic404010601
	self.mappositionid = 404010601
	self.wave = 1                        --总波次
	----可修改参数 ↑-----

	self.me = self.instanceId
	self.role = nil
	self.dialog = 601010701
	self.Over = false
	self.dieCount = 0
	self.allDie = false
	self.challengeSuccece = nil
	self.npcState = 0
	self.npcEntity = nil
	self.animation = false
	self.aniId =nil
	self.aniTime = 0
	self.aniFrame = 0
	self.npchelpBob = 0
	self.choose = nil
	self.helpTime = 0				--npc救命时间
	self.createnpc = 0				--是否创建NPC
	self.npcend = false
	self.npchurt = false
	self.deathCount = 0           --死亡计数
	self.currentWaveLookAtPos = nil       --当前波次关卡相机朝向点
	self.currentWave = 1          --当前波次
	self.currentWaveNum = 0       --当前波次怪物总数
	self.isWarn = true                    --是否开启警戒
	self.transPos = nil                   --设置玩家位置
	self.imageTipId = nil                 --图文教学
	self.guidecamera = false				--指引镜头
	self.range = 0							--玩家和事件距离,1近距离,2中距离,3远距离
	self.tipsstate = false					--城市威胁tips是否发送
	self.npcSquat = 0						--npc是否下蹲
	self.missionFinished = false			--判断是否进入战斗区域
	self.playerPos = nil					--玩家当前位置
	self.npcvictory = false
	self.npcidlist = {
		[1] = {entityId = self.npcid}		--npc信息
	}
	--怪物状态
	self.monsterStateEnum = {
		Default = 0,
		Live = 1,
		Dead = 2,
	}
	self.monsterList = {
		--第一波
		[1] = {Id = nil , state = self.monsterStateEnum.Default ,posName = "mon11" ,wave = 1 ,lev = 0 ,isDead = false ,entityId = self.monsterentityid},  --1猎手
		[2] = {Id = nil , state = self.monsterStateEnum.Default ,posName = "mon12" ,wave = 1 ,lev = 0 ,isDead = false ,entityId = self.monsterentityid},  --1猎手
		[3] = {Id = nil , state = self.monsterStateEnum.Default ,posName = "mon13" ,wave = 1 ,lev = 0 ,isDead = false ,entityId = self.monsterentityid},  --1猎手
	}
	self.missionState = 0
	self.missionCreate = false
end

function LevelBehavior404010601:Update()
	self.role = BehaviorFunctions.GetCtrlEntity()
	self.time = BehaviorFunctions.GetFightFrame()
	self.realtime = BehaviorFunctions.GetFightFrame()/30
	-- print("LevelBehavior404010601初始化")

	self.missionStartPos = BehaviorFunctions.GetTerrainPositionP(self.rogueData.position,self.rogueData.positionId,self.rogueData.logicName)	--获取肉鸽区域的坐标
	-- print("判断关卡是否加载 和 或者肉鸽事件")

	if self.playerPos == nil then
		self.playerPos = BehaviorFunctions.GetPositionP(self.role)										--获取玩家的坐标
	end
	self.missionDistance = BehaviorFunctions.GetDistanceFromPos(self.playerPos,self.missionStartPos)		--获取玩家和肉鸽的距离
	--print("获取角色和目标的距离",self.missionDistance)
	if self.missionCreate == false then			--判断关卡是否加载
		--关卡追踪标				--关卡追踪标和追踪标函数是通用写法
		if self.guidePos == nil then
			local pos = BehaviorFunctions.GetTerrainPositionP(self.rogueData.position,self.rogueData.positionId,self.rogueData.logicName)		--获取肉鸽和玩家的距离
			-- print("local pos = ",pos)
			self:RogueGuidePointer(pos,self.guideDistance,self.GuideTypeEnum.Police)											--调用关卡追踪标 函数
			-- print("调用关卡追踪标 函数")
			self.missionCreate = true
		else
			if self.rogueEventId then
				self.guidePos = BehaviorFunctions.GetRoguelikePointInfo(self.rogueEventId)
			end
		end
	end

	--近距离
	if self.missionDistance <= self.missionStartDis then	--玩家距离 < 30
	--	print("进入战斗的距离",self.missionStartDis)
		--玩家在小范围内，开启tips
		if self.tipsstate == false then
			BehaviorFunctions.ShowCommonTitle(7,"发现城市威胁",true)
			BehaviorFunctions.ShowTip(32000007) --显示敌人剩余数量
			BehaviorFunctions.ChangeSubTipsDesc(1,32000007,#self.monsterList) --修改剩余敌人数量
			self:MakeRandomMonsterAttack()
			--	print("tip:发现城市威胁")
			self.tipsstate = true
		end

		--设置Npc受伤
		if self.npc01 then
			if self.npchelpBob == 0 then
				--设置怪物打人
				-- self:ChangeTarget(self.monsterList)

				--呼救气泡
				BehaviorFunctions.ChangeNpcBubbleContent(self.npc01,"救命！谁来帮帮我！",999999)
				BehaviorFunctions.SetNonNpcBubbleVisible(self.npc01,true)
				BehaviorFunctions.DoEntityAudioPlay(self.npc01,"Play_v_pvnpc4_001",true,FightEnum.SoundSignType.Language)
			--	print("NPC救命！")
				self.npchelpBob = 1
			end

			if self.npchurt == false then
				-- self:FirstCollide()
			--	print("开启NPC受伤函数内容")
				self.npchurt = true
			end
		end
	end

	--如果距离超出则卸载距离
	if self.missionDistance >= self.missionUnloadDis and self.unloaded == false then				--玩家距离 < 60, self.missionUnloadDis是init里面自定义的数值60
		-- print("玩家超出肉鸽触发区域")
		BehaviorFunctions.SetRoguelikeEventCompleteState(self.eventId,false)						--肉鸽专用接口，告诉服务器，事件失败
		self:Leave()
		self.unloaded = true
	--	print("如果距离超出则卸载距离")
	end

	if self.missionCreate == true then
		if self.missionState == 0 then
			--开场自定义功能
			if self.createnpc == 0 then
			--	print("判断是否创建NPC，self.createnpc == false")
				local npcpos = BehaviorFunctions.GetTerrainPositionP("npc",self.mappositionid)
				self.npc01 =  BehaviorFunctions.CreateEntity(self.npcid,nil,npcpos.x,npcpos.y,npcpos.z, nil, nil, nil, self.levelId)
				BehaviorFunctions.fight.clientFight.headInfoManager:CreateHeadInfoObj(self.npc01)
			--	print("创建NPC流程开始")

				if self.npcSquat == 0 then
					BehaviorFunctions.PlayAnimation(self.npc01,"Squat_loop")
				--	print("NPC下蹲")
					--设置npc属性
					BehaviorFunctions.DoMagic(1,self.npc01,900000001) --免疫受击
					BehaviorFunctions.DoMagic(1,self.npc01,900000013)--免疫锁定
					BehaviorFunctions.DoMagic(1,self.npc01,900000020)--免疫受击朝向
					BehaviorFunctions.DoMagic(1,self.npc01,900000022)--免疫伤害
					BehaviorFunctions.DoMagic(1,self.npc01,900000023)--免疫伤害
				--	print("NPC免疫受击")
					BehaviorFunctions.SetPartEnableHit(self.npc01, "Body", false)
					self.npcSquat = 1
				end
				self.createnpc = 1
			--	print("创建NPC流程结束")
			end
			--self:CustomLevelFunctions()
			self.missionState = 1
		--	print("自定义功能阶段结束")
			--第一波刷怪
		elseif self.missionState == 1 then
			self:CreateMonster(self.currentWave)
			self.missionState = 2
		--	print("第一波怪物结束")
			--判断是否还有波次
		elseif self.missionState == self.currentWave + 1 then
			--当前波怪物全死时
			if self.currentWaveAllDie == true then
				--如果仍有后续波次
				if self.wave > self.currentWave then
					self.currentWave = self.currentWave + 1
					self.currentWaveAllDie = false
					--成功击杀所有怪
				elseif self.wave == self.currentWave then
					if self.npcvictory == false then
						self:Victory()
					end
					-- print("成功击杀所有怪")
				end
			end
			--后续波次刷怪
		elseif self.missionState == self.currentWave and self.missionState ~= 1 then
			self:CreateMonster(self.currentWave)
		--	print("没有最后一波次")
		end
	end
	--根据感谢对话和胜利条件播放结算内容
	if self.npcend == true and self.npcvictory == true  and self.missionState ~= 999 then
	--	print("进入结算阶段")
		BehaviorFunctions.HideTip(32000007) --隐藏敌人数量的tips
		BehaviorFunctions.SetRoguelikeEventCompleteState(self.eventId,true)
		self:Leave()
		self.missionState = 999 --由于与后端有关，只告诉服务端一次就好
	end
end

function LevelBehavior404010601:__delete()
end

-------------------------函数--------------------------------

-- -- 更新距离函数，该函数直接对比 self.range， self.range<=30 , 30 < self.range <= 50, self.range > 50
-- function LevelBehavior404010601:UpdateRange()
-- 	local rolepos = BehaviorFunctions.GetPositionP(self.role) -- 获取角色位置
-- 	local pos = BehaviorFunctions.GetTerrainPositionP("npc",self.mappositionid,self.mapname) -- 获取事件位置
-- 	self.range = BehaviorFunctions.GetDistanceFromPos(rolepos,pos) -- 计算两点距离并存储
-- 	print("实时对比玩家和中心距离")
-- end

-- --开场自定义功能函数
-- function LevelBehavior404010601:CustomLevelFunctions()
--     --如果需要开场图文教学
--     if self.imageTipId then
--         BehaviorFunctions.ShowGuideImageTips(self.imageTipId)
--     end
--     --如果需要同步玩家位置
--     if self.transPos then
--         local rolePos = BehaviorFunctions.GetTerrainPositionP(self.posName.rolePos, 10020005, "Prologue02")
--         BehaviorFunctions.InMapTransport(rolePos.x,rolePos.y,rolePos.z)
--     end
-- end

--创怪函数
function LevelBehavior404010601:CreateMonster(wave)
	--print("创怪物函数")
	for i, v in pairs(self.monsterList) do
		--创该波的怪
		local pos = nil
		local rot = nil
		if v.wave == wave then
			--获取怪物位置信息，写成通用逻辑
			if self.logicName then
				pos = BehaviorFunctions.GetTerrainPositionP(v.posName, self.mapId, self.logicName)
				rot = BehaviorFunctions.GetTerrainRotationP(v.posName, self.mapId, self.logicName)
			else
				pos = BehaviorFunctions.GetTerrainPositionP(v.posName, self.levelId)
				rot = BehaviorFunctions.GetTerrainRotationP(v.posName, self.levelId)
			end
			--创建怪物，从self.monsterList中获取信息
			v.instanceId = BehaviorFunctions.CreateEntity(v.entityId, nil, pos.x, pos.y, pos.z, nil, nil, nil, self.levelId)
			--print("创建实体")
			BehaviorFunctions.SetEntityEuler(v.instanceId,rot.x,rot.y,rot.z)
			self.currentWaveNum = self.currentWaveNum + 1	--根据怪物列表的信息，记录创建怪物的数量
			--看向npc
			BehaviorFunctions.DoLookAtTargetImmediately(v.instanceId, self.npc01)
			--如果要关闭警戒
			if not self.isWarn then
				BehaviorFunctions.SetEntityValue(v.instanceId,"haveWarn",false)   --关闭警戒
			end
		end
		-- --设置该波的看向点
		-- if not self.currentWaveLookAtPos then
		-- 	self.currentWaveLookAtPos = pos
		-- end
	end
	self.missionState = self.missionState + 1
	--self:SetLevelCamera()			肉鸽暂时不创建转向相机
end

----npc受伤函数
function LevelBehavior404010601:FirstCollide(attackInstanceId,hitInstanceId,instanceId)
	--print("进入受伤函数")
	--and attackInstanceId == self.monsterList[i].Id
	--播受击动作
	if self.animation == false then
		if hitInstanceId == self.npc01 then
			local R = BehaviorFunctions.RandomSelect(1,2,3)
			if R == 1 then
				self.choose = "Afraid"
			elseif R == 2 then
				self.choose ="Bhit"
			elseif R == 3 then
				self.choose ="Fhit"
			end
			--self.beforePos = BehaviorFunctions.GetPositionP(self.hurtnpc)
			--self.beforelookPos = BehaviorFunctions.GetPositionOffsetBySelf(self.hurtnpc,10,0)
			--BehaviorFunctions.DoLookAtTargetImmediately(self.hurtnpc,self.role)
			BehaviorFunctions.PlayAnimation(self.npc01,self.choose)
			-- self.aniFrame = BehaviorFunctions.GetEntityAnimationFrame(self.hurtnpc,self.choose)
			-- --BehaviorFunctions.PlayAnimation(self.hurtnpc,"Afraid_loop")
			-- self.aniTime = BehaviorFunctions.GetFightFrame()
			self.animation = true
			--print("受伤动画播放完毕")
		end
	end
end

--卸载内容
function LevelBehavior404010601:Leave()
	--移除相机
	BehaviorFunctions.RemoveEntity(self.levelCam)
	BehaviorFunctions.RemoveEntity(self.empty)
	--移除怪物
	if next(self.monsterList) ~= nil then
		for i,v in ipairs(self.monsterList) do
			if v.Id then
				BehaviorFunctions.RemoveEntity(v.Id)
			end
		end
	end
	self.monsterList = {
		[1] = {Id = nil , state = self.monsterStateEnum.Default ,posName = "mon11" ,wave = 1 ,lev = 0 ,isDead = false ,entityId = self.monsterentityid},  --1猎手
		[2] = {Id = nil , state = self.monsterStateEnum.Default ,posName = "mon12" ,wave = 1 ,lev = 0 ,isDead = false ,entityId = self.monsterentityid},  --1猎手
		[3] = {Id = nil , state = self.monsterStateEnum.Default ,posName = "mon13" ,wave = 1 ,lev = 0 ,isDead = false ,entityId = self.monsterentityid},  --1猎手
	}
	self.dieCount = 0
	self.allDie = false
	self.missionState = 0
	self.Over = false
	self.animation = false
	BehaviorFunctions.HideTip(30000010)
	BehaviorFunctions.HideTip(32000007)
end

-- --关卡结束函数
-- function LevelBehavior404010601:LevelFinish()
--     BehaviorFunctions.Victory()
-- end

--设置攻击目标
function LevelBehavior404010601:ChangeTarget(monsterList)
	for i,v in ipairs(monsterList) do
		if v.state == self.monsterStateEnum.Live then
			if BehaviorFunctions.CheckEntity(self.npc01) then
				BehaviorFunctions.SetEntityValue(monsterList[i].Id,"battleTarget",self.npc01)
			end
		end
	end
end

--关卡胜利表现
function LevelBehavior404010601:Victory()
	if self.tipsstate == true then
		BehaviorFunctions.ShowCommonTitle(8,"已清除城市威胁",true)
		--print("清除城市威胁")
	end

	self:LevelLookAtPos("npc",self.mapname,22002)
	-- --相机转向相关内容 ↓----------
	-- --创建镜头
	-- self.levelCam = BehaviorFunctions.CreateEntity(22001)
	-- BehaviorFunctions.CameraEntityFollowTarget(self.levelCam,self.role,"CameraTarget")
	-- --看向目标
	-- BehaviorFunctions.CameraEntityLockTarget(self.levelCam,self.npc01)
	-- BehaviorFunctions.DoLookAtTargetImmediately(self.role,self.npc01)
	-- --延时移除目标和镜头
	-- BehaviorFunctions.AddDelayCallByFrame(45,BehaviorFunctions,BehaviorFunctions.RemoveEntity,self.levelCam)
	-- BehaviorFunctions.AddDelayCallByFrame(45,BehaviorFunctions,BehaviorFunctions.RemoveEntity,self.empty)
	-- --print("成功镜头朝向npc")
	-- --相机转向相关内容 ↑----------

	--隐藏气泡对话
	BehaviorFunctions.SetNonNpcBubbleVisible(self.npc01,false)
	BehaviorFunctions.AddDelayCallByTime(3,BehaviorFunctions,BehaviorFunctions.HideTip,30000010)

	--移除恐惧表演
	BehaviorFunctions.PlayAnimation(self.npc01,"Squat_out")
	--print("移除恐惧表演")

	--播对话
	BehaviorFunctions.DoLookAtTargetImmediately(self.npc01,self.role)
	BehaviorFunctions.AddDelayCallByTime(2,BehaviorFunctions,BehaviorFunctions.StartStoryDialog,601010701)
	--("npc播放感谢对话")

	self.npcvictory = true
end

--关卡失败表现
function LevelBehavior404010601:Fail()
	BehaviorFunctions.HideTip(32000007) --隐藏敌人数量的tips
	BehaviorFunctions.SetRoguelikeEventCompleteState(self.eventId,false)
	self.missionState = 999 --由于与后端有关，只告诉服务端一次就好
	self:Leave()
end

--相机函数
function LevelBehavior404010601:LevelLookAtPos(pos,logic,type,bindTransform)
	local fp1 = BehaviorFunctions.GetTerrainPositionP(pos,self.levelId,logic)
	self.empty = BehaviorFunctions.CreateEntity(2001,nil,fp1.x,fp1.y,fp1.z,nil,nil,nil,self.levelId)
	self.levelCam = BehaviorFunctions.CreateEntity(type,nil,nil,nil,nil,nil,nil,nil,self.level)
	--立刻朝向目标点
	BehaviorFunctions.DoLookAtTargetImmediately(self.role,self.empty)
	if bindTransform then
		BehaviorFunctions.CameraEntityFollowTarget(self.levelCam,self.role,bindTransform)
	else
		BehaviorFunctions.CameraEntityFollowTarget(self.levelCam,self.role)
	end
	BehaviorFunctions.CameraEntityLockTarget(self.levelCam,self.empty)
end

---------------------回调----------------------------------
--结尾对话播放完毕
function LevelBehavior404010601:StoryEndEvent(dialogId)
	if dialogId == 601010701 then
		--print("感谢对话播放完毕")
		self.npcend = true
	end
end

--死亡回调
function LevelBehavior404010601:Death(instanceId,isFormationRevive)
	if isFormationRevive then
		self:Fail()
	--	print("角色死亡")
	end
	for i, v in pairs(self.monsterList) do
		if instanceId == v.instanceId and v.isDead == false then
			self.deathCount = self.deathCount + 1
			v.isDead = true
			---死亡计数器
			local totalMonster = #self.monsterList - self.deathCount
			BehaviorFunctions.ChangeSubTipsDesc(1,32000007,totalMonster)
			-- print("走完死亡计数")
			if self.deathCount == self.currentWaveNum then
				--该波怪物全死
				self.currentWaveAllDie = true
				--参数复原
				self.currentWaveNum = 0
				self.currentWaveLookAtPos = nil
				self.deathCount = 0
				--("怪物死亡")
			end
		end
	end
end

--任务前置肉鸽追踪指标，以封装函数，不管
function LevelBehavior404010601:RogueGuidePointer(guidePos,guideDistance,guideType)
	local playerPos = BehaviorFunctions.GetPositionP(self.role)
	local distance = BehaviorFunctions.GetDistanceFromPos(playerPos,guidePos)
	if distance <= guideDistance then
		if not self.guide then
			self.guideEntity = BehaviorFunctions.CreateEntity(2001,nil,guidePos.x,guidePos.y,guidePos.z,nil,nil,nil,self.levelId)
			self.guide =BehaviorFunctions.AddEntityGuidePointer(self.guideEntity,guideType,0,false)
		end
	else
		--移除追踪标空实体
		if self.guideEntity and BehaviorFunctions.CheckEntity(self.guideEntity) then
			BehaviorFunctions.RemoveEntity(self.guideEntity)
			self.guideEntity = nil
		end
		--移除追踪标
		BehaviorFunctions.RemoveEntityGuidePointer(self.guide)
		self.guide = nil
	end
end

----随机获取怪物，并播放攻击动画--函数
function LevelBehavior404010601:GetRandomAliveMonster()
    local aliveMonsters = {}
    -- 筛选出活着的怪物
    for i, v in pairs(self.monsterList) do
        if v.instanceId and not v.isDead then
            table.insert(aliveMonsters, v)
        end
    end
    -- 如果没有活着的怪物，则返回 nil
    if #aliveMonsters == 0 then
        return nil
    end
    -- 随机选择一个活着的怪物
    local randomIndex = math.random(1, #aliveMonsters)
    return aliveMonsters[randomIndex]
end
function LevelBehavior404010601:MakeRandomMonsterAttack()
    local monster = self:GetRandomAliveMonster()
    if monster then
        BehaviorFunctions.PlayAnimation(monster.instanceId, "Attack001")
    end
end