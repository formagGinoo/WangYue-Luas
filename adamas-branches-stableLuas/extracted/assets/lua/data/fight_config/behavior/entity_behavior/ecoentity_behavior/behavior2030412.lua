Behavior2030412 = BaseClass("Behavior2030412",EntityBehaviorBase)
--月灵大师特殊NPC测试lua
function Behavior2030412.GetGenerates()
	local generates = {890008001}
	return generates
end


function Behavior2030412.GetMagics()
	local generates = {8080100030101,8080100030102}
	return generates
end

function Behavior2030412:Init()
	self.me = self.instanceId
	self.ecoMe = self.sInstanceId --获得生态id
	self.yueling = nil --月灵大师配套的月灵的实例id
	self.ecoYueling = nil --月灵的生态id
	self.npc = nil --Npc的实例id
	self.ecoNpc = nil --npc的生态id
	self.role = nil --当前操控角色
	self.reward = nil --奖励实体
	self.rewardFresh = false
	self.yuelingFresh = false --当前的月灵是否刷新出来了
	self.groupAll = {} --生态分组
	self.tag = nil --标签
	self.dis = 100
	
	self.missionOutState = 0 --副本外的关卡状态
	self.missionOutStateEnum = {default = 0, start = 1, ongoing = 2, success = 3, fail = 4, inLevel = 5, endLevle = 6} --副本外的关卡状态枚举

	self.param = nil --额外参数
	self.duplicate = nil --副本系统id
	self.bindLevel = nil
	
	self.npcAniListNum = 0

	self.battleStart = false
		
	self.startDialogStart = false
	self.battleDialogFinish = false --开始战斗的对话结束，进入战斗
	self.endDialogStart = false
	self.endDialogFinish = false --关卡结束的对话结束

	self.chooseBattle = false --是否选择了战斗选项
	self.success = false --是否胜利
	
	self.yuelingFrameNext = 0
	self.npcFrameNext = 0 --npc循环表演的总帧数
	self.npcShowInFrame = 0 --npc表演的进入动作的帧数
	self.npcShowEndFrame = 0 --npc结束表演的动作的帧数
	self.npcShowing = false
	self.npcShowingEnd = false

	self.npcTalkFrameNext = 0
	self.npcTalkInFrame = 0
	self.npcTalkLoopFrame = 0
	self.npcTalkEndFrame = 0
	self.npcTalkFrameCD = 100
	self.npcTalkAniNum = 0
	self.npcTalkAniNum1 = 0
	self.npcTalkShowing = false
	self.npcTalkShowLoop = false
	self.npcTalkShowingEnd = false
	
	self.npcBattleStartFrame = 0
	self.npcBattleStart = false
	
	self.npcBattleInFrame = 0
	self.npcBattleEndFrame = 0
	self.npcbattleShow = false
	self.npcbattleIn = false
	self.npcbattleEnd = false
	self.showCommonTitle = false
	
	self.bubble = false
	
	self.endBlackStart = false
	
	self.endFrame = 0
	
	self.interact = nil --交互组件
	self.npcLookPos = nil
	self.inSkill = false --玩家是否正在技能中
	
	self.inDup = false
	self.camera = nil --对话用的镜头
	
	self.battleFrameNext = 0
	self.guidePointer = nil
	self.guidePointerRadius = 50
	self.guidePointerLimit = 30
	
	self.levelFinish = false --关卡是否完成
	
	self.showBubble = false
	
	self.forbidInput = false
	
	
	--需要配置的内容------------------------------------------
	self.startDialog = 602150101 --开始玩法的对话
	self.endDialog = 602150201   --结束玩法的对话
	self.failDialog = 602150301 --玩法失败的对话
	self.battleDialog = 602150103 --选择战斗的对话
	
	self.yuelingShow = "Alert"
	--self.npcShow = "SitGround_loop"
	--self.npcTalkShow = "SitGround_loop"
	--self.npcEndTalkShow = "Sbaoxiong_loop"
	
	self.npcShowState = {aniIn = "Jushou_in",aniLoop = "Jushou_loop",aniEnd = "Jushou_end"}
	self.npcShowInFrameCD = 60 --npc举手in的动作帧数
	self.npcShowEndFrameCD = 50 --npc举手end的动作帧数
	self.npcFrameCD = 150 --npc循环播放动作的总帧数
	
	self.npcTalkState = {
		[1] = {frameIn = 50,frameEnd = 50, aniIn = "Chayao_in",aniLoop = "Chayao_loop",aniEnd = "Chayao_end"},
		[2] = {frameIn = 50,frameEnd = 50, aniIn = "Sbaoxiong_in",aniLoop = "Sbaoxiong_loop",aniEnd = "Sbaoxiong_end"},
		[3] = {frameIn = 30,frameEnd = 40, aniIn = "Schayao_in",aniLoop = "Schayao_loop",aniEnd = "Schayao_end"},
		[4] = {frameIn = 40,frameEnd = 50, aniIn = "Stanshou_in",aniLoop = "Stanshou_loop",aniEnd = "Stanshou_end"},
		[5] = {frameIn = 50,frameEnd = 50, aniIn = "Tuoshou_in",aniLoop = "Tuoshou_loop",aniEnd = "Tuoshou_end"},
	}
	self.npcEndShowAni = "Clap_loop"
	
	self.npcTalkStateNowEnum = {none = 0,aniIn = 1,aniLoop = 2,aniEnd = 3}
	self.npcTalkStateNow = self.npcTalkStateNowEnum.none
	
	self.npcTalkLoopCD = 150
	self.npcTalkFrameCDplus = 90
	
	self.npcBattleAni = {aniIn = "Woquan_in", aniLoop = "Woquan_loop", aniEnd = "Woquan_end"}
	
	
	self.yuelingFrameCD = 500
	
	self.battleFrameCD = 30 --选择进入战斗，npc开始表演之后所需要的帧数
	
	self.interactRadius = 4 --出现交互距离的范围
	self.disLook = 10 --月灵大师开始看向玩家的距离

	--通用行为树
	self.LevelCommon = BehaviorFunctions.CreateBehavior("LevelCommonFunction",self) --创建关卡通用行为树
	self.LevelCommon.levelId = self.levelId --将关卡ID赋值给关卡通用行为树
end

function Behavior2030412:LateInit()

end

function Behavior2030412:Update()
	self.LevelCommon:Update() --执行关卡通用行为树的每帧运行
	self.state = BehaviorFunctions.GetEcoEntityState(self.ecoMe)
	self.frame = BehaviorFunctions.GetFightFrame()
	self.role = BehaviorFunctions.GetCtrlEntity()
	if self.dis == nil then
		self.dis = 100
	end
	
	if self.state == 0 then
		--默认状态，修改npc默认状态-------------------------------------------------------------------------------------------------------------------------------
		if self.missionOutState == 0 then
			
			self.bindLevel = BehaviorFunctions.GetEcoEntityBindLevel(self.ecoMe)

			self.missionOutState = 1

		--修改月灵相关状态-------------------------------------------------------------------------------------------------------------------------------------
		elseif self.missionOutState == 1 then
			if self.npc then
				if BehaviorFunctions.CheckEntity(self.npc) then
					self.dis = BehaviorFunctions.GetDistanceFromTargetWithY(self.role,self.npc)
				end
				
			end
			
			--获取npc和yueling的数据，设定初始数据
			if self.yueling == nil or self.npc == nil or self.reward == nil then
				--根据分组获得月灵id
				self.groupAll = BehaviorFunctions.GetEcoEntityGroup(nil,self.ecoMe,self.me)
				if next(self.groupAll) then
					for i, v in pairs(self.groupAll) do
						local id = BehaviorFunctions.GetEcoEntityByEcoId(v.ecoId)
						if id then
							self.tag = BehaviorFunctions.GetNpcType(id)
							--如果是npc，设置npc的默认属性
							if self.tag == FightEnum.EntityNpcTag.NPC then
								self.npc = id
								self.ecoNpc = v.ecoId
								--增加magic效果
								if self.npc then
									if BehaviorFunctions.CheckEntity(self.npc) then
										if not BehaviorFunctions.HasBuffKind(self.npc,200000017) then
											BehaviorFunctions.AddBuff(self.npc,self.npc,200000017)
										end
										--气泡前置修改
										BehaviorFunctions.ShowCharacterHeadTips(self.npc,true)
										BehaviorFunctions.SetEntityWorldInteractState(self.npc,false)
									end
								end
								if self.npc then
									if BehaviorFunctions.CheckEntity(self.yueling) then
										if not BehaviorFunctions.HasBuffKind(self.npc,200000018) then
											BehaviorFunctions.AddBuff(self.npc,self.npc,200000018)
										end
									end
								end
								
								--修改月灵大师的信息
								BehaviorFunctions.SetEntityHackInformation(self.npc,"月灵大师","Textures/Icon/Single/HeadIcon/SquRWeizhirenyuan.png","与自己的月灵亲密无间") --修改駭入信息
								BehaviorFunctions.SetEntityHackEffectIsTask(self.npc,true)
								
								if self.showBubble == false then
									self.showBubble = true
									----给npc增加头部标志
									--BehaviorFunctions.AddDelayCallByFrame(1,BehaviorFunctions,BehaviorFunctions.ChangeNpcHeadIcon,self.npc, "Textures/Icon/Single/FuncIcon/Map_yuemaster.png")
								end
								

							--如果是怪物，设置怪物的默认属性
							elseif self.tag == FightEnum.EntityNpcTag.Monster or self.tag == FightEnum.EntityNpcTag.Elite then
								self.yueling = id
								--给月灵增加永久霸体
								BehaviorFunctions.AddBuff(self.yueling,self.yueling,600000041)
								self.ecoYueling = v.ecoId
							elseif id ~= self.me then
								self.reward = id
							end
						end
					end
				end
			end
			
			--每帧检测修改月灵数据
			if self.yueling then
				self.yuelingFresh = BehaviorFunctions.CheckEntity(self.yueling) --检测当前月灵是否刷新出来
				if self.yuelingFresh  then
					if self.success  == false then
						if self.frame >= self.yuelingFrameNext then
							self.yuelingFrameNext = self.frame + self.yuelingFrameCD
							if BehaviorFunctions.CheckEntity(self.yueling) then
								--BehaviorFunctions.PlayAnimation(self.yueling,self.yuelingShow,FightEnum.AnimationLayer.BaseLayer)
							end
						end
					end
				else
					self.yueling = nil --如果月灵没刷新出来，则重置月灵状态，重新跑刷新逻辑
				end
			end
			
			--每帧检测修改奖励实体数据
			if self.reward then
				self.rewardFresh = BehaviorFunctions.CheckEntity(self.reward) --检测当前月灵是否刷新出来
				if self.rewardFresh  then
					
				else
					self.reward = nil --如果月灵没刷新出来，则重置月灵状态，重新跑刷新逻辑
				end
			end

			--每帧检测修改npc数据
			if self.npc then
				self.npcFresh = BehaviorFunctions.CheckEntity(self.npc) --检测当前月灵是否刷新出来
				if self.npcFresh then
					if self.success == false and self.chooseBattle == false then
						--播放对话的时候的动作
						if self.startDialogStart then
							--初始调整
							self.npcShowingEnd = false
							self.npcShowing = false
							BehaviorFunctions.SetNonNpcBubbleVisible(self.npc,false)
							self.bubble = false
							
							--播放动作
							if self.frame >= self.npcTalkFrameNext then
								if self.npcTalkShowing == false then
									self.npcTalkAniNum = math.random(1,#self.npcTalkState)
									if self.npcTalkAniNum ~= self.npcTalkAniNum1 then
										self.npcTalkAniNum1 =self.npcTalkAniNum
										--npc播放动作
										if self.npc then
											if BehaviorFunctions.CheckEntity(self.npc) then
												BehaviorFunctions.PlayAnimation(self.npc,self.npcTalkState[self.npcTalkAniNum].aniIn,FightEnum.AnimationLayer.BaseLayer)--播放动画
												self.npcTalkFrameNext = self.frame + self.npcTalkState[self.npcTalkAniNum].frameIn + self.npcTalkState[self.npcTalkAniNum].frameEnd + self.npcTalkFrameCDplus + self.npcTalkLoopCD
												self.npcTalkInFrame = self.frame + self.npcTalkState[self.npcTalkAniNum].frameIn
												self.npcTalkShowing = true
												self.npcTalkStateNow = self.npcTalkStateNowEnum.aniIn
											end
										end
									end
								end
							else
								if self.npcTalkShowing then
									if self.frame > self.npcTalkInFrame and self.npcTalkShowLoop == false then
										if BehaviorFunctions.CheckEntity(self.npc) then
											BehaviorFunctions.PlayAnimation(self.npc,self.npcTalkState[self.npcTalkAniNum].aniLoop,FightEnum.AnimationLayer.BaseLayer)--播放动画
											self.npcTalkLoopFrame = self.frame + self.npcTalkLoopCD
											self.npcTalkShowLoop = true
											self.npcTalkStateNow = self.npcTalkStateNowEnum.aniLoop
										end
									end

									if self.frame > self.npcTalkLoopFrame and self.npcTalkShowingEnd == false and self.npcTalkShowLoop == true then
										if BehaviorFunctions.CheckEntity(self.npc) then
											BehaviorFunctions.PlayAnimation(self.npc,self.npcTalkState[self.npcTalkAniNum].aniEnd,FightEnum.AnimationLayer.BaseLayer)--播放动画
											self.npcTalkEndFrame = self.frame + self.npcTalkState[self.npcTalkAniNum].frameEnd
											self.npcTalkShowingEnd = true
											self.npcTalkStateNow = self.npcTalkStateNowEnum.aniEnd
										end
										
									end
									
									
									if self.frame > self.npcTalkEndFrame and self.npcTalkShowingEnd and self.npcTalkShowLoop then
										if BehaviorFunctions.CheckEntity(self.npc) then
											BehaviorFunctions.PlayAnimation(self.npc,"stand1",FightEnum.AnimationLayer.BaseLayer)--播放动画
											self.npcTalkShowing = false
											self.npcTalkShowLoop = false
											self.npcTalkShowingEnd = false
											self.npcTalkStateNow = self.npcTalkStateNowEnum.none
										end
									end
								end
								
							end
							
						--非播放对话时候的动作，每隔固定的帧数修改角色动作并且播放气泡
						else
							--气泡
							if self.bubble == false then
								self.bubble = true
								BehaviorFunctions.ChangeNpcBubbleContent(self.npc,"有人想和我的月灵切磋一下吗？",9999)
								BehaviorFunctions.SetNonNpcBubbleVisible(self.npc,true)
							end
							
							if self.dis then
								if self.dis < self.disLook then
									BehaviorFunctions.DoLookAtTargetImmediately(self.npc,self.role)
								end
							end
							
							
							if self.frame >= self.npcFrameNext then

								self.npcFrameNext = self.frame + self.npcFrameCD
								--npc播放动作
								if self.npc then
									if BehaviorFunctions.CheckEntity(self.npc) then
										BehaviorFunctions.PlayAnimation(self.npc,self.npcShowState.aniIn,FightEnum.AnimationLayer.BaseLayer)--播放动画
										self.npcShowInFrame = self.frame + self.npcShowInFrameCD
										self.npcShowing = true
									end
								end

							else
								if self.npcShowing then
									if self.frame > self.npcShowInFrame  and self.npcShowingEnd == false then
										--npc播放动作
										if self.npc then
											if BehaviorFunctions.CheckEntity(self.npc) then
												BehaviorFunctions.PlayAnimation(self.npc,self.npcShowState.aniEnd,FightEnum.AnimationLayer.BaseLayer)--播放动画
												self.npcShowEndFrame = self.frame + self.npcShowEndFrameCD
												self.npcShowingEnd = true
											end
										end
									end
									
									if self.frame > self.npcShowEndFrame and self.npcShowingEnd then
										--npc播放动作
										if self.npc then
											if BehaviorFunctions.CheckEntity(self.npc) then
												BehaviorFunctions.PlayAnimation(self.npc,"stand1",FightEnum.AnimationLayer.BaseLayer)--播放动画
												self.npcShowingEnd = false
												self.npcShowing = false
												
											end
										end
									end
								end
							end
						end
					end
				else
					self.npc= nil --如果月灵没刷新出来，则重置月灵状态
				end
			end
			
			--玩法是否胜利了，没胜利则根据距离增加交互组件，胜利了则执行胜利的逻辑
			if self.levelFinish == false then
				
				if self.dis then
					--根据距离增加交互组件
					if self.dis < self.interactRadius and self.inSkill == false then
						if self.interact == nil then
							self.interact = BehaviorFunctions.WorldInteractActive(self.me,WorldEnum.InteractType.Talk,nil,"切磋",1)
						end
					elseif self.interact then
						BehaviorFunctions.WorldInteractRemove(self.me,self.interact)
						self.interact = nil
					end
					--判断是否在引导范围内，增加图标引导
					if self.dis < self.guidePointerRadius then
						if self.showCommonTitle == false then
							self.showCommonTitle = true
							--BehaviorFunctions.ShowCommonTitle(8,"发现月灵大师")
						end
						--if self.guidePointer == nil then
							--self.guidePointer = BehaviorFunctions.AddEntityGuidePointer(self.npc,19,0,false,self.guidePointerLimit)
						--end
					else
						if self.showCommonTitle == true then
							self.showCommonTitle = false
						end
						--if self.guidePointer then
							--BehaviorFunctions.RemoveEntityGuidePointer(self.guidePointer)
							--self.guidePointer = nil
						--end
					end
					
				end
				
				
				
			else
				
			end

			--若玩家选择了进入战斗的dialog，就进入下一个状态
			if self.chooseBattle and self.levelFinish == false then
				self.npcShowingEnd = false
				self.npcShowing = false
				self.npcTalkShowing = false
				self.npcTalkShowLoop = false
				self.npcTalkShowingEnd = false
				if self.npcTalkStateNow == self.npcTalkStateNowEnum.aniLoop then
					BehaviorFunctions.PlayAnimation(self.npc,self.npcTalkState[self.npcTalkAniNum].aniEnd,FightEnum.AnimationLayer.BaseLayer)--播放动画
					self.npcBattleStartFrame = self.frame + self.npcTalkState[self.npcTalkAniNum].frameEnd
				end
				
				--self:DisablePlayerInput(true,true)

				
				
				
				
				self.missionOutState = 2
			end

		--与npc进行对话，触发表演---------------------------------------------------------------------------------------------------------
		elseif self.missionOutState == 2 then
			--容错
			if self.interact then
				BehaviorFunctions.WorldInteractRemove(self.me,self.interact)
				self.interact = nil
			end
			
			if self.battleStart == false then
				if self.npcBattleAni == false then
					--npc播放动作
					if self.npc then
						if BehaviorFunctions.CheckEntity(self.npc) then
							BehaviorFunctions.PlayAnimation(self.npc,self.npcBattleAni.aniIn,FightEnum.AnimationLayer.BaseLayer)--播放动画
							self.npcBattleInFrame = self.frame + 32
							self.npcBattleAni = true
						end
					end
				else
					if self.frame > self.npcBattleInFrame  and self.npcbattleEnd == false then
						--npc播放动作
						if self.npc then
							if BehaviorFunctions.CheckEntity(self.npc) then
								BehaviorFunctions.PlayAnimation(self.npc,self.npcBattleAni.aniLoop,FightEnum.AnimationLayer.BaseLayer)--播放动画
								self.npcbattleEnd = true
								self.battleStart = true
							end
						end
					end
				end
			end
			
				
			if self.battleStart and self.battleDialogFinish then
				self.missionOutState = 3
			end
			
		elseif self.missionOutState == 3 then
			
			--删除镜头
			if self.camera then
				self.LevelCommon:RemoveLevelCamera(self.camera)
				self.camera = nil
			end
			
			
			--添加关卡
			BehaviorFunctions.AddLevel(self.bindLevel)
			--黑幕
			--BehaviorFunctions.ShowBlackCurtain(true,0.5,false)
			--BehaviorFunctions.AddDelayCallByFrame(0.5,BehaviorFunctions,BehaviorFunctions.ShowBlackCurtain,false,0.5,false)
			--移除npc和月灵
			if self.npc then
				BehaviorFunctions.SetEntityShowState(self.npc,false)
				--气泡前置修改
				BehaviorFunctions.ShowCharacterHeadTips(self.npc,false)
			end
			if self.yueling then
				BehaviorFunctions.SetEntityShowState(self.yueling,false)
			end
			if self.guidePointer then
				--BehaviorFunctions.RemoveEntityGuidePointer(self.guidePointer)
				--self.guidePointer = nil
			end
			
			
			--BehaviorFunctions.AddLevelTips(200507002,self.bindLevel)
			
			self.missionOutState = 4

		--战斗中-----------------------------------------------------------------------------------------------------------------------------------------
		elseif self.missionOutState == 4 then
			
			--如果关卡胜利
			if self.levelFinish == true and self.inSkill == false then
				BehaviorFunctions.SetEntityShowState(self.npc,true)
				BehaviorFunctions.SetEntityShowState(self.yueling,true)
				--把玩家瞬移到npc旁边
				if self.npc then
					self.posRole = BehaviorFunctions.GetEntityPositionOffset(self.npc, 0, 0, 3)
					if self.posRole then
						BehaviorFunctions.InMapTransport(self.posRole.x,self.posRole.y, self.posRole.z, false)
					end
				end
				BehaviorFunctions.DoLookAtTargetImmediately(self.role,self.npc)
				BehaviorFunctions.DoLookAtTargetImmediately(self.npc,self.role)
				
				--关卡胜利
				self.missionOutState = 5
			end
		--战斗胜利表现-------------------------------------------------------------------------------------------------------------------------------
		elseif self.missionOutState == 5 then
			
			--播放对话
			if self.npc then
				if self.endDialog and self.endDialogStart == false then
					self.endDialogStart = true
					
					--BehaviorFunctions.AddDelayCallByFrame(5,BehaviorFunctions,BehaviorFunctions.StartStoryDialog,self.endDialog)
					BehaviorFunctions.StartStoryDialog(self.endDialog)
				end
			end

			if self.npc and self.yueling then
				if self.endDialogFinish then
					self.missionOutState = 6
				end
			end
			
		elseif self.missionOutState == 6 then
			if self.endDialogFinish  then
				if self.frame > self.endFrame then
					if self.endBlackStart == false then
						self.endBlackStart = true
						--BehaviorFunctions.ShowBlackCurtain(false,0.3,false)
						--BehaviorFunctions.SetEcoEntityState(self.ecoMe,1)

						BehaviorFunctions.InteractEntityHit(self.reward,false)
						BehaviorFunctions.InteractEntityHit(self.yueling,false)
						BehaviorFunctions.InteractEntityHit(self.npc,false)
						BehaviorFunctions.InteractEntityHit(self.me,false)
						if self.npc then
							BehaviorFunctions.RemoveEntity(self.npc)
						end
						
						if self.yueling then
							BehaviorFunctions.RemoveEntity(self.yueling)
						end
						self.missionOutState = 7
					end
				end
			end
		end
		if self.countDown == true and self.forbidInput == false then
			self.forbidInput = true
			--self:DisablePlayerInput(false,false)
			self.LevelCommon:DisablePlayerInput(false,false)
		end
		
		
	end
end

--与NPC互动
function Behavior2030412:WorldInteractClick(uniqueId,instanceId)
	if self.dis then
		if self.dis < self.interactRadius then
			--与月灵npc互动，开启切磋邀请对话
			if uniqueId == self.interact and self.startDialogStart == false then
				if self.startDialog then

					BehaviorFunctions.StartStoryDialog(self.startDialog)
				end
			end
		end
	end
	
	
end

--对话开始
function Behavior2030412:StoryStartEvent(dialogId)
	if dialogId == self.startDialog then
		self.startDialogStart = true
		self.role = BehaviorFunctions.GetCtrlEntity()
		if self.npc and self.role then
			BehaviorFunctions.DoLookAtTargetImmediately(self.role,self.npc)
			BehaviorFunctions.DoLookAtTargetImmediately(self.npc,self.role)
			self.camera = self.LevelCommon:LevelCameraLookAtInstance(22002,-1,nil,self.npc,"CameraTarget")
		end
		
		--self:DisablePlayerInput(true,true)
		self.LevelCommon:DisablePlayerInput(true,true)
		
	elseif dialogId == self.endDialog then
		if self.npc and self.role then
			BehaviorFunctions.PlayAnimation(self.npc,self.npcEndShowAni,FightEnum.AnimationLayer.BaseLayer)--播放动画
			BehaviorFunctions.DoLookAtTargetImmediately(self.role,self.npc)
			BehaviorFunctions.DoLookAtTargetImmediately(self.npc,self.role)
			BehaviorFunctions.DoLookAtTargetImmediately(self.yueling,self.role)
			self.camera = self.LevelCommon:LevelCameraLookAtInstance(22002,-1,nil,self.npc,"CameraTarget",0)
		end
		
	end
end

--对话结束
function Behavior2030412:StoryEndEvent(dialogId)
	if dialogId == self.startDialog then
		if self.chooseBattle then
			if self.camera then
				self.LevelCommon:RemoveLevelCamera(self.camera)
				self.camera = nil
			end
			self.battleDialogFinish = true
		else
			if self.camera then
				self.LevelCommon:RemoveLevelCamera(self.camera)
				self.camera = nil
			end
		end
		
		self.npcTalkShowing = false
		self.npcTalkShowLoop = false
		self.npcTalkShowingEnd = false
		self.startDialogStart = false
		self.npcTalkFrameNext = 0
		self.npcFrameNext = 0
		if self.chooseBattle then
			--self:DisablePlayerInput(true,true)
		else
			--self:DisablePlayerInput(false,false)
			self.LevelCommon:DisablePlayerInput(false,false)
		end
		
	elseif dialogId == self.endDialog then
		if self.camera then
			self.LevelCommon:RemoveLevelCamera(self.camera)
			self.camera = nil
		end
		self.endDialogFinish = true
		self.endFrame = self.frame + 30
		--BehaviorFunctions.ShowBlackCurtain(true,0.3,false)
	end
	
end

--选择选项
function Behavior2030412:StorySelectEvent(dialogId)
	if dialogId == self.battleDialog then
		self.chooseBattle = true
		--self:DisablePlayerInput(true,true)
	end
end

--技能释放
function Behavior2030412:CastSkill(instanceId,skillId,SkillConfigSign,skillType)
	if instanceId == self.role then
		if self.interact then
			self.inSkill = true
			BehaviorFunctions.WorldInteractRemove(self.me,self.interact)
			self.interact = nil
		end
	end
end

--技能中断或结束
function Behavior2030412:BreakSkill(instanceId,skillId,SkillConfigSign,skillType)
	if instanceId == self.role then
		if self.inSkill then
			self.inSkill = false
		end
	end
end
function Behavior2030412:FinishSkill(instanceId,skillId,SkillConfigSign,skillType)
	if instanceId == self.role then
		if self.inSkill then
			self.inSkill = false
		end
	end
end

function Behavior2030412:FinishLevel(LevelId)
	if LevelId == self.bindLevel then
		self.levelFinish = true
	end
	
end

--禁用角色移动
function Behavior2030412:DisablePlayerInput(isOpen,closeUI)
	--取消摇杆移动
	BehaviorFunctions.CancelJoystick()
	if isOpen then
		----禁用摇杆输入
		--BehaviorFunctions.SetJoyMoveEnable(self.role,false)
		--关闭按键输入
		for i,v in ipairs(FightEnum.KeyEvent) do
			BehaviorFunctions.ForbidKey(i,true)
		end
	else
		BehaviorFunctions.SetJoyMoveEnable(self.role,true)
		for i,v in ipairs(FightEnum.KeyEvent) do
			BehaviorFunctions.ForbidKey(i,false)
		end
	end
	if closeUI then
		--屏蔽战斗主UI
		BehaviorFunctions.SetFightMainNodeVisible(2,"PanelParent",false)
	else
		--显示战斗主UI
		BehaviorFunctions.SetFightMainNodeVisible(2,"PanelParent",true)
	end
end

function Behavior2030412:OnCountDownFinishEvent(levelId)
	if levelId == self.bindLevel then
		self.countDown = true
	end
end