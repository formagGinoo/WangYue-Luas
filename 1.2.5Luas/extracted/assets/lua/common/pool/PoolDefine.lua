PoolDefine = SingleClass("PoolDefine")

PoolDefine.poolMappings = 
{
	[PoolType.base_view] = BaseViewPool,
	[PoolType.class] = ClassPool,
	[PoolType.object] = GameObjectPool,
}

--有些对象类型，系统进行封装，并不想改动源文件，在此做索引
PoolDefine.PoolKey = 
{
	["vector3"] = "vector3",
	["vector2"] = "vector2",
	["object"] = "object",
	["empty_object"] = "empty_object",
}