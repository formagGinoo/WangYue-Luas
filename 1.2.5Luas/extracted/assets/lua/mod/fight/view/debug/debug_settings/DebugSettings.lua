DebugSettings = BaseClass("DebugSettings",BaseView)

function DebugSettings:__init()
	self:SetAsset("Prefabs/UI/FightDebug/DebugSettings.prefab")
	self:SetParent(UIDefine.canvasRoot.transform)
end

function DebugSettings:__Show()
	local resolutions = Screen.resolutions;
	local height = resolutions[0].height
	local width = resolutions[0].width
	Log("height "..height)
	Log("width "..width)
end

function DebugSettings:__Hide()
	
end

function DebugSettings:__CacheObject()
	local canvas = self.gameObject:GetComponent(Canvas)
	if canvas ~= nil then
		canvas.pixelPerfect = false
		canvas.overrideSorting = true
	end
	
	self.DPIConfirm_btn.onClick:AddListener(self:ToFunc("DPIConfirmFun"))
	self.DPIReset_btn.onClick:AddListener(self:ToFunc("DPIResetFun"))
	
	self.GrassHide_btn.onClick:AddListener(self:ToFunc("GrassHideFun"))
	self.GrassShow_btn.onClick:AddListener(self:ToFunc("GrassShowFun"))
	
	self.MSAAClose_btn.onClick:AddListener(self:ToFunc("MSAACloseFun"))
	self.MSAAOpen_btn.onClick:AddListener(self:ToFunc("MSAAOpenFun"))
	
	self.MSAA2Close_btn.onClick:AddListener(self:ToFunc("MSAA2CloseFun"))
	self.MSAA2Open_btn.onClick:AddListener(self:ToFunc("MSAA2OpenFun"))
	
	self.PPClose_btn.onClick:AddListener(self:ToFunc("PPCloseFun"))
	self.PPOpen_btn.onClick:AddListener(self:ToFunc("PPOpenFun"))

	self.UnitConfirm_btn.onClick:AddListener(self:ToFunc("UnitConfirmFun"))

	self.BlockConfirm_btn.onClick:AddListener(self:ToFunc("BlockConfirmFun"))
	
	self.TranportConfirm_btn.onClick:AddListener(self:ToFunc("TranportConfirmFun"))

	self.Lod0DistConfirm_btn.onClick:AddListener(self:ToFunc("Lod0DistConfirmFun"))
	self.Lod1DistConfirm_btn.onClick:AddListener(self:ToFunc("Lod1DistConfirmFun"))

	self.FightResume_btn.onClick:AddListener(self:ToFunc("FightResumeFun"))
	self.FightPause_btn.onClick:AddListener(self:ToFunc("FightPauseFun"))

	self.DepthClose_btn.onClick:AddListener(self:ToFunc("DepthCloseFun"))
	self.DepthOpen_btn.onClick:AddListener(self:ToFunc("DepthOpenFun"))

	self.GrassConfirm_btn.onClick:AddListener(self:ToFunc("GrassConfirmFun"))

	self.ASDistConfirm_btn.onClick:AddListener(self:ToFunc("ASDistConfirmFun"))
end

function DebugSettings:DPIConfirmFun()
	local txt = self.ScaleInput:GetComponent(TMP_InputField).text
	local scale = tonumber(txt)
	if scale then
		CustomUnityUtils.SetRenderScale(scale)
	end
	
end

function DebugSettings:DPIResetFun()
	
end

function DebugSettings:GrassHideFun()
	if not self.Grass then
		self.Grass = GameObject.Find("New Grass Tools")
		if not UtilsBase.IsNull(self.Grass) then
			self.Grass.gameObject:SetActive(false)
		end
	end
end

function DebugSettings:GrassShowFun()
	if self.Grass then
		self.Grass.gameObject:SetActive(true)
	end
end

function DebugSettings:MSAACloseFun()
	CustomUnityUtils.EnableMsaa(false)
end

function DebugSettings:MSAAOpenFun()
	CustomUnityUtils.EnableMsaa(true)
end

function DebugSettings:MSAA2CloseFun()
	CustomUnityUtils.EnableMsaa2(false)
end

function DebugSettings:MSAA2OpenFun()
	CustomUnityUtils.EnableMsaa2(true)
end

function DebugSettings:PPCloseFun()
	CustomUnityUtils.EnablePP(false)
end

function DebugSettings:PPOpenFun()
	CustomUnityUtils.EnablePP(true)
end

local transposList = 
{
	{1452.189,74.3466,664.3354},
	{1150.054,100.6702,692.8478},
	{944.0073,116.8569,699.5995},
	{734.6196,162.3622,914.4797},
	{612, 175.754, 1054},
	{481.8138, 57.9, 1469.732},
}

local cameraRotateList =
{
	{5.53, -72},
	{5.53, -72},
	{-5.23, -84.288},
	{-2, -39},
	{0, -28.125},
	{483.2075, 60.3,1465}
}

function DebugSettings:TranportConfirmFun()
	local txt = self.TranportInput:GetComponent(TMP_InputField).text
	local idx = tonumber(txt)
	if idx then
		local posInfo = transposList[idx]
		BehaviorFunctions.Transport(10020001,posInfo[1], posInfo[2], posInfo[3])
		local rotateInfo = cameraRotateList[idx]
		local camera = CameraManager.Instance.states[FightEnum.CameraState.Operating].camera
		local cvcamera = camera:GetComponent(Cinemachine.CinemachineVirtualCamera)
		cvcamera:ForceCameraPosition(camera.position, Quaternion.Euler(rotateInfo[1], rotateInfo[2], 0))
	end
end


function DebugSettings:UnitConfirmFun()
	local flag = 0
	for i = 1, 3 do 
		if self["UnitTog"..i.."_tog"].isOn then
			flag = flag | (1 << (i-1))
		end
	end
	print("UnitConfirmFun flag "..flag)
	SceneUnitManager.Instance.DebugDrawUnitType = flag
end

function DebugSettings:BlockConfirmFun()
	local flag = 0
	for i = 1, 3 do 
		if self["BlockTog"..i.."_tog"].isOn then
			flag = flag | (1 << (i-1))
		end
	end
	print("BlockConfirmFun flag "..flag)
	CustomUnityUtils.SetShowBlockCondLod(flag)
end

function DebugSettings:Lod0DistConfirmFun()
	local txt = self.Lod0DistInput:GetComponent(TMP_InputField).text
	local distance = tonumber(txt)
	if distance then
		SceneUnitManager.Instance.DebugLod0Distance = distance
	end
end

function DebugSettings:Lod1DistConfirmFun()
	local txt = self.Lod1DistInput:GetComponent(TMP_InputField).text
	local distance = tonumber(txt)
	if distance then
		SceneUnitManager.Instance.DebugLod1Distance = distance
	end
end


function DebugSettings:FightPauseFun()
	print("FightPauseFun")
	Fight.Instance:Pause()
end

function DebugSettings:FightResumeFun()
	print("FightResumeFun")
	Fight.Instance:Resume()
end

function DebugSettings:DepthCloseFun()
	CustomUnityUtils.CameraDepthOpen(false)
end

function DebugSettings:DepthOpenFun()
	CustomUnityUtils.CameraDepthOpen(true)
end

function DebugSettings:GrassConfirmFun()
	local txt = self.GrassInput:GetComponent(TMP_InputField).text
	local list = self:SplitParam(txt, ",")
	CustomUnityUtils.SetGrassLod(tonumber(list[1]), tonumber(list[2]))
end

function DebugSettings:ASDistConfirmFun()
	local txt = self.ASDistInput:GetComponent(TMP_InputField).text
	local distance = tonumber(txt)
	if distance then
		SceneUnitManager.Instance:SetLoadBoundSize(distance)
	end
end

function DebugSettings:SplitParam(string,sep)
	local list={}
	if string == nil then
		return nil
	end
	string.gsub(string,'[^'..sep..']+',function (w)
			table.insert(list,w)
		end)
	return list
end
	
function DebugSettings:__delete()

end

function DebugSettings:__Create()
end

