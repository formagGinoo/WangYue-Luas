BlurBack = BaseClass("BlurBack", BaseView)

function BlurBack:__init(parent, setting, extraSetting)
    self:SetAsset("Prefabs/UI/Common/BlurBack.prefab")

    self.rawImage = nil
    self.blurRawImage = nil
    self.screenShotRt = {}
    self.callBack = nil

    local setting = setting and setting or {}
    self.blurRadius = setting.blurRadius or 2 --模糊程度
    self.passEvent = setting.passEvent or UIDefine.BlurBackCaptureType.UI --捕获类型
    self.playAnim = setting.playAnim or nil --入场动画
    self.bindNode = setting.bindNode or nil --自定义绑定节点
    self.extraSetting = extraSetting -- 额外设置,目前用来获取其他参数的模糊效果,包括参数blurRadius、passEvent 

    self.bindParent = parent
end

function BlurBack:__delete()
    for i = 1, #self.screenShotRt do
        RenderTexture.Destroy(self.screenShotRt[i])
    end
    for i = 1, #self.screenShotRt do
        table.remove(self.screenShotRt, 1)
    end
    if self.AniRt then
        self.AniRt:SetActive(false)
    end
    if self.Rt then
        self.Rt:SetActive(false)
    end
    self.bindParent = nil
    self.rawImage = nil
    self.blurRawImage = nil
    self.callBack = nil
    self.extraSetting = nil
    self.playAnim = nil

end

function BlurBack:__Show()
    if not self.bindParent then
        self:Hide()
        return
    end

    if self.args and next(self.args) then
        self.callBack = self.args[1]
    end

    if not self.rawImage then
        self.rawImage = self.Rt:GetComponent(RawImage)
    end
    if not self.blurRawImage then
        self.blurRawImage = self.AniRt:GetComponent(RawImage)
    end
end

function BlurBack:__ShowComplete()
    if self.bindNode then
        self:SetParent(self.bindNode.transform)
    else
        self:SetParent(self.bindParent.transform)
    end
    self.transform:SetAsFirstSibling()

    self.curImage = self.blurRawImage
    self:GetScreenShot(self.blurRadius, self.passEvent)
end

function BlurBack:GetScreenShot(blurRadius, passEvent)
    CustomUnityUtils.GetBlurScreenShot(self:ToFunc("OnGetRtCallBack"), blurRadius, passEvent)
end

function BlurBack:OnGetRtCallBack(rt)
    table.insert(self.screenShotRt, rt)
    self.curImage.gameObject:SetActive(true)
    self.curImage.texture = rt
    if self.curImage == self.blurRawImage and self.extraSetting ~= nil then
        self.curImage = self.rawImage
        self:GetScreenShot(self.extraSetting.blurRadius, self.extraSetting.passEvent)
        return
    end
    self.bindParent:SetActive(true)
    local animator = self.gameObject:GetComponent(Animator)
    if animator then
        animator:Play(self.playAnim)
    end
    if self.callBack then
        self.callBack()
    end
end