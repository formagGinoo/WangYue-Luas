Config = Config or {}
Config.Entity2020110 = Config.Entity2020110 or { }
local empty = { }
Config.Entity2020110 = 
{
  [ 2020110 ] = {
    EntityId = 2020110,
    Components = {
      Transform = {
        Prefab = "CommonEntity/FxQi/FxQiLoop.prefab",
        Model = "FxQiLoop",
        isClone = false,
        MinDistance = 0.0,
        MaxDistance = 1.0,
        MinTranslucent = 0.0,
        MaxTranslucent = 0.8,
        TranslucentHeight = 1.8,
        LodRes = false,
        localEntity = false
      },
      Animator = {
        Animator = "CommonEntity/FxQi/FxQiLoop.controller",
        AnimationConfigID = "",

      },
      Behavior = {
        Behaviors = {
          "2020110"
        },
      },
      TimeoutDeath = {
        Frame = -1,
        RemoveDelayFrame = 0,
      },
      Time = {
        DefalutTimeScale = 1.0
      },
      Trigger = {
        TriggerIcon = "Textures/Icon/Single/FuncIcon/Trigger_door.png",
        TriggerText = "进入",
        TriggerType = 0,
        Offset = { 0.0, 0.0, 0.0 },
        DurationTime = -1.0,
        ShapeType = 1,
        EnterBehaviorAlways = true,
        Radius = 3.0,
        RadiusOut = 5.0,
        EnterHeight = 0.0,
        LeftHeight = 0.0,
        CubeIng = { 0.0, 0.0, 0.0 },
        CubeOut = { 0.0, 0.0, 0.0 },
        SetOutOffset = false,
        OutOffset = { 0.0, 0.0, 0.0 },      },
      Collision = {
        CollisionCheckType = 1,
        Radius = 0.0,
        Priority = 0,
        FixAngle = 45.0,
        CollisionRadius = 0.5,
        Height = 0.0,
        offsetX = 0.0,
        offsetY = 0.0,
        offsetZ = 0.0
      },
      Tag = {
        Tag = 3,
        NpcTag = 0,
        SceneObjectTag = 1,
        Camp = 1,
        PartTag = 1
      }
    }
  }
}
