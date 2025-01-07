


GMProfilerConfig = GMProfilerConfig or {}

GMProfilerConfig.AssetPropety = 
{
	[1] = {
		ame = "贴图", 
		titleList = {
			"名称", "内存", "最大引用", "宽高", "格式", "mimap数量"
		},
		memberSortList = {
			"","memoryNum","maxReference","","","mipmapCount"
		}
	},
	[2] = {
		name = "网格", 
		titleList = {
			"名称", "内存", "最大引用", "顶点", "三角形", "法线", "颜色","切线"
		},
		memberSortList = {
			"","memoryNum","maxReference","vertex","trangles"
		}
	},
	[3] = {
		name = "动画", 
		titleList = {
			"名称", "内存", "最大引用", "时长", "帧率"
		},
		memberSortList = {
			"","memoryNum","maxReference","timeLength","frameRate"
		}
	},
	[4] = {
		name = "粒子", 
		titleList = {
			"名称", "内存", "最大引用"
		},
		memberSortList = {
			"","memoryNum","maxReference",
		}
	},
	[5] = {
		name = "Animator", 
		titleList = {
			"名称", "内存", "最大引用"
		},
		memberSortList = {
			"","memoryNum","maxReference",
		}
	},
}