CoreUILogic1007 = BaseClass("CoreUILogic1007", CoreUIBase)

local MaxProcess = 3
function CoreUILogic1007:OnInit()
	self.activeProcess = {}
	self.nextIdx = 1
	self.fxGo = self.ui.gameObject.transform:Find("fx")
	self.animator = self.fxGo:GetComponent(Animator)
	self.timeFxGo = self.ui.CoreUI1007_shijian.transform:Find("fx")
	self.timeAnimator = self.timeFxGo:GetComponent(Animator)
	self.percent = 0
	self.oldPercent = 0
	self.realPercent = 0
	self.devState = 1
	self.HaoJingIngTime = 0
	self.animatorNowTime = 0
	self.timeAnimatorNowTime = 0
	UtilsUI.SetAnimationEventCallBack(self.fxGo.gameObject, self:ToFunc("AnimationEventCallback"))
	UtilsUI.SetAnimationEventCallBack(self.timeFxGo.gameObject, self:ToFunc("AnimationEventCallback"))
end

local AnimationState = {
	In = 1,
	Out = 2,
	ChongNeng = 3,
	KeShiFang = 4,
	HaoJingIng = 5,
	Out2 = 6,
	Other = 999,
}

--被打断了 恢复下状态
function CoreUILogic1007:Resume(force)
	local info = self.animator:GetCurrentAnimatorStateInfo(0)
	if self.state == AnimationState.ChongNeng then
		if self.devState == 1 and (not info:IsName("CoreUI1007_chongneng1") or force) then
			self.animator:Play("CoreUI1007_chongneng1", 0, self.realPercent);
		elseif self.devState == 2 and (not info:IsName("CoreUI1007_chongneng2") or force)then
			self.animator:Play("CoreUI1007_chongneng2", 0, self.realPercent);
		end
	end

	if self.state == AnimationState.KeShiFang then
		if not info:IsName("CoreUI1007_keshifang") then
			self.animator:Play("CoreUI1007_keshifang", 0, 0)
		end
	end
	if self.state == AnimationState.HaoJingIng then
		if self.ui["CoreUI1007_shijian"].activeSelf == false then
			self:ShowEffect(1007, "CoreUI1007_shijian", true)
		end
		if not info:IsName("CoreUI1007_nengliang") then
			self.animator:Play("CoreUI1007_nengliang", 0, self.HaoJingIngTime)
		end
	end

	if self.state == AnimationState.Out2 then
		if not info:IsName("CoreUI1007_out2") then
			self:PlayOut2Animation()
		end
	end
end

function CoreUILogic1007:Update(entity)
	self:BaseFunc("Update", entity)
	if self.nowVisible == false then
		return
	end
	local animTime = self.animator.gameObject.activeInHierarchy == true and self.animator:GetCurrentAnimatorStateInfo(0).normalizedTime or 0
	local timeAnimTime = self.timeAnimator.activeInHierarchy == true and self.timeAnimator:GetCurrentAnimatorStateInfo(0).normalizedTime or 0
	self.animatorNowTime = animTime

	if self.state == AnimationState.HaoJingIng then
		if animTime ~= 0 then
			self.HaoJingIngTime = animTime
		end
		self.timeAnimatorNowTime = timeAnimTime
	end

	if self.state == AnimationState.Out2 then
		self.HaoJingIngTime = 0
		self.timeAnimatorNowTime = 0
		self:SetObjActive(self.ui["CoreUI1007_shijian"], false)
	end
	
	if self.state == AnimationState.ChongNeng and self.animatorNowTime >= self.realPercent then
		self.animator.speed = 0
	end
end

function CoreUILogic1007:AnimationEventCallback(state)
	if state == "In" and self.value and self.maxValue then
		-- self:UpdateAnimationPercent()
	elseif state == "TimeOut" then
		self:PlayOut2Animation()
		self:SetObjActive(self.ui["CoreUI1007_shijian"], false)
	elseif state == "Out2" then
        Fight.Instance.entityManager:CallBehaviorFun("CoreUI1007OnOut")
		self.state = AnimationState.ChongNeng
		self.oldPercent = 0
		self.realPercent = 0
		self.percent = 0
		self.HaoJingIngTime = 0
		self.animatorNowTime = 0
		self.timeAnimatorNowTime = 0
		self:SetRealPercentAndState()
		self:UpdateAnimationPercent()
		self:SetObjActive(self.ui["CoreUI1007_shijian"], false)
	elseif state == "NengLiangEnd" then
		self:SetObjActive(self.ui["CoreUI1007_shijian"], false)
		self:PlayOut2Animation()
	end
end

function CoreUILogic1007:UpdateVisible(visible, time, force)
	self:BaseFunc("UpdateVisible", visible, time, force)
	if not self.animator then
		return
	end
	if visible == false then
		self.nowVisible = false
		self:SetObjActive(self.ui["CoreUI1007_shijian"], false)
	else
		self.nowVisible = true
		self:Resume(false)
		self:UpdateAnimationPercent()
	end
end

function CoreUILogic1007:SetCorUIPercentDivide(...)
	self:BaseFunc("SetCorUIPercentDivide", ...)
	self:SetRealPercentAndState()
	self:Resume(true)
end

function CoreUILogic1007:UpdatePercent(value, maxValue)
	self.percent = value / maxValue
	self.value = value
	self.maxValue = maxValue
	if self.nowVisible == false then
		return
	end
	self:SetRealPercentAndState()
	self:UpdateAnimationPercent()
end

function CoreUILogic1007:SetRealPercentAndState()
	local total = 0
	for state, dev in ipairs(self.coreDev) do
		if total + dev >= self.percent then
			self.devState = state 
			self.realPercent = (self.percent - total) / dev
			break
		end
		total = total + dev
	end
end

function CoreUILogic1007:UpdateAnimationPercent()
	if self.state == AnimationState.KeShiFang 
	or self.state == AnimationState.HaoJingIng 
	or self.state == AnimationState.Out2 then
		return
	end
	if self.state == AnimationState.ChongNeng 
	and self.realPercent == 1 
	and self.HaoJingIngTime == 0 then
		self.state = AnimationState.KeShiFang
		self.animator.speed = 1
		self.animator:Play("CoreUI1007_keshifang", 0, 0);
		return
	end
	if self.oldPercent == self.realPercent
	and self.state == AnimationState.ChongNeng 
	and self.oldPercent ~= 0 then
		return
	end
	if not self.realPercent == self.oldPercent then
		return
	end
	self.state = AnimationState.ChongNeng
	self.animator.speed = self.oldPercent > 0 and 1 or 0 
	if self.devState == 1 then
		self.animator:Play("CoreUI1007_chongneng1", 0, self.oldPercent);
	elseif self.devState == 2 then
		self.animator:Play("CoreUI1007_chongneng2", 0, self.oldPercent);
	end
	self.oldPercent = self.realPercent
end

function CoreUILogic1007:ShowEffect(entity, index, active, speed, ...)
	local args = {...}
	if entity ~= 1007 and entity.entityId ~= 1007 then
		return
	end
	if index == "CoreUI1007_nengliang" then
		-- 策划逻辑保底
		if self.state == AnimationState.ChongNeng
		or self.state == AnimationState.Out2 then
			return
		end
		if active == true then
			self.animator.speed = speed
			local addtime = (self.HaoJingIngTime or 0) + (args and args[1] or 0)
			if self.state == AnimationState.HaoJingIng then
				self.animator:Play("CoreUI1007_nengliang", 0, addtime)
			else
				self.animator:Play("CoreUI1007_nengliang", 0, 0)
			end
			self.state = AnimationState.HaoJingIng
		else
			self:PlayOut2Animation()
		end

	elseif index == "CoreUI1007_shijian" then
		self:SetObjActive(self.ui["CoreUI1007_shijian"], active)
		if active == true then
			self.timeAnimator:Play("CoreUI1007_shijian", 0, self.timeAnimatorNowTime or 0)
		elseif active == false then
			self:PlayOut2Animation()
		end
		
	elseif index == "CoreUI1007_out2"then
		self:PlayOut2Animation()
	end
end

function CoreUILogic1007:PlayOut2Animation()
	self.animator.speed = 1
	self.animator:Play("CoreUI1007_out2", 0, 0)
	self.state = AnimationState.Out2
end

function CoreUILogic1007:Cache()
	Fight.Instance.objectPool:Cache(CoreUILogic1007,self)
end