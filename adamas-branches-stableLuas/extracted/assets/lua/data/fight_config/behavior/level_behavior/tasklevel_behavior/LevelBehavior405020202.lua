LevelBehavior405020202 = BaseClass("LevelBehavior405020202",LevelBehaviorBase)
--普通任务刷怪关
 
function LevelBehavior405020202:__init(fight)
    self.fight = fight
end

function LevelBehavior405020202.GetGenerates()
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

function LevelBehavior405020202:Init()
    self.missionState = 0
    self.role = nil
    self.missionUnloadDis = 25             --卸载距离
    self.playerPos = nil
    self.missionDistance = 0
    self.missionStartPos = nil
    self.levelwin = false                   --关卡胜利
    self.eco = 3003001080002
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
    self.Trig0103Take = false
    self.Trig01EndTake = false

    self.Trig03BeginTake = false
    self.Trig0300Take = false
    self.Trig03EndTake = false

    self.TrigPos = {             --电路位置点信息
        [1] = "Trig01Begin",
        [2] = "Trig0100",
        [3] = "Trig0101",
        [4] = "Trig0102",
        [5] = "Trig0103",
        [6] = "Trig0104",
        [7] = "Trig01End",
        [8] = "Trig0200",
        [9] = "Trig0201",
        [10] = "Trig03Begin",
        [11] = "Trig0300",
        [12] = "Trig0301",
        [13] = "Trig03End",
        [14] = "Trig0400",
        [15] = "Trig0202",
        [16] = "Trig0401",
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
        [10] = nil,
        [11] = nil,
        [12] = nil,
        [13] = nil,
        [14] = nil,
        [15] = nil,
        [16] = nil,
    }

    --预存电线特效名称
    self.fxhackDriveLine = {
        [12] = nil,
        [23] = nil,
        [34] = nil,
        [45] = nil,
        [56] = nil,
        [67] = nil,
        [58] = nil,
        [89] = nil,
        [1011] = nil,
        [1112] = nil,
        [1213] = nil,
        [1114] = nil,
        [915] = nil,
        [1416] = nil,
    }

    --电线变色预存
    self.Trig01_1_1Blue = true
    self.Trig01_1_1Gold = false
    self.Trig01_1_2Blue = true
    self.Trig01_1_2Gold = false
    self.Trig01_2_1Blue = true
    self.Trig01_2_1Gold = false
    self.Trig02_1_1Blue = true
    self.Trig02_1_1Gold = false
    self.Trig02_1_2Blue = true
    self.Trig02_1_2Gold = false
    self.Trig02_2_1Blue = true
    self.Trig02_2_1Gold = false

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
    self.Trig0103 = nil
    self.Trig0104 = nil
    self.Trig01End = nil
    self.Trig0200 = nil
    self.Trig02End = nil
    self.Trig03Begin = nil
    self.Trig0300 = nil
    self.Trig0301 = nil
    self.Trig03End = nil
    self.Trig04End = nil

    --移除电路节点预存
    self.RemoveLineEntityInit = false
    --↑电路位置点TrigPos，电路玩法必用↑---
end

function LevelBehavior405020202:Update()
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
        --线路1, 命名01＆02
        self.Trig01Begin = self:InPositionEntity('Trig01Begin',self.TrigBeginEntity, 1)     --线路1起点
        self.Trig0103 = self:InPositionEntity('Trig0103',self.TrigTurnEntity, 5)            --线路1节点
        self.Trig01End = self:InPositionEntity('Trig01End',self.TrigEndEntity, 7)           --线路1终点
        -- self.Trig02End = self:InPositionEntity('Trig02End',self.TrigEndEntity, 9)           --分支1终点

        --线路2，命名03＆分支04
        self.Trig03Begin = self:InPositionEntity('Trig03Begin',self.TrigBeginEntity, 10)     --线路2起点
        self.Trig0300 = self:InPositionEntity('Trig0300',self.TrigTurnEntity, 11)            --线路2节点
        self.Trig03End = self:InPositionEntity('Trig03End',self.TrigEndEntity, 13)           --线路2终点
        -- self.Trig04End = self:InPositionEntity('Trig04End',self.TrigEndEntity, 14)           --分支2终点
        --创建电路开关↑       

        do  --临时，重置玩家位置
            -- local palypos = BehaviorFunctions.GetTerrainPositionP("Player", self.levelId)
            -- BehaviorFunctions.InMapTransport(palypos.x, palypos.y, palypos.z)

            do
                local levelCam = BehaviorFunctions.CreateEntity(22007)
                BehaviorFunctions.CameraEntityFollowTarget(levelCam,self.role,"CameraTarget")
                BehaviorFunctions.CameraEntityLockTarget(levelCam,self.TrigNil[7])
                BehaviorFunctions.DoLookAtTargetImmediately(self.role,self.TrigNil[7])
                BehaviorFunctions.AddDelayCallByFrame(45,BehaviorFunctions,BehaviorFunctions.RemoveEntity,levelCam)
            end
        end

        BehaviorFunctions.ShowTip(self.tips)
        BehaviorFunctions.ChangeSubTipsDesc(1, self.tips, self.tipstack, self.tipsSum)

        --教学
        if BehaviorFunctions.CheckTeachIsFinish(self.teach) == false then
            BehaviorFunctions.AddDelayCallByTime(1.5,BehaviorFunctions,BehaviorFunctions.ShowGuideImageTips,self.teach)
            -- BehaviorFunctions.ShowGuideImageTips(self.teach)
        end

        self.missionState = 1
	end

    if self.missionState == 1 then

        --↓获取当前开关的状态，电路玩法必用↓--
        --Trig01Begin--1线路起点--
        if self.Trig01Begin then
            if BehaviorFunctions.GetEntityValue(self.Trig01Begin,"wire") then
                self.Trig01BeginTake = true
            else
                self.Trig01BeginTake = false
            end
        end
        --Trig0103--1线路节点--
        if self.Trig0103 then
            if BehaviorFunctions.GetEntityValue(self.Trig0103,"wire") then
                self.Trig0103Take = true
            else
                self.Trig0103Take = false
            end
        end

        --Trig03Begin--2线路起点--
        if self.Trig03Begin then
            if BehaviorFunctions.GetEntityValue(self.Trig03Begin,"wire") then
                self.Trig03BeginTake = true
            else
                self.Trig03BeginTake = false
            end
        end
        --Trig0300--2线路节点--
        if self.Trig0300 then
            if BehaviorFunctions.GetEntityValue(self.Trig0300,"wire") then
                self.Trig0300Take = true
            else
                self.Trig0300Take = false
            end
        end
        --↑获取当前开关的状态，电路玩法必用↑--

        --↓在空实体之间创建电路链接特效，电路玩法必用↓--
        if BehaviorFunctions.GetEntityState(self.role) == FightEnum.EntityState.Hack then   --在骇入模式创建连线特效
            self.RemoveLineEntityInit = false
            if self.RemoveLineTack == false then
                self.RemoveLineTack = true
            end
            --↓ 线路1创建↓--
            if self.Trig01BeginTake == false then
                if self.Trig0103Take == false then
                    self:HanrkSwitchBlue(self.Trig01End)            --控制终点1颜色，蓝色
                    self.Trig01EndTake = false
                    -- self:HanrkSwitchBlue(self.Trig02End)            --控制终点2颜色，蓝色
                    --线路1-1-1
                    if  self.Trig01_1_1Blue == true and self.Trig01_1_1Gold == false then
                        self:CreateAndStoreTriggers(12,1,2,self.HanrklineBlue)
                        self:CreateAndStoreTriggers(23,2,3,self.HanrklineBlue)
                        self:CreateAndStoreTriggers(34,3,4,self.HanrklineBlue)
                        self:CreateAndStoreTriggers(45,4,5,self.HanrklineBlue)
                        self.Trig01_1_1Blue = false
                        self.Trig01_1_1Gold = true
                    end
                    --线路1-1-2
                    if  self.Trig01_1_2Blue == true and self.Trig01_1_2Gold == false then
                        self:CreateAndStoreTriggers(56,5,6,self.HanrklineBlue)
                        self:CreateAndStoreTriggers(67,6,7,self.HanrklineBlue)
                        self.Trig01_1_2Blue = false
                        self.Trig01_1_2Gold = true
                    end
                    --线路1-2-1
                    if  self.Trig01_2_1Blue == true and self.Trig01_2_1Gold == false then
                        self:CreateAndStoreTriggers(58,5,8,self.HanrklineBlue)
                        self:CreateAndStoreTriggers(89,8,9,self.HanrklineBlue)
                        self:CreateAndStoreTriggers(915,9,15,self.HanrklineBlue)
                        self.Trig01_2_1Blue = false
                        self.Trig01_2_1Gold = true
                    end
                elseif self.Trig0103Take == true then
                    self:HanrkSwitchBlue(self.Trig01End)            --控制终点1颜色，蓝色
                    self.Trig01EndTake = false
                    -- self:HanrkSwitchBlue(self.Trig02End)            --控制终点2颜色，蓝色
                    --线路1-1-1
                    if  self.Trig01_1_1Blue == true and self.Trig01_1_1Gold == false then
                        self:CreateAndStoreTriggers(12,1,2,self.HanrklineBlue)
                        self:CreateAndStoreTriggers(23,2,3,self.HanrklineBlue)
                        self:CreateAndStoreTriggers(34,3,4,self.HanrklineBlue)
                        self:CreateAndStoreTriggers(45,4,5,self.HanrklineBlue)
                        self.Trig01_1_1Blue = false
                        self.Trig01_1_1Gold = true
                    end
                    --线路1-1-2
                    if  self.Trig01_1_2Blue == true and self.Trig01_1_2Gold == false then
                        self:CreateAndStoreTriggers(56,5,6,self.HanrklineBlue)
                        self:CreateAndStoreTriggers(67,6,7,self.HanrklineBlue)
                        self.Trig01_1_2Blue = false
                        self.Trig01_1_2Gold = true
                    end
                    --线路1-2-1
                    if  self.Trig01_2_1Blue == true and self.Trig01_2_1Gold == false then
                        self:CreateAndStoreTriggers(58,5,8,self.HanrklineBlue)
                        self:CreateAndStoreTriggers(89,8,9,self.HanrklineBlue)
                        self:CreateAndStoreTriggers(915,9,15,self.HanrklineBlue)
                        self.Trig01_2_1Blue = false
                        self.Trig01_2_1Gold = true
                    end
                end
            elseif self.Trig01BeginTake == true then
                if self.Trig0103Take == true then
                    BehaviorFunctions.SetEntityHackEffectIsTask(self.Trig01End, true)   --控制终点1颜色，黄色
                    self.Trig01EndTake = true
                    -- self:HanrkSwitchBlue(self.Trig02End)            --控制终点2颜色，蓝色
                    
                    --线路1-1-1
                    if  self.Trig01_1_1Blue == false and self.Trig01_1_1Gold == true then
                        self:CreateAndStoreTriggers(12,1,2,self.HanrklineGold)
                        self:CreateAndStoreTriggers(23,2,3,self.HanrklineGold)
                        self:CreateAndStoreTriggers(34,3,4,self.HanrklineGold)
                        self:CreateAndStoreTriggers(45,4,5,self.HanrklineGold)
                        self.Trig01_1_1Blue = true
                        self.Trig01_1_1Gold = false
                    end
                    --线路1-1-2
                    if  self.Trig01_1_2Blue == false and self.Trig01_1_2Gold == true then
                        self:CreateAndStoreTriggers(56,5,6,self.HanrklineGold)
                        self:CreateAndStoreTriggers(67,6,7,self.HanrklineGold)
                        self.Trig01_1_2Blue = true
                        self.Trig01_1_2Gold = false
                    end
                    --线路1-2-1
                    if  self.Trig01_2_1Blue == true and self.Trig01_2_1Gold == false then
                        self:CreateAndStoreTriggers(58,5,8,self.HanrklineBlue)
                        self:CreateAndStoreTriggers(89,8,9,self.HanrklineBlue)
                        self:CreateAndStoreTriggers(915,9,15,self.HanrklineBlue)
                        self.Trig01_2_1Blue = false
                        self.Trig01_2_1Gold = true
                    end

                elseif self.Trig0103Take == false then
                    self:HanrkSwitchBlue(self.Trig01End)            --控制终点1颜色，蓝色
                    self.Trig01EndTake = false
                    -- BehaviorFunctions.SetEntityHackEffectIsTask(self.Trig02End, true)   --控制终点2颜色，黄色

                    --线路1-1-1
                    if  self.Trig01_1_1Blue == false and self.Trig01_1_1Gold == true then
                        self:CreateAndStoreTriggers(12,1,2,self.HanrklineGold)
                        self:CreateAndStoreTriggers(23,2,3,self.HanrklineGold)
                        self:CreateAndStoreTriggers(34,3,4,self.HanrklineGold)
                        self:CreateAndStoreTriggers(45,4,5,self.HanrklineGold)
                        self.Trig01_1_1Blue = true
                        self.Trig01_1_1Gold = false
                    end
                    --线路1-1-2
                    if  self.Trig01_1_2Blue == true and self.Trig01_1_2Gold == false then
                        self:CreateAndStoreTriggers(56,5,6,self.HanrklineBlue)
                        self:CreateAndStoreTriggers(67,6,7,self.HanrklineBlue)
                        self.Trig01_1_2Blue = false
                        self.Trig01_1_2Gold = true
                    end
                    --线路1-2-1
                    if  self.Trig01_2_1Blue == false and self.Trig01_2_1Gold == true then
                        self:CreateAndStoreTriggers(58,5,8,self.HanrklineGold)
                        self:CreateAndStoreTriggers(89,8,9,self.HanrklineGold)
                        self:CreateAndStoreTriggers(915,9,15,self.HanrklineGold)
                        self.Trig01_2_1Blue = true
                        self.Trig01_2_1Gold = false
                    end

                end
            end

            if self.Trig0103Take == false then
                if self.Trig01BeginTake == false then
                    self:HanrkSwitchBlue(self.Trig01End)            --控制终点1颜色，蓝色
                    self.Trig01EndTake = false
                    -- self:HanrkSwitchBlue(self.Trig02End)            --控制终点2颜色，蓝色
                    --线路1-1-1
                    if  self.Trig01_1_1Blue == true and self.Trig01_1_1Gold == false then
                        self:CreateAndStoreTriggers(12,1,2,self.HanrklineBlue)
                        self:CreateAndStoreTriggers(23,2,3,self.HanrklineBlue)
                        self:CreateAndStoreTriggers(34,3,4,self.HanrklineBlue)
                        self:CreateAndStoreTriggers(45,4,5,self.HanrklineBlue)
                        self.Trig01_1_1Blue = false
                        self.Trig01_1_1Gold = true
                    end
                    --线路1-1-2
                    if  self.Trig01_1_2Blue == true and self.Trig01_1_2Gold == false then
                        self:CreateAndStoreTriggers(56,5,6,self.HanrklineBlue)
                        self:CreateAndStoreTriggers(67,6,7,self.HanrklineBlue)
                        self.Trig01_1_2Blue = false
                        self.Trig01_1_2Gold = true
                    end
                    --线路1-2-1
                    if  self.Trig01_2_1Blue == true and self.Trig01_2_1Gold == false then
                        self:CreateAndStoreTriggers(58,5,8,self.HanrklineBlue)
                        self:CreateAndStoreTriggers(89,8,9,self.HanrklineBlue)
                        self:CreateAndStoreTriggers(915,9,15,self.HanrklineBlue)
                        self.Trig01_2_1Blue = false
                        self.Trig01_2_1Gold = true
                    end
                elseif self.Trig01BeginTake == true then
                    self:HanrkSwitchBlue(self.Trig01End)            --控制终点1颜色，蓝色
                    self.Trig01EndTake = false
                    -- BehaviorFunctions.SetEntityHackEffectIsTask(self.Trig02End, true)   --控制终点2颜色，黄色
                    --线路1-1-1
                    if  self.Trig01_1_1Blue == false and self.Trig01_1_1Gold == true then
                        self:CreateAndStoreTriggers(12,1,2,self.HanrklineGold)
                        self:CreateAndStoreTriggers(23,2,3,self.HanrklineGold)
                        self:CreateAndStoreTriggers(34,3,4,self.HanrklineGold)
                        self:CreateAndStoreTriggers(45,4,5,self.HanrklineGold)
                        self.Trig01_1_1Blue = true
                        self.Trig01_1_1Gold = false
                    end
                    --线路1-1-2
                    if  self.Trig01_1_2Blue == true and self.Trig01_1_2Gold == false then
                        self:CreateAndStoreTriggers(56,5,6,self.HanrklineBlue)
                        self:CreateAndStoreTriggers(67,6,7,self.HanrklineBlue)
                        self.Trig01_1_2Blue = false
                        self.Trig01_1_2Gold = true
                    end
                    --线路1-2-1
                    if  self.Trig01_2_1Blue == false and self.Trig01_2_1Gold == true then
                        self:CreateAndStoreTriggers(58,5,8,self.HanrklineGold)
                        self:CreateAndStoreTriggers(89,8,9,self.HanrklineGold)
                        self:CreateAndStoreTriggers(915,9,15,self.HanrklineGold)
                        self.Trig01_2_1Blue = true
                        self.Trig01_2_1Gold = false
                    end
                end
            elseif self.Trig0103Take == true then
                if self.Trig01BeginTake == true then
                    BehaviorFunctions.SetEntityHackEffectIsTask(self.Trig01End, true)   --控制终点1颜色，黄色
                    self.Trig01EndTake = true
                    -- self:HanrkSwitchBlue(self.Trig02End)            --控制终点2颜色，蓝色

                    --线路1-1-1
                    if  self.Trig01_1_1Blue == false and self.Trig01_1_1Gold == true then
                        self:CreateAndStoreTriggers(12,1,2,self.HanrklineGold)
                        self:CreateAndStoreTriggers(23,2,3,self.HanrklineGold)
                        self:CreateAndStoreTriggers(34,3,4,self.HanrklineGold)
                        self:CreateAndStoreTriggers(45,4,5,self.HanrklineGold)
                        self.Trig01_1_1Blue = true
                        self.Trig01_1_1Gold = false
                    end
                    --线路1-1-2
                    if  self.Trig01_1_2Blue == false and self.Trig01_1_2Gold == true then
                        self:CreateAndStoreTriggers(56,5,6,self.HanrklineGold)
                        self:CreateAndStoreTriggers(67,6,7,self.HanrklineGold)
                        self.Trig01_1_2Blue = true
                        self.Trig01_1_2Gold = false
                    end
                    --线路1-2-1
                    if  self.Trig01_2_1Blue == true and self.Trig01_2_1Gold == false then
                        self:CreateAndStoreTriggers(58,5,8,self.HanrklineBlue)
                        self:CreateAndStoreTriggers(89,8,9,self.HanrklineBlue)
                        self:CreateAndStoreTriggers(915,9,15,self.HanrklineBlue)
                        self.Trig01_2_1Blue = false
                        self.Trig01_2_1Gold = true
                    end

                elseif self.Trig01BeginTake == false then
                    self:HanrkSwitchBlue(self.Trig01End)            --控制终点1颜色，蓝色
                    self.Trig01EndTake = false
                    -- self:HanrkSwitchBlue(self.Trig02End)            --控制终点2颜色，蓝色

                    --线路1-1-1
                    if  self.Trig01_1_1Blue == true and self.Trig01_1_1Gold == false then
                        self:CreateAndStoreTriggers(12,1,2,self.HanrklineBlue)
                        self:CreateAndStoreTriggers(23,2,3,self.HanrklineBlue)
                        self:CreateAndStoreTriggers(34,3,4,self.HanrklineBlue)
                        self:CreateAndStoreTriggers(45,4,5,self.HanrklineBlue)
                        self.Trig01_1_1Blue = false
                        self.Trig01_1_1Gold = true
                    end
                    --线路1-1-2
                    if  self.Trig01_1_2Blue == true and self.Trig01_1_2Gold == false then
                        self:CreateAndStoreTriggers(56,5,6,self.HanrklineBlue)
                        self:CreateAndStoreTriggers(67,6,7,self.HanrklineBlue)
                        self.Trig01_1_2Blue = false
                        self.Trig01_1_2Gold = true
                    end
                    --线路1-2-1
                    if  self.Trig01_2_1Blue == true and self.Trig01_2_1Gold == false then
                        self:CreateAndStoreTriggers(58,5,8,self.HanrklineBlue)
                        self:CreateAndStoreTriggers(89,8,9,self.HanrklineBlue)
                        self:CreateAndStoreTriggers(915,9,15,self.HanrklineBlue)
                        self.Trig01_2_1Blue = false
                        self.Trig01_2_1Gold = true
                    end

                end
            end
            --↑ 线路1创建 ↑--

            --↓ 线路2创建↓--
            if self.Trig03BeginTake == false then
                if self.Trig0300Take == false then
                    self:HanrkSwitchBlue(self.Trig03End)            --控制终点3颜色，蓝色
                    self.Trig03EndTake = false
                    -- self:HanrkSwitchBlue(self.Trig04End)            --控制终点4颜色，蓝色

                    --线路2-1-1
                    if  self.Trig02_1_1Blue == true and self.Trig02_1_1Gold == false then
                        self:CreateAndStoreTriggers(1011,10,11,self.HanrklineBlue)
                        self.Trig02_1_1Blue = false
                        self.Trig02_1_1Gold = true
                    end
                    --线路2-1-2
                    if  self.Trig02_1_2Blue == true and self.Trig02_1_2Gold == false then
                        self:CreateAndStoreTriggers(1112,11,12,self.HanrklineBlue)
                        self:CreateAndStoreTriggers(1213,12,13,self.HanrklineBlue)
                        self.Trig02_1_2Blue = false
                        self.Trig02_1_2Gold = true
                    end
                    --线路2-2-1
                    if  self.Trig02_2_1Blue == true and self.Trig02_2_1Gold == false then
                        self:CreateAndStoreTriggers(1114,14,11,self.HanrklineBlue)
                        self:CreateAndStoreTriggers(1416,16,14,self.HanrklineBlue)
                        self.Trig02_2_1Blue = false
                        self.Trig02_2_1Gold = true
                    end

                elseif self.Trig0300Take == true then
                    self:HanrkSwitchBlue(self.Trig03End)            --控制终点3颜色，蓝色
                    self.Trig03EndTake = false
                    -- self:HanrkSwitchBlue(self.Trig04End)            --控制终点4颜色，蓝色

                    --线路2-1-1
                    if  self.Trig02_1_1Blue == true and self.Trig02_1_1Gold == false then
                        self:CreateAndStoreTriggers(1011,10,11,self.HanrklineBlue)
                        self.Trig02_1_1Blue = false
                        self.Trig02_1_1Gold = true
                    end
                    --线路2-1-2
                    if  self.Trig02_1_2Blue == true and self.Trig02_1_2Gold == false then
                        self:CreateAndStoreTriggers(1112,11,12,self.HanrklineBlue)
                        self:CreateAndStoreTriggers(1213,12,13,self.HanrklineBlue)
                        self.Trig02_1_2Blue = false
                        self.Trig02_1_2Gold = true
                    end
                    --线路2-2-1
                    if  self.Trig02_2_1Blue == true and self.Trig02_2_1Gold == false then
                        self:CreateAndStoreTriggers(1114,14,11,self.HanrklineBlue)
                        self:CreateAndStoreTriggers(1416,16,14,self.HanrklineBlue)
                        self.Trig02_2_1Blue = false
                        self.Trig02_2_1Gold = true
                    end

                end
            elseif self.Trig03BeginTake == true then
                if self.Trig0300Take == true then
                    BehaviorFunctions.SetEntityHackEffectIsTask(self.Trig03End, true)   --控制终点3颜色，黄色
                    self.Trig03EndTake = true
                    -- self:HanrkSwitchBlue(self.Trig04End)            --控制终点4颜色，蓝色

                    --线路2-1-1
                    if  self.Trig02_1_1Blue == false and self.Trig02_1_1Gold == true then
                        self:CreateAndStoreTriggers(1011,10,11,self.HanrklineGold)
                        self.Trig02_1_1Blue = true
                        self.Trig02_1_1Gold = false
                    end
                    --线路2-1-2
                    if  self.Trig02_1_2Blue == false and self.Trig02_1_2Gold == true then
                        self:CreateAndStoreTriggers(1112,11,12,self.HanrklineGold)
                        self:CreateAndStoreTriggers(1213,12,13,self.HanrklineGold)
                        self.Trig02_1_2Blue = true
                        self.Trig02_1_2Gold = false
                    end
                    --线路2-2-1
                    if  self.Trig02_2_1Blue == true and self.Trig02_2_1Gold == false then
                        self:CreateAndStoreTriggers(1114,14,11,self.HanrklineBlue)
                        self:CreateAndStoreTriggers(1416,16,14,self.HanrklineBlue)
                        self.Trig02_2_1Blue = false
                        self.Trig02_2_1Gold = true
                    end

                elseif self.Trig0300Take == false then
                    self:HanrkSwitchBlue(self.Trig03End)            --控制终点3颜色，蓝色
                    self.Trig03EndTake = false
                    -- BehaviorFunctions.SetEntityHackEffectIsTask(self.Trig04End, true)   --控制终点4颜色，黄色

                    --线路2-1-1
                    if  self.Trig02_1_1Blue == false and self.Trig02_1_1Gold == true then
                        self:CreateAndStoreTriggers(1011,10,11,self.HanrklineGold)
                        self.Trig02_1_1Blue = true
                        self.Trig02_1_1Gold = false
                    end
                    --线路2-1-2
                    if  self.Trig02_1_2Blue == true and self.Trig02_1_2Gold == false then
                        self:CreateAndStoreTriggers(1112,11,12,self.HanrklineBlue)
                        self:CreateAndStoreTriggers(1213,12,13,self.HanrklineBlue)
                        self.Trig02_1_2Blue = false
                        self.Trig02_1_2Gold = true
                    end
                    --线路2-2-1
                    if  self.Trig02_2_1Blue == false and self.Trig02_2_1Gold == true then
                        self:CreateAndStoreTriggers(1114,14,11,self.HanrklineGold)
                        self:CreateAndStoreTriggers(1416,16,14,self.HanrklineGold)
                        self.Trig02_2_1Blue = true
                        self.Trig02_2_1Gold = false
                    end
                    
                end
            end

            if self.Trig0300Take == false then
                if self.Trig03BeginTake == false then
                    self:HanrkSwitchBlue(self.Trig03End)            --控制终点3颜色，蓝色
                    self.Trig03EndTake = false
                    -- self:HanrkSwitchBlue(self.Trig04End)            --控制终点4颜色，蓝色

                    --线路2-1-1
                    if  self.Trig02_1_1Blue == true and self.Trig02_1_1Gold == false then
                        self:CreateAndStoreTriggers(1011,10,11,self.HanrklineBlue)
                        self.Trig02_1_1Blue = false
                        self.Trig02_1_1Gold = true
                    end
                    --线路2-1-2
                    if  self.Trig02_1_2Blue == true and self.Trig02_1_2Gold == false then
                        self:CreateAndStoreTriggers(1112,11,12,self.HanrklineBlue)
                        self:CreateAndStoreTriggers(1213,12,13,self.HanrklineBlue)
                        self.Trig02_1_2Blue = false
                        self.Trig02_1_2Gold = true
                    end
                    --线路2-2-1
                    if  self.Trig02_2_1Blue == true and self.Trig02_2_1Gold == false then
                        self:CreateAndStoreTriggers(1114,14,11,self.HanrklineBlue)
                        self:CreateAndStoreTriggers(1416,16,14,self.HanrklineBlue)
                        self.Trig02_2_1Blue = false
                        self.Trig02_2_1Gold = true
                    end

                elseif self.Trig03BeginTake == true then
                    self:HanrkSwitchBlue(self.Trig03End)            --控制终点3颜色，蓝色
                    self.Trig03EndTake = false
                    -- BehaviorFunctions.SetEntityHackEffectIsTask(self.Trig04End, true)   --控制终点4颜色，黄色
                    --线路2-1-1
                    if  self.Trig02_1_1Blue == false and self.Trig02_1_1Gold == true then
                        self:CreateAndStoreTriggers(1011,10,11,self.HanrklineGold)
                        self.Trig02_1_1Blue = true
                        self.Trig02_1_1Gold = false
                    end
                    --线路2-1-2
                    if  self.Trig02_1_2Blue == true and self.Trig02_1_2Gold == false then
                        self:CreateAndStoreTriggers(1112,11,12,self.HanrklineBlue)
                        self:CreateAndStoreTriggers(1213,12,13,self.HanrklineBlue)
                        self.Trig02_1_2Blue = false
                        self.Trig02_1_2Gold = true
                    end
                    --线路2-2-1
                    if  self.Trig02_2_1Blue == false and self.Trig02_2_1Gold == true then
                        self:CreateAndStoreTriggers(1114,14,11,self.HanrklineGold)
                        self:CreateAndStoreTriggers(1416,16,14,self.HanrklineGold)
                        self.Trig02_2_1Blue = true
                        self.Trig02_2_1Gold = false
                    end

                end
            elseif self.Trig0300Take == true then
                if self.Trig03BeginTake == true then
                    BehaviorFunctions.SetEntityHackEffectIsTask(self.Trig03End, true)   --控制终点3颜色，黄色
                    self.Trig03EndTake = true
                    -- self:HanrkSwitchBlue(self.Trig04End)            --控制终点4颜色，蓝色

                    --线路2-1-1
                    if  self.Trig02_1_1Blue == false and self.Trig02_1_1Gold == true then
                        self:CreateAndStoreTriggers(1011,10,11,self.HanrklineGold)
                        self.Trig02_1_1Blue = true
                        self.Trig02_1_1Gold = false
                    end
                    --线路2-1-2
                    if  self.Trig02_1_2Blue == false and self.Trig02_1_2Gold == true then
                        self:CreateAndStoreTriggers(1112,11,12,self.HanrklineGold)
                        self:CreateAndStoreTriggers(1213,12,13,self.HanrklineGold)
                        self.Trig02_1_2Blue = true
                        self.Trig02_1_2Gold = false
                    end
                    --线路2-2-1
                    if  self.Trig02_2_1Blue == true and self.Trig02_2_1Gold == false then
                        self:CreateAndStoreTriggers(1114,14,11,self.HanrklineBlue)
                        self:CreateAndStoreTriggers(1416,16,14,self.HanrklineBlue)
                        self.Trig02_2_1Blue = false
                        self.Trig02_2_1Gold = true
                    end

                elseif self.Trig03BeginTake == false then
                    self:HanrkSwitchBlue(self.Trig03End)            --控制终点3颜色，蓝色
                    self.Trig03EndTake = false
                    -- self:HanrkSwitchBlue(self.Trig04End)            --控制终点4颜色，蓝色

                    --线路2-1-1
                    if  self.Trig02_1_1Blue == true and self.Trig02_1_1Gold == false then
                        self:CreateAndStoreTriggers(1011,10,11,self.HanrklineBlue)
                        self.Trig02_1_1Blue = false
                        self.Trig02_1_1Gold = true
                    end
                    --线路2-1-2
                    if  self.Trig02_1_2Blue == true and self.Trig02_1_2Gold == false then
                        self:CreateAndStoreTriggers(1112,11,12,self.HanrklineBlue)
                        self:CreateAndStoreTriggers(1213,12,13,self.HanrklineBlue)
                        self.Trig02_1_2Blue = false
                        self.Trig02_1_2Gold = true
                    end
                    --线路2-2-1
                    if  self.Trig02_2_1Blue == true and self.Trig02_2_1Gold == false then
                        self:CreateAndStoreTriggers(1114,14,11,self.HanrklineBlue)
                        self:CreateAndStoreTriggers(1416,16,14,self.HanrklineBlue)
                        self.Trig02_2_1Blue = false
                        self.Trig02_2_1Gold = true
                    end

                end
            end
            --↑ 线路2创建 ↑--

        elseif BehaviorFunctions.GetEntityState(self.role) ~= FightEnum.EntityState.Hack then
			if self.RemoveLineEntityInit == false then
                --在退出骇入模式移除连线特效
                --检查并移除实体，传递索引而不是实体对象
                if self.RemoveLineTack == true then
                    self:ToggleTrigColorState('Trig01_1_1Gold','Trig01_1_1Blue')
                    self:ToggleTrigColorState('Trig01_1_2Gold','Trig01_1_2Blue')
                    self:ToggleTrigColorState('Trig01_2_1Gold','Trig01_2_1Blue')
                    self:ToggleTrigColorState('Trig02_1_1Gold','Trig02_1_1Blue')
                    self:ToggleTrigColorState('Trig02_1_2Gold','Trig02_1_2Blue')
                    self:ToggleTrigColorState('Trig02_2_1Gold','Trig02_2_1Blue')

                    self:RemoveLineEntity(12)
                    self:RemoveLineEntity(23)
                    self:RemoveLineEntity(34)
                    self:RemoveLineEntity(45)
                    self:RemoveLineEntity(56)
                    self:RemoveLineEntity(67)
                    self:RemoveLineEntity(58)
                    self:RemoveLineEntity(89)
                    self:RemoveLineEntity(1011)
                    self:RemoveLineEntity(1112)
                    self:RemoveLineEntity(1213)
                    self:RemoveLineEntity(1114)
                    self:RemoveLineEntity(915)
                    self:RemoveLineEntity(1416)
                    self.RemoveLineEntityInit = true
                    self.RemoveLineTack = false
                end
			end
        end
       --↑在空实体之间创建电路链接特效↑--

        --↓左侧提示--
        if self.Trig01EndTake == false and self.Trig03EndTake == false then
            BehaviorFunctions.ChangeSubTipsDesc(1, self.tips, 0, 2) -- 当两者都为 false 时  
        elseif (self.Trig01EndTake == true and self.Trig03EndTake == false) or (self.Trig01EndTake == false and self.Trig03EndTake == true) then
            BehaviorFunctions.ChangeSubTipsDesc(1, self.tips, 1, 2) -- 当其中一个为 true，另一个为 false 时  
        elseif self.Trig01EndTake == true and self.Trig03EndTake == true then
            BehaviorFunctions.ChangeSubTipsDesc(1, self.tips, 2, 2) -- 当两者都为 true 时  
        end
        --↑左侧提示--

        --判断关卡关卡是否结束
        if self.Trig01BeginTake == true and self.Trig03BeginTake == true and self.Trig0103Take == true and self.Trig0300Take == true then
            if self.levelwin == false then
                if self.ecoEntity ~= nil then
                    BehaviorFunctions.InteractEntityHit(self.ecoEntity,true)
                    BehaviorFunctions.AddDelayCallByTime(3,BehaviorFunctions,BehaviorFunctions.InteractEntityHit,self.ecoEntity,false)
                end
                BehaviorFunctions.ExitHackingMode()             --退出骇入模式

                BehaviorFunctions.ShowCommonTitle(5,'挑战胜利',true)
                BehaviorFunctions.HideTip(102670102)
                self:RemoveFxTrigNil()
                do
                    BehaviorFunctions.AddDelayCallByTime(3,BehaviorFunctions,BehaviorFunctions.SetEntityHackEnable,self.Trig01Begin,false)
                    BehaviorFunctions.AddDelayCallByTime(3,BehaviorFunctions,BehaviorFunctions.SetEntityHackEnable,self.Trig0103,false)
                    BehaviorFunctions.AddDelayCallByTime(3,BehaviorFunctions,BehaviorFunctions.SetEntityHackEnable,self.Trig01End,false)
                    BehaviorFunctions.AddDelayCallByTime(3,BehaviorFunctions,BehaviorFunctions.SetEntityHackEnable,self.Trig03Begin,false)
                    BehaviorFunctions.AddDelayCallByTime(3,BehaviorFunctions,BehaviorFunctions.SetEntityHackEnable,self.Trig0300,false)
                    BehaviorFunctions.AddDelayCallByTime(3,BehaviorFunctions,BehaviorFunctions.SetEntityHackEnable,self.Trig03End,false)
                end
                self.levelwin = true
                self.missionState = 999
            end
        end
    end
end

function LevelBehavior405020202:__delete()
end

-------------------------函数--------------------------------

--↓电路创建函数TrigPos，只需修改self.TrigPos中的值，便能自动更新self.TrigNil实体名称并创建真正的空实体。电路玩法必用↓--
--创建空实体函数，电路玩法必用↓--
function LevelBehavior405020202:CreateNilEntity()
    self.TrigNil = self.TrigNil or {}
    for index, posName in ipairs(self.TrigPos) do
        self.TrigNil[index] = BehaviorFunctions.CreateEntityByPosition(self.trigEntity, nil, posName, self.logicName, self.levelId, nil)
    end
end

--在指定位置创建实体
function LevelBehavior405020202:InPositionEntity(entityPropertyName, entityPrefab, positionIndex)
    if self[entityPropertyName] == nil then
        self[entityPropertyName] = BehaviorFunctions.CreateEntityByPosition(entityPrefab, nil, self.TrigPos[positionIndex], self.logicName, self.levelId, nil)
    end
    return self[entityPropertyName]
end

-- 创建或替换指定索引的特效
function LevelBehavior405020202:CreateAndStoreTriggers(fxhackDriveLineIndex, triggerStartIndex, triggerEndIndex, lineColorResource)
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
function LevelBehavior405020202:RemoveLineEntity(index,trigGold,trigBlue)
    local entity = self.fxhackDriveLine[index]
    if entity ~= nil then
        BehaviorFunctions.RemoveEntity(entity)
        self.fxhackDriveLine[index] = nil  -- 将数组中对应的索引设置为 nil
    end
end

function LevelBehavior405020202:ToggleTrigColorState(trigBlue, trigGold)
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
function LevelBehavior405020202:HanrkSwitchBlue(index)
    if BehaviorFunctions.GetEntityHackEffectIsTask(index) == true then	--开关变黄色
        BehaviorFunctions.SetEntityHackEffectIsTask(index, true)
    else
        BehaviorFunctions.SetEntityHackEffectIsTask(index, false)
    end
end

--↑电路创建函数TrigPos，只需修改self.TrigPos中的值，便能自动更新self.TrigNil实体名称并创建真正的空实体。电路玩法必用↑--


--开场自定义功能函数
function LevelBehavior405020202:CustomLevelFunctions()
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
function LevelBehavior405020202:SetLevelCamera()
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
function LevelBehavior405020202:LevelFinish()
    BehaviorFunctions.HideTip(102670102)
    BehaviorFunctions.RemoveLevel(self.levelId)
end

function LevelBehavior405020202:RemoveFxTrigNil()
    BehaviorFunctions.RemoveEntity(self.fxhackDriveLine[12])
    BehaviorFunctions.RemoveEntity(self.fxhackDriveLine[23])
    BehaviorFunctions.RemoveEntity(self.fxhackDriveLine[34])
    BehaviorFunctions.RemoveEntity(self.fxhackDriveLine[45])
    BehaviorFunctions.RemoveEntity(self.fxhackDriveLine[56])
    BehaviorFunctions.RemoveEntity(self.fxhackDriveLine[67])
    BehaviorFunctions.RemoveEntity(self.fxhackDriveLine[58])
    BehaviorFunctions.RemoveEntity(self.fxhackDriveLine[89])
    BehaviorFunctions.RemoveEntity(self.fxhackDriveLine[1011])
    BehaviorFunctions.RemoveEntity(self.fxhackDriveLine[1112])
    BehaviorFunctions.RemoveEntity(self.fxhackDriveLine[1213])
    BehaviorFunctions.RemoveEntity(self.fxhackDriveLine[1114])
    BehaviorFunctions.RemoveEntity(self.fxhackDriveLine[915])
    BehaviorFunctions.RemoveEntity(self.fxhackDriveLine[1416])

    BehaviorFunctions.RemoveEntity(self.TrigNil[1])
    BehaviorFunctions.RemoveEntity(self.TrigNil[2])
    BehaviorFunctions.RemoveEntity(self.TrigNil[3])
    BehaviorFunctions.RemoveEntity(self.TrigNil[4])
    BehaviorFunctions.RemoveEntity(self.TrigNil[5])
    BehaviorFunctions.RemoveEntity(self.TrigNil[6])
    BehaviorFunctions.RemoveEntity(self.TrigNil[7])
    BehaviorFunctions.RemoveEntity(self.TrigNil[8])
    BehaviorFunctions.RemoveEntity(self.TrigNil[9])
    BehaviorFunctions.RemoveEntity(self.TrigNil[10])
    BehaviorFunctions.RemoveEntity(self.TrigNil[11])
    BehaviorFunctions.RemoveEntity(self.TrigNil[12])
    BehaviorFunctions.RemoveEntity(self.TrigNil[13])
    BehaviorFunctions.RemoveEntity(self.TrigNil[14])
    BehaviorFunctions.RemoveEntity(self.TrigNil[15])
    BehaviorFunctions.RemoveEntity(self.TrigNil[16])
end

function LevelBehavior405020202:RemoveTrig()
    BehaviorFunctions.RemoveEntity(self.Trig01Begin)
    BehaviorFunctions.RemoveEntity(self.Trig0103)
    BehaviorFunctions.RemoveEntity(self.Trig01End)
    BehaviorFunctions.RemoveEntity(self.Trig03Begin)
    BehaviorFunctions.RemoveEntity(self.Trig0300)
    BehaviorFunctions.RemoveEntity(self.Trig03End)
end

---------------------回调----------------------------------

--死亡回调
function LevelBehavior405020202:Death(instanceId,isFormationRevive)
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