Behavior2041107 = BaseClass("Behavior2041107",EntityBehaviorBase) --在怪物身上使用CheckEcoEntityGroup,来决定是否要调用这个函数。
--资源预加载
function Behavior2041107.GetGenerates()
	local generates = {}
	return generates
end

function Behavior2041107:Init()
	self.LinelevelID = 405020201

	self.levelAddDistance = 3
    self.missionUnloadDis = 25             --卸载距离
	self.transPos = "Pos1"
	self.mapId = 10020005
	self.logicName = "ElectricWire"
	self.levelAdd = false
end

function Behavior2041107:Update()
    self.role = BehaviorFunctions.GetCtrlEntity()
    if self.playerPos == nil then
		self.playerPos = BehaviorFunctions.GetPositionP(self.role)										--获取玩家的坐标
	end
	self.missionStartPos = BehaviorFunctions.GetTerrainPositionP(self.transPos, self.mapId, self.logicName)
	self.missionDistance = BehaviorFunctions.GetDistanceFromPos(self.playerPos,self.missionStartPos)		--获取玩家和肉鸽的距离
	--距离近就加载关卡
	if self.missionDistance <= self.levelAddDistance and self.levelAdd == false then
		BehaviorFunctions.AddLevel(self.LinelevelID)
		self.levelAdd = true
	end
	if self.missionDistance >= self.missionUnloadDis then
		self.levelAdd = false
	end
end