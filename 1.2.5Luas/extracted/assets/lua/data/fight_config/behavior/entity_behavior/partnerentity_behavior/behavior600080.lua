Behavior600080 = BaseClass("Behavior600080",EntityBehaviorBase)

local BF = BehaviorFunctions
local FES = FightEnum.EntityState
local FK = FightEnum.KeyEvent
local FE = FightEnum
local FEAS = FightEnum.EntityAimState
local FEET = FightEnum.ElementType
local FEAET = FightEnum.AnimEventType

--资源预加载
function Behavior600080.GetGenerates()
	local generates = {}
	return generates
end

function Behavior600080.GetMagics()
	local generates = {}
	return generates
end

function Behavior600080:Init()
	self.me = self.instanceId	--记录自身
	self.role = 0
	self.mission = 0
	self.time = 0
	self.state = 0
	
	--是否骇入
	self.isHacking = false
	
	--缓存技能按钮
	self.curSkillId = 0
	
end



function Behavior600080:Update()
	self.role = BF.GetEntityOwner(self.me)  --获得角色
	self.time = BF.GetFightFrame() 		--获得世界帧数
	self.roleState = BF.GetEntityState(self.role) --获得角色状态
	self.roleFrontPos = BF.GetPositionOffsetBySelf(self.role,5,0) --获得角色90度5米处位置坐标
	self.state = BF.GetEntityState(self.role) --获得角色状态

	self.rolePos = BF.GetPositionP(self.role)
	
	--检测高度，若不在平地则无法使用仲魔技能

	if BehaviorFunctions.CheckEntityHeight(self.role) ~= 0 then
		BehaviorFunctions.DisableSkillButton(self.me,FightEnum.KeyEvent.Partner , true)
	else
		BehaviorFunctions.DisableSkillButton(self.me,FightEnum.KeyEvent.Partner , false)
	end
	
	
	--当进入建造骇入时
	if BehaviorFunctions.CheckBtnUseSkill(self.me,600080001) then
		if BehaviorFunctions.CheckKeyDown(FightEnum.KeyEvent.Partner) and BehaviorFunctions.GetCtrlEntity() == self.role then
		
			if self.isHacking == false then
				--BF.AddEntitySign(self.role,600080,-1,false) --给角色增加仲魔标记
				self.isHacking = true
				BehaviorFunctions.EnterHackingMode()
				BehaviorFunctions.CastSkillCost(self.me,600080001)
				
				self.state = BF.GetEntityState(self.role) --获得角色状态
				
				
				--local Pos = BF.GetPositionOffsetBySelf(self.role,0.5,0) --获得角色周围的位置
				--BF.CallCommonBehaviorFunc(self.me, "StopPartnerLeave")
				--BF.DoSetPosition(self.me,Pos.x - 1,Pos.y,Pos.z - 0.3)	--设置召唤位置
				--BF.DoLookAtPositionImmediately(self.me,self.roleFrontPos.x,self.roleFrontPos.y,self.roleFrontPos.z,true)	--设置朝向
				--BF.ShowPartner(self.role, true)	--显示仲魔
				--BF.SetUseParentTimeScale(self.me, false)--不使用创建者时间缩放
				--BF.DoMagic(self.me,self.me,1000055,1)	--仲魔召唤技能无敌buff
				--BF.DoMagic(self.me,self.me,600000014,1)	--允许穿墙buff
				--BF.DoMagic(self.me,self.me,600000016,1)	--浮空buff
				--BF.DoMagic(self.me,self.me,600000005,1)	--播放仲魔出场特效
				--BF.CastSkillByTarget(self.me,600080001,self.role)	--释放技能
				--BehaviorFunctions.BindEntityToOwnerBone(self.me,"Role",true)
				
			end
		end
	end
	
	----保底骇入建造检测
	--if self.state == FE.EntityState.Hack and self.isHacking == false and BF.GetCtrlEntity() == self.role then
		----BF.AddEntitySign(self.role,600080,-1,false) --给角色增加仲魔标记
		--self.isHacking = true
		--BehaviorFunctions.EnterHackingMode()
		--BehaviorFunctions.CastSkillCost(self.me,600080001)
		--Log(self.state)


		----local Pos = BF.GetPositionOffsetBySelf(self.role,0.5,0) --获得角色周围的位置
		----BF.CallCommonBehaviorFunc(self.me, "StopPartnerLeave")
		----BF.DoSetPosition(self.me,Pos.x - 1,Pos.y,Pos.z - 0.3)	--设置召唤位置
		----BF.DoLookAtPositionImmediately(self.me,self.roleFrontPos.x,self.roleFrontPos.y,self.roleFrontPos.z,true)	--设置朝向
		----BF.ShowPartner(self.role, true)	--显示仲魔
		----BF.SetUseParentTimeScale(self.me, false)--不使用创建者时间缩放
		----BF.DoMagic(self.me,self.me,1000055,1)	--仲魔召唤技能无敌buff
		----BF.DoMagic(self.me,self.me,600000014,1)	--允许穿墙buff
		----BF.DoMagic(self.me,self.me,600000016,1)	--浮空buff
		----BF.DoMagic(self.me,self.me,600000005,1)	--播放仲魔出场特效
		----BF.CastSkillByTarget(self.me,600080001,self.role)	--释放技能
		----BehaviorFunctions.BindEntityToOwnerBone(self.me,"Role",true)

	--end
	
	
	--退出骇入建造模式时
	if self.state ~= FE.EntityState.Hack and self.isHacking == true then
		--BF.ShowPartner(self.role, false)	--隐藏仲魔
		self.isHacking = false
		
	end
	
	
end