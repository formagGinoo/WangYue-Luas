-- ----------------------------------------------------------
--循环格子
--Author: lizc Data 2017年7月3日
-- ----------------------------------------------------------

--[[
e.g

    local gridLayerTest = self.transform:Find("GridLayerTest")
    local scrlContent = gridLayerTest:Find("Content")
    local cloneCell = self.transform:Find("GridNode").gameObject

    local setting = {}
    setting.column = 7
    setting.cspacing = 5
    setting.rspacing = 5
    setting.cloneCell = cloneCell
    setting.cellSizeX = 100
    setting.cellSizeY = 100
    setting.scrollRect = gridLayerTest
    local gridLayout = LuaGridCycleLayout.New(scrlContent, setting)

    local function NumberOfCellsInGridView()
        return 200
    end

    local function GridCellAtIndex(cloneCell, index)
        cloneCell.transform:Find("Text"):GetComponent(Text).text = index
    end
    
    local function GirdCellNormalIndex(cloneCell, index)
    end

    local function GirdCellSelectIndex(cloneCell, index)
    end

    local function GirdCellTouched(cloneCell, index)
    end



    gridLayout:RegisterScriptHandler(NumberOfCellsInGridView, GridFuncType.NumberOfCells)
    gridLayout:RegisterScriptHandler(GridCellAtIndex, GridFuncType.CellAtIndex)
    gridLayout:RegisterScriptHandler(GirdCellTouched, GridFuncType.GridCellTouched)
    gridLayout:RegisterScriptHandler(GirdCellSelectIndex, GridFuncType.CellSelectIndex) --可以不实现 选中状态 如果实现和不选择状态一起实现
    gridLayout:RegisterScriptHandler(GirdCellNormalIndex, GridFuncType.CellNormalIndex) --可以不实现 不选中状态


    gridLayout:ReloadData()

]]--


GridFuncType = {
	CellAtIndex = 1,
	NumberOfCells = 2,     
    GridCellTouched = 3,
    CellNormalIndex = 4,   --不选中中格子显示回调方法
    CellSelectIndex = 5   --选中中格子显示回调方法
}

LuaGridCycleLayout = BaseClass("LuaGridCycleLayout",BaseLayout)

function LuaGridCycleLayout:__init(panel, setting)
    --列数
    self.column = setting.column
    self.bordertop = setting.bordertop or 0
    self.borderleft = setting.borderleft or 0
    --列间距
    self.cspacing = setting.cspacing or 1
    --行间距
    self.rspacing = setting.rspacing or 1
    self.cloneCell = setting.cloneCell
    self.cellSizeX = setting.cellSizeX
    self.cellSizeY = setting.cellSizeY
    self.scrollRect = setting.scrollRect

    --存放所有格子结构体
    self.cellList = {}
    --缓存cloneCell
    self.cacheList = {}
    --记录活跃得格子ID
    self.activeCellIdx = {}
    --当前选择物品的索引
    self.selectCellIndex = 1

    self.handler = {}

    self.panel = panel
    self.panelRect = self.panel:GetComponent(RectTransform)

    local scrollSize = self.scrollRect.sizeDelta

    self.funcScroll = function(value)
        self:OnScroll(scrollSize, value)
    end

    self.scrollRect:GetComponent(ScrollRect).onValueChanged:AddListener(self.funcScroll)

    self.unvisibleVec = Vector3(10000, 10000, 10000)

    self.viewSize = scrollSize

    self:SetCacheMaxSize()

    local function callback(pointData)
        if pointData.dragging then
            return
        end
        for k, v in ipairs(self.activeCellIdx) do
            if RectTransformUtility.RectangleContainsScreenPoint(self.cellList[v].cellTran, Input.mousePosition, ctx.UICamera) then
                self:GirdCellTouched(self.cellList[v].cell, v)
            end
        end
    end
    --UtilsUI.AddClickListener(self.scrollRect.gameObject, callback)
end

function LuaGridCycleLayout:__delete()
    self.panel = nil
    self.panelRect = nil
    self.cellList = nil
    self.scrollRect = nil
    self.selectCell = nil
end

function LuaGridCycleLayout:Clear()
    for _, cellData in ipairs(self.cellList) do
        GameObject.DestroyImmediate(cellData.cell)
    end
    self.cellList = {}
end

function LuaGridCycleLayout:DeActivated()
    self.scrollRect:GetComponent(ScrollRect).onValueChanged:RemoveListener(self.funcScroll)
end

function LuaGridCycleLayout:Activate()
    self.scrollRect:GetComponent(ScrollRect).onValueChanged:AddListener(self.funcScroll)
end

function LuaGridCycleLayout:RegisterScriptHandler(func, handlerId)
	self.handler[handlerId] = func
end

function LuaGridCycleLayout:NumberOfCellsInGridView()
	return self.handler[GridFuncType.NumberOfCells]()
end

function LuaGridCycleLayout:GridCellAtIndex(clone, index)
	self.handler[GridFuncType.CellAtIndex](clone, index)
end

function LuaGridCycleLayout:GridCellSelectIndex(clone, index)
    if self.handler[GridFuncType.CellSelectIndex] ~= nil then
        self.handler[GridFuncType.CellSelectIndex](clone, index) 
    -- else
    --     self.handler[GridFuncType.CellAtIndex](clone, index)
    end
end
function LuaGridCycleLayout:GridCellNormalIndex(clone, index)
    if self.handler[GridFuncType.CellNormalIndex] ~= nil then
        self.handler[GridFuncType.CellNormalIndex](clone, index) 
    end
end

function LuaGridCycleLayout:GirdCellTouched(clone, index)
    if self.handler[GridFuncType.CellSelectIndex] ~= nil then
        if self.selectCell then
            local isSelectIndex = false
            for i,v in ipairs(self.activeCellIdx) do
                if v == self.selectCellIndex then
                    isSelectIndex = true
                end
            end
            if isSelectIndex then
                self:GridCellNormalIndex(self.selectCell, self.selectCellIndex)
            end
        end

        self.selectCell = clone
        self:GridCellSelectIndex(clone, index)
    end
    self.selectCellIndex = index
    self.handler[GridFuncType.GridCellTouched](clone, index)
end

--创建格子结构，并存放到cellList
function LuaGridCycleLayout:AddCell(cell)
    local count = #self.cellList
    local pos = self:GetCellPosition(count + 1)
    local cellData = {cellTran = cell:GetComponent(RectTransform), cell = cell, pos = pos}
    table.insert(self.cellList, cellData)
end

--设置最大缓存数
function LuaGridCycleLayout:SetCacheMaxSize()
    local rowNum = math.ceil(self.viewSize.y / self.cellSizeY) + 1
    self.cacheMaxSize = rowNum * self.column
end

-- 左上角
function LuaGridCycleLayout:SetCellAnchor(rect)
    rect.anchorMin = Vector2 (0, 1)
    rect.anchorMax = Vector2 (0, 1)
    rect.pivot = Vector2 (0, 1);
end

-- 设置大小
function LuaGridCycleLayout:SetSize(rect, index)
    rect.sizeDelta = Vector2(self.cellSizeX, self.cellSizeY)
end

-- 设置位置，index从1开始
function LuaGridCycleLayout:GetCellPosition(index)
    local col = index % self.column
    if col == 0 then
        col = self.column
    end
    local row = math.ceil(index / self.column)
    local x = (col - 1) * self.cellSizeX + (col - 1) * self.cspacing + self.borderleft
    local y = 0 - ((row - 1) * self.cellSizeY + (row - 1) * self.rspacing) - self.bordertop
    return Vector3(x, y, 0)
end

--获得格子下标对应的缓存cloneCell
function LuaGridCycleLayout:GetCacheCellByIndex(index)
	local cacheIndex = (index - 1) % self.cacheMaxSize + 1
	if not self.cacheList[cacheIndex] then
		local newCell = GameObject.Instantiate(self.cloneCell)
	    local rect = newCell:GetComponent(RectTransform)
	    rect:SetParent(self.panelRect)
	    newCell.transform.localScale = Vector3.one
        newCell.transform.localPosition = self.unvisibleVec
	    newCell:SetActive(true)
	    self:SetCellAnchor(rect)
	    self:SetSize(rect, index)
	    self.cacheList[cacheIndex] = newCell
	    return newCell
	else
		return self.cacheList[cacheIndex]
	end
end

--生成格子
function LuaGridCycleLayout:ReloadData()
	self.cellList = {}
    self.activeCellIdx = {}

    for k, v in ipairs(self.cacheList) do
        v:GetComponent(RectTransform).anchoredPosition3D = self.unvisibleVec
    end

	local number = self:NumberOfCellsInGridView()
	for i = 1, number do
		local cell = self:GetCacheCellByIndex(i)
		self:AddCell(cell)
	end

    local maxRefreshNum = self.cacheMaxSize - self.column
	local refreshNum = number < maxRefreshNum and number or maxRefreshNum
	for i = 1, refreshNum do
		self:UpdateCellAtIndex(i)
	end

    if #self.cellList > 0 then
        self.panelRect:SetSizeWithCurrentAnchors(RectTransform.Axis.Vertical, -self.cellList[#self.cellList].pos.y + self.cellSizeY)
    else
        self.panelRect:SetSizeWithCurrentAnchors(RectTransform.Axis.Vertical, 0)
    end
    local x = self.panelRect.anchoredPosition3D.x
    self.panelRect.anchoredPosition3D = Vector3(x, 0, 0)
end

--刷新当前在显示的格子
function LuaGridCycleLayout:RefreshCurrentShowCell()
    for k, index in ipairs(self.activeCellIdx) do
        local cellData = self.cellList[index]
        if self.selectCellIndex == index then
            --保证第一次点击其它cell时，第一个选择的cell会被设为normal
            self.selectCell = cellData.cell
            self:GridCellSelectIndex(cellData.cell, index)
        else
            self:GridCellNormalIndex(cellData.cell, index)
        end
        self:GridCellAtIndex(cellData.cell, index)
    end
end

--更新格子，并记为活跃
function LuaGridCycleLayout:UpdateCellAtIndex(index)
	local cellData = self.cellList[index]
	cellData.cellTran.anchoredPosition3D = cellData.pos
    if self.selectCellIndex == index then
        --保证第一次点击其它cell时，第一个选择的cell会被设为normal
        self.selectCell = cellData.cell
        self:GridCellSelectIndex(cellData.cell, index)
    else
        self:GridCellNormalIndex(cellData.cell, index)
    end
    self:GridCellAtIndex(cellData.cell, index)
	table.insert(self.activeCellIdx, index)
end

function LuaGridCycleLayout:SelectCellByIndex(index)
    if self:NumberOfCellsInGridView() == 0 then
        return
    end
    local isExist = false
    for k, v in ipairs(self.activeCellIdx) do
        if v == index then
            isExist = true
        end
    end
    if not isExist or index > (#self.activeCellIdx - self.column) then
        local cellData = self.cellList[index]
        cellData.cellTran.anchoredPosition3D = cellData.pos
        local max = self.panelRect.sizeDelta.y - self.scrollRect.sizeDelta.y
        local offset = max - (self.panelRect.sizeDelta.y + (cellData.pos.y - cellData.cellTran.sizeDelta.y))
        if offset < 0 then
            offset = 0
        end
        self.panelRect.anchoredPosition3D = Vector3(0, offset, 0)
    end
    self:GirdCellTouched(self.cellList[index].cell, index)
end

--获得行数
function LuaGridCycleLayout:RowFromOffset(offset)
	local low = 0
	local hight = math.ceil(self:NumberOfCellsInGridView() / self.column) - 1
	local search = offset
    local cellIndex = nil
    local count = 0
	while(hight >= low)
	do
		local index = math.floor(low + (hight - low) / 2)
		local cellStart = -self.cellList[index * self.column + 1].pos.y
        local endCellIndex = (index + 1)* self.column + 1
        if endCellIndex > self:NumberOfCellsInGridView() then
            endCellIndex = self:NumberOfCellsInGridView()
        end
		local cellEnd = -self.cellList[endCellIndex].pos.y
		if search >= cellStart and search <= cellEnd then
			cellIndex = index 
            break
		elseif search < cellStart then
			hight = index - 1
		else
			low = index + 1
		end
        count = count + 1
	end
    if low < 0 then
        cellIndex = 0        
    end

    if not cellIndex then
        cellIndex = -1
    end


    local maxIdx = self:NumberOfCellsInGridView() - 1
    if cellIndex ~= -1 then
        cellIndex = math.max(0, cellIndex);
        if cellIndex > maxIdx then
            cellIndex = -1;
        end
    end

    return cellIndex
end

function LuaGridCycleLayout:OnScroll(scrollSizeDelta, value)
    if self:NumberOfCellsInGridView() == 0 then
        return
    end

    local contentSize = self.panelRect.sizeDelta.y
    --可视范围开始的位置
    local top = (contentSize - scrollSizeDelta.y) * (1 - value.y)
    --可视范围结束的位置
    local bot = scrollSizeDelta.y + top
    if bot > contentSize + self.cspacing then
        bot = contentSize + self.cspacing
    end
    if top < 0 then
        top = 0
    end

    local topRowIndex = self:RowFromOffset(top)
    local botRowIndex = self:RowFromOffset(bot)


    if topRowIndex == -1 then
        topRowIndex = self:NumberOfCellsInGridView() - 1
    end

    if botRowIndex == -1 then
        botRowIndex = self:NumberOfCellsInGridView() - 1
    end

    if topRowIndex > botRowIndex then
        local tmp = topRowIndex
        topRowIndex = botRowIndex
        botRowIndex = tmp
    end

    --可视范围的第一个格子下标
    local topCellIndex = topRowIndex * self.column + 1
    --可视范围的最后一个格子下标
    local botCellIndex = (botRowIndex + 1) * self.column
    if botCellIndex > self:NumberOfCellsInGridView() then
        botCellIndex = self:NumberOfCellsInGridView()
    end

    --移除不活跃的格子
    local removeIdx = {}
    for i = #self.activeCellIdx, 1, -1 do
    	if self.activeCellIdx[i] < topCellIndex or self.activeCellIdx[i] > botCellIndex then
    		table.insert(removeIdx, i)
		end
    end
    for k, v in ipairs(removeIdx) do
    	table.remove(self.activeCellIdx, v)
    end

    local isUpdate = nil
    --遍历格式范围内需要更新的格子
    if topCellIndex ~= botCellIndex then
        for i = topCellIndex, botCellIndex do
        	isUpdate = true
        	for k, v in ipairs(self.activeCellIdx) do
        		if v == i then
        			isUpdate = false
        			break
        		end
        	end
        	if isUpdate then
        		self:UpdateCellAtIndex(i)
        	end
        end
    end
end
