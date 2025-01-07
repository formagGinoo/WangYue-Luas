WaitCommandPanel = BaseClass("WaitCommandPanel", BaseView)

function WaitCommandPanel:__init()
    local config = Config.DataCommonCfg.Find["WaitCommand_ShowMaskTime"]
    self.showMaskTime = config and config.double_val or 0.5
	self:SetAsset("Prefabs/UI/Common/WaitCommandPanel.prefab")
end

function WaitCommandPanel:__CacheObject()
    self.canvas = self:Find(nil, Canvas)
    self:SetParent(UIDefine.canvasRoot.transform)
end

function WaitCommandPanel:__delete()
end

function WaitCommandPanel:__Show()

end

function WaitCommandPanel:Update()
    if not self.isEnter or not self.active then
        return
    end
    self.time = self.time + Global.deltaTime
    if self.time > self:GetShowMaskTime() then
        UnityUtils.SetActive(self.ContentMask, true)
    end

    -- if self.time > 30 then
    --     LogError("屏蔽时间过长，自动关闭")
    --     CurtainManager.Instance:ResetWait()
    -- end
end

function WaitCommandPanel:SetWaitType(type)
    self.waitType = self.waitType or type
    self.waitType = type > self.waitType and type or self.waitType
end

function WaitCommandPanel:GetShowMaskTime()
    if self.waitType == SystemConfig.WaitType.Immediately then
        return 0
    elseif self.waitType >= SystemConfig.WaitType.NotLoading then
        return 999
    else
        return self.showMaskTime
    end
end

function WaitCommandPanel:EnterWait()
    if self.active then
        self.gameObject:SetActive(true)
        self.Content:SetActive(true)
        self.ContentMask:SetActive(false)
        self:SetTopLayer(self.canvas)
    end
    self.isEnter = true
    self.time = 0
end

function WaitCommandPanel:ExitWait()
    self.waitType = nil
    self.gameObject:SetActive(false)
    self.isEnter = false
    self.time = 0
end