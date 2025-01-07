Behavior1000088 = BaseClass("Behavior1000088",EntityBehaviorBase)
local BF = BehaviorFunctions
function Behavior1000088.GetGenerates()


end

function Behavior1000088.GetMagics()

end

function Behavior1000088:Init()
	self.me = self.instanceId		--记录自己
	self.connectState = 0	--缔约状态记录
	self.myPos = {}
end

function Behavior1000088:Update()
	self.ctrlRole = BF.GetCtrlEntity()
	self.myPos.x,self.myPos.y,self.myPos.z = BF.GetEntityTransformPos(self.me,"HitCase")
	
	
	if self.connectState == 0 then
		BF.DoMagic(self.ctrlRole,self.me,1000089)	--顿帧
		BF.DoMagic(self.ctrlRole,self.me,1000081)	--连结开始
		BF.AddDelayCallByFrame(20,self,self.ConnectStart)	--执行连接开始的流程
		self.connectState = 1	--标记为开始
	end
end

function Behavior1000088:ConnectStart()	
	if BF.CheckEntity(self.me) then
		local hitBullet = BF.CreateEntity(1000000028,self.ctrlRole,self.myPos.x,self.myPos.y,self.myPos.z)	--受击表演子弹
		BF.SetAttackCheckList(hitBullet, {self.me})	--设置子弹仅对自己有效，并加上眩晕
		self.connectState = 2	--标记为受击
	end
end



--捕捉完成伪代码
function Behavior1000088:ConcludePartnerSuc(instanceId)
	if instanceId == self.me then
		local hitBullet = BF.CreateEntity(1000000030,self.ctrlRole,self.myPos.x,self.myPos.y,self.myPos.z)	--回身体特效
		BF.SetAttackCheckList(hitBullet, {self.ctrlRole})	--设置子弹仅对角色有效
		BF.SetEntityTrackTarget(hitBullet,self.ctrlRole)
	end
end