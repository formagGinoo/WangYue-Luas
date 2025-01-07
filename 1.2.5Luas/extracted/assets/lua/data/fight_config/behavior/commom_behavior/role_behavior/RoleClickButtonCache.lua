RoleClickButtonCache = BaseClass("RoleClickButtonCache",EntityBehaviorBase)

local BF = BehaviorFunctions
local FK = FightEnum.KeyEvent

--角色按键点击记录组合
function RoleClickButtonCache:Init()
	
	self.Me = self.instanceId	--记录自己
	--通用参数组合初始化
	self.RoleAllParm = self.MainBehavior.RoleAllParm
	self.RAP = self.RoleAllParm
end

function RoleClickButtonCache:Update()
	
	--组合缩写
	self.RAP = self.RoleAllParm

	--按键点击缓存时间结束后移除记录
	if self.RAP.ClickButton[1] ~= 0 and self.RAP.RealFrame > self.RAP.ClickButtonFrame[1] then
		self.RAP.ClickButton[1] = 0
	end
	if self.RAP.ClickButton[2] ~= 0 and self.RAP.RealFrame > self.RAP.ClickButtonFrame[2] then
		self.RAP.ClickButton[2] = 0
	end
	if self.RAP.ClickButton[3] ~= 0 and self.RAP.RealFrame > self.RAP.ClickButtonFrame[3] then
		self.RAP.ClickButton[3] = 0
	end

	--角色在前台且被操控时
	if BF.CheckEntity(self.RAP.CtrlRole) and self.RAP.CtrlRole == self.Me and BF.CheckEntityForeground(self.Me) then
		if not BF.HasEntitySign(self.Me,10000009) then 
			----按钮点击判断----
			self:ClickButton(0)
	
			----按钮长按判断----
			self:PressButton(0,0)
			
		end
	end
end

--通用按钮点击判定：按键类型
function RoleClickButtonCache:ClickButton(KeyEvent)
	local r1 = BF.GetCtrlEntity()
	--大招按钮点击记录、增加缓存
	if ((BF.CheckKeyDown(FK.UltimateSkill) and self.RAP.CtrlRole == self.Me) or KeyEvent == FK.UltimateSkill)
		and BF.CheckBtnUseSkill(self.Me,FK.UltimateSkill) then
		self:ClickButtonRecord(FK.UltimateSkill)
	end
	--跳跃按钮点击记录、增加缓存
	if ((BF.CheckKeyDown(FK.Jump) and self.RAP.CtrlRole == self.Me) or KeyEvent == FK.Jump)
		and BF.CheckBtnUseSkill(self.Me, FK.Jump) then
		self:ClickButtonRecord(FK.Jump)
	end
	--瞄准按钮点击记录、增加缓存
	if ((BF.CheckKeyDown(FK.AimMode) and self.RAP.CtrlRole == self.Me) or KeyEvent == FK.Aim)
		and BF.CheckBtnUseSkill(self.Me, FK.AimMode) then
		self:ClickButtonRecord(FK.AimMode)
	end
	--闪避按钮点击记录、增加缓存
	if ((BF.CheckKeyDown(FK.Dodge) and self.RAP.CtrlRole == self.Me) or KeyEvent == FK.Dodge)
		and BF.CheckBtnUseSkill(self.Me,FK.Dodge) and self.RAP.MoveRes >= 250 then
		self:ClickButtonRecord(FK.Dodge)
	end
	--核心按钮点击记录、增加缓存
	if ((BF.CheckKeyDown(FK.Partner) and self.RAP.CtrlRole == self.Me) or KeyEvent == FK.Partner)
		and BF.CheckBtnUseSkill(self.Me,FK.Partner) and BF.CheckEntity(r1) and not BF.HasEntitySign(1,10000012) then
		self:ClickButtonRecord(FK.Partner)
	end
	--普通技能点击记录、增加缓存
	if ((BF.CheckKeyDown(FK.NormalSkill) and self.RAP.CtrlRole == self.Me) or KeyEvent == FK.NormalSkill)
		and BF.CheckBtnUseSkill(self.Me,FK.NormalSkill) then
		self:ClickButtonRecord(FK.NormalSkill)
	end
	--普攻按钮点击记录、增加缓存
	if ((BF.CheckKeyDown(FK.Attack) and self.RAP.CtrlRole == self.Me) or KeyEvent == FK.Attack)
		and BF.CheckBtnUseSkill(self.Me,FK.Attack) then
		self:ClickButtonRecord(FK.Attack)
	end
end

--通用按钮长按判定：按键类型，单帧累计帧数(不填默认1帧加1)
function RoleClickButtonCache:PressButton(KeyEvent,Frame)
	local r1 = BF.GetQTEEntity(1)
	--大招按钮长按记录、增加缓存
	if (BF.CheckKeyPress(FK.UltimateSkill) and self.RAP.CtrlRole == self.Me) 
		or KeyEvent == FK.UltimateSkill then
		self:PressButtonRecord(FK.UltimateSkill,Frame)
	else
		self:ClearPressButtonRecord(FK.UltimateSkill)
	end
	--跳跃按钮长按记录、增加缓存
	if (BF.CheckKeyPress(FK.Jump) and self.RAP.CtrlRole == self.Me)
		or KeyEvent == FK.Jump then
		self:PressButtonRecord(FK.Jump,Frame)
	else
		self:ClearPressButtonRecord(FK.Jump)
	end
	--瞄准按钮长按记录、增加缓存
	if (BF.CheckKeyPress(FK.Aim) and self.RAP.CtrlRole == self.Me)
		or KeyEvent == FK.Aim then
		self:PressButtonRecord(FK.Aim,Frame)
	else
		self:ClearPressButtonRecord(FK.Aim)
	end
	--闪避按钮长按记录、增加缓存
	if (BF.CheckKeyPress(FK.Dodge) and self.RAP.CtrlRole == self.Me)
		or KeyEvent == FK.Dodge then
		self:PressButtonRecord(FK.Dodge,Frame)
	else
		self:ClearPressButtonRecord(FK.Dodge)
	end
	--核心按钮长按记录、增加缓存
	if (BF.CheckKeyPress(FK.Partner) and self.RAP.CtrlRole == self.Me)
		or KeyEvent == FK.Partner and BF.CheckEntity(r1) then
		self:PressButtonRecord(FK.Partner,Frame)
	else
		self:ClearPressButtonRecord(FK.Partner)
	end
	--普通技能按钮长按记录、增加缓存
	if (BF.CheckKeyPress(FK.NormalSkill) and self.RAP.CtrlRole == self.Me) 
		or KeyEvent == FK.NormalSkill then
		self:PressButtonRecord(FK.NormalSkill,Frame)
	else
		self:ClearPressButtonRecord(FK.NormalSkill)
	end
	--普攻按钮长按记录、增加缓存
	if (BF.CheckKeyPress(FK.Attack) and self.RAP.CtrlRole == self.Me) 
		or KeyEvent == FK.Attack then
		self:PressButtonRecord(FK.Attack,Frame)
		--Log(self.RAP.PressButton[1].."    "..self.RAP.PressButtonFrame[1])
	else
		self:ClearPressButtonRecord(FK.Attack)
	end
end

--通用点击记录判断：按键类型
function RoleClickButtonCache:ClickButtonRecord(KeyEvent)

	--判断大招按钮点击
	if KeyEvent == FK.UltimateSkill then
		self.RAP.ClickButton[1] = FK.UltimateSkill
		self.RAP.ClickButtonFrame[1] = self.RAP.RealFrame + 10
		
	--判断闪避按钮点击
	elseif KeyEvent == FK.Dodge then
		self.RAP.ClickButton[1] = FK.Dodge
		self.RAP.ClickButtonFrame[1] = self.RAP.RealFrame + 5
	
	--判断跳跃按钮点击	
	elseif KeyEvent == FK.Jump then
		self.RAP.ClickButton[1] = FK.Jump
		self.RAP.ClickButtonFrame[1] = self.RAP.RealFrame + 5
		
	--判断瞄准按钮点击
	elseif KeyEvent == FK.Aim then
		self.RAP.ClickButton[1] = FK.Aim
		self.RAP.ClickButtonFrame[1] = self.RAP.RealFrame + 5
		
	--判断核心按钮点击
	elseif KeyEvent == FK.Partner then
		self.RAP.ClickButton[1] = FK.Partner
		self.RAP.ClickButtonFrame[1] = self.RAP.RealFrame
	
	--判断普通技能按钮点击
	elseif KeyEvent == FK.NormalSkill then
		self.RAP.ClickButton[1] = FK.NormalSkill
		self.RAP.ClickButtonFrame[1] = self.RAP.RealFrame + 10
	--判断普攻按钮点击
	else
		if self.RAP.ClickButton[1] == 0 or self.RAP.ClickButton[1] == nil then
			self.RAP.ClickButton[1] = KeyEvent
			self.RAP.ClickButtonFrame[1] = self.RAP.RealFrame + 10
		elseif self.RAP.ClickButton[2] == 0 or self.RAP.ClickButton[2] == nil then
			self.RAP.ClickButton[2] = KeyEvent
			self.RAP.ClickButtonFrame[2] = self.RAP.RealFrame + 10
		elseif self.RAP.ClickButton[3] == 0 or self.RAP.ClickButton[3] == nil then
			self.RAP.ClickButton[3] = KeyEvent
			self.RAP.ClickButtonFrame[3] = self.RAP.RealFrame + 10
		end
	end
end

--通用长按记录判断：按键类型，单帧累计帧数(不填默认1帧加1)
function RoleClickButtonCache:PressButtonRecord(KeyEvent,Frame)
	if self.RAP.PressButton[1] == 0 or self.RAP.PressButton[1] == KeyEvent or self.RAP.PressButton[1] == nil then
		self.RAP.PressButton[1] = KeyEvent
		if Frame == 0 then
			self.RAP.PressButtonFrame[1] = BF.GetKeyPressFrame(KeyEvent)
		else
			self.RAP.PressButtonFrame[1] = self.RAP.PressButtonFrame[1] + Frame
		end
	elseif self.RAP.PressButton[2] == 0 or self.RAP.PressButton[2] == KeyEvent or self.RAP.PressButton[2] == nil then
		self.RAP.PressButton[2] = KeyEvent
		if Frame == 0 then
			self.RAP.PressButtonFrame[2] = BF.GetKeyPressFrame(KeyEvent)
		else
			self.RAP.PressButtonFrame[2] = self.RAP.PressButtonFrame[2] + Frame
		end
	elseif self.RAP.PressButton[3] == 0 or self.RAP.PressButton[3] == KeyEvent or self.RAP.PressButton[3] == nil then
		self.RAP.PressButton[3] = KeyEvent
		if Frame == 0 then
			self.RAP.PressButtonFrame[3] = BF.GetKeyPressFrame(KeyEvent)
		else
			self.RAP.PressButtonFrame[3] = self.RAP.PressButtonFrame[3] + Frame
		end
	end
end

--通用长按清除判断：按键类型
function RoleClickButtonCache:ClearPressButtonRecord(KeyEvent)
	if self.RAP.PressButton[1] == KeyEvent then
		self.RAP.PressButton[1] = 0
		self.RAP.PressButtonFrame[1] = 0
	elseif self.RAP.PressButton[2] == KeyEvent then
		self.RAP.PressButton[2] = 0
		self.RAP.PressButtonFrame[2] = 0
	elseif self.RAP.PressButton[3] == KeyEvent then
		self.RAP.PressButton[3] = 0
		self.RAP.PressButtonFrame[3] = 0
	end
end