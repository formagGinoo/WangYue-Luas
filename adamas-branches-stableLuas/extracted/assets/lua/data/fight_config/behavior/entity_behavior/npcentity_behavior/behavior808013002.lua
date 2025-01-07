Behavior808013002 = BaseClass("Behavior808013002",EntityBehaviorBase)
--于静，嘉元版
function Behavior808013002.GetGenerates()
    local generates = {}
    return generates
end

function Behavior808013002:Init()
    self.me = self.instanceId
	self.ecoMe = self.sInstanceId
	self.totalFrame = 0
	self.doorState = 0
	self.doorStateEnum =
	{
		Closed =0,
		Opened = 1,
		Closing = 2,
		Opening = 3,
	}
	self.canOpen = true
	self.doorOpen = false
    self.npcStade = false
    self.canOpenKey = false
	self.happyAnim = false
	self.happyCall = nil

	self.turnAnim = false
	self.turnCall = nil
end

function Behavior808013002:LateInit()
    self.doorOpen = BehaviorFunctions.SetEntityValue(self.me,"doorOpen",false)
	BehaviorFunctions.SetEntityValue(self.me,"canOpenKey",false)
	BehaviorFunctions.SetEntityValue(self.me,"happyAnim",false)
	BehaviorFunctions.SetEntityValue(self.me,"turnAnim",false)
	BehaviorFunctions.SetEntityValue(self.me,"gamePlay",false)
end

function Behavior808013002:Update()
	self.role = BehaviorFunctions.GetCtrlEntity()
    if BehaviorFunctions.GetEntityValue(self.me,"canOpenKey") == true then
        if self.npcStade == false then
            BehaviorFunctions.PlayAnimation(self.me,"Squat_out",FightEnum.AnimationLayer.PerformLayer)
            self.npcStade = true
        end
    end

	if BehaviorFunctions.GetEntityValue(self.me,"happyAnim") == true then
        if self.happyAnim == false then
			self.happyCall = BehaviorFunctions.AddDelayCallByFrame(90,BehaviorFunctions,BehaviorFunctions.PlayAnimation,self.me,"Jump",FightEnum.AnimationLayer.PerformLayer)
            -- BehaviorFunctions.PlayAnimation(self.me,"Squat_out",FightEnum.AnimationLayer.PerformLayer)
            self.happyAnim = true
        end
    end

	if BehaviorFunctions.GetEntityValue(self.me,"turnAnim") == true then
        if self.turnAnim == false then
			self.turnCall = BehaviorFunctions.AddDelayCallByFrame(100,BehaviorFunctions,BehaviorFunctions.CastSkillBySelfPosition,self.me,2147483601)
			-- BehaviorFunctions.CastSkillBySelfPosition(self.me,2147483601)
            -- BehaviorFunctions.PlayAnimation(self.me,"Squat_out",FightEnum.AnimationLayer.PerformLayer)
            self.turnAnim = true
        end
    end

	--非游戏状态下屏蔽交互按钮
	if BehaviorFunctions.GetEntityValue(self.me,"gamePlay") == true then
		BehaviorFunctions.SetEntityWorldInteractState(self.me,true)
	else
		BehaviorFunctions.SetEntityWorldInteractState(self.me,false)
	end

end

--点击按钮
function Behavior808013002:WorldInteractClick(uniqueId, instanceId)
	if instanceId == self.me then
		if self.interactUniqueId == uniqueId then
			local canOpenKey = BehaviorFunctions.GetEntityValue(self.me,"canOpenKey")
			if self.canOpen and canOpenKey == false then		-- self.doorOpen == false and

                if self.canOpenKey == false then
                    BehaviorFunctions.SetEntityValue(self.me,"canOpenKey",true)
                    self.canOpenKey = true
                end
                
				if self.doorState == self.doorStateEnum.Closed then
					self.isTrigger = false
					-- 移除标记
					BehaviorFunctions.WorldInteractRemove(self.me,self.interactUniqueId)
					-- 播开门动画
					-- BehaviorFunctions.PlayAnimation(self.me, "Opening")
					-- 获取开门的帧数
					self.openingTime = BehaviorFunctions.GetEntityFrame(self.me)
					-- 修改门的状态
					self.doorState = self.doorStateEnum.Opening
				end
			-- else
			-- 	BehaviorFunctions.StartStoryDialog(601019601)
			end
		end
	end
end

function Behavior808013002:EnterTrigger(triggerInstanceId,triggerEntityId,roleInstanceId)
	if self.isTrigger or triggerInstanceId ~= self.me or (self.doorState ~= self.doorStateEnum.Closed) then		-- and self.doorState ~= self.doorStateEnum.Opened
		return
	end
	self.isTrigger = true
	local interactType = WorldEnum.InteractType.Collect
	local interactDesc = self.doorState == self.doorStateEnum.Closed and "松绑" or "松绑"
	self.interactUniqueId = BehaviorFunctions.WorldInteractActive(self.me,interactType, nil, interactDesc, 1)
	-- BehaviorFunctions.SetEntityValue(self.me,"doorOpen",true)
end

function Behavior808013002:ExitTrigger(triggerInstanceId,triggerEntityId,roleInstanceId)
	if not self.isTrigger or triggerInstanceId ~= self.me then
		return
	end
	self.isTrigger = false
	BehaviorFunctions.WorldInteractRemove(self.me, self.interactUniqueId)
	self.interactUniqueId = nil
end