CustomFightBtnPanel = BaseClass("CustomFightBtnPanel", BasePanel)

local BtnConfig = {}

local BtnDict = {}

local OverlapTable = {
    ["Joystick"] = {count = 0},
	["HP"] = {count = 0},
    ["RoleGroup"] = {count = 0},
	["J"] = {count = 0},
	["L"] = {count = 0},
	["K"] = {count = 0},
	["O"] = {count = 0},
	["I"] = {count = 0},
	["R"] = {count = 0},
	["X"] = {count = 0},
	["JR"] = {count = 0},
	["SW"] = {count = 0},
}

function CustomFightBtnPanel:__init(parent)
    self:SetAsset("Prefabs/UI/Fight/CustomFightBtnPanel.prefab")
	self.selectBox = nil
	self.selectBtn = nil
    self.isSettingOpen = true
end

function CustomFightBtnPanel:__BindListener()
	self.SizeSlider_sld.onValueChanged:AddListener(self:ToFunc("OnValueChanged_SizeSlider"))
	self.TransparencySlider_sld.onValueChanged:AddListener(self:ToFunc("OnValueChanged_TransparencySlider"))

	self.SaveBtn_btn.onClick:AddListener(self:ToFunc("SaveConfig"))
	self.ReSetBtn_btn.onClick:AddListener(self:ToFunc("InitPlane"))
    self.ShowBtn_btn.onClick:AddListener(self:ToFunc("OnClickShowBtn"))
    self.CloseBtn_btn.onClick:AddListener(self:ToFunc("OnClickCloseBtn"))

    self.CommonModeBtn_btn.onClick:AddListener(self:ToFunc("ChangeToCommonMode"))
    self.CustomModeBtn_btn.onClick:AddListener(self:ToFunc("ChangeToCustomMode"))

    self.Type1Btn_btn.onClick:AddListener(self:ToFunc("OnClickType1"))
    self.Type2Btn_btn.onClick:AddListener(self:ToFunc("OnClickType2"))

	self:BindBtn("Joystick")
	self:BindBtn("J")
	self:BindBtn("L")
	self:BindBtn("K")
	self:BindBtn("O")
	self:BindBtn("I")
	self:BindBtn("R")
	self:BindBtn("X")
	self:BindBtn("JR")
	self:BindBtn("SW")
	self:BindBtn("HP")
    self:BindBtn("RoleGroup")
end

function CustomFightBtnPanel:__CacheObject()
	self:SetCacheMode(UIDefine.CacheMode.destroy)
end

function CustomFightBtnPanel:__Create()

end

function CustomFightBtnPanel:__BindEvent()

end

function CustomFightBtnPanel:__delete()
    self.mainUI = nil
	self.skillPanel = nil
    self.FightFormationPanel = nil
    self.FightInfoPanel = nil
    self.FightJoyStickPanel = nil
	self.uiCamera = nil
end

function CustomFightBtnPanel:__Show()
	self:GetConfig()
	self.MinX = - self.BG_rect.rect.width/2
    self.MaxX = self.BG_rect.rect.width/2
    self.MinY = - self.BG_rect.rect.height/2
    self.MaxY = self.BG_rect.rect.height/2

    self.mainUI = WindowManager.Instance:GetWindow("FightMainUIView")
	self.skillPanel = self.mainUI.panelList["FightNewSkillPanel"]
    self.FightFormationPanel = self.mainUI.panelList["FightFormationPanel"]
    self.FightInfoPanel = self.mainUI.panelList["FightInfoPanel"]
    self.FightJoyStickPanel = self.mainUI.panelList["FightJoyStickPanel"]
	self.uiCamera = ctx.UICamera

    self:OpenSetting()
end

function CustomFightBtnPanel:__Hide()

end

function CustomFightBtnPanel:__ShowComplete()

end

function CustomFightBtnPanel:BeginDrag()
	
end

function CustomFightBtnPanel:Drag(btnname,data)
	local delta = Vec3.New(data.delta.x, data.delta.y,0)
    local anchoredPos = self[btnname.."_rect"].anchoredPosition + delta
	
    self[btnname.."_rect"].anchoredPosition = anchoredPos
	self:ClampUIPosition(self[btnname.."_rect"])
	self:CheckOverlap(btnname)
end

function CustomFightBtnPanel:EndDrag(data)
    
end

function CustomFightBtnPanel:Down(btnname,data)
    if self.selectBox and self.selectBox == self[btnname .. "SelectedBox"] then return end
	if self.selectBox then self.selectBox:SetActive(false) end
    self[btnname .. "SelectedBox"]:SetActive(true)
	
	self.selectBox = self[btnname .. "SelectedBox"]
	self.selectBtn = btnname
    self:OpenSetting()
	self:ShowSetting()
end

function CustomFightBtnPanel:Up(data)
    
end

function CustomFightBtnPanel:BindBtn(btnname)
	local DragBehaviour = self[btnname]:GetComponent(UIDragBehaviour) or self[btnname]:AddComponent(UIDragBehaviour)
	local onBeginDrag = function(data)
		self:BeginDrag(btnname,data)
	end
	DragBehaviour.onBeginDrag = onBeginDrag
	local cbOnDrag = function(data)
		self:Drag(btnname,data)
	end
	DragBehaviour.onDrag = cbOnDrag
	local cbOnEndDrag = function(data)
		self:EndDrag(data)
	end
	DragBehaviour.onEndDrag = cbOnEndDrag
	local onDown = function(data)
		self:Down(btnname,data)
	end
	DragBehaviour.onPointerDown = onDown
	local onUp = function(data)
		self:Up(data)
	end
	DragBehaviour.onPointerUp = onUp
end

function CustomFightBtnPanel:CheckOverlap(btnname)
	local rect1 = self[btnname.."_rect"]
	local rect2
	for k, v in pairs(BtnDict) do
		if (BtnDict[btnname].type >= 100 and v.type ~= BtnDict[btnname].type)
		 or (k ~= btnname and (v.type == BtnDict[btnname].type or v.type >= 100)) then 
			rect2 = self[k.."_rect"]
			if self:AreRectsIntersect(rect1, rect2) then
				if OverlapTable[btnname][k] == nil or OverlapTable[btnname][k] == false then 
					OverlapTable[btnname][k] = true
					OverlapTable[k][btnname] = true
					OverlapTable[btnname].count = OverlapTable[btnname].count + 1
					OverlapTable[k].count = OverlapTable[k].count + 1
					self[k .. "OverlapBox"]:SetActive(true)
				end
			else
				if OverlapTable[btnname][k] == true then 
					OverlapTable[btnname][k] = false
					OverlapTable[k][btnname] = false
					OverlapTable[btnname].count = OverlapTable[btnname].count - 1
					OverlapTable[k].count = OverlapTable[k].count - 1
				end
				if OverlapTable[k].count == 0 then 
					self[k .. "OverlapBox"]:SetActive(false)
				end
			end
		end
	end
	if OverlapTable[btnname].count > 0 then 
		self[btnname .. "OverlapBox"]:SetActive(true)
	else
		self[btnname .. "OverlapBox"]:SetActive(false)
	end
end

function CustomFightBtnPanel:ResetOverlapTable()
    for _, v in pairs(OverlapTable) do
        v.count = 0
    end
end

function CustomFightBtnPanel:ChangeConfig(type)
    self.type = type
    BtnConfig.ChoseType = type
    BtnDict = BtnConfig[tostring(type)]
    self:InitPlane()
end

function CustomFightBtnPanel:InitPlane()
    self:ResetOverlapTable()
    for key,value in pairs(BtnDict) do
		local pos = {}
		pos.x = value.posx
		pos.y = value.posy
		self[key.."_rect"].anchoredPosition = pos
		self[key.."_rect"].localScale = Vec3.New(value.scale,value.scale,value.scale)
		self[key.."Body_canvas"].alpha = value.alpha
	end
end

function CustomFightBtnPanel:AreRectsIntersect(rect1, rect2)
    local rect1MinX = rect1.anchoredPosition.x - rect1.pivot.x * rect1.sizeDelta.x * rect1.localScale.x
    local rect1MaxX = rect1MinX + rect1.sizeDelta.x * rect1.localScale.x
    local rect1MinY = rect1.anchoredPosition.y - rect1.pivot.y * rect1.sizeDelta.y * rect1.localScale.y
    local rect1MaxY = rect1MinY + rect1.sizeDelta.y * rect1.localScale.y

    local rect2MinX = rect2.anchoredPosition.x - rect2.pivot.x * rect2.sizeDelta.x * rect2.localScale.x
    local rect2MaxX = rect2MinX + rect2.sizeDelta.x * rect2.localScale.x
    local rect2MinY = rect2.anchoredPosition.y - rect2.pivot.y * rect2.sizeDelta.y * rect2.localScale.y
    local rect2MaxY = rect2MinY + rect2.sizeDelta.y * rect2.localScale.y

    if rect1MaxX < rect2MinX or rect1MinX > rect2MaxX then
        return false
    end

    if rect1MaxY < rect2MinY or rect1MinY > rect2MaxY then
        return false
    end

    return true
end

function CustomFightBtnPanel:ClampUIPosition(rectTransform)
    local clampedPosition = {}

    local rectWidth = rectTransform.rect.width * rectTransform.localScale.x
    local rectHeight = rectTransform.rect.height * rectTransform.localScale.y

    local function Clamp(value, min, max)
        if value < min then
            return min
        elseif value > max then
            return max
        else
            return value
        end
    end

    clampedPosition.x = Clamp(rectTransform.anchoredPosition.x, (rectWidth/2) + self.MinX, self.MaxX - (rectWidth/2))
    clampedPosition.y = Clamp(rectTransform.anchoredPosition.y, (rectHeight/2) + self.MinY, self.MaxY - (rectHeight/2))

    rectTransform.anchoredPosition = clampedPosition
end

function CustomFightBtnPanel:ShowSetting()
	self.SizeSlider_sld.value = self[self.selectBtn.."_rect"].localScale.x
	self.TransparencySlider_sld.value = self[self.selectBtn.."Body_canvas"].alpha
end

function CustomFightBtnPanel:OnValueChanged_SizeSlider()
    if self.selectBtn then 
        local newSccle = Vec3.New(self.SizeSlider_sld.value,self.SizeSlider_sld.value,self.SizeSlider_sld.value)
        self[self.selectBtn.."_rect"].localScale = newSccle
        self:ClampUIPosition(self[self.selectBtn.."_rect"])
        self:CheckOverlap(self.selectBtn)
    end
end

function CustomFightBtnPanel:OnValueChanged_TransparencySlider()
    if self.selectBtn then
        self[self.selectBtn.."Body_canvas"].alpha = self.TransparencySlider_sld.value
    end
end

function CustomFightBtnPanel:OnClickShowBtn()
    if self.isSettingOpen then 
        self:CloseSetting()
    else
        self:OpenSetting()
    end
end

function CustomFightBtnPanel:OnClickCloseBtn()
    PanelManager.Instance:ClosePanel(self)
end

function CustomFightBtnPanel:ChangeToCommonMode()
    self:ChangeConfig(1)
    if self.selectBox then
        self.selectBox:SetActive(false)
    end
    self.selectBox = nil
    self.selectBtn = nil
    self.CommonMask:SetActive(true)
    self.CommonPart:SetActive(true)
    self.CustomPart:SetActive(false)
end

function CustomFightBtnPanel:ChangeToCustomMode()
    self:ChangeConfig(3)
    self.CommonMask:SetActive(false)
    self.CommonPart:SetActive(false)
    self.CustomPart:SetActive(true)
end

function CustomFightBtnPanel:OnClickType1()
    self:ChangeConfig(1)
end

function CustomFightBtnPanel:OnClickType2()
    self:ChangeConfig(2)
end

function CustomFightBtnPanel:CloseSetting()
    self.isSettingOpen = false
    self.Setting_rect.anchoredPosition = {x = self.Setting_rect.anchoredPosition.x, y = self.MaxY + self.Setting_rect.rect.height/2}
end

function CustomFightBtnPanel:OpenSetting()
    self.isSettingOpen = true
    self.Setting_rect.anchoredPosition = {x = self.Setting_rect.anchoredPosition.x, y = self.MaxY - self.Setting_rect.rect.height/2}
end

function CustomFightBtnPanel:CheckCanSave()
    for _, v in pairs(OverlapTable) do
        if v.count > 0 then 
            return false
        end
    end
    return true
end

function CustomFightBtnPanel:SaveConfig()
    if not self:CheckCanSave() then 
        MsgBoxManager.Instance:ShowTips(TI18N("按键重叠，保存失败！"), 1)
        return 
    end
	for key,value in pairs(BtnDict) do
		value.posx = self[key.."_rect"].anchoredPosition.x
		value.posy = self[key.."_rect"].anchoredPosition.y
		value.scale = self[key.."_rect"].localScale.x
		value.alpha = self[key.."Body_canvas"].alpha
	end
    Fight.Instance.fightBtnManager:SetFightBtn(self.type)
    Fight.Instance.fightBtnManager:SaveConfig()
    MsgBoxManager.Instance:ShowTips(TI18N("保存成功！"), 1)
end

function CustomFightBtnPanel:GetConfig()
	BtnConfig = Fight.Instance.fightBtnManager.BtnConfig
    self.type = self.type or BtnConfig.ChoseType
    BtnDict = BtnConfig[tostring(self.type)]
    self:InitPlane()
end