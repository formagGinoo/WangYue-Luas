Config = Config or {}
Config.Entity2020902 = Config.Entity2020902 or { }
local empty = { }
Config.Entity2020902 = 
{
  [ 2020902 ] = {
    EntityId = 2020902,
    Components = {
      Transform = {
        Prefab = "CommonEntity/Chair/PVChair.prefab",
        Model = "Chunk_Chazhuo_10020004_01b_City",
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
      Tag = {
        Tag = 3,
        NpcTag = 0,
        SceneObjectTag = 0,
        Camp = 1,
        PartTag = 1
      },
      Time = {
        DefalutTimeScale = 1.0
      },
      Trigger = {
        TriggerIcon = "Textures/Icon/Single/FuncIcon/Trigger_look.png",
        TriggerText = "坐下",
        TriggerType = 0,
        Offset = { 0.895, 0.042, -0.869 },
        DurationTime = -1.0,
        ShapeType = 1,
        EnterBehaviorAlways = false,
        Radius = 0.5,
        RadiusOut = 1.0,
        EnterHeight = 0.0,
        LeftHeight = 0.0,
        CubeIng = { 0.0, 0.0, 0.0 },
        CubeOut = { 0.0, 0.0, 0.0 },
        SetOutOffset = false,
        OutOffset = { 0.0, 0.0, 0.0 },      },
      Behavior = {
        Behaviors = {
          "2020902"
        },
      },
      CommonBehavior = {
        CommonBehaviors = {
          Anim = {
            ComponentBehaviorName = "CommonAnimBehavior",

          }
        },
        m_commonBehaviorsAnim = {
          StartBehaviorAnim = {
            m_isUsePreciseMoveTo = true,
            m_preciseMoveFrame = 1.0,
            m_checkName = "SitR_in",
            m_heroAnimName = "SitR_in",
            m_animName = ""
          },
          EndBehaviorAnim = {
            m_isUsePreciseMoveTo = true,
            m_preciseMoveFrame = 1.0,
            m_checkName = "SitR_end",
            m_heroAnimName = "SitR_end",
            m_animName = ""
          }
        }
      }
    }
  }
}
