TaskBehavior101110201 = BaseClass("TaskBehavior101110201")
--滑翔教学:
--1.给玩家一次随便飞的机会
--2.第二次飞，如果耐力<30%,且脚下高度>10m,插入时停保底教学
function TaskBehavior101110201.GetGenerates()
	local generates = {}
	return generates
end

function TaskBehavior101110201:__init(taskInfo)
	self.taskInfo = taskInfo
	self.taskId = taskInfo.taskId
	self.role = nil
	self.taskState = 0
	self.dialogId = {

	}
	self.posName = {
		rolePos = "Gongdi",
	}
	self.dialogState = 0
	self.missionState = 0
	self.teachState = 0
end

function TaskBehavior101110201:Update()
	self.role = BehaviorFunctions.GetCtrlEntity()
	if self.missionState == 0 then
		--直接设置位置
		local rolePos = BehaviorFunctions.GetTerrainPositionP("Gongdi", 10020005, "Prologue02")
		BehaviorFunctions.InMapTransport(rolePos.x,rolePos.y,rolePos.z)
		BehaviorFunctions.ShowGuideImageTips(20013)    --滑翔教学
		--临时复活点
		BehaviorFunctions.SetReviveTransportPos(rolePos.x, rolePos.y, rolePos.z)
		self.missionState = 1
	end
	--滑翔取消教学与保底
	if self.teachState == 0 then
		if BehaviorFunctions.CheckEntity(self.role) then
			local rolePos = BehaviorFunctions.GetPositionP(self.role)
			local height,layer= BehaviorFunctions.CheckPosHeight(rolePos)
			local staminaPercent = BehaviorFunctions.GetPlayerAttrRatio(1642)
			if BehaviorFunctions.GetEntityState(self.role) == FightEnum.EntityState.Glide then
				if height > 10 and staminaPercent <= 3000 then
					--玩家要摔死了，时停教学救一下
					--时停
					BehaviorFunctions.DoMagic(1,self.role,200000008)
					BehaviorFunctions.AddEntitySign(1,10000012,-1)
					--教学取消滑翔
					BehaviorFunctions.PlayGuide(2050)
					BehaviorFunctions.CancelJoystick()
					self.teachState = 1
				end
			end
		end
	elseif self.teachState == 2 then
		if BehaviorFunctions.CheckEntity(self.role) then
			local rolePos = BehaviorFunctions.GetPositionP(self.role)
			local height,layer= BehaviorFunctions.CheckPosHeight(rolePos)
			local staminaPercent = BehaviorFunctions.GetPlayerAttrRatio(1642)
			if BehaviorFunctions.GetEntityJumpState(self.role) == FightEnum.EntityJumpState.JumpDown then
				--马上落地了
				if height <= 5 then
					BehaviorFunctions.DoMagic(1,self.role,200000008)
					BehaviorFunctions.AddEntitySign(1,10000012,-1)
					self:DisablePlayerInput(false,false)
					BehaviorFunctions.PlayGuide(2051)
					self.teachState = 3
				end
			end
		end
	end
end

function TaskBehavior101110201:Remove()
	--移除临时复活点
	BehaviorFunctions.SetReviveTransportPos(nil,nil,nil)
end

function TaskBehavior101110201:OnGuideFinish(guideId, stage)
	if guideId == 2050 and self.teachState == 1 and BehaviorFunctions.HasBuffKind(self.role,200000008) then
		BehaviorFunctions.RemoveBuff(self.role,200000008)
		BehaviorFunctions.RemoveEntitySign(1,10000012)
		self:DisablePlayerInput(true,true)
		self.teachState = 2
	elseif guideId == 2051 and self.teachState == 3 and BehaviorFunctions.HasBuffKind(self.role,200000008) then
		BehaviorFunctions.RemoveBuff(self.role,200000008)
		BehaviorFunctions.RemoveEntitySign(1,10000012)
		self.teachState = 999
	end
end

function TaskBehavior101110201:DisablePlayerInput(isOpen,closeUI)
	--取消摇杆移动
	BehaviorFunctions.CancelJoystick()
	if isOpen then
		----禁用摇杆输入
		--BehaviorFunctions.SetJoyMoveEnable(self.role,false)
		--关闭按键输入
		for i,v in ipairs(FightEnum.KeyEvent) do
			BehaviorFunctions.ForbidKey(i,true)
		end
	else
		BehaviorFunctions.SetJoyMoveEnable(self.role,true)
		for i,v in ipairs(FightEnum.KeyEvent) do
			BehaviorFunctions.ForbidKey(i,false)
		end
	end
	if closeUI then
		--屏蔽战斗主UI
		BehaviorFunctions.SetFightMainNodeVisible(2,"PanelParent",false)
	else
		--显示战斗主UI
		BehaviorFunctions.SetFightMainNodeVisible(2,"PanelParent",true)
	end
end

--用任务占用做了，不需要写逻辑啦！！！！！！！！！


-- TaskBehavior101110201 = BaseClass("TaskBehavior101110201")
-- --创建交互点，交互后播对话
-- --完成：播完对话后完成任务

-- function TaskBehavior101110201.GetGenerates()
-- 	local generates = {}
-- 	return generates
-- end

-- function TaskBehavior101110201:__init(taskInfo)
-- 	self.taskInfo = taskInfo
--     self.taskId = taskInfo.taskId
-- 	self.role = nil
-- 	self.taskState = 0
--     self.gongrenNpcId = nil
--     self.dialogId = {
--         101110301   --和工人聊天
--     }
--     self.npcInstanceId = nil
--     self.dialogState = 0
-- end

-- function TaskBehavior101110201:Update()
-- 	self.role = BehaviorFunctions.GetCtrlEntity()
--     if not self.npcInstanceId then
--         self.npcEntity = BehaviorFunctions.GetNpcEntity(self.gongrenNpcId)
--         if self.npcEntity then
-- 	        self.npcInstanceId = self.npcEntity.instanceId
--         end
--     end
-- end

-- function TaskBehavior101110201:WorldInteractClick(uniqueId,instanceId)
--     if instanceId == self.npcInstanceId and self.dialogState == 0 then
--         BehaviorFunctions.StartStoryDialog(self.dialogId[1])
--         BehaviorFunctions.RemoveEntity(self.Jiaohudian)
--         self.dialogState = 1
--     end
-- end