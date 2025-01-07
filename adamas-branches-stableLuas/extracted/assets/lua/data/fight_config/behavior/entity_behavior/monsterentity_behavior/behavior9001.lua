Behavior9001 = BaseClass("Behavior9001",EntityBehaviorBase)

function Behavior9001:Init()
	self.monster = self.instanceId
	self.battleTarget = 0
	self.key = true
	--self.timeStart = -300 
	self.t1=0
	self.skillList = {
		{id = 9001001,distance = 4,angle = 80,cd = 5,durationFrame = 90,frame = 0,priority = 1,isAuto = true,difficultyDegree = 0},
		{id = 9001002,distance = 4,angle = 80,cd = 5,durationFrame = 90,frame = 0,priority = 2,isAuto = true,difficultyDegree = 0},
		{id = 9001003,distance = 4,angle = 80,cd = 5,durationFrame = 90,frame = 0,priority = 3,isAuto = true,difficultyDegree = 0},
		{id = 9001004,distance = 4,angle = 80,cd = 5,durationFrame = 90,frame = 0,priority = 4,isAuto = true,difficultyDegree = 0},
		}
	self.skillTable0={9001001,9001002,9001003,9001004}
	self.skillTable={9001001,9001002,9001004,9001003} --怪物初始就有技能 --
	self.CD1=true
	self.CD2=true
	self.CD3=true
	self.CD4=true
	--self.hit = BehaviorFunctions.GetHitType(self.battleTarget)
	self.attackKey=true
	self.angleKey=false
	self.chooseSkill=true
	self.action=true
	self.time0 = 0
	self.time00=0
	self.keytest =true
	self.commonCD=true
end

function Behavior9001:Update()
	self.time = BehaviorFunctions.GetFightFrame()
	self.battleTarget = BehaviorFunctions.GetCtrlEntity()
	self.battleTargetDistance = BehaviorFunctions.GetDistanceFromTarget(self.monster,self.battleTarget)	
	self.angle = BehaviorFunctions.GetEntityAngle(self.monster,self.battleTarget)
	BehaviorFunctions.DoLookAtTargetImmediately(self.monster,self.battleTarget)
	--self.hit = BehaviorFunctions.GetHitType(self.battleTarget)
	self:CD()
	--self:Delay()
	self:Move()
	--self:Delay()
	self:Condition()
	self:CommonCD()
	self:Instruction()
	--self:NormalSkill()
end


function Behavior9001:Move()
	if #self.skillTable>0 and BehaviorFunctions.CanCastSkill(self.monster) == true and self.commonCD == true then --条件需要重新写
		if self.battleTargetDistance >10 and BehaviorFunctions.GetSubMoveState(self.monster)~=FightEnum.EntityMoveSubState.Run then
			BehaviorFunctions.DoSetMoveType(self.monster,FightEnum.EntityMoveSubState.Run)

		elseif self.battleTargetDistance<=10 and self.battleTargetDistance>2 and BehaviorFunctions.GetSubMoveState(self.monster)~=FightEnum.EntityMoveSubState.Walk then
			BehaviorFunctions.DoSetMoveType(self.monster,FightEnum.EntityMoveSubState.Walk)
		elseif self.battleTargetDistance <=2 then
			self:Attack() --判断是否有技能满足释放条件
		end
	elseif #self.skillTable==0  and self.time-self.time0>60 and BehaviorFunctions.CanCastSkill(self.monster) == true and self.commonCD == true then  --条件需要重写,当技能是空的时候，也不能瞬间切到这个状态。要等攻击动作做完才可以。
		if self.battleTargetDistance >10 and BehaviorFunctions.GetSubMoveState(self.monster)~=FightEnum.EntityMoveSubState.Run then
			BehaviorFunctions.DoSetMoveType(self.monster,FightEnum.EntityMoveSubState.Run)
		elseif self.battleTargetDistance<=10 and self.battleTargetDistance>4 and (BehaviorFunctions.GetSubMoveState(self.monster)~=FightEnum.EntityMoveSubState.WalkLeft and BehaviorFunctions.GetSubMoveState(self.monster)~=FightEnum.EntityMoveSubState.WalkRight ) then
			self:Random()
			self.time0=self.time
		elseif self.battleTargetDistance <=4 and BehaviorFunctions.GetSubMoveState(self.monster)~=FightEnum.EntityMoveSubState.WalkBack then
			BehaviorFunctions.DoSetMoveType(self.monster,FightEnum.EntityMoveSubState.WalkBack)
			self.time0=self.time
		end
	end
end


--通过指令释放技能时，同样需要进入公共CD。
----只要chooseSkill开关开了，就会使用SkillRandom函数，使用这个函数的前提是技能库不为空。
function Behavior9001:Instruction() --选择使用的技能（保证选出来的技能不在CD中），技能选择也是一个开关，不能每帧都变化。
	--当选择函数的开关打开时，才会做技能选择。一旦选择了技能，该函数就关闭，直到技能释放完毕+公共CD，才会重新选择技能。
	if BehaviorFunctions.CanCastSkill(self.monster) == true then
		if BehaviorFunctions.CheckKeyDown(FightEnum.KeyEvent.Attack) and self.CD1==true then --CD函数还需要写
			self.a = 9001001
			BehaviorFunctions.CastSkillByTarget(self.monster,self.a,self.battleTarget)
			self.timeStart1 = self.time --记录释放技能的时间
			for i,v in ipairs(self.skillTable) do
				if v ==self.a  then
					self.x= i
				end
			end
			table.remove(self.skillTable,self.x) --在灵活技能库中移除使用的技能
			self.CD1=false
			self.commonCD=false
		elseif BehaviorFunctions.CheckKeyDown(FightEnum.KeyEvent.Dodge) and self.CD2==true  then
			self.a =9001002
			BehaviorFunctions.CastSkillByTarget(self.monster,self.a,self.battleTarget)
			self.timeStart2 = self.time --记录释放技能的时间
			for i,v in ipairs(self.skillTable) do
				if v ==self.a  then
					self.x= i
				end
			end
			table.remove(self.skillTable,self.x) --在灵活技能库中移除使用的技能
			self.CD2=false
			self.commonCD=false
		elseif BehaviorFunctions.CheckKeyDown(FightEnum.KeyEvent.Jump)  and self.CD3==true  then
			self.a =9001003
			BehaviorFunctions.CastSkillByTarget(self.monster,self.a,self.battleTarget)
			self.timeStart3 = self.time
			for i,v in ipairs(self.skillTable) do
				if v ==self.a  then
					self.x= i
				end
			end
			table.remove(self.skillTable,self.x) --在灵活技能库中移除使用的技能
			self.CD3=false
			self.commonCD=false
			self.timeStart=self.time
		end
	end
end

--通过指令使用技能后，公共CD开关关闭。什么时候能够打开开关呢？

--function Behavior9001:NormalSkill()
	--if self.chooseSkill == true then --这里选了一个技能，但是可能会被指令的技能库删除掉
		--self:SkillRandom()
		--self.chooseSkill =false
	--end
--end



function Behavior9001:Condition() --每帧都需要判断角度，判断是否符合开启条件
	if self.angle <= 80  then --判断是否符合释放角度。偷懒了，先这样吧
		self.angleKey =true
	elseif self.angle>80 then
		self.angleKey=false
	end
end




--选出不在CD的技能后，保持走路状态，直到找到合适的角度，释放该技能。	
function Behavior9001:Attack()  --当角度合适的时候释放技能，1）一旦释放技能不再释放该技能，技能立刻进入冷却状态，直到冷却结束才开启。2）技能需要释放完，才可以切换下一个状态，3）技能释放完，进入公共CD，公共CD结束才能释放下一个技能。
	if self.angleKey == true and self.attackKey == true and BehaviorFunctions.CanCastSkill(self.monster) == true then
		self:SkillRandom() --随机一个技能
		BehaviorFunctions.CastSkillByTarget(self.monster,self.a,self.battleTarget) --立刻释放技能
		self.commonCD=false

		self.attackKey = false --释放了技能立刻关闭攻击按钮，直到公共CD结束才打开这个开关。
		self.timeStart = self.time --记录释放技能的时间

		if self.a ==9001001 then --释放技能的瞬间关闭CD开关，CD好的瞬间打开开关，这样就不会重复执行了。
			self.timeStart1=self.timeStart
			self.CD1=false
		elseif self.a ==9001002 then --犯了个很傻的问题。技能判断只是用于CD判断，不应该同时作为插入技能开关。应该是技能-CD-插入。现在写的逻辑：技能同时影响CD和插入两个条件。
			self.timeStart2=self.timeStart
			self.CD2=false
		elseif self.a ==9001003 then
			self.timeStart3=self.timeStart
			self.CD3=false
		elseif self.a ==9001004  then
			self.timeStart4=self.timeStart
			self.CD4=false

		end

		--self.a是被索引值，如何反推索引值
		for i,v in ipairs(self.skillTable) do
			if v ==self.a  then
				self.x= i
			end
		end
		table.remove(self.skillTable,self.x) --在灵活技能库中移除使用的技能
		--当角色没做出攻击行为，角度不正确时，保持走路状态，直到找到正确角度。
	elseif self.attackKey ==true and self.anglekey ==false and  BehaviorFunctions.GetSubMoveState(self.monster)~=FightEnum.EntityMoveSubState.Walk then
		BehaviorFunctions.DoSetMoveType(self.monster,FightEnum.EntityMoveSubState.Walk)
	end
end




--function Behavior9001:Delay() --判断攻击动作是否播完，如果播完则可以进入下一阶段。Delay()函数在动画结束的一瞬间，就需要开启。
	--if self.commonCD== true then

		--if BehaviorFunctions.CanCastSkill(self.monster) == true then
		--self.commonTime =self.time 
			--self.commonCD=false

		--end
	--end
--end

--当动作播完的时候，进入公共CD,公共CD按钮关闭


function Behavior9001:CommonCD() --公共CD2s,一种偷懒的写法，正式写法应该根据动作时间来判断，先这样写。
	if self.timeStart then --每当通过随机方式生成技能时，释放完技能时进入公共CD。
		if self.time-self.timeStart==200  then --结束公共CD的结点
			self.attackKey=true	--公共CD结束的时候，怪物可以再次发动技能。
			BehaviorFunctions.DoSetMoveType(self.monster,FightEnum.EntityMoveSubState.Walk) --直接切换成走路状态
			self.commonCD=true
		--保证技能动画需要播完
		elseif #self.skillTable>0 and self.time-self.timeStart<200  and (BehaviorFunctions.GetSubMoveState(self.monster)~=FightEnum.EntityMoveSubState.WalkLeft and BehaviorFunctions.GetSubMoveState(self.monster)~=FightEnum.EntityMoveSubState.WalkRight ) and BehaviorFunctions.CanCastSkill(self.monster) == true  then --
			self:Random() --在公共CD的时候，怪物左右移动
		end
	end
end

--这段时间在左右走的同时


--这里有一个问题，self.timeStart的来源太多了。
--如果时读指令释放的技能，不走CD这条判断。

function Behavior9001:CD() --技能是否能够使用，能使用的时候加入技能库。用table应该能简化 
	--if self.timeStart then
		--if self.a ==9001001 then --释放技能的瞬间关闭CD开关，CD好的瞬间打开开关，这样就不会重复执行了。
			--self.timeStart1=self.timeStart
		--elseif self.a ==9001002 then --犯了个很傻的问题。技能判断只是用于CD判断，不应该同时作为插入技能开关。应该是技能-CD-插入。现在写的逻辑：技能同时影响CD和插入两个条件。
			--self.timeStart2=self.timeStart
		--elseif self.a ==9001003 then
			--self.timeStart3=self.timeStart
		--elseif self.a ==9001004  then
			--self.timeStart4=self.timeStart
		--end
		if self.timeStart1 then
			if self.time-self.timeStart1==450 then
				self.CD1=true
				table.insert(self.skillTable,9001001)
			end
		end
		if self.timeStart2 then
			if self.time-self.timeStart2==450 then
				self.CD2=true
				table.insert(self.skillTable,9001002)
			end
		end
		if self.timeStart3 then
			if self.time-self.timeStart3==450 then --当CD3转好的时候，此时的self.a不一定是之前的技能。需要重新思考这里怎么写。
				self.CD3=true
				table.insert(self.skillTable,9001003)
			end
		end
		if self.timeStart4 then
			if self.time-self.timeStart4==450 then
				self.CD4=true
				table.insert(self.skillTable,9001004)
			end
		end
	--end
end





function Behavior9001:SkillRandom() --随机技能，技能库是每帧都变化的。在Attack函数中，使用了技能就删除库里的技能。等CD好了就加回来。
	if #self.skillTable~=0 then --空的时候别进这个判断
		local randomIndex = math.random(1,#self.skillTable) 
		self.a=self.skillTable[randomIndex]
	end
end



function Behavior9001:Random() --随机左移右移的运动函数。
	self.R = BehaviorFunctions.RandomSelect(1,2)
	if self.R ==1 then
		BehaviorFunctions.DoSetMoveType(self.monster,FightEnum.EntityMoveSubState.WalkRight)
	elseif self.R==2 then
		BehaviorFunctions.DoSetMoveType(self.monster,FightEnum.EntityMoveSubState.WalkLeft)
	end
end



--发现指令和随机技能独立。


--公共CD有不自然的动作
--空技能左右走，左右走有不自然的抖动。应该有状态冲突，可能和前进的状态有冲突。

--空技能，同时处于公共CD和空技能状态










--function Behavior9001:Instruction() --选择使用的技能（保证选出来的技能不在CD中），技能选择也是一个开关，不能每帧都变化。
	--if self.chooseSkill ==true then --当选择函数的开关打开时，才会做技能选择。一旦选择了技能，该函数就关闭，直到技能释放完毕+公共CD，才会重新选择技能。
		--if BehaviorFunctions.CheckKeyDown(FightEnum.KeyEvent.Attack) and self.CD1==true and self.action ==true then --CD函数还需要写
			--self.a = 9001001
		--elseif BehaviorFunctions.CheckKeyDown(FightEnum.KeyEvent.Dodge) and self.CD2==true and self.action ==true then
			--self.a =9001002
		--elseif BehaviorFunctions.CheckKeyDown(FightEnum.KeyEvent.Jump)  and self.CD3==true and self.action ==true then
			--self.a =9001003
		--else
			--self:SkillRandom()--随机技能
			----self.a =9001003
		--end
		--self.chooseSkill =false
	--end
--end







--Behavior9001 = BaseClass("Behavior9001",EntityBehaviorBase)

--function Behavior9001:Init()
	--self.monster = self.instanceId
	--self.battleTarget = 0
	--self.key = true
	--self.timeStart = -300
	--self.t1=0
	--self.skillList = {
		--{id = 9001001,distance = 4,angle = 80,cd = 5,durationFrame = 90,frame = 0,priority = 1,isAuto = true,difficultyDegree = 0},
		--{id = 9001002,distance = 4,angle = 80,cd = 5,durationFrame = 90,frame = 0,priority = 2,isAuto = true,difficultyDegree = 0},
		--{id = 9001003,distance = 4,angle = 80,cd = 5,durationFrame = 90,frame = 0,priority = 3,isAuto = true,difficultyDegree = 0},
		--{id = 9001004,distance = 4,angle = 80,cd = 5,durationFrame = 90,frame = 0,priority = 4,isAuto = true,difficultyDegree = 0},
	--}
--end

--function Behavior9001:Update()
	--self.time = BehaviorFunctions.GetFightFrame()
	--self.battleTarget = BehaviorFunctions.GetCtrlEntity()
	--self.battleTargetDistance = BehaviorFunctions.GetDistanceFromTarget(self.monster,self.battleTarget)
	--self.angle = BehaviorFunctions.GetEntityAngle(self.monster,self.battleTarget)
	--BehaviorFunctions.DoLookAtTargetImmediately(self.monster,self.battleTarget)
	--self.hit = BehaviorFunctions.GetHitType(self.battleTarget)
	--self:CD()
	--self:Delay()
--end


--function Behavior9001:CD()
	--if self.time - self.timeStart>=360 and self.key ==true  then
		--if self.battleTargetDistance >10 and BehaviorFunctions.GetSubMoveState(self.monster)~=FightEnum.EntityMoveSubState.Run then
			--BehaviorFunctions.DoSetMoveType(self.monster,FightEnum.EntityMoveSubState.Run)
		--elseif self.battleTargetDistance<=10 and self.battleTargetDistance>1 and BehaviorFunctions.GetSubMoveState(self.monster)~=FightEnum.EntityMoveSubState.Walk then
			--BehaviorFunctions.DoSetMoveType(self.monster,FightEnum.EntityMoveSubState.Walk)
		--elseif self.battleTargetDistance <=1 then
			--self:Attack()
		--end
	--elseif self.time- self.timeStart < 360 and self.key == true then
		--if self.battleTargetDistance >10 and BehaviorFunctions.GetSubMoveState(self.monster)~=FightEnum.EntityMoveSubState.Run then
			--BehaviorFunctions.DoSetMoveType(self.monster,FightEnum.EntityMoveSubState.Run)
		--elseif self.battleTargetDistance<=10 and self.battleTargetDistance>4 and (BehaviorFunctions.GetSubMoveState(self.monster)~=FightEnum.EntityMoveSubState.WalkLeft and BehaviorFunctions.GetSubMoveState(self.monster)~=FightEnum.EntityMoveSubState.WalkRight ) then
			--self:Random()
		--elseif self.battleTargetDistance <=4 and BehaviorFunctions.GetSubMoveState(self.monster)~=FightEnum.EntityMoveSubState.WalkBack then
			--BehaviorFunctions.DoSetMoveType(self.monster,FightEnum.EntityMoveSubState.WalkBack)
		--end
	--end
--end


--function Behavior9001:Attack() --满足攻击条件时，发起攻击；不满足攻击条件时，保持向角色走的过程，直到满足条件。
	--if BehaviorFunctions.CheckKeyDown(FightEnum.KeyEvent.Attack) then
		--self.a = 9001001
	--elseif BehaviorFunctions.CheckKeyDown(FightEnum.KeyEvent.Dodge) then
		--self.a =9001002
	--elseif BehaviorFunctions.CheckKeyDown(FightEnum.KeyEvent.RedSkill) or BehaviorFunctions.CheckKeyDown(FightEnum.KeyEvent.BlueSkill) then
		--self.a =9001003
	--else
		--self.a = 9001004
	--end
	--if self.angle <80 and self.hit==0 and self.key== true then
		--BehaviorFunctions.CastSkillByTarget(self.monster,self.a,self.battleTarget)
		--self.timeStart=BehaviorFunctions.GetFightFrame() --当释放技能的时候，刷新timeStart的值。
	--end
--end
----这里犯了一个很傻逼的问题，攻击一次之后，self.angle和self.hit条件还是满足的。所以，需要另外设计一个开关，记录攻击的时间，在这一时刻把开关关上，不要再执行攻击的指令了。

--function Behavior9001:Delay() --判断攻击动作是否播完，如果播完则可以进入下一阶段。
	--if self.time-self.timeStart ==0 then
		--self.key = false --攻击动作没有播完，不可切换状态。
	--elseif self.time-self.timeStart>60 then
		--self.key = true
	--end
--end


--function Behavior9001:Random()
	--self.R = BehaviorFunctions.RandomSelect(1,2)
	--if self.R ==1 then
		--BehaviorFunctions.DoSetMoveType(self.monster,FightEnum.EntityMoveSubState.WalkRight)
	--elseif self.R==2 then
		--BehaviorFunctions.DoSetMoveType(self.monster,FightEnum.EntityMoveSubState.WalkLeft)
	--end
--end



















