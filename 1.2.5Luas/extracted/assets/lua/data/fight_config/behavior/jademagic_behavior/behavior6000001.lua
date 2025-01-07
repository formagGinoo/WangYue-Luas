Behavior6000001 = BaseClass("Behavior6000001",EntityBehaviorBase)

local BF = BehaviorFunctions

function Behavior6000001.GetGenerates()
end

function Behavior6000001.GetMagics()
end


function Behavior6000001:Init()
	self.me = self.instanceId 	--记录自己
	self.hpCurrentRatio = 0 	--记录当前生命万分比
	self.hpRatioLow = 2500      --触发报复的最低生命值（目前是生命值低于25%）
	self.hpRatioMedium = 5000   --触发报复的中等生命值（目前是生命值低于50%）
	self.hpRatioHigh = 7500     --触发报复的最高生命值（目前是生命值低于75%）
end


function Behavior6000001:Update()
	if BF.CheckEntity(self.me) then
		
		--记录当前生命值万分比判断
		self.hpCurrentRatio = BF.GetEntityAttrValueRatio(self.me,1001)
		
		--判断并添加血量低于25%的报复1buff
		if self.hpCurrentRatio < self.hpRatioLow then
			BF.AddBuff(self.me,self.me,6000002,1) --25%血量BUFF
			--存在50%血量BUFF判断
			if BF.HasBuffKind(self.me,6000003) then
				BF.RemoveBuff(self.me,6000003)
			end
			--存在75%血量BUFF判断
			if BF.HasBuffKind(self.me,6000004) then
				BF.RemoveBuff(self.me,6000004)
			end

		--判断并添加血量低于50%的报复2buff
		elseif self.hpCurrentRatio < self.hpRatioMedium then
			BF.AddBuff(self.me,self.me,6000003,1) --50%血量BUFF
			--存在25%血量BUFF判断
			if BF.HasBuffKind(self.me,6000002) then
				BF.RemoveBuff(self.me,6000002)
			end
			--存在75%血量BUFF判断
			if BF.HasBuffKind(self.me,6000004) then
				BF.RemoveBuff(self.me,6000004)
			end

		--判断并添加血量低于75%的报复3buff
		elseif self.hpCurrentRatio < self.hpRatioHigh then
			BF.AddBuff(self.me,self.me,6000004,1) --75%血量BUFF
			--存在25%血量BUFF判断
			if BF.HasBuffKind(self.me,6000002) then
				BF.RemoveBuff(self.me,6000002)
			end
			--存在50%血量BUFF判断
			if BF.HasBuffKind(self.me,6000003) then
				BF.RemoveBuff(self.me,6000003)
			end
		--在75%血量以上时，所有血量BUFF检测判断
		else
			if BF.HasBuffKind(self.me,6000002) then
				BF.RemoveBuff(self.me,6000002)
			end
			if BF.HasBuffKind(self.me,6000003) then
				BF.RemoveBuff(self.me,6000003)
			end
			if BF.HasBuffKind(self.me,6000004) then
				BF.RemoveBuff(self.me,6000004)
			end
		end
	end
end

----移除BUFF回调
--function Behavior6000001:RemoveBuff(entityInstanceId, buffInstanceId,buffId)
	--if buffInstanceId == self.me and buffId == 6000001 and BF.CheckEntity(self.me) then
		--if BF.HasBuffKind(self.me,6000002) then
			--BF.RemoveBuff(self.me,6000002)
		--end
		--if BF.HasBuffKind(self.me,6000003) then
			--BF.RemoveBuff(self.me,6000003)
		--end
		--if BF.HasBuffKind(self.me,6000004) then
			--BF.RemoveBuff(self.me,6000004)
		--end
	--end
--end