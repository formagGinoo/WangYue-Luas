AttrSubPanel = BaseClass("AttrSubPanel", Module)

local Idx2Setting = {
	[1] = {id = 1, title = "buff", pos = Vector3(-624, 232, 0), length = 180},
	[2] = {id = 2, title = TI18N("基础"), pos = Vector3(-624, 0, 0), length = 180},
	[3] = {id = 3, title = TI18N("属性"), pos = Vector3(346, 232, 0), length = 520},

}

local buffState2Desc =
{
	[FightEnum.EntityBuffState.None] = "无",
	[FightEnum.EntityBuffState.ImmuneDamage] = "免疫伤害",
	[FightEnum.EntityBuffState.ImmuneHit] = "免疫受击",
	[FightEnum.EntityBuffState.ImmuneCure] = "免疫治疗",
	[FightEnum.EntityBuffState.ImmuneForceMove] = "免疫强制位移",
	[FightEnum.EntityBuffState.ImmuneDie] = "免疫死亡",
	[FightEnum.EntityBuffState.ImmuneByCollision] = "不产生实体碰撞",
	[FightEnum.EntityBuffState.ImmuneToCollision] = "不受实体碰撞",
	[FightEnum.EntityBuffState.PauseEntityTime] = "暂停实体时间帧数",
	[FightEnum.EntityBuffState.PauseBehavior] = "暂停实体行为逻辑",
	[FightEnum.EntityBuffState.Stun] = "晕眩",
	[FightEnum.EntityBuffState.PauseTime] = "时停",
	[FightEnum.EntityBuffState.ImmuneAttackMagic] = "免疫子弹受击效果",
	[FightEnum.EntityBuffState.Penetrable] = "穿墙",
	[FightEnum.EntityBuffState.Levitation] = "浮空",
	[FightEnum.EntityBuffState.ImmuneHitRotate] = "免疫受击朝向",
	[FightEnum.EntityBuffState.ForceNormalHit] = "所有受击强制变为普通受击",
	[FightEnum.EntityBuffState.IgnoreCommonTimeScale] = "免疫全局速度",
	[FightEnum.EntityBuffState.ForbiddenImmuneHit] = "禁用免疫受击",
	[FightEnum.EntityBuffState.ImmuneBreakLieDown] = "免疫中断倒地",
	[FightEnum.EntityBuffState.ImmuneWorldCollision] = "不产生世界碰撞",
	[FightEnum.EntityBuffState.ImmuneDownDmg] = "免疫掉落伤害",
	[FightEnum.EntityBuffState.ImmuneStun] = "免疫眩晕",
	[FightEnum.EntityBuffState.ForceHitDown] = "强制击倒受击",
	[FightEnum.EntityBuffState.AbsoluteImmuneHit] = "绝对免疫受击",
}

function AttrSubPanel:__init(main, parent, color)
	self.main = main
	self.panelList = {}
	
	for i = 1, #Idx2Setting do
		self.panelList[i] = {}
		
		local panel = {}
		panel.setting = Idx2Setting[i]
		panel.gameObject = GameObject.Instantiate(main.SubPanel)
		panel.transform = panel.gameObject.transform
		UtilsUI.GetContainerObject(panel.transform, panel)

		panel.gameObject:SetActive(true)
		panel.transform:SetParent(parent)
		panel.transform.localScale = Vector3(1, 1, 1)
		panel.transform.localPosition = panel.setting.pos
		panel.InfoScroll_rect.sizeDelta = Vector2(panel.InfoScroll_rect.sizeDelta.x, panel.setting.length)
		
		self.panelList[i].panel = panel
		self.panelList[i].content = {}
		self.panelList[i].panelIndex = i
	end
	
	self.color = color
	self.curSelectedTagIndex = {1, 2, 3}

	self.attrSort = {
		[1] = {name = TI18N("基础属性"), clamp = {1, 5}, show = false, attr = {}},
		[2] = {name = TI18N("其他属性"), clamp = {6, 20}, show = false, attr = {}},
		[3] = {name = TI18N("基础加成属性"), clamp = {21, 24}, show = false, attr = {}},
		[4] = {name = TI18N("进阶属性"), clamp = {25, 50}, show = false, attr = {}},
		[5] = {name = TI18N("元素属性"), clamp = {51, 100}, show = false, attr = {}},
		[6] = {name = TI18N("部位属性"), clamp = {101, 200}, show = false, attr = {}},
		[7] = {name = TI18N("技能属性"), clamp = {201, 210}, show = false, attr = {}},
		[8] = {name = TI18N("角色自定义能量"), clamp = {211, 999}, show = false, attr = {}},
		[9] = {name = TI18N("当前属性"), clamp = {1001, 9999}, show = false, attr = {}},
	}
	
	local tempAttrType = {}
	for k, v in pairs(EntityAttrsConfig.AttrType) do
		table.insert(tempAttrType, v)
	end
	table.sort(tempAttrType)
	
	local sortIndex = 1
	local attrSort = self.attrSort[sortIndex]
	for k, v in pairs(tempAttrType) do
		while v > attrSort.clamp[2] do
			sortIndex = sortIndex + 1
			attrSort = self.attrSort[sortIndex]
		end
		table.insert(attrSort.attr, v)
	end
	
	self:InitPanel()
	self.panelList[1].panel.SearchArea:SetActive(false)
	self.panelList[2].panel.SearchArea:SetActive(false)
end

function AttrSubPanel:__delete()
end

function AttrSubPanel:Reload(entity, closeCallback)
	self.entity = entity
	self.closeCallback = closeCallback
	for k, v in pairs(self.panelList) do
		v.panel.gameObject:SetActive(true)
		v.panel.InfoPanel.transform.localPosition = Vector3(0, 0, 0)
		self:HideInfo(k)
	end
	
	self.main.ChangePanel:SetActive(false)
	
	self:UpdateInfoPanel()
end

function AttrSubPanel:_GetEnumName(enum, value)
	for k, v in pairs(enum) do
		if value == v then
			return k
		end
	end
	return "NotFound"
end

function AttrSubPanel:_GetActiveChildCount(parent)
	local count = 0
	for i = 1, parent.childCount do
		if parent:GetChild(i - 1).gameObject.activeSelf then
			count = count + 1
		end
	end
	return count
end

function AttrSubPanel:InitPanel()
	self.main.CloseChangeBtn_btn.onClick:AddListener(function() self.main.ChangePanel:SetActive(false) end)
	
	for i = 1, #self.panelList do
		local panel = self.panelList[i].panel
		
		local dragBehaviour = panel.Title:AddComponent(UIDragBehaviour)

		local onPointerDown = function(data)
			local _, pos = RectTransformUtility.ScreenPointToLocalPointInRectangle(panel.transform.parent, data.position, ctx.UICamera)
			self.offset = Vector3(pos.x, pos.y, 0)  - panel.transform.localPosition
		end
		dragBehaviour.onPointerDown = onPointerDown

		local onDrag = function(data)
			self.drag = true
			local _, pos = RectTransformUtility.ScreenPointToLocalPointInRectangle(panel.transform.parent, data.position, ctx.UICamera)
			panel.transform.localPosition = Vector3(pos.x, pos.y, 0) - self.offset
		end
		dragBehaviour.onDrag = onDrag
		
		local onPointerUp = function(data)
			if not self.drag then
				self:OnClickTag(i)
			end
			self.drag = false
		end
		dragBehaviour.onPointerUp = onPointerUp
		
		panel.TitleText_txt.text = panel.setting.title
		panel.TitleText_txt.color = self.color
		
		local callback = function()
			panel.SearchInput.transform:GetComponent(TMP_InputField).text = ""
			panel.SearchInput:SetActive(not panel.SearchInput.activeSelf)
		end
		
		panel.SearchBtn_btn.onClick:AddListener(callback)
		
		local sizeDragBehaviour = panel.DragArea:AddComponent(UIDragBehaviour)

		local onDrag = function(data)
			local a = panel.InfoScroll.transform:GetComponent(RectTransform).sizeDelta
			panel.InfoScroll.transform:GetComponent(RectTransform).sizeDelta = a + Vector2(data.delta.x, -data.delta.y)
		end
		sizeDragBehaviour.onDrag = onDrag
	end
end

function AttrSubPanel:OnClickTag(index)
	local panel = self.panelList[index].panel
	if self.curSelectedTagIndex[index] then
		panel.InfoScroll:SetActive(false)
		self.curSelectedTagIndex[index] = nil
		self:HideInfo(index)
	else
		panel.InfoScroll:SetActive(true)
		panel.InfoPanel.transform.localPosition = Vector3(0, 0, 0)
		self.curSelectedTagIndex[index] = index
		self:UpdateInfoPanel()
	end
end

function AttrSubPanel:IsPanelSearch(tagIndex)
	local panelIns = self.panelList[tagIndex]
	local txt = panelIns.panel.SearchInput:GetComponent(TMP_InputField).text
	if txt ~= self.tempSearch then
		self:HideInfo(tagIndex)
	end
	self.tempSearch = txt
	if txt and txt ~= "" then
		if string.sub(txt, 1, 1) == "#" then
			return true, nil, tonumber(string.sub(txt, 2))
		else
			return true, txt, nil
		end
	end
	return false
end

function AttrSubPanel:UpdateInfoPanel()
	if not self.entity then
		return 
	end
	
	if self.curSelectedTagIndex[1] then
		self:UpdateBuffData(1)
	end
	
	if self.curSelectedTagIndex[2] then
		self:UpdateBaseData(2)
	end
	
	if self.curSelectedTagIndex[3] then
		local isSearch, s, i = self:IsPanelSearch(3)
		if isSearch then
			self:UpdateAttrDataBySearch(3, s, i)
		else
			self:UpdateAttrData(3)
		end
	end
	
	self:UpdatePanelSize()
end

function AttrSubPanel:UpdateBuffData(tagIndex)
	local index = 1
	if self.entity.buffComponent then
		local buffStates = self.entity.buffComponent.buffStates
		local content = ""
		for k, v in pairs(buffStates) do
			if v ~= 0 then
				content = buffState2Desc[k]
				self:AddContent(tagIndex, index, content)
				index = index + 1
			end
		end
			
		for k, v in pairs(self.entity.buffComponent.buffs) do
			content = string.format("%.0f->%.0f[%.0f]: %.0f", v.relEntity.instanceId, v.buffId, v.level or 1, math.ceil(v.durationFrame))
			self:AddContent(tagIndex, index, content)
			index = index + 1
		end
	end
	self:HideInfo(tagIndex, index)
end

function AttrSubPanel:UpdateBaseData(tagIndex)
	local index = 1
	if self.entity.stateComponent then
		local state = self.entity.stateComponent:GetState()
		if state == FightEnum.EntityState.Move then
			local subState = self.entity.stateComponent.stateFSM:GetSubMoveState()
			state = string.format("%s[%s]", self:_GetEnumName(FightEnum.EntityState, state), self:_GetEnumName(FightEnum.EntityMoveSubState, subState))
		elseif state == FightEnum.EntityState.Jump then
			local subState = self.entity.stateComponent.stateFSM.states[state].jumpFSM.curState
			state = string.format("%s[%s]", self:_GetEnumName(FightEnum.EntityState, state), self:_GetEnumName(FightEnum.EntityJumpState, subState))
		elseif state == FightEnum.EntityState.Climb then
			local subState = self.entity.stateComponent.stateFSM.states[state].climbFSM.curState
			state = string.format("%s[%s]", self:_GetEnumName(FightEnum.EntityState, state), self:_GetEnumName(FightEnum.EntityClimbState, subState))
		elseif state == FightEnum.EntityState.Swim then
			local subState = self.entity.stateComponent.stateFSM.states[state].swimFSM.curState
			state = string.format("%s[%s]", self:_GetEnumName(FightEnum.EntityState, state), self:_GetEnumName(FightEnum.EntitySwimState, subState))
		elseif state == FightEnum.EntityState.Idle then
			local subState = self.entity.defaultIdleType or FightEnum.EntityIdleType.LeisurelyIdle
			state = string.format("%s[%s]", self:_GetEnumName(FightEnum.EntityState, state), self:_GetEnumName(FightEnum.EntityIdleType, subState))
		elseif state == FightEnum.EntityState.Hit then
			local subState = self.entity.stateComponent.stateFSM.states[state].hitFSM.curState
			state = string.format("%s[%s]", self:_GetEnumName(FightEnum.EntityState, state), self:_GetEnumName(FightEnum.EntityHitState, subState))
		elseif state == FightEnum.EntityState.Skill then
			local subState = tostring(self.entity.skillComponent.skillId)
			state = string.format("%s[%s]", self:_GetEnumName(FightEnum.EntityState, state), subState)
		else
			state = self:_GetEnumName(FightEnum.EntityState, state)
		end
		local content = string.format("当前状态：%s", state)
		self:AddContent(tagIndex, index, content)
		index = index + 1
	end

	if self.entity.customFSMComponent then
		local content = string.format("HFSM：%s", self.entity.customFSMComponent:GetCurStateName())
		self:AddContent(tagIndex, index, content)
		index = index + 1
	end
	
	if self.entity.animatorComponent then
		local animName = string.format("%s[%s]", self.entity.animatorComponent:GetAnimName(), self.entity.animatorComponent.animationName)
		local content = string.format("当前动画：%s", animName)
		self:AddContent(tagIndex, index, content)
		index = index + 1
	end
	
	if self.entity.timeComponent then
		local content = string.format("时间缩放：%0.2f", self.entity.timeComponent:GetTimeScale())
		self:AddContent(tagIndex, index, content)
		index = index + 1
	end
	
	if self.entity.transformComponent then
		local pos = self.entity.transformComponent.position
		local content = string.format("逻辑坐标：%0.2f, %0.2f, %0.2f", pos.x, pos.y, pos.z)
		local contentIndex = index
		local callback = function()
			self:OnChangePos(tagIndex, contentIndex, pos.x, pos.y, pos.z)
		end
		self:AddContent(tagIndex, index, content, callback)
		index = index + 1
		
		local rot = self.entity.transformComponent.rotation:ToEulerAngles()
		local height = self.entity.transformComponent:GetRealPositionY()
		content = string.format("旋转和实际高度：%0.2f, %0.2f", rot.y, height)
		self:AddContent(tagIndex, index, content)
		index = index + 1
		
		local lastPos = self.entity.transformComponent.lastPosition
		local speed = Vector3.Distance(pos, lastPos)
		content = string.format("移动速度：%0.2f", speed / FightUtil.deltaTimeSecond)
		self:AddContent(tagIndex, index, content)
		index = index + 1
	end
	
	self:HideInfo(tagIndex, index)
end

function AttrSubPanel:UpdateAttrData(tagIndex)
	if not self.entity.attrComponent then
		return 
	end
	
	local index = 1
	for i = 1, #self.attrSort do
		local attrSortItem = self.attrSort[i]
		local callback = function()
			attrSortItem.show = not attrSortItem.show
			self:HideInfo(tagIndex)
		end
		local showName = attrSortItem.show and "+"..attrSortItem.name or attrSortItem.name
		local content = string.format("<color=#%s>%s</color>", ColorUtility.ToHtmlStringRGB(self.color), showName)
		self:AddContent(tagIndex, index, content, callback)
		index = index + 1
		if attrSortItem.show then
			if i < #self.attrSort then
				for j = 1, #attrSortItem.attr do
					local k = attrSortItem.attr[j]
					if k < EntityAttrsConfig.AttrType.CurTypeBegin then
						local val = self.entity.attrComponent:GetValue(k)
						if val and val ~= 0 then
							local v = self:_GetEnumName(EntityAttrsConfig.AttrType, k)
							content = string.format("[%.0f]%s: %0.2f", k, v, val)
							self:AddContent(tagIndex, index, content)
							index = index + 1
						end
					end
				end
			else
				for k, v in pairs(EntityAttrsConfig.AttrType2MaxType) do
					local val, maxVal = self.entity.attrComponent:GetValueAndMaxValue(k)
					if maxVal and maxVal ~= 0 then
						content = string.format("[%.0f]%s: %.0f/%.0f", k, self:_GetEnumName(EntityAttrsConfig.AttrType, k), math.ceil(val), maxVal)
						local contentIndex = index
						local callback = function()
							self:OnChange(tagIndex, contentIndex, k, maxVal)
						end
						self:AddContent(tagIndex, index, content, callback)
						index = index + 1
					end
				end
				if self.entity.elementStateComponent then
					local elementState = self.entity.elementStateComponent.elementState
					for k, v in pairs(elementState) do
						content = string.format("[ET]%s: %s/%s", self:_GetEnumName(FightEnum.ElementType, k), v.count, v.maxCount)
						local contentIndex = index
						local callback = function()
							self:OnChangeElementAccu(tagIndex, contentIndex, k, v.maxCount)
						end
						self:AddContent(tagIndex, index, content, callback)
						index = index + 1
					end
				end
			end
		end
	end
	self:HideInfo(tagIndex, index)
end

function AttrSubPanel:UpdateAttrDataBySearch(tagIndex, keyWord, id)
	if not self.entity.attrComponent then
		return 
	end
	local index = 1
	for k, v in pairs(EntityAttrsConfig.AttrType) do
		if (keyWord and string.find(string.lower(k), string.lower(keyWord))) or 
			(id and id == v) then
			local val = self.entity.attrComponent:GetValue(v)
			if val and val ~= 0 then
				local content = string.format("[%.0f]%s: %0.2f", v, k, val)
				self:AddContent(tagIndex, index, content)
				index = index + 1
			end
		end
	end
	self:HideInfo(tagIndex, index)
end

local cellSize = 30
function AttrSubPanel:UpdatePanelSize()
	for k, v in pairs(self.panelList) do
		local cellNum = self:_GetActiveChildCount(v.panel.InfoPanel.transform)
		v.panel.InfoPanel_rect.sizeDelta = Vector2(v.panel.InfoPanel_rect.sizeDelta.x, cellNum * cellSize)
	end
end

function AttrSubPanel:HideInfo(tagIndex, start)
	local panelIns = self.panelList[tagIndex]
	
	local startIndex = start or 1
	for i = startIndex, #panelIns.content do
		panelIns.content[i].gameObject:SetActive(false)
		panelIns.content[i].btn.onClick:RemoveAllListeners()
	end
end

function AttrSubPanel:AddContent(tagIndex, index, content, callback)
	local panelIndex = self.panelList[tagIndex].panelIndex
	local contentIns = self.panelList[tagIndex].content[index]
	if not contentIns then
		local panel = self.panelList[tagIndex].panel
		local textParent = panel.InfoPanel.transform
		local contentObj = GameObject.Instantiate(panel.ContentText)
		contentObj.transform:SetParent(textParent)
		contentObj.transform.localScale = Vector3(1, 1, 1)
		
		contentIns = {}
		contentIns.gameObject = contentObj
		contentIns.txt = UtilsUI.GetText(contentObj.transform)
		contentIns.btn = contentObj.transform:GetComponent(Button)
		self.panelList[tagIndex].content[index] = contentIns
	end
	if not contentIns.gameObject.activeInHierarchy then
		contentIns.gameObject:SetActive(true)
		contentIns.btn.onClick:RemoveAllListeners()
		if callback then contentIns.btn.onClick:AddListener(callback) end
	end
	
	contentIns.txt.text = content
end

function AttrSubPanel:SetChangePanelPos(tagIndex, index)
	self.main.ChangePanel:SetActive(true)
	self.main.ChangePanel.transform:SetAsLastSibling()
	
	local panelIns = self.panelList[tagIndex]
	local panelAnchoredPosition = panelIns.panel.transform:GetComponent(RectTransform).anchoredPosition
	local textObjAnchoredPosition = panelIns.content[index].gameObject.transform:GetComponent(RectTransform).anchoredPosition

	local textObjPos = panelAnchoredPosition + textObjAnchoredPosition + panelIns.panel.InfoPanel_rect.anchoredPosition
	local changePanelPos = Vector2(panelAnchoredPosition.x, textObjPos.y - 15)
	
	self.main.ChangePanel_rect.anchoredPosition = changePanelPos
end

function AttrSubPanel:SetPanelEvent(tipText, text, event)
	self.main.AttrTypeText_txt.text = tipText
	local input = self.main.AttrTypeInput.transform:GetComponent(TMP_InputField)
	input.text = text
	
	self.main.ChangeBtn_btn.onClick:RemoveAllListeners()
	self.main.ChangeBtn_btn.onClick:AddListener(event)
end

function AttrSubPanel:OnChange(tagIndex, index, attrType, maxVal)
	if not self.entity.attrComponent then return end
	self:SetChangePanelPos(tagIndex, index)
	
	local onChange = function()
		local input = self.main.AttrTypeInput.transform:GetComponent(TMP_InputField)
		local num = tonumber(input.text)
		
		if num then
			self.entity.attrComponent:SetValue(attrType, num)
		end
		self.main.ChangePanel:SetActive(false)
	end
	self:SetPanelEvent(self:_GetEnumName(EntityAttrsConfig.AttrType, attrType), maxVal, onChange)
end

function AttrSubPanel:OnChangePos(tagIndex, index, x, y, z)
	self:SetChangePanelPos(tagIndex, index)

	local onChange = function()
		local input = self.main.AttrTypeInput.transform:GetComponent(TMP_InputField)
		local pos = StringHelper.Split(input.text, ",")
		if #pos == 3 then
			self.entity.transformComponent:SetPosition(tonumber(pos[1]), tonumber(pos[2]), tonumber(pos[3]))
		end
		self.main.ChangePanel:SetActive(false)
	end
	
	self:SetPanelEvent("逗号隔开", string.format("%0.2f,%0.2f,%0.2f", x, y, z), onChange)
end

function AttrSubPanel:OnChangeElementAccu(tagIndex, index, elementType, maxVal)
	if not self.entity.elementStateComponent then return end
	self:SetChangePanelPos(tagIndex, index)

	local onChange = function()
		local input = self.main.AttrTypeInput.transform:GetComponent(TMP_InputField)
		local num = tonumber(input.text)

		if num then
			BehaviorFunctions.SetEntityElementStateAccumulation(self.entity.instanceId, self.entity.instanceId, elementType, num)
		end
		self.main.ChangePanel:SetActive(false)
	end
	
	self:SetPanelEvent(self:_GetEnumName(FightEnum.ElementType, elementType), maxVal, onChange)
end

function AttrSubPanel:OnChangeClose()
	self.main.ChangePanel:SetActive(false)
end

function AttrSubPanel:OnClose()
	if self.closeCallback then
		self.closeCallback()
	end
	
	self.entity = nil
	for k, v in pairs(self.panelList) do
		v.panel.gameObject:SetActive(false)
	end
end