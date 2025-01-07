GmProxy = BaseClass("GmProxy", Proxy)

function GmProxy:__init()
end

function GmProxy:__InitProxy()
	self:BindMsg("gm_list")
	self:BindMsg("gm_exec")
end

function GmProxy:__InitComplete()
end

-- 29004
function GmProxy:Recv_gm_list(data)
	mod.GmCtrl:OnGetGmData(data.gm_list)
end

-- 29005
function GmProxy:Send_gm_exec(name, args)
	local data = {}
	data.gm_name = name
	data.args = args
	return data
end

-- 29006
function GmProxy:Recv_gm_exec(data)
	MsgBoxManager.Instance:ShowTextMsgBox(data.tips)
end