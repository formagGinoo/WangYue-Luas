Config = Config or {}
Config.Entity2020801 = Config.Entity2020801 or { }
local empty = { }
Config.Entity2020801 = 
{
  [ 2020801 ] = {
    EntityId = 2020801,
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
        localEntity = false,
        IsEffectResType = false
      },
      Trigger = {
        TriggerIcon = "Textures/Icon/Single/FuncIcon/Map_mercenary.png",
        TriggerText = "开始挑战",
        TriggerType = 4,
        Offset = { 0.0, 0.0, 0.0 },
        DurationTime = -1.0,
        BlockWall = false,
        BlockWallOffectHight = 1.0,
        OutScreen = false,
        ShapeType = 1,
        EnterBehaviorAlways = false,
        Radius = 5.0,
        RadiusOut = 6.0,
        EnterHeight = 0.0,
        LeftHeight = 0.0,
        CubeIng = { 3.0, 3.0, 3.0 },
        CubeOut = { 5.0, 5.0, 5.0 },
        SetOutOffset = false,
        OutOffset = { 0.0, 0.0, 0.0 },      },
      Tag = {
        Tag = 3,
        NpcTag = 5,
        SceneObjectTag = 0,
        Camp = 1,
        PartTag = 1,
        AttackType = 1,
        Priority = 0
      },
      Behavior = {
        Behaviors = {
          "2020801"
        },
      },
      Effect = {
        IsHang = false,
        IsBind = false,
        IsBindWeapon = false,
        BindOffset = { 0.0, 0.0, 0.0 },
        ScaleOffset = { 0.1, 0.1, 0.1 },
        HitEffectBornType = 1,
        HitEffectOffsetY = 0.0,
        IsHeightLimit = false
      }
    }
  }
}
