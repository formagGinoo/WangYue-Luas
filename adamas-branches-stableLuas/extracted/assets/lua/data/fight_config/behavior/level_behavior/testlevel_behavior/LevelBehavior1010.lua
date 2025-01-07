LevelBehavior1010 = BaseClass("LevelBehavior1010",LevelBehaviorBase)
--fight初始化
function LevelBehavior1010:__init(fight)
	self.fight = fight
end

--预加载
function LevelBehavior1010.GetGenerates()
	local generates = {9001}
	return generates
end

--参数初始化
function LevelBehavior1010:Init()
	self.role = 1           --当前角色
	self.Missionstate = 0   --关卡流程
	self.Lightstate = 0     --光照流程
	self.Areastate = 0      --区域切换
	self.Monsters = {
		Count = 0
	}
	self.wave = 0           --波数计数
	self.wavelimit = 6      --波数上限
	self.time = 0		    --世界时间
	self.timestart = 0      --记录时间
	self.areatime = 0       --区域停留时间
	self.AreaRoom11 = false
	self.AreaRoom12 = false
	self.AreaRoom13 = false
	self.AreaRoom21 = false
	self.AreaRoom22 = false
	self.AreaRoom23 = false
	self.AreaStairs = false
	self.AreaEle = false
	self.room11 = 0
	self.room12 = 0
	self.room13 = 0
	self.room21 = 0
	self.room22 = 0
	self.room23 = 0
	self.ele = 0
	self.eleup = 0
end
--帧事件
function LevelBehavior1010:Update()
	--获取时间，区域
	self.time = BehaviorFunctions.GetFightFrame()
	self.AreaRoom11 = BehaviorFunctions.GetInAreaById("Room11",self.role)
	self.AreaRoom12 = BehaviorFunctions.GetInAreaById("Room12",self.role)
	self.AreaRoom13 = BehaviorFunctions.GetInAreaById("Room13",self.role)
	self.AreaRoom21 = BehaviorFunctions.GetInAreaById("Room21",self.role)
	self.AreaRoom22 = BehaviorFunctions.GetInAreaById("Room22",self.role)
	self.AreaRoom23 = BehaviorFunctions.GetInAreaById("Room23",self.role)
	self.AreaStairs = BehaviorFunctions.GetInAreaById("Stairs",self.role)
	self.AreaEle = BehaviorFunctions.GetInAreaById("Ele",self.role)
	
	BehaviorFunctions.SetWallEnable("AW1",false)
	BehaviorFunctions.SetWallEnable("AW2",false)
	BehaviorFunctions.SetWallEnable("AW3",false)

	--初始化，角色出生点
		if  self.Missionstate == 0 then
		self.entites = {}   --初始化self.entites表
	--获取地点
		local pb1 = BehaviorFunctions.GetTerrainPositionP("pb1")
		BehaviorFunctions.DoSetPosition(self.role,pb1.x,pb1.y,pb1.z)   --角色位置
		--BehaviorFunctions.DoSetPosition(self.role,135,73,100)   --角色位置
		self.timestart =BehaviorFunctions.GetFightFrame()
		self.Missionstate = 5
	end
	--第一次提示
	if self.Missionstate == 5 and self.time - self.timestart >= 90 then
		BehaviorFunctions.ShowTip(1011)
		BehaviorFunctions.SceneObjPlayAnim("elevator","elevatorup")
		self.timestart =BehaviorFunctions.GetFightFrame()
		local guide = BehaviorFunctions.GetTerrainPositionP("pb2")
		BehaviorFunctions.SetGuide(1001,guide.x,guide.y,guide.z)
		self.Missionstate =10
	end
	--光照切换
	if self.Lightstate == 0 and self.AreaRoom13 == true then
		BehaviorFunctions.ActiveSceneObj("zhu",false)
		BehaviorFunctions.ActiveSceneObj("fu",true)
		self.Lightstate = 1
	end
	if self.Lightstate == 1 and self.AreaRoom22 == true then
		BehaviorFunctions.ActiveSceneObj("zhu",true)
		BehaviorFunctions.ActiveSceneObj("fu",false)
		self.Lightstate = 10
	end
	--区域切换
	if self.Areastate == 0 then
		if self.AreaRoom11 == true then
			self.room11 = 1
		elseif self.AreaRoom12 == true then
			self.room12 = 1
		elseif self.AreaRoom13 == true then
			self.room13 = 1
		elseif self.AreaRoom21 == true then
			self.room21 = 1
		elseif self.AreaRoom22 == true then
			self.room22 = 1
		elseif self.AreaRoom23 == true then
			self.room23 = 1
		elseif self.AreaEle == true then
			self.ele = 1
		else
			return
		end
		self.areatime = BehaviorFunctions.GetFightFrame()
		self.Areastate = 1
	end
	if self.Areastate == 1 then
		if self.time - self.areatime > 30 then
			if self.room11 == 1 and  self.AreaRoom11 == true then
				self.room11 = 2
				self.Areastate = 2
				self.areatime = BehaviorFunctions.GetFightFrame()
			elseif self.room12 == 1  and self.AreaRoom12 == true then
				self.room12 = 2
				self.Areastate = 2
				self.areatime = BehaviorFunctions.GetFightFrame()
			elseif self.room13 == 1 and  self.AreaRoom13 == true then
				self.room13 = 2
				self.Areastate = 2
				self.areatime = BehaviorFunctions.GetFightFrame()
			elseif self.room21 == 1 and  self.AreaRoom21 == true then
				self.room21 = 2
				self.Areastate = 2
				self.areatime = BehaviorFunctions.GetFightFrame()
			elseif self.room22 == 1 and  self.AreaRoom22 == true then
				self.room22 = 2
				self.Areastate = 2
				self.areatime = BehaviorFunctions.GetFightFrame()
			elseif self.room23 == 1 and  self.AreaRoom23 == true then
				self.room23 = 2
				self.Areastate = 2
				self.areatime = BehaviorFunctions.GetFightFrame()
			elseif self.ele == 1 and  self.AreaEle == true then
				if  self.eleup == 0 then					
					self.timestart =BehaviorFunctions.GetFightFrame() --记录动画开始时间				
					BehaviorFunctions.UseRenderHeight(self.role,true) --上升时开启
					BehaviorFunctions.SceneObjPlayAnim("ele","Ele_up")
					BehaviorFunctions.SceneObjPlayAnim("elefloor","ele_floor_up")
					self.eleup = 1
				elseif self.time - self.timestart >= 140 and self.eleup == 1 then
					BehaviorFunctions.UseRenderHeight(self.role,false) --抵达时停止
					BehaviorFunctions.DoSetPositionOffset(self.role,0,16.2,0)
					self.eleup = 2
				end
				
				self.Areastate = 2
				self.areatime = BehaviorFunctions.GetFightFrame()
			else
				self.Areastate = 0
			end
		else
			return
		end
	end
	if self.Areastate == 2 and self.time - self.areatime > 60 then
		self.room11 = 0
		self.room12 = 0
		self.room13 = 0
		self.room21 = 0
		self.room22 = 0
		self.room23 = 0
		self.Areastate = 0
	end
	--召怪循环开始，当前波<上限,且在对应区域内则召怪，当前波=上限则触发结束流程
	if self.Missionstate == 10 and self.time - self.timestart >= 90 and self.Monsters.Count == 0 then
	  if self.wave < self.wavelimit then	
			local mb101 = BehaviorFunctions.GetTerrainPositionP("mb101")
			local mb102 = BehaviorFunctions.GetTerrainPositionP("mb102")
			local mb103 = BehaviorFunctions.GetTerrainPositionP("mb103")
			local mb201 = BehaviorFunctions.GetTerrainPositionP("mb201")
			local mb202 = BehaviorFunctions.GetTerrainPositionP("mb202")
			local mb203 = BehaviorFunctions.GetTerrainPositionP("mb203")
			local mb301 = BehaviorFunctions.GetTerrainPositionP("mb301")
			local mb302 = BehaviorFunctions.GetTerrainPositionP("mb302")
			local mb303 = BehaviorFunctions.GetTerrainPositionP("mb303")
			local mb401 = BehaviorFunctions.GetTerrainPositionP("mb401")
			local mb402 = BehaviorFunctions.GetTerrainPositionP("mb402")
			local mb403 = BehaviorFunctions.GetTerrainPositionP("mb403")
			local mb501 = BehaviorFunctions.GetTerrainPositionP("mb501")
			local mb502 = BehaviorFunctions.GetTerrainPositionP("mb502")
			local mb503 = BehaviorFunctions.GetTerrainPositionP("mb503")
			local mb601 = BehaviorFunctions.GetTerrainPositionP("mb601")
			local mb602 = BehaviorFunctions.GetTerrainPositionP("mb602")
			local mb603 = BehaviorFunctions.GetTerrainPositionP("mb603")		
		if self.wave == 0 then
				self.Monsters.Count = self:CreatMonster(
					4,
					9001,mb101.x,mb101.y,mb101.z,
					9001,mb102.x,mb102.y,mb102.z,
					9001,mb103.x,mb103.y,mb103.z,
					9002,mb303.x,mb303.y,mb303.z
				)
				self.wave = self.wave + 1
		elseif self.wave == 1 and self.room12 == 2 then
				--BehaviorFunctions.CancelGuide()
				self.Monsters.Count = self:CreatMonster(
					3,
					9001,mb201.x,mb201.y,mb201.z,
					9001,mb202.x,mb202.y,mb202.z,
					9001,mb203.x,mb203.y,mb203.z
				)
				self.wave = self.wave + 1
				BehaviorFunctions.SetWallEnable("AW1",true)
				BehaviorFunctions.SetWallEnable("AW2",true)					
		elseif self.wave == 2 and self.room13 == 2 then
				self.Monsters.Count = self:CreatMonster(
					3,
					9001,mb301.x,mb301.y,mb301.z,
					9001,mb302.x,mb302.y,mb302.z,
					9001,mb303.x,mb303.y,mb303.z
				)
				self.wave = self.wave + 1
				BehaviorFunctions.SetWallEnable("AW2",true)
				BehaviorFunctions.SetWallEnable("AW3",true)		
		elseif self.wave == 3 and self.room23 == 2 then
				self.Monsters.Count = self:CreatMonster(
					3,
					9001,mb401.x,mb401.y,mb401.z,
					9001,mb402.x,mb402.y,mb402.z,
					9001,mb403.x,mb403.y,mb403.z
				)
				self.wave = self.wave + 1
				BehaviorFunctions.SetWallEnable("AW2",true)
				BehaviorFunctions.SetWallEnable("AW3",true)
		elseif self.wave == 4 and self.room22 == 2 then
				self.Monsters.Count = self:CreatMonster(
					3,
					9001,mb501.x,mb501.y,mb501.z,
					9001,mb502.x,mb502.y,mb502.z,
					9001,mb503.x,mb503.y,mb503.z
				)
				self.wave = self.wave + 1
				BehaviorFunctions.SetWallEnable("AW1",true)
				BehaviorFunctions.SetWallEnable("AW2",true)
		elseif self.wave == 5 and self.room21 == 2 then
				self.Monsters.Count = self:CreatMonster(
					3,
					9001,mb601.x,mb601.y,mb601.z,
					9001,mb602.x,mb602.y,mb602.z,
					9001,mb603.x,mb603.y,mb603.z
				)
				self.wave = self.wave + 1
		else
			return  					
		end
	    self.Missionstate = 20
	  elseif self.wave == self.wavelimit  then
		    if self.AreaEle == true then
				self.Missionstate = 999
				BehaviorFunctions.ShowTip(1018)
--				BehaviorFunctions.SceneObjPlayAnim("elevator","elevatorup")
			end		
	  end
	end
	--清怪检测
	if self.Missionstate == 20 and self.Monsters.Count == 0 then   
	    self.timestart =BehaviorFunctions.GetFightFrame()
		if self.wave == 1 then  --房间1-1
			BehaviorFunctions.ShowTip(1012)	
			BehaviorFunctions.SetWallEnable("AW1",false)
		elseif self.wave == 2 then --房间1-2
			BehaviorFunctions.ShowTip(1013)	
			BehaviorFunctions.SetWallEnable("AW2",false)	
		elseif self.wave == 3 then --房间1-3
			BehaviorFunctions.ShowTip(1014)
			BehaviorFunctions.SetWallEnable("AW3",false)
        elseif self.wave == 4 then  --房间2-3
			BehaviorFunctions.ShowTip(1015)	
			BehaviorFunctions.SetWallEnable("AW2",false)
		elseif self.wave == 5 then --房间2-2
			BehaviorFunctions.ShowTip(1016)	
			BehaviorFunctions.SetWallEnable("AW1",false)	
		end
		self.Missionstate = 30
    end
    if self.Missionstate == 30 and self.time - self.timestart >= 30 then	    
		self.Missionstate = 10
	end

end
--死亡事件
function LevelBehavior1010:Death(instanceId)
	if self.Monsters[instanceId] then
		self.Monsters[instanceId] = nil
		self.Monsters.Count = self.Monsters.Count - 1
		if self.Monsters.Count == 0 and self.wave == 6  then
			BehaviorFunctions.ShowTip(1017)
		end
	end
end

function LevelBehavior1010:CreatMonster(...)
	--MonsterNum,Monster1Id,Monster1PosX,Monster1PosY,Monster1PosZ,Monster2Id,Monster2PosX,Monster2PosY,Monster2PosZ...
	local i = 0
	local v = 0
	local MonsterIdnPos = {}
	local MId = 2
	local MPosX = 3
	local MPosY = 4
	local MPosZ = 5
	for i,v in ipairs{...} do
		MonsterIdnPos[i] = v
	end
	for a = 1,MonsterIdnPos[1] do
		local MonsterId = BehaviorFunctions.CreateEntity(MonsterIdnPos[MId])      --召怪,返回怪物实体id
		self.Monsters[MonsterId] = MonsterId
		BehaviorFunctions.DoSetPosition(MonsterId,MonsterIdnPos[MPosX],MonsterIdnPos[MPosY],MonsterIdnPos[MPosZ])
		MId = MId + 4
		MPosX = MPosX + 4
		MPosY = MPosY + 4
		MPosZ = MPosZ + 4
		--BehaviorFunctions.DoLookAtTargetImmediately(MonsterId,1)
	end
	return MonsterIdnPos[1]
end

function LevelBehavior1010:__delete()

end