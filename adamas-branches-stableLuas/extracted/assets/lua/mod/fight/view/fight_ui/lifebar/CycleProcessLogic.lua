CycleProcessLogic = BaseClass("CycleProcessLogic")

local Percent2Change = 0.25 --变色阈值
local Frame2Percent = 20 --白色条跟进帧数
local Frame2Hide = 40 --隐藏体力条帧数

function CycleProcessLogic:__init(parentUI, subStrengthBar,realUI, followUI, bgUI, lowBgUI,object, offset, normalFull, colors)
	self.parentUI = parentUI
	self.subStrengthBar = subStrengthBar
	self.realUI = realUI
	self.followUI = followUI
	self.bgUI = bgUI
	self.posOffset = offset
	self.lowBgUI =  lowBgUI
	self.object = object

	self.extraPercent = 0
	self.curPercent = normalFull and 1 or 0
	self.percent = normalFull and 1 or 0
	self.recodePercent = normalFull and 1 or 0
	self.step = Frame2Percent
	self.maxStep = Frame2Percent

	self.hideFrame = Frame2Hide
	self.normalFull = normalFull

	self.lowOutPlay = true
	self.lowInPlay = false
	self.maxCycleProcess = SystemConfig.GetCommonValue("MaxStamina").int_val
	self.effectUtils = {}
	local effectUtils = self.parentUI.transform:GetComponentsInChildren(EffectUtil, true)
	for j = 0, effectUtils.Length - 1 do
		table.insert(self.effectUtils, effectUtils[j])
	end

	self.nowState = CycleProcessLogic.ProcessState.Other
	self:BindUI()
	self:UpdateColor(colors)
	UtilsUI.SetActiveByPosition(self.object.UI_FightSystemPanel_haojin, false)
end

function CycleProcessLogic:BindUI()
	self.realUI_img = self.realUI:GetComponent(Image)
	self.followUI_img = self.followUI:GetComponent(Image)
	self.bgUI_img = self.bgUI:GetComponent(Image)
	self.parentUI_img = self.parentUI:GetComponent(Image)
	self.subStrengthBar_img = self.subStrengthBar:GetComponent(Image)
	self.parentUI_canvas = self.parentUI:GetComponent(CanvasGroup)
end

function CycleProcessLogic:UpdateColor(colors)
	self.colors = colors
	self.followUI_img.color = self.colors[5]
end

function CycleProcessLogic:UpdateEffectVisible(percent)
	for _, v in pairs(self.effectUtils) do
		v:SetKeywordValue("_mainAlpha", percent)
		v:SetKeywordValue("_BaseColor", Color(1, 1, 1, percent))
		v:SetKeywordValue("_MainColor", Color(1, 1, 1, percent))
	end
end
CycleProcessLogic.ProcessState = 
{
	CD = 1, -- 冷却期
	Other = 999,  -- 其他状态
}

function CycleProcessLogic:__delete()
end

function CycleProcessLogic:CalFollowDotPosition(percentage)
	local x, y
	local angle = math.rad(percentage * 3.6)
	local radius = 21 -- 圆的半径
	x = radius * math.sin(angle)
	y = radius * math.cos(angle)
    return x, y
end

function CycleProcessLogic:UpdateUI(percent)
	if percent > Percent2Change and self.lowOutPlay == true and percent == self.oldPercent then
		return
	elseif percent <= Percent2Change and self.lowInPlay == true and percent == self.oldPercent then
		return
	end
	UnityUtils.BeginSample("FightSystemPanel:UpdateUI")
	if percent == 0 and self.nowState == CycleProcessLogic.ProcessState.Other then
		BehaviorFunctions.StopFightUIEffect("UI_FightSystemPanel_buzu", "StrengthBar")
		BehaviorFunctions.PlayFightUIEffect("UI_FightSystemPanel_buzu", "StrengthBar")
		self.nowState = CycleProcessLogic.ProcessState.CD
	elseif percent > 0 then
		self.nowState = CycleProcessLogic.ProcessState.Other
	end

	--计算UI圈圈的位置和颜色
	local uiTempPercent = self.percent * self.maxPercent + (1 - self.maxPercent)
	if uiTempPercent ~= self.uiPercent then 
		self.uiPercent = uiTempPercent
		self.realUI_img.fillAmount = uiTempPercent - 0.02
		local x, y = self:CalFollowDotPosition((1 - uiTempPercent) * 100)
		UnityUtils.SetAnchoredPosition(self.object.FollowDot.transform, x, y)
		if self.nowFllowDotColor ~= (percent > Percent2Change) then 
			self.nowFllowDotColor = percent > Percent2Change
			self.object.FollowDot_img.color = percent > Percent2Change and self.colors[1] or self.colors[3]
		end
	end
	-- 体力条充满
	if percent == 1 + self.extraStaminaPercent then
		if not self.isShowFullEffect then
			BehaviorFunctions.StopFightUIEffect("UI_FightSystemPanel_man", "StrengthBar")
			BehaviorFunctions.PlayFightUIEffect("UI_FightSystemPanel_man", "StrengthBar")
			self.isShowFullEffect = true
		end
	else
		self.isShowFullEffect = false
	end
	local uiTempColor = (percent > Percent2Change and self.colors[1] or self.colors[3])
	if self.uiColor ~= uiTempColor then
		self.uiColor = uiTempColor
		self.realUI_img.color = uiTempColor
	end
	if percent > Percent2Change then
		UtilsUI.SetActive(self.bgUI, true)
		UtilsUI.SetActive(self.lowBgUI, false)
		if self.lowOutPlay == false then
			UtilsUI.SetActiveByPosition(self.object.UI_FightSystemPanel_haojin, true)
			self.object["UI_FightSystemPanel_haojin_donghua_anim"]:Play("UI_FightSystem_tilibuzu_out",0,0)
			self.lowInPlay = false
			self.lowOutPlay = true
		end
	else
		UtilsUI.SetActive(self.bgUI, false)
		UtilsUI.SetActive(self.lowBgUI, true)
		if self.lowInPlay == false then
			UtilsUI.SetActiveByPosition(self.object.UI_FightSystemPanel_haojin,true)
			self.object["UI_FightSystemPanel_haojin_donghua_anim"]:Play("UI_FightSystem_in",0,0)
			self.lowInPlay = true
			self.lowOutPlay = false
		end
	end
	self.oldPercent = percent
	UnityUtils.EndSample()
end


function CycleProcessLogic:UpdateMaxValue(maxValue)
	self.maxPercent = maxValue / self.maxCycleProcess
	self.subStrengthBar_img.fillAmount = self.maxPercent
end

function CycleProcessLogic:Update(entity, value, maxValue)
	if BehaviorFunctions.fight.pauseCount >= 1 then
		return
	end
	self.player = Fight.Instance.playerManager:GetPlayer()
	self.extraStaminaPercent = self.player.fightPlayer:GetValueAndMaxValue(FightEnum.PlayerAttr.MaxStaminaPercent)
	local percent = value / (maxValue / (1 + self.extraStaminaPercent))
	self.percent = percent
	self:UpdateUI(percent)
	if self.percent > Percent2Change then
		self.lowPercent = false
	end

	if (self.normalFull and self.percent >= (1 + self.extraStaminaPercent)) 
	or (not self.normalFull and self.percent == 0) then
		self.hideFrame = self.hideFrame - 1
		if self.hideFrame < 0 then
			self.hideAnim = true
		end
	else
		self.hideAnim = false
		self.hideFrame = Frame2Hide
		self.parentUI_canvas.alpha = 1
	end
	self.nowUIalpha = self.parentUI_canvas.alpha
	if self.nowUIalpha <= 0 then
		EventMgr.Instance:Fire(EventName.OnStrengthBarStateUpdate, false)
		return
	end
	self:UpdateCycleProgress()
	if not self.hideAnim then
		self:UpdateCyclePos(entity)
	elseif self.nowUIalpha > 0 then
		self.parentUI_canvas.alpha = self.nowUIalpha - 0.1
	end
end

function CycleProcessLogic:UpdateCycleProgress()
	if self.percent > self.curPercent then
		self.curPercent = self.percent
		self.recodePercent = self.percent
		self.followUI_img.fillAmount = self.percent * self.maxPercent + (1 - self.maxPercent)
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
		self.step = self.step + 5
	end

	if self.step <= self.maxStep then
		self.followUI_img.fillAmount = (self.curPercent + (self.step / self.maxStep) * (self.recodePercent - self.curPercent)) * self.maxPercent + (1 - self.maxPercent)
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
	if self.oldSp then
		if math.abs(self.oldSp.x - sp.x) < 50 and 
		math.abs(self.oldSp.y - sp.y) < 50 and 
		math.abs(self.oldSp.z - sp.z) < 50
		then
			return self.oldSp + self.posOffset
		end
	end
	self.oldSp = sp
	return sp + self.posOffset
end

function CycleProcessLogic:UpdateCyclePos(entity)
	local newSp = Vec3.Lerp(self.parentUI.transform.localPosition, self:GetCyclePos(entity), 0.05)
	UnityUtils.SetLocalPosition(self.parentUI.transform, newSp.x, newSp.y, 0)
end