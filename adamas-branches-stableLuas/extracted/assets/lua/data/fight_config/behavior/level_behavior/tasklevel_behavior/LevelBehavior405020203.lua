LevelBehavior405020203 = BaseClass("LevelBehavior405020203",LevelBehaviorBase)
--普通任务刷怪关

function LevelBehavior405020203:__init(fight)
    self.fight = fight
end

function LevelBehavior405020203.GetGenerates()
    local generates = {
        2041101,     --空实体
        2041104,     --开关实体
        2041105,     --节点实体
        2041106,      --终点
        2041102,      --蓝电线特效
        2041103         --黄电线特效
    }
    return generates
end

function LevelBehavior405020203:Init()
    self.missionState = 0
    self.role = nil
    self.missionUnloadDis = 25             --卸载距离
    self.playerPos = nil
    self.missionDistance = 0
    self.missionStartPos = nil
    self.levelwin = false                   --关卡胜利
    self.eco = 3003001080003
    self.ecoEntity = nil

    --↓电路位置点TrigPos，电路玩法必用↓---
    self.trigEntity = 2041101           --空实体,搜索名称Entity1005

    self.HanrklineBlue = 2041102         --电线特效蓝色
    self.HanrklineGold = 2041103         --电线特效黄色

    self.TrigBeginEntity = 2041104       --开关起点
    self.TrigTurnEntity = 2041105         --电路节点
    self.TrigEndEntity =   2041106       --电路终点

    --各个开关的状态
    self.Trig01BeginTake = false
    self.Trig0100Take = false
    self.Trig0103Take = false
    self.Trig01EndTake = false

    self.Trig02BeginTake = false
    self.Trig0204Take = false

    self.Trig04BeginTake = false
    self.Trig0400Take = false
    self.Trig04EndTake = false

    self.Trig05EndTake = false

    --各个电线的状态记录
    self.Line01 = false
    self.Line02 = false

    self.TrigPos = {             --电路位置点信息
        [1] = "Trig01Begin",
        [2] = "Trig0100",
        [3] = "Trig0101",
        [4] = "Trig01End",
        [5] = "Trig02Begin",
        [6] = "Trig0200",
        [7] = "Trig0201",
        [8] = "Trig0202",
        [9] = "Trig0203",
        [10] = "Trig0204",
        [11] = "Trig0205",
        [12] = "Trig0300",
        [13] = "Trig0301",
        [14] = "Trig04Begin",
        [15] = "Trig0400",
        [16] = "Trig0401",
        [17] = "Trig0402",
        [18] = "Trig04End",
        [19] = "Trig0500",
        [20] = "Trig05End",
        [21] = "Trig0103",
        [22] = "Trig06End",
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
        [17] = nil,
        [18] = nil,
        [19] = nil,
        [20] = nil,
        [21] = nil,
        [22] = nil,
    }

    --预存电线特效名称
    self.fxhackDriveLine = {
        [121] = nil,    --Trig01Begin Trig0103
        [212] = nil,    --Trig0103  Trig0100
        [23] = nil,
        [34] = nil,     --Trig0101 Trig01End
        [56] = nil,
        [67] = nil,
        [78] = nil,
        [89] = nil,
        [910] = nil,
        [1011] = nil,
        [112] = nil,
        [1012] = nil,
        [1213] = nil,
        -- [131] = nil,
        [1415] = nil,
        [1516] = nil,
        [1617] = nil,
        [1718] = nil,
        [1915] = nil,
        [2019] = nil,
        [2122] = nil,
    }

    --电线变色预存
    self.Trig01_1_1Blue = true      --[121]
    self.Trig01_1_1Gold = false     --[121]
    self.Trig01_1_2Blue = true      --[23][34]
    self.Trig01_1_2Gold = false      --[23][34]

    self.Trig01_1_3Blue = true      --[23][34]
    self.Trig01_1_3Gold = false      --[23][34]
    
    self.Trig01_1_4Blue = true
    self.Trig01_1_4Gold = false

    self.Trig01_2_1Blue = true      --[56][67][78][89][910]
    self.Trig01_2_1Gold = false      --[56][67][78][89][910]

    self.Trig01_2_2Blue = true      --[1011][112]
    self.Trig01_2_2Gold = false      --[1011][112]

    self.Trig01_2_3Blue = true
    self.Trig01_2_3Gold = false

    -- self.Trig01_3_1Blue = true      --[1012][1213][131]
    -- self.Trig01_3_1Gold = false      --[1012][1213][131]

    self.Trig02_1_1Blue = true      --[1415]
    self.Trig02_1_1Gold = false      --[1415]

    self.Trig02_1_2Blue = true      --[1516][1617][1718]
    self.Trig02_1_2Gold = false      --[1516][1617][1718]

    self.Trig02_2_1Blue = true      --[1915][2019]
    self.Trig02_2_1Gold = false      --[1915][2019]

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
    self.Trig01End = nil
    self.Trig02Begin = nil
    self.Trig0200 = nil
    self.Trig0201 = nil
    self.Trig0202 = nil
    self.Trig0203 = nil
    self.Trig0204 = nil
    self.Trig0205 = nil
    self.Trig0300 = nil
    self.Trig0301 = nil
    self.Trig04Begin = nil
    self.Trig0400 = nil
    self.Trig0401 = nil
    self.Trig0402 = nil
    self.Trig04End = nil
    self.Trig0500 = nil
    self.Trig05End = nil
    self.Trig0103 = nil
    self.Trig06End = nil

    --移除电路节点预存
    self.RemoveLineEntityInit = false

    --不可交互的位置点
    self.Trig01BeginBool = false
    self.Trig0100Bool = false

    --↑电路位置点TrigPos，电路玩法必用↑---
end

function LevelBehavior405020203:Update()
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
        self.Trig0103 = self:InPositionEntity('Trig0103',self.TrigTurnEntity, 21)     --线路1-1节点

        self.Trig0100 = self:InPositionEntity('Trig0100',self.TrigTurnEntity, 2)            --线路1-2节点
        self.Trig01End = self:InPositionEntity('Trig01End',self.TrigEndEntity, 4)           --线路1终点

        --线路2
        self.Trig02Begin = self:InPositionEntity('Trig02Begin',self.TrigBeginEntity, 5)     --线路2起点
        self.Trig0204 = self:InPositionEntity('Trig0204',self.TrigTurnEntity, 10)            --线路2节点

        --线路4_1，命名04
        self.Trig04Begin = self:InPositionEntity('Trig04Begin',self.TrigBeginEntity, 14)     --线路4起点
        self.Trig0400 = self:InPositionEntity('Trig0400',self.TrigTurnEntity, 15)            --线路4节点
        self.Trig04End = self:InPositionEntity('Trig04End',self.TrigEndEntity, 18)           --线路4终点

        --线路4_2，命名05
        self.Trig05End = self:InPositionEntity('Trig05End',self.TrigEndEntity, 20)           --线路5终点

        --创建电路开关↑       

        do  --临时，重置玩家位置
            -- local palypos = BehaviorFunctions.GetTerrainPositionP("Player", self.levelId)
            -- BehaviorFunctions.InMapTransport(palypos.x, palypos.y, palypos.z)

            do
                local levelCam = BehaviorFunctions.CreateEntity(22007)
                BehaviorFunctions.CameraEntityFollowTarget(levelCam,self.role,"CameraTarget")
                BehaviorFunctions.CameraEntityLockTarget(levelCam,self.TrigNil[14])
                BehaviorFunctions.DoLookAtTargetImmediately(self.role,self.TrigNil[14])
                BehaviorFunctions.AddDelayCallByFrame(45,BehaviorFunctions,BehaviorFunctions.RemoveEntity,levelCam)
            end
        end

        if self.Trig0100Bool == false then
            BehaviorFunctions.SetEntityHackEnable(self.Trig0100,false)
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

        --Trig02Begin--2线路起点--
        if self.Trig02Begin then
            if BehaviorFunctions.GetEntityValue(self.Trig02Begin,"wire") then
                self.Trig02BeginTake = true
            else
                self.Trig02BeginTake = false
            end
        end

        --Trig0204--2线路节点--
        if self.Trig0204 then
            if BehaviorFunctions.GetEntityValue(self.Trig0204,"wire") then
                self.Trig0204Take = true
            else
                self.Trig0204Take = false
            end
        end

        --Trig04Begin--4线路起点--
        if self.Trig04Begin then
            if BehaviorFunctions.GetEntityValue(self.Trig04Begin,"wire") then
                self.Trig04BeginTake = true
            else
                self.Trig04BeginTake = false
            end
        end

        --Trig0400--4线路节点--
        if self.Trig0400 then
            if BehaviorFunctions.GetEntityValue(self.Trig0400,"wire") then
                self.Trig0400Take = true
            else
                self.Trig0400Take = false
            end
        end

        --↑获取当前开关的状态，电路玩法必用↑--

        --↓在空实体之间创建电路链接特效，电路玩法必用↓--
        if BehaviorFunctions.GetEntityState(self.role) == FightEnum.EntityState.Hack then   --在骇入模式创建连线特效
            self.RemoveLineEntityInit = false
            if self.RemoveLineTack == false then
                self.RemoveLineTack = true
            end
            --↓ 线路2创建↓--线路2能激活线路1
            if self.Trig02BeginTake == false then
                if self.Trig0204Take == false then
                    self.Line02 = false                     --线路2未被创建
                    --路线02_1_1不创建
                    if  self.Trig01_2_2Blue == true and self.Trig01_2_2Gold == false then
                        self:CreateAndStoreTriggers(56,5,6,self.HanrklineBlue)
                        self:CreateAndStoreTriggers(67,6,7,self.HanrklineBlue)
                        self:CreateAndStoreTriggers(78,7,8,self.HanrklineBlue)
                        self:CreateAndStoreTriggers(89,8,9,self.HanrklineBlue)
                        self:CreateAndStoreTriggers(910,9,10,self.HanrklineBlue)
                        self.Trig01_2_2Blue = false
                        self.Trig01_2_2Gold = true
                    end
                    --路线02_1_2不创建
                    if  self.Trig01_2_1Blue == true and self.Trig01_2_1Gold == false then
                        self:CreateAndStoreTriggers(1011,10,11,self.HanrklineBlue)
                        self:CreateAndStoreTriggers(112,11,2,self.HanrklineBlue)
                        self.Trig01_2_1Blue = false
                        self.Trig01_2_1Gold = true
                    end
                    --路线02_1_3不创建
                    if  self.Trig01_2_3Blue == true and self.Trig01_2_3Gold == false then
                        self:CreateAndStoreTriggers(1012,10,12,self.HanrklineBlue)
                        self:CreateAndStoreTriggers(1213,12,13,self.HanrklineBlue)
                        self.Trig01_2_3Blue = false
                        self.Trig01_2_3Gold = true
                    end
                elseif self.Trig0204Take == true then
                    self.Line02 = false                     --线路2未被创建
                    --路线02_1_1不创建
                    if  self.Trig01_2_2Blue == true and self.Trig01_2_2Gold == false then
                        self:CreateAndStoreTriggers(56,5,6,self.HanrklineBlue)
                        self:CreateAndStoreTriggers(67,6,7,self.HanrklineBlue)
                        self:CreateAndStoreTriggers(78,7,8,self.HanrklineBlue)
                        self:CreateAndStoreTriggers(89,8,9,self.HanrklineBlue)
                        self:CreateAndStoreTriggers(910,9,10,self.HanrklineBlue)
                        self.Trig01_2_2Blue = false
                        self.Trig01_2_2Gold = true
                    end
                    --路线02_1_2不创建
                    if  self.Trig01_2_1Blue == true and self.Trig01_2_1Gold == false then
                        self:CreateAndStoreTriggers(1011,10,11,self.HanrklineBlue)
                        self:CreateAndStoreTriggers(112,11,2,self.HanrklineBlue)
                        self.Trig01_2_1Blue = false
                        self.Trig01_2_1Gold = true
                    end
                    --路线02_1_3不创建
                    if  self.Trig01_2_3Blue == true and self.Trig01_2_3Gold == false then
                        self:CreateAndStoreTriggers(1012,10,12,self.HanrklineBlue)
                        self:CreateAndStoreTriggers(1213,12,13,self.HanrklineBlue)
                        self.Trig01_2_3Blue = false
                        self.Trig01_2_3Gold = true
                    end
                end
            elseif self.Trig02BeginTake == true then
                if self.Trig0204Take == false then
                    self.Line02 = false                     --线路2未被创建
                    --路线02_1_1创建
                    if  self.Trig01_2_2Blue == false and self.Trig01_2_2Gold == true then
                        self:CreateAndStoreTriggers(56,5,6,self.HanrklineGold)
                        self:CreateAndStoreTriggers(67,6,7,self.HanrklineGold)
                        self:CreateAndStoreTriggers(78,7,8,self.HanrklineGold)
                        self:CreateAndStoreTriggers(89,8,9,self.HanrklineGold)
                        self:CreateAndStoreTriggers(910,9,10,self.HanrklineGold)
                        self.Trig01_2_2Blue = true
                        self.Trig01_2_2Gold = false
                    end
                    --路线02_1_2不创建
                    if  self.Trig01_2_1Blue == true and self.Trig01_2_1Gold == false then
                        self:CreateAndStoreTriggers(1011,10,11,self.HanrklineBlue)
                        self:CreateAndStoreTriggers(112,11,2,self.HanrklineBlue)
                        self.Trig01_2_1Blue = false
                        self.Trig01_2_1Gold = true
                    end
                    --路线02_1_3创建
                    if  self.Trig01_2_3Blue == false and self.Trig01_2_3Gold == true then
                        self:CreateAndStoreTriggers(1012,10,12,self.HanrklineGold)
                        self:CreateAndStoreTriggers(1213,12,13,self.HanrklineGold)
                        self.Trig01_2_3Blue = true
                        self.Trig01_2_3Gold = false
                    end
                elseif self.Trig0204Take == true then
                    self.Line02 = true                     --线路2被创建
                    --路线02_1_1创建
                    if  self.Trig01_2_2Blue == false and self.Trig01_2_2Gold == true then
                        self:CreateAndStoreTriggers(56,5,6,self.HanrklineGold)
                        self:CreateAndStoreTriggers(67,6,7,self.HanrklineGold)
                        self:CreateAndStoreTriggers(78,7,8,self.HanrklineGold)
                        self:CreateAndStoreTriggers(89,8,9,self.HanrklineGold)
                        self:CreateAndStoreTriggers(910,9,10,self.HanrklineGold)
                        self.Trig01_2_2Blue = true
                        self.Trig01_2_2Gold = false
                    end
                    --路线02_1_2创建
                    if  self.Trig01_2_1Blue == false and self.Trig01_2_1Gold == true then
                        self:CreateAndStoreTriggers(1011,10,11,self.HanrklineGold)
                        self:CreateAndStoreTriggers(112,11,2,self.HanrklineGold)
                        self.Trig01_2_1Blue = true
                        self.Trig01_2_1Gold = false
                    end
                    --路线02_1_3不创建
                    if  self.Trig01_2_3Blue == true and self.Trig01_2_3Gold == false then
                        self:CreateAndStoreTriggers(1012,10,12,self.HanrklineBlue)
                        self:CreateAndStoreTriggers(1213,12,13,self.HanrklineBlue)
                        self.Trig01_2_3Blue = false
                        self.Trig01_2_3Gold = true
                    end
                end
            end

            if self.Trig0204Take == false then
                if self.Trig02BeginTake == false then
                    self.Line02 = false                     --线路2未被创建
                    --路线02_1_1不创建
                    if  self.Trig01_2_2Blue == true and self.Trig01_2_2Gold == false then
                        self:CreateAndStoreTriggers(56,5,6,self.HanrklineBlue)
                        self:CreateAndStoreTriggers(67,6,7,self.HanrklineBlue)
                        self:CreateAndStoreTriggers(78,7,8,self.HanrklineBlue)
                        self:CreateAndStoreTriggers(89,8,9,self.HanrklineBlue)
                        self:CreateAndStoreTriggers(910,9,10,self.HanrklineBlue)
                        self.Trig01_2_2Blue = false
                        self.Trig01_2_2Gold = true
                    end
                    --路线02_1_2不创建
                    if  self.Trig01_2_1Blue == true and self.Trig01_2_1Gold == false then
                        self:CreateAndStoreTriggers(1011,10,11,self.HanrklineBlue)
                        self:CreateAndStoreTriggers(112,11,2,self.HanrklineBlue)
                        self.Trig01_2_1Blue = false
                        self.Trig01_2_1Gold = true
                    end
                    --路线02_1_3不创建
                    if  self.Trig01_2_3Blue == true and self.Trig01_2_3Gold == false then
                        self:CreateAndStoreTriggers(1012,10,12,self.HanrklineBlue)
                        self:CreateAndStoreTriggers(1213,12,13,self.HanrklineBlue)
                        self.Trig01_2_3Blue = false
                        self.Trig01_2_3Gold = true
                    end
                elseif self.Trig02BeginTake == true then
                    self.Line02 = false                     --线路2未被创建
                    --路线02_1_1创建
                    if  self.Trig01_2_2Blue == false and self.Trig01_2_2Gold == true then
                        self:CreateAndStoreTriggers(56,5,6,self.HanrklineGold)
                        self:CreateAndStoreTriggers(67,6,7,self.HanrklineGold)
                        self:CreateAndStoreTriggers(78,7,8,self.HanrklineGold)
                        self:CreateAndStoreTriggers(89,8,9,self.HanrklineGold)
                        self:CreateAndStoreTriggers(910,9,10,self.HanrklineGold)
                        self.Trig01_2_2Blue = true
                        self.Trig01_2_2Gold = false
                    end
                    --路线02_1_2不创建
                    if  self.Trig01_2_1Blue == true and self.Trig01_2_1Gold == false then
                        self:CreateAndStoreTriggers(1011,10,11,self.HanrklineBlue)
                        self:CreateAndStoreTriggers(112,11,2,self.HanrklineBlue)
                        self.Trig01_2_1Blue = false
                        self.Trig01_2_1Gold = true
                    end
                    --路线02_1_3创建
                    if  self.Trig01_2_3Blue == false and self.Trig01_2_3Gold == true then
                        self:CreateAndStoreTriggers(1012,10,12,self.HanrklineGold)
                        self:CreateAndStoreTriggers(1213,12,13,self.HanrklineGold)
                        self.Trig01_2_3Blue = true
                        self.Trig01_2_3Gold = false
                    end
                end
            elseif self.Trig0204Take == true then
                if self.Trig02BeginTake == false then
                    self.Line02 = false                     --线路2未被创建
                    --路线02_1_1不创建
                    if  self.Trig01_2_2Blue == true and self.Trig01_2_2Gold == false then
                        self:CreateAndStoreTriggers(56,5,6,self.HanrklineBlue)
                        self:CreateAndStoreTriggers(67,6,7,self.HanrklineBlue)
                        self:CreateAndStoreTriggers(78,7,8,self.HanrklineBlue)
                        self:CreateAndStoreTriggers(89,8,9,self.HanrklineBlue)
                        self:CreateAndStoreTriggers(910,9,10,self.HanrklineBlue)
                        self.Trig01_2_2Blue = false
                        self.Trig01_2_2Gold = true
                    end
                    --路线02_1_2不创建
                    if  self.Trig01_2_1Blue == true and self.Trig01_2_1Gold == false then
                        self:CreateAndStoreTriggers(1011,10,11,self.HanrklineBlue)
                        self:CreateAndStoreTriggers(112,11,2,self.HanrklineBlue)
                        self.Trig01_2_1Blue = false
                        self.Trig01_2_1Gold = true
                    end
                    --路线02_1_3不创建
                    if  self.Trig01_2_3Blue == true and self.Trig01_2_3Gold == false then
                        self:CreateAndStoreTriggers(1012,10,12,self.HanrklineBlue)
                        self:CreateAndStoreTriggers(1213,12,13,self.HanrklineBlue)
                        self.Trig01_2_3Blue = false
                        self.Trig01_2_3Gold = true
                    end
                elseif self.Trig02BeginTake == true then
                    self.Line02 = true                     --线路2被创建
                    --路线02_1_1创建
                    if  self.Trig01_2_2Blue == false and self.Trig01_2_2Gold == true then
                        self:CreateAndStoreTriggers(56,5,6,self.HanrklineGold)
                        self:CreateAndStoreTriggers(67,6,7,self.HanrklineGold)
                        self:CreateAndStoreTriggers(78,7,8,self.HanrklineGold)
                        self:CreateAndStoreTriggers(89,8,9,self.HanrklineGold)
                        self:CreateAndStoreTriggers(910,9,10,self.HanrklineGold)
                        self.Trig01_2_2Blue = true
                        self.Trig01_2_2Gold = false
                    end
                    --路线02_1_2创建
                    if  self.Trig01_2_1Blue == false and self.Trig01_2_1Gold == true then
                        self:CreateAndStoreTriggers(1011,10,11,self.HanrklineGold)
                        self:CreateAndStoreTriggers(112,11,2,self.HanrklineGold)
                        self.Trig01_2_1Blue = true
                        self.Trig01_2_1Gold = false
                    end
                    --路线02_1_3不创建
                    if  self.Trig01_2_3Blue == true and self.Trig01_2_3Gold == false then
                        self:CreateAndStoreTriggers(1012,10,12,self.HanrklineBlue)
                        self:CreateAndStoreTriggers(1213,12,13,self.HanrklineBlue)
                        self.Trig01_2_3Blue = false
                        self.Trig01_2_3Gold = true
                    end
                end
            end
            --↑ 线路2创建 ↑--线路2能激活线路1

            --↓ 线路1创建↓
            if self.Trig01BeginTake == false then
                if self.Trig0103Take == false then
                    self.Line01 = false                     --线路1未被创建
                    --路线01_1_1不创建
                    if  self.Trig01_1_1Blue == true and self.Trig01_1_1Gold == false then
                        self:CreateAndStoreTriggers(121,1,21,self.HanrklineBlue)
                        self.Trig01_1_1Blue = false
                        self.Trig01_1_1Gold = true
                    end
                    --路线01_1_2不创建
                    if  self.Trig01_1_2Blue == true and self.Trig01_1_2Gold == false then
                        self:CreateAndStoreTriggers(212,21,2,self.HanrklineBlue)
                        self.Trig01_1_2Blue = false
                        self.Trig01_1_2Gold = true
                    end
                    --路线01_1_3不创建
                    if  self.Trig01_1_3Blue == true and self.Trig01_1_3Gold == false then
                        self:CreateAndStoreTriggers(2122,21,22,self.HanrklineBlue)
                        self.Trig01_1_3Blue = false
                        self.Trig01_1_3Gold = true
                    end
                elseif self.Trig0103Take == true then
                    self.Line01 = false                     --线路1未被创建
                    --路线01_1_1不创建
                    if  self.Trig01_1_1Blue == true and self.Trig01_1_1Gold == false then
                        self:CreateAndStoreTriggers(121,1,21,self.HanrklineBlue)
                        self.Trig01_1_1Blue = false
                        self.Trig01_1_1Gold = true
                    end
                    --路线01_1_2不创建
                    if  self.Trig01_1_2Blue == true and self.Trig01_1_2Gold == false then
                        self:CreateAndStoreTriggers(212,21,2,self.HanrklineBlue)
                        self.Trig01_1_2Blue = false
                        self.Trig01_1_2Gold = true
                    end
                    --路线01_1_3不创建
                    if  self.Trig01_1_3Blue == true and self.Trig01_1_3Gold == false then
                        self:CreateAndStoreTriggers(2122,21,22,self.HanrklineBlue)
                        self.Trig01_1_3Blue = false
                        self.Trig01_1_3Gold = true
                    end
                end
            elseif self.Trig01BeginTake == true then
                if self.Trig0103Take == false then
                    self.Line01 = false                     --线路1未被创建
                    --路线01_1_1创建
                    if  self.Trig01_1_1Blue == false and self.Trig01_1_1Gold == true then
                        self:CreateAndStoreTriggers(121,1,21,self.HanrklineGold)
                        self.Trig01_1_1Blue = true
                        self.Trig01_1_1Gold = false
                    end
                    --路线01_1_2不创建
                    if  self.Trig01_1_2Blue == true and self.Trig01_1_2Gold == false then
                        self:CreateAndStoreTriggers(212,21,2,self.HanrklineBlue)
                        self.Trig01_1_2Blue = false
                        self.Trig01_1_2Gold = true
                    end
                    --路线01_1_3创建
                    if  self.Trig01_1_3Blue == false and self.Trig01_1_3Gold == true then
                        self:CreateAndStoreTriggers(2122,21,22,self.HanrklineGold)
                        self.Trig01_1_3Blue = true
                        self.Trig01_1_3Gold = false
                    end
                elseif self.Trig0103Take == true then
                    self.Line01 = true                     --线路1被创建
                    --路线01_1_1创建
                    if  self.Trig01_1_1Blue == false and self.Trig01_1_1Gold == true then
                        self:CreateAndStoreTriggers(121,1,21,self.HanrklineGold)
                        self.Trig01_1_1Blue = true
                        self.Trig01_1_1Gold = false
                    end
                    --路线01_1_2创建
                    if  self.Trig01_1_2Blue == false and self.Trig01_1_2Gold == true then
                        self:CreateAndStoreTriggers(212,21,2,self.HanrklineGold)
                        self.Trig01_1_2Blue = true
                        self.Trig01_1_2Gold = false
                    end
                    --路线01_1_3不创建
                    if  self.Trig01_1_3Blue == true and self.Trig01_1_3Gold == false then
                        self:CreateAndStoreTriggers(2122,21,22,self.HanrklineBlue)
                        self.Trig01_1_3Blue = false
                        self.Trig01_1_3Gold = true
                    end
                end
            end

            if self.Trig0103Take == false then
                if self.Trig01BeginTake == false then
                    self.Line01 = false                     --线路1未被创建
                    --路线01_1_1不创建
                    if  self.Trig01_1_1Blue == true and self.Trig01_1_1Gold == false then
                        self:CreateAndStoreTriggers(121,1,21,self.HanrklineBlue)
                        self.Trig01_1_1Blue = false
                        self.Trig01_1_1Gold = true
                    end
                    --路线01_1_2不创建
                    if  self.Trig01_1_2Blue == true and self.Trig01_1_2Gold == false then
                        self:CreateAndStoreTriggers(212,21,2,self.HanrklineBlue)
                        self.Trig01_1_2Blue = false
                        self.Trig01_1_2Gold = true
                    end
                    --路线01_1_3不创建
                    if  self.Trig01_1_3Blue == true and self.Trig01_1_3Gold == false then
                        self:CreateAndStoreTriggers(2122,21,22,self.HanrklineBlue)
                        self.Trig01_1_3Blue = false
                        self.Trig01_1_3Gold = true
                    end
                elseif self.Trig01BeginTake == true then
                    self.Line01 = false                     --线路1未被创建
                    --路线01_1_1创建
                    if  self.Trig01_1_1Blue == false and self.Trig01_1_1Gold == true then
                        self:CreateAndStoreTriggers(121,1,21,self.HanrklineGold)
                        self.Trig01_1_1Blue = true
                        self.Trig01_1_1Gold = false
                    end
                    --路线01_1_2不创建
                    if  self.Trig01_1_2Blue == true and self.Trig01_1_2Gold == false then
                        self:CreateAndStoreTriggers(212,21,2,self.HanrklineBlue)
                        self.Trig01_1_2Blue = false
                        self.Trig01_1_2Gold = true
                    end
                    --路线01_1_3创建
                    if  self.Trig01_1_3Blue == false and self.Trig01_1_3Gold == true then
                        self:CreateAndStoreTriggers(2122,21,22,self.HanrklineGold)
                        self.Trig01_1_3Blue = true
                        self.Trig01_1_3Gold = false
                    end
                end
            elseif self.Trig0103Take == true then
                if self.Trig01BeginTake == false then
                    self.Line01 = false                     --线路1未被创建
                    --路线01_1_1不创建
                    if  self.Trig01_1_1Blue == true and self.Trig01_1_1Gold == false then
                        self:CreateAndStoreTriggers(121,1,21,self.HanrklineBlue)
                        self.Trig01_1_1Blue = false
                        self.Trig01_1_1Gold = true
                    end
                    --路线01_1_2不创建
                    if  self.Trig01_1_2Blue == true and self.Trig01_1_2Gold == false then
                        self:CreateAndStoreTriggers(212,21,2,self.HanrklineBlue)
                        self.Trig01_1_2Blue = false
                        self.Trig01_1_2Gold = true
                    end
                    --路线01_1_3不创建
                    if  self.Trig01_1_3Blue == true and self.Trig01_1_3Gold == false then
                        self:CreateAndStoreTriggers(2122,21,22,self.HanrklineBlue)
                        self.Trig01_1_3Blue = false
                        self.Trig01_1_3Gold = true
                    end
                elseif self.Trig01BeginTake == true then
                    self.Line01 = true                     --线路1被创建
                    --路线01_1_1创建
                    if  self.Trig01_1_1Blue == false and self.Trig01_1_1Gold == true then
                        self:CreateAndStoreTriggers(121,1,21,self.HanrklineGold)
                        self.Trig01_1_1Blue = true
                        self.Trig01_1_1Gold = false
                    end
                    --路线01_1_2创建
                    if  self.Trig01_1_2Blue == false and self.Trig01_1_2Gold == true then
                        self:CreateAndStoreTriggers(212,21,2,self.HanrklineGold)
                        self.Trig01_1_2Blue = true
                        self.Trig01_1_2Gold = false
                    end
                    --路线01_1_3不创建
                    if  self.Trig01_1_3Blue == true and self.Trig01_1_3Gold == false then
                        self:CreateAndStoreTriggers(2122,21,22,self.HanrklineBlue)
                        self.Trig01_1_3Blue = false
                        self.Trig01_1_3Gold = true
                    end
                end
            end

            if self.Line01 == true and self.Line02 == true  then
                --路线01_1_3创建
                self.Trig01EndTake = true
                BehaviorFunctions.SetEntityHackEffectIsTask(self.Trig01End, true)   --控制终点4颜色，黄色
                BehaviorFunctions.SetEntityHackEffectIsTask(self.Trig0100, true)   --控制终点4颜色，黄色
                if  self.Trig01_1_4Blue == false and self.Trig01_1_4Gold == true then
                    self:CreateAndStoreTriggers(23,2,3,self.HanrklineGold)
                    self:CreateAndStoreTriggers(34,3,4,self.HanrklineGold)
                    self.Trig01_1_4Blue = true
                    self.Trig01_1_4Gold = false
                end
            end
            if self.Line01 == false and self.Line02 == false then
                --路线01_1_3创建
                self.Trig01EndTake = false
                if  self.Trig01_1_4Blue == true and self.Trig01_1_4Gold == false then
                    self:CreateAndStoreTriggers(23,2,3,self.HanrklineBlue)
                    self:CreateAndStoreTriggers(34,3,4,self.HanrklineBlue)
                    self.Trig01_1_4Blue = false
                    self.Trig01_1_4Gold = true
                end
            elseif self.Line01 == true and self.Line02 == false then
                --路线01_1_3创建
                self.Trig01EndTake = false
                if  self.Trig01_1_4Blue == true and self.Trig01_1_4Gold == false then
                    self:CreateAndStoreTriggers(23,2,3,self.HanrklineBlue)
                    self:CreateAndStoreTriggers(34,3,4,self.HanrklineBlue)
                    self.Trig01_1_4Blue = false
                    self.Trig01_1_4Gold = true
                end
            elseif self.Line01 == false and self.Line02 == true then
                --路线01_1_3创建
                self.Trig01EndTake = false
                if  self.Trig01_1_4Blue == true and self.Trig01_1_4Gold == false then
                    self:CreateAndStoreTriggers(23,2,3,self.HanrklineBlue)
                    self:CreateAndStoreTriggers(34,3,4,self.HanrklineBlue)
                    self.Trig01_1_4Gold = false
                    self.Trig01_1_4Gold = true
                end
            end
            --↑ 线路1创建↑

            --↓ 线路3创建↓--
            if self.Trig04BeginTake == false then
                if self.Trig0400Take == false then
                    self:HanrkSwitchBlue(self.Trig04End)            --控制终点4颜色，蓝色
                    self:HanrkSwitchBlue(self.Trig05End)            --控制终点5颜色，蓝色
                    self.Trig04EndTake = false

                    --线路2-1-1
                    if  self.Trig02_1_1Blue == true and self.Trig02_1_1Gold == false then
                        self:CreateAndStoreTriggers(1415,14,15,self.HanrklineBlue)
                        self.Trig02_1_1Blue = false
                        self.Trig02_1_1Gold = true
                    end
                    --线路2-1-2
                    if  self.Trig02_1_2Blue == true and self.Trig02_1_2Gold == false then
                        self:CreateAndStoreTriggers(1516,15,16,self.HanrklineBlue)
                        self:CreateAndStoreTriggers(1617,16,17,self.HanrklineBlue)
                        self:CreateAndStoreTriggers(1718,17,18,self.HanrklineBlue)
                        self.Trig02_1_2Blue = false
                        self.Trig02_1_2Gold = true
                    end
                    --线路2-2-1
                    if  self.Trig02_2_1Blue == true and self.Trig02_2_1Gold == false then
                        self:CreateAndStoreTriggers(1915,19,15,self.HanrklineBlue)
                        self:CreateAndStoreTriggers(2019,20,19,self.HanrklineBlue)
                        self.Trig02_2_1Blue = false
                        self.Trig02_2_1Gold = true
                    end
                elseif self.Trig0400Take == true then
                    self:HanrkSwitchBlue(self.Trig04End)            --控制终点4颜色，蓝色
                    self:HanrkSwitchBlue(self.Trig05End)            --控制终点5颜色，蓝色
                    self.Trig04EndTake = false

                    --线路2-1-1
                    if  self.Trig02_1_1Blue == true and self.Trig02_1_1Gold == false then
                        self:CreateAndStoreTriggers(1415,14,15,self.HanrklineBlue)
                        self.Trig02_1_1Blue = false
                        self.Trig02_1_1Gold = true
                    end
                    --线路2-1-2
                    if  self.Trig02_1_2Blue == true and self.Trig02_1_2Gold == false then
                        self:CreateAndStoreTriggers(1516,15,16,self.HanrklineBlue)
                        self:CreateAndStoreTriggers(1617,16,17,self.HanrklineBlue)
                        self:CreateAndStoreTriggers(1718,17,18,self.HanrklineBlue)
                        self.Trig02_1_2Blue = false
                        self.Trig02_1_2Gold = true
                    end
                    --线路2-2-1
                    if  self.Trig02_2_1Blue == true and self.Trig02_2_1Gold == false then
                        self:CreateAndStoreTriggers(1915,19,15,self.HanrklineBlue)
                        self:CreateAndStoreTriggers(2019,20,19,self.HanrklineBlue)
                        self.Trig02_2_1Blue = false
                        self.Trig02_2_1Gold = true
                    end
                end
            elseif self.Trig04BeginTake == true then
                if self.Trig0400Take == false then
                    self:HanrkSwitchBlue(self.Trig04End)            --控制终点4颜色，蓝色
                    BehaviorFunctions.SetEntityHackEffectIsTask(self.Trig05End, true)   --控制终点5颜色，黄色
                    self.Trig04EndTake = false

                    --线路2-1-1
                    if  self.Trig02_1_1Blue == false and self.Trig02_1_1Gold == true then
                        self:CreateAndStoreTriggers(1415,14,15,self.HanrklineGold)
                        self.Trig02_1_1Blue = true
                        self.Trig02_1_1Gold = false
                    end
                    --线路2-1-2
                    if  self.Trig02_1_2Blue == true and self.Trig02_1_2Gold == false then
                        self:CreateAndStoreTriggers(1516,15,16,self.HanrklineBlue)
                        self:CreateAndStoreTriggers(1617,16,17,self.HanrklineBlue)
                        self:CreateAndStoreTriggers(1718,17,18,self.HanrklineBlue)
                        self.Trig02_1_2Blue = false
                        self.Trig02_1_2Gold = true
                    end
                    --线路2-2-1
                    if  self.Trig02_2_1Blue == false and self.Trig02_2_1Gold == true then
                        self:CreateAndStoreTriggers(1915,19,15,self.HanrklineGold)
                        self:CreateAndStoreTriggers(2019,20,19,self.HanrklineGold)
                        self.Trig02_2_1Blue = true
                        self.Trig02_2_1Gold = false
                    end

                elseif self.Trig0400Take == true then
                    BehaviorFunctions.SetEntityHackEffectIsTask(self.Trig04End, true)   --控制终点4颜色，黄色
                    self:HanrkSwitchBlue(self.Trig05End)            --控制终点5颜色，蓝色
                    self.Trig04EndTake = true

                    self.Trig02EndTake = true
                    --线路2-1-1
                    if  self.Trig02_1_1Blue == false and self.Trig02_1_1Gold == true then
                        self:CreateAndStoreTriggers(1415,14,15,self.HanrklineGold)
                        self.Trig02_1_1Blue = true
                        self.Trig02_1_1Gold = false
                    end
                    --线路2-1-2
                    if  self.Trig02_1_2Blue == false and self.Trig02_1_2Gold == true then
                        self:CreateAndStoreTriggers(1516,15,16,self.HanrklineGold)
                        self:CreateAndStoreTriggers(1617,16,17,self.HanrklineGold)
                        self:CreateAndStoreTriggers(1718,17,18,self.HanrklineGold)
                        self.Trig02_1_2Blue = true
                        self.Trig02_1_2Gold = false
                    end
                    --线路2-2-1
                    if  self.Trig02_2_1Blue == true and self.Trig02_2_1Gold == false then
                        self:CreateAndStoreTriggers(1915,19,15,self.HanrklineBlue)
                        self:CreateAndStoreTriggers(2019,20,19,self.HanrklineBlue)
                        self.Trig02_2_1Blue = false
                        self.Trig02_2_1Gold = true
                    end
                    
                end
            end

            if self.Trig0400Take == false then
                if self.Trig04BeginTake == false then
                    self:HanrkSwitchBlue(self.Trig04End)            --控制终点4颜色，蓝色
                    self:HanrkSwitchBlue(self.Trig05End)            --控制终点5颜色，蓝色
                    self.Trig04EndTake = false

                    --线路2-1-1
                    if  self.Trig02_1_1Blue == true and self.Trig02_1_1Gold == false then
                        self:CreateAndStoreTriggers(1415,14,15,self.HanrklineBlue)
                        self.Trig02_1_1Blue = false
                        self.Trig02_1_1Gold = true
                    end
                    --线路2-1-2
                    if  self.Trig02_1_2Blue == true and self.Trig02_1_2Gold == false then
                        self:CreateAndStoreTriggers(1516,15,16,self.HanrklineBlue)
                        self:CreateAndStoreTriggers(1617,16,17,self.HanrklineBlue)
                        self:CreateAndStoreTriggers(1718,17,18,self.HanrklineBlue)
                        self.Trig02_1_2Blue = false
                        self.Trig02_1_2Gold = true
                    end
                    --线路2-2-1
                    if  self.Trig02_2_1Blue == true and self.Trig02_2_1Gold == false then
                        self:CreateAndStoreTriggers(1915,19,15,self.HanrklineBlue)
                        self:CreateAndStoreTriggers(2019,20,19,self.HanrklineBlue)
                        self.Trig02_2_1Blue = false
                        self.Trig02_2_1Gold = true
                    end
                elseif self.Trig04BeginTake == true then
                    self:HanrkSwitchBlue(self.Trig04End)            --控制终点4颜色，蓝色
                    BehaviorFunctions.SetEntityHackEffectIsTask(self.Trig05End, true)   --控制终点5颜色，黄色
                    self.Trig04EndTake = false

                    --线路2-1-1
                    if  self.Trig02_1_1Blue == false and self.Trig02_1_1Gold == true then
                        self:CreateAndStoreTriggers(1415,14,15,self.HanrklineGold)
                        self.Trig02_1_1Blue = true
                        self.Trig02_1_1Gold = false
                    end
                    --线路2-1-2
                    if  self.Trig02_1_2Blue == true and self.Trig02_1_2Gold == false then
                        self:CreateAndStoreTriggers(1516,15,16,self.HanrklineBlue)
                        self:CreateAndStoreTriggers(1617,16,17,self.HanrklineBlue)
                        self:CreateAndStoreTriggers(1718,17,18,self.HanrklineBlue)
                        self.Trig02_1_2Blue = false
                        self.Trig02_1_2Gold = true
                    end
                    --线路2-2-1
                    if  self.Trig02_2_1Blue == false and self.Trig02_2_1Gold == true then
                        self:CreateAndStoreTriggers(1915,19,15,self.HanrklineGold)
                        self:CreateAndStoreTriggers(2019,20,19,self.HanrklineGold)
                        self.Trig02_2_1Blue = true
                        self.Trig02_2_1Gold = false
                    end
                end
            elseif self.Trig0400Take == true then
                if self.Trig04BeginTake == false then
                    self:HanrkSwitchBlue(self.Trig04End)            --控制终点4颜色，蓝色
                    self:HanrkSwitchBlue(self.Trig05End)            --控制终点5颜色，蓝色
                    self.Trig04EndTake = false

                    --线路2-1-1
                    if  self.Trig02_1_1Blue == true and self.Trig02_1_1Gold == false then
                        self:CreateAndStoreTriggers(1415,14,15,self.HanrklineBlue)
                        self.Trig02_1_1Blue = false
                        self.Trig02_1_1Gold = true
                    end
                    --线路2-1-2
                    if  self.Trig02_1_2Blue == true and self.Trig02_1_2Gold == false then
                        self:CreateAndStoreTriggers(1516,15,16,self.HanrklineBlue)
                        self:CreateAndStoreTriggers(1617,16,17,self.HanrklineBlue)
                        self:CreateAndStoreTriggers(1718,17,18,self.HanrklineBlue)
                        self.Trig02_1_2Blue = false
                        self.Trig02_1_2Gold = true
                    end
                    --线路2-2-1
                    if  self.Trig02_2_1Blue == true and self.Trig02_2_1Gold == false then
                        self:CreateAndStoreTriggers(1915,19,15,self.HanrklineBlue)
                        self:CreateAndStoreTriggers(2019,20,19,self.HanrklineBlue)
                        self.Trig02_2_1Blue = false
                        self.Trig02_2_1Gold = true
                    end
                elseif self.Trig04BeginTake == true then
                    BehaviorFunctions.SetEntityHackEffectIsTask(self.Trig04End, true)   --控制终点4颜色，黄色
                    self:HanrkSwitchBlue(self.Trig05End)            --控制终点5颜色，蓝色
                    self.Trig04EndTake = true

                    --线路2-1-1
                    if  self.Trig02_1_1Blue == false and self.Trig02_1_1Gold == true then
                        self:CreateAndStoreTriggers(1415,14,15,self.HanrklineGold)
                        self.Trig02_1_1Blue = true
                        self.Trig02_1_1Gold = false
                    end
                    --线路2-1-2
                    if  self.Trig02_1_2Blue == false and self.Trig02_1_2Gold == true then
                        self:CreateAndStoreTriggers(1516,15,16,self.HanrklineGold)
                        self:CreateAndStoreTriggers(1617,16,17,self.HanrklineGold)
                        self:CreateAndStoreTriggers(1718,17,18,self.HanrklineGold)
                        self.Trig02_1_2Blue = true
                        self.Trig02_1_2Gold = false
                    end
                    --线路2-2-1
                    if  self.Trig02_2_1Blue == true and self.Trig02_2_1Gold == false then
                        self:CreateAndStoreTriggers(1915,19,15,self.HanrklineBlue)
                        self:CreateAndStoreTriggers(2019,20,19,self.HanrklineBlue)
                        self.Trig02_2_1Blue = false
                        self.Trig02_2_1Gold = true
                    end
                end
            end
            --↑ 线路3创建↑--

        elseif BehaviorFunctions.GetEntityState(self.role) ~= FightEnum.EntityState.Hack then
			if self.RemoveLineEntityInit == false then
                if self.RemoveLineTack == true then
                    --在退出骇入模式移除连线特效
                    --检查并移除实体，传递索引而不是实体对象
                    self:ToggleTrigColorState('Trig01_1_1Gold','Trig01_1_1Blue')
                    self:ToggleTrigColorState('Trig01_1_2Gold','Trig01_1_2Blue')
                    self:ToggleTrigColorState('Trig01_1_3Gold','Trig01_1_3Blue')
                    self:ToggleTrigColorState('Trig01_1_4Gold','Trig01_1_4Blue')
                    self:ToggleTrigColorState('Trig01_2_1Gold','Trig01_2_1Blue')
                    self:ToggleTrigColorState('Trig01_2_2Gold','Trig01_2_2Blue')
                    self:ToggleTrigColorState('Trig01_2_3Gold','Trig01_2_3Blue')
                    self:ToggleTrigColorState('Trig02_1_1Gold','Trig02_1_1Blue')
                    self:ToggleTrigColorState('Trig02_1_2Gold','Trig02_1_2Blue')
                    self:ToggleTrigColorState('Trig02_2_1Gold','Trig02_2_1Blue')

                    self:RemoveLineEntity(12)
                    self:RemoveLineEntity(212)
                    self:RemoveLineEntity(23)
                    self:RemoveLineEntity(34)
                    self:RemoveLineEntity(45)
                    self:RemoveLineEntity(56)
                    self:RemoveLineEntity(67)
                    self:RemoveLineEntity(78)
                    self:RemoveLineEntity(89)
                    self:RemoveLineEntity(910)
                    self:RemoveLineEntity(1011)
                    self:RemoveLineEntity(112)
                    self:RemoveLineEntity(121)
                    self:RemoveLineEntity(1012)
                    self:RemoveLineEntity(1213)
                    self:RemoveLineEntity(1415)
                    self:RemoveLineEntity(1516)
                    self:RemoveLineEntity(1617)
                    self:RemoveLineEntity(1718)
                    self:RemoveLineEntity(1915)
                    self:RemoveLineEntity(2019)
                    self:RemoveLineEntity(2122)
                    self.RemoveLineEntityInit = true
                    self.RemoveLineTack = false
                end
			end
        end
    --↑在空实体之间创建电路链接特效↑--

            --↓左侧提示--
            if self.Trig01EndTake == false and self.Trig04EndTake == false then
                BehaviorFunctions.ChangeSubTipsDesc(1, self.tips, 0, 2) -- 当两者都为 false 时  
            elseif (self.Trig01EndTake == true and self.Trig04EndTake == false) or (self.Trig01EndTake == false and self.Trig04EndTake == true) then
                BehaviorFunctions.ChangeSubTipsDesc(1, self.tips, 1, 2) -- 当其中一个为 true，另一个为 false 时  
            elseif self.Trig01EndTake == true and self.Trig04EndTake == true then
                BehaviorFunctions.ChangeSubTipsDesc(1, self.tips, 2, 2) -- 当两者都为 true 时  
            end
            --↑左侧提示--

        --判断关卡关卡是否结束
        if self.Trig01EndTake == true and self.Trig02EndTake == true then
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
                    BehaviorFunctions.AddDelayCallByTime(3,BehaviorFunctions,BehaviorFunctions.SetEntityHackEnable,self.Trig0100,false)
                    BehaviorFunctions.AddDelayCallByTime(3,BehaviorFunctions,BehaviorFunctions.SetEntityHackEnable,self.Trig01End,false)
                    BehaviorFunctions.AddDelayCallByTime(3,BehaviorFunctions,BehaviorFunctions.SetEntityHackEnable,self.Trig02Begin,false)
                    BehaviorFunctions.AddDelayCallByTime(3,BehaviorFunctions,BehaviorFunctions.SetEntityHackEnable,self.Trig0204,false)
                    BehaviorFunctions.AddDelayCallByTime(3,BehaviorFunctions,BehaviorFunctions.SetEntityHackEnable,self.Trig04Begin,false)
                    BehaviorFunctions.AddDelayCallByTime(3,BehaviorFunctions,BehaviorFunctions.SetEntityHackEnable,self.Trig0400,false)
                    BehaviorFunctions.AddDelayCallByTime(3,BehaviorFunctions,BehaviorFunctions.SetEntityHackEnable,self.Trig04End,false)
                    BehaviorFunctions.AddDelayCallByTime(3,BehaviorFunctions,BehaviorFunctions.SetEntityHackEnable,self.Trig05End,false)
                end
                self.levelwin = true
                self.missionState = 999
            end
        end
    end
end

function LevelBehavior405020203:__delete()
end

-------------------------函数--------------------------------

--↓电路创建函数TrigPos，只需修改self.TrigPos中的值，便能自动更新self.TrigNil实体名称并创建真正的空实体。电路玩法必用↓--
--创建空实体函数，电路玩法必用↓--
function LevelBehavior405020203:CreateNilEntity()
    self.TrigNil = self.TrigNil or {}
    for index, posName in ipairs(self.TrigPos) do
        self.TrigNil[index] = BehaviorFunctions.CreateEntityByPosition(self.trigEntity, nil, posName, self.logicName, self.levelId, nil)
    end
end

--在指定位置创建实体
function LevelBehavior405020203:InPositionEntity(entityPropertyName, entityPrefab, positionIndex)
    if self[entityPropertyName] == nil then
        self[entityPropertyName] = BehaviorFunctions.CreateEntityByPosition(entityPrefab, nil, self.TrigPos[positionIndex], self.logicName, self.levelId, nil)
    end
    return self[entityPropertyName]
end

-- 创建或替换指定索引的特效
function LevelBehavior405020203:CreateAndStoreTriggers(fxhackDriveLineIndex, triggerStartIndex, triggerEndIndex, lineColorResource)
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
function LevelBehavior405020203:RemoveLineEntity(index)
    local entity = self.fxhackDriveLine[index]
    if entity ~= nil then
        BehaviorFunctions.RemoveEntity(entity)
        self.fxhackDriveLine[index] = nil  -- 将数组中对应的索引设置为 nil
    end
end

--记录当前电路的颜色
function LevelBehavior405020203:ToggleTrigColorState(trigBlueName, trigGoldName)
    if self[trigGoldName] then
        -- 如果移除的是金色特效，则下次应该创建蓝色特效
        self[trigBlueName] = true
        self[trigGoldName] = false
    elseif self[trigBlueName] then
        -- 如果移除的是蓝色特效，则下次应该创建金色特效
        self[trigBlueName] = false
        self[trigGoldName] = true
    end
end

-- 骇入物件黄蓝变色函数
function LevelBehavior405020203:HanrkSwitchBlue(index)
    if BehaviorFunctions.GetEntityHackEffectIsTask(index) == true then	--开关变黄色
        BehaviorFunctions.SetEntityHackEffectIsTask(index, true)
    else
        BehaviorFunctions.SetEntityHackEffectIsTask(index, false)
    end
end

--↑电路创建函数TrigPos，只需修改self.TrigPos中的值，便能自动更新self.TrigNil实体名称并创建真正的空实体。电路玩法必用↑--


--开场自定义功能函数
function LevelBehavior405020203:CustomLevelFunctions()
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
function LevelBehavior405020203:SetLevelCamera()
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
function LevelBehavior405020203:LevelFinish()
        BehaviorFunctions.HideTip(102670102)
        BehaviorFunctions.RemoveLevel(self.levelId)
    end

function LevelBehavior405020203:RemoveFxTrigNil()
    BehaviorFunctions.RemoveEntity(self.fxhackDriveLine[12])
    BehaviorFunctions.RemoveEntity(self.fxhackDriveLine[212])
    BehaviorFunctions.RemoveEntity(self.fxhackDriveLine[23])
    BehaviorFunctions.RemoveEntity(self.fxhackDriveLine[34])
    BehaviorFunctions.RemoveEntity(self.fxhackDriveLine[45])
    BehaviorFunctions.RemoveEntity(self.fxhackDriveLine[56])
    BehaviorFunctions.RemoveEntity(self.fxhackDriveLine[67])
    BehaviorFunctions.RemoveEntity(self.fxhackDriveLine[78])
    BehaviorFunctions.RemoveEntity(self.fxhackDriveLine[89])
    BehaviorFunctions.RemoveEntity(self.fxhackDriveLine[910])
    BehaviorFunctions.RemoveEntity(self.fxhackDriveLine[1011])
    BehaviorFunctions.RemoveEntity(self.fxhackDriveLine[112])
    BehaviorFunctions.RemoveEntity(self.fxhackDriveLine[121])
    BehaviorFunctions.RemoveEntity(self.fxhackDriveLine[1012])
    BehaviorFunctions.RemoveEntity(self.fxhackDriveLine[1213])
    BehaviorFunctions.RemoveEntity(self.fxhackDriveLine[1415])
    BehaviorFunctions.RemoveEntity(self.fxhackDriveLine[1516])
    BehaviorFunctions.RemoveEntity(self.fxhackDriveLine[1617])
    BehaviorFunctions.RemoveEntity(self.fxhackDriveLine[1718])
    BehaviorFunctions.RemoveEntity(self.fxhackDriveLine[1915])
    BehaviorFunctions.RemoveEntity(self.fxhackDriveLine[2019])
    BehaviorFunctions.RemoveEntity(self.fxhackDriveLine[2122])

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
    BehaviorFunctions.RemoveEntity(self.TrigNil[17])
    BehaviorFunctions.RemoveEntity(self.TrigNil[18])
    BehaviorFunctions.RemoveEntity(self.TrigNil[19])
    BehaviorFunctions.RemoveEntity(self.TrigNil[20])
    BehaviorFunctions.RemoveEntity(self.TrigNil[21])
    BehaviorFunctions.RemoveEntity(self.TrigNil[22])
end

function LevelBehavior405020203:RemoveTrig()
    BehaviorFunctions.RemoveEntity(self.Trig01Begin)
    BehaviorFunctions.RemoveEntity(self.Trig0103)
    BehaviorFunctions.RemoveEntity(self.Trig0100)
    BehaviorFunctions.RemoveEntity(self.Trig01End)
    BehaviorFunctions.RemoveEntity(self.Trig02Begin)
    BehaviorFunctions.RemoveEntity(self.Trig0204)
    BehaviorFunctions.RemoveEntity(self.Trig04Begin)
    BehaviorFunctions.RemoveEntity(self.Trig0400)
    BehaviorFunctions.RemoveEntity(self.Trig04End)
    BehaviorFunctions.RemoveEntity(self.Trig05End)
end

---------------------回调----------------------------------
 
--死亡回调
function LevelBehavior405020203:Death(instanceId,isFormationRevive)
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