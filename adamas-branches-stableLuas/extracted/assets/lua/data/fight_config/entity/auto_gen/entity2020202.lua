Config = Config or {}
Config.Entity2020202 = Config.Entity2020202 or { }
local empty = { }
Config.Entity2020202 = 
{
  [ 2020202 ] = {
    EntityId = 2020202,
    Components = {
      Transform = {
        Prefab = "Scene/Common/Effect/01/Prefab/FXSceneInteraction.prefab",
        Model = "FXSceneInteraction",
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
        Animator = "CommonEntity/Guide/FxGuide.controller",
        AnimationConfigID = "",

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
        TriggerIcon = "Textures/UI/Story/icon_dialog_talk.png",
        TriggerText = "调查",
        TriggerType = 0,
        Offset = { 0.0, 0.0, 0.0 },
        DurationTime = -1.0,
        ShapeType = 1,
        EnterBehaviorAlways = false,
        Radius = 3.0,
        RadiusOut = 4.0,
        EnterHeight = 0.0,
        LeftHeight = 0.0,
        CubeIng = { 0.0, 0.0, 0.0 },
        CubeOut = { 0.0, 0.0, 0.0 },
        SetOutOffset = false,
        OutOffset = { 0.0, 0.0, 0.0 },      }
    }
  }
}
