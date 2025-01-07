Config = Config or {}
Config.Entity2030905 = Config.Entity2030905 or { }
local empty = { }
Config.Entity2030905 = 
{
  [ 2030905 ] = {
    EntityId = 2030905,
    Components = {
      Transform = {
        Prefab = "CommonEntity/Pipe/Prefab/Pipe03.prefab",
        Model = "Pipe03",
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
      Time = {
        DefalutTimeScale = 1.0
      },
      Buff = empty,
      Trigger = {
        TriggerIcon = "Textures/Icon/Single/FuncIcon/Trigger_door.png",
        TriggerText = "穿梭",
        TriggerType = 0,
        Offset = { 0.0, 0.0, 0.0 },
        DurationTime = -1.0,
        BlockWall = false,
        BlockWallOffectHight = 1.0,
        OutScreen = false,
        ShapeType = 1,
        EnterBehaviorAlways = true,
        Radius = 2.0,
        RadiusOut = 3.0,
        EnterHeight = 0.0,
        LeftHeight = 0.0,
        CubeIng = { 0.0, 0.0, 0.0 },
        CubeOut = { 0.0, 0.0, 0.0 },
        SetOutOffset = false,
        OutOffset = { 0.0, 0.0, 0.0 },      },
      Tag = {
        Tag = 3,
        NpcTag = 0,
        SceneObjectTag = 3,
        Camp = 1,
        PartTag = 1,
        AttackType = 1,
        Priority = 0
      },
      CommonBehavior = {
        CommonBehaviors = {
          AtomizePoint = {
            ComponentBehaviorName = "CommonAtomizePointBehavior",
            NewCommonBehaviorParms = {
              [ "环境类型" ] = 2.0,
              [ "穿梭方向" ] = 3.0,
              [ "水平视野转动范围" ] = 180.0,
              [ "垂直视野转动范围" ] = 90.0
            }
          }
        },        m_PartnerHShowTime = 0.0,
        m_PlayerOTime = 0.0,
        m_RoleHShowTime = 0.0,
        m_PartnerOTime = 0.0,
        m_SwitchBtn = false
      },
      Behavior = {
        Behaviors = {
          "2030905"
        },
      },
      Animator = {
        Animator = "CommonEntity/Pipe/Animation/PipeAni.controller",
        AnimationConfigID = "",

      }
    }
  }
}
