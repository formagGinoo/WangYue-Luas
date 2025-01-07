Behavior2040201 = BaseClass("Behavior2040201",EntityBehaviorBase)
--气脉入口
function Behavior2040201.GetGenerates()
	--预加载
	local generates = {}
	return generates
end

function Behavior2040201:Init()
	--初始化
	self.me = self.instanceId--记录自己
	self.doActive = false
	self.timeStart = 0
	self.time = 0
	self.actTime = 3
	self.actState =0
	self.hideState = nil
end


function Behavior2040201:Update()
	if not self.dropentity then
		self.dropentity = BehaviorFunctions.GetEcoEntityByEcoId(20002)--获取宝箱生态id
		--BehaviorFunctions.DoMagic(1,self.dropentity,900000010)--隐藏宝箱
	elseif not self.hideState and self.dropentity and BehaviorFunctions.CheckEntity(self.dropentity) then
		BehaviorFunctions.SetEntityValue(self.dropentity,"isHide",true)--隐藏宝箱交互按钮
		self.hideState = true
	end
	self.isActive = BehaviorFunctions.CheckEntityEcoState(self.me)--每帧检测实体的状态
	self.time = BehaviorFunctions.GetFightFrame()/30--世界时间
	self.chal_state = BehaviorFunctions.GetEntityValue(self.me,"chal_state")--取关卡挑战状态
	-----------------成功失败判断
	if self.chal_state and self.chal_state== 1 then--挑战成功
		BehaviorFunctions.InteractEntityHit(self.me,FightEnum.SysEntityOpType.Collect)--移除机关
		BehaviorFunctions.SetEntityValue(self.me,"chal_state",nil)--还原参数
		--BehaviorFunctions.RemoveBuff(self.dropentity,900000010)--取消隐藏宝箱
		BehaviorFunctions.SetEntityValue(self.dropentity,"isHide",false)--还原隐藏宝箱交互按钮的值
		--LogError()
	elseif self.chal_state and self.chal_state== 2 then--挑战失败
		self.hidetigger = nil--还原参数
		self.isTrigger = nil--还原参数
		BehaviorFunctions.SetEntityValue(self.me,"chal_state",nil)--还原参数
		BehaviorFunctions.RemoveBuff(self.me,900000010)--取消隐藏机关
	end
end

function Behavior2040201:WorldInteractClick(uniqueId)--点击交互列表
	if self.interactUniqueId and self.interactUniqueId == uniqueId then
		BehaviorFunctions.DoMagic(1,self.me,900000010)--隐藏机关
		self.hidetigger = true--隐藏按钮
		BehaviorFunctions.AddLevel(10020007)--进入关卡
		BehaviorFunctions.WorldInteractRemove(self.interactUniqueId)--移除交互按钮
	end
end
function Behavior2040201:EnterTrigger(triggerInstanceId,triggerEntityId,roleInstanceId)--进入交互范围
	if self.isTrigger then--已经触发过了，则跳过
		return
	end
	self.isTrigger = triggerInstanceId == self.me--判断现在触发的是不是自己
	if not self.isTrigger then
		return
	end
	if BehaviorFunctions.HasBuffKind(self.me,900000010) and self.interactUniqueId and self.hidetigger then
		BehaviorFunctions.WorldInteractRemove(self.interactUniqueId)--移除交互按钮
		--LogError("aaaaaaaaaa")
	elseif not self.hidetigger then--没有隐藏按钮
		self.interactUniqueId = BehaviorFunctions.WorldInteractActive(WorldEnum.InteractType.Item,200001,"开始挑战", 1)--物品类型，图标，文字，品质
	    --LogError("ssssssssss")
	end
end


function Behavior2040201:ExitTrigger(triggerInstanceId,triggerEntityId,roleInstanceId)--退出交互范围
	if self.isTrigger and triggerInstanceId == self.me and not self.hidetigger then--如果已经进入交互范围
		self.isTrigger = false--则变量变为false
		BehaviorFunctions.WorldInteractRemove(self.interactUniqueId)--移除交互按钮
	end
end