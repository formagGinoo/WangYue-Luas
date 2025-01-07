Terrain = BaseClass("Terrain")

local BitCount = 62
local moveHeightDiff = 0.5

function Terrain:__init()
end

function Terrain:Init(terrain)
	self.terrain = Config[terrain]
	if not self.terrain then
		return
	end
	local xBitCount = self.terrain.Size.x / self.terrain.CellSize
	self.xCount = xBitCount % BitCount > 0 and math.floor(xBitCount / BitCount) + 1 or math.floor(xBitCount / BitCount)
	self.cellSize = self.terrain.CellSize
	self.cellHeight = self.terrain.CellHeight
	self.fix = 0.001 --修正
	self.wallInfos = {}
	for k, v in pairs(self.terrain.WallInfos) do
		self.wallInfos[k] = {
			enable = v & (2 ^ 0) > 0,
			penetrable = v & (2 ^ 1) > 0
		}
	end
end

function Terrain:SetFight(fight)
	self.fight = fight
end

function Terrain:CheckTerrainY(curPos)
	local to = curPos - self.terrain.Center
	if self:CheckBorder(to) then
		return 0
	end

	local yIndex = self:GetHeightIndex(to.y)
	local planIndex = self:GetPlan(to.x,to.z)
	local bitIndex = BitCount - math.ceil(to.x / self.cellSize % BitCount) +1
	local yOffset, isFind = self:GetHeight(yIndex,planIndex,bitIndex)
	return (yOffset + yIndex) * self.cellHeight, isFind
end

-- 根据身高检测Y轴是否有地形格子
function Terrain:CheckTerrainHeight(curPos, entity)
	local to = curPos - self.terrain.Center
	if self:CheckBorder(to) then
		return -1
	end

	local yIndex = self:GetHeightIndex(to.y)
	local heightIndex = math.ceil(entity.collistionComponent.height / self.cellHeight)
	local planIndex = self:GetPlan(to.x, to.z)
	local bitIndex = BitCount - math.ceil(to.x / self.cellSize % BitCount) + 1
	for i = 0, heightIndex do
		if self.terrain.TerrainInfo[yIndex - i] and self.terrain.TerrainInfo[yIndex - i][planIndex] then
			local long = self.terrain.TerrainInfo[yIndex - i][planIndex]
			local val = long & 1 << bitIndex
			if val > 0 then
				return i
			end
		end
	end

	return -1
end

-- 检测当个点当前是否有格子
function Terrain:CheckTerrainYAtOne(curPos)
	local to = curPos - self.terrain.Center
	if self:CheckBorder(to) then
		return false
	end

	local yIndex = self:GetHeightIndex(to.y)
	local planIndex = self:GetPlan(to.x,to.z)
	local bitIndex = BitCount - math.ceil(to.x / self.cellSize % BitCount) + 1
	
	if self.terrain.TerrainInfo[yIndex] and self.terrain.TerrainInfo[yIndex][planIndex] then
		local long = self.terrain.TerrainInfo[yIndex][planIndex]
		local val = long & 1 << bitIndex--MathBit.getValByPos(long,bitIndex)
		if val > 0 then
			return true
		end
	end

	return false
end

function Terrain:CheckTerrain(postion,toPostion,penetrable,entity,autoDown)
	if not self.terrain then
		return toPostion - postion
	end
	
	local pos = postion - self.terrain.Center
	local to = toPostion - self.terrain.Center
	local penetrable = penetrable or false
	if self:CheckBorder(to) then
		return pos - pos
	end
	local offset = to - pos
	if offset.x == 0 and offset.y == 0 and offset.z == 0 then
		return pos - pos
	end

	local jumpHeight = math.floor(entity.transformComponent.jumpHeight / self.cellHeight)
	local canMove, posYOffset, toYOffset  = self:CheckHeight(pos, to, entity)
	if not canMove then
		if posYOffset + jumpHeight >= toYOffset then
		elseif self:CheckHeight(pos, Vec3.New(pos.x, to.y, to.z), entity) then
			return Vec3.New(pos.x, to.y, to.z) - pos
		elseif self:CheckHeight(pos, Vec3.New(to.x, to.y, pos.z), entity) then
			return Vec3.New(to.x, to.y, pos.z) - pos
		else 
			return pos - pos
		end
	end
	
	local yIndex = self:GetHeightIndex(to.y)
	--local planIndex = self:GetPlan(to.x,to.z)
	--local bitIndex = BitCount - math.ceil(to.x / self.cellSize % BitCount) +1
	--local yOffset = self:GetHeight(yIndex,planIndex,bitIndex)
	--if yOffset >= 3 or yOffset <= -3 then --目标位置落差大于等于三个格子不能走
		--return pos - pos
	--end
	--local y = (yOffset + yIndex) * self.cellHeight - self.fix
	--offset.y = y - pos.y
	
	local obstruct, checkX, checkZ = self:CheckObstacleByCellSize(yIndex, pos, to, penetrable)
	if obstruct then
		offset.z = checkZ - pos.z
		offset.x = checkX - pos.x
		if self:CheckObstacle(yIndex, pos.x,checkZ, penetrable) then
			local zCount = math.floor(checkZ / self.cellSize)
			local lastZCount = math.floor(pos.z / self.cellSize)
			
			self:ShowAirWallEffect(entity, 1, zCount - lastZCount, checkX, checkZ, postion.y + toYOffset)
			
			if offset.z > 0 then
				local offsetZ = zCount * self.cellSize - pos.z - self.fix
				offset.z = math.min(offset.z,offsetZ)
			else
				local offsetZ = zCount * self.cellSize - pos.z + self.cellSize + self.fix
				offset.z = math.max(offset.z,offsetZ)
			end
		end
		if self:CheckObstacle(yIndex, checkX, pos.z, penetrable) then
			local xCount = math.floor(checkX / self.cellSize)
			local lastXCount = math.floor(pos.x / self.cellSize)
			
			self:ShowAirWallEffect(entity, 2, xCount - lastXCount, checkX, checkZ, postion.y + toYOffset)
			
			if offset.x > 0 then
				local offsetX = xCount * self.cellSize - pos.x - self.fix
				offset.x = math.min(offset.x,offsetX)
			else
				local offsetX = xCount * self.cellSize - pos.x + self.cellSize + self.fix
				offset.x = math.max(offset.x,offsetX)
			end
		end
		return offset
	end
	
	
	return offset
end

function Terrain:ShowAirWallEffect(entity, dirType, dirOffset, checkX, checkZ, height)
	if Fight.Instance.playerManager:GetPlayer():GetCtrlEntity() ~= entity.instanceId then
		return 
	end
	
	if self.effectId and self.fight.entityManager:GetEntity(self.effectId) then
		return 
	end
	
	local stateComp = entity.stateComponent
	if stateComp and stateComp:GetState() ~= FightEnum.EntityState.Move and stateComp:GetState() ~= FightEnum.EntityState.Skill then
		return
	end
	
	local offsetY = 1.3
	local axisOffset = dirOffset > 0 and self.cellSize or -self.cellSize
	
	local x, y, z = 0, height + offsetY, 0
	local rotateY = 0
	
	-- z轴方向
	if dirType == 1 then
		rotateY = dirOffset > 0 and 0 or 180
		x = checkX + self.terrain.Center.x
		z = checkZ + self.terrain.Center.z + axisOffset
	-- x轴方向
	elseif dirType == 2 then
		rotateY = dirOffset > 0 and 90 or -90
		x = checkX + self.terrain.Center.x + axisOffset
		z = checkZ + self.terrain.Center.z
	end
	
	self.effectId = BehaviorFunctions.CreateEntity(200000104,nil,x,y,z)
	local entity = self.fight.entityManager:GetEntity(self.effectId)
	entity.rotateComponent:SetRotation(Quat.Euler(0,rotateY,0))
end

function Terrain:GetHeightDiff(pos, to)
	local toYIndex = self:GetHeightIndex(to.y)
	local toPlanIndex = self:GetPlan(to.x,to.z)
	local toBitIndex = BitCount - math.ceil(to.x / self.cellSize % BitCount) +1
	
	local posYIndex = self:GetHeightIndex(pos.y)
	local posPlanIndex = self:GetPlan(pos.x,pos.z)
	local posBitIndex = BitCount - math.ceil(pos.x / self.cellSize % BitCount) +1
	return self:GetHeight(posYIndex, posPlanIndex, posBitIndex), self:GetHeight(toYIndex, toPlanIndex, toBitIndex)
end

function Terrain:CheckHeight(pos, to, entity)
	local height = moveHeightDiff / self.cellHeight
	local posYOffset, toYOffset = self:GetHeightDiff(pos, to)
	if posYOffset - toYOffset >= height or posYOffset - toYOffset <= -height then
		return false, posYOffset, toYOffset
	end
	return true, posYOffset, toYOffset
end

function Terrain:CheckObstacleByCellSize(yIndex, pos, to, penetrable)
	local offset = to - pos
	local dis = Vec3.Distance(to, pos)
	for i = self.cellSize, dis, self.cellSize do
		local stepPos = i / dis * offset + pos
		if self:CheckObstacle(yIndex, stepPos.x, stepPos.z, penetrable) then
			return true, stepPos.x, stepPos.z
		end
	end
	return self:CheckObstacle(yIndex, to.x,to.z,penetrable), to.x, to.z
end

function Terrain:CheckObstacleBetweenPos(startPos1, targetPos1, penetrable)
	local startPos = startPos1 - self.terrain.Center
	local targetPos = targetPos1 - self.terrain.Center
	local yIndex = self:GetHeightIndex(targetPos.y)
	yIndex = yIndex + 4
    local dir = (targetPos - startPos).normalized
	local dis = math.floor(Vec3.Distance(startPos,targetPos))
	--local num = math.floor(tonumber(dis * 2))
	if dis > 1.5 and not self:CheckObstacle(yIndex, targetPos.x, targetPos.y, penetrable) then
		for i = 1.5, dis - 0.5, 0.5 do
			local pos = startPos + dir * i
			if self:CheckObstacle(yIndex,pos.x,pos.z,penetrable) then
				return true, i
			end
		end
	end

	return false, dis
end

function Terrain:CheckObstacle(yIndex,x,z,penetrable)
	local bitIndex = BitCount - math.ceil(x / self.cellSize % BitCount) +1
	local planIndex = self:GetPlan(x,z)
	for k, wall in pairs(self.terrain.WallInfo) do
		if self.wallInfos[k] and self.wallInfos[k].enable and (not self.wallInfos[k].penetrable or not penetrable) then
			for yIndexOffset = 4, -1,-1 do--检测目标点四个各种高度的墙
				if wall[yIndex+yIndexOffset] and wall[yIndex+yIndexOffset][planIndex] then
					local long = wall[yIndex+yIndexOffset][planIndex]
					local val1 = long & 1
					local val = long & 1 << bitIndex--MathBit.getValByPos(long,bitIndex)
					--if long == 576460752303423488 then
					--	val = 1--%^*(%$$&(&*)^&)%)%&(^)%^$%#*^&*() 系统级的bug
					--end
					if val > 0 then
						return true
					end
				end
			end
		end
	end
	return false
end

function Terrain:CheckObstacleDebug(yIndex,x,z)
	local bitIndex = BitCount - math.ceil(x / self.cellSize % BitCount) +1
	local planIndex = self:GetPlan(x,z)
	for k, wall in pairs(self.terrain.WallInfo) do
		if self.terrain.WallInfos[k] then
			if wall[yIndex] and wall[yIndex][planIndex] then
				local long = wall[yIndex][planIndex]
				local val = long & 1 << bitIndex--MathBit.getValByPos(long,bitIndex)
				--if long == 576460752303423488 then
				--	val = 1--%^*(%$$&(&*)^&)%)%&(^)%^$%#*^&*() 系统级的bug
				--end
				if val > 0 then
					return true
				end
			end
		end
	end
	return false
end

function Terrain:CheckBorder(to)
	return to.x <= 0 or to.y < 0 or to.z <= 0
	or to.x >= self.terrain.Size.x
	or to.y >= self.terrain.Size.y
	or to.z >= self.terrain.Size.z
end


function Terrain:GetInArea(area,position)
	if not self.terrain.AreaInfo[area] then
		return false
	end
	local pos = position - self.terrain.Center
	local yIndex = self:GetHeightIndex(pos.y)
	local planIndex = self:GetPlan(pos.x,pos.z)
	for i = 3, -3,-1 do--区域检测有上下浮动
		if not self.terrain.AreaInfo[area][yIndex+i] then
			return false
		end
		if not self.terrain.AreaInfo[area][yIndex+i][planIndex] then
			return false
		end
		local long = self.terrain.AreaInfo[area][yIndex+i][planIndex]
		local bitIndex = BitCount - math.ceil(pos.x / self.cellSize % BitCount)
		local val = long & 1 << bitIndex --MathBit.getValByPos(long,bitIndex)
		if val > 0 then
			return true
		end
	end
	return false
end

function Terrain:SetWallEnable(wall,enable)
	if self.wallInfos[wall] then
		self.wallInfos[wall].enable = enable
	end
end

function Terrain:GetPosition(name)
	if not self.terrain then
		return Vec3.New(0,0,0)
	end
	local terrainPos = self.terrain.Positions[name]
	if not terrainPos then
		LogError("找不到点："..name)
	end

	local pos = Vec3.New(terrainPos.x, terrainPos.y, terrainPos.z)
	return pos
end

function Terrain:GetPlan(x,z)
	local zCount = math.floor(z / self.cellSize)
	local xCount = math.ceil(x / self.cellSize / BitCount)
	xCount = xCount == 0 and 1 or xCount
	local index = self.xCount * zCount + xCount
	return index
end

function Terrain:GetHeightIndex(y)
	if y == 0 then
		return 1
	end
	return math.ceil(y / self.cellHeight)
end

function Terrain:GetHeight(yIndex, planIndex, bitIndex)
	for i = 10, -4,-1 do
		if self.terrain.TerrainInfo[yIndex + i] and self.terrain.TerrainInfo[yIndex + i][planIndex] then
			local long = self.terrain.TerrainInfo[yIndex + i][planIndex]
			local val = long & 1 << bitIndex--MathBit.getValByPos(long,bitIndex)
			if val > 0 then
				return i, true
			end
		end
	end

	return 0, false
end

function Terrain:__delete()

end