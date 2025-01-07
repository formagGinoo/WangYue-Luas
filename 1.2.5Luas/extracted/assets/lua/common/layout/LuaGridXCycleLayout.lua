-- ----------------------------------------------------------
--循环格子 横向 
--Author: lizc Data 2017年9月7日 
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
    local gridLayout = LuaGridXCycleLayout.New(scrlContent, setting)

    local function NumberOfCellsInGridView()
        return 200
    end

    local function GridCellAtIndex(cloneCell, index)
        cloneCell.transform:Find("Text"):GetComponent(Text).text = index
    end
    
    local function GridCellNormalIndex(cloneCell, index) --未选中
    end

    local function GridCellSelectIndex(cloneCell, index) --选中显示
    end

    local function GridCellTouched(cloneCell, index) --点击
    end



    gridLayout:RegisterScriptHandler(NumberOfCellsInGridView, GridFuncType.NumberOfCells)
    gridLayout:RegisterScriptHandler(GridCellAtIndex, GridFuncType.CellAtIndex)
    gridLayout:RegisterScriptHandler(GridCellTouched, GridFuncType.GridCellTouched)
    gridLayout:RegisterScriptHandler(GridCellSelectIndex, GridFuncType.CellSelectIndex) --可以不实现 选中状态 如果实现和不选择状态一起实现
    gridLayout:RegisterScriptHandler(GridCellNormalIndex, GridFuncType.CellNormalIndex) --可以不实现 不选中状态


    gridLayout:ReloadData()

]]--


-- GridFuncType = {
-- 	CellAtIndex = 1,
-- 	NumberOfCells = 2,     
--     GridCellTouched = 3,
--     CellNormalIndex = 4,   --不选中中格子显示回调方法
--     CellSelectIndex = 5   --选中中格子显示回调方法
-- }

LuaGridXCycleLayout = BaseClass("LuaGridXCycleLayout",BaseLayout)

function LuaGridXCycleLayout:__init(panel, setting)
    --列数
    self.column = setting.column
    self.row = 1
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
    self.selectCellIndex = -1

    self.handler = {}

    self.panel = panel
    self.panelRect = self.panel:GetComponent(RectTransform)

    local scrollSize = self.scrollRect.sizeDelta
    self.scrollRect:GetComponent(ScrollRect).onValueChanged:AddListener(
        function(value)
            self:OnScroll(scrollSize, value)
        end
    )

    self.unvisibleVec = Vector3(1000, 1000, 1000)

    self.viewSize = scrollSize

    self:SetCacheMaxSize()

    local function callback(pointData)
        if pointData.dragging then
            return
        end
        for k, v in ipairs(self.activeCellIdx) do
            if RectTransformUtility.RectangleContainsScreenPoint(self.cellList[v].cellTran, Input.mousePosition, ctx.UICamera) then
                self:GridCellTouched(self.cellList[v].cell, v)
            end
        end
    end
    UtilsUI.AddClickListener(self.scrollRect.gameObject, callback)
end

function LuaGridXCycleLayout:__delete()
    self.panel = nil
    self.panelRect = nil
    self.cellList = nil
    self.scrollRect = nil
    self.selectCell = nil
end

function LuaGridXCycleLayout:Clear()
    for _, cellData in ipairs(self.cellList) do
        GameObject.DestroyImmediate(cellData.cell)
    end
    self.cellList = {}
end

function LuaGridXCycleLayout:RegisterScriptHandler(func, handlerId)
	self.handler[handlerId] = func
end

function LuaGridXCycleLayout:NumberOfCellsInGridView()
	return self.handler[GridFuncType.NumberOfCells]()
end

function LuaGridXCycleLayout:GridCellAtIndex(clone, index)
	self.handler[GridFuncType.CellAtIndex](clone, index)
end

function LuaGridXCycleLayout:GridCellSelectIndex(clone, index)
    if self.handler[GridFuncType.CellSelectIndex] ~= nil then
        self.handler[GridFuncType.CellSelectIndex](clone, index) 
    -- else
    --     self.handler[GridFuncType.CellAtIndex](clone, index)
    end
end
function LuaGridXCycleLayout:GridCellNormalIndex(clone, index)
    if self.handler[GridFuncType.CellNormalIndex] ~= nil then
        self.handler[GridFuncType.CellNormalIndex](clone, index) 
    end
end

function LuaGridXCycleLayout:GridCellTouched(clone, index)
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

--刷新一下选中的对象
function LuaGridXCycleLayout:RefreshSelectIndex()
    if self.selectCellIndex ~= nil then
        if IS_DEBUG then
            print("LuaGridXCycleLayout:RefreshSelectIndex: "..self.selectCellIndex)
        end
        local clone = self.cellList[self.selectCellIndex].cell
        self.GridCellAtIndex(clone, self.selectCellIndex)
        -- self.handler[GridFuncType.CellAtIndex](clone, index)
    end
end

function LuaGridXCycleLayout:RefreshAllCell()
    for _,index in ipairs(self.activeCellIdx) do
        local cellData = self.cellList[index]
        self:GridCellAtIndex(cellData.cell, index)
    end
end

--创建格子结构，并存放到cellList
function LuaGridXCycleLayout:AddCell(cell)
    local count = #self.cellList
    local pos = self:GetCellPosition(count + 1)
    local cellData = {cellTran = cell:GetComponent(RectTransform), cell = cell, pos = pos}
    table.insert(self.cellList, cellData)
end

--设置最大缓存数
function LuaGridXCycleLayout:SetCacheMaxSize()
    local colNum = math.ceil(self.viewSize.x / (self.cellSizeX + self.cspacing)) + 1
    self.cacheMaxSize = colNum 
end

-- 左上角
function LuaGridXCycleLayout:SetCellAnchor(rect)
    rect.anchorMin = Vector2 (0, 1)
    rect.anchorMax = Vector2 (0, 1)
    rect.pivot = Vector2 (0, 1);
end

-- 设置大小
function LuaGridXCycleLayout:SetSize(rect, index)
    rect.sizeDelta = Vector2(self.cellSizeX, self.cellSizeY)
end

-- 设置位置，index从1开始
function LuaGridXCycleLayout:GetCellPosition(index)
    -- local col = index % self.column
    -- if col == 0 then
    --     col = self.column
    -- end

    -- local row = math.ceil(index / self.column)
    -- local x = (col - 1) * self.cellSizeX + (col - 1) * self.cspacing + self.borderleft
    -- local y = 0 - ((row - 1) * self.cellSizeY + (row - 1) * self.rspacing) - self.bordertop
    local x = (index - 1) *(self.cellSizeX + self.cspacing) + self.borderleft
    local y = - self.bordertop
    return Vector3(x, y, 0)
end

--获得格子下标对应的缓存cloneCell
function LuaGridXCycleLayout:GetCacheCellByIndex(index)
	local cacheIndex = (index - 1) % self.cacheMaxSize + 1
	if not self.cacheList[cacheIndex] then
		local newCell = GameObject.Instantiate(self.cloneCell)
	    local rect = newCell:GetComponent(RectTransform)
	    rect:SetParent(self.panelRect)
	    newCell.transform.localScale = Vector3.one
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
function LuaGridXCycleLayout:ReloadData()
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

    local maxRefreshNum = self.cacheMaxSize 
	local refreshNum = number < maxRefreshNum and number or maxRefreshNum
	for i = 1, refreshNum do
		self:UpdateCellAtIndex(i)
	end

    if #self.cellList > 0 then
        self.panelRect:SetSizeWithCurrentAnchors(RectTransform.Axis.Horizontal, self.cellList[#self.cellList].pos.x + self.cellSizeX)
    else
        self.panelRect:SetSizeWithCurrentAnchors(RectTransform.Axis.Horizontal, 0)
    end

    self.panelRect.anchoredPosition3D = Vector3(0, 0, 0)
end

--刷新当前在显示的格子
function LuaGridXCycleLayout:RefreshCurrentShowCell()
    for k, index in ipairs(self.activeCellIdx) do
        local cellData = self.cellList[index]
        if self.selectCellIndex == index then
            self:GridCellSelectIndex(cellData.cell, index)
        else
            self:GridCellNormalIndex(cellData.cell, index)
        end
        self:GridCellAtIndex(cellData.cell, index)
    end
end

--更新格子，并记为活跃
function LuaGridXCycleLayout:UpdateCellAtIndex(index)
	local cellData = self.cellList[index]
	cellData.cellTran.anchoredPosition3D = cellData.pos
    if self.selectCellIndex == index then
        self:GridCellSelectIndex(cellData.cell, index)
    else
        self:GridCellNormalIndex(cellData.cell, index)
    end
    self:GridCellAtIndex(cellData.cell, index)
	table.insert(self.activeCellIdx, index)
end

function LuaGridXCycleLayout:SelectCellByIndex(index)
    if self:NumberOfCellsInGridView() == 0 then
        return
    end
    local isExist = false
    for k, v in ipairs(self.activeCellIdx) do
        if v == index then
            isExist = true
        end
    end
    if not isExist or index > #self.activeCellIdx then
        local cellData = self.cellList[index]
        cellData.cellTran.anchoredPosition3D = cellData.pos
        local scrollSize = self.scrollRect.sizeDelta
        local max = self.panelRect.sizeDelta.x-scrollSize.x
        
        local posx = - cellData.pos.x
        if posx < -max then
            posx = -max
        end
        self.panelRect.anchoredPosition3D = Vector3(posx,0, 0)

        local x = cellData.pos.x/max
        if x > 1 then
            x = 1
        end
        self:OnScroll(scrollSize, {x = x})
    end
    self:GridCellTouched(self.cellList[index].cell, index)
end

function LuaGridXCycleLayout:OnScroll(scrollSizeDelta, value)
    if self:NumberOfCellsInGridView() == 0 then
        return
    end
    local contentSize = self.panelRect.sizeDelta.x
    --可视范围开始的位置 self.panelRect.anchoredPosition.x --
    local top = (contentSize - scrollSizeDelta.x) * value.x
    --可视范围结束的位置
    local bot = scrollSizeDelta.x + top
    if bot > contentSize + self.cspacing then
        bot = contentSize + self.cspacing
    end
    if top < 0 then
        top = 0
    end

    local num , float = math.modf(top/((self.cellSizeX + self.cspacing)))
    --可视范围的第一个格子下标
    local topCellIndex = num + 1

    local num , float = math.modf(bot/((self.cellSizeX + self.cspacing)))
    --可视范围的最后一个格子下标
    local botCellIndex = num + 1

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
