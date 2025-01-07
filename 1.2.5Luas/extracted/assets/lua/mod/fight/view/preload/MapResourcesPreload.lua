
MapResourcesPreload = BaseClass("MapResourcesPreload")

function MapResourcesPreload:__init(x, y, z, callBack)
	self.pos_x = x
	self.pos_y = y
	self.pos_z = z
	self.resLoadHelp = FightResuorcesLoadHelp.New(self:ToFunc("CellLoad"))
	self.callBack = callBack
end

function MapResourcesPreload:DoPreload(saveUI)
	if not saveUI then
		WindowManager.Instance:CloseAllWindow(true)
	end

	ctx.LoadingPage:Show(TI18N("加载地图资源(0%)"))

	local callBack = function (progress)
		Log("MapResourcesPreload End")
		if progress == 1 then
			if not saveUI then
				WindowManager.Instance:SetWindowVisible("FightMainUIView", true, nil, nil, true)
				EventMgr.Instance:Fire(EventName.AdventureChange)
			end
			
			ctx.LoadingPage:Hide()
			if self.callBack then
				self.callBack()
			end
		else
			local enterProgress = progress * 100
			self:UpdateProgress(enterProgress)
		end
	end

	local terrainInitCallback = function()
		Log("LoadTerrian End")
		SceneUnitManager.Instance:DoEnterLoad(callBack, Fight.Instance.clientFight.clientMap.transform, self.pos_x, self.pos_y, self.pos_z, AssetBatchLoader.UseLocalRes)
	end
	Log("LoadTerrian Start")
	Fight.Instance.clientFight.clientMap:LoadTerrian(self.pos_x, self.pos_y, self.pos_z, terrainInitCallback)
end

function MapResourcesPreload:UpdateProgress(progress)
	ctx.LoadingPage:Progress(string.format(TI18N("加载地图资源(%0.1f%%)"), tostring(progress)), progress)
end
