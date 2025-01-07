Config = Config or {}
Config.Entity2010103 = Config.Entity2010103 or { }
local empty = { }
Config.Entity2010103 = 
{
  [ 2010103 ] = {
    EntityId = 2010103,
    EntityName = "2010103",
    Components = {
      Transform = {
        Prefab = "CommonEntity/TreasureBox/Prefab/TreasureBox_Yingyin.prefab",
        StartRotateType = 0,
        StartRotateX = 0.0,
        RandomMinX = 0.0,
        RandomMaxX = 0.0,
        StartRotateY = 0.0,
        RandomMinY = 0.0,
        RandomMaxY = 0.0,
        StartRotateZ = 0.0,
        RandomMinZ = 0.0,
        RandomMaxZ = 0.0,
        BoneName = "HitCase",
        MinDistance = 0.0,
        MaxDistance = 1.0,
        MinTranslucent = 0.0,
        MaxTranslucent = 0.8
      },
      Animator = {
        Animator = "CommonEntity/TreasureBox/Animation/TreasureBox.controller",
        AnimationConfigID = "",

      },
      Trigger = {
        Offset = { 0.0, 0.0, 0.0 },
        ShapeType = 1,
        EnterBehaviorAlways = true,
        Radius = 2.0,
        RadiusOut = 3.0,
        CubeIng = { 0.0, 0.0, 0.0 },
        CubeOut = { 0.0, 0.0, 0.0 }
      },
      TimeoutDeath = {
        Frame = -1,
        RemoveDelayFrame = 0,
      },
      Camp = {
        Camp = 1
      },
      Tag = {
        Tag = 3,
        NpcTag = 0,
        PartTag = 1
      },
      Time = {
        DefalutTimeScale = 1.0
      },
      Behavior = {
        Behaviors = {
          "2010101"
        },
      },
      Buff = empty}
  }
}
