HunterProgressBar = BaseClass("HunterProgressBar", PoolBaseClass)

function HunterProgressBar:__init()
end

function HunterProgressBar:init(object)
    self.object = object
    self.alert_val = mod.MercenaryHuntCtrl:GetAlertVal()
    self.nodes = UtilsUI.GetContainerObject(self.object.transform)
    self.mainId = mod.MercenaryHuntCtrl:GetMainId()
    self.maxStage = -1
    self.maxCount = 4

    self:UpdateProgress()
    self:RegisterCallBack()
end

-- 注册警戒值变更事件回调
function HunterProgressBar:RegisterCallBack()
    EventMgr.Instance:AddListener(EventName.AlertValueUpdate, self:ToFunc("UpdateProgress"))
end

function HunterProgressBar:UpdateProgress()
    local id = mod.MercenaryHuntCtrl:GetMainId()
    local oldValue = self.alert_val
    self.alert_val = mod.MercenaryHuntCtrl:GetAlertVal()
    if oldValue < self.alert_val then
        self.nodes.HunterProgress_Open:SetActive(true)
    end
    local alert_val = self.alert_val
    local maxStage = MercenaryHuntConfig.GetMercenaryInfoMaxStageById(id)
    local part = 1 / maxStage
    local nowMercenaryInfo = MercenaryHuntConfig.GetMercenaryInfoByIdAndAlertValue(id,alert_val)
    if nowMercenaryInfo == nil then 
        self.nodes.Handle_img.fillAmount = 1
        self:RefreshIcon(maxStage,maxStage)
        return
    end
    if nowMercenaryInfo.alert_val == alert_val then
        self.nodes.Handle_img.fillAmount = nowMercenaryInfo.stage_id * part
        self:RefreshIcon(nowMercenaryInfo.stage_id,maxStage)
        return 
    end
    if nowMercenaryInfo.stage_id == 1 then
        self.nodes.Handle_img.fillAmount = part * (alert_val / nowMercenaryInfo.alert_val)
        self:RefreshIcon(0,maxStage)
        return
    end
    local beforeMercenaryInfo = MercenaryHuntConfig.GetMercenaryInfoConfig(id, nowMercenaryInfo.stage_id - 1)

    self.nodes.Handle_img.fillAmount = (part * beforeMercenaryInfo.stage_id) + (part * (alert_val - beforeMercenaryInfo.alert_val) / (nowMercenaryInfo.alert_val - beforeMercenaryInfo.alert_val) )
    self:RefreshIcon(beforeMercenaryInfo.stage_id,maxStage)
end

function HunterProgressBar:RefreshIcon(fullCount,maxCount)
    self.maxCount = maxCount
    maxCount = maxCount or 4
    for i = 1, maxCount, 1 do
        if i <= fullCount then
            UtilsUI.SetActive(self.nodes["FullIcon"..i],true)
        else
            UtilsUI.SetActive(self.nodes["FullIcon"..i],false)
        end
        if self.maxStage ~= maxCount then
            if i > maxCount then
                UtilsUI.SetActive(self.nodes["Icon"..i],false)
            else
                UtilsUI.SetActive(self.nodes["Icon"..i],true)
                local newPos = self.nodes["Icon"..i.."_rect"].anchoredPosition
                newPos.x = self.nodes.HunterIcons_rect.rect.width / maxCount * i
                self.nodes["Icon"..i.."_rect"].anchoredPosition = newPos
            end
        end
    end
    self.maxStage = maxCount
end

function HunterProgressBar:SetLoopEffect(isOpen)
    for i = 1, self.maxCount, 1 do
        UtilsUI.SetActive(self.nodes["22119_"..i],isOpen)
    end
    self.nodes["22120"]:SetActive(isOpen)
    self.nodes.HunterProgress_Loop:SetActive(isOpen)
end

-- 放入缓存
function HunterProgressBar:OnCache()
    Fight.Instance.objectPool:Cache(HunterProgressBar, self)
end

-- 放入缓存
function HunterProgressBar:__cache()
    self.object = nil
    self.alert_val = nil
    self.nodes = nil
    EventMgr.Instance:RemoveListener(EventName.AlertValueUpdate, self:ToFunc("UpdateProgress"))
end

function HunterProgressBar:__delete()

end