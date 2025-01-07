Config = Config or {}
Config.AttackConfig = Config.AttackConfig or {}


Config.AttackConfig[111112] = {
	ShapeType = 1,
	Radius = 15000,
	MagicsBySelf = {
		--[1] = 12001--
	},
	MagicsByTarget = {
		[1] = 12002--
	},
	HitType = 1,
	HitParams = {						--受击必须参数，不可缺少，不用填0
		SpeedZ = 4,						--地面受击击退初速度，可为负
		SpeedZAcceleration = -20,		--地面受击击退加速度，可为负
		SpeedZTime = 0.2,				--地面受击击退时间，必须小于受击动作时间
		SpeedY = 0,						--击飞受击垂直初速度
		SpeedZHitFly = 0,				--击飞受击水平初速度
		SpeedYAcceleration = 0,			--击飞受击垂直加速度
		SpeedYAccelerationTime = 0,		--击飞受击垂直加速度持续时间
		SpeedYAloft = 2.8,				--空中再受击垂直速度(set)
		SpeedZAloft = 1,				--空中再受击水平速度(set)
	},
	LookatType = 3,	
}

Config.AttackConfig[1001001001] = {
	ShapeType = 1,
	Radius = 15000,
	MagicsBySelf = {
		[1] = 1001001--
	},
	MagicsByTarget = {
		[1] = 12002--
	},
	CameraShakes = {
		[1] = {
			ShakeType = 2,				--震屏类型
			StartAmplitude = 0.15,		--初始强度
			StartFrequency = 10,		--初始频率
			TargetAmplitude = 0,		--目标强度
			TargetFrequency = 10,		--目标频率
			AmplitudeChangeTime = 0.3,	--强度变化时间
			FrequencyChangeTime = 0,	--频率变化时间
			DurationTime = 0.15,		--震屏持续时间
			Sign = 1,					--震屏标识，同类标识新覆盖旧震屏
			DistanceDampingId = 0,		--震屏强度距离衰减
		},
	},
	HitType = 1,
	HitParams = {						--受击必须参数，不可缺少，不用填0
		SpeedZ = 4,						--地面受击击退初速度，可为负
		SpeedZAcceleration = -20,		--地面受击击退加速度，可为负
		SpeedZTime = 0.2,				--地面受击击退时间，必须小于受击动作时间
		SpeedY = 0,						--击飞受击垂直初速度
		SpeedZHitFly = 0,				--击飞受击水平初速度
		SpeedYAcceleration = 0,			--击飞受击垂直加速度
		SpeedYAccelerationTime = 0,		--击飞受击垂直加速度持续时间
		SpeedYAloft = 2.8,				--空中再受击垂直速度(set)
		SpeedZAloft = 1,				--空中再受击水平速度(set)
	},
	LookatType = 3,
	DoDamage = {

	}
}
Config.AttackConfig[1001002001] = {
	ShapeType = 1,
	Radius = 15000,
	MagicsBySelf = {
		--[1] = 1001001--
	},
	MagicsByTarget = {
		[1] = 12003--
	},
	CameraShakes = {
		[1] = {
			ShakeType = 3,				--震屏类型
			StartAmplitude = 0.13,		--初始强度
			StartFrequency = 10,		--初始频率
			TargetAmplitude = 0,		--目标强度
			TargetFrequency = 10,		--目标频率
			AmplitudeChangeTime = 0.15,	--强度变化时间
			FrequencyChangeTime = 0,	--频率变化时间
			DurationTime = 0.15,		--震屏持续时间
			Sign = 1,					--震屏标识，同类标识新覆盖旧震屏
			DistanceDampingId = 0,		--震屏强度距离衰减
			}
	},
	HitType = 2,
	HitParams = {					--受击必须参数，不可缺少，不用填0
		SpeedZ = 4,					--地面受击击退速度，可为负
		SpeedZAcceleration = -20,	--地面受击击退加速度
		SpeedZTime = 0.2,			--地面受击击退时间
		SpeedY = 0,					--击飞受击垂直初速度
		SpeedZHitFly = 0,			--击飞受击水平初速度
		SpeedYAcceleration = 0,		--击飞受击垂直加速度
		SpeedYAccelerationTime = 0,	--击飞受击垂直加速度持续时间
		SpeedYAloft = 2.8,			--空中再受击垂直速度(set)
		SpeedZAloft = 1,			--空中再受击水平速度(set)
	},
	LookatType = 3,
}
Config.AttackConfig[1001003001] = {
	ShapeType = 1,
	Radius = 15000,
	MagicsBySelf = {
		[1] = 1001003
	},
	MagicsByTarget = {
		[1] = 1001003
	},
	CameraShakes = {
		[1] = {
			ShakeType = 2,				--震屏类型
			StartAmplitude = 0.2,		--初始强度
			StartFrequency = 10,		--初始频率
			TargetAmplitude = 0,		--目标强度
			TargetFrequency = 10,		--目标频率
			AmplitudeChangeTime = 0.15,	--强度变化时间
			FrequencyChangeTime = 0,	--频率变化时间
			DurationTime = 0.15,		--震屏持续时间
			Sign = 1,					--震屏标识，同类标识新覆盖旧震屏
			DistanceDampingId = 0,		--震屏强度距离衰减
			}
	},
	HitType = 3,
	HitParams = {					--受击必须参数，不可缺少，不用填0
		SpeedZ = 0,					--地面受击击退速度，可为负
		SpeedZAcceleration = 0,		--地面受击击退加速度
		SpeedZTime = 0,				--地面受击击退时间
		SpeedY = 0,					--击飞受击垂直初速度
		SpeedZHitFly = 0,			--击飞受击水平初速度
		SpeedYAcceleration = 0,		--击飞受击垂直加速度
		SpeedYAccelerationTime = 0,	--击飞受击垂直加速度持续时间
		SpeedYAloft = 2.8,			--空中再受击垂直速度(set)
		SpeedZAloft = 1,			--空中再受击水平速度(set)
	},
	LookatType = 3,
}
Config.AttackConfig[1001003002] = {
	ShapeType = 1,
	Radius = 15000,
	MagicsBySelf = {
		--[1] = 1001006--
	},
	MagicsByTarget = {
		--[1] = 1001006--
	},
	CameraShake = {
		[1] = {
			ShakeType = 2,				--震屏类型
			StartAmplitude = 0.07,		--初始强度
			StartFrequency = 10,		--初始频率
			TargetAmplitude = 0,		--目标强度
			TargetFrequency = 10,		--目标频率
			AmplitudeChangeTime = 0.15,	--强度变化时间
			FrequencyChangeTime = 0,	--频率变化时间
			DurationTime = 0.15,		--震屏持续时间
			Sign = 1,					--震屏标识，同类标识新覆盖旧震屏
			DistanceDampingId = 0,		--震屏强度距离衰减
			}
	},
	HitType = 1,
	HitParams = {					--受击必须参数，不可缺少，不用填0
		SpeedZ = 0,					--地面受击击退速度，可为负
		SpeedZAcceleration = 0,		--地面受击击退加速度
		SpeedZTime = 0,				--地面受击击退时间
		SpeedY = 0,					--击飞受击垂直初速度
		SpeedZHitFly = 0,			--击飞受击水平初速度
		SpeedYAcceleration = 0,		--击飞受击垂直加速度
		SpeedYAccelerationTime = 0,	--击飞受击垂直加速度持续时间
		SpeedYAloft = 2.8,			--空中再受击垂直速度(set)
		SpeedZAloft = 1,			--空中再受击水平速度(set)
	},
	LookatType = 3,
}
Config.AttackConfig[1001003003] = {
	ShapeType = 1,
	Radius = 15000,
	MagicsBySelf = {
		--[1] = 1001005
	},
	MagicsByTarget = {
		--[1] = 1001005
	},
	CameraShake = {
		[1] = {
			ShakeType = 2,				--震屏类型
			StartAmplitude = 0.07,		--初始强度
			StartFrequency = 10,		--初始频率
			TargetAmplitude = 0,		--目标强度
			TargetFrequency = 10,		--目标频率
			AmplitudeChangeTime = 0.15,	--强度变化时间
			FrequencyChangeTime = 0,	--频率变化时间
			DurationTime = 0.15,		--震屏持续时间
			Sign = 1,					--震屏标识，同类标识新覆盖旧震屏
			DistanceDampingId = 0,		--震屏强度距离衰减
			}
	},
	HitType = 1,
	HitParams = {					--受击必须参数，不可缺少，不用填0
		SpeedZ = 0,					--地面受击击退速度，可为负
		SpeedZAcceleration = 0,		--地面受击击退加速度
		SpeedZTime = 0,				--地面受击击退时间
		SpeedY = 0,					--击飞受击垂直初速度
		SpeedZHitFly = 0,			--击飞受击水平初速度
		SpeedYAcceleration = 0,		--击飞受击垂直加速度
		SpeedYAccelerationTime = 0,	--击飞受击垂直加速度持续时间
		SpeedYAloft = 2.8,			--空中再受击垂直速度(set)
		SpeedZAloft = 1,			--空中再受击水平速度(set)
	},
	LookatType = 3,
}
Config.AttackConfig[1001003004] = {
	ShapeType = 1,
	Radius = 15000,
	MagicsBySelf = {
		--[1] = 1001005
	},
	MagicsByTarget = {
		--[1] = 1001005
	},
	CameraShake = {
		[1] = {
			ShakeType = 2,				--震屏类型
			StartAmplitude = 0.07,		--初始强度
			StartFrequency = 10,		--初始频率
			TargetAmplitude = 0,		--目标强度
			TargetFrequency = 10,		--目标频率
			AmplitudeChangeTime = 0.15,	--强度变化时间
			FrequencyChangeTime = 0,	--频率变化时间
			DurationTime = 0.15,		--震屏持续时间
			Sign = 1,					--震屏标识，同类标识新覆盖旧震屏
			DistanceDampingId = 0,		--震屏强度距离衰减
			}
	},
	HitType = 3,
	HitParams = {					--受击必须参数，不可缺少，不用填0
		SpeedZ = 0,					--地面受击击退速度，可为负
		SpeedZAcceleration = 0,		--地面受击击退加速度
		SpeedZTime = 0,				--地面受击击退时间
		SpeedY = 0,					--击飞受击垂直初速度
		SpeedZHitFly = 0,			--击飞受击水平初速度
		SpeedYAcceleration = 0,		--击飞受击垂直加速度
		SpeedYAccelerationTime = 0,	--击飞受击垂直加速度持续时间
		SpeedYAloft = 2.8,			--空中再受击垂直速度(set)
		SpeedZAloft = 1,			--空中再受击水平速度(set)
	},
	LookatType = 3,
}
Config.AttackConfig[1001004001] = {
	ShapeType = 1,
	Radius = 15000,
	MagicsBySelf = {
		--[1] = 1001001--
	},
	MagicsByTarget = {
		--[1] = 1001001--
	},
	CameraShake = {
		[1] = {
			ShakeType = 3,				--震屏类型
			StartAmplitude = -0.08,		--初始强度
			StartFrequency = 10,		--初始频率
			TargetAmplitude = 0,		--目标强度
			TargetFrequency = 10,		--目标频率
			AmplitudeChangeTime = 0.15,	--强度变化时间
			FrequencyChangeTime = 0,	--频率变化时间
			DurationTime = 0.15,		--震屏持续时间
			Sign = 1,					--震屏标识，同类标识新覆盖旧震屏
			DistanceDampingId = 0,		--震屏强度距离衰减
			}
	},
	HitType = 2,
	HitParams = {					--受击必须参数，不可缺少，不用填0
		SpeedZ = 0,					--地面受击击退速度，可为负
		SpeedZAcceleration = 0,		--地面受击击退加速度
		SpeedZTime = 0,				--地面受击击退时间
		SpeedY = 0,					--击飞受击垂直初速度
		SpeedZHitFly = 0,			--击飞受击水平初速度
		SpeedYAcceleration = 0,		--击飞受击垂直加速度
		SpeedYAccelerationTime = 0,	--击飞受击垂直加速度持续时间
		SpeedYAloft = 2.8,			--空中再受击垂直速度(set)
		SpeedZAloft = 1,			--空中再受击水平速度(set)
	},
	LookatType = 3,
}
Config.AttackConfig[1001004002] = {
	ShapeType = 1,
	Radius = 15000,
	MagicsBySelf = {
		--[1] = 1001003--
	},
	MagicsByTarget = {
		--[1] = 1001003--
	},
	CameraShake = {
		[1] = {
			ShakeType = 3,				--震屏类型
			StartAmplitude = -0.06,		--初始强度
			StartFrequency = 10,		--初始频率
			TargetAmplitude = 0,		--目标强度
			TargetFrequency = 10,		--目标频率
			AmplitudeChangeTime = 0.15,	--强度变化时间
			FrequencyChangeTime = 0,	--频率变化时间
			DurationTime = 0.15,		--震屏持续时间
			Sign = 1,					--震屏标识，同类标识新覆盖旧震屏
			DistanceDampingId = 0,		--震屏强度距离衰减
			}
	},
	HitType = 2,
	HitParams = {					--受击必须参数，不可缺少，不用填0
		SpeedZ = 0,					--地面受击击退速度，可为负
		SpeedZAcceleration = 0,		--地面受击击退加速度
		SpeedZTime = 0,				--地面受击击退时间
		SpeedY = 0,					--击飞受击垂直初速度
		SpeedZHitFly = 0,			--击飞受击水平初速度
		SpeedYAcceleration = 0,		--击飞受击垂直加速度
		SpeedYAccelerationTime = 0,	--击飞受击垂直加速度持续时间
		SpeedYAloft = 2.8,			--空中再受击垂直速度(set)
		SpeedZAloft = 1,			--空中再受击水平速度(set)
	},
	LookatType = 3,
}
Config.AttackConfig[1001004003] = {
	ShapeType = 1,
	Radius = 15000,
	MagicsBySelf = {
		[1] = 1001003
	},
	MagicsByTarget = {
		[1] = 1001003
	},
	CameraShake = {
		[1] = {
			ShakeType = 3,				--震屏类型
			StartAmplitude = -0.06,		--初始强度
			StartFrequency = 10,		--初始频率
			TargetAmplitude = 0,		--目标强度
			TargetFrequency = 10,		--目标频率
			AmplitudeChangeTime = 0.15,	--强度变化时间
			FrequencyChangeTime = 0,	--频率变化时间
			DurationTime = 0.15,		--震屏持续时间
			Sign = 1,					--震屏标识，同类标识新覆盖旧震屏
			DistanceDampingId = 0,		--震屏强度距离衰减
			}
	},
	HitType = 2,
	HitParams = {					--受击必须参数，不可缺少，不用填0
		SpeedZ = 0,					--地面受击击退速度，可为负
		SpeedZAcceleration = 0,		--地面受击击退加速度
		SpeedZTime = 0,				--地面受击击退时间
		SpeedY = 0,					--击飞受击垂直初速度
		SpeedZHitFly = 0,			--击飞受击水平初速度
		SpeedYAcceleration = 0,		--击飞受击垂直加速度
		SpeedYAccelerationTime = 0,	--击飞受击垂直加速度持续时间
		SpeedYAloft = 2.8,			--空中再受击垂直速度(set)
		SpeedZAloft = 1,			--空中再受击水平速度(set)
	},
	LookatType = 3,
}
Config.AttackConfig[1001004004] = {
	ShapeType = 1,
	Radius = 15000,
	MagicsBySelf = {
		--[1] = 1001005
	},
	MagicsByTarget = {
		--[1] = 1001005
	},
	CameraShake = {
		[1] = {
			ShakeType = 3,				--震屏类型
			StartAmplitude = -0.08,		--初始强度
			StartFrequency = 10,		--初始频率
			TargetAmplitude = 0,		--目标强度
			TargetFrequency = 10,		--目标频率
			AmplitudeChangeTime = 0.25,	--强度变化时间
			FrequencyChangeTime = 0,	--频率变化时间
			DurationTime = 0.25,		--震屏持续时间
			Sign = 1,					--震屏标识，同类标识新覆盖旧震屏
			DistanceDampingId = 0,		--震屏强度距离衰减
			}
	},
	HitType = 4,
	HitParams = {					--受击必须参数，不可缺少，不用填0
		SpeedZ = 4,					--地面受击击退速度，可为负
		SpeedZAcceleration = -20,		--地面受击击退加速度
		SpeedZTime = 0.2,				--地面受击击退时间
		SpeedY = 0,					--击飞受击垂直初速度
		SpeedZHitFly = 0,			--击飞受击水平初速度
		SpeedYAcceleration = 0,		--击飞受击垂直加速度
		SpeedYAccelerationTime = 0,	--击飞受击垂直加速度持续时间
		SpeedYAloft = 2.8,			--空中再受击垂直速度(set)
		SpeedZAloft = 1,			--空中再受击水平速度(set)
	},
	LookatType = 3,
}
Config.AttackConfig[1001005001] = {
	ShapeType = 1,
	Radius = 15000,
	MagicsBySelf = {
		--[1] = 1001001
	},
	MagicsByTarget = {
		--[1] = 1001001
	},
	CameraShake = {
		[1] = {
			ShakeType = 2,				--震屏类型
			StartAmplitude = -0.15,		--初始强度
			StartFrequency = 10,		--初始频率
			TargetAmplitude = 0,		--目标强度
			TargetFrequency = 10,		--目标频率
			AmplitudeChangeTime = 0.15,	--强度变化时间
			FrequencyChangeTime = 0,	--频率变化时间
			DurationTime = 0.15,		--震屏持续时间
			Sign = 1,					--震屏标识，同类标识新覆盖旧震屏
			DistanceDampingId = 0,		--震屏强度距离衰减
			}
	},
	HitType = 2,
	HitParams = {					--受击必须参数，不可缺少，不用填0
		SpeedZ = 0,					--地面受击击退速度，可为负
		SpeedZAcceleration = 0,		--地面受击击退加速度
		SpeedZTime = 0,				--地面受击击退时间
		SpeedY = 0,					--击飞受击垂直初速度
		SpeedZHitFly = 0,			--击飞受击水平初速度
		SpeedYAcceleration = 0,		--击飞受击垂直加速度
		SpeedYAccelerationTime = 0,	--击飞受击垂直加速度持续时间
		SpeedYAloft = 2.8,			--空中再受击垂直速度(set)
		SpeedZAloft = 1,			--空中再受击水平速度(set)
	},
	LookatType = 3,
}
Config.AttackConfig[1001005002] = {
	ShapeType = 1,
	Radius = 15000,
	MagicsBySelf = {
		--[1] = 1001001
	},
	MagicsByTarget = {
		--[1] = 1001001
	},
	CameraShake = {
		[1] = {
			ShakeType = 4,				--震屏类型
			StartAmplitude = 0.4,		--初始强度
			StartFrequency = 10,		--初始频率
			TargetAmplitude = 0,		--目标强度
			TargetFrequency = 10,		--目标频率
			AmplitudeChangeTime = 0.25,	--强度变化时间
			FrequencyChangeTime = 0,	--频率变化时间
			DurationTime = 0.25,		--震屏持续时间
			Sign = 1,					--震屏标识，同类标识新覆盖旧震屏
			DistanceDampingId = 0,		--震屏强度距离衰减
			}
	},
	HitType = 3,
	HitParams = {					--受击必须参数，不可缺少，不用填0
		SpeedZ = 4,					--地面受击击退速度，可为负
		SpeedZAcceleration = -20,		--地面受击击退加速度
		SpeedZTime = 0.2,				--地面受击击退时间
		SpeedY = 0,					--击飞受击垂直初速度
		SpeedZHitFly = 0,			--击飞受击水平初速度
		SpeedYAcceleration = 0,		--击飞受击垂直加速度
		SpeedYAccelerationTime = 0,	--击飞受击垂直加速度持续时间
		SpeedYAloft = 2.8,			--空中再受击垂直速度(set)
		SpeedZAloft = 1,			--空中再受击水平速度(set)
	},
	LookatType = 3,
}
Config.AttackConfig[1001008001] = {
	ShapeType = 1,
	Radius = 20000,
	MagicsBySelf = {
		--[1] = 1001001
	},
	MagicsByTarget = {
		--[1] = 1001001
	},
	CameraShake = {
		[1] = {
			ShakeType = 2,				--震屏类型
			StartAmplitude = 0.18,		--初始强度
			StartFrequency = 10,		--初始频率
			TargetAmplitude = 0,		--目标强度
			TargetFrequency = 10,		--目标频率
			AmplitudeChangeTime = 0.15,	--强度变化时间
			FrequencyChangeTime = 0,	--频率变化时间
			DurationTime = 0.15,		--震屏持续时间
			Sign = 1,					--震屏标识，同类标识新覆盖旧震屏
			DistanceDampingId = 0,		--震屏强度距离衰减
			}
	},
	HitType = 1,
	HitParams = {					--受击必须参数，不可缺少，不用填0
		SpeedZ = 0,					--地面受击击退速度，可为负
		SpeedZAcceleration = 0,		--地面受击击退加速度
		SpeedZTime = 0,				--地面受击击退时间
		SpeedY = 0,					--击飞受击垂直初速度
		SpeedZHitFly = 0,			--击飞受击水平初速度
		SpeedYAcceleration = 0,		--击飞受击垂直加速度
		SpeedYAccelerationTime = 0,	--击飞受击垂直加速度持续时间
		SpeedYAloft = 2.8,			--空中再受击垂直速度(set)
		SpeedZAloft = 1,			--空中再受击水平速度(set)
	},
	LookatType = 3,
}
Config.AttackConfig[1001008002] = {
	ShapeType = 1,
	Radius = 20000,
	MagicsBySelf = {
		--[1] = 1001001
	},
	MagicsByTarget = {
		--[1] = 1001001
	},
	CameraShake = {
		[1] = {
			ShakeType = 2,				--震屏类型
			StartAmplitude = 0.18,		--初始强度
			StartFrequency = 10,		--初始频率
			TargetAmplitude = 0,		--目标强度
			TargetFrequency = 10,		--目标频率
			AmplitudeChangeTime = 0.15,	--强度变化时间
			FrequencyChangeTime = 0,	--频率变化时间
			DurationTime = 0.15,		--震屏持续时间
			Sign = 1,					--震屏标识，同类标识新覆盖旧震屏
			DistanceDampingId = 0,		--震屏强度距离衰减
			}
	},
	HitType = 1,
	HitParams = {					--受击必须参数，不可缺少，不用填0
		SpeedZ = 0,					--地面受击击退速度，可为负
		SpeedZAcceleration = 0,		--地面受击击退加速度
		SpeedZTime = 0,				--地面受击击退时间
		SpeedY = 0,					--击飞受击垂直初速度
		SpeedZHitFly = 0,			--击飞受击水平初速度
		SpeedYAcceleration = 0,		--击飞受击垂直加速度
		SpeedYAccelerationTime = 0,	--击飞受击垂直加速度持续时间
		SpeedYAloft = 2.8,			--空中再受击垂直速度(set)
		SpeedZAloft = 1,			--空中再受击水平速度(set)
	},
	LookatType = 3,
}
Config.AttackConfig[1001008003] = {
	ShapeType = 1,
	Radius = 20000,
	MagicsBySelf = {
		[1] = 1001005
	},
	MagicsByTarget = {
		[1] = 1001005
	},
	CameraShake = {
		[1] = {
			ShakeType = 2,				--震屏类型
			StartAmplitude = 0.22,		--初始强度
			StartFrequency = 10,		--初始频率
			TargetAmplitude = 0,		--目标强度
			TargetFrequency = 10,		--目标频率
			AmplitudeChangeTime = 0.25,	--强度变化时间
			FrequencyChangeTime = 0,	--频率变化时间
			DurationTime = 0.25,		--震屏持续时间
			Sign = 1,					--震屏标识，同类标识新覆盖旧震屏
			DistanceDampingId = 0,		--震屏强度距离衰减
			}
	},
	HitType = 3,
	HitParams = {					--受击必须参数，不可缺少，不用填0
		SpeedZ = 0,					--地面受击击退速度，可为负
		SpeedZAcceleration = 0,		--地面受击击退加速度
		SpeedZTime = 0,				--地面受击击退时间
		SpeedY = 0,					--击飞受击垂直初速度
		SpeedZHitFly = 0,			--击飞受击水平初速度
		SpeedYAcceleration = 0,		--击飞受击垂直加速度
		SpeedYAccelerationTime = 0,	--击飞受击垂直加速度持续时间
		SpeedYAloft = 2.8,			--空中再受击垂直速度(set)
		SpeedZAloft = 1,			--空中再受击水平速度(set)
	},
	LookatType = 3,
}
Config.AttackConfig[1001009001] = {
	ShapeType = 1,
	Radius = 20000,
	MagicsBySelf = {
		[1] = 1001005
	},
	MagicsByTarget = {
		[1] = 1001005
	},
	CameraShake = {
		[1] = {
			ShakeType = 3,				--震屏类型
			StartAmplitude = 0.3,		--初始强度
			StartFrequency = 10,		--初始频率
			TargetAmplitude = 0,		--目标强度
			TargetFrequency = 10,		--目标频率
			AmplitudeChangeTime = 0.25,	--强度变化时间
			FrequencyChangeTime = 0,	--频率变化时间
			DurationTime = 0.25,		--震屏持续时间
			Sign = 1,					--震屏标识，同类标识新覆盖旧震屏
			DistanceDampingId = 0,		--震屏强度距离衰减
			}
	},
	HitType = 7,
	HitParams = {						--受击必须参数，不可缺少，不用填0
		SpeedZ = 0,						--地面受击击退速度，可为负
		SpeedZAcceleration = 0,			--地面受击击退加速度
		SpeedZTime = 0,					--地面受击击退时间
		SpeedY = 25,					--击飞受击垂直初速度
		SpeedZHitFly = 1,				--击飞受击水平初速度
		SpeedYAcceleration = -95,		--击飞受击垂直加速度
		SpeedYAccelerationTime = 0.2,	--击飞受击垂直加速度持续时间
		SpeedYAloft = 5,				--空中再受击垂直速度(set)
		SpeedZAloft = 1,				--空中再受击水平速度(set)
	},
	LookatType = 3,
}



Config.AttackConfig[1003001001] = {
	ShapeType = 1,
	Radius = 30000,
	MagicsBySelf = {
		--[1] = 1001001--
	},
	MagicsByTarget = {
		--[1] = 1001001--
		[1] = 1003001,
		[2] = 1003002,
	},
	CameraShakes = {
		[1] = {
		ShakeType = 2,				--震屏类型
		StartAmplitude = -0.2,		--初始强度
		StartFrequency = 10,		--初始频率
		TargetAmplitude = -0.1,		--目标强度
		TargetFrequency = 10,		--目标频率
		AmplitudeChangeTime = 0.3,	--强度变化时间
		FrequencyChangeTime = 0,	--频率变化时间
		DurationTime = 0.15,		--震屏持续时间
		Sign = 1,					--震屏标识，同类标识新覆盖旧震屏
		DistanceDampingId = 0,		--震屏强度距离衰减
		},
	},
	HitType = 2,
	HitParams = {						--受击必须参数，不可缺少，不用填0
		SpeedZ = 0,						--地面受击击退初速度，可为负
		SpeedZAcceleration = 0,		--地面受击击退加速度，可为负
		SpeedZTime = 0,				--地面受击击退时间，必须小于受击动作时间
		SpeedY = 0,						--击飞受击垂直初速度
		SpeedZHitFly = 0,				--击飞受击水平初速度
		SpeedYAcceleration = 0,			--击飞受击垂直加速度
		SpeedYAccelerationTime = 0,		--击飞受击垂直加速度持续时间
		SpeedYAloft = 2.8,				--空中再受击垂直速度(set)
		SpeedZAloft = 1,				--空中再受击水平速度(set)
	},
	LookatType = 3,
}
Config.AttackConfig[1003002001] = {
	ShapeType = 1,
	Radius = 30000,
	MagicsBySelf = {
		--[1] = 1001001--
	},
	MagicsByTarget = {
		--[1] = 1001001--
		[1] = 1003001,
		[2] = 1003003,
	},
	CameraShakes = {
		[1] = {
			ShakeType = 2,				--震屏类型
			StartAmplitude = 0.12,		--初始强度
			StartFrequency = 10,		--初始频率
			TargetAmplitude = 0.08,		--目标强度
			TargetFrequency = 10,		--目标频率
			AmplitudeChangeTime = 0.3,	--强度变化时间
			FrequencyChangeTime = 0,	--频率变化时间
			DurationTime = 0.15,		--震屏持续时间
			Sign = 1,					--震屏标识，同类标识新覆盖旧震屏
			DistanceDampingId = 0,		--震屏强度距离衰减
		},
	},
	HitType = 1,
	HitParams = {						--受击必须参数，不可缺少，不用填0
		SpeedZ = 0,						--地面受击击退初速度，可为负
		SpeedZAcceleration = 0,		--地面受击击退加速度，可为负
		SpeedZTime = 0,				--地面受击击退时间，必须小于受击动作时间
		SpeedY = 0,						--击飞受击垂直初速度
		SpeedZHitFly = 0,				--击飞受击水平初速度
		SpeedYAcceleration = 0,			--击飞受击垂直加速度
		SpeedYAccelerationTime = 0,		--击飞受击垂直加速度持续时间
		SpeedYAloft = 2.8,				--空中再受击垂直速度(set)
		SpeedZAloft = 1,				--空中再受击水平速度(set)
	},
	LookatType = 3,
}
Config.AttackConfig[1003002002] = {
	ShapeType = 1,
	Radius = 30000,
	MagicsBySelf = {
		--[1] = 1001001--
	},
	MagicsByTarget = {
		--[1] = 1001001--
		[1] = 1003001,
		[2] = 1003004,
	},
	CameraShakes = {
		[1] = {
			ShakeType = 2,				--震屏类型
			StartAmplitude = -0.12,		--初始强度
			StartFrequency = 10,		--初始频率
			TargetAmplitude = -0.08,		--目标强度
			TargetFrequency = 10,		--目标频率
			AmplitudeChangeTime = 0.3,	--强度变化时间
			FrequencyChangeTime = 0,	--频率变化时间
			DurationTime = 0.15,		--震屏持续时间
			Sign = 1,					--震屏标识，同类标识新覆盖旧震屏
			DistanceDampingId = 0,		--震屏强度距离衰减
		},
	},
	HitType = 2,
	HitParams = {						--受击必须参数，不可缺少，不用填0
		SpeedZ = 0,						--地面受击击退初速度，可为负
		SpeedZAcceleration = 0,		--地面受击击退加速度，可为负
		SpeedZTime = 0,				--地面受击击退时间，必须小于受击动作时间
		SpeedY = 0,						--击飞受击垂直初速度
		SpeedZHitFly = 0,				--击飞受击水平初速度
		SpeedYAcceleration = 0,			--击飞受击垂直加速度
		SpeedYAccelerationTime = 0,		--击飞受击垂直加速度持续时间
		SpeedYAloft = 2.8,				--空中再受击垂直速度(set)
		SpeedZAloft = 1,				--空中再受击水平速度(set)
	},
	LookatType = 3,
}
Config.AttackConfig[1003003001] = {
	ShapeType = 1,
	Radius = 30000,
	MagicsBySelf = {
		--[1] = 1001001--
	},
	MagicsByTarget = {
		--[1] = 1001001--
		[1] = 1003001,
		[2] = 1003005,
	},
	CameraShakes = {
		[1] = {
			ShakeType = 2,				--震屏类型
			StartAmplitude = 0.15,		--初始强度
			StartFrequency = 10,		--初始频率
			TargetAmplitude = 0.1,		--目标强度
			TargetFrequency = 10,		--目标频率
			AmplitudeChangeTime = 0.3,	--强度变化时间
			FrequencyChangeTime = 0,	--频率变化时间
			DurationTime = 0.15,		--震屏持续时间
			Sign = 1,					--震屏标识，同类标识新覆盖旧震屏
			DistanceDampingId = 0,		--震屏强度距离衰减
		},
	},
	HitType = 1,
	HitParams = {						--受击必须参数，不可缺少，不用填0
		SpeedZ = 0,						--地面受击击退初速度，可为负
		SpeedZAcceleration = 0,		--地面受击击退加速度，可为负
		SpeedZTime = 0,				--地面受击击退时间，必须小于受击动作时间
		SpeedY = 0,						--击飞受击垂直初速度
		SpeedZHitFly = 0,				--击飞受击水平初速度
		SpeedYAcceleration = 0,			--击飞受击垂直加速度
		SpeedYAccelerationTime = 0,		--击飞受击垂直加速度持续时间
		SpeedYAloft = 2.8,				--空中再受击垂直速度(set)
		SpeedZAloft = 1,				--空中再受击水平速度(set)
	},
	LookatType = 3,
}
Config.AttackConfig[1003003002] = {
	ShapeType = 1,
	Radius = 30000,
	MagicsBySelf = {
		--[1] = 1001001--
	},
	MagicsByTarget = {
		--[1] = 1001001--
		[1] = 1003001,
		[2] = 1003006,
	},
	--[[CameraShakes = {
		[1] = {
			ShakeType = 2,				--震屏类型
			StartAmplitude = 0.1,		--初始强度
			StartFrequency = 10,		--初始频率
			TargetAmplitude = 0.08,		--目标强度
			TargetFrequency = 10,		--目标频率
			AmplitudeChangeTime = 0.3,	--强度变化时间
			FrequencyChangeTime = 0,	--频率变化时间
			DurationTime = 0.15,		--震屏持续时间
			Sign = 1,					--震屏标识，同类标识新覆盖旧震屏
			DistanceDampingId = 0,		--震屏强度距离衰减
		},
	},]]--
	HitType = 1,
	HitParams = {						--受击必须参数，不可缺少，不用填0
		SpeedZ = 0,						--地面受击击退初速度，可为负
		SpeedZAcceleration = 0,		--地面受击击退加速度，可为负
		SpeedZTime = 0,				--地面受击击退时间，必须小于受击动作时间
		SpeedY = 0,						--击飞受击垂直初速度
		SpeedZHitFly = 0,				--击飞受击水平初速度
		SpeedYAcceleration = 0,			--击飞受击垂直加速度
		SpeedYAccelerationTime = 0,		--击飞受击垂直加速度持续时间
		SpeedYAloft = 2.8,				--空中再受击垂直速度(set)
		SpeedZAloft = 1,				--空中再受击水平速度(set)
	},
	LookatType = 3,
}
Config.AttackConfig[1003003003] = {
	ShapeType = 1,
	Radius = 30000,
	MagicsBySelf = {
		--[1] = 1001001--
	},
	MagicsByTarget = {
		--[1] = 1001001--
		[1] = 1003001,
		[2] = 1003007,
	},
	CameraShakes = {
		[1] = {
			ShakeType = 2,				--震屏类型
			StartAmplitude = 0.12,		--初始强度
			StartFrequency = 10,		--初始频率
			TargetAmplitude = 0.08,		--目标强度
			TargetFrequency = 10,		--目标频率
			AmplitudeChangeTime = 0.3,	--强度变化时间
			FrequencyChangeTime = 0,	--频率变化时间
			DurationTime = 0.15,		--震屏持续时间
			Sign = 1,					--震屏标识，同类标识新覆盖旧震屏
			DistanceDampingId = 0,		--震屏强度距离衰减
		},
	},
	HitType = 1,
	HitParams = {						--受击必须参数，不可缺少，不用填0
		SpeedZ = 0,						--地面受击击退初速度，可为负
		SpeedZAcceleration = 0,		--地面受击击退加速度，可为负
		SpeedZTime = 0,				--地面受击击退时间，必须小于受击动作时间
		SpeedY = 0,						--击飞受击垂直初速度
		SpeedZHitFly = 0,				--击飞受击水平初速度
		SpeedYAcceleration = 0,			--击飞受击垂直加速度
		SpeedYAccelerationTime = 0,		--击飞受击垂直加速度持续时间
		SpeedYAloft = 2.8,				--空中再受击垂直速度(set)
		SpeedZAloft = 1,				--空中再受击水平速度(set)
	},
	LookatType = 3,
}
Config.AttackConfig[1003003004] = {
	ShapeType = 1,
	Radius = 30000,
	MagicsBySelf = {
		--[1] = 1001001--
	},
	MagicsByTarget = {
		--[1] = 1001001--
		[1] = 1003001,
		[2] = 1003008,
	},
	CameraShakes = {
		[1] = {
			ShakeType = 3,				--震屏类型
			StartAmplitude = -0.15,		--初始强度
			StartFrequency = 10,		--初始频率
			TargetAmplitude = -0.1,		--目标强度
			TargetFrequency = 10,		--目标频率
			AmplitudeChangeTime = 0.2,	--强度变化时间
			FrequencyChangeTime = 0,	--频率变化时间
			DurationTime = 0.25,		--震屏持续时间
			Sign = 1,					--震屏标识，同类标识新覆盖旧震屏
			DistanceDampingId = 0,		--震屏强度距离衰减
		},
	},
	HitType = 1,
	HitParams = {						--受击必须参数，不可缺少，不用填0
		SpeedZ = 0,						--地面受击击退初速度，可为负
		SpeedZAcceleration = 0,		--地面受击击退加速度，可为负
		SpeedZTime = 0,				--地面受击击退时间，必须小于受击动作时间
		SpeedY = 0,						--击飞受击垂直初速度
		SpeedZHitFly = 0,				--击飞受击水平初速度
		SpeedYAcceleration = 0,			--击飞受击垂直加速度
		SpeedYAccelerationTime = 0,		--击飞受击垂直加速度持续时间
		SpeedYAloft = 2.8,				--空中再受击垂直速度(set)
		SpeedZAloft = 1,				--空中再受击水平速度(set)
	},
	LookatType = 3,
}
Config.AttackConfig[1003004001] = {
	ShapeType = 1,
	Radius = 30000,
	MagicsBySelf = {
		--[1] = 1001001--
	},
	MagicsByTarget = {
		--[1] = 1001001--
		[1] = 1003001,
		[2] = 1003009,
	},
	CameraShakes = {
		[1] = {
			ShakeType = 3,				--震屏类型
			StartAmplitude = -0.3,		--初始强度
			StartFrequency = 10,		--初始频率
			TargetAmplitude = -0.1,		--目标强度
			TargetFrequency = 10,		--目标频率
			AmplitudeChangeTime = 0.3,	--强度变化时间
			FrequencyChangeTime = 0,	--频率变化时间
			DurationTime = 0.25,		--震屏持续时间
			Sign = 1,					--震屏标识，同类标识新覆盖旧震屏
			DistanceDampingId = 0,		--震屏强度距离衰减
		},
	},
	HitType = 2,
	HitParams = {						--受击必须参数，不可缺少，不用填0
		SpeedZ = 0,						--地面受击击退初速度，可为负
		SpeedZAcceleration = 0,		--地面受击击退加速度，可为负
		SpeedZTime = 0,				--地面受击击退时间，必须小于受击动作时间
		SpeedY = 0,						--击飞受击垂直初速度
		SpeedZHitFly = 0,				--击飞受击水平初速度
		SpeedYAcceleration = 0,			--击飞受击垂直加速度
		SpeedYAccelerationTime = 0,		--击飞受击垂直加速度持续时间
		SpeedYAloft = 2.8,				--空中再受击垂直速度(set)
		SpeedZAloft = 1,				--空中再受击水平速度(set)
	},
	LookatType = 3,
}
Config.AttackConfig[1003005001] = {
	ShapeType = 1,
	Radius = 30000,
	MagicsBySelf = {
		--[1] = 1001001--
	},
	MagicsByTarget = {
		--[1] = 1001001--
		[1] = 1003001,
		[2] = 1003010,
	},
	CameraShakes = {
		[1] = {
			ShakeType = 2,				--震屏类型
			StartAmplitude = 0.12,		--初始强度
			StartFrequency = 10,		--初始频率
			TargetAmplitude = 0.08,		--目标强度
			TargetFrequency = 10,		--目标频率
			AmplitudeChangeTime = 0.3,	--强度变化时间
			FrequencyChangeTime = 0,	--频率变化时间
			DurationTime = 0.15,		--震屏持续时间
			Sign = 1,					--震屏标识，同类标识新覆盖旧震屏
			DistanceDampingId = 0,		--震屏强度距离衰减
		},
	},
	HitType = 1,
	HitParams = {						--受击必须参数，不可缺少，不用填0
		SpeedZ = 0,						--地面受击击退初速度，可为负
		SpeedZAcceleration = 0,		--地面受击击退加速度，可为负
		SpeedZTime = 0,				--地面受击击退时间，必须小于受击动作时间
		SpeedY = 0,						--击飞受击垂直初速度
		SpeedZHitFly = 0,				--击飞受击水平初速度
		SpeedYAcceleration = 0,			--击飞受击垂直加速度
		SpeedYAccelerationTime = 0,		--击飞受击垂直加速度持续时间
		SpeedYAloft = 2.8,				--空中再受击垂直速度(set)
		SpeedZAloft = 1,				--空中再受击水平速度(set)
	},
	LookatType = 3,
}
Config.AttackConfig[1003005002] = {
	ShapeType = 1,
	Radius = 30000,
	MagicsBySelf = {
		--[1] = 1001001--
	},
	MagicsByTarget = {
		--[1] = 1001001--
		[1] = 1003001,
		[2] = 1003011,
	},
	--[[CameraShakes = {
		[1] = {
			ShakeType = 2,				--震屏类型
			StartAmplitude = 0.15,		--初始强度
			StartFrequency = 10,		--初始频率
			TargetAmplitude = 0.1,		--目标强度
			TargetFrequency = 10,		--目标频率
			AmplitudeChangeTime = 0.3,	--强度变化时间
			FrequencyChangeTime = 0,	--频率变化时间
			DurationTime = 0.15,		--震屏持续时间
			Sign = 1,					--震屏标识，同类标识新覆盖旧震屏
			DistanceDampingId = 0,		--震屏强度距离衰减
		},
	},]]--
	HitType = 1,
	HitParams = {						--受击必须参数，不可缺少，不用填0
		SpeedZ = 0,						--地面受击击退初速度，可为负
		SpeedZAcceleration = 0,		--地面受击击退加速度，可为负
		SpeedZTime = 0,				--地面受击击退时间，必须小于受击动作时间
		SpeedY = 0,						--击飞受击垂直初速度
		SpeedZHitFly = 0,				--击飞受击水平初速度
		SpeedYAcceleration = 0,			--击飞受击垂直加速度
		SpeedYAccelerationTime = 0,		--击飞受击垂直加速度持续时间
		SpeedYAloft = 2.8,				--空中再受击垂直速度(set)
		SpeedZAloft = 1,				--空中再受击水平速度(set)
	},
	LookatType = 3,
}
Config.AttackConfig[1003005003] = {
	ShapeType = 1,
	Radius = 30000,
	MagicsBySelf = {
		--[1] = 1001001--
	},
	MagicsByTarget = {
		--[1] = 1001001--
		[1] = 1003001,
		[2] = 1003012,
	},
	CameraShakes = {
		[1] = {
			ShakeType = 2,				--震屏类型
			StartAmplitude = -0.12,		--初始强度
			StartFrequency = 10,		--初始频率
			TargetAmplitude = -0.08,		--目标强度
			TargetFrequency = 10,		--目标频率
			AmplitudeChangeTime = 0.3,	--强度变化时间
			FrequencyChangeTime = 0,	--频率变化时间
			DurationTime = 0.15,		--震屏持续时间
			Sign = 1,					--震屏标识，同类标识新覆盖旧震屏
			DistanceDampingId = 0,		--震屏强度距离衰减
		},
	},
	HitType = 2,
	HitParams = {						--受击必须参数，不可缺少，不用填0
		SpeedZ = 0,						--地面受击击退初速度，可为负
		SpeedZAcceleration = 0,		--地面受击击退加速度，可为负
		SpeedZTime = 0,				--地面受击击退时间，必须小于受击动作时间
		SpeedY = 0,						--击飞受击垂直初速度
		SpeedZHitFly = 0,				--击飞受击水平初速度
		SpeedYAcceleration = 0,			--击飞受击垂直加速度
		SpeedYAccelerationTime = 0,		--击飞受击垂直加速度持续时间
		SpeedYAloft = 2.8,				--空中再受击垂直速度(set)
		SpeedZAloft = 1,				--空中再受击水平速度(set)
	},
	LookatType = 3,
}
Config.AttackConfig[1003005004] = {
	ShapeType = 1,
	Radius = 30000,
	MagicsBySelf = {
		--[1] = 1001001--
	},
	MagicsByTarget = {
		--[1] = 1001001--
		[1] = 1003001,
		[2] = 1003013,
	},
	CameraShakes = {
		[1] = {
			ShakeType = 2,				--震屏类型
			StartAmplitude = 0.12,		--初始强度
			StartFrequency = 10,		--初始频率
			TargetAmplitude = 0.08,		--目标强度
			TargetFrequency = 10,		--目标频率
			AmplitudeChangeTime = 0.3,	--强度变化时间
			FrequencyChangeTime = 0,	--频率变化时间
			DurationTime = 0.15,		--震屏持续时间
			Sign = 1,					--震屏标识，同类标识新覆盖旧震屏
			DistanceDampingId = 0,		--震屏强度距离衰减
		},
	},
	HitType = 1,
	HitParams = {						--受击必须参数，不可缺少，不用填0
		SpeedZ = 0,						--地面受击击退初速度，可为负
		SpeedZAcceleration = 0,		--地面受击击退加速度，可为负
		SpeedZTime = 0,				--地面受击击退时间，必须小于受击动作时间
		SpeedY = 0,						--击飞受击垂直初速度
		SpeedZHitFly = 0,				--击飞受击水平初速度
		SpeedYAcceleration = 0,			--击飞受击垂直加速度
		SpeedYAccelerationTime = 0,		--击飞受击垂直加速度持续时间
		SpeedYAloft = 2.8,				--空中再受击垂直速度(set)
		SpeedZAloft = 1,				--空中再受击水平速度(set)
	},
	LookatType = 3,
}
Config.AttackConfig[1003006001] = {
	ShapeType = 1,
	Radius = 30000,
	MagicsBySelf = {
		--[1] = 1001001--
	},
	MagicsByTarget = {
		--[1] = 1001001--
		[1] = 1003001,
		[2] = 1003014,
	},
	CameraShakes = {
		[1] = {
			ShakeType = 3,				--震屏类型
			StartAmplitude = 0.15,		--初始强度
			StartFrequency = 10,		--初始频率
			TargetAmplitude = 0.1,		--目标强度
			TargetFrequency = 10,		--目标频率
			AmplitudeChangeTime = 0.25,	--强度变化时间
			FrequencyChangeTime = 0,	--频率变化时间
			DurationTime = 0.25,		--震屏持续时间
			Sign = 1,					--震屏标识，同类标识新覆盖旧震屏
			DistanceDampingId = 0,		--震屏强度距离衰减
		},
		[2] = {
			ShakeType = 4,				--震屏类型
			StartAmplitude = 0.2,		--初始强度
			StartFrequency = 10,		--初始频率
			TargetAmplitude = 0.1,		--目标强度
			TargetFrequency = 10,		--目标频率
			AmplitudeChangeTime = 0.15,	--强度变化时间
			FrequencyChangeTime = 0,	--频率变化时间
			DurationTime = 0.25,		--震屏持续时间
			Sign = 1,					--震屏标识，同类标识新覆盖旧震屏
			DistanceDampingId = 0,		--震屏强度距离衰减
		},
	},
	HitType = 2,
	HitParams = {						--受击必须参数，不可缺少，不用填0
		SpeedZ = 0,						--地面受击击退初速度，可为负
		SpeedZAcceleration = 0,		--地面受击击退加速度，可为负
		SpeedZTime = 0,				--地面受击击退时间，必须小于受击动作时间
		SpeedY = 0,						--击飞受击垂直初速度
		SpeedZHitFly = 0,				--击飞受击水平初速度
		SpeedYAcceleration = 0,			--击飞受击垂直加速度
		SpeedYAccelerationTime = 0,		--击飞受击垂直加速度持续时间
		SpeedYAloft = 2.8,				--空中再受击垂直速度(set)
		SpeedZAloft = 1,				--空中再受击水平速度(set)
	},
	LookatType = 3,
}
Config.AttackConfig[1003009001] = {
	ShapeType = 1,
	Radius = 50000,
	MagicsBySelf = {
		--[1] = 1001001--
	},
	MagicsByTarget = {
		--[1] = 1001001--
		[1] = 1003001,
		[2] = 1003002,
	},
	CameraShakes = {
		[1] = {
			ShakeType = 2,				--震屏类型
			StartAmplitude = -0.15,		--初始强度
			StartFrequency = 10,		--初始频率
			TargetAmplitude = -0.08,		--目标强度
			TargetFrequency = 10,		--目标频率
			AmplitudeChangeTime = 0.15,	--强度变化时间
			FrequencyChangeTime = 0,	--频率变化时间
			DurationTime = 0.15,		--震屏持续时间
			Sign = 1,					--震屏标识，同类标识新覆盖旧震屏
			DistanceDampingId = 0,		--震屏强度距离衰减
		},
	},
	HitType = 1,
	HitParams = {						--受击必须参数，不可缺少，不用填0
		SpeedZ = 0,						--地面受击击退初速度，可为负
		SpeedZAcceleration = 0,		--地面受击击退加速度，可为负
		SpeedZTime = 0,				--地面受击击退时间，必须小于受击动作时间
		SpeedY = 0,						--击飞受击垂直初速度
		SpeedZHitFly = 0,				--击飞受击水平初速度
		SpeedYAcceleration = 0,			--击飞受击垂直加速度
		SpeedYAccelerationTime = 0,		--击飞受击垂直加速度持续时间
		SpeedYAloft = 2.8,				--空中再受击垂直速度(set)
		SpeedZAloft = 1,				--空中再受击水平速度(set)
	},
	LookatType = 3,
}
Config.AttackConfig[1003009002] = {
	ShapeType = 1,
	Radius = 50000,
	MagicsBySelf = {
		--[1] = 1001001--
	},
	MagicsByTarget = {
		--[1] = 1001001--
		[1] = 1003001,
		[2] = 1003002,
	},
	CameraShakes = {
		[1] = {
			ShakeType = 3,				--震屏类型
			StartAmplitude = 0.3,		--初始强度
			StartFrequency = 10,		--初始频率
			TargetAmplitude = 0.1,		--目标强度
			TargetFrequency = 10,		--目标频率
			AmplitudeChangeTime = 0.2,	--强度变化时间
			FrequencyChangeTime = 0,	--频率变化时间
			DurationTime = 0.15,		--震屏持续时间
			Sign = 1,					--震屏标识，同类标识新覆盖旧震屏
			DistanceDampingId = 0,		--震屏强度距离衰减
		},
	},
	HitType = 1,
	HitParams = {						--受击必须参数，不可缺少，不用填0
		SpeedZ = 0,						--地面受击击退初速度，可为负
		SpeedZAcceleration = 0,		--地面受击击退加速度，可为负
		SpeedZTime = 0,				--地面受击击退时间，必须小于受击动作时间
		SpeedY = 0,						--击飞受击垂直初速度
		SpeedZHitFly = 0,				--击飞受击水平初速度
		SpeedYAcceleration = 0,			--击飞受击垂直加速度
		SpeedYAccelerationTime = 0,		--击飞受击垂直加速度持续时间
		SpeedYAloft = 2.8,				--空中再受击垂直速度(set)
		SpeedZAloft = 1,				--空中再受击水平速度(set)
	},
	LookatType = 3,
}
Config.AttackConfig[1003010001] = {
	ShapeType = 1,
	Radius = 50000,
	MagicsBySelf = {
		--[1] = 1001001--
	},
	MagicsByTarget = {
		--[1] = 1001001--
		[1] = 1003001,
		[2] = 1003002,
	},
	CameraShakes = {
		[1] = {
			ShakeType = 2,				--震屏类型
			StartAmplitude = -0.15,		--初始强度
			StartFrequency = 10,		--初始频率
			TargetAmplitude = -0.08,		--目标强度
			TargetFrequency = 10,		--目标频率
			AmplitudeChangeTime = 0.15,	--强度变化时间
			FrequencyChangeTime = 0,	--频率变化时间
			DurationTime = 0.15,		--震屏持续时间
			Sign = 1,					--震屏标识，同类标识新覆盖旧震屏
			DistanceDampingId = 0,		--震屏强度距离衰减
		},
	},
	HitType = 1,
	HitParams = {						--受击必须参数，不可缺少，不用填0
		SpeedZ = 0,						--地面受击击退初速度，可为负
		SpeedZAcceleration = 0,		--地面受击击退加速度，可为负
		SpeedZTime = 0,				--地面受击击退时间，必须小于受击动作时间
		SpeedY = 0,						--击飞受击垂直初速度
		SpeedZHitFly = 0,				--击飞受击水平初速度
		SpeedYAcceleration = 0,			--击飞受击垂直加速度
		SpeedYAccelerationTime = 0,		--击飞受击垂直加速度持续时间
		SpeedYAloft = 2.8,				--空中再受击垂直速度(set)
		SpeedZAloft = 1,				--空中再受击水平速度(set)
	},
	LookatType = 3,
}
Config.AttackConfig[1003010002] = {
	ShapeType = 1,
	Radius = 50000,
	MagicsBySelf = {
		--[1] = 1001001--
	},
	MagicsByTarget = {
		--[1] = 1001001--
		[1] = 1003001,
		[2] = 1003002,
	},
	CameraShakes = {
		[1] = {
			ShakeType = 3,				--震屏类型
			StartAmplitude = 0.3,		--初始强度
			StartFrequency = 10,		--初始频率
			TargetAmplitude = 0.1,		--目标强度
			TargetFrequency = 10,		--目标频率
			AmplitudeChangeTime = 0.2,	--强度变化时间
			FrequencyChangeTime = 0,	--频率变化时间
			DurationTime = 0.15,		--震屏持续时间
			Sign = 1,					--震屏标识，同类标识新覆盖旧震屏
			DistanceDampingId = 0,		--震屏强度距离衰减
		},
	},
	HitType = 1,
	HitParams = {						--受击必须参数，不可缺少，不用填0
		SpeedZ = 0,						--地面受击击退初速度，可为负
		SpeedZAcceleration = 0,		--地面受击击退加速度，可为负
		SpeedZTime = 0,				--地面受击击退时间，必须小于受击动作时间
		SpeedY = 0,						--击飞受击垂直初速度
		SpeedZHitFly = 0,				--击飞受击水平初速度
		SpeedYAcceleration = 0,			--击飞受击垂直加速度
		SpeedYAccelerationTime = 0,		--击飞受击垂直加速度持续时间
		SpeedYAloft = 2.8,				--空中再受击垂直速度(set)
		SpeedZAloft = 1,				--空中再受击水平速度(set)
	},
	LookatType = 3,
}
Config.AttackConfig[1003010003] = {
	ShapeType = 1,
	Radius = 50000,
	MagicsBySelf = {
		--[1] = 1001001--
	},
	MagicsByTarget = {
		--[1] = 1001001--
		[1] = 1003001,
		[2] = 1003002,
	},
	CameraShakes = {
		[1] = {
			ShakeType = 2,				--震屏类型
			StartAmplitude = 0.08,		--初始强度
			StartFrequency = 10,		--初始频率
			TargetAmplitude = 0.05,		--目标强度
			TargetFrequency = 10,		--目标频率
			AmplitudeChangeTime = 0.15,	--强度变化时间
			FrequencyChangeTime = 0,	--频率变化时间
			DurationTime = 0.1,			--震屏持续时间
			Sign = 1,					--震屏标识，同类标识新覆盖旧震屏
			DistanceDampingId = 0,		--震屏强度距离衰减
		},
	},
	HitType = 1,
	HitParams = {						--受击必须参数，不可缺少，不用填0
		SpeedZ = 0,						--地面受击击退初速度，可为负
		SpeedZAcceleration = 0,		--地面受击击退加速度，可为负
		SpeedZTime = 0,				--地面受击击退时间，必须小于受击动作时间
		SpeedY = 0,						--击飞受击垂直初速度
		SpeedZHitFly = 0,				--击飞受击水平初速度
		SpeedYAcceleration = 0,			--击飞受击垂直加速度
		SpeedYAccelerationTime = 0,		--击飞受击垂直加速度持续时间
		SpeedYAloft = 2.8,				--空中再受击垂直速度(set)
		SpeedZAloft = 1,				--空中再受击水平速度(set)
	},
	LookatType = 3,
}
Config.AttackConfig[1003010004] = {
	ShapeType = 1,
	Radius = 50000,
	MagicsBySelf = {
		--[1] = 1001001--
	},
	MagicsByTarget = {
		--[1] = 1001001--
		[1] = 1003001,
		[2] = 1003002,
	},
	CameraShakes = {
		[1] = {
			ShakeType = 2,				--震屏类型
			StartAmplitude = 0.08,		--初始强度
			StartFrequency = 10,		--初始频率
			TargetAmplitude = 0.05,		--目标强度
			TargetFrequency = 10,		--目标频率
			AmplitudeChangeTime = 0.15,	--强度变化时间
			FrequencyChangeTime = 0,	--频率变化时间
			DurationTime = 0.1,			--震屏持续时间
			Sign = 1,					--震屏标识，同类标识新覆盖旧震屏
			DistanceDampingId = 0,		--震屏强度距离衰减
		},
	},
	HitType = 1,
	HitParams = {						--受击必须参数，不可缺少，不用填0
		SpeedZ = 0,						--地面受击击退初速度，可为负
		SpeedZAcceleration = 0,		--地面受击击退加速度，可为负
		SpeedZTime = 0,				--地面受击击退时间，必须小于受击动作时间
		SpeedY = 0,						--击飞受击垂直初速度
		SpeedZHitFly = 0,				--击飞受击水平初速度
		SpeedYAcceleration = 0,			--击飞受击垂直加速度
		SpeedYAccelerationTime = 0,		--击飞受击垂直加速度持续时间
		SpeedYAloft = 2.8,				--空中再受击垂直速度(set)
		SpeedZAloft = 1,				--空中再受击水平速度(set)
	},
	LookatType = 3,
}
Config.AttackConfig[1003010005] = {
	ShapeType = 1,
	Radius = 50000,
	MagicsBySelf = {
		--[1] = 1001001--
	},
	MagicsByTarget = {
		--[1] = 1001001--
		[1] = 1003001,
		[2] = 1003002,
	},
	CameraShakes = {
		[1] = {
			ShakeType = 2,				--震屏类型
			StartAmplitude = 0.12,		--初始强度
			StartFrequency = 10,		--初始频率
			TargetAmplitude = 0.08,		--目标强度
			TargetFrequency = 10,		--目标频率
			AmplitudeChangeTime = 0.15,	--强度变化时间
			FrequencyChangeTime = 0,	--频率变化时间
			DurationTime = 0.1,			--震屏持续时间
			Sign = 1,					--震屏标识，同类标识新覆盖旧震屏
			DistanceDampingId = 0,		--震屏强度距离衰减
		},
	},
	HitType = 1,
	HitParams = {						--受击必须参数，不可缺少，不用填0
		SpeedZ = 0,						--地面受击击退初速度，可为负
		SpeedZAcceleration = 0,		--地面受击击退加速度，可为负
		SpeedZTime = 0,				--地面受击击退时间，必须小于受击动作时间
		SpeedY = 0,						--击飞受击垂直初速度
		SpeedZHitFly = 0,				--击飞受击水平初速度
		SpeedYAcceleration = 0,			--击飞受击垂直加速度
		SpeedYAccelerationTime = 0,		--击飞受击垂直加速度持续时间
		SpeedYAloft = 2.8,				--空中再受击垂直速度(set)
		SpeedZAloft = 1,				--空中再受击水平速度(set)
	},
	LookatType = 3,
}
Config.AttackConfig[1003010006] = {
	ShapeType = 1,
	Radius = 50000,
	MagicsBySelf = {
		--[1] = 1001001--
	},
	MagicsByTarget = {
		--[1] = 1001001--
		[1] = 1003001,
		[2] = 1003002,
	},
	CameraShakes = {
		[1] = {
			ShakeType = 2,				--震屏类型
			StartAmplitude = 0.2,		--初始强度
			StartFrequency = 10,		--初始频率
			TargetAmplitude = 0.1,		--目标强度
			TargetFrequency = 10,		--目标频率
			AmplitudeChangeTime = 0.3,	--强度变化时间
			FrequencyChangeTime = 0,	--频率变化时间
			DurationTime = 0.25,		--震屏持续时间
			Sign = 1,					--震屏标识，同类标识新覆盖旧震屏
			DistanceDampingId = 0,		--震屏强度距离衰减
		},
	},
	HitType = 1,
	HitParams = {						--受击必须参数，不可缺少，不用填0
		SpeedZ = 0,						--地面受击击退初速度，可为负
		SpeedZAcceleration = 0,		--地面受击击退加速度，可为负
		SpeedZTime = 0,				--地面受击击退时间，必须小于受击动作时间
		SpeedY = 0,						--击飞受击垂直初速度
		SpeedZHitFly = 0,				--击飞受击水平初速度
		SpeedYAcceleration = 0,			--击飞受击垂直加速度
		SpeedYAccelerationTime = 0,		--击飞受击垂直加速度持续时间
		SpeedYAloft = 2.8,				--空中再受击垂直速度(set)
		SpeedZAloft = 1,				--空中再受击水平速度(set)
	},
	LookatType = 3,
}
Config.AttackConfig[1003011001] = {
	ShapeType = 1,
	Radius = 50000,
	MagicsBySelf = {
		--[1] = 1001001--
	},
	MagicsByTarget = {
		--[1] = 1001001--
		[1] = 1003001,
		[2] = 1003002,
	},
	CameraShakes = {
		[1] = {
			ShakeType = 4,				--震屏类型
			StartAmplitude = 0.2,		--初始强度
			StartFrequency = 10,		--初始频率
			TargetAmplitude = 0.1,		--目标强度
			TargetFrequency = 10,		--目标频率
			AmplitudeChangeTime = 0.15,	--强度变化时间
			FrequencyChangeTime = 0,	--频率变化时间
			DurationTime = 0.15,		--震屏持续时间
			Sign = 1,					--震屏标识，同类标识新覆盖旧震屏
			DistanceDampingId = 0,		--震屏强度距离衰减
		},
	},
	HitType = 1,
	HitParams = {						--受击必须参数，不可缺少，不用填0
		SpeedZ = 0,						--地面受击击退初速度，可为负
		SpeedZAcceleration = 0,		--地面受击击退加速度，可为负
		SpeedZTime = 0,				--地面受击击退时间，必须小于受击动作时间
		SpeedY = 0,						--击飞受击垂直初速度
		SpeedZHitFly = 0,				--击飞受击水平初速度
		SpeedYAcceleration = 0,			--击飞受击垂直加速度
		SpeedYAccelerationTime = 0,		--击飞受击垂直加速度持续时间
		SpeedYAloft = 2.8,				--空中再受击垂直速度(set)
		SpeedZAloft = 1,				--空中再受击水平速度(set)
	},
	LookatType = 3,
}
Config.AttackConfig[1003011002] = {
	ShapeType = 1,
	Radius = 50000,
	MagicsBySelf = {
		--[1] = 1001001--
	},
	MagicsByTarget = {
		--[1] = 1001001--
		[1] = 1003001,
		[2] = 1003002,
	},
	CameraShakes = {
		[1] = {
			ShakeType = 2,				--震屏类型
			StartAmplitude = 0.3,		--初始强度
			StartFrequency = 10,		--初始频率
			TargetAmplitude = 0.15,		--目标强度
			TargetFrequency = 10,		--目标频率
			AmplitudeChangeTime = 0.15,	--强度变化时间
			FrequencyChangeTime = 0,	--频率变化时间
			DurationTime = 0.15,		--震屏持续时间
			Sign = 1,					--震屏标识，同类标识新覆盖旧震屏
			DistanceDampingId = 0,		--震屏强度距离衰减
		},
	},
	HitType = 1,
	HitParams = {						--受击必须参数，不可缺少，不用填0
		SpeedZ = 0,						--地面受击击退初速度，可为负
		SpeedZAcceleration = 0,		--地面受击击退加速度，可为负
		SpeedZTime = 0,				--地面受击击退时间，必须小于受击动作时间
		SpeedY = 0,						--击飞受击垂直初速度
		SpeedZHitFly = 0,				--击飞受击水平初速度
		SpeedYAcceleration = 0,			--击飞受击垂直加速度
		SpeedYAccelerationTime = 0,		--击飞受击垂直加速度持续时间
		SpeedYAloft = 2.8,				--空中再受击垂直速度(set)
		SpeedZAloft = 1,				--空中再受击水平速度(set)
	},
	LookatType = 3,
}
Config.AttackConfig[1003012001] = {
	ShapeType = 1,
	Radius = 50000,
	MagicsBySelf = {
		--[1] = 1001001--
	},
	MagicsByTarget = {
		--[1] = 1001001--
		[1] = 1003001,
		[2] = 1003002,
	},
	CameraShakes = {
		[1] = {
			ShakeType = 4,				--震屏类型
			StartAmplitude = 0.2,		--初始强度
			StartFrequency = 10,		--初始频率
			TargetAmplitude = 0.1,		--目标强度
			TargetFrequency = 10,		--目标频率
			AmplitudeChangeTime = 0.15,	--强度变化时间
			FrequencyChangeTime = 0,	--频率变化时间
			DurationTime = 0.15,		--震屏持续时间
			Sign = 1,					--震屏标识，同类标识新覆盖旧震屏
			DistanceDampingId = 0,		--震屏强度距离衰减
		},
	},
	HitType = 1,
	HitParams = {						--受击必须参数，不可缺少，不用填0
		SpeedZ = 0,						--地面受击击退初速度，可为负
		SpeedZAcceleration = 0,		--地面受击击退加速度，可为负
		SpeedZTime = 0,				--地面受击击退时间，必须小于受击动作时间
		SpeedY = 0,						--击飞受击垂直初速度
		SpeedZHitFly = 0,				--击飞受击水平初速度
		SpeedYAcceleration = 0,			--击飞受击垂直加速度
		SpeedYAccelerationTime = 0,		--击飞受击垂直加速度持续时间
		SpeedYAloft = 2.8,				--空中再受击垂直速度(set)
		SpeedZAloft = 1,				--空中再受击水平速度(set)
	},
	LookatType = 3,
}
Config.AttackConfig[1003012002] = {
	ShapeType = 1,
	Radius = 50000,
	MagicsBySelf = {
		--[1] = 1001001--
	},
	MagicsByTarget = {
		--[1] = 1001001--
		[1] = 1003001,
		[2] = 1003002,
	},
	CameraShakes = {
		[1] = {
			ShakeType = 2,				--震屏类型
			StartAmplitude = 0.3,		--初始强度
			StartFrequency = 10,		--初始频率
			TargetAmplitude = 0.15,		--目标强度
			TargetFrequency = 10,		--目标频率
			AmplitudeChangeTime = 0.15,	--强度变化时间
			FrequencyChangeTime = 0,	--频率变化时间
			DurationTime = 0.15,		--震屏持续时间
			Sign = 1,					--震屏标识，同类标识新覆盖旧震屏
			DistanceDampingId = 0,		--震屏强度距离衰减
		},
	},
	HitType = 1,
	HitParams = {						--受击必须参数，不可缺少，不用填0
		SpeedZ = 0,						--地面受击击退初速度，可为负
		SpeedZAcceleration = 0,		--地面受击击退加速度，可为负
		SpeedZTime = 0,				--地面受击击退时间，必须小于受击动作时间
		SpeedY = 0,						--击飞受击垂直初速度
		SpeedZHitFly = 0,				--击飞受击水平初速度
		SpeedYAcceleration = 0,			--击飞受击垂直加速度
		SpeedYAccelerationTime = 0,		--击飞受击垂直加速度持续时间
		SpeedYAloft = 2.8,				--空中再受击垂直速度(set)
		SpeedZAloft = 1,				--空中再受击水平速度(set)
	},
	LookatType = 3,
}


Config.AttackConfig[1004001001] = {
	ShapeType = 1,
	Radius = 50000,
	MagicsBySelf = {
		--[1] = 1001001--
		--[1] = 1004003
	},
	MagicsByTarget = {
		--[1] = 1001001--
		[1] = 1004001,
		[2] = 1004002,
	},
	CameraShakes = {
		--[1] = {
			--ShakeType = 2,				--震屏类型
			--StartAmplitude = 0.15,		--初始强度
			--StartFrequency = 10,		--初始频率
			--TargetAmplitude = 0,		--目标强度
			--TargetFrequency = 10,		--目标频率
			--AmplitudeChangeTime = 0.3,	--强度变化时间
			--FrequencyChangeTime = 0,	--频率变化时间
			--DurationTime = 0.15,		--震屏持续时间
			--Sign = 1,					--震屏标识，同类标识新覆盖旧震屏
			--DistanceDampingId = 0,		--震屏强度距离衰减
		--},
	},
	HitType = 2,
	HitParams = {						--受击必须参数，不可缺少，不用填0
		SpeedZ = 0,						--地面受击击退初速度，可为负
		SpeedZAcceleration = 0,		--地面受击击退加速度，可为负
		SpeedZTime = 0,				--地面受击击退时间，必须小于受击动作时间
		SpeedY = 0,						--击飞受击垂直初速度
		SpeedZHitFly = 0,				--击飞受击水平初速度
		SpeedYAcceleration = 0,			--击飞受击垂直加速度
		SpeedYAccelerationTime = 0,		--击飞受击垂直加速度持续时间
		SpeedYAloft = 2.8,				--空中再受击垂直速度(set)
		SpeedZAloft = 1,				--空中再受击水平速度(set)
	},
	LookatType = 3,
}
Config.AttackConfig[1004002001] = {
	ShapeType = 1,
	Radius = 50000,
	MagicsBySelf = {
		--[1] = 1001001--
	},
	MagicsByTarget = {
		--[1] = 1001001--
		[1] = 1004001,
		[2] = 1004002,
	},
	CameraShakes = {
		--[1] = {
		--ShakeType = 2,				--震屏类型
		--StartAmplitude = 0.15,		--初始强度
		--StartFrequency = 10,		--初始频率
		--TargetAmplitude = 0,		--目标强度
		--TargetFrequency = 10,		--目标频率
		--AmplitudeChangeTime = 0.3,	--强度变化时间
		--FrequencyChangeTime = 0,	--频率变化时间
		--DurationTime = 0.15,		--震屏持续时间
		--Sign = 1,					--震屏标识，同类标识新覆盖旧震屏
		--DistanceDampingId = 0,		--震屏强度距离衰减
		--},
	},
	HitType = 1,
	HitParams = {						--受击必须参数，不可缺少，不用填0
		SpeedZ = 0,						--地面受击击退初速度，可为负
		SpeedZAcceleration = 0,		--地面受击击退加速度，可为负
		SpeedZTime = 0,				--地面受击击退时间，必须小于受击动作时间
		SpeedY = 0,						--击飞受击垂直初速度
		SpeedZHitFly = 0,				--击飞受击水平初速度
		SpeedYAcceleration = 0,			--击飞受击垂直加速度
		SpeedYAccelerationTime = 0,		--击飞受击垂直加速度持续时间
		SpeedYAloft = 2.8,				--空中再受击垂直速度(set)
		SpeedZAloft = 1,				--空中再受击水平速度(set)
	},
	LookatType = 3,
}
Config.AttackConfig[1004002002] = {
	ShapeType = 1,
	Radius = 50000,
	MagicsBySelf = {
		--[1] = 1001001--
	},
	MagicsByTarget = {
		--[1] = 1001001--
		[1] = 1004001,
		[2] = 1004002,
	},
	CameraShakes = {
		--[1] = {
		--ShakeType = 2,				--震屏类型
		--StartAmplitude = 0.15,		--初始强度
		--StartFrequency = 10,		--初始频率
		--TargetAmplitude = 0,		--目标强度
		--TargetFrequency = 10,		--目标频率
		--AmplitudeChangeTime = 0.3,	--强度变化时间
		--FrequencyChangeTime = 0,	--频率变化时间
		--DurationTime = 0.15,		--震屏持续时间
		--Sign = 1,					--震屏标识，同类标识新覆盖旧震屏
		--DistanceDampingId = 0,		--震屏强度距离衰减
		--},
	},
	HitType = 1,
	HitParams = {						--受击必须参数，不可缺少，不用填0
		SpeedZ = 0,						--地面受击击退初速度，可为负
		SpeedZAcceleration = 0,		--地面受击击退加速度，可为负
		SpeedZTime = 0,				--地面受击击退时间，必须小于受击动作时间
		SpeedY = 0,						--击飞受击垂直初速度
		SpeedZHitFly = 0,				--击飞受击水平初速度
		SpeedYAcceleration = 0,			--击飞受击垂直加速度
		SpeedYAccelerationTime = 0,		--击飞受击垂直加速度持续时间
		SpeedYAloft = 2.8,				--空中再受击垂直速度(set)
		SpeedZAloft = 1,				--空中再受击水平速度(set)
	},
	LookatType = 3,
}
Config.AttackConfig[1004003001] = {
	ShapeType = 1,
	Radius = 50000,
	MagicsBySelf = {
		--[1] = 1001001--
	},
	MagicsByTarget = {
		--[1] = 1001001--
		[1] = 1004001,
		[2] = 1004002,
	},
	CameraShakes = {
		--[1] = {
		--ShakeType = 2,				--震屏类型
		--StartAmplitude = 0.15,		--初始强度
		--StartFrequency = 10,		--初始频率
		--TargetAmplitude = 0,		--目标强度
		--TargetFrequency = 10,		--目标频率
		--AmplitudeChangeTime = 0.3,	--强度变化时间
		--FrequencyChangeTime = 0,	--频率变化时间
		--DurationTime = 0.15,		--震屏持续时间
		--Sign = 1,					--震屏标识，同类标识新覆盖旧震屏
		--DistanceDampingId = 0,		--震屏强度距离衰减
		--},
	},
	HitType = 2,
	HitParams = {						--受击必须参数，不可缺少，不用填0
		SpeedZ = 0,						--地面受击击退初速度，可为负
		SpeedZAcceleration = 0,		--地面受击击退加速度，可为负
		SpeedZTime = 0,				--地面受击击退时间，必须小于受击动作时间
		SpeedY = 0,						--击飞受击垂直初速度
		SpeedZHitFly = 0,				--击飞受击水平初速度
		SpeedYAcceleration = 0,			--击飞受击垂直加速度
		SpeedYAccelerationTime = 0,		--击飞受击垂直加速度持续时间
		SpeedYAloft = 2.8,				--空中再受击垂直速度(set)
		SpeedZAloft = 1,				--空中再受击水平速度(set)
	},
	LookatType = 3,
}
Config.AttackConfig[1004003002] = {
	ShapeType = 1,
	Radius = 50000,
	MagicsBySelf = {
		--[1] = 1001001--
	},
	MagicsByTarget = {
		--[1] = 1001001--
		[1] = 1004001,
		[2] = 1004002,
	},
	CameraShakes = {
		--[1] = {
		--ShakeType = 2,				--震屏类型
		--StartAmplitude = 0.15,		--初始强度
		--StartFrequency = 10,		--初始频率
		--TargetAmplitude = 0,		--目标强度
		--TargetFrequency = 10,		--目标频率
		--AmplitudeChangeTime = 0.3,	--强度变化时间
		--FrequencyChangeTime = 0,	--频率变化时间
		--DurationTime = 0.15,		--震屏持续时间
		--Sign = 1,					--震屏标识，同类标识新覆盖旧震屏
		--DistanceDampingId = 0,		--震屏强度距离衰减
		--},
	},
	HitType = 1,
	HitParams = {						--受击必须参数，不可缺少，不用填0
		SpeedZ = 0,						--地面受击击退初速度，可为负
		SpeedZAcceleration = 0,		--地面受击击退加速度，可为负
		SpeedZTime = 0,				--地面受击击退时间，必须小于受击动作时间
		SpeedY = 0,						--击飞受击垂直初速度
		SpeedZHitFly = 0,				--击飞受击水平初速度
		SpeedYAcceleration = 0,			--击飞受击垂直加速度
		SpeedYAccelerationTime = 0,		--击飞受击垂直加速度持续时间
		SpeedYAloft = 2.8,				--空中再受击垂直速度(set)
		SpeedZAloft = 1,				--空中再受击水平速度(set)
	},
	LookatType = 3,
}
Config.AttackConfig[1004003003] = {
	ShapeType = 1,
	Radius = 50000,
	MagicsBySelf = {
		--[1] = 1001001--
	},
	MagicsByTarget = {
		--[1] = 1001001--
		[1] = 1004001,
		[2] = 1004002,
	},
	CameraShakes = {
		--[1] = {
		--ShakeType = 2,				--震屏类型
		--StartAmplitude = 0.15,		--初始强度
		--StartFrequency = 10,		--初始频率
		--TargetAmplitude = 0,		--目标强度
		--TargetFrequency = 10,		--目标频率
		--AmplitudeChangeTime = 0.3,	--强度变化时间
		--FrequencyChangeTime = 0,	--频率变化时间
		--DurationTime = 0.15,		--震屏持续时间
		--Sign = 1,					--震屏标识，同类标识新覆盖旧震屏
		--DistanceDampingId = 0,		--震屏强度距离衰减
		--},
	},
	HitType = 1,
	HitParams = {						--受击必须参数，不可缺少，不用填0
		SpeedZ = 0,						--地面受击击退初速度，可为负
		SpeedZAcceleration = 0,		--地面受击击退加速度，可为负
		SpeedZTime = 0,				--地面受击击退时间，必须小于受击动作时间
		SpeedY = 0,						--击飞受击垂直初速度
		SpeedZHitFly = 0,				--击飞受击水平初速度
		SpeedYAcceleration = 0,			--击飞受击垂直加速度
		SpeedYAccelerationTime = 0,		--击飞受击垂直加速度持续时间
		SpeedYAloft = 2.8,				--空中再受击垂直速度(set)
		SpeedZAloft = 1,				--空中再受击水平速度(set)
	},
	LookatType = 3,
}
Config.AttackConfig[1004004001] = {
	ShapeType = 1,
	Radius = 50000,
	MagicsBySelf = {
		--[1] = 1001001--
	},
	MagicsByTarget = {
		--[1] = 1001001--
		[1] = 1004001,
		[2] = 1004002,
	},
	CameraShakes = {
		--[1] = {
		--ShakeType = 2,				--震屏类型
		--StartAmplitude = 0.15,		--初始强度
		--StartFrequency = 10,		--初始频率
		--TargetAmplitude = 0,		--目标强度
		--TargetFrequency = 10,		--目标频率
		--AmplitudeChangeTime = 0.3,	--强度变化时间
		--FrequencyChangeTime = 0,	--频率变化时间
		--DurationTime = 0.15,		--震屏持续时间
		--Sign = 1,					--震屏标识，同类标识新覆盖旧震屏
		--DistanceDampingId = 0,		--震屏强度距离衰减
		--},
	},
	HitType = 2,
	HitParams = {						--受击必须参数，不可缺少，不用填0
		SpeedZ = 0,						--地面受击击退初速度，可为负
		SpeedZAcceleration = 0,		--地面受击击退加速度，可为负
		SpeedZTime = 0,				--地面受击击退时间，必须小于受击动作时间
		SpeedY = 0,						--击飞受击垂直初速度
		SpeedZHitFly = 0,				--击飞受击水平初速度
		SpeedYAcceleration = 0,			--击飞受击垂直加速度
		SpeedYAccelerationTime = 0,		--击飞受击垂直加速度持续时间
		SpeedYAloft = 2.8,				--空中再受击垂直速度(set)
		SpeedZAloft = 1,				--空中再受击水平速度(set)
	},
	LookatType = 3,
}
Config.AttackConfig[1004004002] = {
	ShapeType = 1,
	Radius = 50000,
	MagicsBySelf = {
		--[1] = 1001001--
	},
	MagicsByTarget = {
		--[1] = 1001001--
		[1] = 1004001,
		[2] = 1004002,
	},
	CameraShakes = {
		--[1] = {
		--ShakeType = 2,				--震屏类型
		--StartAmplitude = 0.15,		--初始强度
		--StartFrequency = 10,		--初始频率
		--TargetAmplitude = 0,		--目标强度
		--TargetFrequency = 10,		--目标频率
		--AmplitudeChangeTime = 0.3,	--强度变化时间
		--FrequencyChangeTime = 0,	--频率变化时间
		--DurationTime = 0.15,		--震屏持续时间
		--Sign = 1,					--震屏标识，同类标识新覆盖旧震屏
		--DistanceDampingId = 0,		--震屏强度距离衰减
		--},
	},
	HitType = 2,
	HitParams = {						--受击必须参数，不可缺少，不用填0
		SpeedZ = 0,						--地面受击击退初速度，可为负
		SpeedZAcceleration = 0,		--地面受击击退加速度，可为负
		SpeedZTime = 0,				--地面受击击退时间，必须小于受击动作时间
		SpeedY = 0,						--击飞受击垂直初速度
		SpeedZHitFly = 0,				--击飞受击水平初速度
		SpeedYAcceleration = 0,			--击飞受击垂直加速度
		SpeedYAccelerationTime = 0,		--击飞受击垂直加速度持续时间
		SpeedYAloft = 2.8,				--空中再受击垂直速度(set)
		SpeedZAloft = 1,				--空中再受击水平速度(set)
	},
	LookatType = 3,
}
Config.AttackConfig[1004005001] = {
	ShapeType = 1,
	Radius = 50000,
	MagicsBySelf = {
		--[1] = 1001001--
	},
	MagicsByTarget = {
		--[1] = 1001001--
		[1] = 1004001,
		[2] = 1004002,
	},
	CameraShakes = {
		--[1] = {
		--ShakeType = 2,				--震屏类型
		--StartAmplitude = 0.15,		--初始强度
		--StartFrequency = 10,		--初始频率
		--TargetAmplitude = 0,		--目标强度
		--TargetFrequency = 10,		--目标频率
		--AmplitudeChangeTime = 0.3,	--强度变化时间
		--FrequencyChangeTime = 0,	--频率变化时间
		--DurationTime = 0.15,		--震屏持续时间
		--Sign = 1,					--震屏标识，同类标识新覆盖旧震屏
		--DistanceDampingId = 0,		--震屏强度距离衰减
		--},
	},
	HitType = 1,
	HitParams = {						--受击必须参数，不可缺少，不用填0
		SpeedZ = 0,						--地面受击击退初速度，可为负
		SpeedZAcceleration = 0,		--地面受击击退加速度，可为负
		SpeedZTime = 0,				--地面受击击退时间，必须小于受击动作时间
		SpeedY = 0,						--击飞受击垂直初速度
		SpeedZHitFly = 0,				--击飞受击水平初速度
		SpeedYAcceleration = 0,			--击飞受击垂直加速度
		SpeedYAccelerationTime = 0,		--击飞受击垂直加速度持续时间
		SpeedYAloft = 2.8,				--空中再受击垂直速度(set)
		SpeedZAloft = 1,				--空中再受击水平速度(set)
	},
	LookatType = 3,
}
Config.AttackConfig[1004005002] = {
	ShapeType = 1,
	Radius = 50000,
	MagicsBySelf = {
		--[1] = 1001001--
	},
	MagicsByTarget = {
		--[1] = 1001001--
		[1] = 1004001,
		[2] = 1004002,
	},
	CameraShakes = {
		--[1] = {
		--ShakeType = 2,				--震屏类型
		--StartAmplitude = 0.15,		--初始强度
		--StartFrequency = 10,		--初始频率
		--TargetAmplitude = 0,		--目标强度
		--TargetFrequency = 10,		--目标频率
		--AmplitudeChangeTime = 0.3,	--强度变化时间
		--FrequencyChangeTime = 0,	--频率变化时间
		--DurationTime = 0.15,		--震屏持续时间
		--Sign = 1,					--震屏标识，同类标识新覆盖旧震屏
		--DistanceDampingId = 0,		--震屏强度距离衰减
		--},
	},
	HitType = 1,
	HitParams = {						--受击必须参数，不可缺少，不用填0
		SpeedZ = 0,						--地面受击击退初速度，可为负
		SpeedZAcceleration = 0,		--地面受击击退加速度，可为负
		SpeedZTime = 0,				--地面受击击退时间，必须小于受击动作时间
		SpeedY = 0,						--击飞受击垂直初速度
		SpeedZHitFly = 0,				--击飞受击水平初速度
		SpeedYAcceleration = 0,			--击飞受击垂直加速度
		SpeedYAccelerationTime = 0,		--击飞受击垂直加速度持续时间
		SpeedYAloft = 2.8,				--空中再受击垂直速度(set)
		SpeedZAloft = 1,				--空中再受击水平速度(set)
	},
	LookatType = 3,
}
Config.AttackConfig[1004005003] = {
	ShapeType = 1,
	Radius = 50000,
	MagicsBySelf = {
		--[1] = 1001001--
	},
	MagicsByTarget = {
		--[1] = 1001001--
		[1] = 1004001,
		[2] = 1004002,
	},
	CameraShakes = {
		--[1] = {
		--ShakeType = 2,				--震屏类型
		--StartAmplitude = 0.15,		--初始强度
		--StartFrequency = 10,		--初始频率
		--TargetAmplitude = 0,		--目标强度
		--TargetFrequency = 10,		--目标频率
		--AmplitudeChangeTime = 0.3,	--强度变化时间
		--FrequencyChangeTime = 0,	--频率变化时间
		--DurationTime = 0.15,		--震屏持续时间
		--Sign = 1,					--震屏标识，同类标识新覆盖旧震屏
		--DistanceDampingId = 0,		--震屏强度距离衰减
		--},
	},
	HitType = 2,
	HitParams = {						--受击必须参数，不可缺少，不用填0
		SpeedZ = 0,						--地面受击击退初速度，可为负
		SpeedZAcceleration = 0,		--地面受击击退加速度，可为负
		SpeedZTime = 0,				--地面受击击退时间，必须小于受击动作时间
		SpeedY = 0,						--击飞受击垂直初速度
		SpeedZHitFly = 0,				--击飞受击水平初速度
		SpeedYAcceleration = 0,			--击飞受击垂直加速度
		SpeedYAccelerationTime = 0,		--击飞受击垂直加速度持续时间
		SpeedYAloft = 2.8,				--空中再受击垂直速度(set)
		SpeedZAloft = 1,				--空中再受击水平速度(set)
	},
	LookatType = 3,
}
Config.AttackConfig[1004005004] = {
	ShapeType = 1,
	Radius = 50000,
	MagicsBySelf = {
		--[1] = 1001001--
	},
	MagicsByTarget = {
		--[1] = 1001001--
		[1] = 1004001,
		[2] = 1004002,
	},
	CameraShakes = {
		--[1] = {
		--ShakeType = 2,				--震屏类型
		--StartAmplitude = 0.15,		--初始强度
		--StartFrequency = 10,		--初始频率
		--TargetAmplitude = 0,		--目标强度
		--TargetFrequency = 10,		--目标频率
		--AmplitudeChangeTime = 0.3,	--强度变化时间
		--FrequencyChangeTime = 0,	--频率变化时间
		--DurationTime = 0.15,		--震屏持续时间
		--Sign = 1,					--震屏标识，同类标识新覆盖旧震屏
		--DistanceDampingId = 0,		--震屏强度距离衰减
		--},
	},
	HitType = 2,
	HitParams = {						--受击必须参数，不可缺少，不用填0
		SpeedZ = 0,						--地面受击击退初速度，可为负
		SpeedZAcceleration = 0,		--地面受击击退加速度，可为负
		SpeedZTime = 0,				--地面受击击退时间，必须小于受击动作时间
		SpeedY = 0,						--击飞受击垂直初速度
		SpeedZHitFly = 0,				--击飞受击水平初速度
		SpeedYAcceleration = 0,			--击飞受击垂直加速度
		SpeedYAccelerationTime = 0,		--击飞受击垂直加速度持续时间
		SpeedYAloft = 2.8,				--空中再受击垂直速度(set)
		SpeedZAloft = 1,				--空中再受击水平速度(set)
	},
	LookatType = 3,
}
Config.AttackConfig[1004006001] = {
	ShapeType = 1,
	Radius = 50000,
	MagicsBySelf = {
		--[1] = 1001001--
	},
	MagicsByTarget = {
		--[1] = 1001001--
		[1] = 1004001,
		[2] = 1004002,
	},
	CameraShakes = {
		--[1] = {
		--ShakeType = 2,				--震屏类型
		--StartAmplitude = 0.15,		--初始强度
		--StartFrequency = 10,		--初始频率
		--TargetAmplitude = 0,		--目标强度
		--TargetFrequency = 10,		--目标频率
		--AmplitudeChangeTime = 0.3,	--强度变化时间
		--FrequencyChangeTime = 0,	--频率变化时间
		--DurationTime = 0.15,		--震屏持续时间
		--Sign = 1,					--震屏标识，同类标识新覆盖旧震屏
		--DistanceDampingId = 0,		--震屏强度距离衰减
		--},
	},
	HitType = 1,
	HitParams = {						--受击必须参数，不可缺少，不用填0
		SpeedZ = 0,						--地面受击击退初速度，可为负
		SpeedZAcceleration = 0,		--地面受击击退加速度，可为负
		SpeedZTime = 0,				--地面受击击退时间，必须小于受击动作时间
		SpeedY = 0,						--击飞受击垂直初速度
		SpeedZHitFly = 0,				--击飞受击水平初速度
		SpeedYAcceleration = 0,			--击飞受击垂直加速度
		SpeedYAccelerationTime = 0,		--击飞受击垂直加速度持续时间
		SpeedYAloft = 2.8,				--空中再受击垂直速度(set)
		SpeedZAloft = 1,				--空中再受击水平速度(set)
	},
	LookatType = 3,
}
Config.AttackConfig[1004009001] = {
	ShapeType = 1,
	Radius = 20000,
	MagicsBySelf = {
		--[1] = 1001001--
	},
	MagicsByTarget = {
		--[1] = 1001001--
		[1] = 1004001,
		[2] = 1004002,
	},
	CameraShakes = {
		--[1] = {
		--ShakeType = 2,				--震屏类型
		--StartAmplitude = 0.15,		--初始强度
		--StartFrequency = 10,		--初始频率
		--TargetAmplitude = 0,		--目标强度
		--TargetFrequency = 10,		--目标频率
		--AmplitudeChangeTime = 0.3,	--强度变化时间
		--FrequencyChangeTime = 0,	--频率变化时间
		--DurationTime = 0.15,		--震屏持续时间
		--Sign = 1,					--震屏标识，同类标识新覆盖旧震屏
		--DistanceDampingId = 0,		--震屏强度距离衰减
		--},
	},
	HitType = 1,
	HitParams = {						--受击必须参数，不可缺少，不用填0
		SpeedZ = 0,						--地面受击击退初速度，可为负
		SpeedZAcceleration = 0,		--地面受击击退加速度，可为负
		SpeedZTime = 0,				--地面受击击退时间，必须小于受击动作时间
		SpeedY = 0,						--击飞受击垂直初速度
		SpeedZHitFly = 0,				--击飞受击水平初速度
		SpeedYAcceleration = 0,			--击飞受击垂直加速度
		SpeedYAccelerationTime = 0,		--击飞受击垂直加速度持续时间
		SpeedYAloft = 2.8,				--空中再受击垂直速度(set)
		SpeedZAloft = 1,				--空中再受击水平速度(set)
	},
	LookatType = 3,
}
Config.AttackConfig[1004013001] = {
	ShapeType = 1,
	Radius = 90000,
	MagicsBySelf = {
		--[1] = 1001001--
	},
	MagicsByTarget = {
		--[1] = 1001001--
		[1] = 1004001,
		[2] = 1004002,
	},
	CameraShakes = {
		--[1] = {
		--ShakeType = 2,				--震屏类型
		--StartAmplitude = 0.15,		--初始强度
		--StartFrequency = 10,		--初始频率
		--TargetAmplitude = 0,		--目标强度
		--TargetFrequency = 10,		--目标频率
		--AmplitudeChangeTime = 0.3,	--强度变化时间
		--FrequencyChangeTime = 0,	--频率变化时间
		--DurationTime = 0.15,		--震屏持续时间
		--Sign = 1,					--震屏标识，同类标识新覆盖旧震屏
		--DistanceDampingId = 0,		--震屏强度距离衰减
		--},
	},
	HitType = 1,
	HitParams = {						--受击必须参数，不可缺少，不用填0
		SpeedZ = 0,						--地面受击击退初速度，可为负
		SpeedZAcceleration = 0,		--地面受击击退加速度，可为负
		SpeedZTime = 0,				--地面受击击退时间，必须小于受击动作时间
		SpeedY = 0,						--击飞受击垂直初速度
		SpeedZHitFly = 0,				--击飞受击水平初速度
		SpeedYAcceleration = 0,			--击飞受击垂直加速度
		SpeedYAccelerationTime = 0,		--击飞受击垂直加速度持续时间
		SpeedYAloft = 2.8,				--空中再受击垂直速度(set)
		SpeedZAloft = 1,				--空中再受击水平速度(set)
	},
	LookatType = 3,
}
Config.AttackConfig[1004013002] = {
	ShapeType = 1,
	Radius = 90000,
	MagicsBySelf = {
		--[1] = 1001001--
	},
	MagicsByTarget = {
		--[1] = 1001001--
		[1] = 1004001,
		[2] = 1004002,
	},
	CameraShakes = {
		--[1] = {
		--ShakeType = 2,				--震屏类型
		--StartAmplitude = 0.15,		--初始强度
		--StartFrequency = 10,		--初始频率
		--TargetAmplitude = 0,		--目标强度
		--TargetFrequency = 10,		--目标频率
		--AmplitudeChangeTime = 0.3,	--强度变化时间
		--FrequencyChangeTime = 0,	--频率变化时间
		--DurationTime = 0.15,		--震屏持续时间
		--Sign = 1,					--震屏标识，同类标识新覆盖旧震屏
		--DistanceDampingId = 0,		--震屏强度距离衰减
		--},
	},
	HitType = 2,
	HitParams = {						--受击必须参数，不可缺少，不用填0
		SpeedZ = 0,						--地面受击击退初速度，可为负
		SpeedZAcceleration = 0,		--地面受击击退加速度，可为负
		SpeedZTime = 0,				--地面受击击退时间，必须小于受击动作时间
		SpeedY = 0,						--击飞受击垂直初速度
		SpeedZHitFly = 0,				--击飞受击水平初速度
		SpeedYAcceleration = 0,			--击飞受击垂直加速度
		SpeedYAccelerationTime = 0,		--击飞受击垂直加速度持续时间
		SpeedYAloft = 2.8,				--空中再受击垂直速度(set)
		SpeedZAloft = 1,				--空中再受击水平速度(set)
	},
	LookatType = 3,
}



Config.AttackConfig[9001001001] = {
	ShapeType = 1,
	Radius = 20000,
	MagicsBySelf = {
		--[1] = 1001001
	},
	MagicsByTarget = {
		[1] = 9001001,
		[2] = 9001002,
	},
	HitType = 7,
	HitParams = {				--受击必须参数，不可缺少，不用填0
		SpeedZ = 0,				--地面受击击退速度，可为负
		SpeedZAcceleration = 0,	--地面受击击退加速度
		SpeedZTime = 0,			--地面受击击退时间
		SpeedY = 5,					--击飞受击垂直初速度
		SpeedZHitFly = 2,			--击飞受击水平初速度
		SpeedYAcceleration = 15,		--击飞受击垂直加速度
		SpeedYAccelerationTime = 0.2,	--击飞受击垂直加速度持续时间
		SpeedYAloft = 5,			--空中再受击垂直速度(set)
		SpeedZAloft = 2,			--空中再受击水平速度(set)
	},
	LookatType = 3,
}
Config.AttackConfig[9001002001] = {
	ShapeType = 1,
	Radius = 20000,
	MagicsBySelf = {
		--[1] = 1001001
	},
	MagicsByTarget = {
		[1] = 9001001,
		[2] = 9001002,
	},
	HitType = 7,
	HitParams = {				--受击必须参数，不可缺少，不用填0
		SpeedZ = 0,				--地面受击击退速度，可为负
		SpeedZAcceleration = 0,	--地面受击击退加速度
		SpeedZTime = 0,			--地面受击击退时间
		SpeedY = 5,					--击飞受击垂直初速度
		SpeedZHitFly = 2,			--击飞受击水平初速度
		SpeedYAcceleration = 15,		--击飞受击垂直加速度
		SpeedYAccelerationTime = 0.2,	--击飞受击垂直加速度持续时间
		SpeedYAloft = 5,			--空中再受击垂直速度(set)
		SpeedZAloft = 2,			--空中再受击水平速度(set)
	},
	LookatType = 3,
}
Config.AttackConfig[9001003001] = {
	ShapeType = 1,
	Radius = 20000,
	MagicsBySelf = {
		--[1] = 1001001
	},
	MagicsByTarget = {
		[1] = 9001001,
		[2] = 9001002,
	},
	HitType = 7,
	HitParams = {				--受击必须参数，不可缺少，不用填0
		SpeedZ = 0,				--地面受击击退速度，可为负
		SpeedZAcceleration = 0,	--地面受击击退加速度
		SpeedZTime = 0,			--地面受击击退时间
		SpeedY = 5,					--击飞受击垂直初速度
		SpeedZHitFly = 2,			--击飞受击水平初速度
		SpeedYAcceleration = 15,		--击飞受击垂直加速度
		SpeedYAccelerationTime = 0.2,	--击飞受击垂直加速度持续时间
		SpeedYAloft = 5,			--空中再受击垂直速度(set)
		SpeedZAloft = 2,			--空中再受击水平速度(set)
	},
	LookatType = 3,
}
Config.AttackConfig[9001004001] = {
	ShapeType = 1,
	Radius = 20000,
	MagicsBySelf = {
		--[1] = 1001001
	},
	MagicsByTarget = {
		[1] = 9001001,
		[2] = 9001002,
	},
	HitType = 7,
	HitParams = {				--受击必须参数，不可缺少，不用填0
		SpeedZ = 0,				--地面受击击退速度，可为负
		SpeedZAcceleration = 0,	--地面受击击退加速度
		SpeedZTime = 0,			--地面受击击退时间
		SpeedY = 5,					--击飞受击垂直初速度
		SpeedZHitFly = 2,			--击飞受击水平初速度
		SpeedYAcceleration = 15,		--击飞受击垂直加速度
		SpeedYAccelerationTime = 0.2,	--击飞受击垂直加速度持续时间
		SpeedYAloft = 5,			--空中再受击垂直速度(set)
		SpeedZAloft = 2,			--空中再受击水平速度(set)
	},
	LookatType = 3,
}