--逻辑：
-- 依盖队玩法，获取npc的InstanceId，然后用回调判断她的受击和对话情况，隐藏Npc并召唤一只怪。

Behavior2040701 = BaseClass("Behavior2040701",EntityBehaviorBase)

--初始化
function Behavior2040701.GetGenerates()
	local generates = {900070}
	return generates
end 

function Behavior2040701:Init()
	self.me = self.instanceId
	self.role = nil
	self.missionState = 0
    -- 移除实体状态的标志
    self.removedState = 0
    -- npc实体是否显示
    self.isShow = false
	self.npcInfo = {
	[1]= {id = 8010244, npcInstanceId = 0},
	--[2]= {id = 8010252, npcInstanceId = 0},
	--[3]= {id = 8010253, npcInstanceId = 0},
	--[4]= {id = 8010254, npcInstanceId = 0},
	--[5]= {id = 8010255, npcInstanceId = 0},
	--[6]= {id = 8010256, npcInstanceId = 0},
	--[7]= {id = 8010257, npcInstanceId = 0},
	--[8]= {id = 8010258, npcInstanceId = 0},
	--[9]= {id = 8010259, npcInstanceId = 0},
	--[10]= {id = 8010260, npcInstanceId = 0},
	}
    -- 是否重置关卡的标志
    self.shouldReset = false
    -- npc实体是否存在
    self.isNpc = nil
end


function Behavior2040701:Update()
	--self.role = BehaviorFunctions.GetCtrlEntity()
	--if self.missionState == 0 then
    	--获取NPC实例id
		--for i, v in ipairs(self.npcInfo) do
			--self.npcEntity = BehaviorFunctions.GetNpcEntity(self.npcInfo[i].id)
			--if self.npcEntity then
				--self.npcInfo[i].npcInstanceId = self.npcEntity.instanceId
				----让依盖队打电话（已经不用手动挂状态了）
				--if self.npcInfo[i].npcInstanceId > 0 and i == 1 then
					--BehaviorFunctions.SetNpcMailState(self.npcInfo[i].npcInstanceId, true)
					--BehaviorFunctions.SetNpcCallState(self.npcInfo[i].npcInstanceId, true)
					--BehaviorFunctions.PlayAnimation(self.npcInfo[i].npcInstanceId, "PhoneStand_loop")
				--end
			--end
		--end
		--for key, value in pairs(self.npcInfo) do
			--print(key, value.id, value.npcInstanceId)
		--end
		--self.missionState = 1
	--end
end


function Behavior2040701:WorldInteractClick(uniqueId, instanceId)
    if instanceId == self.me then
        BehaviorFunctions.StartNPCDialog(601010601)
    end
end


function Behavior2040701:Death(instanceId,isFormationRevive)
    --移除这个玩法实体
	--isFormationRevive or
    if instanceId == self.Yigaidui then
		BehaviorFunctions.ShowCommonTitle(8,"已清除城市威胁",true)
        BehaviorFunctions.InteractEntityHit(self.me)
    end
end

--回调，经过相关剧情，隐藏npc，召唤怪物，让Npc开始四散奔逃
--function Behavior2040701:StoryPassEvent(dialogId)
    --if dialogId == 601010603 then  --选两个都一样
function Behavior2040701:StoryEndEvent(dialogId)
	if dialogId == 601010601 then		
        BehaviorFunctions.SetEntityShowState(self.npcInfo[1].npcInstanceId, false)
		BehaviorFunctions.ShowCharacterHeadTips(self.npcInfo[1].npcInstanceId, false)
        if not self.Yigaidui then
			self:CreateYigaidui()  --罗睺斩客
			--for i, v in ipairs(self.npcInfo) do
				--local pos = BehaviorFunctions.GetTerrainPositionP("EscapePos", 10020004, "WorldTgc_npc")
				--if i ~= 1 then
					--BehaviorFunctions.SetPathFollowPos(self.npcInfo[i].npcInstanceId, pos)
					--if BehaviorFunctions.CanCtrl(self.npcInfo[i].npcInstanceId) and i ~= 1 then
						--if BehaviorFunctions.GetEntityState(self.npcInfo[i].npcInstanceId) ~= FightEnum.EntityState.Move then
							--BehaviorFunctions.DoSetEntityState(self.npcInfo[i].npcInstanceId, FightEnum.EntityState.Move)
							--BehaviorFunctions.DoSetMoveType(self.npcInfo[i].npcInstanceId, FightEnum.EntityMoveSubState.Run)
						--end
					--end
				--end
			--end
		end
    end
end

--创建依盖队函数
function Behavior2040701:CreateYigaidui()
    local pos = BehaviorFunctions.GetTerrainPositionP("YigaiduiGameplay", 10020004, "WorldTgc00101")
    self.Yigaidui = BehaviorFunctions.CreateEntityByEntity(self.me, 900070, pos.x, pos.y, pos.z)
	BehaviorFunctions.SetEntityWorldInteractState(self.me, false)   --关闭交互组件
end

--受击回调
function Behavior2040701:Hit(attackInstanceId,hitInstanceId,hitType,camp)
	if self.missionState == 0 then
		if attackInstanceId == self.role or hitInstanceId == self.role then
			--npc四散奔逃
			local pos = BehaviorFunctions.GetTerrainPositionP("YigaiduiGameplay", 10020004, "WorldTgc00101")
			BehaviorFunctions.SetBlackBoardValue(CustomFsmDataBlackBoardEnum.inCrime, pos)
			self.missionState = 1
		end
	end
end

--退出骇入回调，蹦出弹窗发现城市威胁
function Behavior2040701:ExitHacking()
	--BehaviorFunctions.ShowCommonTitle(7,"发现城市威胁",true)
end