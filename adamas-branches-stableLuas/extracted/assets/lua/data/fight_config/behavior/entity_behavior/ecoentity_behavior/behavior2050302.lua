Behavior2050302 = BaseClass("Behavior2050302",EntityBehaviorBase) --在怪物身上使用CheckEcoEntityGroup,来决定是否要调用这个函数。
--花遗迹
function Behavior2050302.GetGenerates()
	local generates = {}
	return generates
end

function Behavior2050302:Init()
	self.me = self.instanceId
	self.mission=0
	self.bornPosition={}
	self.warnKey=true
	self.warnOthers= false
	self.p = {}
	self.positionList={}
	self.positionList2={}
	self.moveKey=false
	
end

function Behavior2050302:Update()
	self.role=BehaviorFunctions.GetCtrlEntity()
	if BehaviorFunctions.GetEcoEntityGroup(nil,nil,self.me) then
		self.monsterGroup=BehaviorFunctions.GetEcoEntityGroup(nil,nil,self.me) --每帧都需要修改自己的组内成员
	end

	--以下是群组散步逻辑
	if self.monsterGroup~=nil then
		--if self.monsterGroup==1 then






		--巡逻逻辑
		for n,m in pairs(self.monsterGroup) do
			if BehaviorFunctions.CheckEntity(m.instanceId)==true then
				--台上近战怪物
				--for k,y in pairs(self.monsterGroup) do

				--end
				--end

				--台上和箭台上的远程怪物，站定射击
				if BehaviorFunctions.GetEntityTemplateId(m.instanceId)==900051 then 	--给弓小怪传值。
					local x= BehaviorFunctions.GetPositionP(m.instanceId)
					local y= BehaviorFunctions.GetPositionP(self.role)
					if x.y>62 --怪物在台子上
						and y.y<62 then  --角色在台子下
						BehaviorFunctions.SetEntityValue(m.instanceId,"congshigongmove",false)
					else
						BehaviorFunctions.SetEntityValue(m.instanceId,"congshigongmove",true) --将值传过去。
					end
				end
				if BehaviorFunctions.GetEntityTemplateId(m.instanceId)==900050 then 	--给弓小怪传值。
						BehaviorFunctions.SetEntityValue(m.instanceId,"congshigongmove",true) --将值传过去。
				end
				
				
				
				
				--巡逻怪物
				if BehaviorFunctions.GetEntityTemplateId(m.instanceId)==900030 then 	--给盾小怪传值。
					BehaviorFunctions.SetEntityValue(m.instanceId,"peaceState",2)
					BehaviorFunctions.SetEntityValue(m.instanceId,"actPerformance","Sit")

				end
			end
		end


	end
	self:WarnState() --接收信息开
	self:WarnAccept() --接收信息关闭，发送信息开
	self:WarnTogether() --发出警告，发出警告之后关闭

end



function Behavior2050302:WarnState()
	--比较担心执行顺序的影响。
	if self.warnKey==false then
		local m=0
		local x=0
		--判断组内存活怪物数量
		for k,y in pairs(self.monsterGroup) do
			if BehaviorFunctions.CheckEntity(y.instanceId)
				and BehaviorFunctions.GetNpcType(y.instanceId)==FightEnum.EntityNpcTag.Monster then 
				m=m+1
				if BehaviorFunctions.GetEntityValue(y.instanceId,"warnState")==false then
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
function Behavior2050302:WarnAccept()
	if self.warnKey ==true and self.monsterGroup then
		for i,v in pairs(self.monsterGroup) do
			if BehaviorFunctions.CheckEntity(v.instanceId)==true  --检查实体是否存在
				and BehaviorFunctions.GetEntityValue(v.instanceId,"warnOthers")~=nil  --检查是否有收到警告他人的信号
				and BehaviorFunctions.GetEntityValue(v.instanceId,"warnOthers")==true then --检查警告他人的信号传递的值是否是true
				self.warnKey=false  --中继器在得知有人被警告时，立刻关闭，不再接受消息。
				self.warnOthers= true --传值出去。
				BehaviorFunctions.SetEntityValue(v.instanceId,"warnOthers",nil)
			end

		end
	end
end





function Behavior2050302:WarnTogether()
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


--function Behavior900042:DeathEnter(instanceId,isFormationRevive)
	--if BehaviorFunctions.GetEntityTemplateId(instanceId)==900051 then
		--BehaviorFunctions.DoMagic(instanceId,instanceId,900000008)
	--end
--end