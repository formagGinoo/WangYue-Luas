Behavior2010520 = BaseClass("Behavior2010520",EntityBehaviorBase)

local DataItem = Config.DataItem.data_item

--预加载
function Behavior2010520.GetGenerates()

end

function Behavior2010520:Init()
	self.me = self.instanceId
	self.ecoId = self.sInstanceId
	self.myBossId = nil
	self.myJadeQuality = nil	
	self.myJadeDisappearEntityId = nil
	self.myQualityItemId = nil
	--对应的实体信息,如果新增了玉佩类型就加在这里
	self.partnerDropInfo = {
		{entityId = 2010521 , quality = 5 , describe = "橙色玉佩"},
	}
	--玉佩消失的表现特效，如果新增了类型和品质要加在这里
	self.removeEffect = {
		{entityId = 2010531 , quality = 5 , describe = "橙色玉佩消失特效"},
	}
	self.qualityItem ={
		{id = 3003015 , quality = 5}
		}
end

function Behavior2010520:LateInit()
	local myEntityId = BehaviorFunctions.GetEntityTemplateId(self.me)
	for i,v in pairs(self.partnerDropInfo) do
		if v.entityId == myEntityId then
			self.myJadeQuality = v.quality
		end
	end
	for i,v in pairs(self.removeEffect) do
		if v.quality == self.myJadeQuality then
			self.myJadeDisappearEntityId = v.entityId
		end
	end
	for i,v in pairs(self.qualityItem) do
		if v.quality == self.myJadeQuality then
			self.myQualityItemId = v.id
		end
	end
	if self.ecoId then
		--存在花就隐藏boss
		self.myBossId = BehaviorFunctions.GetResDupLinkEcoId(self.ecoId)
		BehaviorFunctions.ChangeEcoEntityCreateState(self.myBossId,true,true)
	end
end


function Behavior2010520:Update()

end

--物品交互
function Behavior2010520:WorldInteractClick(uniqueId, instanceId)
	if instanceId ~= self.me then
		return
	end
	--开启交互界面
	if self.ecoId then
		BehaviorFunctions.CheckResourceEcoHit(self.ecoId)
	end	
end
--qte完成
function Behavior2010520:CatchPartnerEnd()
	--根据品质创建对应消失实体
	BehaviorFunctions.InteractEntityHit(self.me, false)
	local myPos = BehaviorFunctions.GetPositionP(self.me)
	BehaviorFunctions.CreateEntityByEntity(self.me,self.myJadeDisappearEntityId,myPos.x,myPos.y,myPos.z)
	BehaviorFunctions.SetEntityShowState(self.me,false)
	--领取奖励后再显示boss
	if self.myBossId then
		BehaviorFunctions.ChangeEcoEntityCreateState(self.myBossId,false,true)
	end
end

function Behavior2010520:ResEcoHitCostCheckSuc(ecoId)
	if self.ecoId and ecoId == self.ecoId then
		BehaviorFunctions.ShowPartnerGetWindow(self.myQualityItemId,self.me)
	end
end