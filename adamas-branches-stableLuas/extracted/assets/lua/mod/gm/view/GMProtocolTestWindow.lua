--GM协议测试窗口
GMProtocolTestWindow = BaseClass("GMProtocolTestWindow", BaseWindow)

local ptDefine = require("data/proto/pt_define")
--require("data/proto/protocolExportToLua")
require("mod/fight/view/debug/main_debug/test_debug/protocolExportToLua")
local _tinsert = table.insert
local _tsort = table.sort

function GMProtocolTestWindow:__init()
    self.itemObjList = {}
    self.rightObjList = {}
    self:SetAsset("Prefabs/UI/Gm/GMProtocolTestWindow.prefab")
end

function GMProtocolTestWindow:__CacheObject()
    self.SearchTextTmp = self.SearchInput:GetComponent(TMP_InputField)
    self:SetCacheMode(UIDefine.CacheMode.destroy)
end

function GMProtocolTestWindow:__BindListener()
    self:BindCloseBtn(self.BtnClose_btn, self:ToFunc("OnHide"), self:ToFunc("OnClick_Close"))
    self.cancelBtn_btn.onClick:AddListener(self:ToFunc("OnCancelEdit"))
    self.SearchTextTmp.onEndEdit:AddListener(self:ToFunc("OnEndEdit"))
    self.SendMassageBtn_btn.onClick:AddListener(self:ToFunc("OnSendMsg"))
end

function GMProtocolTestWindow:__Hide()

end

function GMProtocolTestWindow:__delete()
    mod.GmCtrl:SetProtocolDebug(false)
    self:ClearRecyList()
    self.itemObjList = {}
end

function GMProtocolTestWindow:ClearRecyList()
    if self.ItemList_recyceList then
        self.ItemList_recyceList:CleanAllCell()
    end
end

function GMProtocolTestWindow:__Show()
    --initData
    --打开打印回包开关
    mod.GmCtrl:SetProtocolDebug(true)
    self:InitData()
    self:RefreshItemList()
end

function GMProtocolTestWindow:InitData()
    --协议表 --筛出req
    local data = {}
    for key, value in pairs(ptDefine.MSG_ID) do
        if string.find(key, "req") and GmConfig.ProtocolExportData[key] then
            _tinsert(data, {name = key, id = value})
        end
    end
    --按id排序
    _tsort(data, function(a, b)
        return a.id < b.id
    end)
    self.itemListBack = data
    self.itemList = data
end

function GMProtocolTestWindow:RefreshItemList(isReset)
    isReset = isReset or false
    if isReset then
        self.itemObjList = {}
    end
    self.ItemList_recyceList:SetLuaCallBack(self:ToFunc("RefreshItemCell"))
    self.ItemList_recyceList:SetCellNum(#self.itemList, isReset)
end

function GMProtocolTestWindow:RefreshItemCell(index, go)
    if not go then
        return
    end

    local data = self.itemList[index]
    local itemObj
    if self.itemObjList[index] then
        itemObj = self.itemObjList[index].itemObj
    else
        itemObj = UtilsUI.GetContainerObject(go)
        self.itemObjList[index] = {}
        self.itemObjList[index].go = go
        self.itemObjList[index].itemObj = itemObj
    end
    --刷新文本
    itemObj.Text_txt.text = string.format("['%s'] = %s", data.name, data.id)
    --注册监听
    itemObj.BtnSelect_btn.onClick:RemoveAllListeners()
    itemObj.BtnSelect_btn.onClick:AddListener(function()
        self.selectIndex = index
        self:RefreshRightPanel()
    end)
end

function GMProtocolTestWindow:OnHide()
    WindowManager.Instance:CloseWindow(self)
end

function GMProtocolTestWindow:OnEndEdit()
    local searchText = self.SearchTextTmp.text
    if searchText == "" then
        self.itemList = self.itemListBack
        self:RefreshItemList(true)
        return
    end

    local newItemList = {}
    for k, v in pairs(self.itemListBack) do
        if string.find(v.name, searchText) then
            _tinsert(newItemList, v)
        end
    end
    self.itemList = newItemList
    self:RefreshItemList(true)
end

function GMProtocolTestWindow:OnCancelEdit()
    self.SearchTextTmp.text = ""
    self.itemList = self.itemListBack
    self:RefreshItemList(true)
end

function GMProtocolTestWindow:OnSendMsg()
    if not self.selectIndex then return end 
    --获取协议名，参数data
    --发包
    local data = {}
    for i, node in pairs(self.rightObjList) do
        local name, childData = node:GetInput()
        data[name] = childData
    end
    local protoData = self.itemList[self.selectIndex]
    Network.Instance:Send(protoData.name, data)
end

function GMProtocolTestWindow:ClearRightPanel()
    for i, v in pairs(self.rightObjList) do
        v:DeleteMe()
    end
    TableUtils.ClearTable(self.rightObjList)
end

function GMProtocolTestWindow:UpdateSelectView()
    local data = self.itemList[self.selectIndex]
    self.selectName_txt.text = data.name
end

function GMProtocolTestWindow:RefreshRightPanel()
    self:UpdateSelectView()
    self:ClearRightPanel()
    --int32
    --uint32
    --string
    --bool
    --int64
    --uint64
    --repeated
    --map<a,b>
    --其他
    local data = self.itemList[self.selectIndex]
    local proto = GmConfig.ProtocolExportData[data.name]
    for key, value in pairs(proto) do
        self:InstanceControlNode(key)
    end
    --延迟一帧设置排列
    BehaviorFunctions.AddDelayCallByFrame(1,self.ParamsContent.transform.gameObject, function()
        if self.ParamsContent then
            LayoutRebuilder.ForceRebuildLayoutImmediate(self.ParamsContent.transform)
        end
    end)
end

function GMProtocolTestWindow:InstanceControlNode(key)
    --判断类型，使用不同的控件
    --长度>=3，(数组 类型 名字)/(map<>)
    --长度为2个, 类型 名字
    --key --读取按__划分 
    local split = StringHelper.Split(key, "__")
    local obj 
    if #split == 2 then
        if GmConfig.protocolSingleType[split[1]] then
            obj = self:GetSingleNode(split[2], self.ParamsContent)
        else
            obj = self:GetStructNode(split[1], split[2], self.ParamsContent)
        end
    else
        if split[1] == "repeated" then
            obj = self:GetRepeatedNode(split[2], split[3], self.ParamsContent)
        elseif split[1] == "map" then
            obj = self:GetMapNode(split[2], split[3], split[5], self.ParamsContent) 
        end
    end
    _tinsert(self.rightObjList, obj)
end

--获取数组节点
function GMProtocolTestWindow:GetRepeatedNode(protoType, name, parent)
    local item = GMRepeatedNode.New(protoType, name, parent)
    return item
end

--获取结构节点
function GMProtocolTestWindow:GetStructNode(protoType, name, parent)
    local item = GMStructNode.New(protoType, name, parent)
    return item
end

--获取普通节点
function GMProtocolTestWindow:GetSingleNode(name, parent)
    local item = GMSingleNode.New(name, parent)
    return item
end

--获取map节点
function GMProtocolTestWindow:GetMapNode(protoType1, protoType2, name, parent)
    local item = GMMapNode.New(protoType1, protoType2, name, parent)
    return item
end





