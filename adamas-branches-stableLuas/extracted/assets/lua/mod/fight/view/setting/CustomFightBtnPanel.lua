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
        if v.type >= 1000 then goto continue end
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
        ::continue::
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
        if value.type < 1000 then
            if self[key.."_rect"] == nil then 
                goto continue
            end
            local pos = {}
            pos.x = value.posx
            pos.y = value.posy
            self[key.."_rect"].anchoredPosition = pos
            self[key.."_rect"].localScale = Vec3.New(value.scale,value.scale,value.scale)
            self[key.."Body_canvas"].alpha = value.alpha
            ::continue::
        end
    end
end

function CustomFightBtnPanel:AreRectsIntersect(rect1, rect2)
    local corners1 = {Vector3.zero, Vector3.zero, Vector3.zero, Vector3.zero}
    corners1 = UnityUtils.GetWorldCorners(rect1, corners1)
    local corners2 = {Vector3.zero, Vector3.zero, Vector3.zero, Vector3.zero}
    corners2 = UnityUtils.GetWorldCorners(rect2, corners2)
    local minx1,miny1,maxx1,maxy1,minx2,miny2,maxx2,maxy2
    local screenPoint1 = self.uiCamera:WorldToScreenPoint(corners1[0])
    minx1 = screenPoint1.x
    miny1 = screenPoint1.y
    maxx1 = screenPoint1.x
    maxy1 = screenPoint1.y
    for j = 1, 3 do
        screenPoint1 = self.uiCamera:WorldToScreenPoint(corners1[j])
        minx1 = screenPoint1.x < minx1 and screenPoint1.x or minx1
        miny1 = screenPoint1.y < miny1 and screenPoint1.y or miny1
        maxx1 = screenPoint1.x > maxx1 and screenPoint1.x or maxx1
        maxy1 = screenPoint1.y > maxy1 and screenPoint1.y or maxy1
    end
    local screenPoint2 = self.uiCamera:WorldToScreenPoint(corners2[0])
    minx2 = screenPoint2.x
    miny2 = screenPoint2.y
    maxx2 = screenPoint2.x
    maxy2 = screenPoint2.y
    for j = 1, 3 do
        screenPoint2 = self.uiCamera:WorldToScreenPoint(corners2[j])
        minx2 = screenPoint2.x < minx2 and screenPoint2.x or minx2
        miny2 = screenPoint2.y < miny2 and screenPoint2.y or miny2
        maxx2 = screenPoint2.x > maxx2 and screenPoint2.x or maxx2
        maxy2 = screenPoint2.y > maxy2 and screenPoint2.y or maxy2
    end

    if minx1 <= maxx2 and maxx1 >= minx2 and miny1 <= maxy2 and maxy1 >= miny2 then
        return true
    else
        return false
    end
end

function CustomFightBtnPanel:ClampUIPosition(rectTransform)
    local corners1 = {Vector3.zero, Vector3.zero, Vector3.zero, Vector3.zero}
    corners1 = UnityUtils.GetWorldCorners(rectTransform, corners1)

    local minx1,miny1,maxx1,maxy1
    local screenPoint1 = self.uiCamera:WorldToScreenPoint(corners1[0])
    minx1 = screenPoint1.x
    miny1 = screenPoint1.y
    maxx1 = screenPoint1.x
    maxy1 = screenPoint1.y
    for j = 1, 3 do
        screenPoint1 = self.uiCamera:WorldToScreenPoint(corners1[j])
        minx1 = screenPoint1.x < minx1 and screenPoint1.x or minx1
        miny1 = screenPoint1.y < miny1 and screenPoint1.y or miny1
        maxx1 = screenPoint1.x > maxx1 and screenPoint1.x or maxx1
        maxy1 = screenPoint1.y > maxy1 and screenPoint1.y or maxy1
    end

    minx1 = minx1 < 0 and minx1 or 0
    miny1 = miny1 < 0 and miny1 or 0
    maxx1 = maxx1 > Screen.width and maxx1 - Screen.width or 0
    maxy1 = maxy1 > Screen.height and maxy1 - Screen.height or 0

    rectTransform.anchoredPosition = {x = rectTransform.anchoredPosition.x - minx1 - maxx1, y = rectTransform.anchoredPosition.y - miny1 - maxy1}
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
        if value.type < 1000 then 
            if self[key.."_rect"] == nil then 
                goto continue
            end
            value.posx = self[key.."_rect"].anchoredPosition.x
            value.posy = self[key.."_rect"].anchoredPosition.y
            value.scale = self[key.."_rect"].localScale.x
            value.alpha = self[key.."Body_canvas"].alpha
            ::continue::
        end
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