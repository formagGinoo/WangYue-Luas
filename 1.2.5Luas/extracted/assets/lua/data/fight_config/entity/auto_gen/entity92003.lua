Config = Config or {}
Config.Entity92003 = Config.Entity92003 or { }
local empty = { }
Config.Entity92003 = 
{
  [ 92003 ] = {
    EntityId = 92003,
    EntityName = "92003",
    Components = {
      Transform = {
        Prefab = "Character/Monster/Shentu/ShentuMb1Low/ShentuMb1.prefab",
        isClone = false,
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
      Skill = {
        Skills = {
          [ 92003001 ] = {
            TotalFrame = 80,
            ForceFrame = 68,
            SkillBreakSkillFrame = 68,
            SkillType = 0,
            AttrType = 5,
            UseCostType = 0,
            UseCostValue = 0,
            CDtime = 0.0,
            FrameEvent = {
              [ 0 ] = {
                {

                  AddType = 1,
                  BuffId = 92003104,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 0,
                  EventType = 9,
                  ActiveSign = {
                    Sign = {
                      123123
                    },
                  }
                },
                {

                  Name = "Attack026",
                  StartFrame = 0,
                  FrameTime = 0,
                  EventType = 2,

                },
                {

                  AddType = 1,
                  BuffId = 92003997,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 0,
                  EventType = 9,

                }
              },
              [ 6 ] = {
                {

                  RotateType = 2,
                  UseSelfSpeed = 0,
                  SpeedOffset = 180.0,
                  Acceleration = 360.0,
                  RotateFrame = 6,
                  FrameTime = 6,
                  EventType = 8,

                }
              },
              [ 29 ] = {
                {

                  RotateType = 2,
                  UseSelfSpeed = 0,
                  SpeedOffset = 360.0,
                  Acceleration = 360.0,
                  RotateFrame = 4,
                  FrameTime = 29,
                  EventType = 8,

                }
              },
              [ 50 ] = {
                {

                  AddType = 2,
                  BuffId = 92003104,
                  LifeBindBuff = false,
                  Count = 1,
                  FrameTime = 50,
                  EventType = 9,

                }
              },
              [ 60 ] = {
                {

                  AddType = 2,
                  BuffId = 92003997,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 60,
                  EventType = 9,

                }
              },
            }
          },
          [ 92003003 ] = {
            TotalFrame = 35,
            ForceFrame = 29,
            SkillType = 0,
            AttrType = 5,
            UseCostType = 0,
            UseCostValue = 0,
            CDtime = 0.0,
            FrameEvent = {
              [ 0 ] = {
                {

                  AddType = 1,
                  BuffId = 92003104,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 0,
                  EventType = 9,
                  ActiveSign = {
                    Sign = {
                      123123
                    },
                  }
                },
                {

                  RotateType = 2,
                  UseSelfSpeed = 0,
                  SpeedOffset = 360.0,
                  Acceleration = 360.0,
                  RotateFrame = 27,
                  FrameTime = 0,
                  EventType = 8,

                },
                {

                  AddType = 1,
                  BuffId = 92003997,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 0,
                  EventType = 9,

                }
              },
              [ 6 ] = {
                {

                  Name = "Attack003",
                  StartFrame = 0,
                  FrameTime = 6,
                  EventType = 2,

                }
              },
              [ 33 ] = {
                {

                  AddType = 2,
                  BuffId = 92003104,
                  LifeBindBuff = false,
                  Count = 1,
                  FrameTime = 33,
                  EventType = 9,

                },
                {

                  AddType = 2,
                  BuffId = 92003997,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 33,
                  EventType = 9,

                }
              },
            }
          },
          [ 92003004 ] = {
            TotalFrame = 96,
            ForceFrame = 95,
            SkillBreakSkillFrame = 95,
            SkillType = 0,
            AttrType = 5,
            UseCostType = 0,
            UseCostValue = 0,
            CDtime = 0.0,
            FrameEvent = {
              [ 0 ] = {
                {

                  Name = "Attack006",
                  StartFrame = 0,
                  FrameTime = 0,
                  EventType = 2,

                },
                {

                  AddType = 1,
                  BuffId = 92003997,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 0,
                  EventType = 9,

                }
              },
              [ 6 ] = {
                {

                  RotateType = 2,
                  UseSelfSpeed = 0,
                  SpeedOffset = 180.0,
                  Acceleration = 180.0,
                  RotateFrame = 16,
                  FrameTime = 6,
                  EventType = 8,

                }
              },
              [ 11 ] = {
                {

                  EntityId = 9200399907,
                  LifeBindSkill = false,
                  CreateEntityType = 1,
                  BindTransform = "LeftEyeCase",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 0.0,
                  BornOffsetZ = 0.0,
                  TerriaOffsetY = 0.0,
                  BornRotateOffsetX = 0.0,
                  BornRotateOffsetY = 0.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = false,
                  LookAngleRange = 360.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 11,
                  EventType = 1,

                }
              },
              [ 30 ] = {
                {

                  RotateType = 2,
                  UseSelfSpeed = 0,
                  SpeedOffset = 180.0,
                  Acceleration = 180.0,
                  RotateFrame = 8,
                  FrameTime = 30,
                  EventType = 8,

                }
              },
              [ 31 ] = {
                {

                  EntityId = 92003006001,
                  LifeBindSkill = false,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 0.0,
                  BornOffsetZ = 0.0,
                  TerriaOffsetY = 0.0,
                  BornRotateOffsetX = 0.0,
                  BornRotateOffsetY = 0.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = false,
                  LookAngleRange = 360.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 31,
                  EventType = 1,

                },
                {

                  EntityId = 9200300601,
                  LifeBindSkill = false,
                  LifeBindSkillFrame = 0,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 0.0,
                  BornOffsetZ = 0.0,
                  TerriaOffsetY = 0.0,
                  BornRotateOffsetX = 0.0,
                  BornRotateOffsetY = 0.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = false,
                  LookAngleRange = 360.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 31,
                  EventType = 1,

                }
              },
              [ 40 ] = {
                {

                  AddType = 2,
                  BuffId = 92003997,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 40,
                  EventType = 9,

                }
              },
              [ 75 ] = {
                {

                  RotateType = 2,
                  UseSelfSpeed = 0,
                  SpeedOffset = 180.0,
                  Acceleration = 360.0,
                  RotateFrame = 10,
                  FrameTime = 75,
                  EventType = 8,
                  ActiveSign = {
                    Sign = {
                      9999
                    },
                  }
                }
              },
            }
          },
          [ 92003005 ] = {
            TotalFrame = 120,
            ForceFrame = 118,
            SkillType = 0,
            AttrType = 5,
            UseCostType = 0,
            UseCostValue = 0,
            CDtime = 0.0,
            FrameEvent = {
              [ 0 ] = {
                {

                  Name = "Attack005",
                  StartFrame = 0,
                  FrameTime = 0,
                  EventType = 2,

                },
                {

                  AddType = 1,
                  BuffId = 92003997,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 0,
                  EventType = 9,

                }
              },
              [ 3 ] = {
                {

                  RotateType = 2,
                  UseSelfSpeed = 0,
                  SpeedOffset = 180.0,
                  Acceleration = 180.0,
                  RotateFrame = 14,
                  FrameTime = 3,
                  EventType = 8,
                  ActiveSign = {
                    Sign = {
                      9999
                    },
                  }
                }
              },
              [ 23 ] = {
                {

                  EntityId = 9200399907,
                  LifeBindSkill = false,
                  CreateEntityType = 1,
                  BindTransform = "LeftEyeCase",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 0.0,
                  BornOffsetZ = 0.0,
                  TerriaOffsetY = 0.0,
                  BornRotateOffsetX = 0.0,
                  BornRotateOffsetY = 0.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = false,
                  LookAngleRange = 360.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 23,
                  EventType = 1,

                }
              },
              [ 30 ] = {
                {

                  RotateType = 2,
                  UseSelfSpeed = 0,
                  SpeedOffset = 180.0,
                  Acceleration = 360.0,
                  RotateFrame = 10,
                  FrameTime = 30,
                  EventType = 8,
                  ActiveSign = {
                    Sign = {
                      9999
                    },
                  }
                }
              },
              [ 42 ] = {
                {

                  EntityId = 92003005002,
                  LifeBindSkill = false,
                  LifeBindSkillFrame = 0,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 0.0,
                  BornOffsetZ = 0.0,
                  TerriaOffsetY = 0.0,
                  BornRotateOffsetX = 0.0,
                  BornRotateOffsetY = 0.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = false,
                  LookAngleRange = 360.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 42,
                  EventType = 1,

                }
              },
              [ 43 ] = {
                {

                  EntityId = 92003005001,
                  LifeBindSkill = false,
                  LifeBindSkillFrame = 0,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 0.0,
                  BornOffsetZ = 0.0,
                  TerriaOffsetY = 0.0,
                  BornRotateOffsetX = 0.0,
                  BornRotateOffsetY = 0.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = false,
                  LookAngleRange = 360.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 43,
                  EventType = 1,

                },
                {

                  PostProcessType = 2,
                  PostProcessParams = {
                    Strength = 0.2,
                    Dir = 0,
                    Radius = 1.0,
                    Alpha = 0.6,
                    AlphaCurveId = 1501,
                    Direction = 0,
                    Count = 4,
                    Center = { 0.6, -1.0 },
                    ShowTemplateID = false,
                    TemplateID = 92003005,
                    PostProcessType = 2,
                    Duration = 3,
                    ID = 0
                  },
                  LifeBindSkill = false,
                  FrameTime = 43,
                  EventType = 16,

                },
                {

                  EntityId = 9200300502,
                  LifeBindSkill = false,
                  LifeBindSkillFrame = 0,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 0.0,
                  BornOffsetZ = 0.0,
                  TerriaOffsetY = 0.0,
                  BornRotateOffsetX = 0.0,
                  BornRotateOffsetY = 0.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = false,
                  LookAngleRange = 0.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 43,
                  EventType = 1,

                }
              },
              [ 44 ] = {
                {

                  CameraShake = {
                    {
                      ShakeType = 3,
                      Random = 0.0,
                      StartOffset = 0.0,
                      StartAmplitude = 2.0,
                      StartFrequency = 6.0,
                      TargetAmplitude = 0.2,
                      TargetFrequency = 12.0,
                      AmplitudeChangeTime = 0.231,
                      FrequencyChangeTime = 0.264,
                      DurationTime = 0.495,
                      Sign = 0.0,
                      DistanceDampingId = 0.0
                    }
                  },
                  FrameTime = 44,
                  EventType = 4,

                }
              },
              [ 55 ] = {
                {

                  AddType = 2,
                  BuffId = 92003997,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 55,
                  EventType = 9,

                }
              },
              [ 95 ] = {
                {

                  RotateType = 2,
                  UseSelfSpeed = 0,
                  SpeedOffset = 180.0,
                  Acceleration = 180.0,
                  RotateFrame = 8,
                  FrameTime = 95,
                  EventType = 8,
                  ActiveSign = {
                    Sign = {
                      9999
                    },
                  }
                }
              },
            }
          },
          [ 92003006 ] = {
            TotalFrame = 96,
            ForceFrame = 95,
            SkillBreakSkillFrame = 51,
            SkillType = 0,
            AttrType = 5,
            UseCostType = 0,
            UseCostValue = 0,
            CDtime = 0.0,
            FrameEvent = {
              [ 0 ] = {
                {

                  Name = "Attack006",
                  StartFrame = 0,
                  FrameTime = 0,
                  EventType = 2,

                },
                {

                  AddType = 1,
                  BuffId = 92003997,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 0,
                  EventType = 9,

                }
              },
              [ 6 ] = {
                {

                  RotateType = 2,
                  UseSelfSpeed = 0,
                  SpeedOffset = 180.0,
                  Acceleration = 180.0,
                  RotateFrame = 16,
                  FrameTime = 6,
                  EventType = 8,

                }
              },
              [ 10 ] = {
                {

                  EntityId = 9200399907,
                  LifeBindSkill = false,
                  CreateEntityType = 1,
                  BindTransform = "LeftEyeCase",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 0.0,
                  BornOffsetZ = 0.0,
                  TerriaOffsetY = 0.0,
                  BornRotateOffsetX = 0.0,
                  BornRotateOffsetY = 0.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = false,
                  LookAngleRange = 360.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 10,
                  EventType = 1,

                }
              },
              [ 29 ] = {
                {

                  EntityId = 92003006001,
                  LifeBindSkill = false,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 0.0,
                  BornOffsetZ = 0.0,
                  TerriaOffsetY = 0.0,
                  BornRotateOffsetX = 0.0,
                  BornRotateOffsetY = 0.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = false,
                  LookAngleRange = 360.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 29,
                  EventType = 1,

                },
                {

                  EntityId = 9200300601,
                  LifeBindSkill = false,
                  LifeBindSkillFrame = 0,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 0.0,
                  BornOffsetZ = 0.0,
                  TerriaOffsetY = 0.0,
                  BornRotateOffsetX = 0.0,
                  BornRotateOffsetY = 0.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = false,
                  LookAngleRange = 360.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 29,
                  EventType = 1,

                }
              },
              [ 30 ] = {
                {

                  RotateType = 2,
                  UseSelfSpeed = 0,
                  SpeedOffset = 180.0,
                  Acceleration = 180.0,
                  RotateFrame = 8,
                  FrameTime = 30,
                  EventType = 8,

                }
              },
              [ 51 ] = {
                {

                  Type = 92003006,
                  Frame = 1,
                  FrameTime = 51,
                  EventType = 3,
                  ActiveSign = {
                    Sign = {
                      8888
                    },
                  }
                }
              },
              [ 73 ] = {
                {

                  AddType = 2,
                  BuffId = 92003997,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 73,
                  EventType = 9,

                }
              },
              [ 75 ] = {
                {

                  RotateType = 2,
                  UseSelfSpeed = 0,
                  SpeedOffset = 180.0,
                  Acceleration = 360.0,
                  RotateFrame = 10,
                  FrameTime = 75,
                  EventType = 8,
                  ActiveSign = {
                    Sign = {
                      9999
                    },
                  }
                }
              },
            }
          },
          [ 92003007 ] = {
            TotalFrame = 111,
            ForceFrame = 100,
            SkillType = 0,
            AttrType = 5,
            UseCostType = 0,
            UseCostValue = 0,
            CDtime = 0.0,
            FrameEvent = {
              [ 0 ] = {
                {

                  Name = "Attack007",
                  StartFrame = 0,
                  FrameTime = 0,
                  EventType = 2,

                },
                {

                  AddType = 1,
                  BuffId = 92003997,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 0,
                  EventType = 9,

                }
              },
              [ 26 ] = {
                {

                  EntityId = 9200399907,
                  LifeBindSkill = false,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 0.0,
                  BornOffsetZ = 0.0,
                  TerriaOffsetY = 0.0,
                  BornRotateOffsetX = 0.0,
                  BornRotateOffsetY = 0.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = false,
                  LookAngleRange = 360.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 26,
                  EventType = 1,

                }
              },
              [ 27 ] = {
                {

                  RotateType = 2,
                  UseSelfSpeed = 0,
                  SpeedOffset = 180.0,
                  Acceleration = 360.0,
                  RotateFrame = 26,
                  FrameTime = 27,
                  EventType = 8,
                  ActiveSign = {
                    Sign = {
                      9999
                    },
                  }
                }
              },
              [ 45 ] = {
                {

                  EntityId = 92003007001,
                  LifeBindSkill = false,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 0.0,
                  BornOffsetZ = 0.0,
                  TerriaOffsetY = 0.0,
                  BornRotateOffsetX = 0.0,
                  BornRotateOffsetY = 0.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = false,
                  LookAngleRange = 360.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 45,
                  EventType = 1,

                }
              },
              [ 46 ] = {
                {

                  EntityId = 9200300701,
                  LifeBindSkill = false,
                  LifeBindSkillFrame = 0,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 0.0,
                  BornOffsetZ = 0.0,
                  TerriaOffsetY = 0.0,
                  BornRotateOffsetX = 0.0,
                  BornRotateOffsetY = 0.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = false,
                  LookAngleRange = 360.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 46,
                  EventType = 1,

                }
              },
              [ 80 ] = {
                {

                  AddType = 2,
                  BuffId = 92003997,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 80,
                  EventType = 9,

                }
              },
            }
          },
          [ 92003008 ] = {
            TotalFrame = 155,
            ForceFrame = 146,
            SkillType = 0,
            AttrType = 5,
            UseCostType = 0,
            UseCostValue = 0,
            CDtime = 0.0,
            FrameEvent = {
              [ 0 ] = {
                {

                  Name = "Attack008",
                  StartFrame = 0,
                  FrameTime = 0,
                  EventType = 2,

                },
                {

                  AddType = 1,
                  BuffId = 92003997,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 0,
                  EventType = 9,

                }
              },
              [ 1 ] = {
                {

                  AddType = 1,
                  BuffId = 92003996,
                  LifeBindBuff = false,
                  Count = 1,
                  FrameTime = 1,
                  EventType = 9,

                }
              },
              [ 3 ] = {
                {

                  EntityId = 9200399907,
                  LifeBindSkill = false,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 0.0,
                  BornOffsetZ = 0.0,
                  TerriaOffsetY = 0.0,
                  BornRotateOffsetX = 0.0,
                  BornRotateOffsetY = 0.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = false,
                  LookAngleRange = 360.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 3,
                  EventType = 1,

                }
              },
              [ 7 ] = {
                {

                  AddType = 2,
                  BuffId = 92003996,
                  LifeBindBuff = false,
                  Count = 1,
                  FrameTime = 7,
                  EventType = 9,

                },
                {

                  RotateType = 2,
                  UseSelfSpeed = 0,
                  SpeedOffset = 360.0,
                  Acceleration = 360.0,
                  RotateFrame = 11,
                  FrameTime = 7,
                  EventType = 8,

                }
              },
              [ 13 ] = {
                {

                  EntityId = 92003008001,
                  LifeBindSkill = false,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 0.0,
                  BornOffsetZ = 0.0,
                  TerriaOffsetY = 0.0,
                  BornRotateOffsetX = 0.0,
                  BornRotateOffsetY = 0.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = false,
                  LookAngleRange = 360.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 13,
                  EventType = 1,

                },
                {

                  EntityId = 9200300801,
                  LifeBindSkill = false,
                  LifeBindSkillFrame = 0,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 0.0,
                  BornOffsetZ = 0.0,
                  TerriaOffsetY = 0.0,
                  BornRotateOffsetX = 0.0,
                  BornRotateOffsetY = 0.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = false,
                  LookAngleRange = 360.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 13,
                  EventType = 1,

                }
              },
              [ 32 ] = {
                {

                  RotateType = 2,
                  UseSelfSpeed = 0,
                  SpeedOffset = 180.0,
                  Acceleration = 180.0,
                  RotateFrame = 20,
                  FrameTime = 32,
                  EventType = 8,

                }
              },
              [ 33 ] = {
                {

                  EntityId = 9200399907,
                  LifeBindSkill = false,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 0.0,
                  BornOffsetZ = 0.0,
                  TerriaOffsetY = 0.0,
                  BornRotateOffsetX = 0.0,
                  BornRotateOffsetY = 0.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = false,
                  LookAngleRange = 360.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 33,
                  EventType = 1,

                }
              },
              [ 53 ] = {
                {

                  EntityId = 92003008002,
                  LifeBindSkill = false,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 0.0,
                  BornOffsetZ = 0.0,
                  TerriaOffsetY = 0.0,
                  BornRotateOffsetX = 0.0,
                  BornRotateOffsetY = 0.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = false,
                  LookAngleRange = 360.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 53,
                  EventType = 1,

                },
                {

                  EntityId = 9200300802,
                  LifeBindSkill = false,
                  LifeBindSkillFrame = 0,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 0.0,
                  BornOffsetZ = 0.0,
                  TerriaOffsetY = 0.0,
                  BornRotateOffsetX = 0.0,
                  BornRotateOffsetY = 0.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = false,
                  LookAngleRange = 360.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 53,
                  EventType = 1,

                }
              },
              [ 97 ] = {
                {

                  AddType = 2,
                  BuffId = 92003997,
                  LifeBindBuff = true,
                  Count = 99,
                  FrameTime = 97,
                  EventType = 9,

                },
                {

                  RotateType = 2,
                  UseSelfSpeed = 0,
                  SpeedOffset = 90.0,
                  Acceleration = 90.0,
                  RotateFrame = 10,
                  FrameTime = 97,
                  EventType = 8,
                  ActiveSign = {
                    Sign = {
                      9998
                    },
                  }
                }
              },
            }
          },
          [ 92003009 ] = {
            TotalFrame = 107,
            ForceFrame = 107,
            SkillBreakSkillFrame = 107,
            SkillType = 0,
            AttrType = 5,
            UseCostType = 0,
            UseCostValue = 0,
            CDtime = 0.0,
            FrameEvent = {
              [ 0 ] = {
                {

                  AddType = 1,
                  BuffId = 92003997,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 0,
                  EventType = 9,

                },
                {

                  Name = "Attack009",
                  StartFrame = 0,
                  FrameTime = 0,
                  EventType = 2,

                }
              },
              [ 5 ] = {
                {

                  AddType = 1,
                  BuffId = 900000043,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 5,
                  EventType = 9,

                },
                {

                  EntityId = 9200399906,
                  LifeBindSkill = false,
                  CreateEntityType = 1,
                  BindTransform = "LeftEyeCase",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 0.0,
                  BornOffsetZ = 0.0,
                  TerriaOffsetY = 0.0,
                  BornRotateOffsetX = 0.0,
                  BornRotateOffsetY = 0.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = false,
                  LookAngleRange = 360.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 5,
                  EventType = 1,

                }
              },
              [ 14 ] = {
                {

                  RotateType = 2,
                  UseSelfSpeed = 0,
                  SpeedOffset = 180.0,
                  Acceleration = 360.0,
                  RotateFrame = 20,
                  FrameTime = 14,
                  EventType = 8,

                }
              },
              [ 34 ] = {
                {

                  EntityId = 92003009003,
                  LifeBindSkill = false,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 0.0,
                  BornOffsetZ = 0.0,
                  TerriaOffsetY = 0.0,
                  BornRotateOffsetX = 0.0,
                  BornRotateOffsetY = 0.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = false,
                  LookAngleRange = 360.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 34,
                  EventType = 1,

                }
              },
              [ 35 ] = {
                {

                  CameraShake = {
                    {
                      ShakeType = 3,
                      Random = 0.0,
                      StartOffset = 0.0,
                      StartAmplitude = -1.2,
                      StartFrequency = 6.0,
                      TargetAmplitude = 0.0,
                      TargetFrequency = 4.0,
                      AmplitudeChangeTime = 0.33,
                      FrequencyChangeTime = 0.528,
                      DurationTime = 1.0,
                      Sign = 0.0,
                      DistanceDampingId = 0.0
                    }
                  },
                  FrameTime = 35,
                  EventType = 4,

                },
                {

                  PostProcessType = 2,
                  PostProcessParams = {
                    Strength = 0.2,
                    Dir = 0,
                    Radius = 1.0,
                    Alpha = 0.6,
                    AlphaCurveId = 1501,
                    Direction = 0,
                    Count = 4,
                    Center = { 0.6, -1.0 },
                    ShowTemplateID = false,
                    TemplateID = 92003005,
                    PostProcessType = 2,
                    Duration = 3,
                    ID = 0
                  },
                  LifeBindSkill = false,
                  FrameTime = 35,
                  EventType = 16,

                },
                {

                  EntityId = 92003009001,
                  LifeBindSkill = false,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 0.0,
                  BornOffsetZ = 0.0,
                  TerriaOffsetY = 0.0,
                  BornRotateOffsetX = 0.0,
                  BornRotateOffsetY = 0.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = false,
                  LookAngleRange = 360.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 35,
                  EventType = 1,

                },
                {

                  EntityId = 9200300901,
                  LifeBindSkill = false,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 0.0,
                  BornOffsetZ = 0.0,
                  TerriaOffsetY = 0.0,
                  BornRotateOffsetX = 0.0,
                  BornRotateOffsetY = 0.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = false,
                  LookAngleRange = 360.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 35,
                  EventType = 1,

                }
              },
              [ 50 ] = {
                {

                  AddType = 2,
                  BuffId = 92003997,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 50,
                  EventType = 9,

                }
              },
            }
          },
          [ 92003010 ] = {
            TotalFrame = 168,
            ForceFrame = 167,
            SkillBreakSkillFrame = 63,
            SkillType = 0,
            AttrType = 5,
            UseCostType = 0,
            UseCostValue = 0,
            CDtime = 0.0,
            FrameEvent = {
              [ 0 ] = {
                {

                  Name = "Attack010",
                  StartFrame = 0,
                  FrameTime = 0,
                  EventType = 2,

                },
                {

                  AddType = 1,
                  BuffId = 92003997,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 0,
                  EventType = 9,

                }
              },
              [ 2 ] = {
                {

                  RotateType = 2,
                  UseSelfSpeed = 0,
                  SpeedOffset = 90.0,
                  Acceleration = 360.0,
                  RotateFrame = 17,
                  FrameTime = 2,
                  EventType = 8,
                  ActiveSign = {
                    Sign = {
                      9998
                    },
                  }
                }
              },
              [ 27 ] = {
                {

                  Enable = false,
                  FrameTime = 27,
                  EventType = 19,
                  ActiveSign = {
                    Sign = {
                      9994
                    },
                  }
                }
              },
              [ 34 ] = {
                {

                  EntityId = 9200399907,
                  LifeBindSkill = false,
                  CreateEntityType = 1,
                  BindTransform = "LeftEyeCase",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 0.0,
                  BornOffsetZ = 0.0,
                  TerriaOffsetY = 0.0,
                  BornRotateOffsetX = 0.0,
                  BornRotateOffsetY = 0.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = false,
                  LookAngleRange = 360.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 34,
                  EventType = 1,

                }
              },
              [ 39 ] = {
                {

                  Enable = true,
                  FrameTime = 39,
                  EventType = 19,

                }
              },
              [ 44 ] = {
                {

                  RotateType = 2,
                  UseSelfSpeed = 0,
                  SpeedOffset = 180.0,
                  Acceleration = 180.0,
                  RotateFrame = 12,
                  FrameTime = 44,
                  EventType = 8,
                  ActiveSign = {
                    Sign = {
                      9996
                    },
                  }
                }
              },
              [ 51 ] = {
                {

                  EntityId = 92003010001,
                  LifeBindSkill = false,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 0.0,
                  BornOffsetZ = 0.0,
                  TerriaOffsetY = 0.0,
                  BornRotateOffsetX = 0.0,
                  BornRotateOffsetY = 0.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = false,
                  LookAngleRange = 360.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 51,
                  EventType = 1,

                },
                {

                  EntityId = 9200301001,
                  LifeBindSkill = false,
                  LifeBindSkillFrame = 0,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 0.0,
                  BornOffsetZ = 0.0,
                  TerriaOffsetY = 0.0,
                  BornRotateOffsetX = 0.0,
                  BornRotateOffsetY = 0.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = false,
                  LookAngleRange = 0.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 51,
                  EventType = 1,

                }
              },
              [ 68 ] = {
                {

                  Type = 92003010,
                  Frame = 10,
                  FrameTime = 68,
                  EventType = 3,
                  ActiveSign = {
                    Sign = {
                      9999
                    },
                  }
                }
              },
              [ 83 ] = {
                {

                  RotateType = 2,
                  UseSelfSpeed = 0,
                  SpeedOffset = 180.0,
                  Acceleration = 180.0,
                  RotateFrame = 30,
                  FrameTime = 83,
                  EventType = 8,
                  ActiveSign = {
                    Sign = {
                      9992
                    },
                  }
                }
              },
              [ 128 ] = {
                {

                  AddType = 2,
                  BuffId = 92003997,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 128,
                  EventType = 9,

                }
              },
            }
          },
          [ 92003013 ] = {
            TotalFrame = 113,
            ForceFrame = 113,
            SkillType = 0,
            AttrType = 5,
            UseCostType = 0,
            UseCostValue = 0,
            CDtime = 0.0,
            FrameEvent = {
              [ 0 ] = {
                {

                  Name = "Attack013",
                  StartFrame = 0,
                  FrameTime = 0,
                  EventType = 2,

                },
                {

                  AddType = 1,
                  BuffId = 92003997,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 0,
                  EventType = 9,

                }
              },
              [ 3 ] = {
                {

                  RotateType = 2,
                  UseSelfSpeed = 0,
                  SpeedOffset = 180.0,
                  Acceleration = 180.0,
                  RotateFrame = 14,
                  FrameTime = 3,
                  EventType = 8,

                }
              },
              [ 8 ] = {
                {

                  EntityId = 9200399907,
                  LifeBindSkill = false,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 0.0,
                  BornOffsetZ = 0.0,
                  TerriaOffsetY = 0.0,
                  BornRotateOffsetX = 0.0,
                  BornRotateOffsetY = 0.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = false,
                  LookAngleRange = 360.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 8,
                  EventType = 1,

                }
              },
              [ 23 ] = {
                {                  DurationUpdateTargetFrame = 7,
                  OffsetType = 2,
                  TargetHPositionOffset = 2.0,
                  TargetVPositionOffset = 0.0,
                  TargetRelationOffset = { 0.0, 0.0, 0.0 },
                  DurationMoveFrame = 7,
                  VDurationMoveFrame = -1,
                  IgnoreY = true,
                  MaxSpeed = 90.0,
                  MinSpeed = 0.0,
                  FrameTime = 23,
                  EventType = 18,
                  ActiveSign = {
                    Sign = {
                      123123
                    },
                  }
                }
              },
              [ 24 ] = {
                {

                  Direction = 1,
                  CustomX = 0.0,
                  CustomY = 0.0,
                  CustomZ = 0.0,
                  SpeedType = 1,
                  SpeedOffset = 8.0,
                  Acceleration = -1.0,
                  MoveFrame = 6,
                  InputSpeed = 0.0,
                  MinDistance = 1.0,
                  IgnoreYAxis = false,
                  SkillMoveDone = 3,
                  FrameTime = 24,
                  EventType = 7,

                },
                {

                  RotateType = 2,
                  UseSelfSpeed = 0,
                  SpeedOffset = 180.0,
                  Acceleration = 180.0,
                  RotateFrame = 11,
                  FrameTime = 24,
                  EventType = 8,

                }
              },
              [ 25 ] = {
                {

                  Enable = false,
                  FrameTime = 25,
                  EventType = 19,
                  ActiveSign = {
                    Sign = {
                      123123
                    },
                  }
                }
              },
              [ 35 ] = {
                {

                  Enable = true,
                  FrameTime = 35,
                  EventType = 19,
                  ActiveSign = {
                    Sign = {
                      123123
                    },
                  }
                }
              },
              [ 38 ] = {
                {

                  RotateType = 2,
                  UseSelfSpeed = 0,
                  SpeedOffset = 180.0,
                  Acceleration = 180.0,
                  RotateFrame = 7,
                  FrameTime = 38,
                  EventType = 8,

                }
              },
              [ 44 ] = {
                {

                  EntityId = 9200301301,
                  LifeBindSkill = false,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 0.0,
                  BornOffsetZ = 0.0,
                  TerriaOffsetY = 0.0,
                  BornRotateOffsetX = 0.0,
                  BornRotateOffsetY = 0.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = false,
                  LookAngleRange = 360.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 44,
                  EventType = 1,

                },
                {

                  EntityId = 92003013001,
                  LifeBindSkill = false,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 0.0,
                  BornOffsetZ = 0.0,
                  TerriaOffsetY = 0.0,
                  BornRotateOffsetX = 0.0,
                  BornRotateOffsetY = 0.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = false,
                  LookAngleRange = 360.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 44,
                  EventType = 1,

                }
              },
              [ 60 ] = {
                {

                  AddType = 2,
                  BuffId = 92003997,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 60,
                  EventType = 9,

                }
              },
              [ 72 ] = {
                {

                  AddType = 1,
                  BuffId = 92003996,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 72,
                  EventType = 9,

                }
              },
              [ 76 ] = {
                {

                  AddType = 2,
                  BuffId = 92003996,
                  LifeBindBuff = true,
                  Count = 2,
                  FrameTime = 76,
                  EventType = 9,

                }
              },
              [ 91 ] = {
                {

                  RotateType = 2,
                  UseSelfSpeed = 0,
                  SpeedOffset = 180.0,
                  Acceleration = 360.0,
                  RotateFrame = 10,
                  FrameTime = 91,
                  EventType = 8,
                  ActiveSign = {
                    Sign = {
                      9999
                    },
                  }
                }
              },
            }
          },
          [ 92003014 ] = {
            TotalFrame = 110,
            ForceFrame = 110,
            SkillType = 0,
            AttrType = 5,
            UseCostType = 0,
            UseCostValue = 0,
            CDtime = 0.0,
            FrameEvent = {
              [ 0 ] = {
                {

                  Name = "Attack014",
                  StartFrame = 0,
                  FrameTime = 0,
                  EventType = 2,

                },
                {

                  RotateType = 2,
                  UseSelfSpeed = 0,
                  SpeedOffset = 360.0,
                  Acceleration = 360.0,
                  RotateFrame = 27,
                  FrameTime = 0,
                  EventType = 8,

                }
              },
              [ 18 ] = {
                {

                  Direction = 0,
                  CustomX = 0.0,
                  CustomY = 0.0,
                  CustomZ = 0.0,
                  SpeedType = 0,
                  SpeedOffset = 20.0,
                  Acceleration = -5.0,
                  MoveFrame = 10,
                  InputSpeed = 0.0,
                  MinDistance = 2.0,
                  IgnoreYAxis = false,
                  SkillMoveDone = 1,
                  FrameTime = 18,
                  EventType = 7,

                }
              },
              [ 40 ] = {
                {

                  EntityId = 9200301301,
                  LifeBindSkill = false,
                  LifeBindSkillFrame = 0,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 0.0,
                  BornOffsetZ = 0.0,
                  TerriaOffsetY = 0.0,
                  BornRotateOffsetX = 0.0,
                  BornRotateOffsetY = 0.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = false,
                  LookAngleRange = 0.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 40,
                  EventType = 1,

                }
              },
            }
          },
          [ 92003015 ] = {
            TotalFrame = 127,
            ForceFrame = 117,
            SkillBreakSkillFrame = 117,
            SkillType = 0,
            AttrType = 5,
            UseCostType = 0,
            UseCostValue = 0,
            CDtime = 0.0,
            FrameEvent = {
              [ 0 ] = {
                {

                  AddType = 1,
                  BuffId = 92003997,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 0,
                  EventType = 9,

                },
                {

                  RotateType = 2,
                  UseSelfSpeed = 0,
                  SpeedOffset = 60.0,
                  Acceleration = 0.0,
                  RotateFrame = 7,
                  FrameTime = 0,
                  EventType = 8,

                },
                {

                  Name = "Attack015",
                  StartFrame = 0,
                  FrameTime = 0,
                  EventType = 2,

                }
              },
              [ 13 ] = {
                {

                  EntityId = 9200399906,
                  LifeBindSkill = false,
                  CreateEntityType = 1,
                  BindTransform = "LeftEyeCase",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 0.0,
                  BornOffsetZ = 0.0,
                  TerriaOffsetY = 0.0,
                  BornRotateOffsetX = 0.0,
                  BornRotateOffsetY = 0.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = false,
                  LookAngleRange = 360.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 13,
                  EventType = 1,

                }
              },
              [ 15 ] = {
                {                  DurationUpdateTargetFrame = 8,
                  OffsetType = 2,
                  TargetHPositionOffset = 3.0,
                  TargetVPositionOffset = 10.0,
                  TargetRelationOffset = { 0.0, 0.0, 0.0 },
                  DurationMoveFrame = 10,
                  VDurationMoveFrame = -1,
                  IgnoreY = true,
                  MaxSpeed = 90.0,
                  MinSpeed = 0.0,
                  FrameTime = 15,
                  EventType = 18,

                }
              },
              [ 19 ] = {
                {

                  RotateType = 2,
                  UseSelfSpeed = 0,
                  SpeedOffset = 180.0,
                  Acceleration = 0.0,
                  RotateFrame = 29,
                  FrameTime = 19,
                  EventType = 8,

                }
              },
              [ 20 ] = {
                {

                  EntityId = 92003015003,
                  LifeBindSkill = false,
                  LifeBindSkillFrame = 0,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 0.0,
                  BornOffsetZ = 0.0,
                  TerriaOffsetY = 0.0,
                  BornRotateOffsetX = 0.0,
                  BornRotateOffsetY = 0.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = false,
                  LookAngleRange = 0.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 20,
                  EventType = 1,

                }
              },
              [ 25 ] = {
                {

                  AddType = 1,
                  BuffId = 900000043,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 25,
                  EventType = 9,

                }
              },
              [ 27 ] = {
                {

                  AddType = 1,
                  BuffId = 92003998,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 27,
                  EventType = 9,

                }
              },
              [ 32 ] = {
                {

                  AddType = 2,
                  BuffId = 92003998,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 32,
                  EventType = 9,

                }
              },
              [ 44 ] = {
                {                  DurationUpdateTargetFrame = 3,
                  OffsetType = 2,
                  TargetHPositionOffset = 2.0,
                  TargetVPositionOffset = 10.0,
                  TargetRelationOffset = { 0.0, 0.0, 0.0 },
                  DurationMoveFrame = 3,
                  VDurationMoveFrame = -1,
                  IgnoreY = true,
                  MaxSpeed = 30.0,
                  MinSpeed = 0.0,
                  FrameTime = 44,
                  EventType = 18,

                }
              },
              [ 47 ] = {
                {

                  EntityId = 9200301501,
                  LifeBindSkill = false,
                  LifeBindSkillFrame = 0,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 0.0,
                  BornOffsetZ = 0.0,
                  TerriaOffsetY = 0.0,
                  BornRotateOffsetX = 0.0,
                  BornRotateOffsetY = 0.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = false,
                  LookAngleRange = 0.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 47,
                  EventType = 1,

                }
              },
              [ 48 ] = {
                {

                  EntityId = 92003015001,
                  LifeBindSkill = false,
                  LifeBindSkillFrame = 0,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 0.0,
                  BornOffsetZ = 0.0,
                  TerriaOffsetY = 0.0,
                  BornRotateOffsetX = 0.0,
                  BornRotateOffsetY = 0.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = false,
                  LookAngleRange = 0.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 48,
                  EventType = 1,

                },
                {

                  EntityId = 9200301502,
                  LifeBindSkill = false,
                  LifeBindSkillFrame = 0,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 0.0,
                  BornOffsetZ = 0.0,
                  TerriaOffsetY = 0.0,
                  BornRotateOffsetX = 0.0,
                  BornRotateOffsetY = 0.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = false,
                  LookAngleRange = 0.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 48,
                  EventType = 1,

                }
              },
              [ 49 ] = {
                {

                  PostProcessType = 2,
                  PostProcessParams = {
                    Strength = 0.4,
                    Dir = 0,
                    Radius = 1.0,
                    Alpha = 0.8,
                    AlphaCurveId = 1501,
                    Direction = 0,
                    FollowTransform = "ShentuMb1_weapon",
                    Count = 5,
                    Center = { 0.6, -1.0 },
                    ShowTemplateID = false,
                    TemplateID = 0,
                    PostProcessType = 2,
                    Duration = 5,
                    ID = 0
                  },
                  LifeBindSkill = false,
                  FrameTime = 49,
                  EventType = 16,

                },
                {

                  CameraShake = {
                    {
                      ShakeType = 3,
                      Random = 0.0,
                      StartOffset = 0.0,
                      StartAmplitude = 1.4,
                      StartFrequency = 6.0,
                      TargetAmplitude = 0.3,
                      TargetFrequency = 12.0,
                      AmplitudeChangeTime = 0.561,
                      FrequencyChangeTime = 0.363,
                      DurationTime = 0.594,
                      Sign = 0.0,
                      DistanceDampingId = 0.0
                    }
                  },
                  FrameTime = 49,
                  EventType = 4,

                },
                {

                  EntityId = 92003015002,
                  LifeBindSkill = false,
                  LifeBindSkillFrame = 0,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 0.0,
                  BornOffsetZ = 0.0,
                  TerriaOffsetY = 0.0,
                  BornRotateOffsetX = 0.0,
                  BornRotateOffsetY = 0.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = false,
                  LookAngleRange = 0.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 49,
                  EventType = 1,

                }
              },
              [ 65 ] = {
                {

                  AddType = 2,
                  BuffId = 92003997,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 65,
                  EventType = 9,

                }
              },
              [ 98 ] = {
                {

                  RotateType = 2,
                  UseSelfSpeed = 0,
                  SpeedOffset = 180.0,
                  Acceleration = 180.0,
                  RotateFrame = 7,
                  FrameTime = 98,
                  EventType = 8,
                  ActiveSign = {
                    Sign = {
                      9999
                    },
                  }
                }
              },
            }
          },
          [ 92003019 ] = {
            TotalFrame = 100,
            ForceFrame = 100,
            SkillType = 0,
            AttrType = 5,
            UseCostType = 0,
            UseCostValue = 0,
            CDtime = 0.0,
            FrameEvent = {
              [ 0 ] = {
                {

                  AddType = 1,
                  BuffId = 92003997,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 0,
                  EventType = 9,

                },
                {

                  Name = "Attack019",
                  StartFrame = 0,
                  FrameTime = 0,
                  EventType = 2,

                }
              },
              [ 67 ] = {
                {

                  EntityId = 92003019001,
                  LifeBindSkill = false,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 0.0,
                  BornOffsetZ = 0.0,
                  TerriaOffsetY = 0.0,
                  BornRotateOffsetX = 0.0,
                  BornRotateOffsetY = 0.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = false,
                  LookAngleRange = 360.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 67,
                  EventType = 1,

                }
              },
              [ 68 ] = {
                {

                  EntityId = 92003019002,
                  LifeBindSkill = false,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 0.0,
                  BornOffsetZ = 0.0,
                  TerriaOffsetY = 0.0,
                  BornRotateOffsetX = 0.0,
                  BornRotateOffsetY = 0.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = false,
                  LookAngleRange = 360.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 68,
                  EventType = 1,

                },
                {

                  CameraShake = {
                    {
                      ShakeType = 3,
                      Random = 0.0,
                      StartOffset = 0.0,
                      StartAmplitude = 1.0,
                      StartFrequency = 6.0,
                      TargetAmplitude = 0.2,
                      TargetFrequency = 4.0,
                      AmplitudeChangeTime = 0.198,
                      FrequencyChangeTime = 0.231,
                      DurationTime = 0.297,
                      Sign = 0.0,
                      DistanceDampingId = 0.0
                    }
                  },
                  FrameTime = 68,
                  EventType = 4,

                }
              },
              [ 69 ] = {
                {

                  EntityId = 9200301904,
                  LifeBindSkill = false,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 0.0,
                  BornOffsetZ = 0.0,
                  TerriaOffsetY = 0.0,
                  BornRotateOffsetX = 0.0,
                  BornRotateOffsetY = 0.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = false,
                  LookAngleRange = 360.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 69,
                  EventType = 1,

                },
                {

                  EntityId = 9200301903,
                  LifeBindSkill = false,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 0.0,
                  BornOffsetZ = 0.0,
                  TerriaOffsetY = 0.0,
                  BornRotateOffsetX = 0.0,
                  BornRotateOffsetY = 0.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = false,
                  LookAngleRange = 360.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 69,
                  EventType = 1,

                }
              },
              [ 75 ] = {
                {

                  Type = 92003319,
                  Frame = 1,
                  FrameTime = 75,
                  EventType = 3,
                  ActiveSign = {
                    Sign = {
                      123456
                    },
                  }
                }
              },
              [ 100 ] = {
                {

                  Type = 92003019,
                  Frame = 1,
                  FrameTime = 100,
                  EventType = 3,

                }
              },
            }
          },
          [ 92003020 ] = {
            TotalFrame = 248,
            ForceFrame = 247,
            SkillType = 0,
            AttrType = 5,
            UseCostType = 0,
            UseCostValue = 0,
            CDtime = 0.0,
            FrameEvent = {
              [ 0 ] = {
                {

                  AddType = 1,
                  BuffId = 92003997,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 0,
                  EventType = 9,

                },
                {

                  Name = "Attack020",
                  StartFrame = 0,
                  FrameTime = 0,
                  EventType = 2,

                }
              },
              [ 81 ] = {
                {

                  EntityId = 92003020001,
                  LifeBindSkill = false,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 0.0,
                  BornOffsetZ = 0.0,
                  TerriaOffsetY = 0.0,
                  BornRotateOffsetX = 0.0,
                  BornRotateOffsetY = 0.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = false,
                  LookAngleRange = 360.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 81,
                  EventType = 1,

                },
                {

                  CameraShake = {
                    {
                      ShakeType = 3,
                      Random = 0.0,
                      StartOffset = 0.0,
                      StartAmplitude = -0.8,
                      StartFrequency = 8.0,
                      TargetAmplitude = 0.0,
                      TargetFrequency = 6.0,
                      AmplitudeChangeTime = 0.231,
                      FrequencyChangeTime = 0.264,
                      DurationTime = 0.363,
                      Sign = 0.0,
                      DistanceDampingId = 0.0
                    }
                  },
                  FrameTime = 81,
                  EventType = 4,

                },
                {

                  EntityId = 9200302001,
                  LifeBindSkill = false,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 0.0,
                  BornOffsetZ = 0.0,
                  TerriaOffsetY = 0.0,
                  BornRotateOffsetX = 0.0,
                  BornRotateOffsetY = 0.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = false,
                  LookAngleRange = 360.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 81,
                  EventType = 1,

                }
              },
              [ 247 ] = {
                {

                  Type = 92003020,
                  Frame = 1,
                  FrameTime = 247,
                  EventType = 3,

                }
              },
            }
          },
          [ 92003030 ] = {
            TotalFrame = 235,
            ForceFrame = 232,
            SkillBreakSkillFrame = 232,
            SkillType = 0,
            AttrType = 5,
            UseCostType = 0,
            UseCostValue = 0,
            CDtime = 0.0,
            FrameEvent = {
              [ 0 ] = {
                {

                  AddType = 1,
                  BuffId = 92003997,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 0,
                  EventType = 9,

                },
                {

                  Name = "Attack010",
                  StartFrame = 0,
                  FrameTime = 0,
                  EventType = 2,

                }
              },
              [ 2 ] = {
                {

                  RotateType = 2,
                  UseSelfSpeed = 0,
                  SpeedOffset = 90.0,
                  Acceleration = 360.0,
                  RotateFrame = 30,
                  FrameTime = 2,
                  EventType = 8,
                  ActiveSign = {
                    Sign = {
                      9999
                    },
                  }
                }
              },
              [ 27 ] = {
                {

                  Enable = false,
                  FrameTime = 27,
                  EventType = 19,
                  ActiveSign = {
                    Sign = {
                      9994
                    },
                  }
                }
              },
              [ 32 ] = {
                {

                  EntityId = 9200399907,
                  LifeBindSkill = false,
                  CreateEntityType = 1,
                  BindTransform = "LeftEyeCase",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 0.0,
                  BornOffsetZ = 0.0,
                  TerriaOffsetY = 0.0,
                  BornRotateOffsetX = 0.0,
                  BornRotateOffsetY = 0.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = false,
                  LookAngleRange = 360.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 32,
                  EventType = 1,

                }
              },
              [ 39 ] = {
                {

                  Enable = true,
                  FrameTime = 39,
                  EventType = 19,

                }
              },
              [ 40 ] = {
                {

                  RotateType = 2,
                  UseSelfSpeed = 0,
                  SpeedOffset = 180.0,
                  Acceleration = 180.0,
                  RotateFrame = 22,
                  FrameTime = 40,
                  EventType = 8,
                  ActiveSign = {
                    Sign = {
                      9999
                    },
                  }
                }
              },
              [ 45 ] = {
                {

                  Direction = 1,
                  CustomX = 0.0,
                  CustomY = 0.0,
                  CustomZ = 0.0,
                  SpeedType = 1,
                  SpeedOffset = 3.0,
                  Acceleration = 0.0,
                  MoveFrame = 6,
                  InputSpeed = 0.0,
                  MinDistance = 2.0,
                  IgnoreYAxis = false,
                  SkillMoveDone = 1,
                  FrameTime = 45,
                  EventType = 7,

                }
              },
              [ 55 ] = {
                {

                  EntityId = 9200301001,
                  LifeBindSkill = false,
                  LifeBindSkillFrame = 0,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 0.0,
                  BornOffsetZ = 0.0,
                  TerriaOffsetY = 0.0,
                  BornRotateOffsetX = 0.0,
                  BornRotateOffsetY = 0.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = false,
                  LookAngleRange = 0.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 55,
                  EventType = 1,

                },
                {

                  EntityId = 92003010001,
                  LifeBindSkill = false,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 0.0,
                  BornOffsetZ = 0.0,
                  TerriaOffsetY = 0.0,
                  BornRotateOffsetX = 0.0,
                  BornRotateOffsetY = 0.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = false,
                  LookAngleRange = 360.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 55,
                  EventType = 1,

                }
              },
              [ 67 ] = {
                {

                  Name = "Attack008",
                  StartFrame = 25,
                  FrameTime = 67,
                  EventType = 2,

                }
              },
              [ 68 ] = {
                {

                  Type = 92003010,
                  Frame = 10,
                  FrameTime = 68,
                  EventType = 3,
                  ActiveSign = {
                    Sign = {
                      123
                    },
                  }
                }
              },
              [ 74 ] = {
                {

                  RotateType = 2,
                  UseSelfSpeed = 0,
                  SpeedOffset = 180.0,
                  Acceleration = 180.0,
                  RotateFrame = 20,
                  FrameTime = 74,
                  EventType = 8,

                }
              },
              [ 75 ] = {
                {

                  EntityId = 9200399907,
                  LifeBindSkill = false,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 0.0,
                  BornOffsetZ = 0.0,
                  TerriaOffsetY = 0.0,
                  BornRotateOffsetX = 0.0,
                  BornRotateOffsetY = 0.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = false,
                  LookAngleRange = 360.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 75,
                  EventType = 1,

                }
              },
              [ 90 ] = {
                {

                  Direction = 1,
                  CustomX = 0.0,
                  CustomY = 0.0,
                  CustomZ = 0.0,
                  SpeedType = 1,
                  SpeedOffset = 6.0,
                  Acceleration = 0.0,
                  MoveFrame = 4,
                  InputSpeed = 0.0,
                  MinDistance = 2.0,
                  IgnoreYAxis = false,
                  SkillMoveDone = 1,
                  FrameTime = 90,
                  EventType = 7,

                }
              },
              [ 95 ] = {
                {

                  EntityId = 92003008002,
                  LifeBindSkill = false,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 0.0,
                  BornOffsetZ = 0.0,
                  TerriaOffsetY = 0.0,
                  BornRotateOffsetX = 0.0,
                  BornRotateOffsetY = 0.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = false,
                  LookAngleRange = 360.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 95,
                  EventType = 1,

                },
                {

                  EntityId = 9200300802,
                  LifeBindSkill = false,
                  LifeBindSkillFrame = 0,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 0.0,
                  BornOffsetZ = 0.0,
                  TerriaOffsetY = 0.0,
                  BornRotateOffsetX = 0.0,
                  BornRotateOffsetY = 0.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = false,
                  LookAngleRange = 360.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 95,
                  EventType = 1,

                }
              },
              [ 105 ] = {
                {

                  AddType = 2,
                  BuffId = 92003997,
                  LifeBindBuff = true,
                  Count = 99,
                  FrameTime = 105,
                  EventType = 9,

                }
              },
              [ 138 ] = {
                {

                  RotateType = 2,
                  UseSelfSpeed = 0,
                  SpeedOffset = 180.0,
                  Acceleration = 360.0,
                  RotateFrame = 13,
                  FrameTime = 138,
                  EventType = 8,
                  ActiveSign = {
                    Sign = {
                      9995
                    },
                  }
                }
              },
              [ 151 ] = {
                {

                  RotateType = 2,
                  UseSelfSpeed = 0,
                  SpeedOffset = 180.0,
                  Acceleration = 360.0,
                  RotateFrame = 39,
                  FrameTime = 151,
                  EventType = 8,
                  ActiveSign = {
                    Sign = {
                      9996
                    },
                  }
                }
              },
            }
          },
          [ 92003201 ] = {
            TotalFrame = 48,
            ForceFrame = 35,
            SkillBreakSkillFrame = 27,
            SkillType = 0,
            AttrType = 5,
            UseCostType = 0,
            UseCostValue = 0,
            CDtime = 0.0,
            FrameEvent = {
              [ 0 ] = {
                {

                  AddType = 1,
                  BuffId = 92003104,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 0,
                  EventType = 9,

                },
                {

                  Name = "Attack201",
                  StartFrame = 0,
                  FrameTime = 0,
                  EventType = 2,

                },
                {

                  AddType = 1,
                  BuffId = 92003997,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 0,
                  EventType = 9,

                }
              },
              [ 5 ] = {
                {

                  RotateType = 2,
                  UseSelfSpeed = 0,
                  SpeedOffset = 180.0,
                  Acceleration = 180.0,
                  RotateFrame = 15,
                  FrameTime = 5,
                  EventType = 8,

                }
              },
              [ 6 ] = {
                {

                  AddType = 1,
                  BuffId = 92003009,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 6,
                  EventType = 9,

                }
              },
              [ 17 ] = {
                {

                  AddType = 2,
                  BuffId = 92003009,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 17,
                  EventType = 9,

                }
              },
              [ 27 ] = {
                {

                  AddType = 2,
                  BuffId = 92003104,
                  LifeBindBuff = false,
                  Count = 1,
                  FrameTime = 27,
                  EventType = 9,

                },
                {

                  Type = 100201,
                  Frame = 21,
                  FrameTime = 27,
                  EventType = 3,

                }
              },
              [ 38 ] = {
                {

                  AddType = 2,
                  BuffId = 92003997,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 38,
                  EventType = 9,

                }
              },
            }
          },
          [ 92003202 ] = {
            TotalFrame = 56,
            ForceFrame = 53,
            SkillBreakSkillFrame = 31,
            SkillType = 0,
            AttrType = 5,
            UseCostType = 0,
            UseCostValue = 0,
            CDtime = 0.0,
            FrameEvent = {
              [ 0 ] = {
                {

                  AddType = 1,
                  BuffId = 92003104,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 0,
                  EventType = 9,

                },
                {

                  Name = "Attack202",
                  StartFrame = 0,
                  FrameTime = 0,
                  EventType = 2,

                },
                {

                  AddType = 1,
                  BuffId = 92003997,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 0,
                  EventType = 9,

                }
              },
              [ 3 ] = {
                {

                  RotateType = 2,
                  UseSelfSpeed = 0,
                  SpeedOffset = 180.0,
                  Acceleration = 360.0,
                  RotateFrame = 7,
                  FrameTime = 3,
                  EventType = 8,

                }
              },
              [ 16 ] = {
                {

                  AddType = 1,
                  BuffId = 92003009,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 16,
                  EventType = 9,

                }
              },
              [ 31 ] = {
                {

                  Type = 92003202,
                  Frame = 1,
                  FrameTime = 31,
                  EventType = 3,

                }
              },
              [ 36 ] = {
                {

                  AddType = 2,
                  BuffId = 92003009,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 36,
                  EventType = 9,

                }
              },
              [ 40 ] = {
                {

                  AddType = 2,
                  BuffId = 92003104,
                  LifeBindBuff = false,
                  Count = 1,
                  FrameTime = 40,
                  EventType = 9,

                },
                {

                  AddType = 2,
                  BuffId = 92003997,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 40,
                  EventType = 9,

                }
              },
            }
          },
          [ 92003203 ] = {
            TotalFrame = 55,
            ForceFrame = 35,
            SkillType = 0,
            AttrType = 5,
            UseCostType = 0,
            UseCostValue = 0,
            CDtime = 0.0,
            FrameEvent = {
              [ 0 ] = {
                {

                  Name = "Attack203",
                  StartFrame = 0,
                  FrameTime = 0,
                  EventType = 2,

                },
                {

                  AddType = 1,
                  BuffId = 92003997,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 0,
                  EventType = 9,

                }
              },
              [ 1 ] = {
                {

                  RotateType = 2,
                  UseSelfSpeed = 0,
                  SpeedOffset = 360.0,
                  Acceleration = 360.0,
                  RotateFrame = 30,
                  FrameTime = 1,
                  EventType = 8,

                }
              },
              [ 43 ] = {
                {

                  AddType = 2,
                  BuffId = 92003997,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 43,
                  EventType = 9,

                }
              },
            }
          },
          [ 92003204 ] = {
            TotalFrame = 145,
            ForceFrame = 124,
            SkillType = 0,
            AttrType = 5,
            UseCostType = 0,
            UseCostValue = 0,
            CDtime = 0.0,
            FrameEvent = {
              [ 0 ] = {
                {

                  Name = "Attack204",
                  StartFrame = 0,
                  FrameTime = 0,
                  EventType = 2,

                },
                {

                  AddType = 1,
                  BuffId = 92003997,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 0,
                  EventType = 9,

                },
                {

                  AddType = 2,
                  BuffId = 92003997,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 0,
                  EventType = 9,

                }
              },
              [ 18 ] = {
                {

                  EntityId = 9200399907,
                  LifeBindSkill = false,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 0.0,
                  BornOffsetZ = 0.0,
                  TerriaOffsetY = 0.0,
                  BornRotateOffsetX = 0.0,
                  BornRotateOffsetY = 0.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = false,
                  LookAngleRange = 360.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 18,
                  EventType = 1,

                }
              },
              [ 36 ] = {
                {

                  RotateType = 2,
                  UseSelfSpeed = 0,
                  SpeedOffset = 180.0,
                  Acceleration = 360.0,
                  RotateFrame = 14,
                  FrameTime = 36,
                  EventType = 8,

                }
              },
              [ 38 ] = {
                {

                  EntityId = 92003204001,
                  LifeBindSkill = false,
                  LifeBindSkillFrame = 0,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 0.0,
                  BornOffsetZ = 0.0,
                  TerriaOffsetY = 0.0,
                  BornRotateOffsetX = 0.0,
                  BornRotateOffsetY = 0.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = false,
                  LookAngleRange = 360.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 38,
                  EventType = 1,

                },
                {

                  CameraShake = {
                    {
                      ShakeType = 3,
                      Random = 0.0,
                      StartOffset = 0.0,
                      StartAmplitude = -0.6,
                      StartFrequency = 6.0,
                      TargetAmplitude = 0.2,
                      TargetFrequency = 4.0,
                      AmplitudeChangeTime = 0.198,
                      FrequencyChangeTime = 0.231,
                      DurationTime = 0.297,
                      Sign = 0.0,
                      DistanceDampingId = 0.0
                    }
                  },
                  FrameTime = 38,
                  EventType = 4,

                },
                {

                  EntityId = 9200320401,
                  LifeBindSkill = false,
                  LifeBindSkillFrame = 0,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 0.0,
                  BornOffsetZ = 0.0,
                  TerriaOffsetY = 0.0,
                  BornRotateOffsetX = 0.0,
                  BornRotateOffsetY = 0.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = false,
                  LookAngleRange = 360.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 38,
                  EventType = 1,

                }
              },
              [ 45 ] = {
                {

                  EntityId = 92003204002,
                  LifeBindSkill = false,
                  LifeBindSkillFrame = 0,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 0.0,
                  BornOffsetZ = 0.0,
                  TerriaOffsetY = 0.0,
                  BornRotateOffsetX = 0.0,
                  BornRotateOffsetY = 0.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = false,
                  LookAngleRange = 360.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 45,
                  EventType = 1,

                },
                {

                  EntityId = 9200320402,
                  LifeBindSkill = false,
                  LifeBindSkillFrame = 0,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 0.0,
                  BornOffsetZ = 0.0,
                  TerriaOffsetY = 0.0,
                  BornRotateOffsetX = 0.0,
                  BornRotateOffsetY = 0.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = false,
                  LookAngleRange = 360.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 45,
                  EventType = 1,

                }
              },
              [ 88 ] = {
                {

                  RotateType = 2,
                  UseSelfSpeed = 0,
                  SpeedOffset = 180.0,
                  Acceleration = 360.0,
                  RotateFrame = 31,
                  FrameTime = 88,
                  EventType = 8,
                  ActiveSign = {
                    Sign = {
                      9999
                    },
                  }
                }
              },
            }
          },
          [ 92003205 ] = {
            TotalFrame = 104,
            ForceFrame = 97,
            SkillBreakSkillFrame = 48,
            SkillType = 0,
            AttrType = 5,
            UseCostType = 0,
            UseCostValue = 0,
            CDtime = 0.0,
            FrameEvent = {
              [ 0 ] = {
                {

                  Name = "Attack205",
                  StartFrame = 0,
                  FrameTime = 0,
                  EventType = 2,

                },
                {

                  AddType = 1,
                  BuffId = 92003997,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 0,
                  EventType = 9,

                }
              },
              [ 4 ] = {
                {

                  RotateType = 2,
                  UseSelfSpeed = 0,
                  SpeedOffset = 180.0,
                  Acceleration = 180.0,
                  RotateFrame = 27,
                  FrameTime = 4,
                  EventType = 8,
                  ActiveSign = {
                    Sign = {
                      9999
                    },
                  }
                }
              },
              [ 14 ] = {
                {

                  EntityId = 9200399907,
                  LifeBindSkill = false,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 0.0,
                  BornOffsetZ = 0.0,
                  TerriaOffsetY = 0.0,
                  BornRotateOffsetX = 0.0,
                  BornRotateOffsetY = 0.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = false,
                  LookAngleRange = 360.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 14,
                  EventType = 1,

                }
              },
              [ 33 ] = {
                {

                  EntityId = 92003005001,
                  LifeBindSkill = false,
                  LifeBindSkillFrame = 0,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 0.0,
                  BornOffsetZ = 0.0,
                  TerriaOffsetY = 0.0,
                  BornRotateOffsetX = 0.0,
                  BornRotateOffsetY = 0.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = false,
                  LookAngleRange = 360.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 33,
                  EventType = 1,

                },
                {

                  Type = 920032051,
                  Frame = 5,
                  FrameTime = 33,
                  EventType = 3,

                },
                {

                  EntityId = 92003005002,
                  LifeBindSkill = false,
                  LifeBindSkillFrame = 0,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 0.0,
                  BornOffsetZ = 0.0,
                  TerriaOffsetY = 0.0,
                  BornRotateOffsetX = 0.0,
                  BornRotateOffsetY = 0.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = false,
                  LookAngleRange = 360.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 33,
                  EventType = 1,

                }
              },
              [ 34 ] = {
                {

                  PostProcessType = 2,
                  PostProcessParams = {
                    Strength = 0.2,
                    Dir = 0,
                    Radius = 1.0,
                    Alpha = 0.6,
                    AlphaCurveId = 1501,
                    Direction = 0,
                    Count = 4,
                    Center = { 0.6, -1.0 },
                    ShowTemplateID = false,
                    TemplateID = 92003005,
                    PostProcessType = 2,
                    Duration = 3,
                    ID = 0
                  },
                  LifeBindSkill = false,
                  FrameTime = 34,
                  EventType = 16,

                },
                {

                  EntityId = 9200320501,
                  LifeBindSkill = false,
                  LifeBindSkillFrame = 0,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 0.0,
                  BornOffsetZ = 0.0,
                  TerriaOffsetY = 0.0,
                  BornRotateOffsetX = 0.0,
                  BornRotateOffsetY = 0.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = false,
                  LookAngleRange = 360.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 34,
                  EventType = 1,

                }
              },
              [ 35 ] = {
                {

                  CameraShake = {
                    {
                      ShakeType = 3,
                      Random = 0.0,
                      StartOffset = 0.0,
                      StartAmplitude = 2.0,
                      StartFrequency = 6.0,
                      TargetAmplitude = 0.2,
                      TargetFrequency = 12.0,
                      AmplitudeChangeTime = 0.231,
                      FrequencyChangeTime = 0.264,
                      DurationTime = 0.495,
                      Sign = 0.0,
                      DistanceDampingId = 0.0
                    }
                  },
                  FrameTime = 35,
                  EventType = 4,

                }
              },
              [ 40 ] = {
                {

                  Type = 92003205,
                  Frame = 24,
                  FrameTime = 40,
                  EventType = 3,

                }
              },
              [ 45 ] = {
                {

                  AddType = 2,
                  BuffId = 92003997,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 45,
                  EventType = 9,

                }
              },
              [ 72 ] = {
                {

                  RotateType = 2,
                  UseSelfSpeed = 0,
                  SpeedOffset = 180.0,
                  Acceleration = 360.0,
                  RotateFrame = 15,
                  FrameTime = 72,
                  EventType = 8,
                  ActiveSign = {
                    Sign = {
                      9999
                    },
                  }
                }
              },
            }
          },
          [ 92003206 ] = {
            TotalFrame = 84,
            ForceFrame = 84,
            SkillType = 0,
            AttrType = 5,
            UseCostType = 0,
            UseCostValue = 0,
            CDtime = 0.0,
            FrameEvent = {
              [ 0 ] = {
                {

                  Name = "Attack206",
                  StartFrame = 0,
                  FrameTime = 0,
                  EventType = 2,

                },
                {

                  AddType = 1,
                  BuffId = 92003997,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 0,
                  EventType = 9,

                }
              },
              [ 9 ] = {
                {

                  RotateType = 2,
                  UseSelfSpeed = 0,
                  SpeedOffset = 180.0,
                  Acceleration = 180.0,
                  RotateFrame = 10,
                  FrameTime = 9,
                  EventType = 8,

                }
              },
              [ 28 ] = {
                {

                  RotateType = 2,
                  UseSelfSpeed = 0,
                  SpeedOffset = 180.0,
                  Acceleration = 180.0,
                  RotateFrame = 6,
                  FrameTime = 28,
                  EventType = 8,

                }
              },
              [ 32 ] = {
                {

                  EntityId = 9200320601,
                  LifeBindSkill = false,
                  LifeBindSkillFrame = 0,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 0.0,
                  BornOffsetZ = 0.0,
                  TerriaOffsetY = 0.0,
                  BornRotateOffsetX = 0.0,
                  BornRotateOffsetY = 0.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = false,
                  LookAngleRange = 360.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 32,
                  EventType = 1,

                }
              },
              [ 51 ] = {
                {

                  RotateType = 2,
                  UseSelfSpeed = 0,
                  SpeedOffset = 180.0,
                  Acceleration = 360.0,
                  RotateFrame = 15,
                  FrameTime = 51,
                  EventType = 8,
                  ActiveSign = {
                    Sign = {
                      9999
                    },
                  }
                }
              },
              [ 64 ] = {
                {

                  AddType = 2,
                  BuffId = 92003997,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 64,
                  EventType = 9,

                }
              },
            }
          },
          [ 92003207 ] = {
            TotalFrame = 137,
            ForceFrame = 129,
            SkillBreakSkillFrame = 61,
            SkillType = 0,
            AttrType = 5,
            UseCostType = 0,
            UseCostValue = 0,
            CDtime = 0.0,
            FrameEvent = {
              [ 0 ] = {
                {

                  Name = "Attack206",
                  StartFrame = 0,
                  FrameTime = 0,
                  EventType = 2,

                },
                {

                  AddType = 1,
                  BuffId = 92003997,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 0,
                  EventType = 9,

                },
                {

                  RotateType = 2,
                  UseSelfSpeed = 0,
                  SpeedOffset = 180.0,
                  Acceleration = 360.0,
                  RotateFrame = 14,
                  FrameTime = 0,
                  EventType = 8,

                }
              },
              [ 7 ] = {
                {

                  EntityId = 9200399907,
                  LifeBindSkill = false,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 0.0,
                  BornOffsetZ = 0.0,
                  TerriaOffsetY = 0.0,
                  BornRotateOffsetX = 0.0,
                  BornRotateOffsetY = 0.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = false,
                  LookAngleRange = 360.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 7,
                  EventType = 1,

                }
              },
              [ 23 ] = {
                {

                  RotateType = 2,
                  UseSelfSpeed = 0,
                  SpeedOffset = 180.0,
                  Acceleration = 360.0,
                  RotateFrame = 6,
                  FrameTime = 23,
                  EventType = 8,

                }
              },
              [ 26 ] = {
                {

                  EntityId = 92003206001,
                  LifeBindSkill = false,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 0.0,
                  BornOffsetZ = 0.0,
                  TerriaOffsetY = 0.0,
                  BornRotateOffsetX = 0.0,
                  BornRotateOffsetY = 0.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = false,
                  LookAngleRange = 360.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 26,
                  EventType = 1,

                }
              },
              [ 27 ] = {
                {

                  EntityId = 9200320601,
                  LifeBindSkill = false,
                  LifeBindSkillFrame = 0,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 0.0,
                  BornOffsetZ = 0.0,
                  TerriaOffsetY = 0.0,
                  BornRotateOffsetX = 0.0,
                  BornRotateOffsetY = 0.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = false,
                  LookAngleRange = 360.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 27,
                  EventType = 1,

                }
              },
              [ 30 ] = {
                {

                  Name = "Attack207",
                  StartFrame = 0,
                  FrameTime = 30,
                  EventType = 2,

                }
              },
              [ 34 ] = {
                {

                  EntityId = 9200399907,
                  LifeBindSkill = false,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 0.0,
                  BornOffsetZ = 0.0,
                  TerriaOffsetY = 0.0,
                  BornRotateOffsetX = 0.0,
                  BornRotateOffsetY = 0.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = false,
                  LookAngleRange = 360.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 34,
                  EventType = 1,

                }
              },
              [ 39 ] = {
                {

                  RotateType = 2,
                  UseSelfSpeed = 0,
                  SpeedOffset = 180.0,
                  Acceleration = 360.0,
                  RotateFrame = 20,
                  FrameTime = 39,
                  EventType = 8,

                }
              },
              [ 53 ] = {
                {

                  EntityId = 92003207001,
                  LifeBindSkill = false,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 0.0,
                  BornOffsetZ = 0.0,
                  TerriaOffsetY = 0.0,
                  BornRotateOffsetX = 0.0,
                  BornRotateOffsetY = 0.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = false,
                  LookAngleRange = 360.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 53,
                  EventType = 1,

                }
              },
              [ 54 ] = {
                {

                  EntityId = 9200320701,
                  LifeBindSkill = false,
                  LifeBindSkillFrame = 0,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 0.0,
                  BornOffsetZ = 0.0,
                  TerriaOffsetY = 0.0,
                  BornRotateOffsetX = 0.0,
                  BornRotateOffsetY = 0.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = false,
                  LookAngleRange = 360.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 54,
                  EventType = 1,

                }
              },
              [ 57 ] = {
                {

                  Type = 92003207,
                  Frame = 10,
                  FrameTime = 57,
                  EventType = 3,

                }
              },
              [ 84 ] = {
                {

                  RotateType = 2,
                  UseSelfSpeed = 0,
                  SpeedOffset = 180.0,
                  Acceleration = 360.0,
                  RotateFrame = 36,
                  FrameTime = 84,
                  EventType = 8,
                  ActiveSign = {
                    Sign = {
                      9999
                    },
                  }
                }
              },
              [ 95 ] = {
                {

                  AddType = 2,
                  BuffId = 92003997,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 95,
                  EventType = 9,

                }
              },
            }
          },
          [ 92003208 ] = {
            TotalFrame = 195,
            ForceFrame = 195,
            SkillType = 0,
            AttrType = 5,
            UseCostType = 0,
            UseCostValue = 0,
            CDtime = 0.0,
            FrameEvent = {
              [ 0 ] = {
                {

                  Name = "Attack206",
                  StartFrame = 0,
                  FrameTime = 0,
                  EventType = 2,

                },
                {

                  AddType = 1,
                  BuffId = 92003997,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 0,
                  EventType = 9,

                }
              },
              [ 29 ] = {
                {

                  RotateType = 2,
                  UseSelfSpeed = 0,
                  SpeedOffset = 180.0,
                  Acceleration = 180.0,
                  RotateFrame = 3,
                  FrameTime = 29,
                  EventType = 8,

                }
              },
              [ 32 ] = {
                {

                  EntityId = 9200320601,
                  LifeBindSkill = false,
                  LifeBindSkillFrame = 0,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 0.0,
                  BornOffsetZ = 0.0,
                  TerriaOffsetY = 0.0,
                  BornRotateOffsetX = 0.0,
                  BornRotateOffsetY = 0.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = false,
                  LookAngleRange = 360.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 32,
                  EventType = 1,

                }
              },
              [ 35 ] = {
                {

                  Name = "Attack207",
                  StartFrame = 0,
                  FrameTime = 35,
                  EventType = 2,

                }
              },
              [ 55 ] = {
                {

                  RotateType = 2,
                  UseSelfSpeed = 0,
                  SpeedOffset = 180.0,
                  Acceleration = 180.0,
                  RotateFrame = 6,
                  FrameTime = 55,
                  EventType = 8,

                },
                {

                  Direction = 1,
                  CustomX = 0.0,
                  CustomY = 0.0,
                  CustomZ = 0.0,
                  SpeedType = 1,
                  SpeedOffset = 10.0,
                  Acceleration = 0.0,
                  MoveFrame = 2,
                  InputSpeed = 0.0,
                  MinDistance = 1.0,
                  IgnoreYAxis = false,
                  SkillMoveDone = 1,
                  FrameTime = 55,
                  EventType = 7,

                }
              },
              [ 59 ] = {
                {

                  EntityId = 9200320701,
                  LifeBindSkill = false,
                  LifeBindSkillFrame = 0,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 0.0,
                  BornOffsetZ = 0.0,
                  TerriaOffsetY = 0.0,
                  BornRotateOffsetX = 0.0,
                  BornRotateOffsetY = 0.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = false,
                  LookAngleRange = 360.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 59,
                  EventType = 1,

                }
              },
              [ 66 ] = {
                {

                  Name = "Attack208",
                  StartFrame = 0,
                  FrameTime = 66,
                  EventType = 2,

                }
              },
              [ 71 ] = {
                {

                  RotateType = 2,
                  UseSelfSpeed = 0,
                  SpeedOffset = 180.0,
                  Acceleration = 180.0,
                  RotateFrame = 23,
                  FrameTime = 71,
                  EventType = 8,

                }
              },
              [ 120 ] = {
                {

                  EntityId = 9200320801,
                  LifeBindSkill = false,
                  LifeBindSkillFrame = 0,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 0.0,
                  BornOffsetZ = 0.0,
                  TerriaOffsetY = 0.0,
                  BornRotateOffsetX = 0.0,
                  BornRotateOffsetY = 0.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = false,
                  LookAngleRange = 360.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 120,
                  EventType = 1,

                }
              },
            }
          },
          [ 92003209 ] = {
            TotalFrame = 88,
            ForceFrame = 63,
            SkillBreakSkillFrame = 42,
            SkillType = 0,
            AttrType = 5,
            UseCostType = 0,
            UseCostValue = 0,
            CDtime = 0.0,
            FrameEvent = {
              [ 0 ] = {
                {

                  Name = "Attack209",
                  StartFrame = 0,
                  FrameTime = 0,
                  EventType = 2,

                },
                {

                  AddType = 1,
                  BuffId = 92003997,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 0,
                  EventType = 9,

                }
              },
              [ 4 ] = {
                {

                  EntityId = 9200399907,
                  LifeBindSkill = false,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 0.0,
                  BornOffsetZ = 0.0,
                  TerriaOffsetY = 0.0,
                  BornRotateOffsetX = 0.0,
                  BornRotateOffsetY = 0.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = false,
                  LookAngleRange = 360.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 4,
                  EventType = 1,

                }
              },
              [ 7 ] = {
                {

                  RotateType = 0,
                  UseSelfSpeed = 0,
                  SpeedOffset = 180.0,
                  Acceleration = 180.0,
                  RotateFrame = 13,
                  FrameTime = 7,
                  EventType = 8,

                }
              },
              [ 24 ] = {
                {

                  EntityId = 9200320901,
                  LifeBindSkill = false,
                  LifeBindSkillFrame = 0,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 0.0,
                  BornOffsetZ = 0.0,
                  TerriaOffsetY = 0.0,
                  BornRotateOffsetX = 0.0,
                  BornRotateOffsetY = 0.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = false,
                  LookAngleRange = 360.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 24,
                  EventType = 1,

                }
              },
              [ 42 ] = {
                {

                  Type = 92003209,
                  Frame = 10,
                  FrameTime = 42,
                  EventType = 3,

                }
              },
              [ 45 ] = {
                {

                  RotateType = 2,
                  UseSelfSpeed = 0,
                  SpeedOffset = 180.0,
                  Acceleration = 360.0,
                  RotateFrame = 10,
                  FrameTime = 45,
                  EventType = 8,
                  ActiveSign = {
                    Sign = {
                      9999
                    },
                  }
                }
              },
              [ 56 ] = {
                {

                  AddType = 2,
                  BuffId = 92003997,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 56,
                  EventType = 9,

                }
              },
            }
          },
          [ 92003210 ] = {
            TotalFrame = 120,
            ForceFrame = 120,
            SkillType = 0,
            AttrType = 5,
            UseCostType = 0,
            UseCostValue = 0,
            CDtime = 0.0,
            FrameEvent = {
              [ 0 ] = {
                {

                  Name = "Attack210",
                  StartFrame = 0,
                  FrameTime = 0,
                  EventType = 2,

                }
              },
            }
          },
          [ 92003211 ] = {
            TotalFrame = 200,
            ForceFrame = 200,
            SkillBreakSkillFrame = 90,
            SkillType = 0,
            AttrType = 5,
            UseCostType = 0,
            UseCostValue = 0,
            CDtime = 0.0,
            FrameEvent = {
              [ 0 ] = {
                {

                  Name = "Attack211",
                  StartFrame = 0,
                  FrameTime = 0,
                  EventType = 2,

                }
              },
              [ 90 ] = {
                {

                  Type = 92003211,
                  Frame = 1,
                  FrameTime = 90,
                  EventType = 3,

                }
              },
            }
          },
          [ 92003212 ] = {
            TotalFrame = 84,
            ForceFrame = 68,
            SkillType = 0,
            AttrType = 5,
            UseCostType = 0,
            UseCostValue = 0,
            CDtime = 0.0,
            FrameEvent = {
              [ 0 ] = {
                {

                  Name = "Attack212",
                  StartFrame = 0,
                  FrameTime = 0,
                  EventType = 2,

                },
                {

                  AddType = 1,
                  BuffId = 92003997,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 0,
                  EventType = 9,

                }
              },
              [ 3 ] = {
                {

                  RotateType = 2,
                  UseSelfSpeed = 0,
                  SpeedOffset = 180.0,
                  Acceleration = 180.0,
                  RotateFrame = 12,
                  FrameTime = 3,
                  EventType = 8,

                }
              },
              [ 6 ] = {
                {

                  EntityId = 9200399907,
                  LifeBindSkill = false,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 0.0,
                  BornOffsetZ = 0.0,
                  TerriaOffsetY = 0.0,
                  BornRotateOffsetX = 0.0,
                  BornRotateOffsetY = 0.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = false,
                  LookAngleRange = 360.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 6,
                  EventType = 1,

                }
              },
              [ 19 ] = {
                {

                  RotateType = 2,
                  UseSelfSpeed = 0,
                  SpeedOffset = 180.0,
                  Acceleration = 180.0,
                  RotateFrame = 6,
                  FrameTime = 19,
                  EventType = 8,

                }
              },
              [ 21 ] = {
                {

                  EntityId = 92003212001,
                  LifeBindSkill = false,
                  LifeBindSkillFrame = 0,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 0.0,
                  BornOffsetZ = 0.0,
                  TerriaOffsetY = 0.0,
                  BornRotateOffsetX = 0.0,
                  BornRotateOffsetY = 0.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = false,
                  LookAngleRange = 360.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 21,
                  EventType = 1,

                }
              },
              [ 22 ] = {
                {

                  EntityId = 9200321201,
                  LifeBindSkill = false,
                  LifeBindSkillFrame = 0,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 0.0,
                  BornOffsetZ = 0.0,
                  TerriaOffsetY = 0.0,
                  BornRotateOffsetX = 0.0,
                  BornRotateOffsetY = 0.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = false,
                  LookAngleRange = 360.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 22,
                  EventType = 1,

                }
              },
              [ 33 ] = {
                {

                  AddType = 2,
                  BuffId = 92003997,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 33,
                  EventType = 9,

                }
              },
              [ 34 ] = {
                {

                  Type = 92003212,
                  Frame = 10,
                  FrameTime = 34,
                  EventType = 3,

                }
              },
              [ 45 ] = {
                {

                  RotateType = 2,
                  UseSelfSpeed = 0,
                  SpeedOffset = 180.0,
                  Acceleration = 360.0,
                  RotateFrame = 8,
                  FrameTime = 45,
                  EventType = 8,

                }
              },
            }
          },
          [ 92003213 ] = {
            TotalFrame = 89,
            ForceFrame = 83,
            SkillBreakSkillFrame = 47,
            SkillType = 0,
            AttrType = 5,
            UseCostType = 0,
            UseCostValue = 0,
            CDtime = 0.0,
            FrameEvent = {
              [ 0 ] = {
                {

                  Name = "Attack213",
                  StartFrame = 0,
                  FrameTime = 0,
                  EventType = 2,

                },
                {

                  AddType = 1,
                  BuffId = 92003997,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 0,
                  EventType = 9,

                }
              },
              [ 3 ] = {
                {

                  RotateType = 2,
                  UseSelfSpeed = 0,
                  SpeedOffset = 180.0,
                  Acceleration = 180.0,
                  RotateFrame = 36,
                  FrameTime = 3,
                  EventType = 8,

                }
              },
              [ 16 ] = {
                {

                  EntityId = 9200399907,
                  LifeBindSkill = false,
                  CreateEntityType = 1,
                  BindTransform = "LeftEyeCase",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 0.0,
                  BornOffsetZ = 0.0,
                  TerriaOffsetY = 0.0,
                  BornRotateOffsetX = 0.0,
                  BornRotateOffsetY = 0.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = false,
                  LookAngleRange = 360.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 16,
                  EventType = 1,

                }
              },
              [ 27 ] = {
                {                  DurationUpdateTargetFrame = 8,
                  OffsetType = 2,
                  TargetHPositionOffset = 3.5,
                  TargetVPositionOffset = 0.0,
                  TargetRelationOffset = { 0.0, 0.0, 0.0 },
                  DurationMoveFrame = 8,
                  VDurationMoveFrame = -1,
                  IgnoreY = true,
                  MaxSpeed = 999.0,
                  MinSpeed = 0.0,
                  FrameTime = 27,
                  EventType = 18,

                }
              },
              [ 36 ] = {
                {

                  EntityId = 9200321301,
                  LifeBindSkill = false,
                  LifeBindSkillFrame = 0,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 0.0,
                  BornOffsetZ = 0.0,
                  TerriaOffsetY = 0.0,
                  BornRotateOffsetX = 0.0,
                  BornRotateOffsetY = 0.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = false,
                  LookAngleRange = 360.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 36,
                  EventType = 1,

                },
                {

                  EntityId = 92003213001,
                  LifeBindSkill = false,
                  LifeBindSkillFrame = 0,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 0.0,
                  BornOffsetZ = 0.0,
                  TerriaOffsetY = 0.0,
                  BornRotateOffsetX = 0.0,
                  BornRotateOffsetY = 0.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = false,
                  LookAngleRange = 360.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 36,
                  EventType = 1,

                }
              },
              [ 39 ] = {
                {

                  EntityId = 9200321302,
                  LifeBindSkill = false,
                  LifeBindSkillFrame = 0,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 0.0,
                  BornOffsetZ = 0.0,
                  TerriaOffsetY = 0.0,
                  BornRotateOffsetX = 0.0,
                  BornRotateOffsetY = 0.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = false,
                  LookAngleRange = 360.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 39,
                  EventType = 1,

                },
                {

                  EntityId = 92003213002,
                  LifeBindSkill = false,
                  LifeBindSkillFrame = 0,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 0.0,
                  BornOffsetZ = 0.0,
                  TerriaOffsetY = 0.0,
                  BornRotateOffsetX = 0.0,
                  BornRotateOffsetY = 0.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = false,
                  LookAngleRange = 360.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 39,
                  EventType = 1,

                }
              },
              [ 62 ] = {
                {

                  RotateType = 2,
                  UseSelfSpeed = 0,
                  SpeedOffset = 180.0,
                  Acceleration = 360.0,
                  RotateFrame = 13,
                  FrameTime = 62,
                  EventType = 8,
                  ActiveSign = {
                    Sign = {
                      9999
                    },
                  }
                },
                {

                  AddType = 2,
                  BuffId = 92003997,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 62,
                  EventType = 9,

                }
              },
            }
          },
          [ 92003214 ] = {
            TotalFrame = 122,
            ForceFrame = 121,
            SkillType = 0,
            AttrType = 5,
            UseCostType = 0,
            UseCostValue = 0,
            CDtime = 0.0,
            FrameEvent = {
              [ 0 ] = {
                {

                  AddType = 1,
                  BuffId = 92003997,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 0,
                  EventType = 9,

                },
                {

                  Name = "Attack214",
                  StartFrame = 0,
                  FrameTime = 0,
                  EventType = 2,

                }
              },
              [ 1 ] = {
                {

                  EntityId = 9200399907,
                  LifeBindSkill = false,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 0.0,
                  BornOffsetZ = 0.0,
                  TerriaOffsetY = 0.0,
                  BornRotateOffsetX = 0.0,
                  BornRotateOffsetY = 0.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = false,
                  LookAngleRange = 360.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 1,
                  EventType = 1,

                }
              },
              [ 6 ] = {
                {

                  RotateType = 2,
                  UseSelfSpeed = 0,
                  SpeedOffset = 180.0,
                  Acceleration = 180.0,
                  RotateFrame = 7,
                  FrameTime = 6,
                  EventType = 8,
                  ActiveSign = {
                    Sign = {
                      9999
                    },
                  }
                }
              },
              [ 16 ] = {
                {

                  RotateType = 2,
                  UseSelfSpeed = 0,
                  SpeedOffset = 180.0,
                  Acceleration = 360.0,
                  RotateFrame = 10,
                  FrameTime = 16,
                  EventType = 8,
                  ActiveSign = {
                    Sign = {
                      9999
                    },
                  }
                }
              },
              [ 21 ] = {
                {

                  EntityId = 92003214001,
                  LifeBindSkill = false,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 0.0,
                  BornOffsetZ = 0.0,
                  TerriaOffsetY = 0.0,
                  BornRotateOffsetX = 0.0,
                  BornRotateOffsetY = 0.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = false,
                  LookAngleRange = 360.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 21,
                  EventType = 1,

                },
                {

                  EntityId = 9200321401,
                  LifeBindSkill = false,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 0.0,
                  BornOffsetZ = 0.0,
                  TerriaOffsetY = 0.0,
                  BornRotateOffsetX = 0.0,
                  BornRotateOffsetY = 0.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = false,
                  LookAngleRange = 360.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 21,
                  EventType = 1,

                }
              },
              [ 30 ] = {
                {

                  RotateType = 2,
                  UseSelfSpeed = 0,
                  SpeedOffset = 180.0,
                  Acceleration = 360.0,
                  RotateFrame = 9,
                  FrameTime = 30,
                  EventType = 8,

                },
                {

                  EntityId = 9200399907,
                  LifeBindSkill = false,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 0.0,
                  BornOffsetZ = 0.0,
                  TerriaOffsetY = 0.0,
                  BornRotateOffsetX = 0.0,
                  BornRotateOffsetY = 0.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = false,
                  LookAngleRange = 360.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 30,
                  EventType = 1,

                }
              },
              [ 42 ] = {
                {

                  RotateType = 2,
                  UseSelfSpeed = 0,
                  SpeedOffset = 180.0,
                  Acceleration = 360.0,
                  RotateFrame = 14,
                  FrameTime = 42,
                  EventType = 8,

                }
              },
              [ 43 ] = {
                {

                  Direction = 1,
                  CustomX = 0.0,
                  CustomY = 0.0,
                  CustomZ = 0.0,
                  SpeedType = 0,
                  SpeedOffset = 5.0,
                  Acceleration = 5.0,
                  MoveFrame = 4,
                  InputSpeed = 0.0,
                  MinDistance = 2.0,
                  IgnoreYAxis = false,
                  SkillMoveDone = 4,
                  FrameTime = 43,
                  EventType = 7,

                }
              },
              [ 50 ] = {
                {

                  EntityId = 92003214002,
                  LifeBindSkill = false,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 0.0,
                  BornOffsetZ = 0.0,
                  TerriaOffsetY = 0.0,
                  BornRotateOffsetX = 0.0,
                  BornRotateOffsetY = 0.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = false,
                  LookAngleRange = 360.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 50,
                  EventType = 1,

                },
                {

                  EntityId = 9200321402,
                  LifeBindSkill = false,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 0.0,
                  BornOffsetZ = 0.0,
                  TerriaOffsetY = 0.0,
                  BornRotateOffsetX = 0.0,
                  BornRotateOffsetY = 0.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = false,
                  LookAngleRange = 360.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 50,
                  EventType = 1,

                }
              },
              [ 79 ] = {
                {

                  RotateType = 2,
                  UseSelfSpeed = 0,
                  SpeedOffset = 180.0,
                  Acceleration = 180.0,
                  RotateFrame = 10,
                  FrameTime = 79,
                  EventType = 8,
                  ActiveSign = {
                    Sign = {
                      9997
                    },
                  }
                }
              },
              [ 110 ] = {
                {

                  AddType = 2,
                  BuffId = 92003997,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 110,
                  EventType = 9,

                }
              },
            }
          },
          [ 92003215 ] = {
            TotalFrame = 118,
            ForceFrame = 118,
            SkillType = 0,
            AttrType = 5,
            UseCostType = 0,
            UseCostValue = 0,
            CDtime = 0.0,
            FrameEvent = {
              [ 0 ] = {
                {

                  AddType = 1,
                  BuffId = 92003997,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 0,
                  EventType = 9,

                },
                {

                  Name = "Attack215",
                  StartFrame = 0,
                  FrameTime = 0,
                  EventType = 2,

                }
              },
              [ 2 ] = {
                {

                  RotateType = 2,
                  UseSelfSpeed = 0,
                  SpeedOffset = 360.0,
                  Acceleration = 360.0,
                  RotateFrame = 3,
                  FrameTime = 2,
                  EventType = 8,
                  ActiveSign = {
                    Sign = {
                      9999
                    },
                  }
                }
              },
              [ 20 ] = {
                {

                  EntityId = 92003215004,
                  LifeBindSkill = false,
                  LifeBindSkillFrame = 0,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 0.0,
                  BornOffsetZ = 0.0,
                  TerriaOffsetY = 0.0,
                  BornRotateOffsetX = 0.0,
                  BornRotateOffsetY = 0.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = false,
                  LookAngleRange = 0.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 20,
                  EventType = 1,

                },
                {                  DurationUpdateTargetFrame = 6,
                  OffsetType = 2,
                  TargetHPositionOffset = 3.0,
                  TargetVPositionOffset = 6.0,
                  TargetRelationOffset = { 0.0, 0.0, 0.0 },
                  DurationMoveFrame = 6,
                  VDurationMoveFrame = -1,
                  IgnoreY = true,
                  MaxSpeed = 999.0,
                  MinSpeed = 0.0,
                  FrameTime = 20,
                  EventType = 18,

                }
              },
              [ 24 ] = {
                {

                  AddType = 1,
                  BuffId = 900000043,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 24,
                  EventType = 9,

                },
                {

                  EntityId = 9200399906,
                  LifeBindSkill = false,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 0.0,
                  BornOffsetZ = 0.0,
                  TerriaOffsetY = 0.0,
                  BornRotateOffsetX = 0.0,
                  BornRotateOffsetY = 0.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = false,
                  LookAngleRange = 360.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 24,
                  EventType = 1,

                }
              },
              [ 26 ] = {
                {

                  RotateType = 2,
                  UseSelfSpeed = 0,
                  SpeedOffset = 180.0,
                  Acceleration = 0.0,
                  RotateFrame = 31,
                  FrameTime = 26,
                  EventType = 8,

                }
              },
              [ 32 ] = {
                {

                  AddType = 1,
                  BuffId = 92003998,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 32,
                  EventType = 9,

                }
              },
              [ 37 ] = {
                {

                  AddType = 2,
                  BuffId = 92003998,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 37,
                  EventType = 9,

                }
              },
              [ 48 ] = {
                {                  DurationUpdateTargetFrame = 5,
                  OffsetType = 2,
                  TargetHPositionOffset = 2.0,
                  TargetVPositionOffset = 10.0,
                  TargetRelationOffset = { 0.0, 0.0, 0.0 },
                  DurationMoveFrame = 5,
                  VDurationMoveFrame = -1,
                  IgnoreY = true,
                  MaxSpeed = 90.0,
                  MinSpeed = 0.0,
                  FrameTime = 48,
                  EventType = 18,

                }
              },
              [ 53 ] = {
                {

                  EntityId = 92003215001,
                  LifeBindSkill = false,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 0.0,
                  BornOffsetZ = 0.0,
                  TerriaOffsetY = 0.0,
                  BornRotateOffsetX = 0.0,
                  BornRotateOffsetY = 0.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = false,
                  LookAngleRange = 360.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 53,
                  EventType = 1,

                }
              },
              [ 54 ] = {
                {

                  EntityId = 92003215002,
                  LifeBindSkill = false,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 0.0,
                  BornOffsetZ = 0.0,
                  TerriaOffsetY = 0.0,
                  BornRotateOffsetX = 0.0,
                  BornRotateOffsetY = 0.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = false,
                  LookAngleRange = 360.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 54,
                  EventType = 1,

                },
                {

                  EntityId = 9200321501,
                  LifeBindSkill = false,
                  LifeBindSkillFrame = 0,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 0.0,
                  BornOffsetZ = 0.0,
                  TerriaOffsetY = 0.0,
                  BornRotateOffsetX = 0.0,
                  BornRotateOffsetY = 0.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = false,
                  LookAngleRange = 360.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 54,
                  EventType = 1,

                },
                {

                  PostProcessType = 2,
                  PostProcessParams = {
                    Strength = 0.4,
                    Dir = 0,
                    Radius = 1.0,
                    Alpha = 0.8,
                    AlphaCurveId = 1501,
                    Direction = 0,
                    FollowTransform = "ShentuMb1_weapon",
                    Count = 5,
                    Center = { 0.6, -1.0 },
                    ShowTemplateID = false,
                    TemplateID = 0,
                    PostProcessType = 2,
                    Duration = 5,
                    ID = 0
                  },
                  LifeBindSkill = false,
                  FrameTime = 54,
                  EventType = 16,

                },
                {

                  EntityId = 92003215002,
                  LifeBindSkill = false,
                  LifeBindSkillFrame = 0,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 0.0,
                  BornOffsetZ = 0.0,
                  TerriaOffsetY = 0.0,
                  BornRotateOffsetX = 0.0,
                  BornRotateOffsetY = 0.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = false,
                  LookAngleRange = 0.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 54,
                  EventType = 1,

                }
              },
              [ 55 ] = {
                {

                  CameraShake = {
                    {
                      ShakeType = 3,
                      Random = 0.0,
                      StartOffset = 0.0,
                      StartAmplitude = 1.4,
                      StartFrequency = 6.0,
                      TargetAmplitude = 0.3,
                      TargetFrequency = 12.0,
                      AmplitudeChangeTime = 0.561,
                      FrequencyChangeTime = 0.363,
                      DurationTime = 0.594,
                      Sign = 0.0,
                      DistanceDampingId = 0.0
                    }
                  },
                  FrameTime = 55,
                  EventType = 4,

                }
              },
              [ 92 ] = {
                {

                  RotateType = 2,
                  UseSelfSpeed = 0,
                  SpeedOffset = 180.0,
                  Acceleration = 180.0,
                  RotateFrame = 7,
                  FrameTime = 92,
                  EventType = 8,
                  ActiveSign = {
                    Sign = {
                      9999
                    },
                  }
                }
              },
              [ 95 ] = {
                {

                  AddType = 2,
                  BuffId = 92003997,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 95,
                  EventType = 9,

                }
              },
            }
          },
          [ 92003218 ] = {
            TotalFrame = 137,
            ForceFrame = 129,
            SkillBreakSkillFrame = 68,
            SkillType = 0,
            AttrType = 5,
            UseCostType = 0,
            UseCostValue = 0,
            CDtime = 0.0,
            FrameEvent = {
              [ 0 ] = {
                {

                  Name = "Attack208",
                  StartFrame = 0,
                  FrameTime = 0,
                  EventType = 2,

                },
                {

                  AddType = 1,
                  BuffId = 92003997,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 0,
                  EventType = 9,

                }
              },
              [ 5 ] = {
                {

                  RotateType = 2,
                  UseSelfSpeed = 0,
                  SpeedOffset = 180.0,
                  Acceleration = 180.0,
                  RotateFrame = 45,
                  FrameTime = 5,
                  EventType = 8,

                }
              },
              [ 33 ] = {
                {

                  EntityId = 9200399907,
                  LifeBindSkill = false,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 0.0,
                  BornOffsetZ = 0.0,
                  TerriaOffsetY = 0.0,
                  BornRotateOffsetX = 0.0,
                  BornRotateOffsetY = 0.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = false,
                  LookAngleRange = 360.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 33,
                  EventType = 1,

                }
              },
              [ 51 ] = {
                {

                  EntityId = 92003005001,
                  LifeBindSkill = false,
                  LifeBindSkillFrame = 0,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 0.0,
                  BornOffsetZ = 0.0,
                  TerriaOffsetY = 0.0,
                  BornRotateOffsetX = 0.0,
                  BornRotateOffsetY = 0.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = false,
                  LookAngleRange = 360.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 51,
                  EventType = 1,

                }
              },
              [ 53 ] = {
                {

                  EntityId = 9200320801,
                  LifeBindSkill = false,
                  LifeBindSkillFrame = 0,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 0.0,
                  BornOffsetZ = 0.0,
                  TerriaOffsetY = 0.0,
                  BornRotateOffsetX = 0.0,
                  BornRotateOffsetY = 0.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = false,
                  LookAngleRange = 360.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 53,
                  EventType = 1,

                },
                {

                  PostProcessType = 2,
                  PostProcessParams = {
                    Strength = 0.2,
                    Dir = 0,
                    Radius = 1.0,
                    Alpha = 0.6,
                    AlphaCurveId = 1501,
                    Direction = 0,
                    Count = 4,
                    Center = { 0.6, -1.0 },
                    ShowTemplateID = false,
                    TemplateID = 92003005,
                    PostProcessType = 2,
                    Duration = 3,
                    ID = 0
                  },
                  LifeBindSkill = false,
                  FrameTime = 53,
                  EventType = 16,

                },
                {

                  EntityId = 92003005002,
                  LifeBindSkill = false,
                  LifeBindSkillFrame = 0,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 0.0,
                  BornOffsetZ = 0.0,
                  TerriaOffsetY = 0.0,
                  BornRotateOffsetX = 0.0,
                  BornRotateOffsetY = 0.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = false,
                  LookAngleRange = 360.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 53,
                  EventType = 1,

                }
              },
              [ 54 ] = {
                {

                  CameraShake = {
                    {
                      ShakeType = 3,
                      Random = 0.0,
                      StartOffset = 0.0,
                      StartAmplitude = 1.2,
                      StartFrequency = 6.0,
                      TargetAmplitude = 0.1,
                      TargetFrequency = 3.0,
                      AmplitudeChangeTime = 0.33,
                      FrequencyChangeTime = 0.297,
                      DurationTime = 0.561,
                      Sign = 0.0,
                      DistanceDampingId = 0.0
                    }
                  },
                  FrameTime = 54,
                  EventType = 4,

                }
              },
              [ 98 ] = {
                {

                  RotateType = 2,
                  UseSelfSpeed = 0,
                  SpeedOffset = 180.0,
                  Acceleration = 360.0,
                  RotateFrame = 18,
                  FrameTime = 98,
                  EventType = 8,
                  ActiveSign = {
                    Sign = {
                      123
                    },
                  }
                }
              },
              [ 120 ] = {
                {

                  Type = 92003218,
                  Frame = 3,
                  FrameTime = 120,
                  EventType = 3,

                }
              },
              [ 128 ] = {
                {

                  AddType = 2,
                  BuffId = 92003997,
                  LifeBindBuff = true,
                  Count = 99,
                  FrameTime = 128,
                  EventType = 9,

                }
              },
            }
          },
          [ 92003219 ] = {
            TotalFrame = 100,
            ForceFrame = 94,
            SkillType = 0,
            AttrType = 5,
            UseCostType = 0,
            UseCostValue = 0,
            CDtime = 0.0,
            FrameEvent = {
              [ 0 ] = {
                {

                  Name = "Attack215",
                  StartFrame = 18,
                  FrameTime = 0,
                  EventType = 2,

                },
                {

                  AddType = 1,
                  BuffId = 92003997,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 0,
                  EventType = 9,

                }
              },
              [ 2 ] = {
                {                  DurationUpdateTargetFrame = 6,
                  OffsetType = 2,
                  TargetHPositionOffset = 4.0,
                  TargetVPositionOffset = 6.0,
                  TargetRelationOffset = { 0.0, 0.0, 0.0 },
                  DurationMoveFrame = 6,
                  VDurationMoveFrame = -1,
                  IgnoreY = true,
                  MaxSpeed = 90.0,
                  MinSpeed = 0.0,
                  FrameTime = 2,
                  EventType = 18,

                }
              },
              [ 6 ] = {
                {

                  EntityId = 9200399906,
                  LifeBindSkill = false,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 0.0,
                  BornOffsetZ = 0.0,
                  TerriaOffsetY = 0.0,
                  BornRotateOffsetX = 0.0,
                  BornRotateOffsetY = 0.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = false,
                  LookAngleRange = 360.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 6,
                  EventType = 1,

                },
                {

                  AddType = 1,
                  BuffId = 900000043,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 6,
                  EventType = 9,

                }
              },
              [ 8 ] = {
                {

                  RotateType = 2,
                  UseSelfSpeed = 0,
                  SpeedOffset = 180.0,
                  Acceleration = 0.0,
                  RotateFrame = 31,
                  FrameTime = 8,
                  EventType = 8,

                }
              },
              [ 14 ] = {
                {

                  AddType = 1,
                  BuffId = 92003998,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 14,
                  EventType = 9,

                }
              },
              [ 19 ] = {
                {

                  AddType = 2,
                  BuffId = 92003998,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 19,
                  EventType = 9,

                }
              },
              [ 30 ] = {
                {                  DurationUpdateTargetFrame = 5,
                  OffsetType = 2,
                  TargetHPositionOffset = 2.0,
                  TargetVPositionOffset = 10.0,
                  TargetRelationOffset = { 0.0, 0.0, 0.0 },
                  DurationMoveFrame = 5,
                  VDurationMoveFrame = -1,
                  IgnoreY = true,
                  MaxSpeed = 90.0,
                  MinSpeed = 0.0,
                  FrameTime = 30,
                  EventType = 18,

                }
              },
              [ 35 ] = {
                {

                  EntityId = 92003215001,
                  LifeBindSkill = false,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 0.0,
                  BornOffsetZ = 0.0,
                  TerriaOffsetY = 0.0,
                  BornRotateOffsetX = 0.0,
                  BornRotateOffsetY = 0.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = false,
                  LookAngleRange = 360.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 35,
                  EventType = 1,

                }
              },
              [ 36 ] = {
                {

                  EntityId = 92003215002,
                  LifeBindSkill = false,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 0.0,
                  BornOffsetZ = 0.0,
                  TerriaOffsetY = 0.0,
                  BornRotateOffsetX = 0.0,
                  BornRotateOffsetY = 0.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = false,
                  LookAngleRange = 360.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 36,
                  EventType = 1,

                },
                {

                  EntityId = 9200321501,
                  LifeBindSkill = false,
                  LifeBindSkillFrame = 0,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 0.0,
                  BornOffsetZ = 0.0,
                  TerriaOffsetY = 0.0,
                  BornRotateOffsetX = 0.0,
                  BornRotateOffsetY = 0.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = false,
                  LookAngleRange = 360.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 36,
                  EventType = 1,

                },
                {

                  PostProcessType = 2,
                  PostProcessParams = {
                    Strength = 0.4,
                    Dir = 0,
                    Radius = 1.0,
                    Alpha = 0.8,
                    AlphaCurveId = 1501,
                    Direction = 0,
                    FollowTransform = "ShentuMb1_weapon",
                    Count = 5,
                    Center = { 0.6, -1.0 },
                    ShowTemplateID = false,
                    TemplateID = 0,
                    PostProcessType = 2,
                    Duration = 5,
                    ID = 0
                  },
                  LifeBindSkill = false,
                  FrameTime = 36,
                  EventType = 16,

                }
              },
              [ 37 ] = {
                {

                  CameraShake = {
                    {
                      ShakeType = 3,
                      Random = 0.0,
                      StartOffset = 0.0,
                      StartAmplitude = 1.4,
                      StartFrequency = 6.0,
                      TargetAmplitude = 0.3,
                      TargetFrequency = 12.0,
                      AmplitudeChangeTime = 0.561,
                      FrequencyChangeTime = 0.363,
                      DurationTime = 0.594,
                      Sign = 0.0,
                      DistanceDampingId = 0.0
                    }
                  },
                  FrameTime = 37,
                  EventType = 4,

                }
              },
              [ 74 ] = {
                {

                  RotateType = 2,
                  UseSelfSpeed = 0,
                  SpeedOffset = 180.0,
                  Acceleration = 180.0,
                  RotateFrame = 7,
                  FrameTime = 74,
                  EventType = 8,
                  ActiveSign = {
                    Sign = {
                      9999
                    },
                  }
                }
              },
              [ 77 ] = {
                {

                  AddType = 2,
                  BuffId = 92003997,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 77,
                  EventType = 9,

                }
              },
            }
          },
          [ 92003220 ] = {
            TotalFrame = 137,
            ForceFrame = 129,
            SkillBreakSkillFrame = 68,
            SkillType = 0,
            AttrType = 5,
            UseCostType = 0,
            UseCostValue = 0,
            CDtime = 0.0,
            FrameEvent = {
              [ 0 ] = {
                {

                  Name = "Attack208",
                  StartFrame = 0,
                  FrameTime = 0,
                  EventType = 2,

                },
                {

                  AddType = 1,
                  BuffId = 92003997,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 0,
                  EventType = 9,

                }
              },
              [ 5 ] = {
                {

                  RotateType = 2,
                  UseSelfSpeed = 0,
                  SpeedOffset = 180.0,
                  Acceleration = 180.0,
                  RotateFrame = 45,
                  FrameTime = 5,
                  EventType = 8,

                }
              },
              [ 27 ] = {
                {

                  AddType = 1,
                  BuffId = 92003998,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 27,
                  EventType = 9,

                }
              },
              [ 34 ] = {
                {

                  EntityId = 9200399905,
                  LifeBindSkill = false,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 0.0,
                  BornOffsetZ = 0.0,
                  TerriaOffsetY = 0.0,
                  BornRotateOffsetX = 0.0,
                  BornRotateOffsetY = 0.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = false,
                  LookAngleRange = 360.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 34,
                  EventType = 1,

                }
              },
              [ 38 ] = {
                {

                  EntityId = 9200399907,
                  LifeBindSkill = false,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 0.0,
                  BornOffsetZ = 0.0,
                  TerriaOffsetY = 0.0,
                  BornRotateOffsetX = 0.0,
                  BornRotateOffsetY = 0.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = false,
                  LookAngleRange = 360.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 38,
                  EventType = 1,

                }
              },
              [ 44 ] = {
                {

                  AddType = 2,
                  BuffId = 92003998,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 44,
                  EventType = 9,

                }
              },
              [ 51 ] = {
                {

                  EntityId = 92003005001,
                  LifeBindSkill = false,
                  LifeBindSkillFrame = 0,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 0.0,
                  BornOffsetZ = 0.0,
                  TerriaOffsetY = 0.0,
                  BornRotateOffsetX = 0.0,
                  BornRotateOffsetY = 0.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = false,
                  LookAngleRange = 360.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 51,
                  EventType = 1,

                }
              },
              [ 53 ] = {
                {

                  EntityId = 92003005002,
                  LifeBindSkill = false,
                  LifeBindSkillFrame = 0,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 0.0,
                  BornOffsetZ = 0.0,
                  TerriaOffsetY = 0.0,
                  BornRotateOffsetX = 0.0,
                  BornRotateOffsetY = 0.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = false,
                  LookAngleRange = 360.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 53,
                  EventType = 1,

                },
                {

                  Type = 92003220,
                  Frame = 1,
                  FrameTime = 53,
                  EventType = 3,

                },
                {

                  PostProcessType = 2,
                  PostProcessParams = {
                    Strength = 0.2,
                    Dir = 0,
                    Radius = 1.0,
                    Alpha = 0.6,
                    AlphaCurveId = 1501,
                    Direction = 0,
                    Count = 4,
                    Center = { 0.6, -1.0 },
                    ShowTemplateID = false,
                    TemplateID = 92003005,
                    PostProcessType = 2,
                    Duration = 3,
                    ID = 0
                  },
                  LifeBindSkill = false,
                  FrameTime = 53,
                  EventType = 16,

                },
                {

                  EntityId = 9200320801,
                  LifeBindSkill = false,
                  LifeBindSkillFrame = 0,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 0.0,
                  BornOffsetZ = 0.0,
                  TerriaOffsetY = 0.0,
                  BornRotateOffsetX = 0.0,
                  BornRotateOffsetY = 0.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = false,
                  LookAngleRange = 360.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 53,
                  EventType = 1,

                }
              },
              [ 54 ] = {
                {

                  CameraShake = {
                    {
                      ShakeType = 3,
                      Random = 0.0,
                      StartOffset = 0.0,
                      StartAmplitude = 1.2,
                      StartFrequency = 6.0,
                      TargetAmplitude = 0.1,
                      TargetFrequency = 3.0,
                      AmplitudeChangeTime = 0.33,
                      FrequencyChangeTime = 0.297,
                      DurationTime = 0.561,
                      Sign = 0.0,
                      DistanceDampingId = 0.0
                    }
                  },
                  FrameTime = 54,
                  EventType = 4,

                }
              },
              [ 73 ] = {
                {

                  EntityId = 9200301902,
                  LifeBindSkill = false,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 0.0,
                  BornOffsetZ = 2.0,
                  TerriaOffsetY = 0.0,
                  BornRotateOffsetX = 0.0,
                  BornRotateOffsetY = 0.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = false,
                  LookAngleRange = 360.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 73,
                  EventType = 1,

                }
              },
              [ 76 ] = {
                {

                  EntityId = 9200301902,
                  LifeBindSkill = false,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 0.0,
                  BornOffsetZ = 5.5,
                  TerriaOffsetY = 0.0,
                  BornRotateOffsetX = 0.0,
                  BornRotateOffsetY = 0.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = false,
                  LookAngleRange = 360.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 76,
                  EventType = 1,

                }
              },
              [ 79 ] = {
                {

                  EntityId = 9200301902,
                  LifeBindSkill = false,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 0.0,
                  BornOffsetZ = 9.0,
                  TerriaOffsetY = 0.0,
                  BornRotateOffsetX = 0.0,
                  BornRotateOffsetY = 0.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = false,
                  LookAngleRange = 360.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 79,
                  EventType = 1,

                }
              },
              [ 82 ] = {
                {

                  EntityId = 9200301902,
                  LifeBindSkill = false,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 0.0,
                  BornOffsetZ = 12.5,
                  TerriaOffsetY = 0.0,
                  BornRotateOffsetX = 0.0,
                  BornRotateOffsetY = 0.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = false,
                  LookAngleRange = 360.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 82,
                  EventType = 1,

                }
              },
              [ 98 ] = {
                {

                  RotateType = 2,
                  UseSelfSpeed = 0,
                  SpeedOffset = 180.0,
                  Acceleration = 360.0,
                  RotateFrame = 18,
                  FrameTime = 98,
                  EventType = 8,

                }
              },
              [ 128 ] = {
                {

                  AddType = 2,
                  BuffId = 92003997,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 128,
                  EventType = 9,

                }
              },
            }
          },
          [ 92003221 ] = {
            TotalFrame = 80,
            ForceFrame = 60,
            SkillType = 0,
            AttrType = 5,
            UseCostType = 0,
            UseCostValue = 0,
            CDtime = 0.0,
            FrameEvent = {
              [ 0 ] = {
                {

                  Name = "Attack212",
                  StartFrame = 4,
                  FrameTime = 0,
                  EventType = 2,

                },
                {

                  RotateType = 2,
                  UseSelfSpeed = 0,
                  SpeedOffset = 180.0,
                  Acceleration = 180.0,
                  RotateFrame = 12,
                  FrameTime = 0,
                  EventType = 8,

                },
                {

                  AddType = 1,
                  BuffId = 92003997,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 0,
                  EventType = 9,

                }
              },
              [ 17 ] = {
                {

                  EntityId = 92003212001,
                  LifeBindSkill = false,
                  LifeBindSkillFrame = 0,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 0.0,
                  BornOffsetZ = 0.0,
                  TerriaOffsetY = 0.0,
                  BornRotateOffsetX = 0.0,
                  BornRotateOffsetY = 0.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = false,
                  LookAngleRange = 360.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 17,
                  EventType = 1,

                }
              },
              [ 18 ] = {
                {

                  EntityId = 9200321201,
                  LifeBindSkill = false,
                  LifeBindSkillFrame = 0,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 0.0,
                  BornOffsetZ = 0.0,
                  TerriaOffsetY = 0.0,
                  BornRotateOffsetX = 0.0,
                  BornRotateOffsetY = 0.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = false,
                  LookAngleRange = 360.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 18,
                  EventType = 1,

                }
              },
              [ 41 ] = {
                {

                  RotateType = 2,
                  UseSelfSpeed = 0,
                  SpeedOffset = 180.0,
                  Acceleration = 360.0,
                  RotateFrame = 8,
                  FrameTime = 41,
                  EventType = 8,

                }
              },
              [ 50 ] = {
                {

                  AddType = 2,
                  BuffId = 92003997,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 50,
                  EventType = 9,

                }
              },
            }
          },
          [ 92003222 ] = {
            TotalFrame = 86,
            ForceFrame = 54,
            SkillType = 0,
            AttrType = 5,
            UseCostType = 0,
            UseCostValue = 0,
            CDtime = 0.0,
            FrameEvent = {
              [ 0 ] = {
                {

                  Name = "Attack209",
                  StartFrame = 10,
                  FrameTime = 0,
                  EventType = 2,

                },
                {

                  RotateType = 0,
                  UseSelfSpeed = 0,
                  SpeedOffset = 180.0,
                  Acceleration = 180.0,
                  RotateFrame = 3,
                  FrameTime = 0,
                  EventType = 8,

                },
                {

                  AddType = 1,
                  BuffId = 92003997,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 0,
                  EventType = 9,

                }
              },
              [ 14 ] = {
                {

                  EntityId = 9200320901,
                  LifeBindSkill = false,
                  LifeBindSkillFrame = 0,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 0.0,
                  BornOffsetZ = 0.0,
                  TerriaOffsetY = 0.0,
                  BornRotateOffsetX = 0.0,
                  BornRotateOffsetY = 0.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = false,
                  LookAngleRange = 360.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 14,
                  EventType = 1,

                }
              },
              [ 35 ] = {
                {

                  RotateType = 2,
                  UseSelfSpeed = 0,
                  SpeedOffset = 180.0,
                  Acceleration = 360.0,
                  RotateFrame = 10,
                  FrameTime = 35,
                  EventType = 8,
                  ActiveSign = {
                    Sign = {
                      9999
                    },
                  }
                }
              },
              [ 47 ] = {
                {

                  AddType = 2,
                  BuffId = 92003997,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 47,
                  EventType = 9,

                }
              },
            }
          },
          [ 92003223 ] = {
            TotalFrame = 131,
            ForceFrame = 102,
            SkillType = 0,
            AttrType = 5,
            UseCostType = 0,
            UseCostValue = 0,
            CDtime = 0.0,
            FrameEvent = {
              [ 0 ] = {
                {

                  Name = "Attack211",
                  StartFrame = 0,
                  FrameTime = 0,
                  EventType = 2,

                },
                {

                  AddType = 1,
                  BuffId = 92003997,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 0,
                  EventType = 9,

                }
              },
              [ 43 ] = {
                {

                  RotateType = 2,
                  UseSelfSpeed = 0,
                  SpeedOffset = 360.0,
                  Acceleration = 360.0,
                  RotateFrame = 17,
                  FrameTime = 43,
                  EventType = 8,

                }
              },
              [ 56 ] = {
                {

                  EntityId = 9200321101,
                  LifeBindSkill = false,
                  LifeBindSkillFrame = 0,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 0.0,
                  BornOffsetZ = 0.0,
                  TerriaOffsetY = 0.0,
                  BornRotateOffsetX = 0.0,
                  BornRotateOffsetY = 0.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = false,
                  LookAngleRange = 360.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 56,
                  EventType = 1,

                }
              },
              [ 63 ] = {
                {

                  EntityId = 9200321102,
                  LifeBindSkill = false,
                  LifeBindSkillFrame = 0,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 0.0,
                  BornOffsetZ = 0.0,
                  TerriaOffsetY = 0.0,
                  BornRotateOffsetX = 0.0,
                  BornRotateOffsetY = 0.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = false,
                  LookAngleRange = 360.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 63,
                  EventType = 1,

                }
              },
              [ 90 ] = {
                {

                  RotateType = 2,
                  UseSelfSpeed = 0,
                  SpeedOffset = 180.0,
                  Acceleration = 360.0,
                  RotateFrame = 10,
                  FrameTime = 90,
                  EventType = 8,

                }
              },
            }
          },
          [ 92003224 ] = {
            TotalFrame = 100,
            ForceFrame = 99,
            SkillBreakSkillFrame = 31,
            SkillType = 0,
            AttrType = 5,
            UseCostType = 0,
            UseCostValue = 0,
            CDtime = 0.0,
            FrameEvent = {
              [ 0 ] = {
                {

                  Name = "Attack007",
                  StartFrame = 25,
                  FrameTime = 0,
                  EventType = 2,

                },
                {

                  AddType = 1,
                  BuffId = 92003997,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 0,
                  EventType = 9,

                }
              },
              [ 1 ] = {
                {

                  EntityId = 9200399907,
                  LifeBindSkill = false,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 0.0,
                  BornOffsetZ = 0.0,
                  TerriaOffsetY = 0.0,
                  BornRotateOffsetX = 0.0,
                  BornRotateOffsetY = 0.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = false,
                  LookAngleRange = 360.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 1,
                  EventType = 1,

                }
              },
              [ 4 ] = {
                {

                  RotateType = 2,
                  UseSelfSpeed = 0,
                  SpeedOffset = 180.0,
                  Acceleration = 180.0,
                  RotateFrame = 18,
                  FrameTime = 4,
                  EventType = 8,

                }
              },
              [ 21 ] = {
                {

                  EntityId = 9200300701,
                  LifeBindSkill = false,
                  LifeBindSkillFrame = 0,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 0.0,
                  BornOffsetZ = 0.0,
                  TerriaOffsetY = 0.0,
                  BornRotateOffsetX = 0.0,
                  BornRotateOffsetY = 0.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = false,
                  LookAngleRange = 360.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 21,
                  EventType = 1,

                }
              },
              [ 31 ] = {
                {

                  Type = 92003224,
                  Frame = 10,
                  FrameTime = 31,
                  EventType = 3,
                  ActiveSign = {
                    Sign = {
                      8888
                    },
                  }
                }
              },
              [ 50 ] = {
                {

                  RotateType = 2,
                  UseSelfSpeed = 0,
                  SpeedOffset = 180.0,
                  Acceleration = 360.0,
                  RotateFrame = 10,
                  FrameTime = 50,
                  EventType = 8,
                  ActiveSign = {
                    Sign = {
                      9999
                    },
                  }
                }
              },
              [ 55 ] = {
                {

                  AddType = 2,
                  BuffId = 92003997,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 55,
                  EventType = 9,

                }
              },
            }
          },
          [ 92003225 ] = {
            TotalFrame = 180,
            ForceFrame = 176,
            SkillType = 0,
            AttrType = 5,
            UseCostType = 0,
            UseCostValue = 0,
            CDtime = 0.0,
            FrameEvent = {
              [ 0 ] = {
                {

                  AddType = 1,
                  BuffId = 92003997,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 0,
                  EventType = 9,

                },
                {

                  Name = "Attack223",
                  StartFrame = 3,
                  FrameTime = 0,
                  EventType = 2,

                }
              },
              [ 54 ] = {
                {

                  Name = "Attack224",
                  StartFrame = 0,
                  FrameTime = 54,
                  EventType = 2,

                }
              },
              [ 114 ] = {
                {

                  Name = "Attack225",
                  StartFrame = 0,
                  FrameTime = 114,
                  EventType = 2,

                }
              },
              [ 180 ] = {
                {

                  AddType = 2,
                  BuffId = 92003997,
                  LifeBindBuff = false,
                  Count = 1,
                  FrameTime = 180,
                  EventType = 9,

                }
              },
            }
          },
          [ 92003226 ] = {
            TotalFrame = 80,
            ForceFrame = 68,
            SkillBreakSkillFrame = 68,
            SkillType = 0,
            AttrType = 5,
            UseCostType = 0,
            UseCostValue = 0,
            CDtime = 0.0,
            FrameEvent = {
              [ 0 ] = {
                {

                  AddType = 1,
                  BuffId = 92003104,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 0,
                  EventType = 9,
                  ActiveSign = {
                    Sign = {
                      123123
                    },
                  }
                },
                {

                  Name = "Attack226",
                  StartFrame = 0,
                  FrameTime = 0,
                  EventType = 2,

                },
                {

                  AddType = 1,
                  BuffId = 92003997,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 0,
                  EventType = 9,

                }
              },
              [ 8 ] = {
                {

                  RotateType = 2,
                  UseSelfSpeed = 0,
                  SpeedOffset = 180.0,
                  Acceleration = 360.0,
                  RotateFrame = 6,
                  FrameTime = 8,
                  EventType = 8,

                }
              },
              [ 29 ] = {
                {

                  RotateType = 2,
                  UseSelfSpeed = 0,
                  SpeedOffset = 180.0,
                  Acceleration = 360.0,
                  RotateFrame = 3,
                  FrameTime = 29,
                  EventType = 8,

                }
              },
              [ 50 ] = {
                {

                  AddType = 2,
                  BuffId = 92003997,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 50,
                  EventType = 9,

                }
              },
              [ 60 ] = {
                {

                  AddType = 2,
                  BuffId = 92003104,
                  LifeBindBuff = false,
                  Count = 1,
                  FrameTime = 60,
                  EventType = 9,

                }
              },
            }
          },
          [ 92003227 ] = {
            TotalFrame = 85,
            ForceFrame = 85,
            SkillBreakSkillFrame = 85,
            SkillType = 0,
            AttrType = 5,
            UseCostType = 0,
            UseCostValue = 0,
            CDtime = 0.0,
            FrameEvent = {
              [ 0 ] = {
                {

                  Name = "Attack227",
                  StartFrame = 0,
                  FrameTime = 0,
                  EventType = 2,

                }
              },
              [ 5 ] = {
                {

                  RotateType = 2,
                  UseSelfSpeed = 0,
                  SpeedOffset = 180.0,
                  Acceleration = 360.0,
                  RotateFrame = 27,
                  FrameTime = 5,
                  EventType = 8,

                }
              },
              [ 31 ] = {
                {

                  EntityId = 92003009003,
                  LifeBindSkill = false,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 0.0,
                  BornOffsetZ = 0.0,
                  TerriaOffsetY = 0.0,
                  BornRotateOffsetX = 0.0,
                  BornRotateOffsetY = 0.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = false,
                  LookAngleRange = 360.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 31,
                  EventType = 1,

                }
              },
              [ 32 ] = {
                {

                  PostProcessType = 2,
                  PostProcessParams = {
                    Strength = 0.2,
                    Dir = 0,
                    Radius = 1.0,
                    Alpha = 0.6,
                    AlphaCurveId = 1501,
                    Direction = 0,
                    Count = 4,
                    Center = { 0.6, -1.0 },
                    ShowTemplateID = false,
                    TemplateID = 92003005,
                    PostProcessType = 2,
                    Duration = 3,
                    ID = 0
                  },
                  LifeBindSkill = false,
                  FrameTime = 32,
                  EventType = 16,

                },
                {

                  CameraShake = {
                    {
                      ShakeType = 3,
                      Random = 0.0,
                      StartOffset = 0.0,
                      StartAmplitude = -1.0,
                      StartFrequency = 6.0,
                      TargetAmplitude = 0.0,
                      TargetFrequency = 4.0,
                      AmplitudeChangeTime = 0.33,
                      FrequencyChangeTime = 0.528,
                      DurationTime = 0.66,
                      Sign = 0.0,
                      DistanceDampingId = 0.0
                    }
                  },
                  FrameTime = 32,
                  EventType = 4,

                },
                {

                  EntityId = 92003009001,
                  LifeBindSkill = false,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 0.0,
                  BornOffsetZ = 0.0,
                  TerriaOffsetY = 0.0,
                  BornRotateOffsetX = 0.0,
                  BornRotateOffsetY = 0.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = false,
                  LookAngleRange = 360.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 32,
                  EventType = 1,

                },
                {

                  EntityId = 9200300901,
                  LifeBindSkill = false,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 0.0,
                  BornOffsetZ = 0.0,
                  TerriaOffsetY = 0.0,
                  BornRotateOffsetX = 0.0,
                  BornRotateOffsetY = 0.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = false,
                  LookAngleRange = 360.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 32,
                  EventType = 1,

                }
              },
            }
          },
          [ 92003228 ] = {
            TotalFrame = 64,
            ForceFrame = 64,
            SkillBreakSkillFrame = 64,
            SkillType = 0,
            AttrType = 5,
            UseCostType = 0,
            UseCostValue = 0,
            CDtime = 0.0,
            FrameEvent = {
              [ 0 ] = {
                {

                  Name = "Attack228",
                  StartFrame = 0,
                  FrameTime = 0,
                  EventType = 2,

                },
                {

                  AddType = 1,
                  BuffId = 92003997,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 0,
                  EventType = 9,

                },
                {

                  RotateType = 2,
                  UseSelfSpeed = 0,
                  SpeedOffset = 180.0,
                  Acceleration = 360.0,
                  RotateFrame = 14,
                  FrameTime = 0,
                  EventType = 8,

                }
              },
              [ 5 ] = {
                {

                  EntityId = 9200399907,
                  LifeBindSkill = false,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 0.0,
                  BornOffsetZ = 0.0,
                  TerriaOffsetY = 0.0,
                  BornRotateOffsetX = 0.0,
                  BornRotateOffsetY = 0.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = false,
                  LookAngleRange = 360.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 5,
                  EventType = 1,

                }
              },
              [ 14 ] = {
                {

                  RotateType = 2,
                  UseSelfSpeed = 0,
                  SpeedOffset = 180.0,
                  Acceleration = 360.0,
                  RotateFrame = 15,
                  FrameTime = 14,
                  EventType = 8,

                }
              },
              [ 25 ] = {
                {

                  EntityId = 92003228001,
                  LifeBindSkill = false,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 0.0,
                  BornOffsetZ = 0.0,
                  TerriaOffsetY = 0.0,
                  BornRotateOffsetX = 0.0,
                  BornRotateOffsetY = 0.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = false,
                  LookAngleRange = 360.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 25,
                  EventType = 1,

                },
                {

                  EntityId = 9200320601,
                  LifeBindSkill = false,
                  LifeBindSkillFrame = 0,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 0.0,
                  BornOffsetZ = 0.0,
                  TerriaOffsetY = 0.0,
                  BornRotateOffsetX = 0.0,
                  BornRotateOffsetY = 0.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = false,
                  LookAngleRange = 360.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 25,
                  EventType = 1,

                }
              },
              [ 29 ] = {
                {

                  EntityId = 9200399907,
                  LifeBindSkill = false,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 0.0,
                  BornOffsetZ = 0.0,
                  TerriaOffsetY = 0.0,
                  BornRotateOffsetX = 0.0,
                  BornRotateOffsetY = 0.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = false,
                  LookAngleRange = 360.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 29,
                  EventType = 1,

                }
              },
              [ 41 ] = {
                {

                  RotateType = 2,
                  UseSelfSpeed = 0,
                  SpeedOffset = 180.0,
                  Acceleration = 360.0,
                  RotateFrame = 20,
                  FrameTime = 41,
                  EventType = 8,

                }
              },
              [ 53 ] = {
                {

                  EntityId = 92003228002,
                  LifeBindSkill = false,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 0.0,
                  BornOffsetZ = 0.0,
                  TerriaOffsetY = 0.0,
                  BornRotateOffsetX = 0.0,
                  BornRotateOffsetY = 0.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = false,
                  LookAngleRange = 360.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 53,
                  EventType = 1,

                }
              },
              [ 54 ] = {
                {

                  EntityId = 9200320701,
                  LifeBindSkill = false,
                  LifeBindSkillFrame = 0,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 0.0,
                  BornOffsetZ = 0.0,
                  TerriaOffsetY = 0.0,
                  BornRotateOffsetX = 0.0,
                  BornRotateOffsetY = 0.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = false,
                  LookAngleRange = 360.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 54,
                  EventType = 1,

                }
              },
              [ 63 ] = {
                {

                  Type = 92003228,
                  Frame = 1,
                  FrameTime = 63,
                  EventType = 3,

                }
              },
            }
          },
          [ 92003229 ] = {
            TotalFrame = 120,
            ForceFrame = 120,
            SkillBreakSkillFrame = 104,
            SkillType = 0,
            AttrType = 5,
            UseCostType = 0,
            UseCostValue = 0,
            CDtime = 0.0,
            FrameEvent = {
              [ 0 ] = {
                {

                  Name = "Attack228",
                  StartFrame = 64,
                  FrameTime = 0,
                  EventType = 2,

                }
              },
              [ 4 ] = {
                {

                  AddType = 1,
                  BuffId = 92003997,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 4,
                  EventType = 9,

                }
              },
              [ 5 ] = {
                {

                  RotateType = 2,
                  UseSelfSpeed = 0,
                  SpeedOffset = 180.0,
                  Acceleration = 180.0,
                  RotateFrame = 22,
                  FrameTime = 5,
                  EventType = 8,

                }
              },
              [ 7 ] = {
                {

                  EntityId = 9200399907,
                  LifeBindSkill = false,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 0.0,
                  BornOffsetZ = 0.0,
                  TerriaOffsetY = 0.0,
                  BornRotateOffsetX = 0.0,
                  BornRotateOffsetY = 0.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = false,
                  LookAngleRange = 360.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 7,
                  EventType = 1,

                }
              },
              [ 27 ] = {
                {

                  EntityId = 92003228003,
                  LifeBindSkill = false,
                  LifeBindSkillFrame = 0,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 0.0,
                  BornOffsetZ = 0.0,
                  TerriaOffsetY = 0.0,
                  BornRotateOffsetX = 0.0,
                  BornRotateOffsetY = 0.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = false,
                  LookAngleRange = 360.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 27,
                  EventType = 1,

                }
              },
              [ 29 ] = {
                {

                  EntityId = 9200320801,
                  LifeBindSkill = false,
                  LifeBindSkillFrame = 0,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 0.0,
                  BornOffsetZ = 0.0,
                  TerriaOffsetY = 0.0,
                  BornRotateOffsetX = 0.0,
                  BornRotateOffsetY = 0.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = false,
                  LookAngleRange = 360.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 29,
                  EventType = 1,

                },
                {

                  PostProcessType = 2,
                  PostProcessParams = {
                    Strength = 0.2,
                    Dir = 0,
                    Radius = 1.0,
                    Alpha = 0.6,
                    AlphaCurveId = 1501,
                    Direction = 0,
                    Count = 4,
                    Center = { 0.6, -1.0 },
                    ShowTemplateID = false,
                    TemplateID = 92003005,
                    PostProcessType = 2,
                    Duration = 3,
                    ID = 0
                  },
                  LifeBindSkill = false,
                  FrameTime = 29,
                  EventType = 16,

                },
                {

                  EntityId = 92003005002,
                  LifeBindSkill = false,
                  LifeBindSkillFrame = 0,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 0.0,
                  BornOffsetZ = 0.0,
                  TerriaOffsetY = 0.0,
                  BornRotateOffsetX = 0.0,
                  BornRotateOffsetY = 0.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = false,
                  LookAngleRange = 360.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 29,
                  EventType = 1,

                }
              },
              [ 30 ] = {
                {

                  CameraShake = {
                    {
                      ShakeType = 3,
                      Random = 0.0,
                      StartOffset = 0.0,
                      StartAmplitude = 1.2,
                      StartFrequency = 6.0,
                      TargetAmplitude = 0.1,
                      TargetFrequency = 3.0,
                      AmplitudeChangeTime = 0.33,
                      FrequencyChangeTime = 0.297,
                      DurationTime = 0.561,
                      Sign = 0.0,
                      DistanceDampingId = 0.0
                    }
                  },
                  FrameTime = 30,
                  EventType = 4,

                }
              },
              [ 84 ] = {
                {

                  RotateType = 2,
                  UseSelfSpeed = 0,
                  SpeedOffset = 180.0,
                  Acceleration = 360.0,
                  RotateFrame = 10,
                  FrameTime = 84,
                  EventType = 8,

                }
              },
              [ 104 ] = {
                {

                  Type = 92003218,
                  Frame = 3,
                  FrameTime = 104,
                  EventType = 3,

                }
              },
              [ 109 ] = {
                {

                  AddType = 2,
                  BuffId = 92003997,
                  LifeBindBuff = true,
                  Count = 99,
                  FrameTime = 109,
                  EventType = 9,

                }
              },
            }
          },
          [ 92003230 ] = {
            TotalFrame = 124,
            ForceFrame = 124,
            SkillBreakSkillFrame = 124,
            SkillType = 0,
            AttrType = 5,
            UseCostType = 0,
            UseCostValue = 0,
            CDtime = 0.0,
            FrameEvent = {
              [ 0 ] = {
                {

                  Name = "Attack228",
                  StartFrame = 64,
                  FrameTime = 0,
                  EventType = 2,

                }
              },
              [ 4 ] = {
                {

                  AddType = 1,
                  BuffId = 92003997,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 4,
                  EventType = 9,

                },
                {

                  EntityId = 9200399905,
                  LifeBindSkill = false,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 0.0,
                  BornOffsetZ = 0.0,
                  TerriaOffsetY = 0.0,
                  BornRotateOffsetX = 0.0,
                  BornRotateOffsetY = 0.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = false,
                  LookAngleRange = 360.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 4,
                  EventType = 1,

                }
              },
              [ 5 ] = {
                {

                  RotateType = 2,
                  UseSelfSpeed = 0,
                  SpeedOffset = 180.0,
                  Acceleration = 180.0,
                  RotateFrame = 22,
                  FrameTime = 5,
                  EventType = 8,

                }
              },
              [ 11 ] = {
                {

                  AddType = 1,
                  BuffId = 92003998,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 11,
                  EventType = 9,

                }
              },
              [ 20 ] = {
                {

                  EntityId = 9200399907,
                  LifeBindSkill = false,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 0.0,
                  BornOffsetZ = 0.0,
                  TerriaOffsetY = 0.0,
                  BornRotateOffsetX = 0.0,
                  BornRotateOffsetY = 0.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = false,
                  LookAngleRange = 360.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 20,
                  EventType = 1,

                }
              },
              [ 22 ] = {
                {

                  AddType = 2,
                  BuffId = 92003998,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 22,
                  EventType = 9,

                }
              },
              [ 27 ] = {
                {

                  EntityId = 92003228003,
                  LifeBindSkill = false,
                  LifeBindSkillFrame = 0,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 0.0,
                  BornOffsetZ = 0.0,
                  TerriaOffsetY = 0.0,
                  BornRotateOffsetX = 0.0,
                  BornRotateOffsetY = 0.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = false,
                  LookAngleRange = 360.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 27,
                  EventType = 1,

                }
              },
              [ 29 ] = {
                {

                  EntityId = 92003005002,
                  LifeBindSkill = false,
                  LifeBindSkillFrame = 0,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 0.0,
                  BornOffsetZ = 0.0,
                  TerriaOffsetY = 0.0,
                  BornRotateOffsetX = 0.0,
                  BornRotateOffsetY = 0.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = false,
                  LookAngleRange = 360.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 29,
                  EventType = 1,

                },
                {

                  Type = 92003220,
                  Frame = 1,
                  FrameTime = 29,
                  EventType = 3,

                },
                {

                  PostProcessType = 2,
                  PostProcessParams = {
                    Strength = 0.2,
                    Dir = 0,
                    Radius = 1.0,
                    Alpha = 0.6,
                    AlphaCurveId = 1501,
                    Direction = 0,
                    Count = 4,
                    Center = { 0.6, -1.0 },
                    ShowTemplateID = false,
                    TemplateID = 92003005,
                    PostProcessType = 2,
                    Duration = 3,
                    ID = 0
                  },
                  LifeBindSkill = false,
                  FrameTime = 29,
                  EventType = 16,

                },
                {

                  EntityId = 9200320801,
                  LifeBindSkill = false,
                  LifeBindSkillFrame = 0,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 0.0,
                  BornOffsetZ = 0.0,
                  TerriaOffsetY = 0.0,
                  BornRotateOffsetX = 0.0,
                  BornRotateOffsetY = 0.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = false,
                  LookAngleRange = 360.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 29,
                  EventType = 1,

                }
              },
              [ 30 ] = {
                {

                  CameraShake = {
                    {
                      ShakeType = 3,
                      Random = 0.0,
                      StartOffset = 0.0,
                      StartAmplitude = 1.2,
                      StartFrequency = 6.0,
                      TargetAmplitude = 0.1,
                      TargetFrequency = 3.0,
                      AmplitudeChangeTime = 0.33,
                      FrequencyChangeTime = 0.297,
                      DurationTime = 0.561,
                      Sign = 0.0,
                      DistanceDampingId = 0.0
                    }
                  },
                  FrameTime = 30,
                  EventType = 4,

                }
              },
              [ 49 ] = {
                {

                  EntityId = 9200301902,
                  LifeBindSkill = false,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 0.0,
                  BornOffsetZ = 2.0,
                  TerriaOffsetY = 0.0,
                  BornRotateOffsetX = 0.0,
                  BornRotateOffsetY = 0.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = false,
                  LookAngleRange = 360.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 49,
                  EventType = 1,

                }
              },
              [ 52 ] = {
                {

                  EntityId = 9200301902,
                  LifeBindSkill = false,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 0.0,
                  BornOffsetZ = 5.5,
                  TerriaOffsetY = 0.0,
                  BornRotateOffsetX = 0.0,
                  BornRotateOffsetY = 0.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = false,
                  LookAngleRange = 360.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 52,
                  EventType = 1,

                }
              },
              [ 55 ] = {
                {

                  EntityId = 9200301902,
                  LifeBindSkill = false,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 0.0,
                  BornOffsetZ = 9.0,
                  TerriaOffsetY = 0.0,
                  BornRotateOffsetX = 0.0,
                  BornRotateOffsetY = 0.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = false,
                  LookAngleRange = 360.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 55,
                  EventType = 1,

                }
              },
              [ 58 ] = {
                {

                  EntityId = 9200301902,
                  LifeBindSkill = false,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 0.0,
                  BornOffsetZ = 12.5,
                  TerriaOffsetY = 0.0,
                  BornRotateOffsetX = 0.0,
                  BornRotateOffsetY = 0.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = false,
                  LookAngleRange = 360.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 58,
                  EventType = 1,

                }
              },
              [ 84 ] = {
                {

                  RotateType = 2,
                  UseSelfSpeed = 0,
                  SpeedOffset = 180.0,
                  Acceleration = 360.0,
                  RotateFrame = 10,
                  FrameTime = 84,
                  EventType = 8,

                }
              },
              [ 94 ] = {
                {

                  AddType = 2,
                  BuffId = 92003997,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 94,
                  EventType = 9,

                }
              },
            }
          },
          [ 92003250 ] = {
            TotalFrame = 42,
            ForceFrame = 42,
            SkillType = 0,
            AttrType = 5,
            UseCostType = 0,
            UseCostValue = 0,
            CDtime = 0.0,
            FrameEvent = {
              [ 0 ] = {
                {

                  Name = "Tandao",
                  StartFrame = 0,
                  FrameTime = 0,
                  EventType = 2,

                }
              },
            }
          },
          [ 92003301 ] = {
            TotalFrame = 86,
            ForceFrame = 86,
            SkillBreakSkillFrame = 86,
            SkillType = 0,
            AttrType = 5,
            UseCostType = 0,
            UseCostValue = 0,
            CDtime = 0.0,
            FrameEvent = {
              [ 0 ] = {
                {

                  Name = "Attack212",
                  StartFrame = 0,
                  FrameTime = 0,
                  EventType = 2,

                }
              },
              [ 20 ] = {
                {

                  Name = "Attack212",
                  StartFrame = 48,
                  FrameTime = 20,
                  EventType = 2,

                }
              },
              [ 38 ] = {
                {

                  Name = "Attack203",
                  StartFrame = 5,
                  FrameTime = 38,
                  EventType = 2,

                }
              },
            }
          },
          [ 92003303 ] = {
            TotalFrame = 160,
            ForceFrame = 160,
            SkillBreakSkillFrame = 160,
            SkillType = 0,
            AttrType = 5,
            UseCostType = 0,
            UseCostValue = 0,
            CDtime = 0.0,
            FrameEvent = {
              [ 0 ] = {
                {

                  Name = "Attack010_1",
                  StartFrame = 0,
                  FrameTime = 0,
                  EventType = 2,

                }
              },
              [ 115 ] = {
                {

                  Name = "Attack003_1",
                  StartFrame = 2,
                  FrameTime = 115,
                  EventType = 2,

                }
              },
            }
          },
          [ 92003305 ] = {
            TotalFrame = 114,
            ForceFrame = 112,
            SkillType = 0,
            AttrType = 5,
            UseCostType = 0,
            UseCostValue = 0,
            CDtime = 0.0,
            FrameEvent = {
              [ 0 ] = {
                {

                  Name = "Attack005",
                  StartFrame = 6,
                  FrameTime = 0,
                  EventType = 2,

                },
                {

                  AddType = 1,
                  BuffId = 92003997,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 0,
                  EventType = 9,

                },
                {

                  RotateType = 2,
                  UseSelfSpeed = 0,
                  SpeedOffset = 180.0,
                  Acceleration = 180.0,
                  RotateFrame = 11,
                  FrameTime = 0,
                  EventType = 8,
                  ActiveSign = {
                    Sign = {
                      9999
                    },
                  }
                }
              },
              [ 16 ] = {
                {

                  EntityId = 9200399907,
                  LifeBindSkill = false,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 0.0,
                  BornOffsetZ = 0.0,
                  TerriaOffsetY = 0.0,
                  BornRotateOffsetX = 0.0,
                  BornRotateOffsetY = 0.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = false,
                  LookAngleRange = 360.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 16,
                  EventType = 1,

                }
              },
              [ 24 ] = {
                {

                  RotateType = 2,
                  UseSelfSpeed = 0,
                  SpeedOffset = 180.0,
                  Acceleration = 360.0,
                  RotateFrame = 10,
                  FrameTime = 24,
                  EventType = 8,
                  ActiveSign = {
                    Sign = {
                      9999
                    },
                  }
                }
              },
              [ 36 ] = {
                {

                  EntityId = 92003005001,
                  LifeBindSkill = false,
                  LifeBindSkillFrame = 0,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 0.0,
                  BornOffsetZ = 0.0,
                  TerriaOffsetY = 0.0,
                  BornRotateOffsetX = 0.0,
                  BornRotateOffsetY = 0.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = false,
                  LookAngleRange = 360.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 36,
                  EventType = 1,

                },
                {

                  EntityId = 9200300501,
                  LifeBindSkill = false,
                  LifeBindSkillFrame = 0,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 0.0,
                  BornOffsetZ = 0.0,
                  TerriaOffsetY = 0.0,
                  BornRotateOffsetX = 0.0,
                  BornRotateOffsetY = 0.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = false,
                  LookAngleRange = 0.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 36,
                  EventType = 1,

                }
              },
              [ 37 ] = {
                {

                  EntityId = 9200300502,
                  LifeBindSkill = false,
                  LifeBindSkillFrame = 0,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 0.0,
                  BornOffsetZ = 0.0,
                  TerriaOffsetY = 0.0,
                  BornRotateOffsetX = 0.0,
                  BornRotateOffsetY = 0.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = false,
                  LookAngleRange = 0.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 37,
                  EventType = 1,

                },
                {

                  PostProcessType = 2,
                  PostProcessParams = {
                    Strength = 0.2,
                    Dir = 0,
                    Radius = 1.0,
                    Alpha = 0.6,
                    AlphaCurveId = 1501,
                    Direction = 0,
                    Count = 4,
                    Center = { 0.6, -1.0 },
                    ShowTemplateID = false,
                    TemplateID = 92003005,
                    PostProcessType = 2,
                    Duration = 3,
                    ID = 0
                  },
                  LifeBindSkill = false,
                  FrameTime = 37,
                  EventType = 16,

                },
                {

                  CameraShake = {
                    {
                      ShakeType = 3,
                      Random = 0.0,
                      StartOffset = 0.0,
                      StartAmplitude = 1.2,
                      StartFrequency = 6.0,
                      TargetAmplitude = 0.1,
                      TargetFrequency = 3.0,
                      AmplitudeChangeTime = 0.33,
                      FrequencyChangeTime = 0.297,
                      DurationTime = 0.561,
                      Sign = 0.0,
                      DistanceDampingId = 0.0
                    }
                  },
                  FrameTime = 37,
                  EventType = 4,

                },
                {

                  EntityId = 92003005002,
                  LifeBindSkill = false,
                  LifeBindSkillFrame = 0,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 0.0,
                  BornOffsetZ = 0.0,
                  TerriaOffsetY = 0.0,
                  BornRotateOffsetX = 0.0,
                  BornRotateOffsetY = 0.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = false,
                  LookAngleRange = 360.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 37,
                  EventType = 1,

                }
              },
              [ 90 ] = {
                {

                  AddType = 2,
                  BuffId = 92003997,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 90,
                  EventType = 9,

                },
                {

                  RotateType = 2,
                  UseSelfSpeed = 0,
                  SpeedOffset = 90.0,
                  Acceleration = 90.0,
                  RotateFrame = 7,
                  FrameTime = 90,
                  EventType = 8,
                  ActiveSign = {
                    Sign = {
                      123456
                    },
                  }
                }
              },
            }
          },
          [ 92003306 ] = {
            TotalFrame = 106,
            ForceFrame = 98,
            SkillType = 0,
            AttrType = 5,
            UseCostType = 0,
            UseCostValue = 0,
            CDtime = 0.0,
            FrameEvent = {
              [ 0 ] = {
                {

                  Name = "Attack006",
                  StartFrame = 0,
                  FrameTime = 0,
                  EventType = 2,

                },
                {

                  AddType = 1,
                  BuffId = 92003997,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 0,
                  EventType = 9,

                }
              },
              [ 3 ] = {
                {

                  RotateType = 2,
                  UseSelfSpeed = 0,
                  SpeedOffset = 360.0,
                  Acceleration = 360.0,
                  RotateFrame = 14,
                  FrameTime = 3,
                  EventType = 8,

                }
              },
              [ 10 ] = {
                {

                  EntityId = 9200399907,
                  LifeBindSkill = false,
                  CreateEntityType = 1,
                  BindTransform = "LeftEyeCase",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 0.0,
                  BornOffsetZ = 0.0,
                  TerriaOffsetY = 0.0,
                  BornRotateOffsetX = 0.0,
                  BornRotateOffsetY = 0.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = false,
                  LookAngleRange = 360.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 10,
                  EventType = 1,

                }
              },
              [ 29 ] = {
                {

                  EntityId = 92003006001,
                  LifeBindSkill = false,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 0.0,
                  BornOffsetZ = 0.0,
                  TerriaOffsetY = 0.0,
                  BornRotateOffsetX = 0.0,
                  BornRotateOffsetY = 0.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = false,
                  LookAngleRange = 360.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 29,
                  EventType = 1,

                }
              },
              [ 30 ] = {
                {

                  RotateType = 2,
                  UseSelfSpeed = 0,
                  SpeedOffset = 360.0,
                  Acceleration = 360.0,
                  RotateFrame = 7,
                  FrameTime = 30,
                  EventType = 8,

                },
                {

                  RotateType = 2,
                  UseSelfSpeed = 0,
                  SpeedOffset = 180.0,
                  Acceleration = 180.0,
                  RotateFrame = 8,
                  FrameTime = 30,
                  EventType = 8,

                },
                {

                  EntityId = 9200300601,
                  LifeBindSkill = false,
                  LifeBindSkillFrame = 0,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 0.0,
                  BornOffsetZ = 0.0,
                  TerriaOffsetY = 0.0,
                  BornRotateOffsetX = 0.0,
                  BornRotateOffsetY = 0.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = false,
                  LookAngleRange = 360.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 30,
                  EventType = 1,

                }
              },
              [ 51 ] = {
                {

                  Type = 92003306,
                  Frame = 1,
                  FrameTime = 51,
                  EventType = 3,
                  ActiveSign = {
                    Sign = {
                      8888
                    },
                  }
                }
              },
              [ 68 ] = {
                {

                  RotateType = 2,
                  UseSelfSpeed = 0,
                  SpeedOffset = 180.0,
                  Acceleration = 360.0,
                  RotateFrame = 10,
                  FrameTime = 68,
                  EventType = 8,
                  ActiveSign = {
                    Sign = {
                      9999
                    },
                  }
                }
              },
              [ 73 ] = {
                {

                  AddType = 2,
                  BuffId = 92003997,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 73,
                  EventType = 9,

                }
              },
            }
          },
          [ 92003307 ] = {
            TotalFrame = 112,
            ForceFrame = 111,
            SkillType = 0,
            AttrType = 5,
            UseCostType = 0,
            UseCostValue = 0,
            CDtime = 0.0,
            FrameEvent = {
              [ 0 ] = {
                {

                  Name = "Attack007",
                  StartFrame = 0,
                  FrameTime = 0,
                  EventType = 2,

                },
                {

                  AddType = 1,
                  BuffId = 92003997,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 0,
                  EventType = 9,

                }
              },
              [ 4 ] = {
                {

                  RotateType = 2,
                  UseSelfSpeed = 0,
                  SpeedOffset = 360.0,
                  Acceleration = 360.0,
                  RotateFrame = 5,
                  FrameTime = 4,
                  EventType = 8,
                  ActiveSign = {
                    Sign = {
                      9996
                    },
                  }
                }
              },
              [ 26 ] = {
                {

                  EntityId = 9200399907,
                  LifeBindSkill = false,
                  CreateEntityType = 1,
                  BindTransform = "LeftEyeCase",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 0.0,
                  BornOffsetZ = 0.0,
                  TerriaOffsetY = 0.0,
                  BornRotateOffsetX = 0.0,
                  BornRotateOffsetY = 0.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = false,
                  LookAngleRange = 360.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 26,
                  EventType = 1,

                }
              },
              [ 37 ] = {
                {

                  RotateType = 2,
                  UseSelfSpeed = 0,
                  SpeedOffset = 180.0,
                  Acceleration = 180.0,
                  RotateFrame = 5,
                  FrameTime = 37,
                  EventType = 8,

                }
              },
              [ 43 ] = {
                {

                  RotateType = 2,
                  UseSelfSpeed = 0,
                  SpeedOffset = 180.0,
                  Acceleration = 360.0,
                  RotateFrame = 9,
                  FrameTime = 43,
                  EventType = 8,

                },
                {

                  Direction = 1,
                  CustomX = 0.0,
                  CustomY = 0.0,
                  CustomZ = 0.0,
                  SpeedType = 0,
                  SpeedOffset = 5.0,
                  Acceleration = 5.0,
                  MoveFrame = 2,
                  InputSpeed = 0.0,
                  MinDistance = 1.5,
                  IgnoreYAxis = true,
                  SkillMoveDone = 4,
                  FrameTime = 43,
                  EventType = 7,
                  ActiveSign = {
                    Sign = {
                      8888
                    },
                  }
                }
              },
              [ 45 ] = {
                {

                  EntityId = 92003007001,
                  LifeBindSkill = false,
                  LifeBindSkillFrame = 0,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 0.0,
                  BornOffsetZ = 0.0,
                  TerriaOffsetY = 0.0,
                  BornRotateOffsetX = 0.0,
                  BornRotateOffsetY = 0.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = false,
                  LookAngleRange = 360.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 45,
                  EventType = 1,

                }
              },
              [ 46 ] = {
                {

                  EntityId = 9200300701,
                  LifeBindSkill = false,
                  LifeBindSkillFrame = 0,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 0.0,
                  BornOffsetZ = 0.0,
                  TerriaOffsetY = 0.0,
                  BornRotateOffsetX = 0.0,
                  BornRotateOffsetY = 0.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = false,
                  LookAngleRange = 360.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 46,
                  EventType = 1,

                }
              },
              [ 56 ] = {
                {

                  Type = 92003224,
                  Frame = 10,
                  FrameTime = 56,
                  EventType = 3,
                  ActiveSign = {
                    Sign = {
                      8888
                    },
                  }
                }
              },
              [ 80 ] = {
                {

                  AddType = 2,
                  BuffId = 92003997,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 80,
                  EventType = 9,

                }
              },
            }
          },
          [ 92003308 ] = {
            TotalFrame = 87,
            ForceFrame = 85,
            SkillType = 0,
            AttrType = 5,
            UseCostType = 0,
            UseCostValue = 0,
            CDtime = 0.0,
            FrameEvent = {
              [ 0 ] = {
                {

                  Name = "Attack007",
                  StartFrame = 25,
                  FrameTime = 0,
                  EventType = 2,

                },
                {

                  AddType = 1,
                  BuffId = 92003997,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 0,
                  EventType = 9,

                }
              },
              [ 1 ] = {
                {

                  EntityId = 9200399907,
                  LifeBindSkill = false,
                  CreateEntityType = 1,
                  BindTransform = "LeftEyeCase",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 0.0,
                  BornOffsetZ = 0.0,
                  TerriaOffsetY = 0.0,
                  BornRotateOffsetX = 0.0,
                  BornRotateOffsetY = 0.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = false,
                  LookAngleRange = 360.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 1,
                  EventType = 1,

                }
              },
              [ 4 ] = {
                {

                  RotateType = 2,
                  UseSelfSpeed = 0,
                  SpeedOffset = 180.0,
                  Acceleration = 180.0,
                  RotateFrame = 18,
                  FrameTime = 4,
                  EventType = 8,

                }
              },
              [ 13 ] = {
                {

                  RotateType = 2,
                  UseSelfSpeed = 0,
                  SpeedOffset = 180.0,
                  Acceleration = 360.0,
                  RotateFrame = 11,
                  FrameTime = 13,
                  EventType = 8,

                }
              },
              [ 18 ] = {
                {

                  Direction = 1,
                  CustomX = 0.0,
                  CustomY = 0.0,
                  CustomZ = 0.0,
                  SpeedType = 1,
                  SpeedOffset = 8.0,
                  Acceleration = 5.0,
                  MoveFrame = 2,
                  InputSpeed = 0.0,
                  MinDistance = 1.5,
                  IgnoreYAxis = true,
                  SkillMoveDone = 4,
                  FrameTime = 18,
                  EventType = 7,
                  ActiveSign = {
                    Sign = {
                      8888
                    },
                  }
                }
              },
              [ 20 ] = {
                {

                  EntityId = 92003006001,
                  LifeBindSkill = false,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 0.0,
                  BornOffsetZ = 0.0,
                  TerriaOffsetY = 0.0,
                  BornRotateOffsetX = 0.0,
                  BornRotateOffsetY = 0.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = false,
                  LookAngleRange = 360.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 20,
                  EventType = 1,

                }
              },
              [ 21 ] = {
                {

                  EntityId = 9200300701,
                  LifeBindSkill = false,
                  LifeBindSkillFrame = 0,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 0.0,
                  BornOffsetZ = 0.0,
                  TerriaOffsetY = 0.0,
                  BornRotateOffsetX = 0.0,
                  BornRotateOffsetY = 0.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = false,
                  LookAngleRange = 360.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 21,
                  EventType = 1,

                }
              },
              [ 30 ] = {
                {

                  AddType = 2,
                  BuffId = 92003997,
                  LifeBindBuff = true,
                  Count = 99,
                  FrameTime = 30,
                  EventType = 9,

                }
              },
              [ 50 ] = {
                {

                  RotateType = 2,
                  UseSelfSpeed = 0,
                  SpeedOffset = 180.0,
                  Acceleration = 360.0,
                  RotateFrame = 10,
                  FrameTime = 50,
                  EventType = 8,
                  ActiveSign = {
                    Sign = {
                      9999
                    },
                  }
                }
              },
            }
          },
          [ 92003309 ] = {
            TotalFrame = 88,
            ForceFrame = 88,
            SkillBreakSkillFrame = 88,
            SkillType = 0,
            AttrType = 5,
            UseCostType = 0,
            UseCostValue = 0,
            CDtime = 0.0,
            FrameEvent = {
              [ 0 ] = {
                {

                  AddType = 1,
                  BuffId = 92003997,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 0,
                  EventType = 9,

                },
                {

                  Name = "Attack009",
                  StartFrame = 0,
                  FrameTime = 0,
                  EventType = 2,

                }
              },
              [ 6 ] = {
                {

                  RotateType = 2,
                  UseSelfSpeed = 0,
                  SpeedOffset = 180.0,
                  Acceleration = 360.0,
                  RotateFrame = 16,
                  FrameTime = 6,
                  EventType = 8,

                }
              },
              [ 21 ] = {
                {

                  EntityId = 92003009003,
                  LifeBindSkill = false,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 0.0,
                  BornOffsetZ = 0.0,
                  TerriaOffsetY = 0.0,
                  BornRotateOffsetX = 0.0,
                  BornRotateOffsetY = 0.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = false,
                  LookAngleRange = 360.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 21,
                  EventType = 1,

                }
              },
              [ 22 ] = {
                {

                  CameraShake = {
                    {
                      ShakeType = 3,
                      Random = 0.0,
                      StartOffset = 0.0,
                      StartAmplitude = -1.0,
                      StartFrequency = 6.0,
                      TargetAmplitude = 0.0,
                      TargetFrequency = 4.0,
                      AmplitudeChangeTime = 0.33,
                      FrequencyChangeTime = 0.528,
                      DurationTime = 0.66,
                      Sign = 0.0,
                      DistanceDampingId = 0.0
                    }
                  },
                  FrameTime = 22,
                  EventType = 4,

                },
                {

                  PostProcessType = 2,
                  PostProcessParams = {
                    Strength = 0.2,
                    Dir = 0,
                    Radius = 1.0,
                    Alpha = 0.6,
                    AlphaCurveId = 1501,
                    Direction = 0,
                    Count = 4,
                    Center = { 0.6, -1.0 },
                    ShowTemplateID = false,
                    TemplateID = 92003005,
                    PostProcessType = 2,
                    Duration = 3,
                    ID = 0
                  },
                  LifeBindSkill = false,
                  FrameTime = 22,
                  EventType = 16,

                },
                {

                  EntityId = 92003009001,
                  LifeBindSkill = false,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 0.0,
                  BornOffsetZ = 0.0,
                  TerriaOffsetY = 0.0,
                  BornRotateOffsetX = 0.0,
                  BornRotateOffsetY = 0.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = false,
                  LookAngleRange = 360.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 22,
                  EventType = 1,

                },
                {

                  EntityId = 9200300901,
                  LifeBindSkill = false,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 0.0,
                  BornOffsetZ = 0.0,
                  TerriaOffsetY = 0.0,
                  BornRotateOffsetX = 0.0,
                  BornRotateOffsetY = 0.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = false,
                  LookAngleRange = 360.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 22,
                  EventType = 1,

                }
              },
              [ 70 ] = {
                {

                  AddType = 2,
                  BuffId = 92003997,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 70,
                  EventType = 9,

                }
              },
            }
          },
          [ 92003312 ] = {
            TotalFrame = 191,
            ForceFrame = 177,
            SkillType = 0,
            AttrType = 5,
            UseCostType = 0,
            UseCostValue = 0,
            CDtime = 0.0,
            FrameEvent = {
              [ 0 ] = {
                {

                  Name = "Attack209",
                  StartFrame = 0,
                  FrameTime = 0,
                  EventType = 2,

                },
                {

                  AddType = 1,
                  BuffId = 92003997,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 0,
                  EventType = 9,

                }
              },
              [ 3 ] = {
                {

                  RotateType = 2,
                  UseSelfSpeed = 0,
                  SpeedOffset = 180.0,
                  Acceleration = 360.0,
                  RotateFrame = 36,
                  FrameTime = 3,
                  EventType = 8,
                  ActiveSign = {
                    Sign = {
                      9999
                    },
                  }
                }
              },
              [ 19 ] = {
                {

                  EntityId = 9200399907,
                  LifeBindSkill = false,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 0.0,
                  BornOffsetZ = 0.0,
                  TerriaOffsetY = 0.0,
                  BornRotateOffsetX = 0.0,
                  BornRotateOffsetY = 0.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = false,
                  LookAngleRange = 360.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 19,
                  EventType = 1,

                }
              },
              [ 38 ] = {
                {

                  EntityId = 92003209001,
                  LifeBindSkill = false,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 0.0,
                  BornOffsetZ = 0.0,
                  TerriaOffsetY = 0.0,
                  BornRotateOffsetX = 0.0,
                  BornRotateOffsetY = 0.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = false,
                  LookAngleRange = 360.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 38,
                  EventType = 1,

                }
              },
              [ 39 ] = {
                {

                  EntityId = 9200331201,
                  LifeBindSkill = false,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 0.0,
                  BornOffsetZ = 0.0,
                  TerriaOffsetY = 0.0,
                  BornRotateOffsetX = 0.0,
                  BornRotateOffsetY = 0.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = false,
                  LookAngleRange = 360.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 39,
                  EventType = 1,

                }
              },
              [ 51 ] = {
                {

                  Name = "Attack212",
                  StartFrame = 10,
                  FrameTime = 51,
                  EventType = 2,

                }
              },
              [ 61 ] = {
                {

                  EntityId = 9200399905,
                  LifeBindSkill = false,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 0.0,
                  BornOffsetZ = 0.0,
                  TerriaOffsetY = 0.0,
                  BornRotateOffsetX = 0.0,
                  BornRotateOffsetY = 0.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = false,
                  LookAngleRange = 360.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 61,
                  EventType = 1,

                },
                {

                  RotateType = 2,
                  UseSelfSpeed = 0,
                  SpeedOffset = 180.0,
                  Acceleration = 180.0,
                  RotateFrame = 25,
                  FrameTime = 61,
                  EventType = 8,

                }
              },
              [ 66 ] = {
                {

                  EntityId = 9200399906,
                  LifeBindSkill = false,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 0.0,
                  BornOffsetZ = 0.0,
                  TerriaOffsetY = 0.0,
                  BornRotateOffsetX = 0.0,
                  BornRotateOffsetY = 0.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = false,
                  LookAngleRange = 360.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 66,
                  EventType = 1,

                }
              },
              [ 78 ] = {
                {

                  AddType = 1,
                  BuffId = 900000043,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 78,
                  EventType = 9,

                }
              },
              [ 92 ] = {
                {

                  RotateType = 2,
                  UseSelfSpeed = 0,
                  SpeedOffset = 180.0,
                  Acceleration = 360.0,
                  RotateFrame = 12,
                  FrameTime = 92,
                  EventType = 8,
                  ActiveSign = {
                    Sign = {
                      9999
                    },
                  }
                }
              },
              [ 99 ] = {
                {

                  EntityId = 92003212001,
                  LifeBindSkill = false,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 0.0,
                  BornOffsetZ = 0.0,
                  TerriaOffsetY = 0.0,
                  BornRotateOffsetX = 0.0,
                  BornRotateOffsetY = 0.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = false,
                  LookAngleRange = 360.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 99,
                  EventType = 1,

                }
              },
              [ 100 ] = {
                {

                  EntityId = 9200331202,
                  LifeBindSkill = false,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 0.0,
                  BornOffsetZ = 0.0,
                  TerriaOffsetY = 0.0,
                  BornRotateOffsetX = 0.0,
                  BornRotateOffsetY = 0.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = false,
                  LookAngleRange = 360.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 100,
                  EventType = 1,

                }
              },
              [ 117 ] = {
                {

                  AddType = 2,
                  BuffId = 900000043,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 117,
                  EventType = 9,

                }
              },
              [ 126 ] = {
                {

                  EntityId = 9200301902,
                  LifeBindSkill = false,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 3.0,
                  BornOffsetY = 0.0,
                  BornOffsetZ = 3.5,
                  TerriaOffsetY = 0.0,
                  BornRotateOffsetX = 0.0,
                  BornRotateOffsetY = 0.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = false,
                  LookAngleRange = 360.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 126,
                  EventType = 1,

                }
              },
              [ 128 ] = {
                {

                  EntityId = 9200301902,
                  LifeBindSkill = false,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 0.0,
                  BornOffsetZ = 4.0,
                  TerriaOffsetY = 0.0,
                  BornRotateOffsetX = 0.0,
                  BornRotateOffsetY = 0.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = false,
                  LookAngleRange = 360.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 128,
                  EventType = 1,

                }
              },
              [ 130 ] = {
                {

                  EntityId = 9200301902,
                  LifeBindSkill = false,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = -3.0,
                  BornOffsetY = 0.0,
                  BornOffsetZ = 3.5,
                  TerriaOffsetY = 0.0,
                  BornRotateOffsetX = 0.0,
                  BornRotateOffsetY = 0.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = false,
                  LookAngleRange = 360.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 130,
                  EventType = 1,

                }
              },
              [ 132 ] = {
                {

                  EntityId = 9200301902,
                  LifeBindSkill = false,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 2.0,
                  BornOffsetY = 0.0,
                  BornOffsetZ = 5.5,
                  TerriaOffsetY = 0.0,
                  BornRotateOffsetX = 0.0,
                  BornRotateOffsetY = 0.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = false,
                  LookAngleRange = 360.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 132,
                  EventType = 1,

                }
              },
              [ 134 ] = {
                {

                  EntityId = 9200301902,
                  LifeBindSkill = false,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = -2.0,
                  BornOffsetY = 0.0,
                  BornOffsetZ = 5.5,
                  TerriaOffsetY = 0.0,
                  BornRotateOffsetX = 0.0,
                  BornRotateOffsetY = 0.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = false,
                  LookAngleRange = 360.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 134,
                  EventType = 1,

                }
              },
              [ 146 ] = {
                {

                  RotateType = 2,
                  UseSelfSpeed = 0,
                  SpeedOffset = 180.0,
                  Acceleration = 360.0,
                  RotateFrame = 20,
                  FrameTime = 146,
                  EventType = 8,
                  ActiveSign = {
                    Sign = {
                      9991
                    },
                  }
                }
              },
            }
          },
          [ 92003316 ] = {
            TotalFrame = 24,
            ForceFrame = 24,
            SkillType = 0,
            AttrType = 5,
            UseCostType = 0,
            UseCostValue = 0,
            CDtime = 0.0,
            FrameEvent = {
              [ 0 ] = {
                {

                  AddType = 1,
                  BuffId = 92003997,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 0,
                  EventType = 9,

                },
                {

                  RotateType = 2,
                  UseSelfSpeed = 0,
                  SpeedOffset = 360.0,
                  Acceleration = 360.0,
                  RotateFrame = 6,
                  FrameTime = 0,
                  EventType = 8,

                },
                {

                  Name = "Attack216",
                  StartFrame = 0,
                  FrameTime = 0,
                  EventType = 2,

                }
              },
              [ 11 ] = {
                {

                  RotateType = 2,
                  UseSelfSpeed = 0,
                  SpeedOffset = 360.0,
                  Acceleration = 360.0,
                  RotateFrame = 11,
                  FrameTime = 11,
                  EventType = 8,

                }
              },
              [ 20 ] = {
                {

                  EntityId = 9200399907,
                  LifeBindSkill = false,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 0.0,
                  BornOffsetZ = 0.0,
                  TerriaOffsetY = 0.0,
                  BornRotateOffsetX = 0.0,
                  BornRotateOffsetY = 0.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = false,
                  LookAngleRange = 360.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 20,
                  EventType = 1,

                }
              },
              [ 23 ] = {
                {

                  AddType = 1,
                  BuffId = 92003008,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 23,
                  EventType = 9,

                }
              },
              [ 24 ] = {
                {

                  Type = 92003316,
                  Frame = 1,
                  FrameTime = 24,
                  EventType = 3,

                }
              },
            }
          },
          [ 92003317 ] = {
            TotalFrame = 121,
            ForceFrame = 109,
            SkillBreakSkillFrame = 73,
            SkillType = 0,
            AttrType = 5,
            UseCostType = 0,
            UseCostValue = 0,
            CDtime = 0.0,
            FrameEvent = {
              [ 0 ] = {
                {

                  AddType = 1,
                  BuffId = 92003008,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 0,
                  EventType = 9,

                },
                {

                  AddType = 1,
                  BuffId = 92003997,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 0,
                  EventType = 9,

                },
                {

                  Name = "Attack217",
                  StartFrame = 0,
                  FrameTime = 0,
                  EventType = 2,

                }
              },
              [ 4 ] = {
                {                  DurationUpdateTargetFrame = 4,
                  OffsetType = 2,
                  TargetHPositionOffset = 3.0,
                  TargetVPositionOffset = 0.0,
                  TargetRelationOffset = { 0.0, 0.0, 0.0 },
                  DurationMoveFrame = 4,
                  VDurationMoveFrame = -1,
                  IgnoreY = true,
                  MaxSpeed = 999.0,
                  MinSpeed = 6.0,
                  FrameTime = 4,
                  EventType = 18,

                }
              },
              [ 5 ] = {
                {

                  RotateType = 2,
                  UseSelfSpeed = 0,
                  SpeedOffset = 180.0,
                  Acceleration = 180.0,
                  RotateFrame = 5,
                  FrameTime = 5,
                  EventType = 8,

                }
              },
              [ 11 ] = {
                {

                  RotateType = 2,
                  UseSelfSpeed = 0,
                  SpeedOffset = 360.0,
                  Acceleration = 360.0,
                  RotateFrame = 13,
                  FrameTime = 11,
                  EventType = 8,

                },
                {

                  EntityId = 92003217001,
                  LifeBindSkill = false,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 0.0,
                  BornOffsetZ = 0.0,
                  TerriaOffsetY = 0.0,
                  BornRotateOffsetX = 0.0,
                  BornRotateOffsetY = 0.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = false,
                  LookAngleRange = 360.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 11,
                  EventType = 1,

                }
              },
              [ 12 ] = {
                {

                  EntityId = 9200331701,
                  LifeBindSkill = false,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 0.0,
                  BornOffsetZ = 0.0,
                  TerriaOffsetY = 0.0,
                  BornRotateOffsetX = 0.0,
                  BornRotateOffsetY = 0.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = false,
                  LookAngleRange = 360.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 12,
                  EventType = 1,

                }
              },
              [ 34 ] = {
                {

                  EntityId = 9200399907,
                  LifeBindSkill = false,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 0.0,
                  BornOffsetZ = 0.0,
                  TerriaOffsetY = 0.0,
                  BornRotateOffsetX = 0.0,
                  BornRotateOffsetY = 0.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = false,
                  LookAngleRange = 360.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 34,
                  EventType = 1,

                }
              },
              [ 37 ] = {
                {

                  AddType = 2,
                  BuffId = 92003008,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 37,
                  EventType = 9,

                }
              },
              [ 50 ] = {
                {

                  RotateType = 2,
                  UseSelfSpeed = 0,
                  SpeedOffset = 360.0,
                  Acceleration = 360.0,
                  RotateFrame = 5,
                  FrameTime = 50,
                  EventType = 8,

                }
              },
              [ 53 ] = {
                {

                  EntityId = 92003217002,
                  LifeBindSkill = false,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 0.0,
                  BornOffsetZ = 0.0,
                  TerriaOffsetY = 0.0,
                  BornRotateOffsetX = 0.0,
                  BornRotateOffsetY = 0.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = false,
                  LookAngleRange = 360.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 53,
                  EventType = 1,

                }
              },
              [ 54 ] = {
                {

                  CameraShake = {
                    {
                      ShakeType = 3,
                      Random = 0.0,
                      StartOffset = 0.0,
                      StartAmplitude = 1.2,
                      StartFrequency = 6.0,
                      TargetAmplitude = 0.2,
                      TargetFrequency = 10.0,
                      AmplitudeChangeTime = 0.198,
                      FrequencyChangeTime = 0.231,
                      DurationTime = 0.297,
                      Sign = 0.0,
                      DistanceDampingId = 0.0
                    }
                  },
                  FrameTime = 54,
                  EventType = 4,

                },
                {

                  EntityId = 92003217003,
                  LifeBindSkill = false,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 0.0,
                  BornOffsetZ = 0.0,
                  TerriaOffsetY = 0.0,
                  BornRotateOffsetX = 0.0,
                  BornRotateOffsetY = 0.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = false,
                  LookAngleRange = 360.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 54,
                  EventType = 1,

                },
                {

                  EntityId = 9200331702,
                  LifeBindSkill = false,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 0.0,
                  BornOffsetZ = 0.0,
                  TerriaOffsetY = 0.0,
                  BornRotateOffsetX = 0.0,
                  BornRotateOffsetY = 0.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = false,
                  LookAngleRange = 360.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 54,
                  EventType = 1,

                }
              },
              [ 73 ] = {
                {

                  Type = 92003317,
                  Frame = 1,
                  FrameTime = 73,
                  EventType = 3,

                }
              },
              [ 95 ] = {
                {

                  AddType = 2,
                  BuffId = 92003997,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 95,
                  EventType = 9,

                }
              },
            }
          },
          [ 92003321 ] = {
            TotalFrame = 126,
            ForceFrame = 126,
            SkillType = 0,
            AttrType = 5,
            UseCostType = 0,
            UseCostValue = 0,
            CDtime = 0.0,
            FrameEvent = {
              [ 0 ] = {
                {

                  AddType = 1,
                  BuffId = 92003008,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 0,
                  EventType = 9,

                },
                {

                  AddType = 1,
                  BuffId = 92003997,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 0,
                  EventType = 9,

                },
                {

                  Name = "Attack221",
                  StartFrame = 0,
                  FrameTime = 0,
                  EventType = 2,

                },
                {

                  EntityId = 9200399905,
                  LifeBindSkill = false,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 0.0,
                  BornOffsetZ = 0.0,
                  TerriaOffsetY = 0.0,
                  BornRotateOffsetX = 0.0,
                  BornRotateOffsetY = 0.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = false,
                  LookAngleRange = 360.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 0,
                  EventType = 1,

                }
              },
              [ 13 ] = {
                {

                  RotateType = 2,
                  UseSelfSpeed = 0,
                  SpeedOffset = 360.0,
                  Acceleration = 360.0,
                  RotateFrame = 3,
                  FrameTime = 13,
                  EventType = 8,

                }
              },
              [ 16 ] = {
                {

                  EntityId = 92003221001,
                  LifeBindSkill = false,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 0.0,
                  BornOffsetZ = 0.0,
                  TerriaOffsetY = 0.0,
                  BornRotateOffsetX = 0.0,
                  BornRotateOffsetY = 0.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = false,
                  LookAngleRange = 360.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 16,
                  EventType = 1,

                },
                {

                  CameraShake = {
                    {
                      ShakeType = 3,
                      Random = 0.0,
                      StartOffset = 0.0,
                      StartAmplitude = 1.2,
                      StartFrequency = 6.0,
                      TargetAmplitude = 0.0,
                      TargetFrequency = 10.0,
                      AmplitudeChangeTime = 0.231,
                      FrequencyChangeTime = 0.231,
                      DurationTime = 0.297,
                      Sign = 0.0,
                      DistanceDampingId = 0.0
                    }
                  },
                  FrameTime = 16,
                  EventType = 4,

                },
                {

                  EntityId = 9200332101,
                  LifeBindSkill = false,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 0.0,
                  BornOffsetZ = 0.0,
                  TerriaOffsetY = 0.0,
                  BornRotateOffsetX = 0.0,
                  BornRotateOffsetY = 0.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = false,
                  LookAngleRange = 360.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 16,
                  EventType = 1,

                },
                {

                  PostProcessType = 2,
                  PostProcessParams = {
                    Strength = 0.2,
                    Dir = 0,
                    Radius = 1.0,
                    Alpha = 0.6,
                    AlphaCurveId = 1501,
                    Direction = 0,
                    Count = 4,
                    Center = { 0.6, -1.0 },
                    ShowTemplateID = false,
                    TemplateID = 92003005,
                    PostProcessType = 2,
                    Duration = 3,
                    ID = 0
                  },
                  LifeBindSkill = false,
                  FrameTime = 16,
                  EventType = 16,

                }
              },
              [ 20 ] = {
                {                  DurationUpdateTargetFrame = 10,
                  OffsetType = 2,
                  TargetHPositionOffset = 2.0,
                  TargetVPositionOffset = 0.0,
                  TargetRelationOffset = { 0.0, 0.0, 0.0 },
                  DurationMoveFrame = 10,
                  VDurationMoveFrame = 10,
                  IgnoreY = true,
                  MaxSpeed = 999.0,
                  MinSpeed = 0.0,
                  FrameTime = 20,
                  EventType = 18,

                }
              },
              [ 21 ] = {
                {

                  EntityId = 9200399906,
                  LifeBindSkill = false,
                  CreateEntityType = 1,
                  BindTransform = "LeftEyeCase",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 0.0,
                  BornOffsetZ = 0.0,
                  TerriaOffsetY = 0.0,
                  BornRotateOffsetX = 0.0,
                  BornRotateOffsetY = 0.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = false,
                  LookAngleRange = 360.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 21,
                  EventType = 1,

                }
              },
              [ 24 ] = {
                {

                  RotateType = 2,
                  UseSelfSpeed = 0,
                  SpeedOffset = 360.0,
                  Acceleration = 360.0,
                  RotateFrame = 26,
                  FrameTime = 24,
                  EventType = 8,

                }
              },
              [ 25 ] = {
                {

                  Type = 92003321,
                  Frame = 35,
                  FrameTime = 25,
                  EventType = 3,

                }
              },
              [ 33 ] = {
                {

                  AddType = 1,
                  BuffId = 900000043,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 33,
                  EventType = 9,

                }
              },
              [ 50 ] = {
                {                  DurationUpdateTargetFrame = 4,
                  OffsetType = 2,
                  TargetHPositionOffset = 1.0,
                  TargetVPositionOffset = 0.0,
                  TargetRelationOffset = { 0.0, 0.0, 0.0 },
                  DurationMoveFrame = 4,
                  VDurationMoveFrame = 4,
                  IgnoreY = true,
                  MaxSpeed = 999.0,
                  MinSpeed = 0.0,
                  FrameTime = 50,
                  EventType = 18,
                  ActiveSign = {
                    Sign = {
                      123
                    },
                  }
                }
              },
              [ 53 ] = {
                {

                  EntityId = 92003221002,
                  LifeBindSkill = false,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 0.0,
                  BornOffsetZ = 0.0,
                  TerriaOffsetY = 0.0,
                  BornRotateOffsetX = 0.0,
                  BornRotateOffsetY = 0.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = false,
                  LookAngleRange = 360.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 53,
                  EventType = 1,

                }
              },
              [ 55 ] = {
                {

                  EntityId = 9200332102,
                  LifeBindSkill = false,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 0.0,
                  BornOffsetZ = 0.0,
                  TerriaOffsetY = 0.0,
                  BornRotateOffsetX = 0.0,
                  BornRotateOffsetY = 0.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = false,
                  LookAngleRange = 360.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 55,
                  EventType = 1,

                },
                {

                  EntityId = 92003221003,
                  LifeBindSkill = false,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 0.0,
                  BornOffsetZ = 0.0,
                  TerriaOffsetY = 0.0,
                  BornRotateOffsetX = 0.0,
                  BornRotateOffsetY = 0.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = false,
                  LookAngleRange = 360.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 55,
                  EventType = 1,

                }
              },
              [ 56 ] = {
                {

                  PostProcessType = 2,
                  PostProcessParams = {
                    Strength = 0.4,
                    Dir = 0,
                    Radius = 1.0,
                    Alpha = 0.8,
                    AlphaCurveId = 1501,
                    Direction = 0,
                    FollowTransform = "ShentuMb1_weapon",
                    Count = 5,
                    Center = { 0.6, -1.0 },
                    ShowTemplateID = false,
                    TemplateID = 0,
                    PostProcessType = 2,
                    Duration = 5,
                    ID = 30
                  },
                  LifeBindSkill = false,
                  FrameTime = 56,
                  EventType = 16,

                },
                {

                  CameraShake = {
                    {
                      ShakeType = 3,
                      Random = 0.0,
                      StartOffset = 0.0,
                      StartAmplitude = 5.0,
                      StartFrequency = 8.0,
                      TargetAmplitude = 0.4,
                      TargetFrequency = 20.0,
                      AmplitudeChangeTime = 0.462,
                      FrequencyChangeTime = 0.393,
                      DurationTime = 0.627,
                      Sign = 0.0,
                      DistanceDampingId = 0.0
                    }
                  },
                  FrameTime = 56,
                  EventType = 4,

                }
              },
              [ 86 ] = {
                {

                  RotateType = 2,
                  UseSelfSpeed = 0,
                  SpeedOffset = 90.0,
                  Acceleration = 480.0,
                  RotateFrame = 30,
                  FrameTime = 86,
                  EventType = 8,

                }
              },
              [ 106 ] = {
                {

                  AddType = 2,
                  BuffId = 92003997,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 106,
                  EventType = 9,

                }
              },
            }
          },
          [ 92003322 ] = {
            TotalFrame = 20,
            ForceFrame = 20,
            SkillBreakSkillFrame = 19,
            SkillType = 0,
            AttrType = 5,
            UseCostType = 0,
            UseCostValue = 0,
            CDtime = 0.0,
            FrameEvent = {
              [ 0 ] = {
                {

                  AddType = 1,
                  BuffId = 92003008,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 0,
                  EventType = 9,

                },
                {

                  AddType = 1,
                  BuffId = 92003997,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 0,
                  EventType = 9,

                },
                {

                  Direction = 1,
                  CustomX = 0.0,
                  CustomY = 0.0,
                  CustomZ = 0.0,
                  SpeedType = 1,
                  SpeedOffset = 7.0,
                  Acceleration = 0.0,
                  MoveFrame = 20,
                  InputSpeed = 0.0,
                  MinDistance = 0.0,
                  IgnoreYAxis = false,
                  SkillMoveDone = 1,
                  FrameTime = 0,
                  EventType = 7,

                },
                {

                  RotateType = 2,
                  UseSelfSpeed = 0,
                  SpeedOffset = 360.0,
                  Acceleration = 360.0,
                  RotateFrame = 20,
                  FrameTime = 0,
                  EventType = 8,

                },
                {

                  Name = "Attack222",
                  StartFrame = 0,
                  FrameTime = 0,
                  EventType = 2,

                }
              },
              [ 19 ] = {
                {

                  Type = 92003322,
                  Frame = 1,
                  FrameTime = 19,
                  EventType = 3,

                }
              },
            }
          },
          [ 92003327 ] = {
            TotalFrame = 42,
            ForceFrame = 40,
            SkillType = 0,
            AttrType = 5,
            UseCostType = 0,
            UseCostValue = 0,
            CDtime = 0.0,
            FrameEvent = {
              [ 0 ] = {
                {

                  Name = "Attack209",
                  StartFrame = 3,
                  FrameTime = 0,
                  EventType = 2,

                }
              },
              [ 22 ] = {
                {

                  Type = 92003225,
                  Frame = 10,
                  FrameTime = 22,
                  EventType = 3,

                }
              },
            }
          },
          [ 92003911 ] = {
            TotalFrame = 131,
            ForceFrame = 102,
            SkillType = 0,
            AttrType = 5,
            UseCostType = 0,
            UseCostValue = 0,
            CDtime = 0.0,
            FrameEvent = {
              [ 0 ] = {
                {

                  Name = "Attack211",
                  StartFrame = 0,
                  FrameTime = 0,
                  EventType = 2,

                },
                {

                  AddType = 1,
                  BuffId = 92003997,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 0,
                  EventType = 9,

                }
              },
              [ 2 ] = {
                {

                  RotateType = 2,
                  UseSelfSpeed = 0,
                  SpeedOffset = 180.0,
                  Acceleration = 180.0,
                  RotateFrame = 17,
                  FrameTime = 2,
                  EventType = 8,
                  ActiveSign = {
                    Sign = {
                      9998
                    },
                  }
                }
              },
              [ 36 ] = {
                {

                  EntityId = 9200399907,
                  LifeBindSkill = false,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 0.0,
                  BornOffsetZ = 0.0,
                  TerriaOffsetY = 0.0,
                  BornRotateOffsetX = 0.0,
                  BornRotateOffsetY = 0.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = false,
                  LookAngleRange = 360.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 36,
                  EventType = 1,

                }
              },
              [ 43 ] = {
                {

                  RotateType = 2,
                  UseSelfSpeed = 0,
                  SpeedOffset = 180.0,
                  Acceleration = 180.0,
                  RotateFrame = 17,
                  FrameTime = 43,
                  EventType = 8,

                }
              },
              [ 56 ] = {
                {

                  EntityId = 9200321101,
                  LifeBindSkill = false,
                  LifeBindSkillFrame = 0,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 0.0,
                  BornOffsetZ = 0.0,
                  TerriaOffsetY = 0.0,
                  BornRotateOffsetX = 0.0,
                  BornRotateOffsetY = 0.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = false,
                  LookAngleRange = 360.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 56,
                  EventType = 1,

                }
              },
              [ 63 ] = {
                {

                  EntityId = 9200321102,
                  LifeBindSkill = false,
                  LifeBindSkillFrame = 0,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 0.0,
                  BornOffsetZ = 0.0,
                  TerriaOffsetY = 0.0,
                  BornRotateOffsetX = 0.0,
                  BornRotateOffsetY = 0.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = false,
                  LookAngleRange = 360.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 63,
                  EventType = 1,

                }
              },
              [ 90 ] = {
                {

                  RotateType = 2,
                  UseSelfSpeed = 0,
                  SpeedOffset = 180.0,
                  Acceleration = 360.0,
                  RotateFrame = 10,
                  FrameTime = 90,
                  EventType = 8,
                  ActiveSign = {
                    Sign = {
                      9999
                    },
                  }
                }
              },
              [ 97 ] = {
                {

                  AddType = 2,
                  BuffId = 92003997,
                  LifeBindBuff = true,
                  Count = 1,
                  FrameTime = 97,
                  EventType = 9,

                }
              },
            }
          },
          [ 92003994 ] = {
            TotalFrame = 85,
            ForceFrame = 84,
            SkillType = 0,
            AttrType = 5,
            UseCostType = 0,
            UseCostValue = 0,
            CDtime = 0.0,
            FrameEvent = {
              [ 0 ] = {
                {

                  Name = "Attack004",
                  StartFrame = 0,
                  FrameTime = 0,
                  EventType = 2,

                }
              },
              [ 8 ] = {
                {

                  RotateType = 2,
                  UseSelfSpeed = 0,
                  SpeedOffset = 180.0,
                  Acceleration = 180.0,
                  RotateFrame = 13,
                  FrameTime = 8,
                  EventType = 8,

                }
              },
              [ 34 ] = {
                {

                  EntityId = 9200300401,
                  LifeBindSkill = false,
                  LifeBindSkillFrame = 0,
                  CreateEntityType = 1,
                  BindTransform = "",
                  MaxDistance = 0.0,
                  BornOffsetX = 0.0,
                  BornOffsetY = 0.0,
                  BornOffsetZ = 0.0,
                  TerriaOffsetY = 0.0,
                  BornRotateOffsetX = 0.0,
                  BornRotateOffsetY = 0.0,
                  BornRotateOffsetZ = 0.0,
                  LookatTarget = false,
                  LookAngleRange = 0.0,
                  TargetOffsetY = 0.0,
                  IsBindTargetLogicPos = false,
                  FrameTime = 34,
                  EventType = 1,

                }
              },
              [ 40 ] = {
                {

                  RotateType = 2,
                  UseSelfSpeed = 0,
                  SpeedOffset = 120.0,
                  Acceleration = 120.0,
                  RotateFrame = 7,
                  FrameTime = 40,
                  EventType = 8,

                }
              },
              [ 60 ] = {
                {

                  RotateType = 2,
                  UseSelfSpeed = 0,
                  SpeedOffset = 180.0,
                  Acceleration = 360.0,
                  RotateFrame = 19,
                  FrameTime = 60,
                  EventType = 8,
                  ActiveSign = {
                    Sign = {
                      9999
                    },
                  }
                }
              },
            }
          }
        }
      },
      Animator = {
        Animator = "Character/Monster/Shentu/ShentuMb1Low/ShentuMb1.controller",
        AnimationConfigID = "",
        TransitionDic = {
          [ 0 ] = {
            AnyState = {
              LeftSlightHit = 0.0,
              RightSlightHit = 0.0,
              LeftHeavyHit = 0.0,
              RightHeavyHit = 0.0
            }
          }
        }
      },
      Behavior = {
        Behaviors = {
          "92003"
        },
      },
      Camp = {
        Camp = 2
      },
      Tag = {
        Tag = 1,
        NpcTag = 4,
        SceneObjectTag = 0,
        PartTag = 1
      },
      Move = {
        pivot = 1.47,
        canGlide = false,
        GlideCost = 0.0,
        GlideHeight = 0.0,
        GlideRotationSpeed = 0.0,
        GlideDownSpeed = 0.0,
        GlideMoveSpeed = 0.0,
        GlideTurnSpeed = 0.0,
        GlideTurnBackSpeed = 0.0,
        MoveType = 1,
        LineraSpeedType = 1,
        Speed = 0.0,
        SpeedCurveId = 0,
        EarlyWarningFrame = 0,
        SignId = 0,
        WarningDurationFrame = 0,
        RotateSpeedCurveId = 0,
        AlwaysUpdateTargetPos = false,
        RotationLockInterval = 0.0,
        RotationLockDelay = 0,
        ConfigName = "ShentuMb1",
        LogicMoveConfigs = {
          Attack004_12 = 2,
          Attack005_1 = 2,
          Attack015_1 = 2,
          Attack010_1 = 2,
          Attack002 = 2,
          Attack004_2 = 2,
          Attack005_2 = 2,
          Attack006_2 = 2,
          Attack007_2 = 2,
          Attack008_2 = 2,
          Attack009_2 = 2,
          Attack011_2 = 2,
          Attack012_2 = 2,
          Attack013_2 = 2,
          Attack013_1 = 2,
          Attack015_2 = 2,
          Attack001 = 2,
          Attack003_1 = 2,
          Attack006_1 = 2,
          Attack007_1 = 2,
          Attack008_1 = 2,
          Attack016_2 = 2,
          Attack017_2 = 2,
          Attack021_2 = 2,
          Attack022_2 = 2,
          Attack014_2 = 2,
          Attack019 = 2,
          Attack020 = 2,
          Attack209_2 = 2,
          Attack009_1 = 2,
          Attack027_2 = 2,
          Attack026_2 = 10,
          Attack026_1 = 10,
          Attack028_2 = 2,
          Attack010_2 = 2
        },        BindRotation = false,

      },
      State = {
        DyingTime = 3.0,
        DeathTime = 2.0,
        ReviveTime = 0.0,
        BornTime = 0.0,
        FightToLeisurely = 0.0,
        HitTime = {
          [ 1 ] = {
            Time = 1.0,
            ForceTime = 1.0,
            FusionChangeTime = 0.5,
            IgnoreHitTime = 0.0
          },
          [ 2 ] = {
            Time = 1.0,
            ForceTime = 1.0,
            FusionChangeTime = 0.5,
            IgnoreHitTime = 0.0
          },
          [ 3 ] = {
            Time = 2.1,
            ForceTime = 2.0,
            FusionChangeTime = 1.0,
            IgnoreHitTime = 0.0
          },
          [ 4 ] = {
            Time = 2.1,
            ForceTime = 2.0,
            FusionChangeTime = 1.0,
            IgnoreHitTime = 0.0
          }
        },
        HitStateRandomMapping = {
          HitFly = {
            3,
            4
          },
          HitDown = {
            3,
            4
          },
        }
      },
      Collision = {
        CollisionCheckType = 1,
        Radius = 1.5,
        Priority = 10,
        FixAngle = 45.0,
        PartList = {
          {
            Name = "body",
            BoneColliders = {
              {
                ShapeType = 3,
                ParentName = "Bip001",
                LocalPosition = { -0.05473239, 0.0017447772, -0.4 },
                LocalEuler = { 0.0, 270.0, 270.0 },
                LocalScale = { 1.7, 1.1, 1.0 }
              }
            },
            DefaultEnable = true,
            ColliderFollow = 1,

          },
          {
            Name = "head",
            BoneColliders = {
              {
                ShapeType = 1,
                ParentName = "Bip001 Head",
                LocalPosition = { -0.006, -0.235, 0.0 },
                LocalEuler = { 0.0, 0.0, 0.0 },
                LocalScale = { 0.8, 0.8, 0.8 }
              }
            },
            DefaultEnable = true,
            ColliderFollow = 1,

          }
        },
        CollisionRadius = 0.5,
        Height = 2.5,
        offsetX = 0.0,
        offsetY = 0.0,
        offsetZ = 0.0
      },
      Part = {
        PartList = {
          {
            Name = "body",
            PartType = 0,
            PartWeakType = 0,
            lockTransformName = "HitCase",
            attackTransformName = "HitCase",
            hitTransformName = "HitCase",
            weakWeight = 1,
            BoneColliders = {
              {
                ShapeType = 3,
                ParentName = "Bip001",
                LocalPosition = { -0.05473239, 0.0017447772, -0.4 },
                LocalEuler = { 0.0, 270.0, 270.0 },
                LocalScale = { 1.7, 1.1, 1.0 }
              }
            },
            LogicSearch = true,
            SearchWeight = 0.0,
            LogicLock = true,
            LockWeight = 0.0,
            DmgHurtOpen = true,
            DmgPartHurtOpen = true,
            CheckEntityCollider = false
          },
          {
            Name = "head",
            Attr = {
              HpPercent = 10000.0,
              DamageParam = 12000.0
            },
            PartType = 0,
            PartWeakType = 0,
            WeakTrasnforms = {
              "CongshiMo1_hair",
              "CongshiMo1_mask"
            },
            lockTransformName = "Bip001 Head",
            attackTransformName = "Bip001 Head",
            hitTransformName = "Bip001 Head",
            weakWeight = 2,
            BoneColliders = {
              {
                ShapeType = 1,
                ParentName = "Bip001 Head",
                LocalPosition = { -0.006, -0.235, 0.0 },
                LocalEuler = { 0.0, 0.0, 0.0 },
                LocalScale = { 0.8, 0.8, 0.8 }
              }
            },
            LogicSearch = true,
            SearchWeight = 0.0,
            LogicLock = false,
            LockWeight = 0.0,
            DmgHurtOpen = true,
            DmgPartHurtOpen = true,
            CheckEntityCollider = false
          }
        },

      },
      Hit = {
        GravityAcceleration = -0.15,
        ReboundCoefficient = 0.1,
        ReboundTimes = 1.0,
        MinSpeed = 3.0,
        SpeedZCoefficient = 0.0,
        HitFlyHeight = 999.0
      },
      Time = {
        DefalutTimeScale = 1.0
      },
      Buff = empty,
      Attributes = {
        DefaultName = "神荼",
        DefaultAttrID = 92003,
      },
      Death = {
        DeathList = {
          {
            DeathReason = 1,
            DeathTime = 1.6,
            deathCondition = {
              DrownHeight = 1.35,
              CheckPower = false
            }
          },
          {
            DeathReason = 2,
            DeathTime = -1.0,
            deathCondition = {
              TerrainDeathList = {
                {
                  TerrainDeath = 20,
                  TerrainDeathHeight = 1.35,
                  TerrainDeathTime = -1.0,
                  AccelerationY = -0.2
                }
              },
            }
          }
        },
      },
      ElementState = {
        ElementType = 2,
        ElementMaxAccumulateDict = {
          Earth = 200
        }
      },
      Ik = {
        shakeLeftFrontId = 0,
        shakeLeftBackId = 0,
        shakeRightFrontId = 0,
        shakeRightBackId = 0,
        shakeDistanceRatio = 0.0,
        Look = {
          IsLookCtrlObject = true
        },
      },
      Condition = {
        ConditionParamsList = {
          {
            Interval = 3.0,
            Count = -1,
            ConditionList = {
              {

                Count = 6,
                CountWhenSuperArmor = false,
                MinusCountWhenSuperArmor = 0,
                CountInterval = 5.0,
                HitDuration = 0.0,
                ConditionType = 2
              },
              {

                MinLife = 50.0,
                MaxLife = 100.0,
                ConditionType = 1
              }
            },
            MeetConditionEventList = {
              {

                Duration = 4.0,
                MeetConditionEventType = 2
              }
            },
          },
          {
            Interval = 3.0,
            Count = -1,
            ConditionList = {
              {

                Count = 6,
                CountWhenSuperArmor = false,
                MinusCountWhenSuperArmor = 0,
                CountInterval = 5.0,
                HitDuration = 0.0,
                ConditionType = 2
              },
              {

                MinLife = 0.0,
                MaxLife = 49.0,
                ConditionType = 1
              }
            },
            MeetConditionEventList = {
              {

                Duration = 3.0,
                MeetConditionEventType = 2
              }
            },
          }
        },
      }
    }
  },
  [ 9200300401 ] = {
    EntityId = 9200300401,
    EntityName = "9200300401",
    Components = {
      Transform = {
        Prefab = "Character/Role/Entity1003/Model/Entity1004.prefab",
        isClone = false,
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
      TimeoutDeath = {
        Frame = 4,
        RemoveDelayFrame = 0,
      },
      Camp = {
        Camp = 2
      },
      Tag = {
        Tag = 2,
        NpcTag = 0,
        SceneObjectTag = 0,
        PartTag = 1
      },
      Attack = {
        AttackType = 0,
        MaxAttackTimes = -1,
        DelayFrame = 0,
        DurationFrame = 4,
        ShapeType = 2,
        Radius = 11000.0,
        circleStartRadius = 0.5,
        circleRadius = 0.5,
        SpreadSpeed = 0.0,
        SpreadFrame = 0,
        Lenght = 3.0,
        Height = 3.0,
        Width = 3.5,
        OffsetX = 0.0,
        OffsetY = 0.0,
        OffsetZ = 1.0,
        Repetition = false,
        IntervalFrame = 0,
        RemoveAfterHit = true,
        CanHitGround = false,
        RemoveAfterReach = false,
        ReachRange = 0.0,
        ReboundFrame = 0,
        IntervalTime = 0.0,
        ReboundTag = 1,
        ReboundEntityId = 0,
        DodgeInvalidType = 1,
        NotCheckDodge = false,
        NotJumpDodge = true,
        NotJumpBeatBack = true,
        MagicsByTarget = {
          10040001
        },
        HitTypeConfigList = {
          {
            HitType = 4,
            BreakLieDown = false
          }
        },
        SwtichLieAnimTime = 0.0,
        LookatType = 3,
        HitParams = {
          SpeedZ = 3.5,
          SpeedZAcceleration = 3.0,
          SpeedZTime = 0.2,
          SpeedY = 0.0,
          SpeedZHitFly = 0.0,
          SpeedYAcceleration = 0.0,
          SpeedYAccelerationTime = 0.0,
          SpeedYAloft = 5.0,
          SpeedZAloft = 2.0,

        },        UseCameraShake = false,
        CameraShake = {
          {
            ShakeType = 2,
            Random = 0.0,
            StartOffset = 0.0,
            StartAmplitude = 0.15,
            StartFrequency = 15.0,
            TargetAmplitude = 0.3,
            TargetFrequency = 10.0,
            AmplitudeChangeTime = 0.15,
            FrequencyChangeTime = 0.0,
            DurationTime = 0.15,
            Sign = 9200304.0,
            DistanceDampingId = 0.0
          }
        },
        ShakeId = 0,
        CalcNearShakeBone = true,
        BoneEffectPos = { 0.0, 0.0, 0.0 },
        ShakeDir = 0,
        ShakeStrenRatio = 0.0,
        HavePauseFrame = false,
        IsCanBreak = true,
        PFFrame = 3,
        PFTimeScale = 1.0,
        PFTimeScaleCurve = "-1",
        TargetPFTimeScaleCurve = "-1",
        PFMonsterSpeed = 1.0,
        PFMonsterSpeedCurve = "-1",
        PFSceneSpeed = 1.0,
        PFSceneSpeedCurve = "-1",
        PFTime = 0.099,
        UsePostProcess = false,
      },
      Move = {
        pivot = 0.0,
        canGlide = false,
        GlideCost = 0.0,
        GlideHeight = 0.0,
        GlideRotationSpeed = 0.0,
        GlideDownSpeed = 0.0,
        GlideMoveSpeed = 0.0,
        GlideTurnSpeed = 0.0,
        GlideTurnBackSpeed = 0.0,
        MoveType = 3,
        LineraSpeedType = 1,
        Speed = 0.0,
        SpeedCurveId = 0,
        EarlyWarningFrame = 0,
        SignId = 0,
        WarningDurationFrame = 0,
        RotateSpeedCurveId = 0,
        AlwaysUpdateTargetPos = false,
        RotationLockInterval = 0.0,
        RotationLockDelay = 0,
        BindOffsetX = 0.0,
        BindOffsetY = 0.0,
        BindOffsetZ = 0.0,
        BindRotation = false,

      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 9200300501 ] = {
    EntityId = 9200300501,
    EntityName = "9200300501",
    Components = {
      Transform = {
        Prefab = "Character/Role/Entity1003/Model/Entity1004.prefab",
        isClone = false,
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
      TimeoutDeath = {
        Frame = 4,
        RemoveDelayFrame = 0,
      },
      Camp = {
        Camp = 2
      },
      Tag = {
        Tag = 2,
        NpcTag = 0,
        SceneObjectTag = 0,
        PartTag = 1
      },
      Attack = {
        AttackType = 0,
        MaxAttackTimes = -1,
        DelayFrame = 0,
        DurationFrame = 4,
        ShapeType = 2,
        Radius = 11000.0,
        circleStartRadius = 0.5,
        circleRadius = 0.5,
        SpreadSpeed = 0.0,
        SpreadFrame = 0,
        Lenght = 3.0,
        Height = 3.0,
        Width = 6.0,
        OffsetX = 0.0,
        OffsetY = 1.0,
        OffsetZ = 3.0,
        Repetition = false,
        IntervalFrame = 0,
        RemoveAfterHit = true,
        CanHitGround = false,
        RemoveAfterReach = false,
        ReachRange = 0.0,
        ReboundFrame = 0,
        IntervalTime = 0.0,
        ReboundTag = 1,
        ReboundEntityId = 0,
        DodgeInvalidType = 1,
        NotCheckDodge = false,
        NotJumpDodge = true,
        NotJumpBeatBack = true,
        MagicsByTarget = {
          10050001
        },
        HitTypeConfigList = {
          {
            HitType = 4,
            BreakLieDown = false
          }
        },
        SwtichLieAnimTime = 0.0,
        LookatType = 3,
        HitParams = {
          SpeedZ = 3.5,
          SpeedZAcceleration = 3.0,
          SpeedZTime = 0.2,
          SpeedY = 0.0,
          SpeedZHitFly = 0.0,
          SpeedYAcceleration = 0.0,
          SpeedYAccelerationTime = 0.0,
          SpeedYAloft = 5.0,
          SpeedZAloft = 2.0,

        },        UseCameraShake = false,
        CameraShake = {
          {
            ShakeType = 2,
            Random = 0.0,
            StartOffset = 0.0,
            StartAmplitude = 0.15,
            StartFrequency = 15.0,
            TargetAmplitude = 0.3,
            TargetFrequency = 10.0,
            AmplitudeChangeTime = 0.15,
            FrequencyChangeTime = 0.0,
            DurationTime = 0.15,
            Sign = 9200304.0,
            DistanceDampingId = 0.0
          }
        },
        ShakeId = 0,
        CalcNearShakeBone = true,
        BoneEffectPos = { 0.0, 0.0, 0.0 },
        ShakeDir = 0,
        ShakeStrenRatio = 0.0,
        HavePauseFrame = false,
        IsCanBreak = true,
        PFFrame = 3,
        PFTimeScale = 1.0,
        PFTimeScaleCurve = "-1",
        TargetPFTimeScaleCurve = "-1",
        PFMonsterSpeed = 1.0,
        PFMonsterSpeedCurve = "-1",
        PFSceneSpeed = 1.0,
        PFSceneSpeedCurve = "-1",
        PFTime = 0.099,
        UsePostProcess = false,
      },
      Move = {
        pivot = 0.0,
        canGlide = false,
        GlideCost = 0.0,
        GlideHeight = 0.0,
        GlideRotationSpeed = 0.0,
        GlideDownSpeed = 0.0,
        GlideMoveSpeed = 0.0,
        GlideTurnSpeed = 0.0,
        GlideTurnBackSpeed = 0.0,
        MoveType = 3,
        LineraSpeedType = 1,
        Speed = 0.0,
        SpeedCurveId = 0,
        EarlyWarningFrame = 0,
        SignId = 0,
        WarningDurationFrame = 0,
        RotateSpeedCurveId = 0,
        AlwaysUpdateTargetPos = false,
        RotationLockInterval = 0.0,
        RotationLockDelay = 0,
        BindOffsetX = 0.0,
        BindOffsetY = 0.0,
        BindOffsetZ = 0.0,
        BindRotation = false,

      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 9200301501 ] = {
    EntityId = 9200301501,
    EntityName = "9200301501",
    Components = {
      Transform = {
        Prefab = "Character/Role/Entity1003/Model/Entity1004.prefab",
        isClone = false,
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
      TimeoutDeath = {
        Frame = 3,
        RemoveDelayFrame = 0,
      },
      Camp = {
        Camp = 2
      },
      Tag = {
        Tag = 2,
        NpcTag = 0,
        SceneObjectTag = 0,
        PartTag = 1
      },
      Attack = {
        AttackType = 3,
        MaxAttackTimes = -1,
        DelayFrame = 0,
        DurationFrame = 4,
        ShapeType = 2,
        Radius = 11000.0,
        circleStartRadius = 0.5,
        circleRadius = 0.5,
        SpreadSpeed = 0.0,
        SpreadFrame = 0,
        Lenght = 2.0,
        Height = 2.0,
        Width = 2.0,
        OffsetX = 0.0,
        OffsetY = 0.0,
        OffsetZ = 1.0,
        Repetition = false,
        IntervalFrame = 0,
        RemoveAfterHit = false,
        CanHitGround = false,
        RemoveAfterReach = false,
        ReachRange = 0.0,
        ReboundFrame = 0,
        IntervalTime = 0.0,
        ReboundTag = 1,
        ReboundEntityId = 0,
        DodgeInvalidType = 1,
        NotCheckDodge = false,
        NotJumpDodge = false,
        NotJumpBeatBack = false,
        MagicsByTarget = {
          900020002,
          10150001
        },
        HitTypeConfigList = {
          {
            HitType = 4,
            BreakLieDown = false
          }
        },
        SwtichLieAnimTime = 0.0,
        LookatType = 3,
        HitParams = {
          SpeedZ = 0.0,
          SpeedZAcceleration = 0.0,
          SpeedZTime = 0.0,
          SpeedY = 0.0,
          SpeedZHitFly = 0.0,
          SpeedYAcceleration = 0.0,
          SpeedYAccelerationTime = 0.0,
          SpeedYAloft = 5.0,
          SpeedZAloft = 2.0,

        },        UseCameraShake = false,
        ShakeId = 0,
        CalcNearShakeBone = true,
        BoneEffectPos = { 0.0, 0.0, 0.0 },
        ShakeDir = 0,
        ShakeStrenRatio = 0.0,
        HavePauseFrame = false,
        IsCanBreak = true,
        PFFrame = 3,
        PFTimeScale = 1.0,
        PFTimeScaleCurve = "-1",
        TargetPFTimeScaleCurve = "-1",
        PFMonsterSpeed = 1.0,
        PFMonsterSpeedCurve = "-1",
        PFSceneSpeed = 1.0,
        PFSceneSpeedCurve = "-1",
        PFTime = 0.099,
        UsePostProcess = false,
      },
      Move = {
        pivot = 0.0,
        canGlide = false,
        GlideCost = 0.0,
        GlideHeight = 0.0,
        GlideRotationSpeed = 0.0,
        GlideDownSpeed = 0.0,
        GlideMoveSpeed = 0.0,
        GlideTurnSpeed = 0.0,
        GlideTurnBackSpeed = 0.0,
        MoveType = 3,
        LineraSpeedType = 1,
        Speed = 0.0,
        SpeedCurveId = 0,
        EarlyWarningFrame = 0,
        SignId = 0,
        WarningDurationFrame = 0,
        RotateSpeedCurveId = 0,
        AlwaysUpdateTargetPos = false,
        RotationLockInterval = 0.0,
        RotationLockDelay = 0,
        BindOffsetX = 0.0,
        BindOffsetY = 0.0,
        BindOffsetZ = 0.0,
        BindRotation = false,

      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 9200300502 ] = {
    EntityId = 9200300502,
    EntityName = "9200300502",
    Components = {
      Transform = {
        Prefab = "Character/Role/Entity1003/Model/Entity1004.prefab",
        isClone = false,
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
      TimeoutDeath = {
        Frame = 4,
        RemoveDelayFrame = 0,
      },
      Camp = {
        Camp = 2
      },
      Tag = {
        Tag = 2,
        NpcTag = 0,
        SceneObjectTag = 0,
        PartTag = 1
      },
      Attack = {
        AttackType = 0,
        MaxAttackTimes = -1,
        DelayFrame = 0,
        DurationFrame = 4,
        ShapeType = 2,
        Radius = 11000.0,
        circleStartRadius = 0.5,
        circleRadius = 0.5,
        SpreadSpeed = 0.0,
        SpreadFrame = 0,
        Lenght = 3.0,
        Height = 3.0,
        Width = 6.5,
        OffsetX = 0.0,
        OffsetY = 1.5,
        OffsetZ = 2.5,
        Repetition = false,
        IntervalFrame = 0,
        RemoveAfterHit = true,
        CanHitGround = false,
        RemoveAfterReach = false,
        ReachRange = 0.0,
        ReboundFrame = 0,
        IntervalTime = 0.0,
        ReboundTag = 1,
        ReboundEntityId = 0,
        DodgeInvalidType = 1,
        NotCheckDodge = false,
        NotJumpDodge = true,
        NotJumpBeatBack = true,
        MagicsBySelfBeforeHit = {
          20000001
        },
        MagicsByTargetBeforeHit = {
          10000001
        },
        MagicsByTarget = {
          10050002,
          92003007
        },
        CreateHitEntities = {
          {
            EntityId = 92003997,
            LookRX = false,
            LookRY = true,
            LookRZ = false,
            LookatType = 3
          }
        },
        HitTypeConfigList = {
          {
            HitType = 7,
            BreakLieDown = false
          }
        },
        SwtichLieAnimTime = 0.0,
        LookatType = 3,
        HitParams = {
          SpeedZ = 6.0,
          SpeedZAcceleration = -1.0,
          SpeedZTime = 0.3,
          SpeedY = 18.0,
          SpeedZHitFly = 8.0,
          SpeedYAcceleration = -18.0,
          SpeedYAccelerationTime = 0.3,
          SpeedYAloft = 5.0,
          SpeedZAloft = 2.0,

        },        UseCameraShake = false,
        CameraShake = {
          {
            ShakeType = 2,
            Random = 0.0,
            StartOffset = 0.0,
            StartAmplitude = 0.15,
            StartFrequency = 15.0,
            TargetAmplitude = 0.3,
            TargetFrequency = 10.0,
            AmplitudeChangeTime = 0.15,
            FrequencyChangeTime = 0.0,
            DurationTime = 0.15,
            Sign = 9200304.0,
            DistanceDampingId = 0.0
          }
        },
        ShakeId = 0,
        CalcNearShakeBone = true,
        BoneEffectPos = { 0.0, 0.0, 0.0 },
        ShakeDir = 0,
        ShakeStrenRatio = 0.0,
        HavePauseFrame = false,
        IsCanBreak = true,
        PFFrame = 3,
        PFTimeScale = 1.0,
        PFTimeScaleCurve = "-1",
        TargetPFTimeScaleCurve = "-1",
        PFMonsterSpeed = 1.0,
        PFMonsterSpeedCurve = "-1",
        PFSceneSpeed = 1.0,
        PFSceneSpeedCurve = "-1",
        PFTime = 0.099,
        UsePostProcess = false,
      },
      Move = {
        pivot = 0.0,
        canGlide = false,
        GlideCost = 0.0,
        GlideHeight = 0.0,
        GlideRotationSpeed = 0.0,
        GlideDownSpeed = 0.0,
        GlideMoveSpeed = 0.0,
        GlideTurnSpeed = 0.0,
        GlideTurnBackSpeed = 0.0,
        MoveType = 3,
        LineraSpeedType = 1,
        Speed = 0.0,
        SpeedCurveId = 0,
        EarlyWarningFrame = 0,
        SignId = 0,
        WarningDurationFrame = 0,
        RotateSpeedCurveId = 0,
        AlwaysUpdateTargetPos = false,
        RotationLockInterval = 0.0,
        RotationLockDelay = 0,
        BindOffsetX = 0.0,
        BindOffsetY = 0.0,
        BindOffsetZ = 0.0,
        BindRotation = false,

      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 9200301502 ] = {
    EntityId = 9200301502,
    EntityName = "9200301502",
    Components = {
      Transform = {
        Prefab = "Character/Role/Entity1003/Model/Entity1004.prefab",
        isClone = false,
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
      TimeoutDeath = {
        Frame = 3,
        RemoveDelayFrame = 0,
      },
      Camp = {
        Camp = 2
      },
      Tag = {
        Tag = 2,
        NpcTag = 0,
        SceneObjectTag = 0,
        PartTag = 1
      },
      Attack = {
        AttackType = 3,
        MaxAttackTimes = -1,
        DelayFrame = 0,
        DurationFrame = 4,
        ShapeType = 2,
        Radius = 11000.0,
        circleStartRadius = 0.5,
        circleRadius = 0.5,
        SpreadSpeed = 0.0,
        SpreadFrame = 0,
        Lenght = 3.0,
        Height = 3.0,
        Width = 3.0,
        OffsetX = 0.0,
        OffsetY = 0.0,
        OffsetZ = 1.0,
        Repetition = false,
        IntervalFrame = 0,
        RemoveAfterHit = false,
        CanHitGround = false,
        RemoveAfterReach = false,
        ReachRange = 0.0,
        ReboundFrame = 0,
        IntervalTime = 0.0,
        ReboundTag = 1,
        ReboundEntityId = 0,
        DodgeInvalidType = 1,
        NotCheckDodge = false,
        NotJumpDodge = false,
        NotJumpBeatBack = false,
        MagicsByTarget = {
          900020002,
          10150002
        },
        HitTypeConfigList = {
          {
            HitType = 7,
            BreakLieDown = true
          }
        },
        SwtichLieAnimTime = 0.0,
        LookatType = 3,
        HitParams = {
          SpeedZ = 5.0,
          SpeedZAcceleration = -1.0,
          SpeedZTime = 0.2,
          SpeedY = 17.0,
          SpeedZHitFly = 3.5,
          SpeedYAcceleration = -35.0,
          SpeedYAccelerationTime = 0.3,
          SpeedYAloft = 10.0,
          SpeedZAloft = 10.0,

        },        UseCameraShake = true,
        ShakeId = 0,
        CalcNearShakeBone = true,
        BoneEffectPos = { 0.0, 0.0, 0.0 },
        ShakeDir = 0,
        ShakeStrenRatio = 0.0,
        HavePauseFrame = false,
        IsCanBreak = true,
        PFFrame = 3,
        PFTimeScale = 1.0,
        PFTimeScaleCurve = "-1",
        TargetPFTimeScaleCurve = "-1",
        PFMonsterSpeed = 1.0,
        PFMonsterSpeedCurve = "-1",
        PFSceneSpeed = 1.0,
        PFSceneSpeedCurve = "-1",
        PFTime = 0.099,
        UsePostProcess = false,
      },
      Move = {
        pivot = 0.0,
        canGlide = false,
        GlideCost = 0.0,
        GlideHeight = 0.0,
        GlideRotationSpeed = 0.0,
        GlideDownSpeed = 0.0,
        GlideMoveSpeed = 0.0,
        GlideTurnSpeed = 0.0,
        GlideTurnBackSpeed = 0.0,
        MoveType = 3,
        LineraSpeedType = 1,
        Speed = 0.0,
        SpeedCurveId = 0,
        EarlyWarningFrame = 0,
        SignId = 0,
        WarningDurationFrame = 0,
        RotateSpeedCurveId = 0,
        AlwaysUpdateTargetPos = false,
        RotationLockInterval = 0.0,
        RotationLockDelay = 0,
        BindOffsetX = 0.0,
        BindOffsetY = 0.0,
        BindOffsetZ = 0.0,
        BindRotation = false,

      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 9200301301 ] = {
    EntityId = 9200301301,
    EntityName = "9200301301",
    Components = {
      Transform = {
        Prefab = "Character/Role/Entity1003/Model/Entity1004.prefab",
        isClone = false,
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
      TimeoutDeath = {
        Frame = 3,
        RemoveDelayFrame = 0,
      },
      Camp = {
        Camp = 2
      },
      Tag = {
        Tag = 2,
        NpcTag = 0,
        SceneObjectTag = 0,
        PartTag = 1
      },
      Attack = {
        AttackType = 0,
        MaxAttackTimes = -1,
        DelayFrame = 0,
        DurationFrame = 4,
        ShapeType = 2,
        Radius = 11000.0,
        circleStartRadius = 0.5,
        circleRadius = 0.5,
        SpreadSpeed = 0.0,
        SpreadFrame = 0,
        Lenght = 4.0,
        Height = 3.0,
        Width = 3.0,
        OffsetX = 0.0,
        OffsetY = 1.5,
        OffsetZ = 1.5,
        Repetition = false,
        IntervalFrame = 0,
        RemoveAfterHit = true,
        CanHitGround = false,
        RemoveAfterReach = false,
        ReachRange = 0.0,
        ReboundFrame = 0,
        IntervalTime = 0.0,
        ReboundTag = 1,
        ReboundEntityId = 0,
        DodgeInvalidType = 1,
        NotCheckDodge = false,
        NotJumpDodge = true,
        NotJumpBeatBack = true,
        MagicsBySelfBeforeHit = {
          10000002,
          30000005
        },
        MagicsByTarget = {
          900020002,
          10130001,
          20000002
        },
        CreateHitEntities = {
          {
            EntityId = 92003998,
            LookRX = false,
            LookRY = true,
            LookRZ = false,
            LookatType = 3
          }
        },
        HitTypeConfigList = {
          {
            HitType = 7,
            BreakLieDown = true
          }
        },
        SwtichLieAnimTime = 0.0,
        LookatType = 3,
        HitParams = {
          SpeedZ = 5.0,
          SpeedZAcceleration = -1.0,
          SpeedZTime = 0.2,
          SpeedY = 13.0,
          SpeedZHitFly = 10.0,
          SpeedYAcceleration = -3.0,
          SpeedYAccelerationTime = 0.2,
          SpeedYAloft = 10.0,
          SpeedZAloft = 10.0,
          SpeedYAccelerationAloft = -5.0,
          SpeedYAccelerationTimeAloft = 0.2
        },        UseCameraShake = true,
        ShakeId = 0,
        CalcNearShakeBone = true,
        BoneEffectPos = { 0.0, 0.0, 0.0 },
        ShakeDir = 0,
        ShakeStrenRatio = 0.0,
        HavePauseFrame = true,
        IsCanBreak = true,
        PFFrame = 4,
        PFTimeScale = 0.0,
        PFTimeScaleCurve = "-1",
        TargetPFTimeScaleCurve = "-1",
        PFMonsterSpeed = 1.0,
        PFMonsterSpeedCurve = "-1",
        PFSceneSpeed = 1.0,
        PFSceneSpeedCurve = "-1",
        PFTime = 0.132,
        UsePostProcess = true,
        PostProcessParamsList = {
          {

            Strength = 0.2,
            Dir = 0,
            Radius = 0.35,
            Alpha = 1.0,
            AlphaCurveId = 1301,
            Direction = 0,
            Count = 3,
            Center = { 0.5, 0.5 },
            ShowTemplateID = false,
            TemplateID = 0,
            PostProcessType = 2,
            Duration = 3,
            ID = 0
          }
        },
      },
      Move = {
        pivot = 0.0,
        canGlide = false,
        GlideCost = 0.0,
        GlideHeight = 0.0,
        GlideRotationSpeed = 0.0,
        GlideDownSpeed = 0.0,
        GlideMoveSpeed = 0.0,
        GlideTurnSpeed = 0.0,
        GlideTurnBackSpeed = 0.0,
        MoveType = 3,
        LineraSpeedType = 1,
        Speed = 0.0,
        SpeedCurveId = 0,
        EarlyWarningFrame = 0,
        SignId = 0,
        WarningDurationFrame = 0,
        RotateSpeedCurveId = 0,
        AlwaysUpdateTargetPos = false,
        RotationLockInterval = 0.0,
        RotationLockDelay = 0,
        BindOffsetX = 0.0,
        BindOffsetY = 0.0,
        BindOffsetZ = 0.0,
        BindRotation = false,

      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 9200300402 ] = {
    EntityId = 9200300402,
    EntityName = "9200300402",
    Components = {
      Transform = {
        Prefab = "Character/Role/Entity1003/Model/Entity1004.prefab",
        isClone = false,
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
      TimeoutDeath = {
        Frame = 4,
        RemoveDelayFrame = 0,
      },
      Camp = {
        Camp = 2
      },
      Tag = {
        Tag = 2,
        NpcTag = 0,
        SceneObjectTag = 0,
        PartTag = 1
      },
      Attack = {
        AttackType = 0,
        MaxAttackTimes = -1,
        DelayFrame = 0,
        DurationFrame = 4,
        ShapeType = 2,
        Radius = 11000.0,
        circleStartRadius = 0.5,
        circleRadius = 0.5,
        SpreadSpeed = 0.0,
        SpreadFrame = 0,
        Lenght = 3.0,
        Height = 3.0,
        Width = 4.0,
        OffsetX = 0.0,
        OffsetY = 0.0,
        OffsetZ = 2.0,
        Repetition = false,
        IntervalFrame = 0,
        RemoveAfterHit = true,
        CanHitGround = false,
        RemoveAfterReach = false,
        ReachRange = 0.0,
        ReboundFrame = 0,
        IntervalTime = 0.0,
        ReboundTag = 1,
        ReboundEntityId = 0,
        DodgeInvalidType = 1,
        NotCheckDodge = false,
        NotJumpDodge = true,
        NotJumpBeatBack = true,
        MagicsByTarget = {
          900020002,
          10040001
        },
        HitTypeConfigList = {
          {
            HitType = 7,
            BreakLieDown = true
          }
        },
        SwtichLieAnimTime = 0.0,
        LookatType = 3,
        HitParams = {
          SpeedZ = 0.0,
          SpeedZAcceleration = 0.0,
          SpeedZTime = 0.0,
          SpeedY = 15.0,
          SpeedZHitFly = 3.5,
          SpeedYAcceleration = -35.0,
          SpeedYAccelerationTime = 0.3,
          SpeedYAloft = 10.0,
          SpeedZAloft = 10.0,

        },        UseCameraShake = true,
        ShakeId = 0,
        CalcNearShakeBone = true,
        BoneEffectPos = { 0.0, 0.0, 0.0 },
        ShakeDir = 0,
        ShakeStrenRatio = 0.0,
        HavePauseFrame = false,
        IsCanBreak = true,
        PFFrame = 3,
        PFTimeScale = 1.0,
        PFTimeScaleCurve = "-1",
        TargetPFTimeScaleCurve = "-1",
        PFMonsterSpeed = 1.0,
        PFMonsterSpeedCurve = "-1",
        PFSceneSpeed = 1.0,
        PFSceneSpeedCurve = "-1",
        PFTime = 0.099,
        UsePostProcess = false,
      },
      Move = {
        pivot = 0.0,
        canGlide = false,
        GlideCost = 0.0,
        GlideHeight = 0.0,
        GlideRotationSpeed = 0.0,
        GlideDownSpeed = 0.0,
        GlideMoveSpeed = 0.0,
        GlideTurnSpeed = 0.0,
        GlideTurnBackSpeed = 0.0,
        MoveType = 3,
        LineraSpeedType = 1,
        Speed = 0.0,
        SpeedCurveId = 0,
        EarlyWarningFrame = 0,
        SignId = 0,
        WarningDurationFrame = 0,
        RotateSpeedCurveId = 0,
        AlwaysUpdateTargetPos = false,
        RotationLockInterval = 0.0,
        RotationLockDelay = 0,
        BindOffsetX = 0.0,
        BindOffsetY = 0.0,
        BindOffsetZ = 0.0,
        BindRotation = false,

      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 9200301001 ] = {
    EntityId = 9200301001,
    EntityName = "9200301001",
    Components = {
      Transform = {
        Prefab = "Character/Role/Entity1003/Model/Entity1004.prefab",
        isClone = false,
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
      TimeoutDeath = {
        Frame = 3,
        RemoveDelayFrame = 0,
      },
      Camp = {
        Camp = 2
      },
      Tag = {
        Tag = 2,
        NpcTag = 0,
        SceneObjectTag = 0,
        PartTag = 1
      },
      Attack = {
        AttackType = 0,
        MaxAttackTimes = -1,
        DelayFrame = 0,
        DurationFrame = 4,
        ShapeType = 2,
        Radius = 11000.0,
        circleStartRadius = 0.5,
        circleRadius = 0.5,
        SpreadSpeed = 0.0,
        SpreadFrame = 0,
        Lenght = 5.0,
        Height = 3.0,
        Width = 4.5,
        OffsetX = 0.0,
        OffsetY = 1.5,
        OffsetZ = 1.0,
        Repetition = false,
        IntervalFrame = 0,
        RemoveAfterHit = true,
        CanHitGround = false,
        RemoveAfterReach = false,
        ReachRange = 0.0,
        ReboundFrame = 0,
        IntervalTime = 0.0,
        ReboundTag = 1,
        ReboundEntityId = 0,
        DodgeInvalidType = 1,
        NotCheckDodge = false,
        NotJumpDodge = true,
        NotJumpBeatBack = true,
        MagicsBySelf = {
          10000001,
          30000008
        },
        MagicsByTarget = {
          10100001,
          20000001,
          92003006
        },
        HitTypeConfigList = {
          {
            HitType = 4,
            BreakLieDown = false
          }
        },
        SwtichLieAnimTime = 0.0,
        LookatType = 3,
        HitParams = {
          SpeedZ = 7.5,
          SpeedZAcceleration = -2.0,
          SpeedZTime = 0.4,
          SpeedY = 0.0,
          SpeedZHitFly = 0.0,
          SpeedYAcceleration = 0.0,
          SpeedYAccelerationTime = 0.0,
          SpeedYAloft = 5.0,
          SpeedZAloft = 2.0,

        },        UseCameraShake = false,
        CameraShake = {
          {
            ShakeType = 2,
            Random = 0.0,
            StartOffset = 0.0,
            StartAmplitude = 0.15,
            StartFrequency = 15.0,
            TargetAmplitude = 0.3,
            TargetFrequency = 10.0,
            AmplitudeChangeTime = 0.15,
            FrequencyChangeTime = 0.0,
            DurationTime = 0.15,
            Sign = 9200304.0,
            DistanceDampingId = 0.0
          }
        },
        ShakeId = 0,
        CalcNearShakeBone = true,
        BoneEffectPos = { 0.0, 0.0, 0.0 },
        ShakeDir = 0,
        ShakeStrenRatio = 0.0,
        HavePauseFrame = false,
        IsCanBreak = true,
        PFFrame = 3,
        PFTimeScale = 1.0,
        PFTimeScaleCurve = "-1",
        TargetPFTimeScaleCurve = "-1",
        PFMonsterSpeed = 1.0,
        PFMonsterSpeedCurve = "-1",
        PFSceneSpeed = 1.0,
        PFSceneSpeedCurve = "-1",
        PFTime = 0.099,
        UsePostProcess = true,
        PostProcessParamsList = {
          {

            Strength = 0.2,
            Dir = 0,
            Radius = 0.35,
            Alpha = 0.7,
            AlphaCurveId = 1301,
            Direction = 0,
            Count = 3,
            Center = { 0.5, 0.5 },
            ShowTemplateID = false,
            TemplateID = 0,
            PostProcessType = 2,
            Duration = 3,
            ID = 0
          }
        },
      },
      Move = {
        pivot = 0.0,
        canGlide = false,
        GlideCost = 0.0,
        GlideHeight = 0.0,
        GlideRotationSpeed = 0.0,
        GlideDownSpeed = 0.0,
        GlideMoveSpeed = 0.0,
        GlideTurnSpeed = 0.0,
        GlideTurnBackSpeed = 0.0,
        MoveType = 3,
        LineraSpeedType = 1,
        Speed = 0.0,
        SpeedCurveId = 0,
        EarlyWarningFrame = 0,
        SignId = 0,
        WarningDurationFrame = 0,
        RotateSpeedCurveId = 0,
        AlwaysUpdateTargetPos = false,
        RotationLockInterval = 0.0,
        RotationLockDelay = 0,
        BindOffsetX = 0.0,
        BindOffsetY = 0.0,
        BindOffsetZ = 0.0,
        BindRotation = false,

      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 9200320401 ] = {
    EntityId = 9200320401,
    EntityName = "9200320401",
    Components = {
      Transform = {
        Prefab = "Character/Role/Entity1003/Model/Entity1004.prefab",
        isClone = false,
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
      TimeoutDeath = {
        Frame = 2,
        RemoveDelayFrame = 0,
      },
      Camp = {
        Camp = 2
      },
      Tag = {
        Tag = 2,
        NpcTag = 0,
        SceneObjectTag = 0,
        PartTag = 1
      },
      Attack = {
        AttackType = 0,
        MaxAttackTimes = -1,
        DelayFrame = 0,
        DurationFrame = 4,
        ShapeType = 2,
        Radius = 11000.0,
        circleStartRadius = 0.5,
        circleRadius = 0.5,
        SpreadSpeed = 0.0,
        SpreadFrame = 0,
        Lenght = 3.0,
        Height = 3.0,
        Width = 4.0,
        OffsetX = 0.0,
        OffsetY = 0.0,
        OffsetZ = 1.0,
        Repetition = false,
        IntervalFrame = 0,
        RemoveAfterHit = true,
        CanHitGround = false,
        RemoveAfterReach = false,
        ReachRange = 0.0,
        ReboundFrame = 0,
        IntervalTime = 0.0,
        ReboundTag = 1,
        ReboundEntityId = 0,
        DodgeInvalidType = 1,
        NotCheckDodge = false,
        NotJumpDodge = true,
        NotJumpBeatBack = true,
        MagicsBySelfBeforeHit = {
          30000003,
          10000001
        },
        MagicsByTarget = {
          20040001,
          92003
        },
        HitTypeConfigList = {
          {
            HitType = 4,
            BreakLieDown = false
          }
        },
        SwtichLieAnimTime = 0.0,
        LookatType = 3,
        HitParams = {
          SpeedZ = 4.5,
          SpeedZAcceleration = 3.0,
          SpeedZTime = 0.3,
          SpeedY = 0.0,
          SpeedZHitFly = 0.0,
          SpeedYAcceleration = 0.0,
          SpeedYAccelerationTime = 0.0,
          SpeedYAloft = 5.0,
          SpeedZAloft = 2.0,

        },        UseCameraShake = false,
        CameraShake = {
          {
            ShakeType = 2,
            Random = 0.0,
            StartOffset = 0.0,
            StartAmplitude = 0.15,
            StartFrequency = 15.0,
            TargetAmplitude = 0.3,
            TargetFrequency = 10.0,
            AmplitudeChangeTime = 0.15,
            FrequencyChangeTime = 0.0,
            DurationTime = 0.15,
            Sign = 9200304.0,
            DistanceDampingId = 0.0
          }
        },
        ShakeId = 0,
        CalcNearShakeBone = true,
        BoneEffectPos = { 0.0, 0.0, 0.0 },
        ShakeDir = 0,
        ShakeStrenRatio = 0.0,
        HavePauseFrame = false,
        IsCanBreak = true,
        PFFrame = 3,
        PFTimeScale = 1.0,
        PFTimeScaleCurve = "-1",
        TargetPFTimeScaleCurve = "-1",
        PFMonsterSpeed = 1.0,
        PFMonsterSpeedCurve = "-1",
        PFSceneSpeed = 1.0,
        PFSceneSpeedCurve = "-1",
        PFTime = 0.099,
        UsePostProcess = true,
        PostProcessParamsList = {
          {

            Strength = 0.2,
            Dir = 0,
            Radius = 0.35,
            Alpha = 0.7,
            AlphaCurveId = 1301,
            Direction = 0,
            Count = 3,
            Center = { 0.5, 0.5 },
            ShowTemplateID = false,
            TemplateID = 0,
            PostProcessType = 2,
            Duration = 3,
            ID = 0
          }
        },
      },
      Move = {
        pivot = 0.0,
        canGlide = false,
        GlideCost = 0.0,
        GlideHeight = 0.0,
        GlideRotationSpeed = 0.0,
        GlideDownSpeed = 0.0,
        GlideMoveSpeed = 0.0,
        GlideTurnSpeed = 0.0,
        GlideTurnBackSpeed = 0.0,
        MoveType = 3,
        LineraSpeedType = 1,
        Speed = 0.0,
        SpeedCurveId = 0,
        EarlyWarningFrame = 0,
        SignId = 0,
        WarningDurationFrame = 0,
        RotateSpeedCurveId = 0,
        AlwaysUpdateTargetPos = false,
        RotationLockInterval = 0.0,
        RotationLockDelay = 0,
        BindOffsetX = 0.0,
        BindOffsetY = 0.0,
        BindOffsetZ = 0.0,
        BindRotation = false,

      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 9200320501 ] = {
    EntityId = 9200320501,
    EntityName = "9200320501",
    Components = {
      Transform = {
        Prefab = "Character/Role/Entity1003/Model/Entity1004.prefab",
        isClone = false,
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
      TimeoutDeath = {
        Frame = 3,
        RemoveDelayFrame = 0,
      },
      Camp = {
        Camp = 2
      },
      Tag = {
        Tag = 2,
        NpcTag = 0,
        SceneObjectTag = 0,
        PartTag = 1
      },
      Attack = {
        AttackType = 1,
        MaxAttackTimes = -1,
        DelayFrame = 0,
        DurationFrame = 4,
        ShapeType = 2,
        Radius = 11000.0,
        circleStartRadius = 0.5,
        circleRadius = 0.5,
        SpreadSpeed = 0.0,
        SpreadFrame = 0,
        Lenght = 3.0,
        Height = 3.0,
        Width = 6.5,
        OffsetX = 0.0,
        OffsetY = 1.5,
        OffsetZ = 2.5,
        Repetition = false,
        IntervalFrame = 0,
        RemoveAfterHit = true,
        CanHitGround = false,
        RemoveAfterReach = false,
        ReachRange = 0.0,
        ReboundFrame = 0,
        IntervalTime = 0.0,
        ReboundTag = 1,
        ReboundEntityId = 0,
        DodgeInvalidType = 2,
        NotCheckDodge = false,
        NotJumpDodge = true,
        NotJumpBeatBack = true,
        MagicsBySelfBeforeHit = {
          10000001
        },
        MagicsByTargetBeforeHit = {
          20000001
        },
        MagicsByTarget = {
          92003007,
          20050001
        },
        HitTypeConfigList = {
          {
            HitType = 7,
            BreakLieDown = true
          }
        },
        SwtichLieAnimTime = 0.0,
        LookatType = 3,
        HitParams = {
          SpeedZ = 6.0,
          SpeedZAcceleration = -1.0,
          SpeedZTime = 0.3,
          SpeedY = 17.0,
          SpeedZHitFly = 3.5,
          SpeedYAcceleration = -35.0,
          SpeedYAccelerationTime = 0.3,
          SpeedYAloft = 10.0,
          SpeedZAloft = 10.0,

        },        UseCameraShake = true,
        ShakeId = 0,
        CalcNearShakeBone = true,
        BoneEffectPos = { 0.0, 0.0, 0.0 },
        ShakeDir = 0,
        ShakeStrenRatio = 0.0,
        HavePauseFrame = false,
        IsCanBreak = true,
        PFFrame = 3,
        PFTimeScale = 1.0,
        PFTimeScaleCurve = "-1",
        TargetPFTimeScaleCurve = "-1",
        PFMonsterSpeed = 1.0,
        PFMonsterSpeedCurve = "-1",
        PFSceneSpeed = 1.0,
        PFSceneSpeedCurve = "-1",
        PFTime = 0.099,
        UsePostProcess = false,
      },
      Move = {
        pivot = 0.0,
        canGlide = false,
        GlideCost = 0.0,
        GlideHeight = 0.0,
        GlideRotationSpeed = 0.0,
        GlideDownSpeed = 0.0,
        GlideMoveSpeed = 0.0,
        GlideTurnSpeed = 0.0,
        GlideTurnBackSpeed = 0.0,
        MoveType = 2,
        LineraSpeedType = 1,
        Speed = 0.0,
        SpeedCurveId = 0,
        EarlyWarningFrame = 0,
        SignId = 0,
        WarningDurationFrame = 0,
        RotateSpeedCurveId = 0,
        AlwaysUpdateTargetPos = false,
        RotationLockInterval = 0.0,
        RotationLockDelay = 0,
        BindRotation = false,

      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 9200320402 ] = {
    EntityId = 9200320402,
    EntityName = "9200320402",
    Components = {
      Transform = {
        Prefab = "Character/Role/Entity1003/Model/Entity1004.prefab",
        isClone = false,
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
      TimeoutDeath = {
        Frame = 2,
        RemoveDelayFrame = 0,
      },
      Camp = {
        Camp = 2
      },
      Tag = {
        Tag = 2,
        NpcTag = 0,
        SceneObjectTag = 0,
        PartTag = 1
      },
      Attack = {
        AttackType = 0,
        MaxAttackTimes = -1,
        DelayFrame = 0,
        DurationFrame = 4,
        ShapeType = 2,
        Radius = 11000.0,
        circleStartRadius = 0.5,
        circleRadius = 0.5,
        SpreadSpeed = 0.0,
        SpreadFrame = 0,
        Lenght = 3.0,
        Height = 3.0,
        Width = 5.0,
        OffsetX = 0.0,
        OffsetY = 0.0,
        OffsetZ = 1.0,
        Repetition = false,
        IntervalFrame = 0,
        RemoveAfterHit = true,
        CanHitGround = false,
        RemoveAfterReach = false,
        ReachRange = 0.0,
        ReboundFrame = 0,
        IntervalTime = 0.0,
        ReboundTag = 1,
        ReboundEntityId = 0,
        DodgeInvalidType = 1,
        NotCheckDodge = false,
        NotJumpDodge = true,
        NotJumpBeatBack = true,
        MagicsByTarget = {
          900020002,
          20040002
        },
        HitTypeConfigList = {
          {
            HitType = 7,
            BreakLieDown = true
          }
        },
        SwtichLieAnimTime = 0.0,
        LookatType = 3,
        HitParams = {
          SpeedZ = 0.0,
          SpeedZAcceleration = 0.0,
          SpeedZTime = 0.0,
          SpeedY = 15.0,
          SpeedZHitFly = 3.5,
          SpeedYAcceleration = -35.0,
          SpeedYAccelerationTime = 0.3,
          SpeedYAloft = 10.0,
          SpeedZAloft = 10.0,

        },        UseCameraShake = true,
        ShakeId = 0,
        CalcNearShakeBone = true,
        BoneEffectPos = { 0.0, 0.0, 0.0 },
        ShakeDir = 0,
        ShakeStrenRatio = 0.0,
        HavePauseFrame = false,
        IsCanBreak = true,
        PFFrame = 3,
        PFTimeScale = 1.0,
        PFTimeScaleCurve = "-1",
        TargetPFTimeScaleCurve = "-1",
        PFMonsterSpeed = 1.0,
        PFMonsterSpeedCurve = "-1",
        PFSceneSpeed = 1.0,
        PFSceneSpeedCurve = "-1",
        PFTime = 0.099,
        UsePostProcess = false,
      },
      Move = {
        pivot = 0.0,
        canGlide = false,
        GlideCost = 0.0,
        GlideHeight = 0.0,
        GlideRotationSpeed = 0.0,
        GlideDownSpeed = 0.0,
        GlideMoveSpeed = 0.0,
        GlideTurnSpeed = 0.0,
        GlideTurnBackSpeed = 0.0,
        MoveType = 3,
        LineraSpeedType = 1,
        Speed = 0.0,
        SpeedCurveId = 0,
        EarlyWarningFrame = 0,
        SignId = 0,
        WarningDurationFrame = 0,
        RotateSpeedCurveId = 0,
        AlwaysUpdateTargetPos = false,
        RotationLockInterval = 0.0,
        RotationLockDelay = 0,
        BindOffsetX = 0.0,
        BindOffsetY = 0.0,
        BindOffsetZ = 0.0,
        BindRotation = false,

      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 9200320601 ] = {
    EntityId = 9200320601,
    EntityName = "9200320601",
    Components = {
      Transform = {
        Prefab = "Character/Role/Entity1003/Model/Entity1004.prefab",
        isClone = false,
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
      TimeoutDeath = {
        Frame = 2,
        RemoveDelayFrame = 0,
      },
      Camp = {
        Camp = 2
      },
      Tag = {
        Tag = 2,
        NpcTag = 0,
        SceneObjectTag = 0,
        PartTag = 1
      },
      Attack = {
        AttackType = 0,
        MaxAttackTimes = -1,
        DelayFrame = 0,
        DurationFrame = 4,
        ShapeType = 2,
        Radius = 11000.0,
        circleStartRadius = 0.5,
        circleRadius = 0.5,
        SpreadSpeed = 0.0,
        SpreadFrame = 0,
        Lenght = 4.0,
        Height = 3.0,
        Width = 3.0,
        OffsetX = 0.0,
        OffsetY = 1.5,
        OffsetZ = 1.5,
        Repetition = false,
        IntervalFrame = 0,
        RemoveAfterHit = true,
        CanHitGround = false,
        RemoveAfterReach = false,
        ReachRange = 0.0,
        ReboundFrame = 0,
        IntervalTime = 0.0,
        ReboundTag = 1,
        ReboundEntityId = 0,
        DodgeInvalidType = 2,
        NotCheckDodge = false,
        NotJumpDodge = true,
        NotJumpBeatBack = true,
        MagicsBySelfBeforeHit = {
          30000001,
          10000001
        },
        MagicsByTarget = {
          20060001,
          92003006,
          20000001
        },
        HitTypeConfigList = {
          {
            HitType = 3,
            BreakLieDown = false
          }
        },
        SwtichLieAnimTime = 0.0,
        LookatType = 3,
        HitParams = {
          SpeedZ = 10.0,
          SpeedZAcceleration = -2.0,
          SpeedZTime = 0.3,
          SpeedY = 0.0,
          SpeedZHitFly = 0.0,
          SpeedYAcceleration = 0.0,
          SpeedYAccelerationTime = 0.0,
          SpeedYAloft = 5.0,
          SpeedZAloft = 2.0,

        },        UseCameraShake = false,
        CameraShake = {
          {
            ShakeType = 2,
            Random = 0.0,
            StartOffset = 0.0,
            StartAmplitude = 0.15,
            StartFrequency = 15.0,
            TargetAmplitude = 0.3,
            TargetFrequency = 10.0,
            AmplitudeChangeTime = 0.15,
            FrequencyChangeTime = 0.0,
            DurationTime = 0.15,
            Sign = 9200304.0,
            DistanceDampingId = 0.0
          }
        },
        ShakeId = 0,
        CalcNearShakeBone = true,
        BoneEffectPos = { 0.0, 0.0, 0.0 },
        ShakeDir = 0,
        ShakeStrenRatio = 0.0,
        HavePauseFrame = false,
        IsCanBreak = true,
        PFFrame = 3,
        PFTimeScale = 1.0,
        PFTimeScaleCurve = "-1",
        TargetPFTimeScaleCurve = "-1",
        PFMonsterSpeed = 1.0,
        PFMonsterSpeedCurve = "-1",
        PFSceneSpeed = 1.0,
        PFSceneSpeedCurve = "-1",
        PFTime = 0.099,
        UsePostProcess = true,
        PostProcessParamsList = {
          {

            Strength = 0.2,
            Dir = 0,
            Radius = 0.35,
            Alpha = 0.7,
            AlphaCurveId = 1301,
            Direction = 0,
            Count = 3,
            Center = { 0.5, 0.5 },
            ShowTemplateID = false,
            TemplateID = 0,
            PostProcessType = 2,
            Duration = 3,
            ID = 0
          }
        },
      },
      Move = {
        pivot = 0.0,
        canGlide = false,
        GlideCost = 0.0,
        GlideHeight = 0.0,
        GlideRotationSpeed = 0.0,
        GlideDownSpeed = 0.0,
        GlideMoveSpeed = 0.0,
        GlideTurnSpeed = 0.0,
        GlideTurnBackSpeed = 0.0,
        MoveType = 3,
        LineraSpeedType = 1,
        Speed = 0.0,
        SpeedCurveId = 0,
        EarlyWarningFrame = 0,
        SignId = 0,
        WarningDurationFrame = 0,
        RotateSpeedCurveId = 0,
        AlwaysUpdateTargetPos = false,
        RotationLockInterval = 0.0,
        RotationLockDelay = 0,
        BindOffsetX = 0.0,
        BindOffsetY = 0.0,
        BindOffsetZ = 0.0,
        BindRotation = false,

      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 9200320701 ] = {
    EntityId = 9200320701,
    EntityName = "9200320701",
    Components = {
      Transform = {
        Prefab = "Character/Role/Entity1003/Model/Entity1004.prefab",
        isClone = false,
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
      TimeoutDeath = {
        Frame = 2,
        RemoveDelayFrame = 0,
      },
      Camp = {
        Camp = 2
      },
      Tag = {
        Tag = 2,
        NpcTag = 0,
        SceneObjectTag = 0,
        PartTag = 1
      },
      Attack = {
        AttackType = 0,
        MaxAttackTimes = -1,
        DelayFrame = 0,
        DurationFrame = 4,
        ShapeType = 2,
        Radius = 11000.0,
        circleStartRadius = 0.5,
        circleRadius = 0.5,
        SpreadSpeed = 0.0,
        SpreadFrame = 0,
        Lenght = 3.0,
        Height = 3.0,
        Width = 3.0,
        OffsetX = 0.0,
        OffsetY = 1.5,
        OffsetZ = 1.5,
        Repetition = false,
        IntervalFrame = 0,
        RemoveAfterHit = true,
        CanHitGround = false,
        RemoveAfterReach = false,
        ReachRange = 0.0,
        ReboundFrame = 0,
        IntervalTime = 0.0,
        ReboundTag = 1,
        ReboundEntityId = 0,
        DodgeInvalidType = 2,
        NotCheckDodge = false,
        NotJumpDodge = true,
        NotJumpBeatBack = true,
        MagicsBySelfBeforeHit = {
          30000003,
          10000001
        },
        MagicsByTarget = {
          92003005,
          20070001,
          20000001
        },
        HitTypeConfigList = {
          {
            HitType = 4,
            BreakLieDown = true
          }
        },
        SwtichLieAnimTime = 0.0,
        LookatType = 3,
        HitParams = {
          SpeedZ = 10.0,
          SpeedZAcceleration = -2.0,
          SpeedZTime = 0.3,
          SpeedY = 18.0,
          SpeedZHitFly = 6.0,
          SpeedYAcceleration = -30.0,
          SpeedYAccelerationTime = 0.3,
          SpeedYAloft = 10.0,
          SpeedZAloft = 10.0,

        },        UseCameraShake = true,
        ShakeId = 0,
        CalcNearShakeBone = true,
        BoneEffectPos = { 0.0, 0.0, 0.0 },
        ShakeDir = 0,
        ShakeStrenRatio = 0.0,
        HavePauseFrame = false,
        IsCanBreak = true,
        PFFrame = 3,
        PFTimeScale = 1.0,
        PFTimeScaleCurve = "-1",
        TargetPFTimeScaleCurve = "-1",
        PFMonsterSpeed = 1.0,
        PFMonsterSpeedCurve = "-1",
        PFSceneSpeed = 1.0,
        PFSceneSpeedCurve = "-1",
        PFTime = 0.099,
        UsePostProcess = false,
      },
      Move = {
        pivot = 0.0,
        canGlide = false,
        GlideCost = 0.0,
        GlideHeight = 0.0,
        GlideRotationSpeed = 0.0,
        GlideDownSpeed = 0.0,
        GlideMoveSpeed = 0.0,
        GlideTurnSpeed = 0.0,
        GlideTurnBackSpeed = 0.0,
        MoveType = 3,
        LineraSpeedType = 1,
        Speed = 0.0,
        SpeedCurveId = 0,
        EarlyWarningFrame = 0,
        SignId = 0,
        WarningDurationFrame = 0,
        RotateSpeedCurveId = 0,
        AlwaysUpdateTargetPos = false,
        RotationLockInterval = 0.0,
        RotationLockDelay = 0,
        BindOffsetX = 0.0,
        BindOffsetY = 0.0,
        BindOffsetZ = 0.0,
        BindRotation = false,

      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 9200320801 ] = {
    EntityId = 9200320801,
    EntityName = "9200320801",
    Components = {
      Transform = {
        Prefab = "Character/Role/Entity1003/Model/Entity1004.prefab",
        isClone = false,
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
      TimeoutDeath = {
        Frame = 3,
        RemoveDelayFrame = 0,
      },
      Camp = {
        Camp = 2
      },
      Tag = {
        Tag = 2,
        NpcTag = 0,
        SceneObjectTag = 0,
        PartTag = 1
      },
      Attack = {
        AttackType = 0,
        MaxAttackTimes = -1,
        DelayFrame = 0,
        DurationFrame = 4,
        ShapeType = 2,
        Radius = 11000.0,
        circleStartRadius = 0.5,
        circleRadius = 0.5,
        SpreadSpeed = 0.0,
        SpreadFrame = 0,
        Lenght = 4.0,
        Height = 3.0,
        Width = 5.0,
        OffsetX = 1.0,
        OffsetY = 1.5,
        OffsetZ = 2.5,
        Repetition = false,
        IntervalFrame = 0,
        RemoveAfterHit = true,
        CanHitGround = false,
        RemoveAfterReach = false,
        ReachRange = 0.0,
        ReboundFrame = 0,
        IntervalTime = 0.0,
        ReboundTag = 1,
        ReboundEntityId = 0,
        DodgeInvalidType = 1,
        NotCheckDodge = false,
        NotJumpDodge = true,
        NotJumpBeatBack = true,
        MagicsBySelfBeforeHit = {
          10000007
        },
        MagicsByTargetBeforeHit = {
          20000006
        },
        MagicsByTarget = {
          92003007,
          20080001
        },
        HitTypeConfigList = {
          {
            HitType = 7,
            BreakLieDown = true
          }
        },
        SwtichLieAnimTime = 0.0,
        LookatType = 3,
        HitParams = {
          SpeedZ = 6.0,
          SpeedZAcceleration = -1.0,
          SpeedZTime = 0.3,
          SpeedY = 15.0,
          SpeedZHitFly = 5.0,
          SpeedYAcceleration = -18.0,
          SpeedYAccelerationTime = 0.3,
          SpeedYAloft = 5.0,
          SpeedZAloft = 5.0,

        },        UseCameraShake = true,
        ShakeId = 0,
        CalcNearShakeBone = true,
        BoneEffectPos = { 0.0, 0.0, 0.0 },
        ShakeDir = 0,
        ShakeStrenRatio = 0.0,
        HavePauseFrame = false,
        IsCanBreak = true,
        PFFrame = 3,
        PFTimeScale = 1.0,
        PFTimeScaleCurve = "-1",
        TargetPFTimeScaleCurve = "-1",
        PFMonsterSpeed = 1.0,
        PFMonsterSpeedCurve = "-1",
        PFSceneSpeed = 1.0,
        PFSceneSpeedCurve = "-1",
        PFTime = 0.099,
        UsePostProcess = false,
      },
      Move = {
        pivot = 0.0,
        canGlide = false,
        GlideCost = 0.0,
        GlideHeight = 0.0,
        GlideRotationSpeed = 0.0,
        GlideDownSpeed = 0.0,
        GlideMoveSpeed = 0.0,
        GlideTurnSpeed = 0.0,
        GlideTurnBackSpeed = 0.0,
        MoveType = 3,
        LineraSpeedType = 1,
        Speed = 0.0,
        SpeedCurveId = 0,
        EarlyWarningFrame = 0,
        SignId = 0,
        WarningDurationFrame = 0,
        RotateSpeedCurveId = 0,
        AlwaysUpdateTargetPos = false,
        RotationLockInterval = 0.0,
        RotationLockDelay = 0,
        BindOffsetX = 0.0,
        BindOffsetY = 0.0,
        BindOffsetZ = 0.0,
        BindRotation = false,

      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 9200321102 ] = {
    EntityId = 9200321102,
    EntityName = "9200321102",
    Components = {
      Transform = {
        Prefab = "Character/Role/Entity1003/Model/Entity1004.prefab",
        isClone = false,
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
      TimeoutDeath = {
        Frame = 3,
        RemoveDelayFrame = 0,
      },
      Camp = {
        Camp = 2
      },
      Tag = {
        Tag = 2,
        NpcTag = 0,
        SceneObjectTag = 0,
        PartTag = 1
      },
      Attack = {
        AttackType = 0,
        MaxAttackTimes = -1,
        DelayFrame = 0,
        DurationFrame = 4,
        ShapeType = 2,
        Radius = 11000.0,
        circleStartRadius = 0.5,
        circleRadius = 0.5,
        SpreadSpeed = 0.0,
        SpreadFrame = 0,
        Lenght = 3.0,
        Height = 3.0,
        Width = 3.5,
        OffsetX = 0.0,
        OffsetY = 0.0,
        OffsetZ = 1.0,
        Repetition = false,
        IntervalFrame = 0,
        RemoveAfterHit = true,
        CanHitGround = false,
        RemoveAfterReach = false,
        ReachRange = 0.0,
        ReboundFrame = 0,
        IntervalTime = 0.0,
        ReboundTag = 1,
        ReboundEntityId = 0,
        DodgeInvalidType = 1,
        NotCheckDodge = false,
        NotJumpDodge = true,
        NotJumpBeatBack = true,
        MagicsBySelfBeforeHit = {
          10000004,
          30000009
        },
        MagicsByTarget = {
          20110002,
          92003007,
          20000001
        },
        HitTypeConfigList = {
          {
            HitType = 4,
            BreakLieDown = false
          }
        },
        SwtichLieAnimTime = 0.0,
        LookatType = 3,
        HitParams = {
          SpeedZ = 4.5,
          SpeedZAcceleration = 3.0,
          SpeedZTime = 0.3,
          SpeedY = 0.0,
          SpeedZHitFly = 0.0,
          SpeedYAcceleration = 0.0,
          SpeedYAccelerationTime = 0.0,
          SpeedYAloft = 5.0,
          SpeedZAloft = 2.0,

        },        UseCameraShake = false,
        CameraShake = {
          {
            ShakeType = 2,
            Random = 0.0,
            StartOffset = 0.0,
            StartAmplitude = 0.15,
            StartFrequency = 15.0,
            TargetAmplitude = 0.3,
            TargetFrequency = 10.0,
            AmplitudeChangeTime = 0.15,
            FrequencyChangeTime = 0.0,
            DurationTime = 0.15,
            Sign = 9200304.0,
            DistanceDampingId = 0.0
          }
        },
        ShakeId = 0,
        CalcNearShakeBone = true,
        BoneEffectPos = { 0.0, 0.0, 0.0 },
        ShakeDir = 0,
        ShakeStrenRatio = 0.0,
        HavePauseFrame = false,
        IsCanBreak = true,
        PFFrame = 3,
        PFTimeScale = 1.0,
        PFTimeScaleCurve = "-1",
        TargetPFTimeScaleCurve = "-1",
        PFMonsterSpeed = 1.0,
        PFMonsterSpeedCurve = "-1",
        PFSceneSpeed = 1.0,
        PFSceneSpeedCurve = "-1",
        PFTime = 0.099,
        UsePostProcess = true,
        PostProcessParamsList = {
          {

            Strength = 0.2,
            Dir = 0,
            Radius = 0.35,
            Alpha = 0.7,
            AlphaCurveId = 1301,
            Direction = 0,
            Count = 3,
            Center = { 0.5, 0.5 },
            ShowTemplateID = false,
            TemplateID = 0,
            PostProcessType = 2,
            Duration = 3,
            ID = 0
          }
        },
      },
      Move = {
        pivot = 0.0,
        canGlide = false,
        GlideCost = 0.0,
        GlideHeight = 0.0,
        GlideRotationSpeed = 0.0,
        GlideDownSpeed = 0.0,
        GlideMoveSpeed = 0.0,
        GlideTurnSpeed = 0.0,
        GlideTurnBackSpeed = 0.0,
        MoveType = 3,
        LineraSpeedType = 1,
        Speed = 0.0,
        SpeedCurveId = 0,
        EarlyWarningFrame = 0,
        SignId = 0,
        WarningDurationFrame = 0,
        RotateSpeedCurveId = 0,
        AlwaysUpdateTargetPos = false,
        RotationLockInterval = 0.0,
        RotationLockDelay = 0,
        BindOffsetX = 0.0,
        BindOffsetY = 0.0,
        BindOffsetZ = 0.0,
        BindRotation = false,

      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 9200321101 ] = {
    EntityId = 9200321101,
    EntityName = "9200321101",
    Components = {
      Transform = {
        Prefab = "Character/Role/Entity1003/Model/Entity1004.prefab",
        isClone = false,
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
      TimeoutDeath = {
        Frame = 3,
        RemoveDelayFrame = 0,
      },
      Camp = {
        Camp = 2
      },
      Tag = {
        Tag = 2,
        NpcTag = 0,
        SceneObjectTag = 0,
        PartTag = 1
      },
      Attack = {
        AttackType = 0,
        MaxAttackTimes = -1,
        DelayFrame = 0,
        DurationFrame = 4,
        ShapeType = 2,
        Radius = 11000.0,
        circleStartRadius = 0.5,
        circleRadius = 0.5,
        SpreadSpeed = 0.0,
        SpreadFrame = 0,
        Lenght = 3.0,
        Height = 3.0,
        Width = 3.5,
        OffsetX = 0.0,
        OffsetY = 0.0,
        OffsetZ = 1.0,
        Repetition = false,
        IntervalFrame = 0,
        RemoveAfterHit = true,
        CanHitGround = false,
        RemoveAfterReach = false,
        ReachRange = 0.0,
        ReboundFrame = 0,
        IntervalTime = 0.0,
        ReboundTag = 1,
        ReboundEntityId = 0,
        DodgeInvalidType = 1,
        NotCheckDodge = false,
        NotJumpDodge = true,
        NotJumpBeatBack = true,
        MagicsBySelfBeforeHit = {
          10000001,
          30000007
        },
        MagicsByTargetBeforeHit = {
          20000001
        },
        MagicsByTarget = {
          20110001,
          92003006
        },
        HitTypeConfigList = {
          {
            HitType = 4,
            BreakLieDown = false
          }
        },
        SwtichLieAnimTime = 0.0,
        LookatType = 3,
        HitParams = {
          SpeedZ = 4.5,
          SpeedZAcceleration = 3.0,
          SpeedZTime = 0.3,
          SpeedY = 0.0,
          SpeedZHitFly = 0.0,
          SpeedYAcceleration = 0.0,
          SpeedYAccelerationTime = 0.0,
          SpeedYAloft = 5.0,
          SpeedZAloft = 2.0,

        },        UseCameraShake = false,
        CameraShake = {
          {
            ShakeType = 2,
            Random = 0.0,
            StartOffset = 0.0,
            StartAmplitude = 0.15,
            StartFrequency = 15.0,
            TargetAmplitude = 0.3,
            TargetFrequency = 10.0,
            AmplitudeChangeTime = 0.15,
            FrequencyChangeTime = 0.0,
            DurationTime = 0.15,
            Sign = 9200304.0,
            DistanceDampingId = 0.0
          }
        },
        ShakeId = 0,
        CalcNearShakeBone = true,
        BoneEffectPos = { 0.0, 0.0, 0.0 },
        ShakeDir = 0,
        ShakeStrenRatio = 0.0,
        HavePauseFrame = false,
        IsCanBreak = true,
        PFFrame = 3,
        PFTimeScale = 1.0,
        PFTimeScaleCurve = "-1",
        TargetPFTimeScaleCurve = "-1",
        PFMonsterSpeed = 1.0,
        PFMonsterSpeedCurve = "-1",
        PFSceneSpeed = 1.0,
        PFSceneSpeedCurve = "-1",
        PFTime = 0.099,
        UsePostProcess = true,
        PostProcessParamsList = {
          {

            Strength = 0.2,
            Dir = 0,
            Radius = 0.35,
            Alpha = 0.7,
            AlphaCurveId = 1301,
            Direction = 0,
            Count = 3,
            Center = { 0.5, 0.5 },
            ShowTemplateID = false,
            TemplateID = 0,
            PostProcessType = 2,
            Duration = 3,
            ID = 0
          }
        },
      },
      Move = {
        pivot = 0.0,
        canGlide = false,
        GlideCost = 0.0,
        GlideHeight = 0.0,
        GlideRotationSpeed = 0.0,
        GlideDownSpeed = 0.0,
        GlideMoveSpeed = 0.0,
        GlideTurnSpeed = 0.0,
        GlideTurnBackSpeed = 0.0,
        MoveType = 3,
        LineraSpeedType = 1,
        Speed = 0.0,
        SpeedCurveId = 0,
        EarlyWarningFrame = 0,
        SignId = 0,
        WarningDurationFrame = 0,
        RotateSpeedCurveId = 0,
        AlwaysUpdateTargetPos = false,
        RotationLockInterval = 0.0,
        RotationLockDelay = 0,
        BindOffsetX = 0.0,
        BindOffsetY = 0.0,
        BindOffsetZ = 0.0,
        BindRotation = false,

      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 9200321301 ] = {
    EntityId = 9200321301,
    EntityName = "9200321301",
    Components = {
      Transform = {
        Prefab = "Character/Role/Entity1003/Model/Entity1004.prefab",
        isClone = false,
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
      TimeoutDeath = {
        Frame = 2,
        RemoveDelayFrame = 0,
      },
      Camp = {
        Camp = 2
      },
      Tag = {
        Tag = 2,
        NpcTag = 0,
        SceneObjectTag = 0,
        PartTag = 1
      },
      Attack = {
        AttackType = 1,
        MaxAttackTimes = -1,
        DelayFrame = 0,
        DurationFrame = 4,
        ShapeType = 2,
        Radius = 11000.0,
        circleStartRadius = 0.5,
        circleRadius = 0.5,
        SpreadSpeed = 0.0,
        SpreadFrame = 0,
        Lenght = 4.0,
        Height = 3.0,
        Width = 4.0,
        OffsetX = 0.0,
        OffsetY = 1.5,
        OffsetZ = 2.0,
        Repetition = false,
        IntervalFrame = 0,
        RemoveAfterHit = true,
        CanHitGround = false,
        RemoveAfterReach = false,
        ReachRange = 0.0,
        ReboundFrame = 0,
        IntervalTime = 0.0,
        ReboundTag = 1,
        ReboundEntityId = 0,
        DodgeInvalidType = 1,
        NotCheckDodge = false,
        NotJumpDodge = false,
        NotJumpBeatBack = false,
        MagicsBySelfBeforeHit = {
          30000001
        },
        MagicsByTarget = {
          92003006,
          20130001
        },
        HitTypeConfigList = {
          {
            HitType = 1,
            BreakLieDown = true
          }
        },
        SwtichLieAnimTime = 0.0,
        LookatType = 3,
        HitParams = {
          SpeedZ = 5.0,
          SpeedZAcceleration = -1.0,
          SpeedZTime = 0.2,
          SpeedY = 18.0,
          SpeedZHitFly = 6.0,
          SpeedYAcceleration = -20.0,
          SpeedYAccelerationTime = 0.3,
          SpeedYAloft = 10.0,
          SpeedZAloft = 10.0,

        },        UseCameraShake = true,
        ShakeId = 0,
        CalcNearShakeBone = true,
        BoneEffectPos = { 0.0, 0.0, 0.0 },
        ShakeDir = 0,
        ShakeStrenRatio = 0.0,
        HavePauseFrame = true,
        IsCanBreak = true,
        PFFrame = 4,
        PFTimeScale = 0.0,
        PFTimeScaleCurve = "-1",
        TargetPFTimeScaleCurve = "-1",
        PFMonsterSpeed = 1.0,
        PFMonsterSpeedCurve = "-1",
        PFSceneSpeed = 1.0,
        PFSceneSpeedCurve = "-1",
        PFTime = 0.132,
        UsePostProcess = true,
        PostProcessParamsList = {
          {

            Strength = 0.2,
            Dir = 0,
            Radius = 0.6,
            Alpha = 1.0,
            AlphaCurveId = 1301,
            Direction = 0,
            Count = 3,
            Center = { 0.5, 0.5 },
            ShowTemplateID = false,
            TemplateID = 0,
            PostProcessType = 2,
            Duration = 3,
            ID = 0
          }
        },
      },
      Move = {
        pivot = 0.0,
        canGlide = false,
        GlideCost = 0.0,
        GlideHeight = 0.0,
        GlideRotationSpeed = 0.0,
        GlideDownSpeed = 0.0,
        GlideMoveSpeed = 0.0,
        GlideTurnSpeed = 0.0,
        GlideTurnBackSpeed = 0.0,
        MoveType = 3,
        LineraSpeedType = 1,
        Speed = 0.0,
        SpeedCurveId = 0,
        EarlyWarningFrame = 0,
        SignId = 0,
        WarningDurationFrame = 0,
        RotateSpeedCurveId = 0,
        AlwaysUpdateTargetPos = false,
        RotationLockInterval = 0.0,
        RotationLockDelay = 0,
        BindOffsetX = 0.0,
        BindOffsetY = 0.0,
        BindOffsetZ = 0.0,
        BindRotation = false,

      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 9200321302 ] = {
    EntityId = 9200321302,
    EntityName = "9200321302",
    Components = {
      Transform = {
        Prefab = "Character/Role/Entity1003/Model/Entity1004.prefab",
        isClone = false,
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
      TimeoutDeath = {
        Frame = 2,
        RemoveDelayFrame = 0,
      },
      Camp = {
        Camp = 2
      },
      Tag = {
        Tag = 2,
        NpcTag = 0,
        SceneObjectTag = 0,
        PartTag = 1
      },
      Attack = {
        AttackType = 1,
        MaxAttackTimes = -1,
        DelayFrame = 0,
        DurationFrame = 4,
        ShapeType = 2,
        Radius = 11000.0,
        circleStartRadius = 0.5,
        circleRadius = 0.5,
        SpreadSpeed = 0.0,
        SpreadFrame = 0,
        Lenght = 3.0,
        Height = 3.0,
        Width = 3.0,
        OffsetX = 0.0,
        OffsetY = 0.0,
        OffsetZ = 1.0,
        Repetition = false,
        IntervalFrame = 0,
        RemoveAfterHit = true,
        CanHitGround = false,
        RemoveAfterReach = false,
        ReachRange = 0.0,
        ReboundFrame = 0,
        IntervalTime = 0.0,
        ReboundTag = 1,
        ReboundEntityId = 0,
        DodgeInvalidType = 1,
        NotCheckDodge = false,
        NotJumpDodge = false,
        NotJumpBeatBack = false,
        MagicsBySelf = {
          10000002,
          30000006
        },
        MagicsByTarget = {
          20130002,
          92003006,
          20000002
        },
        HitTypeConfigList = {
          {
            HitType = 7,
            BreakLieDown = true
          }
        },
        SwtichLieAnimTime = 0.0,
        LookatType = 3,
        HitParams = {
          SpeedZ = 7.0,
          SpeedZAcceleration = -2.0,
          SpeedZTime = 0.3,
          SpeedY = 15.0,
          SpeedZHitFly = 8.0,
          SpeedYAcceleration = -35.0,
          SpeedYAccelerationTime = 0.3,
          SpeedYAloft = 10.0,
          SpeedZAloft = 8.0,

        },        UseCameraShake = true,
        ShakeId = 0,
        CalcNearShakeBone = true,
        BoneEffectPos = { 0.0, 0.0, 0.0 },
        ShakeDir = 0,
        ShakeStrenRatio = 0.0,
        HavePauseFrame = true,
        IsCanBreak = true,
        PFFrame = 4,
        PFTimeScale = 0.0,
        PFTimeScaleCurve = "-1",
        TargetPFTimeScaleCurve = "-1",
        PFMonsterSpeed = 1.0,
        PFMonsterSpeedCurve = "-1",
        PFSceneSpeed = 1.0,
        PFSceneSpeedCurve = "-1",
        PFTime = 0.132,
        UsePostProcess = true,
        PostProcessParamsList = {
          {

            Strength = 0.2,
            Dir = 0,
            Radius = 0.35,
            Alpha = 1.0,
            AlphaCurveId = 1301,
            Direction = 0,
            Count = 3,
            Center = { 0.5, 0.5 },
            ShowTemplateID = false,
            TemplateID = 0,
            PostProcessType = 2,
            Duration = 3,
            ID = 0
          }
        },
      },
      Move = {
        pivot = 0.0,
        canGlide = false,
        GlideCost = 0.0,
        GlideHeight = 0.0,
        GlideRotationSpeed = 0.0,
        GlideDownSpeed = 0.0,
        GlideMoveSpeed = 0.0,
        GlideTurnSpeed = 0.0,
        GlideTurnBackSpeed = 0.0,
        MoveType = 3,
        LineraSpeedType = 1,
        Speed = 0.0,
        SpeedCurveId = 0,
        EarlyWarningFrame = 0,
        SignId = 0,
        WarningDurationFrame = 0,
        RotateSpeedCurveId = 0,
        AlwaysUpdateTargetPos = false,
        RotationLockInterval = 0.0,
        RotationLockDelay = 0,
        BindOffsetX = 0.0,
        BindOffsetY = 0.0,
        BindOffsetZ = 0.0,
        BindRotation = false,

      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 9200320901 ] = {
    EntityId = 9200320901,
    EntityName = "9200320901",
    Components = {
      Transform = {
        Prefab = "Character/Role/Entity1003/Model/Entity1004.prefab",
        isClone = false,
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
      TimeoutDeath = {
        Frame = 3,
        RemoveDelayFrame = 0,
      },
      Camp = {
        Camp = 2
      },
      Tag = {
        Tag = 2,
        NpcTag = 0,
        SceneObjectTag = 0,
        PartTag = 1
      },
      Attack = {
        AttackType = 0,
        MaxAttackTimes = -1,
        DelayFrame = 0,
        DurationFrame = 4,
        ShapeType = 2,
        Radius = 11000.0,
        circleStartRadius = 0.5,
        circleRadius = 0.5,
        SpreadSpeed = 0.0,
        SpreadFrame = 0,
        Lenght = 3.0,
        Height = 3.0,
        Width = 5.0,
        OffsetX = 0.0,
        OffsetY = 0.0,
        OffsetZ = 1.0,
        Repetition = false,
        IntervalFrame = 0,
        RemoveAfterHit = true,
        CanHitGround = false,
        RemoveAfterReach = false,
        ReachRange = 0.0,
        ReboundFrame = 0,
        IntervalTime = 0.0,
        ReboundTag = 1,
        ReboundEntityId = 0,
        DodgeInvalidType = 1,
        NotCheckDodge = false,
        NotJumpDodge = false,
        NotJumpBeatBack = false,
        MagicsByTarget = {
          20090001,
          92003007
        },
        HitTypeConfigList = {
          {
            HitType = 4,
            BreakLieDown = false
          }
        },
        SwtichLieAnimTime = 0.0,
        LookatType = 3,
        HitParams = {
          SpeedZ = 6.0,
          SpeedZAcceleration = -2.0,
          SpeedZTime = 0.3,
          SpeedY = 0.0,
          SpeedZHitFly = 0.0,
          SpeedYAcceleration = 0.0,
          SpeedYAccelerationTime = 0.0,
          SpeedYAloft = 5.0,
          SpeedZAloft = 2.0,

        },        UseCameraShake = false,
        CameraShake = {
          {
            ShakeType = 2,
            Random = 0.0,
            StartOffset = 0.0,
            StartAmplitude = 0.15,
            StartFrequency = 15.0,
            TargetAmplitude = 0.3,
            TargetFrequency = 10.0,
            AmplitudeChangeTime = 0.15,
            FrequencyChangeTime = 0.0,
            DurationTime = 0.15,
            Sign = 9200304.0,
            DistanceDampingId = 0.0
          }
        },
        ShakeId = 0,
        CalcNearShakeBone = true,
        BoneEffectPos = { 0.0, 0.0, 0.0 },
        ShakeDir = 0,
        ShakeStrenRatio = 0.0,
        HavePauseFrame = false,
        IsCanBreak = true,
        PFFrame = 3,
        PFTimeScale = 1.0,
        PFTimeScaleCurve = "-1",
        TargetPFTimeScaleCurve = "-1",
        PFMonsterSpeed = 1.0,
        PFMonsterSpeedCurve = "-1",
        PFSceneSpeed = 1.0,
        PFSceneSpeedCurve = "-1",
        PFTime = 0.099,
        UsePostProcess = true,
        PostProcessParamsList = {
          {

            Strength = 0.2,
            Dir = 0,
            Radius = 0.35,
            Alpha = 0.7,
            AlphaCurveId = 1301,
            Direction = 0,
            Count = 3,
            Center = { 0.5, 0.5 },
            ShowTemplateID = false,
            TemplateID = 0,
            PostProcessType = 2,
            Duration = 3,
            ID = 0
          }
        },
      },
      Move = {
        pivot = 0.0,
        canGlide = false,
        GlideCost = 0.0,
        GlideHeight = 0.0,
        GlideRotationSpeed = 0.0,
        GlideDownSpeed = 0.0,
        GlideMoveSpeed = 0.0,
        GlideTurnSpeed = 0.0,
        GlideTurnBackSpeed = 0.0,
        MoveType = 3,
        LineraSpeedType = 1,
        Speed = 0.0,
        SpeedCurveId = 0,
        EarlyWarningFrame = 0,
        SignId = 0,
        WarningDurationFrame = 0,
        RotateSpeedCurveId = 0,
        AlwaysUpdateTargetPos = false,
        RotationLockInterval = 0.0,
        RotationLockDelay = 0,
        BindOffsetX = 0.0,
        BindOffsetY = 0.0,
        BindOffsetZ = 0.0,
        BindRotation = false,

      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 9200321201 ] = {
    EntityId = 9200321201,
    EntityName = "9200321201",
    Components = {
      Transform = {
        Prefab = "Character/Role/Entity1003/Model/Entity1004.prefab",
        isClone = false,
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
      TimeoutDeath = {
        Frame = 2,
        RemoveDelayFrame = 0,
      },
      Camp = {
        Camp = 2
      },
      Tag = {
        Tag = 2,
        NpcTag = 0,
        SceneObjectTag = 0,
        PartTag = 1
      },
      Attack = {
        AttackType = 0,
        MaxAttackTimes = -1,
        DelayFrame = 0,
        DurationFrame = 4,
        ShapeType = 2,
        Radius = 11000.0,
        circleStartRadius = 0.5,
        circleRadius = 0.5,
        SpreadSpeed = 0.0,
        SpreadFrame = 0,
        Lenght = 3.0,
        Height = 3.0,
        Width = 3.5,
        OffsetX = 0.0,
        OffsetY = 0.0,
        OffsetZ = 1.0,
        Repetition = false,
        IntervalFrame = 0,
        RemoveAfterHit = true,
        CanHitGround = false,
        RemoveAfterReach = false,
        ReachRange = 0.0,
        ReboundFrame = 0,
        IntervalTime = 0.0,
        ReboundTag = 1,
        ReboundEntityId = 0,
        DodgeInvalidType = 1,
        NotCheckDodge = false,
        NotJumpDodge = false,
        NotJumpBeatBack = false,
        MagicsByTarget = {
          20120001,
          92003005
        },
        HitTypeConfigList = {
          {
            HitType = 4,
            BreakLieDown = false
          }
        },
        SwtichLieAnimTime = 0.0,
        LookatType = 3,
        HitParams = {
          SpeedZ = 4.5,
          SpeedZAcceleration = 3.0,
          SpeedZTime = 0.3,
          SpeedY = 0.0,
          SpeedZHitFly = 0.0,
          SpeedYAcceleration = 0.0,
          SpeedYAccelerationTime = 0.0,
          SpeedYAloft = 5.0,
          SpeedZAloft = 2.0,

        },        UseCameraShake = false,
        CameraShake = {
          {
            ShakeType = 2,
            Random = 0.0,
            StartOffset = 0.0,
            StartAmplitude = 0.15,
            StartFrequency = 15.0,
            TargetAmplitude = 0.3,
            TargetFrequency = 10.0,
            AmplitudeChangeTime = 0.15,
            FrequencyChangeTime = 0.0,
            DurationTime = 0.15,
            Sign = 9200304.0,
            DistanceDampingId = 0.0
          }
        },
        ShakeId = 0,
        CalcNearShakeBone = true,
        BoneEffectPos = { 0.0, 0.0, 0.0 },
        ShakeDir = 0,
        ShakeStrenRatio = 0.0,
        HavePauseFrame = false,
        IsCanBreak = true,
        PFFrame = 3,
        PFTimeScale = 1.0,
        PFTimeScaleCurve = "-1",
        TargetPFTimeScaleCurve = "-1",
        PFMonsterSpeed = 1.0,
        PFMonsterSpeedCurve = "-1",
        PFSceneSpeed = 1.0,
        PFSceneSpeedCurve = "-1",
        PFTime = 0.099,
        UsePostProcess = true,
        PostProcessParamsList = {
          {

            Strength = 0.2,
            Dir = 0,
            Radius = 0.35,
            Alpha = 0.7,
            AlphaCurveId = 1301,
            Direction = 0,
            Count = 3,
            Center = { 0.5, 0.5 },
            ShowTemplateID = false,
            TemplateID = 0,
            PostProcessType = 2,
            Duration = 3,
            ID = 0
          }
        },
      },
      Move = {
        pivot = 0.0,
        canGlide = false,
        GlideCost = 0.0,
        GlideHeight = 0.0,
        GlideRotationSpeed = 0.0,
        GlideDownSpeed = 0.0,
        GlideMoveSpeed = 0.0,
        GlideTurnSpeed = 0.0,
        GlideTurnBackSpeed = 0.0,
        MoveType = 3,
        LineraSpeedType = 1,
        Speed = 0.0,
        SpeedCurveId = 0,
        EarlyWarningFrame = 0,
        SignId = 0,
        WarningDurationFrame = 0,
        RotateSpeedCurveId = 0,
        AlwaysUpdateTargetPos = false,
        RotationLockInterval = 0.0,
        RotationLockDelay = 0,
        BindOffsetX = 0.0,
        BindOffsetY = 0.0,
        BindOffsetZ = 0.0,
        BindRotation = false,

      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 9200321501 ] = {
    EntityId = 9200321501,
    EntityName = "9200321501",
    Components = {
      Transform = {
        Prefab = "Character/Role/Entity1003/Model/Entity1004.prefab",
        isClone = false,
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
      TimeoutDeath = {
        Frame = 3,
        RemoveDelayFrame = 0,
      },
      Camp = {
        Camp = 2
      },
      Tag = {
        Tag = 2,
        NpcTag = 0,
        SceneObjectTag = 0,
        PartTag = 1
      },
      Attack = {
        AttackType = 3,
        MaxAttackTimes = -1,
        DelayFrame = 0,
        DurationFrame = 4,
        ShapeType = 2,
        Radius = 11000.0,
        circleStartRadius = 0.5,
        circleRadius = 0.5,
        SpreadSpeed = 0.0,
        SpreadFrame = 0,
        Lenght = 4.0,
        Height = 3.0,
        Width = 4.0,
        OffsetX = 0.0,
        OffsetY = 1.5,
        OffsetZ = 2.0,
        Repetition = false,
        IntervalFrame = 0,
        RemoveAfterHit = true,
        CanHitGround = false,
        RemoveAfterReach = false,
        ReachRange = 0.0,
        ReboundFrame = 0,
        IntervalTime = 0.0,
        ReboundTag = 1,
        ReboundEntityId = 0,
        DodgeInvalidType = 1,
        NotCheckDodge = false,
        NotJumpDodge = false,
        NotJumpBeatBack = false,
        MagicsByTarget = {
          20150001
        },
        HitTypeConfigList = {
          {
            HitType = 7,
            BreakLieDown = true
          }
        },
        SwtichLieAnimTime = 0.0,
        LookatType = 3,
        HitParams = {
          SpeedZ = 0.0,
          SpeedZAcceleration = 0.0,
          SpeedZTime = 0.0,
          SpeedY = 15.0,
          SpeedZHitFly = 3.5,
          SpeedYAcceleration = -35.0,
          SpeedYAccelerationTime = 0.3,
          SpeedYAloft = 10.0,
          SpeedZAloft = 10.0,

        },        UseCameraShake = true,
        ShakeId = 0,
        CalcNearShakeBone = true,
        BoneEffectPos = { 0.0, 0.0, 0.0 },
        ShakeDir = 0,
        ShakeStrenRatio = 0.0,
        HavePauseFrame = false,
        IsCanBreak = true,
        PFFrame = 3,
        PFTimeScale = 1.0,
        PFTimeScaleCurve = "-1",
        TargetPFTimeScaleCurve = "-1",
        PFMonsterSpeed = 1.0,
        PFMonsterSpeedCurve = "-1",
        PFSceneSpeed = 1.0,
        PFSceneSpeedCurve = "-1",
        PFTime = 0.099,
        UsePostProcess = false,
      },
      Move = {
        pivot = 0.0,
        canGlide = false,
        GlideCost = 0.0,
        GlideHeight = 0.0,
        GlideRotationSpeed = 0.0,
        GlideDownSpeed = 0.0,
        GlideMoveSpeed = 0.0,
        GlideTurnSpeed = 0.0,
        GlideTurnBackSpeed = 0.0,
        MoveType = 3,
        LineraSpeedType = 1,
        Speed = 0.0,
        SpeedCurveId = 0,
        EarlyWarningFrame = 0,
        SignId = 0,
        WarningDurationFrame = 0,
        RotateSpeedCurveId = 0,
        AlwaysUpdateTargetPos = false,
        RotationLockInterval = 0.0,
        RotationLockDelay = 0,
        BindOffsetX = 0.0,
        BindOffsetY = 0.0,
        BindOffsetZ = 0.0,
        BindRotation = false,

      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 92003999 ] = {
    EntityId = 92003999,
    EntityName = "92003999",
    Components = {
      Effect = {
        IsBind = true,
        BindTransformName = "HitCase",
        BindOffset = { 0.0, 0.0, 0.0 },
        ScaleOffset = { 0.0, 0.0, 0.0 },
        HitEffectBornType = 1,
        HitEffectOffsetY = 0.0,
        IsHeightLimit = false
      },
      Transform = {
        Prefab = "Character/Monster/Shentu/ShentuMb1Low/Effect/FxShentuLeftHit.prefab",
        isClone = false,
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
      TimeoutDeath = {
        Frame = 73,
        RemoveDelayFrame = 0,
      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 92003998 ] = {
    EntityId = 92003998,
    EntityName = "92003998",
    Components = {
      Effect = {
        IsBind = true,
        BindTransformName = "HitCase",
        BindOffset = { 0.0, 0.0, 0.0 },
        ScaleOffset = { 0.0, 0.0, 0.0 },
        HitEffectBornType = 1,
        HitEffectOffsetY = 0.0,
        IsHeightLimit = false
      },
      Transform = {
        Prefab = "Character/Monster/Shentu/ShentuMb1Low/Effect/FxShentuRightHit.prefab",
        isClone = false,
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
      TimeoutDeath = {
        Frame = 73,
        RemoveDelayFrame = 0,
      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 92003997 ] = {
    EntityId = 92003997,
    EntityName = "92003997",
    Components = {
      Effect = {
        IsBind = true,
        BindTransformName = "HitCase",
        BindOffset = { 0.0, 0.0, 0.0 },
        ScaleOffset = { 0.0, 0.0, 0.0 },
        HitEffectBornType = 1,
        HitEffectOffsetY = 0.0,
        IsHeightLimit = false
      },
      Transform = {
        Prefab = "Character/Monster/Shentu/ShentuMb1Low/Effect/FxShentuFrontHit.prefab",
        isClone = false,
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
      TimeoutDeath = {
        Frame = 73,
        RemoveDelayFrame = 0,
      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 92003213002 ] = {
    EntityId = 92003213002,
    EntityName = "92003213002",
    Components = {
      Effect = {
        IsBind = true,
        BindTransformName = "",
        BindOffset = { 0.0, 0.0, 0.0 },
        ScaleOffset = { 0.0, 0.0, 0.0 },
        HitEffectBornType = 1,
        HitEffectOffsetY = 0.0,
        IsHeightLimit = false
      },
      Transform = {
        Prefab = "Character/Monster/Shentu/ShentuMb1Low/Effect/FxShentuMb1Atk213daoguang2.prefab",
        isClone = false,
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
      TimeoutDeath = {
        Frame = 55,
        RemoveDelayFrame = 0,
      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 92003212001 ] = {
    EntityId = 92003212001,
    EntityName = "92003212001",
    Components = {
      Effect = {
        IsBind = true,
        BindTransformName = "",
        BindOffset = { 0.0, 0.0, 0.0 },
        ScaleOffset = { 0.0, 0.0, 0.0 },
        HitEffectBornType = 1,
        HitEffectOffsetY = 0.0,
        IsHeightLimit = false
      },
      Transform = {
        Prefab = "Character/Monster/Shentu/ShentuMb1Low/Effect/FxShentuMb1Atk012.prefab",
        isClone = false,
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
      TimeoutDeath = {
        Frame = 55,
        RemoveDelayFrame = 0,
      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 92003213001 ] = {
    EntityId = 92003213001,
    EntityName = "92003213001",
    Components = {
      Effect = {
        IsBind = true,
        BindTransformName = "",
        BindOffset = { 0.0, 0.0, 0.0 },
        ScaleOffset = { 0.0, 0.0, 0.0 },
        HitEffectBornType = 1,
        HitEffectOffsetY = 0.0,
        IsHeightLimit = false
      },
      Transform = {
        Prefab = "Character/Monster/Shentu/ShentuMb1Low/Effect/FxShentuMb1Atk213daoguang1.prefab",
        isClone = false,
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
      TimeoutDeath = {
        Frame = 55,
        RemoveDelayFrame = 0,
      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 92003005001 ] = {
    EntityId = 92003005001,
    EntityName = "92003005001",
    Components = {
      Effect = {
        IsBind = true,
        BindTransformName = "",
        BindOffset = { 0.0, 0.0, 0.0 },
        ScaleOffset = { 0.0, 0.0, 0.0 },
        HitEffectBornType = 1,
        HitEffectOffsetY = 0.0,
        IsHeightLimit = false
      },
      Transform = {
        Prefab = "Character/Monster/Shentu/ShentuMb1Low/Effect/FxShentuMb1Atk005.prefab",
        isClone = false,
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
      TimeoutDeath = {
        Frame = 55,
        RemoveDelayFrame = 0,
      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 92003005002 ] = {
    EntityId = 92003005002,
    EntityName = "92003005002",
    Components = {
      Effect = {
        IsBind = false,
        BindOffset = { -0.35, -0.4, 0.4 },
        ScaleOffset = { 0.0, 0.0, 0.0 },
        HitEffectBornType = 1,
        HitEffectOffsetY = 0.0,
        IsHeightLimit = false
      },
      Transform = {
        Prefab = "Character/Monster/Shentu/ShentuMb1Low/Effect/FxShentuMb1Atk005Dilie.prefab",
        isClone = false,
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
      TimeoutDeath = {
        Frame = 121,
        RemoveDelayFrame = 0,
      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 9200300601 ] = {
    EntityId = 9200300601,
    EntityName = "9200300601",
    Components = {
      Transform = {
        Prefab = "Character/Role/Entity1003/Model/Entity1004.prefab",
        isClone = false,
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
      TimeoutDeath = {
        Frame = 3,
        RemoveDelayFrame = 0,
      },
      Camp = {
        Camp = 2
      },
      Tag = {
        Tag = 2,
        NpcTag = 0,
        SceneObjectTag = 0,
        PartTag = 1
      },
      Attack = {
        AttackType = 0,
        MaxAttackTimes = -1,
        DelayFrame = 0,
        DurationFrame = 4,
        ShapeType = 2,
        Radius = 11000.0,
        circleStartRadius = 0.5,
        circleRadius = 0.5,
        SpreadSpeed = 0.0,
        SpreadFrame = 0,
        Lenght = 4.0,
        Height = 3.0,
        Width = 3.0,
        OffsetX = 0.0,
        OffsetY = 1.5,
        OffsetZ = 1.5,
        Repetition = false,
        IntervalFrame = 0,
        RemoveAfterHit = true,
        CanHitGround = false,
        RemoveAfterReach = false,
        ReachRange = 0.0,
        ReboundFrame = 0,
        IntervalTime = 0.0,
        ReboundTag = 1,
        ReboundEntityId = 0,
        DodgeInvalidType = 1,
        NotCheckDodge = false,
        NotJumpDodge = true,
        NotJumpBeatBack = true,
        MagicsBySelfBeforeHit = {
          30000012,
          10000005
        },
        MagicsByTarget = {
          10060001,
          20000004
        },
        CreateHitEntities = {
          {
            EntityId = 92003997,
            LookRX = false,
            LookRY = true,
            LookRZ = false,
            LookatType = 3
          }
        },
        HitTypeConfigList = {
          {
            HitType = 7,
            BreakLieDown = true
          }
        },
        SwtichLieAnimTime = 0.0,
        LookatType = 3,
        HitParams = {
          SpeedZ = 4.0,
          SpeedZAcceleration = -1.0,
          SpeedZTime = 0.2,
          SpeedY = 18.0,
          SpeedZHitFly = 8.0,
          SpeedYAcceleration = -12.0,
          SpeedYAccelerationTime = 0.3,
          SpeedYAloft = 18.0,
          SpeedZAloft = 8.0,

        },        UseCameraShake = true,
        ShakeId = 0,
        CalcNearShakeBone = true,
        BoneEffectPos = { 0.0, 0.0, 0.0 },
        ShakeDir = 0,
        ShakeStrenRatio = 0.0,
        HavePauseFrame = false,
        IsCanBreak = true,
        PFFrame = 4,
        PFTimeScale = 0.0,
        PFTimeScaleCurve = "-1",
        TargetPFTimeScaleCurve = "-1",
        PFMonsterSpeed = 1.0,
        PFMonsterSpeedCurve = "-1",
        PFSceneSpeed = 1.0,
        PFSceneSpeedCurve = "-1",
        PFTime = 0.132,
        UsePostProcess = true,
        PostProcessParamsList = {
          {

            Strength = 0.2,
            Dir = 0,
            Radius = 0.35,
            Alpha = 1.0,
            AlphaCurveId = 1301,
            Direction = 0,
            Count = 3,
            Center = { 0.5, 0.5 },
            ShowTemplateID = false,
            TemplateID = 0,
            PostProcessType = 2,
            Duration = 4,
            ID = 30
          }
        },
      },
      Move = {
        pivot = 0.0,
        canGlide = false,
        GlideCost = 0.0,
        GlideHeight = 0.0,
        GlideRotationSpeed = 0.0,
        GlideDownSpeed = 0.0,
        GlideMoveSpeed = 0.0,
        GlideTurnSpeed = 0.0,
        GlideTurnBackSpeed = 0.0,
        MoveType = 3,
        LineraSpeedType = 1,
        Speed = 0.0,
        SpeedCurveId = 0,
        EarlyWarningFrame = 0,
        SignId = 0,
        WarningDurationFrame = 0,
        RotateSpeedCurveId = 0,
        AlwaysUpdateTargetPos = false,
        RotationLockInterval = 0.0,
        RotationLockDelay = 0,
        BindOffsetX = 0.0,
        BindOffsetY = 0.0,
        BindOffsetZ = 0.0,
        BindRotation = false,

      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 9200300701 ] = {
    EntityId = 9200300701,
    EntityName = "9200300701",
    Components = {
      Transform = {
        Prefab = "Character/Role/Entity1003/Model/Entity1004.prefab",
        isClone = false,
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
      TimeoutDeath = {
        Frame = 3,
        RemoveDelayFrame = 0,
      },
      Camp = {
        Camp = 2
      },
      Tag = {
        Tag = 2,
        NpcTag = 0,
        SceneObjectTag = 0,
        PartTag = 1
      },
      Attack = {
        AttackType = 0,
        MaxAttackTimes = -1,
        DelayFrame = 0,
        DurationFrame = 4,
        ShapeType = 2,
        Radius = 11000.0,
        circleStartRadius = 0.5,
        circleRadius = 0.5,
        SpreadSpeed = 0.0,
        SpreadFrame = 0,
        Lenght = 4.0,
        Height = 3.0,
        Width = 3.0,
        OffsetX = 0.0,
        OffsetY = 1.5,
        OffsetZ = 1.5,
        Repetition = false,
        IntervalFrame = 0,
        RemoveAfterHit = true,
        CanHitGround = false,
        RemoveAfterReach = false,
        ReachRange = 0.0,
        ReboundFrame = 0,
        IntervalTime = 0.0,
        ReboundTag = 1,
        ReboundEntityId = 0,
        DodgeInvalidType = 1,
        NotCheckDodge = false,
        NotJumpDodge = true,
        NotJumpBeatBack = true,
        MagicsBySelfBeforeHit = {
          10000002,
          30000006
        },
        MagicsByTarget = {
          92003007,
          10070001,
          20000002
        },
        CreateHitEntities = {
          {
            EntityId = 92003999,
            LookRX = false,
            LookRY = true,
            LookRZ = false,
            LookatType = 3
          }
        },
        HitTypeConfigList = {
          {
            HitType = 3,
            BreakLieDown = true
          }
        },
        SwtichLieAnimTime = 0.0,
        LookatType = 3,
        HitParams = {
          SpeedZ = 15.0,
          SpeedZAcceleration = -10.0,
          SpeedZTime = 0.4,
          SpeedY = 15.0,
          SpeedZHitFly = 3.5,
          SpeedYAcceleration = -35.0,
          SpeedYAccelerationTime = 0.3,
          SpeedYAloft = 10.0,
          SpeedZAloft = 10.0,

        },        UseCameraShake = true,
        ShakeId = 0,
        CalcNearShakeBone = true,
        BoneEffectPos = { 0.0, 0.0, 0.0 },
        ShakeDir = 0,
        ShakeStrenRatio = 0.0,
        HavePauseFrame = false,
        IsCanBreak = true,
        PFFrame = 3,
        PFTimeScale = 1.0,
        PFTimeScaleCurve = "-1",
        TargetPFTimeScaleCurve = "-1",
        PFMonsterSpeed = 1.0,
        PFMonsterSpeedCurve = "-1",
        PFSceneSpeed = 1.0,
        PFSceneSpeedCurve = "-1",
        PFTime = 0.099,
        UsePostProcess = false,
      },
      Move = {
        pivot = 0.0,
        canGlide = false,
        GlideCost = 0.0,
        GlideHeight = 0.0,
        GlideRotationSpeed = 0.0,
        GlideDownSpeed = 0.0,
        GlideMoveSpeed = 0.0,
        GlideTurnSpeed = 0.0,
        GlideTurnBackSpeed = 0.0,
        MoveType = 3,
        LineraSpeedType = 1,
        Speed = 0.0,
        SpeedCurveId = 0,
        EarlyWarningFrame = 0,
        SignId = 0,
        WarningDurationFrame = 0,
        RotateSpeedCurveId = 0,
        AlwaysUpdateTargetPos = false,
        RotationLockInterval = 0.0,
        RotationLockDelay = 0,
        BindOffsetX = 0.0,
        BindOffsetY = 0.0,
        BindOffsetZ = 0.0,
        BindRotation = false,

      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 9200300801 ] = {
    EntityId = 9200300801,
    EntityName = "9200300801",
    Components = {
      Transform = {
        Prefab = "Character/Role/Entity1003/Model/Entity1004.prefab",
        isClone = false,
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
      TimeoutDeath = {
        Frame = 3,
        RemoveDelayFrame = 0,
      },
      Camp = {
        Camp = 2
      },
      Tag = {
        Tag = 2,
        NpcTag = 0,
        SceneObjectTag = 0,
        PartTag = 1
      },
      Attack = {
        AttackType = 0,
        MaxAttackTimes = -1,
        DelayFrame = 0,
        DurationFrame = 4,
        ShapeType = 2,
        Radius = 11000.0,
        circleStartRadius = 0.5,
        circleRadius = 0.5,
        SpreadSpeed = 0.0,
        SpreadFrame = 0,
        Lenght = 4.0,
        Height = 3.0,
        Width = 3.0,
        OffsetX = 0.0,
        OffsetY = 1.5,
        OffsetZ = 1.5,
        Repetition = false,
        IntervalFrame = 0,
        RemoveAfterHit = true,
        CanHitGround = false,
        RemoveAfterReach = false,
        ReachRange = 0.0,
        ReboundFrame = 0,
        IntervalTime = 0.0,
        ReboundTag = 1,
        ReboundEntityId = 0,
        DodgeInvalidType = 1,
        NotCheckDodge = false,
        NotJumpDodge = true,
        NotJumpBeatBack = true,
        MagicsBySelf = {
          30000012,
          10000005
        },
        MagicsByTarget = {
          10080001,
          20000004
        },
        CreateHitEntities = {
          {
            EntityId = 92003998,
            LookRX = false,
            LookRY = true,
            LookRZ = false,
            LookatType = 3
          }
        },
        HitTypeConfigList = {
          {
            HitType = 4,
            BreakLieDown = false
          }
        },
        SwtichLieAnimTime = 0.0,
        LookatType = 3,
        HitParams = {
          SpeedZ = 5.0,
          SpeedZAcceleration = -1.0,
          SpeedZTime = 0.3,
          SpeedY = 0.0,
          SpeedZHitFly = 0.0,
          SpeedYAcceleration = 0.0,
          SpeedYAccelerationTime = 0.0,
          SpeedYAloft = 5.0,
          SpeedZAloft = 2.0,

        },        UseCameraShake = false,
        CameraShake = {
          {
            ShakeType = 2,
            Random = 0.0,
            StartOffset = 0.0,
            StartAmplitude = 0.15,
            StartFrequency = 15.0,
            TargetAmplitude = 0.3,
            TargetFrequency = 10.0,
            AmplitudeChangeTime = 0.15,
            FrequencyChangeTime = 0.0,
            DurationTime = 0.15,
            Sign = 9200304.0,
            DistanceDampingId = 0.0
          }
        },
        ShakeId = 0,
        CalcNearShakeBone = true,
        BoneEffectPos = { 0.0, 0.0, 0.0 },
        ShakeDir = 0,
        ShakeStrenRatio = 0.0,
        HavePauseFrame = false,
        IsCanBreak = true,
        PFFrame = 3,
        PFTimeScale = 1.0,
        PFTimeScaleCurve = "-1",
        TargetPFTimeScaleCurve = "-1",
        PFMonsterSpeed = 1.0,
        PFMonsterSpeedCurve = "-1",
        PFSceneSpeed = 1.0,
        PFSceneSpeedCurve = "-1",
        PFTime = 0.099,
        UsePostProcess = true,
        PostProcessParamsList = {
          {

            Strength = 0.2,
            Dir = 0,
            Radius = 0.35,
            Alpha = 0.7,
            AlphaCurveId = 1301,
            Direction = 0,
            Count = 3,
            Center = { 0.5, 0.5 },
            ShowTemplateID = false,
            TemplateID = 0,
            PostProcessType = 2,
            Duration = 3,
            ID = 0
          }
        },
      },
      Move = {
        pivot = 0.0,
        canGlide = false,
        GlideCost = 0.0,
        GlideHeight = 0.0,
        GlideRotationSpeed = 0.0,
        GlideDownSpeed = 0.0,
        GlideMoveSpeed = 0.0,
        GlideTurnSpeed = 0.0,
        GlideTurnBackSpeed = 0.0,
        MoveType = 3,
        LineraSpeedType = 1,
        Speed = 0.0,
        SpeedCurveId = 0,
        EarlyWarningFrame = 0,
        SignId = 0,
        WarningDurationFrame = 0,
        RotateSpeedCurveId = 0,
        AlwaysUpdateTargetPos = false,
        RotationLockInterval = 0.0,
        RotationLockDelay = 0,
        BindOffsetX = 0.0,
        BindOffsetY = 0.0,
        BindOffsetZ = 0.0,
        BindRotation = false,

      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 9200300802 ] = {
    EntityId = 9200300802,
    EntityName = "9200300802",
    Components = {
      Transform = {
        Prefab = "Character/Role/Entity1003/Model/Entity1004.prefab",
        isClone = false,
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
      TimeoutDeath = {
        Frame = 3,
        RemoveDelayFrame = 0,
      },
      Camp = {
        Camp = 2
      },
      Tag = {
        Tag = 2,
        NpcTag = 0,
        SceneObjectTag = 0,
        PartTag = 1
      },
      Attack = {
        AttackType = 0,
        MaxAttackTimes = -1,
        DelayFrame = 0,
        DurationFrame = 4,
        ShapeType = 2,
        Radius = 11000.0,
        circleStartRadius = 0.5,
        circleRadius = 0.5,
        SpreadSpeed = 0.0,
        SpreadFrame = 0,
        Lenght = 3.0,
        Height = 4.0,
        Width = 3.5,
        OffsetX = 0.0,
        OffsetY = 2.0,
        OffsetZ = 1.5,
        Repetition = false,
        IntervalFrame = 0,
        RemoveAfterHit = true,
        CanHitGround = false,
        RemoveAfterReach = false,
        ReachRange = 0.0,
        ReboundFrame = 0,
        IntervalTime = 0.0,
        ReboundTag = 1,
        ReboundEntityId = 0,
        DodgeInvalidType = 1,
        NotCheckDodge = false,
        NotJumpDodge = true,
        NotJumpBeatBack = true,
        MagicsBySelf = {
          30000012,
          10000005
        },
        MagicsByTarget = {
          10080002,
          20000004
        },
        CreateHitEntities = {
          {
            EntityId = 92003997,
            LookRX = false,
            LookRY = true,
            LookRZ = false,
            LookatType = 3
          }
        },
        HitTypeConfigList = {
          {
            HitType = 7,
            BreakLieDown = true
          }
        },
        SwtichLieAnimTime = 0.0,
        LookatType = 3,
        HitParams = {
          SpeedZ = 5.0,
          SpeedZAcceleration = -1.0,
          SpeedZTime = 0.2,
          SpeedY = 18.0,
          SpeedZHitFly = 8.0,
          SpeedYAcceleration = -12.0,
          SpeedYAccelerationTime = 0.3,
          SpeedYAloft = 18.0,
          SpeedZAloft = 8.0,

        },        UseCameraShake = true,
        ShakeId = 0,
        CalcNearShakeBone = true,
        BoneEffectPos = { 0.0, 0.0, 0.0 },
        ShakeDir = 0,
        ShakeStrenRatio = 0.0,
        HavePauseFrame = true,
        IsCanBreak = true,
        PFFrame = 4,
        PFTimeScale = 0.0,
        PFTimeScaleCurve = "-1",
        TargetPFTimeScaleCurve = "-1",
        PFMonsterSpeed = 1.0,
        PFMonsterSpeedCurve = "-1",
        PFSceneSpeed = 1.0,
        PFSceneSpeedCurve = "-1",
        PFTime = 0.132,
        UsePostProcess = true,
        PostProcessParamsList = {
          {

            Strength = 0.2,
            Dir = 0,
            Radius = 0.35,
            Alpha = 1.0,
            AlphaCurveId = 1301,
            Direction = 0,
            Count = 3,
            Center = { 0.5, 0.5 },
            ShowTemplateID = false,
            TemplateID = 0,
            PostProcessType = 2,
            Duration = 3,
            ID = 0
          }
        },
      },
      Move = {
        pivot = 0.0,
        canGlide = false,
        GlideCost = 0.0,
        GlideHeight = 0.0,
        GlideRotationSpeed = 0.0,
        GlideDownSpeed = 0.0,
        GlideMoveSpeed = 0.0,
        GlideTurnSpeed = 0.0,
        GlideTurnBackSpeed = 0.0,
        MoveType = 3,
        LineraSpeedType = 1,
        Speed = 0.0,
        SpeedCurveId = 0,
        EarlyWarningFrame = 0,
        SignId = 0,
        WarningDurationFrame = 0,
        RotateSpeedCurveId = 0,
        AlwaysUpdateTargetPos = false,
        RotationLockInterval = 0.0,
        RotationLockDelay = 0,
        BindOffsetX = 0.0,
        BindOffsetY = 0.0,
        BindOffsetZ = 0.0,
        BindRotation = false,

      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 92003015001 ] = {
    EntityId = 92003015001,
    EntityName = "92003015001",
    Components = {
      Effect = {
        IsBind = true,
        BindTransformName = "",
        BindOffset = { 0.0, 0.0, 0.0 },
        ScaleOffset = { 0.0, 0.0, 0.0 },
        HitEffectBornType = 1,
        HitEffectOffsetY = 0.0,
        IsHeightLimit = false
      },
      Transform = {
        Prefab = "Character/Monster/Shentu/ShentuMb1Low/Effect/FxShentuMb1Atk015daoguang.prefab",
        isClone = false,
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
      TimeoutDeath = {
        Frame = 55,
        RemoveDelayFrame = 0,
      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 92003015002 ] = {
    EntityId = 92003015002,
    EntityName = "92003015002",
    Components = {
      Effect = {
        IsBind = false,
        BindOffset = { -0.35, -0.4, 0.4 },
        ScaleOffset = { 0.0, 0.0, 0.0 },
        HitEffectBornType = 1,
        HitEffectOffsetY = 0.0,
        IsHeightLimit = false
      },
      Transform = {
        Prefab = "Character/Monster/Shentu/ShentuMb1Low/Effect/FxShentuMb1Atk015Dilie.prefab",
        isClone = false,
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
      TimeoutDeath = {
        Frame = 121,
        RemoveDelayFrame = 0,
      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 92003015003 ] = {
    EntityId = 92003015003,
    EntityName = "92003015003",
    Components = {
      Effect = {
        IsBind = true,
        BindTransformName = "",
        BindOffset = { 0.0, 0.0, 0.0 },
        ScaleOffset = { 0.0, 0.0, 0.0 },
        HitEffectBornType = 1,
        HitEffectOffsetY = 0.0,
        IsHeightLimit = false
      },
      Transform = {
        Prefab = "Character/Monster/Shentu/ShentuMb1Low/Effect/FxShentuMb1Atk015.prefab",
        isClone = false,
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
      TimeoutDeath = {
        Frame = 55,
        RemoveDelayFrame = 0,
      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 92003215001 ] = {
    EntityId = 92003215001,
    EntityName = "92003215001",
    Components = {
      Effect = {
        IsBind = true,
        BindTransformName = "",
        BindOffset = { 0.0, 0.0, 0.0 },
        ScaleOffset = { 0.0, 0.0, 0.0 },
        HitEffectBornType = 1,
        HitEffectOffsetY = 0.0,
        IsHeightLimit = false
      },
      Transform = {
        Prefab = "Character/Monster/Shentu/ShentuMb1Low/Effect/FxShentuMb1Atk215daoguang.prefab",
        isClone = false,
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
      TimeoutDeath = {
        Frame = 55,
        RemoveDelayFrame = 0,
      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 92003215002 ] = {
    EntityId = 92003215002,
    EntityName = "92003215002",
    Components = {
      Effect = {
        IsBind = false,
        BindOffset = { -0.35, -0.4, 0.4 },
        ScaleOffset = { 0.0, 0.0, 0.0 },
        HitEffectBornType = 1,
        HitEffectOffsetY = 0.0,
        IsHeightLimit = false
      },
      Transform = {
        Prefab = "Character/Monster/Shentu/ShentuMb1Low/Effect/FxShentuMb1Atk215Dilie.prefab",
        isClone = false,
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
      TimeoutDeath = {
        Frame = 121,
        RemoveDelayFrame = 0,
      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 92003215003 ] = {
    EntityId = 92003215003,
    EntityName = "92003215003",
    Components = {
      Effect = {
        IsBind = false,
        BindOffset = { -0.35, -0.4, 0.4 },
        ScaleOffset = { 0.0, 0.0, 0.0 },
        HitEffectBornType = 1,
        HitEffectOffsetY = 0.0,
        IsHeightLimit = false
      },
      Transform = {
        Prefab = "Character/Monster/Shentu/ShentuMb1Low/Effect/FxShentuMb1Atk215Dilie2.prefab",
        isClone = false,
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
      TimeoutDeath = {
        Frame = 121,
        RemoveDelayFrame = 0,
      }
    }
  },
  [ 92003215004 ] = {
    EntityId = 92003215004,
    EntityName = "92003215004",
    Components = {
      Effect = {
        IsBind = true,
        BindTransformName = "",
        BindOffset = { 0.0, 0.0, 0.0 },
        ScaleOffset = { 0.0, 0.0, 0.0 },
        HitEffectBornType = 1,
        HitEffectOffsetY = 0.0,
        IsHeightLimit = false
      },
      Transform = {
        Prefab = "Character/Monster/Shentu/ShentuMb1Low/Effect/FxShentuMb1Atk215.prefab",
        isClone = false,
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
      TimeoutDeath = {
        Frame = 55,
        RemoveDelayFrame = 0,
      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 92003209001 ] = {
    EntityId = 92003209001,
    EntityName = "92003209001",
    Components = {
      Effect = {
        IsBind = true,
        BindTransformName = "",
        BindOffset = { 0.0, 0.0, 0.0 },
        ScaleOffset = { 0.0, 0.0, 0.0 },
        HitEffectBornType = 1,
        HitEffectOffsetY = 0.0,
        IsHeightLimit = false
      },
      Transform = {
        Prefab = "Character/Monster/Shentu/ShentuMb1Low/Effect/FxShentuMb1Atk209.prefab",
        isClone = false,
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
      TimeoutDeath = {
        Frame = 55,
        RemoveDelayFrame = 0,
      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 92003996 ] = {
    EntityId = 92003996,
    EntityName = "92003996",
    Components = {
      Effect = {
        IsBind = true,
        BindTransformName = "HitCase",
        BindOffset = { 0.0, 0.0, 0.0 },
        ScaleOffset = { 0.0, 0.0, 0.0 },
        HitEffectBornType = 1,
        HitEffectOffsetY = 0.0,
        IsHeightLimit = false
      },
      Transform = {
        Prefab = "Character/Monster/Shentu/ShentuMb1Low/Effect/FxShentuMb1Atk209Hit.prefab",
        isClone = false,
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
      TimeoutDeath = {
        Frame = 73,
        RemoveDelayFrame = 0,
      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 92003204001 ] = {
    EntityId = 92003204001,
    EntityName = "92003204001",
    Components = {
      Effect = {
        IsBind = true,
        BindTransformName = "",
        BindOffset = { 0.0, 0.0, 0.0 },
        ScaleOffset = { 0.0, 0.0, 0.0 },
        HitEffectBornType = 1,
        HitEffectOffsetY = 0.0,
        IsHeightLimit = false
      },
      Transform = {
        Prefab = "Character/Monster/Shentu/ShentuMb1Low/Effect/FxShentuMb1Atk204daoguang.prefab",
        isClone = false,
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
      TimeoutDeath = {
        Frame = 55,
        RemoveDelayFrame = 0,
      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 92003204002 ] = {
    EntityId = 92003204002,
    EntityName = "92003204002",
    Components = {
      Effect = {
        IsBind = true,
        BindTransformName = "",
        BindOffset = { 0.0, 0.0, 0.0 },
        ScaleOffset = { 0.0, 0.0, 0.0 },
        HitEffectBornType = 1,
        HitEffectOffsetY = 0.0,
        IsHeightLimit = false
      },
      Transform = {
        Prefab = "Character/Monster/Shentu/ShentuMb1Low/Effect/FxShentuMb1Atk204daoguang2.prefab",
        isClone = false,
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
      TimeoutDeath = {
        Frame = 55,
        RemoveDelayFrame = 0,
      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 92003206001 ] = {
    EntityId = 92003206001,
    EntityName = "92003206001",
    Components = {
      Effect = {
        IsBind = true,
        BindTransformName = "",
        BindOffset = { 0.0, 0.0, 0.0 },
        ScaleOffset = { 0.0, 0.0, 0.0 },
        HitEffectBornType = 1,
        HitEffectOffsetY = 0.0,
        IsHeightLimit = false
      },
      Transform = {
        Prefab = "Character/Monster/Shentu/ShentuMb1Low/Effect/FxShentuMb1Atk206daoguang.prefab",
        isClone = false,
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
      TimeoutDeath = {
        Frame = 55,
        RemoveDelayFrame = 0,
      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 92003995 ] = {
    EntityId = 92003995,
    EntityName = "92003995",
    Components = {
      Effect = {
        IsBind = true,
        BindTransformName = "HitCase",
        BindOffset = { 0.0, 0.0, 0.0 },
        ScaleOffset = { 0.0, 0.0, 0.0 },
        HitEffectBornType = 1,
        HitEffectOffsetY = 0.0,
        IsHeightLimit = false
      },
      Transform = {
        Prefab = "Character/Monster/Shentu/ShentuMb1Low/Effect/FxShentuRightHit2.prefab",
        isClone = false,
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
      TimeoutDeath = {
        Frame = 73,
        RemoveDelayFrame = 0,
      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 92003994 ] = {
    EntityId = 92003994,
    EntityName = "92003994",
    Components = {
      Effect = {
        IsBind = true,
        BindTransformName = "HitCase",
        BindOffset = { 0.0, 0.0, 0.0 },
        ScaleOffset = { 0.0, 0.0, 0.0 },
        HitEffectBornType = 1,
        HitEffectOffsetY = 0.0,
        IsHeightLimit = false
      },
      Transform = {
        Prefab = "Character/Monster/Shentu/ShentuMb1Low/Effect/FxShentuLeftHit2.prefab",
        isClone = false,
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
      TimeoutDeath = {
        Frame = 73,
        RemoveDelayFrame = 0,
      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 92003207001 ] = {
    EntityId = 92003207001,
    EntityName = "92003207001",
    Components = {
      Effect = {
        IsBind = true,
        BindTransformName = "",
        BindOffset = { 0.0, 0.0, 0.0 },
        ScaleOffset = { 0.0, 0.0, 0.0 },
        HitEffectBornType = 1,
        HitEffectOffsetY = 0.0,
        IsHeightLimit = false
      },
      Transform = {
        Prefab = "Character/Monster/Shentu/ShentuMb1Low/Effect/FxShentuMb1Atk207daoguang.prefab",
        isClone = false,
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
      TimeoutDeath = {
        Frame = 55,
        RemoveDelayFrame = 0,
      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 9200331701 ] = {
    EntityId = 9200331701,
    EntityName = "9200331701",
    Components = {
      Transform = {
        Prefab = "Character/Role/Entity1003/Model/Entity1004.prefab",
        isClone = false,
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
      TimeoutDeath = {
        Frame = 2,
        RemoveDelayFrame = 0,
      },
      Camp = {
        Camp = 2
      },
      Tag = {
        Tag = 2,
        NpcTag = 0,
        SceneObjectTag = 0,
        PartTag = 1
      },
      Attack = {
        AttackType = 0,
        MaxAttackTimes = -1,
        DelayFrame = 0,
        DurationFrame = 4,
        ShapeType = 2,
        Radius = 11000.0,
        circleStartRadius = 0.5,
        circleRadius = 0.5,
        SpreadSpeed = 0.0,
        SpreadFrame = 0,
        Lenght = 3.0,
        Height = 3.0,
        Width = 4.0,
        OffsetX = 0.0,
        OffsetY = 1.5,
        OffsetZ = 1.0,
        Repetition = false,
        IntervalFrame = 0,
        RemoveAfterHit = true,
        CanHitGround = false,
        RemoveAfterReach = false,
        ReachRange = 0.0,
        ReboundFrame = 0,
        IntervalTime = 0.0,
        ReboundTag = 1,
        ReboundEntityId = 0,
        DodgeInvalidType = 2,
        NotCheckDodge = false,
        NotJumpDodge = true,
        NotJumpBeatBack = true,
        MagicsBySelfBeforeHit = {
          10000001,
          30000011
        },
        MagicsByTarget = {
          20160001,
          92003006,
          20000003
        },
        HitTypeConfigList = {
          {
            HitType = 4,
            BreakLieDown = false
          }
        },
        SwtichLieAnimTime = 0.0,
        LookatType = 3,
        HitParams = {
          SpeedZ = 10.0,
          SpeedZAcceleration = -2.0,
          SpeedZTime = 0.3,
          SpeedY = 0.0,
          SpeedZHitFly = 0.0,
          SpeedYAcceleration = 0.0,
          SpeedYAccelerationTime = 0.0,
          SpeedYAloft = 5.0,
          SpeedZAloft = 2.0,

        },        UseCameraShake = false,
        CameraShake = {
          {
            ShakeType = 2,
            Random = 0.0,
            StartOffset = 0.0,
            StartAmplitude = 0.15,
            StartFrequency = 15.0,
            TargetAmplitude = 0.3,
            TargetFrequency = 10.0,
            AmplitudeChangeTime = 0.15,
            FrequencyChangeTime = 0.0,
            DurationTime = 0.15,
            Sign = 9200304.0,
            DistanceDampingId = 0.0
          }
        },
        ShakeId = 0,
        CalcNearShakeBone = true,
        BoneEffectPos = { 0.0, 0.0, 0.0 },
        ShakeDir = 0,
        ShakeStrenRatio = 0.0,
        HavePauseFrame = false,
        IsCanBreak = true,
        PFFrame = 3,
        PFTimeScale = 1.0,
        PFTimeScaleCurve = "-1",
        TargetPFTimeScaleCurve = "-1",
        PFMonsterSpeed = 1.0,
        PFMonsterSpeedCurve = "-1",
        PFSceneSpeed = 1.0,
        PFSceneSpeedCurve = "-1",
        PFTime = 0.099,
        UsePostProcess = true,
        PostProcessParamsList = {
          {

            Strength = 0.2,
            Dir = 0,
            Radius = 0.35,
            Alpha = 0.7,
            AlphaCurveId = 1301,
            Direction = 0,
            Count = 3,
            Center = { 0.5, 0.5 },
            ShowTemplateID = false,
            TemplateID = 0,
            PostProcessType = 2,
            Duration = 3,
            ID = 0
          }
        },
      },
      Move = {
        pivot = 0.0,
        canGlide = false,
        GlideCost = 0.0,
        GlideHeight = 0.0,
        GlideRotationSpeed = 0.0,
        GlideDownSpeed = 0.0,
        GlideMoveSpeed = 0.0,
        GlideTurnSpeed = 0.0,
        GlideTurnBackSpeed = 0.0,
        MoveType = 3,
        LineraSpeedType = 1,
        Speed = 0.0,
        SpeedCurveId = 0,
        EarlyWarningFrame = 0,
        SignId = 0,
        WarningDurationFrame = 0,
        RotateSpeedCurveId = 0,
        AlwaysUpdateTargetPos = false,
        RotationLockInterval = 0.0,
        RotationLockDelay = 0,
        BindOffsetX = 0.0,
        BindOffsetY = 0.0,
        BindOffsetZ = 0.0,
        BindRotation = false,

      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 9200331702 ] = {
    EntityId = 9200331702,
    EntityName = "9200331702",
    Components = {
      Transform = {
        Prefab = "Character/Role/Entity1003/Model/Entity1004.prefab",
        isClone = false,
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
      TimeoutDeath = {
        Frame = 3,
        RemoveDelayFrame = 0,
      },
      Camp = {
        Camp = 2
      },
      Tag = {
        Tag = 2,
        NpcTag = 0,
        SceneObjectTag = 0,
        PartTag = 1
      },
      Attack = {
        AttackType = 0,
        MaxAttackTimes = -1,
        DelayFrame = 0,
        DurationFrame = 4,
        ShapeType = 2,
        Radius = 11000.0,
        circleStartRadius = 0.5,
        circleRadius = 0.5,
        SpreadSpeed = 0.0,
        SpreadFrame = 0,
        Lenght = 3.5,
        Height = 3.0,
        Width = 5.0,
        OffsetX = 0.0,
        OffsetY = 1.5,
        OffsetZ = 2.0,
        Repetition = false,
        IntervalFrame = 0,
        RemoveAfterHit = true,
        CanHitGround = false,
        RemoveAfterReach = false,
        ReachRange = 0.0,
        ReboundFrame = 0,
        IntervalTime = 0.0,
        ReboundTag = 1,
        ReboundEntityId = 0,
        DodgeInvalidType = 2,
        NotCheckDodge = false,
        NotJumpDodge = true,
        NotJumpBeatBack = true,
        MagicsBySelfBeforeHit = {
          10000006
        },
        MagicsByTargetBeforeHit = {
          20000005
        },
        MagicsByTarget = {
          92003007,
          20160002
        },
        HitTypeConfigList = {
          {
            HitType = 3,
            BreakLieDown = true
          }
        },
        SwtichLieAnimTime = 0.0,
        LookatType = 3,
        HitParams = {
          SpeedZ = 6.0,
          SpeedZAcceleration = -2.0,
          SpeedZTime = 0.3,
          SpeedY = 15.0,
          SpeedZHitFly = 3.5,
          SpeedYAcceleration = -35.0,
          SpeedYAccelerationTime = 0.3,
          SpeedYAloft = 10.0,
          SpeedZAloft = 10.0,

        },        UseCameraShake = true,
        ShakeId = 0,
        CalcNearShakeBone = true,
        BoneEffectPos = { 0.0, 0.0, 0.0 },
        ShakeDir = 0,
        ShakeStrenRatio = 0.0,
        HavePauseFrame = false,
        IsCanBreak = true,
        PFFrame = 3,
        PFTimeScale = 1.0,
        PFTimeScaleCurve = "-1",
        TargetPFTimeScaleCurve = "-1",
        PFMonsterSpeed = 1.0,
        PFMonsterSpeedCurve = "-1",
        PFSceneSpeed = 1.0,
        PFSceneSpeedCurve = "-1",
        PFTime = 0.099,
        UsePostProcess = false,
      },
      Move = {
        pivot = 0.0,
        canGlide = false,
        GlideCost = 0.0,
        GlideHeight = 0.0,
        GlideRotationSpeed = 0.0,
        GlideDownSpeed = 0.0,
        GlideMoveSpeed = 0.0,
        GlideTurnSpeed = 0.0,
        GlideTurnBackSpeed = 0.0,
        MoveType = 3,
        LineraSpeedType = 1,
        Speed = 0.0,
        SpeedCurveId = 0,
        EarlyWarningFrame = 0,
        SignId = 0,
        WarningDurationFrame = 0,
        RotateSpeedCurveId = 0,
        AlwaysUpdateTargetPos = false,
        RotationLockInterval = 0.0,
        RotationLockDelay = 0,
        BindOffsetX = 0.0,
        BindOffsetY = 0.0,
        BindOffsetZ = 0.0,
        BindRotation = false,

      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 9200332101 ] = {
    EntityId = 9200332101,
    EntityName = "9200332101",
    Components = {
      Transform = {
        Prefab = "Character/Role/Entity1003/Model/Entity1004.prefab",
        isClone = false,
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
      TimeoutDeath = {
        Frame = 3,
        RemoveDelayFrame = 0,
      },
      Camp = {
        Camp = 2
      },
      Tag = {
        Tag = 2,
        NpcTag = 0,
        SceneObjectTag = 0,
        PartTag = 1
      },
      Attack = {
        AttackType = 0,
        MaxAttackTimes = -1,
        DelayFrame = 0,
        DurationFrame = 4,
        ShapeType = 2,
        Radius = 11000.0,
        circleStartRadius = 0.5,
        circleRadius = 0.5,
        SpreadSpeed = 0.0,
        SpreadFrame = 0,
        Lenght = 7.0,
        Height = 3.0,
        Width = 7.0,
        OffsetX = 0.0,
        OffsetY = 1.0,
        OffsetZ = 1.0,
        Repetition = false,
        IntervalFrame = 0,
        RemoveAfterHit = true,
        CanHitGround = false,
        RemoveAfterReach = false,
        ReachRange = 0.0,
        ReboundFrame = 0,
        IntervalTime = 0.0,
        ReboundTag = 1,
        ReboundEntityId = 0,
        DodgeInvalidType = 2,
        NotCheckDodge = false,
        NotJumpDodge = true,
        NotJumpBeatBack = true,
        MagicsBySelf = {
          10000007
        },
        MagicsByTargetBeforeHit = {
          20000006
        },
        MagicsByTarget = {
          92003007,
          20160003
        },
        HitTypeConfigList = {
          {
            HitType = 3,
            BreakLieDown = true
          }
        },
        SwtichLieAnimTime = 0.0,
        LookatType = 3,
        HitParams = {
          SpeedZ = 6.0,
          SpeedZAcceleration = -2.0,
          SpeedZTime = 0.3,
          SpeedY = 15.0,
          SpeedZHitFly = 3.5,
          SpeedYAcceleration = -35.0,
          SpeedYAccelerationTime = 0.3,
          SpeedYAloft = 10.0,
          SpeedZAloft = 10.0,

        },        UseCameraShake = true,
        ShakeId = 0,
        CalcNearShakeBone = true,
        BoneEffectPos = { 0.0, 0.0, 0.0 },
        ShakeDir = 0,
        ShakeStrenRatio = 0.0,
        HavePauseFrame = false,
        IsCanBreak = true,
        PFFrame = 3,
        PFTimeScale = 1.0,
        PFTimeScaleCurve = "-1",
        TargetPFTimeScaleCurve = "-1",
        PFMonsterSpeed = 1.0,
        PFMonsterSpeedCurve = "-1",
        PFSceneSpeed = 1.0,
        PFSceneSpeedCurve = "-1",
        PFTime = 0.099,
        UsePostProcess = false,
      },
      Move = {
        pivot = 0.0,
        canGlide = false,
        GlideCost = 0.0,
        GlideHeight = 0.0,
        GlideRotationSpeed = 0.0,
        GlideDownSpeed = 0.0,
        GlideMoveSpeed = 0.0,
        GlideTurnSpeed = 0.0,
        GlideTurnBackSpeed = 0.0,
        MoveType = 3,
        LineraSpeedType = 1,
        Speed = 0.0,
        SpeedCurveId = 0,
        EarlyWarningFrame = 0,
        SignId = 0,
        WarningDurationFrame = 0,
        RotateSpeedCurveId = 0,
        AlwaysUpdateTargetPos = false,
        RotationLockInterval = 0.0,
        RotationLockDelay = 0,
        BindOffsetX = 0.0,
        BindOffsetY = 0.0,
        BindOffsetZ = 0.0,
        BindRotation = false,

      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 9200332102 ] = {
    EntityId = 9200332102,
    EntityName = "9200332102",
    Components = {
      Transform = {
        Prefab = "Character/Role/Entity1003/Model/Entity1004.prefab",
        isClone = false,
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
      TimeoutDeath = {
        Frame = 3,
        RemoveDelayFrame = 0,
      },
      Camp = {
        Camp = 2
      },
      Tag = {
        Tag = 2,
        NpcTag = 0,
        SceneObjectTag = 0,
        PartTag = 1
      },
      Attack = {
        AttackType = 3,
        MaxAttackTimes = -1,
        DelayFrame = 0,
        DurationFrame = 4,
        ShapeType = 2,
        Radius = 11000.0,
        circleStartRadius = 0.5,
        circleRadius = 0.5,
        SpreadSpeed = 0.0,
        SpreadFrame = 0,
        Lenght = 6.0,
        Height = 5.0,
        Width = 6.0,
        OffsetX = 0.0,
        OffsetY = 0.0,
        OffsetZ = 1.0,
        Repetition = false,
        IntervalFrame = 0,
        RemoveAfterHit = true,
        CanHitGround = false,
        RemoveAfterReach = false,
        ReachRange = 0.0,
        ReboundFrame = 0,
        IntervalTime = 0.0,
        ReboundTag = 1,
        ReboundEntityId = 0,
        DodgeInvalidType = 0,
        NotCheckDodge = false,
        NotJumpDodge = false,
        NotJumpBeatBack = false,
        MagicsByTarget = {
          900020002,
          20160004
        },
        HitTypeConfigList = {
          {
            HitType = 7,
            BreakLieDown = true
          }
        },
        SwtichLieAnimTime = 0.0,
        LookatType = 3,
        HitParams = {
          SpeedZ = 5.0,
          SpeedZAcceleration = -1.0,
          SpeedZTime = 0.2,
          SpeedY = 23.0,
          SpeedZHitFly = 10.0,
          SpeedYAcceleration = -20.0,
          SpeedYAccelerationTime = 0.3,
          SpeedYAloft = 10.0,
          SpeedZAloft = 10.0,

        },        UseCameraShake = true,
        ShakeId = 0,
        CalcNearShakeBone = true,
        BoneEffectPos = { 0.0, 0.0, 0.0 },
        ShakeDir = 0,
        ShakeStrenRatio = 0.0,
        HavePauseFrame = false,
        IsCanBreak = true,
        PFFrame = 3,
        PFTimeScale = 1.0,
        PFTimeScaleCurve = "-1",
        TargetPFTimeScaleCurve = "-1",
        PFMonsterSpeed = 1.0,
        PFMonsterSpeedCurve = "-1",
        PFSceneSpeed = 1.0,
        PFSceneSpeedCurve = "-1",
        PFTime = 0.099,
        UsePostProcess = false,
      },
      Move = {
        pivot = 0.0,
        canGlide = false,
        GlideCost = 0.0,
        GlideHeight = 0.0,
        GlideRotationSpeed = 0.0,
        GlideDownSpeed = 0.0,
        GlideMoveSpeed = 0.0,
        GlideTurnSpeed = 0.0,
        GlideTurnBackSpeed = 0.0,
        MoveType = 3,
        LineraSpeedType = 1,
        Speed = 0.0,
        SpeedCurveId = 0,
        EarlyWarningFrame = 0,
        SignId = 0,
        WarningDurationFrame = 0,
        RotateSpeedCurveId = 0,
        AlwaysUpdateTargetPos = false,
        RotationLockInterval = 0.0,
        RotationLockDelay = 0,
        BindOffsetX = 0.0,
        BindOffsetY = 0.0,
        BindOffsetZ = 0.0,
        BindRotation = false,

      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 9200321401 ] = {
    EntityId = 9200321401,
    EntityName = "9200321401",
    Components = {
      Transform = {
        Prefab = "Character/Role/Entity1003/Model/Entity1004.prefab",
        isClone = false,
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
      TimeoutDeath = {
        Frame = 2,
        RemoveDelayFrame = 0,
      },
      Camp = {
        Camp = 2
      },
      Tag = {
        Tag = 2,
        NpcTag = 0,
        SceneObjectTag = 0,
        PartTag = 1
      },
      Attack = {
        AttackType = 0,
        MaxAttackTimes = -1,
        DelayFrame = 0,
        DurationFrame = 4,
        ShapeType = 2,
        Radius = 11000.0,
        circleStartRadius = 0.5,
        circleRadius = 0.5,
        SpreadSpeed = 0.0,
        SpreadFrame = 0,
        Lenght = 4.0,
        Height = 3.0,
        Width = 5.0,
        OffsetX = 0.0,
        OffsetY = 1.0,
        OffsetZ = 2.0,
        Repetition = false,
        IntervalFrame = 0,
        RemoveAfterHit = true,
        CanHitGround = false,
        RemoveAfterReach = false,
        ReachRange = 0.0,
        ReboundFrame = 0,
        IntervalTime = 0.0,
        ReboundTag = 1,
        ReboundEntityId = 0,
        DodgeInvalidType = 1,
        NotCheckDodge = false,
        NotJumpDodge = true,
        NotJumpBeatBack = true,
        MagicsBySelfBeforeHit = {
          10000003,
          30000001
        },
        MagicsByTargetBeforeHit = {
          20000001
        },
        MagicsByTarget = {
          20140001,
          92003006
        },
        HitTypeConfigList = {
          {
            HitType = 4,
            BreakLieDown = false
          }
        },
        SwtichLieAnimTime = 0.0,
        LookatType = 3,
        HitParams = {
          SpeedZ = 4.5,
          SpeedZAcceleration = 3.0,
          SpeedZTime = 0.3,
          SpeedY = 0.0,
          SpeedZHitFly = 0.0,
          SpeedYAcceleration = 0.0,
          SpeedYAccelerationTime = 0.0,
          SpeedYAloft = 5.0,
          SpeedZAloft = 2.0,

        },        UseCameraShake = false,
        CameraShake = {
          {
            ShakeType = 2,
            Random = 0.0,
            StartOffset = 0.0,
            StartAmplitude = 0.15,
            StartFrequency = 15.0,
            TargetAmplitude = 0.3,
            TargetFrequency = 10.0,
            AmplitudeChangeTime = 0.15,
            FrequencyChangeTime = 0.0,
            DurationTime = 0.15,
            Sign = 9200304.0,
            DistanceDampingId = 0.0
          }
        },
        ShakeId = 0,
        CalcNearShakeBone = true,
        BoneEffectPos = { 0.0, 0.0, 0.0 },
        ShakeDir = 0,
        ShakeStrenRatio = 0.0,
        HavePauseFrame = false,
        IsCanBreak = true,
        PFFrame = 3,
        PFTimeScale = 1.0,
        PFTimeScaleCurve = "-1",
        TargetPFTimeScaleCurve = "-1",
        PFMonsterSpeed = 1.0,
        PFMonsterSpeedCurve = "-1",
        PFSceneSpeed = 1.0,
        PFSceneSpeedCurve = "-1",
        PFTime = 0.099,
        UsePostProcess = true,
        PostProcessParamsList = {
          {

            Strength = 0.2,
            Dir = 0,
            Radius = 0.35,
            Alpha = 0.7,
            AlphaCurveId = 1301,
            Direction = 0,
            Count = 3,
            Center = { 0.5, 0.5 },
            ShowTemplateID = false,
            TemplateID = 0,
            PostProcessType = 2,
            Duration = 3,
            ID = 0
          }
        },
      },
      Move = {
        pivot = 0.0,
        canGlide = false,
        GlideCost = 0.0,
        GlideHeight = 0.0,
        GlideRotationSpeed = 0.0,
        GlideDownSpeed = 0.0,
        GlideMoveSpeed = 0.0,
        GlideTurnSpeed = 0.0,
        GlideTurnBackSpeed = 0.0,
        MoveType = 3,
        LineraSpeedType = 1,
        Speed = 0.0,
        SpeedCurveId = 0,
        EarlyWarningFrame = 0,
        SignId = 0,
        WarningDurationFrame = 0,
        RotateSpeedCurveId = 0,
        AlwaysUpdateTargetPos = false,
        RotationLockInterval = 0.0,
        RotationLockDelay = 0,
        BindOffsetX = 0.0,
        BindOffsetY = 0.0,
        BindOffsetZ = 0.0,
        BindRotation = false,

      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 9200321402 ] = {
    EntityId = 9200321402,
    EntityName = "9200321402",
    Components = {
      Transform = {
        Prefab = "Character/Role/Entity1003/Model/Entity1004.prefab",
        isClone = false,
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
      TimeoutDeath = {
        Frame = 2,
        RemoveDelayFrame = 0,
      },
      Camp = {
        Camp = 2
      },
      Tag = {
        Tag = 2,
        NpcTag = 0,
        SceneObjectTag = 0,
        PartTag = 1
      },
      Attack = {
        AttackType = 0,
        MaxAttackTimes = -1,
        DelayFrame = 0,
        DurationFrame = 4,
        ShapeType = 2,
        Radius = 11000.0,
        circleStartRadius = 0.5,
        circleRadius = 0.5,
        SpreadSpeed = 0.0,
        SpreadFrame = 0,
        Lenght = 4.0,
        Height = 3.0,
        Width = 5.0,
        OffsetX = 0.0,
        OffsetY = 1.0,
        OffsetZ = 2.0,
        Repetition = false,
        IntervalFrame = 0,
        RemoveAfterHit = true,
        CanHitGround = false,
        RemoveAfterReach = false,
        ReachRange = 0.0,
        ReboundFrame = 0,
        IntervalTime = 0.0,
        ReboundTag = 1,
        ReboundEntityId = 0,
        DodgeInvalidType = 1,
        NotCheckDodge = false,
        NotJumpDodge = true,
        NotJumpBeatBack = true,
        MagicsBySelfBeforeHit = {
          10000001,
          30000002
        },
        MagicsByTarget = {
          92003005,
          20000001,
          20140001
        },
        HitTypeConfigList = {
          {
            HitType = 7,
            BreakLieDown = true
          }
        },
        SwtichLieAnimTime = 0.0,
        LookatType = 3,
        HitParams = {
          SpeedZ = 6.0,
          SpeedZAcceleration = -1.0,
          SpeedZTime = 0.2,
          SpeedY = 15.0,
          SpeedZHitFly = 9.0,
          SpeedYAcceleration = -18.0,
          SpeedYAccelerationTime = 0.3,
          SpeedYAloft = 10.0,
          SpeedZAloft = 10.0,

        },        UseCameraShake = true,
        ShakeId = 0,
        CalcNearShakeBone = true,
        BoneEffectPos = { 0.0, 0.0, 0.0 },
        ShakeDir = 0,
        ShakeStrenRatio = 0.0,
        HavePauseFrame = false,
        IsCanBreak = true,
        PFFrame = 3,
        PFTimeScale = 1.0,
        PFTimeScaleCurve = "-1",
        TargetPFTimeScaleCurve = "-1",
        PFMonsterSpeed = 1.0,
        PFMonsterSpeedCurve = "-1",
        PFSceneSpeed = 1.0,
        PFSceneSpeedCurve = "-1",
        PFTime = 0.099,
        UsePostProcess = false,
      },
      Move = {
        pivot = 0.0,
        canGlide = false,
        GlideCost = 0.0,
        GlideHeight = 0.0,
        GlideRotationSpeed = 0.0,
        GlideDownSpeed = 0.0,
        GlideMoveSpeed = 0.0,
        GlideTurnSpeed = 0.0,
        GlideTurnBackSpeed = 0.0,
        MoveType = 3,
        LineraSpeedType = 1,
        Speed = 0.0,
        SpeedCurveId = 0,
        EarlyWarningFrame = 0,
        SignId = 0,
        WarningDurationFrame = 0,
        RotateSpeedCurveId = 0,
        AlwaysUpdateTargetPos = false,
        RotationLockInterval = 0.0,
        RotationLockDelay = 0,
        BindOffsetX = 0.0,
        BindOffsetY = 0.0,
        BindOffsetZ = 0.0,
        BindRotation = false,

      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 9200399905 ] = {
    EntityId = 9200399905,
    EntityName = "9200399905",
    Components = {
      Effect = {
        IsBind = true,
        BindTransformName = "ShentuMb1",
        BindOffset = { 0.0, 0.0, 0.0 },
        ScaleOffset = { 0.0, 0.0, 0.0 },
        HitEffectBornType = 1,
        HitEffectOffsetY = 0.0,
        IsHeightLimit = false
      },
      Transform = {
        Prefab = "Effect/Prefab/Fight/FxJuejihongseyujing1.prefab",
        isClone = false,
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
      TimeoutDeath = {
        Frame = 90,
        RemoveDelayFrame = 0,
      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 9200399906 ] = {
    EntityId = 9200399906,
    EntityName = "9200399906",
    Components = {
      Effect = {
        IsBind = true,
        BindTransformName = "LeftEyeCase",
        BindOffset = { 0.0, 0.0, 0.0 },
        ScaleOffset = { 0.0, 0.0, 0.0 },
        HitEffectBornType = 1,
        HitEffectOffsetY = 0.0,
        IsHeightLimit = false
      },
      Transform = {
        Prefab = "Effect/Prefab/Fight/FxWarningYellow.prefab",
        isClone = false,
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
      TimeoutDeath = {
        Frame = 50,
        RemoveDelayFrame = 0,
      }
    }
  },
  [ 9200399907 ] = {
    EntityId = 9200399907,
    EntityName = "9200399907",
    Components = {
      Effect = {
        IsBind = true,
        BindTransformName = "LeftEyeCase",
        BindOffset = { 0.0, 0.0, 0.0 },
        ScaleOffset = { 0.0, 0.0, 0.0 },
        HitEffectBornType = 1,
        HitEffectOffsetY = 0.0,
        IsHeightLimit = false
      },
      Transform = {
        Prefab = "Effect/Prefab/Fight/FxLowThreatWarningEye.prefab",
        isClone = false,
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
      TimeoutDeath = {
        Frame = 30,
        RemoveDelayFrame = 0,
      }
    }
  },
  [ 9200301901 ] = {
    EntityId = 9200301901,
    EntityName = "9200301901",
    Components = {
      Transform = {
        Prefab = "Character/Monster/Shentu/ShentuMb1Low/Effect/FxShentuMb1Atk019yujing.prefab",
        isClone = false,
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
      TimeoutDeath = {
        Frame = 30,
        RemoveDelayFrame = 0,
      },
      Move = {
        pivot = 0.0,
        canGlide = false,
        GlideCost = 0.0,
        GlideHeight = 0.0,
        GlideRotationSpeed = 0.0,
        GlideDownSpeed = 0.0,
        GlideMoveSpeed = 0.0,
        GlideTurnSpeed = 0.0,
        GlideTurnBackSpeed = 0.0,
        MoveType = 2,
        LineraSpeedType = 1,
        Speed = 0.0,
        SpeedCurveId = 0,
        EarlyWarningFrame = 0,
        SignId = 0,
        WarningDurationFrame = 0,
        RotateSpeedCurveId = 0,
        AlwaysUpdateTargetPos = false,
        RotationLockInterval = 0.0,
        RotationLockDelay = 0,
        BindRotation = false,

      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 9200301902 ] = {
    EntityId = 9200301902,
    EntityName = "9200301902",
    Components = {
      Transform = {
        Prefab = "Character/Monster/Shentu/ShentuMb1Low/Effect/FxShentuMb1Atk019luolei.prefab",
        isClone = false,
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
      TimeoutDeath = {
        Frame = 120,
        RemoveDelayFrame = 0,
      },
      Camp = {
        Camp = 2
      },
      Tag = {
        Tag = 2,
        NpcTag = 0,
        SceneObjectTag = 0,
        PartTag = 1
      },
      Attack = {
        AttackType = 2,
        MaxAttackTimes = 1,
        DelayFrame = 0,
        DurationFrame = 4,
        ShapeType = 3,
        Radius = 3.5,
        circleStartRadius = 0.5,
        circleRadius = 0.5,
        SpreadSpeed = 0.0,
        SpreadFrame = 0,
        Lenght = 3.0,
        Height = 2.0,
        Width = 3.0,
        OffsetX = 0.0,
        OffsetY = 1.0,
        OffsetZ = 0.0,
        Repetition = false,
        IntervalFrame = 0,
        RemoveAfterHit = false,
        CanHitGround = false,
        RemoveAfterReach = false,
        ReachRange = 0.0,
        ReboundFrame = 0,
        IntervalTime = 0.0,
        ReboundTag = 1,
        ReboundEntityId = 0,
        DodgeInvalidType = 2,
        NotCheckDodge = true,
        NotJumpDodge = true,
        NotJumpBeatBack = true,
        MagicsByTarget = {
          10190001
        },
        HitTypeConfigList = {
          {
            HitType = 5,
            BreakLieDown = false
          }
        },
        SwtichLieAnimTime = 0.0,
        LookatType = 3,
        HitParams = {
          SpeedZ = 2.0,
          SpeedZAcceleration = -2.0,
          SpeedZTime = 0.1,
          SpeedY = 10.0,
          SpeedZHitFly = -10.0,
          SpeedYAcceleration = 20.0,
          SpeedYAccelerationTime = 0.1,
          SpeedYAloft = 5.0,
          SpeedZAloft = 2.0,

        },        UseCameraShake = true,
        CameraShake = {
          {
            ShakeType = 2,
            Random = 0.0,
            StartOffset = 0.0,
            StartAmplitude = 0.5,
            StartFrequency = 10.0,
            TargetAmplitude = 0.35,
            TargetFrequency = 5.0,
            AmplitudeChangeTime = 0.3,
            FrequencyChangeTime = 0.3,
            DurationTime = 0.4,
            Sign = 0.0,
            DistanceDampingId = 0.0
          }
        },
        ShakeId = 0,
        CalcNearShakeBone = true,
        BoneEffectPos = { 0.0, 0.0, 0.0 },
        ShakeDir = 0,
        ShakeStrenRatio = 0.0,
        HavePauseFrame = false,
        IsCanBreak = true,
        PFTimeScaleCurve = "-1",
        TargetPFTimeScaleCurve = "-1",
        PFMonsterSpeedCurve = "-1",
        PFSceneSpeedCurve = "-1",
        UsePostProcess = false,
      },
      Move = {
        pivot = 0.0,
        canGlide = false,
        GlideCost = 0.0,
        GlideHeight = 0.0,
        GlideRotationSpeed = 0.0,
        GlideDownSpeed = 0.0,
        GlideMoveSpeed = 0.0,
        GlideTurnSpeed = 0.0,
        GlideTurnBackSpeed = 0.0,
        MoveType = 2,
        LineraSpeedType = 1,
        Speed = 0.0,
        SpeedCurveId = 0,
        EarlyWarningFrame = 0,
        SignId = 0,
        WarningDurationFrame = 0,
        RotateSpeedCurveId = 0,
        AlwaysUpdateTargetPos = false,
        RotationLockInterval = 0.0,
        RotationLockDelay = 0,
        BindRotation = false,

      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 9200302001 ] = {
    EntityId = 9200302001,
    EntityName = "9200302001",
    Components = {
      Transform = {
        Prefab = "Character/Monster/Shentu/ShentuMb1Low/Effect/FxShentuMb1Atk020dilie.prefab",
        isClone = false,
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
      TimeoutDeath = {
        Frame = 120,
        RemoveDelayFrame = 0,
      },
      Camp = {
        Camp = 2
      },
      Tag = {
        Tag = 2,
        NpcTag = 0,
        SceneObjectTag = 0,
        PartTag = 1
      },
      Attack = {
        AttackType = 2,
        MaxAttackTimes = 1,
        DelayFrame = 0,
        DurationFrame = 4,
        ShapeType = 3,
        Radius = 60.0,
        circleStartRadius = 0.5,
        circleRadius = 0.5,
        SpreadSpeed = 0.0,
        SpreadFrame = 0,
        Lenght = 3.0,
        Height = 2.0,
        Width = 3.0,
        OffsetX = 0.0,
        OffsetY = 1.0,
        OffsetZ = 0.0,
        Repetition = false,
        IntervalFrame = 0,
        RemoveAfterHit = false,
        CanHitGround = false,
        RemoveAfterReach = false,
        ReachRange = 0.0,
        ReboundFrame = 0,
        IntervalTime = 0.0,
        ReboundTag = 1,
        ReboundEntityId = 0,
        DodgeInvalidType = 0,
        NotCheckDodge = true,
        NotJumpDodge = true,
        NotJumpBeatBack = true,
        MagicsByTarget = {
          10190001,
          30000008
        },
        HitTypeConfigList = {
          {
            HitType = 5,
            BreakLieDown = false
          }
        },
        SwtichLieAnimTime = 0.0,
        LookatType = 3,
        HitParams = {
          SpeedZ = 10.0,
          SpeedZAcceleration = -2.0,
          SpeedZTime = 0.5,
          SpeedY = 10.0,
          SpeedZHitFly = -10.0,
          SpeedYAcceleration = 20.0,
          SpeedYAccelerationTime = 0.1,
          SpeedYAloft = 5.0,
          SpeedZAloft = 2.0,

        },        UseCameraShake = true,
        CameraShake = {
          {
            ShakeType = 3,
            Random = 0.0,
            StartOffset = 0.0,
            StartAmplitude = -1.2,
            StartFrequency = 5.0,
            TargetAmplitude = 0.0,
            TargetFrequency = 1.0,
            AmplitudeChangeTime = 0.297,
            FrequencyChangeTime = 0.33,
            DurationTime = 0.429,
            Sign = 0.0,
            DistanceDampingId = 0.0
          }
        },
        ShakeId = 0,
        CalcNearShakeBone = true,
        BoneEffectPos = { 0.0, 0.0, 0.0 },
        ShakeDir = 0,
        ShakeStrenRatio = 0.0,
        HavePauseFrame = false,
        IsCanBreak = true,
        PFTimeScaleCurve = "-1",
        TargetPFTimeScaleCurve = "-1",
        PFMonsterSpeedCurve = "-1",
        PFSceneSpeedCurve = "-1",
        UsePostProcess = false,
      },
      Move = {
        pivot = 0.0,
        canGlide = false,
        GlideCost = 0.0,
        GlideHeight = 0.0,
        GlideRotationSpeed = 0.0,
        GlideDownSpeed = 0.0,
        GlideMoveSpeed = 0.0,
        GlideTurnSpeed = 0.0,
        GlideTurnBackSpeed = 0.0,
        MoveType = 2,
        LineraSpeedType = 1,
        Speed = 0.0,
        SpeedCurveId = 0,
        EarlyWarningFrame = 0,
        SignId = 0,
        WarningDurationFrame = 0,
        RotateSpeedCurveId = 0,
        AlwaysUpdateTargetPos = false,
        RotationLockInterval = 0.0,
        RotationLockDelay = 0,
        BindRotation = false,

      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 92003020001 ] = {
    EntityId = 92003020001,
    EntityName = "92003020001",
    Components = {
      Effect = {
        IsBind = true,
        BindTransformName = "",
        BindOffset = { 0.0, 0.0, 0.0 },
        ScaleOffset = { 0.0, 0.0, 0.0 },
        HitEffectBornType = 1,
        HitEffectOffsetY = 0.0,
        IsHeightLimit = false
      },
      Transform = {
        Prefab = "Character/Monster/Shentu/ShentuMb1Low/Effect/FxShentuMb1Atk019huohua.prefab",
        isClone = false,
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
      TimeoutDeath = {
        Frame = 55,
        RemoveDelayFrame = 0,
      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 92003020002 ] = {
    EntityId = 92003020002,
    EntityName = "92003020002",
    Components = {
      Effect = {
        IsBind = true,
        BindTransformName = "",
        BindOffset = { 0.0, 0.0, 0.0 },
        ScaleOffset = { 0.0, 0.0, 0.0 },
        HitEffectBornType = 1,
        HitEffectOffsetY = 0.0,
        IsHeightLimit = false
      },
      Transform = {
        Prefab = "Character/Monster/Shentu/ShentuMb1Low/Effect/FxShentuMb1Atk020huohua.prefab",
        isClone = false,
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
      TimeoutDeath = {
        Frame = 55,
        RemoveDelayFrame = 0,
      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 92003019001 ] = {
    EntityId = 92003019001,
    EntityName = "92003019001",
    Components = {
      Effect = {
        IsBind = true,
        BindTransformName = "",
        BindOffset = { 0.0, 0.0, 0.0 },
        ScaleOffset = { 0.0, 0.0, 0.0 },
        HitEffectBornType = 1,
        HitEffectOffsetY = 0.0,
        IsHeightLimit = false
      },
      Transform = {
        Prefab = "Character/Monster/Shentu/ShentuMb1Low/Effect/FxShentuMb1Atk019huohua.prefab",
        isClone = false,
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
      TimeoutDeath = {
        Frame = 55,
        RemoveDelayFrame = 0,
      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 92003217001 ] = {
    EntityId = 92003217001,
    EntityName = "92003217001",
    Components = {
      Effect = {
        IsBind = true,
        BindTransformName = "",
        BindOffset = { 0.0, 0.0, 0.0 },
        ScaleOffset = { 0.0, 0.0, 0.0 },
        HitEffectBornType = 1,
        HitEffectOffsetY = 0.0,
        IsHeightLimit = false
      },
      Transform = {
        Prefab = "Character/Monster/Shentu/ShentuMb1Low/Effect/FxShentuMb1Atk217daoguang1.prefab",
        isClone = false,
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
      TimeoutDeath = {
        Frame = 55,
        RemoveDelayFrame = 0,
      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 92003217002 ] = {
    EntityId = 92003217002,
    EntityName = "92003217002",
    Components = {
      Effect = {
        IsBind = true,
        BindTransformName = "",
        BindOffset = { 0.0, 0.0, 0.0 },
        ScaleOffset = { 0.0, 0.0, 0.0 },
        HitEffectBornType = 1,
        HitEffectOffsetY = 0.0,
        IsHeightLimit = false
      },
      Transform = {
        Prefab = "Character/Monster/Shentu/ShentuMb1Low/Effect/FxShentuMb1Atk217daoguang2.prefab",
        isClone = false,
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
      TimeoutDeath = {
        Frame = 55,
        RemoveDelayFrame = 0,
      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 92003217003 ] = {
    EntityId = 92003217003,
    EntityName = "92003217003",
    Components = {
      Effect = {
        IsBind = false,
        BindOffset = { -0.35, -0.4, 0.4 },
        ScaleOffset = { 0.0, 0.0, 0.0 },
        HitEffectBornType = 1,
        HitEffectOffsetY = 0.0,
        IsHeightLimit = false
      },
      Transform = {
        Prefab = "Character/Monster/Shentu/ShentuMb1Low/Effect/FxShentuMb1Atk217dilie.prefab",
        isClone = false,
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
      TimeoutDeath = {
        Frame = 121,
        RemoveDelayFrame = 0,
      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 92003214001 ] = {
    EntityId = 92003214001,
    EntityName = "92003214001",
    Components = {
      Effect = {
        IsBind = true,
        BindTransformName = "",
        BindOffset = { 0.0, 0.0, 0.0 },
        ScaleOffset = { 0.0, 0.0, 0.0 },
        HitEffectBornType = 1,
        HitEffectOffsetY = 0.0,
        IsHeightLimit = false
      },
      Transform = {
        Prefab = "Character/Monster/Shentu/ShentuMb1Low/Effect/FxShentuMb1Atk214daoguang.prefab",
        isClone = false,
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
      TimeoutDeath = {
        Frame = 55,
        RemoveDelayFrame = 0,
      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 92003214002 ] = {
    EntityId = 92003214002,
    EntityName = "92003214002",
    Components = {
      Effect = {
        IsBind = true,
        BindTransformName = "",
        BindOffset = { 0.0, 0.0, 0.0 },
        ScaleOffset = { 0.0, 0.0, 0.0 },
        HitEffectBornType = 1,
        HitEffectOffsetY = 0.0,
        IsHeightLimit = false
      },
      Transform = {
        Prefab = "Character/Monster/Shentu/ShentuMb1Low/Effect/FxShentuMb1Atk214daoguang2.prefab",
        isClone = false,
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
      TimeoutDeath = {
        Frame = 55,
        RemoveDelayFrame = 0,
      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 92003010001 ] = {
    EntityId = 92003010001,
    EntityName = "92003010001",
    Components = {
      Effect = {
        IsBind = true,
        BindTransformName = "",
        BindOffset = { 0.0, 0.0, 0.0 },
        ScaleOffset = { 0.0, 0.0, 0.0 },
        HitEffectBornType = 1,
        HitEffectOffsetY = 0.0,
        IsHeightLimit = false
      },
      Transform = {
        Prefab = "Character/Monster/Shentu/ShentuMb1Low/Effect/FxShentuMb1Atk010daoguang.prefab",
        isClone = false,
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
      TimeoutDeath = {
        Frame = 55,
        RemoveDelayFrame = 0,
      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 92003221001 ] = {
    EntityId = 92003221001,
    EntityName = "92003221001",
    Components = {
      Effect = {
        IsBind = false,
        BindTransformName = "",
        BindOffset = { 0.0, 0.0, 0.0 },
        ScaleOffset = { 0.0, 0.0, 0.0 },
        HitEffectBornType = 1,
        HitEffectOffsetY = 0.0,
        IsHeightLimit = false
      },
      Transform = {
        Prefab = "Character/Monster/Shentu/ShentuMb1Low/Effect/FxShentuMb1Atk221dilie.prefab",
        isClone = false,
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
      TimeoutDeath = {
        Frame = 40,
        RemoveDelayFrame = 0,
      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 92003221002 ] = {
    EntityId = 92003221002,
    EntityName = "92003221002",
    Components = {
      Effect = {
        IsBind = true,
        BindTransformName = "",
        BindOffset = { 0.0, 0.0, 0.0 },
        ScaleOffset = { 0.0, 0.0, 0.0 },
        HitEffectBornType = 1,
        HitEffectOffsetY = 0.0,
        IsHeightLimit = false
      },
      Transform = {
        Prefab = "Character/Monster/Shentu/ShentuMb1Low/Effect/FxShentuMb1Atk221daoguang.prefab",
        isClone = false,
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
      TimeoutDeath = {
        Frame = 28,
        RemoveDelayFrame = 0,
      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 92003221003 ] = {
    EntityId = 92003221003,
    EntityName = "92003221003",
    Components = {
      Effect = {
        IsBind = false,
        BindTransformName = "",
        BindOffset = { 0.0, 0.0, 0.0 },
        ScaleOffset = { 0.0, 0.0, 0.0 },
        HitEffectBornType = 1,
        HitEffectOffsetY = 0.0,
        IsHeightLimit = false
      },
      Transform = {
        Prefab = "Character/Monster/Shentu/ShentuMb1Low/Effect/FxShentuMb1Atk221dilie1.prefab",
        isClone = false,
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
      TimeoutDeath = {
        Frame = 64,
        RemoveDelayFrame = 0,
      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 92003013001 ] = {
    EntityId = 92003013001,
    EntityName = "92003013001",
    Components = {
      Effect = {
        IsBind = true,
        BindTransformName = "",
        BindOffset = { 0.0, 0.0, 0.0 },
        ScaleOffset = { 0.0, 0.0, 0.0 },
        HitEffectBornType = 1,
        HitEffectOffsetY = 0.0,
        IsHeightLimit = false
      },
      Transform = {
        Prefab = "Character/Monster/Shentu/ShentuMb1Low/Effect/FxShentuMb1Atk013daoguang.prefab",
        isClone = false,
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
      TimeoutDeath = {
        Frame = 28,
        RemoveDelayFrame = 0,
      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 92003006001 ] = {
    EntityId = 92003006001,
    EntityName = "92003006001",
    Components = {
      Effect = {
        IsBind = true,
        BindTransformName = "",
        BindOffset = { 0.0, 0.0, 0.0 },
        ScaleOffset = { 0.0, 0.0, 0.0 },
        HitEffectBornType = 1,
        HitEffectOffsetY = 0.0,
        IsHeightLimit = false
      },
      Transform = {
        Prefab = "Character/Monster/Shentu/ShentuMb1Low/Effect/FxShentuMb1Atk006daoguang.prefab",
        isClone = false,
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
      TimeoutDeath = {
        Frame = 55,
        RemoveDelayFrame = 0,
      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 92003008001 ] = {
    EntityId = 92003008001,
    EntityName = "92003008001",
    Components = {
      Effect = {
        IsBind = true,
        BindTransformName = "",
        BindOffset = { 0.0, 0.0, 0.0 },
        ScaleOffset = { 0.0, 0.0, 0.0 },
        HitEffectBornType = 1,
        HitEffectOffsetY = 0.0,
        IsHeightLimit = false
      },
      Transform = {
        Prefab = "Character/Monster/Shentu/ShentuMb1Low/Effect/FxShentuMb1Atk008daoguang.prefab",
        isClone = false,
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
      TimeoutDeath = {
        Frame = 55,
        RemoveDelayFrame = 0,
      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 92003008002 ] = {
    EntityId = 92003008002,
    EntityName = "92003008002",
    Components = {
      Effect = {
        IsBind = true,
        BindTransformName = "",
        BindOffset = { 0.0, 0.0, 0.0 },
        ScaleOffset = { 0.0, 0.0, 0.0 },
        HitEffectBornType = 1,
        HitEffectOffsetY = 0.0,
        IsHeightLimit = false
      },
      Transform = {
        Prefab = "Character/Monster/Shentu/ShentuMb1Low/Effect/FxShentuMb1Atk008daoguang2.prefab",
        isClone = false,
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
      TimeoutDeath = {
        Frame = 55,
        RemoveDelayFrame = 0,
      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 92003007001 ] = {
    EntityId = 92003007001,
    EntityName = "92003007001",
    Components = {
      Effect = {
        IsBind = true,
        BindTransformName = "",
        BindOffset = { 0.0, 0.0, 0.0 },
        ScaleOffset = { 0.0, 0.0, 0.0 },
        HitEffectBornType = 1,
        HitEffectOffsetY = 0.0,
        IsHeightLimit = false
      },
      Transform = {
        Prefab = "Character/Monster/Shentu/ShentuMb1Low/Effect/FxShentuMb1Atk007daoguang.prefab",
        isClone = false,
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
      TimeoutDeath = {
        Frame = 55,
        RemoveDelayFrame = 0,
      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 9200331202 ] = {
    EntityId = 9200331202,
    EntityName = "9200331202",
    Components = {
      Transform = {
        Prefab = "Character/Role/Entity1003/Model/Entity1004.prefab",
        isClone = false,
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
      TimeoutDeath = {
        Frame = 2,
        RemoveDelayFrame = 0,
      },
      Camp = {
        Camp = 2
      },
      Tag = {
        Tag = 2,
        NpcTag = 0,
        SceneObjectTag = 0,
        PartTag = 1
      },
      Attack = {
        AttackType = 3,
        MaxAttackTimes = -1,
        DelayFrame = 0,
        DurationFrame = 4,
        ShapeType = 2,
        Radius = 11000.0,
        circleStartRadius = 0.5,
        circleRadius = 0.5,
        SpreadSpeed = 0.0,
        SpreadFrame = 0,
        Lenght = 4.0,
        Height = 3.0,
        Width = 3.5,
        OffsetX = 0.0,
        OffsetY = 1.5,
        OffsetZ = 1.0,
        Repetition = false,
        IntervalFrame = 0,
        RemoveAfterHit = true,
        CanHitGround = false,
        RemoveAfterReach = false,
        ReachRange = 0.0,
        ReboundFrame = 0,
        IntervalTime = 0.0,
        ReboundTag = 1,
        ReboundEntityId = 0,
        DodgeInvalidType = 2,
        NotCheckDodge = false,
        NotJumpDodge = false,
        NotJumpBeatBack = false,
        MagicsBySelfBeforeHit = {
          10000001,
          30000011
        },
        MagicsByTarget = {
          20160001,
          92003006,
          20000003
        },
        HitTypeConfigList = {
          {
            HitType = 4,
            BreakLieDown = false
          }
        },
        SwtichLieAnimTime = 0.0,
        LookatType = 3,
        HitParams = {
          SpeedZ = 4.5,
          SpeedZAcceleration = -1.0,
          SpeedZTime = 0.3,
          SpeedY = 0.0,
          SpeedZHitFly = 0.0,
          SpeedYAcceleration = 0.0,
          SpeedYAccelerationTime = 0.0,
          SpeedYAloft = 5.0,
          SpeedZAloft = 2.0,

        },        UseCameraShake = false,
        CameraShake = {
          {
            ShakeType = 2,
            Random = 0.0,
            StartOffset = 0.0,
            StartAmplitude = 0.15,
            StartFrequency = 15.0,
            TargetAmplitude = 0.3,
            TargetFrequency = 10.0,
            AmplitudeChangeTime = 0.15,
            FrequencyChangeTime = 0.0,
            DurationTime = 0.15,
            Sign = 9200304.0,
            DistanceDampingId = 0.0
          }
        },
        ShakeId = 0,
        CalcNearShakeBone = true,
        BoneEffectPos = { 0.0, 0.0, 0.0 },
        ShakeDir = 0,
        ShakeStrenRatio = 0.0,
        HavePauseFrame = false,
        IsCanBreak = true,
        PFFrame = 3,
        PFTimeScale = 1.0,
        PFTimeScaleCurve = "-1",
        TargetPFTimeScaleCurve = "-1",
        PFMonsterSpeed = 1.0,
        PFMonsterSpeedCurve = "-1",
        PFSceneSpeed = 1.0,
        PFSceneSpeedCurve = "-1",
        PFTime = 0.099,
        UsePostProcess = true,
        PostProcessParamsList = {
          {

            Strength = 0.2,
            Dir = 0,
            Radius = 0.35,
            Alpha = 0.7,
            AlphaCurveId = 1301,
            Direction = 0,
            Count = 3,
            Center = { 0.5, 0.5 },
            ShowTemplateID = false,
            TemplateID = 0,
            PostProcessType = 2,
            Duration = 3,
            ID = 0
          }
        },
      },
      Move = {
        pivot = 0.0,
        canGlide = false,
        GlideCost = 0.0,
        GlideHeight = 0.0,
        GlideRotationSpeed = 0.0,
        GlideDownSpeed = 0.0,
        GlideMoveSpeed = 0.0,
        GlideTurnSpeed = 0.0,
        GlideTurnBackSpeed = 0.0,
        MoveType = 3,
        LineraSpeedType = 1,
        Speed = 0.0,
        SpeedCurveId = 0,
        EarlyWarningFrame = 0,
        SignId = 0,
        WarningDurationFrame = 0,
        RotateSpeedCurveId = 0,
        AlwaysUpdateTargetPos = false,
        RotationLockInterval = 0.0,
        RotationLockDelay = 0,
        BindOffsetX = 0.0,
        BindOffsetY = 0.0,
        BindOffsetZ = 0.0,
        BindRotation = false,

      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 9200331201 ] = {
    EntityId = 9200331201,
    EntityName = "9200331201",
    Components = {
      Transform = {
        Prefab = "Character/Role/Entity1003/Model/Entity1004.prefab",
        isClone = false,
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
      TimeoutDeath = {
        Frame = 2,
        RemoveDelayFrame = 0,
      },
      Camp = {
        Camp = 2
      },
      Tag = {
        Tag = 2,
        NpcTag = 0,
        SceneObjectTag = 0,
        PartTag = 1
      },
      Attack = {
        AttackType = 1,
        MaxAttackTimes = -1,
        DelayFrame = 0,
        DurationFrame = 4,
        ShapeType = 2,
        Radius = 11000.0,
        circleStartRadius = 0.5,
        circleRadius = 0.5,
        SpreadSpeed = 0.0,
        SpreadFrame = 0,
        Lenght = 3.0,
        Height = 3.0,
        Width = 4.0,
        OffsetX = 0.0,
        OffsetY = 1.5,
        OffsetZ = 2.0,
        Repetition = false,
        IntervalFrame = 0,
        RemoveAfterHit = true,
        CanHitGround = false,
        RemoveAfterReach = false,
        ReachRange = 0.0,
        ReboundFrame = 0,
        IntervalTime = 0.0,
        ReboundTag = 1,
        ReboundEntityId = 0,
        DodgeInvalidType = 2,
        NotCheckDodge = false,
        NotJumpDodge = false,
        NotJumpBeatBack = false,
        MagicsBySelfBeforeHit = {
          10000001,
          30000011
        },
        MagicsByTarget = {
          20160001,
          92003006,
          20000003
        },
        HitTypeConfigList = {
          {
            HitType = 4,
            BreakLieDown = false
          }
        },
        SwtichLieAnimTime = 0.0,
        LookatType = 3,
        HitParams = {
          SpeedZ = 7.0,
          SpeedZAcceleration = -1.0,
          SpeedZTime = 0.3,
          SpeedY = 0.0,
          SpeedZHitFly = 0.0,
          SpeedYAcceleration = 0.0,
          SpeedYAccelerationTime = 0.0,
          SpeedYAloft = 5.0,
          SpeedZAloft = 2.0,

        },        UseCameraShake = false,
        CameraShake = {
          {
            ShakeType = 2,
            Random = 0.0,
            StartOffset = 0.0,
            StartAmplitude = 0.15,
            StartFrequency = 15.0,
            TargetAmplitude = 0.3,
            TargetFrequency = 10.0,
            AmplitudeChangeTime = 0.15,
            FrequencyChangeTime = 0.0,
            DurationTime = 0.15,
            Sign = 9200304.0,
            DistanceDampingId = 0.0
          }
        },
        ShakeId = 0,
        CalcNearShakeBone = true,
        BoneEffectPos = { 0.0, 0.0, 0.0 },
        ShakeDir = 0,
        ShakeStrenRatio = 0.0,
        HavePauseFrame = false,
        IsCanBreak = true,
        PFFrame = 3,
        PFTimeScale = 1.0,
        PFTimeScaleCurve = "-1",
        TargetPFTimeScaleCurve = "-1",
        PFMonsterSpeed = 1.0,
        PFMonsterSpeedCurve = "-1",
        PFSceneSpeed = 1.0,
        PFSceneSpeedCurve = "-1",
        PFTime = 0.099,
        UsePostProcess = true,
        PostProcessParamsList = {
          {

            Strength = 0.2,
            Dir = 0,
            Radius = 0.35,
            Alpha = 0.7,
            AlphaCurveId = 1301,
            Direction = 0,
            Count = 3,
            Center = { 0.5, 0.5 },
            ShowTemplateID = false,
            TemplateID = 0,
            PostProcessType = 2,
            Duration = 3,
            ID = 0
          }
        },
      },
      Move = {
        pivot = 0.0,
        canGlide = false,
        GlideCost = 0.0,
        GlideHeight = 0.0,
        GlideRotationSpeed = 0.0,
        GlideDownSpeed = 0.0,
        GlideMoveSpeed = 0.0,
        GlideTurnSpeed = 0.0,
        GlideTurnBackSpeed = 0.0,
        MoveType = 3,
        LineraSpeedType = 1,
        Speed = 0.0,
        SpeedCurveId = 0,
        EarlyWarningFrame = 0,
        SignId = 0,
        WarningDurationFrame = 0,
        RotateSpeedCurveId = 0,
        AlwaysUpdateTargetPos = false,
        RotationLockInterval = 0.0,
        RotationLockDelay = 0,
        BindOffsetX = 0.0,
        BindOffsetY = 0.0,
        BindOffsetZ = 0.0,
        BindRotation = false,

      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 9200300901 ] = {
    EntityId = 9200300901,
    EntityName = "9200300901",
    Components = {
      Transform = {
        Prefab = "Character/Role/Entity1003/Model/Entity1004.prefab",
        isClone = false,
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
      TimeoutDeath = {
        Frame = 4,
        RemoveDelayFrame = 0,
      },
      Camp = {
        Camp = 2
      },
      Tag = {
        Tag = 2,
        NpcTag = 0,
        SceneObjectTag = 0,
        PartTag = 1
      },
      Attack = {
        AttackType = 3,
        MaxAttackTimes = -1,
        DelayFrame = 0,
        DurationFrame = 4,
        ShapeType = 2,
        Radius = 11000.0,
        circleStartRadius = 0.5,
        circleRadius = 0.5,
        SpreadSpeed = 0.0,
        SpreadFrame = 0,
        Lenght = 3.0,
        Height = 4.0,
        Width = 10.0,
        OffsetX = 0.0,
        OffsetY = 1.0,
        OffsetZ = 5.0,
        Repetition = false,
        IntervalFrame = 0,
        RemoveAfterHit = true,
        CanHitGround = false,
        RemoveAfterReach = false,
        ReachRange = 0.0,
        ReboundFrame = 0,
        IntervalTime = 0.0,
        ReboundTag = 1,
        ReboundEntityId = 0,
        DodgeInvalidType = 1,
        NotCheckDodge = false,
        NotJumpDodge = false,
        NotJumpBeatBack = false,
        MagicsByTarget = {
          10050001
        },
        CreateHitEntities = {
          {
            EntityId = 92003009002,
            LookRX = false,
            LookRY = true,
            LookRZ = false,
            LookatType = 3
          }
        },
        HitTypeConfigList = {
          {
            HitType = 7,
            BreakLieDown = false
          }
        },
        SwtichLieAnimTime = 0.0,
        LookatType = 3,
        HitParams = {
          SpeedZ = 3.5,
          SpeedZAcceleration = 3.0,
          SpeedZTime = 0.2,
          SpeedY = 15.0,
          SpeedZHitFly = 3.5,
          SpeedYAcceleration = -35.0,
          SpeedYAccelerationTime = 0.3,
          SpeedYAloft = 5.0,
          SpeedZAloft = 2.0,

        },        UseCameraShake = false,
        CameraShake = {
          {
            ShakeType = 2,
            Random = 0.0,
            StartOffset = 0.0,
            StartAmplitude = 0.15,
            StartFrequency = 15.0,
            TargetAmplitude = 0.3,
            TargetFrequency = 10.0,
            AmplitudeChangeTime = 0.15,
            FrequencyChangeTime = 0.0,
            DurationTime = 0.15,
            Sign = 9200304.0,
            DistanceDampingId = 0.0
          }
        },
        ShakeId = 0,
        CalcNearShakeBone = true,
        BoneEffectPos = { 0.0, 0.0, 0.0 },
        ShakeDir = 0,
        ShakeStrenRatio = 0.0,
        HavePauseFrame = false,
        IsCanBreak = true,
        PFFrame = 3,
        PFTimeScale = 1.0,
        PFTimeScaleCurve = "-1",
        TargetPFTimeScaleCurve = "-1",
        PFMonsterSpeed = 1.0,
        PFMonsterSpeedCurve = "-1",
        PFSceneSpeed = 1.0,
        PFSceneSpeedCurve = "-1",
        PFTime = 0.099,
        UsePostProcess = false,
      },
      Move = {
        pivot = 0.0,
        canGlide = false,
        GlideCost = 0.0,
        GlideHeight = 0.0,
        GlideRotationSpeed = 0.0,
        GlideDownSpeed = 0.0,
        GlideMoveSpeed = 0.0,
        GlideTurnSpeed = 0.0,
        GlideTurnBackSpeed = 0.0,
        MoveType = 3,
        LineraSpeedType = 1,
        Speed = 0.0,
        SpeedCurveId = 0,
        EarlyWarningFrame = 0,
        SignId = 0,
        WarningDurationFrame = 0,
        RotateSpeedCurveId = 0,
        AlwaysUpdateTargetPos = false,
        RotationLockInterval = 0.0,
        RotationLockDelay = 0,
        BindOffsetX = 0.0,
        BindOffsetY = 0.0,
        BindOffsetZ = 0.0,
        BindRotation = false,

      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 92003009001 ] = {
    EntityId = 92003009001,
    EntityName = "92003009001",
    Components = {
      Effect = {
        IsBind = false,
        BindOffset = { -0.35, -0.4, 0.4 },
        ScaleOffset = { 0.0, 0.0, 0.0 },
        HitEffectBornType = 1,
        HitEffectOffsetY = 0.0,
        IsHeightLimit = false
      },
      Transform = {
        Prefab = "Character/Monster/Shentu/ShentuMb1Low/Effect/FxShentuMb1Atk009dilie.prefab",
        isClone = false,
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
      TimeoutDeath = {
        Frame = 42,
        RemoveDelayFrame = 0,
      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 92003009002 ] = {
    EntityId = 92003009002,
    EntityName = "92003009002",
    Components = {
      Effect = {
        IsBind = true,
        BindTransformName = "HitCase",
        BindOffset = { 0.0, 0.0, 0.0 },
        ScaleOffset = { 0.0, 0.0, 0.0 },
        HitEffectBornType = 1,
        HitEffectOffsetY = 0.0,
        IsHeightLimit = false
      },
      Transform = {
        Prefab = "Character/Monster/Shentu/ShentuMb1Low/Effect/FxShentuMb1Atk009Hit.prefab",
        isClone = false,
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
      TimeoutDeath = {
        Frame = 34,
        RemoveDelayFrame = 0,
      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 92003009003 ] = {
    EntityId = 92003009003,
    EntityName = "92003009003",
    Components = {
      Effect = {
        IsBind = true,
        BindTransformName = "",
        BindOffset = { 0.0, 0.0, 0.0 },
        ScaleOffset = { 0.0, 0.0, 0.0 },
        HitEffectBornType = 1,
        HitEffectOffsetY = 0.0,
        IsHeightLimit = false
      },
      Transform = {
        Prefab = "Character/Monster/Shentu/ShentuMb1Low/Effect/FxShentuMb1Atk009daoguang.prefab",
        isClone = false,
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
      TimeoutDeath = {
        Frame = 65,
        RemoveDelayFrame = 0,
      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 9200301302 ] = {
    EntityId = 9200301302,
    EntityName = "9200301302",
    Components = {
      Transform = {
        Prefab = "Character/Role/Entity1003/Model/Entity1004.prefab",
        isClone = false,
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
      TimeoutDeath = {
        Frame = 3,
        RemoveDelayFrame = 0,
      },
      Camp = {
        Camp = 2
      },
      Tag = {
        Tag = 2,
        NpcTag = 0,
        SceneObjectTag = 0,
        PartTag = 1
      },
      Attack = {
        AttackType = 0,
        MaxAttackTimes = -1,
        DelayFrame = 0,
        DurationFrame = 4,
        ShapeType = 2,
        Radius = 11000.0,
        circleStartRadius = 0.5,
        circleRadius = 0.5,
        SpreadSpeed = 0.0,
        SpreadFrame = 0,
        Lenght = 4.0,
        Height = 3.0,
        Width = 3.0,
        OffsetX = 0.0,
        OffsetY = 1.5,
        OffsetZ = 0.0,
        Repetition = false,
        IntervalFrame = 0,
        RemoveAfterHit = true,
        CanHitGround = false,
        RemoveAfterReach = false,
        ReachRange = 0.0,
        ReboundFrame = 0,
        IntervalTime = 0.0,
        ReboundTag = 1,
        ReboundEntityId = 0,
        DodgeInvalidType = 1,
        NotCheckDodge = false,
        NotJumpDodge = true,
        NotJumpBeatBack = true,
        MagicsBySelfBeforeHit = {
          10000001,
          30000006
        },
        MagicsByTarget = {
          92003007,
          10070001,
          20000001
        },
        HitTypeConfigList = {
          {
            HitType = 4,
            BreakLieDown = true
          }
        },
        SwtichLieAnimTime = 0.0,
        LookatType = 3,
        HitParams = {
          SpeedZ = 8.0,
          SpeedZAcceleration = -2.0,
          SpeedZTime = 0.2,
          SpeedY = 15.0,
          SpeedZHitFly = 3.5,
          SpeedYAcceleration = -35.0,
          SpeedYAccelerationTime = 0.3,
          SpeedYAloft = 10.0,
          SpeedZAloft = 10.0,

        },        UseCameraShake = true,
        ShakeId = 0,
        CalcNearShakeBone = true,
        BoneEffectPos = { 0.0, 0.0, 0.0 },
        ShakeDir = 0,
        ShakeStrenRatio = 0.0,
        HavePauseFrame = false,
        IsCanBreak = true,
        PFFrame = 3,
        PFTimeScale = 1.0,
        PFTimeScaleCurve = "-1",
        TargetPFTimeScaleCurve = "-1",
        PFMonsterSpeed = 1.0,
        PFMonsterSpeedCurve = "-1",
        PFSceneSpeed = 1.0,
        PFSceneSpeedCurve = "-1",
        PFTime = 0.099,
        UsePostProcess = false,
      },
      Move = {
        pivot = 0.0,
        canGlide = false,
        GlideCost = 0.0,
        GlideHeight = 0.0,
        GlideRotationSpeed = 0.0,
        GlideDownSpeed = 0.0,
        GlideMoveSpeed = 0.0,
        GlideTurnSpeed = 0.0,
        GlideTurnBackSpeed = 0.0,
        MoveType = 3,
        LineraSpeedType = 1,
        Speed = 0.0,
        SpeedCurveId = 0,
        EarlyWarningFrame = 0,
        SignId = 0,
        WarningDurationFrame = 0,
        RotateSpeedCurveId = 0,
        AlwaysUpdateTargetPos = false,
        RotationLockInterval = 0.0,
        RotationLockDelay = 0,
        BindOffsetX = 0.0,
        BindOffsetY = 0.0,
        BindOffsetZ = 0.0,
        BindRotation = false,

      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 9200301903 ] = {
    EntityId = 9200301903,
    EntityName = "9200301903",
    Components = {
      Transform = {
        Prefab = "Character/Role/Entity1003/Model/Entity1004.prefab",
        isClone = false,
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
      TimeoutDeath = {
        Frame = 45,
        RemoveDelayFrame = 0,
      },
      Camp = {
        Camp = 2
      },
      Tag = {
        Tag = 2,
        NpcTag = 0,
        SceneObjectTag = 0,
        PartTag = 1
      },
      Attack = {
        AttackType = 3,
        MaxAttackTimes = -1,
        DelayFrame = 0,
        DurationFrame = 90,
        ShapeType = 4,
        Radius = 11000.0,
        circleStartRadius = 5.0,
        circleRadius = 0.46,
        SpreadSpeed = 0.56,
        SpreadFrame = 45,
        Lenght = 0.0,
        Height = 1.5,
        Width = 0.0,
        OffsetX = 0.0,
        OffsetY = 0.0,
        OffsetZ = 0.0,
        Repetition = false,
        IntervalFrame = 0,
        RemoveAfterHit = true,
        CanHitGround = false,
        RemoveAfterReach = false,
        ReachRange = 0.0,
        ReboundFrame = 0,
        IntervalTime = 0.0,
        ReboundTag = 1,
        ReboundEntityId = 0,
        DodgeInvalidType = 0,
        NotCheckDodge = true,
        NotJumpDodge = true,
        NotJumpBeatBack = true,
        MagicsBySelfBeforeHit = {
          10000001,
          30000006
        },
        MagicsByTarget = {
          92003007,
          10070001,
          20000002
        },
        HitTypeConfigList = {
          {
            HitType = 4,
            BreakLieDown = true
          }
        },
        SwtichLieAnimTime = 0.0,
        LookatType = 3,
        HitParams = {
          SpeedZ = 5.0,
          SpeedZAcceleration = -1.0,
          SpeedZTime = 0.2,
          SpeedY = 15.0,
          SpeedZHitFly = 3.5,
          SpeedYAcceleration = -35.0,
          SpeedYAccelerationTime = 0.3,
          SpeedYAloft = 10.0,
          SpeedZAloft = 10.0,

        },        UseCameraShake = true,
        ShakeId = 0,
        CalcNearShakeBone = true,
        BoneEffectPos = { 0.0, 0.0, 0.0 },
        ShakeDir = 0,
        ShakeStrenRatio = 0.0,
        HavePauseFrame = false,
        IsCanBreak = true,
        PFFrame = 3,
        PFTimeScale = 1.0,
        PFTimeScaleCurve = "-1",
        TargetPFTimeScaleCurve = "-1",
        PFMonsterSpeed = 1.0,
        PFMonsterSpeedCurve = "-1",
        PFSceneSpeed = 1.0,
        PFSceneSpeedCurve = "-1",
        PFTime = 0.099,
        UsePostProcess = false,
      },
      Move = {
        pivot = 0.0,
        canGlide = false,
        GlideCost = 0.0,
        GlideHeight = 0.0,
        GlideRotationSpeed = 0.0,
        GlideDownSpeed = 0.0,
        GlideMoveSpeed = 0.0,
        GlideTurnSpeed = 0.0,
        GlideTurnBackSpeed = 0.0,
        MoveType = 3,
        LineraSpeedType = 1,
        Speed = 0.0,
        SpeedCurveId = 0,
        EarlyWarningFrame = 0,
        SignId = 0,
        WarningDurationFrame = 0,
        RotateSpeedCurveId = 0,
        AlwaysUpdateTargetPos = false,
        RotationLockInterval = 0.0,
        RotationLockDelay = 0,
        BindOffsetX = 0.0,
        BindOffsetY = 0.0,
        BindOffsetZ = 0.0,
        BindRotation = false,

      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 92003019002 ] = {
    EntityId = 92003019002,
    EntityName = "92003019002",
    Components = {
      Effect = {
        IsBind = true,
        BindTransformName = "",
        BindOffset = { 0.0, 0.0, 0.0 },
        ScaleOffset = { 0.0, 0.0, 0.0 },
        HitEffectBornType = 1,
        HitEffectOffsetY = 0.0,
        IsHeightLimit = false
      },
      Transform = {
        Prefab = "Character/Monster/Shentu/ShentuMb1Low/Effect/FxShentuMb1Atk019dibo.prefab",
        isClone = false,
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
      TimeoutDeath = {
        Frame = 45,
        RemoveDelayFrame = 0,
      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 9200301904 ] = {
    EntityId = 9200301904,
    EntityName = "9200301904",
    Components = {
      Transform = {
        Prefab = "Character/Role/Entity1003/Model/Entity1004.prefab",
        isClone = false,
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
      TimeoutDeath = {
        Frame = 45,
        RemoveDelayFrame = 0,
      },
      Camp = {
        Camp = 2
      },
      Tag = {
        Tag = 2,
        NpcTag = 0,
        SceneObjectTag = 0,
        PartTag = 1
      },
      Attack = {
        AttackType = 3,
        MaxAttackTimes = -1,
        DelayFrame = 0,
        DurationFrame = 4,
        ShapeType = 3,
        Radius = 5.0,
        circleStartRadius = 5.0,
        circleRadius = 0.48,
        SpreadSpeed = 0.56,
        SpreadFrame = 45,
        Lenght = 0.0,
        Height = 1.5,
        Width = 0.0,
        OffsetX = 0.0,
        OffsetY = 0.0,
        OffsetZ = 0.0,
        Repetition = false,
        IntervalFrame = 0,
        RemoveAfterHit = true,
        CanHitGround = false,
        RemoveAfterReach = false,
        ReachRange = 0.0,
        ReboundFrame = 0,
        IntervalTime = 0.0,
        ReboundTag = 1,
        ReboundEntityId = 0,
        DodgeInvalidType = 0,
        NotCheckDodge = true,
        NotJumpDodge = true,
        NotJumpBeatBack = true,
        MagicsBySelfBeforeHit = {
          10000001,
          30000006
        },
        MagicsByTarget = {
          92003007,
          10070001,
          20000002
        },
        HitTypeConfigList = {
          {
            HitType = 4,
            BreakLieDown = true
          }
        },
        SwtichLieAnimTime = 0.0,
        LookatType = 3,
        HitParams = {
          SpeedZ = 5.0,
          SpeedZAcceleration = -1.0,
          SpeedZTime = 0.2,
          SpeedY = 15.0,
          SpeedZHitFly = 3.5,
          SpeedYAcceleration = -35.0,
          SpeedYAccelerationTime = 0.3,
          SpeedYAloft = 10.0,
          SpeedZAloft = 10.0,

        },        UseCameraShake = true,
        ShakeId = 0,
        CalcNearShakeBone = true,
        BoneEffectPos = { 0.0, 0.0, 0.0 },
        ShakeDir = 0,
        ShakeStrenRatio = 0.0,
        HavePauseFrame = false,
        IsCanBreak = true,
        PFFrame = 3,
        PFTimeScale = 1.0,
        PFTimeScaleCurve = "-1",
        TargetPFTimeScaleCurve = "-1",
        PFMonsterSpeed = 1.0,
        PFMonsterSpeedCurve = "-1",
        PFSceneSpeed = 1.0,
        PFSceneSpeedCurve = "-1",
        PFTime = 0.099,
        UsePostProcess = false,
      },
      Move = {
        pivot = 0.0,
        canGlide = false,
        GlideCost = 0.0,
        GlideHeight = 0.0,
        GlideRotationSpeed = 0.0,
        GlideDownSpeed = 0.0,
        GlideMoveSpeed = 0.0,
        GlideTurnSpeed = 0.0,
        GlideTurnBackSpeed = 0.0,
        MoveType = 3,
        LineraSpeedType = 1,
        Speed = 0.0,
        SpeedCurveId = 0,
        EarlyWarningFrame = 0,
        SignId = 0,
        WarningDurationFrame = 0,
        RotateSpeedCurveId = 0,
        AlwaysUpdateTargetPos = false,
        RotationLockInterval = 0.0,
        RotationLockDelay = 0,
        BindOffsetX = 0.0,
        BindOffsetY = 0.0,
        BindOffsetZ = 0.0,
        BindRotation = false,

      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 92003228001 ] = {
    EntityId = 92003228001,
    EntityName = "92003228001",
    Components = {
      Effect = {
        IsBind = true,
        BindTransformName = "",
        BindOffset = { 0.0, 0.0, 0.0 },
        ScaleOffset = { 0.0, 0.0, 0.0 },
        HitEffectBornType = 1,
        HitEffectOffsetY = 0.0,
        IsHeightLimit = false
      },
      Transform = {
        Prefab = "Character/Monster/Shentu/ShentuMb1Low/Effect/FxShentuMb1Atk228daoguang1.prefab",
        isClone = false,
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
      TimeoutDeath = {
        Frame = 42,
        RemoveDelayFrame = 0,
      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 92003228002 ] = {
    EntityId = 92003228002,
    EntityName = "92003228002",
    Components = {
      Effect = {
        IsBind = true,
        BindTransformName = "",
        BindOffset = { 0.0, 0.0, 0.0 },
        ScaleOffset = { 0.0, 0.0, 0.0 },
        HitEffectBornType = 1,
        HitEffectOffsetY = 0.0,
        IsHeightLimit = false
      },
      Transform = {
        Prefab = "Character/Monster/Shentu/ShentuMb1Low/Effect/FxShentuMb1Atk228daoguang2.prefab",
        isClone = false,
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
      TimeoutDeath = {
        Frame = 42,
        RemoveDelayFrame = 0,
      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 92003228003 ] = {
    EntityId = 92003228003,
    EntityName = "92003228003",
    Components = {
      Effect = {
        IsBind = true,
        BindTransformName = "",
        BindOffset = { 0.0, 0.0, 0.0 },
        ScaleOffset = { 0.0, 0.0, 0.0 },
        HitEffectBornType = 1,
        HitEffectOffsetY = 0.0,
        IsHeightLimit = false
      },
      Transform = {
        Prefab = "Character/Monster/Shentu/ShentuMb1Low/Effect/FxShentuMb1Atk228daoguang3.prefab",
        isClone = false,
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
      TimeoutDeath = {
        Frame = 42,
        RemoveDelayFrame = 0,
      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 9200321001 ] = {
    EntityId = 9200321001,
    EntityName = "9200321001",
    Components = {
      Transform = {
        Prefab = "Character/Role/Entity1003/Model/Entity1004.prefab",
        isClone = false,
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
      TimeoutDeath = {
        Frame = 3,
        RemoveDelayFrame = 0,
      },
      Camp = {
        Camp = 2
      },
      Tag = {
        Tag = 2,
        NpcTag = 0,
        SceneObjectTag = 0,
        PartTag = 1
      },
      Attack = {
        AttackType = 0,
        MaxAttackTimes = -1,
        DelayFrame = 0,
        DurationFrame = 4,
        ShapeType = 2,
        Radius = 11000.0,
        circleStartRadius = 0.5,
        circleRadius = 0.5,
        SpreadSpeed = 0.0,
        SpreadFrame = 0,
        Lenght = 3.5,
        Height = 3.0,
        Width = 5.0,
        OffsetX = 0.0,
        OffsetY = 1.5,
        OffsetZ = 2.0,
        Repetition = false,
        IntervalFrame = 0,
        RemoveAfterHit = true,
        CanHitGround = false,
        RemoveAfterReach = false,
        ReachRange = 0.0,
        ReboundFrame = 0,
        IntervalTime = 0.0,
        ReboundTag = 1,
        ReboundEntityId = 0,
        DodgeInvalidType = 2,
        NotCheckDodge = false,
        NotJumpDodge = true,
        NotJumpBeatBack = true,
        MagicsBySelfBeforeHit = {
          10000006
        },
        MagicsByTargetBeforeHit = {
          20000005
        },
        MagicsByTarget = {
          92003007,
          20160002
        },
        HitTypeConfigList = {
          {
            HitType = 3,
            BreakLieDown = true
          }
        },
        SwtichLieAnimTime = 0.0,
        LookatType = 3,
        HitParams = {
          SpeedZ = 6.0,
          SpeedZAcceleration = -2.0,
          SpeedZTime = 0.3,
          SpeedY = 15.0,
          SpeedZHitFly = 3.5,
          SpeedYAcceleration = -35.0,
          SpeedYAccelerationTime = 0.3,
          SpeedYAloft = 10.0,
          SpeedZAloft = 10.0,

        },        UseCameraShake = true,
        ShakeId = 0,
        CalcNearShakeBone = true,
        BoneEffectPos = { 0.0, 0.0, 0.0 },
        ShakeDir = 0,
        ShakeStrenRatio = 0.0,
        HavePauseFrame = false,
        IsCanBreak = true,
        PFFrame = 3,
        PFTimeScale = 1.0,
        PFTimeScaleCurve = "-1",
        TargetPFTimeScaleCurve = "-1",
        PFMonsterSpeed = 1.0,
        PFMonsterSpeedCurve = "-1",
        PFSceneSpeed = 1.0,
        PFSceneSpeedCurve = "-1",
        PFTime = 0.099,
        UsePostProcess = false,
      },
      Move = {
        pivot = 0.0,
        canGlide = false,
        GlideCost = 0.0,
        GlideHeight = 0.0,
        GlideRotationSpeed = 0.0,
        GlideDownSpeed = 0.0,
        GlideMoveSpeed = 0.0,
        GlideTurnSpeed = 0.0,
        GlideTurnBackSpeed = 0.0,
        MoveType = 3,
        LineraSpeedType = 1,
        Speed = 0.0,
        SpeedCurveId = 0,
        EarlyWarningFrame = 0,
        SignId = 0,
        WarningDurationFrame = 0,
        RotateSpeedCurveId = 0,
        AlwaysUpdateTargetPos = false,
        RotationLockInterval = 0.0,
        RotationLockDelay = 0,
        BindOffsetX = 0.0,
        BindOffsetY = 0.0,
        BindOffsetZ = 0.0,
        BindRotation = false,

      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  },
  [ 9200321002 ] = {
    EntityId = 9200321002,
    EntityName = "9200321002",
    Components = {
      Transform = {
        Prefab = "Character/Role/Entity1003/Model/Entity1004.prefab",
        isClone = false,
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
      TimeoutDeath = {
        Frame = 3,
        RemoveDelayFrame = 0,
      },
      Camp = {
        Camp = 2
      },
      Tag = {
        Tag = 2,
        NpcTag = 0,
        SceneObjectTag = 0,
        PartTag = 1
      },
      Attack = {
        AttackType = 0,
        MaxAttackTimes = -1,
        DelayFrame = 0,
        DurationFrame = 4,
        ShapeType = 2,
        Radius = 11000.0,
        circleStartRadius = 0.5,
        circleRadius = 0.5,
        SpreadSpeed = 0.0,
        SpreadFrame = 0,
        Lenght = 3.5,
        Height = 3.0,
        Width = 5.0,
        OffsetX = 0.0,
        OffsetY = 1.5,
        OffsetZ = 2.0,
        Repetition = false,
        IntervalFrame = 0,
        RemoveAfterHit = true,
        CanHitGround = false,
        RemoveAfterReach = false,
        ReachRange = 0.0,
        ReboundFrame = 0,
        IntervalTime = 0.0,
        ReboundTag = 1,
        ReboundEntityId = 0,
        DodgeInvalidType = 2,
        NotCheckDodge = false,
        NotJumpDodge = true,
        NotJumpBeatBack = true,
        MagicsBySelfBeforeHit = {
          10000006
        },
        MagicsByTargetBeforeHit = {
          20000005
        },
        MagicsByTarget = {
          92003007,
          20160002
        },
        HitTypeConfigList = {
          {
            HitType = 3,
            BreakLieDown = true
          }
        },
        SwtichLieAnimTime = 0.0,
        LookatType = 3,
        HitParams = {
          SpeedZ = 6.0,
          SpeedZAcceleration = -2.0,
          SpeedZTime = 0.3,
          SpeedY = 15.0,
          SpeedZHitFly = 3.5,
          SpeedYAcceleration = -35.0,
          SpeedYAccelerationTime = 0.3,
          SpeedYAloft = 10.0,
          SpeedZAloft = 10.0,

        },        UseCameraShake = true,
        ShakeId = 0,
        CalcNearShakeBone = true,
        BoneEffectPos = { 0.0, 0.0, 0.0 },
        ShakeDir = 0,
        ShakeStrenRatio = 0.0,
        HavePauseFrame = false,
        IsCanBreak = true,
        PFFrame = 3,
        PFTimeScale = 1.0,
        PFTimeScaleCurve = "-1",
        TargetPFTimeScaleCurve = "-1",
        PFMonsterSpeed = 1.0,
        PFMonsterSpeedCurve = "-1",
        PFSceneSpeed = 1.0,
        PFSceneSpeedCurve = "-1",
        PFTime = 0.099,
        UsePostProcess = false,
      },
      Move = {
        pivot = 0.0,
        canGlide = false,
        GlideCost = 0.0,
        GlideHeight = 0.0,
        GlideRotationSpeed = 0.0,
        GlideDownSpeed = 0.0,
        GlideMoveSpeed = 0.0,
        GlideTurnSpeed = 0.0,
        GlideTurnBackSpeed = 0.0,
        MoveType = 3,
        LineraSpeedType = 1,
        Speed = 0.0,
        SpeedCurveId = 0,
        EarlyWarningFrame = 0,
        SignId = 0,
        WarningDurationFrame = 0,
        RotateSpeedCurveId = 0,
        AlwaysUpdateTargetPos = false,
        RotationLockInterval = 0.0,
        RotationLockDelay = 0,
        BindOffsetX = 0.0,
        BindOffsetY = 0.0,
        BindOffsetZ = 0.0,
        BindRotation = false,

      },
      Time = {
        DefalutTimeScale = 1.0
      }
    }
  }
}
