GmProfilerWindow = BaseClass("GmProfilerWindow", BaseWindow)

local CUSTOM_TAB = 9
local MemoryProfilerMgr = CS.GameProfiler.MemoryProfilerMgr
local AssetTabFun = 
{
    [1] = {CountFunc = "ShowTextureCountInfo", ItemFunc = "ShowTextureItemInfo"},
    [2] = {CountFunc = "ShowMeshCountInfo", ItemFunc = "ShowMeshItemInfo"},
    [3] = {CountFunc = "ShowClipCountInfo", ItemFunc = "ShowClipItemInfo"},
    [4] = {CountFunc = "ShowParticleCountInfo", ItemFunc = "ShowParticleItemInfo"},
    [5] = {CountFunc = "ShowAnimatorCountInfo", ItemFunc = "ShowAnimatorItemInfo"},
}

function GmProfilerWindow:__init()
    self.curTab = 0
    self.curAssetTab = 0
    self.itemObjList = {}
    self:SetAsset("Prefabs/UI/MemoryProfiler/MemoryProfilerWindow.prefab")
end

function GmProfilerWindow:__CacheObject()
    self.SearchTextTmp = self.SearchInput:GetComponent(TMP_InputField)
end

function GmProfilerWindow:__BindListener()
    self:BindCloseBtn(self.BtnClose_btn, self:ToFunc("OnHide"), self:ToFunc("OnClick_Close"))
    self.SearchTextTmp.onEndEdit:AddListener(self:ToFunc("OnEndEdit"))

    for i = 2, 7 do
        local OnCallBack = function()
            self:OnAssetSort(i)
        end
        self["BtnProp"..i.."_btn"].onClick:AddListener(OnCallBack)
    end
end


function GmProfilerWindow:__Hide()
 
end

function GmProfilerWindow:__Show()
    self.customTramsform = self.args
    self.memoryProfilerMgr = MemoryProfilerMgr.Instance
    self:InitTabData()

    local toggleList = {}
    for i = 1, CUSTOM_TAB do
        table.insert(toggleList, self["BtnTab"..i.."_tog"])
    end
    self.toggleTab = ToggleTab.New()
    local defalutSelect = self.customTramsform and CUSTOM_TAB or 0
    self.toggleTab:InitByToggles(toggleList, function(curSelect)
        self:SelectTab(curSelect)
    end, defalutSelect, false)
    if defalutSelect > 0 then
        self:SelectTab(defalutSelect)
    end

    -- 有自定义节点，默认跳自定义节点
    if self.customTramsform then
        UtilsUI.GetText(self["BtnTab9"].transform:Find("Text")).text = self.customTramsform.name
    end

    local toggleAssetList = {}
    for i = 1, 5 do
        table.insert(toggleAssetList, self["BtnAsset"..i.."_tog"])
    end
    self.toggleAssetTab = ToggleTab.New()
    self.toggleAssetTab:InitByToggles(toggleAssetList, function(curSelect)
        self:SelectAssetTab(curSelect)
    end, 1, false)
    self:SelectAssetTab(1)
end


function GmProfilerWindow:InitTabData()
     local clientFight = BehaviorFunctions.fight.clientFight
     self.tabData = {
        [1] = {transform = clientFight.fightRootTrans},
        [2] = {transform = clientFight.assetPoolRoot.transform},
        [3] = {transform = clientFight.clientEntityManager.entityRoot.transform},
		[4] = {transform = self.memoryProfilerMgr:GetSceneBlockTransform(-1)},
		[5] = {transform = self.memoryProfilerMgr:GetSceneBlockTransform(0)},
		[6] = {transform = self.memoryProfilerMgr:GetSceneBlockTransform(1)},
		[7] = {transform = self.memoryProfilerMgr:GetSceneBlockTransform(2)},
		[8] = {transform = self.memoryProfilerMgr:GetSceneBlockTransform(3)},
     }

    if self.customTramsform then
        self.tabData[CUSTOM_TAB] = {transform = self.customTramsform}
    end

     for k, v in pairs(self.tabData) do
         v.profiler = self.memoryProfilerMgr:CreateMemoryProfiler(v.transform, k)
     end
end

function GmProfilerWindow:SelectTab(curSelect)
    self.curTab = curSelect
    self:ShowProfilerDetail()
end

function GmProfilerWindow:SelectAssetTab(curSelect)
    self.curAssetTab = curSelect

    local assetTitle = GMProfilerConfig.AssetPropety[curSelect]
    for i = 1, 8 do
        local text = assetTitle.titleList[i]
        if text then
            self["AssetProp"..i]:SetActive(true)
            self["LabelAsset"..i.."_txt"].text =text
        else
            self["AssetProp"..i]:SetActive(false)
        end
    end

    self:ShowProfilerDetail()
end

function GmProfilerWindow:RefreshItemList()
    self.ItemList_recyceList:SetLuaCallBack(self:ToFunc("RefreshItemCell"))
    self.ItemList_recyceList:SetCellNum(#self.itemList)  
end

function GmProfilerWindow:RefreshItemCell(index, go)
    if not go then
        return
    end

    local itemObj
    if self.itemObjList[index] then
        itemObj = self.itemObjList[index].itemObj
    else
		itemObj = UtilsUI.GetContainerObject(go)
       if ctx.Editor then
            local OnCallBack = function ()
                local itemInfo = self.itemList[index]
                -- 特效调整gameobject
                if self.curAssetTab ~= 4 then
                    MemoryProfilerMgr.SelectToAsset(itemInfo.instanceId)
                end
            end
            itemObj.BtnSelect_btn.onClick:AddListener(OnCallBack)
        end
        self.itemObjList[index] = {}
        self.itemObjList[index].go = go
        self.itemObjList[index].itemObj = itemObj
    end  
    self[self.assetTabInfo.ItemFunc](self, index, itemObj)

    itemObj.ImageBg:SetActive(index % 2 == 1)
    for i = 1, 5 do 
        itemObj["Icon"..i]:SetActive(i == self.curAssetTab)
    end
end

function GmProfilerWindow:ShowProfilerDetail()
    if self.curTab == 0 or self.curAssetTab == 0 then
        return
    end

    self.curTabInfo = self.tabData[self.curTab]
    self.curProfiler = self.curTabInfo.profiler
    self.assetProfiler = self.curProfiler:GetAssetProfiler(self.curAssetTab)

    self:ShowCommonCountInfo()
    self.assetTabInfo = AssetTabFun[self.curAssetTab]
    self[self.assetTabInfo.CountFunc](self)
    self.itemListBack = self.itemList
    self:RefreshItemList()
end

function GmProfilerWindow:ShowCommonCountInfo()
    local str = string.format("节点: %s    内存: %s/%s   (当前/最大)", 
        self.curTabInfo.transform.name, self.assetProfiler.curMemoryStr, self.assetProfiler.maxMemoryStr)
    self.LableDetail2_txt.text = str
end

function GmProfilerWindow:ShowTextureCountInfo()
    local itemList = self.assetProfiler.texList
    local str = string.format("资源: %d", itemList.Count)
    self.LabelDetail1_txt.text = str
    self.itemList = {}
    for i = 1, itemList.Count do
        table.insert(self.itemList, itemList[i-1])
    end
end

function GmProfilerWindow:ShowTextureItemInfo(index, itemObj)
    local itemInfo = self.itemList[index]
    itemObj.Text1_txt.text = itemInfo.name
    itemObj.Text2_txt.text = itemInfo.memorySize
    itemObj.Text3_txt.text = itemInfo.maxReference
    itemObj.Text4_txt.text = itemInfo.width.."/"..itemInfo.height
    itemObj.Text5_txt.text = itemInfo.format
    itemObj.Text6_txt.text = itemInfo.mipmapCount
    itemObj.Text7_txt.text = ""
    itemObj.Text8_txt.text = ""
end

function GmProfilerWindow:ShowMeshCountInfo()
	local itemList = self.assetProfiler.meshList
	local str = string.format("资源: %d    顶点: %d/%d   三角形: %d/%d  (当前/最大)", itemList.Count,
		self.assetProfiler.curVertex, self.assetProfiler.maxVertex, 
		self.assetProfiler.curTrangles, self.assetProfiler.maxTrangles)
	self.LabelDetail1_txt.text = str
	self.itemList = {}
	for i = 1, itemList.Count do
		table.insert(self.itemList, itemList[i-1])
	end
end

function GmProfilerWindow:ShowMeshItemInfo(index, itemObj)
    local itemInfo = self.itemList[index]
    itemObj.Text1_txt.text = itemInfo.name
    itemObj.Text2_txt.text = itemInfo.memorySize
    itemObj.Text3_txt.text = itemInfo.maxReference
    itemObj.Text4_txt.text = itemInfo.vertex
    itemObj.Text5_txt.text = itemInfo.trangles
    itemObj.Text6_txt.text = itemInfo.normal
    itemObj.Text7_txt.text = itemInfo.colors
    itemObj.Text8_txt.text = itemInfo.tangents
end

function GmProfilerWindow:ShowClipCountInfo()
	local itemList = self.assetProfiler.aniClipList
	local str = string.format("资源: %d", itemList.Count)
	self.LabelDetail1_txt.text = str
	self.itemList = {}
	for i = 1, itemList.Count do
		table.insert(self.itemList, itemList[i-1])
	end
end

function GmProfilerWindow:ShowClipItemInfo(index, itemObj)
    local itemInfo = self.itemList[index]
    itemObj.Text1_txt.text = itemInfo.name
    itemObj.Text2_txt.text = itemInfo.memorySize
    itemObj.Text3_txt.text = itemInfo.maxReference
    itemObj.Text4_txt.text = string.format("%.2f", itemInfo.timeLength)
    itemObj.Text5_txt.text = itemInfo.frameRate
    itemObj.Text6_txt.text = ""
    itemObj.Text7_txt.text = ""
    itemObj.Text8_txt.text = ""
end

function GmProfilerWindow:ShowParticleCountInfo()
	local itemList = self.assetProfiler.particleList
	local str = string.format("资源: %d    播放:%d/%d   (当前/最大)", itemList.Count,
		self.assetProfiler.curPlaying, self.assetProfiler.maxPlaying)
	self.LabelDetail1_txt.text = str
	self.itemList = {}
	for i = 1, itemList.Count do
		table.insert(self.itemList, itemList[i-1])
	end
end

function GmProfilerWindow:ShowParticleItemInfo(index, itemObj)
    local itemInfo = self.itemList[index]
    itemObj.Text1_txt.text = itemInfo.name
    itemObj.Text2_txt.text = itemInfo.memorySize
    itemObj.Text3_txt.text = itemInfo.maxReference
    itemObj.Text4_txt.text = ""
    itemObj.Text5_txt.text = ""
    itemObj.Text6_txt.text = ""
    itemObj.Text7_txt.text = ""
    itemObj.Text8_txt.text = ""
end

function GmProfilerWindow:ShowAnimatorCountInfo()
    local itemList = self.assetProfiler.animatorList
    local str = string.format("资源: %d ", itemList.Count)
    self.LabelDetail1_txt.text = str
    self.itemList = {}
    for i = 1, itemList.Count do
        table.insert(self.itemList, itemList[i-1])
    end
end

function GmProfilerWindow:ShowAnimatorItemInfo(index, itemObj)
    local itemInfo = self.itemList[index]
    itemObj.Text1_txt.text = itemInfo.name
    itemObj.Text2_txt.text = itemInfo.memorySize
    itemObj.Text3_txt.text = itemInfo.maxReference
    itemObj.Text4_txt.text = ""
    itemObj.Text5_txt.text = ""
    itemObj.Text6_txt.text = ""
    itemObj.Text7_txt.text = ""
    itemObj.Text8_txt.text = ""
end

function GmProfilerWindow:OnHide()
    WindowManager.Instance:CloseWindow(self)
end

function GmProfilerWindow:OnEndEdit()
    local searchText = self.SearchTextTmp.text
    if searchText == "" then
        self.itemList = self.itemListBack
        self:RefreshItemList()
        return 
    end
    
    local newItemList = {}
    for k, v in pairs(self.itemListBack) do
        if string.find(v.name, searchText) then
            table.insert(newItemList, v)
        end
    end
    self.itemList = newItemList
    self:RefreshItemList() 
end

function GmProfilerWindow:OnAssetSort(memIndex)
    local assetInfoCfg = GMProfilerConfig.AssetPropety[self.curAssetTab]
    local memberName = assetInfoCfg.memberSortList[memIndex]
    if memberName and memberName ~= "" then
        local onSort = function (a, b)
            return a[memberName] > b[memberName]
        end
        table.sort(self.itemList, onSort)
		self:RefreshItemList()
    end
end

function GmProfilerWindow:UpdateCustomTrasform(transform)
	self.customTramsform = transform
	local profiler = self.memoryProfilerMgr:CreateMemoryProfiler(transform, CUSTOM_TAB)
    self.tabData[CUSTOM_TAB] = {transform = transform, profiler = profiler} 
    UtilsUI.GetText(self["BtnTab9"].transform:Find("Text")).text = self.customTramsform.name
    if self.curTab ~= CUSTOM_TAB then
        self:SelectTab(CUSTOM_TAB)
    else
        self:ShowProfilerDetail()
    end
end




