Config = Config or {}
Config.Entity2040703 = Config.Entity2040703 or { }
local empty = { }
Config.Entity2040703 = 
{
  [ 2040703 ] = {
    EntityId = 2040703,
    Components = {
      Transform = {
        Prefab = "Scene/Common/Effect/01/Prefab/FxPositionGuide.prefab",
        Model = "FxPositionGuide",
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
      Trigger = {
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
      Behavior = {
        Behaviors = {
          "2040703"
        },
      },
      Buff = empty,
      Tag = {
        Tag = 3,
        NpcTag = 0,
        SceneObjectTag = 1,
        PartTag = 1
      }
    }
  }
}
