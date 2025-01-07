Config = Config or {}
Config.Entity2020105 = Config.Entity2020105 or { }
local empty = { }
Config.Entity2020105 = 
{
  [ 2020105 ] = {
    EntityId = 2020105,
    Components = {
      Transform = {
        Prefab = "CommonEntity/BigBellTower/Prefab/BigBellTower.prefab",
        Model = "BigBellTower",
        isClone = false,
        MinDistance = 0.0,
        MaxDistance = 1.0,
        MinTranslucent = 0.0,
        MaxTranslucent = 0.8,
        TranslucentHeight = 1.8,
        LodRes = true,
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
      Trigger = {
        TriggerIcon = "Textures/Icon/Single/FuncIcon/Trigger_Transform.png",
        TriggerText = "敲钟",
        TriggerType = 0,
        Offset = { 0.0, 50.0, 0.0 },
        DurationTime = -1.0,
        BlockWall = false,
        BlockWallOffectHight = 1.0,
        OutScreen = false,
        ShapeType = 2,
        EnterBehaviorAlways = true,
        Radius = 3.0,
        RadiusOut = 5.0,
        EnterHeight = 0.0,
        LeftHeight = 0.0,
        CubeIng = { 5.0, 5.0, 5.0 },
        CubeOut = { 5.0, 5.0, 5.0 },
        SetOutOffset = false,
        OutOffset = { 0.0, 0.0, 0.0 },      },
      Behavior = {
        Behaviors = {
          "2020105"
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
      }
    }
  }
}
