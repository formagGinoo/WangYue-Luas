CoreUILogic1008 = BaseClass("CoreUILogic1008", CoreUIBase)

local GradurationNum = 12

local CoreUIType = 
{
	ProcessState = 1,
	CoreState = 2,
}

function CoreUILogic1008:OnInit()
	self.coreStateRootAnimator = self.ui.CoreState:GetComponent(Animator)
	for i = 1, GradurationNum, 1 do
		self["coreState".. i .. "Animator"] = self.ui["Core".. i]:GetComponent(Animator)
	end
	UtilsUI.SetActive(self.ui.CoreState, false)
	UtilsUI.SetActive(self.ui.ProcessState, true)
	UtilsUI.SetHideCallBack(self.ui.CoreState_out, function()
		if not self.ui then
			return
		end
		UtilsUI.SetActive(self.ui.CoreState, false)
		UtilsUI.SetActive(self.ui.ProcessState, true)
		self:UpdatePercent(self.value, self.maxValue)
	end)
end

function CoreUILogic1008:CoreState_out()
	
end

function CoreUILogic1008:UpdatePercent(value, maxValue)
	self.type = self.type or CoreUIType.ProcessState
	self.value = value
	self.maxValue = maxValue
	self.percent = value / maxValue
	self.ui.Process_img.fillAmount = self.percent
	if self.type == CoreUIType.ProcessState then
		self:UpdateEffect("UI_CoreUI1008_kejihuo", self.percent == 1)
		self:UpdateEffect("UI_CoreUI1008_jindu", self.percent > 0)
		self:UpdateEffect("UI_CoreUI1008_zengjia", self.percent > 0)
		self:UpdateEffect("UI_CoreUI1008_xian", self.percent > 0)
        UnityUtils.SetAnchoredPosition(self.ui.UI_CoreUI1008_xian.transform, 5.47, -30 + self.percent * 56)
	end
	if self.type == CoreUIType.CoreState then
		for i = 1, GradurationNum, 1 do
			local active = 1 / GradurationNum * i <= (self.percent or 0)
			local info = self["coreState".. i .. "Animator"]:GetCurrentAnimatorStateInfo(0)
			if active then
				local nowActive = self.ui["Core" .. i].activeSelf
				UtilsUI.SetActive(self.ui["Core" .. i], active)
				if not nowActive  then
					self["coreState".. i .. "Animator"]:Play("Core_chuxian",0,0)
				end
				
				if info:IsName("Core_kong") or info:IsName("Core_xiaoshi")then
					self["coreState".. i .. "Animator"]:Play("Core_chuxian",0,0)
				end
			else
				if info:IsName("Core_kong") then
					UtilsUI.SetActive(self.ui["Core" .. i], false)
				end
				if info:IsName("Core_chuxian") or info:IsName("Core_moren") then
					self["coreState".. i .. "Animator"]:Play("Core_xiaoshi",0,0)
				end
			end
		end
	end
end


function CoreUILogic1008:SwitchCoreUIType(type)
	if self.type == type then
		return
	end
	if self.type == CoreUIType.CoreState then
		self:UpdateEffect("UI_CoreUI1008_kejihuo", false)
		self:UpdateEffect("UI_CoreUI1008_jindu", false)
		self:UpdateEffect("UI_CoreUI1008_zengjia", false)
	end

	self.type = type
	if type == CoreUIType.CoreState then
		UtilsUI.SetActive(self.ui.CoreState, true)
		UtilsUI.SetActive(self.ui.ProcessState, false)
		for i = 1, GradurationNum, 1 do
			local active = 1 / GradurationNum * i <= (self.percent or 0)
			UtilsUI.SetActive(self.ui["Core" .. i], active)
		end
	end
	if type == CoreUIType.ProcessState then
		self.coreStateRootAnimator:Play("CoreUI1008_guanbi",0,0)
	end
end

function CoreUILogic1008:Cache()
	Fight.Instance.objectPool:Cache(CoreUILogic1008,self)
end