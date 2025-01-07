PartnerEXSkillPanel = BaseClass("PartnerEXSkillPanel", BasePanel)
local localMath = math

local getRotatedPosition = function (x, y, angle, matrixSize)
    -- 将角度转换为弧度
    local radians = localMath.rad(-angle)
    
    -- 计算矩阵中心点的位置
    local center = localMath.floor(matrixSize / 2) + 1

    -- 将点相对于中心点进行平移
    local translatedX = x - center
    local translatedY = y - center

    -- 计算旋转后的坐标
    local rotatedX = translatedX * localMath.cos(radians) - translatedY * localMath.sin(radians)
    local rotatedY = translatedX * localMath.sin(radians) + translatedY * localMath.cos(radians)

    -- 将旋转后的坐标再次平移回原始位置
    local finalX = rotatedX + center
    local finalY = rotatedY + center

    -- 处理边界情况，确保坐标在合法范围内
    finalX = localMath.floor(localMath.max(1, localMath.min(matrixSize, finalX)) + 0.5)
    finalY = localMath.floor(localMath.max(1, localMath.min(matrixSize, finalY)) + 0.5)

    return finalX, finalY
end

local ControlMode = 
{
    Move = "Move",
    Draw = "Draw",
    Remove = "Remove"
}

local AttrType = 
{
    Desc = 1,
    Value = 2
}

function PartnerEXSkillPanel:__init()
    self:SetAsset("Prefabs/UI/Partner/PartnerEXSkillPanel.prefab")
    self.blockPosMap = {}
    self.blockMap = {}
    self.totalNodeMap = {}
end

function PartnerEXSkillPanel:__Create()
    self:InitDrawData()
end

function PartnerEXSkillPanel:__BindListener()
    for _, mode in pairs(ControlMode) do
        if mode ~= ControlMode.Move then
            local func = function (isEnter)
                self:EnterControlMode(mode, isEnter)
            end
            self[mode.."Btn_tog"].onValueChanged:AddListener(func)
        end
    end

    self.ModflyBtn_btn.onClick:AddListener(function ()
        self.Cost:SetActive(true)
        self.GoldCount_txt.text = 0
        self.recordPoint = self.curPoint
        self:SelectMode(ControlMode.Move)
    end)

    self.ExitBtn_btn.onClick:AddListener(self:ToFunc("TryExit"))
    self.ScaleBar_sld.onValueChanged:AddListener(self:ToFunc("ScaleView"))
    self.AddBtn_btn.onClick:AddListener(function ()
        self.ScaleBar_sld.value = self.ScaleBar_sld.value + 0.05
    end)
    self.ReduceBtn_btn.onClick:AddListener(function ()
        self.ScaleBar_sld.value = self.ScaleBar_sld.value - 0.05
    end)
    self.SaveBtn_btn.onClick:AddListener(self:ToFunc("SaveData"))
    self.SaveBtnV2_btn.onClick:AddListener(self:ToFunc("SaveData"))
    self.ResetBtn_btn.onClick:AddListener(self:ToFunc("ResetPanel"))
    self.ContentView_btn.onClick:AddListener(self:ToFunc("OnClick_ContentView"))

    self.maskClickFunc = self.LeftBtn:AddComponent(TryPostEvent)
    self.maskClickFunc.onPointerClick = function(eventData)
        local needExecute = self.maskClickFunc:TryExecute()
        if needExecute then --命中其他页签
            local func = function(res)
                if res then
                    self.maskClickFunc:Execute()
                end
            end
            self:TryExit(func)
        end
    end

    self.JumpBtn_btn.onClick:AddListener(function()
        local func = function(res)
            if res then
                self.parentWindow:GetPanel(CommonLeftTabPanel):SelectType(RoleConfig.PartnerPanelType.Level)
            end
        end
        self:TryExit(func)
    end)

end

function PartnerEXSkillPanel:__Hide()
    self.DrawBtn_tog.isOn = true
    self.curMode = nil
    Fight.Instance.modelViewMgr:GetView():ShowModel("RoleRoot", true)
    Fight.Instance.modelViewMgr:GetView():ShowModel("PartnerRoot", true)
end

function PartnerEXSkillPanel:__Show()
    Fight.Instance.modelViewMgr:GetView():ShowModel("RoleRoot", false)
    Fight.Instance.modelViewMgr:GetView():ShowModel("PartnerRoot", false)
    self:ShowDetail()
end

function PartnerEXSkillPanel:PartnerInfoChange()
    if self.active then
        local partnerData = self.parentWindow:GetPartnerData()
        self:RefreshData(partnerData)
    end
end

function PartnerEXSkillPanel:ShowDetail()
    self.ScaleBar_sld.value = 1
    SingleIconLoader.Load(self.GoldIcon, ItemConfig.GetItemIcon(2))
    self:PushAllUITmpObject("BVLine", self.Cache_rect)
    self:PushAllUITmpObject("BHLine", self.Cache_rect)
    self:PushAllUITmpObject("SVLine", self.Cache_rect)
    self:PushAllUITmpObject("SHLine", self.Cache_rect)
    self:PushAllUITmpObject("NodeObj", self.Cache_rect)
    self:PushAllUITmpObject("BigBlockObj", self.Cache_rect)

    local partnerData = self.parentWindow:GetPartnerData()
    local count = #partnerData.panel_list
    if count == 0 then
        return
    end
    local size = RoleConfig.GetPlateSize(partnerData.panel_list[1].template_id)
    self:CreateDrawArea(count, size)
    self:RefreshData(partnerData, true)
end

function PartnerEXSkillPanel:ShowRightDetail()
    self.CurPoint_txt.text = self.curPoint
    self.MaxPoint_txt.text = self.totalPoint
    local money = RoleConfig.GetPartnerPointMoney()
    if self.curPoint > self.historyPoint then
        money = (self.curPoint - self.historyPoint) * money
    else
        money = 0
    end
    self.GoldCount_txt.text = money
    
    local attrMap = {}
    self.attrObjMap = self.attrObjMap or {}
    for k, v in pairs(self.recordMap) do
        if v then
            local node = self:GetNodeByKey(k)
            local skillId = node.skill.skill_id
            local config = RoleConfig.GetPartnerSkillConfig(node.skill.skill_id)
            if config.type == 3 or config.type == 4 then
                for _, attr in pairs(config.fight_attrs) do
                    attrMap[attr[1]] = attrMap[attr[1]] or {}
                    local info = attrMap[attr[1]]
                    info.desc = info.desc or 0
                    info.desc =info.desc + attr[2]
                    info.type = AttrType.Value
                    info.skillId = info.skillId or skillId
                    info.attrKey = attr[1]
                end
            else
                attrMap[skillId] = {type = AttrType.Desc, desc = config.desc, skillId = skillId}
            end
        end
    end
    self.activeCacheTable = {}
    for k, v in pairs(attrMap) do
        table.insert(self.activeCacheTable, v)
    end
    table.sort(self.activeCacheTable, function(a, b)
        local ap = RoleConfig.GetPartnerSkillConfig(a.skillId).priority
        local bp = RoleConfig.GetPartnerSkillConfig(b.skillId).priority
        if ap == bp then
            return a.skillId > b.skillId
        end
        return ap > bp
    end)

    self:PushAllUITmpObject("AttrObj", self.Cache_rect)
    for i, v in ipairs(self.activeCacheTable) do
        local obj = self:PopUITmpObject("AttrObj", self.DescRoot_rect)
        local icon = RoleConfig.GetPartnerSkillConfig(v.skillId).icon
        SingleIconLoader.Load(obj.Icon, icon)
        if v.type == AttrType.Desc then
            local desc = v.desc
            obj.Text_txt.text = desc
        else
            local desc, value = RoleConfig.GetShowAttr(v.attrKey, v.desc)
            obj.Text_txt.text = string.format("%s + %s",  desc, value)
        end
    end
    if not self.DescRoot_layout then
        self.DescRoot_layout = self.DescRoot:GetComponent(VerticalLayoutGroup)
    end
    self.NullText:SetActive(#self.activeCacheTable == 0)
    self.DescRoot_layout.enabled = false
    LuaTimerManager.Instance:AddTimerByNextFrame(1,0, function()
        if self.DescRoot_layout then
            self.DescRoot_layout.enabled = true
        end
    end)
end

function PartnerEXSkillPanel:RefreshData(partnerData, reDraw)
    self.partnerData = partnerData
    self.totalPoint = RoleConfig.GetSkillPoint(partnerData.template_id, partnerData.lev)
    self:UpdatePanelList(self.partnerData.panel_list)
    self:ReRunPath()
    self.historyPoint = self.curPoint
    self:DrawAllBlocks(reDraw)
    self:EnterControlMode(self.curMode or ControlMode.Draw, true)
end

function PartnerEXSkillPanel:InitDrawData()
    self.nodeLength = self.NodeObj_rect.sizeDelta.x -- 小格子边长
    self.bLineWidth = self.BVLine_rect.sizeDelta.x -- 粗线宽带
    self.sLineWidth = self.SVLine_rect.sizeDelta.x -- 细线宽度
end

---comment
---@param count any 巅峰盘数量
---@param size any 巅峰盘边长
function PartnerEXSkillPanel:CreateDrawArea(count, size)
    self.dataCount = count
    self.dataSize = size
    
    local HCount = 2 * count - 1
    local VCount = count > 1 and 2 * count - 2 or 1
    self.blockLenth = size * self.nodeLength + (size - 1) * self.sLineWidth
    local width = (self.blockLenth + self.bLineWidth) * HCount + self.bLineWidth
    local height = (self.blockLenth + self.bLineWidth) * VCount + self.bLineWidth
    UnityUtils.SetSizeDelata(self.ContentPart_rect, width, height)
    local xIndex, yIndex = 0,0
    for i = - count + 1, count, 1 do
        local tempCount = count > 2 and (- count + 2) or 0
        self.blockMap[i] = {}
        self.blockPosMap[i] = {}
        yIndex = 0
        for j = tempCount,  count, 1 do
            self.blockMap[i][j] = {}
            self.blockMap[i][j].x = i
            self.blockMap[i][j].y = j

            self.blockPosMap[i][j] = {}
            local tempLenth = (self.blockLenth + self.bLineWidth)
            self.blockPosMap[i][j].x = tempLenth * xIndex + self.bLineWidth
            self.blockPosMap[i][j].y = tempLenth * yIndex + self.bLineWidth
            yIndex = yIndex + 1
        end
        xIndex = xIndex + 1
    end


    --画线
    for _, data in pairs(self.blockPosMap) do
        for _, value in pairs(data) do
            local obj = self:PopUITmpObject("BVLine", self.LongLines_rect)
            UnityUtils.SetAnchoredPosition(obj.objectTransform, value.x, 0)
            UnityUtils.SetSizeDelata(obj.objectTransform, self.bLineWidth, self.blockLenth * (VCount + 1))
            break
        end
    end

    for _, value in pairs(self.blockPosMap[0]) do
        local obj = self:PopUITmpObject("BHLine", self.LongLines_rect)
        UnityUtils.SetAnchoredPosition(obj.objectTransform, 0, value.y)
        UnityUtils.SetSizeDelata(obj.objectTransform, self.blockLenth * (HCount + 1), self.bLineWidth)
    end

    --画分区
    for x, data in pairs(self.blockPosMap) do
        for y, value in pairs(data) do
            if x < count and y < count then
                self:CreateGorupObj(x, y)
            end
        end
    end

    --初始化开始节点
    local startIndex = math.floor(size / 2)
    local startX = startIndex * (self.nodeLength + self.sLineWidth) + self.blockPosMap[0][0].x
    UnityUtils.SetAnchoredPosition(self.StartNode_rect, startX, self.blockPosMap[0][0].y)

    local offect = self.CenterPoint_rect.position - self.StartNode_rect.position
    self.ContentPart_rect.position = self.ContentPart_rect.position + offect
end

function PartnerEXSkillPanel:CreateGorupObj(x, y)
    local rootObj = self:PopUITmpObject("BigBlockObj", self.ContentPart_rect)
    rootObj.Body:SetActive(false)
    UnityUtils.SetSizeDelata(rootObj.objectTransform, self.blockLenth, self.blockLenth)
    UnityUtils.SetAnchoredPosition(rootObj.objectTransform, 
    self.blockPosMap[x][y].x + self.blockLenth / 2, self.blockPosMap[x][y].y + self.blockLenth / 2)
    self.blockMap[x][y].obj = rootObj
    local block = self.blockMap[x][y]

    block.obj.Rotation:SetActive(false)
    block.obj.MoveBtn:SetActive(false)
    rootObj.Move_btn.onClick:RemoveAllListeners()
    rootObj.Move_btn.onClick:AddListener(function ()
        self:SelectBlock(block.x, block.y)
    end)
    rootObj.MoveBtn_btn.onClick:RemoveAllListeners()
	rootObj.MoveBtn_btn.onClick:AddListener(function ()
        self:EnterControlMode(ControlMode.Move, true)
        self:SelectBlock(block.x, block.y)
    end)
end

function PartnerEXSkillPanel:InitGroup(x, y)
    local block = self.blockMap[x][y]
    local blockObj = block.obj
    blockObj.Body:SetActive(true)
    blockObj.YellowBox:SetActive(false)
    blockObj.RedBox:SetActive(false)
    block.nodeMap = {}
    for i = 1, self.dataSize, 1 do
        if i ~= self.dataSize then
            local vline = self:PopUITmpObject("SVLine", blockObj.HLines_rect)
            local hline = self:PopUITmpObject("SHLine", blockObj.VLines_rect)
        end
        for j = 1, self.dataSize, 1 do
            local obj = self:PopUITmpObject("NodeObj", blockObj.NodeContent_rect)
            -- local totalX = x * self.dataSize + i
            -- local totalY = y * self.dataSize + j
            block.nodeMap[j] = block.nodeMap[j] or {}
            block.nodeMap[j][i] = block.nodeMap[j][i] or {}
            block.nodeMap[j][i].obj = obj
        end
    end
    blockObj.Rotation_btn.onClick:RemoveAllListeners()
    blockObj.Rotation_btn.onClick:AddListener(function ()
        self:RotateGroup(block.x, block.y)
    end)
end

function PartnerEXSkillPanel:SelectBlock(x, y)
    if x == 0 and y == -1 then
        MsgBoxManager.Instance:ShowTips(TI18N("该位置不能放置巅峰盘"))
        return
    end

    self.curSelect = self.curSelect or {}
    local select = self.curSelect
    if next(select) then
        local block = self.blockMap[select.x][select.y]
        block.obj.YellowBox:SetActive(false)
        if select.x ~= x or select.y ~= y then
            self:SwapGroup(select.x, select.y, x, y)
        end
        TableUtils.ClearTable(select)
        self:EnterControlMode(ControlMode.Draw, true)
    else
        local block = self.blockMap[x][y]
        block.obj.YellowBox:SetActive(true)
        select.x = x
        select.y = y
    end
end

function PartnerEXSkillPanel:SwapGroup(x,y,targetX,targetY)
    local temp = self.blockMap[x][y]

    self.blockMap[x][y] = self.blockMap[targetX][targetY]
    self.blockMap[targetX][targetY] = temp

    self.blockMap[x][y].x = x
    self.blockMap[x][y].y = y
    self.blockMap[targetX][targetY].x = targetX
    self.blockMap[targetX][targetY].y = targetY

    local targetPos = self.blockPosMap[targetX][targetY]
    local offset = self.blockLenth / 2
    UnityUtils.SetAnchoredPosition(temp.obj.objectTransform, targetPos.x + offset, targetPos.y + offset)
    local tempPos = self.blockPosMap[x][y]
    UnityUtils.SetAnchoredPosition(self.blockMap[x][y].obj.objectTransform, tempPos.x + offset, tempPos.y + offset)

    self:ReRunPath()
    self:DrawAllBlocks()
end

function PartnerEXSkillPanel:RotateGroup(x, y)
    self:ShowNodeDetail(false)
    local block = self.blockMap[x][y]
    local tf = block.obj.objectTransform
    tf:DORotate(Vector3(0, 0, -90), 0.3)
    LuaTimerManager.Instance:AddTimer(1, 0.35, function()
        UnityUtils.SetLocalEulerAngles(tf, 0, 0, 0)
        block.rotate = math.fmod(block.rotate + 90, 360)
        self:DrawBlock(x,y,false)
        self:UpdateBlockNode(x,y)
        self:ReRunPath()
        self:DrawAllBlocks()
    end)
end

function PartnerEXSkillPanel:UpdatePanelList(panelList)
    for key, value in pairs(panelList) do
        self:UpdatePanelData(value)
    end
end

function PartnerEXSkillPanel:UpdatePanelData(data)
    local pos = data.pos
    local block = self.blockMap[pos.key][pos.value]
    block.obj.PosCount_txt.text = data.panel_id
    if not block.nodeMap then
        self:InitGroup(pos.key, pos.value)
    end
    for key, value in pairs(data) do
        if type(value) == "table" then
            block[key] = TableUtils.CopyTable(value) or {}
        else
            block[key] = value
        end
    end
    self:UpdateBlockNode(pos.key, pos.value)
end

function PartnerEXSkillPanel:UpdateBlockNode(tempX, tempY)
    local block = self.blockMap[tempX][tempY]
    for _, value in pairs(block.nodeMap) do
        for _, node in pairs(value) do
            node.skill = nil
        end
    end
    for _, skill in pairs(block.skill_list) do
        local x, y = getRotatedPosition(skill.pos.key, skill.pos.value, block.rotate, self.dataSize)
        block.nodeMap[x][y].skill = skill
    end
end

function PartnerEXSkillPanel:DrawAllBlocks(isFirst)
    for x, value in pairs(self.blockMap) do
        for y, _ in pairs(value) do
            self:DrawBlock(x, y, true, isFirst)
        end
    end
    self:ShowRightDetail()
end

function PartnerEXSkillPanel:DrawBlock(x, y, state, isFirst)
    local block = self.blockMap[x][y]
    if isFirst and block.panel_id then
        local originalSkill = self.partnerData.skill_list[block.panel_id].key
        local config = RoleConfig.GetPartnerSkillConfig(originalSkill)
        SingleIconLoader.Load(block.obj.BGImg, config.icon)
    end
    if block.nodeMap then
        for tempX, value in pairs(block.nodeMap) do
            for tempY, node in pairs(value) do
                node.x = tempX
                node.y = tempY
                self:ShowNode(node, state, block)
            end
        end
    end
end

function PartnerEXSkillPanel:ShowNode(node, state, block)
    local obj = node.obj
    local skill = node.skill
    if not skill or not state then
        obj.Root:SetActive(false)
        return
    end
    --TODO
    local config = RoleConfig.GetPartnerSkillConfig(skill.skill_id)
    SingleIconLoader.Load(obj.Icon, config.icon)
    if not node.isInit then
        node.isInit = true
        obj.RedPoint:SetActive(config.show_point == 1)
        obj.GreenPoint:SetActive(config.show_point == 2)
        obj.Root_drag.onPointerEnter = function ()
            self:OnPointerEnter(block.x, block.y, node.x, node.y)
        end
        obj.Root_drag.onBeginDrag = function ()
            self:OnBeginDrag(block.x, block.y, node.x, node.y)
        end
        obj.Root_drag.onEndDrag = function ()
            self:OnEndDrag(block.x, block.y, node.x, node.y)
        end
        obj.Root_drag.onPointerDown = function ()
            self:OnPointerDown(block.x, block.y, node.x, node.y)
        end
        obj.Root_drag.onPointerUp = function ()
            self:OnPointerUp(block.x, block.y, node.x, node.y)
        end
    end

    obj.Root:SetActive(true)

    if skill.is_active then
        obj.Unlock:SetActive(false)
        obj.Icon_canvas.alpha = 1
    else
        obj.Unlock:SetActive(true)
        obj.Icon_canvas.alpha = 0.8
    end

end

function PartnerEXSkillPanel:SelectMode(mode)
    if mode ~= ControlMode.Move then
        self.LeftRoot:SetActive(true)
		self[mode.."Btn_tog"].isOn = false
        self[mode.."Btn_tog"].isOn = true
    end
end

function PartnerEXSkillPanel:EnterControlMode(mode, isEnter)
    if mode ~= ControlMode.Move then
        self[mode.."BG"]:SetActive(isEnter)
        self[mode.."Select"]:SetActive(isEnter)
        self[mode.."UnSelect"]:SetActive(not isEnter)
    end

    if isEnter then
        if mode == self.curMode then return end
        if self.curMode == ControlMode.Move then
            self:EnterControlMode(ControlMode.Move, false)
        end
        self:ShowNodeDetail(false)
        self.lastPointerUpKey = nil
    end
    if mode == ControlMode.Move then
        self:ShowAllMoveContent(isEnter)
    elseif mode == ControlMode.Draw then
        self:ShowAllMovePart(isEnter)
        self.ContentView_img.raycastTarget = not isEnter
    elseif mode == ControlMode.Remove then
        self:ShowAllRedBox(isEnter)
    end
    if isEnter then self.curMode = mode end
end

function PartnerEXSkillPanel:ShowAllRedBox(state)
    for x, value in pairs(self.blockMap) do
        for y, block in pairs(value) do
            if block.obj and block.nodeMap then
                block.obj.RedBox:SetActive(state)
            end
        end
    end
end

function PartnerEXSkillPanel:ShowAllMovePart(state)
    for x, value in pairs(self.blockMap) do
        for y, block in pairs(value) do
            if block.obj then
                block.obj.MovePart:SetActive(state)
                if block.panel_id then
                    block.obj.Rotation:SetActive(state)
                    block.obj.MoveBtn:SetActive(state)
                end
            end
        end
    end

end

function PartnerEXSkillPanel:ShowAllMoveContent(state)
    for x, value in pairs(self.blockMap) do
        for y, block in pairs(value) do
            if block.obj then
                block.obj.Move:SetActive(state)
            end
        end
    end
    if not state then
        local select = self.curSelect
        if select and next(select) then
            local block = self.blockMap[select.x][select.y]
            block.obj.YellowBox:SetActive(false)
            TableUtils.ClearTable(select)
        end
    end
end

function PartnerEXSkillPanel:ScaleView(value)
    UnityUtils.SetLocalScale(self.ContentPart_rect, value, value)
end

function PartnerEXSkillPanel:OnPointerEnter(blockX, blockY, nodeX, nodeY)
    local key = self.GetUniqueKey(blockX, blockY, nodeX, nodeY)
    if self.curMode == ControlMode.Draw then
        if self.isDrag then
            self:TryActiveNode(key)
        end
    end
end
function PartnerEXSkillPanel:OnBeginDrag(blockX, blockY, nodeX, nodeY)
    local key = self.GetUniqueKey(blockX, blockY, nodeX, nodeY)
    if self.curMode == ControlMode.Draw then
        self.isDrag = true
        self:ShowNodeDetail(false)
        self:TryActiveNode(key)
    end
end

function PartnerEXSkillPanel:OnEndDrag(blockX, blockY, nodeX, nodeY)
    if self.curMode == ControlMode.Draw then
        self.isDrag = false
    end
end

-- function PartnerEXSkillPanel:OnPointerExit(blockX, blockY, nodeX, nodeY)
    
-- end

function PartnerEXSkillPanel:OnPointerDown(blockX, blockY, nodeX, nodeY)
end

function PartnerEXSkillPanel:OnPointerUp(blockX, blockY, nodeX, nodeY)
    local node, block, key = self:GetBlockNode(blockX, blockY, nodeX, nodeY)
    if not self.isDrag then
        if self.lastPointerUpKey == key then
            self:ShowNodeDetail(false)
            self.lastPointerUpKey = nil
        else
            self.lastPointerUpKey = key
            self:ShowNodeDetail(true, node)
        end
        if self.curMode == ControlMode.Draw then
            self:TryActiveNode(key)
        elseif self.curMode == ControlMode.Remove then
            self:TryRemoveNode(key)
        end
    end
    self:ShowPointNode(false)
end

function PartnerEXSkillPanel:OnClick_ContentView()
    if self.lastPointerUpKey then
        self:ShowNodeDetail(false)
        self.lastPointerUpKey = nil
    end
end

function PartnerEXSkillPanel:TryRemoveNode(key)
    local node, block, _ =self:GetNodeByKey(key)
    if node.skill.is_active then
        self.recordMap[key] = false
        node.skill.is_active = false
        self:ReRunPath()
        self:DrawAllBlocks()
    end
end

function PartnerEXSkillPanel:TryActiveNode(key)
    local blockX, blockY, nodeX, nodeY = self.AnalyseUniqueKey(key)
    local node, block, _ = self:GetBlockNode(blockX, blockY, nodeX, nodeY)
    if self.recordMap[key] or self.curPoint >= self.totalPoint then
        return
    end
    local nodeMap = block.nodeMap
    local tempKey, res
    local startIndex = math.floor(self.dataSize / 2)
    local startKey = self.GetUniqueKey(0,0, startIndex + 1,1)
    res = startKey == key
    if nodeMap[nodeX][nodeY + 1] then
        tempKey = self.GetUniqueKey(blockX, blockY, nodeX, nodeY + 1)
    else
        tempKey = self.GetUniqueKey(blockX, blockY + 1, nodeX, 1)
    end
    res = self.recordMap[tempKey] or res
    if nodeMap[nodeX][nodeY - 1] then
        tempKey = self.GetUniqueKey(blockX, blockY, nodeX, nodeY - 1)
    else
        tempKey = self.GetUniqueKey(blockX, blockY - 1, nodeX, self.dataSize)
    end
    res = self.recordMap[tempKey] or res
    if nodeMap[nodeX + 1] then
        tempKey = self.GetUniqueKey(blockX, blockY, nodeX + 1, nodeY)
    else
        tempKey = self.GetUniqueKey(blockX + 1, blockY, 1, nodeY)
    end
    res = self.recordMap[tempKey] or res
    if nodeMap[nodeX - 1] then
        tempKey = self.GetUniqueKey(blockX, blockY, nodeX - 1, nodeY)
    else
        tempKey = self.GetUniqueKey(blockX - 1, blockY, self.dataSize, nodeY)
    end
    res = self.recordMap[tempKey] or res

    if res then
        self.recordMap[key] = true
        self.curPoint = self.curPoint + 1
        node.skill.is_active = true
        node.obj.Unlock:SetActive(false)
        node.obj.Icon_canvas.alpha = 1
        self:ShowPointNode(true, node)
        local config = RoleConfig.GetPartnerSkillConfig(node.skill.skill_id)
        MsgBoxManager.Instance:ShowScrollTips(config.desc)
    end
end


function PartnerEXSkillPanel:ShowPointNode(state, node)
    if not state then
        self.PointInfo:SetActive(false)
        return
    end
    self.PointInfo:SetActive(true)
    local point = self.totalPoint - self.curPoint
    self.PointCount_txt.text = point

    local obj = node.obj
    self.PointInfo_rect:SetParent(obj.PointRoot_rect)
    UnityUtils.SetAnchoredPosition(self.PointInfo_rect, 0, 0)
    self.PointInfo_rect:SetParent(self.ContentPart_rect)
    self:ShowRightDetail()
end

function PartnerEXSkillPanel:ShowNodeDetail(state, node)
    if not state then
        self.NodeInfo:SetActive(false)
        return
    end
    self.NodeInfo:SetActive(true)
    local obj = node.obj
    local skill = node.skill
    local config = RoleConfig.GetPartnerSkillConfig(skill.skill_id)
    self.NodeInfo_rect:SetParent(obj.Root_rect)
    UnityUtils.SetAnchoredPosition(self.NodeInfo_rect, 0, 0)
    self.NodeInfo_rect:SetParent(self.ContentPart_rect)
    self.RightDesc_txt.text = config.desc
    SingleIconLoader.Load(self.RightTipIcon, config.icon)
    self.NodeInfo_rect:SetAsLastSibling()
end

function PartnerEXSkillPanel:GetBlockNode(blockX, blockY, nodeX, nodeY)
    local block = self.blockMap[blockX][blockY]
    local node = block.nodeMap[nodeX][nodeY]
    local key = self.GetUniqueKey(blockX, blockY, nodeX, nodeY)
    return node, block, key
end

function PartnerEXSkillPanel:GetNodeByKey(key)
    local blockX, blockY, nodeX, nodeY = self.AnalyseUniqueKey(key)
    return self:GetBlockNode(blockX, blockY, nodeX, nodeY)
end

--遍历路径
function PartnerEXSkillPanel:ReRunPath()
    self.recordMap = TableUtils.ClearTable(self.recordMap) or {}
    local startIndex = math.floor(self.dataSize / 2)
    self:EnterNextNode(0,0, startIndex + 1, 1)
    local count = 0
    for key, value in pairs(self.recordMap) do
		if value then
			count = count + 1
		end
    end
    self.curPoint = count
    self:RebuildState()
end

function PartnerEXSkillPanel:EnterNextNode(blockX, blockY, nodeX, nodeY)
    if blockX == 0 and blockY == -1 then return end
    local key = self.GetUniqueKey(blockX, blockY, nodeX, nodeY)
    if self.recordMap[key] ~= nil then return end
	self.recordMap[key] = false
    if not self.blockMap[blockX] or not self.blockMap[blockY] then return end
    local block = self.blockMap[blockX][blockY]
    local nodeMap = block.nodeMap
    if not nodeMap then return end
    local node = nodeMap[nodeX][nodeY]
    if not node.skill then return end

    if node.skill.is_active then
        self.recordMap[key] = true
        if nodeMap[nodeX][nodeY + 1] then
            self:EnterNextNode(blockX, blockY, nodeX, nodeY + 1)
        else
            self:EnterNextNode(blockX, blockY + 1, nodeX, 1)
        end
        if nodeMap[nodeX][nodeY - 1] then
            self:EnterNextNode(blockX, blockY, nodeX, nodeY - 1)
        else
            self:EnterNextNode(blockX, blockY - 1, nodeX, self.dataSize)
        end
        if nodeMap[nodeX + 1] then
            self:EnterNextNode(blockX, blockY, nodeX + 1, nodeY)
        else
            self:EnterNextNode(blockX + 1, blockY, 1, nodeY)
        end
        if nodeMap[nodeX - 1] then
            self:EnterNextNode(blockX, blockY, nodeX - 1, nodeY)
        else
            self:EnterNextNode(blockX - 1, blockY, self.dataSize, nodeY)
        end
    end
end

local offset = 10
function PartnerEXSkillPanel.GetUniqueKey(blockX, blockY, nodeX, nodeY)
    return (blockX + offset) << 30 | (blockY + offset) << 20 | (nodeX) << 10 | (nodeY)
end

function PartnerEXSkillPanel.AnalyseUniqueKey(key)
    local blockX = ((key >> 30) & 0xF) - offset

    local blockY = ((key >> 20) & 0xF) - offset

    local nodeX = ((key >> 10) & 0xF)

    local nodeY = (key & 0xF)


    return blockX, blockY, nodeX, nodeY
end

function PartnerEXSkillPanel:RebuildState()
    for X, value in pairs(self.blockMap) do
        for Y, block in pairs(value) do
            if block.panel_id then
                block.pos = {x = X, y = Y}
                for _, skill in pairs(block.skill_list) do
                    local x, y = getRotatedPosition(skill.pos.key, skill.pos.value, block.rotate, self.dataSize)
                    local uniqueKey = self.GetUniqueKey(X,Y,x,y)
                    if self.recordMap[uniqueKey] then
                        skill.is_active = true
                    else
                        skill.is_active = false
                    end
                end
            end
        end
    end
end

function PartnerEXSkillPanel:GetTempData()
    local panelList = {}
    for X, value in pairs(self.blockMap) do
        for Y, block in pairs(value) do
            if block.panel_id then
                panelList[block.panel_id] = {}
                local data = panelList[block.panel_id]
                data.pos = {key = X, value = Y}
                data.rotate = block.rotate
                data.skill_list = block.skill_list
            end
        end
    end

    local partnerData = self.parentWindow:GetPartnerData()
    local tempList = TableUtils.CopyTable(partnerData.panel_list) or {}
    local isChanged = false
    for _, value in pairs(tempList) do
        local panel = panelList[value.panel_id]
        for k, v in pairs(panel) do
            if k == "skill_list" then
                for key, skill in pairs(value[k]) do
                    isChanged = isChanged or skill.is_active ~= v[key].is_active
                end
            elseif k == "pos" then
                isChanged = isChanged or value[k].key ~= v.key
                isChanged = isChanged or value[k].value ~= v.value
            elseif type(value[k]) ~= "table" then
                isChanged = isChanged or value[k] ~= v
            end
			value[k] = v
        end
    end
    
    return tempList, isChanged
end

function PartnerEXSkillPanel:SaveData(tempList, isChanged, func)
    local partnerData = self.parentWindow:GetPartnerData()
    if not tempList then
        tempList, isChanged = self:GetTempData()
    end
    
    if isChanged then
        local money = RoleConfig.GetPartnerPointMoney()
        if self.curPoint > self.historyPoint then
            money = (self.curPoint - self.historyPoint) * money
        else
            money = 0
        end

        local curGold = mod.BagCtrl:GetGoldCount()
        if curGold >= money then
            mod.RoleCtrl:SavePartnerPanel(partnerData.unique_id, tempList)
            if self.curPoint > 0 then
                EventMgr.Instance:Fire(EventName.AddSystemContent, PartnerExSkillSavePanel, {args =
                {
                    point = self.curPoint, 
                    config = self.activeCacheTable,
                }})
            else
                MsgBoxManager.Instance:ShowTips(TI18N("保存成功!"))
            end
            
            if func then func(true) end
        else
            MsgBoxManager.Instance:ShowTips(TI18N("金币不足!"))
            if func then func(false) end
        end
    else
        MsgBoxManager.Instance:ShowTips(TI18N("没有修改"))
    end
end

function PartnerEXSkillPanel:TryExit(func)
    local partnerData = self.parentWindow:GetPartnerData()
    local tempList, isChanged = self:GetTempData()
    local save = function()
        self:SaveData(tempList, isChanged, func)
    end
    local notSave = function()
        self:RefreshData(partnerData)
        if func then func(true) end
    end
    local close = function()
        if func then func(false) end
    end
    if isChanged then
        MsgBoxManager.Instance:ShowTextMsgBox(TI18N("是否保存修改?"), save, notSave, close)
    else
        notSave()
    end
end

function PartnerEXSkillPanel:ResetPanel()
    local func = function(code)
        if code == 0 then
            local partnerData = self.parentWindow:GetPartnerData()
            self:RefreshData(partnerData)
        end
    end

    local partnerData = self.parentWindow:GetPartnerData()
    mod.RoleCtrl:ResetPartnerPanel(partnerData.unique_id, func)
end