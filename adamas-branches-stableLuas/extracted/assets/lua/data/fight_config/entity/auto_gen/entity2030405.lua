Config = Config or {}
Config.Entity2030405 = Config.Entity2030405 or { }
local empty = { }
Config.Entity2030405 = 
{
  [ 2030405 ] = {
    EntityId = 2030405,
    Components = {
      Transform = {
        Prefab = "Character/Role/Entity1003/Model/Entity1004.prefab",
        Model = "Entity1004",
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
          "2030405"
        },
      },
      Buff = empty}
  }
}
