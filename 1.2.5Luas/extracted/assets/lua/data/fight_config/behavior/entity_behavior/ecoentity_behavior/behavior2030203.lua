Behavior2030203 = BaseClass("Behavior2030203",EntityBehaviorBase) --在怪物身上使用CheckEcoEntityGroup,来决定是否要调用这个函数。
--资源预加载
function Behavior2030203.GetGenerates()
	local generates = {}
	return generates
end

function Behavior2030203:Init()
	self.me = self.instanceId
	self.mission=0
	self.bornPosition={}
	self.warnKey=true
	self.warnOthers= false
	self.treasureBoxList={2010101,2010102,2010103,2010104}
	self.mission=0
	self.treasureBox=0 --给一个初始化id

end

function Behavior2030203:Update()

	self.monsterGroup=BehaviorFunctions.GetEcoEntityGroup(nil,nil,self.me) --怪物跑逻辑的时候就会知道自己的组员（如果有）。
	if self.monsterGroup~=nil then
		for i,v in pairs(self.monsterGroup) do
			if  BehaviorFunctions.CheckEntity(v.instanceId) == true
				and (BehaviorFunctions.GetEntityTemplateId(v.instanceId)==2010101
				or BehaviorFunctions.GetEntityTemplateId(v.instanceId)==2010102
				or BehaviorFunctions.GetEntityTemplateId(v.instanceId)==2010103
				or BehaviorFunctions.GetEntityTemplateId(v.instanceId)==2010104) then
				self.treasureBox = v.instanceId --取宝箱的id

			end
		end
	end



	--以下是群组散步逻辑
	if self.monsterGroup~=nil then
		

				
		for i,v in pairs(self.monsterGroup) do --遍历monsterGroup中所有实例id,查找实例id对应的状态。需要知道这个实例是否存活吗？
			if BehaviorFunctions.CheckEntity(v.instanceId)==true then --检查实体是否存在

				if BehaviorFunctions.GetEntityTemplateId(v.instanceId)==900030 then 	--给盾小怪传值。目前感觉不需要额外逻辑。盾小怪走路线1
					self.p1=BehaviorFunctions.GetTerrainPositionP("p1",10020001,"Logic10020001_shaota1") --逻辑取点要遵循一套通用逻辑。暂时还没考虑，先这样写着。应该是可以批量创建的，想想办法。
					self.p2=BehaviorFunctions.GetTerrainPositionP("p2",10020001,"Logic10020001_shaota1")
					self.p3=BehaviorFunctions.GetTerrainPositionP("p3",10020001,"Logic10020001_shaota1")
					self.p4=BehaviorFunctions.GetTerrainPositionP("p4",10020001,"Logic10020001_shaota1")
					self.positionList={self.p1,self.p2,self.p3,self.p4} --寻路1
					BehaviorFunctions.SetEntityValue(v.instanceId,"paceState",1) --将巡逻状态的改变传给对应的怪物


					BehaviorFunctions.SetEntityValue(v.instanceId,"patrolPositionList",self.positionList) --将巡逻点位传给对应怪物
					BehaviorFunctions.SetEntityValue(v.instanceId,"canReturn",true) --将巡逻点位传给对应怪物
				end

				if BehaviorFunctions.GetEntityTemplateId(v.instanceId)==900040 then 	--给棍小怪传值。按照传入的点进行巡逻。可能找玩家需要额外的寻路逻辑。棍小怪走路线二。有个问题是，当前只能布置1个怪物。如果布多只会抢道。
					self.p5=BehaviorFunctions.GetTerrainPositionP("p5",10020001,"Logic10020001_shaota1")
					self.p6=BehaviorFunctions.GetTerrainPositionP("p6",10020001,"Logic10020001_shaota1")
					self.p7=BehaviorFunctions.GetTerrainPositionP("p7",10020001,"Logic10020001_shaota1")
					self.p8=BehaviorFunctions.GetTerrainPositionP("p8",10020001,"Logic10020001_shaota1")
					self.positionList2={self.p5,self.p6,self.p7,self.p8} --寻路2
					BehaviorFunctions.SetEntityValue(v.instanceId,"paceState",1) --将巡逻状态的改变传给对应的怪物
					--这里直接把peaceState改了，因为已经指定了生态id，这里属于定向传值
					BehaviorFunctions.SetEntityValue(v.instanceId,"patrolPositionList",self.positionList2) --将巡逻点位传给对应怪物
					BehaviorFunctions.SetEntityValue(v.instanceId,"canReturn",true) --将巡逻点位传给对应怪物


				end
				if BehaviorFunctions.GetEntityTemplateId(v.instanceId)==900051 then 	--给弓小怪传值。
					BehaviorFunctions.SetEntityValue(v.instanceId,"congshigongmove",true) --将值传过去，修改弓小怪的行为逻辑：朝玩家走，直到边缘停下，随后静止不动。直接在怪身上写两套逻辑。
				end
			end
		end

	end

	----以下是共同进战逻辑
	--self:WarnState() --接收信息开
	self:WarnAccept() --接收信息关闭，发送信息开
	self:WarnTogether() --发出警告，发出警告之后关闭

	
	
end


function Behavior2030203:WarnState()
	--比较担心执行顺序的影响。
	if self.warnKey==false then
		local m=0
		local x=0
		--判断组内存活怪物数量
		for k, v in pairs(self.monsterGroup) do
			if BehaviorFunctions.CheckEntity(v.instanceId)
				and BehaviorFunctions.GetNpcType(v.instanceId)==FightEnum.EntityNpcTag.Monster then
				m=m+1
				if BehaviorFunctions.GetEntityValue(v.instanceId,"warnState")==false then
					x=x+1
				end
			end
		end


		--当存活怪物数量==peace怪物数量时，中继器的警告锁打开。
		if x==m  and  m~=0  then
			self.warnKey=true
		end
	end
end


--中继器传数值的开关，一旦将数值传出，开关将关闭。直到满足“存活怪物全部脱战”的条件，才会开启。
function Behavior2030203:WarnAccept()
	for i,v in pairs(self.monsterGroup) do
		if BehaviorFunctions.CheckEntity(v.instanceId)==true  --检查实体是否存在
			and BehaviorFunctions.GetEntityValue(v.instanceId,"warnOthers")~=nil  --检查是否有收到警告他人的信号
			and BehaviorFunctions.GetEntityValue(v.instanceId,"warnOthers")==true then --检查警告他人的信号传递的值是否是true
			self.warnOthers= true --传值出去。
			BehaviorFunctions.SetEntityValue(v.instanceId,"warnOthers",nil)
		end

	end
end





function Behavior2030203:WarnTogether()
	if self.warnOthers==true then
		for n,m in pairs(self.monsterGroup) do  --当从其中一只怪身上收到警告消息时，数组中所有怪物，向怪物中传被警告的指令。
			if  BehaviorFunctions.CheckEntity(m.instanceId)==true --只警告存活的怪物
				and BehaviorFunctions.GetNpcType(m.instanceId)==FightEnum.EntityNpcTag.Monster
				and BehaviorFunctions.GetEntityValue(m.instanceId,"warnState")==false then --只警告没有被警告的怪物。
				BehaviorFunctions.SetEntityValue(m.instanceId,"monsterBeWarned",true) --将警告组内成员的消息传出
			end
		end
		self.warnOthers=false --保证只传一次值
	end

end




			
