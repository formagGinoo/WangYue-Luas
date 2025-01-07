LevelBehavior405010105 = BaseClass("LevelBehavior405010105",LevelBehaviorBase)
--肉鸽关卡:窃听识破抽奖骗局

-- 通用物品创建——遍历列表创建
-- 确定一个坏人（读npcId）,让他显示，给他插对话
-- 确定各个节点，比如啥时候进战、啥时候失败成功
-- 确定一个怪物，让他变身

--准备支持但还没支持的功能：
--创建多个依盖队，或者多个npc变身

function LevelBehavior405010105:__init(fight)
	self.fight = fight
end

function LevelBehavior405010105.GetGenerates()
	local generates = {2070102,2030222,790014000}
	return generates
end


function LevelBehavior405010105:Init()
	self.me = self.instanceId
	self.role = nil
	self.rolePos = nil
	self.time = nil
	self.missionState = 0
	
-----状态定义---------------------------------------------------------------------------------------------------------------------------------------	
	
	--关卡状态枚举
	self.levelStateEnum = 
	{
		Default = 0,
		Ongoing = 1,
		LevelSuccece = 2,
		LevelFail = 3,
		LevelEnd = 4,
	}

	--骇入内容枚举
	self.HackContentEnum = 
	{
		Mail = 1,
		Call = 2,
	}

	--关卡状态	
	self.levelState = self.levelStateEnum.Default
    self.alreadyHack = false
	
-----关卡配置参数---------------------------------------------------------------------------------------------------------------------------------------

	--关卡起始点位
	self.levelStartPos = nil

	--环境物品创建列表
	self.logicName = "RogueHackNpc"  --不填默认为关卡logic
	self.mapId = 10020005        --不填默认为用的关卡logic
	self.posList = {
		--[1] = {posName = "table5", entityId = 2030222, instanceId = nil},
		}
    
    --被骇入的npc列表
	self.npcInfo = {
		[1]= {id = 5881105, npcInstanceId = nil, HackContent = 1,},--骇入内容，1短信2电话
	}
	
	--变身的怪物Id
	self.monsterList ={
		[1] = {entityId = 790014000, lev = nil, bindNpc = 1,},
	}

    self.dialogList = {
        Interact = nil,
        FightNode =  602010212,
        FailNode1 = 602010208,
		FailNode2 = 602010108,
        SucceceNode = 602010301,   --这个暂时不是Node
    }
	
	--距离警告
	self.distanceWarning = false
	--距离范围
	self.warninDistance = 20
	--警告时间
	self.warningEndTime = nil
	--警告时长(秒)
	self.warningTime = 8	
end

function LevelBehavior405010105:LateInit()
	-- if not self.levelStartPos then
	-- 	if self.rogueEventId then
	-- 		self.levelStartPos = BehaviorFunctions.GetRoguelikePointInfo(self.rogueEventId)
	-- 	else
	-- 		self.levelStartPos = BehaviorFunctions.GetPositionP(self.role)
	-- 	end
	-- end
	
	--BehaviorFunctions.SetEntityValue(self.me,"active",false)
end

function LevelBehavior405010105:Update()
	self.role = BehaviorFunctions.GetCtrlEntity()
	self.rolePos = BehaviorFunctions.GetPositionP(self.role)

    --关卡处于默认状态时
	if self.levelState == self.levelStateEnum.Default then

		--关卡创建点位获取
		if not self.levelStartPos then
			if self.rogueEventId then
				local posData = BehaviorFunctions.GetRoguelikePointInfo(self.rogueEventId)
				self.levelStartPos = BehaviorFunctions.GetTerrainPositionP(posData.position, posData.positionId, posData.logicName)
			else
				--如果获取不到点位就在玩家身边创建
				self.levelStartPos = BehaviorFunctions.GetPositionP(self.role)
			end
		end
		
		----物品创建
		--for i, v in ipairs(self.posList) do
			----BehaviorFunctions.CreateEntityByPosition(v.entityId, nil, v.posName, self.LogicName, self.mapId, self.levelId)
			--if not v.instanceId then
				--local pos = nil
				--local rot = nil
				--if self.logicName then
					--pos = BehaviorFunctions.GetTerrainPositionP(v.posName, self.mapId, self.logicName)
					--rot = BehaviorFunctions.GetTerrainRotationP(v.posName, self.mapId, self.logicName)
				--else
					--pos = BehaviorFunctions.GetTerrainPositionP(v.posName, self.levelId)
					--rot = BehaviorFunctions.GetTerrainRotationP(v.posName, self.levelId)
				--end
				--v.instanceId = BehaviorFunctions.CreateEntity(v.entityId, nil, pos.x, pos.y, pos.z, nil, nil, nil, self.levelId, v.lev)
				--BehaviorFunctions.SetEntityEuler(v.instanceId,rot.x,rot.y,rot.z)
			--end	
		--end

        --获取NPC实例id并处理状态
        for i, v in ipairs(self.npcInfo) do
			BehaviorFunctions.ChangeEcoEntityCreateState(v.id, true)
            self.npcEntity = BehaviorFunctions.GetNpcEntity(v.id)
			BehaviorFunctions.SetEntityHackEffectIsTask(v.id, true)
            if self.npcEntity then
                v.npcInstanceId = self.npcEntity.instanceId
                if v.npcInstanceId > 0 and v.HackContent then
					--根据是窃听电话还是短信改对应的状态
					if v.HackContent == self.HackContentEnum.Mail then
                		BehaviorFunctions.SetNpcMailState(v.npcInstanceId, true)
						BehaviorFunctions.PlayAnimation(v.npcInstanceId, "TextStand")
					elseif v.HackContent == self.HackContentEnum.Call then
                		BehaviorFunctions.SetNpcCallState(v.npcInstanceId, true)
                		BehaviorFunctions.PlayAnimation(v.npcInstanceId, "PhoneStand")
                	end
                end
				
				BehaviorFunctions.ShowCharacterHeadTips(self.npcInfo[1].npcInstanceId,true)
				

				BehaviorFunctions.SetEntityHackEffectIsTask(self.npcInfo[1].npcInstanceId, true)
				BehaviorFunctions.SetEntityValue(self.npcInfo[1].npcInstanceId,"active",fasle)
				self.levelState = self.levelStateEnum.Ongoing
            end
        end

		
		
	elseif self.levelState == self.levelStateEnum.Ongoing then	
		
		if not self.bubble then
			self.bubble = true
			BehaviorFunctions.AddDelayCallByFrame(1,BehaviorFunctions,BehaviorFunctions.ChangeNpcBubbleContent,self.npcInfo[1].npcInstanceId,"希望我的伪装不要被发现....",999999)
			BehaviorFunctions.AddDelayCallByFrame(1,BehaviorFunctions,BehaviorFunctions.SetNonNpcBubbleVisible,self.npcInfo[1].npcInstanceId,true)
		end
		
		if self.npcInfo[1].npcInstanceId and BehaviorFunctions.CheckEntity(self.npcInfo[1].npcInstanceId) then
			BehaviorFunctions.SetNpcMailState(self.npcInfo[1].npcInstanceId, true)
		end
		
		
		if not self.active and BehaviorFunctions.CheckEntity(self.npcInfo[1].npcInstanceId) then
			self.active = BehaviorFunctions.GetEntityValue(self.npcInfo[1].npcInstanceId,"active")
		elseif self.active and (not  self.Yigaidui)  then
				self:CreateYigaidui()  --罗睺斩客
		end
		
	
    --关卡处于胜利状态
	elseif self.levelState == self.levelStateEnum.LevelSuccece then
		BehaviorFunctions.ShowCommonTitle(7,"清除城市威胁",true)
		if self.rogueEventId then
			BehaviorFunctions.SetRoguelikeEventCompleteState(self.rogueEventId,true)
		end
		self.levelState = self.levelStateEnum.LevelEnd

	--关卡处于失败状态
	elseif self.levelState == self.levelStateEnum.LevelFail then
		if self.rogueEventId then
			BehaviorFunctions.SetRoguelikeEventCompleteState(self.rogueEventId,false)
		end
		self.levelState = self.levelStateEnum.LevelEnd

	--关卡处于结束状态
	elseif self.levelState == self.levelStateEnum.LevelEnd then

		--BehaviorFunctions.RemoveLevel(self.levelId)
	end
end


function LevelBehavior405010105:Death(instanceId,isFormationRevive)
    --角色死亡判负
	if isFormationRevive then
		self.levelState = self.levelStateEnum.LevelFail
	end
    --打死依盖队成功
	if instanceId == self.Yigaidui then
		BehaviorFunctions.ShowCommonTitle(8,"已清除城市威胁",true)
		self.levelState = self.levelStateEnum.LevelSuccece
	end
end

--回调，经过相关剧情，隐藏npc，召唤怪物
function LevelBehavior405010105:StoryEndEvent(dialogId)
	if dialogId == self.dialogList.FightNode then
		if not self.Yigaidui then
			self:CreateYigaidui()  --罗睺斩客
		end
	elseif dialogId == self.dialogList.FailNode1 or dialogId == self.dialogList.FailNode2 then
		self.levelState = self.levelStateEnum.LevelFail
	end
end

--回调，经过相关剧情，隐藏npc，召唤怪物
function LevelBehavior405010105:StoryPassEvent(dialogId)

end

--创建依盖队函数
function LevelBehavior405010105:CreateYigaidui()
	for i, v in ipairs(self.monsterList) do
		if v.bindNpc then
			local pos = BehaviorFunctions.GetPositionP(self.npcInfo[v.bindNpc].npcInstanceId)
			BehaviorFunctions.SetEntityWorldInteractState(self.npcInfo[v.bindNpc].npcInstanceId, false)   --关闭交互组件
			BehaviorFunctions.SetEntityShowState(self.npcInfo[v.bindNpc].npcInstanceId, false)
			BehaviorFunctions.ShowCharacterHeadTips(self.npcInfo[v.bindNpc].npcInstanceId, false)
			self.Yigaidui = BehaviorFunctions.CreateEntity(v.entityId, nil, pos.x, pos.y, pos.z, nil, nil, nil, self.levelId, v.Lev)
		else
			--self.Yigaidui = BehaviorFunctions.CreateEntityByPosition(v.entityId, nil, v.posName, self.LogicName, self.mapId, self.levelId, v.lev)
		end
		if self.Yigaidui then
			BehaviorFunctions.DoLookAtTargetImmediately(self.Yigaidui, self.role)
		end
	end
end

--npc四散奔逃（视情况看用不用）
function LevelBehavior405010105:Hit(attackInstanceId,hitInstanceId,hitType,camp)
	if self.missionState == 0 then
		if attackInstanceId == self.role or hitInstanceId == self.role then	
			BehaviorFunctions.SetBlackBoardValue(CustomFsmDataBlackBoardEnum.inCrime, self.levelStartPos)
			self.missionState = 1
		end
	end
end

--开始窃听
function LevelBehavior405010105:HackingClickUp(instanceId)
	if instanceId == self.npcInfo[1].npcInstanceId and self.alreadyHack == false then   --暂时写死了是1号npc被窃听
		self.alreadyHack = true
		--BehaviorFunctions.ShowCommonTitle(7,"已拦截到关键信息",true)
		BehaviorFunctions.ShowCharacterHeadTips(self.npcInfo[1].npcInstanceId,false)
		BehaviorFunctions.AddDelayCallByFrame(1,BehaviorFunctions,BehaviorFunctions.SetNonNpcBubbleVisible,self.npcInfo[1].npcInstanceId,false)
		BehaviorFunctions.AddDelayCallByTime(15,BehaviorFunctions, BehaviorFunctions.ShowCommonTitle, 7,"发现城市威胁",true)
		BehaviorFunctions.AddDelayCallByTime(13,BehaviorFunctions, BehaviorFunctions.SetEntityValue, self.npcInfo[1].npcInstanceId,"active",true)
	end
end

--退出骇入回调，蹦出弹窗发现城市威胁（改成在窃听的时候弹）
function LevelBehavior405010105:ExitHacking()
	--BehaviorFunctions.ShowCommonTitle(7,"发现城市威胁",true)
end


function LevelBehavior405010105:Remove()
	BehaviorFunctions.ChangeEcoEntityCreateState(self.npcInfo[1].npcInstanceId, false)
end
