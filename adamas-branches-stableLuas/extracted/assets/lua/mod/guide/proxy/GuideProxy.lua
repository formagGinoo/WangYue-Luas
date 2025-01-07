GuideProxy = BaseClass("GuideProxy",Proxy)

function GuideProxy:__init()

end

function GuideProxy:__InitProxy()
    self:BindMsg("guide_add")
    self:BindMsg("guide_init")
end

function GuideProxy:Send_guide_add(id)
	return { id = id }
end

function GuideProxy:Recv_guide_add(data)
	mod.GuideCtrl:OnRecv_GuideState(data)
end

function GuideProxy:Recv_guide_init(data)
	mod.GuideCtrl:OnRecv_FinishGuideIdList(data.id_list)
end