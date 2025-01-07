LevelBehavior405020201 = BaseClass("LevelBehavior405020201",LevelBehaviorBase)
--普通任务刷怪关
 
function LevelBehavior405020201:__init(fight)
    self.fight = fight
end

function LevelBehavior405020201.GetGenerates()
    local generates = {
        2041101,     --空实体
        2041104,     --开关实体
        2041105,     --节点实体
        2041106,      --终点
        2041102,      --蓝电线特效
        2041103         --黄电线特效
        -- 2010101,      --宝箱
    }
    return generates
end

function LevelBehavior405020201:Init()
    self.missionState = 0
    self.role = nil
    self.missionUnloadDis = 25             --卸载距离
    self.playerPos = nil
    self.missionDistance = 0
    self.missionStartPos = nil
    self.levelwin = false                   --关卡胜利
    self.eco = 3003001080001
    self.ecoEntity = nil
	-- self.TreasureBox = 2010101          --宝箱

    --↓电路位置点TrigPos，电路玩法必用↓---
    self.trigEntity = 2041101           --空实体,搜索名称Entity1005

    self.HanrklineBlue = 2041102         --电线特效蓝色
    self.HanrklineGold = 2041103         --电线特效黄色

    self.TrigBeginEntity = 2041104       --开关起点
    self.TrigTurnEntity = 2041105         --电路节点
    self.TrigEndEntity =   2041106       --电路终点

    self.Trig01BeginTake = false
    self.Trig01EndTake = false

    self.Trig02BeginTake = false
    self.Trig0200Take = false
    self.Trig02EndTake = false

    self.TrigPos = {             --电路位置点信息，能修改的地方
        [1] = "Trig01Begin",
        [2] = "Trig0100",
        [3] = "Trig0101",
        [4] = "Trig0102",
        [5] = "Trig01End",
        [6] = "Trig02Begin",
        [7] = "Trig0200",
        [8] = "Trig02End",
        [9] = "Trig03End"
    }
    --预存电路节点名称
    self.TrigPosNil = false
    self.TrigNil = {
        [1] = nil,
        [2] = nil,
        [3] = nil,
        [4] = nil,
        [5] = nil,
        [6] = nil,
        [7] = nil,
        [8] = nil,
        [9] = nil,
    }

    --预存电线特效名称
    self.fxhackDriveLine = {
        [12] = nil,
        [23] = nil,
        [34] = nil,
        [45] = nil,
        [67] = nil,
        [78] = nil,
        [97] = nil,
    }

    --电线变色预存
    self.Trig01Blue = true
    self.Trig01Gold = false
    self.Trig02_1Blue = true
    self.Trig02_1Gold = false
    self.Trig02_2Blue = true
    self.Trig02_2Gold = false
    self.Trig02_3Blue = true
    self.Trig02_3Gold = false

    self.RemoveLineTack = false

    --tips
    self.tips = 102670102
    self.tipstack = 0
    self.tipsSum = 2
    --教学
    self.teach = 20034

    --每个节点预存名称占位资源
    self.Trig01Begin = nil
    self.Trig0100 = nil
    self.Trig0101 = nil
    self.Trig0102 = nil
    self.Trig01End = nil
    self.Trig02Begin = nil
    self.Trig0200 = nil
    self.Trig02End = nil
    self.Trig03End = nil

    --移除电路节点预存
    self.RemoveLineEntityInit = false
    --↑电路位置点TrigPos，电路玩法必用↑---

end

function LevelBehavior405020201:Update()
    self.role = BehaviorFunctions.GetCtrlEntity()
    --获取生态ID
    self.ecoEntity = BehaviorFunctions.GetEcoEntityByEcoId(self.eco)

    if self.playerPos == nil then
		self.playerPos = BehaviorFunctions.GetPositionP(self.role)										--获取玩家的坐标
	end
    self.missionStartPos = BehaviorFunctions.GetTerrainPositionP("Player",self.levelId,self.logicName)
	self.missionDistance = BehaviorFunctions.GetDistanceFromPos(self.playerPos,self.missionStartPos)		--获取玩家和肉鸽的距离
    --如果距离超出则卸载距离
    if self.missionDistance >= self.missionUnloadDis then				--玩家距离 > 100
        self:RemoveFxTrigNil()
        self:RemoveTrig()
        self:LevelFinish()
        self.missionState = 999
    end

    if self.missionState == 0 then
        --↓在各个节点位置创建空实体,连线特效挂点使用，电路玩法必用↓--
        if self.TrigPosNil == false then
            self:CreateNilEntity()
            BehaviorFunctions.ShowCommonTitle(4,'开始解密',true)
        end
        --↑在各个节点位置创建空实体,连线特效挂点使用，电路玩法必用↑--

        --创建电路开关↓
        --线路1
        self.Trig01Begin = self:InPositionEntity('Trig01Begin',self.TrigBeginEntity, 1)     --线路1起点
        self.Trig01End = self:InPositionEntity('Trig01End',self.TrigEndEntity, 5)            --线路1节点

        --线路2
        self.Trig02Begin = self:InPositionEntity('Trig02Begin',self.TrigBeginEntity, 6)     --线路2起点
        self.Trig0200 = self:InPositionEntity('Trig0200',self.TrigTurnEntity, 7)            --线路2节点
        self.Trig02End = self:InPositionEntity('Trig02End',self.TrigEndEntity, 8)           --线路2终点
        --创建电路开关↑  

        do  --临时，重置玩家位置
            -- local palypos = BehaviorFunctions.GetTerrainPositionP("Player", self.levelId)
            -- BehaviorFunctions.InMapTransport(palypos.x, palypos.y, palypos.z)

            do
                local levelCam = BehaviorFunctions.CreateEntity(22007)
                BehaviorFunctions.CameraEntityFollowTarget(levelCam,self.role,"CameraTarget")
                BehaviorFunctions.CameraEntityLockTarget(levelCam,self.TrigNil[1])
                BehaviorFunctions.DoLookAtTargetImmediately(self.role,self.TrigNil[1])
                BehaviorFunctions.AddDelayCallByFrame(45,BehaviorFunctions,BehaviorFunctions.RemoveEntity,levelCam)
            end
            -- LevelCommonFunction:LevelCameraLookAtPos(22002,30,'CameraTarget','Trig01End',10,10)
        end
        BehaviorFunctions.ShowTip(self.tips)
        BehaviorFunctions.ChangeSubTipsDesc(2, self.tips, self.tipstack, self.tipsSum)

        --教学
        if BehaviorFunctions.CheckTeachIsFinish(self.teach) == false then
            BehaviorFunctions.AddDelayCallByTime(1.5,BehaviorFunctions,BehaviorFunctions.ShowGuideImageTips,self.teach)
            -- BehaviorFunctions.ShowGuideImageTips(self.teach)
        end

        self.missionState = 1
	end

    if self.missionState == 1 then
        --↓获取当前开关的状态，电路玩法必用↓--

        --Trig01Begin--1线路--
        if self.Trig01Begin then
            if BehaviorFunctions.GetEntityValue(self.Trig01Begin,"wire") then
                self.Trig01BeginTake = true
            else
                self.Trig01BeginTake = false
            end
        end
        --↑获取当前开关的状态，电路玩法必用↑--

        --Trig02Begin--2线路--
        if self.Trig02Begin then
            if BehaviorFunctions.GetEntityValue(self.Trig02Begin,"wire") then
                self.Trig02BeginTake = true
            else
                self.Trig02BeginTake = false
            end
        end

        --Trig0200--2线路--
        if self.Trig0200 then
            if BehaviorFunctions.GetEntityValue(self.Trig0200,"wire") then
                self.Trig0200Take = true
            else
                self.Trig0200Take = false
            end
        end
        --↑获取当前开关的状态，电路玩法必用↑--

        --↓在空实体之间创建电路链接特效，电路玩法必用↓--
        if BehaviorFunctions.GetEntityState(self.role) == FightEnum.EntityState.Hack then   --在骇入模式创建连线特效
            self.RemoveLineEntityInit = false
            if self.RemoveLineTack == false then
                self.RemoveLineTack = true
            end

            --↓ 线路1创建--蓝色 ↓--
            if self.Trig01BeginTake == false then
                if self.Trig01Blue == true and self.Trig01Gold == false then
                    self:HanrkSwitchBlue(self.Trig01End)            --控制终点颜色，蓝色
                    self.Trig01EndTake = false

                    self:CreateAndStoreTriggers(12,1,2,self.HanrklineBlue)
                    self:CreateAndStoreTriggers(23,2,3,self.HanrklineBlue)
                    self:CreateAndStoreTriggers(34,3,4,self.HanrklineBlue)
                    self:CreateAndStoreTriggers(45,4,5,self.HanrklineBlue)

                    self.Trig01Blue = false
                    self.Trig01Gold = true
                end
            elseif self.Trig01BeginTake == true then
                if self.Trig01Blue == false and self.Trig01Gold == true then
                    BehaviorFunctions.SetEntityHackEffectIsTask(self.Trig01End, true)   --控制终点颜色，黄色
                    self.Trig01EndTake = true

                    self:CreateAndStoreTriggers(12,1,2,self.HanrklineGold)
                    self:CreateAndStoreTriggers(23,2,3,self.HanrklineGold)
                    self:CreateAndStoreTriggers(34,3,4,self.HanrklineGold)
                    self:CreateAndStoreTriggers(45,4,5,self.HanrklineGold)

                    self.Trig01Blue = true
                    self.Trig01Gold = false
                end
            end
            --↑ 线路1创建--蓝色 ↑--

            --线路2_2, 基础版本，两个开关
            --↓ 线路2_2，二选一格式 ↓--

            if self.Trig02BeginTake == false then
                if self.Trig0200Take == false then
                    self:HanrkSwitchBlue(self.Trig02End)            --控制终点颜色，蓝色
                    self.Trig02EndTake = false
                    if self.Trig02_1Blue == true and self.Trig02_1Gold == false then
                        self:CreateAndStoreTriggers(67, 6, 7, self.HanrklineBlue)
                        self.Trig02_1Blue = false
                        self.Trig02_1Gold = true
                    end
                    if self.Trig02_2Blue == true and self.Trig02_2Gold == false then
                        self:CreateAndStoreTriggers(78, 7, 8, self.HanrklineBlue)
                        self.Trig02_2Blue = false
                        self.Trig02_2Gold = true
                    end
                    if self.Trig02_3Blue == true and self.Trig02_3Gold == false then
                        self:CreateAndStoreTriggers(97, 9, 7, self.HanrklineBlue)
                        self.Trig02_3Blue = false
                        self.Trig02_3Gold = true
                    end
                elseif self.Trig0200Take == true then
                    self:HanrkSwitchBlue(self.Trig02End)            --控制终点颜色，蓝色
                    self.Trig02EndTake = false
                    if self.Trig02_1Blue == true and self.Trig02_1Gold == false then
                        self:CreateAndStoreTriggers(67, 6, 7, self.HanrklineBlue)
                        self.Trig02_1Blue = false
                        self.Trig02_1Gold = true
                    end
                    if self.Trig02_2Blue == true and self.Trig02_2Gold == false then
                        self:CreateAndStoreTriggers(78, 7, 8, self.HanrklineBlue)
                        self.Trig02_2Blue = false
                        self.Trig02_2Gold = true
                    end
                    if self.Trig02_3Blue == true and self.Trig02_3Gold == false then
                        self:CreateAndStoreTriggers(97, 9, 7, self.HanrklineBlue)
                        self.Trig02_3Blue = false
                        self.Trig02_3Gold = true
                    end
                end
            elseif self.Trig02BeginTake == true then
                if self.Trig0200Take == false then
                    self:HanrkSwitchBlue(self.Trig02End)            --控制终点颜色，蓝色
                    self.Trig02EndTake = false
                    if self.Trig02_1Blue == false and self.Trig02_1Gold == true then
                        self:CreateAndStoreTriggers(67, 6, 7, self.HanrklineGold)
                        self.Trig02_1Blue = true
                        self.Trig02_1Gold = false
                    end
                    if self.Trig02_2Blue == true and self.Trig02_2Gold == false then
                        self:CreateAndStoreTriggers(78, 7, 8, self.HanrklineBlue)
                        self.Trig02_2Blue = false
                        self.Trig02_2Gold = true
                    end
                    if self.Trig02_3Blue == false and self.Trig02_3Gold == true then
                        self:CreateAndStoreTriggers(97, 7, 9, self.HanrklineGold)
                        self.Trig02_3Blue = true
                        self.Trig02_3Gold = false
                    end
                elseif self.Trig0200Take == true then
                    BehaviorFunctions.SetEntityHackEffectIsTask(self.Trig02End, true)   --控制终点颜色，黄色
                    self.Trig02EndTake = true
                    if self.Trig02_1Blue == false and self.Trig02_1Gold == true then
                        self:CreateAndStoreTriggers(67, 6, 7, self.HanrklineGold)
                        self.Trig02_1Blue = true
                        self.Trig02_1Gold = false
                    end
                    if self.Trig02_2Blue == false and self.Trig02_2Gold == true then
                        self:CreateAndStoreTriggers(78, 7, 8, self.HanrklineGold)
                        self.Trig02_2Blue = true
                        self.Trig02_2Gold = false
                    end
                    if self.Trig02_3Blue == true and self.Trig02_3Gold == false then
                        BehaviorFunctions.SetEntityHackEffectIsTask(self.Trig02End, true)   --控制终点颜色，黄色
                        self:CreateAndStoreTriggers(97, 9, 7, self.HanrklineBlue)
                        self.Trig02_3Blue = false
                        self.Trig02_3Gold = true
                    end
                end
            end

            if self.Trig0200Take == false then
                if self.Trig02BeginTake == false then
                    self:HanrkSwitchBlue(self.Trig02End)            --控制终点颜色，蓝色
                    self.Trig02EndTake = false
                    if self.Trig02_1Blue == true and self.Trig02_1Gold == false then
                        self:CreateAndStoreTriggers(67, 6, 7, self.HanrklineBlue)
                        self.Trig02_1Blue = false
                        self.Trig02_1Gold = true
                    end
                    if self.Trig02_2Blue == true and self.Trig02_2Gold == false then
                        self:CreateAndStoreTriggers(78, 7, 8, self.HanrklineBlue)
                        self.Trig02_2Blue = false
                        self.Trig02_2Gold = true
                    end
                    if self.Trig02_3Blue == true and self.Trig02_3Gold == false then
                        self:CreateAndStoreTriggers(97, 9, 7, self.HanrklineBlue)
                        self.Trig02_3Blue = false
                        self.Trig02_3Gold = true
                    end
                elseif self.Trig02BeginTake == true then
                    self:HanrkSwitchBlue(self.Trig02End)            --控制终点颜色，蓝色
                    self.Trig02EndTake = false
                    if self.Trig02_1Blue == false and self.Trig02_1Gold == true then
                        self:CreateAndStoreTriggers(67, 6, 7, self.HanrklineGold)
                        self.Trig02_1Blue = true
                        self.Trig02_1Gold = false
                    end
                    if self.Trig02_2Blue == true and self.Trig02_2Gold == false then
                        self:CreateAndStoreTriggers(78, 7, 8, self.HanrklineBlue)
                        self.Trig02_2Blue = false
                        self.Trig02_2Gold = true
                    end
                    if self.Trig02_3Blue == false and self.Trig02_3Gold == true then
                        self:CreateAndStoreTriggers(97, 7, 9, self.HanrklineGold)
                        self.Trig02_3Blue = true
                        self.Trig02_3Gold = false
                    end
                end
            elseif self.Trig0200Take == true then
                if self.Trig02BeginTake == false then
                    self:HanrkSwitchBlue(self.Trig02End)            --控制终点颜色，蓝色
                    self.Trig02EndTake = false
                    if self.Trig02_1Blue == true and self.Trig02_1Gold == false then
                        self:CreateAndStoreTriggers(67, 6, 7, self.HanrklineBlue)
                        self.Trig02_1Blue = false
                        self.Trig02_1Gold = true
                    end
                    if self.Trig02_2Blue == true and self.Trig02_2Gold == false then
                        self:CreateAndStoreTriggers(78, 7, 8, self.HanrklineBlue)
                        self.Trig02_2Blue = false
                        self.Trig02_2Gold = true
                    end
                    if self.Trig02_3Blue == true and self.Trig02_3Gold == false then
                        self:CreateAndStoreTriggers(97, 9, 7, self.HanrklineBlue)
                        self.Trig02_3Blue = false
                        self.Trig02_3Gold = true
                    end
                elseif self.Trig02BeginTake == true then
                    BehaviorFunctions.SetEntityHackEffectIsTask(self.Trig02End, true)   --控制终点颜色，黄色
                    self.Trig02EndTake = true
                    if self.Trig02_1Blue == false and self.Trig02_1Gold == true then
                        self:CreateAndStoreTriggers(67, 6, 7, self.HanrklineGold)
                        self.Trig02_1Blue = true
                        self.Trig02_1Gold = false
                    end
                    if self.Trig02_2Blue == false and self.Trig02_2Gold == true then
                        self:CreateAndStoreTriggers(78, 7, 8, self.HanrklineGold)
                        self.Trig02_2Blue = true
                        self.Trig02_2Gold = false
                    end
                    if self.Trig02_3Blue == true and self.Trig02_3Gold == false then
                        BehaviorFunctions.SetEntityHackEffectIsTask(self.Trig02End, true)   --控制终点颜色，黄色
                        self:CreateAndStoreTriggers(97, 9, 7, self.HanrklineBlue)
                        self.Trig02_3Blue = false
                        self.Trig02_3Gold = true
                    end
                end
            end

            --↑ 线路2_2，二选一格式 ↑--

        elseif BehaviorFunctions.GetEntityState(self.role) ~= FightEnum.EntityState.Hack then
			if self.RemoveLineEntityInit == false then
                if self.RemoveLineTack == true then

                -- 根据当前的状态切换颜色标记
                    self:ToggleTrigColorState('Trig01Gold','Trig01Blue')
                    self:ToggleTrigColorState('Trig02_1Gold','Trig02_1Blue')
                    self:ToggleTrigColorState('Trig02_2Gold','Trig02_2Blue')
                    self:ToggleTrigColorState('Trig02_3Gold','Trig02_3Blue')

                --在退出骇入模式移除连线特效
                --检查并移除实体，传递索引而不是实体对象
                self:RemoveLineEntity(12)
                self:RemoveLineEntity(23)
                self:RemoveLineEntity(34)
                self:RemoveLineEntity(45)
                self:RemoveLineEntity(67)
                self:RemoveLineEntity(78)
                self:RemoveLineEntity(97)
                self.RemoveLineEntityInit = true
                self.RemoveLineTack = false
                end
			end
        end
        --↑在空实体之间创建电路链接特效↑--

        --↓左侧提示--
        if self.Trig01EndTake == false and self.Trig02EndTake == false then
            BehaviorFunctions.ChangeSubTipsDesc(1, self.tips, 0, 2) -- 当两者都为 false 时  
        elseif (self.Trig01EndTake == true and self.Trig02EndTake == false) or (self.Trig01EndTake == false and self.Trig02EndTake == true) then
            BehaviorFunctions.ChangeSubTipsDesc(1, self.tips, 1, 2) -- 当其中一个为 true，另一个为 false 时  
        elseif self.Trig01EndTake == true and self.Trig02EndTake == true then
            BehaviorFunctions.ChangeSubTipsDesc(1, self.tips, 2, 2) -- 当两者都为 true 时  
        end
        --↑左侧提示--


        --判断关卡关卡是否结束
        if self.Trig01BeginTake == true and self.Trig02BeginTake == true and self.Trig0200Take == true then
            if self.levelwin == false then
                if self.ecoEntity ~= nil then
                    BehaviorFunctions.InteractEntityHit(self.ecoEntity,true)
                    BehaviorFunctions.AddDelayCallByTime(3,BehaviorFunctions,BehaviorFunctions.InteractEntityHit,self.ecoEntity,false)
                end
                BehaviorFunctions.ExitHackingMode()             --退出骇入模式
                
                BehaviorFunctions.ShowCommonTitle(5,'挑战胜利',true)
                BehaviorFunctions.HideTip(self.tips)
                self:RemoveFxTrigNil()
                do
                    BehaviorFunctions.AddDelayCallByTime(3,BehaviorFunctions,BehaviorFunctions.SetEntityHackEnable,self.Trig01Begin,false)
                    BehaviorFunctions.AddDelayCallByTime(3,BehaviorFunctions,BehaviorFunctions.SetEntityHackEnable,self.Trig01End,false)
                    BehaviorFunctions.AddDelayCallByTime(3,BehaviorFunctions,BehaviorFunctions.SetEntityHackEnable,self.Trig02Begin,false)
                    BehaviorFunctions.AddDelayCallByTime(3,BehaviorFunctions,BehaviorFunctions.SetEntityHackEnable,self.Trig0200,false)
                    BehaviorFunctions.AddDelayCallByTime(3,BehaviorFunctions,BehaviorFunctions.SetEntityHackEnable,self.Trig02End,false)
                end
                self.levelwin = true
                self.missionState = 999
            end
        end

    end
end

function LevelBehavior405020201:__delete()
end

-------------------------函数--------------------------------

--↓电路创建函数TrigPos，只需修改self.TrigPos中的值，便能自动更新self.TrigNil实体名称并创建真正的空实体。电路玩法必用↓--
--创建空实体函数，电路玩法必用↓--
function LevelBehavior405020201:CreateNilEntity()
    self.TrigNil = self.TrigNil or {}
    for index, posName in ipairs(self.TrigPos) do
        self.TrigNil[index] = BehaviorFunctions.CreateEntityByPosition(self.trigEntity, nil, posName, self.logicName, self.levelId, nil)
    end
end

--在指定位置创建实体
function LevelBehavior405020201:InPositionEntity(entityPropertyName, entityPrefab, positionIndex)
    if self[entityPropertyName] == nil then
        self[entityPropertyName] = BehaviorFunctions.CreateEntityByPosition(entityPrefab, nil, self.TrigPos[positionIndex], self.logicName, self.levelId, nil)
    end
    return self[entityPropertyName]
end

-- 创建或替换指定索引的特效
function LevelBehavior405020201:CreateAndStoreTriggers(fxhackDriveLineIndex, triggerStartIndex, triggerEndIndex, lineColorResource)
    if self.fxhackDriveLine[fxhackDriveLineIndex] ~= nil then
        BehaviorFunctions.ClientEffectRemoveRelation(self.fxhackDriveLine[fxhackDriveLineIndex])
        BehaviorFunctions.RemoveEntity(self.fxhackDriveLine[fxhackDriveLineIndex])
        self.fxhackDriveLine[fxhackDriveLineIndex] = nil
    end
    if self.fxhackDriveLine[fxhackDriveLineIndex] == nil then
        -- 创建新的特效
        self.fxhackDriveLine[fxhackDriveLineIndex] = BehaviorFunctions.CreateEntity(lineColorResource, self.TrigNil[triggerStartIndex], 0, 0, 0)
        BehaviorFunctions.ClientEffectRelation(self.fxhackDriveLine[fxhackDriveLineIndex], self.TrigNil[triggerStartIndex], "root", self.TrigNil[triggerEndIndex], "root", 0)
    end
end

-- 检查并移除实体
function LevelBehavior405020201:RemoveLineEntity(index)
    local entity = self.fxhackDriveLine[index]
    if entity ~= nil then
        BehaviorFunctions.RemoveEntity(entity)
        self.fxhackDriveLine[index] = nil  -- 将数组中对应的索引设置为 nil
    end
end

function LevelBehavior405020201:ToggleTrigColorState(trigBlue, trigGold)
    if self[trigGold] == true then
        -- 如果移除的是金色特效，则下次应该创建蓝色特效
        self[trigBlue] = true
        self[trigGold] = false
    elseif self[trigBlue] == true then
        -- 如果移除的是蓝色特效，则下次应该创建金色特效
        self[trigBlue] = false
        self[trigGold] = true
    end
end

-- 骇入物件黄蓝变色函数
function LevelBehavior405020201:HanrkSwitchBlue(index)
    if BehaviorFunctions.GetEntityHackEffectIsTask(index) == true then	--开关变黄色
        BehaviorFunctions.SetEntityHackEffectIsTask(index, true)
    else
        BehaviorFunctions.SetEntityHackEffectIsTask(index, false)
    end
end

--↑电路创建函数TrigPos，只需修改self.TrigPos中的值，便能自动更新self.TrigNil实体名称并创建真正的空实体。电路玩法必用↑--


--开场自定义功能函数
function LevelBehavior405020201:CustomLevelFunctions()
    --如果需要开场图文教学
    if self.imageTipId then
        BehaviorFunctions.ShowGuideImageTips(self.imageTipId)
    end
    --如果需要同步玩家位置
    if self.transPos then
        local rolePos = BehaviorFunctions.GetTerrainPositionP(self.posName.rolePos, 10020005, "Prologue02")
        BehaviorFunctions.InMapTransport(rolePos.x,rolePos.y,rolePos.z)
    end
end

--设置关卡相机函数
function LevelBehavior405020201:SetLevelCamera()
    self.empty = BehaviorFunctions.CreateEntity(2001, nil, self.currentWaveLookAtPos.x, self.currentWaveLookAtPos.y + 1, self.currentWaveLookAtPos.z, nil,nil,nil,self.levelId)
    self.levelCam = BehaviorFunctions.CreateEntity(22001)
    BehaviorFunctions.CameraEntityFollowTarget(self.levelCam,self.role,"CameraTarget")
    --看向目标
    BehaviorFunctions.CameraEntityLockTarget(self.levelCam,self.empty)
    BehaviorFunctions.DoLookAtTargetImmediately(self.role,self.empty)
    --延时移除目标和镜头
    BehaviorFunctions.AddDelayCallByFrame(45,BehaviorFunctions,BehaviorFunctions.RemoveEntity,self.levelCam)
    BehaviorFunctions.AddDelayCallByFrame(45,BehaviorFunctions,BehaviorFunctions.RemoveEntity,self.empty)
end

--关卡结束函数
function LevelBehavior405020201:LevelFinish()
    BehaviorFunctions.HideTip(self.tips)
    BehaviorFunctions.RemoveLevel(self.levelId)
end

function LevelBehavior405020201:RemoveFxTrigNil()
    BehaviorFunctions.RemoveEntity(self.fxhackDriveLine[12])
    BehaviorFunctions.RemoveEntity(self.fxhackDriveLine[23])
    BehaviorFunctions.RemoveEntity(self.fxhackDriveLine[34])
    BehaviorFunctions.RemoveEntity(self.fxhackDriveLine[45])
    BehaviorFunctions.RemoveEntity(self.fxhackDriveLine[67])
    BehaviorFunctions.RemoveEntity(self.fxhackDriveLine[78])
    BehaviorFunctions.RemoveEntity(self.fxhackDriveLine[97])

    BehaviorFunctions.RemoveEntity(self.TrigNil[1])
    BehaviorFunctions.RemoveEntity(self.TrigNil[2])
    BehaviorFunctions.RemoveEntity(self.TrigNil[3])
    BehaviorFunctions.RemoveEntity(self.TrigNil[4])
    BehaviorFunctions.RemoveEntity(self.TrigNil[5])
    BehaviorFunctions.RemoveEntity(self.TrigNil[6])
    BehaviorFunctions.RemoveEntity(self.TrigNil[7])
    BehaviorFunctions.RemoveEntity(self.TrigNil[8])
    BehaviorFunctions.RemoveEntity(self.TrigNil[9])
end

function LevelBehavior405020201:RemoveTrig()
    BehaviorFunctions.RemoveEntity(self.Trig01Begin)
    BehaviorFunctions.RemoveEntity(self.Trig01End)
    BehaviorFunctions.RemoveEntity(self.Trig02Begin)
    BehaviorFunctions.RemoveEntity(self.Trig0200)
    BehaviorFunctions.RemoveEntity(self.Trig02End)
end

---------------------回调----------------------------------
 
--死亡回调
function LevelBehavior405020201:Death(instanceId,isFormationRevive)
    for i, v in pairs(self.monsterList) do
        if instanceId == v.instanceId and v.isDead == false then
            self.deathCount = self.deathCount + 1
            v.isDead = true
            if self.deathCount == self.currentWaveNum then
                --该波怪物全死
                self.currentWaveAllDie = true
                --参数复原
                self.currentWaveNum = 0
                self.currentWaveLookAtPos = nil
                self.deathCount = 0
            end
        end
    end
end