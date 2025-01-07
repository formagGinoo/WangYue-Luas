SystemStateConfig = SystemStateConfig or {}

SystemStateConfig.StateType = 
{
    Story = 2,
    Hack = 3,
    Photo = 4,
    Build = 5,
    Car = 7,
    Decoration = 8,
}
local StateType = SystemStateConfig.StateType

SystemStateConfig.DebugStateName = {
    [StateType.Story] = "剧情",
    [StateType.Hack] = "骇入",
    [StateType.Photo] = "拍照",
    [StateType.Build] = "建造",
    [StateType.Car] = "驾驶",
    [StateType.Decoration] = "装修",
}

SystemStateConfig.TransitionType = 
{
    LineUp = 3,--（后者）排队
    Break = 2,--（前者被）打断
    Coexist = 1, --共存
}
local TransitionType = SystemStateConfig.TransitionType

SystemStateConfig.TipQueueState = 
{
    Pause = 3,
    PausePart = 2,
    Play = 1,
}
local TipQueueState = SystemStateConfig.TipQueueState

local ActionMap = InputDefine.ActionMap

--配置状态权重
SystemStateConfig.StateWeight =
{
    [StateType.Story] = 2,
    [StateType.Hack] = 1,
    [StateType.Photo] = 1,
    [StateType.Build] = 1,
    [StateType.Car] = 1,
    [StateType.Decoration] = 1,
}

--配置输入模式归属
SystemStateConfig.ActionMap2State =
{
    [ActionMap.Story] = StateType.Story,
    [ActionMap.Hack] = StateType.Hack,
    [ActionMap.Photo] = StateType.Photo,
    [ActionMap.PhotoTPS] = StateType.Photo,
    [ActionMap.Build] = StateType.Build,
    [ActionMap.Drone] = StateType.Car,
    [ActionMap.Decoration] = StateType.Build,
}

--配置过渡设置,没配的默认排队
local TransitionTypeConfig = 
{
    [StateType.Hack] = 
    {
        [StateType.Story] = TransitionType.Break,
    },
    [StateType.Photo] = 
    {
        [StateType.Story] = TransitionType.Break,
    },
    [StateType.Build] = 
    {
        [StateType.Story] = TransitionType.Break,
    },
    [StateType.Car] = 
    {
        [StateType.Story] = TransitionType.Coexist,
    },
    [StateType.Decoration] = 
    {
        [StateType.Story] = TransitionType.Break,
    },
}

---配置系统弹窗状态
local TipQueueStateConfig = 
{
    [StateType.Story] = TipQueueState.Pause,
}

function SystemStateConfig.GetActionMapWeight(actionMap)
    if actionMap == ActionMap.UI then
        return 9999
    end
    if not SystemStateConfig.ActionMap2State[actionMap] then
        return 1
    end
    local stateType = SystemStateConfig.ActionMap2State[actionMap]
    return SystemStateConfig.StateWeight[stateType] * 100
end

function SystemStateConfig.GetStateTransition(curState, targetState)
    if TransitionTypeConfig[curState] and TransitionTypeConfig[curState][targetState] then
        return TransitionTypeConfig[curState][targetState]
    end
    return TransitionType.LineUp
end


function SystemStateConfig.GetTipQueueState(state)
    return TipQueueStateConfig[state] or TipQueueState.Play
end

SystemStateConfig.EnterFuncs =
{
    [StateType.Story] = function(...)
        Story.Instance:StartStory(...)
    end,

    [StateType.Photo] = function(...)
        mod.PhotoCtrl:TempOpenPhoto(...)
    end,

    [StateType.Hack] = function(...)
        Fight.Instance.hackManager:TempEnterHackingMode(...)
    end,

    [StateType.Build] = function(...)
        Fight.Instance.clientFight.buildManager:TempOpenBuildControlPanel(...)
    end,

    [StateType.Decoration] = function(...)
        Fight.Instance.clientFight.decorationManager:TempOpenDecorationControlPanel(...)
    end,
    --驾驶通过事件触发
}

SystemStateConfig.ExitFuncs =
{
    [StateType.Story] = function()
        BehaviorFunctions.ForceExitStory()
    end,

    [StateType.Photo] = function()
        mod.PhotoCtrl:ClosePhoto()
    end,

    [StateType.Hack] = function()
        BehaviorFunctions.ExitHackingMode()
    end,

    [StateType.Build] = function()
        Fight.Instance.clientFight.buildManager:CloseBuildControlPanel()
    end,

    [StateType.Car] = function()
        BehaviorFunctions.GetOffCar(true)
    end,

    [StateType.Decoration] = function()
        Fight.Instance.clientFight.decorationManager:CloseBuildControlPanel()
    end,
}



--输入模式权重是独立的，目前并未按原计划修改
--相机有两种实现，状态机，权重相机(这部分同理没按原计划修改)
--系统弹窗队列，系统类：能在任意场合出现，战斗类：只能在战斗界面出现

--退出模块，看上面的 SystemStateConfig.ExitFuncs
--进入剧情：GM已有，或者Story.Instance:AddStoryCommand(id)
--打开拍照 mod.PhotoCtrl:OpenPhoto()
--进入骇入模式 BehaviorFunctions.EnterHackingMode(args)
--建造 BehaviorFunctions.OpenBuildControlPanel()
--驾驶，没有

--例如：打开拍照后立刻进入剧情
-- mod.PhotoCtrl:OpenPhoto()
-- Story.Instance:AddStoryCommand(101112601)

--补充：整理相关内容时发现还有很多模块也需要接入此系统，这里不做赘述

--弹窗世界等级变化
--EventMgr.Instance:Fire(EventName.AddSystemContent, WorldLevelChangeTipPanel, {args = {level = 5}})
--弹探索等级、
-- EventMgr.Instance:Fire(EventName.AdventureChange)

-- 提示旁白，602070201
-- 强剧情，101104101