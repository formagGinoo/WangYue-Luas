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

	--通用参数：
	self.me = self.instanceId--記錄自己
	self.battleTarget = BF.GetCtrlEntity()--记录玩家
	self.MonsterCommonParam = BF.CreateBehavior("MonsterCommonParam",self)
	self.MonsterCommonBehavior = BF.CreateBehavior("MonsterCommonBehavior",self)
	--开关
	self.isActive=0
end

function Behavior90007000701:Update()

	if self.isActive == 0 then  																--防止Buff反复触发保护
		--添加隱身特效magic&无敌，隐身Buff：
		--BF.DoMagic(self.me,self.me,9000700701,1)--还缺特效
		BF.DoMagic(self.me,self.me,900000007,1)
		BF.DoMagic(self.me,self.me,900000010,1)

		----延时多少秒展示玩家头上警示标记：
		--BF.AddDelayCallByTime(2.5,self,self.MaskTargetHead)

		--延时隐身：
		BF.AddDelayCallByTime(2,self,self.StealthFunction)										--延时时间长度由技能施法动作+特效时长决定
		--延时传送到玩家头顶进行突袭：
		BF.AddDelayCallByTime(3.5,self,self.AboveAttack)
		--移除技能状态恢复正常保底：
		BF.AddDelayCallByTime(5.5,self,self.RecoverNormal)										--延时时间长度由技能释放完毕时间节点决定
		self.isActive =1
	end
end

----玩家头上警示标记：
--function Behavior90007000701:MaskTargetHead()
	--BF.DoMagic(self.me,self.battleTarget,90007007,1)
--end


--执行隐身技能效果（添加隐身特效和隐身状态）：
function Behavior90007000701:StealthFunction()
	--添加隱身特效magic&隱身状态buff：：
	--BF.DoMagic(self.me,self.me,9000700701,1)--还缺特效
	BF.DoMagic(self.me,self.me,900000010,1)
end


--隐身传送至玩家头顶
function Behavior90007000701:AboveAttack(instanceId)
	
	--技能释放保底判断
	if BF.CheckEntity(self.battleTarget) and self.MonsterCommonParam.inFight == true and BF.CanCtrl(self.MonsterCommonParam.me) then
		--位置信息记录
		self.myLocation=BF.GetPositionP(self.me)
		self.battleTargetLocation=BF.GetPositionP(self.battleTarget)

		--获取目标数据&数据偏移：
		local positionP = BF.GetPositionP(self.battleTarget)
		local positionH = BF.GetPositionP(self.battleTarget)
		positionP.y = positionP.y + 0.4															--释放探针，检测玩家所在位置地形&地面高度
		positionH.y = positionH.y + 4															--释放探针，检测玩家所在位置头顶空间
		
		--检测障碍：
		--保底检查：头顶空间尺寸，下方是否为“安全范围”——非岩浆，水，流沙...
		if not BF.CheckObstaclesBetweenPos(self.battleTargetLocation,positionH,false) then     	--头顶空间检测
			self.posCheck=BF.GetPositionOffsetBySelf(self.MonsterCommonParam.me,2,0)
			local hight,layer=BF.CheckPosHeight(positionP)
			if layer~=nil and hight~=nil and hight<0.7       									--距离地面高度检查
				or layer~=FightEnum.Layer.Water													--检查地面层级
				or layer~=FightEnum.Layer.Marsh
				or layer~=FightEnum.Layer.Lava
				or layer~=FightEnum.Layer.Driftsand then
				
				
				
			--------符合条件情况下进行传送：
			--设置坐标：
			BF.DoSetPositionP(self.me,positionH)
			--退出隐身特效
			--BF.DoMagic(self.me,self.me,9000700703,1)--还缺特效
			--释放退出隐身刺杀技能
			BF.DoLookAtTargetImmediately(self.me,self.battleTarget)
			BF.CastSkillByTarget(self.me,900070008,self.battleTarget)
			--移除隐身,无敌buff&本体隐身刺杀行为树buff
			BF.RemoveBuff(self.me,900000010)
			BF.RemoveBuff(self.me,900000007)
			--BF.RemoveBuff(self.me,900070007)--还缺特效
			BF.RemoveBuff(self.me,900000040)
			BF.BreakSkill(self.MonsterCommonParam.me)
			end
		end
	end
end	


--缺了一个如果条件不满足，怎么出来的保底攻击行为方案

--延时激活用的恢复状态保底buff：
function Behavior90007000701:RecoverNormal(instanceId)
	if BF.CheckEntity(self.me) and BF.CanCtrl(self.me) then
		BF.RemoveBuff(self.me,900000010)--移除隐身buff
		BF.RemoveBuff(self.me,900000007)--移除无敌buff
		--BF.RemoveBuff(self.me,900070007)--移除本体隐身刺杀行为树buff
		BF.RemoveBuff(self.me,900000040)
	end
end