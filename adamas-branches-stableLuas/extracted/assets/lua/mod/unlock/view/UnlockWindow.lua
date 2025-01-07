UnlockWindow = BaseClass("UnlockWindow",BaseWindow)

local unlockState = {
    start = 0,
    suc = 1,
    fail = 2,
    cd = 3,
    complete = 4,
    moveKey = 5,
}

local defTimeColor = Color(221/255, 222/255, 224/255, 1)

function UnlockWindow:__init()
    self:SetAsset("Prefabs/UI/Unlock/UnlockWindow.prefab")

    self.blurBack = nil
end

function UnlockWindow:__delete()
end

function UnlockWindow:__CacheObject()
end

function UnlockWindow:__ShowComplete()
    if not self.blurBack then
        local setting = { passEvent = UIDefine.BlurBackCaptureType.UI, blurRadius = 2, bindNode = self.BlurBack }
        self.blurBack = BlurBack.New(self, setting)
    end
    self:SetActive(false)
    self.blurBack:Show()
end

function UnlockWindow:__BindListener()
    self:SetHideNode("UnlockWindowExit")
    self:BindCloseBtn(self.CommonBack2_btn,self:ToFunc("UnlockWinClose"))

    self.SureBtn_btn.onClick:AddListener(self:ToFunc("ClickSureBtn"))

    self.UnlockTimeEnd_hcb.HideAction:AddListener(self:ToFunc("UnlockTimeEndFail"))
end

function UnlockWindow:WinBack()
    self.UnlockWindowExit:SetActive(true)
end

function UnlockWindow:UnlockWinClose()
    self.UnlockWindowExit:SetActive(false)
    WindowManager.Instance:CloseWindow(self)
end

function UnlockWindow:UnlockTimeEndFail()
    self.UnlockTimeEnd:SetActive(false)
    self:OpenPanel(UnlockFailPanel, self.args)
end

function UnlockWindow:ClickSureBtn()
    if self.unlockState == unlockState.fail then
        self:OpenFailPanel()
        return
    end

    if self.unlockState == unlockState.cd or
        self.unlockState == unlockState.complete or
        self.unlockState == unlockState.moveKey then
        return
    end

    if not self.UnlockWindowTimeOpen.activeSelf then
        self.UnlockWindowTimeOpen:SetActive(true)
    end
    self.TimeContent:SetActive(true)
    self.Tip:SetActive(false)

    if self.unlockState ~= unlockState.start then
       local unlockInitCfg = UnlockConfig.GetUnlockInitCfg(self.args.ecoId)
        mod.UnlockFacade:SendMsg("unlock_begin", unlockInitCfg.lock_id)
        self:StartUnlock()
    else
        self:StopUnLock()
    end
end

function UnlockWindow:__Create()

end

function UnlockWindow:__Show()
    self.isUnlockFail = true
    self.entityMgr = BehaviorFunctions.fight.entityManager

    self.doorInstanceId = BehaviorFunctions.GetEcoEntityByEcoId(self.args.ecoId)

    self.TimeTxt_txt.color = defTimeColor
    self.isSetColor = false

    self.lockInfoId = self.args.lockInfoId
    self.lockCfg = UnlockConfig.GetlockInfoCfg(self.lockInfoId)

    self.unlockSkillId = self.args.unlockSkillId
    self.unlockSkillLv = self.args.unlockSkillLv
    self.unlockSkillCfg = UnlockConfig.GetUnlockSkillLevelCfg(self.unlockSkillId, self.unlockSkillLv)

    self.SelectCircleObj = nil
    self.selectIdx = 1
	self.quat = Quat.New()

    self.keyInitY = self.UpKeys_rect.anchoredPosition.y

    self.unlockAllTime = self.lockCfg.unlock_time + self.unlockSkillCfg.add_time
    self.unlockFailCDTime = self.lockCfg.fail_cd - self.unlockSkillCfg.dec_fail_cd
    self.circleRotationSpeed = self.lockCfg.rotation_speed - self.unlockSkillCfg.dec_rotation_speed

    self.Tip:SetActive(true)
    self.TimeContent:SetActive(false)
    self.Sure:SetActive(false)
    self.Start:SetActive(true)

    self.unlockState = nil
    self:InitLockView()
end

function UnlockWindow:__Hide()
    if self.sequence then
        self.sequence:Kill()
        self.sequence = nil
    end

    if self.blurBack then
        self.blurBack:Hide()
    end

    if self.isUnlockFail then
        local player = Fight.Instance.playerManager:GetPlayer()
        local playerObject = player:GetCtrlEntityObject()

        BehaviorFunctions.SetCameraState(FightEnum.CameraState.Operating)
        BehaviorFunctions.fight.clientFight.cameraManager:SetMainTarget(playerObject.clientTransformComponent.transform)
    end

    self.entityMgr:CallBehaviorFun("OpenKeyFinish",self.doorInstanceId)
end

function UnlockWindow:UnlockSucToCameraState()
    local player = Fight.Instance.playerManager:GetPlayer()
	local playerObject = player:GetCtrlEntityObject()
    local time = 0

    local doorInsid = BehaviorFunctions.GetEcoEntityByEcoId(self.args.ecoId)
    if doorInsid then
        local doorEntity = BehaviorFunctions.GetEntity(doorInsid)
        local trans = doorEntity.clientTransformComponent.transform
        local lookTrans = trans:Find("KeyCameraTarget")
        LuaTimerManager.Instance:AddTimer(1, 0.1, function()
            BehaviorFunctions.SetCameraState(FightEnum.CameraState.OpenDoor)
            BehaviorFunctions.fight.clientFight.cameraManager.states[FightEnum.CameraState.OpenDoor]:SetMainTarget(lookTrans)
        end)

        local doorOpenAnimFrame = BehaviorFunctions.GetEntityAnimationFrame(doorInsid, "Opening")
        time = doorOpenAnimFrame / FightUtil.targetFrameRate
        if doorOpenAnimFrame < 0 then
            time = 1
        end
    end

    LuaTimerManager.Instance:AddTimer(1, time + 0.1, function()
        BehaviorFunctions.SetCameraState(FightEnum.CameraState.Operating)
        BehaviorFunctions.fight.clientFight.cameraManager:SetMainTarget(playerObject.clientTransformComponent.transform)
    end)
end

function UnlockWindow:Update()
    self:UpdateTime()
    if self.unlockState == unlockState.fail or
        self.unlockState == unlockState.complete or
        self.unlockState == unlockState.moveKey then
        return
    end

    if self.unlockState == unlockState.cd then
        self:UpdateUnlockFailCD()
    else
        self:UpdateCircleRotation()
    end
end

function UnlockWindow:RestartUnlock()
    self:InitLockView()
    self.TimeTxt_txt.color = defTimeColor
    self.selectIdx = 1
    self.SelectCircleObj = nil
    self.unlockAllTime = self.lockCfg.unlock_time + self.unlockSkillCfg.add_time
    
    UnityUtils.SetAnchoredPosition(self.UpKeys_rect, 0, 0)
    self:StartUnlock()
end

function UnlockWindow:InitLockView()
    local cfg = self.lockCfg
    local circleNum = cfg.circle_num
    local initDegreeMap = cfg.open_degree
    local offsetDegreeMap = cfg.offset_degree

    self.MaxIdx = circleNum

    local defColor = UnlockConfig.LockResultColor[1]
    for num = 1, 3 do
        self["Circle"..num]:SetActive(num <= circleNum)
        self["Circle"..num.."_img"].color = defColor
    end

    for num = 1, circleNum do
        local val = initDegreeMap[num] or 0
        local degreeVal = val + self.unlockSkillCfg.add_degree
        local precent = (360 - degreeVal) / 360
        local circleImgObj = self["Circle"..num.."_img"]
        circleImgObj.fillAmount = precent

        local rect = self["Circle"..num]:GetComponent(RectTransform)
        local offsetDegree = offsetDegreeMap[num] or 0
        rect.rotation = self.quat.Euler(0, 0, offsetDegree, 0)
    end
end

-- 开始解锁
function UnlockWindow:StartUnlock()
    self.SelectCircleRectObj = self["Circle"..self.selectIdx.."_rect"]
    if not self.SelectCircleRectObj then
        return
    end
    self.isUnlockFail = false
    self.unlockState = unlockState.start
    self.isTimeEndFail = false
    self.isSetColor = false

    self.Sure:SetActive(true)
    self.Start:SetActive(false)
end

function UnlockWindow:UpdateCircleRotation(fixedSpeed)
    -- 没有选中对象
    if not self.SelectCircleRectObj then return end
    -- 当前处于钥匙上升阶段
    if self.unlockState == unlockState.moveKey then return end

    -- 刷新角度
    local frameSpeed = fixedSpeed or self.circleRotationSpeed
    local rotation = self.SelectCircleRectObj.rotation
    local eulerZ = rotation.eulerAngles.z
    eulerZ = eulerZ + frameSpeed * Time.deltaTime
    self.SelectCircleRectObj.rotation = self.quat.Euler(0, 0, eulerZ, 0)
end

function UnlockWindow:UpdateTime()
    if not self.unlockState then return end
    if self.unlockState == unlockState.fail or
        self.unlockState == unlockState.complete then
        return
    end

    local desc = UnlockConfig.GetTimeDesc(self.unlockAllTime)
    self.unlockAllTime = self.unlockAllTime - Time.deltaTime
    self.TimeTxt_txt.text = desc

    -- 固定小于10秒
    if self.unlockAllTime <= 10 and not self.isSetColor then
        self.TimeTxt_txt.color = Color(203/255, 91/255, 91/255, 1)
        self.isSetColor = true
    end

    if self.unlockAllTime <= 0 then
        -- 开锁失败 TODO
        self.unlockState = unlockState.fail
        self:OpenFailPanel()
    end
end

function UnlockWindow:OpenFailPanel()
    self.isUnlockFail = true
    if self.UnlockTimeEnd.activeSelf then
        return
    end

    if self.isTimeEndFail then
        self:OpenPanel(UnlockFailPanel, self.args)
        return
    end

    self.UnlockTimeEnd:SetActive(true)
    self:ResetKeyAnchorPos()
    self.isTimeEndFail = true
end

function UnlockWindow:OpenSucPanel()
    self.entityMgr:CallBehaviorFun("OpenKeySuccess", self.doorInstanceId)
    mod.UnlockFacade:SendMsg("unlock_success", self.args.lockId)
    self:UnlockSucToCameraState()
    WindowManager.Instance:CloseWindow(self)
end

function UnlockWindow:StopUnLock()
    local cfg = self.lockCfg
    local degreeMap = cfg.open_degree

    local degreeVal = degreeMap[self.selectIdx] + self.unlockSkillCfg.add_degree
    local eulerZ = self.SelectCircleRectObj.rotation.eulerAngles.z
    eulerZ = eulerZ < 0 and eulerZ + 360 or eulerZ

    if 360 - eulerZ <= degreeVal then
        self.unlockState = unlockState.suc
        self.SelectCircleRectObj.rotation = self.quat.Euler(0, 0, - degreeVal / 2 - 2, 0)
        self:UnlockSuc()
    else
        -- 失败流程
        self:UnlockFail()
    end
end

-- 解锁完成
function UnlockWindow:UnlockSuc()
    local sucColor = UnlockConfig.LockResultColor[2]
    self["Circle"..self.selectIdx.."_img"].color = sucColor

    local cb = function()
        if self.selectIdx + 1 <= self.MaxIdx then
            self.selectIdx = self.selectIdx + 1
            self:StartUnlock()
        else
            self.SelectCircleRectObj = nil
            self.unlockState = unlockState.complete
            -- 打开界面
            self:OpenSucPanel()
        end
    end
    self.unlockState = unlockState.moveKey
    self:MoveUpkey(cb)
end

-- 开锁失败
function UnlockWindow:UnlockFail()
    -- 改变颜色，进入cd
    local failColor = UnlockConfig.LockResultColor[3]
    self["Circle"..self.selectIdx.."_img"].color = failColor

    -- 在cd时间内快速旋转
    self.unlockFailCD = self.unlockFailCDTime
    self.unlockState = unlockState.cd
end

function UnlockWindow:UpdateUnlockFailCD()
    self.unlockFailCD = self.unlockFailCD - Time.deltaTime
    if self.unlockFailCD <= 0 then
        self.unlockState = unlockState.start
        local defColor = UnlockConfig.LockResultColor[1]
        self["Circle"..self.selectIdx.."_img"].color = defColor
        return
    end
    self:UpdateCircleRotation(1500)
end

function UnlockWindow:MoveUpkey(cb)
    if self.sequence then
        self.sequence:Kill()
        self.sequence = nil
    end

    local sizeDelta = self.UpKeys_rect.sizeDelta
    local hight = sizeDelta.y / 2

    local selectObjSizeDelta = self.SelectCircleRectObj.sizeDelta
    local selectObjHight = selectObjSizeDelta.y / 2

    local targetHeight = selectObjHight - hight
    self.sequence = DOTween.Sequence()
    self.sequence:Append(self.UpKeys_rect:DOAnchorPosY(self.keyInitY + targetHeight, 0.5))
    self.sequence:OnComplete(function ()
        cb()
    end)
end

function UnlockWindow:ResetKeyAnchorPos()
    if self.sequence then
        self.sequence:Kill()
        self.sequence = nil
    end
    self.sequence = DOTween.Sequence()
    self.sequence:Append(self.UpKeys_rect:DOAnchorPosY(0, 1))
end
