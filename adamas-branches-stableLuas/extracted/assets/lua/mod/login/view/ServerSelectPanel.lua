ServerSelectPanel = BaseClass("ServerSelectPanel", BasePanel)

function ServerSelectPanel:__init()
    self:SetAsset("Prefabs/UI/Login/ServerSelectPanel.prefab")
end

function ServerSelectPanel:__CacheObject()
    self:SetCacheMode(UIDefine.CacheMode.destroy)
end

function ServerSelectPanel:__BindListener()
     
    self.CommonBack1_btn.onClick:AddListener(self:ToFunc("PlayExitAnim"))
    self.Submit_btn.onClick:AddListener(function ()
        self.parentWindow:SelectServer(LoginDefine.ServerListConfig[self.selectIndex], self.selectIndex)
        self:PlayExitAnim()
    end)
    self.Cancel_btn.onClick:AddListener(self:ToFunc("PlayExitAnim"))
    self.CommonGrid_btn.onClick:AddListener(self:ToFunc("PlayExitAnim"))
end

function ServerSelectPanel:__Show()
    self.selectIndex =  self.args.selectIndex or 1
	self:SetActive(false)
    self:ShowDetail()
end

function ServerSelectPanel:__Hide()
end


function ServerSelectPanel:ShowDetail()
    self:SetActive(true)
    for idx, cfg in ipairs(LoginDefine.ServerListConfig) do
        local obj = self:PopUITmpObject("ServerObj", self.Content_rect)
        obj.objectTransform:SetActive(true)
        if idx == self.selectIndex then
            self.selectObj = obj
            UtilsUI.SetTextColor(obj.Text_txt,"#FFFFFF")
        else
            UtilsUI.SetTextColor(obj.Text_txt,"#000000")
        end
        obj.UnSelect:SetActive(idx ~= self.selectIndex)
        obj.Select:SetActive(idx == self.selectIndex)
        obj.Text_txt.text = cfg.name

        obj.UnSelect_btn.onClick:AddListener(function ()
            self.selectObj.UnSelect:SetActive(true)
            self.selectObj.Select:SetActive(false)
            UtilsUI.SetTextColor(self.selectObj.Text_txt,"#000000")
            self.selectObj = obj
            self.selectIndex = idx
            obj.UnSelect:SetActive(false)
            obj.Select:SetActive(true)
            UtilsUI.SetTextColor(obj.Text_txt,"#FFFFFF")
        end)
    end
    UnityUtils.SetAnchored3DPosition(self.Content_rect, 0, 0, 0)
end


function ServerSelectPanel:__AfterExitAnim()
    self.parentWindow:ClosePanel(self)
end