
local RtLayer = 13
local ModelCount = 0
local ModelViewPrefab = "Prefabs/UI/Common/ModelRtView.prefab"
local ScreenFactor = math.max(Screen.width / 1280, Screen.height / 720)
local _floor = math.floor
local DataHero = Config.DataHeroMain.Find
local DataUiModel = Config.DataUiModel.data_ui_model

ModelRtView = BaseClass("ModelRtView")

function ModelRtView:__init(uiView, uiImage, noDrag, callback)
	self.uiView = uiView
	self.uiImage = uiImage
    self.uiImage.enabled = false
    self.noDrag = noDrag
	self.callback = callback
	self:Load()
end

function ModelRtView:Load()
    self.sceneRoomPath = "Prefabs/Scene/scene_UI_P/scene_UI_P.prefab"
    local resList = {
        {path = ModelViewPrefab, type = AssetType.Prefab},
        {path = self.sceneRoomPath, type = AssetType.Prefab},
    }   

    local callback = function()
        if self.cancel then
            self.assetLoader:DeleteMe()
            self.assetLoader = nil
        else
        	ModelCount = ModelCount + 1
            self:Create()
        end
    end
    self.assetLoader = AssetBatchLoader.New("ModelRtView"..ModelCount)
    self.assetLoader:AddListener(callback)
    self.assetLoader:LoadAll(resList)
end

function ModelRtView:Create()
    self.uiImage.enabled = true
	self.modelRoot = self.assetLoader:Pop(ModelViewPrefab)
    GameObject.DontDestroyOnLoad(self.modelRoot)
	self.modelRoot.transform:SetPosition(1000 + ModelCount * 10, 0, 0)
	self.contentRoot = self.modelRoot.transform:Find("ContentRoot")
	self.cameraRoot = self.modelRoot.transform:Find("CameraRoot")
	self.cameraComp = self.cameraRoot:GetComponent(Camera)
	self.uiRawImage = self.uiImage:GetComponent(RawImage)

    if self.cameraSetPosition then
        self.cameraRoot.localPosition = self.cameraSetPosition
    end

    --  场景灯光信息
    self.sceneRoom = self.assetLoader:Pop(self.sceneRoomPath)
    if self.sceneRoomPath then
        self.sceneRoom.transform:SetParent(self.contentRoot)
    end

    UnityUtils.GraphicsInit()

	self:_CreateRt()

    self:_BindEvent()

    if self.showModel then
        self.showModel.transform:SetParent(self.contentRoot)
        self.showModel.transform:ResetAttr()
    end
end

function ModelRtView:_CreateRt()
    local rect = self.uiRawImage.rectTransform.rect
    local factor = math.min(ScreenFactor, 2)
    self.rtTemp = CustomUnityUtils.GetTextureTemporary(_floor(rect.width * factor), _floor(rect.height * factor))
    self.uiRawImage.texture = self.rtTemp 
    self.cameraComp.targetTexture = self.rtTemp 
end

function ModelRtView:_BindEvent()
    if not self.noDrag then
        local dragBehaviour = self.uiImage.gameObject:AddComponent(UIDragBehaviour)
        dragBehaviour.onDrag = function(data)
            self.contentRoot.transform:Rotate(0, data.delta.x, 0)
        end
    end
end

function ModelRtView:SetCameraPosition(x, y, z)
    self.cameraSetPosition = Vector3(x, y, z)
    if self.cameraRoot then
        self.cameraRoot.localPosition = self.cameraSetPosition
    end
end

function ModelRtView:Show()
    if self.modelRoot then
        self.modelRoot:SetActive(true)
        UnityUtils.GraphicsInit()
    end
end

function ModelRtView:Hide()
    if self.modelRoot then
    UnityUtils.GraphicsUnload()
       self.modelRoot:SetActive(false) 
    end
end

function ModelRtView:ShowHero(heroId)
	self:ShowModel(DataHero[heroId].ui_model)
end

function ModelRtView:ShowModel(modelName)	
	if self.showModel then
		GameObject.Destroy(self.showModel)
		self.showModel = nil
	end

	if self.modelLoader then
		self.modelLoader:DeleteMe()
		self.modelLoader = nil
	end

	local path = DataUiModel[modelName].model_path
	local ctlPath = DataUiModel[modelName].ui_controller_path
	local callback = function()
		if self.cancel then
			if self.modelLoader then
				self.modelLoader:DeleteMe()
				self.modelLoader = nil
			end
		else
			self.showModel = self.modelLoader:Pop(path)
			CustomUnityUtils.SetLayerRecursively(self.showModel, RtLayer)
			if self.contentRoot then
				self.showModel.transform:SetParent(self.contentRoot)
				self.showModel.transform:ResetAttr()
			end
			
			if self.callback then
				self.callback()
			end
		end
	end

	local resList = {
		{path = path, type = AssetType.Prefab},
		{path = ctlPath, type = AssetType.Prefab},
	}

	self.modelLoader = AssetBatchLoader.New("ModelRtView"..modelName)
	self.modelLoader:AddListener(callback)
	self.modelLoader:LoadAll(resList)
end

function ModelRtView:__delete()
    if self.showModel then
        GameObject.Destroy(self.showModel)
        self.showModel = nil
    end

    if self.rtTemp then
        RenderTexture.ReleaseTemporary(self.rtTemp)
        self.rtTemp = nil
    end

    if self.v_raw_image then
        self.v_raw_image.texture = nil
        self.v_raw_image = nil
    end

    if self.assetLoader ~= nil then
        self.assetLoader:DeleteMe()
        self.assetLoader = nil
    end

    if self.modelLoader then
        self.modelLoader:DeleteMe()
        self.modelLoader = nil
    end

    if self.modelRoot then
        GameObject.Destroy(self.modelRoot)
        self.modelRoot = nil
    end

    UnityUtils.GraphicsUnload()
end