Behavior2030208 = BaseClass("Behavior2030208",EntityBehaviorBase)
--可破坏花遗迹
function Behavior2030208.GetGenerates()
	-- local generates = {}
	-- return generates
end

function Behavior2030208:Init()
	self.me = self.instanceId
	self.state = true
	self.mission=0
	self.myFrame=0
	self.fightFrame=0
	self.startFrame=0
	self.magicKey=true
	self.bornPosition={}
end


function Behavior2030208:Update()
	----等有分组了再取消注释
	--if BehaviorFunctions.GetEcoEntityGroup(nil,nil,self.me) then
	--self.monsterGroup=BehaviorFunctions.GetEcoEntityGroup(nil,nil,self.me) --每帧都需要修改自己的组内成员
	--end


	self.fightFrame=BehaviorFunctions.GetFightFrame()
	self.startFrame=BehaviorFunctions.GetEntityFrame(self.me)
	if self.mission==0 and self.startFrame>1 then
		BehaviorFunctions.DoMagic(1,self.me,900000020)
		BehaviorFunctions.DoMagic(1,self.me,900000022)
		self.mission=1
	end


	if self.mission==1 then
		if BehaviorFunctions.GetEcoEntityGroup(nil,nil,self.me) then
			self.monsterGroup=BehaviorFunctions.GetEcoEntityGroup(nil,nil,self.me) --每帧都需要修改自己的组内成员
		end

		if self.monsterGroup~=nil then
			--保证怪物在哨塔加载出来之后加载，保证怪物不会掉下去。
			for i,v in pairs(self.monsterGroup) do --设置组里每个怪物的状态
				if BehaviorFunctions.CheckEntity(v.instanceId) == true  --如果怪物存在，将怪物设在出身点处。只需要设置一次。
					and BehaviorFunctions.GetNpcType(v.instanceId)==FightEnum.EntityNpcTag.Monster
					and BehaviorFunctions.GetEntityValue(v.instanceId,"keyOpen")
					and BehaviorFunctions.GetEntityValue(v.instanceId,"keyOpen")==true
					and BehaviorFunctions.GetEntityValue(v.instanceId,"bornPosition")~=nil then
					
					local pos = BehaviorFunctions.GetEntityValue(v.instanceId,"bornPosition")
					self.bornPosition[v.instanceId] = BehaviorFunctions.GetEntityValue(v.instanceId,"bornPosition")
					BehaviorFunctions.DoSetPosition(v.instanceId, pos.x, pos.y, pos.z)
					BehaviorFunctions.SetEntityValue(v.instanceId,"keyOpen",false)
				end
			end
			
			
			
			
			
			
			local k=0
			for n,m in pairs(self.monsterGroup) do
				if BehaviorFunctions.CheckEntity(m.instanceId)==true
					and  BehaviorFunctions.GetEntityTemplateId(m.instanceId)==9030208 then
					k=k+1
				end
			end

			if k==0  then   --临时管理器不存在,
				BehaviorFunctions.PlayAnimation(self.me,"RuinStand2")
				if self.magicKey==true then
					BehaviorFunctions.AddBuff(self.me,self.me,203020801)
					self.magicKey=false
				end
			elseif k~=0 then --临时管理器存在
				BehaviorFunctions.PlayAnimation(self.me,"RuinStand1")
			    self.Effect = BehaviorFunctions.CreateEntity(203020803,self.me)  --呼吸特效
				if BehaviorFunctions.HasBuffKind(self.me,203020801) then
					BehaviorFunctions.RemoveBuff(self.me,203020801)
				end
				
				self.mission=2
			end
			
		end

	end
	


	if self.mission==3
		and self.fightFrame>=self.myFrame+78 then
		BehaviorFunctions.PlayAnimation(self.me,"RuinStand2")
		BehaviorFunctions.AddBuff(self.me,self.me,203020801)
		self.mission=4

	end


end


function Behavior2030208:PartHit(instanceId,partName,life,damage)
	if self.mission==2
		and instanceId == self.me
		and partName=="flower" then
		self.myFrame=self.fightFrame
		BehaviorFunctions.CreateEntity(203020801,self.me)
		BehaviorFunctions.CreateEntity(203020802,self.me)
		BehaviorFunctions.PlayAnimation(self.me,"FallDown")
		BehaviorFunctions.SetEntityValue(self.me,"death",true)
		BehaviorFunctions.RemoveEntity(self.Effect)
		self.mission=3
		
	end
end

function Behavior2030208:RemoveEntity(instanceId)
	if instanceId == self.me then
		if self.Effect and BehaviorFunctions.CheckEntity(self.Effect) then
			BehaviorFunctions.RemoveEntity(self.Effect)
		end
	end
end

--function BehaviorBase:PartDestroy(instanceId,partName)
	--if self.mission==0 then
		--if instanceId == self.me then
			--BehaviorFunctions.PlayAnimation(self.me,"FallDown")
			--self.mission=1
			--self.myFrame=self.fightFrame
		--end
	--end
--end
