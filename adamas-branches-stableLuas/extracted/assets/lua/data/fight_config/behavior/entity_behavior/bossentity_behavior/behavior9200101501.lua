Behavior9200101501 = BaseClass("Behavior9200101501",EntityBehaviorBase)

function Behavior9200101501.GetGenerates()
	local generates = {}
	return generates
end

function Behavior9200101501.GetMagics()
	local generates = {900000008,900000009,900000010,900000007}
	return generates
end

BF=BehaviorFunctions

--初始化，执行1帧
function Behavior9200101501:Init()

	--通用参数：
	self.me = self.instanceId--記錄自己
	self.battleTarget = BehaviorFunctions.GetCtrlEntity()--记录玩家
	
	--開關
	self.isActive=0
	

end

function Behavior9200101501:Update()
	
	
	
	if self.isActive == 0 then--如果身上已經有了這個buff
		--添加隱身特效magic：
		BF.DoMagic(self.me,self.me,92001011,1)
		
		--添加无敌magic:
		BF.DoMagic(self.me,self.me,900000007,1)
		
		--隱身状态buff：
		BF.DoMagic(self.me,self.me,900000010,1)
		
		----------------
		
		--延时多少秒出现头上的标记：
		BF.AddDelayCallByTime(2.5,self,self.MaskTargetHead)
		
		--延时传送到正前方左跳：
		BF.AddDelayCallByTime(2,self,self.LeftFlash)
		
		--延时隐身：
		BF.AddDelayCallByTime(2.5,self,self.StealthBuff)
		
		--延时传送到正前方右跳：
		BF.AddDelayCallByTime(3.5,self,self.RightFlash)
		
		--延时隐身：
		BF.AddDelayCallByTime(4,self,self.StealthBuff)
		
		--延时飞弹：
		BF.AddDelayCallByTime(5,self,self.MissileFlash)
		
		--延时隐身：
		BF.AddDelayCallByTime(7.5,self,self.StealthBuff)
		
		--突进挑飞：
		BF.AddDelayCallByTime(8,self,self.CastSkill_Attack015)
		
		
		
		--给自己加一个保底buff：
		BF.AddDelayCallByTime(12,self,self.BaodiBuff)
		
		self.isActive =1
			
	end				
	
end

--玩家头上的标记：
function Behavior9200101501:MaskTargetHead()
	BF.DoMagic(self.me,self.battleTarget,92001012,1)
end

--添加隐身特效和隐身状态：
function Behavior9200101501:StealthBuff()
	--添加隱身特效magic：
	BF.DoMagic(self.me,self.me,92001011,1)
	--隱身状态buff：
	BF.DoMagic(self.me,self.me,900000010,1)
	
end


--隐身传送左闪现：
function Behavior9200101501:LeftFlash()
	if BF.CheckEntity(self.battleTarget) then--如果敌方目标存在：
		--获取我的坐标：
		self.myLocation=BF.GetPositionP(self.me)

		--获取敌方坐标：
		self.battleTargetLocation=BF.GetPositionP(self.battleTarget)


		--根据目标坐标以角度和距离偏移得到新的坐标(角度、距离)：
		for i = 0,3600,25 do

			local positionP = BehaviorFunctions.GetPositionOffsetBySelf(self.battleTarget,6,i)

			--检测障碍：
			if not BF.CheckObstaclesBetweenPos(self.battleTargetLocation,positionP,false) then
				--如果没有障碍的情况下就进行传送：
				--设置坐标：
				BF.DoSetPositionP(self.me,positionP)
				BF.DoMagic(self.me,self.me,92001011,1)--显形特效
				--延时多少秒进行攻击,并且面向目标：
				BF.DoLookAtTargetImmediately(self.me,self.battleTarget)--看向目标
				BF.CastSkillByTarget(self.me,92001001,self.battleTarget)--朝目标放技能
				BF.RemoveBuff(self.me,900000010)--移除隐身buff
				break
			end
		end
	end
end

--隐身传送右闪现：
function Behavior9200101501:RightFlash()
	if BF.CheckEntity(self.battleTarget) then--如果敌方目标存在：
		--获取我的坐标：
		self.myLocation=BF.GetPositionP(self.me)

		--获取敌方坐标：
		self.battleTargetLocation=BF.GetPositionP(self.battleTarget)


		--根据目标坐标以角度和距离偏移得到新的坐标(角度、距离)：
		for i = 0,3600,25 do

			local positionP = BehaviorFunctions.GetPositionOffsetBySelf(self.battleTarget,6,i)

			--检测障碍：
			if not BF.CheckObstaclesBetweenPos(self.battleTargetLocation,positionP,false) then
				--如果没有障碍的情况下就进行传送：
				--设置坐标：
				BF.DoSetPositionP(self.me,positionP)
				BF.DoMagic(self.me,self.me,92001011,1)--显形特效
				--延时多少秒进行攻击,并且面向目标：
				BF.DoLookAtTargetImmediately(self.me,self.battleTarget)
				BF.CastSkillByTarget(self.me,92001002,self.battleTarget)--朝目标放技能
				BF.RemoveBuff(self.me,900000010)--移除隐身buff
				break
			end
		end
	end
end

--隐身传送左闪现：
function Behavior9200101501:MissileFlash()
	if BF.CheckEntity(self.battleTarget) then--如果敌方目标存在：
		--获取我的坐标：
		self.myLocation=BF.GetPositionP(self.me)

		--获取敌方坐标：
		self.battleTargetLocation=BF.GetPositionP(self.battleTarget)
		
		--申明第二个技能开关：
		local initHoutiao=0


		--根据目标坐标以角度和距离偏移得到新的坐标(角度、距离)：
		for i = 0,3600,25 do

			local positionP = BehaviorFunctions.GetPositionOffsetBySelf(self.battleTarget,6,i)

			--检测障碍：
			if not BF.CheckObstaclesBetweenPos(self.battleTargetLocation,positionP,false) then
				--如果没有障碍的情况下就进行传送：
				--设置坐标：
				BF.DoSetPositionP(self.me,positionP)
				BF.DoMagic(self.me,self.me,92001011,1)--显形特效
				--延时多少秒进行攻击,并且面向目标：
				BF.DoLookAtTargetImmediately(self.me,self.battleTarget)
				BF.CastSkillByTarget(self.me,92001010,self.battleTarget)--朝目标放技能
				BF.RemoveBuff(self.me,900000010)--移除隐身buff
				break
			end
		end
	end
end


--判断玩家位置+传送到合适位置+放技能+删除该buff
function Behavior9200101501:CastSkill_Attack015()
	
	
	
	if BF.CheckEntity(self.battleTarget) then--如果敌方目标存在：
		--获取我的坐标：
		self.myLocation=BF.GetPositionP(self.me)

		--获取敌方坐标：
		self.battleTargetLocation=BF.GetPositionP(self.battleTarget)


		--根据目标坐标以角度和距离偏移得到新的坐标(角度、距离)：
		for i = 0,3600,25 do

			local positionP = BehaviorFunctions.GetPositionOffsetBySelf(self.battleTarget,6,i)

			--检测障碍：
			if not BF.CheckObstaclesBetweenPos(self.battleTargetLocation,positionP,false) then
				--如果没有障碍的情况下就进行传送：
				--设置坐标：
				BF.DoSetPositionP(self.me,positionP)
				BF.DoMagic(self.me,self.me,92001011,1)--显形特效
				--延时多少秒进行攻击,并且面向目标：
				BF.DoLookAtTargetImmediately(self.me,self.battleTarget)
				BF.CastSkillByTarget(self.me,92001008,self.battleTarget)--朝目标放技能
				BF.RemoveBuff(self.me,900000010)--移除隐身buff
				BF.RemoveBuff(self.me,900000007)--移除无敌buff
				BF.RemoveBuff(self.me,9200101501)--移除本体buff
				break
			end
		end
	end
end

--保底buff：

function Behavior9200101501:BaodiBuff()
	
	
	if BF.CheckEntity(self.me) then--如果我方目标存在：
		BF.RemoveBuff(self.me,900000010)--移除隐身buff
		BF.RemoveBuff(self.me,900000007)--移除无敌buff
		BF.RemoveBuff(self.me,9200101501)--移除本体buff
	end
end