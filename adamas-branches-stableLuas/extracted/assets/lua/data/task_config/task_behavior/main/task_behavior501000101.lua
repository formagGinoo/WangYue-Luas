TaskBehavior501000101 = BaseClass("TaskBehavior501000101")
--序章bgm控制逻辑

function TaskBehavior501000101.GetGenerates()
	local generates = {}
	return generates
end

function TaskBehavior501000101:__init(taskInfo)
	self.taskInfo = taskInfo
	self.taskId = taskInfo.taskId
	self.taskStepId = taskInfo.stepId
	self.role = nil	
	
	self.bgmLogic =
	{
		[1] = {
			Bgmtype = "Boss" ,
			BgmList = {
				[1] = {bgmName = "Corridor",bgmState = false},--走廊战斗bgm
				[2] = {bgmName = "Detect",bgmState = false},--探索阶段bgm
				[3] = {bgmName = "Balcony",bgmState = false},--天台战斗bgm
					  }
			  },
		[2] = {
			Bgmtype = "Story" ,
			BgmList = {
				[1] = {bgmName = "Negotiation1",bgmState = false},--谈判bgm缓和循环
				[2] = {bgmName = "Negotiation2",bgmState = false},--谈判bgm高潮循环
				[3] = {bgmName = "PrologueEnd",bgmState = false},--序章结尾过场音乐
					  }
			  }		
	}
	
	self.endingTaskId ={1011401,1011501,1011601,1011701,1011801,1011901}
	self.endingBgmDialog = {101202805,101203404,101203707,101203608,101202905,101203105}
	
	self.hideTiantaiId = {101202904,101203104,101203606}
	self.hideBuildingId = {101202903,101203706,101203103}
	
	self.ending = false
	
	self.bgmState = 0
	self.currentBGM = nil
	
	self.AmbSound = false

end

function TaskBehavior501000101:Update()	
	self.role = BehaviorFunctions.GetCtrlEntity()	
	
	--战斗开始bgm
	if BehaviorFunctions.CheckLevelIsCreate(101130101) then
		if self.bgmState < 5 then
			self:BgmChangeLogic(self.bgmLogic,1,3)
			--LogError("现在正在播放天台战斗bgm")
			self.currentBGM = 13
			self.bgmState = 5
		end
	elseif not BehaviorFunctions.CheckLevelIsCreate(101130101) then
		if self.bgmState == 5 then
			if self.currentBGM ~= nil then
				self:BgmChangeLogic(nil)
				--LogError("现在停止了bgm的播放")
				self.currentBGM = nil
			end
		end
	end
	
	if self.ending == false then
		for i,v in ipairs (self.endingTaskId) do
			if BehaviorFunctions.CheckTaskId(v) then
				self.ending = true
				self:BgmChangeLogic(nil)
				--LogError("现在是结局，已经停止bgm的播放了")
			end
		end
	end
	
	--开始第一场战斗时，切换为走廊战斗bgm
	if BehaviorFunctions.CheckTaskStepIsFinish(1010101,1) and not BehaviorFunctions.CheckTaskStepIsFinish(1010101,2) then
		if self.bgmState < 1 then
			self:BgmChangeLogic(self.bgmLogic,1,1)
			--LogError("现在正在播放走廊战斗bgm")
			self.currentBGM = 11
			self.bgmState = 1
		end
	--战斗结束后，切换为底噪bgm
	elseif BehaviorFunctions.CheckTaskStepIsFinish(1010101,2) and not BehaviorFunctions.CheckTaskStepIsFinish(1010201,2) then
		if not self.AmbSound then
			self:BgmChangeLogic(nil)
			BehaviorFunctions.PlayAmbSound("Amb_Bgm_Prologue_Paragraph")
			self.AmbSound = true
		end		
	--进入房间调查阶段时，切换为调查bgm
	elseif BehaviorFunctions.CheckTaskStepIsFinish(1010201,3) and not BehaviorFunctions.CheckTaskStepIsFinish(1010501,1) then
		if self.bgmState < 2 then
			if self.AmbSound then
				BehaviorFunctions.StopAmbSound("Amb_Bgm_Prologue_Paragraph")
				self.AmbSound = false
			end
			self:BgmChangeLogic(self.bgmLogic,1,2)
			--LogError("现在正在播放房间调查bgm")
			self.currentBGM = 12
			self.bgmState = 2
		end
	--谈判缓和阶段bgm
	elseif BehaviorFunctions.CheckTaskStepIsFinish(1010501,1) and not BehaviorFunctions.CheckTaskStepIsFinish(1010801,1) then
		if self.bgmState < 3 then
			self:BgmChangeLogic(self.bgmLogic,2,1)
			--LogError("现在正在播放谈判缓和阶段bgm")
			self.currentBGM = 21
			self.bgmState = 3
		end
	--谈判焦灼阶段bgm	
	elseif BehaviorFunctions.CheckTaskStepIsFinish(1010801,1) then
		if self.bgmState < 4 then
			self:BgmChangeLogic(self.bgmLogic,2,2)
			--LogError("现在正在播放谈判焦灼阶段bgm")
			self.currentBGM = 22
			self.bgmState = 4
		end
	else
		if self.currentBGM ~= nil and self.ending == false then
			self:BgmChangeLogic(nil)
			--LogError("现在停止了bgm的播放")
			self.currentBGM = nil
		end
	end
end

function TaskBehavior501000101:StoryPassEvent(dialogId)
	for i,v in ipairs(self.endingBgmDialog) do
		if v == dialogId then
			self.bgmState = 6
			self:BgmChangeLogic(self.bgmLogic,2,3)
			--LogError("现在正在播放序章结尾bgm")
			self.currentBGM = 23
		end
	end
	for i,v in ipairs(self.hideTiantaiId) do
		if v == dialogId then
			BehaviorFunctions.HideSceneObjectByPath("Scene10020005/Scene/SubScene/SceneL0/SceneBlock33599490/SingleRoot/lndoor_10020005_XZL_Yangtai_A_01(Clone)",true)
			BehaviorFunctions.HideSceneObjectByPath("Scene10020005/Scene/SubScene/SceneL0/SceneBlock33599490/SingleRoot/Chunk_Dsjinjing_10020004_02_City(Clone)(Clone)",true)
		end
	end	
	for i,v in ipairs(self.hideBuildingId) do
		if v == dialogId then		
			BehaviorFunctions.ActiveSceneObjByPath("Scene10020005/Scene/SubScene/SceneL0/SceneBlock33665034",false)
			BehaviorFunctions.ActiveSceneObjByPath("Scene10020005/Scene/SubScene/SceneL0/SceneBlock33648650",false)
			BehaviorFunctions.ActiveSceneObjByPath("Scene10020005/Scene/SubScene/SceneL0/SceneBlock33640458",false)
			BehaviorFunctions.ActiveSceneObjByPath("Scene10020005/Scene/SubScene/SceneL0/SceneBlock33656842",false)
			BehaviorFunctions.ActiveSceneObjByPath("Scene10020005/Scene/SubScene/SceneL0/SceneBlock33640457",false)
			BehaviorFunctions.ActiveSceneObjByPath("Scene10020005/Scene/SubScene/SceneL0/SceneBlock33648649",false)
			BehaviorFunctions.ActiveSceneObjByPath("Scene10020005/Scene/SubScene/SceneL0/SceneBlock33656841",false)
			BehaviorFunctions.ActiveSceneObjByPath("Scene10020005/Scene/SubScene/SceneL0/SceneBlock33632266",false)
			BehaviorFunctions.ActiveSceneObjByPath("Scene10020005/Scene/SubScene/SceneL0/SceneBlock33665033",false)
			BehaviorFunctions.ActiveSceneObjByPath("Scene10020005/Scene/SubScene/SceneL0/SceneBlock33673225",false)
			BehaviorFunctions.ActiveSceneObjByPath("Scene10020005/Scene/SubScene/SceneL0/SceneBlock33681417",false)
			BehaviorFunctions.ActiveSceneObjByPath("Scene10020005/Scene/SubScene/SceneL0/SceneBlock33673226",false)
			BehaviorFunctions.ActiveSceneObjByPath("Scene10020005/Scene/SubScene/SceneL0/SceneBlock33681418",false)
		end
	end
end

function TaskBehavior501000101:StorySelectEvent(dialogId)
	if dialogId == 101203005 or 
	   dialogId == 101203008 or 
	   dialogId == 101203013 then
		if self.bgmState < 4 then
			self:BgmChangeLogic(self.bgmLogic,2,2)
			--LogError("现在正在播放谈判焦灼阶段bgm")
			self.currentBGM = 22
			self.bgmState = 4
		end
	end
end

function TaskBehavior501000101:BgmChangeLogic(group,groupNum,memberNum)
	--if group then
		--BehaviorFunctions.SetActiveBGM("TRUE")--开启默认BGM
		--BehaviorFunctions.SetBgmState("BgmType",group[groupNum].Bgmtype)
		--BehaviorFunctions.SetBgmState("GamePlayType",group[groupNum].BgmList[memberNum].bgmName)
		--group[groupNum].BgmList[memberNum].bgmState = true
	--else
		--BehaviorFunctions.SetActiveBGM("FAlSE")--关闭默认BGM
		----BehaviorFunctions.SetBgmState("GamePlayType","Explore")
	--end
end
