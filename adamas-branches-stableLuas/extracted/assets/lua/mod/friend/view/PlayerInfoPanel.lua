PlayerInfoPanel = BaseClass("PlayerInfoPanel", BasePanel)

function PlayerInfoPanel:__init()  
    self:SetAsset("Prefabs/UI/Friend/PlayerInfoPanel.prefab")
end

function PlayerInfoPanel:__BindListener()
    --self.ChangeNamebtn_btn.onClick()
end

function PlayerInfoPanel:__BindEvent()
    EventMgr.Instance:AddListener(EventName.PlayerInfoUpdate, self:ToFunc("UpdatePlayerInfo"))
end

function PlayerInfoPanel:__Create()
end

function PlayerInfoPanel:__delete()
    EventMgr.Instance:RemoveListener(EventName.PlayerInfoUpdate, self:ToFunc("UpdatePlayerInfo"))

    PoolManager.Instance:Push(PoolType.class, "PlayerInfoItem", self.playerInfoItem)
end

function PlayerInfoPanel:__Hide()

end

function PlayerInfoPanel:__Show()
    self.id = self.args.id
end


function PlayerInfoPanel:__ShowComplete()
    self.playerInfoItem = PoolManager.Instance:Pop(PoolType.class, "PlayerInfoItem")
	if not self.playerInfoItem then
		self.playerInfoItem = PlayerInfoItem.New()
	end
    self.playerInfoItem:InitItem(self.PlayerInfoItem, self, self.id)
    --self:UpdataPlayerInfo(self.id)
end
