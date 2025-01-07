DebugGOAPView = BaseClass("DebugGOAPView", BasePanel)

local maxValue = 100
function DebugGOAPView:__init()
	self:SetAsset("Prefabs/UI/FightDebug/DebugGOAP.prefab")
	self:SetParent(UIDefine.canvasRoot.transform)
	self.fight = Fight.Instance
	self.gobalAttrsObjs = {}
	self.plannerManager = self.fight.goapManager.plannerManager
	self.globalAttrs = self.fight.goapManager.globalAttrs
	self.agentManager = self.fight.goapManager.agentManager
	self.globalStates = self.globalAttrs.globalStates
end

function DebugGOAPView:__BindListener()
	self.ApplyBtn_btn.onClick:AddListener(self:ToFunc("OnClick_Apply"))
	self.RefreshBtn_btn.onClick:AddListener(self:ToFunc("OnClick_Refresh"))
	self.CloseBtn_btn.onClick:AddListener(self:ToFunc("OnClick_Close"))
	for k, v in pairs(self.globalStates) do
		self.globalAttrs:AddListener(k, self:ToFunc("TestReSetGoal")) 
	end
end

function DebugGOAPView:TestReSetGoal()
	local planner = self.plannerManager:GetPlanner(2)
	planner:PlanningGoal()
end

function DebugGOAPView:__CacheObject()
    self:SetCacheMode(UIDefine.CacheMode.destroy)
end

function DebugGOAPView:__Show()
	self:ShowGobalAttrItems()
end

function DebugGOAPView:ShowGobalAttrItems()
    self:PushAllUITmpObject("GobalAttrItem", self.AttrItemCache_rect)
	TableUtils.ClearTable(self.gobalAttrsObjs)
	for k, v in pairs(self.globalStates) do
		local obj = self:GetAttrItemObj()
		obj.GobalAttrName_txt.text = k
		obj.GobalAttrSlider_sld.maxValue = maxValue
		obj.GobalAttrSlider_sld.minValue = 0
		obj.GobalAttrSlider_sld.value = v
		obj.GobalAttrSlider_sld.onValueChanged:AddListener(function(value) 
			obj.GobalAttrValue_txt.text = value
		end)
		obj.GobalAttrValue_txt.text = v
		self.gobalAttrsObjs[k] = obj
	end
end

function DebugGOAPView:GetAttrItemObj()
    local obj = self:PopUITmpObject("GobalAttrItem")
    obj.objectTransform:SetParent(self.GobalAttrContent.transform)
    UnityUtils.SetLocalScale(obj.objectTransform, 1, 1, 1)
    UnityUtils.SetLocalPosition(obj.objectTransform, 0, 0, 0)
    UtilsUI.GetContainerObject(obj.objectTransform, obj)
    UtilsUI.SetActive(obj.object, true)
    return obj
end

function DebugGOAPView:OnClick_Apply()
	for k, v in pairs(self.globalStates) do
		self.globalAttrs:ChangeStateValue(k, tonumber(self.gobalAttrsObjs[k].GobalAttrValue_txt.text))
	end
end

function DebugGOAPView:OnClick_Refresh()
	if not self.gobalAttrsObjs or not next(self.gobalAttrsObjs) then
		return 
	end
	for k, v in pairs(self.globalStates) do
		self.gobalAttrsObjs[k].GobalAttrValue_txt.text = self.globalStates[k]
		self.gobalAttrsObjs[k].GobalAttrSlider_sld.value = v
	end
end

function DebugGOAPView:OnClick_Close()
	PanelManager.Instance:ClosePanel(self)
end

function DebugGOAPView:Hide()
	for k, v in pairs(self.globalStates) do
		self.globalAttrs:RemoveListener(k, self:ToFunc("TestReSetGoal")) 
	end
end

function DebugGOAPView:__delete()
	
end
