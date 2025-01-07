

Config = Config or {} 
Config.DataWorldAnimSwitch = Config.DataWorldAnimSwitch or {}


Config.DataWorldAnimSwitch =
{
	[10020005] =  --当前地图
	{
		[10020001] = {  --目标地图
		
			EnterSceneId = 10020001,  --目标地图
			EnterTimeLineId = 601010301,
			ExitTimeLineId = 601010401,
			StartPos = {x=2126.01,y=118.4412,z=519.3295},  --开始时钟位置
			StartRotate = {x=0, y=-22.559, z=0},  --开始时钟位置旋转
			EndPos = {x=1091,y=91.03,z=710.1996},  --结束时钟位置
			EndRotate = {x=0, y=-92.952, z=0},  --结束时钟旋转
			RolePos = {x=1088.90002,y=140.009995,z=709.940002},  --结束时角色位置
			RoleRotateY = -91.768  --结束时角色位置旋转
		},
	},
	
	
	[10020001] =  --当前地图
	{
		[10020005] = {  --目标地图
			EnterSceneId = 10020005, --目标地图
			EnterTimeLineId = 601010301,
			ExitTimeLineId = 601010401,
			StartPos = {x=1091,y=91.03,z=710.1996}, --开始时钟位置
			StartRotate = {x=0, y=-92.952, z=0},  --开始时钟位置旋转
			EndPos = {x=2126.01,y=118.4412,z=519.3295}, --结束时钟位置
			EndRotate = {x=0, y=-22.559, z=0},  --结束时钟旋转
			RolePos = {x=2125.23,y=167.4971,z=521.25}, --结束时角色位置
			RoleRotateY = -21.192  --结束时角色位置旋转
		},
	},
}


