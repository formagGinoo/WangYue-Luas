CycleProcessLogic = BaseClass("CycleProcessLogic")

local Percent2Change = 0.25 --变色阈值
local Frame2Percent = 20 --白色条跟进帧数
local Frame2Hide = 40 --隐藏体力条帧数

function CycleProcessLogic:__init(parentUI, realUI, followUI, bgUI, offset, normalFull, colors)
	self.parentUI = parentUI
	self.realUI = realUI
	self.followUI = followUI
	self.bgUI = bgUI
	self.posOffset = offset
	
	self.curPercent = normalFull and 1 or 0
	self.percent = normalFull and 1 or 0
	self.recodePercent = normalFull and 1 or 0
	self.step = Frame2Percent
	self.maxStep = Frame2Percent

	self.hideFrame = Frame2Hide
	self.normalFull = normalFull
	
	self:UpdateColor(colors)
	self:BindUI()
end

function CycleProcessLogic:BindUI()
	self.realUI_img = self.realUI:GetComponent(Image)
	self.followUI_img = self.followUI:GetComponent(Image)
	self.bgUI_img = self.bgUI:GetComponent(Image)
	
	self.parentUI_canvas = self.parentUI:GetComponent(CanvasGroup)
end

function CycleProcessLogic:UpdateColor(colors)
	self.colors = colors
end

function CycleProcessLogic:__delete()
end

function CycleProcessLogic:UpdateUI(percent)
	self.realUI_img.fillAmount = percent

	self.realUI_img.color = percent > Percent2Change and self.colors[1] or self.colors[3]
	self.bgUI_img.color = percent > Percent2Change and self.colors[2] or self.colors[4]
end

function CycleProcessLogic:Update(entity, value, maxValue)
	self.percent = value / maxValue
	if self.percent > Percent2Change then
		self.lowPercent = false
	end

	self:UpdateUI(self.percent)

	if (self.normalFull and self.percent == 1) or (not self.normalFull and self.percent == 0) then
		self.hideFrame = self.hideFrame - 1
		if self.hideFrame < 0 then
			self.hideAnim = true
		end
	else
		self.hideAnim = false
		self.hideFrame = Frame2Hide
		self.parentUI_canvas.alpha = 1
	end

	self:UpdateCyclePos(entity)
	if not self.hideAnim then
		self:UpdateCycleProgress()
	else
		self.parentUI_canvas.alpha = self.parentUI_canvas.alpha - 0.1
	end
end

function CycleProcessLogic:UpdateCycleProgress()
	if self.percent > self.curPercent then
		self.curPercent = self.percent
		self.recodePercent = self.percent
		self.followUI_img.fillAmount = self.percent
		return
	end

	if self.recodePercent == self.curPercent and self.recodePercent ~= self.percent then
		self.step = 0
		self.maxStep = Frame2Percent
		self.recodePercent = self.percent

		if self.lowPercent then
			self.curPercent = self.percent
		elseif self.percent < Percent2Change then --策划说，体力小于阈值时白色快速过渡
			self.lowPercent = true
			self.maxStep = Frame2Percent / 2
		end
	end

	if self.lowPercent then --体力过少快速过渡到真实体力位置
		self.recodePercent = self.percent
	elseif self.percent < Percent2Change then
		self.step = self.step * 2
	end

	if self.step <= self.maxStep then
		self.followUI_img.fillAmount = self.curPercent + (self.step / self.maxStep) * (self.recodePercent - self.curPercent)
		self.step = self.step + 1
	else
		self.curPercent = self.recodePercent
	end
end

local TempCyclePos = Vec3.New()
function CycleProcessLogic:GetCyclePos(entity)
	local height = entity.collistionComponent.config.Height
	TempCyclePos:Set(0, height * 0.5, 0)
	TempCyclePos:Add(entity.transformComponent.position)
	local sp = UtilsBase.WorldToUIPointBase(TempCyclePos.x, TempCyclePos.y, TempCyclePos.z)
	return sp + self.posOffset
end

function CycleProcessLogic:UpdateCyclePos(entity)
	local sp = self:GetCyclePos(entity)
	local newSp = Vec3.Lerp(self.parentUI.transform.localPosition, sp, 0.15)
	UnityUtils.SetLocalPosition(self.parentUI.transform, newSp.x, newSp.y, 0)
end