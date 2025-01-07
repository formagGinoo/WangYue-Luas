Behavior1002051001 = BaseClass("Behavior1002051001",EntityBehaviorBase)

local BF = BehaviorFunctions

function Behavior1002051001.GetGenerates()
	local generates = {1002051002,100205102}
	return generates
end
function Behavior1002051001.GetMagics()
	local generates = {}
	return generates
end

--缔约连线实体逻辑
function Behavior1002051001:Init()
	
	--变量声明
	self.Me = self.instanceId		--记录自己
	self.RealFrame = 0
	self.AttackTarget = 0
	self.AttackTargetPoint = 0
	self.AttackTargetPart = 0
	
	self.AttackAltnTarget = 0
	self.AttackAltnTargetPoint = 0
	self.AttackAltnTargetPart = 0
	
	self.LockTarget = 0
	self.LockTargetPoint = 0
	self.LockTargetPart = 0
	
	self.LockAltnTarget = 0
	self.LockAltnTargetPoint = 0
	self.LockAltnTargetPart = 0
	
	self.ShootFrame = BF.GetFightFrame()
	self.TimeFrame = BF.GetFightFrame() + 240
	
end

function Behavior1002051001:Update()

	self.RealFrame = BF.GetFightFrame()
	
	if self.TimeFrame < self.RealFrame then
		BF.RemoveEntity(self.Me)
	end
	
	if BF.CheckEntity(self.Me) then
		self.Role1 = BF.GetCtrlEntity()
		if BF.CheckEntity(self.Role1) then
			BF.ResetBindTransform(self.Me,self.Role1,"FollowTarget")
		end
		
		--基本目标获取
		self.AttackTarget = BF.GetEntityValue(self.Role1,"AttackTarget")
		
		self.AttackAltnTarget = BF.GetEntityValue(self.Role1,"AttackAltnTarget")
		
		--目标存在判断
		if not BF.CheckEntity(self.AttackTarget) and BF.CheckEntity(self.AttackAltnTarget) then
			self.AttackTarget = BF.GetEntityValue(self.Role1,"AttackAltnTarget")
		elseif not BF.CheckEntity(self.AttackTarget) and not BF.CheckEntity(self.AttackAltnTarget) then
			self.AllTarget = BF.SearchEntities(self.Me,30,0,360,2,1,nil,1004,1,1,nil,false,false,1,1,false,true)
			--补充搜索目标判断
			if next(self.AllTarget) then
				if BF.CheckEntity(self.AllTarget[1][1]) then
					self.AttackTarget = self.AllTarget[1][1]
				end
			end
		end

		if BF.CheckEntity(self.AttackTarget) and self.ShootFrame < self.RealFrame then
			
			self:UltimateShoot()

		end
	end
end

--大招子弹释放判断
function Behavior1002051001:UltimateShoot()
	
	--参数项
	local s = 1002051002  --大招子弹Id
	local e = 100205102
	--偏转欧拉角
	--local r1 = {{-70,70,0},{-80,290,0},{-55,50,0},{-45,310,0},{-40,90,0},{-40,270,0},{-50,30,0},{-70,340,0}}
	--local r2 = r1[self.UltimateNum]
	
	--出生坐标
	local p1 = BF.GetPositionP(self.AttackTarget)
	--local p1 = BF.GetPositionP(self.Me)
	--朝向坐标
	local p2 = BF.GetPositionP(self.AttackTarget)
	
	local c = BF.Random(45,70)
	local c2 = BF.Random(-70,-45)
	local d = BF.Random(1,3)
	
	--local o = BF.GetPositionP(BF.GetEntityOwner(self.Me))
	--local o2 = BF.GetPositionOffsetBySelf(BF.GetEntityOwner(self.Me),d,BF.RandomSelect(c,c2))
	--local e2 = BF.CreateEntity(e,BF.GetEntityOwner(self.Me), o2.x,o2.y,o2.z) --释放大招子弹实体
	
	
	local m = BF.CreateEntity(s, BF.GetEntityOwner(self.Me), p1.x+BF.Random(-3,3), p1.y+10, p1.z+BF.Random(-3,3),p2.x, p2.y, p2.z) --释放大招子弹实体
	--BF.AddEntityEuler(m,90,0,0)
	--local n = BF.Random(4,6)
	
	self.ShootFrame = self.RealFrame + 9
	
	--设置追踪目标
	if BF.CheckEntity(self.AttackTarget) then
		--BF.SetEntityTrackTarget(m,self.AttackTarget)
		BF.SetEntityTrackPosition(m,p2.x, p2.y, p2.z)
	else
		BF.SetEntityTrackPosition(m,self.RAP.MyFrontPos.x, self.RAP.MyFrontPos.y, self.RAP.MyFrontPos.z)
	end
end