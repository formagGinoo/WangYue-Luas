

TimeLine = BaseClass("TimeLine")

function TimeLine:__init()

end

function TimeLine:Play(timeLineId, startCallBack, endCallBack, parent)
	self.parent = parent
	self.startCallBack = startCallBack
	self.endCallBack = endCallBack 
	self:LoadAssets(timeLineId)
end

function TimeLine:LoadAssets(timeLineId)
	self.timeLineConfig = StoryConfig.GetStoryConfig(timeLineId)

	self.loadList = {
		{ path = "Prefabs/StoryTimeline/Prefabs/"..timeLineId..".prefab", type = AssetType.Prefab },
	}

    if next(self.loadList) then
        self.assertLoader = AssetMgrProxy.Instance:GetLoader("TimeLineLoader")
        self.assertLoader:AddListener(self:ToFunc("OnResLoad"))
        self.assertLoader:LoadAll(self.loadList)
    end
end

function TimeLine:OnResLoad()
    self.timeLineObject = self.assertLoader:Pop(self.loadList[1].path)
    if self.parent then
    	self.timeLineObject:SetParent(self.parent)
    else
    	GameObject.DontDestroyOnLoad(self.timeLineObject)
    end

    self.playableDirector = self.timeLineObject:GetComponent(PlayableDirector)
    self.playableDirector:Play()

    if self.endCallBack then
    	CustomUnityUtils.SetPlayableEndEvent(self.playableDirector, self:ToFunc("OnTimeLineEnd"))
    end

    if self.assertLoader then
        AssetMgrProxy.Instance:CacheLoader(self.assertLoader)
        self.assertLoader = nil
    end

    if self.startCallBack then
    	self.startCallBack()
    	self.startCallBack = nil
    end
end

function TimeLine:OnTimeLineEnd()
     if self.timeLineConfig.fade_out then
        CurtainManager.Instance:FadeIn(true, 1)
        self.endFuncTimer =  LuaTimerManager.Instance:AddTimer(1, 1, function ()
            self:_End()
        end)
    else
        self:_End()
    end
end

function TimeLine:_End()
	if self.endCallBack then
		self.endCallBack()
		self.endCallBack = nil
	end

	if self.timeLineConfig.fade_out then
		CurtainManager.Instance:FadeOut(1)
	end
end
