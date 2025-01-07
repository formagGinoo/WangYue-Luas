MessageSortPanel = BaseClass("MessageSortPanel", BasePanel)

local infor = Config.DataMessageScreen.Find

function MessageSortPanel:__init()
    self:SetAsset("Prefabs/UI/Message/MessageSortPanel2.prefab")
    self.MessageContents={}
    self.sortItemList = {}
    self.SiftMessage = {}
    self.SelectType = nil --用来存储当前选择的类型的名称
end

function MessageSortPanel:__CacheObject()
    self:SetCacheMode(UIDefine.CacheMode.destroy)
end

function  MessageSortPanel:__BindEvent()

end

function MessageSortPanel:__delete()
  if self.MessageContents then
    self.MessageContents ={}
  end
  if self.sortItemList then
    self.sortItemList ={}
  end
  if self.SiftMessage then
    self.SiftMessage ={}
  end
  if self.SelectType then
    self.SelectType =nil
  end
end

function MessageSortPanel:__BindListener()

    self.CancaleBtn_btn.onClick:AddListener(self:ToFunc("OnClick_CancaleBtn"))   --取消选中
    self.EnterBtn_btn.onClick:AddListener(self:ToFunc("OnClick_EnterBtn"))       --确认筛选
    self.SelectCloseBtn_btn.onClick:AddListener(self:ToFunc("OnClick_Close"))
end

function MessageSortPanel:__Show()
    if self.args then
        self.callBackFunc = self.args.callBackFunc
    end
    self:SetInforType()
    self:CreatSortItem()
end

function MessageSortPanel:SetInforType()
     self.screenTypes = {}
    for index, value in ipairs(infor) do
        local type = value.screen_type

        if not self.screenTypes[type] then
            self.screenTypes[type] = {}
        end
        table.insert(self.screenTypes[type],value)
    end
end

function MessageSortPanel:CreatSortItem()

    for k, v in pairs(self.sortItemList) do
		v.toggle.onValueChanged:RemoveAllListeners()
		self:PushUITmpObject("sortItem", v, self.transform)
	end

	self.sortItemList = {}

    for key, value in pairs(self.screenTypes) do
        for k, v in ipairs(value) do
            local objectInfo, new = self:PopUITmpObject("sortItem")
            table.insert(self.sortItemList, objectInfo)
    
            if new then
                objectInfo.toggle = objectInfo.objectTransform:GetComponent(Toggle)
            end

            local OnToggle1 = function()
                self:SelectByGroup(v.parameter)
                objectInfo.Selected:SetActive(objectInfo.toggle.isOn)
                objectInfo.DefaultTextBai_txt.text = objectInfo.DefaultText_txt.text
            end
            
            local OnToggle2 = function()
                self:SelectByType(v.parameter)
                objectInfo.Selected:SetActive(objectInfo.toggle.isOn)
                objectInfo.DefaultTextBai_txt.text = objectInfo.DefaultText_txt.text
            end
            objectInfo.toggle.isOn = false
            if key ==1 then
                objectInfo.toggle.onValueChanged:AddListener(OnToggle1)
                local name = Config.DataMessageType.Find[v.parameter].message_main_name
                objectInfo.DefaultText_txt.text = name
                objectInfo.object.transform:SetParent(self.SortList.transform)
            elseif key ==2 then
                objectInfo.toggle.onValueChanged:AddListener(OnToggle2)
                if v.parameter==1 then
                    objectInfo.DefaultText_txt.text = TI18N("个人")
                elseif v.parameter==2 then
                    objectInfo.DefaultText_txt.text = TI18N("群聊")
                elseif v.parameter==0 then
                    objectInfo.DefaultText_txt.text = TI18N("默认")
                    objectInfo.toggle.isOn = true
                end
                objectInfo.object.transform:SetParent(self.SortType.transform)
            end
            objectInfo.object.transform.localScale = Vector3.one
            objectInfo.object:SetActive(true)
        end
    end
end

function MessageSortPanel:SelectByGroup(type)
    self.SiftMessage =  mod.MessageCtrl:GetSiftMessageByGroup(type)
    self.SelectType = Config.DataMessageType.Find[type].message_main_name
end

function MessageSortPanel:SelectByType(type)
    self.SiftMessage =  mod.MessageCtrl:GetSiftMessageByType(type)
    if type ==0 then
        self.SelectType = "默认"
    elseif type ==1 then
        self.SelectType = "个人"
    elseif type ==2 then
        self.SelectType = "群聊"
    end
end

function MessageSortPanel:__Hide()
   
end

function MessageSortPanel:OnClick_Close()
    self.callBackFunc()
end

function MessageSortPanel:OnClick_CancaleBtn()
   self.callBackFunc()
end

function MessageSortPanel:OnClick_EnterBtn()
    --排序
    mod.MessageCtrl:SortMessageLeftPanel(self.SiftMessage,self.SelectType)
    self.callBackFunc()
end