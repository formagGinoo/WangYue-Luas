---@class BaseView : Module
BaseView = BaseClass("BaseView",Module)

function BaseView:__init()
    self.__isCreate = true
    self.__canShow = true
    self.__firstShow = true

    self.gameObject = nil
    self.active = false
    self.viewType = nil
    self.assetList = {}
    self.isDelete = false
    self.assetPath = nil
    self.iconLoaders = {}
    self.refreshParent = false
    self.extendViews = {}
    self:SuperFunc("__ExtendView",true)
    self:SuperFunc("__BindBeforeEvent",true)
    self:ExecuteExtendFun("__BindBeforeEvent",true)

    self.uiTmpObjCache = nil
    self.uiTmpObjMap = nil
end

function BaseView:__delete()
	if not self.isDelete then
		LogError(string.format("View销毁异常,禁止直接调用DeleteMe,改用Destroy[%s]",self.__className))
	end

    if self.extendViews and next(self.extendViews) then
        for k, v in pairs(self.extendViews) do
            v:DeleteMe()
        end
    end
    --assert(self.isDelete,string.format("View销毁异常,禁止直接调用DeleteMe,改用Destroy[%s]",self.__className))
    if not UtilsBase.IsNull(self.gameObject) then 
        if self.fightPreload and Fight.Instance then
            Fight.Instance.clientFight.assetsPool:Cache(self.assetPath, self.gameObject)
        else
		    GameObject.Destroy(self.gameObject)
        end
    end

    self:RemoveLoader()
    self:RemoveSprite()
    self:RemoveBeforeEvent()
    self.gameObject = nil
    self.baseIconLoader = nil
    self:StopDebugDestroy()
    self:RemoveBlurBack()
end

function BaseView:DebugDestroy()
    if ctx.Editor then
        self.debugTimer = LuaTimerManager.Instance:AddTimer(0,3,self:ToFunc("CheckDebug"))
    end
end

function BaseView:CheckDebug()
    if UtilsBase.IsNull(self.gameObject) then
        LogErrorf("BaseView被异常删除[%s][创建堆栈:\n%s]",tostring(self.__className),self.debug)
    end
end

function BaseView:StopDebugDestroy()
    if self.debugTimer then 
		LuaTimerManager.Instance:RemoveTimer(self.debugTimer)
        self.debugTimer = nil 
    end
end

function BaseView:Destroy()
    if self.isDelete then 
        return 
    end
    self.isDelete = true

    self:HideCommonHandle()
    self:RemoveLastingEvent()
    self:DeleteHandle()
end

function BaseView:DeleteHandle()
    self:ExecuteExtendFun("DeleteMe")
    self:DeleteMe()
end

function BaseView:HideHandle()
    self:HideCommonHandle()
    self:SetActive(false)
    self.isHideing = false
end

function BaseView:HideCommonHandle()
    if not self.active then 
        return 
    end
    self.__firstShow = true
    self.active = false
    self:RemoveEvent()
    self:_RemoveRedPoint()
    self:_RemoveRedEvent()
    self:SuperFunc("__Hide",false)
    self:ExecuteExtendFun("__Hide",false)
end

function BaseView:SetObject(gameObject)
    if not gameObject then
        return
    end

    self.gameObject = gameObject
    self:SetObjectName()

    self.transform = self.gameObject.transform
    self.rectTrans = self:Find(nil,RectTransform)
end

function BaseView:SetObjectName()
    if ctx.Editor then
        local name = string.match(self.assetPath, ".*/(.-)%.")
        if name ~= self.__className then
            self.gameObject.name = string.format("%s prefab: %s", self.__className, name)
        else
            self.gameObject.name = self.__className
        end
    else
        self.gameObject.name = self.__className
    end
end

function BaseView:SetParent(parent,x,y)
    self.refreshParent = true
    self.parent = parent
    self.x = x
    self.y = y
    if self:IsValid() then self:RefreshParent() end
end

function BaseView:RefreshParent()
    if not self.refreshParent then
        return
    end
    self.refreshParent = false

    if self.parent and UtilsBase.IsNull(self.parent) then
        LogErrorf("BaseView设置的父节点已经被删除了,但是没有调用(Hide、Destroy)函数[%s]",tostring(self.__className))
        return
    end

    self.transform:SetParent(self.parent, false)
    UnityUtils.SetAnchoredPosition(self.transform,self.x or 0,self.y or 0)
    UnityUtils.SetLocalScale(self.transform,1,1,1)
    local uiAdaptor = self.transform:GetComponent(UIAdaptor)
    if uiAdaptor then
        uiAdaptor:UpdateScreenInfo()
    end
end

function BaseView:Show(args)
    self.args = args or self.args
    if not self.__canShow then 
        self.__canShow = true 
    end
    if not self:ShowObject() then 
        self:LoadAsset()
    end
    if not self._orderId or self._orderId == 0 then
        self._orderId = UIDefine.GetOrderId()
    end
    EventMgr.Instance:Fire(EventName.UIOpen, self.__className)
end

function BaseView:Hide()
    self:__BaseHide()

    if self:LoadAsseting() then 
        self.__canShow = false 
        return 
    end

    if not self.active or self.isHideing then 
        return 
    end

    self.isHideing = true
    self:CloseComplete()

    self._orderId = 0

    EventMgr.Instance:Fire(EventName.UIHide, self.__className)
    EventMgr.Instance:Fire(EventName.TipHideEvent, self.__className) 
end

function BaseView:CloseComplete()
    self.isHideing = false
    self:HideHandle()
end

function BaseView:ShowObject()
    if UtilsBase.IsNull(self.gameObject) then 
        return false 
    end

    self:FirstCreate()
    if not self.__canShow then
        self.__canShow = true
        self:SetActive(false)
        return false
    end

    self:RepeatShow()
    self:FirstShow()
    self:ShowBlurBack()
    if not self.blurBack then
        self:SuperFunc("__ShowComplete", true)
    end
    self:RefreshRedPoint()
    
    return true
end

function BaseView:FirstCreate()
    if not self.__isCreate then 
        return 
    end
    self.__isCreate = false
    self:RefreshParent()
	self:InitContainerObjList()
    self:CreateAction(self)
    self:InitAnimation()
    --self:DebugDestroy()
end

function BaseView:CreateAction(view)
    view:__BaseCreate()
    self:SuperFunc("__CacheObject",true)
    self:ExecuteExtendFun("__CacheObject",true)
    self:SuperFunc("__Create",true)
    self:ExecuteExtendFun("__Create",true)
    self:SuperFunc("__BindListener",true)
    self:ExecuteExtendFun("__BindListener",true)
    self:SuperFunc("__BindLastingEvent",true)
    self:ExecuteExtendFun("__BindLastingEvent",true)
end

function BaseView:InitAnimation()
    if not self.animationSetting then
        self.animationSetting = self.gameObject:GetComponent(UIAnimationSetting)
    end
    local func = function ()
        self.isExiting = false
        if self.SuperFunc then --可能提前被销毁
            self:SuperFunc("__AfterExitAnim",true)
        end
        if self._closeFunc then
            self._closeFunc()
        end
    end

    local animationSetting = self.animationSetting
    if animationSetting then
        UtilsUI.SetHideCallBack(animationSetting.HideNode, func)
    elseif self.hideNode then
        self[self.hideNode.."_hcb"].HideAction:RemoveAllListeners()
        self[self.hideNode.."_hcb"].HideAction:AddListener(func)
    end
end

function BaseView:Active()
    return self.active
end

function BaseView:FirstShow()
    if not self.__firstShow then 
        return 
    end
    self.__firstShow = false
    self:RefreshParent()
    self.active = true
    self.isHideing = false
    self:SetActive(true)
    self:firstShowAction(self)
    

    if self.soundBinder then
        self.soundBinder:PlayEnterSound()
    end
end

function BaseView:firstShowAction(view)
    view:__BaseShow()
    self:SuperFunc("__BindEvent",true)
    self:ExecuteExtendFun("__BindEvent",true)
    self:SuperFunc("__Show",true)
    self:ExecuteExtendFun("__Show",true)
    self:_AddRedEvent()
end

function BaseView:RepeatShow()
    if self.__firstShow then 
        return 
    end
    self:SuperFunc("__RepeatShow",true)
    self:ExecuteExtendFun("__RepeatShow",true)
end

function BaseView:LoadAsset()
    if self:LoadAsseting() then 
        return 
    end

    if not self.assetPath then
        Log("UI资源路径为空，请调用SetAsset接口设置") 
    end

    self:MergeAsset()

    if Fight.Instance and Fight.Instance.clientFight.assetsPool:Contain(self.assetPath) then
        local obj = Fight.Instance.clientFight.assetsPool:Get(self.assetPath, true)
        self:SetObject(obj)
        UnityUtils.SetAnchorMinAndMax(self.rectTrans,0,0,1,1)
        UnityUtils.SetOffsetMinAndMax(self.rectTrans,0,0,0,0)
        UnityUtils.SetLocalScale(self.rectTrans,1,1)
        UnityUtils.SetLocalPosition(self.rectTrans,0,0,0)
        UnityUtils.SetAnchored3DPosition(self.rectTrans,0,0,0)
        self.fightPreload = true
		self:ShowObject()
		return 
    end

    if not self.assetList or #self.assetList <= 0 or self.fightPreload then 
        self:AssetLoaded()
    else

        self.assetLoader = AssetMgrProxy.Instance:GetLoader(self.__className)
        self.assetLoader:AddListener(self:ToFunc("AssetLoaded"))
        self.assetLoader:LoadAll(self.assetList)
    end
end

function BaseView:AssetLoaded()
    self.gameObject = self.gameObject or self:GetObject(self.assetPath)
    self:SetObjectName()
    self.transform = self.gameObject.transform
    self.rectTrans = self:Find(nil,RectTransform)
    self:ShowObject()
    --self:RemoveLoader()
end

function BaseView:GetObject(file,parent,instantiateInWorldSpace)
    if self.assetLoader then
        return self.assetLoader:Pop(file,parent,instantiateInWorldSpace)
    end
end

function BaseView:RemoveLoader()
    if self.assetLoader then
        AssetMgrProxy.Instance:CacheLoader(self.assetLoader)
        self.assetLoader = nil
    end
end

function BaseView:SetViewType(viewType)
    self.viewType = viewType
end

function BaseView:SetAsset(file)
    if UtilsUI.CheckPCPlatform() then
        file = WindowDefine.PCPanel[file] or file
    end
    assert(self.assetPath == nil, "禁止多次设置UI资源路径")
    self.assetPath = file
end

function BaseView:SetBlurBack(setting, callback)
    if not self.blurBack then
        setting = setting or { bindNode = self.BlurNode }
        self.blurBack = BlurBack.New(self, setting)
    end
    self.blurBackCallback = callback
end

function BaseView:RemoveBlurBack()
    if self.blurBack then
        self.blurBack:Destroy()
        self.blurBack = nil
        self.blurBackCallback = nil
    end
end

function BaseView:ShowBlurBack()
    if self.blurBack then
        self:SetActive(false)
        self.blurBack:Show({function()
            if self.blurBackCallback then
                self.blurBackCallback()
            end
            self:SuperFunc("__ShowComplete", true)
        end})
    end
end

function BaseView:AddAsset(file,assetType)
    table.insert(self.assetList,{path = file, type = assetType})
end

function BaseView:MergeAsset()
    table.insert(self.assetList,{path = self.assetPath, type = AssetType.Prefab})
end

function BaseView:Find(path,component,transform)
    if not transform then transform = self.transform end
    if path then transform = transform:Find(path) end
    if not transform then return nil end
    return component and transform:GetComponent(component) or transform
end

function BaseView:SetSprite(image,path,name,nativeSize)
    if not self.baseIconLoader then 
        self.baseIconLoader = BaseIconLoader.New() 
    end
    self.baseIconLoader:setSprite(image,path,name,nativeSize)
end

function BaseView:RemoveSprite(image)
    if not self.baseIconLoader then 
        return 
    end

    if not image then
        self.baseIconLoader:pushAllIconLoader()
    else
        self.baseIconLoader:pushIconLoader(image) 
    end
end

function BaseView:SetActive(active)
	 if self.animationSetting then
		UtilsUI.SetActiveByPosition(self.gameObject, active)
	 else
		UtilsUI.SetActive(self.gameObject, active)
	 end
end

function BaseView:LoadAsseting()
    return not UtilsBase.IsNull(self.assetLoader) and self.assetLoader.isLoading
end

function BaseView:ExtendView(view)
    assert(view ~= nil,"扩展类不存在")
	if not view._extendView then
		LogError(string.format("扩展类异常[%s]",tostring(view.__className)))
	end
    --assert(view._extendView,string.format("扩展类异常[%s]",tostring(view.__className)))

    local extendView = view.New(self)
	if not extendView then
		LogError(string.format("扩展类所属模块不一致[%s]",tostring(view.__className)))
	end
    --assert(extendView.module == self.module,string.format("扩展类所属模块不一致[%s]",tostring(view.__className)))
    table.insert(self.extendViews,extendView)
    return extendView
end

function BaseView:ExecuteExtendFun(fn,flag,...)
    for _,view in ipairs(self.extendViews) do
        view:SuperFunc(fn,flag,...)
    end
end

function BaseView:Create()
    if not self.__isCreate or self:LoadAsseting() then 
        return 
    end

    if not UtilsBase.IsNull(self.gameObject) then
        return
    end

    self.__canShow = false
    self:LoadAsset()
end

function BaseView:SetTopLayer(canvas)
    canvas.sortingOrder = WindowManager.Instance:GetMaxOrderLayer()
end

function BaseView:SetOrder()
    local canvas = self:Find(nil,Canvas)
    canvas.sortingOrder = UIDefine.Layer[self.name] or 0
end

function BaseView:BindEvent(event,extendView)
    local view = extendView or self
    self:AssertEvent(event,view)
    local func = view:ToFunc(event.value)
    self.module:BindEvent(event,func)
    if not self.events then self.events = {} end
    table.insert(self.events,{event = event,func = func})
end

function BaseView:BindLastingEvent(event,extendView)
    local view = extendView or self
    self:AssertEvent(event,view)
    local func = view:ToFunc(event.value)
    self.module:BindEvent(event,func)
    if not self.lastingEvents then self.lastingEvents = {} end
    table.insert(self.lastingEvents,{event = event,func = func})
end

function BaseView:BindBeforeEvent(event,extendView)
    local view = extendView or self
    self:AssertEvent(event,view)
    local func = view:ToFunc(event.value)
    self.module:BindEvent(event,func)
    if not self.beforeEvents then self.beforeEvents = {} end
    table.insert(self.beforeEvents,{event = event,func = func})
end

local debugEvents = {}
function BaseView:AssertEvent(event,view)
    assert(self.module ~= nil, "BaseView添加事件失败[error:当前类缺失所属模块]")
    assert(event ~= nil, "BaseView添加事件失败[error:传入了空的事件]")
    assert(event._enum, "BaseView添加事件失败[error:传入的不是事件]")

    if not debugEvents[event.value] then
        debugEvents[event.value] = event.id
    elseif debugEvents[event.value] ~= event.id then
        assert(false,string.format("同一模块重复定义了相同事件[模块:%s][事件:%s]",self.module.__className,event.value))
    end

    -- TODO 
    -- assert((view.Event and event == view.Event[event.value]) or (self.module.Event and event == self.module.Event[event.value]), "禁止传入其它模块的事件")
    if not view[event.value] then
		LogError(string.format("BaseView添加事件失败[error:未实现回调函数(%s)]",event.value))
	end
	--assert(view[event.value], string.format("BaseView添加事件失败[error:未实现回调函数(%s)]",event.value))
end

function BaseView:RemoveEvent()
	debugEvents = {}
    if not self.module or not self.events or #self.events<=0 then return end
    for i,v in ipairs(self.events) do self.module:RemoveEvent(v.event,v.func) end
    self.events = nil
end

function BaseView:RemoveLastingEvent()
    if not self.module or not self.lastingEvents or #self.lastingEvents<=0 then return end
    for i,v in ipairs(self.lastingEvents) do self.module:RemoveEvent(v.event,v.func) end
    self.lastingEvents = nil
end

function BaseView:RemoveBeforeEvent()
    if not self.module or not self.beforeEvents or #self.beforeEvents<=0 then return end
    for i,v in ipairs(self.beforeEvents) do self.module:RemoveEvent(v.event,v.func) end
    self.beforeEvents = nil
end

function BaseView:IsValid()
    return self.gameObject ~= nil
end

function BaseView:InitContainerObjList()
    local uiContainer = self.transform:GetComponent(UIContainer)
    self.soundBinder = self.transform:GetComponent(UISoundBinder)
    if uiContainer then
        local listName = uiContainer.ListName
        local listObjects = uiContainer.ListObj

        local listCompName = uiContainer.ListCompName
        local listCompObjects = uiContainer.ListComponent

        for i = 0, listName.Count - 1 do
            local name = listName[i]
            self[name] = listObjects[i]
        end

        for i = 0, listCompName.Count - 1 do
            local name = listCompName[i]
            self[name] = listCompObjects[i]
        end
    end
end

function BaseView:PopUITmpObject(name, parent)
    local objectInfo = {}
    if self.uiTmpObjCache and self.uiTmpObjCache[name] then
        local objectInfo = self.uiTmpObjCache[name][1]
        if objectInfo then
            table.remove(self.uiTmpObjCache[name], 1)
            objectInfo.object:SetActive(true)
            self:_RecordTmpObject(name, objectInfo)
            if parent then
                objectInfo.objectTransform:SetParent(parent)
                objectInfo.objectTransform:SetAsLastSibling()
            end
            return objectInfo
        end
    end

    objectInfo.object = GameObject.Instantiate(self[name])
    objectInfo.objectTransform = objectInfo.object.transform
    if objectInfo.objectTransform:GetComponent(UIContainer) then
        UtilsUI.GetContainerObject(objectInfo.objectTransform, objectInfo)
    end
    self:_RecordTmpObject(name, objectInfo)
    if parent then
        objectInfo.objectTransform:SetParent(parent)
    end
    UnityUtils.SetLocalScale(objectInfo.objectTransform, 1,1,1)
    return objectInfo, true
end

function BaseView:PushUITmpObject(name, objectInfo, parent)
    self.uiTmpObjCache = self.uiTmpObjCache or {}
    self.uiTmpObjCache[name] = self.uiTmpObjCache[name] or {}
    objectInfo.object:SetActive(false)
    if parent then
        objectInfo.objectTransform:SetParent(parent)
    end
    table.insert(self.uiTmpObjCache[name], objectInfo)
end

function BaseView:_RecordTmpObject(name, info)
    self.uiTmpObjMap = self.uiTmpObjMap or {}
    self.uiTmpObjMap[name] = self.uiTmpObjMap[name] or {}
    table.insert(self.uiTmpObjMap[name], info)
end

function BaseView:PushAllUITmpObject(name, parent)
    if self.uiTmpObjMap and self.uiTmpObjMap[name] then
        for i = #self.uiTmpObjMap[name], 1, -1 do
            local obj = table.remove(self.uiTmpObjMap[name], i)
            self:PushUITmpObject(name, obj, parent)
        end
    end
end

--#region 业务相关功能
-- __Show之前使用
function BaseView:BindRedPoint(key, obj)
    self.redPointMap = self.redPointMap or {}
    if self.redPointMap[key] then
        -- LogError("绑定重复的红点!", key)
        return
    end
    RedPointMgr.Instance:AddBind(key)
    self.redPointMap[key] = obj
end

function BaseView:_RemoveRedPoint()
    if not self.redPointMap then return end
    for key, obj in pairs(self.redPointMap) do
        RedPointMgr.Instance:RemoveBind(key)
    end
end

function BaseView:RefreshRedPoint()
    if self.redPointMap and next(self.redPointMap) then
        for key, obj in pairs(self.redPointMap) do
            local state = RedPointMgr.Instance:GetRedPointState(key)
            UtilsUI.SetActive(obj, state)
        end
    end
end

function BaseView:AddRedPointEvent()
    self:RefreshRedPoint()
    if self.redPointMap and next(self.redPointMap) then
        EventMgr.Instance:RemoveListener(EventName.RedPointStateChange, self:ToFunc("_UpdateRedPoint"))
        EventMgr.Instance:AddListener(EventName.RedPointStateChange, self:ToFunc("_UpdateRedPoint"))
    end
end

function BaseView:_AddRedEvent()
    if self.redPointMap and next(self.redPointMap) then
        EventMgr.Instance:AddListener(EventName.RedPointStateChange, self:ToFunc("_UpdateRedPoint"))
    end
end

function BaseView:_RemoveRedEvent()
    if self.redPointMap and next(self.redPointMap) then
        EventMgr.Instance:RemoveListener(EventName.RedPointStateChange, self:ToFunc("_UpdateRedPoint"))
    end
end

function BaseView:_UpdateRedPoint(key, state)
    if self.redPointMap[key] then
        UtilsUI.SetActive(self.redPointMap[key], state)
    end
end

function BaseView:SetHideNode(nodeName)
    self.hideNode = nodeName
end

---comment 可以不使用此方法，按钮直接绑定PlayExitAnim，然后重写xxxExitAnim方法
---@param btn any
---@param closeFunc function 关闭界面方法，__AfterExitAnim后执行
---@param extraFunc function 点击时触发，__BeforeExitAnim前执行
function BaseView:BindCloseBtn(btn, closeFunc, extraFunc)
    btn.onClick:AddListener(function ()
        if extraFunc then extraFunc() end
        self:PlayExitAnim()
    end)
    self._closeFunc = self._closeFunc or closeFunc
end

function BaseView:PlayExitAnim(time)
    time = time or 0
    if not self.active then
        return false
    end
    if self.isExiting then
        return true
    end
    self.isExiting = true
    self:SuperFunc("__BeforeExitAnim", true)

    if self.active and self.soundBinder then
        self.soundBinder:PlayExitSound()
    end

    local animationSetting = self.animationSetting
    if animationSetting then
        self:SetActive(true)
        return animationSetting:PlayExitAnimator(time)
    elseif self.hideNode then
        self[self.hideNode]:SetActive(true)
        return true
    else --没有动效就直接关
        self.isExiting = false
        self:SuperFunc("__AfterExitAnim", true)
        if self._closeFunc then
            self._closeFunc()
        end
    end
    return false
end

function BaseView:PlayEnterAnim(time)
    time = time or 0
    local animationSetting = self.animationSetting
	if animationSetting then
        self:SetActive(true)
		return animationSetting:PlayEnterAnimator(time)
	end
end

function BaseView:CloseByCommand()
    self:PlayExitAnim()
end

function BaseView:GetOrderId()
    return self._orderId or 0
end

--#endregion

function BaseView:__ExtendView() end
function BaseView:__CacheObject() end
function BaseView:__Create() end
function BaseView:__BindListener() end
function BaseView:__BindBeforeEvent() end
function BaseView:__BindEvent() end
function BaseView:__BindLastingEvent() end
function BaseView:__Show(args) 
    self:PlayEnterAnim()
end
function BaseView:__RepeatShow(args) end
function BaseView:__Hide() end

function BaseView:__BaseCreate() end
function BaseView:__BaseShow() end
function BaseView:__ShowComplete() end
function BaseView:__BaseHide() end