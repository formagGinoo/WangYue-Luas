TeachWindow = BaseClass("TeachWindow",BaseWindow)
local _tinsert = table.insert

local TempHight = 121
local scrollHight = 938
function TeachWindow:__init()
    self:SetAsset("Prefabs/UI/Teach/TeachWindow.prefab")
end

function TeachWindow:__CacheObject()

end

function TeachWindow:__ShowComplete()

end

function TeachWindow:BlurShowCb()
end

function TeachWindow:__BindListener()
    -- self:SetHideNode("TeachWindow_out")
    self.CommonBack2_btn.onClick:AddListener(self:ToFunc("PlayExitAnim"))
    self.LastSureBtn_btn.onClick:AddListener(self:ToFunc("ClickLastBtn"))
    self.NextSureBtn_btn.onClick:AddListener(self:ToFunc("ClickNextBtn"))
end

function TeachWindow:__BindEvent()
    EventMgr.Instance:AddListener(EventName.RetTeachLookReward, self:ToFunc("UpdateItemRed"))
end

function TeachWindow:__AfterExitAnim()
	WindowManager.Instance:CloseWindow(self)
end

function TeachWindow:__Show()
    local setting = { bindNode = self.BlurNode }
    local cb = function ()
        self:BlurShowCb()
    end
    self:SetBlurBack(setting, cb)
    self.tagItemMap = {}
    self.teachItemMap = {}
    self.teachIdToItem = {}

    self.rtCatchMap = {}
    self.rawImageMap = {}

    self.teachManager = BehaviorFunctions.fight.teachManager
    self.teachCtrl = mod.TeachCtrl

    self.Empty:SetActive(false)
    self.TeachContent:SetActive(true)

    self:InitTagData()
    -- self:InitTeachData()
end

function TeachWindow:__Hide()
    self:ReleaseVideoInfo()
    if self.assetLoader ~= nil then
        AssetMgrProxy.Instance:CacheLoader(self.assetLoader)
        self.assetLoader = nil
    end

    self.teachManager:CheckShowTeachReward()
    EventMgr.Instance:RemoveListener(EventName.RetTeachLookReward, self:ToFunc("UpdateItemRed"))
end

function TeachWindow:__delete()

end

function TeachWindow:__Create()
    self:InitLeftTabCfg()
end

function TeachWindow:InitTagData()
    -- self.TagContent_recyceList:SetLuaCallBack(self:ToFunc("UpdateTeachTagView"))
    -- -- 这里加一是因为要加一个全部的页签
    -- self.TagContent_recyceList:SetCellNum(#self.teachTagCfg + 1)

    -- -- 默认选中第一个
    -- local item = self.tagItemMap[1]
    -- if item then
    --     item:ClickSelect()
    -- end
    self.tabPanel = self:OpenPanel(CommonLeftTabPanelV3,{ 
        name = TI18N("教学目录"), 
        name2 = "jiaoxue", 
        tabList = self.TeachMainToggleInfo
    })
end

function TeachWindow:InitLeftTabCfg()
    self.teachTagCfg = TeachConfig.GetTeachTagConfig()
    local teachIcon = {}
    --全部教学
    teachIcon[TeachConfig.AllTagIdx] = {}
    teachIcon[TeachConfig.AllTagIdx][1] = TeachConfig.AllTagCfg.select_icon
    teachIcon[TeachConfig.AllTagIdx][2] = TeachConfig.AllTagCfg.cancel_icon

    for k, v in pairs(self.teachTagCfg) do
        teachIcon[v.teach_tag + 1] = {}
        teachIcon[v.teach_tag + 1][1] = v.select_icon
        teachIcon[v.teach_tag + 1][2] = v.cancel_icon
    end

    self.TeachMainToggleInfo = {}
    self.TeachMainToggleInfo[TeachConfig.AllTagIdx] = 
    {
        type = tonumber("10" .. TeachConfig.AllTagIdx),
        icon = teachIcon[TeachConfig.AllTagIdx],
        name = TeachConfig.AllTagCfg.name,
        callback = function(parent, isSelect)
            if isSelect then
                self:SelectTagItem(TeachConfig.AllTagIdx)
            end
        end
    }

    for k, teachTypeInfo in pairs(self.teachTagCfg) do
        self.TeachMainToggleInfo[teachTypeInfo.teach_tag + 1] = 
        {
            type = tonumber("10" .. teachTypeInfo.teach_tag + 1),
            icon = teachIcon[teachTypeInfo.teach_tag + 1],
            name = teachTypeInfo.name,
            callback = function(parent, isSelect)
                if isSelect then
                    self:SelectTagItem(teachTypeInfo.teach_tag + 1)
                end
            end
        }
    end
end

function TeachWindow:UpdateTeachTagView(index, obj)
    local rect = obj:GetComponent(RectTransform)
    UnityUtils.SetAnchoredPosition(rect, 0, 0)
    local tagItem = TeachTagItem.New()
    local cfg
    if index == TeachConfig.AllTagIdx then
        cfg = TeachConfig.AllTagCfg
    else
        cfg = self.teachTagCfg[index - 1]
    end

    local data = {
        obj = obj,
        cfg = cfg,
        index = index,
    }
    tagItem:SetData(self, data)
    self.tagItemMap[index] = tagItem
end

function TeachWindow:SelectTagItem(selectIdx)
    for index, luaObj in pairs(self.tagItemMap) do
        if index ~= selectIdx then
            luaObj:CancelSelect()
        end
    end

    self.selectTeachTag = selectIdx
    self:InitTeachData()
end

function TeachWindow:ClearTeachContentItem()
    self.NewContent_recyceList:CleanAllCell()
    self.OldContent_recyceList:CleanAllCell()
    for _, luaObj in pairs(self.teachItemMap) do
        luaObj:DeleteMe()
    end
    self.teachItemMap = {}
    self.teachIdToItem = {}
end

function TeachWindow:UpdateEmptyState(isShowEmpty)
    self.Empty:SetActive(isShowEmpty)
    self.TeachContent:SetActive(not isShowEmpty)
end

function TeachWindow:InitTeachData()
    self.cacheIndex = 0
    self:ClearTeachContentItem()

    if self.selectTeachTag == TeachConfig.AllTagIdx then
        self:ShowAllTeachData()
    else
        self:ShowTagTeachData()
    end

    LuaTimerManager.Instance:AddTimerByNextFrame(1, 0.1, function ()
        if self.teachItemMap[1] then
            self.teachItemMap[1]:SelectItem()
        end
    end)
end

function TeachWindow:ShowAllTeachData()
    local newData, lastData = self.teachManager:GetTeachDataByTag(self.selectTeachTag)
    if #newData <= 0 and #lastData <= 0 then
        self:UpdateEmptyState(true)
        return
    end

    self.teachData = {}
    for _, data in ipairs(newData) do
        _tinsert(self.teachData, data)
    end

    for _, data in ipairs(lastData) do
        _tinsert(self.teachData, data)
    end

    self:UpdateEmptyState(false)
    local component = self.NewContent.transform:GetComponent(RecyclableScrollRect)
    local sizeDelta = self.NewContent_rect.sizeDelta

    local newNum = #newData
    local isShowNewList = newNum > 0
    self.NewContent:SetActive(isShowNewList)
    self.Recent:SetActive(isShowNewList)
    self.Separate:SetActive(isShowNewList)
    if newNum > 0 then
        component.enabled = true
        UnityUtils.SetSizeDelata(self.NewContent_rect, sizeDelta.x, newNum * TempHight)
        self.NewContent_recyceList:SetLuaCallBack(self:ToFunc("UpdateTeachCotent"))
        self.NewContent_recyceList:SetCellNum(newNum)
        -- 这里做一个处理，在item加载完成后关掉这个组件
        -- TODO 需要优化掉
        component.enabled = false
    end

    local lastNum = #lastData
    self.OldContent:SetActive(lastNum > 0)
    if lastNum > 0 then
        component = self.OldContent.transform:GetComponent(RecyclableScrollRect)
        component.enabled = true
        sizeDelta = self.OldContent_rect.sizeDelta
        UnityUtils.SetSizeDelata(self.OldContent_rect, sizeDelta.x, lastNum * TempHight)
        self.OldContent_recyceList:SetLuaCallBack(self:ToFunc("UpdateTeachCotent"))
        self.OldContent_recyceList:SetCellNum(lastNum)
        component.enabled = false
    end
end

function TeachWindow:ShowTagTeachData()
    local teachData = self.teachManager:GetTeachDataByTag(self.selectTeachTag)
    local num = #teachData
    if num <= 0 then
        self:UpdateEmptyState(true)
        return
    end

    self.teachData = teachData
    self.NewContent:SetActive(false)
    self.Recent:SetActive(false)
    self.Separate:SetActive(false)

    self.OldContent:SetActive(true)
    self:UpdateEmptyState(false)

    local component = self.OldContent.transform:GetComponent(RecyclableScrollRect)
    component.enabled = true
    local sizeDelta = self.OldContent_rect.sizeDelta
    UnityUtils.SetSizeDelata(self.OldContent_rect, sizeDelta.x, num * TempHight)
    self.OldContent_recyceList:SetLuaCallBack(self:ToFunc("UpdateTeachCotent"))
    self.OldContent_recyceList:SetCellNum(num)
    component.enabled = false
end

function TeachWindow:UpdateTeachCotent(index, obj)
    self.cacheIndex = self.cacheIndex + 1
    local rect = obj:GetComponent(RectTransform)
    UnityUtils.SetAnchoredPosition(rect, 0, 0)
    local teachItem = TeachContentItem.New()
    local teachData = self.teachData[self.cacheIndex]
    local data = {
        obj = obj,
        index = self.cacheIndex,
        teachData = teachData
    }
	self.teachItemMap[self.cacheIndex] = teachItem
    self.teachIdToItem[teachData.teachId] = teachItem
    teachItem:SetData(self, data)
end

function TeachWindow:SelectTeachItem(idx, obj)
    for index, obj in pairs(self.teachItemMap) do
        if index ~= idx then
            obj:CancelSelect()
        end
    end
    
    self.selectItemIdx = idx
    local selectData = self.teachData[idx]
    if not selectData then return end
    self:UpdataSeletTeachView(selectData)

    local objPos = obj.transform.position
    objPos = self.TeachList.transform:InverseTransformPoint(objPos)

    local listPos = self.TeachList.transform.position
    local listY = listPos.y 
    local targetY = -objPos.y
    local DownlistY = listY + scrollHight
    local listLocalPos = self.TeachList.transform.localPosition
    local localPosY = listLocalPos.y
    if localPosY + scrollHight < targetY then
        targetY = targetY - DownlistY + 70
    elseif localPosY > targetY then
        local val = localPosY - targetY
        targetY = localPosY - val - 70
    else
        return
    end
    self.TeachList.transform:DOLocalMoveY(targetY, 0.2)
end

function TeachWindow:UpdataSeletTeachView(selectData)
    local teachId = selectData.teachId
    local teachIdMap = TeachConfig.GetTeachIdMap(teachId)
    if not teachIdMap then 
        Log("缺少教学id对应配置 教学id = "..teachId)
        return
    end

    self.selectTeachIdMap = teachIdMap
    self.selectInfoIdx = 1
    self.Pro_txt.text = self.selectInfoIdx .. "/"..#teachIdMap
    
    self:UpdateBtnState()
    self:UpdateTeachInfoView()

    -- 展示具体信息后发送协议通知后端领奖
    self.teachManager:GetTeachLookReward(teachId)
end

function TeachWindow:ClickLastBtn()
    local infoCount = #self.selectTeachIdMap
    -- 同一个教学内切换
    if self.selectInfoIdx > 1 and infoCount > 1 then
        self.selectInfoIdx = self.selectInfoIdx - 1
    else
        -- 切换教学
        self.selectItemIdx = self.selectItemIdx - 1
        self:UpdateSelectItem()
        return
    end
    self:UpdateBtnState()
    self.Pro_txt.text = self.selectInfoIdx .. "/"..infoCount
    self:UpdateTeachInfoView()
end

function TeachWindow:ClickNextBtn()
    local infoCount = #self.selectTeachIdMap
    -- 同一个教学内切换
    if self.selectInfoIdx < infoCount then
        self.selectInfoIdx = self.selectInfoIdx + 1
    else
        -- 切换教学
        self.selectItemIdx = self.selectItemIdx + 1
        self:UpdateSelectItem()
        return
    end
    self:UpdateBtnState()
    self.Pro_txt.text = self.selectInfoIdx .. "/"..infoCount
    self:UpdateTeachInfoView()
end

function TeachWindow:UpdateSelectItem()
    local item = self.teachItemMap[self.selectItemIdx]
    if not item then return end
    item:SelectItem()
end

function TeachWindow:UpdateBtnState()
    -- 起始位置
    local isFirst = self.selectItemIdx <= 1 and self.selectInfoIdx <= 1
    self.LastSureBtn:SetActive(not isFirst)
    self.LastNo:SetActive(isFirst)
    self.LastSureBtn_btn.enabled = not isFirst

    -- 结束位置
    local allNum = #self.teachData
    local infoCount = #self.selectTeachIdMap

    local isEnd = self.selectItemIdx >= allNum and self.selectInfoIdx >= infoCount
    self.NextSureBtn:SetActive(not isEnd)
    self.NextNo:SetActive(isEnd)
    self.NextSureBtn_btn.enabled = not isEnd
end

function TeachWindow:ReleaseVideoInfo(isHide)
    -- if self.rtTemp then
    --     RenderTexture.ReleaseTemporary(self.rtTemp)
    --     self.rtTemp = nil
    -- end


    for _, rt in pairs(self.rtCatchMap) do
        RenderTexture.ReleaseTemporary(rt)
    end
    self.rtCatchMap = {}

    for _, rawImg in pairs(self.rawImageMap) do
        GameObject.Destroy(rawImg)
    end
    self.rawImageMap = {}

    -- if self.RawImage then
    --     GameObject.Destroy(self.RawImage)
    --     self.RawImage = nil
    -- end
end

function TeachWindow:UpdateTeachInfoView()
    local selectIdMap = self.selectTeachIdMap
    local selectData = selectIdMap[self.selectInfoIdx]
    local teachId = selectData.id
    local teachCfg = TeachConfig.GetTeachIdCfg(teachId)
    if not teachCfg then return end

    local resType = teachCfg.res_type
    self.PicImage:SetActive(resType == TeachConfig.ShowTeachResType.Image)
    self.VideoContent:SetActive(resType == TeachConfig.ShowTeachResType.Video)

    self:HideAllRawImage()

    if resType == TeachConfig.ShowTeachResType.Image then
        SingleIconLoader.Load(self.PicImage, teachCfg.img)
    elseif resType == TeachConfig.ShowTeachResType.Video then
        self:CreateVideo(teachCfg.video)
    end

    self.TxtTitle_txt.text = teachCfg.topic
    self.TxtContent_txt.text = teachCfg.content
end

function TeachWindow:HideAllRawImage()
    for _, rawImg in pairs(self.rawImageMap) do
        if rawImg.activeSelf then
            rawImg:SetActive(false)
        end
    end
end

local ScreenFactor = math.max(Screen.width / 1280, Screen.height / 720)
function TeachWindow:CreateVideo(videoName)
    self.VideoContent:SetActive(false)
    local videoPath = "Prefabs/UI/Video/"..videoName
    local resList = {
        {path = videoPath, type = AssetType.Prefab},
    }   
    local callback = function()
        self.VideoContent:SetActive(true)
        if not self.rawImageMap[videoName] then
            self.RawImage = self.assetLoader:Pop(videoPath)
            self.rawImageMap[videoName] = self.RawImage
        else
            self.RawImage = self.rawImageMap[videoName]
            self.RawImage:SetActive(true)
        end

        self.RawImage.transform:SetParent(self.VideoContent.transform)
        self.RawImage.transform:ResetAttr()

        -- 这里因为在原先预设中已经设置了大小，所以需要改成父节点的大小
        local rawRect = self.RawImage:GetComponent(RectTransform)
        UnityUtils.SetSizeDelata(rawRect, 992, 558)

    	self.RawImage_rimg = self.RawImage:GetComponent(RawImage)
	    local rect = self.RawImage_rimg.rectTransform.rect
	    local factor = math.min(ScreenFactor, 2)
        
        if not self.rtCatchMap[videoName] then
            self.rtTemp = CustomUnityUtils.GetTextureTemporary(math.floor(rect.width * factor), math.floor(rect.height * factor))
        else
            self.rtTemp = self.rtCatchMap[videoName]
        end

        self.RawImage_rimg.texture = self.rtTemp
	    self.vedioPlayer = self.RawImage:GetComponent(CS.UnityEngine.Video.VideoPlayer)
	    self.vedioPlayer.targetTexture = self.rtTemp
    end
    
    if self.assetLoader ~= nil then
        AssetMgrProxy.Instance:CacheLoader(self.assetLoader)
        self.assetLoader = nil
    end
    self.assetLoader = AssetMgrProxy.Instance:GetLoader("TeachVideo")
    self.assetLoader:AddListener(callback)
    self.assetLoader:LoadAll(resList)
end

function TeachWindow:UpdateItemRed(teachId)
    local item = self.teachIdToItem[teachId]
    if not item then return end
    item:UpdateRed()
end