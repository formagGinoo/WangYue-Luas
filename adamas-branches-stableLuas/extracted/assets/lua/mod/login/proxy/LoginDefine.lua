LoginDefine = LoginDefine or {}

LoginDefine.ServerListConfig =
{
	{ name = "内网开发1服", host = "192.168.10.67", port = 8201, platform = "develop", zone_id = 201},
	{ name = "内网开发2服", host = "192.168.10.67", port = 8202, platform = "develop", zone_id = 202},
	{ name = "性能测试服", host = "192.168.10.67", port = 8204, platform = "develop", zone_id = 204},

	{ name = "内网稳定服", host = "192.168.10.233", port = 8501, platform = "stable", zone_id = 501},

	{ name = "外网版署1服", host = "124.71.168.61", port = 45001, platform = "banshu", zone_id = 1},

	{ name = "功能1服", host = "192.168.10.67", port = 8401, platform = "develop", zone_id = 401},
	{ name = "功能2服", host = "192.168.10.67", port = 8402, platform = "develop", zone_id = 402},
	{ name = "功能3服", host = "192.168.10.67", port = 8403, platform = "develop", zone_id = 403},
	{ name = "功能4服", host = "192.168.10.67", port = 8404, platform = "develop", zone_id = 404},

	{ name = "容器", host = "wy-develop.shiyuegame.com", port = 8001, platform = "k8s", zone_id = 1},

	{ name = "外网服开发", host = "124.71.187.178", port = 45100, platform = "develop", zone_id = 1},
	{ name = "外网服stable", host = "124.71.187.178", port = 45200, platform = "develop", zone_id = 2},

	{ name = "梓梁",   host = "192.168.61.112", port = 8001, platform = "develop", zone_id = 1},
	{ name = "韩浩贤", host = "192.168.61.81", port = 8001, platform = "develop", zone_id = 1},
	{ name = "徐琪",   host = "192.168.61.206", port = 8001, platform = "develop", zone_id = 1},
	{ name = "烨佳",   host = "192.168.68.148", port = 8001, platform = "develop", zone_id = 1},
	{ name = "梓梁399", host = "192.168.10.67", port = 8399, platform = "develop", zone_id = 1},
	
	{ name = "策划-嘉元",   host = "192.168.10.67", port = 8301, platform = "design", zone_id = 301},
	{ name = "策划-阮杉",   host = "192.168.10.67", port = 8302, platform = "design", zone_id = 302},
	{ name = "策划-华韬",   host = "192.168.10.67", port = 8305, platform = "design", zone_id = 305},
	{ name = "策划-安琪",   host = "192.168.10.67", port = 8304, platform = "design", zone_id = 304},
	{ name = "策划-振港",   host = "192.168.10.67", port = 8303, platform = "design", zone_id = 303},
	{ name = "策划-雨彤",   host = "192.168.10.67", port = 8306, platform = "design", zone_id = 306},
	{ name = "策划-昕龙",   host = "192.168.10.67", port = 8307, platform = "design", zone_id = 307},
	{ name = "策划-文一",   host = "192.168.10.67", port = 8308, platform = "design", zone_id = 308},
	{ name = "策划-程远",   host = "192.168.10.67", port = 8309, platform = "design", zone_id = 309},
	{ name = "测试-颜昊鸿", host = "192.168.10.67", port = 8310, platform = "design", zone_id = 310},
	{ name = "策划-陈弘辉", host = "192.168.10.67", port = 8311, platform = "design", zone_id = 311},
	{ name = "策划-童伟豪", host = "192.168.10.67", port = 8313, platform = "design", zone_id = 313},
	{ name = "策划-叶浩坤", host = "192.168.10.67", port = 8315, platform = "design", zone_id = 315},
	{ name = "策划-钟宏泽", host = "192.168.10.67", port = 8316, platform = "design", zone_id = 316},
	{ name = "策划-周楠", host = "192.168.10.67", port = 8317, platform = "design", zone_id = 317},
	{ name = "策划-于畅",   host = "192.168.10.67", port = 8302, platform = "design", zone_id = 321},
	{ name = "策划-吴海峰", host = "192.168.10.67", port = 8322, platform = "design", zone_id = 322},
	{ name = "策划-张铭洋", host = "192.168.10.67", port = 8323, platform = "design", zone_id = 323},
	{ name = "测试-张峰铭",   host = "192.168.10.67", port = 8101, platform = "test", zone_id = 101},
	{ name = "测试-何仕杰",   host = "192.168.10.67", port = 8102, platform = "test", zone_id = 101},
	{ name = "测试-曾霖", host = "192.168.10.67", port = 8103, platform = "test", zone_id = 101},
	{ name = "测试-黄泽文", host = "192.168.10.67", port = 8104, platform = "test", zone_id = 101},
}

LoginDefine.QueryEntryURL = "http://test-cgw-wy.shiyuegame.com/maintain/queryEntry"
LoginDefine.QueryEntryKey = "3b72f3f84b773753ab5dc6b10831ea37"