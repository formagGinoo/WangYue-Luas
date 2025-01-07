WaitCommandPanel = BaseClass("WaitCommandPanel", BaseView)

function WaitCommandPanel:__init()
    local config = Config.DataCommonCfg.Find["WaitCommand_ShowMaskTime"]
    self.showMaskTime = config and config.double_val or 0.5
	self:SetAsset("Prefabs/UI/Common/WaitCommandPanel.prefab")
	self:SetParent(UIDefine.canvasRoot.transform)
end

function WaitCommandPanel:__CacheObject()
    self.canvas = self:Find(nil, Canvas)
    self.timer = LuaTimerManager.Instance:AddTimer(0, 1/60,self:ToFunc("Update"))
end

function WaitCommandPanel:__delete()
    if self.timer then
		LuaTimerManager.Instance:RemoveTimer(self.timer)
		self.timer = nil
	end
end

function WaitCommandPanel:__Show()

end

function WaitCommandPanel:Update()
    if not self.isEnter  then
        return
    end
    self.time = self.time + 1 / 60
    if self.time > self.showMaskTime then
        UnityUtils.SetActive(self.ContentMask, true)
    end

    if self.time > 10 then
        Log("屏蔽时间过长，自动关闭")
        self:ExitWait()
    end
end

function WaitCommandPanel:EnterWait()
    self.gameObject:SetActive(true)
    self.Content:SetActive(true)
    self.ContentMask:SetActive(false)
    self:SetTopLayer(self.canvas)
    self.isEnter = true
    self.time = 0
end

function WaitCommandPanel:ExitWait()
    self.gameObject:SetActive(false)
    self.isEnter = false
end