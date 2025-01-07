TaskBehavior105020112 = BaseClass("TaskBehavior105020112")

--预加载
--function TaskBehavior105020112.GetGenerates()
	--local generates = {2001}
	--return generates
--end

function TaskBehavior105020112:__init()
    --self.frame = 0
	--self.elcbox = nil
	--self.FakeElc1 = nil
	--self.FakeElc2 = nil
	--self.photostate = nil
	--self.phototimes = 0
	--self.createId = 2001
end



function TaskBehavior105020112:Update()
	self.elcbox = BehaviorFunctions.GetEcoEntityByEcoId(2001001020009)
	--self:createFakeElc()
end



function TaskBehavior105020112:EntryPhotoFrame(entityInstanceId)
	--if entityInstanceId == self.elcbox then
		--self.photostate = 1
	--elseif (entityInstanceId == self.FakeElc1 or entityInstanceId == self.FakeElc2) and self.photostate ~= 1 then
		--self.photostate = 2
	--end
end


function TaskBehavior105020112:ExitPhotoFrame(entityInstanceId)
	--if entityInstanceId == self.elcbox then
		--self.photostate = 0
	--elseif (entityInstanceId == self.FakeElc1 or entityInstanceId == self.FakeElc2) and self.photostate ~= 1 then
		--self.photostate = 0
	--end
end


function TaskBehavior105020112:OnPhotoClick()
	--if self.photostate == 1 then
		--self.photostate = 3
		----BehaviorFunctions.ClosePhotoPanel()
	--end
end

function TaskBehavior105020112:OnPhotoExit()
	--if self.photostate == 3 then
		--BehaviorFunctions.StartStoryDialog(601013101)
	--elseif 	self.photostate == 2 and self.phototimes < 1 then
		--BehaviorFunctions.StartStoryDialog(601013201)
		--self.phototimes = self.phototimes + 1
	--elseif 	self.photostate == 2 and self.phototimes >= 1 then
		--BehaviorFunctions.StartStoryDialog(601013301)
	--end
end

function TaskBehavior105020112:StoryEndEvent(dialogId)
	--if dialogId == 601013101 then
		--BehaviorFunctions.SendTaskProgress(1050201, 12, 1)
	--end
end


--创建两个假电箱的判断实体
function TaskBehavior105020112:createFakeElc()
	--if not self.FakeElc1 then
		--self.FakeElc1 = BehaviorFunctions.CreateEntityByPosition(self.createId, nil, "FakeElc1", "Task_Main_52")
	--end
	--if not self.FakeElc2 then
		--self.FakeElc2 = BehaviorFunctions.CreateEntityByPosition(self.createId, nil, "FakeElc2", "Task_Main_52")
	--end
end