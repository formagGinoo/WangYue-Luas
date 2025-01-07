StoryClueObj = BaseClass("StoryClueObj", PoolBaseClass)

function StoryClueObj:__init()
    self.objInfo = {}
end

function StoryClueObj:Init(id, clueObj, root)
    self.id = id 
    self.root = root
    self.exploreObj = clueObj:GetComponent(ExploreObj)
    self:GetObject()
end

function StoryClueObj:OnReset()
    StoryAssetsMgr.Instance:PushObj(StoryConfig.ObjType.Clue, self.objInfo)

    if self.timer then
        LuaTimerManager.Instance:RemoveTimer(self.timer)
    end

end

function StoryClueObj:InitObj()
    local tf = self.objInfo.objectTransform
    tf:SetParent(self.root)
    UnityUtils.SetLocalScale(tf, 1, 1, 1)
    self.exploreObj:SetTipObject(self.objInfo.Root, self.objInfo.Type, self.objInfo.Button)
end

function StoryClueObj:ActionInput(key)
    if key == FightEnum.KeyEvent.Inspect then
        self:ClickDown()
    end
end

function StoryClueObj:ActionInputEnd(key)
    if key == FightEnum.KeyEvent.Inspect then
        self:ClickUp()
    end
end

function StoryClueObj:Hide()
    EventMgr.Instance:RemoveListener(EventName.ActionInputEnd,self:ToFunc("ActionInputEnd"))
    EventMgr.Instance:RemoveListener(EventName.ActionInput,self:ToFunc("ActionInput"))
    self.objInfo.Type1_uianim:PlayExitAnimator()
    self.objInfo.Type2_uianim:PlayExitAnimator()
    self.objInfo.Button:SetActive(false)
end
--101100201
function StoryClueObj:ShowDetail()
    EventMgr.Instance:AddListener(EventName.ActionInputEnd,self:ToFunc("ActionInputEnd"))
    EventMgr.Instance:AddListener(EventName.ActionInput,self:ToFunc("ActionInput"))
    local config = StoryConfig.GetClueConfig(self.id)
    local locked = StoryExploreMgr.Instance:GetClueLockState(self.id) == StoryConfig.ClueState.Locked
    local objInfo = self.objInfo
    objInfo.object:SetActive(true)
    objInfo.Button:SetActive(locked)
    objInfo.Type1:SetActive(not locked and config.type == StoryConfig.ClueType.Tip)
    objInfo.Type2:SetActive(not locked and config.type == StoryConfig.ClueType.Unlock)
    if not locked then
        SoundManager.Instance:PlaySound("UIDetectInformation")
    end
    objInfo.Type1_uianim:PlayEnterAnimator()
    objInfo.Type2_uianim:PlayEnterAnimator()
    objInfo.Content1_txt.text = config.content
    objInfo.Content2_txt.text = config.content
    objInfo.Button_drag.onPointerDown = self:ToFunc("ClickDown")
    objInfo.Button_drag.onPointerUp = self:ToFunc("ClickUp")
    objInfo.Button_drag.onDrag = self:ToFunc("Draging")

    objInfo.Yellow_out_hcb.HideAction:RemoveAllListeners()

    objInfo.Arrow:SetActive(true)
    objInfo.Yellow:SetActive(false)
    objInfo.Black:SetActive(true)

    objInfo.Yellow_out_hcb.HideAction:AddListener(self:ToFunc("ShowContent"))
    --objInfo.mask = objInfo.Black:GetComponent(RectMask2D)
    --objInfo.mask.padding = Vector4(0, maxTop, 0, 0)
    objInfo.Black_img.fillAmount = 0
    local content = objInfo["Content"..config.type.."_rect"]
    
    -- local offect = self.exploreObj.offect
    -- local pos = content.anchoredPosition3D
    -- UnityUtils.SetAnchored3DPosition(content, pos.x + offect.x, pos.y + offect.y, pos.z)
end

function StoryClueObj:ClickDown()
    local maxCount = 50
    local count = 0
    local objInfo = self.objInfo
    if self.timer then
        LuaTimerManager.Instance:RemoveTimer(self.timer)
        SoundManager.Instance:StopUISound("UIDetectButton1Press")
    end
    SoundManager.Instance:PlaySound("UIDetectButton1Press")
    self.timer = LuaTimerManager.Instance:AddTimer(0, 0.02, function ()
        count = count + 1
        objInfo.Black_img.fillAmount = count / maxCount
        if count == maxCount then
            --self:ShowContent()
            objInfo.Yellow:SetActive(true)
            objInfo.Yellow_uianim:PlayEnterAnimator()
            LuaTimerManager.Instance:RemoveTimer(self.timer)
            SoundManager.Instance:StopUISound("UIDetectButton1Press")
            SoundManager.Instance:PlaySound("UIDetectButton1")
        end
    end)
end

function StoryClueObj:Draging()
    if self.timer then
        LuaTimerManager.Instance:RemoveTimer(self.timer)
        SoundManager.Instance:StopUISound("UIDetectButton1Press")
    end
    self.objInfo.Black_img.fillAmount = 0
end


function StoryClueObj:ClickUp()
    if self.timer then
        LuaTimerManager.Instance:RemoveTimer(self.timer)
        SoundManager.Instance:StopUISound("UIDetectButton1Press")
    end
    self.objInfo.Black_img.fillAmount = 0
end

function StoryClueObj:ShowContent()
    StoryExploreMgr.Instance:SetClueLockState(self.id, StoryConfig.ClueState.Unlock)
    local config = StoryConfig.GetClueConfig(self.id)
    local objInfo = self.objInfo
    objInfo.Button:SetActive(false)
    objInfo.Type1:SetActive(config.type == StoryConfig.ClueType.Tip)
    objInfo.Type2:SetActive(config.type == StoryConfig.ClueType.Unlock)
    objInfo.Type1_uianim:PlayEnterAnimator()
    objInfo.Type2_uianim:PlayEnterAnimator()
    SoundManager.Instance:PlaySound("UIDetectInformation")
end

function StoryClueObj:GetObject()
    self.objInfo = StoryAssetsMgr.Instance:PopObj(StoryConfig.ObjType.Clue)
    self:InitObj()
end