ToggleTab = BaseClass("ToggleTab", BaseLayout)

local NAME_TOGGLE_TEXT = "Text"

local COLOR_LIGHT  = Color(40/255, 42/255, 48/255) 
local COLOR_DIME = Color(1,1,1)

function ToggleTab:__init()
    self.toggleObj = nil
    self.pageToggles = nil
    self.callback = nil
    self.pageToggleTexts = nil
end

function ToggleTab:InitByToggles(toggleList, callback, defaultSelect, useTextColor)
    self:Dispose()
    self:_InitByToggles(toggleList, callback, defaultSelect, useTextColor)
end

function ToggleTab:SetToggleByIndex(index, ...)
    self:_OnToggle(index, ...)
end

function ToggleTab:GetToggleByIndex( index )
    return self.toggles and self.toggles[index]
end

function ToggleTab:Dispose()
    if self.pageToggles then
        for _, toggle in pairs(self.pageToggles) do
            toggle.onValueChanged:RemoveAllListeners()
        end
    end

    self.toggleObj = nil
    self.pageToggles = nil
    self.callback = nil
    self.pageToggleTexts = nil
end

function ToggleTab:_InitByToggles(toggleList, callback, defaultSelect, useTextColor)
    if useTextColor == nil then
        self.useTextColor = true
    else
        self.useTextColor = useTextColor
    end

    self.toggles = toggleList
    self.pageCount = #self.toggles
    self.callback = callback
    self.curSelect = defaultSelect or 1
    self.preSelect = -1
    self.pageToggles = {}
    self.pageToggleTexts = {}
    for i = 1, self.pageCount do
        self.pageToggles[i] = self.toggles[i]
        self:_SetToggleFun(self.toggles[i], function(is_on)
            if is_on then
                self:_OnToggle(i)
            end
        end)

        if self.useTextColor then
            local parent = self.pageToggles[i].gameObject.transform
            local child = parent:Find(NAME_TOGGLE_TEXT)
            local text
            if child then
                text = UtilsUI.GetText(child)
            end
            if text == nil then
                self.useTextColor = false
            else
                self.pageToggleTexts[i] = text
            end
        end
    end

    if self.useTextColor then
        self.toggleOncolor = COLOR_LIGHT
        self.toggleOffcolor = COLOR_DIME
    end

    for i = 1, self.pageCount do
        local toggle = self.pageToggles[i]
        local text = self.pageToggleTexts[i]
        if i == self.curSelect then
            toggle.isOn = true
            toggle.interactable = false
            if self.useTextColor and text then
                text.color = self.toggleOncolor
            end
        else
            toggle.isOn = false
            toggle.interactable = true
            if self.useTextColor and text then
                text.color = self.toggleOffcolor
            end
        end
    end
end

function ToggleTab:SetColor(light, dime)
    if light then
        self.toggleOncolor = light
    end
    if dime then
        self.toggleOffcolor = dime
    end

    for i = 1, self.pageCount do
        local toggle = self.pageToggles[i]
        local text = self.pageToggleTexts[i]
        if i == self.curSelect then
            toggle.isOn = true
            toggle.interactable = false
            if self.useTextColor and text then
                text.color = self.toggleOncolor
            end
        else
            toggle.isOn = false
            toggle.interactable = true
            if self.useTextColor and text then
                text.color = self.toggleOffcolor
            end
        end
    end
end

function ToggleTab:_OnToggle(curIndex, ...)
    if curIndex == -1 then
        for _, toggle in pairs(self.pageToggles) do
            toggle.isOn = false
            toggle.interactable = true
        end
        self.curSelect = -1
        self.preSelect = -1
        return
    end

    if curIndex == self.curSelect then
        return
    end

    for index, toggle in pairs(self.pageToggles) do
        toggle.isOn = curIndex == index
        toggle.interactable = curIndex ~= index
    end

    self.preSelect = self.curSelect
    self.curSelect = curIndex

    if self.useTextColor then
        if self.pageToggleTexts[self.preSelect] then
            self.pageToggleTexts[self.preSelect].color = self.toggleOffcolor
        end

        if self.pageToggleTexts[self.curSelect] then
            self.pageToggleTexts[self.curSelect].color = self.toggleOncolor
        end
    end

    if self.callback then
        local curToggle = self.pageToggles[self.curSelect]
        local preToggle = self.pageToggles[self.preSelect]
        self.callback(self.curSelect, self.preSelect, curToggle, preToggle, ...)
    end
end

function ToggleTab:_SetToggleFun(toggle, callback)
    toggle.onValueChanged:RemoveAllListeners()
    toggle.onValueChanged:AddListener(callback)
end
