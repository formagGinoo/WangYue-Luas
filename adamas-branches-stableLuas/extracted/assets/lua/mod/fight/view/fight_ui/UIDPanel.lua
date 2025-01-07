UIDPanel = BaseClass("UIDPanel", BasePanel)


function UIDPanel:__init(mainView)
	self.mainView = mainView
	self:SetAsset("Prefabs/UI/Fight/UIDPanel.prefab")
end

function UIDPanel:__delete()
	EventMgr.Instance:RemoveListener(EventName.StoryDialogEnd, self:ToFunc("ShowUID"))
	EventMgr.Instance:RemoveListener(EventName.StoryDialogStart, self:ToFunc("HideUID"))
end

function UIDPanel:__BaseShow()
	self:SetParent(self.mainView.PanelParent.transform)
end

function UIDPanel:__Create()
end

function UIDPanel:__ShowComplete()
	self.mainView:AddLoadDoneCount()
end

function UIDPanel:__BindListener()
	EventMgr.Instance:AddListener(EventName.StoryDialogEnd, self:ToFunc("ShowUID"))
	EventMgr.Instance:AddListener(EventName.StoryDialogStart, self:ToFunc("HideUID"))

end

function UIDPanel:__Show()
	self.UID_txt.text = string.format("UID:%s", mod.InformationCtrl:GetPlayerInfo().uid)
	self.UID_txt.raycastTarget = false
end

function UIDPanel:HideUID()
	UtilsUI.SetActive(self.UID, false)
end
function UIDPanel:ShowUID()
	UtilsUI.SetActive(self.UID, true)
end

function UIDPanel:__Hide()
end