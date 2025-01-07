FixedQueue = BaseClass("FixedQueue")

local _tinsert = table.insert

function FixedQueue:__init()
	self.v_head = 1
	self.v_tail = 0
	self.v_list = {}
end

function FixedQueue:Push(info)
	self.v_tail = self.v_tail + 1
	self.v_list[self.v_tail] = info
end

function FixedQueue:Pop()
	local head = self.v_head
	if head > self.v_tail then
		return
	end

	local info = self.v_list[head]
	self.v_list[head] = nil
	self.v_head = self.v_head + 1

	return info
end

function FixedQueue:GetTop()
	local head = self.v_head

	if head > self.v_tail then
		self.v_head = 1
		self.v_tail = 0
		return
	end

	return self.v_list[head]
end

function FixedQueue:GetIndex(index)
	index = self.v_head + index

	if index > self.v_tail then
		return
	end

	return self.v_list[index]
end

function FixedQueue:Length()
	return self.v_tail - self.v_head + 1
end

function FixedQueue:Refresh()
	self.v_head = 1
	self.v_tail = 0
	self.v_list = {}
end