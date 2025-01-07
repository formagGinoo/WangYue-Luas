Behavior200001181 = BaseClass("Behavior200001181",EntityBehaviorBase)
function Behavior200001181.GetGenerates()
	local generates = {}
	return generates

end

function Behavior200001181.GetMagics()
	local generates = {}
	return generates
end

function Behavior200001181:Init()
	self.active = false --是否激活当前功能
	self.me = self.instanceId
	
	self.entity = nil
	
end


function Behavior200001181:LateInit()
	BehaviorFunctions.SetEntityValue(self.me,"level_200001181",1)
end

function Behavior200001181:Update()
	self.role = BehaviorFunctions.GetCtrlEntity()
	self.active = BehaviorFunctions.GetEntityValue(self.me,"active_200001181")
	self.level = BehaviorFunctions.GetEntityValue(self.me,"level_200001181")
	self.pos = BehaviorFunctions.GetPositionP(self.me)
	
	--self.active = BehaviorFunctions.GetEntityValue(self.me,"active_200001181")
	
	--if self.entity == nil then
		----self.entity = BehaviorFunctions.CreateEntity(2030530,self.me,self.pos.x,self.pos.y,self.pos.z)
		----增加“隐藏碰撞”的buff
		----if BehaviorFunctions.HasBuffKind(self.entity,600080010) then
		----else
			----BehaviorFunctions.AddBuff(self.entity,self.entity,600080010)
		----end

		------增加“防止死亡”的buff
		----if BehaviorFunctions.HasBuffKind(self.entity,600080101) then
		----else
			----BehaviorFunctions.AddBuff(self.entity,self.entity,600080101)
		----end
	--end
	
	--激活功能后，创建子弹
	if not self.me then	
	elseif self.me and self.active== true then
		
		local pos = BehaviorFunctions.GetPositionP(self.me)
		
		if self.level == 1 then
			BehaviorFunctions.CreateEntity(20031,self.me,self.pos.x,self.pos.y,self.pos.z)
			BehaviorFunctions.DoMagic(self.me,self.me,900000010)
		elseif self.level == 2 then
			BehaviorFunctions.CreateEntity(20034,self.me,self.pos.x,self.pos.y,self.pos.z)
			BehaviorFunctions.DoMagic(self.me,self.me,900000010)
		elseif self.level == 3 then
			BehaviorFunctions.CreateEntity(20035,self.me,self.pos.x,self.pos.y,self.pos.z)
			BehaviorFunctions.DoMagic(self.me,self.me,900000010)
		end
		--BehaviorFunctions.CastSkillByPosition(self.entity,203053001,self.pos.x,self.pos.y,self.pos.z)
		
		--关闭激活按钮
		BehaviorFunctions.SetEntityValue(self.me,"active_200001181",false)
		BehaviorFunctions.AddDelayCallByFrame(10,BehaviorFunctions,BehaviorFunctions.RemoveEntity,self.me)
		
	end
end

