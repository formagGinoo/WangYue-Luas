TaskReviewLine = BaseClass("TaskReviewLine", Module)

local lineSize = 4

function TaskReviewLine:__init()
    self.object = nil
	self.node = {}
    self.curLineData = {}
end

function TaskReviewLine:Destroy()
end

function TaskReviewLine:InitLine(object, vec, type, isMoreLine)
	-- 获取对应的组件
	self.object = object
    self.node = UtilsUI.GetContainerObject(self.object.transform)
	self.vec = vec
	self.type = type
	self.isMoreLine = isMoreLine  -- 是否同时有多条线（计算偏移）
	if self.type == 1 then
		self:InitRLine()
	elseif self.type == 2 then
		self:InitDLine()
	elseif self.type == 3 then
		self:InitULine()
	elseif self.type == 4 then
		self:InitRDLine()
	elseif self.type == 5 then
		self:InitRULine()
	elseif self.type == 12 then
		self:InitRDRLine()
	elseif self.type == 13 then
		self:InitRURLine()
	elseif self.type == 21 then
		self:InitDRULine()
	elseif self.type == 31 then
		self:InitURDLine()
	end
	self.object:SetActive(true)
end

function TaskReviewLine:InitRLine()
	self.node.LineX_rect.sizeDelta = Vector2(self.vec.x - 100,lineSize)
end

function TaskReviewLine:InitDLine()
	self.node.LineY_rect.sizeDelta = Vector2(lineSize,- self.vec.y - 110)
end

function TaskReviewLine:InitULine()
	self.node.LineY_rect.sizeDelta = Vector2(lineSize,self.vec.y - 110)
end

function TaskReviewLine:InitRDLine()
	if self.isMoreLine then 
		self.vec.y  = self.vec.y + 15 
		UnityUtils.SetAnchoredPosition(self.object.transform,self.object.transform.anchoredPosition.x,self.object.transform.anchoredPosition.y-15)
	end	
	self.node.LineX_rect.sizeDelta = Vector2(self.vec.x - 100,lineSize)
	self.node.LineY_rect.sizeDelta = Vector2(lineSize,-self.vec.y - 75)
end

function TaskReviewLine:InitRULine()
	if self.isMoreLine then 
		self.vec.y  = self.vec.y - 15 
		UnityUtils.SetAnchoredPosition(self.object.transform,self.object.transform.anchoredPosition.x,self.object.transform.anchoredPosition.y+15)
	end
	self.node.LineX_rect.sizeDelta = Vector2(self.vec.x - 100,lineSize)
	self.node.LineY_rect.sizeDelta = Vector2(lineSize,self.vec.y - 75)
end

function TaskReviewLine:InitRDRLine()
	if self.isMoreLine then 
		self.vec.y  = self.vec.y + 15 
		UnityUtils.SetAnchoredPosition(self.object.transform,self.object.transform.anchoredPosition.x,self.object.transform.anchoredPosition.y-15)
	end
	self.node.LineX_rect.sizeDelta = Vector2(self.vec.x - 195,lineSize)
	self.node.LineY_rect.sizeDelta = Vector2(lineSize, -self.vec.y - 60)
end

function TaskReviewLine:InitRURLine()
	if self.isMoreLine then 
		self.vec.y  = self.vec.y - 15 
		UnityUtils.SetAnchoredPosition(self.object.transform,self.object.transform.anchoredPosition.x,self.object.transform.anchoredPosition.y+15)
	end
	self.node.LineX_rect.sizeDelta = Vector2(self.vec.x - 195,lineSize)
	self.node.LineY_rect.sizeDelta = Vector2(lineSize,self.vec.y - 60)
end

function TaskReviewLine:InitDRULine()
	self.node.LineX_rect.sizeDelta = Vector2(self.vec.x - 65,lineSize)
	self.node.LineY_rect.sizeDelta = Vector2(lineSize,-self.vec.y + 20)
end

function TaskReviewLine:InitURDLine()
	self.node.LineX_rect.sizeDelta = Vector2(self.vec.x - 65,lineSize)
	self.node.LineY_rect.sizeDelta = Vector2(lineSize,self.vec.y + 20)
end

function TaskReviewLine:OnReset()
	
end