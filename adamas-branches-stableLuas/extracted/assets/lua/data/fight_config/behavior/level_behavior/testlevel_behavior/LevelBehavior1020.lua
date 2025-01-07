LevelBehavior1020 = BaseClass("LevelBehavior1020",LevelBehaviorBase)
--fight初始化
function LevelBehavior1020:__init(fight)
	self.fight = fight
end

--预加载
function LevelBehavior1020.GetGenerates()
	local generates = {900020,900021,900022,900023,910024,910025,900010,900000105}
	return generates
end

--参数初始化
function LevelBehavior1020:Init()
	self.role = 0           --当前角色
	self.Missionstate = 0   --关卡流程
	self.wave = 0
	self.Monsters = {
		Count = 0
	}
	
	self.MonstersGroup = BehaviorFunctions.CreateBehavior("LevelMonstersGroup",self)

	self.time = 0		    --世界时间
	self.timestart = 0      --记录时间
	
	--self.numNPC = 0
	--self.typeNpc = 0
	--self.summonNum = 1
	--self.summontype = 900010
	--self.typeList = {900010,900020,900021,900022,900023,910024,910025}
	--self.interactButton = false
	
	--创建关卡通用行为树
	self.levelBeha = BehaviorFunctions.CreateBehavior("LevelBehavior",self)
end

--UI预加载
function LevelBehavior1020.GetUIGenerates()
	local generates = {
		FightEnum.PreLoadUI.RemoteDialog,--带头像的剧情对话框UI
		FightEnum.PreLoadUI.FightTalkDialog,--纯文字的剧情对话框UI
		FightEnum.PreLoadUI.GuideMask,--教学引导UI
		FightEnum.PreLoadUI.FightTips--中间横幅和底部横幅
	}
	return generates
end
	

--帧事件
function LevelBehavior1020:Update()

	--记录角色切换
	self.role = BehaviorFunctions.GetCtrlEntity()
	
	self.time = BehaviorFunctions.GetFightFrame()
	--初始化，角色出生点
	if  self.Missionstate == 0 then
		self.entites = {}   --初始化self.entites表
		local pb1 = BehaviorFunctions.GetTerrainPositionP("PB1")
		BehaviorFunctions.DoSetPosition(self.role,pb1.x,pb1.y,pb1.z)   --角色位置
		
		--local npc1 = BehaviorFunctions.GetTerrainPositionP("NPC1")
		--local npc2 = BehaviorFunctions.GetTerrainPositionP("NPC2")
		
		--self.numNPC = BehaviorFunctions.CreateEntity(81004001,nil,npc1.x,npc1.y,npc1.z)
		--self.typeNPC = BehaviorFunctions.CreateEntity(81004001,nil,npc2.x,npc2.y,npc2.z)
		
		self.timestart =BehaviorFunctions.GetFightFrame()
		

		self.Missionstate = 1
		
	end

	--关卡开始
	if self.Missionstate == 1 and self.time - self.timestart >= 90 then
		
		self.timestart = BehaviorFunctions.GetFightFrame()
		
		--local mon1 = BehaviorFunctions.CreateEntity(900020)
		--self.Monsters[mon1] = mon1
		--local mb1 = BehaviorFunctions.GetTerrainPositionP("MB1")
		--BehaviorFunctions .DoSetPosition(mon1,mb1.x,mb1.y,mb1.z)
		--self.Monsters.Count = self.Monsters.Count + 1
		
		--local mon2 = BehaviorFunctions.CreateEntity(900021)
		--self.Monsters[mon2] = mon2
		--local mb2 = BehaviorFunctions.GetTerrainPositionP("MB2")
		--BehaviorFunctions .DoSetPosition(mon2,mb2.x,mb2.y,mb2.z)
		--self.Monsters.Count = self.Monsters.Count + 1
		
		--local mon3 = BehaviorFunctions.CreateEntity(900022)
		--self.Monsters[mon3] = mon3
		--local mb3 = BehaviorFunctions.GetTerrainPositionP("MB3")
		--BehaviorFunctions .DoSetPosition(mon3,mb3.x,mb3.y,mb3.z)
		--self.Monsters.Count = self.Monsters.Count + 1
		
		--local mon4 = BehaviorFunctions.CreateEntity(900023)
		--self.Monsters[mon4] = mon4
		--local mb4 = BehaviorFunctions.GetTerrainPositionP("MB4")
		--BehaviorFunctions .DoSetPosition(mon4,mb4.x,mb4.y,mb4.z)
		--self.Monsters.Count = self.Monsters.Count + 1
		
		
		--self.MonstersGroup:MonsterGroup(self.MonstersGroup,3,mon1,mon2)
		--self.MonstersGroup:MonsterGroup(self.MonstersGroup,5,mon3,mon4)	
		
		self.Missionstate = 20
		
	end
	
	if self.Missionstate ==20 then
		local position = BehaviorFunctions.GetTerrainPositionP("MB1")
		self.inter = BehaviorFunctions.CreateEntity(900000105,nil,position.x,position.y+1,position.z)--设置交互实体		
		self.Missionstate =21
	end
	
	if self.Missionstate == 21 then
		if self.InterInstance == self.inter then
			if BehaviorFunctions.CheckKeyDown(FightEnum.KeyEvent.Common1) then
				LogError("111")
			end
		end
	end
	----战斗阶段
	--if self.Missionstate == 20  and self.Monsters.Count ~= 0 then
		--self.MonstersGroup:MonsterGroupAttack(self.MonstersGroup,3,5,1)
		--self.MonstersGroup:MonsterGroupAttack(self.MonstersGroup,5,5,1)

	--end
	
	--if self.Missionstate == 20 and self.Monsters.Count == 0 then
		
		--BehaviorFunctions.SetFightResult(true)
		--self.Missionstate = 30
	--end
		
end

--获取目前可交互npc的id
function LevelBehavior1020:EnterTrigger(triggerInstanceId,triggerEntityId,roleInstanceId)
	if triggerInstanceId then
		self.InterInstance = triggerInstanceId
		BehaviorFunctions.SetFightMainNodeVisible(2,"ButtomRight",false)	--右侧UI隐藏
		BehaviorFunctions.InteractTrigger(true,1,-550,360)					--显示交互按钮
	end
end

--离开范围时，取消所有交互ui
function LevelBehavior1020:ExitTrigger(triggerInstanceId,triggerEntityId,roleInstanceId)
	self.InterInstance = nil	
	BehaviorFunctions.SetFightMainNodeVisible(2,"ButtomRight",true)	--右侧UI显示
	BehaviorFunctions.InteractTrigger(false)							--隐藏交互按钮
end

--死亡事件
function LevelBehavior1020:Death(instanceId)
	if self.Monsters[instanceId] then
		self.Monsters[instanceId] = nil
		self.Monsters.Count = self.Monsters.Count - 1
	end
	
	if instanceId == self.role then
		BehaviorFunctions.SetFightResult(false)
	end
end


function LevelBehavior1020:__delete()

end

function LevelBehavior1020:CreatMonster(...)
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

function LevelBehavior1020:Print(index)
	LogError(index)
end