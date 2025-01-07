RoleAllBehavior = BaseClass("RoleAllBehavior",EntityBehaviorBase)


--角色组合合集
function RoleAllBehavior:Init()

	--角色AI逻辑
	self.RoleAiBase = BehaviorFunctions.CreateBehavior("RoleAiBase",self)
	
	--角色按键点击记录组合
	self.RoleClickButtonCache = BehaviorFunctions.CreateBehavior("RoleClickButtonCache",self)

	--角色释放技能组合（重写可复制至最多3个，同时执行3种行为）
	self.RoleCatchSkill = BehaviorFunctions.CreateBehavior("RoleCatchSkill",self)

	--角色目标选择判断
	self.RoleLockTarget = BehaviorFunctions.CreateBehavior("RoleLockTarget",self)

	--角色目标选择判断
	self.RoleSelectTarget = BehaviorFunctions.CreateBehavior("RoleSelectTarget",self)
end

function RoleAllBehavior:Update()
	
end