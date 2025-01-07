Behavior900051 = BaseClass("Behavior900051",EntityBehaviorBase)
--资源预加载
function Behavior900051.GetGenerates()
	local generates = {}
	return generates
end

function Behavior900051.GetMagics()
	local generates = {900000024,900000025}
	return generates
end


function Behavior900051:Init()
	self.MonsterCommonParam = BehaviorFunctions.CreateBehavior("MonsterCommonParam",self)
	self.MonsterCommonBehavior = BehaviorFunctions.CreateBehavior("MonsterCommonBehavior",self)
	--被暗杀动作
	self.beAssassin = 90005109
	self.backHited = 90005162
	self.mission = 0
	self.MonsterCommonParam.canBeAss = true --可以被暗杀
	--开放参数
	--MonsterBorn
	self.MonsterCommonParam.haveSpecialBornLogic = false                                       --出生技能是否有特殊逻辑
	self.MonsterCommonParam.bornSkillId = nil         	                                        --出生技能id(为nil就不放)
	self.MonsterCommonParam.initialDazeTime = 2		                                        --出生发呆时间
	--MonsterPeace
	self.MonsterCommonParam.actSkillId = nil                                                   --演出技能Id
	--MonsterWarn
	self.MonsterCommonParam.haveWarn = true             --是否有警告状态
	self.MonsterCommonParam.warnLimitRange = 5           --近身警告距离
	self.MonsterCommonParam.warnShortRange = 10           --近身警告距离（无视角度）
	self.MonsterCommonParam.warnLongRange = 20            --远距离警告距离（结合VisionAngle）
	self.MonsterCommonParam.warnVisionAngle = 60          --远距离警告视角
	self.MonsterCommonParam.warnDelayTime = 2            --警告延迟时间
	self.MonsterCommonParam.warnSkillId = 90005104            --警告技能Id
	self.MonsterCommonParam.warnSitSkillId = 90005105            --坐下后起立警告技能Id
	self.MonsterCommonParam.tauntSkillId = nil            --嘲讽技能
	self.MonsterCommonParam.noWarnInFightRange = 30        --自如其名
	--MonsterCastSkill
	self.MonsterCommonParam.difficultyDegree = 0           --难度系数
	self.MonsterCommonParam.initialSkillCd = 0				--技能初始cd
	self.MonsterCommonParam.commonSkillCd = 2				--技能公共cd
	self.MonsterCommonParam.haveSkillLifeRatio = false     --技能是否有生命值区间判断

	self.MonsterCommonParam.initialSkillList = {
		--左跳001
		--{id = 90005101,
		--minDistance = 0,         --技能释放最小距离（有等号）
		--maxDistance = 2.2,        --技能释放最大距离（无等号）
		--angle = 80,              --技能释放角度
		--cd = 15,                  --技能cd，单位：秒
		--durationFrame = 68,      --技能持续帧数
		--frame = 0,               --cd用帧数参数，默认为0，大于0相当于有单独的初始cd
		--priority = 1,            --优先级，数值越大优先级越高
		--isAuto = true,           --是否自动释放
		--difficultyDegree = 0,    --难度系数，初始化会剔除大于预设难度的技能
		--minLifeRatio = 0,        --技能释放最低生命万分比（有等号）
		--maxLifeRatio = 10000     --技能释放最高生命万分比（无等号）
		--},
		--{id = 90005102,
			--minDistance = 0.5,         --技能释放最小距离（有等号）
			--maxDistance = 8,        --技能释放最大距离（无等号）
			--angle = 80,              --技能释放角度
			--cd = 0,                  --技能cd，单位：秒
			--durationFrame = 63,      --技能持续帧数
			--frame = 0,               --cd用帧数参数，默认为0，大于0相当于有单独的初始cd
			--priority = 1,            --优先级，数值越大优先级越高
			--isAuto = true,           --是否自动释放
			--difficultyDegree = 0,    --难度系数，初始化会剔除大于预设难度的技能
			--minLifeRatio = 0,        --技能释放最低生命万分比（有等号）
			--maxLifeRatio = 10000     --技能释放最高生命万分比（无等号）
		--},
		--远距离CD变长
		{id = 90005102,
			minDistance = 0.5,         --技能释放最小距离（有等号）
			maxDistance = 30,        --技能释放最大距离（无等号）
			angle = 40,              --技能释放角度
			cd = 8,                  --技能cd，单位：秒
			durationFrame = 63,      --技能持续帧数
			frame = 0,               --cd用帧数参数，默认为0，大于0相当于有单独的初始cd
			priority = 1,            --优先级，数值越大优先级越高
			isAuto = true,           --是否自动释放
			difficultyDegree = 0,    --难度系数，初始化会剔除大于预设难度的技能
			minLifeRatio = 0,        --技能释放最低生命万分比（有等号）
			maxLifeRatio = 10000     --技能释放最高生命万分比（无等号）
		}
		--{id = 90005103,
		--minDistance = 3,         --技能释放最小距离（有等号）
		--maxDistance = 30,        --技能释放最大距离（无等号）
		--angle = 30,              --技能释放角度
		--cd = 30,                  --技能cd，单位：秒
		--durationFrame = 64,      --技能持续帧数
		--frame = 0,               --cd用帧数参数，默认为0，大于0相当于有单独的初始cd
		--priority = 1,            --优先级，数值越大优先级越高
		--isAuto = true,           --是否自动释放
		--difficultyDegree = 0,    --难度系数，初始化会剔除大于预设难度的技能
		--minLifeRatio = 0,        --技能释放最低生命万分比（有等号）
		--maxLifeRatio = 10000     --技能释放最高生命万分比（无等号）
		--}

	}
	--MonsterWander
	self.MonsterCommonParam.shortRange = 8                 --游荡近距离边界值
	self.MonsterCommonParam.longRange = 15                 --游荡远距离边界值
	self.MonsterCommonParam.maxRange = 20                  --游荡超远距离边界值
	self.MonsterCommonParam.minRange = 2.3                   --极限近身距离，追杀模式最小追踪距离
	self.MonsterCommonParam.canLRWalk = false              --左右走开关
	self.MonsterCommonParam.LRWalkSwitchTime = 5.76        --左右走切换时间
	self.MonsterCommonParam.switchDelayTime = 1.92         --延迟切换时间(前后走)
	self.MonsterCommonParam.walkDazeTime = 1               --移动发呆时间
	self.MonsterCommonParam.canRun = false                  --跑步开关
	self.MonsterCommonParam.haveRunAndHit = false           --是否有追杀模式(↓↓跑到脸上放defaultSkill↓↓)
	self.MonsterCommonParam.defaultSkillId = 90005102		        --默认技能id，追杀模式使用
	self.MonsterCommonParam.visionAngle = 60               --视野范围，不在视野范围内会进行转向
	--MonsterExitFight
	self.MonsterCommonParam.ExitFightRange = 25           --脱战距离
	self.MonsterCommonParam.RebornRange = 200              --重生距离
	self.MonsterCommonParam.canExitFight = true           --能否脱战
	self.MonsterCommonParam.exitFightLimitTime = 20       --脱战时间
	self.MonsterCommonParam.canNotChase = 50
	self.MonsterCommonParam.targetMaxRange = self.MonsterCommonParam.maxRange

	--分组参数
	--self.MonsterCommonParam.groupSkillFrame = 0                                                --执行分组逻辑的技能帧数
	--self.MonsterCommonParam.groupSkillNum = 0                                                  --执行分组释放的技能编号
	--self.MonsterCommonParam.groupSkillSign = nil
	self.walkSwitchFrame=0
	self.posCheck={}
	self.stopMove=0
	self.list = {}
	self.patrolPositionList={}
	self.information={"moveState"}
	self.direactionDisable={}


end



function Behavior900051:Update()
	--目标可暗杀buff
	BehaviorFunctions.SetEntityValue(self.MonsterCommonParam.me,"beAssassin",self.beAssassin)
	BehaviorFunctions.SetEntityValue(self.MonsterCommonParam.me,"backHited",self.backHited)
	--可暗杀
	--if self.mission == 0 then
	--BehaviorFunctions.DoMagic(self.MonsterCommonParam.me,self.MonsterCommonParam.me,900000055)

	--self.mission = 1
	--end

	self.MonsterCommonParam:Update()
	self.MonsterCommonBehavior.MonsterBorn:Update()
	self.MonsterCommonBehavior.MonsterPeace:Update()
	self.MonsterCommonBehavior.MonsterWarn:Update()
	self.MonsterCommonBehavior.MonsterExitFight:Update()
	--self.MonsterCommonBehavior.MonsterWander:Update()
	self.MonsterCommonBehavior.MonsterCastSkill:Update()
	self.MonsterCommonBehavior.MonsterMercenaryChase:Update()
	local pos1=BehaviorFunctions.GetPositionOffsetBySelf(self.MonsterCommonParam.me,2,0) --前
	local pos2=BehaviorFunctions.GetPositionOffsetBySelf(self.MonsterCommonParam.me,2,90)  --右
	local pos3=BehaviorFunctions.GetPositionOffsetBySelf(self.MonsterCommonParam.me,2,270)  --左
	local pos4=BehaviorFunctions.GetPositionOffsetBySelf(self.MonsterCommonParam.me,2,180) --后
	self.posCheck[1]={x=pos1.x,y=pos1.y+1,z=pos1.z}
	self.posCheck[2]={x=pos2.x,y=pos2.y+1,z=pos2.z}
	self.posCheck[3]={x=pos3.x,y=pos3.y+1,z=pos3.z}
	self.posCheck[4]={x=pos4.x,y=pos4.y+1,z=pos4.z}

	--local m=0
	--for i=1,4 do
		--local y,layer=BehaviorFunctions.CheckPosHeight(self.posCheck[i])
		--if y~=nil
			--and layer~=nil
			--and y>3
			--or layer==FightEnum.Layer.Water
			--or layer==FightEnum.Layer.Marsh then
			--m=m+1
			--self.direactionDisable[i]=i
		--else
			--if self.direactionDisable[i]~=nil then
				--self.direactionDisable[i]=nil  --用于把以前不能行走，现在可以行走的区域删掉。
			--end
		--end
		--if m==4 then
			--self.stopMove=4
		--end
	--end
	self.direactionDisable={1}
	
	
	--if self.stopMove==0 then
		--local m=0
		--for i=1,4 do
			--local y,layer=BehaviorFunctions.CheckPosHeight(self.posCheck[i])
			--if y~=nil
				--and layer~=nil
				--and y>3
				--or layer==FightEnum.Layer.Water
				--or layer==FightEnum.Layer.Marsh then
				--m=m+1
				--self.direactionDisable[i]=i
			--else
				--if self.direactionDisable[i]~=nil then
					--self.direactionDisable[i]=nil  --用于把以前不能行走，现在可以行走的区域删掉。
				--end
			--end
			--if m==4 then
				--self.stopMove=4
			--end
		--end
	--end
	
	
	--接收运动参数
	if BehaviorFunctions.GetEntityEcoId(self.MonsterCommonParam.me)~=nil then
		self.param = BehaviorFunctions.GetEcoEntityExtraParam(self.MonsterCommonParam.ecoMe)
		if not self.param or not next(self.param) then
			return
		else
			for k,v in pairs(self.param) do
				for n,m in ipairs(self.information) do
					if v[m]~=nil then
						self.list[m]=self:SplitParam(v[m],"|")
					end

				end
			end
		end
	end
	
	
	

	if self.stopMove==4
		or (BehaviorFunctions.GetEntityValue(self.MonsterCommonParam.me,"congshigongmove")
			and BehaviorFunctions.GetEntityValue(self.MonsterCommonParam.me,"congshigongmove")==true) then
		self:FightIdle()
	elseif  BehaviorFunctions.GetEntityValue(self.MonsterCommonParam.me,"congshigongmove")==false then
		self:RunBack()
	elseif (self.list["moveState"]~=nil
			and self.list["moveState"][1]=="WanderAndHit") then
		self:WanderAndHit()
	else
		self:WalkBack()
	end
	--角色是否有潜行
	if BehaviorFunctions.HasEntitySign(self.MonsterCommonParam.battleTarget,610025) then
		self.MonsterCommonParam.warnLimitRange = 2           --近身警告距离
		self.MonsterCommonParam.warnShortRange = 3
		self.MonsterCommonParam.warnLongRange = 3
	else
		self.MonsterCommonParam.warnLimitRange = 5           --近身警告距离
		self.MonsterCommonParam.warnShortRange = 10
		self.MonsterCommonParam.warnLongRange = 20
	end
end





function Behavior900051:WalkBack()
	if  self.MonsterCommonParam.inFight == true and BehaviorFunctions.CanCtrl(self.MonsterCommonParam.me) then
		if self.MonsterCommonParam.skillState == self.MonsterCommonParam.SkillStateEnum.Default
			--or self.MonsterCommonParam.skillState == self.MonsterCommonParam.SkillStateEnum.InCommonCd --放完技能进入公共CD
			or self.MonsterCommonParam.skillState == self.MonsterCommonParam.SkillStateEnum.CastingSkill then
			if   self.MonsterCommonParam.myFrame > self.walkSwitchFrame then --因为怪物释放技能之后但是切换指令还存在，没有位移指令输入，所以会傻站。
				if self.MonsterCommonParam.battleTargetDistance<self.MonsterCommonParam.shortRange and  BehaviorFunctions.GetSubMoveState(self.MonsterCommonParam.me) ~= FightEnum.EntityMoveSubState.WalkBack  then
					BehaviorFunctions.DoSetMoveType(self.MonsterCommonParam.me,FightEnum.EntityMoveSubState.WalkBack)
					self.walkSwitchFrame = self.MonsterCommonParam.myFrame + self.MonsterCommonParam.switchDelayTime * 30
				elseif self.MonsterCommonParam.battleTargetDistance>=self.MonsterCommonParam.shortRange and self.MonsterCommonParam.battleTargetDistance<self.MonsterCommonParam.longRange  then
					local R = BehaviorFunctions.RandomSelect(1,2)
					if R == 1 then
						BehaviorFunctions.DoSetMoveType(self.MonsterCommonParam.me,FightEnum.EntityMoveSubState.WalkLeft)
						self.walkSwitchFrame = self.MonsterCommonParam.myFrame + self.MonsterCommonParam.LRWalkSwitchTime * 30
					elseif R == 2 then
						BehaviorFunctions.DoSetMoveType(self.MonsterCommonParam.me,FightEnum.EntityMoveSubState.WalkRight)
						self.walkSwitchFrame = self.MonsterCommonParam.myFrame + self.MonsterCommonParam.LRWalkSwitchTime * 30
					end

					--BehaviorFunctions.DoSetEntityState(self.MonsterCommonParam.me,FightEnum.EntityState.FightIdle)
					--self.walkSwitchFrame = self.MonsterCommonParam.myFrame + self.MonsterCommonParam.switchDelayTime * 30
				elseif self.MonsterCommonParam.battleTargetDistance>=self.MonsterCommonParam.longRange and BehaviorFunctions.GetSubMoveState(self.MonsterCommonParam.me) ~= FightEnum.EntityMoveSubState.Run   then
					BehaviorFunctions.DoSetMoveType(self.MonsterCommonParam.me,FightEnum.EntityMoveSubState.Run)
					self.walkSwitchFrame = self.MonsterCommonParam.myFrame + self.MonsterCommonParam.switchDelayTime * 30


				end
			end
		end
		if self.MonsterCommonParam.skillState == self.MonsterCommonParam.SkillStateEnum.InCommonCd then
			if BehaviorFunctions.GetEntityState(self.MonsterCommonParam.me)==FightEnum.EntityState.Idle then
				if self.MonsterCommonParam.battleTargetDistance<self.MonsterCommonParam.shortRange   then
					BehaviorFunctions.DoSetMoveType(self.MonsterCommonParam.me,FightEnum.EntityMoveSubState.WalkBack)
					self.walkSwitchFrame = self.MonsterCommonParam.myFrame + self.MonsterCommonParam.switchDelayTime * 30
				elseif self.MonsterCommonParam.battleTargetDistance>=self.MonsterCommonParam.shortRange and self.MonsterCommonParam.battleTargetDistance<self.MonsterCommonParam.longRange  then
					local R = BehaviorFunctions.RandomSelect(1,2)
					if R == 1 then
						BehaviorFunctions.DoSetMoveType(self.MonsterCommonParam.me,FightEnum.EntityMoveSubState.WalkLeft)
						self.walkSwitchFrame = self.MonsterCommonParam.myFrame + self.MonsterCommonParam.LRWalkSwitchTime * 30
					elseif R == 2 then
						BehaviorFunctions.DoSetMoveType(self.MonsterCommonParam.me,FightEnum.EntityMoveSubState.WalkRight)
						self.walkSwitchFrame = self.MonsterCommonParam.myFrame + self.MonsterCommonParam.LRWalkSwitchTime * 30
					end

					--BehaviorFunctions.DoSetEntityState(self.MonsterCommonParam.me,FightEnum.EntityState.FightIdle)
					--self.walkSwitchFrame = self.MonsterCommonParam.myFrame + self.MonsterCommonParam.switchDelayTime * 30
				elseif self.MonsterCommonParam.battleTargetDistance>=self.MonsterCommonParam.longRange  then
					BehaviorFunctions.DoSetMoveType(self.MonsterCommonParam.me,FightEnum.EntityMoveSubState.Run)
					self.walkSwitchFrame = self.MonsterCommonParam.myFrame + self.MonsterCommonParam.switchDelayTime * 30


				end

			end


		end
		if BehaviorFunctions.CanCtrl(self.MonsterCommonParam.me) then
			--在视野中
			if BehaviorFunctions.CompEntityLessAngle(self.MonsterCommonParam.me,self.MonsterCommonParam.battleTarget,self.MonsterCommonParam.visionAngle/2) then
				self.inVision = true
				--不在则进行转向
			else
				self.inVision = false
				BehaviorFunctions.DoLookAtTargetByLerp(self.MonsterCommonParam.me,self.MonsterCommonParam.battleTarget,true,0,60,-2)
			end
			if self.MonsterCommonParam.myState ==  FightEnum.EntityState.Move then
				BehaviorFunctions.DoLookAtTargetByLerp(self.MonsterCommonParam.me,self.MonsterCommonParam.battleTarget,true,0,60,-2)
			end
		end
		
		
		
		
	end




end

function Behavior900051:FightIdle()
	if  self.MonsterCommonParam.inFight == true and BehaviorFunctions.CanCtrl(self.MonsterCommonParam.me) then
		if self.MonsterCommonParam.skillState == self.MonsterCommonParam.SkillStateEnum.Default
			or self.MonsterCommonParam.skillState == self.MonsterCommonParam.SkillStateEnum.InCommonCd
			or self.MonsterCommonParam.skillState == self.MonsterCommonParam.SkillStateEnum.CastingSkill then
				if  BehaviorFunctions.GetEntityState(self.MonsterCommonParam.me)~= FightEnum.EntityState.FightIdle   then
					BehaviorFunctions.DoSetEntityState(self.MonsterCommonParam.me,FightEnum.EntityState.FightIdle)
				end
			end
		if BehaviorFunctions.CanCtrl(self.MonsterCommonParam.me) then
			--在视野中
			if BehaviorFunctions.CompEntityLessAngle(self.MonsterCommonParam.me,self.MonsterCommonParam.battleTarget,self.MonsterCommonParam.visionAngle/2) then
				self.inVision = true
				--不在则进行转向
			else
				self.inVision = false
				BehaviorFunctions.DoLookAtTargetByLerp(self.MonsterCommonParam.me,self.MonsterCommonParam.battleTarget,true,0,60,-2)
			end
			if self.MonsterCommonParam.myState ==  FightEnum.EntityState.Move then
				BehaviorFunctions.DoLookAtTargetByLerp(self.MonsterCommonParam.me,self.MonsterCommonParam.battleTarget,true,0,60,-2)
			end
		end
	end


end





function Behavior900051:RunBack()
	if  self.MonsterCommonParam.inFight == true and BehaviorFunctions.CanCtrl(self.MonsterCommonParam.me) then

		
		if self.MonsterCommonParam.skillState == self.MonsterCommonParam.SkillStateEnum.Default
			or self.MonsterCommonParam.skillState == self.MonsterCommonParam.SkillStateEnum.InCommonCd
			or self.MonsterCommonParam.skillState == self.MonsterCommonParam.SkillStateEnum.CastingSkill then
			local myPos = BehaviorFunctions.GetPositionP(self.MonsterCommonParam.me)
			self.bornDistance = BehaviorFunctions.GetDistanceFromPos(myPos,self.MonsterCommonParam.bornPosition)
			if self.bornDistance>1  then
				self.moveKey=true
				BehaviorFunctions.CancelLookAt(self.MonsterCommonParam.me)
				BehaviorFunctions.DoLookAtPositionImmediately(self.MonsterCommonParam.me,self.MonsterCommonParam.bornPosition.x,nil,self.MonsterCommonParam.bornPosition.z)
				if BehaviorFunctions.GetSubMoveState(self.MonsterCommonParam.me) ~= FightEnum.EntityMoveSubState.Run then
					BehaviorFunctions.DoSetMoveType(self.MonsterCommonParam.me,FightEnum.EntityMoveSubState.Run)
				end
			elseif 	self.bornDistance<=1 and self.bornDistance>0.5 then
				if BehaviorFunctions.GetSubMoveState(self.MonsterCommonParam.me) ~= FightEnum.EntityMoveSubState.Run 
					and BehaviorFunctions.GetEntityState(self.MonsterCommonParam.me)~= FightEnum.EntityState.FightIdle then
					BehaviorFunctions.DoSetEntityState(self.MonsterCommonParam.me,FightEnum.EntityState.FightIdle)
				end
				
				
			elseif self.bornDistance<0.5 then
				if  self.moveKey==true  then
					BehaviorFunctions.DoSetPositionP(self.MonsterCommonParam.me,self.MonsterCommonParam.bornPosition)
					BehaviorFunctions.StopMove(self.MonsterCommonParam.me)
					self.moveKey=false
				else
					if  BehaviorFunctions.GetEntityState(self.MonsterCommonParam.me)~= FightEnum.EntityState.FightIdle   then
						BehaviorFunctions.DoSetEntityState(self.MonsterCommonParam.me,FightEnum.EntityState.FightIdle)
					end
				end
				if BehaviorFunctions.CanCtrl(self.MonsterCommonParam.me) then
					--在视野中
					if BehaviorFunctions.CompEntityLessAngle(self.MonsterCommonParam.me,self.MonsterCommonParam.battleTarget,self.MonsterCommonParam.visionAngle/2) then
						self.inVision = true
						--不在则进行转向
					else
						self.inVision = false
						BehaviorFunctions.DoLookAtTargetByLerp(self.MonsterCommonParam.me,self.MonsterCommonParam.battleTarget,true,0,60,-2)
					end
					if self.MonsterCommonParam.myState ==  FightEnum.EntityState.Move then
						BehaviorFunctions.DoLookAtTargetByLerp(self.MonsterCommonParam.me,self.MonsterCommonParam.battleTarget,true,0,60,-2)
					end
				end
				
				
			end
			
		end
	end
end

function Behavior900051:WanderAndHit()
	if  self.MonsterCommonParam.inFight == true and BehaviorFunctions.CanCtrl(self.MonsterCommonParam.me) then
		if self.MonsterCommonParam.skillState == self.MonsterCommonParam.SkillStateEnum.Default
			--or self.MonsterCommonParam.skillState == self.MonsterCommonParam.SkillStateEnum.InCommonCd --放完技能进入公共CD
			or self.MonsterCommonParam.skillState == self.MonsterCommonParam.SkillStateEnum.CastingSkill then
			if   self.MonsterCommonParam.myFrame > self.walkSwitchFrame then --因为怪物释放技能之后但是切换指令还存在，没有位移指令输入，所以会傻站。
				--if self.MonsterCommonParam.battleTargetDistance<self.MonsterCommonParam.shortRange and  BehaviorFunctions.GetSubMoveState(self.MonsterCommonParam.me) ~= FightEnum.EntityMoveSubState.WalkBack  then
				--BehaviorFunctions.DoSetMoveType(self.MonsterCommonParam.me,FightEnum.EntityMoveSubState.WalkBack)
				--self.walkSwitchFrame = self.MonsterCommonParam.myFrame + self.MonsterCommonParam.switchDelayTime * 30
				--elseif self.MonsterCommonParam.battleTargetDistance>=self.MonsterCommonParam.shortRange and self.MonsterCommonParam.battleTargetDistance<self.MonsterCommonParam.longRange  then
				local a={1,2,3,4}
				if self.direactionDisable[3]~=nil then
					a[1]=nil
				end
				if self.direactionDisable[2]~=nil then
					a[2]=nil
				end
				if self.direactionDisable[1]~=nil then
					a[4]=nil
				end
				local b={}
				for k,v in pairs(a) do
					if v~=nil then
						table.insert(b,v)
					end
				end
				math.randomseed(os.time())
				local i=math.random(1,#b)
				local R=b[i]
				if R == 1 then
					BehaviorFunctions.DoSetMoveType(self.MonsterCommonParam.me,FightEnum.EntityMoveSubState.WalkLeft)
					self.walkSwitchFrame = self.MonsterCommonParam.myFrame + self.MonsterCommonParam.LRWalkSwitchTime * 30
				elseif R == 2 then
					BehaviorFunctions.DoSetMoveType(self.MonsterCommonParam.me,FightEnum.EntityMoveSubState.WalkRight)
					self.walkSwitchFrame = self.MonsterCommonParam.myFrame + self.MonsterCommonParam.LRWalkSwitchTime * 30
				elseif R == 3 then
					BehaviorFunctions.DoSetEntityState(self.MonsterCommonParam.me,FightEnum.EntityState.FightIdle)
					self.walkSwitchFrame = self.MonsterCommonParam.myFrame + self.MonsterCommonParam.walkDazeTime * 30
				elseif R == 4 then
					BehaviorFunctions.DoSetMoveType(self.MonsterCommonParam.me,FightEnum.EntityMoveSubState.Walk)
					self.walkSwitchFrame = self.MonsterCommonParam.myFrame + self.MonsterCommonParam.switchDelayTime * 30
				end
			end
		end
		if self.MonsterCommonParam.skillState == self.MonsterCommonParam.SkillStateEnum.InCommonCd then
			if BehaviorFunctions.GetEntityState(self.MonsterCommonParam.me)==FightEnum.EntityState.Idle then
				local a={1,2,3,4}
				if self.direactionDisable[3]~=nil then
					a[1]=nil
				end
				if self.direactionDisable[2]~=nil then
					a[2]=nil
				end
				if self.direactionDisable[1]~=nil then
					a[4]=nil
				end
				local b={}
				for k,v in pairs(a) do
					if v~=nil then
						table.insert(b,v)
					end
				end
				math.randomseed(os.time())
				local i=math.random(1,#b)
				local R=b[i]
				if R == 1 then
					BehaviorFunctions.DoSetMoveType(self.MonsterCommonParam.me,FightEnum.EntityMoveSubState.WalkLeft)
					self.walkSwitchFrame = self.MonsterCommonParam.myFrame + self.MonsterCommonParam.LRWalkSwitchTime * 30
				elseif R == 2 then
					BehaviorFunctions.DoSetMoveType(self.MonsterCommonParam.me,FightEnum.EntityMoveSubState.WalkRight)
					self.walkSwitchFrame = self.MonsterCommonParam.myFrame + self.MonsterCommonParam.LRWalkSwitchTime * 30
				elseif R == 3 then
					BehaviorFunctions.DoSetEntityState(self.MonsterCommonParam.me,FightEnum.EntityState.FightIdle)
					self.walkSwitchFrame = self.MonsterCommonParam.myFrame + self.MonsterCommonParam.walkDazeTime * 30
				elseif R == 4 then
					BehaviorFunctions.DoSetMoveType(self.MonsterCommonParam.me,FightEnum.EntityMoveSubState.Walk)
					self.walkSwitchFrame = self.MonsterCommonParam.myFrame + self.MonsterCommonParam.switchDelayTime * 30
				end

			end


		end
		if BehaviorFunctions.CanCtrl(self.MonsterCommonParam.me) then
			--在视野中
			if BehaviorFunctions.CompEntityLessAngle(self.MonsterCommonParam.me,self.MonsterCommonParam.battleTarget,self.MonsterCommonParam.visionAngle/2) then
				self.inVision = true
				--不在则进行转向
			else
				self.inVision = false
				BehaviorFunctions.DoLookAtTargetByLerp(self.MonsterCommonParam.me,self.MonsterCommonParam.battleTarget,true,0,60,-2)
			end
			if self.MonsterCommonParam.myState ==  FightEnum.EntityState.Move then
				BehaviorFunctions.DoLookAtTargetByLerp(self.MonsterCommonParam.me,self.MonsterCommonParam.battleTarget,true,0,60,-2)
			end
		end
	end
end

function Behavior900051:SplitParam(string,sep)
	local list={}
	if string == nil then
		return nil
	end
	string.gsub(string,'[^'..sep..']+',function (w)
			table.insert(list,w)
		end)
	return list
end


function Behavior900051:DeathEnter(instanceId,isFormationRevive)
	if instanceId==self.MonsterCommonParam.me then
		BehaviorFunctions.DoMagic(instanceId,instanceId,900000008)
		BehaviorFunctions.DoMagic(instanceId,instanceId,900000036)
	end
end

function Behavior900051:Die(attackInstanceId,dieInstanceId)
	if dieInstanceId==self.MonsterCommonParam.me then
		BehaviorFunctions.DoMagic(dieInstanceId,dieInstanceId,900000027)
		BehaviorFunctions.AddBuff(dieInstanceId,dieInstanceId,900000029)
	end
end
