CoreUILogic1009 = BaseClass("CoreUILogic1009", CoreUIBase)
local CoreUIType = 
{
	ProcessState = 1,
	CoreState = 2,
}

function CoreUILogic1009:OnInit()
	self.fxGo = self.ui.gameObject.transform:Find("UI_CoreUI1009/fx")
	self.animator = self.fxGo:GetComponent(Animator)
	UtilsUI.SetAnimationEventCallBack(self.fxGo, self:ToFunc("CoreState_out"))
end

function CoreUILogic1009:UpdatePercent(value, maxValue)
	self.type = self.type or CoreUIType.ProcessState
	self.value = value
	self.maxValue = maxValue
	self.percent = value / maxValue
	self.oldPercent = self.oldPercent or 0
	self:UpdateAnimationPercent()
end

function CoreUILogic1009:UpdateVisible(visible, time, force)
	self:BaseFunc("UpdateVisible", visible, time, force)
	if not self.animator then
		return
	end
	if visible == self.nowVisible then
		return
	end
	if visible == false then
		self.nowVisible = false
	else
		self.nowVisible = true
		self:Resume()
		self:UpdateAnimationPercent()
	end
end


function CoreUILogic1009:UpdateAnimationPercent()
	if self.oldPercent == 0 and self.percent == 1 then
		self.oldPercent = 1
		self.animator.speed = 0
		self.animator:Play("UI_CoreUI1009_jindu", 0, self.oldPercent)
		return
	end
	if self.type == CoreUIType.ProcessState then
		self.animator.speed = self.oldPercent > 0 or self.percent > 0 and 1 or 0
		self.animator:Play( "UI_CoreUI1009_jindu", 0, self.oldPercent)
	end
	self.oldPercent = self.percent
end

function CoreUILogic1009:Update(entity)
	self:BaseFunc("Update", entity)
	if self.nowVisible == false then
		return
	end
	local animTime = self.animator.gameObject.activeInHierarchy == true and self.animator:GetCurrentAnimatorStateInfo(0).normalizedTime or 0
	self.animatorNowTime = animTime
		
	self.animator.speed = self.type == CoreUIType.ProcessState and self.animatorNowTime >= self.percent and 0 or 1
end

function CoreUILogic1009:SwitchCoreUIType(type)
	if self.type == type then
		return
	end
	self.type = type
	self:Resume(true)
end

--被打断了 恢复下状态
function CoreUILogic1009:Resume(force)
	local info = self.animator:GetCurrentAnimatorStateInfo(0)
	if self.type == CoreUIType.ProcessState then
		if not info:IsName("UI_CoreUI1009_jindu") or force then
			self.animator.speed = 0
			self.animator:Play("UI_CoreUI1009_jindu", 0, self.percent)
		end
	end
	if self.type == CoreUIType.CoreState then
		if info:IsName("UI_CoreUI1009_kong") or force then
		end
	end
end

function CoreUILogic1009:ShowEffect(entity, index, active, speed)
	if entity ~= 1009 and entity.entityId ~= 1009 then
		return
	end
	self:SwitchCoreUIType(CoreUIType.CoreState)
	self.animator.speed = 1
	if index == "UI_CoreUI1009_1" then
		self.animator:Play("UI_CoreUI1009_1", 0, 0)
	elseif index == "UI_CoreUI1009_2" then
		self.animator:Play("UI_CoreUI1009_2", 0, 0)
	elseif index == "UI_CoreUI1009_3"then
		self.animator:Play("UI_CoreUI1009_3", 0, 0)
	elseif index == "UI_CoreUI1009_4" then
		self.animator:Play("UI_CoreUI1009_4", 0, 0)
	elseif index == "UI_CoreUI1009_out" then
		self.animator:Play("UI_CoreUI1009_out", 0, 0)
	end
end

function CoreUILogic1009:CoreState_out()
	self:SwitchCoreUIType(CoreUIType.ProcessState)
end

function CoreUILogic1009:Cache()
	Fight.Instance.objectPool:Cache(CoreUILogic1009,self)
end