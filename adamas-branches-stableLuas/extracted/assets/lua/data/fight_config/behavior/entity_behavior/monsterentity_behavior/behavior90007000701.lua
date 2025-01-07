Behavior90007000701 = BaseClass("Behavior90007000701",EntityBehaviorBase)

function Behavior90007000701.GetGenerates()
	local generates = {}
	return generates
end

function Behavior90007000701.GetMagics()
	local generates = {900000008,900000009,900000010,900000007}
	return generates
end

local BF = BehaviorFunctions

--初始化，执行1帧
function Behavior90007000701:Init()
	
	self.me = self.instanceId
	self.battleTarget = BehaviorFunctions.GetCtrlEntity()--记录玩家
	
	--开关
	self.isActive=0
end

function Behavior90007000701:Update()

	if self.isActive == 0 then  											--防止Buff反复触发保护
		
		--延时隐身：
		BF.AddDelayCallByTime(0.01,self,self.StealthFunction)				--延时时间长度由技能施法动作+特效时长决定
		--延时传送到玩家头顶进行突袭：
		BF.AddDelayCallByTime(0.3,self,self.AboveAttack)					--隐身后额外等待30帧执行传送（增加技能时长避免怪物移动）
	
		self.isActive = 1
	end
end

--执行隐身技能效果（添加隐身特效和隐身状态）：
function Behavior90007000701:StealthFunction()
	--添加隱身状态buff：
	BF.AddBuff(self.me,self.me,900000010,1)
	--添加霸体buff：
	BF.AddBuff(self.me,self.me,900000045,1)
	--添加免疫伤害buff：
	BF.AddBuff(self.me,self.me,900000023,1)
	--隐藏血条
	BF.SetEntityLifeBarVisibleType(self.me,3)

end


--隐身传送至玩家头顶
function Behavior90007000701:AboveAttack()
	local CastPos = Vec3.New()					--获取怪物释放技能位置
	local positionP = Vec3.New()				--获取玩家坐标
	local positionH = Vec3.New()				--获取玩家正上方空间坐标
	local positionT = Vec3.New()				--获取玩家位置深度&地形探针

	if BF.CheckEntity(self.battleTarget) then
		--位置信息记录
		positionP = BF.GetPositionP(self.battleTarget)
		CastPos = BF.GetPositionP(self.me)
		self.battleTargetLocation = BF.GetPositionP(self.battleTarget)
		
		local xDistance = math.abs(CastPos.x - positionP.x) -- 计算X轴距离
		local yDistance = math.abs(CastPos.y - positionP.y) -- 计算Y轴距离

		positionT:Set(positionP.x, positionP.y + 0.4, positionP.z)							--释放探针，检测玩家所在位置地形&地面高度
		positionH:Set(positionP.x, positionP.y + 2.2, positionP.z)					        --释放探针，检测玩家所在位置头顶空间
		
		----如果目标对象高度,水平距离都符合技能释放条件
		if yDistance < 10 and xDistance < 18 and
			BF.CheckEntityState(self.battleTarget,FightEnum.EntityState.Glide) == false then
			
			----同步怪物位于角色前上方
			--检测障碍：
			--保底检查：头顶空间尺寸，下方是否为“安全范围”——非岩浆，水，流沙...
			if not BF.CheckObstaclesBetweenPos(self.battleTargetLocation,positionH) then     		--头顶空间检测
				local hight,layer=BF.CheckPosHeight(positionT)
				if layer~=nil and hight~=nil and hight < 0.5       									--距离地面高度检查
					or layer~=FightEnum.Layer.Water													--检查地面层级
					or layer~=FightEnum.Layer.Marsh then

					--------符合条件的情况下进行传送：
					--移除隐身,受击免疫&本体隐身刺杀行为树buff
					BF.RemoveBuff(self.me,900000010)
					BF.RemoveBuff(self.me,900000045)
					BF.RemoveBuff(self.me,900000023)
					BF.SetEntityLifeBarVisibleType(self.me,3)
					--添加BUff（保护怪物避免进入下落状态机）&传送坐标：
					BF.AddBuff(self.me,self.me,9007005,1)
					BF.DoSetPositionP(self.me,positionH)

					--释放刺杀技能,移除下落速度
					BF.DoLookAtTargetByLerp(self.me,self.battleTarget,0,360,360,-2,includeX)
					BF.AddBuff(self.me,self.me,9007008)
					BF.CastSkillByPositionP(self.me,900070008,positionH)
					--BF.RemoveBuff(self.me,900000040)
					--BF.RemoveBuff(self.me,90007000701)
				end
			end
		else
			----不符合条件情况下进行保护底传送：
			--设置坐标：
			BF.RemoveBuff(self.me,900000023)
			BF.RemoveBuff(self.me,900000010)
			BF.RemoveBuff(self.me,900000045)
			BF.RemoveBuff(self.me,9007005)
			BF.SetEntityLifeBarVisibleType(self.me,2)
			BF.BreakSkill(self.me)
		end
	end
end