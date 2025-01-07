LevelBehavior200509002 = BaseClass("LevelBehavior200509002",LevelBehaviorBase)
--关卡测试关
function LevelBehavior200509002:__init(fight)
	self.fight = fight
end


function LevelBehavior200509002.GetGenerates()
	local generates = {8011001,8011002,8011003,8011004,8011009,8011010,8011011,8011012,
						8010001,8010002,8010003,8010004,8010005,8010006,8010007,8010008,8010009,8010010,
						900070,900071,203041301,790007000,790007100,790010200,790014000}
	return generates
end

function LevelBehavior200509002.GetMagics()
	local generates = {200000017}
	return generates
end

function LevelBehavior200509002:Init()
	--通用参数---------------------------------------------------------------------------------------------------------------------
	self.role = nil --当前操控角色
	self.ecoReward = nil --奖励空实体的生态id
	self.reward = nil --奖励空实体的实例id
	self.groupMe = {} --自己和采集物的生态组
	self.groupNPC = {} --npc的生态组
	self.allFresh = false
	
	self.missionState = 0 --副本内的关卡状态
	self.missionStateEnum = {default = 0, start = 1, ongoing = 2, success = 3, fail = 4} --副本内的关卡状态枚举
	
	self.startMail = false --是否开始拦截短信
	self.mailStartFrame = 0 --开始播放短信的帧数
	self.mailEndFrame = 0 --短信结束播放的帧数
	self.frame = nil --游戏帧数
	self.showStart = false --是否开始表演
	self.showFinish = false --是否表演完成
	self.henshinStartNext = nil --开始变身的时间
	self.henshinFinish = false 
	self.blackStart = false --开始黑幕
	self.disPolice = 0

	self.levelStart = false --是否已经开始玩法
	self.levelSearch = false --是否已经进入搜索环节
	self.levelBattle = false --是否已经进入战斗
	
	self.bubbleFrameNext = nil --警察npc下次播放气泡的时间
	self.bubbleFrameCD = 3000 --警察npc奇葩刷新的cd
	
	self.npcFrameNext = 0 --npc循环表演的总帧数
	self.npcShowInFrame = 0 --npc表演的进入动作的帧数
	self.npcShowLoopFrame = 0
	self.npcShowEndFrame = 0 --npc结束表演的动作的帧数
	self.npcShowing = false
	self.npcShowingLoop = false
	self.npcShowingEnd = false
	
	self.findMon = false --是否找到怪物
	self.monDead = false --怪物是否死亡
	self.monTag = nil --怪物的当前标签
	self.battleDialogStart = false --是否开始战斗对话
	self.battleDialogFinish = false --战斗对话结束
	self.endDialogStart = false 
	self.endDialogFinish = false
	
	self.interact = nil --交互按钮
	self.interactPolice = nil
	self.npcShowAniNum = 0
	
	self.monsterNPCShowAni = false
	
	self.startTitleShowFrameNext = 0
	self.startTipShowFrameNext = 0
	self.startTip1ShowFrameNext = 0 --开始关卡的横幅出现的帧数
	self.startTitleShowFrameCD = 50
	self.startTipShowFrameCD = 0
	self.startTip1ShowFrameCD = 0 --开始关卡的横幅延迟出现的帧数
	self.startTitleShow = false
	self.startTipShow = false
	self.startTip1Show = false
	self.startTip = nil
	self.startEndTip = nil
	
	self.searchTitleShowFrameNext = 0
	self.searchTipShowFrameNext = 0
	self.searchTitleShowFrameCD = 0
	self.searchTipShowFrameCD = 0
	self.searchTitleShow = false
	self.searchTipShow =  false
	self.searchTip = nil
	
	self.battleTitleShowFrameNext = 0
	self.battleTipShowFrameNext = 0
	self.battleTitleShowFrameCD = 0
	self.battleTipShowFrameCD = 30
	self.battleTitleShow = false
	self.battleTipShow = false
	self.battleTip = nil
	
	self.endTitleFrameNext = 0
	self.endTitleFrameCD = 60
	self.endTitleShow = false
	
	self.levelEndFrameNext = 0
	self.levelEndFrameCD = 60
	self.levelEndShow = false
	
	self.textFrameNext = 0
	self.textFrameCD = 150
	self.textFrameShow = false
	
	self.npcRunFrameNext = 0 --npc跑开结束的帧数
	self.npcRunFrameCD = 60 --npc奔跑持续的时间
	self.npcRunStart = false --npc是否开始奔跑
	self.npcRunFinish = false --npc奔跑结束
	
	self.henshinFrameNext = 0
	self.henshinFrameCD = 20
	self.henshinWait = false
	self.henshinWaitStart = false
	self.henshinWaitEnd = false
	
	self.tip = nil
	self.enemyNum = 0

	self.battleShow = false 
		
	self.startDialogStart = false
	self.startDialogEnd = false
	
	self.posPoliceDefault = nil
	
	self.endSet =false
	self.findTitleShow = false
	
	self.phoneInvisible = false
	self.phoneInvisibleFrameNext = 0
	self.phoneInvisibleFrameCD = 60
	self.phoneInvisibleHit = false
	
	self.removeNpc = 0
	
	--需要配置的内容---------------------------------------------------------------------
	self.startDialog = 602170101 --开始玩法的对话
	self.battleDialog = 602170201 --开始战斗的对话
	self.endDialog = 602170301 --结束玩法的对话
	self.policeAskDialog =602170102 --npc表示请求的对话
	self.monsterShowDialog = 602170202 --怪物不演了的对话
	
	self.ecoMe = 2003001092021 --自己生态id
	self.police = {id = nil, pos = nil,ecoId = nil, ecoPos = "police" , entity = 8011011,bubble1 = "觉醒者，帮帮忙！", bubble2 = "如果能骇入的话..."} --警察参数
	--怪物参数，只需要填怪物实体id即可
	self.monster = {id = nil, pos = nil, rot = nil, entity = 790007100, npcEntity = nil, ecoId = nil,ecoPos = "mon1", henshin = false} --怪物参数
	self.npc = {
		[1] = {id = nil, pos = nil, rot = nil, entity = 8011001, isEnemy = false,ecoId = 5003001092021,ecoPos = "npc1"},
		[2] = {id = nil, pos = nil, rot = nil, entity = 8011002, isEnemy = false,ecoId = 5003001092022,ecoPos = "npc2"},
		[3] = {id = nil, pos = nil, rot = nil, entity = 8011003, isEnemy = false,ecoId = 5003001092023,ecoPos = "npc3"},
		[4] = {id = nil, pos = nil, rot = nil, entity = 8010004, isEnemy = false, ecoId = 5003001092025,ecoPos = "npc5"},
		[5] = {id = nil, pos = nil, rot = nil, entity = 8010004, isEnemy = true,ecoId = 5003001092026,ecoPos = "npc6"},
		
	}
	
	self.npcRandomBubble = {
		"救命啊！",
		"快逃命啊！",
		"救救我！",
		"快报警！"
		}
	
	self.interactRadius = 2.5 --出现与警察的交互按钮的距离
	self.guidePointerLimit = 10 --多近的时候移除引导图标

	self.npcShowRadius = 50 --开始触发玩法的距离
	self.npcCreateRadius = 90 --出现提示“附近有骇入揭露玩法”的距离
	
	self.policeTalkAni = "Sbaoxiong_in" --警察开始谈话的动作
	self.npcFightAni = "Squat_loop"
	self.mailCd = 240 --短信显示的时间，可以用来做自动退出骇入的逻辑
	self.showFrameCd = 10 --开始战斗后，怪物登场表演需要的帧数
	
	--开始玩法前，npc对玩家招手
	self.npcShowState = {aniIn = "Jushou_in",aniLoop = "Jushou_loop",aniEnd = "Jushou_end"}
	self.npcShowInFrameCD = 60 --npc举手in的动作帧数
	self.npcShowLoopFrameCD = 30 --npc举手in的动作帧数
	self.npcShowEndFrameCD = 50 --npc举手end的动作帧数
	self.npcFrameCD = 40 --npc循环播放动作的间隔
	
	--开始玩法后，npc的动作更换
	self.npcStartState = {aniIn = "Fue_in",aniLoop = "Fue_loop",aniEnd = "Fue_end"}
	self.npcStartInFrameCD = 45 --npc扶额in的动作帧数
	self.npcStartLoopFrameCD = 60 --npc扶额in的动作帧数
	self.npcStartEndFrameCD = 40 --npc扶额end的动作帧数
	self.npcStartFrameCD = 30 --npc循环播放动作的总帧数
	
	------------------------------------------------------------------------------------
	--通用行为树
	self.LevelCommon = BehaviorFunctions.CreateBehavior("LevelCommonFunction",self) --创建关卡通用行为树
	self.LevelCommon.levelId = self.levelId --将关卡ID赋值给关卡通用行为树
	self.monsterList = {{id = self.monster.entity,posName = self.monster.ecoPos, wave = 1}}
	self.monsterListNow = nil
end

function LevelBehavior200509002:Update()
	self.role = BehaviorFunctions.GetCtrlEntity() --获得当前操控角色
	self.frame = BehaviorFunctions.GetFightFrame() --获取当前游戏帧数
	self.LevelCommon:Update() --执行关卡通用行为树的每帧运行
	self.state = BehaviorFunctions.GetEcoEntityState(self.ecoMe)
	
	if self.state == 0 then
		--关卡初始状态，获得npc属性状态
		if self.missionState == 0 then--------------------------------------------------------------------------------------------------------------------------------------
			--创建警察
			if self.police.id == nil then
				self.police.pos = BehaviorFunctions.GetTerrainPositionP(self.police.ecoPos,self.levelId) --获得位置
				--创建警察
				if self.police.pos then
					self.police.id = BehaviorFunctions.CreateEntityByPosition(self.police.entity, nil,self.police.ecoPos ,nil, self.levelId,self.levelId)
					self.posPoliceDefault = BehaviorFunctions.GetPositionP(self.police.id)
					--气泡
					BehaviorFunctions.ShowCharacterHeadTips(self.police.id,true) --气泡的前置设置
					self.bubbleFrameNext = self.frame + self.bubbleFrameCD --计算出下次显示气泡的时间
					BehaviorFunctions.AddDelayCallByFrame(1,BehaviorFunctions,BehaviorFunctions.ChangeNpcBubbleContent,self.police.id,self.police.bubble1,self.bubbleFrameCD)
					BehaviorFunctions.AddDelayCallByFrame(1,BehaviorFunctions,BehaviorFunctions.SetNonNpcBubbleVisible,self.police.id,true)

					--创建出警察npc之后，设置初始配置
					if self.police.id then
						if BehaviorFunctions.CheckEntity(self.police.id) then
							--给警察增加buff，暂停逻辑
							BehaviorFunctions.AddBuff(self.police.id,self.police.id,200000017)
							BehaviorFunctions.AddBuff(self.police.id,self.police.id,200000018)

							--关闭交互按钮
							BehaviorFunctions.SetEntityWorldInteractState(self.police.id, false)
							--增加头顶显示图标
							--BehaviorFunctions.AddDelayCallByFrame(1,BehaviorFunctions,BehaviorFunctions.ChangeNpcHeadIcon,self.police.id, "Textures/Icon/Single/FuncIcon/Map_badguy.png")
							BehaviorFunctions.SetEntityHackEffectIsTask(self.police.id,true)
						end

					end
				end
			end

			--获得奖励空实体的ecoId
			if next(self.groupMe) == nil or self.ecoReward == nil then
				self.groupMe = BehaviorFunctions.GetEcoEntityGroup(nil,self.ecoMe,nil)
				if next(self.groupMe) ~= {} then
					for i, v in pairs(self.groupMe) do
						if v.ecoId ~= self.ecoMe then
							self.ecoReward = v.ecoId
						end
					end
				end
			end

			--判断所有的npc是否刷新出来
			if self.allFresh == true then
				self:CheckNPC(self.npc)
			end

			--判断警察是否刷新出出来
			if self.police.id then
				if BehaviorFunctions.CheckEntity(self.police.id) then
				else
					self.police.id =nil
				end
			end

			--获得npc的初始配置
			if self.allFresh == false then
				for i = 1, #self.npc do
					--获得npc数据
					if self.npc[i].isEnemy == false then
						if self.npc[i].id == nil then
							local npcEntity = BehaviorFunctions.GetNpcEntity(self.npc[i].ecoId)
							if npcEntity ~= nil then
								self.npc[i].id = BehaviorFunctions.GetNpcEntity(self.npc[i].ecoId).instanceId
								BehaviorFunctions.ShowCharacterHeadTips(self.npc[i].id,false) --气泡的前置设置
								BehaviorFunctions.SetEntityHackEffectIsTask(self.npc[i].id,true)
							end
						end
						--获得npc的怪物数据
					else
						--获取npc的instance实体
						local monsterEntity = BehaviorFunctions.GetNpcEntity(self.npc[i].ecoId)
						if monsterEntity then
							self.monster.id = monsterEntity.instanceId
							self.npc[i].id = monsterEntity.instanceId
							BehaviorFunctions.ShowCharacterHeadTips(self.monster.id,false) --气泡的前置设置
						else
							self.monster.id = nil
						end

						--给npc的变量赋值和进行初始设置
						if self.monster.id then
							self.monster.pos = BehaviorFunctions.GetPositionP(self.monster.id)
							self.monster.ecoId = self.npc[i].ecoId
							--self.monster.ecoPos = self.npc[i].ecoPos
							self.monster.npcEntity = self.npc[i].entity
							BehaviorFunctions.SetNpcMailState(self.monster.id,true) --设置成正在发短信的状态
							--BehaviorFunctions.PlayAnimation(self.monster.id,"TextStand_loop",FightEnum.AnimationLayer.PerformLayer)
							BehaviorFunctions.SetEntityHackInformation(self.monster.id,"神秘人","Textures/Icon/Single/HeadIcon/SquRWeizhirenyuan.png","访问指令被拒绝") --修改駭入信息
							BehaviorFunctions.PlayAnimation(self.monster.id,"TextStand_loop",FightEnum.AnimationLayer.BaseLayer)
							BehaviorFunctions.AddBuff(self.monster.id,self.monster.id,200000017)
							BehaviorFunctions.SetEntityHackEffectIsTask(self.npc[i].id,true)
						end
					end

					--npc数据获得完毕之后，进行初始设置
					if self.npc[i].id then
						if BehaviorFunctions.CheckEntity(self.npc[i].id) then
							--增加buff，防止npc被打跑
							--BehaviorFunctions.AddBuff(self.npc[i].id,self.npc[i].id,200000017)
							--BehaviorFunctions.AddBuff(self.npc[i].id,self.npc[i].id,200000018)
							--删除npc的互动键
							BehaviorFunctions.SetEntityWorldInteractState(self.npc[i].id, false)

							--关闭骇入按钮
							if self.levelStart == false then
								BehaviorFunctions.SetEntityHackEnable(self.npc[i].id,false)
							end

							if i == #self.npc then
								self.allFresh = true
							end
						end
					end
				end
			end

			--获得怪物npc的数据之后，进行初始设置
			if self.monster.id then
				if BehaviorFunctions.CheckEntity(self.monster.id) then


					if self.frame > self.textFrameNext then
						self.textFrameNext = self.frame + self.textFrameCD
						BehaviorFunctions.SetNpcMailState(self.monster.id,true) --设置成正在发短信的状态
						BehaviorFunctions.PlayAnimation(self.monster.id,"TextStand_loop",FightEnum.AnimationLayer.BaseLayer)

					end
				else
					self.monster.id = nil
				end

			end

			--给警察npc增加交互组件、气泡等信息
			if self.police.id and self.role then
				if BehaviorFunctions.CheckEntity(self.police.id) then
					self.disPolice = BehaviorFunctions.GetDistanceFromTargetWithY(self.role, self.police.id) --获得角色与怪物npc之间的距离

					--根据距离增加交互对话
					if self.disPolice < self.interactRadius and self.levelStart == false then
						if self.interactPolice == nil then
							--增加交互组件
							self.interactPolice = BehaviorFunctions.WorldInteractActive(self.role,WorldEnum.InteractType.Talk,nil,"询问",1)
						end
					elseif self.interactPolice then
						BehaviorFunctions.WorldInteractRemove(self.role,self.interactPolice)
						self.interactPolice = nil
					end

					--如果进入npc相关的距离,进行相关设置
					if self.disPolice < self.npcShowRadius then
						if self.levelStart == false then
							--根据距离判断是否要看向玩家
							BehaviorFunctions.DoLookAtTargetImmediately(self.police.id,self.role)
						else
						end

						if self.findTitleShow == false then
							self.findTitleShow = true
							--BehaviorFunctions.ShowCommonTitle(8,"发现骇入揭露事件！")
						end


						----增加图标引导
						--if self.guidePointer == nil then
						--self.guidePointer = BehaviorFunctions.AddEntityGuidePointer(self.police.id,12,0,false,self.guidePointerLimit)
						----BehaviorFunctions.ShowCommonTitle(8,"发现骇入揭露事件！")
						--end
					else
						--if self.guidePointer then
						--BehaviorFunctions.RemoveEntityGuidePointer(self.guidePointer)
						--self.guidePointer = nil
						--end

						if self.findTitleShow == true then
							self.findTitleShow = false
						end
					end

					--if self.disPolice > self.npcCreateRadius then
					--if self.police then
					--if BehaviorFunctions.CheckEntity(self.police.id) then
					--BehaviorFunctions.RemoveEntity(self.police.id)
					--self.police.id = nil
					--end
					--end
					--end

					--警察循环播放动作
					if self.levelStart == false then
						if self.startDialogStart == false then
							--非对话时，npc循环播放挥手动作
							self:PlayAnimationHuishou(self.police.id,self.npcShowState,true,self.npcFrameCD,self.npcShowInFrameCD,self.npcShowLoopFrameCD,self.npcShowEndFrameCD)
						end

					else
						--对话开启玩法后
						self:PlayAnimationHuishou(self.police.id,self.npcStartState,true,self.npcFrameCD,self.npcStartInFrameCD,self.npcStartLoopFrameCD,self.npcStartEndFrameCD)
					end

				end

				--根据帧数，重新增加气泡
				if self.levelStart == false then
					if self.frame > self.bubbleFrameNext then
						self.bubbleFrameNext = self.frame + self.bubbleFrameCD
						BehaviorFunctions.AddDelayCallByFrame(1,BehaviorFunctions,BehaviorFunctions.ChangeNpcBubbleContent,self.police.id,self.police.bubble1,self.bubbleFrameCD)
						BehaviorFunctions.AddDelayCallByFrame(1,BehaviorFunctions,BehaviorFunctions.SetNonNpcBubbleVisible,self.police.id,true)

					end
				else
					if self.frame > self.bubbleFrameNext then
						self.bubbleFrameNext = self.frame + self.bubbleFrameCD
						BehaviorFunctions.AddDelayCallByFrame(1,BehaviorFunctions,BehaviorFunctions.ChangeNpcBubbleContent,self.police.id,self.police.bubble2,self.bubbleFrameCD)
						BehaviorFunctions.AddDelayCallByFrame(1,BehaviorFunctions,BehaviorFunctions.SetNonNpcBubbleVisible,self.police.id,true)
					end
				end

			end

			--增加关卡相关提示
			--判断是否是初次对话，如果是初次对话则增加提示，直接开启任务
			if self.levelStart then
				----标题
				--if self.frame > self.startTitleShowFrameNext and self.startTitleShow == false then
				--self.startTitleShow = true
				--BehaviorFunctions.ShowCommonTitle(4,"玩法开始")
				--end
				--侧边任务栏
				if self.frame > self.startTipShowFrameNext and self.startTipShow == false then
					self.startTipShow = true
					self.startTip = BehaviorFunctions.AddLevelTips(200509001,self.levelId)
					if self.startTip then
						BehaviorFunctions.ChangeLevelSubTips(self.startTip,1,0)
					end

				end
				--横幅
				if self.frame > self.startTip1ShowFrameNext and self.startTip1Show == false then
					self.startTip1Show = true
					--BehaviorFunctions.AddLevelTips(200509002,self.levelId)
					BehaviorFunctions.ShowCommonTitle(10,"通过骇入寻找坏人")
				end
			end

			--当骇入敌人角色，就证明找到了怪物，进入下一阶段
			if self.findMon == true then
				self.missionState = 1 --成功找到了怪物
			end
			--成功找到怪物,此时开始播放拦截短信的内容，自动进入战斗---------------------------------------------------------------------------------------------------------------------------
		elseif self.missionState == 1 then
			self.dis = BehaviorFunctions.GetDistanceFromTarget(self.monster.id,self.role)
			--移除警察的交互组件
			if self.interactPolice then
				BehaviorFunctions.WorldInteractRemove(self.role,self.interactPolice)
				self.interactPolice = nil
			end

			--检测帧数，自动退出骇入
			if self.frame > self.mailEndFrame and self.startMail == true then
				self.startMail = false --结束短信播放，播放战斗对话
				if self.levelSearch == false then
					self.levelSearch = true
					self.searchTitleShowFrameNext = self.frame + self.searchTitleShowFrameCD
					self.searchTipShowFrameNext = self.frame + self.searchTipShowFrameCD
				end
				BehaviorFunctions.ExitHackingMode()
			end

			--添加tips等关卡提示
			if self.battleDialogStart == false then
				if self.levelSearch == true then
					if self.frame > self.searchTitleShowFrameNext and self.searchTitleShow == false then
						self.searchTitleShow = true
						--BehaviorFunctions.AddLevelTips(200509004,self.leveiId)
						BehaviorFunctions.ShowCommonTitle(10,"靠近并指认坏人")
					end

					if self.frame > self.searchTipShowFrameNext and self.searchTipShow == false then
						self.searchTipShow = true
						if self.startEndTip then
							BehaviorFunctions.RemoveLevelTips(self.startEndTip)
							self.startEndTip = nil
						end

						if self.startTip then
							BehaviorFunctions.RemoveLevelTips(self.startTip)
							self.startTip = nil
						end

						self.searchTip = BehaviorFunctions.AddLevelTips(200509003,self.levelId)
						BehaviorFunctions.ChangeLevelSubTipsState(self.searchTip,1,false)
					end

				end
			end

			--在没有进行战斗对话的时候，根据距离判断是否增加“指认敌人”的互动按钮
			if self.battleDialogStart == false then
				if self.dis < 3 then
					if self.interact == nil then
						--修改npc的交互组件——敌人可以被交互
						if self.monster.id then
							self.interact = BehaviorFunctions.WorldInteractActive(self.role,WorldEnum.InteractType.Talk,nil,"指认罪犯",1)
							--BehaviorFunctions.PlayAnimation(self.monster.id,"Motou_loop",FightEnum.AnimationLayer.PerformLayer)
						end
					end
				elseif self.interact then
					BehaviorFunctions.WorldInteractRemove(self.role,self.interact)
					self.interact = nil
				end
			end

			--开始战斗对话的时候根据帧数决定是否要隐藏npc的手机
			if self.battleDialogStart and self.battleDialogFinish == false then
				if self.frame > self.phoneInvisibleFrameNext and self.phoneInvisible == false then
					BehaviorFunctions.SetEntityBineVisible(self.monster.id,"Phone",false)
					self.phoneInvisible = true
				end
			end


			--播放完战斗对话，进入表演阶段
			if self.battleDialogFinish then
				--self.frameNext = self.frame + self.showFrameCd --计算表演需要的帧数
				--self.henshinStartNext = self.frame

				--移除引导图标
				if self.guidePointer then
					BehaviorFunctions.RemoveEntityGuidePointer(self.guidePointer)
					self.guidePointer = nil
				end

				self.missionState = 2
			end
			--npc移除，怪物变身，进入表演------------------------------------------------------------------------------------------------------------------------------------------
		elseif self.missionState == 2 then

			--容错，移除交互按钮
			if self.interactPolice then
				BehaviorFunctions.WorldInteractRemove(self.role,self.interactPolice)
				self.interactPolice = nil
			end
			if self.interact then
				BehaviorFunctions.WorldInteractRemove(self.role,self.interact)
				self.interact = nil
			end

			--移除npc，创建怪物，npc进入抱头蹲防
			if self.henshinFinish == false then
				--移除npc，创建怪物
				if self.monster.henshin == false and self.monster.id then
					BehaviorFunctions.SetEntityShowState(self.monster.id,false)
					self.monster.pos = BehaviorFunctions.GetPositionP(self.monster.id)
					--变身特效
					if self.monster.pos and self.fxChange == nil then
						--播放变身特效
						self.fxChange = BehaviorFunctions.CreateEntity(203041301,nil,self.monster.pos.x,self.monster.pos.y,self.monster.pos.z)
					end
					--BehaviorFunctions.ChangeEcoEntityCreateState(self.monster.ecoId,true)
					BehaviorFunctions.RemoveEntity(self.monster.id)
					self.monster.id = nil
					--让警察摆出蹲下的动作
					if self.police.id then
						if BehaviorFunctions.CheckEntity(self.police.id) then
							BehaviorFunctions.PlayAnimation(self.police.id,"Squat_loop",FightEnum.AnimationLayer.BaseLayer)
						end
					end


					self.monster.henshin = true
				elseif self.monster.henshin == true and self.monster.id == nil then
					--创建monster
					--self.monster.id = BehaviorFunctions.CreateEntity(self.monster.entity,nil,self.monster.pos.x,self.monster.pos.y,self.monster.pos.z,nil,nil,nil)
					--self.monster.id = BehaviorFunctions.CreateEntityByPosition(self.monster.entity, nil,self.monster.ecoPos ,nil, self.levelId,self.levelId)
					if self.monsterListNow == nil then
						self.monsterListNow = self.LevelCommon:LevelCreateMonster(self.monsterList)
					end
					if self.monsterListNow then
						if next(self.monsterListNow) then
							self.monster.id = self.monsterListNow.list[1].instanceId
						end
					end


					--气泡
					BehaviorFunctions.ShowCharacterHeadTips(self.monster.id,true)
					BehaviorFunctions.DoLookAtTargetImmediately(self.monster.id,self.role) --看向角色
					BehaviorFunctions.SetEntityValue(self.monster.id,"haveWarn",false) --关闭警戒
					--特殊镜头——看向怪物npc
					--self.cameraMon = self.LevelCommon:LevelCameraLookAtInstance(22002,30,nil,self.monster.id,"MarkCase",0)
					BehaviorFunctions.AddBuff(self.monster.id,self.monster.id,200000017)
					self.henshinFrameNext = self.frame + self.henshinFrameCD
					self.henshinWaitStart = true

					--让npc跑开
					for i = 1, #self.npc do
						if self.npc[i].id then
							if BehaviorFunctions.CheckEntity(self.npc[i].id) then
								if self.npc[i].isEnemy == false then
									--BehaviorFunctions.PlayAnimation(self.npc[i].id,"Squat_loop",FightEnum.AnimationLayer.BaseLayer)

									BehaviorFunctions.PlayAnimation(self.npc[i].id,"Run",FightEnum.AnimationLayer.BaseLayer)
									self.posRun = BehaviorFunctions.GetTerrainPositionP("run",self.levelId)
									BehaviorFunctions.DoLookAtPositionImmediately(self.npc[i].id,self.posRun.x,self.posRun.y,self.posRun.z,false)
									BehaviorFunctions.DoSetMoveType(self.npc[i].id,FightEnum.EntityMoveSubState.Run)
									--BehaviorFunctions.DoMoveForward(self.npc[i].id,1)

									BehaviorFunctions.AddBuff(self.npc[i].id,self.npc[i].id,200000017)

									if BehaviorFunctions.Random(0,2) > 0.3 then
										local randomNum = math.random(1,4)
										if randomNum > 1 then

											BehaviorFunctions.ShowCharacterHeadTips(self.npc[i].id,true) --气泡的前置设置

											BehaviorFunctions.AddDelayCallByFrame(1,BehaviorFunctions,BehaviorFunctions.ChangeNpcBubbleContent,self.npc[i].id,self.npcRandomBubble[randomNum],self.npcRunFrameCD)
											BehaviorFunctions.AddDelayCallByFrame(1,BehaviorFunctions,BehaviorFunctions.SetNonNpcBubbleVisible,self.npc[i].id,true)

										end
									end
								end
							end
						end
					end

					if self.npcRunStart == false then
						self.npcRunStart = true
						self.npcRunFrameNext = self.frame + self.npcRunFrameCD
					end

					BehaviorFunctions.ShowCharacterHeadTips(self.police.id,false) --气泡的前置设置
					--传送角色
					self.monRole = BehaviorFunctions.GetEntityPositionOffset(self.monster.id, 0, 0, 5)
					BehaviorFunctions.InMapTransport(self.monRole.x,self.monRole.y, self.monRole.z, false)

					self.henshinFinish = true
					--BehaviorFunctions.AddBuff(self.monster.id,self.monster.id,200000017)
				end
			end

			if self.levelBattle == true then
				if self.frame > self.battleTitleShowFrameNext  and self.battleTitleShow == false then
					self.battleTitleShow = true
					--BehaviorFunctions.ShowCommonTitle(4,"击败敌人！")
					--BehaviorFunctions.AddLevelTips(200509006,self.levelId) --增加tips
					BehaviorFunctions.ShowCommonTitle(10,"击败敌人！")
				end
				if self.frame > self.battleTipShowFrameNext and self.battleTipShow == false then
					self.battleTipShow = true
					if self.searchTip then
						BehaviorFunctions.RemoveLevelTips(self.searchTip)
						self.searchTip = nil
					end

					self.tip = BehaviorFunctions.AddLevelTips(200509005,self.levelId) --增加tips
					BehaviorFunctions.ChangeLevelSubTips(self.tip,1,self.enemyNum)
				end
			end


			if self.henshinWaitStart == true and self.henshinWait == false then
				if self.frame > self.henshinFrameNext and self.henshinWaitEnd == false then
					self.henshinWaitEnd = true
					self.henshinWait = true
				end
			end

			--表演结束，移除npc，关闭警戒状态
			if self.henshinFinish == true and self.monster.id and self.battleTipShow and self.battleTitleShow and self.henshinWait then
				if self.monster.id then
					if BehaviorFunctions.HasBuffKind(self.monster.id,200000017) then
						BehaviorFunctions.RemoveBuff(self.monster.id,200000017)
					end
					--开始战斗前的表现制作
					BehaviorFunctions.AddDelayCallByFrame(80,BehaviorFunctions,BehaviorFunctions.ChangeNpcBubbleContent,self.monster.id,"居然看穿了我的伪装，此子断不可留！",5)
					BehaviorFunctions.AddDelayCallByFrame(80,BehaviorFunctions,BehaviorFunctions.SetNonNpcBubbleVisible,self.monster.id,true)
					--BehaviorFunctions.ShowCommonTitle(4,"战斗开始")
					--BehaviorFunctions.AddLevelTips(200509002,self.levelId) --增加tips
				end

				self.missionState = 3
			end

			--表演结束，进入战斗--------------------------------------------------------------------------------------------------------------------------------------------------
		elseif self.missionState == 3 then

			--计算帧数，等npc跑出一段距离后移除npc
			if self.npcRunStart == true and self.npcRunFinish == false then
				if self.frame > self.npcRunFrameNext then
					for i = 1, #self.npc do
						if self.npc[i].id then
							if self.npc[i].isEnemy == false then
								if BehaviorFunctions.CheckEntity(self.npc[i].id) then
									--BehaviorFunctions.ChangeEcoEntityCreateState(self.npc[i].ecoId,true)
									BehaviorFunctions.SetEntityShowState(self.npc[i].id,false)
									BehaviorFunctions.DoSetMoveType(self.npc[i].id,FightEnum.EntityMoveSubState.None)
									BehaviorFunctions.RemoveEntity(self.npc[i].id)
									self.npc[i].id = nil
								end
							end
						end
					end
					self.npcRunFinish = true
				end
			end


			--当怪物死亡的时候，进入阶段4
			if  self.monDead == true then
				if self.frame > self.endTitleFrameNext and self.endTitleShow == false then
					self.endTitleShow = true
					BehaviorFunctions.ShowCommonTitle(5,"战斗胜利！",true)
					self.levelEndFrameNext = self.frame + self.levelEndFrameCD
					--BehaviorFunctions.ShowBlackCurtain(true,0.3,false)
					--BehaviorFunctions.AddDelayCallByFrame(50,BehaviorFunctions,BehaviorFunctions.ShowBlackCurtain,true,0.3,false)
					--BehaviorFunctions.AddDelayCallByFrame(60,BehaviorFunctions,BehaviorFunctions.ShowBlackCurtain,false,0.3,false)
					self.missionState = 4
				end

			end

			--结束战斗---------------------------------------------------------------------------------------------------------------------------------------------------
		elseif self.missionState == 4 then
			if self.frame > self.levelEndFrameNext then
				--移除tip
				if self.tip then
					BehaviorFunctions.RemoveLevelTips(self.tip)
					self.tip = nil
				end
				if self.endSet == false then
					self.endSet = true
					self.posRole = BehaviorFunctions.GetEntityPositionOffset(self.police.id, 0, 0, 2)
					if self.posRole then
						BehaviorFunctions.InMapTransport(self.posRole.x,self.posRole.y, self.posRole.z, false)
					end


					--for i = 1, #self.npc do
					--if self.npc[i].id then
					--if self.npc[i].isEnemy == false then
					--BehaviorFunctions.PlayAnimation(self.npc[i].id,"Squat_out",FightEnum.AnimationLayer.BaseLayer)
					--self.npc[i].id = nil
					--end
					--end
					--end
				end

				if self.police.id and self.endDialogStart == false then
					BehaviorFunctions.DoLookAtTargetImmediately(self.police.id,self.role)

					BehaviorFunctions.StartStoryDialog(self.endDialog)
					self.endDialogStart = true
					if self.police.id then
						self.cameraEnd = self.LevelCommon:LevelCameraLookAtInstance(22002,-1,nil,self.police.id,"CameraTarget",0)
					end
					

					BehaviorFunctions.PlayAnimation(self.police.id,"Jump",FightEnum.AnimationLayer.BaseLayer)
				end

				if self.endDialogFinish then
					self.frameRewardNext = self.frame + 60
					self.missionState = 5
				end
			end


			-------------------------------------------------------------------------------------------------------------------------------------------------------------
		elseif self.missionState == 5 then
			self.reward = BehaviorFunctions.GetEcoEntityByEcoId(self.ecoReward)
			if self.reward then
				BehaviorFunctions.InteractEntityHit(self.reward,false) --获得奖励
			end

			--BehaviorFunctions.ChangeEcoEntityCreateState(self.monster.ecoId, true)



			if self.blackStart == false then
				self.blackStart = true
				--BehaviorFunctions.ShowBlackCurtain(true,0,false)
				if self.police.id then
					BehaviorFunctions.RemoveEntity(self.police.id)
				end
				--BehaviorFunctions.AddDelayCallByFrame(10,BehaviorFunctions,BehaviorFunctions.ShowBlackCurtain,false,0.5,false)
			end


			for i = 1, #self.npc do
				if self.npc[i].id then
					--if self.npc[i].isEnemy == false then
					--BehaviorFunctions.ChangeEcoEntityCreateState(self.npc[i].id, true)
					--BehaviorFunctions.InteractEntityHit(self.npc[i].id,false)
					BehaviorFunctions.RemoveEntity(self.npc[i].id)
					self.npc[i].id = nil
					--end
				end
			end

			self.meEntity = BehaviorFunctions.GetEcoEntityByEcoId(self.ecoMe)
			BehaviorFunctions.SetEcoEntityState(self.ecoMe,1)
			--BehaviorFunctions.InteractEntityHit(self.meEntity,false)
			BehaviorFunctions.FinishLevel(self.levelId)
			--BehaviorFunctions.FinishLevel(self.levelId)
			self.missionState = 6

		end
	elseif self.state == 1 then
		if self.removeNpc < #self.npc then
			for i = 1, #self.npc do
				--获得npc数据

				if self.npc[i].id == nil then
					local npcEntity = BehaviorFunctions.GetNpcEntity(self.npc[i].ecoId)
					if npcEntity ~= nil then
						self.npc[i].id = BehaviorFunctions.GetNpcEntity(self.npc[i].ecoId).instanceId
					end
				end

				--npc数据获得完毕之后，进行初始设置
				if self.npc[i].id then
					if BehaviorFunctions.CheckEntity(self.npc[i].id) then
						BehaviorFunctions.RemoveEntity(self.npc[i].id)
						self.removeNpc = self.removeNpc + 1
					end
				end
			end
		end
	end
end

function LevelBehavior200509002:Die(attackInstanceId,dieInstanceId)
	if dieInstanceId == self.monster.id then
		self.monDead = true
		BehaviorFunctions.SetNonNpcBubbleVisible(self.monster.id,false)
		self.enemyNum = self.enemyNum + 1
		BehaviorFunctions.ChangeLevelSubTips(self.tip,1,self.enemyNum)
		BehaviorFunctions.ChangeLevelSubTipsState(self.tip,1,true)
		self.endTitleFrameNext = self.frame + self.endTitleFrameCD
	end
end


----死亡
--function LevelBehavior200509002:Death(instanceId,isFormationRevive)
	--if instanceId == self.monster.id then
		--self.monDead = true
		--BehaviorFunctions.SetNonNpcBubbleVisible(self.monster.id,false)
		--self.enemyNum = self.enemyNum + 1
		--BehaviorFunctions.ChangeLevelSubTips(self.tip,1,self.enemyNum)
	--end
--end

--与NPC互动
function LevelBehavior200509002:WorldInteractClick(uniqueId,instanceId)
	if uniqueId == self.interact then
		if self.battleDialog then
			BehaviorFunctions.StartStoryDialog(self.battleDialog)
			
		end
	end
	--与npc交互，触发谈话
	if uniqueId == self.interactPolice then
		if self.startDialog then
			BehaviorFunctions.StartStoryDialog(self.startDialog)
			BehaviorFunctions.DoLookAtTargetImmediately(self.police.id,self.role)
		end
	end
end

--对话开始
function LevelBehavior200509002:StoryStartEvent(dialogId)
	if self.state == 0 then
		--开始战斗的对话
		if dialogId == self.battleDialog then
			--移除交互按钮
			if self.interact then
				BehaviorFunctions.WorldInteractRemove(self.role,self.interact)
				self.interact = nil
			end
			if self.interactPolice then
				BehaviorFunctions.WorldInteractRemove(self.role,self.interactPolice)
				self.interactPolice = nil
			end

			if self.monster.id then
				--特殊镜头——看向怪物npc
				if self.disPolice then
					if self.disPolice < self.npcShowRadius then
						if self.monster.id then
							self.cameraMon = self.LevelCommon:LevelCameraLookAtInstance(22002,-1,nil,self.monster.id,"CameraTarget",0)
						end
						
					end
				end

				--播放npc的表现——切换成战斗待机动作
				if self.monster.id then
					BehaviorFunctions.PlayAnimation(self.monster.id,"TextStand_end",FightEnum.AnimationLayer.BaseLayer)
					if self.phoneInvisible == false then
						self.phoneInvisibleFrameNext = self.frame + self.phoneInvisibleFrameCD
					end

					--BehaviorFunctions.PlayAnimation(self.police.id,"Motou_loop",FightEnum.AnimationLayer.PerformLayer)
				end

				--Npc看向玩家
				if self.monster.id then
					BehaviorFunctions.DoLookAtTargetImmediately(self.monster.id,self.role)
				end
			end

			if self.searchTip then
				BehaviorFunctions.ChangeLevelSubTipsState(self.searchTip,1,true)
			end



			--切换参数，开始播放战斗短信
			self.battleDialogStart = true

			--与警察npc谈话
		elseif dialogId == self.startDialog then

			self.startDialogStart = true
			--npc动作相关的变量置零
			self.npcShowingEnd = false
			self.npcShowingLoop = false
			self.npcShowing = false
			self.npcFrameNext = 0

			BehaviorFunctions.PlayAnimation(self.police.id,self.policeTalkAni,FightEnum.AnimationLayer.BaseLayer)
			--警察npc的特殊镜头——审视嫌疑犯们
			if self.disPolice then
				if self.disPolice < self.npcShowRadius then
					if self.police.id then
						self.cameraPolice = self.LevelCommon:LevelCameraLookAtInstance(22002,-1,nil,self.police.id,"CameraTarget")
					end
					
				end
			end

		elseif dialogId == self.endDialog then
			--BehaviorFunctions.AddDelayCallByFrame(15,BehaviorFunctions,BehaviorFunctions.ShowBlackCurtain,false,0.5,false)

		end
	end

end

--对话结束
function LevelBehavior200509002:StoryEndEvent(dialogId)
	if self.state == 0 then
		if dialogId == self.battleDialog then
			self.battleDialogFinish = true
			self.levelBattle = true
			self.battleTitleShowFrameNext = self.frame + self.battleTitleShowFrameCD
			self.battleTipShowFrameNext = self.frame + self.battleTipShowFrameCD



			if self.cameraMon then
				self.LevelCommon:RemoveLevelCamera(self.cameraMon)
				self.cameraMon = nil
			end
		elseif dialogId == self.endDialog then
			if self.cameraEnd then
				self.LevelCommon:RemoveLevelCamera(self.cameraEnd)
				self.cameraEnd = nil
			end
			self.endDialogFinish = true
		elseif dialogId == self.startDialog then
			if self.cameraPolice then
				self.LevelCommon:RemoveLevelCamera(self.cameraPolice)
				self.cameraPolice = nil
				self.startDialogStart = false
			end
			if self.disPolice then
				if self.disPolice < self.npcShowRadius then
					--初次开始玩法的数据设置
					if self.levelStart == false then
						self.levelStart = true
						--计算各种tips提示的时间帧数
						self.startTitleShowFrameNext = self.frame + self.startTitleShowFrameCD
						self.startTipShowFrameNext = self.frame +self.startTipShowFrameCD
						self.startTip1ShowFrameNext = self.frame + self.startTip1ShowFrameCD
						--气泡时间归零，触发重置
						self.bubbleFrameNext = 0
						for i = 1, #self.npc do
							BehaviorFunctions.SetEntityHackEnable(self.npc[i].id,true)
						end

						if self.monster.id then
							BehaviorFunctions.SetEntityHackEnable(self.monster.id,true)
						end
					end
				end
			end

			self.startDialogEnd = true
			--看向人群
			BehaviorFunctions.DoLookAtTargetImmediately(self.police.id,self.monster.id)
		end
	end
	
end

--播放特定对话
function LevelBehavior200509002:StoryPassEvent(dialogId)
	if self.state == 0 then
		--如果播放警察的请求对话
		if dialogId == self.policeAskDialog then
			BehaviorFunctions.AddDelayCallByFrame(15,BehaviorFunctions,BehaviorFunctions.PlayAnimation,self.police.id,"Beishou_in",FightEnum.AnimationLayer.BaseLayer)
			BehaviorFunctions.PlayAnimation(self.police.id,"Sbaoxiong_end",FightEnum.AnimationLayer.BaseLayer)
			--如果播放揭露npc的对话
		elseif dialogId == self.monsterShowDialog then
			BehaviorFunctions.PlayAnimation(self.monster.id,"Stand2",FightEnum.AnimationLayer.BaseLayer)
			--隐藏手机
			BehaviorFunctions.SetEntityBineVisible(self.monster.id,"Phone",false)
			self.phoneInvisible = true
		end
	end
	
end


--拦截短信
function LevelBehavior200509002:HackingClickUp(instanceId)
	if instanceId == self.monster.id then
		self.mailStartFrame = BehaviorFunctions.GetFightFrame() --获得开始播放拦截短信的帧数
		self.mailEndFrame = self.mailStartFrame + self.mailCd --获得拦截短信结束的帧数
		self.findMon = true --已经找到了npc，进入下一个阶段
		self.startMail = true --开始播放拦截短信
		BehaviorFunctions.ChangeLevelSubTips(self.startTip,1,1)
		BehaviorFunctions.ChangeLevelSubTipsState(self.startTip,1,true)
		--BehaviorFunctions.RemoveLevelTips(self.startTip)
		--self.startEndTip = BehaviorFunctions.AddLevelTips(200509007,self.leveiId)
	end
end


--输入按键
function LevelBehavior200509002:KeyInput(key, status)
	if key == FightEnum.KeyEvent.QuitHack and status == FightEnum.KeyInputStatus.Down and self.startMail == true then
		self.startMail = false --结束短信播放，播放战斗对话
		if self.levelSearch == false then
			self.levelSearch = true
			self.searchTitleShowFrameNext = self.frame + self.searchTitleShowFrameCD
			self.searchTipShowFrameNext = self.frame + self.searchTipShowFrameCD
		end
	end
end


--检查npc生成状态
function LevelBehavior200509002:CheckNPC(npcList)
	if self.monster.id then
		if BehaviorFunctions.CheckEntity(self.monster.id) == false then
			self.allFresh = false
		end
	end
	
	
	if next(npcList) then
		for i = 1, #npcList do
			if npcList[i].id then
				if BehaviorFunctions.CheckEntity(npcList[i].id) == false then
					npcList[i].id = nil
					self.allFresh = false
					break
				end
			end
		end
	end
end




--播放动作
function LevelBehavior200509002:PlayAnimationHuishou(instanceId,ani,Loop,aniFrameCD,aniInFrameCD,aniLoopFrameCD,aniEndFrameCD)
	self.frame = BehaviorFunctions.GetFightFrame()

	if self.npcShowing == false then
		if self.frame >= self.npcFrameNext then
			--npc播放动作
			if instanceId then
				if BehaviorFunctions.CheckEntity(instanceId) then
					BehaviorFunctions.PlayAnimation(instanceId,ani.aniIn,FightEnum.AnimationLayer.BaseLayer)--播放动画
					self.npcShowInFrame = self.frame + aniInFrameCD
					self.npcShowing = true
					self.npcShowingLoop = false
					self.npcShowingEnd = false
				end
			end
		end
	else
		if Loop == true then
			if self.frame > self.npcShowInFrame  and self.npcShowingLoop ~= true and self.npcShowingEnd ~= true then
				--npc播放动作
				if instanceId then
					if BehaviorFunctions.CheckEntity(instanceId) then
						BehaviorFunctions.PlayAnimation(instanceId,ani.aniLoop,FightEnum.AnimationLayer.BaseLayer)--播放动画
						self.npcShowLoopFrame = self.frame + aniLoopFrameCD
						self.npcShowingLoop = true
					end
				end
			end

			if self.frame > self.npcShowLoopFrame and self.npcShowingEnd ~= true and self.npcShowingLoop == true then
				--npc播放动作
				if instanceId then
					if BehaviorFunctions.CheckEntity(instanceId) then
						BehaviorFunctions.PlayAnimation(instanceId,ani.aniEnd,FightEnum.AnimationLayer.BaseLayer)--播放动画
						self.npcShowEndFrame = self.frame + aniEndFrameCD
						self.npcShowingEnd = true
					end
				end
			end

			if self.frame > self.npcShowEndFrame and self.npcShowingLoop == true and self.npcShowingEnd == true then
				--npc播放动作
				if instanceId then
					if BehaviorFunctions.CheckEntity(instanceId) then
						BehaviorFunctions.PlayAnimation(instanceId,"stand1",FightEnum.AnimationLayer.BaseLayer)--播放动画
						self.npcFrameNext = self.frame + aniFrameCD
						self.npcShowing = false
						self.npcShowingLoop = false
						self.npcShowingEnd = false
					end
				end
			end
		else
			if self.frame > self.npcShowInFrame  and self.npcShowingEnd ~= true then
				--npc播放动作
				if instanceId then
					if BehaviorFunctions.CheckEntity(instanceId) then
						BehaviorFunctions.PlayAnimation(instanceId,ani.aniEnd,FightEnum.AnimationLayer.BaseLayer)--播放动画
						self.npcShowEndFrame = self.frame + aniEndFrameCD
						self.npcShowingEnd = true
					end
				end
			end

			if self.frame > self.npcShowEndFrame and self.npcShowingEnd == true then
				--npc播放动作
				if instanceId then
					if BehaviorFunctions.CheckEntity(instanceId) then
						BehaviorFunctions.PlayAnimation(instanceId,"stand1",FightEnum.AnimationLayer.BaseLayer)--播放动画
						self.npcFrameNext = self.frame + aniFrameCD
						self.npcShowing = false
						self.npcShowingEnd = false
					end
				end
			end
		end
	end
end


function LevelBehavior200509002:OnAttackNpc(attackInstanceId,hitInstanceId,instanceId,attackType, skillType)
	if hitInstanceId == self.monster.id then
		if self.phoneInvisibleHit == false then
			self.phoneInvisibleHit = true
			BehaviorFunctions.SetEntityBineVisible(self.monster.id,"Phone",true)
		end
	end
end