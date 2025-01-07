GuideCtrl = BaseClass("GuideCtrl",Controller)

local DataGuideGroup = Config.DataGuide.data_guide

function GuideCtrl:__init()
	self.finishGuideIds = {}
	self.waitFinishGuideIds = {}
	self.notFinishedGuideIdList = {}
	
	self.guideInit = false
end

function GuideCtrl:Update()

end

function GuideCtrl:GetNotFinishGuideIdList()
	return self.notFinishedGuideIdList
end

function GuideCtrl:GuideInit()
	return self.guideInit
end

function GuideCtrl:CheckGuideFinish(groupId)
	return self.finishGuideIds[groupId] or self.waitFinishGuideIds[groupId]
end

function GuideCtrl:SendFinishGuideId(guideId)
	if self:CheckGuideFinish(guideId) then
		return 
	end
	
	self.waitFinishGuideIds[guideId] = true
	mod.GuideFacade:SendMsg("guide_add", guideId)
end

function GuideCtrl:OnRecv_GuideState(data)
	if data.error_code ~= 0 then
		LogError("OnRecv_GuideState:"..data.error_code)
		return
	end
	self.finishGuideIds[data.id] = true
	
	local idx = -1
	for i = 1, #self.notFinishedGuideIdList do
		if self.notFinishedGuideIdList[i] == data.id then
			idx = i
			break
		end
	end
	
	if idx ~= -1 then
		table.remove(self.notFinishedGuideIdList, idx)
	end
end

function GuideCtrl:OnRecv_FinishGuideIdList(data)
	self.finishGuideIds = {}
	for i = 1, #data do
		self.finishGuideIds[data[i]] = true
	end
	
	for k, _ in pairs(DataGuideGroup) do
		if not self.finishGuideIds[k] then
			table.insert(self.notFinishedGuideIdList, k)
		end
	end
	
	self.guideInit = true
end

function GuideCtrl:__delete()

end
