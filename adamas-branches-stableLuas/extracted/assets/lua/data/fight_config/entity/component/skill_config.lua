Config = Config or {}
Config.SkillConfig = Config.SkillConfig or {}

Config.SkillConfig[1001] = {
    [1001001] = {
        TotalFrame = 54,
        ForceFrame = 9, --6+3
        FrameEvent = {
            [0] = {
                PlayAnimation = {
                    Name = "Attack001"
                }
            },
			[4] = {
				CameraShake = {
					ShakeType = 1,				--震屏类型
					StartAmplitude = 1,			--初始强度
					StartFrequency = 1,			--初始频率
					TargetAmplitude = 0.2,		--目标强度
					TargetFrequency = 0.2,		--目标频率
					AmplitudeChangeTime = 0.2,	--强度变化时间
					FrequencyChangeTime = 0.2,	--频率变化时间
					DurationTime = 0.5,			--震屏持续时间
					Sign = 1,					--震屏标识，同类标识新覆盖旧震屏
					DistanceDampingId = 0,		--震屏强度距离衰减
				}
			},
			[6] = {
				FrameSign = {
					Type = 1,
					Frame = 9,
				}
			},
			[1] = {
				Action = 
				{
					{
						Type = "CreateEntity",
						-- EntityId = 1001001001,
						EntityName = "TestPartice",
						--QualitySign = 2,
						--ActiveSign = {default = false,sign = {1001,1003}}
					}
				}
			}
        }
    },
    [1001002] = {
        TotalFrame = 50,
        ForceFrame = 18, --16+3
        FrameEvent = {
            [0] = {
                PlayAnimation = {
                    Name = "Attack002"
                }
            },
			[15] = {
				FrameSign = {
					Type = 1,
					Frame = 9,
				}
			},
			[8] = {
				CreateEntity = {
					EntityId = 1001002001
				}
			}
        }
    },
    [1001003] = {
        TotalFrame = 90,
        ForceFrame = 27,--24+3
        FrameEvent = {
            [0] = {
                PlayAnimation = {
                    Name = "Attack003"
                }
            },
			[24] = {
				FrameSign = {
					Type = 1,
					Frame = 9,
				}
			},
			[6] = {
				CreateEntity = {
					EntityId = 1001003001
				}
			},
			[13] = {
				CreateEntity = {
					EntityId = 1001003002
				}
			},
			[18] = {
				CreateEntity = {
					EntityId = 1001003003
				}
			},
			[20] = {
				CreateEntity = {
					EntityId = 1001003004
				}
			}
        }
    },
    [1001004] = {
        TotalFrame = 85,
        ForceFrame = 22,--19+3
        FrameEvent = {
            [0] = {
                PlayAnimation = {
                    Name = "Attack004"
                }
            },
			[19] = {
				FrameSign = {
					Type = 1,
					Frame = 9,
				}
			},
			[6] = {
				CreateEntity = {
					EntityId = 1001004001
				}
			},
			[12] = {
				CreateEntity = {
					EntityId = 1001004002
				}
			},
			[15] = {
				CreateEntity = {
					EntityId = 1001004003
				}
			},
			[17] = {
				CreateEntity = {
					EntityId = 1001004004
				}
			}
        }
    },
	[1001005] = {
		TotalFrame = 70,
		ForceFrame = 24,
		FrameEvent = {
			[0] = {
				PlayAnimation = {
					Name = "Attack005"
				}
			},
			[4] = {
				CreateEntity = {
					EntityId = 1001005001
				}
			},
			[10] = {
				CreateEntity = {
					EntityId = 1001005002
				}
			}
		}
	},
    [1001006] = {
        TotalFrame = 60,
        ForceFrame = 12,
        FrameEvent = {
            [0] = {
                PlayAnimation = {
                    Name = "Move01"
                },
            }
        }
    },
    [1001007] = {
        TotalFrame = 60,
        ForceFrame = 12,
        FrameEvent = {
            [0] = {
                PlayAnimation = {
                    Name = "Move02"
                },
            }
        }
    },
	[1001008] = {
		TotalFrame = 76,
		ForceFrame = 18,
		FrameEvent = {
			[0] = {
				PlayAnimation = {
					Name = "Attack010"
				},
			},
			[3] = {
				CreateEntity = {
					EntityId = 1001008001
				}
			},
			[8] = {
				CreateEntity = {
					EntityId = 1001008002
				}
			},
			[10] = {
				CreateEntity = {
					EntityId = 1001008003
				}
			}
		}
	},
	[1001009] = {
		TotalFrame = 46,
		ForceFrame = 12,
		FrameEvent = {
			[0] = {
				PlayAnimation = {
					Name = "Attack020"
				}
			},
			[5] = {
				CreateEntity = {
					EntityId = 1001009001
				}
			}
		}
	}
}

Config.SkillConfig[1002] = {
	[1002001] = {
		TotalFrame = 74,
		ForceFrame = 16, --13+3
		FrameEvent = {
			[0] = {
				PlayAnimation = {
					Name = "Attack001"
				}
			},
			[13] = {		
				FrameSign = {
					Type = 1,
					Frame = 9,
				}
			}			
		}
	},
	[1002002] = {
		TotalFrame = 79,
		ForceFrame = 25, --22+3
		FrameEvent = {
			[0] = {
				PlayAnimation = {
					Name = "Attack002"
				}
			},
			[22] = {
				FrameSign = {
					Type = 1,
					Frame = 9,
				}
			}
		}
	},
	[1002003] = {
		TotalFrame = 105,
		ForceFrame = 28,--25+3
		FrameEvent = {
			[0] = {
				PlayAnimation = {
					Name = "Attack003"
				}
			},
			[25] = {
				FrameSign = {
					Type = 1,
					Frame = 9,
				}
			}
		}
	},
	[1002004] = {
		TotalFrame = 102,
		ForceFrame = 25,--22+3
		FrameEvent = {
			[0] = {
				PlayAnimation = {
					Name = "Attack004"
				}
			},
			[22] = {
				FrameSign = {
					Type = 1,
					Frame = 9,
				}
			}
		}
	},
	[1002005] = {
		TotalFrame = 93,
		ForceFrame = 39,
		FrameEvent = {
			[0] = {
				PlayAnimation = {
					Name = "Attack005"
				}
			}
		}
	},
	[1002006] = {
		TotalFrame = 37,
		ForceFrame = 15,
		FrameEvent = {
			[0] = {
				PlayAnimation = {
					Name = "Move01"
				},
			}
		}
	},
	[1002007] = {
		TotalFrame = 58,
		ForceFrame = 15,
		FrameEvent = {
			[0] = {
				PlayAnimation = {
					Name = "Move02"
				},
			}
		}
	}
}

Config.SkillConfig[1003] = {
	[1003001] = {
		TotalFrame = 40,
		ForceFrame = 13, --10+3
		FrameEvent = {
			[10] = {
				FrameSign = {
					Type = 1,
					Frame = 9,
				}
			},
			[3] = {
				CreateEntity = {
					EntityId = 1003001001
				}
			},
			[0] = {
				Action = {
					{
						Type = "CreateEntity",
						EntityName = "FxAtk001_1003001",
						LifeBindSkill = true,
					},
					{
						Type = "PlayAnimation",
						Name = "Attack001",
					},
				}
			}
		}
	},
	[1003002] = {
		TotalFrame = 48,
		ForceFrame = 21, --18+3
		FrameEvent = {
			[18] = {
				FrameSign = {
					Type = 1,
					Frame = 9,
				}
			},
			[4] = {
				CreateEntity = {
					EntityId = 1003002001
				}
			},
			[11] = {
				CreateEntity = {
					EntityId = 1003002001
				}
			},
			[0] = {
				Action = {
					{
						Type = "CreateEntity",
						EntityName = "FxAtk002_1003002",
						LifeBindSkill = true,
					},
					{
						Type = "PlayAnimation",
						Name = "Attack002",
					},
				}
			}
		}
	},
	[1003003] = {
		TotalFrame = 54,
		ForceFrame = 27,--24+3
		FrameEvent = {
			[24] = {
				FrameSign = {
					Type = 1,
					Frame = 9,
				}
			},
			[5] = {
				CreateEntity = {
					EntityId = 1003003001
				}
			},
			[8] = {
				CreateEntity = {
					EntityId = 1003003002
				}
			},
			[15] = {
				CreateEntity = {
					EntityId = 1003003003
				}
			},
			[20] = {
				CreateEntity = {
					EntityId = 1003003004
				}
			},
			[0] = {
				Action =
				{
					{
						Type = "CreateEntity",
						EntityName = "FxAtk003_1003003",
						LifeBindSkill = true,
					},
					{
						Type = "PlayAnimation",
						Name = "Attack003",
					},
				}
			}
		}
	},
	[1003004] = {
		TotalFrame = 58,
		ForceFrame = 32,--29+3
		FrameEvent = {
			[29] = {
				FrameSign = {
					Type = 1,
					Frame = 9,
				}
			},
			[20] = {
				CreateEntity = {
					EntityId = 1003004001
				}
			},
			[0] = {
				Action =
				{
					{
						Type = "CreateEntity",
						EntityName = "FxAtk004_1003004",
						LifeBindSkill = true,
					},
					{
						Type = "PlayAnimation",
						Name = "Attack004",
					},
				}
			}
		}
	},
	[1003005] = {
		TotalFrame = 61,
		ForceFrame = 33,--30+3
		FrameEvent = {
			[30] = {
				FrameSign = {
					Type = 1,
					Frame = 9,
				}
			},
			[6] = {
				CreateEntity = {
					EntityId = 1003005001
				}
			},
			[8] = {
				CreateEntity = {
					EntityId = 1003005002
				}
			},
			[15] = {
				CreateEntity = {
					EntityId = 1003005003
				}
			},
			[24] = {
				CreateEntity = {
					EntityId = 1003005004
				}
			},
			[0] = {
				Action =
				{
					{
						Type = "CreateEntity",
						EntityName = "FxAtk005_1003005",
						LifeBindSkill = true,
					},
					{
						Type = "PlayAnimation",
						Name = "Attack005",
					},
				}
			}
		}
	},
	[1003006] = {
		TotalFrame = 49,
		ForceFrame = 21,
		FrameEvent = {
			[9] = {
				CreateEntity = {
					EntityId = 1003006001
				}
			},
			[0] = {
				Action =
				{
					{
						Type = "CreateEntity",
						EntityName = "FxAtk006_1003006",
						LifeBindSkill = true,
					},
					{
						Type = "PlayAnimation",
						Name = "Attack006",
					},
				}
			}
		}
	},
	[1003007] = {
		TotalFrame = 53,
		ForceFrame = 15,
		FrameEvent = {
			[0] = {
				PlayAnimation = {
					Name = "Move01"
				},
			}
		}
	},
	[1003008] = {
		TotalFrame = 45,
		ForceFrame = 15,
		FrameEvent = {
			[0] = {
				PlayAnimation = {
					Name = "Move02"
				},
			}
		}
	},
	[1003009] = {
		TotalFrame = 64,
		ForceFrame = 18,
		FrameEvent = {
			[0] = {
				Action = {
					{
						Type = "CreateEntity",
						EntityName = "FxAtk010_1003010",
					},
					{
						Type = "PlayAnimation",
						Name = "Attack010",
					}
				}
			},
			[3] = {
				CreateEntity = {
					EntityId = 1003009001
				}
			},
			[12] = {
				CreateEntity = {
					EntityId = 1003009002
				}
			},
		}
	},
	[1003010] = {
		TotalFrame = 62,
		ForceFrame = 36,
		FrameEvent = {
			[0] = {
				Action = {
					{
						Type = "CreateEntity",
						EntityName = "FxAtk011_1003011",
					},
					{
						Type = "PlayAnimation",
						Name = "Attack011",
					}
				}
			},
			[3] = {
				CreateEntity = {
					EntityId = 1003010001
				}
			},
			[11] = {
				CreateEntity = {
					EntityId = 1003010002
				}
			},
			[19] = {
				CreateEntity = {
					EntityId = 1003010003
				}
			},
			[21] = {
				CreateEntity = {
					EntityId = 1003010004
				}
			},
			[25] = {
				CreateEntity = {
					EntityId = 1003010005
				}
			},
			[27] = {
				CreateEntity = {
					EntityId = 1003010006
				}
			},
		}
	},
	[1003011] = {
		TotalFrame = 90,
		ForceFrame = 30,
		FrameEvent = {
			[0] = {
				Action = {
					{
						Type = "CreateEntity",
						EntityName = "FxAtk020_1003020",
					},
					{
						Type = "PlayAnimation",
						Name = "Attack020",
					}
				}
			},
			[5] = {
				CreateEntity = {
					EntityId = 1003011001
				}
			},
			[7] = {
				CreateEntity = {
					EntityId = 1003011001
				}
			},
			[9] = {
				CreateEntity = {
					EntityId = 1003011001
				}
			},
			[11] = {
				CreateEntity = {
					EntityId = 1003011001
				}
			},
			[13] = {
				CreateEntity = {
					EntityId = 1003011001
				}
			},
			[22] = {
				CreateEntity = {
					EntityId = 1003011002
				}
			},
		}
	},
	[1003012] = {
		TotalFrame = 90,
		ForceFrame = 30,
		FrameEvent = {
			[0] = {
				Action = {
					{
						Type = "CreateEntity",
						EntityName = "FxAtk021_1003021",
					},
					{
						Type = "PlayAnimation",
						Name = "Attack021",
					}
				}
			},
			[5] = {
				CreateEntity = {
					EntityId = 1003012001
				}
			},
			[7] = {
				CreateEntity = {
					EntityId = 1003012001
				}
			},
			[9] = {
				CreateEntity = {
					EntityId = 1003012001
				}
			},
			[11] = {
				CreateEntity = {
					EntityId = 1003012001
				}
			},
			[13] = {
				CreateEntity = {
					EntityId = 1003012001
				}
			},
			[22] = {
				CreateEntity = {
					EntityId = 1003012002
				}
			},
		}
	}
}

Config.SkillConfig[1004] = {
	[1004001] = {
		TotalFrame = 47,
		ForceFrame = 15, --9+3
		FrameEvent = {
			[0] = {
				PlayAnimation = {
					Name = "Attack001"
				}
			},
			[12] = {
				FrameSign = {
					Type = 1,
					Frame = 9,
				}
			},
			[4] = {
				Action = {
					{
						Type = "CreateEntity",
						EntityId = 1004001001,
						--[[ActiveSign = {
							default = true,
							sign = {1004001,1004002},
						},]]--
					}
				}
			},
		}
	},
	[1004002] = {
		TotalFrame = 51,
		ForceFrame = 21, --18+3
		FrameEvent = {
			[0] = {
				PlayAnimation = {
					Name = "Attack002"
				}
			},
			[18] = {
				FrameSign = {
					Type = 1,
					Frame = 9,
				}
			},
			[7] = {
				CreateEntity = {
					EntityId = 1004002001
				}
			},
			[15] = {
				CreateEntity = {
					EntityId = 1004002001
				}
			}
		}
	},
	[1004003] = {
		TotalFrame = 69,
		ForceFrame = 39,--33+3
		FrameEvent = {
			[0] = {
				PlayAnimation = {
					Name = "Attack003"
				}
			},
			[36] = {
				FrameSign = {
					Type = 1,
					Frame = 9,
				}
			},
			[5] = {
				CreateEntity = {
					EntityId = 1004001001
				}
			},
			[12] = {
				CreateEntity = {
					EntityId = 1004003002
				}
			},
			[22] = {
				CreateEntity = {
					EntityId = 1004003002
				}
			}
		}
	},
	[1004004] = {
		TotalFrame = 62,
		ForceFrame = 18,--15+3
		FrameEvent = {
			[0] = {
				PlayAnimation = {
					Name = "Attack004"
				}
			},
			[15] = {
				FrameSign = {
					Type = 1,
					Frame = 9,
				}
			},
			[5] = {
				CreateEntity = {
					EntityId = 1004004001
				}
			},
			[10] = {
				CreateEntity = {
					EntityId = 1004004001
				}
			}
		}
	},
	[1004005] = {
		TotalFrame = 81,
		ForceFrame = 30,--27+3
		FrameEvent = {
			[0] = {
				PlayAnimation = {
					Name = "Attack005"
				}
			},
			[27] = {
				FrameSign = {
					Type = 1,
					Frame = 9,
				}
			},
			[4] = {
				CreateEntity = {
					EntityId = 1004005001
				}
			},
			[9] = {
				CreateEntity = {
					EntityId = 1004005002
				}
			},
			[19] = {
				CreateEntity = {
					EntityId = 1004005003
				}
			},
			[24] = {
				CreateEntity = {
					EntityId = 1004005004
				}
			}
		}
	},
	[1004006] = {
		TotalFrame = 90,
		ForceFrame = 33,
		FrameEvent = {
			[0] = {
				PlayAnimation = {
					Name = "Attack006"
				}
			},
			[10] = {
				CreateEntity = {
					EntityId = 1004006001
				}
			}
		}
	},
	[1004007] = {
		TotalFrame = 50,
		ForceFrame = 15,
		FrameEvent = {
			[0] = {
				Action = {
					{
						Type ="PlayAnimation",
						Name = "Move01"
					},
					{
						Type = "ActiveDodge",
						Flag = true,
						Frame = 15,
					},
				}	
			},
		}
	},
	[1004008] = {
		TotalFrame = 68,
		ForceFrame = 15,
		FrameEvent = {
			[0] = {
				Action = {
					{
						Type ="PlayAnimation",
						Name = "Move02"
					},
					{
						Type = "ActiveDodge",
						Flag = true,
						Frame = 15,
					},
				}
			},	
		}
	},
	[1004009] = {
		TotalFrame = 33,
		ForceFrame = 18,
		FrameEvent = {
			[0] = {
				PlayAnimation = {
					Name = "Attack010"
				},
			},
			[5] = {
				CreateEntity = {
					EntityId = 1004009001
				}
			},
			[8] = {
				CreateEntity = {
					EntityId = 1004009001
				}
			},
			[11] = {
				CreateEntity = {
					EntityId = 1004009001
				}
			},
			[14] = {
				CreateEntity = {
					EntityId = 1004009001
				}
			},
			[17] = {
				CreateEntity = {
					EntityId = 1004009001
				}
			},
		}
	},
	[1004010] = {
		TotalFrame = 34,
		ForceFrame = 18,
		FrameEvent = {
			[0] = {
				PlayAnimation = {
					Name = "Attack011"
				},
			},
			[8] = {
				CreateEntity = {
					EntityId = 1001001001
				}
			},
			[11] = {
				CreateEntity = {
					EntityId = 1004009001
				}
			},
			[14] = {
				CreateEntity = {
					EntityId = 1004009001
				}
			},
			[17] = {
				CreateEntity = {
					EntityId = 1004009001
				}
			},
		}
	},
	[1004011] = {
		TotalFrame = 34,
		ForceFrame = 18,
		FrameEvent = {
			[0] = {
				PlayAnimation = {
					Name = "Attack012"
				}
			},
			[5] = {
				CreateEntity = {
					EntityId = 1004009001
				}
			},
			[8] = {
				CreateEntity = {
					EntityId = 1004009001
				}
			},
			[11] = {
				CreateEntity = {
					EntityId = 1004009001
				}
			},
			[14] = {
				CreateEntity = {
					EntityId = 1004009001
				}
			},
			[17] = {
				CreateEntity = {
					EntityId = 1004009001
				}
			},
		}
	},
	--1004012是被动型技能
	[1004013] = {
		TotalFrame = 80,
		ForceFrame = 42,
		FrameEvent = {
			[0] = {
				PlayAnimation = {
					Name = "Attack060"		--QTE动作暂时给大招用
				}
			},
			[2] = {
				CreateEntity = {
					EntityId = 1004013001
				}
			},
			[4] = {
				CreateEntity = {
					EntityId = 1004013001
				}
			},
			[6] = {
				CreateEntity = {
					EntityId = 1004013001
				}
			},
			[8] = {
				CreateEntity = {
					EntityId = 1004013001
				}
			},
			[17] = {
				CreateEntity = {
					EntityId = 1004013002
				}
			}
		}
	}
	--1004014是测试被动型技能
}

Config.SkillConfig[9001] = {
	[9001001] = {
		TotalFrame = 70,
		ForceFrame = 70,
		FrameEvent = {
			[0] = {
				PlayAnimation = {
					Name = "Attack001"
				}
			},
			[28] = {
				CreateEntity = {
					EntityId = 9001001001
				}
			}
		}
	},
	[9001002] = {
		TotalFrame = 90,
		ForceFrame = 90,
		FrameEvent = {
			[0] = {
				PlayAnimation = {
					Name = "Attack002"
				}
			},
			[32] = {
				CreateEntity = {
					EntityId = 9001002001
				}
			}
		}
	},
	[9001003] = {
		TotalFrame = 90,
		ForceFrame = 90,
		FrameEvent = {
			[0] = {
				PlayAnimation = {
					Name = "Attack003"
				}
			},
		}
	},
	[9001004] = {
		TotalFrame = 110,
		ForceFrame = 110,
		FrameEvent = {
			[0] = {
				PlayAnimation = {
					Name = "Attack004"
				}
			},
			[32] = {
				CreateEntity = {
					EntityId = 9001004001
				}
			}
		}
	},
}
