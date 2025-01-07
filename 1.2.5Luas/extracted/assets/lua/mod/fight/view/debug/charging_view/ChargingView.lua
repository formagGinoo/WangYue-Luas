ChargingView = BaseClass("ChargingView",BaseView)

local SkillAttr =
{
	[EntityAttrsConfig.AttrType.Dodge] = 999999,
	[EntityAttrsConfig.AttrType.Energy] = 999999,
	[EntityAttrsConfig.AttrType.NormalSkillPoint] = 2,
	[EntityAttrsConfig.AttrType.ExSkillPoint] = 2,
	[EntityAttrsConfig.AttrType.CoreRes] = 999999,
	[EntityAttrsConfig.AttrType.DefineRes1] = 999999,
	[EntityAttrsConfig.AttrType.DefineRes2] = 999999,
	[EntityAttrsConfig.AttrType.CommonAttr1] = 999999,
}

function ChargingView:__init()
	self:SetAsset("Prefabs/UI/FightDebug/ChargingView.prefab")
	self:SetParent(UIDefine.canvasRoot.transform)
end

function ChargingView:__Show()

end

function ChargingView:__Hide()
	
end

function ChargingView:__BindListener()
	self.BlueSkillPoint_btn.onClick:AddListener(self:ToFunc("OnGetBlueSkillPoint"))
	self.Energy_btn.onClick:AddListener(self:ToFunc("OnGetEnergy"))
	self.Dodge_btn.onClick:AddListener(self:ToFunc("OnGetDodge"))
	self.RedSkillPoint_btn.onClick:AddListener(self:ToFunc("OnGetRedSkillPoint"))
	self.CoreRes_btn.onClick:AddListener(self:ToFunc("OnGetCoreRes"))
	self.Diyue_btn.onClick:AddListener(self:ToFunc("OnGetDiyueEnergy"))
	self.DefineRes1_btn.onClick:AddListener(self:ToFunc("OnGetDefineRes1"))
	self.DefineRes2_btn.onClick:AddListener(self:ToFunc("OnGetDefineRes2"))
end

function ChargingView:__CacheObject()
	local canvas = self.gameObject:GetComponent(Canvas)
	if canvas ~= nil then
		canvas.pixelPerfect = false
		canvas.overrideSorting = true
	end

end



function ChargingView:__delete()
end

function ChargingView:__Create()
end

function ChargingView:OnGetBlueSkillPoint()
	self:AddSkillAttr(EntityAttrsConfig.AttrType.ExSkillPoint)
end

function ChargingView:OnGetEnergy()
	self:AddSkillAttr(EntityAttrsConfig.AttrType.Energy)
end

function ChargingView:OnGetDodge()
	self:AddSkillAttr(EntityAttrsConfig.AttrType.Dodge)
end

function ChargingView:OnGetRedSkillPoint()
	self:AddSkillAttr(EntityAttrsConfig.AttrType.NormalSkillPoint)
end

function ChargingView:OnGetCoreRes()
	self:AddSkillAttr(EntityAttrsConfig.AttrType.CoreRes)
end

function ChargingView:OnGetDiyueEnergy()
	self:AddSkillAttr(EntityAttrsConfig.AttrType.CommonAttr1)
end

function ChargingView:OnGetDefineRes1()
	self:AddSkillAttr(EntityAttrsConfig.AttrType.DefineRes1)
end

function ChargingView:OnGetDefineRes2()
	self:AddSkillAttr(EntityAttrsConfig.AttrType.DefineRes2)
end

function ChargingView:AddSkillAttr(attrConfig)
	if Fight.Instance == nil then return end
	local player = Fight.Instance.playerManager:GetPlayer():GetCtrlEntityObject()
	if player ~= nil then
		player.attrComponent:AddValue(attrConfig, SkillAttr[attrConfig])
	end
end