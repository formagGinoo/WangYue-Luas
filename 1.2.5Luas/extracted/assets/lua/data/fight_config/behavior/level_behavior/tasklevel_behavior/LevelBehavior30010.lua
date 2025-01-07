LevelBehavior30010 = BaseClass("LevelBehavior30010",LevelBehaviorBase)
--动态创建关卡1
function LevelBehavior30010:__init(fight)
	self.fight = fight
end


function LevelBehavior30010.GetGenerates()
	local generates = {920010}

	return generates
end
--storydialog预加载
function LevelBehavior30010.GetStorys()
	local story = {101060201,101063501,101063701,101063601,101061401,101061501,101061701,101063801,101060601,101060501,101060701}
	return story
end

--UI预加载
function LevelBehavior30010.GetUIGenerates()
	local generates = {
		FightEnum.PreLoadUI.RemoteDialog,--带头像的剧情对话框UI
		FightEnum.PreLoadUI.FightTalkDialog,--纯文字的剧情对话框UI
		FightEnum.PreLoadUI.GuideMask,--教学引导UI
		FightEnum.PreLoadUI.FightTips--中间横幅和底部横幅
	}
	return generates
end

function LevelBehavior30010:Init()
	self.role = BehaviorFunctions.GetCtrlEntity()

	self.missionState = 0
	self.currentDialog = nil
	self.dialogStateEnum = {
		Default = 0,
		NotPlaying = 1,
		Playing = 2,
		PlayOver = 3,
	}
	self.lingshi=true

	self.dialogKindEnum ={
		CanNotMove= 0,
		Move =1
	}




	self.roleFrame = nil
	self.skillList = {
		{id = 92001905,
			minDistance = 0,         --技能释放最小距离（有等号）
			maxDistance = 8,        --技能释放最大距离（无等号）
			angle = 70,              --技能释放角度
			cd = 5,                  --技能cd，单位：秒
			durationFrame = 84,      --技能持续帧数
			frame = 0,               --cd用帧数参数，默认为0，大于0相当于有单独的初始cd
			priority = 0,            --优先级，数值越大优先级越高
			isAuto = true,           --是否自动释放
			difficultyDegree = 0,    --难度系数，初始化会剔除大于预设难度的技能
			minLifeRatio = 0,        --技能释放最低生命万分比（有等号）
			maxLifeRatio = 10000     --技能释放最高生命万分比（无等号）
		}
	}

	self.skillList2 = {
		{id = 92001906,
			minDistance = 0,         --技能释放最小距离（有等号）
			maxDistance = 8,        --技能释放最大距离（无等号）
			angle = 60,              --技能释放角度
			cd = 4,                  --技能cd，单位：秒
			durationFrame = 98,      --技能持续帧数
			frame = 0,               --cd用帧数参数，默认为0，大于0相当于有单独的初始cd
			priority = 1,            --优先级，数值越大优先级越高
			isAuto = true,           --是否自动释放
			difficultyDegree = 0,    --难度系数，初始化会剔除大于预设难度的技能
			minLifeRatio = 0,        --技能释放最低生命万分比（有等号）
			maxLifeRatio = 10000     --技能释放最高生命万分比（无等号）
		}
	}

	self.skillList3 ={
		--中距离突进挑飞
		{id = 92001008,
			minDistance = 1,         --技能释放最小距离（有等号）
			maxDistance = 14,        --技能释放最大距离（无等号）
			angle = 80,              --技能释放角度
			cd = 4,                  --技能cd，单位：秒
			durationFrame = 105,      --技能持续帧数
			frame = 0,               --cd用帧数参数，默认为0，大于0相当于有单独的初始cd
			priority = 1,            --优先级，数值越大优先级越高
			isAuto = true,           --是否自动释放
			difficultyDegree = 0,    --难度系数，初始化会剔除大于预设难度的技能
			minLifeRatio = 0,        --技能释放最低生命万分比（有等号）
			maxLifeRatio = 10000     --技能释放最高生命万分比（无等号）
		},
	}




	self.lingshi3=true


	self.skillList4 = {
		{id = 92001906,
			minDistance = 0,         --技能释放最小距离（有等号）
			maxDistance = 3.5,        --技能释放最大距离（无等号）
			angle = 70,              --技能释放角度
			cd = 8,                  --技能cd，单位：秒
			durationFrame = 98,      --技能持续帧数
			frame = 0,               --cd用帧数参数，默认为0，大于0相当于有单独的初始cd
			priority = 0,            --优先级，数值越大优先级越高
			isAuto = true,           --是否自动释放
			difficultyDegree = 0,    --难度系数，初始化会剔除大于预设难度的技能
			minLifeRatio = 0,     --技能释放最低生命万分比（有等号）
			maxLifeRatio = 10000     --技能释放最高生命万分比（无等号）
		},
		{id = 92001905,
			minDistance = 0,         --技能释放最小距离（有等号）
			maxDistance = 8,        --技能释放最大距离（无等号）
			angle = 60,              --技能释放角度
			cd = 8,                  --技能cd，单位：秒
			durationFrame = 84,      --技能持续帧数
			frame = 0,               --cd用帧数参数，默认为0，大于0相当于有单独的初始cd
			priority = 1,            --优先级，数值越大优先级越高
			isAuto = true,           --是否自动释放
			difficultyDegree = 0,    --难度系数，初始化会剔除大于预设难度的技能
			minLifeRatio = 0,     --技能释放最低生命万分比（有等号）
			maxLifeRatio = 10000     --技能释放最高生命万分比（无等号）
		},
		--中距离突进挑飞
		{id = 92001008,
			minDistance = 1,         --技能释放最小距离（有等号）
			maxDistance = 14,        --技能释放最大距离（无等号）
			angle = 80,              --技能释放角度
			cd = 10,                  --技能cd，单位：秒
			durationFrame = 105,      --技能持续帧数
			frame = 0,               --cd用帧数参数，默认为0，大于0相当于有单独的初始cd
			priority = 1,            --优先级，数值越大优先级越高
			isAuto = true,           --是否自动释放
			difficultyDegree = 0,    --难度系数，初始化会剔除大于预设难度的技能
			minLifeRatio = 5000,        --技能释放最低生命万分比（有等号）
			maxLifeRatio = 10000     --技能释放最高生命万分比（无等号）
		},

	}
	self.repeatGuide = 0
	self.skillTimeStop = {




	}
	self.jump =0

	self.skillSign = true
	self.moveNum = 0
	self.reboundAttack =0
	self.skillNum1 = 0
	self.skillNum2 = 0

	self.skillKey = true
	self.tutorial = {true,true,true,true}
	self.missionStateKey = {true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true}
	self.titleKey = {true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true}
	self.skillOnePointNum = 0     --普攻积攒技能点，释放技能的记录key
	self.skillTreePointNum = 0        --释放三点数技能次数
	self.skillCoreNum = 0             --释放核心被动
	self.QTENum = 0
	self.QTEHitKey = false
	self.blueBallNum = 0
	self.blueHitKey = false

	self.tips = {}
	self.tipsKey=true
	self.dodgeKey = true
	self.beHitKey = false
	self.beHitNum = 0
	self.specialMoveNum = 0
	self.battleTargetSkill = 0

	self.attackNum = 0
	self.hitKey = false
	self.skillTreePointGuide = true
	self.dialogKey3 = true
	self.dialogKey10 = true
	self.dialogKey5 = true
	self.dialogKey7= true
	self.dialog2=true
	self.dialogKey5 = true
	self.guideSuccess ={true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,}
	self.guideStateEnum = {
		Default = 0,
		NotPlaying = 1,
		Playing = 2,
		PlayOver = 3,
	}
	--播对话
	self.dialogList =
	{
	
		[1] = {Id = 101060201,kind = self.dialogKindEnum.CanNotMove,state = self.dialogStateEnum.NotPlaying,delay=0},
		[2] = {Id = 101062901,kind = self.dialogKindEnum.Move,state = self.dialogStateEnum.NotPlaying,delay=0},
		[3] = {Id = 101061201,kind = self.dialogKindEnum.Move,state = self.dialogStateEnum.NotPlaying,delay=0},
		[4] = {Id = 101062701,kind = self.dialogKindEnum.Move,state = self.dialogStateEnum.NotPlaying,delay=0},
		[5] = {Id = 101061301,kind = self.dialogKindEnum.Move,state = self.dialogStateEnum.NotPlaying,delay=0},
		[6] = {Id = 101063201,kind = self.dialogKindEnum.Move,state = self.dialogStateEnum.NotPlaying,delay=0},
		[7] = {Id = 101063401,kind = self.dialogKindEnum.Move,state = self.dialogStateEnum.NotPlaying,delay=0},
		[8] = {Id = 101060401,kind = self.dialogKindEnum.Move,state = self.dialogStateEnum.NotPlaying,delay=0},
		[9] = {Id = 101062901,kind = self.dialogKindEnum.Move,state = self.dialogStateEnum.NotPlaying,delay=0},
		[10] = {Id = 101062101,kind = self.dialogKindEnum.Move,state = self.dialogStateEnum.NotPlaying,delay=0},
		[11] = {Id = 101063001,kind = self.dialogKindEnum.Move,state = self.dialogStateEnum.NotPlaying,delay=0},
		[12] = {Id = 101063101,kind = self.dialogKindEnum.Move,state = self.dialogStateEnum.NotPlaying,delay=0},
		[13] = {Id = 101063301,kind = self.dialogKindEnum.Move,state = self.dialogStateEnum.NotPlaying,delay=0},
		[14] = {Id = 101061501,kind = self.dialogKindEnum.Move,state = self.dialogStateEnum.NotPlaying,delay=0},
		[15] = {Id = 101063801,kind = self.dialogKindEnum.Move,state = self.dialogStateEnum.NotPlaying,delay=0},
		[16] = {Id = 101061401,kind = self.dialogKindEnum.Move,state = self.dialogStateEnum.NotPlaying,delay=0},
		[17] = {Id = 101061401,kind = self.dialogKindEnum.Move,state = self.dialogStateEnum.NotPlaying,delay=0},
		[18] = {Id = 101061501,kind = self.dialogKindEnum.Move,state = self.dialogStateEnum.NotPlaying,delay=0},
		[19] = {Id = 101061601,kind = self.dialogKindEnum.Move,state = self.dialogStateEnum.NotPlaying,delay=0},
		[20] = {Id = 101063801,kind = self.dialogKindEnum.Move,state = self.dialogStateEnum.NotPlaying,delay=0},
		[21] = {Id = 101060601,kind = self.dialogKindEnum.CanNotMove,state = self.dialogStateEnum.NotPlaying,delay=0},
		[22] = {Id = 101060501,kind = self.dialogKindEnum.Move,state = self.dialogStateEnum.NotPlaying,delay=0},
		[23] = {Id = 101060701,kind = self.dialogKindEnum.CanNotMove,state = self.dialogStateEnum.NotPlaying,delay=0},
		[24] = {Id = 101063501,kind = self.dialogKindEnum.Move,state = self.dialogStateEnum.NotPlaying,delay=0},--眩晕介绍
		[25] = {Id = 101063701,kind = self.dialogKindEnum.Move,state = self.dialogStateEnum.NotPlaying,delay=0},--注意这里
		[26] = {Id = 101063601,kind = self.dialogKindEnum.Move,state = self.dialogStateEnum.NotPlaying,delay=0},--眩晕对白
		[27] = {Id = 101062101,kind = self.dialogKindEnum.Move,state = self.dialogStateEnum.NotPlaying,delay=0},--破绽对白


	}
	self.dialogReactionList =
	{
		[1] = {Id = 101061701,kind = self.dialogKindEnum.Move,state = self.dialogStateEnum.NotPlaying},
		[2] = {Id = 101062101,kind = self.dialogKindEnum.Move,state = self.dialogStateEnum.NotPlaying},
		[3] = {Id = 101061801,kind = self.dialogKindEnum.Move,state = self.dialogStateEnum.NotPlaying},
		[4] = {Id = 101061901,kind = self.dialogKindEnum.Move,state = self.dialogStateEnum.NotPlaying},
		[5] = {Id = 101061901,kind = self.dialogKindEnum.Move,state = self.dialogStateEnum.NotPlaying},
	}



	self.dialogMissionList=
	{
		[1] = {Id = 101061701,kind = self.dialogKindEnum.Move,state = self.dialogStateEnum.NotPlaying},
		[2] = {Id = 101062101,kind = self.dialogKindEnum.Move,state = self.dialogStateEnum.NotPlaying},
		[3] = {Id = 101061801,kind = self.dialogKindEnum.Move,state = self.dialogStateEnum.NotPlaying},
		[4] = {Id = 101061901,kind = self.dialogKindEnum.Move,state = self.dialogStateEnum.NotPlaying},
		[5] = {Id = 101061901,kind = self.dialogKindEnum.Move,state = self.dialogStateEnum.NotPlaying},
	}


	self.guideList = {
		[1] = {Id = 2024,state = self.guideStateEnum.Default},
		[2] = {Id = 2040,state = self.guideStateEnum.Default},
		[3] = {Id = 2035,state = self.guideStateEnum.Default},
		[4] = {Id = 2038,state = self.guideStateEnum.Default},
		[5] = {Id = 2026,state = self.guideStateEnum.Default},
		[6] = {Id = 2027,state = self.guideStateEnum.Default},
		[7] = {Id = 2037,state = self.guideStateEnum.Default},
		[8] = {Id = 2025,state = self.guideStateEnum.Default},
		[9] = {Id = 2038,state = self.guideStateEnum.Default},
		[10] = {Id = 2026,state = self.guideStateEnum.Default},
		[11] = {Id = 2040,state = self.guideStateEnum.Default},
		[12] = {Id = 2039,state = self.guideStateEnum.Default},
		[13] = {Id = 2023,state = self.guideStateEnum.Default},
		[14] = {Id = 2029,state = self.guideStateEnum.Default},
		[15] = {Id = 2028,state = self.guideStateEnum.Default},
		[16] = {Id = 2033,state = self.guideStateEnum.Default},
		[17] = {Id = 2041,state = self.guideStateEnum.Default},
		[18] = {Id = 2042,state = self.guideStateEnum.Default},
		[19] = {Id = 2043,state = self.guideStateEnum.Default},
		[20] = {Id =2036,state = self.guideStateEnum.Default},
		[21] = {Id =2044,state = self.guideStateEnum.Default},
		[22] = {Id =2045,state = self.guideStateEnum.Default},
		[23] = {Id =2046,state = self.guideStateEnum.Default},
		[24] = {Id =2047,state = self.guideStateEnum.Default},

	}

	self.weakGuideFree = true
	
	
	--用于播放任务目标
	self.title={
		[1] = nil,[2] = nil,[3] = nil,[4] = nil,[5] = nil,[6] = nil,[7] = nil,[8] = nil,[9] = nil,[10] = nil,[11] = nil,[12] = nil,[13] = nil,
	}
	
	--用于关闭头顶tips的返回
	self.titleFin={
		[1] = nil,[2] = nil,[3] = nil,[4] = nil,[5] = nil,[6] = nil,[7] = nil,[8] = nil,[9] = nil,[10] = nil,[11] = nil,
	}
	
	--用于第一次释放技能的时停教学
	self.skillDelay = {
		[1] = nil,[2] = nil,[3] = nil,[4] = nil,[5] = nil,[6] = nil,[7] = nil,[8] = nil,[9] = nil,
	}


	self.topTipsEnum =
	{
		NotPlaying =0,
		PlayOver=1,
	}



	self.topTipsList ={

		[1] = {Id=3001001,state=self.topTipsEnum.NotPlaying},
		[2] = {Id=3001002,state=self.topTipsEnum.NotPlaying},
		[3] = {Id=3001003,state=self.topTipsEnum.NotPlaying},
		[4] = {Id=3001004,state=self.topTipsEnum.NotPlaying},
		[5] = {Id=3001005,state=self.topTipsEnum.NotPlaying},
		[6] = {Id=3001006,state=self.topTipsEnum.NotPlaying},
		[7] = {Id=3001007,state=self.topTipsEnum.NotPlaying},
		[8] = {Id=3001008,state=self.topTipsEnum.NotPlaying},
		[9] = {Id=3001009,state=self.topTipsEnum.NotPlaying},
		[10] = {Id=3001010,state=self.topTipsEnum.NotPlaying},
		[11] = {Id=3001011,state=self.topTipsEnum.NotPlaying},
	}


	self.attackKey =true
	self.finishKey=true
	self.noHitBattleTargetKey = false
	self.dodgeFalse = 0
	self.reboundAttackFalse = 0
	self.Button = false


	self.Image ={
		[1] = true,[2] = true,[3] = true,[4] = true,[5] = true,[6] = true,[7] = true,[8] = true}
	self.canClose = false
	self.canClose2 = false
	self.playPowerfulSkillAgain = true
	self.buffExtra = nil
	self.buffExtraKey = false
	self.finishGuide = true
	self.emptySkillKey = true
	self.progressEnum =
	{
		Default =0,
		Begin = 1,
		Finish = 2,
	}
	self.progressState = 0
	self.changeTopKey = false
	self.ClickKey = true
	self.sunPower = 0
	--元素积累
	self.maxElement =0
	self.currentElement=0
	self.skillTwoPointNum=0
	self.linshiList ={
		[1] = true,[2] = true,[3] = true,[4] = true,[5] = true,[6] = true,[7] = true,[8] = true,[9] = true}
	self.guideState=0
	self.battleTargetCastSkillNum=0


end





function LevelBehavior30010:Update()
	self.role = BehaviorFunctions.GetCtrlEntity()
	self.frame = BehaviorFunctions.GetFightFrame()
	self.roleTotalFrame = BehaviorFunctions.GetEntityFrame(self.role)
	--BehaviorFunctions.SetFightMainNodeVisible(2,"L",false) --闪避
	if self.noHitBattleTargetKey == true then
		self.noHitBattleTargetTime = BehaviorFunctions.GetEntityFrame(self.role)
	end
	--添加BossUI
	BehaviorFunctions.SetEntityValue(1,"LevelUiTarget",self.battleTarget)
	--添加boss血条
	if not BehaviorFunctions.HasEntitySign(1,10000020) then
		BehaviorFunctions.AddEntitySign(1,10000020,-1)
	end
	--关卡阶段0：创建实体和初始化镜头
	if self.missionState == 0 then
		BehaviorFunctions.StartStoryDialog(self.dialogList[1].Id)
		BehaviorFunctions.ShowBlackCurtain(false,0,true)
		BehaviorFunctions.SetActiveBGM("FALSE")
		BehaviorFunctions.StopBgmSound()
		BehaviorFunctions.PlayBgmSound("Memory")
		--隐藏不需要的界面按钮
		BehaviorFunctions.SetFightMainNodeVisible(2,"BagButton",false) --背包
		BehaviorFunctions.SetFightMainNodeVisible(2,"RoleButton",false) --角色
		BehaviorFunctions.SetFightMainNodeVisible(2,"MainMenuButton",false) --主界面
		BehaviorFunctions.SetFightMainNodeVisible(2,"L",false) --大招按钮
		BehaviorFunctions.SetFightMainNodeVisible(2,"O",false) --跳跃按钮
		BehaviorFunctions.SetTipsGuideState(false)
		self.noHitBattleTargetKey = true








		--创建叙慕

		local pb1 = BehaviorFunctions.GetTerrainPositionP("characterBorn",20010007)
		
		--BehaviorFunctions.DoSetPosition(self.role,pb1.x,pb1.y,pb1.z)
		BehaviorFunctions.InMapTransport(pb1.x,pb1.y,pb1.z)
		self.corePower=BehaviorFunctions.GetEntityAttrVal(self.role,204)
		self.JumpLevel=BehaviorFunctions.CreateEntity(200000108,nil,pb1.x+1,pb1.y,pb1.z-13)




		----创建离歌
		local pb2 = BehaviorFunctions.GetTerrainPositionP("enemyBorn",20010007)
		self.battleTarget = BehaviorFunctions.CreateEntity(920010,nil,pb2.x,pb2.y,pb2.z)
		local current,max=BehaviorFunctions.GetEntityElementStateAccumulation(self.battleTarget,-1)
		self.maxElement=max
		--置空离歌的技能
		BehaviorFunctions.SetEntityValue(self.battleTarget,"skillList",{})
		--记录贝鲁贝特出身时间
		self.initialSkillTime = BehaviorFunctions.GetEntityFrame(self.role)
		BehaviorFunctions.SetEntityValue(self.battleTarget,"stopMove",true)
		if BehaviorFunctions.CheckEntity(self.role) then
			self.roleLife = BehaviorFunctions.GetEntityAttrVal(self.role,1)

		end
		BehaviorFunctions.DoMagic(self.battleTarget,self.battleTarget,900000022)

		--获取离歌生命上限
		if BehaviorFunctions.CheckEntity(self.battleTarget) then
			self.life = BehaviorFunctions.GetEntityAttrVal(self.battleTarget,1)
			self.defend =BehaviorFunctions.GetEntityAttrVal(self.battleTarget,7)
		end

		self.missionState = 1
	end
	
	--用于将贝鲁贝特的技能置空
	if self.roleTotalFrame-self.initialSkillTime>2
		and self.emptySkillKey == true then
		--置空离歌的技能
		self.emptySkillKey = false

		BehaviorFunctions.SetEntityValue(self.battleTarget,"skillList",{})
		self.emptySkillKey = false
		BehaviorFunctions.AddEntitySign(self.battleTarget,10000025,-1,false)
	end





	--阶段1：释放技能积攒弱点槽
	if self.missionState==3 then



		--释放技能要求
		if self.missionStateKey[3]==true then
			BehaviorFunctions.CameraEntityFollowTarget(self.levelCam,self.role,"CameraTarget")
			BehaviorFunctions.CameraEntityLockTarget(self.levelCam,self.empty)
			BehaviorFunctions.SetCoreUIEnable(self.role,false)
			--播放对白
			BehaviorFunctions.StartStoryDialog(self.dialogList[2].Id)



			--清空核心被动
			if BehaviorFunctions.GetEntityAttrVal(self.role,1204)~=0 then
				BehaviorFunctions.SetEntityAttr(self.role,1204,0,1)
			end

			BehaviorFunctions.SetFightMainNodeVisible(2,"PowerGroup",true)--隐藏能量条
			BehaviorFunctions.SetFightMainNodeVisible(2,"Joystick",false)



			self.missionStateKey[3]=false
		end






		if self.dialogList[2].state==self.dialogStateEnum.PlayOver
			and self.titleKey[3]==true then
			BehaviorFunctions.FinishGuide(self.guideList[1].Id,1)
			
			--弱点槽指引
			BehaviorFunctions.PlayGuide(self.guideList[18].Id,1)
			
			--时停，用于讲解弱点槽
			BehaviorFunctions.AddBuff(self.role,self.role,200000008)
			BehaviorFunctions.AddBuff(self.battleTarget,self.battleTarget,200000008)
			BehaviorFunctions.AddBuff(self.role,self.role,200000009)
			if BehaviorFunctions.CheckEntity(self.levelCam) then
				BehaviorFunctions.RemoveEntity(self.levelCam)
				BehaviorFunctions.RemoveEntity(self.empty)
			end


			self.titleKey[3]=false
		end

		--挑战开始title提示。
		if self.guideList[18].state==self.guideStateEnum.PlayOver
			and self.titleKey[4]==true then
			BehaviorFunctions.ShowCommonTitle(4,"积攒离歌坏相",true)
			
			--delay函数，用于将挑战开始title完整播完。1代表编号，6代表6秒。6秒之后self.title[1]会变成true
			self:TipsInform("title",1,6)
			
			--解除时停
			BehaviorFunctions.RemoveBuff(self.role,200000008)
			BehaviorFunctions.RemoveBuff(self.battleTarget,200000008)
			BehaviorFunctions.RemoveBuff(self.role,200000009)
			BehaviorFunctions.SetFightMainNodeVisible(2,"Joystick",true)
			self.titleKey[4]=false
		end






		if self.dialogList[27].state==self.dialogStateEnum.NotPlaying
			and self.title[1]==true then

			BehaviorFunctions.StartStoryDialog(self.dialogList[27].Id)
			self.dialogList[27].state=self.dialogStateEnum.Playing
			self.title[1]=false
		end


		if self.dialogList[27].state==self.dialogStateEnum.PlayOver
			and self.linshiList[1]==true then
			BehaviorFunctions.SetEntityElementStateAccumulation(self.battleTarget,self.battleTarget,-1,100)


			self.linshiList[1]=false
			self:TipsInform("title",12,0.5)
		end




		--首次释放技能

		if self.title[12]== true then
			BehaviorFunctions.ShowTopTarget(self.topTipsList[1].Id)
			BehaviorFunctions.SetFightMainNodeVisible(2,"I",true) --技能按钮
			BehaviorFunctions.PlayGuide(self.guideList[13].Id,1)
			self.guideList[13].state=self.guideStateEnum.Playing
			self.title[12]=false
		end


		--没命中的时候始终给玩家充能
		if self.guideList[13].state==self.guideStateEnum.Playing then
			BehaviorFunctions.SetSkillPoint(self.role,FightEnum.RoleSkillPoint.Normal,2)
		end
		
		--当进入元素状态时
		if self.currentElement==self.maxElement
			and self.linshiList[2]==true then
			BehaviorFunctions.TopTargetFinish(1)
			BehaviorFunctions.FinishGuide(self.guideList[13].Id,1)
			--播放指引
			BehaviorFunctions.PlayGuide(self.guideList[1].Id,1)
			BehaviorFunctions.SetFightMainNodeVisible(2,"J",false)
			BehaviorFunctions.SetFightMainNodeVisible(2,"I",false)


			self.linshiList[2]=false

		end


		--暂停QTE
		if BehaviorFunctions.HasEntitySign(1,10000028) then
			self:TipsInform("guideStart",1,0.1)

		end


		--关闭指引
		if self.QTENum==1 then

			BehaviorFunctions.FinishGuide(self.guideList[1].Id,1)
		end
		
		--当QTE技能释放玩，则会有以下skillsign
		if   BehaviorFunctions.GetSkillSign(self.role,10000012)
			and self.titleKey[5]== true then
			local closeCallback =function()
				self:ButtonShow()
			end

			--释放技能视频
			BehaviorFunctions.ShowGuideImageTips(20011,closeCallback)

			self.titleKey[5]= false

			--不攻击说话
			self.noHitBattleTargetKey = true
			self.currentElement=0
		end


		if self.Button==true then
			BehaviorFunctions.StartStoryDialog(self.dialogList[11].Id)
			self.dialogList[11].state=self.dialogStateEnum.Playing

			self.attackNum=0
			self.QTENum=0
			self.skillOnePointNum=0

			BehaviorFunctions.FinishGuide(self.guideList[1].Id,1)
			self.Button=false
		end


		if self.dialogList[11].state ==self.dialogStateEnum.PlayOver
			and self.linshiList[9]==true then
			BehaviorFunctions.ShowCommonTitle(5,"积攒离歌坏相",true)
			self:TipsInform("tipsFinish",1,5)
			self.linshiList[9]=false

		end



		if self.titleFin[1]==true then

			self.missionState=11

			self.titleFin[1]=false

		end




	end





	--阶段3：释放月相技能
	if self.missionState==11 then



		if self.missionStateKey[11]==true then
			--清空核心被动
			if BehaviorFunctions.GetEntityAttrVal(self.role,1204)~=0 then
				BehaviorFunctions.SetEntityAttr(self.role,1204,0,1)
			end

			BehaviorFunctions.SetFightMainNodeVisible(2,"Core",true) --核心被动能量
			BehaviorFunctions.StartStoryDialog(self.dialogList[12].Id)

			--常驻普攻积攒能量提示（两个tips,需要额外功能）
			BehaviorFunctions.PlayGuide(self.guideList[4].Id,1)
			self.guideList[9].state = self.guideStateEnum.Playing

			BehaviorFunctions.SetSkillPoint(self.role,FightEnum.RoleSkillPoint.Normal,0)
			BehaviorFunctions.SetSkillPoint(self.role,FightEnum.RoleSkillPoint.Ex,3)
			self.noHitBattleTargetKey = false
			self.missionStateKey[11]=false
			BehaviorFunctions.SetCoreUIEnable(self.role,true)

		end





		if self.dialogList[12].state==self.dialogStateEnum.PlayOver
			and self.titleKey[11]==true then
			BehaviorFunctions.ShowCommonTitle(4,"释放月相技能",true)
			self:TipsInform("title",5,6)
			BehaviorFunctions.FinishGuide(self.guideList[4].Id,1)
			self.titleKey[11]=false
		end


		--通过视频告知月相技能释放效果
		if self.title[5]== true then
			local closeCallback =function()
				self:ButtonShow()
			end
			--释放技能视频
			BehaviorFunctions.ShowGuideImageTips(20017,closeCallback)
			self.title[5] = false
		end

		--出现头部目标指引
		if self.Button ==true
			and self.guideList[5].state == self.guideStateEnum.Default then
			--释放技能指引
			self:TipsInform("guideStart",5,0.5)
			BehaviorFunctions.ShowTopTarget(self.topTipsList[5].Id)
			self.noHitBattleTargetKey = false
			self.Button = false
		end



		if self.guideList[4].state==self.guideStateEnum.PlayOver
			and self.guideList[5].state==self.guideStateEnum.NotPlaying then
			BehaviorFunctions.SetFightMainNodeVisible(2,"I",true) --攻击按钮
			BehaviorFunctions.PlayGuide(self.guideList[5].Id,1)
			self.guideList[5].state = self.guideStateEnum.Playing

		end





		--蓝球指引
		if self.blueBallNum==1 then
			BehaviorFunctions.TopTargetFinish(1)
			BehaviorFunctions.SetFightMainNodeVisible(2,"I",false) --攻击按钮
			BehaviorFunctions.FinishGuide(self.guideList[5].Id,1)
			BehaviorFunctions.SetEntityAttr(self.role,1204,1,1)
		end


		--如果上面的tips完成，那么播阶段完成动画
		if self.topTipsList[5].state ==self.topTipsEnum.PlayOver
			and self.blueBallNum==1 then

			BehaviorFunctions.ShowCommonTitle(5,"释放月相技能",true)
			self:TipsInform("tipsFinish",5,4)
			self.blueBallNum=0

		end

		--进入下一阶段
		if self.titleFin[5]==true then
			BehaviorFunctions.StartStoryDialog(self.dialogList[13].Id)

			self.missionState =12
		end
	end



	--阶段4：释放核心被动
	if self.missionState==7 then
		BehaviorFunctions.SetEntityElementStateAccumulation(self.battleTarget,self.battleTarget,-1,0)





		--释放技能要求
		if self.missionStateKey[7]==true then



			self.noHitBattleTargetKey = false
			BehaviorFunctions.SetEntityAttr(self.role,1204,100,1)
			--播放对白
			BehaviorFunctions.StartStoryDialog(self.dialogList[7].Id)



			--充满核心被动
			if BehaviorFunctions.GetEntityAttrVal(self.role,1204)~=0 then
				BehaviorFunctions.SetEntityAttr(self.role,1204,1,1)
			end
			BehaviorFunctions.SetSkillPoint(self.role,FightEnum.RoleSkillPoint.Normal,2)
			BehaviorFunctions.SetSkillPoint(self.role,FightEnum.RoleSkillPoint.Ex,0)
			self.guideList[10].state=self.guideStateEnum.Default



			self.missionStateKey[7]=false


		end


		--强指引说明炎印效果
		if self.dialogList[7].state==self.dialogStateEnum.PlayOver
			and self.guideList[22].state==self.guideStateEnum.Default
			and self.titleKey[7]==true then
			--播放指引
			BehaviorFunctions.PlayGuide(self.guideList[22].Id,1)
			self.guideList[22].state=self.guideStateEnum.Playing
			--常驻普攻积攒能量提示（两个tips,需要额外功能）
			BehaviorFunctions.AddBuff(self.role,self.role,200000008)
			BehaviorFunctions.AddBuff(self.battleTarget,self.battleTarget,200000008)
			BehaviorFunctions.AddBuff(self.role,self.role,200000009)


			self.titleKey[7]=false

		end


		--强指引结束，出现上头title
		if self.titleKey[6]== true
			and self.guideList[22].state==self.guideStateEnum.PlayOver then
			BehaviorFunctions.ShowCommonTitle(4,"释放信念技",true)
			self:TipsInform("title",2,6)
			self.titleKey[6] = false
			BehaviorFunctions.RemoveBuff(self.role,200000008)
			BehaviorFunctions.RemoveBuff(self.battleTarget,200000008)
			BehaviorFunctions.RemoveBuff(self.role,200000009)
		end



		--出现反馈目标
		if self.title[2]==true then

			BehaviorFunctions.ShowTopTarget(self.topTipsList[6].Id)
			BehaviorFunctions.SetFightMainNodeVisible(2,"I",true) --核心被动能量
			self.title[2]=false

			--出现技能指引
			self:TipsInform("guideStart",10,0.5)

		end



		--指引技能首次释放
		if  self.guideList[10].state==self.guideStateEnum.NotPlaying
			and self.guideState==0 then
			BehaviorFunctions.SetFightMainNodeVisible(2,"J",true) --核心被动能量

			BehaviorFunctions.PlayGuide(self.guideList[10].Id,1)
			self.guideList[10].state = self.guideStateEnum.Playing
			self.guideState=1
		end


		----释放完技能，指引炎印
		--if self.guideList[10].state==self.guideStateEnum.PlayOver
		--and self.guideState==1 then
		--BehaviorFunctions.PlayGuide(self.guideList[23].Id,1)

		--self.guideState=2
		--end


		--指引普攻点击
		if self.guideList[10].state==self.guideStateEnum.PlayOver
			and self.guideState==1
			and self.guideList[21].state == self.guideStateEnum.Default
			and self.skillTwoPointNum<3 then
			BehaviorFunctions.PlayGuide(self.guideList[21].Id,1)
			self.guideList[21].state = self.guideStateEnum.Playing
			self.guideState=2

		end

		--指引技能释放
		if self.guideList[21].state ==self.guideStateEnum.PlayOver
			and self.guideState==2
			and self.guideList[10].state==self.guideStateEnum.NotPlaying then
			BehaviorFunctions.PlayGuide(self.guideList[10].Id,1)
			self.guideList[10].state = self.guideStateEnum.Playing
		end








		--当核心充满，指引炎印
		if BehaviorFunctions.GetEntityAttrVal(self.role,1204)==3
			and self.guideList[24].state ==self.guideStateEnum.Default  then
			BehaviorFunctions.PlayGuide(self.guideList[24].Id,1)
			self.guideList[24].state = self.guideStateEnum.Playing
			BehaviorFunctions.AddBuff(self.role,self.role,200000008)
			BehaviorFunctions.AddBuff(self.battleTarget,self.battleTarget,200000008)
			BehaviorFunctions.AddBuff(self.role,self.role,200000009)

		end


		if self.guideList[24].state==self.guideStateEnum.PlayOver
			and self.skillCoreNum<1
			and BehaviorFunctions.GetEntityAttrVal(self.role,1204)~=3   then
			BehaviorFunctions.SetEntityAttr(self.role,1204,3,1)


		end

		--指引炎印结束，指引长按核心被动




		--指引长按释放普通攻击

		if  self.guideList[2].state ==self.guideStateEnum.Default
			and self.guideList[24].state==self.guideStateEnum.PlayOver then
			--显示核心被动能量
			BehaviorFunctions.PlayGuide(self.guideList[2].Id,1)

			self.guideList[2].state = self.guideStateEnum.Playing
			BehaviorFunctions.RemoveBuff(self.role,200000008)
			BehaviorFunctions.RemoveBuff(self.battleTarget,200000008)
			BehaviorFunctions.RemoveBuff(self.role,200000009)
		end


		if self.skillCoreNum==1 then
			BehaviorFunctions.TopTargetFinish(1)
			--去除长按普攻的指引
			BehaviorFunctions.FinishGuide(self.guideList[1].Id,1)
		end





		if  self.skillCoreNum==1
			and self.topTipsList[6].state == self.topTipsEnum.PlayOver then
			BehaviorFunctions.ShowCommonTitle(5,"释放信念技",true)
			BehaviorFunctions.SetFightMainNodeVisible(2,"J",false) --闪避按钮
			self:TipsInform("tipsFinish",6,4)
			self.attackFrame = BehaviorFunctions.GetEntityFrame(self.role)
			--不攻击说话
			self.noHitBattleTargetKey = true
			self.skillCoreNum = 0
		end

		if self.titleFin[6]==true then
			BehaviorFunctions.StartStoryDialog(self.dialogList[8].Id)
			self.skillCoreNum=0
			self.skillOnePointNum=0
			BehaviorFunctions.FinishGuide(self.guideList[2].Id,1)
			self.missionState=8
		end


	end


	--阶段7：失衡教学
	if self.missionState==10 then
		

		BehaviorFunctions.ClearAllInput()
		
		--释放技能要求,初始化按钮情况
		if self.missionStateKey[16]==true then

			BehaviorFunctions.ShowTopTarget(self.topTipsList[7].Id)
			BehaviorFunctions.SetFightMainNodeVisible(2,"J",false) --技能按钮
			BehaviorFunctions.SetFightMainNodeVisible(2,"K",false) --技能按钮
			BehaviorFunctions.SetFightMainNodeVisible(2,"I",true) --技能按钮
			self.noHitBattleTargetKey = false
			if BehaviorFunctions.GetEntityAttrVal(self.role,1204)~=0 then
				BehaviorFunctions.SetEntityAttr(self.role,1204,0,1)
			end
			BehaviorFunctions.SetCoreUIEnable(self.role,false)

			self.cameraRemove=BehaviorFunctions.GetEntityFrame(self.role)
			self.missionStateKey[16]=false
		end

		BehaviorFunctions.SetEntityElementStateAccumulation(self.battleTarget,self.battleTarget,-1,0)
		
		if BehaviorFunctions.GetEntityAttrVal(self.role,1204)~=0 then
			BehaviorFunctions.SetEntityAttr(self.role,1204,0,1)
		end

		--移除关卡相机
		if self.cameraRemove
			and BehaviorFunctions.GetEntityFrame(self.role)-self.cameraRemove>30 then
			self.cameraRemove=nil
			if BehaviorFunctions.CheckEntity(self.levelCam) then
				BehaviorFunctions.RemoveEntity(self.levelCam)
				BehaviorFunctions.RemoveEntity(self.empty)
			end
			BehaviorFunctions.ShowBlackCurtain(false,0.5)
			BehaviorFunctions.SetSkillPoint(self.role,FightEnum.RoleSkillPoint.Normal,2)
		end



		--消耗完技能点时，把所有按钮给扣掉，离歌开始放技能
		if self.skillOnePointNum==1
			and self.linshiList[8]==true
			and self.dialogList[24].state==self.dialogStateEnum.NotPlaying then
			--预留叙幕对话：坏了，已经没有日相能量了
			self.linshiList[8]=false
			self.dialogList[24].state=self.dialogStateEnum.Playing
			BehaviorFunctions.StartStoryDialog(self.dialogList[24].Id)


			BehaviorFunctions.SetSkillPoint(self.role,FightEnum.RoleSkillPoint.Normal,0)
			BehaviorFunctions.CancelJoystick()
			BehaviorFunctions.SetFightMainNodeVisible(2,"I",false) --技能按钮
			BehaviorFunctions.SetFightMainNodeVisible(2,"K",false) --闪避按钮
			BehaviorFunctions.SetFightMainNodeVisible(2,"J",false) --闪避按钮
			BehaviorFunctions.SetFightMainNodeVisible(2,"Joystick",false)
			self.linshiList[8]= false


			BehaviorFunctions.TopTargetFinish(1)
			self.skillOnePointNum=0
		end
		
		
		if self.dialogList[24].state==self.dialogStateEnum.PlayOver
			and self.titleKey[16]==true then
			--停止走离歌自身的游荡逻辑
			BehaviorFunctions.SetEntityValue(self.battleTarget,"stopMove",true)
			BehaviorFunctions.DoSetMoveType(self.battleTarget,FightEnum.EntityMoveSubState.Walk)
			BehaviorFunctions.SetEntityValue(self.battleTarget,"skillList",self.skillList)
			BehaviorFunctions.DoLookAtTargetImmediately(self.battleTarget,self.role)
			--能量条指引
			BehaviorFunctions.PlayGuide(self.guideList[12].Id,1)

			self.titleKey[16]=false
		end






		if BehaviorFunctions.GetBuffCount(self.role,1000008)==1  then
			self.stunKey = true
			BehaviorFunctions.SetEntityValue(self.battleTarget,"skillList",{})
		end



		if self.stunKey==true
			and self.lingshi==true
			and self.dialogList[26].state==self.dialogStateEnum.NotPlaying
			and self.dialogList[25].state==self.dialogStateEnum.PlayOver then
			self.lingshi=false
			BehaviorFunctions.SetFightMainNodeVisible(2,"Joystick",true)
			
			--重新让离歌走游荡逻辑
			BehaviorFunctions.SetEntityValue(self.battleTarget,"stopMove",nil)
			BehaviorFunctions.StartStoryDialog(self.dialogList[26].Id)
			self.dialogList[26].state=self.dialogStateEnum.Playing
		end


		--眩晕结束，开始播放视频教学
		if BehaviorFunctions.GetBuffCount(self.role,1000008)==0
			and self.dialogList[26].state==self.dialogStateEnum.PlayOver
			and self.stunKey== true
			and self.topTipsList[7].state==self.topTipsEnum.PlayOver then
			BehaviorFunctions.FinishGuide(self.guideList[12].Id,1)

			local closeCallback =function()
				self:ButtonShow()
			end
			BehaviorFunctions.ShowGuideImageTips(20019,closeCallback)
			self.stunKey = false


		end
		
		--关闭视频教学进入下一阶段
		if self.Button ==true then
			self.Button =false
			self.missionState=13
		end
	end





	--阶段7：闪避示范教学
	if self.missionState==13 then
		if BehaviorFunctions.GetEntityAttrVal(self.role,1204)~=0 then
			BehaviorFunctions.SetEntityAttr(self.role,1204,0,1)
		end
		
		BehaviorFunctions.ClearAllInput()
		BehaviorFunctions.SetEntityElementStateAccumulation(self.battleTarget,self.battleTarget,-1,0)

		----初始化条件
		if  self.missionStateKey[13] == true then
			BehaviorFunctions.StartStoryDialog(self.dialogList[16].Id)
			BehaviorFunctions.CancelJoystick()
			BehaviorFunctions.SetFightMainNodeVisible(2,"Joystick",false)


			self.missionStateKey[13] = false
			if BehaviorFunctions.GetEntityAttrVal(self.role,1204)~=0 then
				BehaviorFunctions.SetEntityAttr(self.role,1204,0,1)
			end
		end

		if self.titleKey[13]==true
			and self.dialogList[16].state==self.dialogStateEnum.PlayOver then
			BehaviorFunctions.ShowCommonTitle(4,"成功闪避离歌的攻击",true)
			self:TipsInform("title",6,6)
			self.titleKey[13]=false
		end


		--第一次闪避
		if  self.title[6]==true
			and self.guideList[6].state == self.guideStateEnum.Default then
			self:TipsInform("guideStart",6,0.5)

			--屏蔽按钮
			BehaviorFunctions.SetFightMainNodeVisible(2,"K",true) --闪避按钮
			BehaviorFunctions.ForbidKey(FightEnum.KeyEvent.Dodge,true)

			BehaviorFunctions.ShowTopTarget(self.topTipsList[8].Id)
			BehaviorFunctions.SetEntityValue(self.battleTarget,"skillList",self.skillList)
			self.noHitBattleTargetKey = false
			self.Button = false
		end


		if self.moveNum==3 then
			BehaviorFunctions.TopTargetFinish(1)
		end




		--清空极限闪避的CD
		if BehaviorFunctions.GetDodgeLimitState(self.role)~=1 then
			BehaviorFunctions.SetDodgeCoolingTime(self.role,0,13)
		end


		----检测离歌发起攻击的时机,第一次用时停教学。可能有一点问题。skilldelay[1]释放技能一定帧数后，会变成true
		if self.skillDelay[1]==true
			and self.dodgeKey == true
			and self.guideList[6].state ==self.guideStateEnum.NotPlaying then
			BehaviorFunctions.ForbidKey(FightEnum.KeyEvent.Dodge,false)
			BehaviorFunctions.SetFightMainNodeVisible(2,"Joystick",true)
			BehaviorFunctions.PlayGuide(self.guideList[6].Id,1)
			self.guideList[6].state = self.guideStateEnum.Playing
			BehaviorFunctions.AddBuff(self.role,self.role,200000008)
			BehaviorFunctions.AddBuff(self.battleTarget,self.battleTarget,200000008)
			BehaviorFunctions.AddBuff(self.role,self.role,200000009)
			self.skillDelay[1]=false
			self.canClose = false
			self.dodgeKey = false
		end
		
		

		--检测按钮是否按下，解除时停
		if BehaviorFunctions.CheckKeyDown(FightEnum.KeyEvent.Dodge) and BehaviorFunctions.HasBuffKind(self.battleTarget,200000008) then
			BehaviorFunctions.RemoveBuff(self.battleTarget,200000008)
			BehaviorFunctions.RemoveBuff(self.role,200000008)
			BehaviorFunctions.RemoveBuff(self.role,200000009)
			--用于避免操作卡死
			self.dodgeTutorialStart = BehaviorFunctions.GetEntityFrame(self.role)
			self.dodgeGuideKey = false
			self.guideAgain = true
		end


		if self.moveNum ==1 and not self.dodgeTime then
			self.dodgeTime = BehaviorFunctions.GetEntityFrame(self.role)
		end
		
		--开出攻击按钮，时停
		if self.moveNum == 1
			and not self.buffExtra
			and self.dodgeTime
			and self.roleTotalFrame-self.dodgeTime>30 then
			BehaviorFunctions.FinishGuide(self.guideList[13].Id,1)
			BehaviorFunctions.AddBuff(self.role,self.role,200000008)
			BehaviorFunctions.AddBuff(self.battleTarget,self.battleTarget,200000008)
			BehaviorFunctions.AddBuff(self.role,self.role,200000009)
			BehaviorFunctions.SetFightMainNodeVisible(2,"J",true) --攻击按钮
			BehaviorFunctions.SetEntityValue(self.battleTarget,"skillList",{})
			BehaviorFunctions.PlayGuide(self.guideList[14].Id,1)
			self.buffExtra = true
		end
		
		--按下攻击按钮后，时停结束
		if BehaviorFunctions.CheckKeyDown(FightEnum.KeyEvent.Attack)
			and self.buffExtra == true
			and BehaviorFunctions.HasBuffKind(self.battleTarget,200000008) then
			BehaviorFunctions.RemoveBuff(self.battleTarget,200000008)
			BehaviorFunctions.RemoveBuff(self.role,200000008)
			BehaviorFunctions.RemoveBuff(self.role,200000009)
			self.dodgeAttackTime = BehaviorFunctions.GetEntityFrame(self.role)
			self.buffExtraKey = false
		end

		if self.dodgeAttackTime
			and BehaviorFunctions.GetEntityFrame(self.role)-self.dodgeAttackTime>30
			and self.dialogList[14].state==self.dialogStateEnum.NotPlaying then
			self.dodgeAttackTime=nil
			BehaviorFunctions.StartStoryDialog(self.dialogList[14].Id)
			self.dialogList[14].state=self.dialogStateEnum.Playing

		end

		--第一次闪避教学结束
		if self.dialogList[14].state==self.dialogStateEnum.PlayOver
			and self.titleKey[12]==true then
			local closeCallback =function()
				self:ButtonShow()
			end

			BehaviorFunctions.ShowGuideImageTips(20006,closeCallback)

			self.titleKey[12]=false
		end


		if self.Button==true then
			BehaviorFunctions.SetEntityValue(self.battleTarget,"skillList",self.skillList)
			self.Button=false
		end
		
		
		--后两次闪避的教学指引
		if self.dodgeGuideKey==true
			and self.moveNum<3
			and self.dialogList[14].state==self.dialogStateEnum.PlayOver
			and self.moveNum>=1 then
			BehaviorFunctions.PlayGuide(self.guideList[6].Id,1)
			self.dodgeGuideKey=false
		end





		self.dodgeTutorialEnd = BehaviorFunctions.GetEntityFrame(self.role)
		
		
		--闪避任务完成
		if self.moveNum==3
			and self.topTipsList[8].state == self.topTipsEnum.PlayOver
			and self.finishGuide ==true then
			BehaviorFunctions.ShowCommonTitle(5,"成功闪避离歌的攻击",true)

			BehaviorFunctions.SetEntityValue(self.battleTarget,"skillList",{})



			BehaviorFunctions.SetFightMainNodeVisible(2,"J",false) --攻击按钮
			BehaviorFunctions.SetFightMainNodeVisible(2,"K",false) --闪避按钮
			BehaviorFunctions.SetFightMainNodeVisible(2,"I",false) --技能按钮
			self.finishGuide = false
		end
		
		
		--超时强制完成任务
		if self.dodgeTutorialStart
			and self.finishGuide ==true
			and self.moveNum<3
			--当时间超过2分钟时，将会进入下一阶段教学
			and self.dodgeTutorialEnd-self.dodgeTutorialStart>1800 then
			BehaviorFunctions.SetEntityValue(self.battleTarget,"skillList",{})
			BehaviorFunctions.SetFightMainNodeVisible(2,"J",false) --攻击按钮
			BehaviorFunctions.SetFightMainNodeVisible(2,"K",false) --闪避按钮
			BehaviorFunctions.SetFightMainNodeVisible(2,"I",false) --技能按钮
			self.finishGuide = false
			BehaviorFunctions.StartStoryDialog(self.dialogList[15].Id)
			--BehaviorFunctions.SetEntityValue(self.battleTarget,"stopMove",true)
			BehaviorFunctions.FinishGuide(self.guideList[6].Id,1)
			BehaviorFunctions.TopTargetFinish(1)
			self.missionState = 14


		end




		----记录玩家成功闪避的次数,需要等离歌动作结束后，才开始进入timeline
		if self.moveNum==3
			and BehaviorFunctions.CanCtrl(self.battleTarget)
			and self.topTipsList[8].state == self.topTipsEnum.PlayOver  then

			BehaviorFunctions.StartStoryDialog(self.dialogList[15].Id)
			BehaviorFunctions.SetEntityValue(self.battleTarget,"skillList",{})

			--在进入下阶段教学的时候，需要先把当前的技能库清空，不然会出现台词没说完就开始打的情况。但是这里好像没办法传值过去。

			self.missionState = 14
		end
	end




	--关卡阶段10： 离歌跳反教学。
	if self.missionState == 15 then
		if BehaviorFunctions.GetEntityAttrVal(self.role,1204)~=0 then
			BehaviorFunctions.SetEntityAttr(self.role,1204,0,1)
		end

		BehaviorFunctions.SetEntityElementStateAccumulation(self.battleTarget,self.battleTarget,-1,0)
		----初始化条件
		if  self.missionStateKey[22] == true then
			BehaviorFunctions.SetEntityValue(self.battleTarget,"stopMove",nil)
			BehaviorFunctions.ShowCommonTitle(4,"成功跳反离歌的攻击",true)
			self:TipsInform("title",10,6)
			self.missionStateKey[22] = false
		end




		if BehaviorFunctions.GetEntityAttrVal(self.role,1204)~=0 then
			BehaviorFunctions.SetEntityAttr(self.role,1204,0,1)
		end






		if self.title[10]==true
			and self.guideList[16].state == self.guideStateEnum.Default then
			BehaviorFunctions.SetEntityValue(self.battleTarget,"skillList",self.skillList3)
			self:TipsInform("guideStart",16,0.5)
			BehaviorFunctions.ShowTopTarget(self.topTipsList[10].Id)
			BehaviorFunctions.SetFightMainNodeVisible(2,"O",true) --攻击按钮
			BehaviorFunctions.ForbidKey(FightEnum.KeyEvent.Jump,true)
			self.noHitBattleTargetKey = false
			self.title[10] = false

		end





		if self.reboundGuideKey == true
			and self.weakGuideFree ==true
			and self.guideAgain2
			and self.guideAgain2 == true
			and self.reboundAttack <3 then
			BehaviorFunctions.PlayGuide(self.guideList[16].Id,1)
			self.guideList[16].state = self.guideStateEnum.Playing
			self.weakGuideFree = false
			self.reboundGuideKey = false
		end



		--离歌跳反用时停
		if self.skillDelay[3]==true
			and self.guideList[16].state ==self.guideStateEnum.NotPlaying then
			BehaviorFunctions.ForbidKey(FightEnum.KeyEvent.Jump,false)
			BehaviorFunctions.PlayGuide(self.guideList[16].Id,1)
			self.guideList[16].state = self.guideStateEnum.Playing
			BehaviorFunctions.AddBuff(self.role,self.role,200000008)
			BehaviorFunctions.AddBuff(self.battleTarget,self.battleTarget,200000008)
			BehaviorFunctions.AddBuff(self.role,self.role,200000009)
			BehaviorFunctions.PauseQTE(true)
			self.skillDelay[3]=false
			self.skillSign = false
		end

		if BehaviorFunctions.CheckKeyDown(FightEnum.KeyEvent.Jump) and BehaviorFunctions.HasBuffKind(self.battleTarget,200000008) then
			BehaviorFunctions.RemoveBuff(self.battleTarget,200000008)
			BehaviorFunctions.RemoveBuff(self.role,200000008)
			BehaviorFunctions.RemoveBuff(self.role,200000009)
			self.jumpStart=BehaviorFunctions.GetEntityFrame(self.role)
			self:TipsInform("title",9,4)
			BehaviorFunctions.SetEntityValue(self.battleTarget,"skillList",{})
			self.guideAgain2 = true
			self.dodgeGuideKey = false
			self.canClose2 = false
		end



		if  self.title[9]==true  then
			local closeCallback =function()
				self:ButtonShow()
			end

			BehaviorFunctions.ShowGuideImageTips(20018,closeCallback)
			self.title[9] = false
		end

		if self.Button==true then
			BehaviorFunctions.SetEntityValue(self.battleTarget,"skillList",self.skillList3)
			self.Button=false

		end



		self.jumpEnd=BehaviorFunctions.GetEntityFrame(self.role)
		
		--跳反次数等于3次
		if self.jump==3 then
			BehaviorFunctions.TopTargetFinish(1)
			BehaviorFunctions.SetEntityValue(self.battleTarget,"skillList",{})
		end






		--清理弹刀按钮卡住情况
		BehaviorFunctions.ClearAllInput()



		if self.jump == 3
			and self.topTipsList[10].state == self.topTipsEnum.PlayOver
			and not self.jumpTime then
			BehaviorFunctions.FinishGuide(self.guideList[16].Id,1)
			BehaviorFunctions.ShowCommonTitle(5,"成功跳反离歌的攻击",true)
			BehaviorFunctions.SetTipsGuideState(false)
			self.jumpTime = BehaviorFunctions.GetEntityFrame(self.role)
			BehaviorFunctions.SetFightMainNodeVisible(2,"J",false) --攻击按钮
			BehaviorFunctions.SetFightMainNodeVisible(2,"K",false) --闪避按钮
			BehaviorFunctions.SetFightMainNodeVisible(2,"I",false) --技能按钮
			BehaviorFunctions.SetFightMainNodeVisible(2,"O",false) --技能按钮

		end
		
		--超时关卡结束
		if  self.jumpStart
			and self.jump < 3
			and self.jumpEnd-self.jumpStart>1800 then
			BehaviorFunctions.FinishGuide(self.guideList[16].Id,1)
			BehaviorFunctions.SetTipsGuideState(false)
			BehaviorFunctions.SetEntityValue(self.battleTarget,"skillList",{})
			BehaviorFunctions.SetFightMainNodeVisible(2,"J",false) --攻击按钮
			BehaviorFunctions.SetFightMainNodeVisible(2,"K",false) --闪避按钮
			BehaviorFunctions.SetFightMainNodeVisible(2,"I",false) --技能按钮
			BehaviorFunctions.SetFightMainNodeVisible(2,"O",false) --技能按钮
			BehaviorFunctions.SetEntityValue(self.battleTarget,"stopMove",true)
			BehaviorFunctions.TopTargetFinish(1)

			BehaviorFunctions.StartStoryDialog(self.dialogList[21].Id)
			self.missionState = 23
			self.jump = 0
		end
		
		--关卡结束
		if self.jump ==3
			and self.jumpTime
			and BehaviorFunctions.CanCtrl(self.battleTarget)
			and self.roleTotalFrame-self.jumpTime>90 then
			BehaviorFunctions.SetEntityValue(self.battleTarget,"stopMove",true)
			BehaviorFunctions.SetEntityValue(self.battleTarget,"skillList",{})

			BehaviorFunctions.StartStoryDialog(self.dialogList[21].Id)
			self.missionState = 23
			self.jump = 0
		end
	end


	if self.missionState == 24 then

		----初始化条件
		if  self.missionStateKey[24] == true then
			--回满血
			BehaviorFunctions.ShowBlackCurtain(false,0.5)
			BehaviorFunctions.ChangeEntityAttr(self.battleTarget,1001,self.life,1)
			BehaviorFunctions.ShowCommonTitle(4,"使用五行绝技击中离歌",true)
			BehaviorFunctions.SetEntityValue(self.battleTarget,"stopMove",nil)
			self:TipsInform("title",11,6)
			self.missionStateKey[24] = false
			BehaviorFunctions.AddEntityElementStateAccumulation(self.role,self.battleTarget,-1,-300)

			self.cameraRemove=BehaviorFunctions.GetEntityFrame(self.role)

		end
		
		--清理卡摇杆问题
		BehaviorFunctions.ClearAllInput()



		--移除关卡相机
		if self.cameraRemove
			and BehaviorFunctions.GetEntityFrame(self.role)-self.cameraRemove>30 then
			self.cameraRemove=nil
			if BehaviorFunctions.CheckEntity(self.levelCam) then
				BehaviorFunctions.RemoveEntity(self.levelCam)
				BehaviorFunctions.RemoveEntity(self.empty)
			end
			BehaviorFunctions.ShowBlackCurtain(false,0.5)
		end


		--清空核心被动
		if BehaviorFunctions.GetEntityAttrVal(self.role,1204)~=0 then
			BehaviorFunctions.SetEntityAttr(self.role,1204,0,1)
		end

		self.finishTLEnd = BehaviorFunctions.GetEntityFrame(self.role)


		if self.title[11] == true
			and self.finishKey==true then
			BehaviorFunctions.SetEntityValue(self.battleTarget,"skillList",self.skillList4)
			BehaviorFunctions.ShowTopTarget(self.topTipsList[11].Id)


			self.finishTLStart=BehaviorFunctions.GetEntityFrame(self.role)
			BehaviorFunctions.StartStoryDialog(self.dialogList[22].Id)
			BehaviorFunctions.SetFightMainNodeVisible(2,"J",true) --攻击按钮
			BehaviorFunctions.SetFightMainNodeVisible(2,"K",true) --闪避按钮
			BehaviorFunctions.SetFightMainNodeVisible(2,"I",true) --技能按钮
			BehaviorFunctions.SetFightMainNodeVisible(2,"O",true) --技能按钮
			self.finishKey=false
		end



		if not self.finishDialog then
			if self.QTENum==1 then
				BehaviorFunctions.TopTargetFinish(2)

				self.finishDialog =BehaviorFunctions.GetEntityFrame(self.role)
				BehaviorFunctions.SetEntityValue(self.battleTarget,"skillList",{})
			elseif self.beHitNum==10 then
				BehaviorFunctions.TopTargetFinish(1)
				self.finishDialog =BehaviorFunctions.GetEntityFrame(self.role)
				BehaviorFunctions.SetEntityValue(self.battleTarget,"skillList",{})
			end
		end
		
		--将整个tips关闭
		if self.finishDialog
			and self.roleTotalFrame-self.finishDialog>30 then
			BehaviorFunctions.TopTargetFinish(nil,true)
		end

		if self.topTipsList[11].state == self.topTipsEnum.PlayOver
			and self.QTENum==1 then
			BehaviorFunctions.ShowCommonTitle(5,"使用五行绝技击中离歌",true)
			self:TipsInform("title",13,4)
			self.QTENum=0

		end
		
		--教学关结束
		if  self.finishDialog
			and self.title[13]==true
			and self.dialogList[23].state == self.dialogStateEnum.NotPlaying
			and self.roleTotalFrame-self.finishDialog>90 then
			BehaviorFunctions.StartStoryDialog(self.dialogList[23].Id)
			self.dialogList[23].state = self.dialogStateEnum.Playing
			if self.battleTarget
				 and BehaviorFunctions.CheckEntity(self.battleTarget) then
				BehaviorFunctions.RemoveEntity(self.battleTarget)
			end
			self.title[13]=false
			self.missionState = 25

		end
		
		--教学超时保底
		if self.finishTLStart
			and self.dialogList[23].state == self.dialogStateEnum.NotPlaying
			and self.roleTotalFrame-self.finishTLStart>2700
			or  (self.beHitNum>=10
				and self.finishDialog
				and self.roleTotalFrame-self.finishDialog>90) then
			self.dialogList[23].state = self.dialogStateEnum.Playing
			BehaviorFunctions.StartStoryDialog(self.dialogList[23].Id)
			if BehaviorFunctions.CheckEntity(self.battleTarget) then
				BehaviorFunctions.RemoveEntity(self.battleTarget)
			end
			self.missionState = 25
		end

	end






	if self.missionState==25 then
		if BehaviorFunctions.CheckEntity(self.battleTarget) then
			BehaviorFunctions.RemoveEntity(self.battleTarget)
		end
	end

	if self.missionState== 26 then
		--BehaviorFunctions.SetDuplicateResult(true)
		BehaviorFunctions.AddDelayCallByFrame(5,BehaviorFunctions,BehaviorFunctions.SetDuplicateResult,true)
		BehaviorFunctions.SendTaskProgress(101062201,1,1)
		BehaviorFunctions.StopBgmSound()
		BehaviorFunctions.SetActiveBGM("TRUE")
		self.missionState = 27
	end

	--当怪物破霸体的时候，需要将怪物的霸体值回满
	if BehaviorFunctions.CheckEntity(self.battleTarget)
		and BehaviorFunctions.GetEntityAttrVal(self.battleTarget,1007)==0 then
		BehaviorFunctions.ChangeEntityAttr(self.battleTarget,1007,self.defend,1)
	end
	--当怪物生命值低的时候，需要将怪物的血量回满
	if BehaviorFunctions.CheckEntity(self.battleTarget)
		and BehaviorFunctions.GetEntityAttrVal(self.battleTarget,1001)<10000 then
		BehaviorFunctions.ChangeEntityAttr(self.battleTarget,1001,self.life,1)
	end

	--当角色生命值低的时候，需要将角色的血量回满
	if BehaviorFunctions.CheckEntity(self.role)
		and BehaviorFunctions.GetEntityAttrVal(self.role,1001)<5000 then
		BehaviorFunctions.ChangeEntityAttr(self.role,1001,self.roleLife,1)
	end


	--每一阶段开始时，都需要把血量回满

	--self:InitCondition()

	if (self.missionState ==3
			or self.missionState ==10
			or self.missionState ==12
			or self.missionState ==14
			or self.missionState ==5
			or self.missionState==7)
		and self.noHitBattleTargetTime
		and self.roleTotalFrame-self.noHitBattleTargetTime>210
		and not BehaviorFunctions.GetNowPlayingId() then
		--if self.dialogReactionList[3].state == self.dialogStateEnum.NotPlaying then
		--BehaviorFunctions.StartStoryDialog(self.dialogReactionList[3].Id)
		--self.dialogReactionList[3].state = self.dialogStateEnum.PlayOver

		--return
		--elseif self.dialogReactionList[4].state == self.dialogStateEnum.NotPlaying then
		--BehaviorFunctions.StartStoryDialog(self.dialogReactionList[4].Id)
		--self.dialogReactionList[4].state = self.dialogStateEnum.PlayOver
		--return
		--else
		--BehaviorFunctions.StartStoryDialog(self.dialogReactionList[5].Id)
		--self.dialogReactionList[5].state = self.dialogStateEnum.PlayOver
		--end





	end



end


--timeline开始
function LevelBehavior30010:StoryStartEvent(dialogId)
	--清除按钮状况
	BehaviorFunctions.ClearAllInput()
	self.noHitBattleTargetTime = BehaviorFunctions.GetEntityFrame(self.role)
	self.noHitBattleTargetKey = true
	for i,v in ipairs(self.dialogList) do
		if dialogId == v.Id then
			v.state = self.dialogStateEnum.NotPlaying
			self.currentDialog = v.Id
			--将不能移动的模型隐藏
			if v.kind == self.dialogKindEnum.CanNotMove then
				if BehaviorFunctions.CheckEntity(self.role)
					and not BehaviorFunctions.HasBuffKind(self.role,900000010) then
					BehaviorFunctions.AddBuff(self.role,self.role,900000010)
				end
				if BehaviorFunctions.CheckEntity(self.battleTarget)
					and not BehaviorFunctions.HasBuffKind(self.battleTarget,900000010) then
					BehaviorFunctions.AddBuff(self.battleTarget,self.battleTarget,900000010)
				end





			end
			--用于隐藏按钮
			if i==2  or i ==4 or i==7  or i==9  or i==11 then
				BehaviorFunctions.SetFightMainNodeVisible(2,"J",false) --攻击按钮
				BehaviorFunctions.SetFightMainNodeVisible(2,"O",false) --跳跃按钮
				BehaviorFunctions.SetFightMainNodeVisible(2,"K",false) --闪避按钮
				BehaviorFunctions.SetFightMainNodeVisible(2,"I",false) --技能按钮

			end
		end

	end
end


--timeline结束
function LevelBehavior30010:StoryEndEvent(dialogId)
	--清除按钮状况
	BehaviorFunctions.ClearAllInput()
	self.noHitBattleTargetKey = false
	if dialogId==self.dialogReactionList[1].Id then
		self.dialogReactionList[1].state = self.dialogStateEnum.NotPlaying
	end
	if dialogId==self.dialogReactionList[2].Id then
		self.dialogReactionList[2].state = self.dialogStateEnum.NotPlaying
	end


	if dialogId==self.dialogReactionList[3].Id
		or dialogId==self.dialogReactionList[4].Id
		or dialogId==self.dialogReactionList[5].Id then
		self.noHitBattleTargetTime = BehaviorFunctions.GetEntityFrame(self.role)
	end

	for i,v in ipairs(self.dialogList) do
		if dialogId == v.Id then
			--当不能动的timeline播完时，需要把buff去掉。
			if v.kind == self.dialogKindEnum.CanNotMove  then
				if BehaviorFunctions.CheckEntity(self.role)
					and BehaviorFunctions.HasBuffKind(self.role,900000010) then
					BehaviorFunctions.RemoveBuff(self.role,900000010)
				end
				if BehaviorFunctions.CheckEntity(self.battleTarget)
					and BehaviorFunctions.HasBuffKind(self.battleTarget,900000010) then
					BehaviorFunctions.RemoveBuff(self.battleTarget,900000010)
				end

				--将离歌和角色重置到原来位置
				local pb1 = BehaviorFunctions.GetTerrainPositionP("characterBorn",20010007)

				BehaviorFunctions.DoSetPosition(self.role,pb1.x,pb1.y,pb1.z)

				local rot1 = BehaviorFunctions.GetTerrainRotationP("characterBorn",20010007)

				BehaviorFunctions.SetEntityEuler(self.role,rot1.x,rot1.y,rot1.z)



				if 	BehaviorFunctions.CheckEntity(self.battleTarget) then
					local pb2 = BehaviorFunctions.GetTerrainPositionP("enemyBorn",20010007)
					BehaviorFunctions.DoSetPosition(self.battleTarget,pb2.x,pb2.y,pb2.z)
				end



				local fp1 = BehaviorFunctions.GetTerrainPositionP("enemyBorn",20010007)
				self.empty = BehaviorFunctions.CreateEntity(2001,nil,fp1.x,fp1.y,fp1.z)
				self.levelCam = BehaviorFunctions.CreateEntity(22001)
				BehaviorFunctions.CameraEntityFollowTarget(self.levelCam,self.role,"CameraTarget")
				BehaviorFunctions.CameraEntityLockTarget(self.levelCam,self.empty)






			end




			if self.missionState==1 and dialogId == self.dialogList[1].Id then
				BehaviorFunctions.DoLookAtTargetImmediately(self.role,self.battleTarget)
				BehaviorFunctions.DoLookAtTargetImmediately(self.battleTarget,self.role)
				--允许离歌运动
				BehaviorFunctions.SetEntityValue(self.battleTarget,"stopMove",nil)
				BehaviorFunctions.ShowBlackCurtain(true,0.1)

				--快速
				self.missionState=10
			end


			if self.missionState==4 and dialogId==self.dialogList[4].Id then

				self.missionState=5
			end

			if self.missionState==6 and dialogId == self.dialogList[6].Id then
				self.missionState=11
			end


			if self.missionState==8 and dialogId ==self.dialogList[8].Id then
				self.missionState = 10
			end


			if self.missionState==12 and dialogId == self.dialogList[13].Id then
				self.missionState = 7
			end
			if self.missionState==14 and dialogId == self.dialogList[15].Id then
				self.missionState = 15
			end

			if self.missionState==23 and dialogId==self.dialogList[21].Id then
				BehaviorFunctions.ShowBlackCurtain(true,0.5)
				self.missionState=24

			end
			if self.missionState==25 and dialogId==self.dialogList[23].Id then
				self.missionState=26
			end



			v.state = self.dialogStateEnum.PlayOver
			self.currentDialog = nil
		end
	end
end



function LevelBehavior30010:__delete()

end


function LevelBehavior30010:Dodge(attackInstanceId,hitInstanceId,limit)
	
	--闪避教学的判断
	if attackInstanceId ==self.battleTarget
		and self.missionState ==13 then
		self.moveNum=self.moveNum+1
		if self.moveNum<=3 then
			BehaviorFunctions.ChangeTopTargetDesc(1,self.moveNum)
		end
		if limit == true then
			self.specialMoveNum = self.specialMoveNum+1
		end


	end
end





function LevelBehavior30010:Die(attackInstanceId,dieInstanceId)
	if attackInstanceId == self.role
		or dieInstanceId == self.battleTarget then
		if self.missionState~=9 and self.missionState~=10 then
			if dieInstanceId==self.role then
				BehaviorFunctions.DoMagic(self.role,200000012)
			end
			if dieInstanceId==self.battleTarget then
				BehaviorFunctions.DoMagic(self.battleTarget,200000012)
			end
		else

			self.finish = true
			self.finishTLStart = BehaviorFunctions.GetEntityFrame(self.role)
		end
	end
end







function LevelBehavior30010:CastSkill(instanceId,skillId,skillType)

	--技能和普攻记数
	if  instanceId == self.role then
		--释放普攻开关
		if (skillId == 1001001
				or skillId ==1001002
				or skillId ==1001003
				or skillId ==1001004
				or skillId ==1001005) then
			self.hitKey = true

		end
		--释放技能开关
		if skillId == 1001010 then
			self.skillOneHitKey = true
		end
		if skillId==1001011 then
			self.skillTwoHitKey = true
		end


		if skillId ==1001051 then
			self.QTEHitKey = true
		end
		if skillId == 1001044 then
			self.coreHitKey = true

		end

	end

	--失衡教学
	if self.missionState==10
		and instanceId==self.battleTarget then
		BehaviorFunctions.StartStoryDialog(self.dialogList[25].Id)
	end


	if self.missionState==10
		and skillId== 1001010
		and instanceId==self.role then

		self.skillOnePointNum=self.skillOnePointNum+1
		BehaviorFunctions.ChangeTopTargetDesc(1,self.skillOnePointNum)
	end



	--闪避教学
	if self.missionState==13
		and instanceId==self.battleTarget then
		if self.skillDelay[1]==nil then
			self:TipsInform("skillDelay",1,33)
		end
		if self.moveNum<3
			and self.dialogList[14].state==self.dialogStateEnum.PlayOver
			and self.moveNum>=1 then
			self.dodgeGuideKey=true
		end

	end

	--弹反教学
	if self.missionState==20
		and instanceId==self.battleTarget
		and skillId==92001906
		and self.skillDelay[2]==nil then
		self:TipsInform("skillDelay",2,18)
	end







	if self.missionState==18
		and instanceId== self.battleTarget then
		self.noDodgeKey = true
		self.dodgeGuideKey = true
	end


	if self.missionState==20
		and instanceId== self.battleTarget then
		self.noreboundKey = true
		self.reboundGuideKey = true

	end


	--五行绝技教学
	if self.missionState==5
		and skillId==1001051
		and instanceId==self.role then
		self.QTENum=self.QTENum+1
		BehaviorFunctions.ChangeTopTargetDesc(2,self.QTENum)
	end
	
	--核心被动教学
	if self.missionState==14
		and instanceId==self.role
		and skillId == 1001044 then
		self.skillCoreNum=self.skillCoreNum+1
		BehaviorFunctions.ChangeTopTargetDesc(2,self.skillCoreNum)

	end
	
	--跳反教学
	if self.missionState ==15 then
		if instanceId == self.role
			and skillId == 1001082
			and self.jump<3 then
			self.jump=self.jump+1
			BehaviorFunctions.ChangeTopTargetDesc(1,self.jump)
		end
		if instanceId==self.battleTarget
			and self.skillDelay[3]==nil then
			self:TipsInform("skillDelay",3,30)
		end


	end



	--阶段11：自由联系
	if skillId == 92001906
		or skillId == 92001008
		or skillId == 92001905 then
		self.beHitKey = true
	end





end

function LevelBehavior30010:BreakSkill(instanceId,skillId,skillType)
	--关闭技能记数
	if  instanceId == self.role then
		if self.hitKey == true then
			self.hitKey = false
		end
		if self.skillOneHitKey == true then
			self.skillOneHitKey = false
		end
		if self.skillTwoHitKey == true then
			self.skillTwoHitKey = false
		end
		if self.QTEHitKey == true
			and skillId ==1001051 then
			self.QTEHitKey = false
		end
		if self.coreHitKey == true
			and skillId == 1001044 then
			self.coreHitKey = false
		end

	end


	--闪避教学
	if self.missionState==13
		and instanceId==self.battleTarget then
		if self.moveNum<3
			and self.dialogList[14].state==self.dialogStateEnum.PlayOver
			and self.moveNum>=1 then
			BehaviorFunctions.FinishGuide(self.guideList[6].Id,1)
			self.dodgeGuideKey=false
		end

	end





	if self.missionState==18
		and instanceId== self.battleTarget then
		self.noDodgeKey = false
		self.dodgeGuideKey = false
	end


	if self.missionState==20
		and instanceId== self.battleTarget then
		self.noreboundKey = false
		self.reboundGuideKey = false

	end

	if self.missionState ==9
		and instanceId ==self.battleTarget then
		BehaviorFunctions.FinishGuide(self.guideList[7].Id,1)
	end



	if self.missionState ==11
		and instanceId ==self.battleTarget then
		BehaviorFunctions.FinishGuide(self.guideList[8].Id,1)

	end


	--阶段11
	if  instanceId ==self.battleTarget
		and self.beHitKey == true then
		self.beHitKey = false
	end



end

function LevelBehavior30010:FinishSkill(instanceId,skillId,skillType)
	--关闭技能记数
	if  instanceId == self.role then
		if self.hitKey == true then
			self.hitKey = false
		end
		if self.skillOneHitKey == true then
			self.skillOneHitKey = false
		end
		if self.skillTwoHitKey == true then
			self.skillTwoHitKey = false
		end
		if self.QTEHitKey == true
			and skillId ==1001051 then
			self.QTEHitKey = false
		end
		if self.coreHitKey == true
			and skillId == 1001044 then
			self.coreHitKey = false
		end
	end


	if skillId==1001051 then

		self.linshiList[7]=false
	end



	--闪避教学
	if self.missionState==13
		and instanceId==self.battleTarget then
		if self.moveNum<3
			and self.dialogList[14].state==self.dialogStateEnum.PlayOver
			and self.moveNum>=1 then
			self.dodgeGuideKey=false
			BehaviorFunctions.FinishGuide(self.guideList[6].Id,1)
		end

	end




	if self.battleTarget==instanceId then
		self.beHitKey = false

	end



	if self.missionState==18
		and instanceId== self.battleTarget then
		self.noDodgeKey = false
		self.dodgeGuideKey = false
	end


	if self.missionState==20
		and instanceId== self.battleTarget then
		self.noreboundKey = false
		self.reboundGuideKey = false

	end

	if self.missionState==9
		and instanceId ==self.battleTarget  then
		BehaviorFunctions.FinishGuide(self.guideList[7].Id,1)

	end

	if self.missionState==11
		and instanceId ==self.battleTarget then
		BehaviorFunctions.FinishGuide(self.guideList[8].Id,1)

	end



end



function LevelBehavior30010:AfterDamage(attackInstanceId,hitInstanceId,damageType,magicId,damageElementType,damageVal)
	--如果玩家攻击，则刷新未攻击时间d
	if self.noHitBattleTargetTime
		and (self.missionState ==3
			or self.missionState ==4
			or self.missionState ==5)
		and attackInstanceId == self.role then
		self.noHitBattleTargetTime = BehaviorFunctions.GetEntityFrame(self.role)



	end

	--记录普攻和技能击中次数
	if self.missionState ==3 then
		--只有tips还在的时候才会改
		if self.hitKey == true
			and self.attackNum<5 then
			self.attackNum =self.attackNum + 1
			self.currentElement=self.currentElement+self.maxElement/3/5
			BehaviorFunctions.SetEntityElementStateAccumulation(self.battleTarget,self.battleTarget,-1,self.currentElement)
			BehaviorFunctions.SetSkillPoint(self.role,FightEnum.RoleSkillPoint.Normal,0.4*self.attackNum)

			BehaviorFunctions.ChangeTopTargetDesc(1,self.attackNum)
			self.hitKey = false
		end
		if self.skillOneHitKey == true
			or self.skillTwoHitKey== true then
			self.currentElement=self.maxElement
			self.skillOnePointNum =self.skillOnePointNum + 1
			BehaviorFunctions.ChangeTopTargetDesc(1,self.skillOnePointNum)
			BehaviorFunctions.SetEntityElementStateAccumulation(self.battleTarget,self.battleTarget,-1,self.maxElement)
			self.skillOneHitKey = false
			self.skillTwoHitKey = false


		end

		if self.QTEHitKey ==true then
			self.QTENum=self.QTENum+1
			self.QTEHitKey = false
		end


	end


	--核心被动
	--记录普攻和技能击中次数
	if self.missionState==7
		--只有tips还在的时候才会改
		and  self.topTipsList[6].state ~= self.topTipsEnum.PlayOver then

		if self.skillOneHitKey==true then
			--BehaviorFunctions.ChangeTopTargetDesc(1,self.skillTwoPointNum)
			BehaviorFunctions.FinishGuide(self.guideList[10].Id,1)
			self.guideList[21].state=self.guideStateEnum.Default
			self.skillOnePointNum=self.skillOnePointNum+1
			self.skillOneHitKey= false
		end

		if self.skillTwoHitKey==true then
			if self.skillTwoPointNum<3 then
				self.skillTwoPointNum=self.skillTwoPointNum+1
				--BehaviorFunctions.ChangeTopTargetDesc(1,self.skillTwoPointNum)
				BehaviorFunctions.FinishGuide(self.guideList[10].Id,1)
				self.guideList[21].state=self.guideStateEnum.Default

			end
			self.skillTwoHitKey= false
		end


		if self.coreHitKey == true then
			if self.skillCoreNum<1 then
				self.skillCoreNum=self.skillCoreNum+1
				BehaviorFunctions.ChangeTopTargetDesc(1,self.skillCoreNum)
			end


			self.coreHitKey = false

		end




	end







	--坏相数值作假
	if self.missionState==9 then
		if self.skillOneHitKey== true then
			self.currentElement=self.currentElement+35
			self.skillOneHitKey=false
		end
		if self.hitKey==true then
			self.currentElement=self.currentElement+4
			self.hitKey=false
		end
		if self.coreHitKey==true then
			self.currentElement=self.currentElement+200
			self.coreHitKey=false
		end
		BehaviorFunctions.SetEntityElementStateAccumulation(self.battleTarget,self.battleTarget,-1,self.currentElement)


	end


	if self.missionState ==10
		--只有tips还在的时候才会改
		and  self.topTipsList[7].state ~= self.topTipsEnum.PlayOver then
		if (self.skillOneHitKey == true
				or self.skillTwoHitKey==true)
			and self.skillOnePointNum<1 then
			self.skillOnePointNum=self.skillOnePointNum+1
			BehaviorFunctions.ChangeTopTargetDesc(1,self.skillOnePointNum)

		end
		if self.skillOneHitKey== true then
			self.skillOneHitKey = false
		end

	end






	--记录QTE专用记数
	if (self.missionState ==10
			or self.missionState==24
			or self.missionState==14)
		--只有tips还在的时候才会改
		and attackInstanceId==self.role
		and hitInstanceId==self.battleTarget then

		if self.QTEHitKey == true
			and self.QTENum<1 then
			self.QTENum=self.QTENum+1
			BehaviorFunctions.ChangeTopTargetDesc(2,self.QTENum)
			self.QTEHitKey = false
		end
	end





	if self.missionState ==24
		and attackInstanceId==self.battleTarget
		and hitInstanceId==self.role
		and self.beHitKey == true then
		self.beHitNum =self.beHitNum+1
		BehaviorFunctions.ChangeTopTargetDesc(1,self.beHitNum)
		self.beHitKey = false
	end





	--闪避失败
	if self.missionState==13
		and attackInstanceId== self.battleTarget
		and hitInstanceId==self.role
		and self.moveNum<3
		and self.dodgeFalse <3
		and self.dialogReactionList[1].state == self.dialogStateEnum.NotPlaying then
		BehaviorFunctions.StartStoryDialog(self.dialogReactionList[1].Id)
		self.dialogReactionList[1].state = self.dialogStateEnum.PlayOver
		self.dodgeFalse=self.dodgeFalse+1
		self.dodgeGuideKey=false


	end





end






function LevelBehavior30010:OnGuideFinish(guideId,stage)
	for i,v in ipairs(self.guideList) do
		if guideId == self.guideList[i].Id then
			self.guideList[i].state = self.guideStateEnum.PlayOver
		end
	end
	self.weakGuideFree = true



end


function LevelBehavior30010:ButtonShow()
	BehaviorFunctions.AddDelayCallByTime(0.5,self,self.DelayChange)
end

function LevelBehavior30010:DelayChange()
	self.Button = true
end

function LevelBehavior30010:ProgressDelay(progressKey,num,delayTime)
	if progressKey==self.progressEnum.Begin then
		BehaviorFunctions.AddDelayCallByTime(delayTime,self,self.ProgressPass)
	end
end

function LevelBehavior30010:ProgressPass()
	self.progressState=self.progressEnum.Finish
end


function LevelBehavior30010:TipsInform(tipsKind,num,delayTime)
	if tipsKind =="title" then
		BehaviorFunctions.AddDelayCallByTime(delayTime,self,self.TipsDelay)
		self.tipNum = num
	end
	if tipsKind =="tipsFinish" then
		BehaviorFunctions.AddDelayCallByTime(delayTime,self,self.TipsFinish)
		self.tipFinNum = num
	end
	if tipsKind=="guideStart" then
		BehaviorFunctions.AddDelayCallByTime(delayTime,self,self.GuideStart)
		self.GuideNum = num
	end
	if tipsKind=="dialogDelay" then
		BehaviorFunctions.AddDelayCallByTime(delayTime,self,self.DialogDelay)
		self.dialogNum =num
	end
	if tipsKind=="skillDelay" then
		BehaviorFunctions.AddDelayCallByFrame(delayTime,self,self.SkillDelay)
		self.skillDelayNum = num
	end

end

function LevelBehavior30010:SkillDelay()
	self.skillDelay[self.skillDelayNum] = true
	BehaviorFunctions.AddBuff(self.role,self.role,200000008)
	BehaviorFunctions.AddBuff(self.battleTarget,self.battleTarget,200000008)

end




function LevelBehavior30010:DialogDelay()
	self.dialogList[self.dialogNum].delay = 0
end


function LevelBehavior30010:TipsDelay()
	self.title[self.tipNum] = true
end

function LevelBehavior30010:TipsFinish()
	self.titleFin[self.tipFinNum] = true
end

function LevelBehavior30010:GuideStart()
	self.guideList[self.GuideNum].state = self.guideStateEnum.NotPlaying
end



function LevelBehavior30010:ChangeTipsKey()
	self.changeTopKey = true
end


function LevelBehavior30010:EnterElementStateReady(atkInstanceId,instanceId,element)
	--if atkInstanceId==self.role
	--and self.missionState == 4
	--and instanceId == self.battleTarget then
	--BehaviorFunctions.PlayGuide(self.guideList[2].Id,1)
	--end
end

function LevelBehavior30010:TopTargetClose(Id)
	for k,v in ipairs(self.topTipsList) do
		if Id == v.Id then
			v.state = self.topTipsEnum.PlayOver
		end
	end
end



function LevelBehavior30010:CastSkillCostBefore(instanceId,skillId,blueValue,yellowValue,curBlue,curYellow,totalChanged)
	if self.missionState==11
		and self.blueBallNum<1
		and blueValue==2 then
		self.blueBallNum =self.beHitNum+1
		BehaviorFunctions.ChangeTopTargetDesc(1,self.blueBallNum)
	end
	--有问题，没有判断技能打中


end

function LevelBehavior30010:SkillPointChangeBefore(instanceId,skillPointKind,changedBeforeValue,changedValue)
	if self.missionState==3
		and instanceId==self.role
		and self.skillOnePointNum==1
		and skillPointKind ==FightEnum.RoleSkillPoint.Normal
		and( changedBeforeValue==1
			and changedValue==1)  then
		self.guideList[13].state=self.guideStateEnum.NotPlaying
		BehaviorFunctions.FinishGuide(self.guideList[3].Id,1)


	end


	if self.missionState==7
		and instanceId==self.role
		and self.guideList[21].state==self.guideStateEnum.Playing
		and skillPointKind ==FightEnum.RoleSkillPoint.Normal
		and( changedBeforeValue==1
			and changedValue==1)  then
		self.guideList[10].state=self.guideStateEnum.NotPlaying
		BehaviorFunctions.FinishGuide(self.guideList[21].Id,1)


	end



end




function LevelBehavior30010:CastSkillCostAfter(instanceId,skillId,blueValue,yellowValue,curBlue,curYellow,totalChanged)
	if self.missionState==7 then
		if self.skillOnePointNum>0 and self.skillOnePointNum<3 then
			if curYellow<2
				and self.guideList[3].state == self.guideStateEnum.PlayOver then
				self.guideList[3].state = self.guideStateEnum.Default
			end
		end
	end
end



--进入交互范围，添加交互列表
function LevelBehavior30010:EnterTrigger(triggerInstanceId,triggerEntityId,roleInstanceId)
	if self.isTrigger then
		return
	end

	self.isTrigger = triggerInstanceId == self.JumpLevel
	if not self.isTrigger then
		return
	end
	if self.ClickKey == true then
		self.interactUniqueId = BehaviorFunctions.WorldNPCInteractActive(self.JumpLevel,"跳关后门")
	end
end


--退出交互范围，移除交互列表
function LevelBehavior30010:ExitTrigger(triggerInstanceId,triggerEntityId,roleInstanceId)
	if self.isTrigger and triggerInstanceId == self.JumpLevel  then
		self.isTrigger = false
		BehaviorFunctions.WorldInteractRemove(self.interactUniqueId)
	end
end

--点击交互:播放退出关卡
function LevelBehavior30010:WorldInteractClick(uniqueId)
	if uniqueId == self.interactUniqueId then
		--BehaviorFunctions.SetDuplicateResult(true)
		BehaviorFunctions.AddDelayCallByFrame(5,BehaviorFunctions,BehaviorFunctions.SetDuplicateResult,true)
		BehaviorFunctions.SendTaskProgress(101062201,1,1)
		BehaviorFunctions.StopBgmSound()
		BehaviorFunctions.SetActiveBGM("TRUE")
	end
end


