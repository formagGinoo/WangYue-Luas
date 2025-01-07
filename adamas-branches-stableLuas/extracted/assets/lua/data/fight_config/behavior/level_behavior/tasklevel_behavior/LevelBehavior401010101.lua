LevelBehavior401010101 = BaseClass("LevelBehavior401010101",LevelBehaviorBase)
--天柜城演示内容3清除城市威胁
function LevelBehavior401010101:__init(fight)
	self.fight = fight
end

function LevelBehavior401010101.GetGenerates()
	local generates = {900040,900080,8011001}
	return generates
end

--storydialog预加载
function LevelBehavior401010101.GetStorys()

	local storys = {}
	return storys
end


function LevelBehavior401010101:Init()
	self.role = nil
	self.missionState = 0
	self.hurtnpc = nil
	self.dialog = 601010701
	self.Over = false
	self.dieCount = 0
	self.allDie = false
	self.challengeSuccece = nil
	self.npcState = 0
	self.npcEntity = nil
	self.animation = false
	self.aniId =nil
	self.aniTime = 0
	self.aniFrame = 0
	self.choose = nil
	
	--怪物状态
	self.monsterStateEnum = {
		Default = 0,
		Live = 1,
		Dead = 2,
	}
	self.monsterList = {
		[1] = {state = self.monsterStateEnum.Default,bp = "mon11", Id = nil , hitTime = 0, entityId = 900080},
		[2] = {state = self.monsterStateEnum.Default,bp = "mon13", Id = nil , hitTime = 0, entityId = 900080}
		}
	
	self.coldList = {
		[1] = {state = self.monsterStateEnum.Default,bp = "mon11", Id = nil , hitTime = 0, entityId = 900080},
		[2] = {state = self.monsterStateEnum.Default,bp = "mon13", Id = nil , hitTime = 0, entityId = 900080}
	}
end

function LevelBehavior401010101:Update()
	self.role = BehaviorFunctions.GetCtrlEntity()
	self.time = BehaviorFunctions.GetFightFrame()
	-- 获取NPC实体
	if self.npcState == 0 then
		self.npcEntity = BehaviorFunctions.GetNpcEntity(8010243)

		if self.npcEntity then
			self.hurtnpc = self.npcEntity.instanceId
		end
	end	
			
	--创建怪物
	if self.missionState == 0 then
		
		for i,v in ipairs(self.monsterList) do
			if v.state == self.monsterStateEnum.Default then
				local mpos = BehaviorFunctions.GetTerrainPositionP(self.monsterList[i].bp,self.levelId,"Logic10020004_Savenpc")
				v.Id = BehaviorFunctions.CreateEntity(v.entityId,nil,mpos.x,mpos.y,mpos.z)
				v.state = self.monsterStateEnum.Live
				--看向受伤npc
				BehaviorFunctions.DoLookAtTargetImmediately(self.monsterList[i].Id,self.hurtnpc)
				--发呆buff
				BehaviorFunctions.AddBuff(self.role,self.monsterList[i].Id,900000012)
				--要先用showheadtips，并且和改变气泡内容及显隐不能在同一帧跑
				BehaviorFunctions.ShowCharacterHeadTips(self.hurtnpc,true)
				
			end
		end
		self.missionState = 1
	end
	

	if self.missionState == 1 then
		self:BigRange()
	end
	if self.missionState == 3 then
		self:SmallRange()
	end
	
	--玩家在大范围内，开始揍npc
	if self.missionState == 2 then
		
		local magicState = 0
		if magicState == 0 then
			BehaviorFunctions.DoMagic(1,self.hurtnpc,900000001) --免疫受击
			BehaviorFunctions.DoMagic(1,self.hurtnpc,900000013)--免疫锁定
			BehaviorFunctions.DoMagic(1,self.hurtnpc,900000020)--免疫受击朝向
			BehaviorFunctions.DoMagic(1,self.hurtnpc,900000022)--免疫伤害
			BehaviorFunctions.DoMagic(1,self.hurtnpc,900000023)--免疫伤害
			
			--呼救气泡
			BehaviorFunctions.ChangeNpcBubbleContent(self.hurtnpc,"救命！谁来帮帮我！",999999)
			BehaviorFunctions.SetNonNpcBubbleVisible(self.hurtnpc,true)
			
			
		end
		
		--移除发呆buff
		local time = 0
		for i,v in ipairs(self.monsterList) do
			time = 2 + time
			--BehaviorFunctions.RemoveBuff(v.Id,900000012)
			BehaviorFunctions.AddDelayCallByTime(time,BehaviorFunctions,BehaviorFunctions.RemoveBuff,v.Id,900000012)
		end
		
				
		--设置攻击目标
		self:ChangeTarget(self.monsterList)
		self.missionState = 3
		
		
		magicState = 1

	end
	
	--玩家在小范围内，开启tips
	if self.missionState == 4 then
		--tip:发现城市威胁
		BehaviorFunctions.ShowCommonTitle(7,"发现城市威胁",true)
		
		--加战斗tip（击杀个数，npc血量）
		BehaviorFunctions.ShowTip(30000010,self.dieCount)
		
		
		self.missionState = 5
	end
	
		
	
		
	--战斗关卡进行中
	if self.missionState == 5 then
		
		
		--修改tips（击杀个数，npc血量）
		BehaviorFunctions.ChangeTitleTipsDesc(30000010,self.dieCount)
		
		
		--仇恨转换
		for i,v in ipairs(self.monsterList) do
			if v.hitTime > 0 then
				if self.time - v.hitTime > 6*30 then
					BehaviorFunctions.SetEntityValue(v.Id,"battleTarget",self.hurtnpc)
					v.hitTime = 0
				end
			end
		end
		self:FirstCollide()
		----重复播开关
		--if self.animation == ture then

			--if self.time - self.aniTime > self.aniFrame and self.aniFrame ~= 0 then
				--self.aniTime = 0
				--self.animation = false

			--end
		--end
		
		----播动作
		--if self.animation == false then
			--BehaviorFunctions.PlayAnimation(self.hurtnpc,"Afraid_loop")
			--self.aniFrame = BehaviorFunctions.GetEntityAnimationFrame(self.hurtnpc,"Afraid_loop")
			--self.aniTime = BehaviorFunctions.GetFightFrame()
			--self.animation = ture
		--end
		----重复播开关
		--if self.animation == ture then

			--if self.time - self.aniTime > self.aniFrame and self.aniFrame ~= 0 then
				--self.aniTime = 0
				--self.animation = false

			--end
		--end
		
		--判断任务结果
		--成功：怪物死亡
		if self.allDie == true and self.Over == false then
			--BehaviorFunctions.RemoveDelayCall(self.aniId)
			--隐藏气泡和tip
			BehaviorFunctions.SetNonNpcBubbleVisible(self.hurtnpc,false)
			BehaviorFunctions.AddDelayCallByTime(3,BehaviorFunctions,BehaviorFunctions.HideTip,30000010)
			
			BehaviorFunctions.AddDelayCallByTime(1,BehaviorFunctions,BehaviorFunctions.ShowCommonTitle,8,"已清除城市威胁",true)
			BehaviorFunctions.AddDelayCallByTime(2,BehaviorFunctions,BehaviorFunctions.StartStoryDialog,601010701)
			----移除恐惧表演
			--BehaviorFunctions.PlayAnimation(self.hurtnpc,"Stand")
			
			self.missionState = 6
			self.Over = true
			
			--BehaviorFunctions.ChangeNpcBubbleContent(self.hurtnpc,"气脉乱流好可怕",4)
		end
	end	
	--对话播完移除关卡
	if self.missionState == 7 then
		BehaviorFunctions.AddDelayCallByTime(5,BehaviorFunctions,BehaviorFunctions.RemoveLevel,self.levelId)
			
		self.missionState = 8
	end
		
	--超出范围卸载
	if self.missionState >= 2 then
		local rolepos = BehaviorFunctions.GetPositionP(self.role)
		local pos = BehaviorFunctions.GetTerrainPositionP("npc",10020004,"Logic10020004_Savenpc")
		local distance = BehaviorFunctions.GetDistanceFromPos(rolepos,pos)
		if distance > 80 then
			self:Leave()
		end
	end
end



--卸载内容
function LevelBehavior401010101:Leave()
	--移除怪物
	for i,v in ipairs(self.monsterList) do
		if v.Id then
			BehaviorFunctions.RemoveEntity(v.Id)
		end
	end
	self.monsterList = {
		[1] = {state = self.monsterStateEnum.Default,bp = "mon11", Id = nil , hitTime = 0, entityId = 900080},
		[2] = {state = self.monsterStateEnum.Default,bp = "mon13", Id = nil , hitTime = 0, entityId = 900080}
	}
	self.dieCount = 0
	self.allDie = false
	self.missionState = 0
	self.Over = false
	self.animation = false
	BehaviorFunctions.HideTip(30000010)
	
end

	
--判断任务完成条件1：怪物全部死亡
function LevelBehavior401010101:Death(instanceId,isFormationRevive)
	
	for i,v in ipairs(self.monsterList) do
		if v.Id == instanceId then
			self.dieCount = self.dieCount + 1
			table.remove(self.monsterList,i)
		end
	end
	
	if self.dieCount == 2 then
		self.allDie = true
	end
end	

--function LevelBehavior401010101:Die(attackInstanceId,instanceId)
	--if self.hurtnpc == instanceId then
		--self:Remake()
	--end
--end

--设置攻击目标
function LevelBehavior401010101:ChangeTarget(monsterList)
	for i,v in ipairs(monsterList) do
		if v.state == self.monsterStateEnum.Live then
			if BehaviorFunctions.CheckEntity(self.hurtnpc) then
				BehaviorFunctions.SetEntityValue(monsterList[i].Id,"battleTarget",self.hurtnpc)
				--BehaviorFunctions.RemoveBuff(monsterList[i].Id,900000012)
			--else
				--BehaviorFunctions.SetEntityValue(monsterList[i].Id,"battleTarget",self.role)
			end
		end
	end
end

--受击转换攻击目标
function LevelBehavior401010101:Hit(attackInstanceId,hitInstanceId,hitType)
	if self.missionState == 5 then
		for i,v in ipairs(self.monsterList) do
			if  v.Id == hitInstanceId  then
				BehaviorFunctions.SetEntityValue(v.Id,"battleTarget",self.role)
				v.hitTime = BehaviorFunctions.GetFightFrame()
			end
		end
	end
end


function LevelBehavior401010101:BigRange()
	local rolepos = BehaviorFunctions.GetPositionP(self.role)
	local pos = BehaviorFunctions.GetTerrainPositionP("npc",10020004,"Logic10020004_Savenpc")
	local distance = BehaviorFunctions.GetDistanceFromPos(rolepos,pos)
	if distance < 50 then
		self.missionState = 2
	end
	
end

function LevelBehavior401010101:SmallRange()
	local rolepos = BehaviorFunctions.GetPositionP(self.role)
	local pos = BehaviorFunctions.GetTerrainPositionP("npc",10020004,"Logic10020004_Savenpc")
	local distance = BehaviorFunctions.GetDistanceFromPos(rolepos,pos)
	if distance < 20 then
		self.missionState = 4
	end
end

--npc受击表演
function LevelBehavior401010101:FirstCollide(attackInstanceId,hitInstanceId,instanceId)
	--and attackInstanceId == self.monsterList[i].Id
	
	--播受击动作
	--if self.animation == false then
		if hitInstanceId == self.hurtnpc then
			local R = BehaviorFunctions.RandomSelect(1,2,3)
			if R == 1 then
				self.choose = "Afraid"
			elseif R == 2 then
				self.choose ="Bhit"
			elseif R == 3 then
				self.choose ="Fhit"
			end
				
			--self.beforePos = BehaviorFunctions.GetPositionP(self.hurtnpc)
			--self.beforelookPos = BehaviorFunctions.GetPositionOffsetBySelf(self.hurtnpc,10,0)
			--BehaviorFunctions.DoLookAtTargetImmediately(self.hurtnpc,self.role)
			BehaviorFunctions.PlayAnimation(self.hurtnpc,self.choose)
			self.aniFrame = BehaviorFunctions.GetEntityAnimationFrame(self.hurtnpc,self.choose)
			--BehaviorFunctions.PlayAnimation(self.hurtnpc,"Afraid_loop")
			self.aniTime = BehaviorFunctions.GetFightFrame()
			self.animation = ture
		end
	--end
		
end

function LevelBehavior401010101:StoryEndEvent(dialogId)
	if dialogId == 601010701 then
		self.missionState = 7
	end
end

--对话时播动作
function LevelBehavior401010101:StoryPassEvent(dialogId)
	if dialogId == 601010701 then
		
		BehaviorFunctions.PlayAnimation(self.hurtnpc,"Motou_in")
		--BehaviorFunctions.AddDelayCallByFrame(45,BehaviorFunctions,BehaviorFunctions.PlayAnimation,self.hurtnpc,"Motou_end")
	end
	if dialogId == 601010702 then
		BehaviorFunctions.PlayAnimation(self.hurtnpc,"Baoshou_in")
		BehaviorFunctions.AddDelayCallByFrame(45,BehaviorFunctions,BehaviorFunctions.PlayAnimation,self.hurtnpc,"Baoshou_end")
	end
end



