LevelBehavior10020007 = BaseClass("LevelBehavior10020007",LevelBehaviorBase)
--拯救于静
function LevelBehavior10020007:__init(fight)
	self.fight = fight
end


function LevelBehavior10020007.GetGenerates()
	local generates = {900040}
	return generates
end
--mgaic预加载
function LevelBehavior10020007.GetMagics()
	local generates = {201001411,900000003}
	return generates
end

function LevelBehavior10020007:Init()
	self.role = 1
	self.missionState = 0
	self.starttime = BehaviorFunctions.GetFightFrame()/30--世界时间
	self.lasttime = 35--倒计时时间
	self.ecoentity = BehaviorFunctions.GetEcoEntityByEcoId(20001)--获取挑战关卡的生态id
end

function LevelBehavior10020007:Update()
	self.time = BehaviorFunctions.GetFightFrame()/30--世界时间
	self.player = BehaviorFunctions.GetCtrlEntity()--获取玩家
	if self.missionState == 0 then--初始招怪
		BehaviorFunctions.ShowCommonTitle(4,"限时杀怪",true) --提示挑战开始
		BehaviorFunctions.DoMagic(self.player,self.player,201001411)--测试buff
		local pos1 = BehaviorFunctions.GetTerrainPositionP("M1",10020001,"Logic10020001_tiaozhan")
		local pos2 = BehaviorFunctions.GetTerrainPositionP("M2",10020001,"Logic10020001_tiaozhan")
		local pos3 = BehaviorFunctions.GetTerrainPositionP("M3",10020001,"Logic10020001_tiaozhan")
		local pos4 = BehaviorFunctions.GetTerrainPositionP("M4",10020001,"Logic10020001_tiaozhan")
		self.monster1 = BehaviorFunctions.CreateEntity(900040,nil,pos1.x,pos1.y,pos1.z)
		self.monster2 = BehaviorFunctions.CreateEntity(900040,nil,pos2.x,pos2.y,pos2.z)
		self.monster3 = BehaviorFunctions.CreateEntity(900040,nil,pos3.x,pos3.y,pos3.z)
		self.timeStart = self.time--记录时间点
		BehaviorFunctions.CreateEntity(20012)
		self.missionState = 1--已经召唤完怪物
	end
	if self.missionState == 1 and self.lasttime > 0 and self.time - self.timeStart >= 1 then
		self.lasttime = self.lasttime - 1--更新剩余时间
		BehaviorFunctions.ShowTip(3001005,self.lasttime)--更新提示
		self.timeStart = self.time--更新当前时间
	elseif self.missionState == 1 and self.lasttime == 0  then--倒计时归零
		self.missionState = 999--结束关卡
		BehaviorFunctions.ShowCommonTitle(5,"限时杀怪",false) --提示挑战失败
		BehaviorFunctions.RemoveEntity(self.monster1)--移除怪物
		BehaviorFunctions.RemoveEntity(self.monster2)--移除怪物
		BehaviorFunctions.RemoveEntity(self.monster3)--移除怪物
		BehaviorFunctions.RemoveLevel(10020007)
		BehaviorFunctions.SetEntityValue(self.ecoentity,"chal_state",2)--传值失败
	elseif self.missionState == 1 and BehaviorFunctions.GetDistanceFromTarget(self.player,self.ecoentity)>25 then--距离太远
		self.missionState = 999--结束关卡
		BehaviorFunctions.ShowTip(2002002) --提示距离过远挑战失败
		BehaviorFunctions.RemoveEntity(self.monster1)--移除怪物
		BehaviorFunctions.RemoveEntity(self.monster2)--移除怪物
		BehaviorFunctions.RemoveEntity(self.monster3)--移除怪物
		BehaviorFunctions.RemoveLevel(10020007)
		BehaviorFunctions.SetEntityValue(self.ecoentity,"chal_state",2)--传值失败	
	end
	if self.missionState == 1 and self.monsterdie1 and self.monsterdie2 and self.monsterdie3 then
		self.missionState = 30--击杀成功
	end
	if self.missionState == 30 then
		BehaviorFunctions.ShowCommonTitle(5,"限时杀怪",true) --提示挑战完成
		BehaviorFunctions.RemoveLevel(10020007)
		BehaviorFunctions.SetEntityValue(self.ecoentity,"chal_state",1)--传值成功
		self.missionState = 999--结束关卡
	end
end
function LevelBehavior10020007:RemoveEntity(instanceId)
	if instanceId == self.monster1 and self.missionState == 1 then--在倒计时内
		self.monsterdie1 = true
	elseif instanceId == self.monster2 and self.missionState == 1 then--在倒计时内
		self.monsterdie2 = true
	elseif instanceId == self.monster3 and self.missionState == 1 then--在倒计时内
		self.monsterdie3 = true
	end
end

function LevelBehavior10020007:__delete()

end
