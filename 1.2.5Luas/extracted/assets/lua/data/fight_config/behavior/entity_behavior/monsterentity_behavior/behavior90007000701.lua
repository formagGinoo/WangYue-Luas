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
	--self.MonsterCommonParam = BF.CreateBehavior("MonsterCommonParam",self)
	--self.MonsterCommonBehavior = BF.CreateBehavior("MonsterCommonBehavior",self)
	
	--开关
	self.isActive=0
end

function Behavior90007000701:Update()

	if self.isActive == 0 then  																--防止Buff反复触发保护
		
		--延时隐身：
		BF.AddDelayCallByTime(1.3,self,self.StealthFunction)								    --延时时间长度由技能施法动作+特效时长决定
		--延时传送到玩家头顶进行突袭：
		BF.AddDelayCallByTime(2.4,self,self.AboveAttack)										--延时时间长度最小为1.9（ATK007施法时长）
		--移除技能状态恢复正常保底：
		BF.AddDelayCallByTime(4,self,self.RecoverNormal)										--延时时间长度由技能释放完毕时间节点决定
		self.isActive = 1
	end
end

--执行隐身技能效果（添加隐身特效和隐身状态）：
function Behavior90007000701:StealthFunction()
	--添加隱身状态buff：
	BF.AddBuff(self.me,self.me,900000010,1)
	--添加霸体buff：
	BF.AddBuff(self.me,self.me,900000045,1)
	--隐藏血条
	BF.SetEntityLifeBarVisibleType(self.me,3)

end


--隐身传送至玩家头顶
function Behavior90007000701:AboveAttack()
	local myPos = Vec3.New()					--获取怪物释放技能位置
	local positionP = Vec3.New()				--获取玩家坐标
	local positionH = Vec3.New()				--获取玩家正上方空间坐标
	local positionT = Vec3.New()				--获取玩家位置深度&地形探针
	--技能释放保底判断
	if BF.CheckEntity(self.battleTarget) then
		
		
		--位置信息记录
		positionP = BF.GetPositionP(self.battleTarget)
		myPos = BF.GetPositionP(self.me)
		self.battleTargetLocation = BF.GetPositionP(self.battleTarget)

		positionT:Set(positionP.x, positionP.y + 0.4, positionP.z)							--释放探针，检测玩家所在位置地形&地面高度
		positionH:Set(positionP.x, positionP.y + 2.2, positionP.z)					        --释放探针，检测玩家所在位置头顶空间
		
		--检测障碍：
		--保底检查：头顶空间尺寸，下方是否为“安全范围”——非岩浆，水，流沙...
		if not BF.CheckObstaclesBetweenPos(self.battleTargetLocation,positionH) then     		--头顶空间检测
			local hight,layer=BF.CheckPosHeight(positionT)
			if layer~=nil and hight~=nil and hight < 0.5       									--距离地面高度检查
				or layer~=FightEnum.Layer.Water													--检查地面层级
				or layer~=FightEnum.Layer.Marsh
				or layer~=FightEnum.Layer.Lava
				or layer~=FightEnum.Layer.Driftsand then

				--------符合条件情况下进行传送：
				--设置坐标：
				BF.DoSetPositionP(self.me,positionH)
				--退出隐身特效
				--BF.DoMagic(self.me,self.me,9000700703,1)--还缺特效
				--移除隐身,受击免疫&本体隐身刺杀行为树buff
				BF.RemoveBuff(self.me,900000010)
				BF.RemoveBuff(self.me,900000045)
				BF.SetEntityLifeBarVisibleType(self.me,2)
				--释放退出隐身刺杀技能
				BF.DoLookAtTargetByLerp(self.me,self.battleTarget,0,360,360,-2,includeX)
				BF.CastSkillByPositionP(self.me,900070008,positionH)
				--BF.RemoveBuff(self.me,900070007)--还缺特效
				--BF.RemoveBuff(self.me,900000040)
				--BF.RemoveBuff(self.me,90007000701)
			end
		else
			--------不符合条件情况下进行保护底传送：
			--设置坐标：
			--BF.DoSetPositionP(self.me,myPos)
			--BF.TransportByInstanceId(self.me,positionH,0.1)
			--退出隐身特效
			--BF.DoMagic(self.me,self.me,9000700703,1)--还缺特效
			--移除隐身,受击免疫&本体隐身刺杀行为树buff
			--BF.RemoveBuff(self.me,900000010)
			--BF.RemoveBuff(self.me,self.me,900000045,1)
			--BF.RemoveBuff(self.me,self.me,900000029)
			--BF.RemoveBuff(self.me,900070007)--还缺特效
			--BF.RemoveBuff(self.me,900000040)
			--BF.RemoveBuff(self.me,90007000701)
		end
	end
end	

--延时激活用的恢复状态保底buff：
function Behavior90007000701:RecoverNormal(instanceId)
	if BF.CheckEntity(self.me) then
		local myPos = Vec3.New()					--重置怪物释放技能时位置数据
		local positionP = Vec3.New()				--重置获取玩家坐标数据
		local positionH = Vec3.New()				--重置玩家正上方空间坐标获取坐标数据
		local positionT = Vec3.New()				--重置玩家位置深度&地形探针获取坐标数据
		--BF.RemoveBuff(self.me,900000010)--移除隐身buff
		--BF.RemoveBuff(self.me,900000007)--移除无敌buff
		--BF.RemoveBuff(self.me,900070007)--移除本体隐身刺杀行为树buff
		--BF.RemoveBuff(self.me,900000040)
		--BF.RemoveBuff(self.me,90007000701)
	end
end