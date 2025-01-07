Config = Config or {}
Config.Entity2030409 = Config.Entity2030409 or { }
local empty = { }
Config.Entity2030409 = 
{
  [ 2030409 ] = {
    EntityId = 2030409,
    Components = {
      Transform = {
        Prefab = "CommonEntity/OpenWorldChallenge/Prefab/Challenge_fight.prefab",
        Model = "Metal",
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
          "2030409"
        },
      },
      Buff = empty,
      Tag = {
        Tag = 3,
        NpcTag = 2,
        SceneObjectTag = 0,
        PartTag = 1,
        AttackType = 1,
        Priority = 0
      },
      Trigger = {
        TriggerIcon = "Textures/Icon/Single/FuncIcon/Trigger_door.png",
        TriggerText = "开启挑战",
        TriggerType = 0,
        Offset = { 0.0, 0.0, 0.0 },
        DurationTime = -1.0,
        BlockWall = false,
        BlockWallOffectHight = 1.0,
        OutScreen = false,
        ShapeType = 1,
        EnterBehaviorAlways = true,
        Radius = 3.0,
        RadiusOut = 3.0,
        EnterHeight = 0.0,
        LeftHeight = 0.0,
        CubeIng = { 0.0, 0.0, 0.0 },
        CubeOut = { 0.0, 0.0, 0.0 },
        SetOutOffset = false,
        OutOffset = { 0.0, 0.0, 0.0 },      }
    }
  },
  [ 203040901 ] = {
    EntityId = 203040901,
    Components = {
      Transform = {
        Prefab = "CommonEntity/OpenWorldChallenge/Prefab/Challenge_fight02.prefab",
        Model = "Cube",
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
      Tag = {
        Tag = 3,
        NpcTag = 2,
        SceneObjectTag = 0,
        Camp = 2,
        PartTag = 1,
        AttackType = 1,
        Priority = 0
      },
      Time = {
        DefalutTimeScale = 1.0
      },
      Buff = empty,
      TimeoutDeath = {
        Frame = -1,
        RemoveDelayFrame = 0,
      }
    }
  }
}
