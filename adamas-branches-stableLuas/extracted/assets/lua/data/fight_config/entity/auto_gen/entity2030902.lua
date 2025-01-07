Config = Config or {}
Config.Entity2030902 = Config.Entity2030902 or { }
local empty = { }
Config.Entity2030902 = 
{
  [ 2030902 ] = {
    EntityId = 2030902,
    Components = {
      Transform = {
        Prefab = "CommonEntity/CoffeeDoor/Prefab/CoffeeDoor02.prefab",
        Model = "CoffeeDoor02",
        isClone = false,
        MinDistance = 0.0,
        MaxDistance = 1.0,
        MinTranslucent = 0.0,
        MaxTranslucent = 0.8,
        TranslucentHeight = 1.8,
        LodRes = false,
        localEntity = false,
        IsEffectResType = false
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
          "2030902"
        },
      },
      Buff = empty,
      Tag = {
        Tag = 3,
        NpcTag = 2,
        SceneObjectTag = 3,
        PartTag = 1,
        AttackType = 1,
        Priority = 0
      },
      Animator = {
        Animator = "CommonEntity/CoffeeDoor/Animation/CoffeeDoor02.controller",
        AnimationConfigID = "",

      },
      Trigger = {
        TriggerType = 0,
        Offset = { 0.0, 0.0, 0.0 },
        DurationTime = -1.0,
        BlockWall = false,
        BlockWallOffectHight = 1.0,
        OutScreen = false,
        ShapeType = 2,
        EnterBehaviorAlways = true,
        Radius = 0.0,
        RadiusOut = 0.0,
        EnterHeight = 0.0,
        LeftHeight = 0.0,
        CubeIng = { 3.0, 3.0, 4.0 },
        CubeOut = { 4.0, 4.0, 5.0 },
        SetOutOffset = false,
        OutOffset = { 0.0, 0.0, 0.0 },      }
    }
  }
}
