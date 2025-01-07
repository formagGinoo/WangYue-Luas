--主线第5章

LevelBehavior10502022 = BaseClass("LevelBehavior10502022",LevelBehaviorBase)

--预加载
function LevelBehavior10502022.GetGenerates()
	local generates = {2001}
	return generates
end
function LevelBehavior10502022.GetMagics()
	local generates = {}
	return generates
end


--参数初始化
function LevelBehavior10502022:Init()
	self.frame = 0
	self.elcbox = nil
	self.FakeElc1 = nil
	self.FakeElc2 = nil
	self.photostate = nil
	self.phototimes = 0
	self.createId = 2001
end

--帧事件
function LevelBehavior10502022:Update()
	self.elcbox = BehaviorFunctions.GetEcoEntityByEcoId(2001001020009)
	self:createFakeElc()
end


function LevelBehavior10502022:EntryPhotoFrame(entityInstanceId)
	if entityInstanceId == self.elcbox then
		self.photostate = 1
	elseif (entityInstanceId == self.FakeElc1 or entityInstanceId == self.FakeElc2) and self.photostate ~= 1 then
		self.photostate = 2
	end
end


function LevelBehavior10502022:ExitPhotoFrame(entityInstanceId)
	if entityInstanceId == self.elcbox then
		self.photostate = 0
	elseif (entityInstanceId == self.FakeElc1 or entityInstanceId == self.FakeElc2) and self.photostate ~= 1 then
		self.photostate = 0
	end
end


function LevelBehavior10502022:OnPhotoClick()
	if self.photostate == 1 then
		self.photostate = 3
		--BehaviorFunctions.ClosePhotoPanel()
	end
end

function LevelBehavior10502022:OnPhotoExit()
	if self.photostate == 3 then
		BehaviorFunctions.StartStoryDialog(601013101)
	elseif 	self.photostate == 2 and self.phototimes < 1 then
		BehaviorFunctions.StartStoryDialog(601013201)
		self.phototimes = self.phototimes + 1
	elseif 	self.photostate == 2 and self.phototimes >= 1 then
		BehaviorFunctions.StartStoryDialog(601013301)
	end
end

function LevelBehavior10502022:StoryEndEvent(dialogId)
	if dialogId == 601013101 then
		BehaviorFunctions.FinishLevel(10502022)
	end
end


--创建两个假电箱的判断实体
function LevelBehavior10502022:createFakeElc()
	if not self.FakeElc1 then
		self.FakeElc1 = BehaviorFunctions.CreateEntityByPosition(self.createId, nil, "FakeElc1", "Task_Main_52",10502022,self.levelId,nil)
	end
	if not self.FakeElc2 then
		self.FakeElc2 = BehaviorFunctions.CreateEntityByPosition(self.createId, nil, "FakeElc2", "Task_Main_52",10502022,self.levelId,nil)
	end
end