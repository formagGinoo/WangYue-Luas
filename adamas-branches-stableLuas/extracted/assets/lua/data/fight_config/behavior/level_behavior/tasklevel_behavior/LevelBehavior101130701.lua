LevelBehavior101130701 = BaseClass("LevelBehavior101130701",LevelBehaviorBase)
--打败悬天的负责人

function LevelBehavior101130701:__init(fight)
	self.fight = fight
end

function LevelBehavior101130701.GetGenerates()
	local generates = {790007002}
	return generates
end

function LevelBehavior101130701:Init()
	self.missionState = 0
    self.role = nil
    self.posName = {
		fuzerenPos = "Cangku02", 
		rolePos = "CangkuRole",
		}
	self.deathCount = 0
	self.monsterList = {
		790007002,
    }
    self.dialogId = nil
	
	--跳反
	self.TiaofanSkillId = 900070010    --技能
	self.TiaofanGuideId = 2020      --引导
end

function LevelBehavior101130701:Update()
    self.role = BehaviorFunctions.GetCtrlEntity()
    if self.missionState == 0 then
        local pos = BehaviorFunctions.GetTerrainPositionP(self.posName.fuzerenPos, 10020005, "Prologue02")
		local rolePos = BehaviorFunctions.GetTerrainPositionP(self.posName.rolePos, 10020005, "Prologue02")
		BehaviorFunctions.InMapTransport(rolePos.x,rolePos.y,rolePos.z)
		local npcTag = BehaviorFunctions.GetTagByEntityId(self.monsterList[1])
		local worldMonsterLevel = BehaviorFunctions.GetEcoEntityLevel(npcTag)
		local monsterLevel = worldMonsterLevel - 2
        self.XuantianFuzeren = BehaviorFunctions.CreateEntity(self.monsterList[1], nil, pos.x, pos.y, pos.z, nil,nil,nil, self.levelId, 3)
		BehaviorFunctions.SetEntityValue(self.XuantianFuzeren,"haveWarn",false)   --关闭警戒
        BehaviorFunctions.DoLookAtTargetImmediately(self.XuantianFuzeren, self.role)
		BehaviorFunctions.DoLookAtTargetImmediately(self.role, self.XuantianFuzeren)
		--关卡相机
		self.empty = BehaviorFunctions.CreateEntity(2001, nil, pos.x, pos.y+1, pos.z)
		self.levelCam = BehaviorFunctions.CreateEntity(22001)
		BehaviorFunctions.CameraEntityFollowTarget(self.levelCam,self.role,"CameraTarget")
		--看向目标
		BehaviorFunctions.CameraEntityLockTarget(self.levelCam,self.empty)
		BehaviorFunctions.DoLookAtTargetImmediately(self.role,self.empty)
		--延时移除目标和镜头
		BehaviorFunctions.AddDelayCallByFrame(45,BehaviorFunctions,BehaviorFunctions.RemoveEntity,self.levelCam)
		BehaviorFunctions.AddDelayCallByFrame(45,BehaviorFunctions,BehaviorFunctions.RemoveEntity,self.empty)
        self.missionState = 1
    end
	
	if self.missionState == 1 then
		--当负责人进战后暂停负责人行为树
		--BehaviorFunctions.AddDelayCallByFrame(30,BehaviorFunctions,BehaviorFunctions.AddBuff,self.role,self.XuantianFuzeren,900000012)
		--让放技能
		BehaviorFunctions.CastSkillByTarget(self.XuantianFuzeren,self.TiaofanSkillId,self.role)   --跳反技能
		self.missionState = 2
	end
	
	if self.missionState == 2 then
		--跳反教程相关函数
		BehaviorFunctions.AddDelayCallByFrame(20,self,self.TiaofanGuide)
	end
	
	if self.missionState == 3 and BehaviorFunctions.CheckKeyDown(FightEnum.KeyEvent.Jump) then
		BehaviorFunctions.RemoveBuff(self.XuantianFuzeren,200000008)
		BehaviorFunctions.RemoveBuff(self.role,200000008)
		self.missionState = 4
	end
end


--跳反引导和时停
function LevelBehavior101130701:TiaofanGuide()
	--当负责人进战后暂停负责人行为树
	BehaviorFunctions.AddBuff(self.role,self.XuantianFuzeren,900000012)
	--打开跳反引导
	BehaviorFunctions.PlayGuide(self.TiaofanGuideId,1,1)
	--打开时停
	BehaviorFunctions.AddBuff(self.role,self.role,200000008)
	BehaviorFunctions.AddBuff(self.role,self.XuantianFuzeren,200000008)
	self.missionState = 3
end

function LevelBehavior101130701:__delete()

end

--死亡事件
function LevelBehavior101130701:Death(instanceId,isFormationRevive)
    if instanceId == self.XuantianFuzeren then
        self.deathCount = self.deathCount + 1
		if self.deathCount == 1 then
            --BehaviorFunctions.StartStoryDialog(self.dialogId)
            self:LevelFinish()
		end
    end
end


function LevelBehavior101130701:LevelFinish()
	BehaviorFunctions.SendTaskProgress(self.levelId, 1, 1)
	BehaviorFunctions.RemoveLevel(self.levelId)
end

--没用
function LevelBehavior101130701:StoryEndEvent(dialogId)
    if dialogId == self.dialogId then
        self:LevelFinish()
    end
end

--释放技能检查
function LevelBehavior101130701:FinishSkill(instanceId,skillId,skillType)
	if instanceId == self.XuantianFuzeren and skillId == self.TiaofanSkillId then
		if BehaviorFunctions.HasBuffKind(self.XuantianFuzeren,900000012) then
			BehaviorFunctions.RemoveBuff(self.XuantianFuzeren,900000012)
		end
	end
end

--释放技能检查
function LevelBehavior101130701:BreakSkill(instanceId,skillId,skillType)
	if instanceId == self.XuantianFuzeren and skillId == self.TiaofanSkillId then
		if BehaviorFunctions.HasBuffKind(self.XuantianFuzeren,900000012) then
			BehaviorFunctions.RemoveBuff(self.XuantianFuzeren,900000012)
		end
	end
end
