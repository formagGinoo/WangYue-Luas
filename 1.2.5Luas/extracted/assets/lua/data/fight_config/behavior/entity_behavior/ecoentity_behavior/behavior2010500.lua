Behavior2010500 = BaseClass("Behavior2010500",EntityBehaviorBase)

local DataItem = Config.DataItem.data_item

--预加载
function Behavior2010500.GetGenerates()

end

function Behavior2010500:Init()
	self.me = self.instanceId
	self.itemInfo = nil	   --物品信息
	self.itemId = nil	   --物品ID
	self.itemQuality = nil --物品品质
	self.myEntityId = nil  --实体类型
	
	--对应的实体信息,如果新增了玉佩类型就加在这里
	self.partnerDropInfo = 
	{
		[1] = {entityId = 2010501 , describe = "白色玉佩"},
		[2] = {entityId = 2010502 , describe = "绿色玉佩"},
		[3] = {entityId = 2010503 , describe = "蓝色玉佩"},
		[4] = {entityId = 2010504 , describe = "紫色玉佩"},
		[5] = {entityId = 2010505 , describe = "橙色玉佩"},
		[6] = {entityId = 2010509 , describe = "无色玉佩"},--无色玉佩有根据序号的特殊判断
	}
	--玉佩消失的表现特效，如果新增了类型和品质要加在这里
	self.removeEffect =
	{
		[1] = {entityId = 2010511 , quality = 1 , describe = "白色玉佩消失特效"},
		[2] = {entityId = 2010512 , quality = 2 , describe = "绿色玉佩消失特效"},
		[3] = {entityId = 2010513 , quality = 3 , describe = "蓝色玉佩消失特效"},
		[4] = {entityId = 2010514 , quality = 4 , describe = "紫色玉佩消失特效"},
		[5] = {entityId = 2010515 , quality = 5 , describe = "橙色玉佩消失特效"},
	}
end


function Behavior2010500:Update()
	--获取物品信息
	if not self.itemInfo then
		self.itemInfo = BehaviorFunctions.GetEntityItemInfo(self.me)
		--self.itemId = self.itemInfo.item_template_id
		self.itemId = self.itemInfo.id
		self.itemQuality = BehaviorFunctions.GetItemQuality(self.itemId)
		self.myEntityId = BehaviorFunctions.GetEntityTemplateId(self.me)
	end
end

--物品交互
function Behavior2010500:WorldInteractClick(uniqueId)
	if self.interactUniqueId and self.interactUniqueId == uniqueId then
		--如果是无色玉佩
		if self.myEntityId == self.partnerDropInfo[6].entityId then
			--隐藏实体
			BehaviorFunctions.AddBuff(1,self.me,200000101)
			--开启交互界面
			BehaviorFunctions.ShowPartnerGetWindow(self.itemId,self.me)
		--非无色玉佩
		else
			--根据品质创建对应消失实体
			self:CreateRemoveEffect(self.itemQuality)
			BehaviorFunctions.InteractEntityHit(self.me,false)
		end
	end	
end

function Behavior2010500:CatchPartnerEnd()
	--根据品质创建对应消失实体
	self:CreateRemoveEffect(self.itemQuality)
	BehaviorFunctions.InteractEntityHit(self.me, false)
end

function Behavior2010500:EnterTrigger(triggerInstanceId,triggerEntityId,roleInstanceId)
	if self.isTrigger then
		return	
	end

	self.isTrigger = triggerInstanceId == self.me
	if not self.isTrigger then
		return
	end	
	--进入范围时，将对应物品信息添加至交互列表中
	self.interactUniqueId = BehaviorFunctions.WorldInteractActive(WorldEnum.InteractType.Jade,nil,"捕捉配从",1)
end

function Behavior2010500:ExitTrigger(triggerInstanceId,triggerEntityId,roleInstanceId)
	if self.isTrigger and triggerInstanceId == self.me then
		self.isTrigger = false
		--离开范围时，移除交互列表中对应的交互信息
		BehaviorFunctions.WorldInteractRemove(self.interactUniqueId)
	end
end

function Behavior2010500:__delete()
	if self.isTrigger then
		BehaviorFunctions.WorldInteractRemove(self.interactUniqueId)
		self.isTrigger = false
	end
end

--根据品质创建移除消失特效
function Behavior2010500:CreateRemoveEffect(quality)
	for i,v in ipairs(self.removeEffect) do
		if v.quality == quality then
			local myPos = BehaviorFunctions.GetPositionP(self.me)
			BehaviorFunctions.CreateEntity(v.entityId,nil,myPos.x,myPos.y,myPos.z)
		end
	end
end