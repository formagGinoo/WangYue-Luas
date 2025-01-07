Config = Config or {}
Config.Entity2020604 = Config.Entity2020604 or { }
local empty = { }
Config.Entity2020604 = 
{
  [ 2020604 ] = {
    EntityId = 2020604,
    Components = {
      Transform = {
        Prefab = "CommonEntity/BigBellTower/Prefab/TowerDoor.prefab",
        Model = "TowerDoor",
        isClone = false,
        MinDistance = 0.0,
        MaxDistance = 1.0,
        MinTranslucent = 0.0,
        MaxTranslucent = 0.8,
        TranslucentHeight = 1.8,
        LodRes = false,
        localEntity = false
      },
      TimeoutDeath = {
        Frame = -1,
        RemoveDelayFrame = 0,
      },
      Time = {
        DefalutTimeScale = 1.0
      },
      Behavior = {
        Behaviors = {
          "2020604"
        },
      },
      Buff = empty,
      Tag = {
        Tag = 1,
        NpcTag = 2,
        SceneObjectTag = 0,
        PartTag = 1
      },
      Animator = {
        Animator = "CommonEntity/BigBellTower/Animation/TowerDoor/TowerDoor.controller",
        AnimationConfigID = "",

      },
      Trigger = {
        TriggerIcon = "Textures/Icon/Single/FuncIcon/Trigger_Transform.png",
        TriggerText = "开门",
        TriggerType = 0,
        Offset = { 0.0, 2.0, 9.0 },
        DurationTime = -1.0,
        ShapeType = 2,
        EnterBehaviorAlways = true,
        Radius = 2.0,
        RadiusOut = 2.0,
        EnterHeight = 0.0,
        LeftHeight = 0.0,
        CubeIng = { 3.0, 2.0, 3.0 },
        CubeOut = { 4.0, 2.0, 4.0 },
        SetOutOffset = false,
        OutOffset = { 0.0, 0.0, 0.0 },      }
    }
  }
}
