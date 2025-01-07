Behavior2020708 = BaseClass("Behavior2020708",EntityBehaviorBase)
--NPC对话空实体
local DataItem = Config.DataItem.data_item

--预加载
function Behavior2020708.GetGenerates()
	-- local generates = {}
	-- return generates
end

function Behavior2020708:Init()
	self.me = self.instanceId
	self.myName = nil
	self.ecoId = nil
	self.defaultDialogId = 0
	self.isAutoRemove = false	
	self.extraParam = nil
	self.interactUniqueId = nil
	self.isTrigger = false
	self.isInfight = false
	self.role = nil

	self.effectSwitch = false
	self.init = false
	self.myguideIndex = nil
end

function Behavior2020708:LateInit()
	if not self.extraParam then
		self.ecoId = BehaviorFunctions.GetEntityEcoId(self.me)
		--获取额外参数
		self.extraParam = BehaviorFunctions.GetEcoEntityExtraParam(self.ecoId)
		if self.extraParam then
			--获取额外参数的对话ID
			self.defaultDialogId = tonumber(self.extraParam[1].dialogId)
			--获取该物体的名字
			self.myName = self.extraParam[1].name
			BehaviorFunctions.ChangeWorldInteractInfo(self.me,nil,self.myName)
			--获取交互后是否hit掉
			if self.extraParam[1].autoRemove == "false" then
				self.isAutoRemove = false
			elseif self.extraParam[1].autoRemove == "true" then
				self.isAutoRemove = true
			end
		else
			LogError("没有额外参数配置：我的ecoID是"..self.ecoId.."看到请立刻截图给阮杉")
		end
	end
	self.myguideIndex = BehaviorFunctions.AddEntityGuidePointer(self.me,FightEnum.GuideType.OpenDoor)
end


function Behavior2020708:Update()
	self.role = BehaviorFunctions.GetCtrlEntity()
	
	if self.defaultDialogId > 0 then
		--根据距离显示实体标记
		if BehaviorFunctions.GetDistanceFromTarget(self.me,self.role) < 8 then
			if not self.myguideIndex then
				self.myguideIndex = BehaviorFunctions.AddEntityGuidePointer(self.me,FightEnum.GuideType.OpenDoor)
			end
		else
			if self.myguideIndex then
				BehaviorFunctions.RemoveEntityGuidePointer(self.myguideIndex)
				self.myguideIndex = nil
			end
		end
		
		----显示交互提示特效
		--if self.effectSwitch == false then
			----交互提示特效
			--if not BehaviorFunctions.HasBuffKind(self.me,200000003) then
				--BehaviorFunctions.AddBuff(self.me,self.me,200000003)
			--end
		--elseif self.effectSwitch == true then
			----移除交互提示特效
			--if BehaviorFunctions.HasBuffKind(self.me,200000003) then
				--BehaviorFunctions.RemoveBuff(self.me,200000003)
			--end
		--end
	end
		----检查物品是否处于视线范围内
		--if not BehaviorFunctions.CheckObstaclesBetweenEntity(self.me,self.role) then
			--local myPos = BehaviorFunctions.GetPositionP(self.me)
			--local isInsign = BehaviorFunctions.CheckPosIsInScreen(myPos)
			--if isInsign and not self.myguideIndex then
				--self.myguideIndex = BehaviorFunctions.AddEntityGuidePointer(self.me,FightEnum.TaskGuideType.Entity)
			--elseif not isInsign and self.myguideIndex then
				--BehaviorFunctions.RemoveEntityGuidePointer(self.myguideIndex)
				--self.myguideIndex = nil
			--end
		--end
	--end
end


--进入交互范围，添加交互列表
function Behavior2020708:EnterTrigger(triggerInstanceId,triggerEntityId,roleInstanceId)
	if triggerInstanceId == self.me then
		if self.defaultDialogId	> 0 then
			
			if not BehaviorFunctions.CheckPlayerInFight() then
				local myPos = BehaviorFunctions.GetPositionP(self.me)
				local isInsign = BehaviorFunctions.CheckPosIsInScreen(myPos)

				----检查物品是否处于视线范围内
				--if not BehaviorFunctions.CheckObstaclesBetweenEntity(self.me,self.role) then
					--isInsign = BehaviorFunctions.CheckPosIsInScreen(myPos)
				--end
				--如果不处于视线内但是触发过按钮
				if self.isTrigger and not isInsign then
					self.isTrigger = nil
					BehaviorFunctions.WorldInteractRemove(self.me,self.interactUniqueId)
				--如果处于视线内但是没触发过按钮
				elseif not self.isTrigger and isInsign then
					self.isTrigger = triggerInstanceId == self.me
					self.interactUniqueId = BehaviorFunctions.WorldNPCInteractActive(self.me,self.myName)
				else
					return
				end
			else
				--如果处于战斗中且触发过按钮
				if self.isTrigger then
					self.isTrigger = nil
					BehaviorFunctions.WorldInteractRemove(self.me,self.interactUniqueId)
					return
				end
			end
		end
	end
end

--退出交互范围，移除交互列表
function Behavior2020708:ExitTrigger(triggerInstanceId,triggerEntityId,roleInstanceId)
	if self.isTrigger and triggerInstanceId == self.me then
		self.isTrigger = nil
		BehaviorFunctions.WorldInteractRemove(self.me,self.interactUniqueId)
	end
end

--点击交互:播放默认对话
function Behavior2020708:WorldInteractClick(uniqueId, instanceId)
	if instanceId ~= self.me then
		return
	end
	if self.defaultDialogId > 0 then
		if self.interactUniqueId and self.interactUniqueId == uniqueId then
			BehaviorFunctions.WorldInteractRemove(self.me,self.interactUniqueId)
			BehaviorFunctions.StartNPCDialog(self.defaultDialogId,self.me)
			self.isTrigger = nil
		end
	else
		if self.isAutoRemove then
			BehaviorFunctions.InteractEntityHit(self.me,false)
		end
	end
end

function Behavior2020708:StoryDialogEnd(dialogId)
	if dialogId == self.defaultDialogId then
		if self.isAutoRemove then
			BehaviorFunctions.InteractEntityHit(self.me,false)
		end
	end
end