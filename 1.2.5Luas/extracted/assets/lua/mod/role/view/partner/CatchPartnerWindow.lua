CatchPartnerWindow = BaseClass("CatchPartnerWindow",BaseWindow)
local playFrame = 20

local pro = 0.68

local ChangeAnimName = "FxPartnerDropChange"
local catchCdTime = 0.2

local SceneEffectConfig = Config.DataCommonCfg.Find["CatchPartnerSceneEffect"]
local SceneEffectName = SceneEffectConfig.string_val

local CameraShakeCfg = Config.DataCommonCfg.Find["CatchPartnerShakeMagicId"]
local CameraShakeMagicId = CameraShakeCfg.int_val

local CameraEndShakeCfg = Config.DataCommonCfg.Find["CatchPartnerEndShakeMagicId"]
local EndShakeMagicId = CameraEndShakeCfg.int_val

local TimePauseBuffCfg = Config.DataCommonCfg.Find["TimePauseBuffId"]
local TimePauseBuffId = TimePauseBuffCfg.int_val

function CatchPartnerWindow:__init()
    self:SetAsset("Prefabs/UI/Partner/CatchPartnerWindow.prefab")
end

function CatchPartnerWindow:__CacheObject()

end

function CatchPartnerWindow:__ShowComplete()
    EventMgr.Instance:Fire(EventName.ShowCursor, true)
end

function CatchPartnerWindow:__BindListener()
    local dragBehaviour = self.CatchBtn:AddComponent(UIDragBehaviour)
    dragBehaviour.onPointerDown = function(data)
        self:BtnDown()
    end

    dragBehaviour.onPointerUp = function(data)
        self:BtnUp()
    end

    self.CatchBtn_btn.onClick:AddListener(self:ToFunc("OnClickCatchBtn"))
end

function CatchPartnerWindow:BtnDown()
    self.clickDown = true
    self.catchCdTime = catchCdTime
    self.DownTime = catchCdTime
    self:onPointerDown()
end

function CatchPartnerWindow:BtnUp()
    self.clickDown = false
    self:onPointerUp()
end


function CatchPartnerWindow:OnClickCatchBtn()
    self.isCatch = true
    self.catchCdTime = catchCdTime

    self:DoShakeMagic(CameraShakeMagicId)
    self:onPointerDown()
end

function CatchPartnerWindow:DoShakeMagic(magicId)
    BehaviorFunctions.DoMagic(self.playInstanceId, self.playInstanceId, magicId, 1)
end

function CatchPartnerWindow:onPointerDown()
    self:ContinueEffect()
end

function CatchPartnerWindow:onPointerUp()
    if self.catchCdTime > 0 then return end
    for i = 0, self.animatorList.Length - 1 do
        local animator = self.animatorList[i]
        local stateInfo = animator:GetCurrentAnimatorStateInfo(0)
        local isChangeAnim = stateInfo:IsName(ChangeAnimName)
        if not isChangeAnim or stateInfo.normalizedTime >= 0.5 then
            return
        end
    end
    self:PauseEffect()
end

function CatchPartnerWindow:UpdateDownTime()
    
end

function CatchPartnerWindow:Update()
    if self.isBlendingCamera and not self.cameraMgr.cinemachineBrain.IsBlending then
        if self.blendingCB then
            self.blendingCB()
            self.blendingCB = nil
        end
    end

    if not self.animatorList then return end

    if not self.clickDown then
        self.catchCdTime = self.catchCdTime - Time.deltaTime
    else
        self.DownTime = self.DownTime - Time.deltaTime
        if self.DownTime <= 0 then
            self:DoShakeMagic(CameraShakeMagicId)
            self.DownTime = catchCdTime
        end
    end

    local animatorEnd = true
    for i = 0, self.animatorList.Length - 1 do
        local animator = self.animatorList[i]
        local stateInfo = animator:GetCurrentAnimatorStateInfo(0)
        local isChangeAnim = stateInfo:IsName(ChangeAnimName)
        local norTime = stateInfo.normalizedTime
        if isChangeAnim or norTime < 1 then
            animatorEnd = false
            self.Pro:SetActive(true)
            self.Pro_sld.value = norTime / pro
        end

        if not isChangeAnim or norTime >= pro then
            self:AniEnd()
        end
    end

    if not self.isPlaying then return end

    if self.catchCdTime <= 0 then
        self.catchCdTime = 0
        self:onPointerUp()
    end


    if animatorEnd then
        self:BlendingDefCamera()
    end
end

function CatchPartnerWindow:AniEnd()
    self.clickDown = false
    self.CatchBtn:SetActive(false)
    self.Pro:SetActive(false)
    if not self.isPlayEndShake then
        self:UpdateSceneEffect(true)
        self:DoShakeMagic(EndShakeMagicId)
        self.isPlayEndShake = true
    end
end

function CatchPartnerWindow:BlendingDefCamera()
    if self.isBlendingCamera then return end
    self.isBlendingCamera = true
    local playerObject = self.player:GetCtrlEntityObject()

    self.blendingCB = function ()
        WindowManager.Instance:CloseWindow(self)
    end

    BehaviorFunctions.SetCameraState(FightEnum.CameraState.Operating)
    local state = self.cameraMgr.states[FightEnum.CameraState.Operating]
    state:SetCameraMgrNoise()
    self.cameraMgr:SetMainTarget(playerObject.clientEntity.clientTransformComponent.transform)
end

function CatchPartnerWindow:showBlur()
    CustomUnityUtils.SetDepthOfFieldBoken(true, 2, 10, 100)
end

function CatchPartnerWindow:__Show()
    self.clickDown = false

    self.player = Fight.Instance.playerManager:GetPlayer()
    self.playInstanceId = self.player:GetCtrlEntity()

    self.fight = BehaviorFunctions.fight
    self:showBlur()
    self.catchCdTime = 0
    self.isBlendingCamera = false
    self.isPlayEndShake = false
    self.CatchBtn:SetActive(true)
    self.Pro:SetActive(true)
    self:DoShakeMagic(TimePauseBuffId)

    self.cameraMgr = self.fight.clientFight.cameraManager
    local partnerId = self.args.partnerId
    local dropEntity = self.args.entity
    local dropPos = dropEntity.transformComponent.position
    local qualityCfg = RoleConfig.GetPartnerQualityConfig(partnerId)

    self.clientFight = self.fight.clientFight
    self.path = qualityCfg.jade_effect
	self.effectGameobj = self.clientFight.assetsPool:Get(self.path)
    self.effectTrans = self.effectGameobj.transform
    self.animatorList = self.effectTrans:GetComponentsInChildren(Animator)
    self.particleSysList = self.effectTrans:GetComponentsInChildren(ParticleSystem)

    local EffectCamera = self.effectTrans:Find("EffectCamera")
    if EffectCamera then
        local entityRoot = Fight.Instance.clientFight.clientEntityManager.entityRoot.transform
        self.effectTrans:SetParent(entityRoot)
        UnityUtils.SetPosition(self.effectTrans, dropPos.x, dropPos.y, dropPos.z)
        local curEulerAngles = self.cameraMgr.cameraTransform.rotation.eulerAngles
        UnityUtils.SetEulerAngles(self.effectTrans, 0, curEulerAngles.y, curEulerAngles.z)

        local playerObject = self.player:GetCtrlEntityObject()
        -- playerObject.clientEntity.clientTransformComponent:SetActive(false)
      
        BehaviorFunctions.SetCameraState(FightEnum.CameraState.CatchPartner)
        local state = self.cameraMgr.states[FightEnum.CameraState.CatchPartner]
        state:SetCameraMgrNoise()
        state:SetMainTarget(EffectCamera)
    end

    local map = {
        [self.playInstanceId] = {isIgnoreTime = true},
    }
    self.fight.entityManager:HideAllEntity(map)

    self.isPlaying = true
    self:UpdateSceneEffect()
    self:PauseEffect()
end

function CatchPartnerWindow:UpdateSceneEffect(isEnd)
    if not isEnd then
		CameraManager.Instance:AddScreenEffect(self.playInstanceId, SceneEffectName)
	else
		CameraManager.Instance:RemoveScreenEffect(self.playInstanceId, SceneEffectName)
	end
end

function CatchPartnerWindow:ContinueEffect()
    if self.isPlaying then return end
    self.isPlaying = true
    for i = 0, self.animatorList.Length - 1 do
        local animator = self.animatorList[i]
        animator:Play(ChangeAnimName, 0, 0)
        animator.speed = 1
    end

    for i = 0, self.particleSysList.Length - 1 do
        local partice = self.particleSysList[i]
        partice:Play()
    end
end

function CatchPartnerWindow:PauseEffect()
    if not self.isPlaying then return end
    self.isPlaying = false
    for i = 0, self.animatorList.Length - 1 do
        local animator = self.animatorList[i]
        animator:StartPlayback()
        animator.speed = -5
    end

    for i = 0, self.particleSysList.Length - 1 do
        local partice = self.particleSysList[i]
        partice:Stop()
    end
end

function CatchPartnerWindow:__Hide()
    CustomUnityUtils.SetDepthOfFieldBoken(false, 0.16, 56, 32)
    if self.assetLoader then
		self.assetLoader:DeleteMe()
		self.assetLoader = nil
	end
    BehaviorFunctions.RemoveBuff(self.playInstanceId,TimePauseBuffId)

    -- playerObject.clientEntity.clientTransformComponent:SetActive(true)
    self.fight.entityManager:ShowAllEntity()
    self.clientFight.assetsPool:Cache(self.path, self.effectGameobj)
    Fight.Instance.entityManager:CallBehaviorFun("CatchPartnerEnd")
    EventMgr.Instance:Fire(EventName.ShowCursor, false)
end

function CatchPartnerWindow:__delete()

end