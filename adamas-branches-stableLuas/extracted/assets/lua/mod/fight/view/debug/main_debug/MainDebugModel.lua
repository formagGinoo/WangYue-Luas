MainDebugModel = BaseClass("MainDebugModel",BaseModel)
MainDebugModel.NotClear = true

function MainDebugModel:__init()
	self.window = nil

	self.login_visable = false
	
	self.custom = {
		quick = {},
		groupTop = {},
		subTop = {},
		tag = 1,
	}
	
	self:LoadCustomConfig()
	
	self.debugGlobalCache = {}
	DebugClientInvoke.SetCache(self.debugGlobalCache)
	DebugPlanInvoke.SetCache(self.debugGlobalCache)
	DebugTestInvoke.SetCache(self.debugGlobalCache)
end

function MainDebugModel:__delete()
	if self.window ~= nil then
		self.window:DeleteMe()
		self.window = nil
		self.login_visable = false
	end
	self.debugGlobalCache = {}
end

function MainDebugModel:InitMainUI()
	if self.window == nil then
		self.window = DebugMainView.New(self)
		--self.window = MainDebugView.New(self)
		self.window:SetParent(UIDefine.canvasRoot.transform)
		self.window:Show()
		self.login_visable = true
	else
		self.window:Show()
	end
end

function MainDebugModel:CloseMainUI()
	if self.window ~= nil then
		self.window:Destroy()
		self.window = nil
		self.login_visable = false
	end
end

function MainDebugModel:CheckConfigVaild(list)
	local removeList = {}
	local notVaild = false
	for tag, idList in pairs(list) do
		TableUtils.ClearTable(removeList)
		for i = 1, #idList do
			local config = DebugConfig.GetDataConfig(tag, idList[i])
			if not config then
				table.insert(removeList, i)
				notVaild = true
			end
		end
		
		for i = #removeList, 1, -1 do
			table.remove(idList, removeList[i])
		end
		
		if #idList == 0 then
			list[tag] = nil
		end
	end
	
	if notVaild then
		self:SaveCustomConfig()
	end
end

function MainDebugModel:ConvertStrToCustom(str)
	local ret = {}
	if str == "" then
		return ret
	end
	
	if str == "-1" then
		return {
			[3] = {101, 102, 103, 104, 105, 106, 107, 108, 109, 110, 111, 112, 113, 114, 115, 119}	
		}
	end
	
	local tagStr = StringHelper.Split(str, "|")
	for i = 1, #tagStr do
		if tagStr[i] ~= "" then
			local data = StringHelper.Split(tagStr[i], ",")
			if #data > 0 then
				local tag = tonumber(data[1])
				ret[tag] = {}
				for j = 2, #data do
					if data[j] ~= "" then
						table.insert(ret[tag], tonumber(data[j]))
					end
				end
			end
		end
	end
	
	return ret
end

function MainDebugModel:LoadCustomConfig()
	self.custom.tag = PlayerPrefs.GetInt("DebugTag", 3)
	
	self.custom.quick = self:ConvertStrToCustom(PlayerPrefs.GetString("DebugQuick", "-1"))
	self.custom.groupTop = self:ConvertStrToCustom(PlayerPrefs.GetString("DebugGroupTop", ""))
	self.custom.subTop = self:ConvertStrToCustom(PlayerPrefs.GetString("DebugSubTop", ""))
	
	self:CheckConfigVaild(self.custom.quick)
	self:CheckConfigVaild(self.custom.groupTop)
	self:CheckConfigVaild(self.custom.subTop)
end

function MainDebugModel:ConvertCustomToStr(list)
	local str = ""
	for tag, idList in pairs(list) do
		str = str..tag..","
		for _, id in pairs(idList) do
			str = str..id..","
		end
		str = str.."|"
	end
	
	return str
end

function MainDebugModel:SaveCustomConfig()
	PlayerPrefs.SetInt("DebugTag", self.custom.tag)
	
	local quickStr = self:ConvertCustomToStr(self.custom.quick)
	if quickStr then
		PlayerPrefs.SetString("DebugQuick", quickStr)
	end
	
	local groupTopStr = self:ConvertCustomToStr(self.custom.groupTop)
	if groupTopStr then
		PlayerPrefs.SetString("DebugGroupTop", groupTopStr)
	end
	
	local subTopStr = self:ConvertCustomToStr(self.custom.subTop)
	if subTopStr then
		PlayerPrefs.SetString("DebugSubTop", subTopStr)
	end
end

function MainDebugModel:InCustom(list, tag, id)
	local tagGroup = list[tag]
	if not tagGroup then
		return false
	end
	
	for i = 1, #tagGroup do
		if tagGroup[i] == id then
			return true
		end
	end
	
	return false
end

function MainDebugModel:InCustomQuickList(tag, id)
	return self:InCustom(self.custom.quick, tag, id)
end

function MainDebugModel:InCustomGroupTopList(tag, id)
	return self:InCustom(self.custom.groupTop, tag, id)
end

function MainDebugModel:InCustomSubTopList(tag, id)
	return self:InCustom(self.custom.subTop, tag, id)
end

function MainDebugModel:UpdateCustomList(list, tag, id, set)
	if set then
		local tagGroup = list[tag]
		if not tagGroup then
			list[tag] = {}
			tagGroup = list[tag]
		end
		
		for i = 1, #tagGroup do
			if tagGroup[i] == id then
				return false
			end
		end
		
		table.insert(tagGroup, id)
		self:SaveCustomConfig()
		return true
	else
		local tagGroup = list[tag]
		if not tagGroup then
			return false
		end
		
		for i = 1, #tagGroup do
			if tagGroup[i] == id then
				table.remove(tagGroup, i)

				if #tagGroup == 0 then
					list[tag] = nil
				end
				self:SaveCustomConfig()
				return true
			end
		end
		
		return false
	end
end

function MainDebugModel:UpdateQuickList(tag, id, set)
	local suc = self:UpdateCustomList(self.custom.quick, tag, id, set)
	if suc and self.window and self.login_visable then
		self.window:RefreshScroll()
	end
	return suc
end

function MainDebugModel:UpdateGroupToppingList(tag, id, set)
	return self:UpdateCustomList(self.custom.groupTop, tag, id, set)
end

function MainDebugModel:UpdateSubToppingList(tag, id, set)
	return self:UpdateCustomList(self.custom.subTop, tag, id, set)
end

function MainDebugModel:SetLastSelectedTag(tag)
	self.custom.tag = tag
	self:SaveCustomConfig()
end

function MainDebugModel:GetLastSelectedTag()
	return self.custom.tag
end

function MainDebugModel:GourpingAndSort(tag, data)
	local ret = {}
	for k, v in pairs(data) do
		local group = ret[v.group_id]
		if not group then
			ret[v.group_id] = {}
			ret[v.group_id].desc = v.group_desc
			ret[v.group_id].top = self:InCustomGroupTopList(tag, v.group_id)
			group = ret[v.group_id]
		end
		
		if (not group.desc or group.desc == "") and v.desc ~= "" then
			group.desc = v.group_desc
		end
		local data = {}
		data.config = v
		data.top = self:InCustomSubTopList(tag, v.id)
		
		group[k] = data
	end
	
	--for _, v in pairs(ret) do
		--table.sort(v, function(a, b) return a.top and not b.top end)
	--end
	
	--table.sort(ret, function(a, b) return a.top and not b.top end)
	
	return ret
end

function MainDebugModel:GetDebugConfig(tag)
	local data = DebugConfig.GetDataConfigByTag(tag)
	if not data then
		return
	end
	
	return self:GourpingAndSort(tag, data)
end

function MainDebugModel:GetQuickConfig()
	--local ret = {}
	
	--local quick = self.custom.quick
	--if not quick or not next(quick) then
		--return ret
	--end
	
	--for tag, idList in pairs(quick) do
		--for _, v in pairs(idList) do
			--table.insert(ret, DebugConfig.GetDataConfig(tag, v))
		--end
	--end
	
	--return ret
	return self.custom.quick
end